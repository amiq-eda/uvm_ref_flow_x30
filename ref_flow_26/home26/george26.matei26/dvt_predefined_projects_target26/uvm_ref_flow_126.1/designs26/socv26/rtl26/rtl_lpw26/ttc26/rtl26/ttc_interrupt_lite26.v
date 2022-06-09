//File26 name   : ttc_interrupt_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 : Interrupts26 from the counter modules26 are registered
//              and if enabled cause the output interrupt26 to go26 high26.
//              Also26 the match126 interrupts26 are monitored26 to generate output 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module26 definition26
//-----------------------------------------------------------------------------

module ttc_interrupt_lite26(

  //inputs26
  n_p_reset26,                             
  pwdata26,                             
  pclk26,
  intr_en_reg_sel26, 
  clear_interrupt26,                   
  interval_intr26,
  match_intr26,
  overflow_intr26,
  restart26,

  //outputs26
  interrupt26,
  interrupt_reg_out26,
  interrupt_en_out26
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS26
//-----------------------------------------------------------------------------

   //inputs26
   input         n_p_reset26;            //reset signal26
   input [5:0]   pwdata26;               //6 Bit26 Data signal26
   input         pclk26;                 //System26 clock26
   input         intr_en_reg_sel26;      //Interrupt26 Enable26 Reg26 Select26 signal26
   input         clear_interrupt26;      //Clear Interrupt26 Register signal26
   input         interval_intr26;        //Timer_Counter26 Interval26 Interrupt26
   input [3:1]   match_intr26;           //Timer_Counter26 Match26 1 Interrupt26 
   input         overflow_intr26;        //Timer_Counter26 Overflow26 Interrupt26 
   input         restart26;              //Counter26 restart26

   //Outputs26
   output        interrupt26;            //Interrupt26 Signal26 
   output [5:0]  interrupt_reg_out26;    //6 Bit26 Interrupt26 Register
   output [5:0]  interrupt_en_out26; //6 Bit26 Interrupt26 Enable26 Register


//-----------------------------------------------------------------------------
// Internal Signals26 & Registers26
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect26;          //Interrupts26 from the Timer_Counter26
   reg [5:0]    int_sync_reg26;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg26;        //6-bit register ensuring26 each interrupt26 
                                      //only read once26
   reg [5:0]    interrupt_reg26;        //6-bit interrupt26 register        
   reg [5:0]    interrupt_en_reg26; //6-bit interrupt26 enable register
   

   reg          interrupt_set26;        //Prevents26 unread26 interrupt26 being cleared26
   
   wire         interrupt26;            //Interrupt26 output
   wire [5:0]   interrupt_reg_out26;    //Interrupt26 register output
   wire [5:0]   interrupt_en_out26; //Interrupt26 enable output


   assign interrupt26              = |(interrupt_reg26);
   assign interrupt_reg_out26      = interrupt_reg26;
   assign interrupt_en_out26       = interrupt_en_reg26;
   
   assign intr_detect26 = {1'b0,
                         overflow_intr26,  
                         match_intr26[3],  
                         match_intr26[2], 
                         match_intr26[1], 
                         interval_intr26};

   

// Setting interrupt26 registers
   
   always @ (posedge pclk26 or negedge n_p_reset26)
   begin: p_intr_reg_ctrl26
      
      if (!n_p_reset26)
      begin
         int_sync_reg26         <= 6'b000000;
         interrupt_reg26        <= 6'b000000;
         int_cycle_reg26        <= 6'b000000;
         interrupt_set26        <= 1'b0;
      end
      else 
      begin

         int_sync_reg26    <= intr_detect26;
         int_cycle_reg26   <= ~int_sync_reg26 & intr_detect26;

         interrupt_set26   <= |int_cycle_reg26;
          
         if (clear_interrupt26 & ~interrupt_set26)
            interrupt_reg26 <= (6'b000000 | (int_cycle_reg26 & interrupt_en_reg26));
         else 
            interrupt_reg26 <= (interrupt_reg26 | (int_cycle_reg26 & 
                                               interrupt_en_reg26));
      end 
      
   end  //p_intr_reg_ctrl26


// Setting interrupt26 enable register
   
   always @ (posedge pclk26 or negedge n_p_reset26)
   begin: p_intr_en_reg26
      
      if (!n_p_reset26)
      begin
         interrupt_en_reg26 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel26)
            interrupt_en_reg26 <= pwdata26[5:0];
         else
            interrupt_en_reg26 <= interrupt_en_reg26;

      end 
      
   end  
           


endmodule

