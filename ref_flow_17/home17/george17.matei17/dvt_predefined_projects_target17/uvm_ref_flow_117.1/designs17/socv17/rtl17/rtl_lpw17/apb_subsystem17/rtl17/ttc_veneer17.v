//File17 name   : ttc_veneer17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------
module ttc_veneer17 (
           
           //inputs17
           n_p_reset17,
           pclk17,
           psel17,
           penable17,
           pwrite17,
           pwdata17,
           paddr17,
           scan_in17,
           scan_en17,

           //outputs17
           prdata17,
           interrupt17,
           scan_out17           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS17
//-----------------------------------------------------------------------------

   input         n_p_reset17;            //System17 Reset17
   input         pclk17;                 //System17 clock17
   input         psel17;                 //Select17 line
   input         penable17;              //Enable17
   input         pwrite17;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata17;               //Write data
   input [7:0]   paddr17;                //Address Bus17 register
   input         scan_in17;              //Scan17 chain17 input port
   input         scan_en17;              //Scan17 chain17 enable port
   
   output [31:0] prdata17;               //Read Data from the APB17 Interface17
   output [3:1]  interrupt17;            //Interrupt17 from PCI17 
   output        scan_out17;             //Scan17 chain17 output port

//##############################################################################
// if the TTC17 is NOT17 black17 boxed17 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC17 

ttc_lite17 i_ttc17(

   //inputs17
   .n_p_reset17(n_p_reset17),
   .pclk17(pclk17),
   .psel17(psel17),
   .penable17(penable17),
   .pwrite17(pwrite17),
   .pwdata17(pwdata17),
   .paddr17(paddr17),
   .scan_in17(),
   .scan_en17(scan_en17),

   //outputs17
   .prdata17(prdata17),
   .interrupt17(interrupt17),
   .scan_out17()
);

`else 
//##############################################################################
// if the TTC17 is black17 boxed17 
//##############################################################################

   wire          n_p_reset17;            //System17 Reset17
   wire          pclk17;                 //System17 clock17
   wire          psel17;                 //Select17 line
   wire          penable17;              //Enable17
   wire          pwrite17;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata17;               //Write data
   wire  [7:0]   paddr17;                //Address Bus17 register
   wire          scan_in17;              //Scan17 chain17 wire  port
   wire          scan_en17;              //Scan17 chain17 enable port
   
   reg    [31:0] prdata17;               //Read Data from the APB17 Interface17
   reg    [3:1]  interrupt17;            //Interrupt17 from PCI17 
   reg           scan_out17;             //Scan17 chain17 reg    port

`endif
//##############################################################################
// black17 boxed17 defines17 
//##############################################################################

endmodule
