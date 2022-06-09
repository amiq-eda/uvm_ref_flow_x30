//File26 name   : smc_apb_lite_if26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------


`include "smc_defs_lite26.v" 
// apb26 interface
module smc_apb_lite_if26 (
                   //Inputs26
                   
                   n_preset26, 
                   pclk26, 
                   psel26, 
                   penable26, 
                   pwrite26, 
                   paddr26, 
                   pwdata26,
 
                   
                   //Outputs26
                   
                   
                   prdata26
                   
                   );
   
    //   // APB26 Inputs26  
   input     n_preset26;           // APBreset26 
   input     pclk26;               // APB26 clock26
   input     psel26;               // APB26 select26
   input     penable26;            // APB26 enable 
   input     pwrite26;             // APB26 write strobe26 
   input [4:0] paddr26;              // APB26 address bus
   input [31:0] pwdata26;             // APB26 write data 
   
   // Outputs26 to SMC26
   
   // APB26 Output26
   output [31:0] prdata26;        //APB26 output
   
   
    // Outputs26 to SMC26
   
   wire   [31:0] prdata26;

   wire   [31:0] rdata026;  // Selected26 data for register 0
   wire   [31:0] rdata126;  // Selected26 data for register 1
   wire   [31:0] rdata226;  // Selected26 data for register 2
   wire   [31:0] rdata326;  // Selected26 data for register 3
   wire   [31:0] rdata426;  // Selected26 data for register 4
   wire   [31:0] rdata526;  // Selected26 data for register 5
   wire   [31:0] rdata626;  // Selected26 data for register 6
   wire   [31:0] rdata726;  // Selected26 data for register 7

   reg    selreg26;   // Select26 for register (bit significant26)

   
   
   // register addresses26
   
//`define address_config026 5'h00


smc_cfreg_lite26 i_cfreg026 (
  .selreg26           ( selreg26 ),

  .rdata26            ( rdata026 )
);


assign prdata26 = ( rdata026 );

// Generate26 register selects26
always @ (
  psel26 or
  paddr26 or
  penable26
)
begin : p_addr_decode26

  if ( psel26 & penable26 )
    if (paddr26 == 5'h00)
       selreg26 = 1'b1;
    else
       selreg26 = 1'b0;
  else 
       selreg26 = 1'b0;

end // p_addr_decode26
  
endmodule // smc_apb_interface26


