//File13 name   : ttc_interrupt_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 : Interrupts13 from the counter modules13 are registered
//              and if enabled cause the output interrupt13 to go13 high13.
//              Also13 the match113 interrupts13 are monitored13 to generate output 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module13 definition13
//-----------------------------------------------------------------------------

module ttc_interrupt_lite13(

  //inputs13
  n_p_reset13,                             
  pwdata13,                             
  pclk13,
  intr_en_reg_sel13, 
  clear_interrupt13,                   
  interval_intr13,
  match_intr13,
  overflow_intr13,
  restart13,

  //outputs13
  interrupt13,
  interrupt_reg_out13,
  interrupt_en_out13
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS13
//-----------------------------------------------------------------------------

   //inputs13
   input         n_p_reset13;            //reset signal13
   input [5:0]   pwdata13;               //6 Bit13 Data signal13
   input         pclk13;                 //System13 clock13
   input         intr_en_reg_sel13;      //Interrupt13 Enable13 Reg13 Select13 signal13
   input         clear_interrupt13;      //Clear Interrupt13 Register signal13
   input         interval_intr13;        //Timer_Counter13 Interval13 Interrupt13
   input [3:1]   match_intr13;           //Timer_Counter13 Match13 1 Interrupt13 
   input         overflow_intr13;        //Timer_Counter13 Overflow13 Interrupt13 
   input         restart13;              //Counter13 restart13

   //Outputs13
   output        interrupt13;            //Interrupt13 Signal13 
   output [5:0]  interrupt_reg_out13;    //6 Bit13 Interrupt13 Register
   output [5:0]  interrupt_en_out13; //6 Bit13 Interrupt13 Enable13 Register


//-----------------------------------------------------------------------------
// Internal Signals13 & Registers13
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect13;          //Interrupts13 from the Timer_Counter13
   reg [5:0]    int_sync_reg13;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg13;        //6-bit register ensuring13 each interrupt13 
                                      //only read once13
   reg [5:0]    interrupt_reg13;        //6-bit interrupt13 register        
   reg [5:0]    interrupt_en_reg13; //6-bit interrupt13 enable register
   

   reg          interrupt_set13;        //Prevents13 unread13 interrupt13 being cleared13
   
   wire         interrupt13;            //Interrupt13 output
   wire [5:0]   interrupt_reg_out13;    //Interrupt13 register output
   wire [5:0]   interrupt_en_out13; //Interrupt13 enable output


   assign interrupt13              = |(interrupt_reg13);
   assign interrupt_reg_out13      = interrupt_reg13;
   assign interrupt_en_out13       = interrupt_en_reg13;
   
   assign intr_detect13 = {1'b0,
                         overflow_intr13,  
                         match_intr13[3],  
                         match_intr13[2], 
                         match_intr13[1], 
                         interval_intr13};

   

// Setting interrupt13 registers
   
   always @ (posedge pclk13 or negedge n_p_reset13)
   begin: p_intr_reg_ctrl13
      
      if (!n_p_reset13)
      begin
         int_sync_reg13         <= 6'b000000;
         interrupt_reg13        <= 6'b000000;
         int_cycle_reg13        <= 6'b000000;
         interrupt_set13        <= 1'b0;
      end
      else 
      begin

         int_sync_reg13    <= intr_detect13;
         int_cycle_reg13   <= ~int_sync_reg13 & intr_detect13;

         interrupt_set13   <= |int_cycle_reg13;
          
         if (clear_interrupt13 & ~interrupt_set13)
            interrupt_reg13 <= (6'b000000 | (int_cycle_reg13 & interrupt_en_reg13));
         else 
            interrupt_reg13 <= (interrupt_reg13 | (int_cycle_reg13 & 
                                               interrupt_en_reg13));
      end 
      
   end  //p_intr_reg_ctrl13


// Setting interrupt13 enable register
   
   always @ (posedge pclk13 or negedge n_p_reset13)
   begin: p_intr_en_reg13
      
      if (!n_p_reset13)
      begin
         interrupt_en_reg13 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel13)
            interrupt_en_reg13 <= pwdata13[5:0];
         else
            interrupt_en_reg13 <= interrupt_en_reg13;

      end 
      
   end  
           


endmodule

