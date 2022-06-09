//File29 name   : smc_apb_lite_if29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------


`include "smc_defs_lite29.v" 
// apb29 interface
module smc_apb_lite_if29 (
                   //Inputs29
                   
                   n_preset29, 
                   pclk29, 
                   psel29, 
                   penable29, 
                   pwrite29, 
                   paddr29, 
                   pwdata29,
 
                   
                   //Outputs29
                   
                   
                   prdata29
                   
                   );
   
    //   // APB29 Inputs29  
   input     n_preset29;           // APBreset29 
   input     pclk29;               // APB29 clock29
   input     psel29;               // APB29 select29
   input     penable29;            // APB29 enable 
   input     pwrite29;             // APB29 write strobe29 
   input [4:0] paddr29;              // APB29 address bus
   input [31:0] pwdata29;             // APB29 write data 
   
   // Outputs29 to SMC29
   
   // APB29 Output29
   output [31:0] prdata29;        //APB29 output
   
   
    // Outputs29 to SMC29
   
   wire   [31:0] prdata29;

   wire   [31:0] rdata029;  // Selected29 data for register 0
   wire   [31:0] rdata129;  // Selected29 data for register 1
   wire   [31:0] rdata229;  // Selected29 data for register 2
   wire   [31:0] rdata329;  // Selected29 data for register 3
   wire   [31:0] rdata429;  // Selected29 data for register 4
   wire   [31:0] rdata529;  // Selected29 data for register 5
   wire   [31:0] rdata629;  // Selected29 data for register 6
   wire   [31:0] rdata729;  // Selected29 data for register 7

   reg    selreg29;   // Select29 for register (bit significant29)

   
   
   // register addresses29
   
//`define address_config029 5'h00


smc_cfreg_lite29 i_cfreg029 (
  .selreg29           ( selreg29 ),

  .rdata29            ( rdata029 )
);


assign prdata29 = ( rdata029 );

// Generate29 register selects29
always @ (
  psel29 or
  paddr29 or
  penable29
)
begin : p_addr_decode29

  if ( psel29 & penable29 )
    if (paddr29 == 5'h00)
       selreg29 = 1'b1;
    else
       selreg29 = 1'b0;
  else 
       selreg29 = 1'b0;

end // p_addr_decode29
  
endmodule // smc_apb_interface29


