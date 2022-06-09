//File10 name   : ttc_veneer10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------
module ttc_veneer10 (
           
           //inputs10
           n_p_reset10,
           pclk10,
           psel10,
           penable10,
           pwrite10,
           pwdata10,
           paddr10,
           scan_in10,
           scan_en10,

           //outputs10
           prdata10,
           interrupt10,
           scan_out10           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS10
//-----------------------------------------------------------------------------

   input         n_p_reset10;            //System10 Reset10
   input         pclk10;                 //System10 clock10
   input         psel10;                 //Select10 line
   input         penable10;              //Enable10
   input         pwrite10;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata10;               //Write data
   input [7:0]   paddr10;                //Address Bus10 register
   input         scan_in10;              //Scan10 chain10 input port
   input         scan_en10;              //Scan10 chain10 enable port
   
   output [31:0] prdata10;               //Read Data from the APB10 Interface10
   output [3:1]  interrupt10;            //Interrupt10 from PCI10 
   output        scan_out10;             //Scan10 chain10 output port

//##############################################################################
// if the TTC10 is NOT10 black10 boxed10 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC10 

ttc_lite10 i_ttc10(

   //inputs10
   .n_p_reset10(n_p_reset10),
   .pclk10(pclk10),
   .psel10(psel10),
   .penable10(penable10),
   .pwrite10(pwrite10),
   .pwdata10(pwdata10),
   .paddr10(paddr10),
   .scan_in10(),
   .scan_en10(scan_en10),

   //outputs10
   .prdata10(prdata10),
   .interrupt10(interrupt10),
   .scan_out10()
);

`else 
//##############################################################################
// if the TTC10 is black10 boxed10 
//##############################################################################

   wire          n_p_reset10;            //System10 Reset10
   wire          pclk10;                 //System10 clock10
   wire          psel10;                 //Select10 line
   wire          penable10;              //Enable10
   wire          pwrite10;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata10;               //Write data
   wire  [7:0]   paddr10;                //Address Bus10 register
   wire          scan_in10;              //Scan10 chain10 wire  port
   wire          scan_en10;              //Scan10 chain10 enable port
   
   reg    [31:0] prdata10;               //Read Data from the APB10 Interface10
   reg    [3:1]  interrupt10;            //Interrupt10 from PCI10 
   reg           scan_out10;             //Scan10 chain10 reg    port

`endif
//##############################################################################
// black10 boxed10 defines10 
//##############################################################################

endmodule
