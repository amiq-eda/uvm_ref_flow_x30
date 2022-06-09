//File5 name   : ttc_veneer5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------
module ttc_veneer5 (
           
           //inputs5
           n_p_reset5,
           pclk5,
           psel5,
           penable5,
           pwrite5,
           pwdata5,
           paddr5,
           scan_in5,
           scan_en5,

           //outputs5
           prdata5,
           interrupt5,
           scan_out5           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS5
//-----------------------------------------------------------------------------

   input         n_p_reset5;            //System5 Reset5
   input         pclk5;                 //System5 clock5
   input         psel5;                 //Select5 line
   input         penable5;              //Enable5
   input         pwrite5;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata5;               //Write data
   input [7:0]   paddr5;                //Address Bus5 register
   input         scan_in5;              //Scan5 chain5 input port
   input         scan_en5;              //Scan5 chain5 enable port
   
   output [31:0] prdata5;               //Read Data from the APB5 Interface5
   output [3:1]  interrupt5;            //Interrupt5 from PCI5 
   output        scan_out5;             //Scan5 chain5 output port

//##############################################################################
// if the TTC5 is NOT5 black5 boxed5 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC5 

ttc_lite5 i_ttc5(

   //inputs5
   .n_p_reset5(n_p_reset5),
   .pclk5(pclk5),
   .psel5(psel5),
   .penable5(penable5),
   .pwrite5(pwrite5),
   .pwdata5(pwdata5),
   .paddr5(paddr5),
   .scan_in5(),
   .scan_en5(scan_en5),

   //outputs5
   .prdata5(prdata5),
   .interrupt5(interrupt5),
   .scan_out5()
);

`else 
//##############################################################################
// if the TTC5 is black5 boxed5 
//##############################################################################

   wire          n_p_reset5;            //System5 Reset5
   wire          pclk5;                 //System5 clock5
   wire          psel5;                 //Select5 line
   wire          penable5;              //Enable5
   wire          pwrite5;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata5;               //Write data
   wire  [7:0]   paddr5;                //Address Bus5 register
   wire          scan_in5;              //Scan5 chain5 wire  port
   wire          scan_en5;              //Scan5 chain5 enable port
   
   reg    [31:0] prdata5;               //Read Data from the APB5 Interface5
   reg    [3:1]  interrupt5;            //Interrupt5 from PCI5 
   reg           scan_out5;             //Scan5 chain5 reg    port

`endif
//##############################################################################
// black5 boxed5 defines5 
//##############################################################################

endmodule
