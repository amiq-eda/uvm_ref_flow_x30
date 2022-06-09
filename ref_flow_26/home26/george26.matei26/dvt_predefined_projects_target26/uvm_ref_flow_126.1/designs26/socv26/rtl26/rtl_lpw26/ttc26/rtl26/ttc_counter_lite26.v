//File26 name   : ttc_counter_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 :The counter can increment and decrement.
//   In increment mode instead of counting26 to its full 16 bit
//   value the counter counts26 up to or down from a programmed26 interval26 value.
//   Interrupts26 are issued26 when the counter overflows26 or reaches26 it's interval26
//   value. In match mode if the count value equals26 that stored26 in one of three26
//   match registers an interrupt26 is issued26.
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------
//


module ttc_counter_lite26(

  //inputs26
  n_p_reset26,    
  pclk26,          
  pwdata26,              
  count_en26,
  cntr_ctrl_reg_sel26, 
  interval_reg_sel26,
  match_1_reg_sel26,
  match_2_reg_sel26,
  match_3_reg_sel26,         

  //outputs26    
  count_val_out26,
  cntr_ctrl_reg_out26,
  interval_reg_out26,
  match_1_reg_out26,
  match_2_reg_out26,
  match_3_reg_out26,
  interval_intr26,
  match_intr26,
  overflow_intr26

);


//--------------------------------------------------------------------
// PORT DECLARATIONS26
//--------------------------------------------------------------------

   //inputs26
   input          n_p_reset26;         //reset signal26
   input          pclk26;              //System26 Clock26
   input [15:0]   pwdata26;            //6 Bit26 data signal26
   input          count_en26;          //Count26 enable signal26
   input          cntr_ctrl_reg_sel26; //Select26 bit for ctrl_reg26
   input          interval_reg_sel26;  //Interval26 Select26 Register
   input          match_1_reg_sel26;   //Match26 1 Select26 register
   input          match_2_reg_sel26;   //Match26 2 Select26 register
   input          match_3_reg_sel26;   //Match26 3 Select26 register

   //outputs26
   output [15:0]  count_val_out26;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out26;    //Counter26 control26 reg select26
   output [15:0]  interval_reg_out26;     //Interval26 reg
   output [15:0]  match_1_reg_out26;      //Match26 1 register
   output [15:0]  match_2_reg_out26;      //Match26 2 register
   output [15:0]  match_3_reg_out26;      //Match26 3 register
   output         interval_intr26;        //Interval26 interrupt26
   output [3:1]   match_intr26;           //Match26 interrupt26
   output         overflow_intr26;        //Overflow26 interrupt26

//--------------------------------------------------------------------
// Internal Signals26 & Registers26
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg26;     // 5-bit Counter26 Control26 Register
   reg [15:0]     interval_reg26;      //16-bit Interval26 Register 
   reg [15:0]     match_1_reg26;       //16-bit Match_126 Register
   reg [15:0]     match_2_reg26;       //16-bit Match_226 Register
   reg [15:0]     match_3_reg26;       //16-bit Match_326 Register
   reg [15:0]     count_val26;         //16-bit counter value register
                                                                      
   
   reg            counting26;          //counter has starting counting26
   reg            restart_temp26;   //ensures26 soft26 reset lasts26 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out26; //7-bit Counter26 Control26 Register
   wire [15:0]    interval_reg_out26;  //16-bit Interval26 Register 
   wire [15:0]    match_1_reg_out26;   //16-bit Match_126 Register
   wire [15:0]    match_2_reg_out26;   //16-bit Match_226 Register
   wire [15:0]    match_3_reg_out26;   //16-bit Match_326 Register
   wire [15:0]    count_val_out26;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign26 output wires26
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out26 = cntr_ctrl_reg26;    // 7-bit Counter26 Control26
   assign interval_reg_out26  = interval_reg26;     // 16-bit Interval26
   assign match_1_reg_out26   = match_1_reg26;      // 16-bit Match_126
   assign match_2_reg_out26   = match_2_reg26;      // 16-bit Match_226 
   assign match_3_reg_out26   = match_3_reg26;      // 16-bit Match_326 
   assign count_val_out26     = count_val26;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning26 interrupts26
//--------------------------------------------------------------------

   assign interval_intr26 =  cntr_ctrl_reg26[1] & (count_val26 == 16'h0000)
      & (counting26) & ~cntr_ctrl_reg26[4] & ~cntr_ctrl_reg26[0];
   assign overflow_intr26 = ~cntr_ctrl_reg26[1] & (count_val26 == 16'h0000)
      & (counting26) & ~cntr_ctrl_reg26[4] & ~cntr_ctrl_reg26[0];
   assign match_intr26[1]  =  cntr_ctrl_reg26[3] & (count_val26 == match_1_reg26)
      & (counting26) & ~cntr_ctrl_reg26[4] & ~cntr_ctrl_reg26[0];
   assign match_intr26[2]  =  cntr_ctrl_reg26[3] & (count_val26 == match_2_reg26)
      & (counting26) & ~cntr_ctrl_reg26[4] & ~cntr_ctrl_reg26[0];
   assign match_intr26[3]  =  cntr_ctrl_reg26[3] & (count_val26 == match_3_reg26)
      & (counting26) & ~cntr_ctrl_reg26[4] & ~cntr_ctrl_reg26[0];


//    p_reg_ctrl26: Process26 to write to the counter control26 registers
//    cntr_ctrl_reg26 decode:  0 - Counter26 Enable26 Active26 Low26
//                           1 - Interval26 Mode26 =1, Overflow26 =0
//                           2 - Decrement26 Mode26
//                           3 - Match26 Mode26
//                           4 - Restart26
//                           5 - Waveform26 enable active low26
//                           6 - Waveform26 polarity26
   
   always @ (posedge pclk26 or negedge n_p_reset26)
   begin: p_reg_ctrl26  // Register writes
      
      if (!n_p_reset26)                                   
      begin                                     
         cntr_ctrl_reg26 <= 7'b0000001;
         interval_reg26  <= 16'h0000;
         match_1_reg26   <= 16'h0000;
         match_2_reg26   <= 16'h0000;
         match_3_reg26   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel26)
            cntr_ctrl_reg26 <= pwdata26[6:0];
         else if (restart_temp26)
            cntr_ctrl_reg26[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg26 <= cntr_ctrl_reg26;             

         interval_reg26  <= (interval_reg_sel26) ? pwdata26 : interval_reg26;
         match_1_reg26   <= (match_1_reg_sel26)  ? pwdata26 : match_1_reg26;
         match_2_reg26   <= (match_2_reg_sel26)  ? pwdata26 : match_2_reg26;
         match_3_reg26   <= (match_3_reg_sel26)  ? pwdata26 : match_3_reg26;   
      end
      
   end  //p_reg_ctrl26

   
//    p_cntr26: Process26 to increment or decrement the counter on receiving26 a 
//            count_en26 signal26 from the pre_scaler26. Count26 can be restarted26
//            or disabled and can overflow26 at a specified interval26 value.
   
   
   always @ (posedge pclk26 or negedge n_p_reset26)
   begin: p_cntr26   // Counter26 block

      if (!n_p_reset26)     //System26 Reset26
      begin                     
         count_val26 <= 16'h0000;
         counting26  <= 1'b0;
         restart_temp26 <= 1'b0;
      end
      else if (count_en26)
      begin
         
         if (cntr_ctrl_reg26[4])     //Restart26
         begin     
            if (~cntr_ctrl_reg26[2])  
               count_val26         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg26[1])
                 count_val26         <= interval_reg26;     
              else
                 count_val26         <= 16'hFFFF;     
            end
            counting26       <= 1'b0;
            restart_temp26   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg26[0])          //Low26 Active26 Counter26 Enable26
            begin

               if (cntr_ctrl_reg26[1])  //Interval26               
                  if (cntr_ctrl_reg26[2])  //Decrement26        
                  begin
                     if (count_val26 == 16'h0000)
                        count_val26 <= interval_reg26;  //Assumed26 Static26
                     else
                        count_val26 <= count_val26 - 16'h0001;
                  end
                  else                   //Increment26
                  begin
                     if (count_val26 == interval_reg26)
                        count_val26 <= 16'h0000;
                     else           
                        count_val26 <= count_val26 + 16'h0001;
                  end
               else    
               begin  //Overflow26
                  if (cntr_ctrl_reg26[2])   //Decrement26
                  begin
                     if (count_val26 == 16'h0000)
                        count_val26 <= 16'hFFFF;
                     else           
                        count_val26 <= count_val26 - 16'h0001;
                  end
                  else                    //Increment26
                  begin
                     if (count_val26 == 16'hFFFF)
                        count_val26 <= 16'h0000;
                     else           
                        count_val26 <= count_val26 + 16'h0001;
                  end 
               end
               counting26  <= 1'b1;
            end     
            else
               count_val26 <= count_val26;   //Disabled26
   
            restart_temp26 <= 1'b0;
      
         end
     
      end // if (count_en26)

      else
      begin
         count_val26    <= count_val26;
         counting26     <= counting26;
         restart_temp26 <= restart_temp26;               
      end
     
   end  //p_cntr26

endmodule
