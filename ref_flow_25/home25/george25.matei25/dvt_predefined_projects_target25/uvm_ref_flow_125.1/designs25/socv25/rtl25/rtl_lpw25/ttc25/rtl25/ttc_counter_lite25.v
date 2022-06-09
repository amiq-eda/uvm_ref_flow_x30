//File25 name   : ttc_counter_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 :The counter can increment and decrement.
//   In increment mode instead of counting25 to its full 16 bit
//   value the counter counts25 up to or down from a programmed25 interval25 value.
//   Interrupts25 are issued25 when the counter overflows25 or reaches25 it's interval25
//   value. In match mode if the count value equals25 that stored25 in one of three25
//   match registers an interrupt25 is issued25.
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
//


module ttc_counter_lite25(

  //inputs25
  n_p_reset25,    
  pclk25,          
  pwdata25,              
  count_en25,
  cntr_ctrl_reg_sel25, 
  interval_reg_sel25,
  match_1_reg_sel25,
  match_2_reg_sel25,
  match_3_reg_sel25,         

  //outputs25    
  count_val_out25,
  cntr_ctrl_reg_out25,
  interval_reg_out25,
  match_1_reg_out25,
  match_2_reg_out25,
  match_3_reg_out25,
  interval_intr25,
  match_intr25,
  overflow_intr25

);


//--------------------------------------------------------------------
// PORT DECLARATIONS25
//--------------------------------------------------------------------

   //inputs25
   input          n_p_reset25;         //reset signal25
   input          pclk25;              //System25 Clock25
   input [15:0]   pwdata25;            //6 Bit25 data signal25
   input          count_en25;          //Count25 enable signal25
   input          cntr_ctrl_reg_sel25; //Select25 bit for ctrl_reg25
   input          interval_reg_sel25;  //Interval25 Select25 Register
   input          match_1_reg_sel25;   //Match25 1 Select25 register
   input          match_2_reg_sel25;   //Match25 2 Select25 register
   input          match_3_reg_sel25;   //Match25 3 Select25 register

   //outputs25
   output [15:0]  count_val_out25;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out25;    //Counter25 control25 reg select25
   output [15:0]  interval_reg_out25;     //Interval25 reg
   output [15:0]  match_1_reg_out25;      //Match25 1 register
   output [15:0]  match_2_reg_out25;      //Match25 2 register
   output [15:0]  match_3_reg_out25;      //Match25 3 register
   output         interval_intr25;        //Interval25 interrupt25
   output [3:1]   match_intr25;           //Match25 interrupt25
   output         overflow_intr25;        //Overflow25 interrupt25

//--------------------------------------------------------------------
// Internal Signals25 & Registers25
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg25;     // 5-bit Counter25 Control25 Register
   reg [15:0]     interval_reg25;      //16-bit Interval25 Register 
   reg [15:0]     match_1_reg25;       //16-bit Match_125 Register
   reg [15:0]     match_2_reg25;       //16-bit Match_225 Register
   reg [15:0]     match_3_reg25;       //16-bit Match_325 Register
   reg [15:0]     count_val25;         //16-bit counter value register
                                                                      
   
   reg            counting25;          //counter has starting counting25
   reg            restart_temp25;   //ensures25 soft25 reset lasts25 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out25; //7-bit Counter25 Control25 Register
   wire [15:0]    interval_reg_out25;  //16-bit Interval25 Register 
   wire [15:0]    match_1_reg_out25;   //16-bit Match_125 Register
   wire [15:0]    match_2_reg_out25;   //16-bit Match_225 Register
   wire [15:0]    match_3_reg_out25;   //16-bit Match_325 Register
   wire [15:0]    count_val_out25;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign25 output wires25
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out25 = cntr_ctrl_reg25;    // 7-bit Counter25 Control25
   assign interval_reg_out25  = interval_reg25;     // 16-bit Interval25
   assign match_1_reg_out25   = match_1_reg25;      // 16-bit Match_125
   assign match_2_reg_out25   = match_2_reg25;      // 16-bit Match_225 
   assign match_3_reg_out25   = match_3_reg25;      // 16-bit Match_325 
   assign count_val_out25     = count_val25;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning25 interrupts25
//--------------------------------------------------------------------

   assign interval_intr25 =  cntr_ctrl_reg25[1] & (count_val25 == 16'h0000)
      & (counting25) & ~cntr_ctrl_reg25[4] & ~cntr_ctrl_reg25[0];
   assign overflow_intr25 = ~cntr_ctrl_reg25[1] & (count_val25 == 16'h0000)
      & (counting25) & ~cntr_ctrl_reg25[4] & ~cntr_ctrl_reg25[0];
   assign match_intr25[1]  =  cntr_ctrl_reg25[3] & (count_val25 == match_1_reg25)
      & (counting25) & ~cntr_ctrl_reg25[4] & ~cntr_ctrl_reg25[0];
   assign match_intr25[2]  =  cntr_ctrl_reg25[3] & (count_val25 == match_2_reg25)
      & (counting25) & ~cntr_ctrl_reg25[4] & ~cntr_ctrl_reg25[0];
   assign match_intr25[3]  =  cntr_ctrl_reg25[3] & (count_val25 == match_3_reg25)
      & (counting25) & ~cntr_ctrl_reg25[4] & ~cntr_ctrl_reg25[0];


//    p_reg_ctrl25: Process25 to write to the counter control25 registers
//    cntr_ctrl_reg25 decode:  0 - Counter25 Enable25 Active25 Low25
//                           1 - Interval25 Mode25 =1, Overflow25 =0
//                           2 - Decrement25 Mode25
//                           3 - Match25 Mode25
//                           4 - Restart25
//                           5 - Waveform25 enable active low25
//                           6 - Waveform25 polarity25
   
   always @ (posedge pclk25 or negedge n_p_reset25)
   begin: p_reg_ctrl25  // Register writes
      
      if (!n_p_reset25)                                   
      begin                                     
         cntr_ctrl_reg25 <= 7'b0000001;
         interval_reg25  <= 16'h0000;
         match_1_reg25   <= 16'h0000;
         match_2_reg25   <= 16'h0000;
         match_3_reg25   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel25)
            cntr_ctrl_reg25 <= pwdata25[6:0];
         else if (restart_temp25)
            cntr_ctrl_reg25[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg25 <= cntr_ctrl_reg25;             

         interval_reg25  <= (interval_reg_sel25) ? pwdata25 : interval_reg25;
         match_1_reg25   <= (match_1_reg_sel25)  ? pwdata25 : match_1_reg25;
         match_2_reg25   <= (match_2_reg_sel25)  ? pwdata25 : match_2_reg25;
         match_3_reg25   <= (match_3_reg_sel25)  ? pwdata25 : match_3_reg25;   
      end
      
   end  //p_reg_ctrl25

   
//    p_cntr25: Process25 to increment or decrement the counter on receiving25 a 
//            count_en25 signal25 from the pre_scaler25. Count25 can be restarted25
//            or disabled and can overflow25 at a specified interval25 value.
   
   
   always @ (posedge pclk25 or negedge n_p_reset25)
   begin: p_cntr25   // Counter25 block

      if (!n_p_reset25)     //System25 Reset25
      begin                     
         count_val25 <= 16'h0000;
         counting25  <= 1'b0;
         restart_temp25 <= 1'b0;
      end
      else if (count_en25)
      begin
         
         if (cntr_ctrl_reg25[4])     //Restart25
         begin     
            if (~cntr_ctrl_reg25[2])  
               count_val25         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg25[1])
                 count_val25         <= interval_reg25;     
              else
                 count_val25         <= 16'hFFFF;     
            end
            counting25       <= 1'b0;
            restart_temp25   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg25[0])          //Low25 Active25 Counter25 Enable25
            begin

               if (cntr_ctrl_reg25[1])  //Interval25               
                  if (cntr_ctrl_reg25[2])  //Decrement25        
                  begin
                     if (count_val25 == 16'h0000)
                        count_val25 <= interval_reg25;  //Assumed25 Static25
                     else
                        count_val25 <= count_val25 - 16'h0001;
                  end
                  else                   //Increment25
                  begin
                     if (count_val25 == interval_reg25)
                        count_val25 <= 16'h0000;
                     else           
                        count_val25 <= count_val25 + 16'h0001;
                  end
               else    
               begin  //Overflow25
                  if (cntr_ctrl_reg25[2])   //Decrement25
                  begin
                     if (count_val25 == 16'h0000)
                        count_val25 <= 16'hFFFF;
                     else           
                        count_val25 <= count_val25 - 16'h0001;
                  end
                  else                    //Increment25
                  begin
                     if (count_val25 == 16'hFFFF)
                        count_val25 <= 16'h0000;
                     else           
                        count_val25 <= count_val25 + 16'h0001;
                  end 
               end
               counting25  <= 1'b1;
            end     
            else
               count_val25 <= count_val25;   //Disabled25
   
            restart_temp25 <= 1'b0;
      
         end
     
      end // if (count_en25)

      else
      begin
         count_val25    <= count_val25;
         counting25     <= counting25;
         restart_temp25 <= restart_temp25;               
      end
     
   end  //p_cntr25

endmodule
