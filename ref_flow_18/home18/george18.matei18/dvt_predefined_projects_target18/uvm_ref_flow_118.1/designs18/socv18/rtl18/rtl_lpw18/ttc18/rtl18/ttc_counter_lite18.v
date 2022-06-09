//File18 name   : ttc_counter_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 :The counter can increment and decrement.
//   In increment mode instead of counting18 to its full 16 bit
//   value the counter counts18 up to or down from a programmed18 interval18 value.
//   Interrupts18 are issued18 when the counter overflows18 or reaches18 it's interval18
//   value. In match mode if the count value equals18 that stored18 in one of three18
//   match registers an interrupt18 is issued18.
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------
//


module ttc_counter_lite18(

  //inputs18
  n_p_reset18,    
  pclk18,          
  pwdata18,              
  count_en18,
  cntr_ctrl_reg_sel18, 
  interval_reg_sel18,
  match_1_reg_sel18,
  match_2_reg_sel18,
  match_3_reg_sel18,         

  //outputs18    
  count_val_out18,
  cntr_ctrl_reg_out18,
  interval_reg_out18,
  match_1_reg_out18,
  match_2_reg_out18,
  match_3_reg_out18,
  interval_intr18,
  match_intr18,
  overflow_intr18

);


//--------------------------------------------------------------------
// PORT DECLARATIONS18
//--------------------------------------------------------------------

   //inputs18
   input          n_p_reset18;         //reset signal18
   input          pclk18;              //System18 Clock18
   input [15:0]   pwdata18;            //6 Bit18 data signal18
   input          count_en18;          //Count18 enable signal18
   input          cntr_ctrl_reg_sel18; //Select18 bit for ctrl_reg18
   input          interval_reg_sel18;  //Interval18 Select18 Register
   input          match_1_reg_sel18;   //Match18 1 Select18 register
   input          match_2_reg_sel18;   //Match18 2 Select18 register
   input          match_3_reg_sel18;   //Match18 3 Select18 register

   //outputs18
   output [15:0]  count_val_out18;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out18;    //Counter18 control18 reg select18
   output [15:0]  interval_reg_out18;     //Interval18 reg
   output [15:0]  match_1_reg_out18;      //Match18 1 register
   output [15:0]  match_2_reg_out18;      //Match18 2 register
   output [15:0]  match_3_reg_out18;      //Match18 3 register
   output         interval_intr18;        //Interval18 interrupt18
   output [3:1]   match_intr18;           //Match18 interrupt18
   output         overflow_intr18;        //Overflow18 interrupt18

//--------------------------------------------------------------------
// Internal Signals18 & Registers18
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg18;     // 5-bit Counter18 Control18 Register
   reg [15:0]     interval_reg18;      //16-bit Interval18 Register 
   reg [15:0]     match_1_reg18;       //16-bit Match_118 Register
   reg [15:0]     match_2_reg18;       //16-bit Match_218 Register
   reg [15:0]     match_3_reg18;       //16-bit Match_318 Register
   reg [15:0]     count_val18;         //16-bit counter value register
                                                                      
   
   reg            counting18;          //counter has starting counting18
   reg            restart_temp18;   //ensures18 soft18 reset lasts18 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out18; //7-bit Counter18 Control18 Register
   wire [15:0]    interval_reg_out18;  //16-bit Interval18 Register 
   wire [15:0]    match_1_reg_out18;   //16-bit Match_118 Register
   wire [15:0]    match_2_reg_out18;   //16-bit Match_218 Register
   wire [15:0]    match_3_reg_out18;   //16-bit Match_318 Register
   wire [15:0]    count_val_out18;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign18 output wires18
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out18 = cntr_ctrl_reg18;    // 7-bit Counter18 Control18
   assign interval_reg_out18  = interval_reg18;     // 16-bit Interval18
   assign match_1_reg_out18   = match_1_reg18;      // 16-bit Match_118
   assign match_2_reg_out18   = match_2_reg18;      // 16-bit Match_218 
   assign match_3_reg_out18   = match_3_reg18;      // 16-bit Match_318 
   assign count_val_out18     = count_val18;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning18 interrupts18
//--------------------------------------------------------------------

   assign interval_intr18 =  cntr_ctrl_reg18[1] & (count_val18 == 16'h0000)
      & (counting18) & ~cntr_ctrl_reg18[4] & ~cntr_ctrl_reg18[0];
   assign overflow_intr18 = ~cntr_ctrl_reg18[1] & (count_val18 == 16'h0000)
      & (counting18) & ~cntr_ctrl_reg18[4] & ~cntr_ctrl_reg18[0];
   assign match_intr18[1]  =  cntr_ctrl_reg18[3] & (count_val18 == match_1_reg18)
      & (counting18) & ~cntr_ctrl_reg18[4] & ~cntr_ctrl_reg18[0];
   assign match_intr18[2]  =  cntr_ctrl_reg18[3] & (count_val18 == match_2_reg18)
      & (counting18) & ~cntr_ctrl_reg18[4] & ~cntr_ctrl_reg18[0];
   assign match_intr18[3]  =  cntr_ctrl_reg18[3] & (count_val18 == match_3_reg18)
      & (counting18) & ~cntr_ctrl_reg18[4] & ~cntr_ctrl_reg18[0];


//    p_reg_ctrl18: Process18 to write to the counter control18 registers
//    cntr_ctrl_reg18 decode:  0 - Counter18 Enable18 Active18 Low18
//                           1 - Interval18 Mode18 =1, Overflow18 =0
//                           2 - Decrement18 Mode18
//                           3 - Match18 Mode18
//                           4 - Restart18
//                           5 - Waveform18 enable active low18
//                           6 - Waveform18 polarity18
   
   always @ (posedge pclk18 or negedge n_p_reset18)
   begin: p_reg_ctrl18  // Register writes
      
      if (!n_p_reset18)                                   
      begin                                     
         cntr_ctrl_reg18 <= 7'b0000001;
         interval_reg18  <= 16'h0000;
         match_1_reg18   <= 16'h0000;
         match_2_reg18   <= 16'h0000;
         match_3_reg18   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel18)
            cntr_ctrl_reg18 <= pwdata18[6:0];
         else if (restart_temp18)
            cntr_ctrl_reg18[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg18 <= cntr_ctrl_reg18;             

         interval_reg18  <= (interval_reg_sel18) ? pwdata18 : interval_reg18;
         match_1_reg18   <= (match_1_reg_sel18)  ? pwdata18 : match_1_reg18;
         match_2_reg18   <= (match_2_reg_sel18)  ? pwdata18 : match_2_reg18;
         match_3_reg18   <= (match_3_reg_sel18)  ? pwdata18 : match_3_reg18;   
      end
      
   end  //p_reg_ctrl18

   
//    p_cntr18: Process18 to increment or decrement the counter on receiving18 a 
//            count_en18 signal18 from the pre_scaler18. Count18 can be restarted18
//            or disabled and can overflow18 at a specified interval18 value.
   
   
   always @ (posedge pclk18 or negedge n_p_reset18)
   begin: p_cntr18   // Counter18 block

      if (!n_p_reset18)     //System18 Reset18
      begin                     
         count_val18 <= 16'h0000;
         counting18  <= 1'b0;
         restart_temp18 <= 1'b0;
      end
      else if (count_en18)
      begin
         
         if (cntr_ctrl_reg18[4])     //Restart18
         begin     
            if (~cntr_ctrl_reg18[2])  
               count_val18         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg18[1])
                 count_val18         <= interval_reg18;     
              else
                 count_val18         <= 16'hFFFF;     
            end
            counting18       <= 1'b0;
            restart_temp18   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg18[0])          //Low18 Active18 Counter18 Enable18
            begin

               if (cntr_ctrl_reg18[1])  //Interval18               
                  if (cntr_ctrl_reg18[2])  //Decrement18        
                  begin
                     if (count_val18 == 16'h0000)
                        count_val18 <= interval_reg18;  //Assumed18 Static18
                     else
                        count_val18 <= count_val18 - 16'h0001;
                  end
                  else                   //Increment18
                  begin
                     if (count_val18 == interval_reg18)
                        count_val18 <= 16'h0000;
                     else           
                        count_val18 <= count_val18 + 16'h0001;
                  end
               else    
               begin  //Overflow18
                  if (cntr_ctrl_reg18[2])   //Decrement18
                  begin
                     if (count_val18 == 16'h0000)
                        count_val18 <= 16'hFFFF;
                     else           
                        count_val18 <= count_val18 - 16'h0001;
                  end
                  else                    //Increment18
                  begin
                     if (count_val18 == 16'hFFFF)
                        count_val18 <= 16'h0000;
                     else           
                        count_val18 <= count_val18 + 16'h0001;
                  end 
               end
               counting18  <= 1'b1;
            end     
            else
               count_val18 <= count_val18;   //Disabled18
   
            restart_temp18 <= 1'b0;
      
         end
     
      end // if (count_en18)

      else
      begin
         count_val18    <= count_val18;
         counting18     <= counting18;
         restart_temp18 <= restart_temp18;               
      end
     
   end  //p_cntr18

endmodule
