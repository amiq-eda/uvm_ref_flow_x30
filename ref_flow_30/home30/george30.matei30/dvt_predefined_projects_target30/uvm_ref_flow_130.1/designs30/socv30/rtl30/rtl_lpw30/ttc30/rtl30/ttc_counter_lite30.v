//File30 name   : ttc_counter_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 :The counter can increment and decrement.
//   In increment mode instead of counting30 to its full 16 bit
//   value the counter counts30 up to or down from a programmed30 interval30 value.
//   Interrupts30 are issued30 when the counter overflows30 or reaches30 it's interval30
//   value. In match mode if the count value equals30 that stored30 in one of three30
//   match registers an interrupt30 is issued30.
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------
//


module ttc_counter_lite30(

  //inputs30
  n_p_reset30,    
  pclk30,          
  pwdata30,              
  count_en30,
  cntr_ctrl_reg_sel30, 
  interval_reg_sel30,
  match_1_reg_sel30,
  match_2_reg_sel30,
  match_3_reg_sel30,         

  //outputs30    
  count_val_out30,
  cntr_ctrl_reg_out30,
  interval_reg_out30,
  match_1_reg_out30,
  match_2_reg_out30,
  match_3_reg_out30,
  interval_intr30,
  match_intr30,
  overflow_intr30

);


//--------------------------------------------------------------------
// PORT DECLARATIONS30
//--------------------------------------------------------------------

   //inputs30
   input          n_p_reset30;         //reset signal30
   input          pclk30;              //System30 Clock30
   input [15:0]   pwdata30;            //6 Bit30 data signal30
   input          count_en30;          //Count30 enable signal30
   input          cntr_ctrl_reg_sel30; //Select30 bit for ctrl_reg30
   input          interval_reg_sel30;  //Interval30 Select30 Register
   input          match_1_reg_sel30;   //Match30 1 Select30 register
   input          match_2_reg_sel30;   //Match30 2 Select30 register
   input          match_3_reg_sel30;   //Match30 3 Select30 register

   //outputs30
   output [15:0]  count_val_out30;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out30;    //Counter30 control30 reg select30
   output [15:0]  interval_reg_out30;     //Interval30 reg
   output [15:0]  match_1_reg_out30;      //Match30 1 register
   output [15:0]  match_2_reg_out30;      //Match30 2 register
   output [15:0]  match_3_reg_out30;      //Match30 3 register
   output         interval_intr30;        //Interval30 interrupt30
   output [3:1]   match_intr30;           //Match30 interrupt30
   output         overflow_intr30;        //Overflow30 interrupt30

//--------------------------------------------------------------------
// Internal Signals30 & Registers30
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg30;     // 5-bit Counter30 Control30 Register
   reg [15:0]     interval_reg30;      //16-bit Interval30 Register 
   reg [15:0]     match_1_reg30;       //16-bit Match_130 Register
   reg [15:0]     match_2_reg30;       //16-bit Match_230 Register
   reg [15:0]     match_3_reg30;       //16-bit Match_330 Register
   reg [15:0]     count_val30;         //16-bit counter value register
                                                                      
   
   reg            counting30;          //counter has starting counting30
   reg            restart_temp30;   //ensures30 soft30 reset lasts30 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out30; //7-bit Counter30 Control30 Register
   wire [15:0]    interval_reg_out30;  //16-bit Interval30 Register 
   wire [15:0]    match_1_reg_out30;   //16-bit Match_130 Register
   wire [15:0]    match_2_reg_out30;   //16-bit Match_230 Register
   wire [15:0]    match_3_reg_out30;   //16-bit Match_330 Register
   wire [15:0]    count_val_out30;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign30 output wires30
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out30 = cntr_ctrl_reg30;    // 7-bit Counter30 Control30
   assign interval_reg_out30  = interval_reg30;     // 16-bit Interval30
   assign match_1_reg_out30   = match_1_reg30;      // 16-bit Match_130
   assign match_2_reg_out30   = match_2_reg30;      // 16-bit Match_230 
   assign match_3_reg_out30   = match_3_reg30;      // 16-bit Match_330 
   assign count_val_out30     = count_val30;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning30 interrupts30
//--------------------------------------------------------------------

   assign interval_intr30 =  cntr_ctrl_reg30[1] & (count_val30 == 16'h0000)
      & (counting30) & ~cntr_ctrl_reg30[4] & ~cntr_ctrl_reg30[0];
   assign overflow_intr30 = ~cntr_ctrl_reg30[1] & (count_val30 == 16'h0000)
      & (counting30) & ~cntr_ctrl_reg30[4] & ~cntr_ctrl_reg30[0];
   assign match_intr30[1]  =  cntr_ctrl_reg30[3] & (count_val30 == match_1_reg30)
      & (counting30) & ~cntr_ctrl_reg30[4] & ~cntr_ctrl_reg30[0];
   assign match_intr30[2]  =  cntr_ctrl_reg30[3] & (count_val30 == match_2_reg30)
      & (counting30) & ~cntr_ctrl_reg30[4] & ~cntr_ctrl_reg30[0];
   assign match_intr30[3]  =  cntr_ctrl_reg30[3] & (count_val30 == match_3_reg30)
      & (counting30) & ~cntr_ctrl_reg30[4] & ~cntr_ctrl_reg30[0];


//    p_reg_ctrl30: Process30 to write to the counter control30 registers
//    cntr_ctrl_reg30 decode:  0 - Counter30 Enable30 Active30 Low30
//                           1 - Interval30 Mode30 =1, Overflow30 =0
//                           2 - Decrement30 Mode30
//                           3 - Match30 Mode30
//                           4 - Restart30
//                           5 - Waveform30 enable active low30
//                           6 - Waveform30 polarity30
   
   always @ (posedge pclk30 or negedge n_p_reset30)
   begin: p_reg_ctrl30  // Register writes
      
      if (!n_p_reset30)                                   
      begin                                     
         cntr_ctrl_reg30 <= 7'b0000001;
         interval_reg30  <= 16'h0000;
         match_1_reg30   <= 16'h0000;
         match_2_reg30   <= 16'h0000;
         match_3_reg30   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel30)
            cntr_ctrl_reg30 <= pwdata30[6:0];
         else if (restart_temp30)
            cntr_ctrl_reg30[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg30 <= cntr_ctrl_reg30;             

         interval_reg30  <= (interval_reg_sel30) ? pwdata30 : interval_reg30;
         match_1_reg30   <= (match_1_reg_sel30)  ? pwdata30 : match_1_reg30;
         match_2_reg30   <= (match_2_reg_sel30)  ? pwdata30 : match_2_reg30;
         match_3_reg30   <= (match_3_reg_sel30)  ? pwdata30 : match_3_reg30;   
      end
      
   end  //p_reg_ctrl30

   
//    p_cntr30: Process30 to increment or decrement the counter on receiving30 a 
//            count_en30 signal30 from the pre_scaler30. Count30 can be restarted30
//            or disabled and can overflow30 at a specified interval30 value.
   
   
   always @ (posedge pclk30 or negedge n_p_reset30)
   begin: p_cntr30   // Counter30 block

      if (!n_p_reset30)     //System30 Reset30
      begin                     
         count_val30 <= 16'h0000;
         counting30  <= 1'b0;
         restart_temp30 <= 1'b0;
      end
      else if (count_en30)
      begin
         
         if (cntr_ctrl_reg30[4])     //Restart30
         begin     
            if (~cntr_ctrl_reg30[2])  
               count_val30         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg30[1])
                 count_val30         <= interval_reg30;     
              else
                 count_val30         <= 16'hFFFF;     
            end
            counting30       <= 1'b0;
            restart_temp30   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg30[0])          //Low30 Active30 Counter30 Enable30
            begin

               if (cntr_ctrl_reg30[1])  //Interval30               
                  if (cntr_ctrl_reg30[2])  //Decrement30        
                  begin
                     if (count_val30 == 16'h0000)
                        count_val30 <= interval_reg30;  //Assumed30 Static30
                     else
                        count_val30 <= count_val30 - 16'h0001;
                  end
                  else                   //Increment30
                  begin
                     if (count_val30 == interval_reg30)
                        count_val30 <= 16'h0000;
                     else           
                        count_val30 <= count_val30 + 16'h0001;
                  end
               else    
               begin  //Overflow30
                  if (cntr_ctrl_reg30[2])   //Decrement30
                  begin
                     if (count_val30 == 16'h0000)
                        count_val30 <= 16'hFFFF;
                     else           
                        count_val30 <= count_val30 - 16'h0001;
                  end
                  else                    //Increment30
                  begin
                     if (count_val30 == 16'hFFFF)
                        count_val30 <= 16'h0000;
                     else           
                        count_val30 <= count_val30 + 16'h0001;
                  end 
               end
               counting30  <= 1'b1;
            end     
            else
               count_val30 <= count_val30;   //Disabled30
   
            restart_temp30 <= 1'b0;
      
         end
     
      end // if (count_en30)

      else
      begin
         count_val30    <= count_val30;
         counting30     <= counting30;
         restart_temp30 <= restart_temp30;               
      end
     
   end  //p_cntr30

endmodule
