//File15 name   : smc_apb_lite_if15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------


`include "smc_defs_lite15.v" 
// apb15 interface
module smc_apb_lite_if15 (
                   //Inputs15
                   
                   n_preset15, 
                   pclk15, 
                   psel15, 
                   penable15, 
                   pwrite15, 
                   paddr15, 
                   pwdata15,
 
                   
                   //Outputs15
                   
                   
                   prdata15
                   
                   );
   
    //   // APB15 Inputs15  
   input     n_preset15;           // APBreset15 
   input     pclk15;               // APB15 clock15
   input     psel15;               // APB15 select15
   input     penable15;            // APB15 enable 
   input     pwrite15;             // APB15 write strobe15 
   input [4:0] paddr15;              // APB15 address bus
   input [31:0] pwdata15;             // APB15 write data 
   
   // Outputs15 to SMC15
   
   // APB15 Output15
   output [31:0] prdata15;        //APB15 output
   
   
    // Outputs15 to SMC15
   
   wire   [31:0] prdata15;

   wire   [31:0] rdata015;  // Selected15 data for register 0
   wire   [31:0] rdata115;  // Selected15 data for register 1
   wire   [31:0] rdata215;  // Selected15 data for register 2
   wire   [31:0] rdata315;  // Selected15 data for register 3
   wire   [31:0] rdata415;  // Selected15 data for register 4
   wire   [31:0] rdata515;  // Selected15 data for register 5
   wire   [31:0] rdata615;  // Selected15 data for register 6
   wire   [31:0] rdata715;  // Selected15 data for register 7

   reg    selreg15;   // Select15 for register (bit significant15)

   
   
   // register addresses15
   
//`define address_config015 5'h00


smc_cfreg_lite15 i_cfreg015 (
  .selreg15           ( selreg15 ),

  .rdata15            ( rdata015 )
);


assign prdata15 = ( rdata015 );

// Generate15 register selects15
always @ (
  psel15 or
  paddr15 or
  penable15
)
begin : p_addr_decode15

  if ( psel15 & penable15 )
    if (paddr15 == 5'h00)
       selreg15 = 1'b1;
    else
       selreg15 = 1'b0;
  else 
       selreg15 = 1'b0;

end // p_addr_decode15
  
endmodule // smc_apb_interface15


