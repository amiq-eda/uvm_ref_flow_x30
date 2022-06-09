//File11 name   : ttc_interrupt_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 : Interrupts11 from the counter modules11 are registered
//              and if enabled cause the output interrupt11 to go11 high11.
//              Also11 the match111 interrupts11 are monitored11 to generate output 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module11 definition11
//-----------------------------------------------------------------------------

module ttc_interrupt_lite11(

  //inputs11
  n_p_reset11,                             
  pwdata11,                             
  pclk11,
  intr_en_reg_sel11, 
  clear_interrupt11,                   
  interval_intr11,
  match_intr11,
  overflow_intr11,
  restart11,

  //outputs11
  interrupt11,
  interrupt_reg_out11,
  interrupt_en_out11
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS11
//-----------------------------------------------------------------------------

   //inputs11
   input         n_p_reset11;            //reset signal11
   input [5:0]   pwdata11;               //6 Bit11 Data signal11
   input         pclk11;                 //System11 clock11
   input         intr_en_reg_sel11;      //Interrupt11 Enable11 Reg11 Select11 signal11
   input         clear_interrupt11;      //Clear Interrupt11 Register signal11
   input         interval_intr11;        //Timer_Counter11 Interval11 Interrupt11
   input [3:1]   match_intr11;           //Timer_Counter11 Match11 1 Interrupt11 
   input         overflow_intr11;        //Timer_Counter11 Overflow11 Interrupt11 
   input         restart11;              //Counter11 restart11

   //Outputs11
   output        interrupt11;            //Interrupt11 Signal11 
   output [5:0]  interrupt_reg_out11;    //6 Bit11 Interrupt11 Register
   output [5:0]  interrupt_en_out11; //6 Bit11 Interrupt11 Enable11 Register


//-----------------------------------------------------------------------------
// Internal Signals11 & Registers11
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect11;          //Interrupts11 from the Timer_Counter11
   reg [5:0]    int_sync_reg11;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg11;        //6-bit register ensuring11 each interrupt11 
                                      //only read once11
   reg [5:0]    interrupt_reg11;        //6-bit interrupt11 register        
   reg [5:0]    interrupt_en_reg11; //6-bit interrupt11 enable register
   

   reg          interrupt_set11;        //Prevents11 unread11 interrupt11 being cleared11
   
   wire         interrupt11;            //Interrupt11 output
   wire [5:0]   interrupt_reg_out11;    //Interrupt11 register output
   wire [5:0]   interrupt_en_out11; //Interrupt11 enable output


   assign interrupt11              = |(interrupt_reg11);
   assign interrupt_reg_out11      = interrupt_reg11;
   assign interrupt_en_out11       = interrupt_en_reg11;
   
   assign intr_detect11 = {1'b0,
                         overflow_intr11,  
                         match_intr11[3],  
                         match_intr11[2], 
                         match_intr11[1], 
                         interval_intr11};

   

// Setting interrupt11 registers
   
   always @ (posedge pclk11 or negedge n_p_reset11)
   begin: p_intr_reg_ctrl11
      
      if (!n_p_reset11)
      begin
         int_sync_reg11         <= 6'b000000;
         interrupt_reg11        <= 6'b000000;
         int_cycle_reg11        <= 6'b000000;
         interrupt_set11        <= 1'b0;
      end
      else 
      begin

         int_sync_reg11    <= intr_detect11;
         int_cycle_reg11   <= ~int_sync_reg11 & intr_detect11;

         interrupt_set11   <= |int_cycle_reg11;
          
         if (clear_interrupt11 & ~interrupt_set11)
            interrupt_reg11 <= (6'b000000 | (int_cycle_reg11 & interrupt_en_reg11));
         else 
            interrupt_reg11 <= (interrupt_reg11 | (int_cycle_reg11 & 
                                               interrupt_en_reg11));
      end 
      
   end  //p_intr_reg_ctrl11


// Setting interrupt11 enable register
   
   always @ (posedge pclk11 or negedge n_p_reset11)
   begin: p_intr_en_reg11
      
      if (!n_p_reset11)
      begin
         interrupt_en_reg11 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel11)
            interrupt_en_reg11 <= pwdata11[5:0];
         else
            interrupt_en_reg11 <= interrupt_en_reg11;

      end 
      
   end  
           


endmodule

