//File10 name   : ttc_interrupt_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 : Interrupts10 from the counter modules10 are registered
//              and if enabled cause the output interrupt10 to go10 high10.
//              Also10 the match110 interrupts10 are monitored10 to generate output 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module10 definition10
//-----------------------------------------------------------------------------

module ttc_interrupt_lite10(

  //inputs10
  n_p_reset10,                             
  pwdata10,                             
  pclk10,
  intr_en_reg_sel10, 
  clear_interrupt10,                   
  interval_intr10,
  match_intr10,
  overflow_intr10,
  restart10,

  //outputs10
  interrupt10,
  interrupt_reg_out10,
  interrupt_en_out10
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS10
//-----------------------------------------------------------------------------

   //inputs10
   input         n_p_reset10;            //reset signal10
   input [5:0]   pwdata10;               //6 Bit10 Data signal10
   input         pclk10;                 //System10 clock10
   input         intr_en_reg_sel10;      //Interrupt10 Enable10 Reg10 Select10 signal10
   input         clear_interrupt10;      //Clear Interrupt10 Register signal10
   input         interval_intr10;        //Timer_Counter10 Interval10 Interrupt10
   input [3:1]   match_intr10;           //Timer_Counter10 Match10 1 Interrupt10 
   input         overflow_intr10;        //Timer_Counter10 Overflow10 Interrupt10 
   input         restart10;              //Counter10 restart10

   //Outputs10
   output        interrupt10;            //Interrupt10 Signal10 
   output [5:0]  interrupt_reg_out10;    //6 Bit10 Interrupt10 Register
   output [5:0]  interrupt_en_out10; //6 Bit10 Interrupt10 Enable10 Register


//-----------------------------------------------------------------------------
// Internal Signals10 & Registers10
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect10;          //Interrupts10 from the Timer_Counter10
   reg [5:0]    int_sync_reg10;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg10;        //6-bit register ensuring10 each interrupt10 
                                      //only read once10
   reg [5:0]    interrupt_reg10;        //6-bit interrupt10 register        
   reg [5:0]    interrupt_en_reg10; //6-bit interrupt10 enable register
   

   reg          interrupt_set10;        //Prevents10 unread10 interrupt10 being cleared10
   
   wire         interrupt10;            //Interrupt10 output
   wire [5:0]   interrupt_reg_out10;    //Interrupt10 register output
   wire [5:0]   interrupt_en_out10; //Interrupt10 enable output


   assign interrupt10              = |(interrupt_reg10);
   assign interrupt_reg_out10      = interrupt_reg10;
   assign interrupt_en_out10       = interrupt_en_reg10;
   
   assign intr_detect10 = {1'b0,
                         overflow_intr10,  
                         match_intr10[3],  
                         match_intr10[2], 
                         match_intr10[1], 
                         interval_intr10};

   

// Setting interrupt10 registers
   
   always @ (posedge pclk10 or negedge n_p_reset10)
   begin: p_intr_reg_ctrl10
      
      if (!n_p_reset10)
      begin
         int_sync_reg10         <= 6'b000000;
         interrupt_reg10        <= 6'b000000;
         int_cycle_reg10        <= 6'b000000;
         interrupt_set10        <= 1'b0;
      end
      else 
      begin

         int_sync_reg10    <= intr_detect10;
         int_cycle_reg10   <= ~int_sync_reg10 & intr_detect10;

         interrupt_set10   <= |int_cycle_reg10;
          
         if (clear_interrupt10 & ~interrupt_set10)
            interrupt_reg10 <= (6'b000000 | (int_cycle_reg10 & interrupt_en_reg10));
         else 
            interrupt_reg10 <= (interrupt_reg10 | (int_cycle_reg10 & 
                                               interrupt_en_reg10));
      end 
      
   end  //p_intr_reg_ctrl10


// Setting interrupt10 enable register
   
   always @ (posedge pclk10 or negedge n_p_reset10)
   begin: p_intr_en_reg10
      
      if (!n_p_reset10)
      begin
         interrupt_en_reg10 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel10)
            interrupt_en_reg10 <= pwdata10[5:0];
         else
            interrupt_en_reg10 <= interrupt_en_reg10;

      end 
      
   end  
           


endmodule

