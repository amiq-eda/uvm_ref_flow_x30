//File20 name   : ttc_interrupt_lite20.v
//Title20       : 
//Created20     : 1999
//Description20 : Interrupts20 from the counter modules20 are registered
//              and if enabled cause the output interrupt20 to go20 high20.
//              Also20 the match120 interrupts20 are monitored20 to generate output 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module20 definition20
//-----------------------------------------------------------------------------

module ttc_interrupt_lite20(

  //inputs20
  n_p_reset20,                             
  pwdata20,                             
  pclk20,
  intr_en_reg_sel20, 
  clear_interrupt20,                   
  interval_intr20,
  match_intr20,
  overflow_intr20,
  restart20,

  //outputs20
  interrupt20,
  interrupt_reg_out20,
  interrupt_en_out20
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS20
//-----------------------------------------------------------------------------

   //inputs20
   input         n_p_reset20;            //reset signal20
   input [5:0]   pwdata20;               //6 Bit20 Data signal20
   input         pclk20;                 //System20 clock20
   input         intr_en_reg_sel20;      //Interrupt20 Enable20 Reg20 Select20 signal20
   input         clear_interrupt20;      //Clear Interrupt20 Register signal20
   input         interval_intr20;        //Timer_Counter20 Interval20 Interrupt20
   input [3:1]   match_intr20;           //Timer_Counter20 Match20 1 Interrupt20 
   input         overflow_intr20;        //Timer_Counter20 Overflow20 Interrupt20 
   input         restart20;              //Counter20 restart20

   //Outputs20
   output        interrupt20;            //Interrupt20 Signal20 
   output [5:0]  interrupt_reg_out20;    //6 Bit20 Interrupt20 Register
   output [5:0]  interrupt_en_out20; //6 Bit20 Interrupt20 Enable20 Register


//-----------------------------------------------------------------------------
// Internal Signals20 & Registers20
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect20;          //Interrupts20 from the Timer_Counter20
   reg [5:0]    int_sync_reg20;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg20;        //6-bit register ensuring20 each interrupt20 
                                      //only read once20
   reg [5:0]    interrupt_reg20;        //6-bit interrupt20 register        
   reg [5:0]    interrupt_en_reg20; //6-bit interrupt20 enable register
   

   reg          interrupt_set20;        //Prevents20 unread20 interrupt20 being cleared20
   
   wire         interrupt20;            //Interrupt20 output
   wire [5:0]   interrupt_reg_out20;    //Interrupt20 register output
   wire [5:0]   interrupt_en_out20; //Interrupt20 enable output


   assign interrupt20              = |(interrupt_reg20);
   assign interrupt_reg_out20      = interrupt_reg20;
   assign interrupt_en_out20       = interrupt_en_reg20;
   
   assign intr_detect20 = {1'b0,
                         overflow_intr20,  
                         match_intr20[3],  
                         match_intr20[2], 
                         match_intr20[1], 
                         interval_intr20};

   

// Setting interrupt20 registers
   
   always @ (posedge pclk20 or negedge n_p_reset20)
   begin: p_intr_reg_ctrl20
      
      if (!n_p_reset20)
      begin
         int_sync_reg20         <= 6'b000000;
         interrupt_reg20        <= 6'b000000;
         int_cycle_reg20        <= 6'b000000;
         interrupt_set20        <= 1'b0;
      end
      else 
      begin

         int_sync_reg20    <= intr_detect20;
         int_cycle_reg20   <= ~int_sync_reg20 & intr_detect20;

         interrupt_set20   <= |int_cycle_reg20;
          
         if (clear_interrupt20 & ~interrupt_set20)
            interrupt_reg20 <= (6'b000000 | (int_cycle_reg20 & interrupt_en_reg20));
         else 
            interrupt_reg20 <= (interrupt_reg20 | (int_cycle_reg20 & 
                                               interrupt_en_reg20));
      end 
      
   end  //p_intr_reg_ctrl20


// Setting interrupt20 enable register
   
   always @ (posedge pclk20 or negedge n_p_reset20)
   begin: p_intr_en_reg20
      
      if (!n_p_reset20)
      begin
         interrupt_en_reg20 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel20)
            interrupt_en_reg20 <= pwdata20[5:0];
         else
            interrupt_en_reg20 <= interrupt_en_reg20;

      end 
      
   end  
           


endmodule

