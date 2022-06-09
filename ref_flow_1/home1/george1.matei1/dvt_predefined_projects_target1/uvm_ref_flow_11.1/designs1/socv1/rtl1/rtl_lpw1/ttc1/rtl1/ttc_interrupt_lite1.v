//File1 name   : ttc_interrupt_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 : Interrupts1 from the counter modules1 are registered
//              and if enabled cause the output interrupt1 to go1 high1.
//              Also1 the match11 interrupts1 are monitored1 to generate output 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module1 definition1
//-----------------------------------------------------------------------------

module ttc_interrupt_lite1(

  //inputs1
  n_p_reset1,                             
  pwdata1,                             
  pclk1,
  intr_en_reg_sel1, 
  clear_interrupt1,                   
  interval_intr1,
  match_intr1,
  overflow_intr1,
  restart1,

  //outputs1
  interrupt1,
  interrupt_reg_out1,
  interrupt_en_out1
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS1
//-----------------------------------------------------------------------------

   //inputs1
   input         n_p_reset1;            //reset signal1
   input [5:0]   pwdata1;               //6 Bit1 Data signal1
   input         pclk1;                 //System1 clock1
   input         intr_en_reg_sel1;      //Interrupt1 Enable1 Reg1 Select1 signal1
   input         clear_interrupt1;      //Clear Interrupt1 Register signal1
   input         interval_intr1;        //Timer_Counter1 Interval1 Interrupt1
   input [3:1]   match_intr1;           //Timer_Counter1 Match1 1 Interrupt1 
   input         overflow_intr1;        //Timer_Counter1 Overflow1 Interrupt1 
   input         restart1;              //Counter1 restart1

   //Outputs1
   output        interrupt1;            //Interrupt1 Signal1 
   output [5:0]  interrupt_reg_out1;    //6 Bit1 Interrupt1 Register
   output [5:0]  interrupt_en_out1; //6 Bit1 Interrupt1 Enable1 Register


//-----------------------------------------------------------------------------
// Internal Signals1 & Registers1
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect1;          //Interrupts1 from the Timer_Counter1
   reg [5:0]    int_sync_reg1;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg1;        //6-bit register ensuring1 each interrupt1 
                                      //only read once1
   reg [5:0]    interrupt_reg1;        //6-bit interrupt1 register        
   reg [5:0]    interrupt_en_reg1; //6-bit interrupt1 enable register
   

   reg          interrupt_set1;        //Prevents1 unread1 interrupt1 being cleared1
   
   wire         interrupt1;            //Interrupt1 output
   wire [5:0]   interrupt_reg_out1;    //Interrupt1 register output
   wire [5:0]   interrupt_en_out1; //Interrupt1 enable output


   assign interrupt1              = |(interrupt_reg1);
   assign interrupt_reg_out1      = interrupt_reg1;
   assign interrupt_en_out1       = interrupt_en_reg1;
   
   assign intr_detect1 = {1'b0,
                         overflow_intr1,  
                         match_intr1[3],  
                         match_intr1[2], 
                         match_intr1[1], 
                         interval_intr1};

   

// Setting interrupt1 registers
   
   always @ (posedge pclk1 or negedge n_p_reset1)
   begin: p_intr_reg_ctrl1
      
      if (!n_p_reset1)
      begin
         int_sync_reg1         <= 6'b000000;
         interrupt_reg1        <= 6'b000000;
         int_cycle_reg1        <= 6'b000000;
         interrupt_set1        <= 1'b0;
      end
      else 
      begin

         int_sync_reg1    <= intr_detect1;
         int_cycle_reg1   <= ~int_sync_reg1 & intr_detect1;

         interrupt_set1   <= |int_cycle_reg1;
          
         if (clear_interrupt1 & ~interrupt_set1)
            interrupt_reg1 <= (6'b000000 | (int_cycle_reg1 & interrupt_en_reg1));
         else 
            interrupt_reg1 <= (interrupt_reg1 | (int_cycle_reg1 & 
                                               interrupt_en_reg1));
      end 
      
   end  //p_intr_reg_ctrl1


// Setting interrupt1 enable register
   
   always @ (posedge pclk1 or negedge n_p_reset1)
   begin: p_intr_en_reg1
      
      if (!n_p_reset1)
      begin
         interrupt_en_reg1 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel1)
            interrupt_en_reg1 <= pwdata1[5:0];
         else
            interrupt_en_reg1 <= interrupt_en_reg1;

      end 
      
   end  
           


endmodule

