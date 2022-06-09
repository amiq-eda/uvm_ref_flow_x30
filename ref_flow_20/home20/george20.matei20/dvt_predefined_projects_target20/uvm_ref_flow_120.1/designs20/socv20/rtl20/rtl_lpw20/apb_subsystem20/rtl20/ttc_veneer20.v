//File20 name   : ttc_veneer20.v
//Title20       : 
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------
module ttc_veneer20 (
           
           //inputs20
           n_p_reset20,
           pclk20,
           psel20,
           penable20,
           pwrite20,
           pwdata20,
           paddr20,
           scan_in20,
           scan_en20,

           //outputs20
           prdata20,
           interrupt20,
           scan_out20           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS20
//-----------------------------------------------------------------------------

   input         n_p_reset20;            //System20 Reset20
   input         pclk20;                 //System20 clock20
   input         psel20;                 //Select20 line
   input         penable20;              //Enable20
   input         pwrite20;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata20;               //Write data
   input [7:0]   paddr20;                //Address Bus20 register
   input         scan_in20;              //Scan20 chain20 input port
   input         scan_en20;              //Scan20 chain20 enable port
   
   output [31:0] prdata20;               //Read Data from the APB20 Interface20
   output [3:1]  interrupt20;            //Interrupt20 from PCI20 
   output        scan_out20;             //Scan20 chain20 output port

//##############################################################################
// if the TTC20 is NOT20 black20 boxed20 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC20 

ttc_lite20 i_ttc20(

   //inputs20
   .n_p_reset20(n_p_reset20),
   .pclk20(pclk20),
   .psel20(psel20),
   .penable20(penable20),
   .pwrite20(pwrite20),
   .pwdata20(pwdata20),
   .paddr20(paddr20),
   .scan_in20(),
   .scan_en20(scan_en20),

   //outputs20
   .prdata20(prdata20),
   .interrupt20(interrupt20),
   .scan_out20()
);

`else 
//##############################################################################
// if the TTC20 is black20 boxed20 
//##############################################################################

   wire          n_p_reset20;            //System20 Reset20
   wire          pclk20;                 //System20 clock20
   wire          psel20;                 //Select20 line
   wire          penable20;              //Enable20
   wire          pwrite20;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata20;               //Write data
   wire  [7:0]   paddr20;                //Address Bus20 register
   wire          scan_in20;              //Scan20 chain20 wire  port
   wire          scan_en20;              //Scan20 chain20 enable port
   
   reg    [31:0] prdata20;               //Read Data from the APB20 Interface20
   reg    [3:1]  interrupt20;            //Interrupt20 from PCI20 
   reg           scan_out20;             //Scan20 chain20 reg    port

`endif
//##############################################################################
// black20 boxed20 defines20 
//##############################################################################

endmodule
