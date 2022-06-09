//File30 name   : ttc_interrupt_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 : Interrupts30 from the counter modules30 are registered
//              and if enabled cause the output interrupt30 to go30 high30.
//              Also30 the match130 interrupts30 are monitored30 to generate output 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module30 definition30
//-----------------------------------------------------------------------------

module ttc_interrupt_lite30(

  //inputs30
  n_p_reset30,                             
  pwdata30,                             
  pclk30,
  intr_en_reg_sel30, 
  clear_interrupt30,                   
  interval_intr30,
  match_intr30,
  overflow_intr30,
  restart30,

  //outputs30
  interrupt30,
  interrupt_reg_out30,
  interrupt_en_out30
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS30
//-----------------------------------------------------------------------------

   //inputs30
   input         n_p_reset30;            //reset signal30
   input [5:0]   pwdata30;               //6 Bit30 Data signal30
   input         pclk30;                 //System30 clock30
   input         intr_en_reg_sel30;      //Interrupt30 Enable30 Reg30 Select30 signal30
   input         clear_interrupt30;      //Clear Interrupt30 Register signal30
   input         interval_intr30;        //Timer_Counter30 Interval30 Interrupt30
   input [3:1]   match_intr30;           //Timer_Counter30 Match30 1 Interrupt30 
   input         overflow_intr30;        //Timer_Counter30 Overflow30 Interrupt30 
   input         restart30;              //Counter30 restart30

   //Outputs30
   output        interrupt30;            //Interrupt30 Signal30 
   output [5:0]  interrupt_reg_out30;    //6 Bit30 Interrupt30 Register
   output [5:0]  interrupt_en_out30; //6 Bit30 Interrupt30 Enable30 Register


//-----------------------------------------------------------------------------
// Internal Signals30 & Registers30
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect30;          //Interrupts30 from the Timer_Counter30
   reg [5:0]    int_sync_reg30;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg30;        //6-bit register ensuring30 each interrupt30 
                                      //only read once30
   reg [5:0]    interrupt_reg30;        //6-bit interrupt30 register        
   reg [5:0]    interrupt_en_reg30; //6-bit interrupt30 enable register
   

   reg          interrupt_set30;        //Prevents30 unread30 interrupt30 being cleared30
   
   wire         interrupt30;            //Interrupt30 output
   wire [5:0]   interrupt_reg_out30;    //Interrupt30 register output
   wire [5:0]   interrupt_en_out30; //Interrupt30 enable output


   assign interrupt30              = |(interrupt_reg30);
   assign interrupt_reg_out30      = interrupt_reg30;
   assign interrupt_en_out30       = interrupt_en_reg30;
   
   assign intr_detect30 = {1'b0,
                         overflow_intr30,  
                         match_intr30[3],  
                         match_intr30[2], 
                         match_intr30[1], 
                         interval_intr30};

   

// Setting interrupt30 registers
   
   always @ (posedge pclk30 or negedge n_p_reset30)
   begin: p_intr_reg_ctrl30
      
      if (!n_p_reset30)
      begin
         int_sync_reg30         <= 6'b000000;
         interrupt_reg30        <= 6'b000000;
         int_cycle_reg30        <= 6'b000000;
         interrupt_set30        <= 1'b0;
      end
      else 
      begin

         int_sync_reg30    <= intr_detect30;
         int_cycle_reg30   <= ~int_sync_reg30 & intr_detect30;

         interrupt_set30   <= |int_cycle_reg30;
          
         if (clear_interrupt30 & ~interrupt_set30)
            interrupt_reg30 <= (6'b000000 | (int_cycle_reg30 & interrupt_en_reg30));
         else 
            interrupt_reg30 <= (interrupt_reg30 | (int_cycle_reg30 & 
                                               interrupt_en_reg30));
      end 
      
   end  //p_intr_reg_ctrl30


// Setting interrupt30 enable register
   
   always @ (posedge pclk30 or negedge n_p_reset30)
   begin: p_intr_en_reg30
      
      if (!n_p_reset30)
      begin
         interrupt_en_reg30 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel30)
            interrupt_en_reg30 <= pwdata30[5:0];
         else
            interrupt_en_reg30 <= interrupt_en_reg30;

      end 
      
   end  
           


endmodule

