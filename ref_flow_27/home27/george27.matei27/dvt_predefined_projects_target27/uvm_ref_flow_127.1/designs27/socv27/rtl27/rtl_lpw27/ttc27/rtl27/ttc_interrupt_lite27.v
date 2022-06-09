//File27 name   : ttc_interrupt_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 : Interrupts27 from the counter modules27 are registered
//              and if enabled cause the output interrupt27 to go27 high27.
//              Also27 the match127 interrupts27 are monitored27 to generate output 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module27 definition27
//-----------------------------------------------------------------------------

module ttc_interrupt_lite27(

  //inputs27
  n_p_reset27,                             
  pwdata27,                             
  pclk27,
  intr_en_reg_sel27, 
  clear_interrupt27,                   
  interval_intr27,
  match_intr27,
  overflow_intr27,
  restart27,

  //outputs27
  interrupt27,
  interrupt_reg_out27,
  interrupt_en_out27
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS27
//-----------------------------------------------------------------------------

   //inputs27
   input         n_p_reset27;            //reset signal27
   input [5:0]   pwdata27;               //6 Bit27 Data signal27
   input         pclk27;                 //System27 clock27
   input         intr_en_reg_sel27;      //Interrupt27 Enable27 Reg27 Select27 signal27
   input         clear_interrupt27;      //Clear Interrupt27 Register signal27
   input         interval_intr27;        //Timer_Counter27 Interval27 Interrupt27
   input [3:1]   match_intr27;           //Timer_Counter27 Match27 1 Interrupt27 
   input         overflow_intr27;        //Timer_Counter27 Overflow27 Interrupt27 
   input         restart27;              //Counter27 restart27

   //Outputs27
   output        interrupt27;            //Interrupt27 Signal27 
   output [5:0]  interrupt_reg_out27;    //6 Bit27 Interrupt27 Register
   output [5:0]  interrupt_en_out27; //6 Bit27 Interrupt27 Enable27 Register


//-----------------------------------------------------------------------------
// Internal Signals27 & Registers27
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect27;          //Interrupts27 from the Timer_Counter27
   reg [5:0]    int_sync_reg27;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg27;        //6-bit register ensuring27 each interrupt27 
                                      //only read once27
   reg [5:0]    interrupt_reg27;        //6-bit interrupt27 register        
   reg [5:0]    interrupt_en_reg27; //6-bit interrupt27 enable register
   

   reg          interrupt_set27;        //Prevents27 unread27 interrupt27 being cleared27
   
   wire         interrupt27;            //Interrupt27 output
   wire [5:0]   interrupt_reg_out27;    //Interrupt27 register output
   wire [5:0]   interrupt_en_out27; //Interrupt27 enable output


   assign interrupt27              = |(interrupt_reg27);
   assign interrupt_reg_out27      = interrupt_reg27;
   assign interrupt_en_out27       = interrupt_en_reg27;
   
   assign intr_detect27 = {1'b0,
                         overflow_intr27,  
                         match_intr27[3],  
                         match_intr27[2], 
                         match_intr27[1], 
                         interval_intr27};

   

// Setting interrupt27 registers
   
   always @ (posedge pclk27 or negedge n_p_reset27)
   begin: p_intr_reg_ctrl27
      
      if (!n_p_reset27)
      begin
         int_sync_reg27         <= 6'b000000;
         interrupt_reg27        <= 6'b000000;
         int_cycle_reg27        <= 6'b000000;
         interrupt_set27        <= 1'b0;
      end
      else 
      begin

         int_sync_reg27    <= intr_detect27;
         int_cycle_reg27   <= ~int_sync_reg27 & intr_detect27;

         interrupt_set27   <= |int_cycle_reg27;
          
         if (clear_interrupt27 & ~interrupt_set27)
            interrupt_reg27 <= (6'b000000 | (int_cycle_reg27 & interrupt_en_reg27));
         else 
            interrupt_reg27 <= (interrupt_reg27 | (int_cycle_reg27 & 
                                               interrupt_en_reg27));
      end 
      
   end  //p_intr_reg_ctrl27


// Setting interrupt27 enable register
   
   always @ (posedge pclk27 or negedge n_p_reset27)
   begin: p_intr_en_reg27
      
      if (!n_p_reset27)
      begin
         interrupt_en_reg27 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel27)
            interrupt_en_reg27 <= pwdata27[5:0];
         else
            interrupt_en_reg27 <= interrupt_en_reg27;

      end 
      
   end  
           


endmodule

