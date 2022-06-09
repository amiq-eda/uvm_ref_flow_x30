//File16 name   : smc_apb_lite_if16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------


`include "smc_defs_lite16.v" 
// apb16 interface
module smc_apb_lite_if16 (
                   //Inputs16
                   
                   n_preset16, 
                   pclk16, 
                   psel16, 
                   penable16, 
                   pwrite16, 
                   paddr16, 
                   pwdata16,
 
                   
                   //Outputs16
                   
                   
                   prdata16
                   
                   );
   
    //   // APB16 Inputs16  
   input     n_preset16;           // APBreset16 
   input     pclk16;               // APB16 clock16
   input     psel16;               // APB16 select16
   input     penable16;            // APB16 enable 
   input     pwrite16;             // APB16 write strobe16 
   input [4:0] paddr16;              // APB16 address bus
   input [31:0] pwdata16;             // APB16 write data 
   
   // Outputs16 to SMC16
   
   // APB16 Output16
   output [31:0] prdata16;        //APB16 output
   
   
    // Outputs16 to SMC16
   
   wire   [31:0] prdata16;

   wire   [31:0] rdata016;  // Selected16 data for register 0
   wire   [31:0] rdata116;  // Selected16 data for register 1
   wire   [31:0] rdata216;  // Selected16 data for register 2
   wire   [31:0] rdata316;  // Selected16 data for register 3
   wire   [31:0] rdata416;  // Selected16 data for register 4
   wire   [31:0] rdata516;  // Selected16 data for register 5
   wire   [31:0] rdata616;  // Selected16 data for register 6
   wire   [31:0] rdata716;  // Selected16 data for register 7

   reg    selreg16;   // Select16 for register (bit significant16)

   
   
   // register addresses16
   
//`define address_config016 5'h00


smc_cfreg_lite16 i_cfreg016 (
  .selreg16           ( selreg16 ),

  .rdata16            ( rdata016 )
);


assign prdata16 = ( rdata016 );

// Generate16 register selects16
always @ (
  psel16 or
  paddr16 or
  penable16
)
begin : p_addr_decode16

  if ( psel16 & penable16 )
    if (paddr16 == 5'h00)
       selreg16 = 1'b1;
    else
       selreg16 = 1'b0;
  else 
       selreg16 = 1'b0;

end // p_addr_decode16
  
endmodule // smc_apb_interface16


