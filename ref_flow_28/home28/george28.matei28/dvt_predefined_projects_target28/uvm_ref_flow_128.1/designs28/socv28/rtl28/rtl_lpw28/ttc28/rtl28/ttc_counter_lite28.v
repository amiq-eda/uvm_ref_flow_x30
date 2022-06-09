//File28 name   : ttc_counter_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 :The counter can increment and decrement.
//   In increment mode instead of counting28 to its full 16 bit
//   value the counter counts28 up to or down from a programmed28 interval28 value.
//   Interrupts28 are issued28 when the counter overflows28 or reaches28 it's interval28
//   value. In match mode if the count value equals28 that stored28 in one of three28
//   match registers an interrupt28 is issued28.
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
//


module ttc_counter_lite28(

  //inputs28
  n_p_reset28,    
  pclk28,          
  pwdata28,              
  count_en28,
  cntr_ctrl_reg_sel28, 
  interval_reg_sel28,
  match_1_reg_sel28,
  match_2_reg_sel28,
  match_3_reg_sel28,         

  //outputs28    
  count_val_out28,
  cntr_ctrl_reg_out28,
  interval_reg_out28,
  match_1_reg_out28,
  match_2_reg_out28,
  match_3_reg_out28,
  interval_intr28,
  match_intr28,
  overflow_intr28

);


//--------------------------------------------------------------------
// PORT DECLARATIONS28
//--------------------------------------------------------------------

   //inputs28
   input          n_p_reset28;         //reset signal28
   input          pclk28;              //System28 Clock28
   input [15:0]   pwdata28;            //6 Bit28 data signal28
   input          count_en28;          //Count28 enable signal28
   input          cntr_ctrl_reg_sel28; //Select28 bit for ctrl_reg28
   input          interval_reg_sel28;  //Interval28 Select28 Register
   input          match_1_reg_sel28;   //Match28 1 Select28 register
   input          match_2_reg_sel28;   //Match28 2 Select28 register
   input          match_3_reg_sel28;   //Match28 3 Select28 register

   //outputs28
   output [15:0]  count_val_out28;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out28;    //Counter28 control28 reg select28
   output [15:0]  interval_reg_out28;     //Interval28 reg
   output [15:0]  match_1_reg_out28;      //Match28 1 register
   output [15:0]  match_2_reg_out28;      //Match28 2 register
   output [15:0]  match_3_reg_out28;      //Match28 3 register
   output         interval_intr28;        //Interval28 interrupt28
   output [3:1]   match_intr28;           //Match28 interrupt28
   output         overflow_intr28;        //Overflow28 interrupt28

//--------------------------------------------------------------------
// Internal Signals28 & Registers28
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg28;     // 5-bit Counter28 Control28 Register
   reg [15:0]     interval_reg28;      //16-bit Interval28 Register 
   reg [15:0]     match_1_reg28;       //16-bit Match_128 Register
   reg [15:0]     match_2_reg28;       //16-bit Match_228 Register
   reg [15:0]     match_3_reg28;       //16-bit Match_328 Register
   reg [15:0]     count_val28;         //16-bit counter value register
                                                                      
   
   reg            counting28;          //counter has starting counting28
   reg            restart_temp28;   //ensures28 soft28 reset lasts28 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out28; //7-bit Counter28 Control28 Register
   wire [15:0]    interval_reg_out28;  //16-bit Interval28 Register 
   wire [15:0]    match_1_reg_out28;   //16-bit Match_128 Register
   wire [15:0]    match_2_reg_out28;   //16-bit Match_228 Register
   wire [15:0]    match_3_reg_out28;   //16-bit Match_328 Register
   wire [15:0]    count_val_out28;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign28 output wires28
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out28 = cntr_ctrl_reg28;    // 7-bit Counter28 Control28
   assign interval_reg_out28  = interval_reg28;     // 16-bit Interval28
   assign match_1_reg_out28   = match_1_reg28;      // 16-bit Match_128
   assign match_2_reg_out28   = match_2_reg28;      // 16-bit Match_228 
   assign match_3_reg_out28   = match_3_reg28;      // 16-bit Match_328 
   assign count_val_out28     = count_val28;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning28 interrupts28
//--------------------------------------------------------------------

   assign interval_intr28 =  cntr_ctrl_reg28[1] & (count_val28 == 16'h0000)
      & (counting28) & ~cntr_ctrl_reg28[4] & ~cntr_ctrl_reg28[0];
   assign overflow_intr28 = ~cntr_ctrl_reg28[1] & (count_val28 == 16'h0000)
      & (counting28) & ~cntr_ctrl_reg28[4] & ~cntr_ctrl_reg28[0];
   assign match_intr28[1]  =  cntr_ctrl_reg28[3] & (count_val28 == match_1_reg28)
      & (counting28) & ~cntr_ctrl_reg28[4] & ~cntr_ctrl_reg28[0];
   assign match_intr28[2]  =  cntr_ctrl_reg28[3] & (count_val28 == match_2_reg28)
      & (counting28) & ~cntr_ctrl_reg28[4] & ~cntr_ctrl_reg28[0];
   assign match_intr28[3]  =  cntr_ctrl_reg28[3] & (count_val28 == match_3_reg28)
      & (counting28) & ~cntr_ctrl_reg28[4] & ~cntr_ctrl_reg28[0];


//    p_reg_ctrl28: Process28 to write to the counter control28 registers
//    cntr_ctrl_reg28 decode:  0 - Counter28 Enable28 Active28 Low28
//                           1 - Interval28 Mode28 =1, Overflow28 =0
//                           2 - Decrement28 Mode28
//                           3 - Match28 Mode28
//                           4 - Restart28
//                           5 - Waveform28 enable active low28
//                           6 - Waveform28 polarity28
   
   always @ (posedge pclk28 or negedge n_p_reset28)
   begin: p_reg_ctrl28  // Register writes
      
      if (!n_p_reset28)                                   
      begin                                     
         cntr_ctrl_reg28 <= 7'b0000001;
         interval_reg28  <= 16'h0000;
         match_1_reg28   <= 16'h0000;
         match_2_reg28   <= 16'h0000;
         match_3_reg28   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel28)
            cntr_ctrl_reg28 <= pwdata28[6:0];
         else if (restart_temp28)
            cntr_ctrl_reg28[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg28 <= cntr_ctrl_reg28;             

         interval_reg28  <= (interval_reg_sel28) ? pwdata28 : interval_reg28;
         match_1_reg28   <= (match_1_reg_sel28)  ? pwdata28 : match_1_reg28;
         match_2_reg28   <= (match_2_reg_sel28)  ? pwdata28 : match_2_reg28;
         match_3_reg28   <= (match_3_reg_sel28)  ? pwdata28 : match_3_reg28;   
      end
      
   end  //p_reg_ctrl28

   
//    p_cntr28: Process28 to increment or decrement the counter on receiving28 a 
//            count_en28 signal28 from the pre_scaler28. Count28 can be restarted28
//            or disabled and can overflow28 at a specified interval28 value.
   
   
   always @ (posedge pclk28 or negedge n_p_reset28)
   begin: p_cntr28   // Counter28 block

      if (!n_p_reset28)     //System28 Reset28
      begin                     
         count_val28 <= 16'h0000;
         counting28  <= 1'b0;
         restart_temp28 <= 1'b0;
      end
      else if (count_en28)
      begin
         
         if (cntr_ctrl_reg28[4])     //Restart28
         begin     
            if (~cntr_ctrl_reg28[2])  
               count_val28         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg28[1])
                 count_val28         <= interval_reg28;     
              else
                 count_val28         <= 16'hFFFF;     
            end
            counting28       <= 1'b0;
            restart_temp28   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg28[0])          //Low28 Active28 Counter28 Enable28
            begin

               if (cntr_ctrl_reg28[1])  //Interval28               
                  if (cntr_ctrl_reg28[2])  //Decrement28        
                  begin
                     if (count_val28 == 16'h0000)
                        count_val28 <= interval_reg28;  //Assumed28 Static28
                     else
                        count_val28 <= count_val28 - 16'h0001;
                  end
                  else                   //Increment28
                  begin
                     if (count_val28 == interval_reg28)
                        count_val28 <= 16'h0000;
                     else           
                        count_val28 <= count_val28 + 16'h0001;
                  end
               else    
               begin  //Overflow28
                  if (cntr_ctrl_reg28[2])   //Decrement28
                  begin
                     if (count_val28 == 16'h0000)
                        count_val28 <= 16'hFFFF;
                     else           
                        count_val28 <= count_val28 - 16'h0001;
                  end
                  else                    //Increment28
                  begin
                     if (count_val28 == 16'hFFFF)
                        count_val28 <= 16'h0000;
                     else           
                        count_val28 <= count_val28 + 16'h0001;
                  end 
               end
               counting28  <= 1'b1;
            end     
            else
               count_val28 <= count_val28;   //Disabled28
   
            restart_temp28 <= 1'b0;
      
         end
     
      end // if (count_en28)

      else
      begin
         count_val28    <= count_val28;
         counting28     <= counting28;
         restart_temp28 <= restart_temp28;               
      end
     
   end  //p_cntr28

endmodule
