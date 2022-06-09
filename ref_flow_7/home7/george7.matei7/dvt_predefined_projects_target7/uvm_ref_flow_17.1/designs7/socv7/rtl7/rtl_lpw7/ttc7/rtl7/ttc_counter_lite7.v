//File7 name   : ttc_counter_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 :The counter can increment and decrement.
//   In increment mode instead of counting7 to its full 16 bit
//   value the counter counts7 up to or down from a programmed7 interval7 value.
//   Interrupts7 are issued7 when the counter overflows7 or reaches7 it's interval7
//   value. In match mode if the count value equals7 that stored7 in one of three7
//   match registers an interrupt7 is issued7.
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
//


module ttc_counter_lite7(

  //inputs7
  n_p_reset7,    
  pclk7,          
  pwdata7,              
  count_en7,
  cntr_ctrl_reg_sel7, 
  interval_reg_sel7,
  match_1_reg_sel7,
  match_2_reg_sel7,
  match_3_reg_sel7,         

  //outputs7    
  count_val_out7,
  cntr_ctrl_reg_out7,
  interval_reg_out7,
  match_1_reg_out7,
  match_2_reg_out7,
  match_3_reg_out7,
  interval_intr7,
  match_intr7,
  overflow_intr7

);


//--------------------------------------------------------------------
// PORT DECLARATIONS7
//--------------------------------------------------------------------

   //inputs7
   input          n_p_reset7;         //reset signal7
   input          pclk7;              //System7 Clock7
   input [15:0]   pwdata7;            //6 Bit7 data signal7
   input          count_en7;          //Count7 enable signal7
   input          cntr_ctrl_reg_sel7; //Select7 bit for ctrl_reg7
   input          interval_reg_sel7;  //Interval7 Select7 Register
   input          match_1_reg_sel7;   //Match7 1 Select7 register
   input          match_2_reg_sel7;   //Match7 2 Select7 register
   input          match_3_reg_sel7;   //Match7 3 Select7 register

   //outputs7
   output [15:0]  count_val_out7;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out7;    //Counter7 control7 reg select7
   output [15:0]  interval_reg_out7;     //Interval7 reg
   output [15:0]  match_1_reg_out7;      //Match7 1 register
   output [15:0]  match_2_reg_out7;      //Match7 2 register
   output [15:0]  match_3_reg_out7;      //Match7 3 register
   output         interval_intr7;        //Interval7 interrupt7
   output [3:1]   match_intr7;           //Match7 interrupt7
   output         overflow_intr7;        //Overflow7 interrupt7

//--------------------------------------------------------------------
// Internal Signals7 & Registers7
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg7;     // 5-bit Counter7 Control7 Register
   reg [15:0]     interval_reg7;      //16-bit Interval7 Register 
   reg [15:0]     match_1_reg7;       //16-bit Match_17 Register
   reg [15:0]     match_2_reg7;       //16-bit Match_27 Register
   reg [15:0]     match_3_reg7;       //16-bit Match_37 Register
   reg [15:0]     count_val7;         //16-bit counter value register
                                                                      
   
   reg            counting7;          //counter has starting counting7
   reg            restart_temp7;   //ensures7 soft7 reset lasts7 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out7; //7-bit Counter7 Control7 Register
   wire [15:0]    interval_reg_out7;  //16-bit Interval7 Register 
   wire [15:0]    match_1_reg_out7;   //16-bit Match_17 Register
   wire [15:0]    match_2_reg_out7;   //16-bit Match_27 Register
   wire [15:0]    match_3_reg_out7;   //16-bit Match_37 Register
   wire [15:0]    count_val_out7;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign7 output wires7
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out7 = cntr_ctrl_reg7;    // 7-bit Counter7 Control7
   assign interval_reg_out7  = interval_reg7;     // 16-bit Interval7
   assign match_1_reg_out7   = match_1_reg7;      // 16-bit Match_17
   assign match_2_reg_out7   = match_2_reg7;      // 16-bit Match_27 
   assign match_3_reg_out7   = match_3_reg7;      // 16-bit Match_37 
   assign count_val_out7     = count_val7;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning7 interrupts7
//--------------------------------------------------------------------

   assign interval_intr7 =  cntr_ctrl_reg7[1] & (count_val7 == 16'h0000)
      & (counting7) & ~cntr_ctrl_reg7[4] & ~cntr_ctrl_reg7[0];
   assign overflow_intr7 = ~cntr_ctrl_reg7[1] & (count_val7 == 16'h0000)
      & (counting7) & ~cntr_ctrl_reg7[4] & ~cntr_ctrl_reg7[0];
   assign match_intr7[1]  =  cntr_ctrl_reg7[3] & (count_val7 == match_1_reg7)
      & (counting7) & ~cntr_ctrl_reg7[4] & ~cntr_ctrl_reg7[0];
   assign match_intr7[2]  =  cntr_ctrl_reg7[3] & (count_val7 == match_2_reg7)
      & (counting7) & ~cntr_ctrl_reg7[4] & ~cntr_ctrl_reg7[0];
   assign match_intr7[3]  =  cntr_ctrl_reg7[3] & (count_val7 == match_3_reg7)
      & (counting7) & ~cntr_ctrl_reg7[4] & ~cntr_ctrl_reg7[0];


//    p_reg_ctrl7: Process7 to write to the counter control7 registers
//    cntr_ctrl_reg7 decode:  0 - Counter7 Enable7 Active7 Low7
//                           1 - Interval7 Mode7 =1, Overflow7 =0
//                           2 - Decrement7 Mode7
//                           3 - Match7 Mode7
//                           4 - Restart7
//                           5 - Waveform7 enable active low7
//                           6 - Waveform7 polarity7
   
   always @ (posedge pclk7 or negedge n_p_reset7)
   begin: p_reg_ctrl7  // Register writes
      
      if (!n_p_reset7)                                   
      begin                                     
         cntr_ctrl_reg7 <= 7'b0000001;
         interval_reg7  <= 16'h0000;
         match_1_reg7   <= 16'h0000;
         match_2_reg7   <= 16'h0000;
         match_3_reg7   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel7)
            cntr_ctrl_reg7 <= pwdata7[6:0];
         else if (restart_temp7)
            cntr_ctrl_reg7[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg7 <= cntr_ctrl_reg7;             

         interval_reg7  <= (interval_reg_sel7) ? pwdata7 : interval_reg7;
         match_1_reg7   <= (match_1_reg_sel7)  ? pwdata7 : match_1_reg7;
         match_2_reg7   <= (match_2_reg_sel7)  ? pwdata7 : match_2_reg7;
         match_3_reg7   <= (match_3_reg_sel7)  ? pwdata7 : match_3_reg7;   
      end
      
   end  //p_reg_ctrl7

   
//    p_cntr7: Process7 to increment or decrement the counter on receiving7 a 
//            count_en7 signal7 from the pre_scaler7. Count7 can be restarted7
//            or disabled and can overflow7 at a specified interval7 value.
   
   
   always @ (posedge pclk7 or negedge n_p_reset7)
   begin: p_cntr7   // Counter7 block

      if (!n_p_reset7)     //System7 Reset7
      begin                     
         count_val7 <= 16'h0000;
         counting7  <= 1'b0;
         restart_temp7 <= 1'b0;
      end
      else if (count_en7)
      begin
         
         if (cntr_ctrl_reg7[4])     //Restart7
         begin     
            if (~cntr_ctrl_reg7[2])  
               count_val7         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg7[1])
                 count_val7         <= interval_reg7;     
              else
                 count_val7         <= 16'hFFFF;     
            end
            counting7       <= 1'b0;
            restart_temp7   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg7[0])          //Low7 Active7 Counter7 Enable7
            begin

               if (cntr_ctrl_reg7[1])  //Interval7               
                  if (cntr_ctrl_reg7[2])  //Decrement7        
                  begin
                     if (count_val7 == 16'h0000)
                        count_val7 <= interval_reg7;  //Assumed7 Static7
                     else
                        count_val7 <= count_val7 - 16'h0001;
                  end
                  else                   //Increment7
                  begin
                     if (count_val7 == interval_reg7)
                        count_val7 <= 16'h0000;
                     else           
                        count_val7 <= count_val7 + 16'h0001;
                  end
               else    
               begin  //Overflow7
                  if (cntr_ctrl_reg7[2])   //Decrement7
                  begin
                     if (count_val7 == 16'h0000)
                        count_val7 <= 16'hFFFF;
                     else           
                        count_val7 <= count_val7 - 16'h0001;
                  end
                  else                    //Increment7
                  begin
                     if (count_val7 == 16'hFFFF)
                        count_val7 <= 16'h0000;
                     else           
                        count_val7 <= count_val7 + 16'h0001;
                  end 
               end
               counting7  <= 1'b1;
            end     
            else
               count_val7 <= count_val7;   //Disabled7
   
            restart_temp7 <= 1'b0;
      
         end
     
      end // if (count_en7)

      else
      begin
         count_val7    <= count_val7;
         counting7     <= counting7;
         restart_temp7 <= restart_temp7;               
      end
     
   end  //p_cntr7

endmodule
