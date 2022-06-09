//File27 name   : ttc_counter_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 :The counter can increment and decrement.
//   In increment mode instead of counting27 to its full 16 bit
//   value the counter counts27 up to or down from a programmed27 interval27 value.
//   Interrupts27 are issued27 when the counter overflows27 or reaches27 it's interval27
//   value. In match mode if the count value equals27 that stored27 in one of three27
//   match registers an interrupt27 is issued27.
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
//


module ttc_counter_lite27(

  //inputs27
  n_p_reset27,    
  pclk27,          
  pwdata27,              
  count_en27,
  cntr_ctrl_reg_sel27, 
  interval_reg_sel27,
  match_1_reg_sel27,
  match_2_reg_sel27,
  match_3_reg_sel27,         

  //outputs27    
  count_val_out27,
  cntr_ctrl_reg_out27,
  interval_reg_out27,
  match_1_reg_out27,
  match_2_reg_out27,
  match_3_reg_out27,
  interval_intr27,
  match_intr27,
  overflow_intr27

);


//--------------------------------------------------------------------
// PORT DECLARATIONS27
//--------------------------------------------------------------------

   //inputs27
   input          n_p_reset27;         //reset signal27
   input          pclk27;              //System27 Clock27
   input [15:0]   pwdata27;            //6 Bit27 data signal27
   input          count_en27;          //Count27 enable signal27
   input          cntr_ctrl_reg_sel27; //Select27 bit for ctrl_reg27
   input          interval_reg_sel27;  //Interval27 Select27 Register
   input          match_1_reg_sel27;   //Match27 1 Select27 register
   input          match_2_reg_sel27;   //Match27 2 Select27 register
   input          match_3_reg_sel27;   //Match27 3 Select27 register

   //outputs27
   output [15:0]  count_val_out27;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out27;    //Counter27 control27 reg select27
   output [15:0]  interval_reg_out27;     //Interval27 reg
   output [15:0]  match_1_reg_out27;      //Match27 1 register
   output [15:0]  match_2_reg_out27;      //Match27 2 register
   output [15:0]  match_3_reg_out27;      //Match27 3 register
   output         interval_intr27;        //Interval27 interrupt27
   output [3:1]   match_intr27;           //Match27 interrupt27
   output         overflow_intr27;        //Overflow27 interrupt27

//--------------------------------------------------------------------
// Internal Signals27 & Registers27
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg27;     // 5-bit Counter27 Control27 Register
   reg [15:0]     interval_reg27;      //16-bit Interval27 Register 
   reg [15:0]     match_1_reg27;       //16-bit Match_127 Register
   reg [15:0]     match_2_reg27;       //16-bit Match_227 Register
   reg [15:0]     match_3_reg27;       //16-bit Match_327 Register
   reg [15:0]     count_val27;         //16-bit counter value register
                                                                      
   
   reg            counting27;          //counter has starting counting27
   reg            restart_temp27;   //ensures27 soft27 reset lasts27 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out27; //7-bit Counter27 Control27 Register
   wire [15:0]    interval_reg_out27;  //16-bit Interval27 Register 
   wire [15:0]    match_1_reg_out27;   //16-bit Match_127 Register
   wire [15:0]    match_2_reg_out27;   //16-bit Match_227 Register
   wire [15:0]    match_3_reg_out27;   //16-bit Match_327 Register
   wire [15:0]    count_val_out27;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign27 output wires27
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out27 = cntr_ctrl_reg27;    // 7-bit Counter27 Control27
   assign interval_reg_out27  = interval_reg27;     // 16-bit Interval27
   assign match_1_reg_out27   = match_1_reg27;      // 16-bit Match_127
   assign match_2_reg_out27   = match_2_reg27;      // 16-bit Match_227 
   assign match_3_reg_out27   = match_3_reg27;      // 16-bit Match_327 
   assign count_val_out27     = count_val27;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning27 interrupts27
//--------------------------------------------------------------------

   assign interval_intr27 =  cntr_ctrl_reg27[1] & (count_val27 == 16'h0000)
      & (counting27) & ~cntr_ctrl_reg27[4] & ~cntr_ctrl_reg27[0];
   assign overflow_intr27 = ~cntr_ctrl_reg27[1] & (count_val27 == 16'h0000)
      & (counting27) & ~cntr_ctrl_reg27[4] & ~cntr_ctrl_reg27[0];
   assign match_intr27[1]  =  cntr_ctrl_reg27[3] & (count_val27 == match_1_reg27)
      & (counting27) & ~cntr_ctrl_reg27[4] & ~cntr_ctrl_reg27[0];
   assign match_intr27[2]  =  cntr_ctrl_reg27[3] & (count_val27 == match_2_reg27)
      & (counting27) & ~cntr_ctrl_reg27[4] & ~cntr_ctrl_reg27[0];
   assign match_intr27[3]  =  cntr_ctrl_reg27[3] & (count_val27 == match_3_reg27)
      & (counting27) & ~cntr_ctrl_reg27[4] & ~cntr_ctrl_reg27[0];


//    p_reg_ctrl27: Process27 to write to the counter control27 registers
//    cntr_ctrl_reg27 decode:  0 - Counter27 Enable27 Active27 Low27
//                           1 - Interval27 Mode27 =1, Overflow27 =0
//                           2 - Decrement27 Mode27
//                           3 - Match27 Mode27
//                           4 - Restart27
//                           5 - Waveform27 enable active low27
//                           6 - Waveform27 polarity27
   
   always @ (posedge pclk27 or negedge n_p_reset27)
   begin: p_reg_ctrl27  // Register writes
      
      if (!n_p_reset27)                                   
      begin                                     
         cntr_ctrl_reg27 <= 7'b0000001;
         interval_reg27  <= 16'h0000;
         match_1_reg27   <= 16'h0000;
         match_2_reg27   <= 16'h0000;
         match_3_reg27   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel27)
            cntr_ctrl_reg27 <= pwdata27[6:0];
         else if (restart_temp27)
            cntr_ctrl_reg27[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg27 <= cntr_ctrl_reg27;             

         interval_reg27  <= (interval_reg_sel27) ? pwdata27 : interval_reg27;
         match_1_reg27   <= (match_1_reg_sel27)  ? pwdata27 : match_1_reg27;
         match_2_reg27   <= (match_2_reg_sel27)  ? pwdata27 : match_2_reg27;
         match_3_reg27   <= (match_3_reg_sel27)  ? pwdata27 : match_3_reg27;   
      end
      
   end  //p_reg_ctrl27

   
//    p_cntr27: Process27 to increment or decrement the counter on receiving27 a 
//            count_en27 signal27 from the pre_scaler27. Count27 can be restarted27
//            or disabled and can overflow27 at a specified interval27 value.
   
   
   always @ (posedge pclk27 or negedge n_p_reset27)
   begin: p_cntr27   // Counter27 block

      if (!n_p_reset27)     //System27 Reset27
      begin                     
         count_val27 <= 16'h0000;
         counting27  <= 1'b0;
         restart_temp27 <= 1'b0;
      end
      else if (count_en27)
      begin
         
         if (cntr_ctrl_reg27[4])     //Restart27
         begin     
            if (~cntr_ctrl_reg27[2])  
               count_val27         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg27[1])
                 count_val27         <= interval_reg27;     
              else
                 count_val27         <= 16'hFFFF;     
            end
            counting27       <= 1'b0;
            restart_temp27   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg27[0])          //Low27 Active27 Counter27 Enable27
            begin

               if (cntr_ctrl_reg27[1])  //Interval27               
                  if (cntr_ctrl_reg27[2])  //Decrement27        
                  begin
                     if (count_val27 == 16'h0000)
                        count_val27 <= interval_reg27;  //Assumed27 Static27
                     else
                        count_val27 <= count_val27 - 16'h0001;
                  end
                  else                   //Increment27
                  begin
                     if (count_val27 == interval_reg27)
                        count_val27 <= 16'h0000;
                     else           
                        count_val27 <= count_val27 + 16'h0001;
                  end
               else    
               begin  //Overflow27
                  if (cntr_ctrl_reg27[2])   //Decrement27
                  begin
                     if (count_val27 == 16'h0000)
                        count_val27 <= 16'hFFFF;
                     else           
                        count_val27 <= count_val27 - 16'h0001;
                  end
                  else                    //Increment27
                  begin
                     if (count_val27 == 16'hFFFF)
                        count_val27 <= 16'h0000;
                     else           
                        count_val27 <= count_val27 + 16'h0001;
                  end 
               end
               counting27  <= 1'b1;
            end     
            else
               count_val27 <= count_val27;   //Disabled27
   
            restart_temp27 <= 1'b0;
      
         end
     
      end // if (count_en27)

      else
      begin
         count_val27    <= count_val27;
         counting27     <= counting27;
         restart_temp27 <= restart_temp27;               
      end
     
   end  //p_cntr27

endmodule
