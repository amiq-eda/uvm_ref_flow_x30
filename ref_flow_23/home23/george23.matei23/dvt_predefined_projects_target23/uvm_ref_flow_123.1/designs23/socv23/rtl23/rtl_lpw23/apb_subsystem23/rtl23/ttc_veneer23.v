//File23 name   : ttc_veneer23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------
module ttc_veneer23 (
           
           //inputs23
           n_p_reset23,
           pclk23,
           psel23,
           penable23,
           pwrite23,
           pwdata23,
           paddr23,
           scan_in23,
           scan_en23,

           //outputs23
           prdata23,
           interrupt23,
           scan_out23           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS23
//-----------------------------------------------------------------------------

   input         n_p_reset23;            //System23 Reset23
   input         pclk23;                 //System23 clock23
   input         psel23;                 //Select23 line
   input         penable23;              //Enable23
   input         pwrite23;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata23;               //Write data
   input [7:0]   paddr23;                //Address Bus23 register
   input         scan_in23;              //Scan23 chain23 input port
   input         scan_en23;              //Scan23 chain23 enable port
   
   output [31:0] prdata23;               //Read Data from the APB23 Interface23
   output [3:1]  interrupt23;            //Interrupt23 from PCI23 
   output        scan_out23;             //Scan23 chain23 output port

//##############################################################################
// if the TTC23 is NOT23 black23 boxed23 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC23 

ttc_lite23 i_ttc23(

   //inputs23
   .n_p_reset23(n_p_reset23),
   .pclk23(pclk23),
   .psel23(psel23),
   .penable23(penable23),
   .pwrite23(pwrite23),
   .pwdata23(pwdata23),
   .paddr23(paddr23),
   .scan_in23(),
   .scan_en23(scan_en23),

   //outputs23
   .prdata23(prdata23),
   .interrupt23(interrupt23),
   .scan_out23()
);

`else 
//##############################################################################
// if the TTC23 is black23 boxed23 
//##############################################################################

   wire          n_p_reset23;            //System23 Reset23
   wire          pclk23;                 //System23 clock23
   wire          psel23;                 //Select23 line
   wire          penable23;              //Enable23
   wire          pwrite23;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata23;               //Write data
   wire  [7:0]   paddr23;                //Address Bus23 register
   wire          scan_in23;              //Scan23 chain23 wire  port
   wire          scan_en23;              //Scan23 chain23 enable port
   
   reg    [31:0] prdata23;               //Read Data from the APB23 Interface23
   reg    [3:1]  interrupt23;            //Interrupt23 from PCI23 
   reg           scan_out23;             //Scan23 chain23 reg    port

`endif
//##############################################################################
// black23 boxed23 defines23 
//##############################################################################

endmodule
