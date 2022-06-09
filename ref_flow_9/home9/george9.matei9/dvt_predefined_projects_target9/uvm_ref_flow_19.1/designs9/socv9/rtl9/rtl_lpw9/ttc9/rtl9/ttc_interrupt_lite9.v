//File9 name   : ttc_interrupt_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 : Interrupts9 from the counter modules9 are registered
//              and if enabled cause the output interrupt9 to go9 high9.
//              Also9 the match19 interrupts9 are monitored9 to generate output 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module9 definition9
//-----------------------------------------------------------------------------

module ttc_interrupt_lite9(

  //inputs9
  n_p_reset9,                             
  pwdata9,                             
  pclk9,
  intr_en_reg_sel9, 
  clear_interrupt9,                   
  interval_intr9,
  match_intr9,
  overflow_intr9,
  restart9,

  //outputs9
  interrupt9,
  interrupt_reg_out9,
  interrupt_en_out9
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS9
//-----------------------------------------------------------------------------

   //inputs9
   input         n_p_reset9;            //reset signal9
   input [5:0]   pwdata9;               //6 Bit9 Data signal9
   input         pclk9;                 //System9 clock9
   input         intr_en_reg_sel9;      //Interrupt9 Enable9 Reg9 Select9 signal9
   input         clear_interrupt9;      //Clear Interrupt9 Register signal9
   input         interval_intr9;        //Timer_Counter9 Interval9 Interrupt9
   input [3:1]   match_intr9;           //Timer_Counter9 Match9 1 Interrupt9 
   input         overflow_intr9;        //Timer_Counter9 Overflow9 Interrupt9 
   input         restart9;              //Counter9 restart9

   //Outputs9
   output        interrupt9;            //Interrupt9 Signal9 
   output [5:0]  interrupt_reg_out9;    //6 Bit9 Interrupt9 Register
   output [5:0]  interrupt_en_out9; //6 Bit9 Interrupt9 Enable9 Register


//-----------------------------------------------------------------------------
// Internal Signals9 & Registers9
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect9;          //Interrupts9 from the Timer_Counter9
   reg [5:0]    int_sync_reg9;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg9;        //6-bit register ensuring9 each interrupt9 
                                      //only read once9
   reg [5:0]    interrupt_reg9;        //6-bit interrupt9 register        
   reg [5:0]    interrupt_en_reg9; //6-bit interrupt9 enable register
   

   reg          interrupt_set9;        //Prevents9 unread9 interrupt9 being cleared9
   
   wire         interrupt9;            //Interrupt9 output
   wire [5:0]   interrupt_reg_out9;    //Interrupt9 register output
   wire [5:0]   interrupt_en_out9; //Interrupt9 enable output


   assign interrupt9              = |(interrupt_reg9);
   assign interrupt_reg_out9      = interrupt_reg9;
   assign interrupt_en_out9       = interrupt_en_reg9;
   
   assign intr_detect9 = {1'b0,
                         overflow_intr9,  
                         match_intr9[3],  
                         match_intr9[2], 
                         match_intr9[1], 
                         interval_intr9};

   

// Setting interrupt9 registers
   
   always @ (posedge pclk9 or negedge n_p_reset9)
   begin: p_intr_reg_ctrl9
      
      if (!n_p_reset9)
      begin
         int_sync_reg9         <= 6'b000000;
         interrupt_reg9        <= 6'b000000;
         int_cycle_reg9        <= 6'b000000;
         interrupt_set9        <= 1'b0;
      end
      else 
      begin

         int_sync_reg9    <= intr_detect9;
         int_cycle_reg9   <= ~int_sync_reg9 & intr_detect9;

         interrupt_set9   <= |int_cycle_reg9;
          
         if (clear_interrupt9 & ~interrupt_set9)
            interrupt_reg9 <= (6'b000000 | (int_cycle_reg9 & interrupt_en_reg9));
         else 
            interrupt_reg9 <= (interrupt_reg9 | (int_cycle_reg9 & 
                                               interrupt_en_reg9));
      end 
      
   end  //p_intr_reg_ctrl9


// Setting interrupt9 enable register
   
   always @ (posedge pclk9 or negedge n_p_reset9)
   begin: p_intr_en_reg9
      
      if (!n_p_reset9)
      begin
         interrupt_en_reg9 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel9)
            interrupt_en_reg9 <= pwdata9[5:0];
         else
            interrupt_en_reg9 <= interrupt_en_reg9;

      end 
      
   end  
           


endmodule

