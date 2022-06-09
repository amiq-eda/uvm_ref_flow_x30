//File18 name   : ttc_interrupt_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 : Interrupts18 from the counter modules18 are registered
//              and if enabled cause the output interrupt18 to go18 high18.
//              Also18 the match118 interrupts18 are monitored18 to generate output 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module18 definition18
//-----------------------------------------------------------------------------

module ttc_interrupt_lite18(

  //inputs18
  n_p_reset18,                             
  pwdata18,                             
  pclk18,
  intr_en_reg_sel18, 
  clear_interrupt18,                   
  interval_intr18,
  match_intr18,
  overflow_intr18,
  restart18,

  //outputs18
  interrupt18,
  interrupt_reg_out18,
  interrupt_en_out18
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS18
//-----------------------------------------------------------------------------

   //inputs18
   input         n_p_reset18;            //reset signal18
   input [5:0]   pwdata18;               //6 Bit18 Data signal18
   input         pclk18;                 //System18 clock18
   input         intr_en_reg_sel18;      //Interrupt18 Enable18 Reg18 Select18 signal18
   input         clear_interrupt18;      //Clear Interrupt18 Register signal18
   input         interval_intr18;        //Timer_Counter18 Interval18 Interrupt18
   input [3:1]   match_intr18;           //Timer_Counter18 Match18 1 Interrupt18 
   input         overflow_intr18;        //Timer_Counter18 Overflow18 Interrupt18 
   input         restart18;              //Counter18 restart18

   //Outputs18
   output        interrupt18;            //Interrupt18 Signal18 
   output [5:0]  interrupt_reg_out18;    //6 Bit18 Interrupt18 Register
   output [5:0]  interrupt_en_out18; //6 Bit18 Interrupt18 Enable18 Register


//-----------------------------------------------------------------------------
// Internal Signals18 & Registers18
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect18;          //Interrupts18 from the Timer_Counter18
   reg [5:0]    int_sync_reg18;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg18;        //6-bit register ensuring18 each interrupt18 
                                      //only read once18
   reg [5:0]    interrupt_reg18;        //6-bit interrupt18 register        
   reg [5:0]    interrupt_en_reg18; //6-bit interrupt18 enable register
   

   reg          interrupt_set18;        //Prevents18 unread18 interrupt18 being cleared18
   
   wire         interrupt18;            //Interrupt18 output
   wire [5:0]   interrupt_reg_out18;    //Interrupt18 register output
   wire [5:0]   interrupt_en_out18; //Interrupt18 enable output


   assign interrupt18              = |(interrupt_reg18);
   assign interrupt_reg_out18      = interrupt_reg18;
   assign interrupt_en_out18       = interrupt_en_reg18;
   
   assign intr_detect18 = {1'b0,
                         overflow_intr18,  
                         match_intr18[3],  
                         match_intr18[2], 
                         match_intr18[1], 
                         interval_intr18};

   

// Setting interrupt18 registers
   
   always @ (posedge pclk18 or negedge n_p_reset18)
   begin: p_intr_reg_ctrl18
      
      if (!n_p_reset18)
      begin
         int_sync_reg18         <= 6'b000000;
         interrupt_reg18        <= 6'b000000;
         int_cycle_reg18        <= 6'b000000;
         interrupt_set18        <= 1'b0;
      end
      else 
      begin

         int_sync_reg18    <= intr_detect18;
         int_cycle_reg18   <= ~int_sync_reg18 & intr_detect18;

         interrupt_set18   <= |int_cycle_reg18;
          
         if (clear_interrupt18 & ~interrupt_set18)
            interrupt_reg18 <= (6'b000000 | (int_cycle_reg18 & interrupt_en_reg18));
         else 
            interrupt_reg18 <= (interrupt_reg18 | (int_cycle_reg18 & 
                                               interrupt_en_reg18));
      end 
      
   end  //p_intr_reg_ctrl18


// Setting interrupt18 enable register
   
   always @ (posedge pclk18 or negedge n_p_reset18)
   begin: p_intr_en_reg18
      
      if (!n_p_reset18)
      begin
         interrupt_en_reg18 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel18)
            interrupt_en_reg18 <= pwdata18[5:0];
         else
            interrupt_en_reg18 <= interrupt_en_reg18;

      end 
      
   end  
           


endmodule

