//File17 name   : ttc_interrupt_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 : Interrupts17 from the counter modules17 are registered
//              and if enabled cause the output interrupt17 to go17 high17.
//              Also17 the match117 interrupts17 are monitored17 to generate output 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module17 definition17
//-----------------------------------------------------------------------------

module ttc_interrupt_lite17(

  //inputs17
  n_p_reset17,                             
  pwdata17,                             
  pclk17,
  intr_en_reg_sel17, 
  clear_interrupt17,                   
  interval_intr17,
  match_intr17,
  overflow_intr17,
  restart17,

  //outputs17
  interrupt17,
  interrupt_reg_out17,
  interrupt_en_out17
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS17
//-----------------------------------------------------------------------------

   //inputs17
   input         n_p_reset17;            //reset signal17
   input [5:0]   pwdata17;               //6 Bit17 Data signal17
   input         pclk17;                 //System17 clock17
   input         intr_en_reg_sel17;      //Interrupt17 Enable17 Reg17 Select17 signal17
   input         clear_interrupt17;      //Clear Interrupt17 Register signal17
   input         interval_intr17;        //Timer_Counter17 Interval17 Interrupt17
   input [3:1]   match_intr17;           //Timer_Counter17 Match17 1 Interrupt17 
   input         overflow_intr17;        //Timer_Counter17 Overflow17 Interrupt17 
   input         restart17;              //Counter17 restart17

   //Outputs17
   output        interrupt17;            //Interrupt17 Signal17 
   output [5:0]  interrupt_reg_out17;    //6 Bit17 Interrupt17 Register
   output [5:0]  interrupt_en_out17; //6 Bit17 Interrupt17 Enable17 Register


//-----------------------------------------------------------------------------
// Internal Signals17 & Registers17
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect17;          //Interrupts17 from the Timer_Counter17
   reg [5:0]    int_sync_reg17;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg17;        //6-bit register ensuring17 each interrupt17 
                                      //only read once17
   reg [5:0]    interrupt_reg17;        //6-bit interrupt17 register        
   reg [5:0]    interrupt_en_reg17; //6-bit interrupt17 enable register
   

   reg          interrupt_set17;        //Prevents17 unread17 interrupt17 being cleared17
   
   wire         interrupt17;            //Interrupt17 output
   wire [5:0]   interrupt_reg_out17;    //Interrupt17 register output
   wire [5:0]   interrupt_en_out17; //Interrupt17 enable output


   assign interrupt17              = |(interrupt_reg17);
   assign interrupt_reg_out17      = interrupt_reg17;
   assign interrupt_en_out17       = interrupt_en_reg17;
   
   assign intr_detect17 = {1'b0,
                         overflow_intr17,  
                         match_intr17[3],  
                         match_intr17[2], 
                         match_intr17[1], 
                         interval_intr17};

   

// Setting interrupt17 registers
   
   always @ (posedge pclk17 or negedge n_p_reset17)
   begin: p_intr_reg_ctrl17
      
      if (!n_p_reset17)
      begin
         int_sync_reg17         <= 6'b000000;
         interrupt_reg17        <= 6'b000000;
         int_cycle_reg17        <= 6'b000000;
         interrupt_set17        <= 1'b0;
      end
      else 
      begin

         int_sync_reg17    <= intr_detect17;
         int_cycle_reg17   <= ~int_sync_reg17 & intr_detect17;

         interrupt_set17   <= |int_cycle_reg17;
          
         if (clear_interrupt17 & ~interrupt_set17)
            interrupt_reg17 <= (6'b000000 | (int_cycle_reg17 & interrupt_en_reg17));
         else 
            interrupt_reg17 <= (interrupt_reg17 | (int_cycle_reg17 & 
                                               interrupt_en_reg17));
      end 
      
   end  //p_intr_reg_ctrl17


// Setting interrupt17 enable register
   
   always @ (posedge pclk17 or negedge n_p_reset17)
   begin: p_intr_en_reg17
      
      if (!n_p_reset17)
      begin
         interrupt_en_reg17 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel17)
            interrupt_en_reg17 <= pwdata17[5:0];
         else
            interrupt_en_reg17 <= interrupt_en_reg17;

      end 
      
   end  
           


endmodule

