//File29 name   : ttc_veneer29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
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
module ttc_veneer29 (
           
           //inputs29
           n_p_reset29,
           pclk29,
           psel29,
           penable29,
           pwrite29,
           pwdata29,
           paddr29,
           scan_in29,
           scan_en29,

           //outputs29
           prdata29,
           interrupt29,
           scan_out29           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS29
//-----------------------------------------------------------------------------

   input         n_p_reset29;            //System29 Reset29
   input         pclk29;                 //System29 clock29
   input         psel29;                 //Select29 line
   input         penable29;              //Enable29
   input         pwrite29;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata29;               //Write data
   input [7:0]   paddr29;                //Address Bus29 register
   input         scan_in29;              //Scan29 chain29 input port
   input         scan_en29;              //Scan29 chain29 enable port
   
   output [31:0] prdata29;               //Read Data from the APB29 Interface29
   output [3:1]  interrupt29;            //Interrupt29 from PCI29 
   output        scan_out29;             //Scan29 chain29 output port

//##############################################################################
// if the TTC29 is NOT29 black29 boxed29 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC29 

ttc_lite29 i_ttc29(

   //inputs29
   .n_p_reset29(n_p_reset29),
   .pclk29(pclk29),
   .psel29(psel29),
   .penable29(penable29),
   .pwrite29(pwrite29),
   .pwdata29(pwdata29),
   .paddr29(paddr29),
   .scan_in29(),
   .scan_en29(scan_en29),

   //outputs29
   .prdata29(prdata29),
   .interrupt29(interrupt29),
   .scan_out29()
);

`else 
//##############################################################################
// if the TTC29 is black29 boxed29 
//##############################################################################

   wire          n_p_reset29;            //System29 Reset29
   wire          pclk29;                 //System29 clock29
   wire          psel29;                 //Select29 line
   wire          penable29;              //Enable29
   wire          pwrite29;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata29;               //Write data
   wire  [7:0]   paddr29;                //Address Bus29 register
   wire          scan_in29;              //Scan29 chain29 wire  port
   wire          scan_en29;              //Scan29 chain29 enable port
   
   reg    [31:0] prdata29;               //Read Data from the APB29 Interface29
   reg    [3:1]  interrupt29;            //Interrupt29 from PCI29 
   reg           scan_out29;             //Scan29 chain29 reg    port

`endif
//##############################################################################
// black29 boxed29 defines29 
//##############################################################################

endmodule
