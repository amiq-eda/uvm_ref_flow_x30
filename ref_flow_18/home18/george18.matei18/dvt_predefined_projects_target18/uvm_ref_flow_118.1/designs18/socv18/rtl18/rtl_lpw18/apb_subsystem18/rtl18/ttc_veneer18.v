//File18 name   : ttc_veneer18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------
module ttc_veneer18 (
           
           //inputs18
           n_p_reset18,
           pclk18,
           psel18,
           penable18,
           pwrite18,
           pwdata18,
           paddr18,
           scan_in18,
           scan_en18,

           //outputs18
           prdata18,
           interrupt18,
           scan_out18           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS18
//-----------------------------------------------------------------------------

   input         n_p_reset18;            //System18 Reset18
   input         pclk18;                 //System18 clock18
   input         psel18;                 //Select18 line
   input         penable18;              //Enable18
   input         pwrite18;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata18;               //Write data
   input [7:0]   paddr18;                //Address Bus18 register
   input         scan_in18;              //Scan18 chain18 input port
   input         scan_en18;              //Scan18 chain18 enable port
   
   output [31:0] prdata18;               //Read Data from the APB18 Interface18
   output [3:1]  interrupt18;            //Interrupt18 from PCI18 
   output        scan_out18;             //Scan18 chain18 output port

//##############################################################################
// if the TTC18 is NOT18 black18 boxed18 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC18 

ttc_lite18 i_ttc18(

   //inputs18
   .n_p_reset18(n_p_reset18),
   .pclk18(pclk18),
   .psel18(psel18),
   .penable18(penable18),
   .pwrite18(pwrite18),
   .pwdata18(pwdata18),
   .paddr18(paddr18),
   .scan_in18(),
   .scan_en18(scan_en18),

   //outputs18
   .prdata18(prdata18),
   .interrupt18(interrupt18),
   .scan_out18()
);

`else 
//##############################################################################
// if the TTC18 is black18 boxed18 
//##############################################################################

   wire          n_p_reset18;            //System18 Reset18
   wire          pclk18;                 //System18 clock18
   wire          psel18;                 //Select18 line
   wire          penable18;              //Enable18
   wire          pwrite18;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata18;               //Write data
   wire  [7:0]   paddr18;                //Address Bus18 register
   wire          scan_in18;              //Scan18 chain18 wire  port
   wire          scan_en18;              //Scan18 chain18 enable port
   
   reg    [31:0] prdata18;               //Read Data from the APB18 Interface18
   reg    [3:1]  interrupt18;            //Interrupt18 from PCI18 
   reg           scan_out18;             //Scan18 chain18 reg    port

`endif
//##############################################################################
// black18 boxed18 defines18 
//##############################################################################

endmodule
