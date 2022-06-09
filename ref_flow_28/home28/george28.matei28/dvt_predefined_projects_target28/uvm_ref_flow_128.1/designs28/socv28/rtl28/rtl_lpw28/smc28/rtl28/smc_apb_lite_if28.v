//File28 name   : smc_apb_lite_if28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------


`include "smc_defs_lite28.v" 
// apb28 interface
module smc_apb_lite_if28 (
                   //Inputs28
                   
                   n_preset28, 
                   pclk28, 
                   psel28, 
                   penable28, 
                   pwrite28, 
                   paddr28, 
                   pwdata28,
 
                   
                   //Outputs28
                   
                   
                   prdata28
                   
                   );
   
    //   // APB28 Inputs28  
   input     n_preset28;           // APBreset28 
   input     pclk28;               // APB28 clock28
   input     psel28;               // APB28 select28
   input     penable28;            // APB28 enable 
   input     pwrite28;             // APB28 write strobe28 
   input [4:0] paddr28;              // APB28 address bus
   input [31:0] pwdata28;             // APB28 write data 
   
   // Outputs28 to SMC28
   
   // APB28 Output28
   output [31:0] prdata28;        //APB28 output
   
   
    // Outputs28 to SMC28
   
   wire   [31:0] prdata28;

   wire   [31:0] rdata028;  // Selected28 data for register 0
   wire   [31:0] rdata128;  // Selected28 data for register 1
   wire   [31:0] rdata228;  // Selected28 data for register 2
   wire   [31:0] rdata328;  // Selected28 data for register 3
   wire   [31:0] rdata428;  // Selected28 data for register 4
   wire   [31:0] rdata528;  // Selected28 data for register 5
   wire   [31:0] rdata628;  // Selected28 data for register 6
   wire   [31:0] rdata728;  // Selected28 data for register 7

   reg    selreg28;   // Select28 for register (bit significant28)

   
   
   // register addresses28
   
//`define address_config028 5'h00


smc_cfreg_lite28 i_cfreg028 (
  .selreg28           ( selreg28 ),

  .rdata28            ( rdata028 )
);


assign prdata28 = ( rdata028 );

// Generate28 register selects28
always @ (
  psel28 or
  paddr28 or
  penable28
)
begin : p_addr_decode28

  if ( psel28 & penable28 )
    if (paddr28 == 5'h00)
       selreg28 = 1'b1;
    else
       selreg28 = 1'b0;
  else 
       selreg28 = 1'b0;

end // p_addr_decode28
  
endmodule // smc_apb_interface28


