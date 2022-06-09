//File15 name   : ttc_veneer15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------
module ttc_veneer15 (
           
           //inputs15
           n_p_reset15,
           pclk15,
           psel15,
           penable15,
           pwrite15,
           pwdata15,
           paddr15,
           scan_in15,
           scan_en15,

           //outputs15
           prdata15,
           interrupt15,
           scan_out15           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS15
//-----------------------------------------------------------------------------

   input         n_p_reset15;            //System15 Reset15
   input         pclk15;                 //System15 clock15
   input         psel15;                 //Select15 line
   input         penable15;              //Enable15
   input         pwrite15;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata15;               //Write data
   input [7:0]   paddr15;                //Address Bus15 register
   input         scan_in15;              //Scan15 chain15 input port
   input         scan_en15;              //Scan15 chain15 enable port
   
   output [31:0] prdata15;               //Read Data from the APB15 Interface15
   output [3:1]  interrupt15;            //Interrupt15 from PCI15 
   output        scan_out15;             //Scan15 chain15 output port

//##############################################################################
// if the TTC15 is NOT15 black15 boxed15 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC15 

ttc_lite15 i_ttc15(

   //inputs15
   .n_p_reset15(n_p_reset15),
   .pclk15(pclk15),
   .psel15(psel15),
   .penable15(penable15),
   .pwrite15(pwrite15),
   .pwdata15(pwdata15),
   .paddr15(paddr15),
   .scan_in15(),
   .scan_en15(scan_en15),

   //outputs15
   .prdata15(prdata15),
   .interrupt15(interrupt15),
   .scan_out15()
);

`else 
//##############################################################################
// if the TTC15 is black15 boxed15 
//##############################################################################

   wire          n_p_reset15;            //System15 Reset15
   wire          pclk15;                 //System15 clock15
   wire          psel15;                 //Select15 line
   wire          penable15;              //Enable15
   wire          pwrite15;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata15;               //Write data
   wire  [7:0]   paddr15;                //Address Bus15 register
   wire          scan_in15;              //Scan15 chain15 wire  port
   wire          scan_en15;              //Scan15 chain15 enable port
   
   reg    [31:0] prdata15;               //Read Data from the APB15 Interface15
   reg    [3:1]  interrupt15;            //Interrupt15 from PCI15 
   reg           scan_out15;             //Scan15 chain15 reg    port

`endif
//##############################################################################
// black15 boxed15 defines15 
//##############################################################################

endmodule
