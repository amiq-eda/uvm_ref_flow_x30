//File26 name   : ttc_veneer26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------
module ttc_veneer26 (
           
           //inputs26
           n_p_reset26,
           pclk26,
           psel26,
           penable26,
           pwrite26,
           pwdata26,
           paddr26,
           scan_in26,
           scan_en26,

           //outputs26
           prdata26,
           interrupt26,
           scan_out26           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS26
//-----------------------------------------------------------------------------

   input         n_p_reset26;            //System26 Reset26
   input         pclk26;                 //System26 clock26
   input         psel26;                 //Select26 line
   input         penable26;              //Enable26
   input         pwrite26;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata26;               //Write data
   input [7:0]   paddr26;                //Address Bus26 register
   input         scan_in26;              //Scan26 chain26 input port
   input         scan_en26;              //Scan26 chain26 enable port
   
   output [31:0] prdata26;               //Read Data from the APB26 Interface26
   output [3:1]  interrupt26;            //Interrupt26 from PCI26 
   output        scan_out26;             //Scan26 chain26 output port

//##############################################################################
// if the TTC26 is NOT26 black26 boxed26 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC26 

ttc_lite26 i_ttc26(

   //inputs26
   .n_p_reset26(n_p_reset26),
   .pclk26(pclk26),
   .psel26(psel26),
   .penable26(penable26),
   .pwrite26(pwrite26),
   .pwdata26(pwdata26),
   .paddr26(paddr26),
   .scan_in26(),
   .scan_en26(scan_en26),

   //outputs26
   .prdata26(prdata26),
   .interrupt26(interrupt26),
   .scan_out26()
);

`else 
//##############################################################################
// if the TTC26 is black26 boxed26 
//##############################################################################

   wire          n_p_reset26;            //System26 Reset26
   wire          pclk26;                 //System26 clock26
   wire          psel26;                 //Select26 line
   wire          penable26;              //Enable26
   wire          pwrite26;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata26;               //Write data
   wire  [7:0]   paddr26;                //Address Bus26 register
   wire          scan_in26;              //Scan26 chain26 wire  port
   wire          scan_en26;              //Scan26 chain26 enable port
   
   reg    [31:0] prdata26;               //Read Data from the APB26 Interface26
   reg    [3:1]  interrupt26;            //Interrupt26 from PCI26 
   reg           scan_out26;             //Scan26 chain26 reg    port

`endif
//##############################################################################
// black26 boxed26 defines26 
//##############################################################################

endmodule
