//File19 name   : ttc_interrupt_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 : Interrupts19 from the counter modules19 are registered
//              and if enabled cause the output interrupt19 to go19 high19.
//              Also19 the match119 interrupts19 are monitored19 to generate output 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module19 definition19
//-----------------------------------------------------------------------------

module ttc_interrupt_lite19(

  //inputs19
  n_p_reset19,                             
  pwdata19,                             
  pclk19,
  intr_en_reg_sel19, 
  clear_interrupt19,                   
  interval_intr19,
  match_intr19,
  overflow_intr19,
  restart19,

  //outputs19
  interrupt19,
  interrupt_reg_out19,
  interrupt_en_out19
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS19
//-----------------------------------------------------------------------------

   //inputs19
   input         n_p_reset19;            //reset signal19
   input [5:0]   pwdata19;               //6 Bit19 Data signal19
   input         pclk19;                 //System19 clock19
   input         intr_en_reg_sel19;      //Interrupt19 Enable19 Reg19 Select19 signal19
   input         clear_interrupt19;      //Clear Interrupt19 Register signal19
   input         interval_intr19;        //Timer_Counter19 Interval19 Interrupt19
   input [3:1]   match_intr19;           //Timer_Counter19 Match19 1 Interrupt19 
   input         overflow_intr19;        //Timer_Counter19 Overflow19 Interrupt19 
   input         restart19;              //Counter19 restart19

   //Outputs19
   output        interrupt19;            //Interrupt19 Signal19 
   output [5:0]  interrupt_reg_out19;    //6 Bit19 Interrupt19 Register
   output [5:0]  interrupt_en_out19; //6 Bit19 Interrupt19 Enable19 Register


//-----------------------------------------------------------------------------
// Internal Signals19 & Registers19
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect19;          //Interrupts19 from the Timer_Counter19
   reg [5:0]    int_sync_reg19;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg19;        //6-bit register ensuring19 each interrupt19 
                                      //only read once19
   reg [5:0]    interrupt_reg19;        //6-bit interrupt19 register        
   reg [5:0]    interrupt_en_reg19; //6-bit interrupt19 enable register
   

   reg          interrupt_set19;        //Prevents19 unread19 interrupt19 being cleared19
   
   wire         interrupt19;            //Interrupt19 output
   wire [5:0]   interrupt_reg_out19;    //Interrupt19 register output
   wire [5:0]   interrupt_en_out19; //Interrupt19 enable output


   assign interrupt19              = |(interrupt_reg19);
   assign interrupt_reg_out19      = interrupt_reg19;
   assign interrupt_en_out19       = interrupt_en_reg19;
   
   assign intr_detect19 = {1'b0,
                         overflow_intr19,  
                         match_intr19[3],  
                         match_intr19[2], 
                         match_intr19[1], 
                         interval_intr19};

   

// Setting interrupt19 registers
   
   always @ (posedge pclk19 or negedge n_p_reset19)
   begin: p_intr_reg_ctrl19
      
      if (!n_p_reset19)
      begin
         int_sync_reg19         <= 6'b000000;
         interrupt_reg19        <= 6'b000000;
         int_cycle_reg19        <= 6'b000000;
         interrupt_set19        <= 1'b0;
      end
      else 
      begin

         int_sync_reg19    <= intr_detect19;
         int_cycle_reg19   <= ~int_sync_reg19 & intr_detect19;

         interrupt_set19   <= |int_cycle_reg19;
          
         if (clear_interrupt19 & ~interrupt_set19)
            interrupt_reg19 <= (6'b000000 | (int_cycle_reg19 & interrupt_en_reg19));
         else 
            interrupt_reg19 <= (interrupt_reg19 | (int_cycle_reg19 & 
                                               interrupt_en_reg19));
      end 
      
   end  //p_intr_reg_ctrl19


// Setting interrupt19 enable register
   
   always @ (posedge pclk19 or negedge n_p_reset19)
   begin: p_intr_en_reg19
      
      if (!n_p_reset19)
      begin
         interrupt_en_reg19 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel19)
            interrupt_en_reg19 <= pwdata19[5:0];
         else
            interrupt_en_reg19 <= interrupt_en_reg19;

      end 
      
   end  
           


endmodule

