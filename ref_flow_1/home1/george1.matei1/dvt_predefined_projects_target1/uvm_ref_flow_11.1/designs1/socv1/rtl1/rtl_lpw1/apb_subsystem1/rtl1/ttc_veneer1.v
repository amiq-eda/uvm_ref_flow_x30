//File1 name   : ttc_veneer1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------
module ttc_veneer1 (
           
           //inputs1
           n_p_reset1,
           pclk1,
           psel1,
           penable1,
           pwrite1,
           pwdata1,
           paddr1,
           scan_in1,
           scan_en1,

           //outputs1
           prdata1,
           interrupt1,
           scan_out1           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS1
//-----------------------------------------------------------------------------

   input         n_p_reset1;            //System1 Reset1
   input         pclk1;                 //System1 clock1
   input         psel1;                 //Select1 line
   input         penable1;              //Enable1
   input         pwrite1;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata1;               //Write data
   input [7:0]   paddr1;                //Address Bus1 register
   input         scan_in1;              //Scan1 chain1 input port
   input         scan_en1;              //Scan1 chain1 enable port
   
   output [31:0] prdata1;               //Read Data from the APB1 Interface1
   output [3:1]  interrupt1;            //Interrupt1 from PCI1 
   output        scan_out1;             //Scan1 chain1 output port

//##############################################################################
// if the TTC1 is NOT1 black1 boxed1 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC1 

ttc_lite1 i_ttc1(

   //inputs1
   .n_p_reset1(n_p_reset1),
   .pclk1(pclk1),
   .psel1(psel1),
   .penable1(penable1),
   .pwrite1(pwrite1),
   .pwdata1(pwdata1),
   .paddr1(paddr1),
   .scan_in1(),
   .scan_en1(scan_en1),

   //outputs1
   .prdata1(prdata1),
   .interrupt1(interrupt1),
   .scan_out1()
);

`else 
//##############################################################################
// if the TTC1 is black1 boxed1 
//##############################################################################

   wire          n_p_reset1;            //System1 Reset1
   wire          pclk1;                 //System1 clock1
   wire          psel1;                 //Select1 line
   wire          penable1;              //Enable1
   wire          pwrite1;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata1;               //Write data
   wire  [7:0]   paddr1;                //Address Bus1 register
   wire          scan_in1;              //Scan1 chain1 wire  port
   wire          scan_en1;              //Scan1 chain1 enable port
   
   reg    [31:0] prdata1;               //Read Data from the APB1 Interface1
   reg    [3:1]  interrupt1;            //Interrupt1 from PCI1 
   reg           scan_out1;             //Scan1 chain1 reg    port

`endif
//##############################################################################
// black1 boxed1 defines1 
//##############################################################################

endmodule
