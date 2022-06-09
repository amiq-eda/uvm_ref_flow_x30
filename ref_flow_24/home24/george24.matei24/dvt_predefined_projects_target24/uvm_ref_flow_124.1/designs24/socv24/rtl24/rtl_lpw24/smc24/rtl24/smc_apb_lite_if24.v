//File24 name   : smc_apb_lite_if24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------


`include "smc_defs_lite24.v" 
// apb24 interface
module smc_apb_lite_if24 (
                   //Inputs24
                   
                   n_preset24, 
                   pclk24, 
                   psel24, 
                   penable24, 
                   pwrite24, 
                   paddr24, 
                   pwdata24,
 
                   
                   //Outputs24
                   
                   
                   prdata24
                   
                   );
   
    //   // APB24 Inputs24  
   input     n_preset24;           // APBreset24 
   input     pclk24;               // APB24 clock24
   input     psel24;               // APB24 select24
   input     penable24;            // APB24 enable 
   input     pwrite24;             // APB24 write strobe24 
   input [4:0] paddr24;              // APB24 address bus
   input [31:0] pwdata24;             // APB24 write data 
   
   // Outputs24 to SMC24
   
   // APB24 Output24
   output [31:0] prdata24;        //APB24 output
   
   
    // Outputs24 to SMC24
   
   wire   [31:0] prdata24;

   wire   [31:0] rdata024;  // Selected24 data for register 0
   wire   [31:0] rdata124;  // Selected24 data for register 1
   wire   [31:0] rdata224;  // Selected24 data for register 2
   wire   [31:0] rdata324;  // Selected24 data for register 3
   wire   [31:0] rdata424;  // Selected24 data for register 4
   wire   [31:0] rdata524;  // Selected24 data for register 5
   wire   [31:0] rdata624;  // Selected24 data for register 6
   wire   [31:0] rdata724;  // Selected24 data for register 7

   reg    selreg24;   // Select24 for register (bit significant24)

   
   
   // register addresses24
   
//`define address_config024 5'h00


smc_cfreg_lite24 i_cfreg024 (
  .selreg24           ( selreg24 ),

  .rdata24            ( rdata024 )
);


assign prdata24 = ( rdata024 );

// Generate24 register selects24
always @ (
  psel24 or
  paddr24 or
  penable24
)
begin : p_addr_decode24

  if ( psel24 & penable24 )
    if (paddr24 == 5'h00)
       selreg24 = 1'b1;
    else
       selreg24 = 1'b0;
  else 
       selreg24 = 1'b0;

end // p_addr_decode24
  
endmodule // smc_apb_interface24


