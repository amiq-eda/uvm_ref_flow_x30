//File3 name   : ttc_interrupt_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 : Interrupts3 from the counter modules3 are registered
//              and if enabled cause the output interrupt3 to go3 high3.
//              Also3 the match13 interrupts3 are monitored3 to generate output 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module3 definition3
//-----------------------------------------------------------------------------

module ttc_interrupt_lite3(

  //inputs3
  n_p_reset3,                             
  pwdata3,                             
  pclk3,
  intr_en_reg_sel3, 
  clear_interrupt3,                   
  interval_intr3,
  match_intr3,
  overflow_intr3,
  restart3,

  //outputs3
  interrupt3,
  interrupt_reg_out3,
  interrupt_en_out3
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS3
//-----------------------------------------------------------------------------

   //inputs3
   input         n_p_reset3;            //reset signal3
   input [5:0]   pwdata3;               //6 Bit3 Data signal3
   input         pclk3;                 //System3 clock3
   input         intr_en_reg_sel3;      //Interrupt3 Enable3 Reg3 Select3 signal3
   input         clear_interrupt3;      //Clear Interrupt3 Register signal3
   input         interval_intr3;        //Timer_Counter3 Interval3 Interrupt3
   input [3:1]   match_intr3;           //Timer_Counter3 Match3 1 Interrupt3 
   input         overflow_intr3;        //Timer_Counter3 Overflow3 Interrupt3 
   input         restart3;              //Counter3 restart3

   //Outputs3
   output        interrupt3;            //Interrupt3 Signal3 
   output [5:0]  interrupt_reg_out3;    //6 Bit3 Interrupt3 Register
   output [5:0]  interrupt_en_out3; //6 Bit3 Interrupt3 Enable3 Register


//-----------------------------------------------------------------------------
// Internal Signals3 & Registers3
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect3;          //Interrupts3 from the Timer_Counter3
   reg [5:0]    int_sync_reg3;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg3;        //6-bit register ensuring3 each interrupt3 
                                      //only read once3
   reg [5:0]    interrupt_reg3;        //6-bit interrupt3 register        
   reg [5:0]    interrupt_en_reg3; //6-bit interrupt3 enable register
   

   reg          interrupt_set3;        //Prevents3 unread3 interrupt3 being cleared3
   
   wire         interrupt3;            //Interrupt3 output
   wire [5:0]   interrupt_reg_out3;    //Interrupt3 register output
   wire [5:0]   interrupt_en_out3; //Interrupt3 enable output


   assign interrupt3              = |(interrupt_reg3);
   assign interrupt_reg_out3      = interrupt_reg3;
   assign interrupt_en_out3       = interrupt_en_reg3;
   
   assign intr_detect3 = {1'b0,
                         overflow_intr3,  
                         match_intr3[3],  
                         match_intr3[2], 
                         match_intr3[1], 
                         interval_intr3};

   

// Setting interrupt3 registers
   
   always @ (posedge pclk3 or negedge n_p_reset3)
   begin: p_intr_reg_ctrl3
      
      if (!n_p_reset3)
      begin
         int_sync_reg3         <= 6'b000000;
         interrupt_reg3        <= 6'b000000;
         int_cycle_reg3        <= 6'b000000;
         interrupt_set3        <= 1'b0;
      end
      else 
      begin

         int_sync_reg3    <= intr_detect3;
         int_cycle_reg3   <= ~int_sync_reg3 & intr_detect3;

         interrupt_set3   <= |int_cycle_reg3;
          
         if (clear_interrupt3 & ~interrupt_set3)
            interrupt_reg3 <= (6'b000000 | (int_cycle_reg3 & interrupt_en_reg3));
         else 
            interrupt_reg3 <= (interrupt_reg3 | (int_cycle_reg3 & 
                                               interrupt_en_reg3));
      end 
      
   end  //p_intr_reg_ctrl3


// Setting interrupt3 enable register
   
   always @ (posedge pclk3 or negedge n_p_reset3)
   begin: p_intr_en_reg3
      
      if (!n_p_reset3)
      begin
         interrupt_en_reg3 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel3)
            interrupt_en_reg3 <= pwdata3[5:0];
         else
            interrupt_en_reg3 <= interrupt_en_reg3;

      end 
      
   end  
           


endmodule

