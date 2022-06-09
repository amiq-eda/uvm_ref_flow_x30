//File6 name   : ttc_veneer6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------
module ttc_veneer6 (
           
           //inputs6
           n_p_reset6,
           pclk6,
           psel6,
           penable6,
           pwrite6,
           pwdata6,
           paddr6,
           scan_in6,
           scan_en6,

           //outputs6
           prdata6,
           interrupt6,
           scan_out6           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS6
//-----------------------------------------------------------------------------

   input         n_p_reset6;            //System6 Reset6
   input         pclk6;                 //System6 clock6
   input         psel6;                 //Select6 line
   input         penable6;              //Enable6
   input         pwrite6;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata6;               //Write data
   input [7:0]   paddr6;                //Address Bus6 register
   input         scan_in6;              //Scan6 chain6 input port
   input         scan_en6;              //Scan6 chain6 enable port
   
   output [31:0] prdata6;               //Read Data from the APB6 Interface6
   output [3:1]  interrupt6;            //Interrupt6 from PCI6 
   output        scan_out6;             //Scan6 chain6 output port

//##############################################################################
// if the TTC6 is NOT6 black6 boxed6 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC6 

ttc_lite6 i_ttc6(

   //inputs6
   .n_p_reset6(n_p_reset6),
   .pclk6(pclk6),
   .psel6(psel6),
   .penable6(penable6),
   .pwrite6(pwrite6),
   .pwdata6(pwdata6),
   .paddr6(paddr6),
   .scan_in6(),
   .scan_en6(scan_en6),

   //outputs6
   .prdata6(prdata6),
   .interrupt6(interrupt6),
   .scan_out6()
);

`else 
//##############################################################################
// if the TTC6 is black6 boxed6 
//##############################################################################

   wire          n_p_reset6;            //System6 Reset6
   wire          pclk6;                 //System6 clock6
   wire          psel6;                 //Select6 line
   wire          penable6;              //Enable6
   wire          pwrite6;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata6;               //Write data
   wire  [7:0]   paddr6;                //Address Bus6 register
   wire          scan_in6;              //Scan6 chain6 wire  port
   wire          scan_en6;              //Scan6 chain6 enable port
   
   reg    [31:0] prdata6;               //Read Data from the APB6 Interface6
   reg    [3:1]  interrupt6;            //Interrupt6 from PCI6 
   reg           scan_out6;             //Scan6 chain6 reg    port

`endif
//##############################################################################
// black6 boxed6 defines6 
//##############################################################################

endmodule
