//File17 name   : ttc_counter_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 :The counter can increment and decrement.
//   In increment mode instead of counting17 to its full 16 bit
//   value the counter counts17 up to or down from a programmed17 interval17 value.
//   Interrupts17 are issued17 when the counter overflows17 or reaches17 it's interval17
//   value. In match mode if the count value equals17 that stored17 in one of three17
//   match registers an interrupt17 is issued17.
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
//


module ttc_counter_lite17(

  //inputs17
  n_p_reset17,    
  pclk17,          
  pwdata17,              
  count_en17,
  cntr_ctrl_reg_sel17, 
  interval_reg_sel17,
  match_1_reg_sel17,
  match_2_reg_sel17,
  match_3_reg_sel17,         

  //outputs17    
  count_val_out17,
  cntr_ctrl_reg_out17,
  interval_reg_out17,
  match_1_reg_out17,
  match_2_reg_out17,
  match_3_reg_out17,
  interval_intr17,
  match_intr17,
  overflow_intr17

);


//--------------------------------------------------------------------
// PORT DECLARATIONS17
//--------------------------------------------------------------------

   //inputs17
   input          n_p_reset17;         //reset signal17
   input          pclk17;              //System17 Clock17
   input [15:0]   pwdata17;            //6 Bit17 data signal17
   input          count_en17;          //Count17 enable signal17
   input          cntr_ctrl_reg_sel17; //Select17 bit for ctrl_reg17
   input          interval_reg_sel17;  //Interval17 Select17 Register
   input          match_1_reg_sel17;   //Match17 1 Select17 register
   input          match_2_reg_sel17;   //Match17 2 Select17 register
   input          match_3_reg_sel17;   //Match17 3 Select17 register

   //outputs17
   output [15:0]  count_val_out17;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out17;    //Counter17 control17 reg select17
   output [15:0]  interval_reg_out17;     //Interval17 reg
   output [15:0]  match_1_reg_out17;      //Match17 1 register
   output [15:0]  match_2_reg_out17;      //Match17 2 register
   output [15:0]  match_3_reg_out17;      //Match17 3 register
   output         interval_intr17;        //Interval17 interrupt17
   output [3:1]   match_intr17;           //Match17 interrupt17
   output         overflow_intr17;        //Overflow17 interrupt17

//--------------------------------------------------------------------
// Internal Signals17 & Registers17
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg17;     // 5-bit Counter17 Control17 Register
   reg [15:0]     interval_reg17;      //16-bit Interval17 Register 
   reg [15:0]     match_1_reg17;       //16-bit Match_117 Register
   reg [15:0]     match_2_reg17;       //16-bit Match_217 Register
   reg [15:0]     match_3_reg17;       //16-bit Match_317 Register
   reg [15:0]     count_val17;         //16-bit counter value register
                                                                      
   
   reg            counting17;          //counter has starting counting17
   reg            restart_temp17;   //ensures17 soft17 reset lasts17 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out17; //7-bit Counter17 Control17 Register
   wire [15:0]    interval_reg_out17;  //16-bit Interval17 Register 
   wire [15:0]    match_1_reg_out17;   //16-bit Match_117 Register
   wire [15:0]    match_2_reg_out17;   //16-bit Match_217 Register
   wire [15:0]    match_3_reg_out17;   //16-bit Match_317 Register
   wire [15:0]    count_val_out17;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign17 output wires17
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out17 = cntr_ctrl_reg17;    // 7-bit Counter17 Control17
   assign interval_reg_out17  = interval_reg17;     // 16-bit Interval17
   assign match_1_reg_out17   = match_1_reg17;      // 16-bit Match_117
   assign match_2_reg_out17   = match_2_reg17;      // 16-bit Match_217 
   assign match_3_reg_out17   = match_3_reg17;      // 16-bit Match_317 
   assign count_val_out17     = count_val17;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning17 interrupts17
//--------------------------------------------------------------------

   assign interval_intr17 =  cntr_ctrl_reg17[1] & (count_val17 == 16'h0000)
      & (counting17) & ~cntr_ctrl_reg17[4] & ~cntr_ctrl_reg17[0];
   assign overflow_intr17 = ~cntr_ctrl_reg17[1] & (count_val17 == 16'h0000)
      & (counting17) & ~cntr_ctrl_reg17[4] & ~cntr_ctrl_reg17[0];
   assign match_intr17[1]  =  cntr_ctrl_reg17[3] & (count_val17 == match_1_reg17)
      & (counting17) & ~cntr_ctrl_reg17[4] & ~cntr_ctrl_reg17[0];
   assign match_intr17[2]  =  cntr_ctrl_reg17[3] & (count_val17 == match_2_reg17)
      & (counting17) & ~cntr_ctrl_reg17[4] & ~cntr_ctrl_reg17[0];
   assign match_intr17[3]  =  cntr_ctrl_reg17[3] & (count_val17 == match_3_reg17)
      & (counting17) & ~cntr_ctrl_reg17[4] & ~cntr_ctrl_reg17[0];


//    p_reg_ctrl17: Process17 to write to the counter control17 registers
//    cntr_ctrl_reg17 decode:  0 - Counter17 Enable17 Active17 Low17
//                           1 - Interval17 Mode17 =1, Overflow17 =0
//                           2 - Decrement17 Mode17
//                           3 - Match17 Mode17
//                           4 - Restart17
//                           5 - Waveform17 enable active low17
//                           6 - Waveform17 polarity17
   
   always @ (posedge pclk17 or negedge n_p_reset17)
   begin: p_reg_ctrl17  // Register writes
      
      if (!n_p_reset17)                                   
      begin                                     
         cntr_ctrl_reg17 <= 7'b0000001;
         interval_reg17  <= 16'h0000;
         match_1_reg17   <= 16'h0000;
         match_2_reg17   <= 16'h0000;
         match_3_reg17   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel17)
            cntr_ctrl_reg17 <= pwdata17[6:0];
         else if (restart_temp17)
            cntr_ctrl_reg17[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg17 <= cntr_ctrl_reg17;             

         interval_reg17  <= (interval_reg_sel17) ? pwdata17 : interval_reg17;
         match_1_reg17   <= (match_1_reg_sel17)  ? pwdata17 : match_1_reg17;
         match_2_reg17   <= (match_2_reg_sel17)  ? pwdata17 : match_2_reg17;
         match_3_reg17   <= (match_3_reg_sel17)  ? pwdata17 : match_3_reg17;   
      end
      
   end  //p_reg_ctrl17

   
//    p_cntr17: Process17 to increment or decrement the counter on receiving17 a 
//            count_en17 signal17 from the pre_scaler17. Count17 can be restarted17
//            or disabled and can overflow17 at a specified interval17 value.
   
   
   always @ (posedge pclk17 or negedge n_p_reset17)
   begin: p_cntr17   // Counter17 block

      if (!n_p_reset17)     //System17 Reset17
      begin                     
         count_val17 <= 16'h0000;
         counting17  <= 1'b0;
         restart_temp17 <= 1'b0;
      end
      else if (count_en17)
      begin
         
         if (cntr_ctrl_reg17[4])     //Restart17
         begin     
            if (~cntr_ctrl_reg17[2])  
               count_val17         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg17[1])
                 count_val17         <= interval_reg17;     
              else
                 count_val17         <= 16'hFFFF;     
            end
            counting17       <= 1'b0;
            restart_temp17   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg17[0])          //Low17 Active17 Counter17 Enable17
            begin

               if (cntr_ctrl_reg17[1])  //Interval17               
                  if (cntr_ctrl_reg17[2])  //Decrement17        
                  begin
                     if (count_val17 == 16'h0000)
                        count_val17 <= interval_reg17;  //Assumed17 Static17
                     else
                        count_val17 <= count_val17 - 16'h0001;
                  end
                  else                   //Increment17
                  begin
                     if (count_val17 == interval_reg17)
                        count_val17 <= 16'h0000;
                     else           
                        count_val17 <= count_val17 + 16'h0001;
                  end
               else    
               begin  //Overflow17
                  if (cntr_ctrl_reg17[2])   //Decrement17
                  begin
                     if (count_val17 == 16'h0000)
                        count_val17 <= 16'hFFFF;
                     else           
                        count_val17 <= count_val17 - 16'h0001;
                  end
                  else                    //Increment17
                  begin
                     if (count_val17 == 16'hFFFF)
                        count_val17 <= 16'h0000;
                     else           
                        count_val17 <= count_val17 + 16'h0001;
                  end 
               end
               counting17  <= 1'b1;
            end     
            else
               count_val17 <= count_val17;   //Disabled17
   
            restart_temp17 <= 1'b0;
      
         end
     
      end // if (count_en17)

      else
      begin
         count_val17    <= count_val17;
         counting17     <= counting17;
         restart_temp17 <= restart_temp17;               
      end
     
   end  //p_cntr17

endmodule
