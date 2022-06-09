//File11 name   : ttc_counter_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 :The counter can increment and decrement.
//   In increment mode instead of counting11 to its full 16 bit
//   value the counter counts11 up to or down from a programmed11 interval11 value.
//   Interrupts11 are issued11 when the counter overflows11 or reaches11 it's interval11
//   value. In match mode if the count value equals11 that stored11 in one of three11
//   match registers an interrupt11 is issued11.
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
//


module ttc_counter_lite11(

  //inputs11
  n_p_reset11,    
  pclk11,          
  pwdata11,              
  count_en11,
  cntr_ctrl_reg_sel11, 
  interval_reg_sel11,
  match_1_reg_sel11,
  match_2_reg_sel11,
  match_3_reg_sel11,         

  //outputs11    
  count_val_out11,
  cntr_ctrl_reg_out11,
  interval_reg_out11,
  match_1_reg_out11,
  match_2_reg_out11,
  match_3_reg_out11,
  interval_intr11,
  match_intr11,
  overflow_intr11

);


//--------------------------------------------------------------------
// PORT DECLARATIONS11
//--------------------------------------------------------------------

   //inputs11
   input          n_p_reset11;         //reset signal11
   input          pclk11;              //System11 Clock11
   input [15:0]   pwdata11;            //6 Bit11 data signal11
   input          count_en11;          //Count11 enable signal11
   input          cntr_ctrl_reg_sel11; //Select11 bit for ctrl_reg11
   input          interval_reg_sel11;  //Interval11 Select11 Register
   input          match_1_reg_sel11;   //Match11 1 Select11 register
   input          match_2_reg_sel11;   //Match11 2 Select11 register
   input          match_3_reg_sel11;   //Match11 3 Select11 register

   //outputs11
   output [15:0]  count_val_out11;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out11;    //Counter11 control11 reg select11
   output [15:0]  interval_reg_out11;     //Interval11 reg
   output [15:0]  match_1_reg_out11;      //Match11 1 register
   output [15:0]  match_2_reg_out11;      //Match11 2 register
   output [15:0]  match_3_reg_out11;      //Match11 3 register
   output         interval_intr11;        //Interval11 interrupt11
   output [3:1]   match_intr11;           //Match11 interrupt11
   output         overflow_intr11;        //Overflow11 interrupt11

//--------------------------------------------------------------------
// Internal Signals11 & Registers11
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg11;     // 5-bit Counter11 Control11 Register
   reg [15:0]     interval_reg11;      //16-bit Interval11 Register 
   reg [15:0]     match_1_reg11;       //16-bit Match_111 Register
   reg [15:0]     match_2_reg11;       //16-bit Match_211 Register
   reg [15:0]     match_3_reg11;       //16-bit Match_311 Register
   reg [15:0]     count_val11;         //16-bit counter value register
                                                                      
   
   reg            counting11;          //counter has starting counting11
   reg            restart_temp11;   //ensures11 soft11 reset lasts11 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out11; //7-bit Counter11 Control11 Register
   wire [15:0]    interval_reg_out11;  //16-bit Interval11 Register 
   wire [15:0]    match_1_reg_out11;   //16-bit Match_111 Register
   wire [15:0]    match_2_reg_out11;   //16-bit Match_211 Register
   wire [15:0]    match_3_reg_out11;   //16-bit Match_311 Register
   wire [15:0]    count_val_out11;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign11 output wires11
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out11 = cntr_ctrl_reg11;    // 7-bit Counter11 Control11
   assign interval_reg_out11  = interval_reg11;     // 16-bit Interval11
   assign match_1_reg_out11   = match_1_reg11;      // 16-bit Match_111
   assign match_2_reg_out11   = match_2_reg11;      // 16-bit Match_211 
   assign match_3_reg_out11   = match_3_reg11;      // 16-bit Match_311 
   assign count_val_out11     = count_val11;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning11 interrupts11
//--------------------------------------------------------------------

   assign interval_intr11 =  cntr_ctrl_reg11[1] & (count_val11 == 16'h0000)
      & (counting11) & ~cntr_ctrl_reg11[4] & ~cntr_ctrl_reg11[0];
   assign overflow_intr11 = ~cntr_ctrl_reg11[1] & (count_val11 == 16'h0000)
      & (counting11) & ~cntr_ctrl_reg11[4] & ~cntr_ctrl_reg11[0];
   assign match_intr11[1]  =  cntr_ctrl_reg11[3] & (count_val11 == match_1_reg11)
      & (counting11) & ~cntr_ctrl_reg11[4] & ~cntr_ctrl_reg11[0];
   assign match_intr11[2]  =  cntr_ctrl_reg11[3] & (count_val11 == match_2_reg11)
      & (counting11) & ~cntr_ctrl_reg11[4] & ~cntr_ctrl_reg11[0];
   assign match_intr11[3]  =  cntr_ctrl_reg11[3] & (count_val11 == match_3_reg11)
      & (counting11) & ~cntr_ctrl_reg11[4] & ~cntr_ctrl_reg11[0];


//    p_reg_ctrl11: Process11 to write to the counter control11 registers
//    cntr_ctrl_reg11 decode:  0 - Counter11 Enable11 Active11 Low11
//                           1 - Interval11 Mode11 =1, Overflow11 =0
//                           2 - Decrement11 Mode11
//                           3 - Match11 Mode11
//                           4 - Restart11
//                           5 - Waveform11 enable active low11
//                           6 - Waveform11 polarity11
   
   always @ (posedge pclk11 or negedge n_p_reset11)
   begin: p_reg_ctrl11  // Register writes
      
      if (!n_p_reset11)                                   
      begin                                     
         cntr_ctrl_reg11 <= 7'b0000001;
         interval_reg11  <= 16'h0000;
         match_1_reg11   <= 16'h0000;
         match_2_reg11   <= 16'h0000;
         match_3_reg11   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel11)
            cntr_ctrl_reg11 <= pwdata11[6:0];
         else if (restart_temp11)
            cntr_ctrl_reg11[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg11 <= cntr_ctrl_reg11;             

         interval_reg11  <= (interval_reg_sel11) ? pwdata11 : interval_reg11;
         match_1_reg11   <= (match_1_reg_sel11)  ? pwdata11 : match_1_reg11;
         match_2_reg11   <= (match_2_reg_sel11)  ? pwdata11 : match_2_reg11;
         match_3_reg11   <= (match_3_reg_sel11)  ? pwdata11 : match_3_reg11;   
      end
      
   end  //p_reg_ctrl11

   
//    p_cntr11: Process11 to increment or decrement the counter on receiving11 a 
//            count_en11 signal11 from the pre_scaler11. Count11 can be restarted11
//            or disabled and can overflow11 at a specified interval11 value.
   
   
   always @ (posedge pclk11 or negedge n_p_reset11)
   begin: p_cntr11   // Counter11 block

      if (!n_p_reset11)     //System11 Reset11
      begin                     
         count_val11 <= 16'h0000;
         counting11  <= 1'b0;
         restart_temp11 <= 1'b0;
      end
      else if (count_en11)
      begin
         
         if (cntr_ctrl_reg11[4])     //Restart11
         begin     
            if (~cntr_ctrl_reg11[2])  
               count_val11         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg11[1])
                 count_val11         <= interval_reg11;     
              else
                 count_val11         <= 16'hFFFF;     
            end
            counting11       <= 1'b0;
            restart_temp11   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg11[0])          //Low11 Active11 Counter11 Enable11
            begin

               if (cntr_ctrl_reg11[1])  //Interval11               
                  if (cntr_ctrl_reg11[2])  //Decrement11        
                  begin
                     if (count_val11 == 16'h0000)
                        count_val11 <= interval_reg11;  //Assumed11 Static11
                     else
                        count_val11 <= count_val11 - 16'h0001;
                  end
                  else                   //Increment11
                  begin
                     if (count_val11 == interval_reg11)
                        count_val11 <= 16'h0000;
                     else           
                        count_val11 <= count_val11 + 16'h0001;
                  end
               else    
               begin  //Overflow11
                  if (cntr_ctrl_reg11[2])   //Decrement11
                  begin
                     if (count_val11 == 16'h0000)
                        count_val11 <= 16'hFFFF;
                     else           
                        count_val11 <= count_val11 - 16'h0001;
                  end
                  else                    //Increment11
                  begin
                     if (count_val11 == 16'hFFFF)
                        count_val11 <= 16'h0000;
                     else           
                        count_val11 <= count_val11 + 16'h0001;
                  end 
               end
               counting11  <= 1'b1;
            end     
            else
               count_val11 <= count_val11;   //Disabled11
   
            restart_temp11 <= 1'b0;
      
         end
     
      end // if (count_en11)

      else
      begin
         count_val11    <= count_val11;
         counting11     <= counting11;
         restart_temp11 <= restart_temp11;               
      end
     
   end  //p_cntr11

endmodule
