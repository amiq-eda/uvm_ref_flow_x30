//File12 name   : ttc_counter_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 :The counter can increment and decrement.
//   In increment mode instead of counting12 to its full 16 bit
//   value the counter counts12 up to or down from a programmed12 interval12 value.
//   Interrupts12 are issued12 when the counter overflows12 or reaches12 it's interval12
//   value. In match mode if the count value equals12 that stored12 in one of three12
//   match registers an interrupt12 is issued12.
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------
//


module ttc_counter_lite12(

  //inputs12
  n_p_reset12,    
  pclk12,          
  pwdata12,              
  count_en12,
  cntr_ctrl_reg_sel12, 
  interval_reg_sel12,
  match_1_reg_sel12,
  match_2_reg_sel12,
  match_3_reg_sel12,         

  //outputs12    
  count_val_out12,
  cntr_ctrl_reg_out12,
  interval_reg_out12,
  match_1_reg_out12,
  match_2_reg_out12,
  match_3_reg_out12,
  interval_intr12,
  match_intr12,
  overflow_intr12

);


//--------------------------------------------------------------------
// PORT DECLARATIONS12
//--------------------------------------------------------------------

   //inputs12
   input          n_p_reset12;         //reset signal12
   input          pclk12;              //System12 Clock12
   input [15:0]   pwdata12;            //6 Bit12 data signal12
   input          count_en12;          //Count12 enable signal12
   input          cntr_ctrl_reg_sel12; //Select12 bit for ctrl_reg12
   input          interval_reg_sel12;  //Interval12 Select12 Register
   input          match_1_reg_sel12;   //Match12 1 Select12 register
   input          match_2_reg_sel12;   //Match12 2 Select12 register
   input          match_3_reg_sel12;   //Match12 3 Select12 register

   //outputs12
   output [15:0]  count_val_out12;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out12;    //Counter12 control12 reg select12
   output [15:0]  interval_reg_out12;     //Interval12 reg
   output [15:0]  match_1_reg_out12;      //Match12 1 register
   output [15:0]  match_2_reg_out12;      //Match12 2 register
   output [15:0]  match_3_reg_out12;      //Match12 3 register
   output         interval_intr12;        //Interval12 interrupt12
   output [3:1]   match_intr12;           //Match12 interrupt12
   output         overflow_intr12;        //Overflow12 interrupt12

//--------------------------------------------------------------------
// Internal Signals12 & Registers12
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg12;     // 5-bit Counter12 Control12 Register
   reg [15:0]     interval_reg12;      //16-bit Interval12 Register 
   reg [15:0]     match_1_reg12;       //16-bit Match_112 Register
   reg [15:0]     match_2_reg12;       //16-bit Match_212 Register
   reg [15:0]     match_3_reg12;       //16-bit Match_312 Register
   reg [15:0]     count_val12;         //16-bit counter value register
                                                                      
   
   reg            counting12;          //counter has starting counting12
   reg            restart_temp12;   //ensures12 soft12 reset lasts12 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out12; //7-bit Counter12 Control12 Register
   wire [15:0]    interval_reg_out12;  //16-bit Interval12 Register 
   wire [15:0]    match_1_reg_out12;   //16-bit Match_112 Register
   wire [15:0]    match_2_reg_out12;   //16-bit Match_212 Register
   wire [15:0]    match_3_reg_out12;   //16-bit Match_312 Register
   wire [15:0]    count_val_out12;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign12 output wires12
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out12 = cntr_ctrl_reg12;    // 7-bit Counter12 Control12
   assign interval_reg_out12  = interval_reg12;     // 16-bit Interval12
   assign match_1_reg_out12   = match_1_reg12;      // 16-bit Match_112
   assign match_2_reg_out12   = match_2_reg12;      // 16-bit Match_212 
   assign match_3_reg_out12   = match_3_reg12;      // 16-bit Match_312 
   assign count_val_out12     = count_val12;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning12 interrupts12
//--------------------------------------------------------------------

   assign interval_intr12 =  cntr_ctrl_reg12[1] & (count_val12 == 16'h0000)
      & (counting12) & ~cntr_ctrl_reg12[4] & ~cntr_ctrl_reg12[0];
   assign overflow_intr12 = ~cntr_ctrl_reg12[1] & (count_val12 == 16'h0000)
      & (counting12) & ~cntr_ctrl_reg12[4] & ~cntr_ctrl_reg12[0];
   assign match_intr12[1]  =  cntr_ctrl_reg12[3] & (count_val12 == match_1_reg12)
      & (counting12) & ~cntr_ctrl_reg12[4] & ~cntr_ctrl_reg12[0];
   assign match_intr12[2]  =  cntr_ctrl_reg12[3] & (count_val12 == match_2_reg12)
      & (counting12) & ~cntr_ctrl_reg12[4] & ~cntr_ctrl_reg12[0];
   assign match_intr12[3]  =  cntr_ctrl_reg12[3] & (count_val12 == match_3_reg12)
      & (counting12) & ~cntr_ctrl_reg12[4] & ~cntr_ctrl_reg12[0];


//    p_reg_ctrl12: Process12 to write to the counter control12 registers
//    cntr_ctrl_reg12 decode:  0 - Counter12 Enable12 Active12 Low12
//                           1 - Interval12 Mode12 =1, Overflow12 =0
//                           2 - Decrement12 Mode12
//                           3 - Match12 Mode12
//                           4 - Restart12
//                           5 - Waveform12 enable active low12
//                           6 - Waveform12 polarity12
   
   always @ (posedge pclk12 or negedge n_p_reset12)
   begin: p_reg_ctrl12  // Register writes
      
      if (!n_p_reset12)                                   
      begin                                     
         cntr_ctrl_reg12 <= 7'b0000001;
         interval_reg12  <= 16'h0000;
         match_1_reg12   <= 16'h0000;
         match_2_reg12   <= 16'h0000;
         match_3_reg12   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel12)
            cntr_ctrl_reg12 <= pwdata12[6:0];
         else if (restart_temp12)
            cntr_ctrl_reg12[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg12 <= cntr_ctrl_reg12;             

         interval_reg12  <= (interval_reg_sel12) ? pwdata12 : interval_reg12;
         match_1_reg12   <= (match_1_reg_sel12)  ? pwdata12 : match_1_reg12;
         match_2_reg12   <= (match_2_reg_sel12)  ? pwdata12 : match_2_reg12;
         match_3_reg12   <= (match_3_reg_sel12)  ? pwdata12 : match_3_reg12;   
      end
      
   end  //p_reg_ctrl12

   
//    p_cntr12: Process12 to increment or decrement the counter on receiving12 a 
//            count_en12 signal12 from the pre_scaler12. Count12 can be restarted12
//            or disabled and can overflow12 at a specified interval12 value.
   
   
   always @ (posedge pclk12 or negedge n_p_reset12)
   begin: p_cntr12   // Counter12 block

      if (!n_p_reset12)     //System12 Reset12
      begin                     
         count_val12 <= 16'h0000;
         counting12  <= 1'b0;
         restart_temp12 <= 1'b0;
      end
      else if (count_en12)
      begin
         
         if (cntr_ctrl_reg12[4])     //Restart12
         begin     
            if (~cntr_ctrl_reg12[2])  
               count_val12         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg12[1])
                 count_val12         <= interval_reg12;     
              else
                 count_val12         <= 16'hFFFF;     
            end
            counting12       <= 1'b0;
            restart_temp12   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg12[0])          //Low12 Active12 Counter12 Enable12
            begin

               if (cntr_ctrl_reg12[1])  //Interval12               
                  if (cntr_ctrl_reg12[2])  //Decrement12        
                  begin
                     if (count_val12 == 16'h0000)
                        count_val12 <= interval_reg12;  //Assumed12 Static12
                     else
                        count_val12 <= count_val12 - 16'h0001;
                  end
                  else                   //Increment12
                  begin
                     if (count_val12 == interval_reg12)
                        count_val12 <= 16'h0000;
                     else           
                        count_val12 <= count_val12 + 16'h0001;
                  end
               else    
               begin  //Overflow12
                  if (cntr_ctrl_reg12[2])   //Decrement12
                  begin
                     if (count_val12 == 16'h0000)
                        count_val12 <= 16'hFFFF;
                     else           
                        count_val12 <= count_val12 - 16'h0001;
                  end
                  else                    //Increment12
                  begin
                     if (count_val12 == 16'hFFFF)
                        count_val12 <= 16'h0000;
                     else           
                        count_val12 <= count_val12 + 16'h0001;
                  end 
               end
               counting12  <= 1'b1;
            end     
            else
               count_val12 <= count_val12;   //Disabled12
   
            restart_temp12 <= 1'b0;
      
         end
     
      end // if (count_en12)

      else
      begin
         count_val12    <= count_val12;
         counting12     <= counting12;
         restart_temp12 <= restart_temp12;               
      end
     
   end  //p_cntr12

endmodule
