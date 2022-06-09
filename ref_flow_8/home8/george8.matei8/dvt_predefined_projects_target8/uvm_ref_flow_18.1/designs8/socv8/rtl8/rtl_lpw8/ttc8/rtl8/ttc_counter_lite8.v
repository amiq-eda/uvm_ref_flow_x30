//File8 name   : ttc_counter_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 :The counter can increment and decrement.
//   In increment mode instead of counting8 to its full 16 bit
//   value the counter counts8 up to or down from a programmed8 interval8 value.
//   Interrupts8 are issued8 when the counter overflows8 or reaches8 it's interval8
//   value. In match mode if the count value equals8 that stored8 in one of three8
//   match registers an interrupt8 is issued8.
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
//


module ttc_counter_lite8(

  //inputs8
  n_p_reset8,    
  pclk8,          
  pwdata8,              
  count_en8,
  cntr_ctrl_reg_sel8, 
  interval_reg_sel8,
  match_1_reg_sel8,
  match_2_reg_sel8,
  match_3_reg_sel8,         

  //outputs8    
  count_val_out8,
  cntr_ctrl_reg_out8,
  interval_reg_out8,
  match_1_reg_out8,
  match_2_reg_out8,
  match_3_reg_out8,
  interval_intr8,
  match_intr8,
  overflow_intr8

);


//--------------------------------------------------------------------
// PORT DECLARATIONS8
//--------------------------------------------------------------------

   //inputs8
   input          n_p_reset8;         //reset signal8
   input          pclk8;              //System8 Clock8
   input [15:0]   pwdata8;            //6 Bit8 data signal8
   input          count_en8;          //Count8 enable signal8
   input          cntr_ctrl_reg_sel8; //Select8 bit for ctrl_reg8
   input          interval_reg_sel8;  //Interval8 Select8 Register
   input          match_1_reg_sel8;   //Match8 1 Select8 register
   input          match_2_reg_sel8;   //Match8 2 Select8 register
   input          match_3_reg_sel8;   //Match8 3 Select8 register

   //outputs8
   output [15:0]  count_val_out8;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out8;    //Counter8 control8 reg select8
   output [15:0]  interval_reg_out8;     //Interval8 reg
   output [15:0]  match_1_reg_out8;      //Match8 1 register
   output [15:0]  match_2_reg_out8;      //Match8 2 register
   output [15:0]  match_3_reg_out8;      //Match8 3 register
   output         interval_intr8;        //Interval8 interrupt8
   output [3:1]   match_intr8;           //Match8 interrupt8
   output         overflow_intr8;        //Overflow8 interrupt8

//--------------------------------------------------------------------
// Internal Signals8 & Registers8
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg8;     // 5-bit Counter8 Control8 Register
   reg [15:0]     interval_reg8;      //16-bit Interval8 Register 
   reg [15:0]     match_1_reg8;       //16-bit Match_18 Register
   reg [15:0]     match_2_reg8;       //16-bit Match_28 Register
   reg [15:0]     match_3_reg8;       //16-bit Match_38 Register
   reg [15:0]     count_val8;         //16-bit counter value register
                                                                      
   
   reg            counting8;          //counter has starting counting8
   reg            restart_temp8;   //ensures8 soft8 reset lasts8 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out8; //7-bit Counter8 Control8 Register
   wire [15:0]    interval_reg_out8;  //16-bit Interval8 Register 
   wire [15:0]    match_1_reg_out8;   //16-bit Match_18 Register
   wire [15:0]    match_2_reg_out8;   //16-bit Match_28 Register
   wire [15:0]    match_3_reg_out8;   //16-bit Match_38 Register
   wire [15:0]    count_val_out8;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign8 output wires8
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out8 = cntr_ctrl_reg8;    // 7-bit Counter8 Control8
   assign interval_reg_out8  = interval_reg8;     // 16-bit Interval8
   assign match_1_reg_out8   = match_1_reg8;      // 16-bit Match_18
   assign match_2_reg_out8   = match_2_reg8;      // 16-bit Match_28 
   assign match_3_reg_out8   = match_3_reg8;      // 16-bit Match_38 
   assign count_val_out8     = count_val8;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning8 interrupts8
//--------------------------------------------------------------------

   assign interval_intr8 =  cntr_ctrl_reg8[1] & (count_val8 == 16'h0000)
      & (counting8) & ~cntr_ctrl_reg8[4] & ~cntr_ctrl_reg8[0];
   assign overflow_intr8 = ~cntr_ctrl_reg8[1] & (count_val8 == 16'h0000)
      & (counting8) & ~cntr_ctrl_reg8[4] & ~cntr_ctrl_reg8[0];
   assign match_intr8[1]  =  cntr_ctrl_reg8[3] & (count_val8 == match_1_reg8)
      & (counting8) & ~cntr_ctrl_reg8[4] & ~cntr_ctrl_reg8[0];
   assign match_intr8[2]  =  cntr_ctrl_reg8[3] & (count_val8 == match_2_reg8)
      & (counting8) & ~cntr_ctrl_reg8[4] & ~cntr_ctrl_reg8[0];
   assign match_intr8[3]  =  cntr_ctrl_reg8[3] & (count_val8 == match_3_reg8)
      & (counting8) & ~cntr_ctrl_reg8[4] & ~cntr_ctrl_reg8[0];


//    p_reg_ctrl8: Process8 to write to the counter control8 registers
//    cntr_ctrl_reg8 decode:  0 - Counter8 Enable8 Active8 Low8
//                           1 - Interval8 Mode8 =1, Overflow8 =0
//                           2 - Decrement8 Mode8
//                           3 - Match8 Mode8
//                           4 - Restart8
//                           5 - Waveform8 enable active low8
//                           6 - Waveform8 polarity8
   
   always @ (posedge pclk8 or negedge n_p_reset8)
   begin: p_reg_ctrl8  // Register writes
      
      if (!n_p_reset8)                                   
      begin                                     
         cntr_ctrl_reg8 <= 7'b0000001;
         interval_reg8  <= 16'h0000;
         match_1_reg8   <= 16'h0000;
         match_2_reg8   <= 16'h0000;
         match_3_reg8   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel8)
            cntr_ctrl_reg8 <= pwdata8[6:0];
         else if (restart_temp8)
            cntr_ctrl_reg8[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg8 <= cntr_ctrl_reg8;             

         interval_reg8  <= (interval_reg_sel8) ? pwdata8 : interval_reg8;
         match_1_reg8   <= (match_1_reg_sel8)  ? pwdata8 : match_1_reg8;
         match_2_reg8   <= (match_2_reg_sel8)  ? pwdata8 : match_2_reg8;
         match_3_reg8   <= (match_3_reg_sel8)  ? pwdata8 : match_3_reg8;   
      end
      
   end  //p_reg_ctrl8

   
//    p_cntr8: Process8 to increment or decrement the counter on receiving8 a 
//            count_en8 signal8 from the pre_scaler8. Count8 can be restarted8
//            or disabled and can overflow8 at a specified interval8 value.
   
   
   always @ (posedge pclk8 or negedge n_p_reset8)
   begin: p_cntr8   // Counter8 block

      if (!n_p_reset8)     //System8 Reset8
      begin                     
         count_val8 <= 16'h0000;
         counting8  <= 1'b0;
         restart_temp8 <= 1'b0;
      end
      else if (count_en8)
      begin
         
         if (cntr_ctrl_reg8[4])     //Restart8
         begin     
            if (~cntr_ctrl_reg8[2])  
               count_val8         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg8[1])
                 count_val8         <= interval_reg8;     
              else
                 count_val8         <= 16'hFFFF;     
            end
            counting8       <= 1'b0;
            restart_temp8   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg8[0])          //Low8 Active8 Counter8 Enable8
            begin

               if (cntr_ctrl_reg8[1])  //Interval8               
                  if (cntr_ctrl_reg8[2])  //Decrement8        
                  begin
                     if (count_val8 == 16'h0000)
                        count_val8 <= interval_reg8;  //Assumed8 Static8
                     else
                        count_val8 <= count_val8 - 16'h0001;
                  end
                  else                   //Increment8
                  begin
                     if (count_val8 == interval_reg8)
                        count_val8 <= 16'h0000;
                     else           
                        count_val8 <= count_val8 + 16'h0001;
                  end
               else    
               begin  //Overflow8
                  if (cntr_ctrl_reg8[2])   //Decrement8
                  begin
                     if (count_val8 == 16'h0000)
                        count_val8 <= 16'hFFFF;
                     else           
                        count_val8 <= count_val8 - 16'h0001;
                  end
                  else                    //Increment8
                  begin
                     if (count_val8 == 16'hFFFF)
                        count_val8 <= 16'h0000;
                     else           
                        count_val8 <= count_val8 + 16'h0001;
                  end 
               end
               counting8  <= 1'b1;
            end     
            else
               count_val8 <= count_val8;   //Disabled8
   
            restart_temp8 <= 1'b0;
      
         end
     
      end // if (count_en8)

      else
      begin
         count_val8    <= count_val8;
         counting8     <= counting8;
         restart_temp8 <= restart_temp8;               
      end
     
   end  //p_cntr8

endmodule
