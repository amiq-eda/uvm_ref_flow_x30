//File1 name   : ttc_counter_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 :The counter can increment and decrement.
//   In increment mode instead of counting1 to its full 16 bit
//   value the counter counts1 up to or down from a programmed1 interval1 value.
//   Interrupts1 are issued1 when the counter overflows1 or reaches1 it's interval1
//   value. In match mode if the count value equals1 that stored1 in one of three1
//   match registers an interrupt1 is issued1.
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------
//


module ttc_counter_lite1(

  //inputs1
  n_p_reset1,    
  pclk1,          
  pwdata1,              
  count_en1,
  cntr_ctrl_reg_sel1, 
  interval_reg_sel1,
  match_1_reg_sel1,
  match_2_reg_sel1,
  match_3_reg_sel1,         

  //outputs1    
  count_val_out1,
  cntr_ctrl_reg_out1,
  interval_reg_out1,
  match_1_reg_out1,
  match_2_reg_out1,
  match_3_reg_out1,
  interval_intr1,
  match_intr1,
  overflow_intr1

);


//--------------------------------------------------------------------
// PORT DECLARATIONS1
//--------------------------------------------------------------------

   //inputs1
   input          n_p_reset1;         //reset signal1
   input          pclk1;              //System1 Clock1
   input [15:0]   pwdata1;            //6 Bit1 data signal1
   input          count_en1;          //Count1 enable signal1
   input          cntr_ctrl_reg_sel1; //Select1 bit for ctrl_reg1
   input          interval_reg_sel1;  //Interval1 Select1 Register
   input          match_1_reg_sel1;   //Match1 1 Select1 register
   input          match_2_reg_sel1;   //Match1 2 Select1 register
   input          match_3_reg_sel1;   //Match1 3 Select1 register

   //outputs1
   output [15:0]  count_val_out1;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out1;    //Counter1 control1 reg select1
   output [15:0]  interval_reg_out1;     //Interval1 reg
   output [15:0]  match_1_reg_out1;      //Match1 1 register
   output [15:0]  match_2_reg_out1;      //Match1 2 register
   output [15:0]  match_3_reg_out1;      //Match1 3 register
   output         interval_intr1;        //Interval1 interrupt1
   output [3:1]   match_intr1;           //Match1 interrupt1
   output         overflow_intr1;        //Overflow1 interrupt1

//--------------------------------------------------------------------
// Internal Signals1 & Registers1
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg1;     // 5-bit Counter1 Control1 Register
   reg [15:0]     interval_reg1;      //16-bit Interval1 Register 
   reg [15:0]     match_1_reg1;       //16-bit Match_11 Register
   reg [15:0]     match_2_reg1;       //16-bit Match_21 Register
   reg [15:0]     match_3_reg1;       //16-bit Match_31 Register
   reg [15:0]     count_val1;         //16-bit counter value register
                                                                      
   
   reg            counting1;          //counter has starting counting1
   reg            restart_temp1;   //ensures1 soft1 reset lasts1 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out1; //7-bit Counter1 Control1 Register
   wire [15:0]    interval_reg_out1;  //16-bit Interval1 Register 
   wire [15:0]    match_1_reg_out1;   //16-bit Match_11 Register
   wire [15:0]    match_2_reg_out1;   //16-bit Match_21 Register
   wire [15:0]    match_3_reg_out1;   //16-bit Match_31 Register
   wire [15:0]    count_val_out1;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign1 output wires1
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out1 = cntr_ctrl_reg1;    // 7-bit Counter1 Control1
   assign interval_reg_out1  = interval_reg1;     // 16-bit Interval1
   assign match_1_reg_out1   = match_1_reg1;      // 16-bit Match_11
   assign match_2_reg_out1   = match_2_reg1;      // 16-bit Match_21 
   assign match_3_reg_out1   = match_3_reg1;      // 16-bit Match_31 
   assign count_val_out1     = count_val1;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning1 interrupts1
//--------------------------------------------------------------------

   assign interval_intr1 =  cntr_ctrl_reg1[1] & (count_val1 == 16'h0000)
      & (counting1) & ~cntr_ctrl_reg1[4] & ~cntr_ctrl_reg1[0];
   assign overflow_intr1 = ~cntr_ctrl_reg1[1] & (count_val1 == 16'h0000)
      & (counting1) & ~cntr_ctrl_reg1[4] & ~cntr_ctrl_reg1[0];
   assign match_intr1[1]  =  cntr_ctrl_reg1[3] & (count_val1 == match_1_reg1)
      & (counting1) & ~cntr_ctrl_reg1[4] & ~cntr_ctrl_reg1[0];
   assign match_intr1[2]  =  cntr_ctrl_reg1[3] & (count_val1 == match_2_reg1)
      & (counting1) & ~cntr_ctrl_reg1[4] & ~cntr_ctrl_reg1[0];
   assign match_intr1[3]  =  cntr_ctrl_reg1[3] & (count_val1 == match_3_reg1)
      & (counting1) & ~cntr_ctrl_reg1[4] & ~cntr_ctrl_reg1[0];


//    p_reg_ctrl1: Process1 to write to the counter control1 registers
//    cntr_ctrl_reg1 decode:  0 - Counter1 Enable1 Active1 Low1
//                           1 - Interval1 Mode1 =1, Overflow1 =0
//                           2 - Decrement1 Mode1
//                           3 - Match1 Mode1
//                           4 - Restart1
//                           5 - Waveform1 enable active low1
//                           6 - Waveform1 polarity1
   
   always @ (posedge pclk1 or negedge n_p_reset1)
   begin: p_reg_ctrl1  // Register writes
      
      if (!n_p_reset1)                                   
      begin                                     
         cntr_ctrl_reg1 <= 7'b0000001;
         interval_reg1  <= 16'h0000;
         match_1_reg1   <= 16'h0000;
         match_2_reg1   <= 16'h0000;
         match_3_reg1   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel1)
            cntr_ctrl_reg1 <= pwdata1[6:0];
         else if (restart_temp1)
            cntr_ctrl_reg1[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg1 <= cntr_ctrl_reg1;             

         interval_reg1  <= (interval_reg_sel1) ? pwdata1 : interval_reg1;
         match_1_reg1   <= (match_1_reg_sel1)  ? pwdata1 : match_1_reg1;
         match_2_reg1   <= (match_2_reg_sel1)  ? pwdata1 : match_2_reg1;
         match_3_reg1   <= (match_3_reg_sel1)  ? pwdata1 : match_3_reg1;   
      end
      
   end  //p_reg_ctrl1

   
//    p_cntr1: Process1 to increment or decrement the counter on receiving1 a 
//            count_en1 signal1 from the pre_scaler1. Count1 can be restarted1
//            or disabled and can overflow1 at a specified interval1 value.
   
   
   always @ (posedge pclk1 or negedge n_p_reset1)
   begin: p_cntr1   // Counter1 block

      if (!n_p_reset1)     //System1 Reset1
      begin                     
         count_val1 <= 16'h0000;
         counting1  <= 1'b0;
         restart_temp1 <= 1'b0;
      end
      else if (count_en1)
      begin
         
         if (cntr_ctrl_reg1[4])     //Restart1
         begin     
            if (~cntr_ctrl_reg1[2])  
               count_val1         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg1[1])
                 count_val1         <= interval_reg1;     
              else
                 count_val1         <= 16'hFFFF;     
            end
            counting1       <= 1'b0;
            restart_temp1   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg1[0])          //Low1 Active1 Counter1 Enable1
            begin

               if (cntr_ctrl_reg1[1])  //Interval1               
                  if (cntr_ctrl_reg1[2])  //Decrement1        
                  begin
                     if (count_val1 == 16'h0000)
                        count_val1 <= interval_reg1;  //Assumed1 Static1
                     else
                        count_val1 <= count_val1 - 16'h0001;
                  end
                  else                   //Increment1
                  begin
                     if (count_val1 == interval_reg1)
                        count_val1 <= 16'h0000;
                     else           
                        count_val1 <= count_val1 + 16'h0001;
                  end
               else    
               begin  //Overflow1
                  if (cntr_ctrl_reg1[2])   //Decrement1
                  begin
                     if (count_val1 == 16'h0000)
                        count_val1 <= 16'hFFFF;
                     else           
                        count_val1 <= count_val1 - 16'h0001;
                  end
                  else                    //Increment1
                  begin
                     if (count_val1 == 16'hFFFF)
                        count_val1 <= 16'h0000;
                     else           
                        count_val1 <= count_val1 + 16'h0001;
                  end 
               end
               counting1  <= 1'b1;
            end     
            else
               count_val1 <= count_val1;   //Disabled1
   
            restart_temp1 <= 1'b0;
      
         end
     
      end // if (count_en1)

      else
      begin
         count_val1    <= count_val1;
         counting1     <= counting1;
         restart_temp1 <= restart_temp1;               
      end
     
   end  //p_cntr1

endmodule
