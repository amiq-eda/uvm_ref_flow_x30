//File15 name   : ttc_interrupt_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 : Interrupts15 from the counter modules15 are registered
//              and if enabled cause the output interrupt15 to go15 high15.
//              Also15 the match115 interrupts15 are monitored15 to generate output 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module15 definition15
//-----------------------------------------------------------------------------

module ttc_interrupt_lite15(

  //inputs15
  n_p_reset15,                             
  pwdata15,                             
  pclk15,
  intr_en_reg_sel15, 
  clear_interrupt15,                   
  interval_intr15,
  match_intr15,
  overflow_intr15,
  restart15,

  //outputs15
  interrupt15,
  interrupt_reg_out15,
  interrupt_en_out15
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS15
//-----------------------------------------------------------------------------

   //inputs15
   input         n_p_reset15;            //reset signal15
   input [5:0]   pwdata15;               //6 Bit15 Data signal15
   input         pclk15;                 //System15 clock15
   input         intr_en_reg_sel15;      //Interrupt15 Enable15 Reg15 Select15 signal15
   input         clear_interrupt15;      //Clear Interrupt15 Register signal15
   input         interval_intr15;        //Timer_Counter15 Interval15 Interrupt15
   input [3:1]   match_intr15;           //Timer_Counter15 Match15 1 Interrupt15 
   input         overflow_intr15;        //Timer_Counter15 Overflow15 Interrupt15 
   input         restart15;              //Counter15 restart15

   //Outputs15
   output        interrupt15;            //Interrupt15 Signal15 
   output [5:0]  interrupt_reg_out15;    //6 Bit15 Interrupt15 Register
   output [5:0]  interrupt_en_out15; //6 Bit15 Interrupt15 Enable15 Register


//-----------------------------------------------------------------------------
// Internal Signals15 & Registers15
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect15;          //Interrupts15 from the Timer_Counter15
   reg [5:0]    int_sync_reg15;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg15;        //6-bit register ensuring15 each interrupt15 
                                      //only read once15
   reg [5:0]    interrupt_reg15;        //6-bit interrupt15 register        
   reg [5:0]    interrupt_en_reg15; //6-bit interrupt15 enable register
   

   reg          interrupt_set15;        //Prevents15 unread15 interrupt15 being cleared15
   
   wire         interrupt15;            //Interrupt15 output
   wire [5:0]   interrupt_reg_out15;    //Interrupt15 register output
   wire [5:0]   interrupt_en_out15; //Interrupt15 enable output


   assign interrupt15              = |(interrupt_reg15);
   assign interrupt_reg_out15      = interrupt_reg15;
   assign interrupt_en_out15       = interrupt_en_reg15;
   
   assign intr_detect15 = {1'b0,
                         overflow_intr15,  
                         match_intr15[3],  
                         match_intr15[2], 
                         match_intr15[1], 
                         interval_intr15};

   

// Setting interrupt15 registers
   
   always @ (posedge pclk15 or negedge n_p_reset15)
   begin: p_intr_reg_ctrl15
      
      if (!n_p_reset15)
      begin
         int_sync_reg15         <= 6'b000000;
         interrupt_reg15        <= 6'b000000;
         int_cycle_reg15        <= 6'b000000;
         interrupt_set15        <= 1'b0;
      end
      else 
      begin

         int_sync_reg15    <= intr_detect15;
         int_cycle_reg15   <= ~int_sync_reg15 & intr_detect15;

         interrupt_set15   <= |int_cycle_reg15;
          
         if (clear_interrupt15 & ~interrupt_set15)
            interrupt_reg15 <= (6'b000000 | (int_cycle_reg15 & interrupt_en_reg15));
         else 
            interrupt_reg15 <= (interrupt_reg15 | (int_cycle_reg15 & 
                                               interrupt_en_reg15));
      end 
      
   end  //p_intr_reg_ctrl15


// Setting interrupt15 enable register
   
   always @ (posedge pclk15 or negedge n_p_reset15)
   begin: p_intr_en_reg15
      
      if (!n_p_reset15)
      begin
         interrupt_en_reg15 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel15)
            interrupt_en_reg15 <= pwdata15[5:0];
         else
            interrupt_en_reg15 <= interrupt_en_reg15;

      end 
      
   end  
           


endmodule

