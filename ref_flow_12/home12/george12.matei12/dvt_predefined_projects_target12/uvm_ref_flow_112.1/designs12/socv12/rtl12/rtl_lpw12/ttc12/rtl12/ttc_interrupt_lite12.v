//File12 name   : ttc_interrupt_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 : Interrupts12 from the counter modules12 are registered
//              and if enabled cause the output interrupt12 to go12 high12.
//              Also12 the match112 interrupts12 are monitored12 to generate output 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module12 definition12
//-----------------------------------------------------------------------------

module ttc_interrupt_lite12(

  //inputs12
  n_p_reset12,                             
  pwdata12,                             
  pclk12,
  intr_en_reg_sel12, 
  clear_interrupt12,                   
  interval_intr12,
  match_intr12,
  overflow_intr12,
  restart12,

  //outputs12
  interrupt12,
  interrupt_reg_out12,
  interrupt_en_out12
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS12
//-----------------------------------------------------------------------------

   //inputs12
   input         n_p_reset12;            //reset signal12
   input [5:0]   pwdata12;               //6 Bit12 Data signal12
   input         pclk12;                 //System12 clock12
   input         intr_en_reg_sel12;      //Interrupt12 Enable12 Reg12 Select12 signal12
   input         clear_interrupt12;      //Clear Interrupt12 Register signal12
   input         interval_intr12;        //Timer_Counter12 Interval12 Interrupt12
   input [3:1]   match_intr12;           //Timer_Counter12 Match12 1 Interrupt12 
   input         overflow_intr12;        //Timer_Counter12 Overflow12 Interrupt12 
   input         restart12;              //Counter12 restart12

   //Outputs12
   output        interrupt12;            //Interrupt12 Signal12 
   output [5:0]  interrupt_reg_out12;    //6 Bit12 Interrupt12 Register
   output [5:0]  interrupt_en_out12; //6 Bit12 Interrupt12 Enable12 Register


//-----------------------------------------------------------------------------
// Internal Signals12 & Registers12
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect12;          //Interrupts12 from the Timer_Counter12
   reg [5:0]    int_sync_reg12;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg12;        //6-bit register ensuring12 each interrupt12 
                                      //only read once12
   reg [5:0]    interrupt_reg12;        //6-bit interrupt12 register        
   reg [5:0]    interrupt_en_reg12; //6-bit interrupt12 enable register
   

   reg          interrupt_set12;        //Prevents12 unread12 interrupt12 being cleared12
   
   wire         interrupt12;            //Interrupt12 output
   wire [5:0]   interrupt_reg_out12;    //Interrupt12 register output
   wire [5:0]   interrupt_en_out12; //Interrupt12 enable output


   assign interrupt12              = |(interrupt_reg12);
   assign interrupt_reg_out12      = interrupt_reg12;
   assign interrupt_en_out12       = interrupt_en_reg12;
   
   assign intr_detect12 = {1'b0,
                         overflow_intr12,  
                         match_intr12[3],  
                         match_intr12[2], 
                         match_intr12[1], 
                         interval_intr12};

   

// Setting interrupt12 registers
   
   always @ (posedge pclk12 or negedge n_p_reset12)
   begin: p_intr_reg_ctrl12
      
      if (!n_p_reset12)
      begin
         int_sync_reg12         <= 6'b000000;
         interrupt_reg12        <= 6'b000000;
         int_cycle_reg12        <= 6'b000000;
         interrupt_set12        <= 1'b0;
      end
      else 
      begin

         int_sync_reg12    <= intr_detect12;
         int_cycle_reg12   <= ~int_sync_reg12 & intr_detect12;

         interrupt_set12   <= |int_cycle_reg12;
          
         if (clear_interrupt12 & ~interrupt_set12)
            interrupt_reg12 <= (6'b000000 | (int_cycle_reg12 & interrupt_en_reg12));
         else 
            interrupt_reg12 <= (interrupt_reg12 | (int_cycle_reg12 & 
                                               interrupt_en_reg12));
      end 
      
   end  //p_intr_reg_ctrl12


// Setting interrupt12 enable register
   
   always @ (posedge pclk12 or negedge n_p_reset12)
   begin: p_intr_en_reg12
      
      if (!n_p_reset12)
      begin
         interrupt_en_reg12 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel12)
            interrupt_en_reg12 <= pwdata12[5:0];
         else
            interrupt_en_reg12 <= interrupt_en_reg12;

      end 
      
   end  
           


endmodule

