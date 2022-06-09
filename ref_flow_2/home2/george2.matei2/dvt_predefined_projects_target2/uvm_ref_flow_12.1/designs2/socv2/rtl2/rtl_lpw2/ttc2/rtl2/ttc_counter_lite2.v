//File2 name   : ttc_counter_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 :The counter can increment and decrement.
//   In increment mode instead of counting2 to its full 16 bit
//   value the counter counts2 up to or down from a programmed2 interval2 value.
//   Interrupts2 are issued2 when the counter overflows2 or reaches2 it's interval2
//   value. In match mode if the count value equals2 that stored2 in one of three2
//   match registers an interrupt2 is issued2.
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
//


module ttc_counter_lite2(

  //inputs2
  n_p_reset2,    
  pclk2,          
  pwdata2,              
  count_en2,
  cntr_ctrl_reg_sel2, 
  interval_reg_sel2,
  match_1_reg_sel2,
  match_2_reg_sel2,
  match_3_reg_sel2,         

  //outputs2    
  count_val_out2,
  cntr_ctrl_reg_out2,
  interval_reg_out2,
  match_1_reg_out2,
  match_2_reg_out2,
  match_3_reg_out2,
  interval_intr2,
  match_intr2,
  overflow_intr2

);


//--------------------------------------------------------------------
// PORT DECLARATIONS2
//--------------------------------------------------------------------

   //inputs2
   input          n_p_reset2;         //reset signal2
   input          pclk2;              //System2 Clock2
   input [15:0]   pwdata2;            //6 Bit2 data signal2
   input          count_en2;          //Count2 enable signal2
   input          cntr_ctrl_reg_sel2; //Select2 bit for ctrl_reg2
   input          interval_reg_sel2;  //Interval2 Select2 Register
   input          match_1_reg_sel2;   //Match2 1 Select2 register
   input          match_2_reg_sel2;   //Match2 2 Select2 register
   input          match_3_reg_sel2;   //Match2 3 Select2 register

   //outputs2
   output [15:0]  count_val_out2;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out2;    //Counter2 control2 reg select2
   output [15:0]  interval_reg_out2;     //Interval2 reg
   output [15:0]  match_1_reg_out2;      //Match2 1 register
   output [15:0]  match_2_reg_out2;      //Match2 2 register
   output [15:0]  match_3_reg_out2;      //Match2 3 register
   output         interval_intr2;        //Interval2 interrupt2
   output [3:1]   match_intr2;           //Match2 interrupt2
   output         overflow_intr2;        //Overflow2 interrupt2

//--------------------------------------------------------------------
// Internal Signals2 & Registers2
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg2;     // 5-bit Counter2 Control2 Register
   reg [15:0]     interval_reg2;      //16-bit Interval2 Register 
   reg [15:0]     match_1_reg2;       //16-bit Match_12 Register
   reg [15:0]     match_2_reg2;       //16-bit Match_22 Register
   reg [15:0]     match_3_reg2;       //16-bit Match_32 Register
   reg [15:0]     count_val2;         //16-bit counter value register
                                                                      
   
   reg            counting2;          //counter has starting counting2
   reg            restart_temp2;   //ensures2 soft2 reset lasts2 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out2; //7-bit Counter2 Control2 Register
   wire [15:0]    interval_reg_out2;  //16-bit Interval2 Register 
   wire [15:0]    match_1_reg_out2;   //16-bit Match_12 Register
   wire [15:0]    match_2_reg_out2;   //16-bit Match_22 Register
   wire [15:0]    match_3_reg_out2;   //16-bit Match_32 Register
   wire [15:0]    count_val_out2;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign2 output wires2
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out2 = cntr_ctrl_reg2;    // 7-bit Counter2 Control2
   assign interval_reg_out2  = interval_reg2;     // 16-bit Interval2
   assign match_1_reg_out2   = match_1_reg2;      // 16-bit Match_12
   assign match_2_reg_out2   = match_2_reg2;      // 16-bit Match_22 
   assign match_3_reg_out2   = match_3_reg2;      // 16-bit Match_32 
   assign count_val_out2     = count_val2;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning2 interrupts2
//--------------------------------------------------------------------

   assign interval_intr2 =  cntr_ctrl_reg2[1] & (count_val2 == 16'h0000)
      & (counting2) & ~cntr_ctrl_reg2[4] & ~cntr_ctrl_reg2[0];
   assign overflow_intr2 = ~cntr_ctrl_reg2[1] & (count_val2 == 16'h0000)
      & (counting2) & ~cntr_ctrl_reg2[4] & ~cntr_ctrl_reg2[0];
   assign match_intr2[1]  =  cntr_ctrl_reg2[3] & (count_val2 == match_1_reg2)
      & (counting2) & ~cntr_ctrl_reg2[4] & ~cntr_ctrl_reg2[0];
   assign match_intr2[2]  =  cntr_ctrl_reg2[3] & (count_val2 == match_2_reg2)
      & (counting2) & ~cntr_ctrl_reg2[4] & ~cntr_ctrl_reg2[0];
   assign match_intr2[3]  =  cntr_ctrl_reg2[3] & (count_val2 == match_3_reg2)
      & (counting2) & ~cntr_ctrl_reg2[4] & ~cntr_ctrl_reg2[0];


//    p_reg_ctrl2: Process2 to write to the counter control2 registers
//    cntr_ctrl_reg2 decode:  0 - Counter2 Enable2 Active2 Low2
//                           1 - Interval2 Mode2 =1, Overflow2 =0
//                           2 - Decrement2 Mode2
//                           3 - Match2 Mode2
//                           4 - Restart2
//                           5 - Waveform2 enable active low2
//                           6 - Waveform2 polarity2
   
   always @ (posedge pclk2 or negedge n_p_reset2)
   begin: p_reg_ctrl2  // Register writes
      
      if (!n_p_reset2)                                   
      begin                                     
         cntr_ctrl_reg2 <= 7'b0000001;
         interval_reg2  <= 16'h0000;
         match_1_reg2   <= 16'h0000;
         match_2_reg2   <= 16'h0000;
         match_3_reg2   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel2)
            cntr_ctrl_reg2 <= pwdata2[6:0];
         else if (restart_temp2)
            cntr_ctrl_reg2[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg2 <= cntr_ctrl_reg2;             

         interval_reg2  <= (interval_reg_sel2) ? pwdata2 : interval_reg2;
         match_1_reg2   <= (match_1_reg_sel2)  ? pwdata2 : match_1_reg2;
         match_2_reg2   <= (match_2_reg_sel2)  ? pwdata2 : match_2_reg2;
         match_3_reg2   <= (match_3_reg_sel2)  ? pwdata2 : match_3_reg2;   
      end
      
   end  //p_reg_ctrl2

   
//    p_cntr2: Process2 to increment or decrement the counter on receiving2 a 
//            count_en2 signal2 from the pre_scaler2. Count2 can be restarted2
//            or disabled and can overflow2 at a specified interval2 value.
   
   
   always @ (posedge pclk2 or negedge n_p_reset2)
   begin: p_cntr2   // Counter2 block

      if (!n_p_reset2)     //System2 Reset2
      begin                     
         count_val2 <= 16'h0000;
         counting2  <= 1'b0;
         restart_temp2 <= 1'b0;
      end
      else if (count_en2)
      begin
         
         if (cntr_ctrl_reg2[4])     //Restart2
         begin     
            if (~cntr_ctrl_reg2[2])  
               count_val2         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg2[1])
                 count_val2         <= interval_reg2;     
              else
                 count_val2         <= 16'hFFFF;     
            end
            counting2       <= 1'b0;
            restart_temp2   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg2[0])          //Low2 Active2 Counter2 Enable2
            begin

               if (cntr_ctrl_reg2[1])  //Interval2               
                  if (cntr_ctrl_reg2[2])  //Decrement2        
                  begin
                     if (count_val2 == 16'h0000)
                        count_val2 <= interval_reg2;  //Assumed2 Static2
                     else
                        count_val2 <= count_val2 - 16'h0001;
                  end
                  else                   //Increment2
                  begin
                     if (count_val2 == interval_reg2)
                        count_val2 <= 16'h0000;
                     else           
                        count_val2 <= count_val2 + 16'h0001;
                  end
               else    
               begin  //Overflow2
                  if (cntr_ctrl_reg2[2])   //Decrement2
                  begin
                     if (count_val2 == 16'h0000)
                        count_val2 <= 16'hFFFF;
                     else           
                        count_val2 <= count_val2 - 16'h0001;
                  end
                  else                    //Increment2
                  begin
                     if (count_val2 == 16'hFFFF)
                        count_val2 <= 16'h0000;
                     else           
                        count_val2 <= count_val2 + 16'h0001;
                  end 
               end
               counting2  <= 1'b1;
            end     
            else
               count_val2 <= count_val2;   //Disabled2
   
            restart_temp2 <= 1'b0;
      
         end
     
      end // if (count_en2)

      else
      begin
         count_val2    <= count_val2;
         counting2     <= counting2;
         restart_temp2 <= restart_temp2;               
      end
     
   end  //p_cntr2

endmodule
