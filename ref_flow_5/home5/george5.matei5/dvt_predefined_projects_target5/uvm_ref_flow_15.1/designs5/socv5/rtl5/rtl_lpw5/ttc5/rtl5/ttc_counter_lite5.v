//File5 name   : ttc_counter_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 :The counter can increment and decrement.
//   In increment mode instead of counting5 to its full 16 bit
//   value the counter counts5 up to or down from a programmed5 interval5 value.
//   Interrupts5 are issued5 when the counter overflows5 or reaches5 it's interval5
//   value. In match mode if the count value equals5 that stored5 in one of three5
//   match registers an interrupt5 is issued5.
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------
//


module ttc_counter_lite5(

  //inputs5
  n_p_reset5,    
  pclk5,          
  pwdata5,              
  count_en5,
  cntr_ctrl_reg_sel5, 
  interval_reg_sel5,
  match_1_reg_sel5,
  match_2_reg_sel5,
  match_3_reg_sel5,         

  //outputs5    
  count_val_out5,
  cntr_ctrl_reg_out5,
  interval_reg_out5,
  match_1_reg_out5,
  match_2_reg_out5,
  match_3_reg_out5,
  interval_intr5,
  match_intr5,
  overflow_intr5

);


//--------------------------------------------------------------------
// PORT DECLARATIONS5
//--------------------------------------------------------------------

   //inputs5
   input          n_p_reset5;         //reset signal5
   input          pclk5;              //System5 Clock5
   input [15:0]   pwdata5;            //6 Bit5 data signal5
   input          count_en5;          //Count5 enable signal5
   input          cntr_ctrl_reg_sel5; //Select5 bit for ctrl_reg5
   input          interval_reg_sel5;  //Interval5 Select5 Register
   input          match_1_reg_sel5;   //Match5 1 Select5 register
   input          match_2_reg_sel5;   //Match5 2 Select5 register
   input          match_3_reg_sel5;   //Match5 3 Select5 register

   //outputs5
   output [15:0]  count_val_out5;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out5;    //Counter5 control5 reg select5
   output [15:0]  interval_reg_out5;     //Interval5 reg
   output [15:0]  match_1_reg_out5;      //Match5 1 register
   output [15:0]  match_2_reg_out5;      //Match5 2 register
   output [15:0]  match_3_reg_out5;      //Match5 3 register
   output         interval_intr5;        //Interval5 interrupt5
   output [3:1]   match_intr5;           //Match5 interrupt5
   output         overflow_intr5;        //Overflow5 interrupt5

//--------------------------------------------------------------------
// Internal Signals5 & Registers5
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg5;     // 5-bit Counter5 Control5 Register
   reg [15:0]     interval_reg5;      //16-bit Interval5 Register 
   reg [15:0]     match_1_reg5;       //16-bit Match_15 Register
   reg [15:0]     match_2_reg5;       //16-bit Match_25 Register
   reg [15:0]     match_3_reg5;       //16-bit Match_35 Register
   reg [15:0]     count_val5;         //16-bit counter value register
                                                                      
   
   reg            counting5;          //counter has starting counting5
   reg            restart_temp5;   //ensures5 soft5 reset lasts5 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out5; //7-bit Counter5 Control5 Register
   wire [15:0]    interval_reg_out5;  //16-bit Interval5 Register 
   wire [15:0]    match_1_reg_out5;   //16-bit Match_15 Register
   wire [15:0]    match_2_reg_out5;   //16-bit Match_25 Register
   wire [15:0]    match_3_reg_out5;   //16-bit Match_35 Register
   wire [15:0]    count_val_out5;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign5 output wires5
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out5 = cntr_ctrl_reg5;    // 7-bit Counter5 Control5
   assign interval_reg_out5  = interval_reg5;     // 16-bit Interval5
   assign match_1_reg_out5   = match_1_reg5;      // 16-bit Match_15
   assign match_2_reg_out5   = match_2_reg5;      // 16-bit Match_25 
   assign match_3_reg_out5   = match_3_reg5;      // 16-bit Match_35 
   assign count_val_out5     = count_val5;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning5 interrupts5
//--------------------------------------------------------------------

   assign interval_intr5 =  cntr_ctrl_reg5[1] & (count_val5 == 16'h0000)
      & (counting5) & ~cntr_ctrl_reg5[4] & ~cntr_ctrl_reg5[0];
   assign overflow_intr5 = ~cntr_ctrl_reg5[1] & (count_val5 == 16'h0000)
      & (counting5) & ~cntr_ctrl_reg5[4] & ~cntr_ctrl_reg5[0];
   assign match_intr5[1]  =  cntr_ctrl_reg5[3] & (count_val5 == match_1_reg5)
      & (counting5) & ~cntr_ctrl_reg5[4] & ~cntr_ctrl_reg5[0];
   assign match_intr5[2]  =  cntr_ctrl_reg5[3] & (count_val5 == match_2_reg5)
      & (counting5) & ~cntr_ctrl_reg5[4] & ~cntr_ctrl_reg5[0];
   assign match_intr5[3]  =  cntr_ctrl_reg5[3] & (count_val5 == match_3_reg5)
      & (counting5) & ~cntr_ctrl_reg5[4] & ~cntr_ctrl_reg5[0];


//    p_reg_ctrl5: Process5 to write to the counter control5 registers
//    cntr_ctrl_reg5 decode:  0 - Counter5 Enable5 Active5 Low5
//                           1 - Interval5 Mode5 =1, Overflow5 =0
//                           2 - Decrement5 Mode5
//                           3 - Match5 Mode5
//                           4 - Restart5
//                           5 - Waveform5 enable active low5
//                           6 - Waveform5 polarity5
   
   always @ (posedge pclk5 or negedge n_p_reset5)
   begin: p_reg_ctrl5  // Register writes
      
      if (!n_p_reset5)                                   
      begin                                     
         cntr_ctrl_reg5 <= 7'b0000001;
         interval_reg5  <= 16'h0000;
         match_1_reg5   <= 16'h0000;
         match_2_reg5   <= 16'h0000;
         match_3_reg5   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel5)
            cntr_ctrl_reg5 <= pwdata5[6:0];
         else if (restart_temp5)
            cntr_ctrl_reg5[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg5 <= cntr_ctrl_reg5;             

         interval_reg5  <= (interval_reg_sel5) ? pwdata5 : interval_reg5;
         match_1_reg5   <= (match_1_reg_sel5)  ? pwdata5 : match_1_reg5;
         match_2_reg5   <= (match_2_reg_sel5)  ? pwdata5 : match_2_reg5;
         match_3_reg5   <= (match_3_reg_sel5)  ? pwdata5 : match_3_reg5;   
      end
      
   end  //p_reg_ctrl5

   
//    p_cntr5: Process5 to increment or decrement the counter on receiving5 a 
//            count_en5 signal5 from the pre_scaler5. Count5 can be restarted5
//            or disabled and can overflow5 at a specified interval5 value.
   
   
   always @ (posedge pclk5 or negedge n_p_reset5)
   begin: p_cntr5   // Counter5 block

      if (!n_p_reset5)     //System5 Reset5
      begin                     
         count_val5 <= 16'h0000;
         counting5  <= 1'b0;
         restart_temp5 <= 1'b0;
      end
      else if (count_en5)
      begin
         
         if (cntr_ctrl_reg5[4])     //Restart5
         begin     
            if (~cntr_ctrl_reg5[2])  
               count_val5         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg5[1])
                 count_val5         <= interval_reg5;     
              else
                 count_val5         <= 16'hFFFF;     
            end
            counting5       <= 1'b0;
            restart_temp5   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg5[0])          //Low5 Active5 Counter5 Enable5
            begin

               if (cntr_ctrl_reg5[1])  //Interval5               
                  if (cntr_ctrl_reg5[2])  //Decrement5        
                  begin
                     if (count_val5 == 16'h0000)
                        count_val5 <= interval_reg5;  //Assumed5 Static5
                     else
                        count_val5 <= count_val5 - 16'h0001;
                  end
                  else                   //Increment5
                  begin
                     if (count_val5 == interval_reg5)
                        count_val5 <= 16'h0000;
                     else           
                        count_val5 <= count_val5 + 16'h0001;
                  end
               else    
               begin  //Overflow5
                  if (cntr_ctrl_reg5[2])   //Decrement5
                  begin
                     if (count_val5 == 16'h0000)
                        count_val5 <= 16'hFFFF;
                     else           
                        count_val5 <= count_val5 - 16'h0001;
                  end
                  else                    //Increment5
                  begin
                     if (count_val5 == 16'hFFFF)
                        count_val5 <= 16'h0000;
                     else           
                        count_val5 <= count_val5 + 16'h0001;
                  end 
               end
               counting5  <= 1'b1;
            end     
            else
               count_val5 <= count_val5;   //Disabled5
   
            restart_temp5 <= 1'b0;
      
         end
     
      end // if (count_en5)

      else
      begin
         count_val5    <= count_val5;
         counting5     <= counting5;
         restart_temp5 <= restart_temp5;               
      end
     
   end  //p_cntr5

endmodule
