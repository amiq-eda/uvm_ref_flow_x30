//File4 name   : ttc_counter_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 :The counter can increment and decrement.
//   In increment mode instead of counting4 to its full 16 bit
//   value the counter counts4 up to or down from a programmed4 interval4 value.
//   Interrupts4 are issued4 when the counter overflows4 or reaches4 it's interval4
//   value. In match mode if the count value equals4 that stored4 in one of three4
//   match registers an interrupt4 is issued4.
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
//


module ttc_counter_lite4(

  //inputs4
  n_p_reset4,    
  pclk4,          
  pwdata4,              
  count_en4,
  cntr_ctrl_reg_sel4, 
  interval_reg_sel4,
  match_1_reg_sel4,
  match_2_reg_sel4,
  match_3_reg_sel4,         

  //outputs4    
  count_val_out4,
  cntr_ctrl_reg_out4,
  interval_reg_out4,
  match_1_reg_out4,
  match_2_reg_out4,
  match_3_reg_out4,
  interval_intr4,
  match_intr4,
  overflow_intr4

);


//--------------------------------------------------------------------
// PORT DECLARATIONS4
//--------------------------------------------------------------------

   //inputs4
   input          n_p_reset4;         //reset signal4
   input          pclk4;              //System4 Clock4
   input [15:0]   pwdata4;            //6 Bit4 data signal4
   input          count_en4;          //Count4 enable signal4
   input          cntr_ctrl_reg_sel4; //Select4 bit for ctrl_reg4
   input          interval_reg_sel4;  //Interval4 Select4 Register
   input          match_1_reg_sel4;   //Match4 1 Select4 register
   input          match_2_reg_sel4;   //Match4 2 Select4 register
   input          match_3_reg_sel4;   //Match4 3 Select4 register

   //outputs4
   output [15:0]  count_val_out4;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out4;    //Counter4 control4 reg select4
   output [15:0]  interval_reg_out4;     //Interval4 reg
   output [15:0]  match_1_reg_out4;      //Match4 1 register
   output [15:0]  match_2_reg_out4;      //Match4 2 register
   output [15:0]  match_3_reg_out4;      //Match4 3 register
   output         interval_intr4;        //Interval4 interrupt4
   output [3:1]   match_intr4;           //Match4 interrupt4
   output         overflow_intr4;        //Overflow4 interrupt4

//--------------------------------------------------------------------
// Internal Signals4 & Registers4
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg4;     // 5-bit Counter4 Control4 Register
   reg [15:0]     interval_reg4;      //16-bit Interval4 Register 
   reg [15:0]     match_1_reg4;       //16-bit Match_14 Register
   reg [15:0]     match_2_reg4;       //16-bit Match_24 Register
   reg [15:0]     match_3_reg4;       //16-bit Match_34 Register
   reg [15:0]     count_val4;         //16-bit counter value register
                                                                      
   
   reg            counting4;          //counter has starting counting4
   reg            restart_temp4;   //ensures4 soft4 reset lasts4 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out4; //7-bit Counter4 Control4 Register
   wire [15:0]    interval_reg_out4;  //16-bit Interval4 Register 
   wire [15:0]    match_1_reg_out4;   //16-bit Match_14 Register
   wire [15:0]    match_2_reg_out4;   //16-bit Match_24 Register
   wire [15:0]    match_3_reg_out4;   //16-bit Match_34 Register
   wire [15:0]    count_val_out4;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign4 output wires4
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out4 = cntr_ctrl_reg4;    // 7-bit Counter4 Control4
   assign interval_reg_out4  = interval_reg4;     // 16-bit Interval4
   assign match_1_reg_out4   = match_1_reg4;      // 16-bit Match_14
   assign match_2_reg_out4   = match_2_reg4;      // 16-bit Match_24 
   assign match_3_reg_out4   = match_3_reg4;      // 16-bit Match_34 
   assign count_val_out4     = count_val4;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning4 interrupts4
//--------------------------------------------------------------------

   assign interval_intr4 =  cntr_ctrl_reg4[1] & (count_val4 == 16'h0000)
      & (counting4) & ~cntr_ctrl_reg4[4] & ~cntr_ctrl_reg4[0];
   assign overflow_intr4 = ~cntr_ctrl_reg4[1] & (count_val4 == 16'h0000)
      & (counting4) & ~cntr_ctrl_reg4[4] & ~cntr_ctrl_reg4[0];
   assign match_intr4[1]  =  cntr_ctrl_reg4[3] & (count_val4 == match_1_reg4)
      & (counting4) & ~cntr_ctrl_reg4[4] & ~cntr_ctrl_reg4[0];
   assign match_intr4[2]  =  cntr_ctrl_reg4[3] & (count_val4 == match_2_reg4)
      & (counting4) & ~cntr_ctrl_reg4[4] & ~cntr_ctrl_reg4[0];
   assign match_intr4[3]  =  cntr_ctrl_reg4[3] & (count_val4 == match_3_reg4)
      & (counting4) & ~cntr_ctrl_reg4[4] & ~cntr_ctrl_reg4[0];


//    p_reg_ctrl4: Process4 to write to the counter control4 registers
//    cntr_ctrl_reg4 decode:  0 - Counter4 Enable4 Active4 Low4
//                           1 - Interval4 Mode4 =1, Overflow4 =0
//                           2 - Decrement4 Mode4
//                           3 - Match4 Mode4
//                           4 - Restart4
//                           5 - Waveform4 enable active low4
//                           6 - Waveform4 polarity4
   
   always @ (posedge pclk4 or negedge n_p_reset4)
   begin: p_reg_ctrl4  // Register writes
      
      if (!n_p_reset4)                                   
      begin                                     
         cntr_ctrl_reg4 <= 7'b0000001;
         interval_reg4  <= 16'h0000;
         match_1_reg4   <= 16'h0000;
         match_2_reg4   <= 16'h0000;
         match_3_reg4   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel4)
            cntr_ctrl_reg4 <= pwdata4[6:0];
         else if (restart_temp4)
            cntr_ctrl_reg4[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg4 <= cntr_ctrl_reg4;             

         interval_reg4  <= (interval_reg_sel4) ? pwdata4 : interval_reg4;
         match_1_reg4   <= (match_1_reg_sel4)  ? pwdata4 : match_1_reg4;
         match_2_reg4   <= (match_2_reg_sel4)  ? pwdata4 : match_2_reg4;
         match_3_reg4   <= (match_3_reg_sel4)  ? pwdata4 : match_3_reg4;   
      end
      
   end  //p_reg_ctrl4

   
//    p_cntr4: Process4 to increment or decrement the counter on receiving4 a 
//            count_en4 signal4 from the pre_scaler4. Count4 can be restarted4
//            or disabled and can overflow4 at a specified interval4 value.
   
   
   always @ (posedge pclk4 or negedge n_p_reset4)
   begin: p_cntr4   // Counter4 block

      if (!n_p_reset4)     //System4 Reset4
      begin                     
         count_val4 <= 16'h0000;
         counting4  <= 1'b0;
         restart_temp4 <= 1'b0;
      end
      else if (count_en4)
      begin
         
         if (cntr_ctrl_reg4[4])     //Restart4
         begin     
            if (~cntr_ctrl_reg4[2])  
               count_val4         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg4[1])
                 count_val4         <= interval_reg4;     
              else
                 count_val4         <= 16'hFFFF;     
            end
            counting4       <= 1'b0;
            restart_temp4   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg4[0])          //Low4 Active4 Counter4 Enable4
            begin

               if (cntr_ctrl_reg4[1])  //Interval4               
                  if (cntr_ctrl_reg4[2])  //Decrement4        
                  begin
                     if (count_val4 == 16'h0000)
                        count_val4 <= interval_reg4;  //Assumed4 Static4
                     else
                        count_val4 <= count_val4 - 16'h0001;
                  end
                  else                   //Increment4
                  begin
                     if (count_val4 == interval_reg4)
                        count_val4 <= 16'h0000;
                     else           
                        count_val4 <= count_val4 + 16'h0001;
                  end
               else    
               begin  //Overflow4
                  if (cntr_ctrl_reg4[2])   //Decrement4
                  begin
                     if (count_val4 == 16'h0000)
                        count_val4 <= 16'hFFFF;
                     else           
                        count_val4 <= count_val4 - 16'h0001;
                  end
                  else                    //Increment4
                  begin
                     if (count_val4 == 16'hFFFF)
                        count_val4 <= 16'h0000;
                     else           
                        count_val4 <= count_val4 + 16'h0001;
                  end 
               end
               counting4  <= 1'b1;
            end     
            else
               count_val4 <= count_val4;   //Disabled4
   
            restart_temp4 <= 1'b0;
      
         end
     
      end // if (count_en4)

      else
      begin
         count_val4    <= count_val4;
         counting4     <= counting4;
         restart_temp4 <= restart_temp4;               
      end
     
   end  //p_cntr4

endmodule
