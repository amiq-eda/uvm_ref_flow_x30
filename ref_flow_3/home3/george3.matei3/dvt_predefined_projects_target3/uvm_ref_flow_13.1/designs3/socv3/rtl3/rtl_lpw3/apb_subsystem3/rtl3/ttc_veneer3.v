//File3 name   : ttc_veneer3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------
module ttc_veneer3 (
           
           //inputs3
           n_p_reset3,
           pclk3,
           psel3,
           penable3,
           pwrite3,
           pwdata3,
           paddr3,
           scan_in3,
           scan_en3,

           //outputs3
           prdata3,
           interrupt3,
           scan_out3           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS3
//-----------------------------------------------------------------------------

   input         n_p_reset3;            //System3 Reset3
   input         pclk3;                 //System3 clock3
   input         psel3;                 //Select3 line
   input         penable3;              //Enable3
   input         pwrite3;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata3;               //Write data
   input [7:0]   paddr3;                //Address Bus3 register
   input         scan_in3;              //Scan3 chain3 input port
   input         scan_en3;              //Scan3 chain3 enable port
   
   output [31:0] prdata3;               //Read Data from the APB3 Interface3
   output [3:1]  interrupt3;            //Interrupt3 from PCI3 
   output        scan_out3;             //Scan3 chain3 output port

//##############################################################################
// if the TTC3 is NOT3 black3 boxed3 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC3 

ttc_lite3 i_ttc3(

   //inputs3
   .n_p_reset3(n_p_reset3),
   .pclk3(pclk3),
   .psel3(psel3),
   .penable3(penable3),
   .pwrite3(pwrite3),
   .pwdata3(pwdata3),
   .paddr3(paddr3),
   .scan_in3(),
   .scan_en3(scan_en3),

   //outputs3
   .prdata3(prdata3),
   .interrupt3(interrupt3),
   .scan_out3()
);

`else 
//##############################################################################
// if the TTC3 is black3 boxed3 
//##############################################################################

   wire          n_p_reset3;            //System3 Reset3
   wire          pclk3;                 //System3 clock3
   wire          psel3;                 //Select3 line
   wire          penable3;              //Enable3
   wire          pwrite3;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata3;               //Write data
   wire  [7:0]   paddr3;                //Address Bus3 register
   wire          scan_in3;              //Scan3 chain3 wire  port
   wire          scan_en3;              //Scan3 chain3 enable port
   
   reg    [31:0] prdata3;               //Read Data from the APB3 Interface3
   reg    [3:1]  interrupt3;            //Interrupt3 from PCI3 
   reg           scan_out3;             //Scan3 chain3 reg    port

`endif
//##############################################################################
// black3 boxed3 defines3 
//##############################################################################

endmodule
