//File10 name   : ttc_counter_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 :The counter can increment and decrement.
//   In increment mode instead of counting10 to its full 16 bit
//   value the counter counts10 up to or down from a programmed10 interval10 value.
//   Interrupts10 are issued10 when the counter overflows10 or reaches10 it's interval10
//   value. In match mode if the count value equals10 that stored10 in one of three10
//   match registers an interrupt10 is issued10.
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
//


module ttc_counter_lite10(

  //inputs10
  n_p_reset10,    
  pclk10,          
  pwdata10,              
  count_en10,
  cntr_ctrl_reg_sel10, 
  interval_reg_sel10,
  match_1_reg_sel10,
  match_2_reg_sel10,
  match_3_reg_sel10,         

  //outputs10    
  count_val_out10,
  cntr_ctrl_reg_out10,
  interval_reg_out10,
  match_1_reg_out10,
  match_2_reg_out10,
  match_3_reg_out10,
  interval_intr10,
  match_intr10,
  overflow_intr10

);


//--------------------------------------------------------------------
// PORT DECLARATIONS10
//--------------------------------------------------------------------

   //inputs10
   input          n_p_reset10;         //reset signal10
   input          pclk10;              //System10 Clock10
   input [15:0]   pwdata10;            //6 Bit10 data signal10
   input          count_en10;          //Count10 enable signal10
   input          cntr_ctrl_reg_sel10; //Select10 bit for ctrl_reg10
   input          interval_reg_sel10;  //Interval10 Select10 Register
   input          match_1_reg_sel10;   //Match10 1 Select10 register
   input          match_2_reg_sel10;   //Match10 2 Select10 register
   input          match_3_reg_sel10;   //Match10 3 Select10 register

   //outputs10
   output [15:0]  count_val_out10;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out10;    //Counter10 control10 reg select10
   output [15:0]  interval_reg_out10;     //Interval10 reg
   output [15:0]  match_1_reg_out10;      //Match10 1 register
   output [15:0]  match_2_reg_out10;      //Match10 2 register
   output [15:0]  match_3_reg_out10;      //Match10 3 register
   output         interval_intr10;        //Interval10 interrupt10
   output [3:1]   match_intr10;           //Match10 interrupt10
   output         overflow_intr10;        //Overflow10 interrupt10

//--------------------------------------------------------------------
// Internal Signals10 & Registers10
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg10;     // 5-bit Counter10 Control10 Register
   reg [15:0]     interval_reg10;      //16-bit Interval10 Register 
   reg [15:0]     match_1_reg10;       //16-bit Match_110 Register
   reg [15:0]     match_2_reg10;       //16-bit Match_210 Register
   reg [15:0]     match_3_reg10;       //16-bit Match_310 Register
   reg [15:0]     count_val10;         //16-bit counter value register
                                                                      
   
   reg            counting10;          //counter has starting counting10
   reg            restart_temp10;   //ensures10 soft10 reset lasts10 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out10; //7-bit Counter10 Control10 Register
   wire [15:0]    interval_reg_out10;  //16-bit Interval10 Register 
   wire [15:0]    match_1_reg_out10;   //16-bit Match_110 Register
   wire [15:0]    match_2_reg_out10;   //16-bit Match_210 Register
   wire [15:0]    match_3_reg_out10;   //16-bit Match_310 Register
   wire [15:0]    count_val_out10;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign10 output wires10
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out10 = cntr_ctrl_reg10;    // 7-bit Counter10 Control10
   assign interval_reg_out10  = interval_reg10;     // 16-bit Interval10
   assign match_1_reg_out10   = match_1_reg10;      // 16-bit Match_110
   assign match_2_reg_out10   = match_2_reg10;      // 16-bit Match_210 
   assign match_3_reg_out10   = match_3_reg10;      // 16-bit Match_310 
   assign count_val_out10     = count_val10;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning10 interrupts10
//--------------------------------------------------------------------

   assign interval_intr10 =  cntr_ctrl_reg10[1] & (count_val10 == 16'h0000)
      & (counting10) & ~cntr_ctrl_reg10[4] & ~cntr_ctrl_reg10[0];
   assign overflow_intr10 = ~cntr_ctrl_reg10[1] & (count_val10 == 16'h0000)
      & (counting10) & ~cntr_ctrl_reg10[4] & ~cntr_ctrl_reg10[0];
   assign match_intr10[1]  =  cntr_ctrl_reg10[3] & (count_val10 == match_1_reg10)
      & (counting10) & ~cntr_ctrl_reg10[4] & ~cntr_ctrl_reg10[0];
   assign match_intr10[2]  =  cntr_ctrl_reg10[3] & (count_val10 == match_2_reg10)
      & (counting10) & ~cntr_ctrl_reg10[4] & ~cntr_ctrl_reg10[0];
   assign match_intr10[3]  =  cntr_ctrl_reg10[3] & (count_val10 == match_3_reg10)
      & (counting10) & ~cntr_ctrl_reg10[4] & ~cntr_ctrl_reg10[0];


//    p_reg_ctrl10: Process10 to write to the counter control10 registers
//    cntr_ctrl_reg10 decode:  0 - Counter10 Enable10 Active10 Low10
//                           1 - Interval10 Mode10 =1, Overflow10 =0
//                           2 - Decrement10 Mode10
//                           3 - Match10 Mode10
//                           4 - Restart10
//                           5 - Waveform10 enable active low10
//                           6 - Waveform10 polarity10
   
   always @ (posedge pclk10 or negedge n_p_reset10)
   begin: p_reg_ctrl10  // Register writes
      
      if (!n_p_reset10)                                   
      begin                                     
         cntr_ctrl_reg10 <= 7'b0000001;
         interval_reg10  <= 16'h0000;
         match_1_reg10   <= 16'h0000;
         match_2_reg10   <= 16'h0000;
         match_3_reg10   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel10)
            cntr_ctrl_reg10 <= pwdata10[6:0];
         else if (restart_temp10)
            cntr_ctrl_reg10[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg10 <= cntr_ctrl_reg10;             

         interval_reg10  <= (interval_reg_sel10) ? pwdata10 : interval_reg10;
         match_1_reg10   <= (match_1_reg_sel10)  ? pwdata10 : match_1_reg10;
         match_2_reg10   <= (match_2_reg_sel10)  ? pwdata10 : match_2_reg10;
         match_3_reg10   <= (match_3_reg_sel10)  ? pwdata10 : match_3_reg10;   
      end
      
   end  //p_reg_ctrl10

   
//    p_cntr10: Process10 to increment or decrement the counter on receiving10 a 
//            count_en10 signal10 from the pre_scaler10. Count10 can be restarted10
//            or disabled and can overflow10 at a specified interval10 value.
   
   
   always @ (posedge pclk10 or negedge n_p_reset10)
   begin: p_cntr10   // Counter10 block

      if (!n_p_reset10)     //System10 Reset10
      begin                     
         count_val10 <= 16'h0000;
         counting10  <= 1'b0;
         restart_temp10 <= 1'b0;
      end
      else if (count_en10)
      begin
         
         if (cntr_ctrl_reg10[4])     //Restart10
         begin     
            if (~cntr_ctrl_reg10[2])  
               count_val10         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg10[1])
                 count_val10         <= interval_reg10;     
              else
                 count_val10         <= 16'hFFFF;     
            end
            counting10       <= 1'b0;
            restart_temp10   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg10[0])          //Low10 Active10 Counter10 Enable10
            begin

               if (cntr_ctrl_reg10[1])  //Interval10               
                  if (cntr_ctrl_reg10[2])  //Decrement10        
                  begin
                     if (count_val10 == 16'h0000)
                        count_val10 <= interval_reg10;  //Assumed10 Static10
                     else
                        count_val10 <= count_val10 - 16'h0001;
                  end
                  else                   //Increment10
                  begin
                     if (count_val10 == interval_reg10)
                        count_val10 <= 16'h0000;
                     else           
                        count_val10 <= count_val10 + 16'h0001;
                  end
               else    
               begin  //Overflow10
                  if (cntr_ctrl_reg10[2])   //Decrement10
                  begin
                     if (count_val10 == 16'h0000)
                        count_val10 <= 16'hFFFF;
                     else           
                        count_val10 <= count_val10 - 16'h0001;
                  end
                  else                    //Increment10
                  begin
                     if (count_val10 == 16'hFFFF)
                        count_val10 <= 16'h0000;
                     else           
                        count_val10 <= count_val10 + 16'h0001;
                  end 
               end
               counting10  <= 1'b1;
            end     
            else
               count_val10 <= count_val10;   //Disabled10
   
            restart_temp10 <= 1'b0;
      
         end
     
      end // if (count_en10)

      else
      begin
         count_val10    <= count_val10;
         counting10     <= counting10;
         restart_temp10 <= restart_temp10;               
      end
     
   end  //p_cntr10

endmodule
