//File22 name   : ttc_interrupt_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 : Interrupts22 from the counter modules22 are registered
//              and if enabled cause the output interrupt22 to go22 high22.
//              Also22 the match122 interrupts22 are monitored22 to generate output 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module22 definition22
//-----------------------------------------------------------------------------

module ttc_interrupt_lite22(

  //inputs22
  n_p_reset22,                             
  pwdata22,                             
  pclk22,
  intr_en_reg_sel22, 
  clear_interrupt22,                   
  interval_intr22,
  match_intr22,
  overflow_intr22,
  restart22,

  //outputs22
  interrupt22,
  interrupt_reg_out22,
  interrupt_en_out22
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS22
//-----------------------------------------------------------------------------

   //inputs22
   input         n_p_reset22;            //reset signal22
   input [5:0]   pwdata22;               //6 Bit22 Data signal22
   input         pclk22;                 //System22 clock22
   input         intr_en_reg_sel22;      //Interrupt22 Enable22 Reg22 Select22 signal22
   input         clear_interrupt22;      //Clear Interrupt22 Register signal22
   input         interval_intr22;        //Timer_Counter22 Interval22 Interrupt22
   input [3:1]   match_intr22;           //Timer_Counter22 Match22 1 Interrupt22 
   input         overflow_intr22;        //Timer_Counter22 Overflow22 Interrupt22 
   input         restart22;              //Counter22 restart22

   //Outputs22
   output        interrupt22;            //Interrupt22 Signal22 
   output [5:0]  interrupt_reg_out22;    //6 Bit22 Interrupt22 Register
   output [5:0]  interrupt_en_out22; //6 Bit22 Interrupt22 Enable22 Register


//-----------------------------------------------------------------------------
// Internal Signals22 & Registers22
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect22;          //Interrupts22 from the Timer_Counter22
   reg [5:0]    int_sync_reg22;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg22;        //6-bit register ensuring22 each interrupt22 
                                      //only read once22
   reg [5:0]    interrupt_reg22;        //6-bit interrupt22 register        
   reg [5:0]    interrupt_en_reg22; //6-bit interrupt22 enable register
   

   reg          interrupt_set22;        //Prevents22 unread22 interrupt22 being cleared22
   
   wire         interrupt22;            //Interrupt22 output
   wire [5:0]   interrupt_reg_out22;    //Interrupt22 register output
   wire [5:0]   interrupt_en_out22; //Interrupt22 enable output


   assign interrupt22              = |(interrupt_reg22);
   assign interrupt_reg_out22      = interrupt_reg22;
   assign interrupt_en_out22       = interrupt_en_reg22;
   
   assign intr_detect22 = {1'b0,
                         overflow_intr22,  
                         match_intr22[3],  
                         match_intr22[2], 
                         match_intr22[1], 
                         interval_intr22};

   

// Setting interrupt22 registers
   
   always @ (posedge pclk22 or negedge n_p_reset22)
   begin: p_intr_reg_ctrl22
      
      if (!n_p_reset22)
      begin
         int_sync_reg22         <= 6'b000000;
         interrupt_reg22        <= 6'b000000;
         int_cycle_reg22        <= 6'b000000;
         interrupt_set22        <= 1'b0;
      end
      else 
      begin

         int_sync_reg22    <= intr_detect22;
         int_cycle_reg22   <= ~int_sync_reg22 & intr_detect22;

         interrupt_set22   <= |int_cycle_reg22;
          
         if (clear_interrupt22 & ~interrupt_set22)
            interrupt_reg22 <= (6'b000000 | (int_cycle_reg22 & interrupt_en_reg22));
         else 
            interrupt_reg22 <= (interrupt_reg22 | (int_cycle_reg22 & 
                                               interrupt_en_reg22));
      end 
      
   end  //p_intr_reg_ctrl22


// Setting interrupt22 enable register
   
   always @ (posedge pclk22 or negedge n_p_reset22)
   begin: p_intr_en_reg22
      
      if (!n_p_reset22)
      begin
         interrupt_en_reg22 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel22)
            interrupt_en_reg22 <= pwdata22[5:0];
         else
            interrupt_en_reg22 <= interrupt_en_reg22;

      end 
      
   end  
           


endmodule

