//File16 name   : ttc_veneer16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------
module ttc_veneer16 (
           
           //inputs16
           n_p_reset16,
           pclk16,
           psel16,
           penable16,
           pwrite16,
           pwdata16,
           paddr16,
           scan_in16,
           scan_en16,

           //outputs16
           prdata16,
           interrupt16,
           scan_out16           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS16
//-----------------------------------------------------------------------------

   input         n_p_reset16;            //System16 Reset16
   input         pclk16;                 //System16 clock16
   input         psel16;                 //Select16 line
   input         penable16;              //Enable16
   input         pwrite16;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata16;               //Write data
   input [7:0]   paddr16;                //Address Bus16 register
   input         scan_in16;              //Scan16 chain16 input port
   input         scan_en16;              //Scan16 chain16 enable port
   
   output [31:0] prdata16;               //Read Data from the APB16 Interface16
   output [3:1]  interrupt16;            //Interrupt16 from PCI16 
   output        scan_out16;             //Scan16 chain16 output port

//##############################################################################
// if the TTC16 is NOT16 black16 boxed16 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC16 

ttc_lite16 i_ttc16(

   //inputs16
   .n_p_reset16(n_p_reset16),
   .pclk16(pclk16),
   .psel16(psel16),
   .penable16(penable16),
   .pwrite16(pwrite16),
   .pwdata16(pwdata16),
   .paddr16(paddr16),
   .scan_in16(),
   .scan_en16(scan_en16),

   //outputs16
   .prdata16(prdata16),
   .interrupt16(interrupt16),
   .scan_out16()
);

`else 
//##############################################################################
// if the TTC16 is black16 boxed16 
//##############################################################################

   wire          n_p_reset16;            //System16 Reset16
   wire          pclk16;                 //System16 clock16
   wire          psel16;                 //Select16 line
   wire          penable16;              //Enable16
   wire          pwrite16;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata16;               //Write data
   wire  [7:0]   paddr16;                //Address Bus16 register
   wire          scan_in16;              //Scan16 chain16 wire  port
   wire          scan_en16;              //Scan16 chain16 enable port
   
   reg    [31:0] prdata16;               //Read Data from the APB16 Interface16
   reg    [3:1]  interrupt16;            //Interrupt16 from PCI16 
   reg           scan_out16;             //Scan16 chain16 reg    port

`endif
//##############################################################################
// black16 boxed16 defines16 
//##############################################################################

endmodule
