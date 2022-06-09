//File6 name   : ttc_counter_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 :The counter can increment and decrement.
//   In increment mode instead of counting6 to its full 16 bit
//   value the counter counts6 up to or down from a programmed6 interval6 value.
//   Interrupts6 are issued6 when the counter overflows6 or reaches6 it's interval6
//   value. In match mode if the count value equals6 that stored6 in one of three6
//   match registers an interrupt6 is issued6.
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
//


module ttc_counter_lite6(

  //inputs6
  n_p_reset6,    
  pclk6,          
  pwdata6,              
  count_en6,
  cntr_ctrl_reg_sel6, 
  interval_reg_sel6,
  match_1_reg_sel6,
  match_2_reg_sel6,
  match_3_reg_sel6,         

  //outputs6    
  count_val_out6,
  cntr_ctrl_reg_out6,
  interval_reg_out6,
  match_1_reg_out6,
  match_2_reg_out6,
  match_3_reg_out6,
  interval_intr6,
  match_intr6,
  overflow_intr6

);


//--------------------------------------------------------------------
// PORT DECLARATIONS6
//--------------------------------------------------------------------

   //inputs6
   input          n_p_reset6;         //reset signal6
   input          pclk6;              //System6 Clock6
   input [15:0]   pwdata6;            //6 Bit6 data signal6
   input          count_en6;          //Count6 enable signal6
   input          cntr_ctrl_reg_sel6; //Select6 bit for ctrl_reg6
   input          interval_reg_sel6;  //Interval6 Select6 Register
   input          match_1_reg_sel6;   //Match6 1 Select6 register
   input          match_2_reg_sel6;   //Match6 2 Select6 register
   input          match_3_reg_sel6;   //Match6 3 Select6 register

   //outputs6
   output [15:0]  count_val_out6;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out6;    //Counter6 control6 reg select6
   output [15:0]  interval_reg_out6;     //Interval6 reg
   output [15:0]  match_1_reg_out6;      //Match6 1 register
   output [15:0]  match_2_reg_out6;      //Match6 2 register
   output [15:0]  match_3_reg_out6;      //Match6 3 register
   output         interval_intr6;        //Interval6 interrupt6
   output [3:1]   match_intr6;           //Match6 interrupt6
   output         overflow_intr6;        //Overflow6 interrupt6

//--------------------------------------------------------------------
// Internal Signals6 & Registers6
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg6;     // 5-bit Counter6 Control6 Register
   reg [15:0]     interval_reg6;      //16-bit Interval6 Register 
   reg [15:0]     match_1_reg6;       //16-bit Match_16 Register
   reg [15:0]     match_2_reg6;       //16-bit Match_26 Register
   reg [15:0]     match_3_reg6;       //16-bit Match_36 Register
   reg [15:0]     count_val6;         //16-bit counter value register
                                                                      
   
   reg            counting6;          //counter has starting counting6
   reg            restart_temp6;   //ensures6 soft6 reset lasts6 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out6; //7-bit Counter6 Control6 Register
   wire [15:0]    interval_reg_out6;  //16-bit Interval6 Register 
   wire [15:0]    match_1_reg_out6;   //16-bit Match_16 Register
   wire [15:0]    match_2_reg_out6;   //16-bit Match_26 Register
   wire [15:0]    match_3_reg_out6;   //16-bit Match_36 Register
   wire [15:0]    count_val_out6;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign6 output wires6
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out6 = cntr_ctrl_reg6;    // 7-bit Counter6 Control6
   assign interval_reg_out6  = interval_reg6;     // 16-bit Interval6
   assign match_1_reg_out6   = match_1_reg6;      // 16-bit Match_16
   assign match_2_reg_out6   = match_2_reg6;      // 16-bit Match_26 
   assign match_3_reg_out6   = match_3_reg6;      // 16-bit Match_36 
   assign count_val_out6     = count_val6;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning6 interrupts6
//--------------------------------------------------------------------

   assign interval_intr6 =  cntr_ctrl_reg6[1] & (count_val6 == 16'h0000)
      & (counting6) & ~cntr_ctrl_reg6[4] & ~cntr_ctrl_reg6[0];
   assign overflow_intr6 = ~cntr_ctrl_reg6[1] & (count_val6 == 16'h0000)
      & (counting6) & ~cntr_ctrl_reg6[4] & ~cntr_ctrl_reg6[0];
   assign match_intr6[1]  =  cntr_ctrl_reg6[3] & (count_val6 == match_1_reg6)
      & (counting6) & ~cntr_ctrl_reg6[4] & ~cntr_ctrl_reg6[0];
   assign match_intr6[2]  =  cntr_ctrl_reg6[3] & (count_val6 == match_2_reg6)
      & (counting6) & ~cntr_ctrl_reg6[4] & ~cntr_ctrl_reg6[0];
   assign match_intr6[3]  =  cntr_ctrl_reg6[3] & (count_val6 == match_3_reg6)
      & (counting6) & ~cntr_ctrl_reg6[4] & ~cntr_ctrl_reg6[0];


//    p_reg_ctrl6: Process6 to write to the counter control6 registers
//    cntr_ctrl_reg6 decode:  0 - Counter6 Enable6 Active6 Low6
//                           1 - Interval6 Mode6 =1, Overflow6 =0
//                           2 - Decrement6 Mode6
//                           3 - Match6 Mode6
//                           4 - Restart6
//                           5 - Waveform6 enable active low6
//                           6 - Waveform6 polarity6
   
   always @ (posedge pclk6 or negedge n_p_reset6)
   begin: p_reg_ctrl6  // Register writes
      
      if (!n_p_reset6)                                   
      begin                                     
         cntr_ctrl_reg6 <= 7'b0000001;
         interval_reg6  <= 16'h0000;
         match_1_reg6   <= 16'h0000;
         match_2_reg6   <= 16'h0000;
         match_3_reg6   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel6)
            cntr_ctrl_reg6 <= pwdata6[6:0];
         else if (restart_temp6)
            cntr_ctrl_reg6[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg6 <= cntr_ctrl_reg6;             

         interval_reg6  <= (interval_reg_sel6) ? pwdata6 : interval_reg6;
         match_1_reg6   <= (match_1_reg_sel6)  ? pwdata6 : match_1_reg6;
         match_2_reg6   <= (match_2_reg_sel6)  ? pwdata6 : match_2_reg6;
         match_3_reg6   <= (match_3_reg_sel6)  ? pwdata6 : match_3_reg6;   
      end
      
   end  //p_reg_ctrl6

   
//    p_cntr6: Process6 to increment or decrement the counter on receiving6 a 
//            count_en6 signal6 from the pre_scaler6. Count6 can be restarted6
//            or disabled and can overflow6 at a specified interval6 value.
   
   
   always @ (posedge pclk6 or negedge n_p_reset6)
   begin: p_cntr6   // Counter6 block

      if (!n_p_reset6)     //System6 Reset6
      begin                     
         count_val6 <= 16'h0000;
         counting6  <= 1'b0;
         restart_temp6 <= 1'b0;
      end
      else if (count_en6)
      begin
         
         if (cntr_ctrl_reg6[4])     //Restart6
         begin     
            if (~cntr_ctrl_reg6[2])  
               count_val6         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg6[1])
                 count_val6         <= interval_reg6;     
              else
                 count_val6         <= 16'hFFFF;     
            end
            counting6       <= 1'b0;
            restart_temp6   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg6[0])          //Low6 Active6 Counter6 Enable6
            begin

               if (cntr_ctrl_reg6[1])  //Interval6               
                  if (cntr_ctrl_reg6[2])  //Decrement6        
                  begin
                     if (count_val6 == 16'h0000)
                        count_val6 <= interval_reg6;  //Assumed6 Static6
                     else
                        count_val6 <= count_val6 - 16'h0001;
                  end
                  else                   //Increment6
                  begin
                     if (count_val6 == interval_reg6)
                        count_val6 <= 16'h0000;
                     else           
                        count_val6 <= count_val6 + 16'h0001;
                  end
               else    
               begin  //Overflow6
                  if (cntr_ctrl_reg6[2])   //Decrement6
                  begin
                     if (count_val6 == 16'h0000)
                        count_val6 <= 16'hFFFF;
                     else           
                        count_val6 <= count_val6 - 16'h0001;
                  end
                  else                    //Increment6
                  begin
                     if (count_val6 == 16'hFFFF)
                        count_val6 <= 16'h0000;
                     else           
                        count_val6 <= count_val6 + 16'h0001;
                  end 
               end
               counting6  <= 1'b1;
            end     
            else
               count_val6 <= count_val6;   //Disabled6
   
            restart_temp6 <= 1'b0;
      
         end
     
      end // if (count_en6)

      else
      begin
         count_val6    <= count_val6;
         counting6     <= counting6;
         restart_temp6 <= restart_temp6;               
      end
     
   end  //p_cntr6

endmodule
