//File23 name   : ttc_counter_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 :The counter can increment and decrement.
//   In increment mode instead of counting23 to its full 16 bit
//   value the counter counts23 up to or down from a programmed23 interval23 value.
//   Interrupts23 are issued23 when the counter overflows23 or reaches23 it's interval23
//   value. In match mode if the count value equals23 that stored23 in one of three23
//   match registers an interrupt23 is issued23.
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------
//


module ttc_counter_lite23(

  //inputs23
  n_p_reset23,    
  pclk23,          
  pwdata23,              
  count_en23,
  cntr_ctrl_reg_sel23, 
  interval_reg_sel23,
  match_1_reg_sel23,
  match_2_reg_sel23,
  match_3_reg_sel23,         

  //outputs23    
  count_val_out23,
  cntr_ctrl_reg_out23,
  interval_reg_out23,
  match_1_reg_out23,
  match_2_reg_out23,
  match_3_reg_out23,
  interval_intr23,
  match_intr23,
  overflow_intr23

);


//--------------------------------------------------------------------
// PORT DECLARATIONS23
//--------------------------------------------------------------------

   //inputs23
   input          n_p_reset23;         //reset signal23
   input          pclk23;              //System23 Clock23
   input [15:0]   pwdata23;            //6 Bit23 data signal23
   input          count_en23;          //Count23 enable signal23
   input          cntr_ctrl_reg_sel23; //Select23 bit for ctrl_reg23
   input          interval_reg_sel23;  //Interval23 Select23 Register
   input          match_1_reg_sel23;   //Match23 1 Select23 register
   input          match_2_reg_sel23;   //Match23 2 Select23 register
   input          match_3_reg_sel23;   //Match23 3 Select23 register

   //outputs23
   output [15:0]  count_val_out23;        //Value for counter reg
   output [6:0]   cntr_ctrl_reg_out23;    //Counter23 control23 reg select23
   output [15:0]  interval_reg_out23;     //Interval23 reg
   output [15:0]  match_1_reg_out23;      //Match23 1 register
   output [15:0]  match_2_reg_out23;      //Match23 2 register
   output [15:0]  match_3_reg_out23;      //Match23 3 register
   output         interval_intr23;        //Interval23 interrupt23
   output [3:1]   match_intr23;           //Match23 interrupt23
   output         overflow_intr23;        //Overflow23 interrupt23

//--------------------------------------------------------------------
// Internal Signals23 & Registers23
//--------------------------------------------------------------------

   reg [6:0]      cntr_ctrl_reg23;     // 5-bit Counter23 Control23 Register
   reg [15:0]     interval_reg23;      //16-bit Interval23 Register 
   reg [15:0]     match_1_reg23;       //16-bit Match_123 Register
   reg [15:0]     match_2_reg23;       //16-bit Match_223 Register
   reg [15:0]     match_3_reg23;       //16-bit Match_323 Register
   reg [15:0]     count_val23;         //16-bit counter value register
                                                                      
   
   reg            counting23;          //counter has starting counting23
   reg            restart_temp23;   //ensures23 soft23 reset lasts23 1 cycle    
   
   wire [6:0]     cntr_ctrl_reg_out23; //7-bit Counter23 Control23 Register
   wire [15:0]    interval_reg_out23;  //16-bit Interval23 Register 
   wire [15:0]    match_1_reg_out23;   //16-bit Match_123 Register
   wire [15:0]    match_2_reg_out23;   //16-bit Match_223 Register
   wire [15:0]    match_3_reg_out23;   //16-bit Match_323 Register
   wire [15:0]    count_val_out23;     //16-bit counter value register

//-------------------------------------------------------------------
// Assign23 output wires23
//-------------------------------------------------------------------

   assign cntr_ctrl_reg_out23 = cntr_ctrl_reg23;    // 7-bit Counter23 Control23
   assign interval_reg_out23  = interval_reg23;     // 16-bit Interval23
   assign match_1_reg_out23   = match_1_reg23;      // 16-bit Match_123
   assign match_2_reg_out23   = match_2_reg23;      // 16-bit Match_223 
   assign match_3_reg_out23   = match_3_reg23;      // 16-bit Match_323 
   assign count_val_out23     = count_val23;        // 16-bit counter value
   
//--------------------------------------------------------------------
// Assigning23 interrupts23
//--------------------------------------------------------------------

   assign interval_intr23 =  cntr_ctrl_reg23[1] & (count_val23 == 16'h0000)
      & (counting23) & ~cntr_ctrl_reg23[4] & ~cntr_ctrl_reg23[0];
   assign overflow_intr23 = ~cntr_ctrl_reg23[1] & (count_val23 == 16'h0000)
      & (counting23) & ~cntr_ctrl_reg23[4] & ~cntr_ctrl_reg23[0];
   assign match_intr23[1]  =  cntr_ctrl_reg23[3] & (count_val23 == match_1_reg23)
      & (counting23) & ~cntr_ctrl_reg23[4] & ~cntr_ctrl_reg23[0];
   assign match_intr23[2]  =  cntr_ctrl_reg23[3] & (count_val23 == match_2_reg23)
      & (counting23) & ~cntr_ctrl_reg23[4] & ~cntr_ctrl_reg23[0];
   assign match_intr23[3]  =  cntr_ctrl_reg23[3] & (count_val23 == match_3_reg23)
      & (counting23) & ~cntr_ctrl_reg23[4] & ~cntr_ctrl_reg23[0];


//    p_reg_ctrl23: Process23 to write to the counter control23 registers
//    cntr_ctrl_reg23 decode:  0 - Counter23 Enable23 Active23 Low23
//                           1 - Interval23 Mode23 =1, Overflow23 =0
//                           2 - Decrement23 Mode23
//                           3 - Match23 Mode23
//                           4 - Restart23
//                           5 - Waveform23 enable active low23
//                           6 - Waveform23 polarity23
   
   always @ (posedge pclk23 or negedge n_p_reset23)
   begin: p_reg_ctrl23  // Register writes
      
      if (!n_p_reset23)                                   
      begin                                     
         cntr_ctrl_reg23 <= 7'b0000001;
         interval_reg23  <= 16'h0000;
         match_1_reg23   <= 16'h0000;
         match_2_reg23   <= 16'h0000;
         match_3_reg23   <= 16'h0000;  
      end    
      else 
      begin
         if (cntr_ctrl_reg_sel23)
            cntr_ctrl_reg23 <= pwdata23[6:0];
         else if (restart_temp23)
            cntr_ctrl_reg23[4]  <= 1'b0;    
         else 
            cntr_ctrl_reg23 <= cntr_ctrl_reg23;             

         interval_reg23  <= (interval_reg_sel23) ? pwdata23 : interval_reg23;
         match_1_reg23   <= (match_1_reg_sel23)  ? pwdata23 : match_1_reg23;
         match_2_reg23   <= (match_2_reg_sel23)  ? pwdata23 : match_2_reg23;
         match_3_reg23   <= (match_3_reg_sel23)  ? pwdata23 : match_3_reg23;   
      end
      
   end  //p_reg_ctrl23

   
//    p_cntr23: Process23 to increment or decrement the counter on receiving23 a 
//            count_en23 signal23 from the pre_scaler23. Count23 can be restarted23
//            or disabled and can overflow23 at a specified interval23 value.
   
   
   always @ (posedge pclk23 or negedge n_p_reset23)
   begin: p_cntr23   // Counter23 block

      if (!n_p_reset23)     //System23 Reset23
      begin                     
         count_val23 <= 16'h0000;
         counting23  <= 1'b0;
         restart_temp23 <= 1'b0;
      end
      else if (count_en23)
      begin
         
         if (cntr_ctrl_reg23[4])     //Restart23
         begin     
            if (~cntr_ctrl_reg23[2])  
               count_val23         <= 16'h0000;
            else
            begin
              if (cntr_ctrl_reg23[1])
                 count_val23         <= interval_reg23;     
              else
                 count_val23         <= 16'hFFFF;     
            end
            counting23       <= 1'b0;
            restart_temp23   <= 1'b1;

         end
         else 
         begin
            if (!cntr_ctrl_reg23[0])          //Low23 Active23 Counter23 Enable23
            begin

               if (cntr_ctrl_reg23[1])  //Interval23               
                  if (cntr_ctrl_reg23[2])  //Decrement23        
                  begin
                     if (count_val23 == 16'h0000)
                        count_val23 <= interval_reg23;  //Assumed23 Static23
                     else
                        count_val23 <= count_val23 - 16'h0001;
                  end
                  else                   //Increment23
                  begin
                     if (count_val23 == interval_reg23)
                        count_val23 <= 16'h0000;
                     else           
                        count_val23 <= count_val23 + 16'h0001;
                  end
               else    
               begin  //Overflow23
                  if (cntr_ctrl_reg23[2])   //Decrement23
                  begin
                     if (count_val23 == 16'h0000)
                        count_val23 <= 16'hFFFF;
                     else           
                        count_val23 <= count_val23 - 16'h0001;
                  end
                  else                    //Increment23
                  begin
                     if (count_val23 == 16'hFFFF)
                        count_val23 <= 16'h0000;
                     else           
                        count_val23 <= count_val23 + 16'h0001;
                  end 
               end
               counting23  <= 1'b1;
            end     
            else
               count_val23 <= count_val23;   //Disabled23
   
            restart_temp23 <= 1'b0;
      
         end
     
      end // if (count_en23)

      else
      begin
         count_val23    <= count_val23;
         counting23     <= counting23;
         restart_temp23 <= restart_temp23;               
      end
     
   end  //p_cntr23

endmodule
