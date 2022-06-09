//File16 name   : ttc_interrupt_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 : Interrupts16 from the counter modules16 are registered
//              and if enabled cause the output interrupt16 to go16 high16.
//              Also16 the match116 interrupts16 are monitored16 to generate output 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module16 definition16
//-----------------------------------------------------------------------------

module ttc_interrupt_lite16(

  //inputs16
  n_p_reset16,                             
  pwdata16,                             
  pclk16,
  intr_en_reg_sel16, 
  clear_interrupt16,                   
  interval_intr16,
  match_intr16,
  overflow_intr16,
  restart16,

  //outputs16
  interrupt16,
  interrupt_reg_out16,
  interrupt_en_out16
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS16
//-----------------------------------------------------------------------------

   //inputs16
   input         n_p_reset16;            //reset signal16
   input [5:0]   pwdata16;               //6 Bit16 Data signal16
   input         pclk16;                 //System16 clock16
   input         intr_en_reg_sel16;      //Interrupt16 Enable16 Reg16 Select16 signal16
   input         clear_interrupt16;      //Clear Interrupt16 Register signal16
   input         interval_intr16;        //Timer_Counter16 Interval16 Interrupt16
   input [3:1]   match_intr16;           //Timer_Counter16 Match16 1 Interrupt16 
   input         overflow_intr16;        //Timer_Counter16 Overflow16 Interrupt16 
   input         restart16;              //Counter16 restart16

   //Outputs16
   output        interrupt16;            //Interrupt16 Signal16 
   output [5:0]  interrupt_reg_out16;    //6 Bit16 Interrupt16 Register
   output [5:0]  interrupt_en_out16; //6 Bit16 Interrupt16 Enable16 Register


//-----------------------------------------------------------------------------
// Internal Signals16 & Registers16
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect16;          //Interrupts16 from the Timer_Counter16
   reg [5:0]    int_sync_reg16;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg16;        //6-bit register ensuring16 each interrupt16 
                                      //only read once16
   reg [5:0]    interrupt_reg16;        //6-bit interrupt16 register        
   reg [5:0]    interrupt_en_reg16; //6-bit interrupt16 enable register
   

   reg          interrupt_set16;        //Prevents16 unread16 interrupt16 being cleared16
   
   wire         interrupt16;            //Interrupt16 output
   wire [5:0]   interrupt_reg_out16;    //Interrupt16 register output
   wire [5:0]   interrupt_en_out16; //Interrupt16 enable output


   assign interrupt16              = |(interrupt_reg16);
   assign interrupt_reg_out16      = interrupt_reg16;
   assign interrupt_en_out16       = interrupt_en_reg16;
   
   assign intr_detect16 = {1'b0,
                         overflow_intr16,  
                         match_intr16[3],  
                         match_intr16[2], 
                         match_intr16[1], 
                         interval_intr16};

   

// Setting interrupt16 registers
   
   always @ (posedge pclk16 or negedge n_p_reset16)
   begin: p_intr_reg_ctrl16
      
      if (!n_p_reset16)
      begin
         int_sync_reg16         <= 6'b000000;
         interrupt_reg16        <= 6'b000000;
         int_cycle_reg16        <= 6'b000000;
         interrupt_set16        <= 1'b0;
      end
      else 
      begin

         int_sync_reg16    <= intr_detect16;
         int_cycle_reg16   <= ~int_sync_reg16 & intr_detect16;

         interrupt_set16   <= |int_cycle_reg16;
          
         if (clear_interrupt16 & ~interrupt_set16)
            interrupt_reg16 <= (6'b000000 | (int_cycle_reg16 & interrupt_en_reg16));
         else 
            interrupt_reg16 <= (interrupt_reg16 | (int_cycle_reg16 & 
                                               interrupt_en_reg16));
      end 
      
   end  //p_intr_reg_ctrl16


// Setting interrupt16 enable register
   
   always @ (posedge pclk16 or negedge n_p_reset16)
   begin: p_intr_en_reg16
      
      if (!n_p_reset16)
      begin
         interrupt_en_reg16 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel16)
            interrupt_en_reg16 <= pwdata16[5:0];
         else
            interrupt_en_reg16 <= interrupt_en_reg16;

      end 
      
   end  
           


endmodule

