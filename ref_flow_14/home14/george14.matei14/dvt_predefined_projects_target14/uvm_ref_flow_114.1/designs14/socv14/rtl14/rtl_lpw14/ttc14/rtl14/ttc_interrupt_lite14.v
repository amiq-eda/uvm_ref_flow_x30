//File14 name   : ttc_interrupt_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 : Interrupts14 from the counter modules14 are registered
//              and if enabled cause the output interrupt14 to go14 high14.
//              Also14 the match114 interrupts14 are monitored14 to generate output 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module14 definition14
//-----------------------------------------------------------------------------

module ttc_interrupt_lite14(

  //inputs14
  n_p_reset14,                             
  pwdata14,                             
  pclk14,
  intr_en_reg_sel14, 
  clear_interrupt14,                   
  interval_intr14,
  match_intr14,
  overflow_intr14,
  restart14,

  //outputs14
  interrupt14,
  interrupt_reg_out14,
  interrupt_en_out14
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS14
//-----------------------------------------------------------------------------

   //inputs14
   input         n_p_reset14;            //reset signal14
   input [5:0]   pwdata14;               //6 Bit14 Data signal14
   input         pclk14;                 //System14 clock14
   input         intr_en_reg_sel14;      //Interrupt14 Enable14 Reg14 Select14 signal14
   input         clear_interrupt14;      //Clear Interrupt14 Register signal14
   input         interval_intr14;        //Timer_Counter14 Interval14 Interrupt14
   input [3:1]   match_intr14;           //Timer_Counter14 Match14 1 Interrupt14 
   input         overflow_intr14;        //Timer_Counter14 Overflow14 Interrupt14 
   input         restart14;              //Counter14 restart14

   //Outputs14
   output        interrupt14;            //Interrupt14 Signal14 
   output [5:0]  interrupt_reg_out14;    //6 Bit14 Interrupt14 Register
   output [5:0]  interrupt_en_out14; //6 Bit14 Interrupt14 Enable14 Register


//-----------------------------------------------------------------------------
// Internal Signals14 & Registers14
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect14;          //Interrupts14 from the Timer_Counter14
   reg [5:0]    int_sync_reg14;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg14;        //6-bit register ensuring14 each interrupt14 
                                      //only read once14
   reg [5:0]    interrupt_reg14;        //6-bit interrupt14 register        
   reg [5:0]    interrupt_en_reg14; //6-bit interrupt14 enable register
   

   reg          interrupt_set14;        //Prevents14 unread14 interrupt14 being cleared14
   
   wire         interrupt14;            //Interrupt14 output
   wire [5:0]   interrupt_reg_out14;    //Interrupt14 register output
   wire [5:0]   interrupt_en_out14; //Interrupt14 enable output


   assign interrupt14              = |(interrupt_reg14);
   assign interrupt_reg_out14      = interrupt_reg14;
   assign interrupt_en_out14       = interrupt_en_reg14;
   
   assign intr_detect14 = {1'b0,
                         overflow_intr14,  
                         match_intr14[3],  
                         match_intr14[2], 
                         match_intr14[1], 
                         interval_intr14};

   

// Setting interrupt14 registers
   
   always @ (posedge pclk14 or negedge n_p_reset14)
   begin: p_intr_reg_ctrl14
      
      if (!n_p_reset14)
      begin
         int_sync_reg14         <= 6'b000000;
         interrupt_reg14        <= 6'b000000;
         int_cycle_reg14        <= 6'b000000;
         interrupt_set14        <= 1'b0;
      end
      else 
      begin

         int_sync_reg14    <= intr_detect14;
         int_cycle_reg14   <= ~int_sync_reg14 & intr_detect14;

         interrupt_set14   <= |int_cycle_reg14;
          
         if (clear_interrupt14 & ~interrupt_set14)
            interrupt_reg14 <= (6'b000000 | (int_cycle_reg14 & interrupt_en_reg14));
         else 
            interrupt_reg14 <= (interrupt_reg14 | (int_cycle_reg14 & 
                                               interrupt_en_reg14));
      end 
      
   end  //p_intr_reg_ctrl14


// Setting interrupt14 enable register
   
   always @ (posedge pclk14 or negedge n_p_reset14)
   begin: p_intr_en_reg14
      
      if (!n_p_reset14)
      begin
         interrupt_en_reg14 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel14)
            interrupt_en_reg14 <= pwdata14[5:0];
         else
            interrupt_en_reg14 <= interrupt_en_reg14;

      end 
      
   end  
           


endmodule

