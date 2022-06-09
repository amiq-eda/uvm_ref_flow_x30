//File5 name   : ttc_interrupt_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 : Interrupts5 from the counter modules5 are registered
//              and if enabled cause the output interrupt5 to go5 high5.
//              Also5 the match15 interrupts5 are monitored5 to generate output 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module5 definition5
//-----------------------------------------------------------------------------

module ttc_interrupt_lite5(

  //inputs5
  n_p_reset5,                             
  pwdata5,                             
  pclk5,
  intr_en_reg_sel5, 
  clear_interrupt5,                   
  interval_intr5,
  match_intr5,
  overflow_intr5,
  restart5,

  //outputs5
  interrupt5,
  interrupt_reg_out5,
  interrupt_en_out5
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS5
//-----------------------------------------------------------------------------

   //inputs5
   input         n_p_reset5;            //reset signal5
   input [5:0]   pwdata5;               //6 Bit5 Data signal5
   input         pclk5;                 //System5 clock5
   input         intr_en_reg_sel5;      //Interrupt5 Enable5 Reg5 Select5 signal5
   input         clear_interrupt5;      //Clear Interrupt5 Register signal5
   input         interval_intr5;        //Timer_Counter5 Interval5 Interrupt5
   input [3:1]   match_intr5;           //Timer_Counter5 Match5 1 Interrupt5 
   input         overflow_intr5;        //Timer_Counter5 Overflow5 Interrupt5 
   input         restart5;              //Counter5 restart5

   //Outputs5
   output        interrupt5;            //Interrupt5 Signal5 
   output [5:0]  interrupt_reg_out5;    //6 Bit5 Interrupt5 Register
   output [5:0]  interrupt_en_out5; //6 Bit5 Interrupt5 Enable5 Register


//-----------------------------------------------------------------------------
// Internal Signals5 & Registers5
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect5;          //Interrupts5 from the Timer_Counter5
   reg [5:0]    int_sync_reg5;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg5;        //6-bit register ensuring5 each interrupt5 
                                      //only read once5
   reg [5:0]    interrupt_reg5;        //6-bit interrupt5 register        
   reg [5:0]    interrupt_en_reg5; //6-bit interrupt5 enable register
   

   reg          interrupt_set5;        //Prevents5 unread5 interrupt5 being cleared5
   
   wire         interrupt5;            //Interrupt5 output
   wire [5:0]   interrupt_reg_out5;    //Interrupt5 register output
   wire [5:0]   interrupt_en_out5; //Interrupt5 enable output


   assign interrupt5              = |(interrupt_reg5);
   assign interrupt_reg_out5      = interrupt_reg5;
   assign interrupt_en_out5       = interrupt_en_reg5;
   
   assign intr_detect5 = {1'b0,
                         overflow_intr5,  
                         match_intr5[3],  
                         match_intr5[2], 
                         match_intr5[1], 
                         interval_intr5};

   

// Setting interrupt5 registers
   
   always @ (posedge pclk5 or negedge n_p_reset5)
   begin: p_intr_reg_ctrl5
      
      if (!n_p_reset5)
      begin
         int_sync_reg5         <= 6'b000000;
         interrupt_reg5        <= 6'b000000;
         int_cycle_reg5        <= 6'b000000;
         interrupt_set5        <= 1'b0;
      end
      else 
      begin

         int_sync_reg5    <= intr_detect5;
         int_cycle_reg5   <= ~int_sync_reg5 & intr_detect5;

         interrupt_set5   <= |int_cycle_reg5;
          
         if (clear_interrupt5 & ~interrupt_set5)
            interrupt_reg5 <= (6'b000000 | (int_cycle_reg5 & interrupt_en_reg5));
         else 
            interrupt_reg5 <= (interrupt_reg5 | (int_cycle_reg5 & 
                                               interrupt_en_reg5));
      end 
      
   end  //p_intr_reg_ctrl5


// Setting interrupt5 enable register
   
   always @ (posedge pclk5 or negedge n_p_reset5)
   begin: p_intr_en_reg5
      
      if (!n_p_reset5)
      begin
         interrupt_en_reg5 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel5)
            interrupt_en_reg5 <= pwdata5[5:0];
         else
            interrupt_en_reg5 <= interrupt_en_reg5;

      end 
      
   end  
           


endmodule

