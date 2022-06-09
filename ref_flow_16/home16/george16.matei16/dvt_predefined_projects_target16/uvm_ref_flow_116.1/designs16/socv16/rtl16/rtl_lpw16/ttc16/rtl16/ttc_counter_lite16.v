//File16 name   : ttc_counter_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 :The counter can increment and decrement.
//   In increment mode instead of counting16 to its full 16 bit
//   value the counter counts16 up to or down from a programmed16 interval16 value.
//   Interrupts16 are issued16 when the counter overflows16 or reaches16 it's interval16
//   value. In match mode if the count value equals16 that stored16 in one of three16
//   match registers an interrupt16 is issued16.
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
//


module ttc_counter_lite16(

  //inputs16
  n_p_reset16,    
  pclk16,          
  pwdata16,              
  count_en16,
  cntr_ctrl_reg_sel16, 
  interval_reg_sel16,
  match_1_reg_sel16,
  match_2_reg_sel16,
  match_3_reg_sel16,         

  //outputs16    
  count_val_out16,
  cntr_ctrl_reg_out16,
  interval_reg_out16,
  match_1_reg_out16,
  match_2_reg_out16,
  match_3_reg_out16,
  interval_intr16,
  match_intr16,
  overflow_intr16

);


//--------------------------------------------------------------------
// PORT DECLARATIONS16
//--------------------------------------------------------------------

   //inputs16
   input          n_p_reset16;         //reset signal16
   input          pclk16;              //System16 Clock16
   input [15:0]   pwdata16;            //6 Bit16 data signal16
   input          count_en16;          //Count16 enable signal16
   input          cntr_ctrl_reg_sel16; //Select16 bit for ctrl_reg16
   input          interval_reg_sel16;  //Interval16 Select16 Register
   input          match_1_reg_sel16;   //Match16 1 Select16 register
   input          match_2_reg_sel16;   //Match16 2 Select16 register
   input          match_3_reg_sel16;   //Match16 3 Select16 register

   //outputs16
   output [15:0]  count_val_out16;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out16;    //Counter16 control16 reg select16
   output [15:0]  interval_reg_out16;     //Interval16 reg
   output [15:0]  match_1_reg_out16;      //Match16 1 register
   output [15:0]  match_2_reg_out16;      //Match16 2 register
   output [15:0]  match_3_reg_out16;      //Match16 3 register
   output         interval_intr16;        //Interval16 interrupt16
   output [3:1]   match_intr16;           //Match16 interrupt16
   output         overflow_intr16;        //Overflow16 interrupt16

//--------------------------------------------------------------------
// Internal Signals16 & Registers16
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg16;     // 5-bit Counter16 Control16 Register
   reg [15:0]     interval_reg16;      //16-bit Interval16 Register 
   reg [15:0]     match_1_reg16;       //16-bit Match_116 Register
   reg [15:0]     match_2_reg16;       //16-bit Match_216 Register
   reg [15:0]     match_3_reg16;       //16-bit Match_316 Register
   reg [15:0]     count_val16;         //16-bit counter value register
                                                                      
   
   reg            counting16;          //counter has starting counting16
   reg            restart_temp16;   //ensures16 soft16 reset lasts16 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out16; //7-bit Counter16 Control16 Register
   wire [15:0]    interval_reg_out16;  //16-bit Interval16 Register 
   wire [15:0]    match_1_reg_out16;   //16-bit Match_116 Register
   wire [15:0]    match_2_reg_out16;   //16-bit Match_216 Register
   wire [15:0]    match_3_reg_out16;   //16-bit Match_316 Register
   wire [15:0]    count_val_out16;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign16 output wires16
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out16 = cntr_ctrl_reg16;    // 7-bit Counter16 Control16
   assign interval_reg_out16  = interval_reg16;     // 16-bit Interval16
   assign match_1_reg_out16   = match_1_reg16;      // 16-bit Match_116
   assign match_2_reg_out16   = match_2_reg16;      // 16-bit Match_216 
   assign match_3_reg_out16   = match_3_reg16;      // 16-bit Match_316 
   assign count_val_out16     = count_val16;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning16 interrupts16
//--------------------------------------------------------------------

   assign interval_intr16 =  cntr_ctrl_reg16[1] & (count_val16 == 16'h0000)
      & (counting16) & ~cntr_ctrl_reg16[4] & ~cntr_ctrl_reg16[0];
   assign overflow_intr16 = ~cntr_ctrl_reg16[1] & (count_val16 == 16'h0000)
      & (counting16) & ~cntr_ctrl_reg16[4] & ~cntr_ctrl_reg16[0];
   assign match_intr16[1]  =  cntr_ctrl_reg16[3] & (count_val16 == match_1_reg16)
      & (counting16) & ~cntr_ctrl_reg16[4] & ~cntr_ctrl_reg16[0];
   assign match_intr16[2]  =  cntr_ctrl_reg16[3] & (count_val16 == match_2_reg16)
      & (counting16) & ~cntr_ctrl_reg16[4] & ~cntr_ctrl_reg16[0];
   assign match_intr16[3]  =  cntr_ctrl_reg16[3] & (count_val16 == match_3_reg16)
      & (counting16) & ~cntr_ctrl_reg16[4] & ~cntr_ctrl_reg16[0];


//    p_reg_ctrl16: Process16 to write to the counter control16 registers
//    cntr_ctrl_reg16 decode:  0 - Counter16 Enable16 Active16 Low16
//                           1 - Interval16 Mode16 =1, Overflow16 =0
//                           2 - Decrement16 Mode16
//                           3 - Match16 Mode16
//                           4 - Restart16
//                           5 - Waveform16 enable active low16
//                           6 - Waveform16 polarity16
   
   always @ (posedge pclk16 or negedge n_p_reset16)
   begin: p_reg_ctrl16  // Register writes
      
      if (!n_p_reset16)                                   
      begin                                     
         cntr_ctrl_reg16 <= 7'b0000001;
         interval_reg16  <= 16'h0000;
         match_1_reg16   <= 16'h0000;
         match_2_reg16   <= 16'h0000;
         match_3_reg16   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel16)
            cntr_ctrl_reg16 <= pwdata16[6:0];
         else if (restart_temp16)
            cntr_ctrl_reg16[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg16 <= cntr_ctrl_reg16;             

         interval_reg16  <= (interval_reg_sel16) ? pwdata16 : interval_reg16;
         match_1_reg16   <= (match_1_reg_sel16)  ? pwdata16 : match_1_reg16;
         match_2_reg16   <= (match_2_reg_sel16)  ? pwdata16 : match_2_reg16;
         match_3_reg16   <= (match_3_reg_sel16)  ? pwdata16 : match_3_reg16;   
      end
      
   end  //p_reg_ctrl16

   
//    p_cntr16: Process16 to increment or decrement the counter on receiving16 a 
//            count_en16 signal16 from the pre_scaler16. Count16 can be restarted16
//            or disabled and can overflow16 at a specified interval16 value.
   
   
   always @ (posedge pclk16 or negedge n_p_reset16)
   begin: p_cntr16   // Counter16 block

      if (!n_p_reset16)     //System16 Reset16
      begin                     
         count_val16 <= 16'h0000;
         counting16  <= 1'b0;
         restart_temp16 <= 1'b0;
      end
      else if (count_en16)
      begin
         
         if (cntr_ctrl_reg16[4])     //Restart16
         begin     
            if (~cntr_ctrl_reg16[2])  
               count_val16         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg16[1])
                 count_val16         <= interval_reg16;     
              else
                 count_val16         <= 16'hFFFF;     
            end
            counting16       <= 1'b0;
            restart_temp16   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg16[0])          //Low16 Active16 Counter16 Enable16
            begin

               if (cntr_ctrl_reg16[1])  //Interval16               
                  if (cntr_ctrl_reg16[2])  //Decrement16        
                  begin
                     if (count_val16 == 16'h0000)
                        count_val16 <= interval_reg16;  //Assumed16 Static16
                     else
                        count_val16 <= count_val16 - 16'h0001;
                  end
                  else                   //Increment16
                  begin
                     if (count_val16 == interval_reg16)
                        count_val16 <= 16'h0000;
                     else           
                        count_val16 <= count_val16 + 16'h0001;
                  end
               else    
               begin  //Overflow16
                  if (cntr_ctrl_reg16[2])   //Decrement16
                  begin
                     if (count_val16 == 16'h0000)
                        count_val16 <= 16'hFFFF;
                     else           
                        count_val16 <= count_val16 - 16'h0001;
                  end
                  else                    //Increment16
                  begin
                     if (count_val16 == 16'hFFFF)
                        count_val16 <= 16'h0000;
                     else           
                        count_val16 <= count_val16 + 16'h0001;
                  end 
               end
               counting16  <= 1'b1;
            end     
            else
               count_val16 <= count_val16;   //Disabled16
   
            restart_temp16 <= 1'b0;
      
         end
     
      end // if (count_en16)

      else
      begin
         count_val16    <= count_val16;
         counting16     <= counting16;
         restart_temp16 <= restart_temp16;               
      end
     
   end  //p_cntr16

endmodule
