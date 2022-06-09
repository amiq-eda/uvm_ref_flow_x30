//File2 name   : ttc_veneer2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------
module ttc_veneer2 (
           
           //inputs2
           n_p_reset2,
           pclk2,
           psel2,
           penable2,
           pwrite2,
           pwdata2,
           paddr2,
           scan_in2,
           scan_en2,

           //outputs2
           prdata2,
           interrupt2,
           scan_out2           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS2
//-----------------------------------------------------------------------------

   input         n_p_reset2;            //System2 Reset2
   input         pclk2;                 //System2 clock2
   input         psel2;                 //Select2 line
   input         penable2;              //Enable2
   input         pwrite2;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata2;               //Write data
   input [7:0]   paddr2;                //Address Bus2 register
   input         scan_in2;              //Scan2 chain2 input port
   input         scan_en2;              //Scan2 chain2 enable port
   
   output [31:0] prdata2;               //Read Data from the APB2 Interface2
   output [3:1]  interrupt2;            //Interrupt2 from PCI2 
   output        scan_out2;             //Scan2 chain2 output port

//##############################################################################
// if the TTC2 is NOT2 black2 boxed2 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC2 

ttc_lite2 i_ttc2(

   //inputs2
   .n_p_reset2(n_p_reset2),
   .pclk2(pclk2),
   .psel2(psel2),
   .penable2(penable2),
   .pwrite2(pwrite2),
   .pwdata2(pwdata2),
   .paddr2(paddr2),
   .scan_in2(),
   .scan_en2(scan_en2),

   //outputs2
   .prdata2(prdata2),
   .interrupt2(interrupt2),
   .scan_out2()
);

`else 
//##############################################################################
// if the TTC2 is black2 boxed2 
//##############################################################################

   wire          n_p_reset2;            //System2 Reset2
   wire          pclk2;                 //System2 clock2
   wire          psel2;                 //Select2 line
   wire          penable2;              //Enable2
   wire          pwrite2;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata2;               //Write data
   wire  [7:0]   paddr2;                //Address Bus2 register
   wire          scan_in2;              //Scan2 chain2 wire  port
   wire          scan_en2;              //Scan2 chain2 enable port
   
   reg    [31:0] prdata2;               //Read Data from the APB2 Interface2
   reg    [3:1]  interrupt2;            //Interrupt2 from PCI2 
   reg           scan_out2;             //Scan2 chain2 reg    port

`endif
//##############################################################################
// black2 boxed2 defines2 
//##############################################################################

endmodule
