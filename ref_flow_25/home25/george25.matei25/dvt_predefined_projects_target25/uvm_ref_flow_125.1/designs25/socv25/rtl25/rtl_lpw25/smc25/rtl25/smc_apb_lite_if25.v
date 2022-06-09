//File25 name   : smc_apb_lite_if25.v
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


`include "smc_defs_lite25.v" 
// apb25 interface
module smc_apb_lite_if25 (
                   //Inputs25
                   
                   n_preset25, 
                   pclk25, 
                   psel25, 
                   penable25, 
                   pwrite25, 
                   paddr25, 
                   pwdata25,
 
                   
                   //Outputs25
                   
                   
                   prdata25
                   
                   );
   
    //   // APB25 Inputs25  
   input     n_preset25;           // APBreset25 
   input     pclk25;               // APB25 clock25
   input     psel25;               // APB25 select25
   input     penable25;            // APB25 enable 
   input     pwrite25;             // APB25 write strobe25 
   input [4:0] paddr25;              // APB25 address bus
   input [31:0] pwdata25;             // APB25 write data 
   
   // Outputs25 to SMC25
   
   // APB25 Output25
   output [31:0] prdata25;        //APB25 output
   
   
    // Outputs25 to SMC25
   
   wire   [31:0] prdata25;

   wire   [31:0] rdata025;  // Selected25 data for register 0
   wire   [31:0] rdata125;  // Selected25 data for register 1
   wire   [31:0] rdata225;  // Selected25 data for register 2
   wire   [31:0] rdata325;  // Selected25 data for register 3
   wire   [31:0] rdata425;  // Selected25 data for register 4
   wire   [31:0] rdata525;  // Selected25 data for register 5
   wire   [31:0] rdata625;  // Selected25 data for register 6
   wire   [31:0] rdata725;  // Selected25 data for register 7

   reg    selreg25;   // Select25 for register (bit significant25)

   
   
   // register addresses25
   
//`define address_config025 5'h00


smc_cfreg_lite25 i_cfreg025 (
  .selreg25           ( selreg25 ),

  .rdata25            ( rdata025 )
);


assign prdata25 = ( rdata025 );

// Generate25 register selects25
always @ (
  psel25 or
  paddr25 or
  penable25
)
begin : p_addr_decode25

  if ( psel25 & penable25 )
    if (paddr25 == 5'h00)
       selreg25 = 1'b1;
    else
       selreg25 = 1'b0;
  else 
       selreg25 = 1'b0;

end // p_addr_decode25
  
endmodule // smc_apb_interface25


