//File6 name   : ttc_interrupt_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 : Interrupts6 from the counter modules6 are registered
//              and if enabled cause the output interrupt6 to go6 high6.
//              Also6 the match16 interrupts6 are monitored6 to generate output 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module6 definition6
//-----------------------------------------------------------------------------

module ttc_interrupt_lite6(

  //inputs6
  n_p_reset6,                             
  pwdata6,                             
  pclk6,
  intr_en_reg_sel6, 
  clear_interrupt6,                   
  interval_intr6,
  match_intr6,
  overflow_intr6,
  restart6,

  //outputs6
  interrupt6,
  interrupt_reg_out6,
  interrupt_en_out6
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS6
//-----------------------------------------------------------------------------

   //inputs6
   input         n_p_reset6;            //reset signal6
   input [5:0]   pwdata6;               //6 Bit6 Data signal6
   input         pclk6;                 //System6 clock6
   input         intr_en_reg_sel6;      //Interrupt6 Enable6 Reg6 Select6 signal6
   input         clear_interrupt6;      //Clear Interrupt6 Register signal6
   input         interval_intr6;        //Timer_Counter6 Interval6 Interrupt6
   input [3:1]   match_intr6;           //Timer_Counter6 Match6 1 Interrupt6 
   input         overflow_intr6;        //Timer_Counter6 Overflow6 Interrupt6 
   input         restart6;              //Counter6 restart6

   //Outputs6
   output        interrupt6;            //Interrupt6 Signal6 
   output [5:0]  interrupt_reg_out6;    //6 Bit6 Interrupt6 Register
   output [5:0]  interrupt_en_out6; //6 Bit6 Interrupt6 Enable6 Register


//-----------------------------------------------------------------------------
// Internal Signals6 & Registers6
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect6;          //Interrupts6 from the Timer_Counter6
   reg [5:0]    int_sync_reg6;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg6;        //6-bit register ensuring6 each interrupt6 
                                      //only read once6
   reg [5:0]    interrupt_reg6;        //6-bit interrupt6 register        
   reg [5:0]    interrupt_en_reg6; //6-bit interrupt6 enable register
   

   reg          interrupt_set6;        //Prevents6 unread6 interrupt6 being cleared6
   
   wire         interrupt6;            //Interrupt6 output
   wire [5:0]   interrupt_reg_out6;    //Interrupt6 register output
   wire [5:0]   interrupt_en_out6; //Interrupt6 enable output


   assign interrupt6              = |(interrupt_reg6);
   assign interrupt_reg_out6      = interrupt_reg6;
   assign interrupt_en_out6       = interrupt_en_reg6;
   
   assign intr_detect6 = {1'b0,
                         overflow_intr6,  
                         match_intr6[3],  
                         match_intr6[2], 
                         match_intr6[1], 
                         interval_intr6};

   

// Setting interrupt6 registers
   
   always @ (posedge pclk6 or negedge n_p_reset6)
   begin: p_intr_reg_ctrl6
      
      if (!n_p_reset6)
      begin
         int_sync_reg6         <= 6'b000000;
         interrupt_reg6        <= 6'b000000;
         int_cycle_reg6        <= 6'b000000;
         interrupt_set6        <= 1'b0;
      end
      else 
      begin

         int_sync_reg6    <= intr_detect6;
         int_cycle_reg6   <= ~int_sync_reg6 & intr_detect6;

         interrupt_set6   <= |int_cycle_reg6;
          
         if (clear_interrupt6 & ~interrupt_set6)
            interrupt_reg6 <= (6'b000000 | (int_cycle_reg6 & interrupt_en_reg6));
         else 
            interrupt_reg6 <= (interrupt_reg6 | (int_cycle_reg6 & 
                                               interrupt_en_reg6));
      end 
      
   end  //p_intr_reg_ctrl6


// Setting interrupt6 enable register
   
   always @ (posedge pclk6 or negedge n_p_reset6)
   begin: p_intr_en_reg6
      
      if (!n_p_reset6)
      begin
         interrupt_en_reg6 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel6)
            interrupt_en_reg6 <= pwdata6[5:0];
         else
            interrupt_en_reg6 <= interrupt_en_reg6;

      end 
      
   end  
           


endmodule

