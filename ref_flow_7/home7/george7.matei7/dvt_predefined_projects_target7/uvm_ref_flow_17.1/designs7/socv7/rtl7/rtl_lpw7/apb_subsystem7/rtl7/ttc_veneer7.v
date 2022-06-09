//File7 name   : ttc_veneer7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------
module ttc_veneer7 (
           
           //inputs7
           n_p_reset7,
           pclk7,
           psel7,
           penable7,
           pwrite7,
           pwdata7,
           paddr7,
           scan_in7,
           scan_en7,

           //outputs7
           prdata7,
           interrupt7,
           scan_out7           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS7
//-----------------------------------------------------------------------------

   input         n_p_reset7;            //System7 Reset7
   input         pclk7;                 //System7 clock7
   input         psel7;                 //Select7 line
   input         penable7;              //Enable7
   input         pwrite7;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata7;               //Write data
   input [7:0]   paddr7;                //Address Bus7 register
   input         scan_in7;              //Scan7 chain7 input port
   input         scan_en7;              //Scan7 chain7 enable port
   
   output [31:0] prdata7;               //Read Data from the APB7 Interface7
   output [3:1]  interrupt7;            //Interrupt7 from PCI7 
   output        scan_out7;             //Scan7 chain7 output port

//##############################################################################
// if the TTC7 is NOT7 black7 boxed7 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC7 

ttc_lite7 i_ttc7(

   //inputs7
   .n_p_reset7(n_p_reset7),
   .pclk7(pclk7),
   .psel7(psel7),
   .penable7(penable7),
   .pwrite7(pwrite7),
   .pwdata7(pwdata7),
   .paddr7(paddr7),
   .scan_in7(),
   .scan_en7(scan_en7),

   //outputs7
   .prdata7(prdata7),
   .interrupt7(interrupt7),
   .scan_out7()
);

`else 
//##############################################################################
// if the TTC7 is black7 boxed7 
//##############################################################################

   wire          n_p_reset7;            //System7 Reset7
   wire          pclk7;                 //System7 clock7
   wire          psel7;                 //Select7 line
   wire          penable7;              //Enable7
   wire          pwrite7;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata7;               //Write data
   wire  [7:0]   paddr7;                //Address Bus7 register
   wire          scan_in7;              //Scan7 chain7 wire  port
   wire          scan_en7;              //Scan7 chain7 enable port
   
   reg    [31:0] prdata7;               //Read Data from the APB7 Interface7
   reg    [3:1]  interrupt7;            //Interrupt7 from PCI7 
   reg           scan_out7;             //Scan7 chain7 reg    port

`endif
//##############################################################################
// black7 boxed7 defines7 
//##############################################################################

endmodule
