//File6 name   : smc_apb_lite_if6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------


`include "smc_defs_lite6.v" 
// apb6 interface
module smc_apb_lite_if6 (
                   //Inputs6
                   
                   n_preset6, 
                   pclk6, 
                   psel6, 
                   penable6, 
                   pwrite6, 
                   paddr6, 
                   pwdata6,
 
                   
                   //Outputs6
                   
                   
                   prdata6
                   
                   );
   
    //   // APB6 Inputs6  
   input     n_preset6;           // APBreset6 
   input     pclk6;               // APB6 clock6
   input     psel6;               // APB6 select6
   input     penable6;            // APB6 enable 
   input     pwrite6;             // APB6 write strobe6 
   input [4:0] paddr6;              // APB6 address bus
   input [31:0] pwdata6;             // APB6 write data 
   
   // Outputs6 to SMC6
   
   // APB6 Output6
   output [31:0] prdata6;        //APB6 output
   
   
    // Outputs6 to SMC6
   
   wire   [31:0] prdata6;

   wire   [31:0] rdata06;  // Selected6 data for register 0
   wire   [31:0] rdata16;  // Selected6 data for register 1
   wire   [31:0] rdata26;  // Selected6 data for register 2
   wire   [31:0] rdata36;  // Selected6 data for register 3
   wire   [31:0] rdata46;  // Selected6 data for register 4
   wire   [31:0] rdata56;  // Selected6 data for register 5
   wire   [31:0] rdata66;  // Selected6 data for register 6
   wire   [31:0] rdata76;  // Selected6 data for register 7

   reg    selreg6;   // Select6 for register (bit significant6)

   
   
   // register addresses6
   
//`define address_config06 5'h00


smc_cfreg_lite6 i_cfreg06 (
  .selreg6           ( selreg6 ),

  .rdata6            ( rdata06 )
);


assign prdata6 = ( rdata06 );

// Generate6 register selects6
always @ (
  psel6 or
  paddr6 or
  penable6
)
begin : p_addr_decode6

  if ( psel6 & penable6 )
    if (paddr6 == 5'h00)
       selreg6 = 1'b1;
    else
       selreg6 = 1'b0;
  else 
       selreg6 = 1'b0;

end // p_addr_decode6
  
endmodule // smc_apb_interface6


