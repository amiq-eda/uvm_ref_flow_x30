//File27 name   : smc_apb_lite_if27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------


`include "smc_defs_lite27.v" 
// apb27 interface
module smc_apb_lite_if27 (
                   //Inputs27
                   
                   n_preset27, 
                   pclk27, 
                   psel27, 
                   penable27, 
                   pwrite27, 
                   paddr27, 
                   pwdata27,
 
                   
                   //Outputs27
                   
                   
                   prdata27
                   
                   );
   
    //   // APB27 Inputs27  
   input     n_preset27;           // APBreset27 
   input     pclk27;               // APB27 clock27
   input     psel27;               // APB27 select27
   input     penable27;            // APB27 enable 
   input     pwrite27;             // APB27 write strobe27 
   input [4:0] paddr27;              // APB27 address bus
   input [31:0] pwdata27;             // APB27 write data 
   
   // Outputs27 to SMC27
   
   // APB27 Output27
   output [31:0] prdata27;        //APB27 output
   
   
    // Outputs27 to SMC27
   
   wire   [31:0] prdata27;

   wire   [31:0] rdata027;  // Selected27 data for register 0
   wire   [31:0] rdata127;  // Selected27 data for register 1
   wire   [31:0] rdata227;  // Selected27 data for register 2
   wire   [31:0] rdata327;  // Selected27 data for register 3
   wire   [31:0] rdata427;  // Selected27 data for register 4
   wire   [31:0] rdata527;  // Selected27 data for register 5
   wire   [31:0] rdata627;  // Selected27 data for register 6
   wire   [31:0] rdata727;  // Selected27 data for register 7

   reg    selreg27;   // Select27 for register (bit significant27)

   
   
   // register addresses27
   
//`define address_config027 5'h00


smc_cfreg_lite27 i_cfreg027 (
  .selreg27           ( selreg27 ),

  .rdata27            ( rdata027 )
);


assign prdata27 = ( rdata027 );

// Generate27 register selects27
always @ (
  psel27 or
  paddr27 or
  penable27
)
begin : p_addr_decode27

  if ( psel27 & penable27 )
    if (paddr27 == 5'h00)
       selreg27 = 1'b1;
    else
       selreg27 = 1'b0;
  else 
       selreg27 = 1'b0;

end // p_addr_decode27
  
endmodule // smc_apb_interface27


