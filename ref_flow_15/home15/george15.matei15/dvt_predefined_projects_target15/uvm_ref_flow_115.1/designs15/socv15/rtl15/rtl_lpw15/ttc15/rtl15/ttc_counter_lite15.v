//File15 name   : ttc_counter_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 :The counter can increment and decrement.
//   In increment mode instead of counting15 to its full 16 bit
//   value the counter counts15 up to or down from a programmed15 interval15 value.
//   Interrupts15 are issued15 when the counter overflows15 or reaches15 it's interval15
//   value. In match mode if the count value equals15 that stored15 in one of three15
//   match registers an interrupt15 is issued15.
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------
//


module ttc_counter_lite15(

  //inputs15
  n_p_reset15,    
  pclk15,          
  pwdata15,              
  count_en15,
  cntr_ctrl_reg_sel15, 
  interval_reg_sel15,
  match_1_reg_sel15,
  match_2_reg_sel15,
  match_3_reg_sel15,         

  //outputs15    
  count_val_out15,
  cntr_ctrl_reg_out15,
  interval_reg_out15,
  match_1_reg_out15,
  match_2_reg_out15,
  match_3_reg_out15,
  interval_intr15,
  match_intr15,
  overflow_intr15

);


//--------------------------------------------------------------------
// PORT DECLARATIONS15
//--------------------------------------------------------------------

   //inputs15
   input          n_p_reset15;         //reset signal15
   input          pclk15;              //System15 Clock15
   input [15:0]   pwdata15;            //6 Bit15 data signal15
   input          count_en15;          //Count15 enable signal15
   input          cntr_ctrl_reg_sel15; //Select15 bit for ctrl_reg15
   input          interval_reg_sel15;  //Interval15 Select15 Register
   input          match_1_reg_sel15;   //Match15 1 Select15 register
   input          match_2_reg_sel15;   //Match15 2 Select15 register
   input          match_3_reg_sel15;   //Match15 3 Select15 register

   //outputs15
   output [15:0]  count_val_out15;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out15;    //Counter15 control15 reg select15
   output [15:0]  interval_reg_out15;     //Interval15 reg
   output [15:0]  match_1_reg_out15;      //Match15 1 register
   output [15:0]  match_2_reg_out15;      //Match15 2 register
   output [15:0]  match_3_reg_out15;      //Match15 3 register
   output         interval_intr15;        //Interval15 interrupt15
   output [3:1]   match_intr15;           //Match15 interrupt15
   output         overflow_intr15;        //Overflow15 interrupt15

//--------------------------------------------------------------------
// Internal Signals15 & Registers15
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg15;     // 5-bit Counter15 Control15 Register
   reg [15:0]     interval_reg15;      //16-bit Interval15 Register 
   reg [15:0]     match_1_reg15;       //16-bit Match_115 Register
   reg [15:0]     match_2_reg15;       //16-bit Match_215 Register
   reg [15:0]     match_3_reg15;       //16-bit Match_315 Register
   reg [15:0]     count_val15;         //16-bit counter value register
                                                                      
   
   reg            counting15;          //counter has starting counting15
   reg            restart_temp15;   //ensures15 soft15 reset lasts15 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out15; //7-bit Counter15 Control15 Register
   wire [15:0]    interval_reg_out15;  //16-bit Interval15 Register 
   wire [15:0]    match_1_reg_out15;   //16-bit Match_115 Register
   wire [15:0]    match_2_reg_out15;   //16-bit Match_215 Register
   wire [15:0]    match_3_reg_out15;   //16-bit Match_315 Register
   wire [15:0]    count_val_out15;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign15 output wires15
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out15 = cntr_ctrl_reg15;    // 7-bit Counter15 Control15
   assign interval_reg_out15  = interval_reg15;     // 16-bit Interval15
   assign match_1_reg_out15   = match_1_reg15;      // 16-bit Match_115
   assign match_2_reg_out15   = match_2_reg15;      // 16-bit Match_215 
   assign match_3_reg_out15   = match_3_reg15;      // 16-bit Match_315 
   assign count_val_out15     = count_val15;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning15 interrupts15
//--------------------------------------------------------------------

   assign interval_intr15 =  cntr_ctrl_reg15[1] & (count_val15 == 16'h0000)
      & (counting15) & ~cntr_ctrl_reg15[4] & ~cntr_ctrl_reg15[0];
   assign overflow_intr15 = ~cntr_ctrl_reg15[1] & (count_val15 == 16'h0000)
      & (counting15) & ~cntr_ctrl_reg15[4] & ~cntr_ctrl_reg15[0];
   assign match_intr15[1]  =  cntr_ctrl_reg15[3] & (count_val15 == match_1_reg15)
      & (counting15) & ~cntr_ctrl_reg15[4] & ~cntr_ctrl_reg15[0];
   assign match_intr15[2]  =  cntr_ctrl_reg15[3] & (count_val15 == match_2_reg15)
      & (counting15) & ~cntr_ctrl_reg15[4] & ~cntr_ctrl_reg15[0];
   assign match_intr15[3]  =  cntr_ctrl_reg15[3] & (count_val15 == match_3_reg15)
      & (counting15) & ~cntr_ctrl_reg15[4] & ~cntr_ctrl_reg15[0];


//    p_reg_ctrl15: Process15 to write to the counter control15 registers
//    cntr_ctrl_reg15 decode:  0 - Counter15 Enable15 Active15 Low15
//                           1 - Interval15 Mode15 =1, Overflow15 =0
//                           2 - Decrement15 Mode15
//                           3 - Match15 Mode15
//                           4 - Restart15
//                           5 - Waveform15 enable active low15
//                           6 - Waveform15 polarity15
   
   always @ (posedge pclk15 or negedge n_p_reset15)
   begin: p_reg_ctrl15  // Register writes
      
      if (!n_p_reset15)                                   
      begin                                     
         cntr_ctrl_reg15 <= 7'b0000001;
         interval_reg15  <= 16'h0000;
         match_1_reg15   <= 16'h0000;
         match_2_reg15   <= 16'h0000;
         match_3_reg15   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel15)
            cntr_ctrl_reg15 <= pwdata15[6:0];
         else if (restart_temp15)
            cntr_ctrl_reg15[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg15 <= cntr_ctrl_reg15;             

         interval_reg15  <= (interval_reg_sel15) ? pwdata15 : interval_reg15;
         match_1_reg15   <= (match_1_reg_sel15)  ? pwdata15 : match_1_reg15;
         match_2_reg15   <= (match_2_reg_sel15)  ? pwdata15 : match_2_reg15;
         match_3_reg15   <= (match_3_reg_sel15)  ? pwdata15 : match_3_reg15;   
      end
      
   end  //p_reg_ctrl15

   
//    p_cntr15: Process15 to increment or decrement the counter on receiving15 a 
//            count_en15 signal15 from the pre_scaler15. Count15 can be restarted15
//            or disabled and can overflow15 at a specified interval15 value.
   
   
   always @ (posedge pclk15 or negedge n_p_reset15)
   begin: p_cntr15   // Counter15 block

      if (!n_p_reset15)     //System15 Reset15
      begin                     
         count_val15 <= 16'h0000;
         counting15  <= 1'b0;
         restart_temp15 <= 1'b0;
      end
      else if (count_en15)
      begin
         
         if (cntr_ctrl_reg15[4])     //Restart15
         begin     
            if (~cntr_ctrl_reg15[2])  
               count_val15         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg15[1])
                 count_val15         <= interval_reg15;     
              else
                 count_val15         <= 16'hFFFF;     
            end
            counting15       <= 1'b0;
            restart_temp15   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg15[0])          //Low15 Active15 Counter15 Enable15
            begin

               if (cntr_ctrl_reg15[1])  //Interval15               
                  if (cntr_ctrl_reg15[2])  //Decrement15        
                  begin
                     if (count_val15 == 16'h0000)
                        count_val15 <= interval_reg15;  //Assumed15 Static15
                     else
                        count_val15 <= count_val15 - 16'h0001;
                  end
                  else                   //Increment15
                  begin
                     if (count_val15 == interval_reg15)
                        count_val15 <= 16'h0000;
                     else           
                        count_val15 <= count_val15 + 16'h0001;
                  end
               else    
               begin  //Overflow15
                  if (cntr_ctrl_reg15[2])   //Decrement15
                  begin
                     if (count_val15 == 16'h0000)
                        count_val15 <= 16'hFFFF;
                     else           
                        count_val15 <= count_val15 - 16'h0001;
                  end
                  else                    //Increment15
                  begin
                     if (count_val15 == 16'hFFFF)
                        count_val15 <= 16'h0000;
                     else           
                        count_val15 <= count_val15 + 16'h0001;
                  end 
               end
               counting15  <= 1'b1;
            end     
            else
               count_val15 <= count_val15;   //Disabled15
   
            restart_temp15 <= 1'b0;
      
         end
     
      end // if (count_en15)

      else
      begin
         count_val15    <= count_val15;
         counting15     <= counting15;
         restart_temp15 <= restart_temp15;               
      end
     
   end  //p_cntr15

endmodule
