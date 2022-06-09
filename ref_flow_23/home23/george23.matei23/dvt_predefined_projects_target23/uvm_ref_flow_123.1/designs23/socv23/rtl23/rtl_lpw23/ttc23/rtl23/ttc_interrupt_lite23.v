//File23 name   : ttc_interrupt_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 : Interrupts23 from the counter modules23 are registered
//              and if enabled cause the output interrupt23 to go23 high23.
//              Also23 the match123 interrupts23 are monitored23 to generate output 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module23 definition23
//-----------------------------------------------------------------------------

module ttc_interrupt_lite23(

  //inputs23
  n_p_reset23,                             
  pwdata23,                             
  pclk23,
  intr_en_reg_sel23, 
  clear_interrupt23,                   
  interval_intr23,
  match_intr23,
  overflow_intr23,
  restart23,

  //outputs23
  interrupt23,
  interrupt_reg_out23,
  interrupt_en_out23
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS23
//-----------------------------------------------------------------------------

   //inputs23
   input         n_p_reset23;            //reset signal23
   input [5:0]   pwdata23;               //6 Bit23 Data signal23
   input         pclk23;                 //System23 clock23
   input         intr_en_reg_sel23;      //Interrupt23 Enable23 Reg23 Select23 signal23
   input         clear_interrupt23;      //Clear Interrupt23 Register signal23
   input         interval_intr23;        //Timer_Counter23 Interval23 Interrupt23
   input [3:1]   match_intr23;           //Timer_Counter23 Match23 1 Interrupt23 
   input         overflow_intr23;        //Timer_Counter23 Overflow23 Interrupt23 
   input         restart23;              //Counter23 restart23

   //Outputs23
   output        interrupt23;            //Interrupt23 Signal23 
   output [5:0]  interrupt_reg_out23;    //6 Bit23 Interrupt23 Register
   output [5:0]  interrupt_en_out23; //6 Bit23 Interrupt23 Enable23 Register


//-----------------------------------------------------------------------------
// Internal Signals23 & Registers23
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect23;          //Interrupts23 from the Timer_Counter23
   reg [5:0]    int_sync_reg23;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg23;        //6-bit register ensuring23 each interrupt23 
                                      //only read once23
   reg [5:0]    interrupt_reg23;        //6-bit interrupt23 register        
   reg [5:0]    interrupt_en_reg23; //6-bit interrupt23 enable register
   

   reg          interrupt_set23;        //Prevents23 unread23 interrupt23 being cleared23
   
   wire         interrupt23;            //Interrupt23 output
   wire [5:0]   interrupt_reg_out23;    //Interrupt23 register output
   wire [5:0]   interrupt_en_out23; //Interrupt23 enable output


   assign interrupt23              = |(interrupt_reg23);
   assign interrupt_reg_out23      = interrupt_reg23;
   assign interrupt_en_out23       = interrupt_en_reg23;
   
   assign intr_detect23 = {1'b0,
                         overflow_intr23,  
                         match_intr23[3],  
                         match_intr23[2], 
                         match_intr23[1], 
                         interval_intr23};

   

// Setting interrupt23 registers
   
   always @ (posedge pclk23 or negedge n_p_reset23)
   begin: p_intr_reg_ctrl23
      
      if (!n_p_reset23)
      begin
         int_sync_reg23         <= 6'b000000;
         interrupt_reg23        <= 6'b000000;
         int_cycle_reg23        <= 6'b000000;
         interrupt_set23        <= 1'b0;
      end
      else 
      begin

         int_sync_reg23    <= intr_detect23;
         int_cycle_reg23   <= ~int_sync_reg23 & intr_detect23;

         interrupt_set23   <= |int_cycle_reg23;
          
         if (clear_interrupt23 & ~interrupt_set23)
            interrupt_reg23 <= (6'b000000 | (int_cycle_reg23 & interrupt_en_reg23));
         else 
            interrupt_reg23 <= (interrupt_reg23 | (int_cycle_reg23 & 
                                               interrupt_en_reg23));
      end 
      
   end  //p_intr_reg_ctrl23


// Setting interrupt23 enable register
   
   always @ (posedge pclk23 or negedge n_p_reset23)
   begin: p_intr_en_reg23
      
      if (!n_p_reset23)
      begin
         interrupt_en_reg23 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel23)
            interrupt_en_reg23 <= pwdata23[5:0];
         else
            interrupt_en_reg23 <= interrupt_en_reg23;

      end 
      
   end  
           


endmodule

