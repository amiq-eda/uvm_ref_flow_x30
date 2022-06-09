//File13 name   : ttc_veneer13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------
module ttc_veneer13 (
           
           //inputs13
           n_p_reset13,
           pclk13,
           psel13,
           penable13,
           pwrite13,
           pwdata13,
           paddr13,
           scan_in13,
           scan_en13,

           //outputs13
           prdata13,
           interrupt13,
           scan_out13           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS13
//-----------------------------------------------------------------------------

   input         n_p_reset13;            //System13 Reset13
   input         pclk13;                 //System13 clock13
   input         psel13;                 //Select13 line
   input         penable13;              //Enable13
   input         pwrite13;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata13;               //Write data
   input [7:0]   paddr13;                //Address Bus13 register
   input         scan_in13;              //Scan13 chain13 input port
   input         scan_en13;              //Scan13 chain13 enable port
   
   output [31:0] prdata13;               //Read Data from the APB13 Interface13
   output [3:1]  interrupt13;            //Interrupt13 from PCI13 
   output        scan_out13;             //Scan13 chain13 output port

//##############################################################################
// if the TTC13 is NOT13 black13 boxed13 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC13 

ttc_lite13 i_ttc13(

   //inputs13
   .n_p_reset13(n_p_reset13),
   .pclk13(pclk13),
   .psel13(psel13),
   .penable13(penable13),
   .pwrite13(pwrite13),
   .pwdata13(pwdata13),
   .paddr13(paddr13),
   .scan_in13(),
   .scan_en13(scan_en13),

   //outputs13
   .prdata13(prdata13),
   .interrupt13(interrupt13),
   .scan_out13()
);

`else 
//##############################################################################
// if the TTC13 is black13 boxed13 
//##############################################################################

   wire          n_p_reset13;            //System13 Reset13
   wire          pclk13;                 //System13 clock13
   wire          psel13;                 //Select13 line
   wire          penable13;              //Enable13
   wire          pwrite13;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata13;               //Write data
   wire  [7:0]   paddr13;                //Address Bus13 register
   wire          scan_in13;              //Scan13 chain13 wire  port
   wire          scan_en13;              //Scan13 chain13 enable port
   
   reg    [31:0] prdata13;               //Read Data from the APB13 Interface13
   reg    [3:1]  interrupt13;            //Interrupt13 from PCI13 
   reg           scan_out13;             //Scan13 chain13 reg    port

`endif
//##############################################################################
// black13 boxed13 defines13 
//##############################################################################

endmodule
