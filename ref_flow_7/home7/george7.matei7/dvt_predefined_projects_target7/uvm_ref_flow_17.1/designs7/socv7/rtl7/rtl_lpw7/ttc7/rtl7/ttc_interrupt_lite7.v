//File7 name   : ttc_interrupt_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 : Interrupts7 from the counter modules7 are registered
//              and if enabled cause the output interrupt7 to go7 high7.
//              Also7 the match17 interrupts7 are monitored7 to generate output 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module7 definition7
//-----------------------------------------------------------------------------

module ttc_interrupt_lite7(

  //inputs7
  n_p_reset7,                             
  pwdata7,                             
  pclk7,
  intr_en_reg_sel7, 
  clear_interrupt7,                   
  interval_intr7,
  match_intr7,
  overflow_intr7,
  restart7,

  //outputs7
  interrupt7,
  interrupt_reg_out7,
  interrupt_en_out7
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS7
//-----------------------------------------------------------------------------

   //inputs7
   input         n_p_reset7;            //reset signal7
   input [5:0]   pwdata7;               //6 Bit7 Data signal7
   input         pclk7;                 //System7 clock7
   input         intr_en_reg_sel7;      //Interrupt7 Enable7 Reg7 Select7 signal7
   input         clear_interrupt7;      //Clear Interrupt7 Register signal7
   input         interval_intr7;        //Timer_Counter7 Interval7 Interrupt7
   input [3:1]   match_intr7;           //Timer_Counter7 Match7 1 Interrupt7 
   input         overflow_intr7;        //Timer_Counter7 Overflow7 Interrupt7 
   input         restart7;              //Counter7 restart7

   //Outputs7
   output        interrupt7;            //Interrupt7 Signal7 
   output [5:0]  interrupt_reg_out7;    //6 Bit7 Interrupt7 Register
   output [5:0]  interrupt_en_out7; //6 Bit7 Interrupt7 Enable7 Register


//-----------------------------------------------------------------------------
// Internal Signals7 & Registers7
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect7;          //Interrupts7 from the Timer_Counter7
   reg [5:0]    int_sync_reg7;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg7;        //6-bit register ensuring7 each interrupt7 
                                      //only read once7
   reg [5:0]    interrupt_reg7;        //6-bit interrupt7 register        
   reg [5:0]    interrupt_en_reg7; //6-bit interrupt7 enable register
   

   reg          interrupt_set7;        //Prevents7 unread7 interrupt7 being cleared7
   
   wire         interrupt7;            //Interrupt7 output
   wire [5:0]   interrupt_reg_out7;    //Interrupt7 register output
   wire [5:0]   interrupt_en_out7; //Interrupt7 enable output


   assign interrupt7              = |(interrupt_reg7);
   assign interrupt_reg_out7      = interrupt_reg7;
   assign interrupt_en_out7       = interrupt_en_reg7;
   
   assign intr_detect7 = {1'b0,
                         overflow_intr7,  
                         match_intr7[3],  
                         match_intr7[2], 
                         match_intr7[1], 
                         interval_intr7};

   

// Setting interrupt7 registers
   
   always @ (posedge pclk7 or negedge n_p_reset7)
   begin: p_intr_reg_ctrl7
      
      if (!n_p_reset7)
      begin
         int_sync_reg7         <= 6'b000000;
         interrupt_reg7        <= 6'b000000;
         int_cycle_reg7        <= 6'b000000;
         interrupt_set7        <= 1'b0;
      end
      else 
      begin

         int_sync_reg7    <= intr_detect7;
         int_cycle_reg7   <= ~int_sync_reg7 & intr_detect7;

         interrupt_set7   <= |int_cycle_reg7;
          
         if (clear_interrupt7 & ~interrupt_set7)
            interrupt_reg7 <= (6'b000000 | (int_cycle_reg7 & interrupt_en_reg7));
         else 
            interrupt_reg7 <= (interrupt_reg7 | (int_cycle_reg7 & 
                                               interrupt_en_reg7));
      end 
      
   end  //p_intr_reg_ctrl7


// Setting interrupt7 enable register
   
   always @ (posedge pclk7 or negedge n_p_reset7)
   begin: p_intr_en_reg7
      
      if (!n_p_reset7)
      begin
         interrupt_en_reg7 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel7)
            interrupt_en_reg7 <= pwdata7[5:0];
         else
            interrupt_en_reg7 <= interrupt_en_reg7;

      end 
      
   end  
           


endmodule

