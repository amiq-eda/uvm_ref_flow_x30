//File21 name   : ttc_veneer21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------
module ttc_veneer21 (
           
           //inputs21
           n_p_reset21,
           pclk21,
           psel21,
           penable21,
           pwrite21,
           pwdata21,
           paddr21,
           scan_in21,
           scan_en21,

           //outputs21
           prdata21,
           interrupt21,
           scan_out21           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS21
//-----------------------------------------------------------------------------

   input         n_p_reset21;            //System21 Reset21
   input         pclk21;                 //System21 clock21
   input         psel21;                 //Select21 line
   input         penable21;              //Enable21
   input         pwrite21;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata21;               //Write data
   input [7:0]   paddr21;                //Address Bus21 register
   input         scan_in21;              //Scan21 chain21 input port
   input         scan_en21;              //Scan21 chain21 enable port
   
   output [31:0] prdata21;               //Read Data from the APB21 Interface21
   output [3:1]  interrupt21;            //Interrupt21 from PCI21 
   output        scan_out21;             //Scan21 chain21 output port

//##############################################################################
// if the TTC21 is NOT21 black21 boxed21 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC21 

ttc_lite21 i_ttc21(

   //inputs21
   .n_p_reset21(n_p_reset21),
   .pclk21(pclk21),
   .psel21(psel21),
   .penable21(penable21),
   .pwrite21(pwrite21),
   .pwdata21(pwdata21),
   .paddr21(paddr21),
   .scan_in21(),
   .scan_en21(scan_en21),

   //outputs21
   .prdata21(prdata21),
   .interrupt21(interrupt21),
   .scan_out21()
);

`else 
//##############################################################################
// if the TTC21 is black21 boxed21 
//##############################################################################

   wire          n_p_reset21;            //System21 Reset21
   wire          pclk21;                 //System21 clock21
   wire          psel21;                 //Select21 line
   wire          penable21;              //Enable21
   wire          pwrite21;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata21;               //Write data
   wire  [7:0]   paddr21;                //Address Bus21 register
   wire          scan_in21;              //Scan21 chain21 wire  port
   wire          scan_en21;              //Scan21 chain21 enable port
   
   reg    [31:0] prdata21;               //Read Data from the APB21 Interface21
   reg    [3:1]  interrupt21;            //Interrupt21 from PCI21 
   reg           scan_out21;             //Scan21 chain21 reg    port

`endif
//##############################################################################
// black21 boxed21 defines21 
//##############################################################################

endmodule
