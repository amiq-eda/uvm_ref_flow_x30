//File24 name   : ttc_counter_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 :The counter can increment and decrement.
//   In increment mode instead of counting24 to its full 16 bit
//   value the counter counts24 up to or down from a programmed24 interval24 value.
//   Interrupts24 are issued24 when the counter overflows24 or reaches24 it's interval24
//   value. In match mode if the count value equals24 that stored24 in one of three24
//   match registers an interrupt24 is issued24.
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
//


module ttc_counter_lite24(

  //inputs24
  n_p_reset24,    
  pclk24,          
  pwdata24,              
  count_en24,
  cntr_ctrl_reg_sel24, 
  interval_reg_sel24,
  match_1_reg_sel24,
  match_2_reg_sel24,
  match_3_reg_sel24,         

  //outputs24    
  count_val_out24,
  cntr_ctrl_reg_out24,
  interval_reg_out24,
  match_1_reg_out24,
  match_2_reg_out24,
  match_3_reg_out24,
  interval_intr24,
  match_intr24,
  overflow_intr24

);


//--------------------------------------------------------------------
// PORT DECLARATIONS24
//--------------------------------------------------------------------

   //inputs24
   input          n_p_reset24;         //reset signal24
   input          pclk24;              //System24 Clock24
   input [15:0]   pwdata24;            //6 Bit24 data signal24
   input          count_en24;          //Count24 enable signal24
   input          cntr_ctrl_reg_sel24; //Select24 bit for ctrl_reg24
   input          interval_reg_sel24;  //Interval24 Select24 Register
   input          match_1_reg_sel24;   //Match24 1 Select24 register
   input          match_2_reg_sel24;   //Match24 2 Select24 register
   input          match_3_reg_sel24;   //Match24 3 Select24 register

   //outputs24
   output [15:0]  count_val_out24;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out24;    //Counter24 control24 reg select24
   output [15:0]  interval_reg_out24;     //Interval24 reg
   output [15:0]  match_1_reg_out24;      //Match24 1 register
   output [15:0]  match_2_reg_out24;      //Match24 2 register
   output [15:0]  match_3_reg_out24;      //Match24 3 register
   output         interval_intr24;        //Interval24 interrupt24
   output [3:1]   match_intr24;           //Match24 interrupt24
   output         overflow_intr24;        //Overflow24 interrupt24

//--------------------------------------------------------------------
// Internal Signals24 & Registers24
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg24;     // 5-bit Counter24 Control24 Register
   reg [15:0]     interval_reg24;      //16-bit Interval24 Register 
   reg [15:0]     match_1_reg24;       //16-bit Match_124 Register
   reg [15:0]     match_2_reg24;       //16-bit Match_224 Register
   reg [15:0]     match_3_reg24;       //16-bit Match_324 Register
   reg [15:0]     count_val24;         //16-bit counter value register
                                                                      
   
   reg            counting24;          //counter has starting counting24
   reg            restart_temp24;   //ensures24 soft24 reset lasts24 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out24; //7-bit Counter24 Control24 Register
   wire [15:0]    interval_reg_out24;  //16-bit Interval24 Register 
   wire [15:0]    match_1_reg_out24;   //16-bit Match_124 Register
   wire [15:0]    match_2_reg_out24;   //16-bit Match_224 Register
   wire [15:0]    match_3_reg_out24;   //16-bit Match_324 Register
   wire [15:0]    count_val_out24;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign24 output wires24
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out24 = cntr_ctrl_reg24;    // 7-bit Counter24 Control24
   assign interval_reg_out24  = interval_reg24;     // 16-bit Interval24
   assign match_1_reg_out24   = match_1_reg24;      // 16-bit Match_124
   assign match_2_reg_out24   = match_2_reg24;      // 16-bit Match_224 
   assign match_3_reg_out24   = match_3_reg24;      // 16-bit Match_324 
   assign count_val_out24     = count_val24;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning24 interrupts24
//--------------------------------------------------------------------

   assign interval_intr24 =  cntr_ctrl_reg24[1] & (count_val24 == 16'h0000)
      & (counting24) & ~cntr_ctrl_reg24[4] & ~cntr_ctrl_reg24[0];
   assign overflow_intr24 = ~cntr_ctrl_reg24[1] & (count_val24 == 16'h0000)
      & (counting24) & ~cntr_ctrl_reg24[4] & ~cntr_ctrl_reg24[0];
   assign match_intr24[1]  =  cntr_ctrl_reg24[3] & (count_val24 == match_1_reg24)
      & (counting24) & ~cntr_ctrl_reg24[4] & ~cntr_ctrl_reg24[0];
   assign match_intr24[2]  =  cntr_ctrl_reg24[3] & (count_val24 == match_2_reg24)
      & (counting24) & ~cntr_ctrl_reg24[4] & ~cntr_ctrl_reg24[0];
   assign match_intr24[3]  =  cntr_ctrl_reg24[3] & (count_val24 == match_3_reg24)
      & (counting24) & ~cntr_ctrl_reg24[4] & ~cntr_ctrl_reg24[0];


//    p_reg_ctrl24: Process24 to write to the counter control24 registers
//    cntr_ctrl_reg24 decode:  0 - Counter24 Enable24 Active24 Low24
//                           1 - Interval24 Mode24 =1, Overflow24 =0
//                           2 - Decrement24 Mode24
//                           3 - Match24 Mode24
//                           4 - Restart24
//                           5 - Waveform24 enable active low24
//                           6 - Waveform24 polarity24
   
   always @ (posedge pclk24 or negedge n_p_reset24)
   begin: p_reg_ctrl24  // Register writes
      
      if (!n_p_reset24)                                   
      begin                                     
         cntr_ctrl_reg24 <= 7'b0000001;
         interval_reg24  <= 16'h0000;
         match_1_reg24   <= 16'h0000;
         match_2_reg24   <= 16'h0000;
         match_3_reg24   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel24)
            cntr_ctrl_reg24 <= pwdata24[6:0];
         else if (restart_temp24)
            cntr_ctrl_reg24[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg24 <= cntr_ctrl_reg24;             

         interval_reg24  <= (interval_reg_sel24) ? pwdata24 : interval_reg24;
         match_1_reg24   <= (match_1_reg_sel24)  ? pwdata24 : match_1_reg24;
         match_2_reg24   <= (match_2_reg_sel24)  ? pwdata24 : match_2_reg24;
         match_3_reg24   <= (match_3_reg_sel24)  ? pwdata24 : match_3_reg24;   
      end
      
   end  //p_reg_ctrl24

   
//    p_cntr24: Process24 to increment or decrement the counter on receiving24 a 
//            count_en24 signal24 from the pre_scaler24. Count24 can be restarted24
//            or disabled and can overflow24 at a specified interval24 value.
   
   
   always @ (posedge pclk24 or negedge n_p_reset24)
   begin: p_cntr24   // Counter24 block

      if (!n_p_reset24)     //System24 Reset24
      begin                     
         count_val24 <= 16'h0000;
         counting24  <= 1'b0;
         restart_temp24 <= 1'b0;
      end
      else if (count_en24)
      begin
         
         if (cntr_ctrl_reg24[4])     //Restart24
         begin     
            if (~cntr_ctrl_reg24[2])  
               count_val24         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg24[1])
                 count_val24         <= interval_reg24;     
              else
                 count_val24         <= 16'hFFFF;     
            end
            counting24       <= 1'b0;
            restart_temp24   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg24[0])          //Low24 Active24 Counter24 Enable24
            begin

               if (cntr_ctrl_reg24[1])  //Interval24               
                  if (cntr_ctrl_reg24[2])  //Decrement24        
                  begin
                     if (count_val24 == 16'h0000)
                        count_val24 <= interval_reg24;  //Assumed24 Static24
                     else
                        count_val24 <= count_val24 - 16'h0001;
                  end
                  else                   //Increment24
                  begin
                     if (count_val24 == interval_reg24)
                        count_val24 <= 16'h0000;
                     else           
                        count_val24 <= count_val24 + 16'h0001;
                  end
               else    
               begin  //Overflow24
                  if (cntr_ctrl_reg24[2])   //Decrement24
                  begin
                     if (count_val24 == 16'h0000)
                        count_val24 <= 16'hFFFF;
                     else           
                        count_val24 <= count_val24 - 16'h0001;
                  end
                  else                    //Increment24
                  begin
                     if (count_val24 == 16'hFFFF)
                        count_val24 <= 16'h0000;
                     else           
                        count_val24 <= count_val24 + 16'h0001;
                  end 
               end
               counting24  <= 1'b1;
            end     
            else
               count_val24 <= count_val24;   //Disabled24
   
            restart_temp24 <= 1'b0;
      
         end
     
      end // if (count_en24)

      else
      begin
         count_val24    <= count_val24;
         counting24     <= counting24;
         restart_temp24 <= restart_temp24;               
      end
     
   end  //p_cntr24

endmodule
