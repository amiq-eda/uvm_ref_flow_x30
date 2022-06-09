//File13 name   : ttc_counter_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 :The counter can increment and decrement.
//   In increment mode instead of counting13 to its full 16 bit
//   value the counter counts13 up to or down from a programmed13 interval13 value.
//   Interrupts13 are issued13 when the counter overflows13 or reaches13 it's interval13
//   value. In match mode if the count value equals13 that stored13 in one of three13
//   match registers an interrupt13 is issued13.
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
//


module ttc_counter_lite13(

  //inputs13
  n_p_reset13,    
  pclk13,          
  pwdata13,              
  count_en13,
  cntr_ctrl_reg_sel13, 
  interval_reg_sel13,
  match_1_reg_sel13,
  match_2_reg_sel13,
  match_3_reg_sel13,         

  //outputs13    
  count_val_out13,
  cntr_ctrl_reg_out13,
  interval_reg_out13,
  match_1_reg_out13,
  match_2_reg_out13,
  match_3_reg_out13,
  interval_intr13,
  match_intr13,
  overflow_intr13

);


//--------------------------------------------------------------------
// PORT DECLARATIONS13
//--------------------------------------------------------------------

   //inputs13
   input          n_p_reset13;         //reset signal13
   input          pclk13;              //System13 Clock13
   input [15:0]   pwdata13;            //6 Bit13 data signal13
   input          count_en13;          //Count13 enable signal13
   input          cntr_ctrl_reg_sel13; //Select13 bit for ctrl_reg13
   input          interval_reg_sel13;  //Interval13 Select13 Register
   input          match_1_reg_sel13;   //Match13 1 Select13 register
   input          match_2_reg_sel13;   //Match13 2 Select13 register
   input          match_3_reg_sel13;   //Match13 3 Select13 register

   //outputs13
   output [15:0]  count_val_out13;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out13;    //Counter13 control13 reg select13
   output [15:0]  interval_reg_out13;     //Interval13 reg
   output [15:0]  match_1_reg_out13;      //Match13 1 register
   output [15:0]  match_2_reg_out13;      //Match13 2 register
   output [15:0]  match_3_reg_out13;      //Match13 3 register
   output         interval_intr13;        //Interval13 interrupt13
   output [3:1]   match_intr13;           //Match13 interrupt13
   output         overflow_intr13;        //Overflow13 interrupt13

//--------------------------------------------------------------------
// Internal Signals13 & Registers13
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg13;     // 5-bit Counter13 Control13 Register
   reg [15:0]     interval_reg13;      //16-bit Interval13 Register 
   reg [15:0]     match_1_reg13;       //16-bit Match_113 Register
   reg [15:0]     match_2_reg13;       //16-bit Match_213 Register
   reg [15:0]     match_3_reg13;       //16-bit Match_313 Register
   reg [15:0]     count_val13;         //16-bit counter value register
                                                                      
   
   reg            counting13;          //counter has starting counting13
   reg            restart_temp13;   //ensures13 soft13 reset lasts13 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out13; //7-bit Counter13 Control13 Register
   wire [15:0]    interval_reg_out13;  //16-bit Interval13 Register 
   wire [15:0]    match_1_reg_out13;   //16-bit Match_113 Register
   wire [15:0]    match_2_reg_out13;   //16-bit Match_213 Register
   wire [15:0]    match_3_reg_out13;   //16-bit Match_313 Register
   wire [15:0]    count_val_out13;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign13 output wires13
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out13 = cntr_ctrl_reg13;    // 7-bit Counter13 Control13
   assign interval_reg_out13  = interval_reg13;     // 16-bit Interval13
   assign match_1_reg_out13   = match_1_reg13;      // 16-bit Match_113
   assign match_2_reg_out13   = match_2_reg13;      // 16-bit Match_213 
   assign match_3_reg_out13   = match_3_reg13;      // 16-bit Match_313 
   assign count_val_out13     = count_val13;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning13 interrupts13
//--------------------------------------------------------------------

   assign interval_intr13 =  cntr_ctrl_reg13[1] & (count_val13 == 16'h0000)
      & (counting13) & ~cntr_ctrl_reg13[4] & ~cntr_ctrl_reg13[0];
   assign overflow_intr13 = ~cntr_ctrl_reg13[1] & (count_val13 == 16'h0000)
      & (counting13) & ~cntr_ctrl_reg13[4] & ~cntr_ctrl_reg13[0];
   assign match_intr13[1]  =  cntr_ctrl_reg13[3] & (count_val13 == match_1_reg13)
      & (counting13) & ~cntr_ctrl_reg13[4] & ~cntr_ctrl_reg13[0];
   assign match_intr13[2]  =  cntr_ctrl_reg13[3] & (count_val13 == match_2_reg13)
      & (counting13) & ~cntr_ctrl_reg13[4] & ~cntr_ctrl_reg13[0];
   assign match_intr13[3]  =  cntr_ctrl_reg13[3] & (count_val13 == match_3_reg13)
      & (counting13) & ~cntr_ctrl_reg13[4] & ~cntr_ctrl_reg13[0];


//    p_reg_ctrl13: Process13 to write to the counter control13 registers
//    cntr_ctrl_reg13 decode:  0 - Counter13 Enable13 Active13 Low13
//                           1 - Interval13 Mode13 =1, Overflow13 =0
//                           2 - Decrement13 Mode13
//                           3 - Match13 Mode13
//                           4 - Restart13
//                           5 - Waveform13 enable active low13
//                           6 - Waveform13 polarity13
   
   always @ (posedge pclk13 or negedge n_p_reset13)
   begin: p_reg_ctrl13  // Register writes
      
      if (!n_p_reset13)                                   
      begin                                     
         cntr_ctrl_reg13 <= 7'b0000001;
         interval_reg13  <= 16'h0000;
         match_1_reg13   <= 16'h0000;
         match_2_reg13   <= 16'h0000;
         match_3_reg13   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel13)
            cntr_ctrl_reg13 <= pwdata13[6:0];
         else if (restart_temp13)
            cntr_ctrl_reg13[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg13 <= cntr_ctrl_reg13;             

         interval_reg13  <= (interval_reg_sel13) ? pwdata13 : interval_reg13;
         match_1_reg13   <= (match_1_reg_sel13)  ? pwdata13 : match_1_reg13;
         match_2_reg13   <= (match_2_reg_sel13)  ? pwdata13 : match_2_reg13;
         match_3_reg13   <= (match_3_reg_sel13)  ? pwdata13 : match_3_reg13;   
      end
      
   end  //p_reg_ctrl13

   
//    p_cntr13: Process13 to increment or decrement the counter on receiving13 a 
//            count_en13 signal13 from the pre_scaler13. Count13 can be restarted13
//            or disabled and can overflow13 at a specified interval13 value.
   
   
   always @ (posedge pclk13 or negedge n_p_reset13)
   begin: p_cntr13   // Counter13 block

      if (!n_p_reset13)     //System13 Reset13
      begin                     
         count_val13 <= 16'h0000;
         counting13  <= 1'b0;
         restart_temp13 <= 1'b0;
      end
      else if (count_en13)
      begin
         
         if (cntr_ctrl_reg13[4])     //Restart13
         begin     
            if (~cntr_ctrl_reg13[2])  
               count_val13         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg13[1])
                 count_val13         <= interval_reg13;     
              else
                 count_val13         <= 16'hFFFF;     
            end
            counting13       <= 1'b0;
            restart_temp13   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg13[0])          //Low13 Active13 Counter13 Enable13
            begin

               if (cntr_ctrl_reg13[1])  //Interval13               
                  if (cntr_ctrl_reg13[2])  //Decrement13        
                  begin
                     if (count_val13 == 16'h0000)
                        count_val13 <= interval_reg13;  //Assumed13 Static13
                     else
                        count_val13 <= count_val13 - 16'h0001;
                  end
                  else                   //Increment13
                  begin
                     if (count_val13 == interval_reg13)
                        count_val13 <= 16'h0000;
                     else           
                        count_val13 <= count_val13 + 16'h0001;
                  end
               else    
               begin  //Overflow13
                  if (cntr_ctrl_reg13[2])   //Decrement13
                  begin
                     if (count_val13 == 16'h0000)
                        count_val13 <= 16'hFFFF;
                     else           
                        count_val13 <= count_val13 - 16'h0001;
                  end
                  else                    //Increment13
                  begin
                     if (count_val13 == 16'hFFFF)
                        count_val13 <= 16'h0000;
                     else           
                        count_val13 <= count_val13 + 16'h0001;
                  end 
               end
               counting13  <= 1'b1;
            end     
            else
               count_val13 <= count_val13;   //Disabled13
   
            restart_temp13 <= 1'b0;
      
         end
     
      end // if (count_en13)

      else
      begin
         count_val13    <= count_val13;
         counting13     <= counting13;
         restart_temp13 <= restart_temp13;               
      end
     
   end  //p_cntr13

endmodule
