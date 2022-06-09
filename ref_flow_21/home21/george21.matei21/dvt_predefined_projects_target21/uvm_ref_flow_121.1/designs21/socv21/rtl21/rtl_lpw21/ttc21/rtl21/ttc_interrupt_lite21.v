//File21 name   : ttc_interrupt_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 : Interrupts21 from the counter modules21 are registered
//              and if enabled cause the output interrupt21 to go21 high21.
//              Also21 the match121 interrupts21 are monitored21 to generate output 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module21 definition21
//-----------------------------------------------------------------------------

module ttc_interrupt_lite21(

  //inputs21
  n_p_reset21,                             
  pwdata21,                             
  pclk21,
  intr_en_reg_sel21, 
  clear_interrupt21,                   
  interval_intr21,
  match_intr21,
  overflow_intr21,
  restart21,

  //outputs21
  interrupt21,
  interrupt_reg_out21,
  interrupt_en_out21
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS21
//-----------------------------------------------------------------------------

   //inputs21
   input         n_p_reset21;            //reset signal21
   input [5:0]   pwdata21;               //6 Bit21 Data signal21
   input         pclk21;                 //System21 clock21
   input         intr_en_reg_sel21;      //Interrupt21 Enable21 Reg21 Select21 signal21
   input         clear_interrupt21;      //Clear Interrupt21 Register signal21
   input         interval_intr21;        //Timer_Counter21 Interval21 Interrupt21
   input [3:1]   match_intr21;           //Timer_Counter21 Match21 1 Interrupt21 
   input         overflow_intr21;        //Timer_Counter21 Overflow21 Interrupt21 
   input         restart21;              //Counter21 restart21

   //Outputs21
   output        interrupt21;            //Interrupt21 Signal21 
   output [5:0]  interrupt_reg_out21;    //6 Bit21 Interrupt21 Register
   output [5:0]  interrupt_en_out21; //6 Bit21 Interrupt21 Enable21 Register


//-----------------------------------------------------------------------------
// Internal Signals21 & Registers21
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect21;          //Interrupts21 from the Timer_Counter21
   reg [5:0]    int_sync_reg21;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg21;        //6-bit register ensuring21 each interrupt21 
                                      //only read once21
   reg [5:0]    interrupt_reg21;        //6-bit interrupt21 register        
   reg [5:0]    interrupt_en_reg21; //6-bit interrupt21 enable register
   

   reg          interrupt_set21;        //Prevents21 unread21 interrupt21 being cleared21
   
   wire         interrupt21;            //Interrupt21 output
   wire [5:0]   interrupt_reg_out21;    //Interrupt21 register output
   wire [5:0]   interrupt_en_out21; //Interrupt21 enable output


   assign interrupt21              = |(interrupt_reg21);
   assign interrupt_reg_out21      = interrupt_reg21;
   assign interrupt_en_out21       = interrupt_en_reg21;
   
   assign intr_detect21 = {1'b0,
                         overflow_intr21,  
                         match_intr21[3],  
                         match_intr21[2], 
                         match_intr21[1], 
                         interval_intr21};

   

// Setting interrupt21 registers
   
   always @ (posedge pclk21 or negedge n_p_reset21)
   begin: p_intr_reg_ctrl21
      
      if (!n_p_reset21)
      begin
         int_sync_reg21         <= 6'b000000;
         interrupt_reg21        <= 6'b000000;
         int_cycle_reg21        <= 6'b000000;
         interrupt_set21        <= 1'b0;
      end
      else 
      begin

         int_sync_reg21    <= intr_detect21;
         int_cycle_reg21   <= ~int_sync_reg21 & intr_detect21;

         interrupt_set21   <= |int_cycle_reg21;
          
         if (clear_interrupt21 & ~interrupt_set21)
            interrupt_reg21 <= (6'b000000 | (int_cycle_reg21 & interrupt_en_reg21));
         else 
            interrupt_reg21 <= (interrupt_reg21 | (int_cycle_reg21 & 
                                               interrupt_en_reg21));
      end 
      
   end  //p_intr_reg_ctrl21


// Setting interrupt21 enable register
   
   always @ (posedge pclk21 or negedge n_p_reset21)
   begin: p_intr_en_reg21
      
      if (!n_p_reset21)
      begin
         interrupt_en_reg21 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel21)
            interrupt_en_reg21 <= pwdata21[5:0];
         else
            interrupt_en_reg21 <= interrupt_en_reg21;

      end 
      
   end  
           


endmodule

