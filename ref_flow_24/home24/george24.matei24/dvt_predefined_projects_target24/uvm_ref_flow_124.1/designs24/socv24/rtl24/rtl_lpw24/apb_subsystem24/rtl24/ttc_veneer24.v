//File24 name   : ttc_veneer24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------
module ttc_veneer24 (
           
           //inputs24
           n_p_reset24,
           pclk24,
           psel24,
           penable24,
           pwrite24,
           pwdata24,
           paddr24,
           scan_in24,
           scan_en24,

           //outputs24
           prdata24,
           interrupt24,
           scan_out24           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS24
//-----------------------------------------------------------------------------

   input         n_p_reset24;            //System24 Reset24
   input         pclk24;                 //System24 clock24
   input         psel24;                 //Select24 line
   input         penable24;              //Enable24
   input         pwrite24;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata24;               //Write data
   input [7:0]   paddr24;                //Address Bus24 register
   input         scan_in24;              //Scan24 chain24 input port
   input         scan_en24;              //Scan24 chain24 enable port
   
   output [31:0] prdata24;               //Read Data from the APB24 Interface24
   output [3:1]  interrupt24;            //Interrupt24 from PCI24 
   output        scan_out24;             //Scan24 chain24 output port

//##############################################################################
// if the TTC24 is NOT24 black24 boxed24 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC24 

ttc_lite24 i_ttc24(

   //inputs24
   .n_p_reset24(n_p_reset24),
   .pclk24(pclk24),
   .psel24(psel24),
   .penable24(penable24),
   .pwrite24(pwrite24),
   .pwdata24(pwdata24),
   .paddr24(paddr24),
   .scan_in24(),
   .scan_en24(scan_en24),

   //outputs24
   .prdata24(prdata24),
   .interrupt24(interrupt24),
   .scan_out24()
);

`else 
//##############################################################################
// if the TTC24 is black24 boxed24 
//##############################################################################

   wire          n_p_reset24;            //System24 Reset24
   wire          pclk24;                 //System24 clock24
   wire          psel24;                 //Select24 line
   wire          penable24;              //Enable24
   wire          pwrite24;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata24;               //Write data
   wire  [7:0]   paddr24;                //Address Bus24 register
   wire          scan_in24;              //Scan24 chain24 wire  port
   wire          scan_en24;              //Scan24 chain24 enable port
   
   reg    [31:0] prdata24;               //Read Data from the APB24 Interface24
   reg    [3:1]  interrupt24;            //Interrupt24 from PCI24 
   reg           scan_out24;             //Scan24 chain24 reg    port

`endif
//##############################################################################
// black24 boxed24 defines24 
//##############################################################################

endmodule
