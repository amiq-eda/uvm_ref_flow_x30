//File20 name   : ttc_counter_lite20.v
//Title20       : 
//Created20     : 1999
//Description20 :The counter can increment and decrement.
//   In increment mode instead of counting20 to its full 16 bit
//   value the counter counts20 up to or down from a programmed20 interval20 value.
//   Interrupts20 are issued20 when the counter overflows20 or reaches20 it's interval20
//   value. In match mode if the count value equals20 that stored20 in one of three20
//   match registers an interrupt20 is issued20.
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------
//


module ttc_counter_lite20(

  //inputs20
  n_p_reset20,    
  pclk20,          
  pwdata20,              
  count_en20,
  cntr_ctrl_reg_sel20, 
  interval_reg_sel20,
  match_1_reg_sel20,
  match_2_reg_sel20,
  match_3_reg_sel20,         

  //outputs20    
  count_val_out20,
  cntr_ctrl_reg_out20,
  interval_reg_out20,
  match_1_reg_out20,
  match_2_reg_out20,
  match_3_reg_out20,
  interval_intr20,
  match_intr20,
  overflow_intr20

);


//--------------------------------------------------------------------
// PORT DECLARATIONS20
//--------------------------------------------------------------------

   //inputs20
   input          n_p_reset20;         //reset signal20
   input          pclk20;              //System20 Clock20
   input [15:0]   pwdata20;            //6 Bit20 data signal20
   input          count_en20;          //Count20 enable signal20
   input          cntr_ctrl_reg_sel20; //Select20 bit for ctrl_reg20
   input          interval_reg_sel20;  //Interval20 Select20 Register
   input          match_1_reg_sel20;   //Match20 1 Select20 register
   input          match_2_reg_sel20;   //Match20 2 Select20 register
   input          match_3_reg_sel20;   //Match20 3 Select20 register

   //outputs20
   output [15:0]  count_val_out20;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out20;    //Counter20 control20 reg select20
   output [15:0]  interval_reg_out20;     //Interval20 reg
   output [15:0]  match_1_reg_out20;      //Match20 1 register
   output [15:0]  match_2_reg_out20;      //Match20 2 register
   output [15:0]  match_3_reg_out20;      //Match20 3 register
   output         interval_intr20;        //Interval20 interrupt20
   output [3:1]   match_intr20;           //Match20 interrupt20
   output         overflow_intr20;        //Overflow20 interrupt20

//--------------------------------------------------------------------
// Internal Signals20 & Registers20
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg20;     // 5-bit Counter20 Control20 Register
   reg [15:0]     interval_reg20;      //16-bit Interval20 Register 
   reg [15:0]     match_1_reg20;       //16-bit Match_120 Register
   reg [15:0]     match_2_reg20;       //16-bit Match_220 Register
   reg [15:0]     match_3_reg20;       //16-bit Match_320 Register
   reg [15:0]     count_val20;         //16-bit counter value register
                                                                      
   
   reg            counting20;          //counter has starting counting20
   reg            restart_temp20;   //ensures20 soft20 reset lasts20 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out20; //7-bit Counter20 Control20 Register
   wire [15:0]    interval_reg_out20;  //16-bit Interval20 Register 
   wire [15:0]    match_1_reg_out20;   //16-bit Match_120 Register
   wire [15:0]    match_2_reg_out20;   //16-bit Match_220 Register
   wire [15:0]    match_3_reg_out20;   //16-bit Match_320 Register
   wire [15:0]    count_val_out20;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign20 output wires20
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out20 = cntr_ctrl_reg20;    // 7-bit Counter20 Control20
   assign interval_reg_out20  = interval_reg20;     // 16-bit Interval20
   assign match_1_reg_out20   = match_1_reg20;      // 16-bit Match_120
   assign match_2_reg_out20   = match_2_reg20;      // 16-bit Match_220 
   assign match_3_reg_out20   = match_3_reg20;      // 16-bit Match_320 
   assign count_val_out20     = count_val20;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning20 interrupts20
//--------------------------------------------------------------------

   assign interval_intr20 =  cntr_ctrl_reg20[1] & (count_val20 == 16'h0000)
      & (counting20) & ~cntr_ctrl_reg20[4] & ~cntr_ctrl_reg20[0];
   assign overflow_intr20 = ~cntr_ctrl_reg20[1] & (count_val20 == 16'h0000)
      & (counting20) & ~cntr_ctrl_reg20[4] & ~cntr_ctrl_reg20[0];
   assign match_intr20[1]  =  cntr_ctrl_reg20[3] & (count_val20 == match_1_reg20)
      & (counting20) & ~cntr_ctrl_reg20[4] & ~cntr_ctrl_reg20[0];
   assign match_intr20[2]  =  cntr_ctrl_reg20[3] & (count_val20 == match_2_reg20)
      & (counting20) & ~cntr_ctrl_reg20[4] & ~cntr_ctrl_reg20[0];
   assign match_intr20[3]  =  cntr_ctrl_reg20[3] & (count_val20 == match_3_reg20)
      & (counting20) & ~cntr_ctrl_reg20[4] & ~cntr_ctrl_reg20[0];


//    p_reg_ctrl20: Process20 to write to the counter control20 registers
//    cntr_ctrl_reg20 decode:  0 - Counter20 Enable20 Active20 Low20
//                           1 - Interval20 Mode20 =1, Overflow20 =0
//                           2 - Decrement20 Mode20
//                           3 - Match20 Mode20
//                           4 - Restart20
//                           5 - Waveform20 enable active low20
//                           6 - Waveform20 polarity20
   
   always @ (posedge pclk20 or negedge n_p_reset20)
   begin: p_reg_ctrl20  // Register writes
      
      if (!n_p_reset20)                                   
      begin                                     
         cntr_ctrl_reg20 <= 7'b0000001;
         interval_reg20  <= 16'h0000;
         match_1_reg20   <= 16'h0000;
         match_2_reg20   <= 16'h0000;
         match_3_reg20   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel20)
            cntr_ctrl_reg20 <= pwdata20[6:0];
         else if (restart_temp20)
            cntr_ctrl_reg20[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg20 <= cntr_ctrl_reg20;             

         interval_reg20  <= (interval_reg_sel20) ? pwdata20 : interval_reg20;
         match_1_reg20   <= (match_1_reg_sel20)  ? pwdata20 : match_1_reg20;
         match_2_reg20   <= (match_2_reg_sel20)  ? pwdata20 : match_2_reg20;
         match_3_reg20   <= (match_3_reg_sel20)  ? pwdata20 : match_3_reg20;   
      end
      
   end  //p_reg_ctrl20

   
//    p_cntr20: Process20 to increment or decrement the counter on receiving20 a 
//            count_en20 signal20 from the pre_scaler20. Count20 can be restarted20
//            or disabled and can overflow20 at a specified interval20 value.
   
   
   always @ (posedge pclk20 or negedge n_p_reset20)
   begin: p_cntr20   // Counter20 block

      if (!n_p_reset20)     //System20 Reset20
      begin                     
         count_val20 <= 16'h0000;
         counting20  <= 1'b0;
         restart_temp20 <= 1'b0;
      end
      else if (count_en20)
      begin
         
         if (cntr_ctrl_reg20[4])     //Restart20
         begin     
            if (~cntr_ctrl_reg20[2])  
               count_val20         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg20[1])
                 count_val20         <= interval_reg20;     
              else
                 count_val20         <= 16'hFFFF;     
            end
            counting20       <= 1'b0;
            restart_temp20   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg20[0])          //Low20 Active20 Counter20 Enable20
            begin

               if (cntr_ctrl_reg20[1])  //Interval20               
                  if (cntr_ctrl_reg20[2])  //Decrement20        
                  begin
                     if (count_val20 == 16'h0000)
                        count_val20 <= interval_reg20;  //Assumed20 Static20
                     else
                        count_val20 <= count_val20 - 16'h0001;
                  end
                  else                   //Increment20
                  begin
                     if (count_val20 == interval_reg20)
                        count_val20 <= 16'h0000;
                     else           
                        count_val20 <= count_val20 + 16'h0001;
                  end
               else    
               begin  //Overflow20
                  if (cntr_ctrl_reg20[2])   //Decrement20
                  begin
                     if (count_val20 == 16'h0000)
                        count_val20 <= 16'hFFFF;
                     else           
                        count_val20 <= count_val20 - 16'h0001;
                  end
                  else                    //Increment20
                  begin
                     if (count_val20 == 16'hFFFF)
                        count_val20 <= 16'h0000;
                     else           
                        count_val20 <= count_val20 + 16'h0001;
                  end 
               end
               counting20  <= 1'b1;
            end     
            else
               count_val20 <= count_val20;   //Disabled20
   
            restart_temp20 <= 1'b0;
      
         end
     
      end // if (count_en20)

      else
      begin
         count_val20    <= count_val20;
         counting20     <= counting20;
         restart_temp20 <= restart_temp20;               
      end
     
   end  //p_cntr20

endmodule
