//File27 name   : ttc_veneer27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------
module ttc_veneer27 (
           
           //inputs27
           n_p_reset27,
           pclk27,
           psel27,
           penable27,
           pwrite27,
           pwdata27,
           paddr27,
           scan_in27,
           scan_en27,

           //outputs27
           prdata27,
           interrupt27,
           scan_out27           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS27
//-----------------------------------------------------------------------------

   input         n_p_reset27;            //System27 Reset27
   input         pclk27;                 //System27 clock27
   input         psel27;                 //Select27 line
   input         penable27;              //Enable27
   input         pwrite27;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata27;               //Write data
   input [7:0]   paddr27;                //Address Bus27 register
   input         scan_in27;              //Scan27 chain27 input port
   input         scan_en27;              //Scan27 chain27 enable port
   
   output [31:0] prdata27;               //Read Data from the APB27 Interface27
   output [3:1]  interrupt27;            //Interrupt27 from PCI27 
   output        scan_out27;             //Scan27 chain27 output port

//##############################################################################
// if the TTC27 is NOT27 black27 boxed27 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC27 

ttc_lite27 i_ttc27(

   //inputs27
   .n_p_reset27(n_p_reset27),
   .pclk27(pclk27),
   .psel27(psel27),
   .penable27(penable27),
   .pwrite27(pwrite27),
   .pwdata27(pwdata27),
   .paddr27(paddr27),
   .scan_in27(),
   .scan_en27(scan_en27),

   //outputs27
   .prdata27(prdata27),
   .interrupt27(interrupt27),
   .scan_out27()
);

`else 
//##############################################################################
// if the TTC27 is black27 boxed27 
//##############################################################################

   wire          n_p_reset27;            //System27 Reset27
   wire          pclk27;                 //System27 clock27
   wire          psel27;                 //Select27 line
   wire          penable27;              //Enable27
   wire          pwrite27;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata27;               //Write data
   wire  [7:0]   paddr27;                //Address Bus27 register
   wire          scan_in27;              //Scan27 chain27 wire  port
   wire          scan_en27;              //Scan27 chain27 enable port
   
   reg    [31:0] prdata27;               //Read Data from the APB27 Interface27
   reg    [3:1]  interrupt27;            //Interrupt27 from PCI27 
   reg           scan_out27;             //Scan27 chain27 reg    port

`endif
//##############################################################################
// black27 boxed27 defines27 
//##############################################################################

endmodule
