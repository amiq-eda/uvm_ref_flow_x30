//File25 name   : ttc_veneer25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------
module ttc_veneer25 (
           
           //inputs25
           n_p_reset25,
           pclk25,
           psel25,
           penable25,
           pwrite25,
           pwdata25,
           paddr25,
           scan_in25,
           scan_en25,

           //outputs25
           prdata25,
           interrupt25,
           scan_out25           

           );


//-----------------------------------------------------------------------------
// PORT DECLARATIONS25
//-----------------------------------------------------------------------------

   input         n_p_reset25;            //System25 Reset25
   input         pclk25;                 //System25 clock25
   input         psel25;                 //Select25 line
   input         penable25;              //Enable25
   input         pwrite25;               //Write line, 1 for write, 0 for read
   input [31:0]  pwdata25;               //Write data
   input [7:0]   paddr25;                //Address Bus25 register
   input         scan_in25;              //Scan25 chain25 input port
   input         scan_en25;              //Scan25 chain25 enable port
   
   output [31:0] prdata25;               //Read Data from the APB25 Interface25
   output [3:1]  interrupt25;            //Interrupt25 from PCI25 
   output        scan_out25;             //Scan25 chain25 output port

//##############################################################################
// if the TTC25 is NOT25 black25 boxed25 
//##############################################################################
`ifndef FV_KIT_BLACK_BOX_TTC25 

ttc_lite25 i_ttc25(

   //inputs25
   .n_p_reset25(n_p_reset25),
   .pclk25(pclk25),
   .psel25(psel25),
   .penable25(penable25),
   .pwrite25(pwrite25),
   .pwdata25(pwdata25),
   .paddr25(paddr25),
   .scan_in25(),
   .scan_en25(scan_en25),

   //outputs25
   .prdata25(prdata25),
   .interrupt25(interrupt25),
   .scan_out25()
);

`else 
//##############################################################################
// if the TTC25 is black25 boxed25 
//##############################################################################

   wire          n_p_reset25;            //System25 Reset25
   wire          pclk25;                 //System25 clock25
   wire          psel25;                 //Select25 line
   wire          penable25;              //Enable25
   wire          pwrite25;               //Write line, 1 for write, 0 for read
   wire  [31:0]  pwdata25;               //Write data
   wire  [7:0]   paddr25;                //Address Bus25 register
   wire          scan_in25;              //Scan25 chain25 wire  port
   wire          scan_en25;              //Scan25 chain25 enable port
   
   reg    [31:0] prdata25;               //Read Data from the APB25 Interface25
   reg    [3:1]  interrupt25;            //Interrupt25 from PCI25 
   reg           scan_out25;             //Scan25 chain25 reg    port

`endif
//##############################################################################
// black25 boxed25 defines25 
//##############################################################################

endmodule
