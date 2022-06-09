//File30 name   : ttc_veneer30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------
module ttc_veneer30 (
           
           //inputs30
           n_p_reset30,
           pclk30,
           psel30,
           penable30,
           pwrite30,
           pwdata30,
           paddr30,
           scan_in30,
           scan_en30,

           //outputs30
           prdata30,
           interrupt30,
           scan_out30           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS30
//-----------------------------------------------------------------------------

   input         n_p_reset30;            //System30 Reset30
   input         pclk30;                 //System30 clock30
   input         psel30;                 //Select30 line
   input         penable30;              //Enable30
   input         pwrite30;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata30;               //Write data
   input [7:0]   paddr30;                //Address Bus30 register
   input         scan_in30;              //Scan30 chain30 input port
   input         scan_en30;              //Scan30 chain30 enable port
   
   output [31:0] prdata30;               //Read Data from the APB30 Interface30
   output [3:1]  interrupt30;            //Interrupt30 from PCI30 
   output        scan_out30;             //Scan30 chain30 output port

//##############################################################################
// if the TTC30 is NOT30 black30 boxed30 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC30 

ttc_lite30 i_ttc30(

   //inputs30
   .n_p_reset30(n_p_reset30),
   .pclk30(pclk30),
   .psel30(psel30),
   .penable30(penable30),
   .pwrite30(pwrite30),
   .pwdata30(pwdata30),
   .paddr30(paddr30),
   .scan_in30(),
   .scan_en30(scan_en30),

   //outputs30
   .prdata30(prdata30),
   .interrupt30(interrupt30),
   .scan_out30()
);

`else 
//##############################################################################
// if the TTC30 is black30 boxed30 
//##############################################################################

   wire          n_p_reset30;            //System30 Reset30
   wire          pclk30;                 //System30 clock30
   wire          psel30;                 //Select30 line
   wire          penable30;              //Enable30
   wire          pwrite30;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata30;               //Write data
   wire  [7:0]   paddr30;                //Address Bus30 register
   wire          scan_in30;              //Scan30 chain30 wire  port
   wire          scan_en30;              //Scan30 chain30 enable port
   
   reg    [31:0] prdata30;               //Read Data from the APB30 Interface30
   reg    [3:1]  interrupt30;            //Interrupt30 from PCI30 
   reg           scan_out30;             //Scan30 chain30 reg    port

`endif
//##############################################################################
// black30 boxed30 defines30 
//##############################################################################

endmodule
