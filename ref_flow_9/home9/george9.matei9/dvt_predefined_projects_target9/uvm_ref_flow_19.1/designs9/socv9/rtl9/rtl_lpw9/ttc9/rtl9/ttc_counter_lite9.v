//File9 name   : ttc_counter_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 :The counter can increment and decrement.
//   In increment mode instead of counting9 to its full 16 bit
//   value the counter counts9 up to or down from a programmed9 interval9 value.
//   Interrupts9 are issued9 when the counter overflows9 or reaches9 it's interval9
//   value. In match mode if the count value equals9 that stored9 in one of three9
//   match registers an interrupt9 is issued9.
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------
//


module ttc_counter_lite9(

  //inputs9
  n_p_reset9,    
  pclk9,          
  pwdata9,              
  count_en9,
  cntr_ctrl_reg_sel9, 
  interval_reg_sel9,
  match_1_reg_sel9,
  match_2_reg_sel9,
  match_3_reg_sel9,         

  //outputs9    
  count_val_out9,
  cntr_ctrl_reg_out9,
  interval_reg_out9,
  match_1_reg_out9,
  match_2_reg_out9,
  match_3_reg_out9,
  interval_intr9,
  match_intr9,
  overflow_intr9

);


//--------------------------------------------------------------------
// PORT DECLARATIONS9
//--------------------------------------------------------------------

   //inputs9
   input          n_p_reset9;         //reset signal9
   input          pclk9;              //System9 Clock9
   input [15:0]   pwdata9;            //6 Bit9 data signal9
   input          count_en9;          //Count9 enable signal9
   input          cntr_ctrl_reg_sel9; //Select9 bit for ctrl_reg9
   input          interval_reg_sel9;  //Interval9 Select9 Register
   input          match_1_reg_sel9;   //Match9 1 Select9 register
   input          match_2_reg_sel9;   //Match9 2 Select9 register
   input          match_3_reg_sel9;   //Match9 3 Select9 register

   //outputs9
   output [15:0]  count_val_out9;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out9;    //Counter9 control9 reg select9
   output [15:0]  interval_reg_out9;     //Interval9 reg
   output [15:0]  match_1_reg_out9;      //Match9 1 register
   output [15:0]  match_2_reg_out9;      //Match9 2 register
   output [15:0]  match_3_reg_out9;      //Match9 3 register
   output         interval_intr9;        //Interval9 interrupt9
   output [3:1]   match_intr9;           //Match9 interrupt9
   output         overflow_intr9;        //Overflow9 interrupt9

//--------------------------------------------------------------------
// Internal Signals9 & Registers9
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg9;     // 5-bit Counter9 Control9 Register
   reg [15:0]     interval_reg9;      //16-bit Interval9 Register 
   reg [15:0]     match_1_reg9;       //16-bit Match_19 Register
   reg [15:0]     match_2_reg9;       //16-bit Match_29 Register
   reg [15:0]     match_3_reg9;       //16-bit Match_39 Register
   reg [15:0]     count_val9;         //16-bit counter value register
                                                                      
   
   reg            counting9;          //counter has starting counting9
   reg            restart_temp9;   //ensures9 soft9 reset lasts9 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out9; //7-bit Counter9 Control9 Register
   wire [15:0]    interval_reg_out9;  //16-bit Interval9 Register 
   wire [15:0]    match_1_reg_out9;   //16-bit Match_19 Register
   wire [15:0]    match_2_reg_out9;   //16-bit Match_29 Register
   wire [15:0]    match_3_reg_out9;   //16-bit Match_39 Register
   wire [15:0]    count_val_out9;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign9 output wires9
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out9 = cntr_ctrl_reg9;    // 7-bit Counter9 Control9
   assign interval_reg_out9  = interval_reg9;     // 16-bit Interval9
   assign match_1_reg_out9   = match_1_reg9;      // 16-bit Match_19
   assign match_2_reg_out9   = match_2_reg9;      // 16-bit Match_29 
   assign match_3_reg_out9   = match_3_reg9;      // 16-bit Match_39 
   assign count_val_out9     = count_val9;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning9 interrupts9
//--------------------------------------------------------------------

   assign interval_intr9 =  cntr_ctrl_reg9[1] & (count_val9 == 16'h0000)
      & (counting9) & ~cntr_ctrl_reg9[4] & ~cntr_ctrl_reg9[0];
   assign overflow_intr9 = ~cntr_ctrl_reg9[1] & (count_val9 == 16'h0000)
      & (counting9) & ~cntr_ctrl_reg9[4] & ~cntr_ctrl_reg9[0];
   assign match_intr9[1]  =  cntr_ctrl_reg9[3] & (count_val9 == match_1_reg9)
      & (counting9) & ~cntr_ctrl_reg9[4] & ~cntr_ctrl_reg9[0];
   assign match_intr9[2]  =  cntr_ctrl_reg9[3] & (count_val9 == match_2_reg9)
      & (counting9) & ~cntr_ctrl_reg9[4] & ~cntr_ctrl_reg9[0];
   assign match_intr9[3]  =  cntr_ctrl_reg9[3] & (count_val9 == match_3_reg9)
      & (counting9) & ~cntr_ctrl_reg9[4] & ~cntr_ctrl_reg9[0];


//    p_reg_ctrl9: Process9 to write to the counter control9 registers
//    cntr_ctrl_reg9 decode:  0 - Counter9 Enable9 Active9 Low9
//                           1 - Interval9 Mode9 =1, Overflow9 =0
//                           2 - Decrement9 Mode9
//                           3 - Match9 Mode9
//                           4 - Restart9
//                           5 - Waveform9 enable active low9
//                           6 - Waveform9 polarity9
   
   always @ (posedge pclk9 or negedge n_p_reset9)
   begin: p_reg_ctrl9  // Register writes
      
      if (!n_p_reset9)                                   
      begin                                     
         cntr_ctrl_reg9 <= 7'b0000001;
         interval_reg9  <= 16'h0000;
         match_1_reg9   <= 16'h0000;
         match_2_reg9   <= 16'h0000;
         match_3_reg9   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel9)
            cntr_ctrl_reg9 <= pwdata9[6:0];
         else if (restart_temp9)
            cntr_ctrl_reg9[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg9 <= cntr_ctrl_reg9;             

         interval_reg9  <= (interval_reg_sel9) ? pwdata9 : interval_reg9;
         match_1_reg9   <= (match_1_reg_sel9)  ? pwdata9 : match_1_reg9;
         match_2_reg9   <= (match_2_reg_sel9)  ? pwdata9 : match_2_reg9;
         match_3_reg9   <= (match_3_reg_sel9)  ? pwdata9 : match_3_reg9;   
      end
      
   end  //p_reg_ctrl9

   
//    p_cntr9: Process9 to increment or decrement the counter on receiving9 a 
//            count_en9 signal9 from the pre_scaler9. Count9 can be restarted9
//            or disabled and can overflow9 at a specified interval9 value.
   
   
   always @ (posedge pclk9 or negedge n_p_reset9)
   begin: p_cntr9   // Counter9 block

      if (!n_p_reset9)     //System9 Reset9
      begin                     
         count_val9 <= 16'h0000;
         counting9  <= 1'b0;
         restart_temp9 <= 1'b0;
      end
      else if (count_en9)
      begin
         
         if (cntr_ctrl_reg9[4])     //Restart9
         begin     
            if (~cntr_ctrl_reg9[2])  
               count_val9         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg9[1])
                 count_val9         <= interval_reg9;     
              else
                 count_val9         <= 16'hFFFF;     
            end
            counting9       <= 1'b0;
            restart_temp9   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg9[0])          //Low9 Active9 Counter9 Enable9
            begin

               if (cntr_ctrl_reg9[1])  //Interval9               
                  if (cntr_ctrl_reg9[2])  //Decrement9        
                  begin
                     if (count_val9 == 16'h0000)
                        count_val9 <= interval_reg9;  //Assumed9 Static9
                     else
                        count_val9 <= count_val9 - 16'h0001;
                  end
                  else                   //Increment9
                  begin
                     if (count_val9 == interval_reg9)
                        count_val9 <= 16'h0000;
                     else           
                        count_val9 <= count_val9 + 16'h0001;
                  end
               else    
               begin  //Overflow9
                  if (cntr_ctrl_reg9[2])   //Decrement9
                  begin
                     if (count_val9 == 16'h0000)
                        count_val9 <= 16'hFFFF;
                     else           
                        count_val9 <= count_val9 - 16'h0001;
                  end
                  else                    //Increment9
                  begin
                     if (count_val9 == 16'hFFFF)
                        count_val9 <= 16'h0000;
                     else           
                        count_val9 <= count_val9 + 16'h0001;
                  end 
               end
               counting9  <= 1'b1;
            end     
            else
               count_val9 <= count_val9;   //Disabled9
   
            restart_temp9 <= 1'b0;
      
         end
     
      end // if (count_en9)

      else
      begin
         count_val9    <= count_val9;
         counting9     <= counting9;
         restart_temp9 <= restart_temp9;               
      end
     
   end  //p_cntr9

endmodule
