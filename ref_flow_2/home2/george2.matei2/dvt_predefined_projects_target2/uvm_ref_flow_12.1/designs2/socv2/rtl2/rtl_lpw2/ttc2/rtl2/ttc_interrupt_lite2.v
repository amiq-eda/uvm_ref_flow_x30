//File2 name   : ttc_interrupt_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 : Interrupts2 from the counter modules2 are registered
//              and if enabled cause the output interrupt2 to go2 high2.
//              Also2 the match12 interrupts2 are monitored2 to generate output 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module2 definition2
//-----------------------------------------------------------------------------

module ttc_interrupt_lite2(

  //inputs2
  n_p_reset2,                             
  pwdata2,                             
  pclk2,
  intr_en_reg_sel2, 
  clear_interrupt2,                   
  interval_intr2,
  match_intr2,
  overflow_intr2,
  restart2,

  //outputs2
  interrupt2,
  interrupt_reg_out2,
  interrupt_en_out2
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS2
//-----------------------------------------------------------------------------

   //inputs2
   input         n_p_reset2;            //reset signal2
   input [5:0]   pwdata2;               //6 Bit2 Data signal2
   input         pclk2;                 //System2 clock2
   input         intr_en_reg_sel2;      //Interrupt2 Enable2 Reg2 Select2 signal2
   input         clear_interrupt2;      //Clear Interrupt2 Register signal2
   input         interval_intr2;        //Timer_Counter2 Interval2 Interrupt2
   input [3:1]   match_intr2;           //Timer_Counter2 Match2 1 Interrupt2 
   input         overflow_intr2;        //Timer_Counter2 Overflow2 Interrupt2 
   input         restart2;              //Counter2 restart2

   //Outputs2
   output        interrupt2;            //Interrupt2 Signal2 
   output [5:0]  interrupt_reg_out2;    //6 Bit2 Interrupt2 Register
   output [5:0]  interrupt_en_out2; //6 Bit2 Interrupt2 Enable2 Register


//-----------------------------------------------------------------------------
// Internal Signals2 & Registers2
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect2;          //Interrupts2 from the Timer_Counter2
   reg [5:0]    int_sync_reg2;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg2;        //6-bit register ensuring2 each interrupt2 
                                      //only read once2
   reg [5:0]    interrupt_reg2;        //6-bit interrupt2 register        
   reg [5:0]    interrupt_en_reg2; //6-bit interrupt2 enable register
   

   reg          interrupt_set2;        //Prevents2 unread2 interrupt2 being cleared2
   
   wire         interrupt2;            //Interrupt2 output
   wire [5:0]   interrupt_reg_out2;    //Interrupt2 register output
   wire [5:0]   interrupt_en_out2; //Interrupt2 enable output


   assign interrupt2              = |(interrupt_reg2);
   assign interrupt_reg_out2      = interrupt_reg2;
   assign interrupt_en_out2       = interrupt_en_reg2;
   
   assign intr_detect2 = {1'b0,
                         overflow_intr2,  
                         match_intr2[3],  
                         match_intr2[2], 
                         match_intr2[1], 
                         interval_intr2};

   

// Setting interrupt2 registers
   
   always @ (posedge pclk2 or negedge n_p_reset2)
   begin: p_intr_reg_ctrl2
      
      if (!n_p_reset2)
      begin
         int_sync_reg2         <= 6'b000000;
         interrupt_reg2        <= 6'b000000;
         int_cycle_reg2        <= 6'b000000;
         interrupt_set2        <= 1'b0;
      end
      else 
      begin

         int_sync_reg2    <= intr_detect2;
         int_cycle_reg2   <= ~int_sync_reg2 & intr_detect2;

         interrupt_set2   <= |int_cycle_reg2;
          
         if (clear_interrupt2 & ~interrupt_set2)
            interrupt_reg2 <= (6'b000000 | (int_cycle_reg2 & interrupt_en_reg2));
         else 
            interrupt_reg2 <= (interrupt_reg2 | (int_cycle_reg2 & 
                                               interrupt_en_reg2));
      end 
      
   end  //p_intr_reg_ctrl2


// Setting interrupt2 enable register
   
   always @ (posedge pclk2 or negedge n_p_reset2)
   begin: p_intr_en_reg2
      
      if (!n_p_reset2)
      begin
         interrupt_en_reg2 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel2)
            interrupt_en_reg2 <= pwdata2[5:0];
         else
            interrupt_en_reg2 <= interrupt_en_reg2;

      end 
      
   end  
           


endmodule

