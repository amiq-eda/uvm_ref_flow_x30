//File18 name   : smc_apb_lite_if18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------


`include "smc_defs_lite18.v" 
// apb18 interface
module smc_apb_lite_if18 (
                   //Inputs18
                   
                   n_preset18, 
                   pclk18, 
                   psel18, 
                   penable18, 
                   pwrite18, 
                   paddr18, 
                   pwdata18,
 
                   
                   //Outputs18
                   
                   
                   prdata18
                   
                   );
   
    //   // APB18 Inputs18  
   input     n_preset18;           // APBreset18 
   input     pclk18;               // APB18 clock18
   input     psel18;               // APB18 select18
   input     penable18;            // APB18 enable 
   input     pwrite18;             // APB18 write strobe18 
   input [4:0] paddr18;              // APB18 address bus
   input [31:0] pwdata18;             // APB18 write data 
   
   // Outputs18 to SMC18
   
   // APB18 Output18
   output [31:0] prdata18;        //APB18 output
   
   
    // Outputs18 to SMC18
   
   wire   [31:0] prdata18;

   wire   [31:0] rdata018;  // Selected18 data for register 0
   wire   [31:0] rdata118;  // Selected18 data for register 1
   wire   [31:0] rdata218;  // Selected18 data for register 2
   wire   [31:0] rdata318;  // Selected18 data for register 3
   wire   [31:0] rdata418;  // Selected18 data for register 4
   wire   [31:0] rdata518;  // Selected18 data for register 5
   wire   [31:0] rdata618;  // Selected18 data for register 6
   wire   [31:0] rdata718;  // Selected18 data for register 7

   reg    selreg18;   // Select18 for register (bit significant18)

   
   
   // register addresses18
   
//`define address_config018 5'h00


smc_cfreg_lite18 i_cfreg018 (
  .selreg18           ( selreg18 ),

  .rdata18            ( rdata018 )
);


assign prdata18 = ( rdata018 );

// Generate18 register selects18
always @ (
  psel18 or
  paddr18 or
  penable18
)
begin : p_addr_decode18

  if ( psel18 & penable18 )
    if (paddr18 == 5'h00)
       selreg18 = 1'b1;
    else
       selreg18 = 1'b0;
  else 
       selreg18 = 1'b0;

end // p_addr_decode18
  
endmodule // smc_apb_interface18


