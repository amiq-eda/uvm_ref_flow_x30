//File22 name   : ttc_veneer22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------
module ttc_veneer22 (
           
           //inputs22
           n_p_reset22,
           pclk22,
           psel22,
           penable22,
           pwrite22,
           pwdata22,
           paddr22,
           scan_in22,
           scan_en22,

           //outputs22
           prdata22,
           interrupt22,
           scan_out22           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS22
//-----------------------------------------------------------------------------

   input         n_p_reset22;            //System22 Reset22
   input         pclk22;                 //System22 clock22
   input         psel22;                 //Select22 line
   input         penable22;              //Enable22
   input         pwrite22;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata22;               //Write data
   input [7:0]   paddr22;                //Address Bus22 register
   input         scan_in22;              //Scan22 chain22 input port
   input         scan_en22;              //Scan22 chain22 enable port
   
   output [31:0] prdata22;               //Read Data from the APB22 Interface22
   output [3:1]  interrupt22;            //Interrupt22 from PCI22 
   output        scan_out22;             //Scan22 chain22 output port

//##############################################################################
// if the TTC22 is NOT22 black22 boxed22 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC22 

ttc_lite22 i_ttc22(

   //inputs22
   .n_p_reset22(n_p_reset22),
   .pclk22(pclk22),
   .psel22(psel22),
   .penable22(penable22),
   .pwrite22(pwrite22),
   .pwdata22(pwdata22),
   .paddr22(paddr22),
   .scan_in22(),
   .scan_en22(scan_en22),

   //outputs22
   .prdata22(prdata22),
   .interrupt22(interrupt22),
   .scan_out22()
);

`else 
//##############################################################################
// if the TTC22 is black22 boxed22 
//##############################################################################

   wire          n_p_reset22;            //System22 Reset22
   wire          pclk22;                 //System22 clock22
   wire          psel22;                 //Select22 line
   wire          penable22;              //Enable22
   wire          pwrite22;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata22;               //Write data
   wire  [7:0]   paddr22;                //Address Bus22 register
   wire          scan_in22;              //Scan22 chain22 wire  port
   wire          scan_en22;              //Scan22 chain22 enable port
   
   reg    [31:0] prdata22;               //Read Data from the APB22 Interface22
   reg    [3:1]  interrupt22;            //Interrupt22 from PCI22 
   reg           scan_out22;             //Scan22 chain22 reg    port

`endif
//##############################################################################
// black22 boxed22 defines22 
//##############################################################################

endmodule
