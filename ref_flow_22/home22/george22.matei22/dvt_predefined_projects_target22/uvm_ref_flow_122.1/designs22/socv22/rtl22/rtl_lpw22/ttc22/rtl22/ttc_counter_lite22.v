//File22 name   : ttc_counter_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 :The counter can increment and decrement.
//   In increment mode instead of counting22 to its full 16 bit
//   value the counter counts22 up to or down from a programmed22 interval22 value.
//   Interrupts22 are issued22 when the counter overflows22 or reaches22 it's interval22
//   value. In match mode if the count value equals22 that stored22 in one of three22
//   match registers an interrupt22 is issued22.
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
//


module ttc_counter_lite22(

  //inputs22
  n_p_reset22,    
  pclk22,          
  pwdata22,              
  count_en22,
  cntr_ctrl_reg_sel22, 
  interval_reg_sel22,
  match_1_reg_sel22,
  match_2_reg_sel22,
  match_3_reg_sel22,         

  //outputs22    
  count_val_out22,
  cntr_ctrl_reg_out22,
  interval_reg_out22,
  match_1_reg_out22,
  match_2_reg_out22,
  match_3_reg_out22,
  interval_intr22,
  match_intr22,
  overflow_intr22

);


//--------------------------------------------------------------------
// PORT DECLARATIONS22
//--------------------------------------------------------------------

   //inputs22
   input          n_p_reset22;         //reset signal22
   input          pclk22;              //System22 Clock22
   input [15:0]   pwdata22;            //6 Bit22 data signal22
   input          count_en22;          //Count22 enable signal22
   input          cntr_ctrl_reg_sel22; //Select22 bit for ctrl_reg22
   input          interval_reg_sel22;  //Interval22 Select22 Register
   input          match_1_reg_sel22;   //Match22 1 Select22 register
   input          match_2_reg_sel22;   //Match22 2 Select22 register
   input          match_3_reg_sel22;   //Match22 3 Select22 register

   //outputs22
   output [15:0]  count_val_out22;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out22;    //Counter22 control22 reg select22
   output [15:0]  interval_reg_out22;     //Interval22 reg
   output [15:0]  match_1_reg_out22;      //Match22 1 register
   output [15:0]  match_2_reg_out22;      //Match22 2 register
   output [15:0]  match_3_reg_out22;      //Match22 3 register
   output         interval_intr22;        //Interval22 interrupt22
   output [3:1]   match_intr22;           //Match22 interrupt22
   output         overflow_intr22;        //Overflow22 interrupt22

//--------------------------------------------------------------------
// Internal Signals22 & Registers22
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg22;     // 5-bit Counter22 Control22 Register
   reg [15:0]     interval_reg22;      //16-bit Interval22 Register 
   reg [15:0]     match_1_reg22;       //16-bit Match_122 Register
   reg [15:0]     match_2_reg22;       //16-bit Match_222 Register
   reg [15:0]     match_3_reg22;       //16-bit Match_322 Register
   reg [15:0]     count_val22;         //16-bit counter value register
                                                                      
   
   reg            counting22;          //counter has starting counting22
   reg            restart_temp22;   //ensures22 soft22 reset lasts22 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out22; //7-bit Counter22 Control22 Register
   wire [15:0]    interval_reg_out22;  //16-bit Interval22 Register 
   wire [15:0]    match_1_reg_out22;   //16-bit Match_122 Register
   wire [15:0]    match_2_reg_out22;   //16-bit Match_222 Register
   wire [15:0]    match_3_reg_out22;   //16-bit Match_322 Register
   wire [15:0]    count_val_out22;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign22 output wires22
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out22 = cntr_ctrl_reg22;    // 7-bit Counter22 Control22
   assign interval_reg_out22  = interval_reg22;     // 16-bit Interval22
   assign match_1_reg_out22   = match_1_reg22;      // 16-bit Match_122
   assign match_2_reg_out22   = match_2_reg22;      // 16-bit Match_222 
   assign match_3_reg_out22   = match_3_reg22;      // 16-bit Match_322 
   assign count_val_out22     = count_val22;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning22 interrupts22
//--------------------------------------------------------------------

   assign interval_intr22 =  cntr_ctrl_reg22[1] & (count_val22 == 16'h0000)
      & (counting22) & ~cntr_ctrl_reg22[4] & ~cntr_ctrl_reg22[0];
   assign overflow_intr22 = ~cntr_ctrl_reg22[1] & (count_val22 == 16'h0000)
      & (counting22) & ~cntr_ctrl_reg22[4] & ~cntr_ctrl_reg22[0];
   assign match_intr22[1]  =  cntr_ctrl_reg22[3] & (count_val22 == match_1_reg22)
      & (counting22) & ~cntr_ctrl_reg22[4] & ~cntr_ctrl_reg22[0];
   assign match_intr22[2]  =  cntr_ctrl_reg22[3] & (count_val22 == match_2_reg22)
      & (counting22) & ~cntr_ctrl_reg22[4] & ~cntr_ctrl_reg22[0];
   assign match_intr22[3]  =  cntr_ctrl_reg22[3] & (count_val22 == match_3_reg22)
      & (counting22) & ~cntr_ctrl_reg22[4] & ~cntr_ctrl_reg22[0];


//    p_reg_ctrl22: Process22 to write to the counter control22 registers
//    cntr_ctrl_reg22 decode:  0 - Counter22 Enable22 Active22 Low22
//                           1 - Interval22 Mode22 =1, Overflow22 =0
//                           2 - Decrement22 Mode22
//                           3 - Match22 Mode22
//                           4 - Restart22
//                           5 - Waveform22 enable active low22
//                           6 - Waveform22 polarity22
   
   always @ (posedge pclk22 or negedge n_p_reset22)
   begin: p_reg_ctrl22  // Register writes
      
      if (!n_p_reset22)                                   
      begin                                     
         cntr_ctrl_reg22 <= 7'b0000001;
         interval_reg22  <= 16'h0000;
         match_1_reg22   <= 16'h0000;
         match_2_reg22   <= 16'h0000;
         match_3_reg22   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel22)
            cntr_ctrl_reg22 <= pwdata22[6:0];
         else if (restart_temp22)
            cntr_ctrl_reg22[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg22 <= cntr_ctrl_reg22;             

         interval_reg22  <= (interval_reg_sel22) ? pwdata22 : interval_reg22;
         match_1_reg22   <= (match_1_reg_sel22)  ? pwdata22 : match_1_reg22;
         match_2_reg22   <= (match_2_reg_sel22)  ? pwdata22 : match_2_reg22;
         match_3_reg22   <= (match_3_reg_sel22)  ? pwdata22 : match_3_reg22;   
      end
      
   end  //p_reg_ctrl22

   
//    p_cntr22: Process22 to increment or decrement the counter on receiving22 a 
//            count_en22 signal22 from the pre_scaler22. Count22 can be restarted22
//            or disabled and can overflow22 at a specified interval22 value.
   
   
   always @ (posedge pclk22 or negedge n_p_reset22)
   begin: p_cntr22   // Counter22 block

      if (!n_p_reset22)     //System22 Reset22
      begin                     
         count_val22 <= 16'h0000;
         counting22  <= 1'b0;
         restart_temp22 <= 1'b0;
      end
      else if (count_en22)
      begin
         
         if (cntr_ctrl_reg22[4])     //Restart22
         begin     
            if (~cntr_ctrl_reg22[2])  
               count_val22         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg22[1])
                 count_val22         <= interval_reg22;     
              else
                 count_val22         <= 16'hFFFF;     
            end
            counting22       <= 1'b0;
            restart_temp22   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg22[0])          //Low22 Active22 Counter22 Enable22
            begin

               if (cntr_ctrl_reg22[1])  //Interval22               
                  if (cntr_ctrl_reg22[2])  //Decrement22        
                  begin
                     if (count_val22 == 16'h0000)
                        count_val22 <= interval_reg22;  //Assumed22 Static22
                     else
                        count_val22 <= count_val22 - 16'h0001;
                  end
                  else                   //Increment22
                  begin
                     if (count_val22 == interval_reg22)
                        count_val22 <= 16'h0000;
                     else           
                        count_val22 <= count_val22 + 16'h0001;
                  end
               else    
               begin  //Overflow22
                  if (cntr_ctrl_reg22[2])   //Decrement22
                  begin
                     if (count_val22 == 16'h0000)
                        count_val22 <= 16'hFFFF;
                     else           
                        count_val22 <= count_val22 - 16'h0001;
                  end
                  else                    //Increment22
                  begin
                     if (count_val22 == 16'hFFFF)
                        count_val22 <= 16'h0000;
                     else           
                        count_val22 <= count_val22 + 16'h0001;
                  end 
               end
               counting22  <= 1'b1;
            end     
            else
               count_val22 <= count_val22;   //Disabled22
   
            restart_temp22 <= 1'b0;
      
         end
     
      end // if (count_en22)

      else
      begin
         count_val22    <= count_val22;
         counting22     <= counting22;
         restart_temp22 <= restart_temp22;               
      end
     
   end  //p_cntr22

endmodule
