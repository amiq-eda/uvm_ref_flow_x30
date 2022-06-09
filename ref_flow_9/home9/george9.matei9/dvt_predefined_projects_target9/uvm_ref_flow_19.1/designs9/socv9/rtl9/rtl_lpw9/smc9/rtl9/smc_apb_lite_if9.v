//File9 name   : smc_apb_lite_if9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------


`include "smc_defs_lite9.v" 
// apb9 interface
module smc_apb_lite_if9 (
                   //Inputs9
                   
                   n_preset9, 
                   pclk9, 
                   psel9, 
                   penable9, 
                   pwrite9, 
                   paddr9, 
                   pwdata9,
 
                   
                   //Outputs9
                   
                   
                   prdata9
                   
                   );
   
    //   // APB9 Inputs9  
   input     n_preset9;           // APBreset9 
   input     pclk9;               // APB9 clock9
   input     psel9;               // APB9 select9
   input     penable9;            // APB9 enable 
   input     pwrite9;             // APB9 write strobe9 
   input [4:0] paddr9;              // APB9 address bus
   input [31:0] pwdata9;             // APB9 write data 
   
   // Outputs9 to SMC9
   
   // APB9 Output9
   output [31:0] prdata9;        //APB9 output
   
   
    // Outputs9 to SMC9
   
   wire   [31:0] prdata9;

   wire   [31:0] rdata09;  // Selected9 data for register 0
   wire   [31:0] rdata19;  // Selected9 data for register 1
   wire   [31:0] rdata29;  // Selected9 data for register 2
   wire   [31:0] rdata39;  // Selected9 data for register 3
   wire   [31:0] rdata49;  // Selected9 data for register 4
   wire   [31:0] rdata59;  // Selected9 data for register 5
   wire   [31:0] rdata69;  // Selected9 data for register 6
   wire   [31:0] rdata79;  // Selected9 data for register 7

   reg    selreg9;   // Select9 for register (bit significant9)

   
   
   // register addresses9
   
//`define address_config09 5'h00


smc_cfreg_lite9 i_cfreg09 (
  .selreg9           ( selreg9 ),

  .rdata9            ( rdata09 )
);


assign prdata9 = ( rdata09 );

// Generate9 register selects9
always @ (
  psel9 or
  paddr9 or
  penable9
)
begin : p_addr_decode9

  if ( psel9 & penable9 )
    if (paddr9 == 5'h00)
       selreg9 = 1'b1;
    else
       selreg9 = 1'b0;
  else 
       selreg9 = 1'b0;

end // p_addr_decode9
  
endmodule // smc_apb_interface9


