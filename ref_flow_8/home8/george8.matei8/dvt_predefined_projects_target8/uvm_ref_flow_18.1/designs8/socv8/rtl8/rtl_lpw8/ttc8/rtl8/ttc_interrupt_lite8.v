//File8 name   : ttc_interrupt_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 : Interrupts8 from the counter modules8 are registered
//              and if enabled cause the output interrupt8 to go8 high8.
//              Also8 the match18 interrupts8 are monitored8 to generate output 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module8 definition8
//-----------------------------------------------------------------------------

module ttc_interrupt_lite8(

  //inputs8
  n_p_reset8,                             
  pwdata8,                             
  pclk8,
  intr_en_reg_sel8, 
  clear_interrupt8,                   
  interval_intr8,
  match_intr8,
  overflow_intr8,
  restart8,

  //outputs8
  interrupt8,
  interrupt_reg_out8,
  interrupt_en_out8
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS8
//-----------------------------------------------------------------------------

   //inputs8
   input         n_p_reset8;            //reset signal8
   input [5:0]   pwdata8;               //6 Bit8 Data signal8
   input         pclk8;                 //System8 clock8
   input         intr_en_reg_sel8;      //Interrupt8 Enable8 Reg8 Select8 signal8
   input         clear_interrupt8;      //Clear Interrupt8 Register signal8
   input         interval_intr8;        //Timer_Counter8 Interval8 Interrupt8
   input [3:1]   match_intr8;           //Timer_Counter8 Match8 1 Interrupt8 
   input         overflow_intr8;        //Timer_Counter8 Overflow8 Interrupt8 
   input         restart8;              //Counter8 restart8

   //Outputs8
   output        interrupt8;            //Interrupt8 Signal8 
   output [5:0]  interrupt_reg_out8;    //6 Bit8 Interrupt8 Register
   output [5:0]  interrupt_en_out8; //6 Bit8 Interrupt8 Enable8 Register


//-----------------------------------------------------------------------------
// Internal Signals8 & Registers8
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect8;          //Interrupts8 from the Timer_Counter8
   reg [5:0]    int_sync_reg8;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg8;        //6-bit register ensuring8 each interrupt8 
                                      //only read once8
   reg [5:0]    interrupt_reg8;        //6-bit interrupt8 register        
   reg [5:0]    interrupt_en_reg8; //6-bit interrupt8 enable register
   

   reg          interrupt_set8;        //Prevents8 unread8 interrupt8 being cleared8
   
   wire         interrupt8;            //Interrupt8 output
   wire [5:0]   interrupt_reg_out8;    //Interrupt8 register output
   wire [5:0]   interrupt_en_out8; //Interrupt8 enable output


   assign interrupt8              = |(interrupt_reg8);
   assign interrupt_reg_out8      = interrupt_reg8;
   assign interrupt_en_out8       = interrupt_en_reg8;
   
   assign intr_detect8 = {1'b0,
                         overflow_intr8,  
                         match_intr8[3],  
                         match_intr8[2], 
                         match_intr8[1], 
                         interval_intr8};

   

// Setting interrupt8 registers
   
   always @ (posedge pclk8 or negedge n_p_reset8)
   begin: p_intr_reg_ctrl8
      
      if (!n_p_reset8)
      begin
         int_sync_reg8         <= 6'b000000;
         interrupt_reg8        <= 6'b000000;
         int_cycle_reg8        <= 6'b000000;
         interrupt_set8        <= 1'b0;
      end
      else 
      begin

         int_sync_reg8    <= intr_detect8;
         int_cycle_reg8   <= ~int_sync_reg8 & intr_detect8;

         interrupt_set8   <= |int_cycle_reg8;
          
         if (clear_interrupt8 & ~interrupt_set8)
            interrupt_reg8 <= (6'b000000 | (int_cycle_reg8 & interrupt_en_reg8));
         else 
            interrupt_reg8 <= (interrupt_reg8 | (int_cycle_reg8 & 
                                               interrupt_en_reg8));
      end 
      
   end  //p_intr_reg_ctrl8


// Setting interrupt8 enable register
   
   always @ (posedge pclk8 or negedge n_p_reset8)
   begin: p_intr_en_reg8
      
      if (!n_p_reset8)
      begin
         interrupt_en_reg8 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel8)
            interrupt_en_reg8 <= pwdata8[5:0];
         else
            interrupt_en_reg8 <= interrupt_en_reg8;

      end 
      
   end  
           


endmodule

