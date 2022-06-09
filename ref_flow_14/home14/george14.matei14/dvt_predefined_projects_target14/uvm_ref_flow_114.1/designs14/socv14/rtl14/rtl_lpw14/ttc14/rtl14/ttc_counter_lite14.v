//File14 name   : ttc_counter_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 :The counter can increment and decrement.
//   In increment mode instead of counting14 to its full 16 bit
//   value the counter counts14 up to or down from a programmed14 interval14 value.
//   Interrupts14 are issued14 when the counter overflows14 or reaches14 it's interval14
//   value. In match mode if the count value equals14 that stored14 in one of three14
//   match registers an interrupt14 is issued14.
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
//


module ttc_counter_lite14(

  //inputs14
  n_p_reset14,    
  pclk14,          
  pwdata14,              
  count_en14,
  cntr_ctrl_reg_sel14, 
  interval_reg_sel14,
  match_1_reg_sel14,
  match_2_reg_sel14,
  match_3_reg_sel14,         

  //outputs14    
  count_val_out14,
  cntr_ctrl_reg_out14,
  interval_reg_out14,
  match_1_reg_out14,
  match_2_reg_out14,
  match_3_reg_out14,
  interval_intr14,
  match_intr14,
  overflow_intr14

);


//--------------------------------------------------------------------
// PORT DECLARATIONS14
//--------------------------------------------------------------------

   //inputs14
   input          n_p_reset14;         //reset signal14
   input          pclk14;              //System14 Clock14
   input [15:0]   pwdata14;            //6 Bit14 data signal14
   input          count_en14;          //Count14 enable signal14
   input          cntr_ctrl_reg_sel14; //Select14 bit for ctrl_reg14
   input          interval_reg_sel14;  //Interval14 Select14 Register
   input          match_1_reg_sel14;   //Match14 1 Select14 register
   input          match_2_reg_sel14;   //Match14 2 Select14 register
   input          match_3_reg_sel14;   //Match14 3 Select14 register

   //outputs14
   output [15:0]  count_val_out14;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out14;    //Counter14 control14 reg select14
   output [15:0]  interval_reg_out14;     //Interval14 reg
   output [15:0]  match_1_reg_out14;      //Match14 1 register
   output [15:0]  match_2_reg_out14;      //Match14 2 register
   output [15:0]  match_3_reg_out14;      //Match14 3 register
   output         interval_intr14;        //Interval14 interrupt14
   output [3:1]   match_intr14;           //Match14 interrupt14
   output         overflow_intr14;        //Overflow14 interrupt14

//--------------------------------------------------------------------
// Internal Signals14 & Registers14
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg14;     // 5-bit Counter14 Control14 Register
   reg [15:0]     interval_reg14;      //16-bit Interval14 Register 
   reg [15:0]     match_1_reg14;       //16-bit Match_114 Register
   reg [15:0]     match_2_reg14;       //16-bit Match_214 Register
   reg [15:0]     match_3_reg14;       //16-bit Match_314 Register
   reg [15:0]     count_val14;         //16-bit counter value register
                                                                      
   
   reg            counting14;          //counter has starting counting14
   reg            restart_temp14;   //ensures14 soft14 reset lasts14 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out14; //7-bit Counter14 Control14 Register
   wire [15:0]    interval_reg_out14;  //16-bit Interval14 Register 
   wire [15:0]    match_1_reg_out14;   //16-bit Match_114 Register
   wire [15:0]    match_2_reg_out14;   //16-bit Match_214 Register
   wire [15:0]    match_3_reg_out14;   //16-bit Match_314 Register
   wire [15:0]    count_val_out14;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign14 output wires14
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out14 = cntr_ctrl_reg14;    // 7-bit Counter14 Control14
   assign interval_reg_out14  = interval_reg14;     // 16-bit Interval14
   assign match_1_reg_out14   = match_1_reg14;      // 16-bit Match_114
   assign match_2_reg_out14   = match_2_reg14;      // 16-bit Match_214 
   assign match_3_reg_out14   = match_3_reg14;      // 16-bit Match_314 
   assign count_val_out14     = count_val14;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning14 interrupts14
//--------------------------------------------------------------------

   assign interval_intr14 =  cntr_ctrl_reg14[1] & (count_val14 == 16'h0000)
      & (counting14) & ~cntr_ctrl_reg14[4] & ~cntr_ctrl_reg14[0];
   assign overflow_intr14 = ~cntr_ctrl_reg14[1] & (count_val14 == 16'h0000)
      & (counting14) & ~cntr_ctrl_reg14[4] & ~cntr_ctrl_reg14[0];
   assign match_intr14[1]  =  cntr_ctrl_reg14[3] & (count_val14 == match_1_reg14)
      & (counting14) & ~cntr_ctrl_reg14[4] & ~cntr_ctrl_reg14[0];
   assign match_intr14[2]  =  cntr_ctrl_reg14[3] & (count_val14 == match_2_reg14)
      & (counting14) & ~cntr_ctrl_reg14[4] & ~cntr_ctrl_reg14[0];
   assign match_intr14[3]  =  cntr_ctrl_reg14[3] & (count_val14 == match_3_reg14)
      & (counting14) & ~cntr_ctrl_reg14[4] & ~cntr_ctrl_reg14[0];


//    p_reg_ctrl14: Process14 to write to the counter control14 registers
//    cntr_ctrl_reg14 decode:  0 - Counter14 Enable14 Active14 Low14
//                           1 - Interval14 Mode14 =1, Overflow14 =0
//                           2 - Decrement14 Mode14
//                           3 - Match14 Mode14
//                           4 - Restart14
//                           5 - Waveform14 enable active low14
//                           6 - Waveform14 polarity14
   
   always @ (posedge pclk14 or negedge n_p_reset14)
   begin: p_reg_ctrl14  // Register writes
      
      if (!n_p_reset14)                                   
      begin                                     
         cntr_ctrl_reg14 <= 7'b0000001;
         interval_reg14  <= 16'h0000;
         match_1_reg14   <= 16'h0000;
         match_2_reg14   <= 16'h0000;
         match_3_reg14   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel14)
            cntr_ctrl_reg14 <= pwdata14[6:0];
         else if (restart_temp14)
            cntr_ctrl_reg14[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg14 <= cntr_ctrl_reg14;             

         interval_reg14  <= (interval_reg_sel14) ? pwdata14 : interval_reg14;
         match_1_reg14   <= (match_1_reg_sel14)  ? pwdata14 : match_1_reg14;
         match_2_reg14   <= (match_2_reg_sel14)  ? pwdata14 : match_2_reg14;
         match_3_reg14   <= (match_3_reg_sel14)  ? pwdata14 : match_3_reg14;   
      end
      
   end  //p_reg_ctrl14

   
//    p_cntr14: Process14 to increment or decrement the counter on receiving14 a 
//            count_en14 signal14 from the pre_scaler14. Count14 can be restarted14
//            or disabled and can overflow14 at a specified interval14 value.
   
   
   always @ (posedge pclk14 or negedge n_p_reset14)
   begin: p_cntr14   // Counter14 block

      if (!n_p_reset14)     //System14 Reset14
      begin                     
         count_val14 <= 16'h0000;
         counting14  <= 1'b0;
         restart_temp14 <= 1'b0;
      end
      else if (count_en14)
      begin
         
         if (cntr_ctrl_reg14[4])     //Restart14
         begin     
            if (~cntr_ctrl_reg14[2])  
               count_val14         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg14[1])
                 count_val14         <= interval_reg14;     
              else
                 count_val14         <= 16'hFFFF;     
            end
            counting14       <= 1'b0;
            restart_temp14   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg14[0])          //Low14 Active14 Counter14 Enable14
            begin

               if (cntr_ctrl_reg14[1])  //Interval14               
                  if (cntr_ctrl_reg14[2])  //Decrement14        
                  begin
                     if (count_val14 == 16'h0000)
                        count_val14 <= interval_reg14;  //Assumed14 Static14
                     else
                        count_val14 <= count_val14 - 16'h0001;
                  end
                  else                   //Increment14
                  begin
                     if (count_val14 == interval_reg14)
                        count_val14 <= 16'h0000;
                     else           
                        count_val14 <= count_val14 + 16'h0001;
                  end
               else    
               begin  //Overflow14
                  if (cntr_ctrl_reg14[2])   //Decrement14
                  begin
                     if (count_val14 == 16'h0000)
                        count_val14 <= 16'hFFFF;
                     else           
                        count_val14 <= count_val14 - 16'h0001;
                  end
                  else                    //Increment14
                  begin
                     if (count_val14 == 16'hFFFF)
                        count_val14 <= 16'h0000;
                     else           
                        count_val14 <= count_val14 + 16'h0001;
                  end 
               end
               counting14  <= 1'b1;
            end     
            else
               count_val14 <= count_val14;   //Disabled14
   
            restart_temp14 <= 1'b0;
      
         end
     
      end // if (count_en14)

      else
      begin
         count_val14    <= count_val14;
         counting14     <= counting14;
         restart_temp14 <= restart_temp14;               
      end
     
   end  //p_cntr14

endmodule
