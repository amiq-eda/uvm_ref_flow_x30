//File28 name   : ttc_veneer28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------
module ttc_veneer28 (
           
           //inputs28
           n_p_reset28,
           pclk28,
           psel28,
           penable28,
           pwrite28,
           pwdata28,
           paddr28,
           scan_in28,
           scan_en28,

           //outputs28
           prdata28,
           interrupt28,
           scan_out28           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS28
//-----------------------------------------------------------------------------

   input         n_p_reset28;            //System28 Reset28
   input         pclk28;                 //System28 clock28
   input         psel28;                 //Select28 line
   input         penable28;              //Enable28
   input         pwrite28;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata28;               //Write data
   input [7:0]   paddr28;                //Address Bus28 register
   input         scan_in28;              //Scan28 chain28 input port
   input         scan_en28;              //Scan28 chain28 enable port
   
   output [31:0] prdata28;               //Read Data from the APB28 Interface28
   output [3:1]  interrupt28;            //Interrupt28 from PCI28 
   output        scan_out28;             //Scan28 chain28 output port

//##############################################################################
// if the TTC28 is NOT28 black28 boxed28 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC28 

ttc_lite28 i_ttc28(

   //inputs28
   .n_p_reset28(n_p_reset28),
   .pclk28(pclk28),
   .psel28(psel28),
   .penable28(penable28),
   .pwrite28(pwrite28),
   .pwdata28(pwdata28),
   .paddr28(paddr28),
   .scan_in28(),
   .scan_en28(scan_en28),

   //outputs28
   .prdata28(prdata28),
   .interrupt28(interrupt28),
   .scan_out28()
);

`else 
//##############################################################################
// if the TTC28 is black28 boxed28 
//##############################################################################

   wire          n_p_reset28;            //System28 Reset28
   wire          pclk28;                 //System28 clock28
   wire          psel28;                 //Select28 line
   wire          penable28;              //Enable28
   wire          pwrite28;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata28;               //Write data
   wire  [7:0]   paddr28;                //Address Bus28 register
   wire          scan_in28;              //Scan28 chain28 wire  port
   wire          scan_en28;              //Scan28 chain28 enable port
   
   reg    [31:0] prdata28;               //Read Data from the APB28 Interface28
   reg    [3:1]  interrupt28;            //Interrupt28 from PCI28 
   reg           scan_out28;             //Scan28 chain28 reg    port

`endif
//##############################################################################
// black28 boxed28 defines28 
//##############################################################################

endmodule
