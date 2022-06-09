//File8 name   : ttc_veneer8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------
module ttc_veneer8 (
           
           //inputs8
           n_p_reset8,
           pclk8,
           psel8,
           penable8,
           pwrite8,
           pwdata8,
           paddr8,
           scan_in8,
           scan_en8,

           //outputs8
           prdata8,
           interrupt8,
           scan_out8           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS8
//-----------------------------------------------------------------------------

   input         n_p_reset8;            //System8 Reset8
   input         pclk8;                 //System8 clock8
   input         psel8;                 //Select8 line
   input         penable8;              //Enable8
   input         pwrite8;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata8;               //Write data
   input [7:0]   paddr8;                //Address Bus8 register
   input         scan_in8;              //Scan8 chain8 input port
   input         scan_en8;              //Scan8 chain8 enable port
   
   output [31:0] prdata8;               //Read Data from the APB8 Interface8
   output [3:1]  interrupt8;            //Interrupt8 from PCI8 
   output        scan_out8;             //Scan8 chain8 output port

//##############################################################################
// if the TTC8 is NOT8 black8 boxed8 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC8 

ttc_lite8 i_ttc8(

   //inputs8
   .n_p_reset8(n_p_reset8),
   .pclk8(pclk8),
   .psel8(psel8),
   .penable8(penable8),
   .pwrite8(pwrite8),
   .pwdata8(pwdata8),
   .paddr8(paddr8),
   .scan_in8(),
   .scan_en8(scan_en8),

   //outputs8
   .prdata8(prdata8),
   .interrupt8(interrupt8),
   .scan_out8()
);

`else 
//##############################################################################
// if the TTC8 is black8 boxed8 
//##############################################################################

   wire          n_p_reset8;            //System8 Reset8
   wire          pclk8;                 //System8 clock8
   wire          psel8;                 //Select8 line
   wire          penable8;              //Enable8
   wire          pwrite8;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata8;               //Write data
   wire  [7:0]   paddr8;                //Address Bus8 register
   wire          scan_in8;              //Scan8 chain8 wire  port
   wire          scan_en8;              //Scan8 chain8 enable port
   
   reg    [31:0] prdata8;               //Read Data from the APB8 Interface8
   reg    [3:1]  interrupt8;            //Interrupt8 from PCI8 
   reg           scan_out8;             //Scan8 chain8 reg    port

`endif
//##############################################################################
// black8 boxed8 defines8 
//##############################################################################

endmodule
