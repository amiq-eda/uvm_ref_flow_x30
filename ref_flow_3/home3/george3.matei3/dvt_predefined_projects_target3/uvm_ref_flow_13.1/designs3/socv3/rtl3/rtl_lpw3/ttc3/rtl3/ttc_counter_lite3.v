//File3 name   : ttc_counter_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 :The counter can increment and decrement.
//   In increment mode instead of counting3 to its full 16 bit
//   value the counter counts3 up to or down from a programmed3 interval3 value.
//   Interrupts3 are issued3 when the counter overflows3 or reaches3 it's interval3
//   value. In match mode if the count value equals3 that stored3 in one of three3
//   match registers an interrupt3 is issued3.
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
//


module ttc_counter_lite3(

  //inputs3
  n_p_reset3,    
  pclk3,          
  pwdata3,              
  count_en3,
  cntr_ctrl_reg_sel3, 
  interval_reg_sel3,
  match_1_reg_sel3,
  match_2_reg_sel3,
  match_3_reg_sel3,         

  //outputs3    
  count_val_out3,
  cntr_ctrl_reg_out3,
  interval_reg_out3,
  match_1_reg_out3,
  match_2_reg_out3,
  match_3_reg_out3,
  interval_intr3,
  match_intr3,
  overflow_intr3

);


//--------------------------------------------------------------------
// PORT DECLARATIONS3
//--------------------------------------------------------------------

   //inputs3
   input          n_p_reset3;         //reset signal3
   input          pclk3;              //System3 Clock3
   input [15:0]   pwdata3;            //6 Bit3 data signal3
   input          count_en3;          //Count3 enable signal3
   input          cntr_ctrl_reg_sel3; //Select3 bit for ctrl_reg3
   input          interval_reg_sel3;  //Interval3 Select3 Register
   input          match_1_reg_sel3;   //Match3 1 Select3 register
   input          match_2_reg_sel3;   //Match3 2 Select3 register
   input          match_3_reg_sel3;   //Match3 3 Select3 register

   //outputs3
   output [15:0]  count_val_out3;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out3;    //Counter3 control3 reg select3
   output [15:0]  interval_reg_out3;     //Interval3 reg
   output [15:0]  match_1_reg_out3;      //Match3 1 register
   output [15:0]  match_2_reg_out3;      //Match3 2 register
   output [15:0]  match_3_reg_out3;      //Match3 3 register
   output         interval_intr3;        //Interval3 interrupt3
   output [3:1]   match_intr3;           //Match3 interrupt3
   output         overflow_intr3;        //Overflow3 interrupt3

//--------------------------------------------------------------------
// Internal Signals3 & Registers3
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg3;     // 5-bit Counter3 Control3 Register
   reg [15:0]     interval_reg3;      //16-bit Interval3 Register 
   reg [15:0]     match_1_reg3;       //16-bit Match_13 Register
   reg [15:0]     match_2_reg3;       //16-bit Match_23 Register
   reg [15:0]     match_3_reg3;       //16-bit Match_33 Register
   reg [15:0]     count_val3;         //16-bit counter value register
                                                                      
   
   reg            counting3;          //counter has starting counting3
   reg            restart_temp3;   //ensures3 soft3 reset lasts3 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out3; //7-bit Counter3 Control3 Register
   wire [15:0]    interval_reg_out3;  //16-bit Interval3 Register 
   wire [15:0]    match_1_reg_out3;   //16-bit Match_13 Register
   wire [15:0]    match_2_reg_out3;   //16-bit Match_23 Register
   wire [15:0]    match_3_reg_out3;   //16-bit Match_33 Register
   wire [15:0]    count_val_out3;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign3 output wires3
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out3 = cntr_ctrl_reg3;    // 7-bit Counter3 Control3
   assign interval_reg_out3  = interval_reg3;     // 16-bit Interval3
   assign match_1_reg_out3   = match_1_reg3;      // 16-bit Match_13
   assign match_2_reg_out3   = match_2_reg3;      // 16-bit Match_23 
   assign match_3_reg_out3   = match_3_reg3;      // 16-bit Match_33 
   assign count_val_out3     = count_val3;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning3 interrupts3
//--------------------------------------------------------------------

   assign interval_intr3 =  cntr_ctrl_reg3[1] & (count_val3 == 16'h0000)
      & (counting3) & ~cntr_ctrl_reg3[4] & ~cntr_ctrl_reg3[0];
   assign overflow_intr3 = ~cntr_ctrl_reg3[1] & (count_val3 == 16'h0000)
      & (counting3) & ~cntr_ctrl_reg3[4] & ~cntr_ctrl_reg3[0];
   assign match_intr3[1]  =  cntr_ctrl_reg3[3] & (count_val3 == match_1_reg3)
      & (counting3) & ~cntr_ctrl_reg3[4] & ~cntr_ctrl_reg3[0];
   assign match_intr3[2]  =  cntr_ctrl_reg3[3] & (count_val3 == match_2_reg3)
      & (counting3) & ~cntr_ctrl_reg3[4] & ~cntr_ctrl_reg3[0];
   assign match_intr3[3]  =  cntr_ctrl_reg3[3] & (count_val3 == match_3_reg3)
      & (counting3) & ~cntr_ctrl_reg3[4] & ~cntr_ctrl_reg3[0];


//    p_reg_ctrl3: Process3 to write to the counter control3 registers
//    cntr_ctrl_reg3 decode:  0 - Counter3 Enable3 Active3 Low3
//                           1 - Interval3 Mode3 =1, Overflow3 =0
//                           2 - Decrement3 Mode3
//                           3 - Match3 Mode3
//                           4 - Restart3
//                           5 - Waveform3 enable active low3
//                           6 - Waveform3 polarity3
   
   always @ (posedge pclk3 or negedge n_p_reset3)
   begin: p_reg_ctrl3  // Register writes
      
      if (!n_p_reset3)                                   
      begin                                     
         cntr_ctrl_reg3 <= 7'b0000001;
         interval_reg3  <= 16'h0000;
         match_1_reg3   <= 16'h0000;
         match_2_reg3   <= 16'h0000;
         match_3_reg3   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel3)
            cntr_ctrl_reg3 <= pwdata3[6:0];
         else if (restart_temp3)
            cntr_ctrl_reg3[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg3 <= cntr_ctrl_reg3;             

         interval_reg3  <= (interval_reg_sel3) ? pwdata3 : interval_reg3;
         match_1_reg3   <= (match_1_reg_sel3)  ? pwdata3 : match_1_reg3;
         match_2_reg3   <= (match_2_reg_sel3)  ? pwdata3 : match_2_reg3;
         match_3_reg3   <= (match_3_reg_sel3)  ? pwdata3 : match_3_reg3;   
      end
      
   end  //p_reg_ctrl3

   
//    p_cntr3: Process3 to increment or decrement the counter on receiving3 a 
//            count_en3 signal3 from the pre_scaler3. Count3 can be restarted3
//            or disabled and can overflow3 at a specified interval3 value.
   
   
   always @ (posedge pclk3 or negedge n_p_reset3)
   begin: p_cntr3   // Counter3 block

      if (!n_p_reset3)     //System3 Reset3
      begin                     
         count_val3 <= 16'h0000;
         counting3  <= 1'b0;
         restart_temp3 <= 1'b0;
      end
      else if (count_en3)
      begin
         
         if (cntr_ctrl_reg3[4])     //Restart3
         begin     
            if (~cntr_ctrl_reg3[2])  
               count_val3         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg3[1])
                 count_val3         <= interval_reg3;     
              else
                 count_val3         <= 16'hFFFF;     
            end
            counting3       <= 1'b0;
            restart_temp3   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg3[0])          //Low3 Active3 Counter3 Enable3
            begin

               if (cntr_ctrl_reg3[1])  //Interval3               
                  if (cntr_ctrl_reg3[2])  //Decrement3        
                  begin
                     if (count_val3 == 16'h0000)
                        count_val3 <= interval_reg3;  //Assumed3 Static3
                     else
                        count_val3 <= count_val3 - 16'h0001;
                  end
                  else                   //Increment3
                  begin
                     if (count_val3 == interval_reg3)
                        count_val3 <= 16'h0000;
                     else           
                        count_val3 <= count_val3 + 16'h0001;
                  end
               else    
               begin  //Overflow3
                  if (cntr_ctrl_reg3[2])   //Decrement3
                  begin
                     if (count_val3 == 16'h0000)
                        count_val3 <= 16'hFFFF;
                     else           
                        count_val3 <= count_val3 - 16'h0001;
                  end
                  else                    //Increment3
                  begin
                     if (count_val3 == 16'hFFFF)
                        count_val3 <= 16'h0000;
                     else           
                        count_val3 <= count_val3 + 16'h0001;
                  end 
               end
               counting3  <= 1'b1;
            end     
            else
               count_val3 <= count_val3;   //Disabled3
   
            restart_temp3 <= 1'b0;
      
         end
     
      end // if (count_en3)

      else
      begin
         count_val3    <= count_val3;
         counting3     <= counting3;
         restart_temp3 <= restart_temp3;               
      end
     
   end  //p_cntr3

endmodule
