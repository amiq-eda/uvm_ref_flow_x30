//File25 name   : ttc_interrupt_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 : Interrupts25 from the counter modules25 are registered
//              and if enabled cause the output interrupt25 to go25 high25.
//              Also25 the match125 interrupts25 are monitored25 to generate output 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module25 definition25
//-----------------------------------------------------------------------------

module ttc_interrupt_lite25(

  //inputs25
  n_p_reset25,                             
  pwdata25,                             
  pclk25,
  intr_en_reg_sel25, 
  clear_interrupt25,                   
  interval_intr25,
  match_intr25,
  overflow_intr25,
  restart25,

  //outputs25
  interrupt25,
  interrupt_reg_out25,
  interrupt_en_out25
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS25
//-----------------------------------------------------------------------------

   //inputs25
   input         n_p_reset25;            //reset signal25
   input [5:0]   pwdata25;               //6 Bit25 Data signal25
   input         pclk25;                 //System25 clock25
   input         intr_en_reg_sel25;      //Interrupt25 Enable25 Reg25 Select25 signal25
   input         clear_interrupt25;      //Clear Interrupt25 Register signal25
   input         interval_intr25;        //Timer_Counter25 Interval25 Interrupt25
   input [3:1]   match_intr25;           //Timer_Counter25 Match25 1 Interrupt25 
   input         overflow_intr25;        //Timer_Counter25 Overflow25 Interrupt25 
   input         restart25;              //Counter25 restart25

   //Outputs25
   output        interrupt25;            //Interrupt25 Signal25 
   output [5:0]  interrupt_reg_out25;    //6 Bit25 Interrupt25 Register
   output [5:0]  interrupt_en_out25; //6 Bit25 Interrupt25 Enable25 Register


//-----------------------------------------------------------------------------
// Internal Signals25 & Registers25
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect25;          //Interrupts25 from the Timer_Counter25
   reg [5:0]    int_sync_reg25;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg25;        //6-bit register ensuring25 each interrupt25 
                                      //only read once25
   reg [5:0]    interrupt_reg25;        //6-bit interrupt25 register        
   reg [5:0]    interrupt_en_reg25; //6-bit interrupt25 enable register
   

   reg          interrupt_set25;        //Prevents25 unread25 interrupt25 being cleared25
   
   wire         interrupt25;            //Interrupt25 output
   wire [5:0]   interrupt_reg_out25;    //Interrupt25 register output
   wire [5:0]   interrupt_en_out25; //Interrupt25 enable output


   assign interrupt25              = |(interrupt_reg25);
   assign interrupt_reg_out25      = interrupt_reg25;
   assign interrupt_en_out25       = interrupt_en_reg25;
   
   assign intr_detect25 = {1'b0,
                         overflow_intr25,  
                         match_intr25[3],  
                         match_intr25[2], 
                         match_intr25[1], 
                         interval_intr25};

   

// Setting interrupt25 registers
   
   always @ (posedge pclk25 or negedge n_p_reset25)
   begin: p_intr_reg_ctrl25
      
      if (!n_p_reset25)
      begin
         int_sync_reg25         <= 6'b000000;
         interrupt_reg25        <= 6'b000000;
         int_cycle_reg25        <= 6'b000000;
         interrupt_set25        <= 1'b0;
      end
      else 
      begin

         int_sync_reg25    <= intr_detect25;
         int_cycle_reg25   <= ~int_sync_reg25 & intr_detect25;

         interrupt_set25   <= |int_cycle_reg25;
          
         if (clear_interrupt25 & ~interrupt_set25)
            interrupt_reg25 <= (6'b000000 | (int_cycle_reg25 & interrupt_en_reg25));
         else 
            interrupt_reg25 <= (interrupt_reg25 | (int_cycle_reg25 & 
                                               interrupt_en_reg25));
      end 
      
   end  //p_intr_reg_ctrl25


// Setting interrupt25 enable register
   
   always @ (posedge pclk25 or negedge n_p_reset25)
   begin: p_intr_en_reg25
      
      if (!n_p_reset25)
      begin
         interrupt_en_reg25 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel25)
            interrupt_en_reg25 <= pwdata25[5:0];
         else
            interrupt_en_reg25 <= interrupt_en_reg25;

      end 
      
   end  
           


endmodule

