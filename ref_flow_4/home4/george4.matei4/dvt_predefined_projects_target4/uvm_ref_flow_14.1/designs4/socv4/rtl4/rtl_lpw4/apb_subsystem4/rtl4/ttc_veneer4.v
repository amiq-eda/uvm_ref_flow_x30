//File4 name   : ttc_veneer4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------
module ttc_veneer4 (
           
           //inputs4
           n_p_reset4,
           pclk4,
           psel4,
           penable4,
           pwrite4,
           pwdata4,
           paddr4,
           scan_in4,
           scan_en4,

           //outputs4
           prdata4,
           interrupt4,
           scan_out4           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS4
//-----------------------------------------------------------------------------

   input         n_p_reset4;            //System4 Reset4
   input         pclk4;                 //System4 clock4
   input         psel4;                 //Select4 line
   input         penable4;              //Enable4
   input         pwrite4;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata4;               //Write data
   input [7:0]   paddr4;                //Address Bus4 register
   input         scan_in4;              //Scan4 chain4 input port
   input         scan_en4;              //Scan4 chain4 enable port
   
   output [31:0] prdata4;               //Read Data from the APB4 Interface4
   output [3:1]  interrupt4;            //Interrupt4 from PCI4 
   output        scan_out4;             //Scan4 chain4 output port

//##############################################################################
// if the TTC4 is NOT4 black4 boxed4 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC4 

ttc_lite4 i_ttc4(

   //inputs4
   .n_p_reset4(n_p_reset4),
   .pclk4(pclk4),
   .psel4(psel4),
   .penable4(penable4),
   .pwrite4(pwrite4),
   .pwdata4(pwdata4),
   .paddr4(paddr4),
   .scan_in4(),
   .scan_en4(scan_en4),

   //outputs4
   .prdata4(prdata4),
   .interrupt4(interrupt4),
   .scan_out4()
);

`else 
//##############################################################################
// if the TTC4 is black4 boxed4 
//##############################################################################

   wire          n_p_reset4;            //System4 Reset4
   wire          pclk4;                 //System4 clock4
   wire          psel4;                 //Select4 line
   wire          penable4;              //Enable4
   wire          pwrite4;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata4;               //Write data
   wire  [7:0]   paddr4;                //Address Bus4 register
   wire          scan_in4;              //Scan4 chain4 wire  port
   wire          scan_en4;              //Scan4 chain4 enable port
   
   reg    [31:0] prdata4;               //Read Data from the APB4 Interface4
   reg    [3:1]  interrupt4;            //Interrupt4 from PCI4 
   reg           scan_out4;             //Scan4 chain4 reg    port

`endif
//##############################################################################
// black4 boxed4 defines4 
//##############################################################################

endmodule
