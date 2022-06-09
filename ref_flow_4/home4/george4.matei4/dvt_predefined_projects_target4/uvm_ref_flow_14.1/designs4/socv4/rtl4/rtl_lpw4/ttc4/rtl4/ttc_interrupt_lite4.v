//File4 name   : ttc_interrupt_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 : Interrupts4 from the counter modules4 are registered
//              and if enabled cause the output interrupt4 to go4 high4.
//              Also4 the match14 interrupts4 are monitored4 to generate output 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module4 definition4
//-----------------------------------------------------------------------------

module ttc_interrupt_lite4(

  //inputs4
  n_p_reset4,                             
  pwdata4,                             
  pclk4,
  intr_en_reg_sel4, 
  clear_interrupt4,                   
  interval_intr4,
  match_intr4,
  overflow_intr4,
  restart4,

  //outputs4
  interrupt4,
  interrupt_reg_out4,
  interrupt_en_out4
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS4
//-----------------------------------------------------------------------------

   //inputs4
   input         n_p_reset4;            //reset signal4
   input [5:0]   pwdata4;               //6 Bit4 Data signal4
   input         pclk4;                 //System4 clock4
   input         intr_en_reg_sel4;      //Interrupt4 Enable4 Reg4 Select4 signal4
   input         clear_interrupt4;      //Clear Interrupt4 Register signal4
   input         interval_intr4;        //Timer_Counter4 Interval4 Interrupt4
   input [3:1]   match_intr4;           //Timer_Counter4 Match4 1 Interrupt4 
   input         overflow_intr4;        //Timer_Counter4 Overflow4 Interrupt4 
   input         restart4;              //Counter4 restart4

   //Outputs4
   output        interrupt4;            //Interrupt4 Signal4 
   output [5:0]  interrupt_reg_out4;    //6 Bit4 Interrupt4 Register
   output [5:0]  interrupt_en_out4; //6 Bit4 Interrupt4 Enable4 Register


//-----------------------------------------------------------------------------
// Internal Signals4 & Registers4
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect4;          //Interrupts4 from the Timer_Counter4
   reg [5:0]    int_sync_reg4;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg4;        //6-bit register ensuring4 each interrupt4 
                                      //only read once4
   reg [5:0]    interrupt_reg4;        //6-bit interrupt4 register        
   reg [5:0]    interrupt_en_reg4; //6-bit interrupt4 enable register
   

   reg          interrupt_set4;        //Prevents4 unread4 interrupt4 being cleared4
   
   wire         interrupt4;            //Interrupt4 output
   wire [5:0]   interrupt_reg_out4;    //Interrupt4 register output
   wire [5:0]   interrupt_en_out4; //Interrupt4 enable output


   assign interrupt4              = |(interrupt_reg4);
   assign interrupt_reg_out4      = interrupt_reg4;
   assign interrupt_en_out4       = interrupt_en_reg4;
   
   assign intr_detect4 = {1'b0,
                         overflow_intr4,  
                         match_intr4[3],  
                         match_intr4[2], 
                         match_intr4[1], 
                         interval_intr4};

   

// Setting interrupt4 registers
   
   always @ (posedge pclk4 or negedge n_p_reset4)
   begin: p_intr_reg_ctrl4
      
      if (!n_p_reset4)
      begin
         int_sync_reg4         <= 6'b000000;
         interrupt_reg4        <= 6'b000000;
         int_cycle_reg4        <= 6'b000000;
         interrupt_set4        <= 1'b0;
      end
      else 
      begin

         int_sync_reg4    <= intr_detect4;
         int_cycle_reg4   <= ~int_sync_reg4 & intr_detect4;

         interrupt_set4   <= |int_cycle_reg4;
          
         if (clear_interrupt4 & ~interrupt_set4)
            interrupt_reg4 <= (6'b000000 | (int_cycle_reg4 & interrupt_en_reg4));
         else 
            interrupt_reg4 <= (interrupt_reg4 | (int_cycle_reg4 & 
                                               interrupt_en_reg4));
      end 
      
   end  //p_intr_reg_ctrl4


// Setting interrupt4 enable register
   
   always @ (posedge pclk4 or negedge n_p_reset4)
   begin: p_intr_en_reg4
      
      if (!n_p_reset4)
      begin
         interrupt_en_reg4 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel4)
            interrupt_en_reg4 <= pwdata4[5:0];
         else
            interrupt_en_reg4 <= interrupt_en_reg4;

      end 
      
   end  
           


endmodule

