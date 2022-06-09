//File29 name   : ttc_interrupt_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 : Interrupts29 from the counter modules29 are registered
//              and if enabled cause the output interrupt29 to go29 high29.
//              Also29 the match129 interrupts29 are monitored29 to generate output 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------
 


//-----------------------------------------------------------------------------
// Module29 definition29
//-----------------------------------------------------------------------------

module ttc_interrupt_lite29(

  //inputs29
  n_p_reset29,                             
  pwdata29,                             
  pclk29,
  intr_en_reg_sel29, 
  clear_interrupt29,                   
  interval_intr29,
  match_intr29,
  overflow_intr29,
  restart29,

  //outputs29
  interrupt29,
  interrupt_reg_out29,
  interrupt_en_out29
  
);


//-----------------------------------------------------------------------------
// PORT DECLARATIONS29
//-----------------------------------------------------------------------------

   //inputs29
   input         n_p_reset29;            //reset signal29
   input [5:0]   pwdata29;               //6 Bit29 Data signal29
   input         pclk29;                 //System29 clock29
   input         intr_en_reg_sel29;      //Interrupt29 Enable29 Reg29 Select29 signal29
   input         clear_interrupt29;      //Clear Interrupt29 Register signal29
   input         interval_intr29;        //Timer_Counter29 Interval29 Interrupt29
   input [3:1]   match_intr29;           //Timer_Counter29 Match29 1 Interrupt29 
   input         overflow_intr29;        //Timer_Counter29 Overflow29 Interrupt29 
   input         restart29;              //Counter29 restart29

   //Outputs29
   output        interrupt29;            //Interrupt29 Signal29 
   output [5:0]  interrupt_reg_out29;    //6 Bit29 Interrupt29 Register
   output [5:0]  interrupt_en_out29; //6 Bit29 Interrupt29 Enable29 Register


//-----------------------------------------------------------------------------
// Internal Signals29 & Registers29
//-----------------------------------------------------------------------------

   wire [5:0]   intr_detect29;          //Interrupts29 from the Timer_Counter29
   reg [5:0]    int_sync_reg29;         //6-bit 1st cycle sync register
   reg [5:0]    int_cycle_reg29;        //6-bit register ensuring29 each interrupt29 
                                      //only read once29
   reg [5:0]    interrupt_reg29;        //6-bit interrupt29 register        
   reg [5:0]    interrupt_en_reg29; //6-bit interrupt29 enable register
   

   reg          interrupt_set29;        //Prevents29 unread29 interrupt29 being cleared29
   
   wire         interrupt29;            //Interrupt29 output
   wire [5:0]   interrupt_reg_out29;    //Interrupt29 register output
   wire [5:0]   interrupt_en_out29; //Interrupt29 enable output


   assign interrupt29              = |(interrupt_reg29);
   assign interrupt_reg_out29      = interrupt_reg29;
   assign interrupt_en_out29       = interrupt_en_reg29;
   
   assign intr_detect29 = {1'b0,
                         overflow_intr29,  
                         match_intr29[3],  
                         match_intr29[2], 
                         match_intr29[1], 
                         interval_intr29};

   

// Setting interrupt29 registers
   
   always @ (posedge pclk29 or negedge n_p_reset29)
   begin: p_intr_reg_ctrl29
      
      if (!n_p_reset29)
      begin
         int_sync_reg29         <= 6'b000000;
         interrupt_reg29        <= 6'b000000;
         int_cycle_reg29        <= 6'b000000;
         interrupt_set29        <= 1'b0;
      end
      else 
      begin

         int_sync_reg29    <= intr_detect29;
         int_cycle_reg29   <= ~int_sync_reg29 & intr_detect29;

         interrupt_set29   <= |int_cycle_reg29;
          
         if (clear_interrupt29 & ~interrupt_set29)
            interrupt_reg29 <= (6'b000000 | (int_cycle_reg29 & interrupt_en_reg29));
         else 
            interrupt_reg29 <= (interrupt_reg29 | (int_cycle_reg29 & 
                                               interrupt_en_reg29));
      end 
      
   end  //p_intr_reg_ctrl29


// Setting interrupt29 enable register
   
   always @ (posedge pclk29 or negedge n_p_reset29)
   begin: p_intr_en_reg29
      
      if (!n_p_reset29)
      begin
         interrupt_en_reg29 <= 6'b000000;
      end
      else 
      begin

         if (intr_en_reg_sel29)
            interrupt_en_reg29 <= pwdata29[5:0];
         else
            interrupt_en_reg29 <= interrupt_en_reg29;

      end 
      
   end  
           


endmodule

