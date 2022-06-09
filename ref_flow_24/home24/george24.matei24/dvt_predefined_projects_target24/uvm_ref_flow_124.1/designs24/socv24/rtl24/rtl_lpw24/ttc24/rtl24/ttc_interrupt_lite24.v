//File24 name   : ttc_interrupt_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 : Interrupts24 from the counter modules24 are registered
//              and if enabled cause the output interrupt24 to go24 high24.
//              Also24 the match124 interrupts24 are monitored24 to generate output 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module24 definition24
//-----------------------------------------------------------------------------

module ttc_interrupt_lite24(

  //inputs24
  n_p_reset24,                             
  pwdata24,                             
  pclk24,
  intr_en_reg_sel24, 
  clear_interrupt24,                   
  interval_intr24,
  match_intr24,
  overflow_intr24,
  restart24,

  //outputs24
  interrupt24,
  interrupt_reg_out24,
  interrupt_en_out24
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS24
//-----------------------------------------------------------------------------

   //inputs24
   input         n_p_reset24;            //reset signal24
   input [5:0]   pwdata24;               //6 Bit24 Data signal24
   input         pclk24;                 //System24 clock24
   input         intr_en_reg_sel24;      //Interrupt24 Enable24 Reg24 Select24 signal24
   input         clear_interrupt24;      //Clear Interrupt24 Register signal24
   input         interval_intr24;        //Timer_Counter24 Interval24 Interrupt24
   input [3:1]   match_intr24;           //Timer_Counter24 Match24 1 Interrupt24 
   input         overflow_intr24;        //Timer_Counter24 Overflow24 Interrupt24 
   input         restart24;              //Counter24 restart24

   //Outputs24
   output        interrupt24;            //Interrupt24 Signal24 
   output [5:0]  interrupt_reg_out24;    //6 Bit24 Interrupt24 Register
   output [5:0]  interrupt_en_out24; //6 Bit24 Interrupt24 Enable24 Register


//-----------------------------------------------------------------------------
// Internal Signals24 & Registers24
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect24;          //Interrupts24 from the Timer_Counter24
   reg [5:0]    int_sync_reg24;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg24;        //6-bit register ensuring24 each interrupt24 
                                      //only read once24
   reg [5:0]    interrupt_reg24;        //6-bit interrupt24 register        
   reg [5:0]    interrupt_en_reg24; //6-bit interrupt24 enable register
   

   reg          interrupt_set24;        //Prevents24 unread24 interrupt24 being cleared24
   
   wire         interrupt24;            //Interrupt24 output
   wire [5:0]   interrupt_reg_out24;    //Interrupt24 register output
   wire [5:0]   interrupt_en_out24; //Interrupt24 enable output


   assign interrupt24              = |(interrupt_reg24);
   assign interrupt_reg_out24      = interrupt_reg24;
   assign interrupt_en_out24       = interrupt_en_reg24;
   
   assign intr_detect24 = {1'b0,
                         overflow_intr24,  
                         match_intr24[3],  
                         match_intr24[2], 
                         match_intr24[1], 
                         interval_intr24};

   

// Setting interrupt24 registers
   
   always @ (posedge pclk24 or negedge n_p_reset24)
   begin: p_intr_reg_ctrl24
      
      if (!n_p_reset24)
      begin
         int_sync_reg24         <= 6'b000000;
         interrupt_reg24        <= 6'b000000;
         int_cycle_reg24        <= 6'b000000;
         interrupt_set24        <= 1'b0;
      end
      else 
      begin

         int_sync_reg24    <= intr_detect24;
         int_cycle_reg24   <= ~int_sync_reg24 & intr_detect24;

         interrupt_set24   <= |int_cycle_reg24;
          
         if (clear_interrupt24 & ~interrupt_set24)
            interrupt_reg24 <= (6'b000000 | (int_cycle_reg24 & interrupt_en_reg24));
         else 
            interrupt_reg24 <= (interrupt_reg24 | (int_cycle_reg24 & 
                                               interrupt_en_reg24));
      end 
      
   end  //p_intr_reg_ctrl24


// Setting interrupt24 enable register
   
   always @ (posedge pclk24 or negedge n_p_reset24)
   begin: p_intr_en_reg24
      
      if (!n_p_reset24)
      begin
         interrupt_en_reg24 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel24)
            interrupt_en_reg24 <= pwdata24[5:0];
         else
            interrupt_en_reg24 <= interrupt_en_reg24;

      end 
      
   end  
           


endmodule

