//File21 name   : ttc_counter_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 :The counter can increment and decrement.
//   In increment mode instead of counting21 to its full 16 bit
//   value the counter counts21 up to or down from a programmed21 interval21 value.
//   Interrupts21 are issued21 when the counter overflows21 or reaches21 it's interval21
//   value. In match mode if the count value equals21 that stored21 in one of three21
//   match registers an interrupt21 is issued21.
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------
//


module ttc_counter_lite21(

  //inputs21
  n_p_reset21,    
  pclk21,          
  pwdata21,              
  count_en21,
  cntr_ctrl_reg_sel21, 
  interval_reg_sel21,
  match_1_reg_sel21,
  match_2_reg_sel21,
  match_3_reg_sel21,         

  //outputs21    
  count_val_out21,
  cntr_ctrl_reg_out21,
  interval_reg_out21,
  match_1_reg_out21,
  match_2_reg_out21,
  match_3_reg_out21,
  interval_intr21,
  match_intr21,
  overflow_intr21

);


//--------------------------------------------------------------------
// PORT DECLARATIONS21
//--------------------------------------------------------------------

   //inputs21
   input          n_p_reset21;         //reset signal21
   input          pclk21;              //System21 Clock21
   input [15:0]   pwdata21;            //6 Bit21 data signal21
   input          count_en21;          //Count21 enable signal21
   input          cntr_ctrl_reg_sel21; //Select21 bit for ctrl_reg21
   input          interval_reg_sel21;  //Interval21 Select21 Register
   input          match_1_reg_sel21;   //Match21 1 Select21 register
   input          match_2_reg_sel21;   //Match21 2 Select21 register
   input          match_3_reg_sel21;   //Match21 3 Select21 register

   //outputs21
   output [15:0]  count_val_out21;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out21;    //Counter21 control21 reg select21
   output [15:0]  interval_reg_out21;     //Interval21 reg
   output [15:0]  match_1_reg_out21;      //Match21 1 register
   output [15:0]  match_2_reg_out21;      //Match21 2 register
   output [15:0]  match_3_reg_out21;      //Match21 3 register
   output         interval_intr21;        //Interval21 interrupt21
   output [3:1]   match_intr21;           //Match21 interrupt21
   output         overflow_intr21;        //Overflow21 interrupt21

//--------------------------------------------------------------------
// Internal Signals21 & Registers21
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg21;     // 5-bit Counter21 Control21 Register
   reg [15:0]     interval_reg21;      //16-bit Interval21 Register 
   reg [15:0]     match_1_reg21;       //16-bit Match_121 Register
   reg [15:0]     match_2_reg21;       //16-bit Match_221 Register
   reg [15:0]     match_3_reg21;       //16-bit Match_321 Register
   reg [15:0]     count_val21;         //16-bit counter value register
                                                                      
   
   reg            counting21;          //counter has starting counting21
   reg            restart_temp21;   //ensures21 soft21 reset lasts21 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out21; //7-bit Counter21 Control21 Register
   wire [15:0]    interval_reg_out21;  //16-bit Interval21 Register 
   wire [15:0]    match_1_reg_out21;   //16-bit Match_121 Register
   wire [15:0]    match_2_reg_out21;   //16-bit Match_221 Register
   wire [15:0]    match_3_reg_out21;   //16-bit Match_321 Register
   wire [15:0]    count_val_out21;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign21 output wires21
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out21 = cntr_ctrl_reg21;    // 7-bit Counter21 Control21
   assign interval_reg_out21  = interval_reg21;     // 16-bit Interval21
   assign match_1_reg_out21   = match_1_reg21;      // 16-bit Match_121
   assign match_2_reg_out21   = match_2_reg21;      // 16-bit Match_221 
   assign match_3_reg_out21   = match_3_reg21;      // 16-bit Match_321 
   assign count_val_out21     = count_val21;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning21 interrupts21
//--------------------------------------------------------------------

   assign interval_intr21 =  cntr_ctrl_reg21[1] & (count_val21 == 16'h0000)
      & (counting21) & ~cntr_ctrl_reg21[4] & ~cntr_ctrl_reg21[0];
   assign overflow_intr21 = ~cntr_ctrl_reg21[1] & (count_val21 == 16'h0000)
      & (counting21) & ~cntr_ctrl_reg21[4] & ~cntr_ctrl_reg21[0];
   assign match_intr21[1]  =  cntr_ctrl_reg21[3] & (count_val21 == match_1_reg21)
      & (counting21) & ~cntr_ctrl_reg21[4] & ~cntr_ctrl_reg21[0];
   assign match_intr21[2]  =  cntr_ctrl_reg21[3] & (count_val21 == match_2_reg21)
      & (counting21) & ~cntr_ctrl_reg21[4] & ~cntr_ctrl_reg21[0];
   assign match_intr21[3]  =  cntr_ctrl_reg21[3] & (count_val21 == match_3_reg21)
      & (counting21) & ~cntr_ctrl_reg21[4] & ~cntr_ctrl_reg21[0];


//    p_reg_ctrl21: Process21 to write to the counter control21 registers
//    cntr_ctrl_reg21 decode:  0 - Counter21 Enable21 Active21 Low21
//                           1 - Interval21 Mode21 =1, Overflow21 =0
//                           2 - Decrement21 Mode21
//                           3 - Match21 Mode21
//                           4 - Restart21
//                           5 - Waveform21 enable active low21
//                           6 - Waveform21 polarity21
   
   always @ (posedge pclk21 or negedge n_p_reset21)
   begin: p_reg_ctrl21  // Register writes
      
      if (!n_p_reset21)                                   
      begin                                     
         cntr_ctrl_reg21 <= 7'b0000001;
         interval_reg21  <= 16'h0000;
         match_1_reg21   <= 16'h0000;
         match_2_reg21   <= 16'h0000;
         match_3_reg21   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel21)
            cntr_ctrl_reg21 <= pwdata21[6:0];
         else if (restart_temp21)
            cntr_ctrl_reg21[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg21 <= cntr_ctrl_reg21;             

         interval_reg21  <= (interval_reg_sel21) ? pwdata21 : interval_reg21;
         match_1_reg21   <= (match_1_reg_sel21)  ? pwdata21 : match_1_reg21;
         match_2_reg21   <= (match_2_reg_sel21)  ? pwdata21 : match_2_reg21;
         match_3_reg21   <= (match_3_reg_sel21)  ? pwdata21 : match_3_reg21;   
      end
      
   end  //p_reg_ctrl21

   
//    p_cntr21: Process21 to increment or decrement the counter on receiving21 a 
//            count_en21 signal21 from the pre_scaler21. Count21 can be restarted21
//            or disabled and can overflow21 at a specified interval21 value.
   
   
   always @ (posedge pclk21 or negedge n_p_reset21)
   begin: p_cntr21   // Counter21 block

      if (!n_p_reset21)     //System21 Reset21
      begin                     
         count_val21 <= 16'h0000;
         counting21  <= 1'b0;
         restart_temp21 <= 1'b0;
      end
      else if (count_en21)
      begin
         
         if (cntr_ctrl_reg21[4])     //Restart21
         begin     
            if (~cntr_ctrl_reg21[2])  
               count_val21         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg21[1])
                 count_val21         <= interval_reg21;     
              else
                 count_val21         <= 16'hFFFF;     
            end
            counting21       <= 1'b0;
            restart_temp21   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg21[0])          //Low21 Active21 Counter21 Enable21
            begin

               if (cntr_ctrl_reg21[1])  //Interval21               
                  if (cntr_ctrl_reg21[2])  //Decrement21        
                  begin
                     if (count_val21 == 16'h0000)
                        count_val21 <= interval_reg21;  //Assumed21 Static21
                     else
                        count_val21 <= count_val21 - 16'h0001;
                  end
                  else                   //Increment21
                  begin
                     if (count_val21 == interval_reg21)
                        count_val21 <= 16'h0000;
                     else           
                        count_val21 <= count_val21 + 16'h0001;
                  end
               else    
               begin  //Overflow21
                  if (cntr_ctrl_reg21[2])   //Decrement21
                  begin
                     if (count_val21 == 16'h0000)
                        count_val21 <= 16'hFFFF;
                     else           
                        count_val21 <= count_val21 - 16'h0001;
                  end
                  else                    //Increment21
                  begin
                     if (count_val21 == 16'hFFFF)
                        count_val21 <= 16'h0000;
                     else           
                        count_val21 <= count_val21 + 16'h0001;
                  end 
               end
               counting21  <= 1'b1;
            end     
            else
               count_val21 <= count_val21;   //Disabled21
   
            restart_temp21 <= 1'b0;
      
         end
     
      end // if (count_en21)

      else
      begin
         count_val21    <= count_val21;
         counting21     <= counting21;
         restart_temp21 <= restart_temp21;               
      end
     
   end  //p_cntr21

endmodule
