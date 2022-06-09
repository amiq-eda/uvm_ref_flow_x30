//File19 name   : ttc_counter_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 :The counter can increment and decrement.
//   In increment mode instead of counting19 to its full 16 bit
//   value the counter counts19 up to or down from a programmed19 interval19 value.
//   Interrupts19 are issued19 when the counter overflows19 or reaches19 it's interval19
//   value. In match mode if the count value equals19 that stored19 in one of three19
//   match registers an interrupt19 is issued19.
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------
//


module ttc_counter_lite19(

  //inputs19
  n_p_reset19,    
  pclk19,          
  pwdata19,              
  count_en19,
  cntr_ctrl_reg_sel19, 
  interval_reg_sel19,
  match_1_reg_sel19,
  match_2_reg_sel19,
  match_3_reg_sel19,         

  //outputs19    
  count_val_out19,
  cntr_ctrl_reg_out19,
  interval_reg_out19,
  match_1_reg_out19,
  match_2_reg_out19,
  match_3_reg_out19,
  interval_intr19,
  match_intr19,
  overflow_intr19

);


//--------------------------------------------------------------------
// PORT DECLARATIONS19
//--------------------------------------------------------------------

   //inputs19
   input          n_p_reset19;         //reset signal19
   input          pclk19;              //System19 Clock19
   input [15:0]   pwdata19;            //6 Bit19 data signal19
   input          count_en19;          //Count19 enable signal19
   input          cntr_ctrl_reg_sel19; //Select19 bit for ctrl_reg19
   input          interval_reg_sel19;  //Interval19 Select19 Register
   input          match_1_reg_sel19;   //Match19 1 Select19 register
   input          match_2_reg_sel19;   //Match19 2 Select19 register
   input          match_3_reg_sel19;   //Match19 3 Select19 register

   //outputs19
   output [15:0]  count_val_out19;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out19;    //Counter19 control19 reg select19
   output [15:0]  interval_reg_out19;     //Interval19 reg
   output [15:0]  match_1_reg_out19;      //Match19 1 register
   output [15:0]  match_2_reg_out19;      //Match19 2 register
   output [15:0]  match_3_reg_out19;      //Match19 3 register
   output         interval_intr19;        //Interval19 interrupt19
   output [3:1]   match_intr19;           //Match19 interrupt19
   output         overflow_intr19;        //Overflow19 interrupt19

//--------------------------------------------------------------------
// Internal Signals19 & Registers19
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg19;     // 5-bit Counter19 Control19 Register
   reg [15:0]     interval_reg19;      //16-bit Interval19 Register 
   reg [15:0]     match_1_reg19;       //16-bit Match_119 Register
   reg [15:0]     match_2_reg19;       //16-bit Match_219 Register
   reg [15:0]     match_3_reg19;       //16-bit Match_319 Register
   reg [15:0]     count_val19;         //16-bit counter value register
                                                                      
   
   reg            counting19;          //counter has starting counting19
   reg            restart_temp19;   //ensures19 soft19 reset lasts19 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out19; //7-bit Counter19 Control19 Register
   wire [15:0]    interval_reg_out19;  //16-bit Interval19 Register 
   wire [15:0]    match_1_reg_out19;   //16-bit Match_119 Register
   wire [15:0]    match_2_reg_out19;   //16-bit Match_219 Register
   wire [15:0]    match_3_reg_out19;   //16-bit Match_319 Register
   wire [15:0]    count_val_out19;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign19 output wires19
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out19 = cntr_ctrl_reg19;    // 7-bit Counter19 Control19
   assign interval_reg_out19  = interval_reg19;     // 16-bit Interval19
   assign match_1_reg_out19   = match_1_reg19;      // 16-bit Match_119
   assign match_2_reg_out19   = match_2_reg19;      // 16-bit Match_219 
   assign match_3_reg_out19   = match_3_reg19;      // 16-bit Match_319 
   assign count_val_out19     = count_val19;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning19 interrupts19
//--------------------------------------------------------------------

   assign interval_intr19 =  cntr_ctrl_reg19[1] & (count_val19 == 16'h0000)
      & (counting19) & ~cntr_ctrl_reg19[4] & ~cntr_ctrl_reg19[0];
   assign overflow_intr19 = ~cntr_ctrl_reg19[1] & (count_val19 == 16'h0000)
      & (counting19) & ~cntr_ctrl_reg19[4] & ~cntr_ctrl_reg19[0];
   assign match_intr19[1]  =  cntr_ctrl_reg19[3] & (count_val19 == match_1_reg19)
      & (counting19) & ~cntr_ctrl_reg19[4] & ~cntr_ctrl_reg19[0];
   assign match_intr19[2]  =  cntr_ctrl_reg19[3] & (count_val19 == match_2_reg19)
      & (counting19) & ~cntr_ctrl_reg19[4] & ~cntr_ctrl_reg19[0];
   assign match_intr19[3]  =  cntr_ctrl_reg19[3] & (count_val19 == match_3_reg19)
      & (counting19) & ~cntr_ctrl_reg19[4] & ~cntr_ctrl_reg19[0];


//    p_reg_ctrl19: Process19 to write to the counter control19 registers
//    cntr_ctrl_reg19 decode:  0 - Counter19 Enable19 Active19 Low19
//                           1 - Interval19 Mode19 =1, Overflow19 =0
//                           2 - Decrement19 Mode19
//                           3 - Match19 Mode19
//                           4 - Restart19
//                           5 - Waveform19 enable active low19
//                           6 - Waveform19 polarity19
   
   always @ (posedge pclk19 or negedge n_p_reset19)
   begin: p_reg_ctrl19  // Register writes
      
      if (!n_p_reset19)                                   
      begin                                     
         cntr_ctrl_reg19 <= 7'b0000001;
         interval_reg19  <= 16'h0000;
         match_1_reg19   <= 16'h0000;
         match_2_reg19   <= 16'h0000;
         match_3_reg19   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel19)
            cntr_ctrl_reg19 <= pwdata19[6:0];
         else if (restart_temp19)
            cntr_ctrl_reg19[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg19 <= cntr_ctrl_reg19;             

         interval_reg19  <= (interval_reg_sel19) ? pwdata19 : interval_reg19;
         match_1_reg19   <= (match_1_reg_sel19)  ? pwdata19 : match_1_reg19;
         match_2_reg19   <= (match_2_reg_sel19)  ? pwdata19 : match_2_reg19;
         match_3_reg19   <= (match_3_reg_sel19)  ? pwdata19 : match_3_reg19;   
      end
      
   end  //p_reg_ctrl19

   
//    p_cntr19: Process19 to increment or decrement the counter on receiving19 a 
//            count_en19 signal19 from the pre_scaler19. Count19 can be restarted19
//            or disabled and can overflow19 at a specified interval19 value.
   
   
   always @ (posedge pclk19 or negedge n_p_reset19)
   begin: p_cntr19   // Counter19 block

      if (!n_p_reset19)     //System19 Reset19
      begin                     
         count_val19 <= 16'h0000;
         counting19  <= 1'b0;
         restart_temp19 <= 1'b0;
      end
      else if (count_en19)
      begin
         
         if (cntr_ctrl_reg19[4])     //Restart19
         begin     
            if (~cntr_ctrl_reg19[2])  
               count_val19         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg19[1])
                 count_val19         <= interval_reg19;     
              else
                 count_val19         <= 16'hFFFF;     
            end
            counting19       <= 1'b0;
            restart_temp19   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg19[0])          //Low19 Active19 Counter19 Enable19
            begin

               if (cntr_ctrl_reg19[1])  //Interval19               
                  if (cntr_ctrl_reg19[2])  //Decrement19        
                  begin
                     if (count_val19 == 16'h0000)
                        count_val19 <= interval_reg19;  //Assumed19 Static19
                     else
                        count_val19 <= count_val19 - 16'h0001;
                  end
                  else                   //Increment19
                  begin
                     if (count_val19 == interval_reg19)
                        count_val19 <= 16'h0000;
                     else           
                        count_val19 <= count_val19 + 16'h0001;
                  end
               else    
               begin  //Overflow19
                  if (cntr_ctrl_reg19[2])   //Decrement19
                  begin
                     if (count_val19 == 16'h0000)
                        count_val19 <= 16'hFFFF;
                     else           
                        count_val19 <= count_val19 - 16'h0001;
                  end
                  else                    //Increment19
                  begin
                     if (count_val19 == 16'hFFFF)
                        count_val19 <= 16'h0000;
                     else           
                        count_val19 <= count_val19 + 16'h0001;
                  end 
               end
               counting19  <= 1'b1;
            end     
            else
               count_val19 <= count_val19;   //Disabled19
   
            restart_temp19 <= 1'b0;
      
         end
     
      end // if (count_en19)

      else
      begin
         count_val19    <= count_val19;
         counting19     <= counting19;
         restart_temp19 <= restart_temp19;               
      end
     
   end  //p_cntr19

endmodule
