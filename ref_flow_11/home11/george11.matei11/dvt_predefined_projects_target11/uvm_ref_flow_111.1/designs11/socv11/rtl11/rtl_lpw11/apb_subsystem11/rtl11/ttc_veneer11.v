//File11 name   : ttc_veneer11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
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
module ttc_veneer11 (
           
           //inputs11
           n_p_reset11,
           pclk11,
           psel11,
           penable11,
           pwrite11,
           pwdata11,
           paddr11,
           scan_in11,
           scan_en11,

           //outputs11
           prdata11,
           interrupt11,
           scan_out11           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS11
//-----------------------------------------------------------------------------

   input         n_p_reset11;            //System11 Reset11
   input         pclk11;                 //System11 clock11
   input         psel11;                 //Select11 line
   input         penable11;              //Enable11
   input         pwrite11;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata11;               //Write data
   input [7:0]   paddr11;                //Address Bus11 register
   input         scan_in11;              //Scan11 chain11 input port
   input         scan_en11;              //Scan11 chain11 enable port
   
   output [31:0] prdata11;               //Read Data from the APB11 Interface11
   output [3:1]  interrupt11;            //Interrupt11 from PCI11 
   output        scan_out11;             //Scan11 chain11 output port

//##############################################################################
// if the TTC11 is NOT11 black11 boxed11 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC11 

ttc_lite11 i_ttc11(

   //inputs11
   .n_p_reset11(n_p_reset11),
   .pclk11(pclk11),
   .psel11(psel11),
   .penable11(penable11),
   .pwrite11(pwrite11),
   .pwdata11(pwdata11),
   .paddr11(paddr11),
   .scan_in11(),
   .scan_en11(scan_en11),

   //outputs11
   .prdata11(prdata11),
   .interrupt11(interrupt11),
   .scan_out11()
);

`else 
//##############################################################################
// if the TTC11 is black11 boxed11 
//##############################################################################

   wire          n_p_reset11;            //System11 Reset11
   wire          pclk11;                 //System11 clock11
   wire          psel11;                 //Select11 line
   wire          penable11;              //Enable11
   wire          pwrite11;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata11;               //Write data
   wire  [7:0]   paddr11;                //Address Bus11 register
   wire          scan_in11;              //Scan11 chain11 wire  port
   wire          scan_en11;              //Scan11 chain11 enable port
   
   reg    [31:0] prdata11;               //Read Data from the APB11 Interface11
   reg    [3:1]  interrupt11;            //Interrupt11 from PCI11 
   reg           scan_out11;             //Scan11 chain11 reg    port

`endif
//##############################################################################
// black11 boxed11 defines11 
//##############################################################################

endmodule
