//File29 name   : ttc_counter_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 :The counter can increment and decrement.
//   In increment mode instead of counting29 to its full 16 bit
//   value the counter counts29 up to or down from a programmed29 interval29 value.
//   Interrupts29 are issued29 when the counter overflows29 or reaches29 it's interval29
//   value. In match mode if the count value equals29 that stored29 in one of three29
//   match registers an interrupt29 is issued29.
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
//


module ttc_counter_lite29(

  //inputs29
  n_p_reset29,    
  pclk29,          
  pwdata29,              
  count_en29,
  cntr_ctrl_reg_sel29, 
  interval_reg_sel29,
  match_1_reg_sel29,
  match_2_reg_sel29,
  match_3_reg_sel29,         

  //outputs29    
  count_val_out29,
  cntr_ctrl_reg_out29,
  interval_reg_out29,
  match_1_reg_out29,
  match_2_reg_out29,
  match_3_reg_out29,
  interval_intr29,
  match_intr29,
  overflow_intr29

);


//--------------------------------------------------------------------
// PORT DECLARATIONS29
//--------------------------------------------------------------------

   //inputs29
   input          n_p_reset29;         //reset signal29
   input          pclk29;              //System29 Clock29
   input [15:0]   pwdata29;            //6 Bit29 data signal29
   input          count_en29;          //Count29 enable signal29
   input          cntr_ctrl_reg_sel29; //Select29 bit for ctrl_reg29
   input          interval_reg_sel29;  //Interval29 Select29 Register
   input          match_1_reg_sel29;   //Match29 1 Select29 register
   input          match_2_reg_sel29;   //Match29 2 Select29 register
   input          match_3_reg_sel29;   //Match29 3 Select29 register

   //outputs29
   output [15:0]  count_val_out29;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out29;    //Counter29 control29 reg select29
   output [15:0]  interval_reg_out29;     //Interval29 reg
   output [15:0]  match_1_reg_out29;      //Match29 1 register
   output [15:0]  match_2_reg_out29;      //Match29 2 register
   output [15:0]  match_3_reg_out29;      //Match29 3 register
   output         interval_intr29;        //Interval29 interrupt29
   output [3:1]   match_intr29;           //Match29 interrupt29
   output         overflow_intr29;        //Overflow29 interrupt29

//--------------------------------------------------------------------
// Internal Signals29 & Registers29
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg29;     // 5-bit Counter29 Control29 Register
   reg [15:0]     interval_reg29;      //16-bit Interval29 Register 
   reg [15:0]     match_1_reg29;       //16-bit Match_129 Register
   reg [15:0]     match_2_reg29;       //16-bit Match_229 Register
   reg [15:0]     match_3_reg29;       //16-bit Match_329 Register
   reg [15:0]     count_val29;         //16-bit counter value register
                                                                      
   
   reg            counting29;          //counter has starting counting29
   reg            restart_temp29;   //ensures29 soft29 reset lasts29 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out29; //7-bit Counter29 Control29 Register
   wire [15:0]    interval_reg_out29;  //16-bit Interval29 Register 
   wire [15:0]    match_1_reg_out29;   //16-bit Match_129 Register
   wire [15:0]    match_2_reg_out29;   //16-bit Match_229 Register
   wire [15:0]    match_3_reg_out29;   //16-bit Match_329 Register
   wire [15:0]    count_val_out29;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign29 output wires29
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out29 = cntr_ctrl_reg29;    // 7-bit Counter29 Control29
   assign interval_reg_out29  = interval_reg29;     // 16-bit Interval29
   assign match_1_reg_out29   = match_1_reg29;      // 16-bit Match_129
   assign match_2_reg_out29   = match_2_reg29;      // 16-bit Match_229 
   assign match_3_reg_out29   = match_3_reg29;      // 16-bit Match_329 
   assign count_val_out29     = count_val29;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning29 interrupts29
//--------------------------------------------------------------------

   assign interval_intr29 =  cntr_ctrl_reg29[1] & (count_val29 == 16'h0000)
      & (counting29) & ~cntr_ctrl_reg29[4] & ~cntr_ctrl_reg29[0];
   assign overflow_intr29 = ~cntr_ctrl_reg29[1] & (count_val29 == 16'h0000)
      & (counting29) & ~cntr_ctrl_reg29[4] & ~cntr_ctrl_reg29[0];
   assign match_intr29[1]  =  cntr_ctrl_reg29[3] & (count_val29 == match_1_reg29)
      & (counting29) & ~cntr_ctrl_reg29[4] & ~cntr_ctrl_reg29[0];
   assign match_intr29[2]  =  cntr_ctrl_reg29[3] & (count_val29 == match_2_reg29)
      & (counting29) & ~cntr_ctrl_reg29[4] & ~cntr_ctrl_reg29[0];
   assign match_intr29[3]  =  cntr_ctrl_reg29[3] & (count_val29 == match_3_reg29)
      & (counting29) & ~cntr_ctrl_reg29[4] & ~cntr_ctrl_reg29[0];


//    p_reg_ctrl29: Process29 to write to the counter control29 registers
//    cntr_ctrl_reg29 decode:  0 - Counter29 Enable29 Active29 Low29
//                           1 - Interval29 Mode29 =1, Overflow29 =0
//                           2 - Decrement29 Mode29
//                           3 - Match29 Mode29
//                           4 - Restart29
//                           5 - Waveform29 enable active low29
//                           6 - Waveform29 polarity29
   
   always @ (posedge pclk29 or negedge n_p_reset29)
   begin: p_reg_ctrl29  // Register writes
      
      if (!n_p_reset29)                                   
      begin                                     
         cntr_ctrl_reg29 <= 7'b0000001;
         interval_reg29  <= 16'h0000;
         match_1_reg29   <= 16'h0000;
         match_2_reg29   <= 16'h0000;
         match_3_reg29   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel29)
            cntr_ctrl_reg29 <= pwdata29[6:0];
         else if (restart_temp29)
            cntr_ctrl_reg29[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg29 <= cntr_ctrl_reg29;             

         interval_reg29  <= (interval_reg_sel29) ? pwdata29 : interval_reg29;
         match_1_reg29   <= (match_1_reg_sel29)  ? pwdata29 : match_1_reg29;
         match_2_reg29   <= (match_2_reg_sel29)  ? pwdata29 : match_2_reg29;
         match_3_reg29   <= (match_3_reg_sel29)  ? pwdata29 : match_3_reg29;   
      end
      
   end  //p_reg_ctrl29

   
//    p_cntr29: Process29 to increment or decrement the counter on receiving29 a 
//            count_en29 signal29 from the pre_scaler29. Count29 can be restarted29
//            or disabled and can overflow29 at a specified interval29 value.
   
   
   always @ (posedge pclk29 or negedge n_p_reset29)
   begin: p_cntr29   // Counter29 block

      if (!n_p_reset29)     //System29 Reset29
      begin                     
         count_val29 <= 16'h0000;
         counting29  <= 1'b0;
         restart_temp29 <= 1'b0;
      end
      else if (count_en29)
      begin
         
         if (cntr_ctrl_reg29[4])     //Restart29
         begin     
            if (~cntr_ctrl_reg29[2])  
               count_val29         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg29[1])
                 count_val29         <= interval_reg29;     
              else
                 count_val29         <= 16'hFFFF;     
            end
            counting29       <= 1'b0;
            restart_temp29   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg29[0])          //Low29 Active29 Counter29 Enable29
            begin

               if (cntr_ctrl_reg29[1])  //Interval29               
                  if (cntr_ctrl_reg29[2])  //Decrement29        
                  begin
                     if (count_val29 == 16'h0000)
                        count_val29 <= interval_reg29;  //Assumed29 Static29
                     else
                        count_val29 <= count_val29 - 16'h0001;
                  end
                  else                   //Increment29
                  begin
                     if (count_val29 == interval_reg29)
                        count_val29 <= 16'h0000;
                     else           
                        count_val29 <= count_val29 + 16'h0001;
                  end
               else    
               begin  //Overflow29
                  if (cntr_ctrl_reg29[2])   //Decrement29
                  begin
                     if (count_val29 == 16'h0000)
                        count_val29 <= 16'hFFFF;
                     else           
                        count_val29 <= count_val29 - 16'h0001;
                  end
                  else                    //Increment29
                  begin
                     if (count_val29 == 16'hFFFF)
                        count_val29 <= 16'h0000;
                     else           
                        count_val29 <= count_val29 + 16'h0001;
                  end 
               end
               counting29  <= 1'b1;
            end     
            else
               count_val29 <= count_val29;   //Disabled29
   
            restart_temp29 <= 1'b0;
      
         end
     
      end // if (count_en29)

      else
      begin
         count_val29    <= count_val29;
         counting29     <= counting29;
         restart_temp29 <= restart_temp29;               
      end
     
   end  //p_cntr29

endmodule
