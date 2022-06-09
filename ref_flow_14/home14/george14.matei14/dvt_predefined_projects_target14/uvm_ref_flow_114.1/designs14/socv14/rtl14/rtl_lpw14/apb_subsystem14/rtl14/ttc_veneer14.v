//File14 name   : ttc_veneer14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------
module ttc_veneer14 (
           
           //inputs14
           n_p_reset14,
           pclk14,
           psel14,
           penable14,
           pwrite14,
           pwdata14,
           paddr14,
           scan_in14,
           scan_en14,

           //outputs14
           prdata14,
           interrupt14,
           scan_out14           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS14
//-----------------------------------------------------------------------------

   input         n_p_reset14;            //System14 Reset14
   input         pclk14;                 //System14 clock14
   input         psel14;                 //Select14 line
   input         penable14;              //Enable14
   input         pwrite14;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata14;               //Write data
   input [7:0]   paddr14;                //Address Bus14 register
   input         scan_in14;              //Scan14 chain14 input port
   input         scan_en14;              //Scan14 chain14 enable port
   
   output [31:0] prdata14;               //Read Data from the APB14 Interface14
   output [3:1]  interrupt14;            //Interrupt14 from PCI14 
   output        scan_out14;             //Scan14 chain14 output port

//##############################################################################
// if the TTC14 is NOT14 black14 boxed14 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC14 

ttc_lite14 i_ttc14(

   //inputs14
   .n_p_reset14(n_p_reset14),
   .pclk14(pclk14),
   .psel14(psel14),
   .penable14(penable14),
   .pwrite14(pwrite14),
   .pwdata14(pwdata14),
   .paddr14(paddr14),
   .scan_in14(),
   .scan_en14(scan_en14),

   //outputs14
   .prdata14(prdata14),
   .interrupt14(interrupt14),
   .scan_out14()
);

`else 
//##############################################################################
// if the TTC14 is black14 boxed14 
//##############################################################################

   wire          n_p_reset14;            //System14 Reset14
   wire          pclk14;                 //System14 clock14
   wire          psel14;                 //Select14 line
   wire          penable14;              //Enable14
   wire          pwrite14;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata14;               //Write data
   wire  [7:0]   paddr14;                //Address Bus14 register
   wire          scan_in14;              //Scan14 chain14 wire  port
   wire          scan_en14;              //Scan14 chain14 enable port
   
   reg    [31:0] prdata14;               //Read Data from the APB14 Interface14
   reg    [3:1]  interrupt14;            //Interrupt14 from PCI14 
   reg           scan_out14;             //Scan14 chain14 reg    port

`endif
//##############################################################################
// black14 boxed14 defines14 
//##############################################################################

endmodule
