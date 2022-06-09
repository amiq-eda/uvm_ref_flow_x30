//File9 name   : ttc_veneer9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------
module ttc_veneer9 (
           
           //inputs9
           n_p_reset9,
           pclk9,
           psel9,
           penable9,
           pwrite9,
           pwdata9,
           paddr9,
           scan_in9,
           scan_en9,

           //outputs9
           prdata9,
           interrupt9,
           scan_out9           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS9
//-----------------------------------------------------------------------------

   input         n_p_reset9;            //System9 Reset9
   input         pclk9;                 //System9 clock9
   input         psel9;                 //Select9 line
   input         penable9;              //Enable9
   input         pwrite9;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata9;               //Write data
   input [7:0]   paddr9;                //Address Bus9 register
   input         scan_in9;              //Scan9 chain9 input port
   input         scan_en9;              //Scan9 chain9 enable port
   
   output [31:0] prdata9;               //Read Data from the APB9 Interface9
   output [3:1]  interrupt9;            //Interrupt9 from PCI9 
   output        scan_out9;             //Scan9 chain9 output port

//##############################################################################
// if the TTC9 is NOT9 black9 boxed9 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC9 

ttc_lite9 i_ttc9(

   //inputs9
   .n_p_reset9(n_p_reset9),
   .pclk9(pclk9),
   .psel9(psel9),
   .penable9(penable9),
   .pwrite9(pwrite9),
   .pwdata9(pwdata9),
   .paddr9(paddr9),
   .scan_in9(),
   .scan_en9(scan_en9),

   //outputs9
   .prdata9(prdata9),
   .interrupt9(interrupt9),
   .scan_out9()
);

`else 
//##############################################################################
// if the TTC9 is black9 boxed9 
//##############################################################################

   wire          n_p_reset9;            //System9 Reset9
   wire          pclk9;                 //System9 clock9
   wire          psel9;                 //Select9 line
   wire          penable9;              //Enable9
   wire          pwrite9;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata9;               //Write data
   wire  [7:0]   paddr9;                //Address Bus9 register
   wire          scan_in9;              //Scan9 chain9 wire  port
   wire          scan_en9;              //Scan9 chain9 enable port
   
   reg    [31:0] prdata9;               //Read Data from the APB9 Interface9
   reg    [3:1]  interrupt9;            //Interrupt9 from PCI9 
   reg           scan_out9;             //Scan9 chain9 reg    port

`endif
//##############################################################################
// black9 boxed9 defines9 
//##############################################################################

endmodule
