//File28 name   : ttc_interrupt_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 : Interrupts28 from the counter modules28 are registered
//              and if enabled cause the output interrupt28 to go28 high28.
//              Also28 the match128 interrupts28 are monitored28 to generate output 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module28 definition28
//-----------------------------------------------------------------------------

module ttc_interrupt_lite28(

  //inputs28
  n_p_reset28,                             
  pwdata28,                             
  pclk28,
  intr_en_reg_sel28, 
  clear_interrupt28,                   
  interval_intr28,
  match_intr28,
  overflow_intr28,
  restart28,

  //outputs28
  interrupt28,
  interrupt_reg_out28,
  interrupt_en_out28
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS28
//-----------------------------------------------------------------------------

   //inputs28
   input         n_p_reset28;            //reset signal28
   input [5:0]   pwdata28;               //6 Bit28 Data signal28
   input         pclk28;                 //System28 clock28
   input         intr_en_reg_sel28;      //Interrupt28 Enable28 Reg28 Select28 signal28
   input         clear_interrupt28;      //Clear Interrupt28 Register signal28
   input         interval_intr28;        //Timer_Counter28 Interval28 Interrupt28
   input [3:1]   match_intr28;           //Timer_Counter28 Match28 1 Interrupt28 
   input         overflow_intr28;        //Timer_Counter28 Overflow28 Interrupt28 
   input         restart28;              //Counter28 restart28

   //Outputs28
   output        interrupt28;            //Interrupt28 Signal28 
   output [5:0]  interrupt_reg_out28;    //6 Bit28 Interrupt28 Register
   output [5:0]  interrupt_en_out28; //6 Bit28 Interrupt28 Enable28 Register


//-----------------------------------------------------------------------------
// Internal Signals28 & Registers28
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect28;          //Interrupts28 from the Timer_Counter28
   reg [5:0]    int_sync_reg28;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg28;        //6-bit register ensuring28 each interrupt28 
                                      //only read once28
   reg [5:0]    interrupt_reg28;        //6-bit interrupt28 register        
   reg [5:0]    interrupt_en_reg28; //6-bit interrupt28 enable register
   

   reg          interrupt_set28;        //Prevents28 unread28 interrupt28 being cleared28
   
   wire         interrupt28;            //Interrupt28 output
   wire [5:0]   interrupt_reg_out28;    //Interrupt28 register output
   wire [5:0]   interrupt_en_out28; //Interrupt28 enable output


   assign interrupt28              = |(interrupt_reg28);
   assign interrupt_reg_out28      = interrupt_reg28;
   assign interrupt_en_out28       = interrupt_en_reg28;
   
   assign intr_detect28 = {1'b0,
                         overflow_intr28,  
                         match_intr28[3],  
                         match_intr28[2], 
                         match_intr28[1], 
                         interval_intr28};

   

// Setting interrupt28 registers
   
   always @ (posedge pclk28 or negedge n_p_reset28)
   begin: p_intr_reg_ctrl28
      
      if (!n_p_reset28)
      begin
         int_sync_reg28         <= 6'b000000;
         interrupt_reg28        <= 6'b000000;
         int_cycle_reg28        <= 6'b000000;
         interrupt_set28        <= 1'b0;
      end
      else 
      begin

         int_sync_reg28    <= intr_detect28;
         int_cycle_reg28   <= ~int_sync_reg28 & intr_detect28;

         interrupt_set28   <= |int_cycle_reg28;
          
         if (clear_interrupt28 & ~interrupt_set28)
            interrupt_reg28 <= (6'b000000 | (int_cycle_reg28 & interrupt_en_reg28));
         else 
            interrupt_reg28 <= (interrupt_reg28 | (int_cycle_reg28 & 
                                               interrupt_en_reg28));
      end 
      
   end  //p_intr_reg_ctrl28


// Setting interrupt28 enable register
   
   always @ (posedge pclk28 or negedge n_p_reset28)
   begin: p_intr_en_reg28
      
      if (!n_p_reset28)
      begin
         interrupt_en_reg28 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel28)
            interrupt_en_reg28 <= pwdata28[5:0];
         else
            interrupt_en_reg28 <= interrupt_en_reg28;

      end 
      
   end  
           


endmodule

