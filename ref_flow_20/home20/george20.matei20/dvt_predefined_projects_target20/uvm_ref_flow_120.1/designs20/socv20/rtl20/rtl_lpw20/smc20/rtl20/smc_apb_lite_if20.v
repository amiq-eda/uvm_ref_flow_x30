//File20 name   : smc_apb_lite_if20.v
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


`include "smc_defs_lite20.v" 
// apb20 interface
module smc_apb_lite_if20 (
                   //Inputs20
                   
                   n_preset20, 
                   pclk20, 
                   psel20, 
                   penable20, 
                   pwrite20, 
                   paddr20, 
                   pwdata20,
 
                   
                   //Outputs20
                   
                   
                   prdata20
                   
                   );
   
    //   // APB20 Inputs20  
   input     n_preset20;           // APBreset20 
   input     pclk20;               // APB20 clock20
   input     psel20;               // APB20 select20
   input     penable20;            // APB20 enable 
   input     pwrite20;             // APB20 write strobe20 
   input [4:0] paddr20;              // APB20 address bus
   input [31:0] pwdata20;             // APB20 write data 
   
   // Outputs20 to SMC20
   
   // APB20 Output20
   output [31:0] prdata20;        //APB20 output
   
   
    // Outputs20 to SMC20
   
   wire   [31:0] prdata20;

   wire   [31:0] rdata020;  // Selected20 data for register 0
   wire   [31:0] rdata120;  // Selected20 data for register 1
   wire   [31:0] rdata220;  // Selected20 data for register 2
   wire   [31:0] rdata320;  // Selected20 data for register 3
   wire   [31:0] rdata420;  // Selected20 data for register 4
   wire   [31:0] rdata520;  // Selected20 data for register 5
   wire   [31:0] rdata620;  // Selected20 data for register 6
   wire   [31:0] rdata720;  // Selected20 data for register 7

   reg    selreg20;   // Select20 for register (bit significant20)

   
   
   // register addresses20
   
//`define address_config020 5'h00


smc_cfreg_lite20 i_cfreg020 (
  .selreg20           ( selreg20 ),

  .rdata20            ( rdata020 )
);


assign prdata20 = ( rdata020 );

// Generate20 register selects20
always @ (
  psel20 or
  paddr20 or
  penable20
)
begin : p_addr_decode20

  if ( psel20 & penable20 )
    if (paddr20 == 5'h00)
       selreg20 = 1'b1;
    else
       selreg20 = 1'b0;
  else 
       selreg20 = 1'b0;

end // p_addr_decode20
  
endmodule // smc_apb_interface20


