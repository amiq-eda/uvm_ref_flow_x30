//File23 name   : smc_apb_lite_if23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------


`include "smc_defs_lite23.v" 
// apb23 interface
module smc_apb_lite_if23 (
                   //Inputs23
                   
                   n_preset23, 
                   pclk23, 
                   psel23, 
                   penable23, 
                   pwrite23, 
                   paddr23, 
                   pwdata23,
 
                   
                   //Outputs23
                   
                   
                   prdata23
                   
                   );
   
    //   // APB23 Inputs23  
   input     n_preset23;           // APBreset23 
   input     pclk23;               // APB23 clock23
   input     psel23;               // APB23 select23
   input     penable23;            // APB23 enable 
   input     pwrite23;             // APB23 write strobe23 
   input [4:0] paddr23;              // APB23 address bus
   input [31:0] pwdata23;             // APB23 write data 
   
   // Outputs23 to SMC23
   
   // APB23 Output23
   output [31:0] prdata23;        //APB23 output
   
   
    // Outputs23 to SMC23
   
   wire   [31:0] prdata23;

   wire   [31:0] rdata023;  // Selected23 data for register 0
   wire   [31:0] rdata123;  // Selected23 data for register 1
   wire   [31:0] rdata223;  // Selected23 data for register 2
   wire   [31:0] rdata323;  // Selected23 data for register 3
   wire   [31:0] rdata423;  // Selected23 data for register 4
   wire   [31:0] rdata523;  // Selected23 data for register 5
   wire   [31:0] rdata623;  // Selected23 data for register 6
   wire   [31:0] rdata723;  // Selected23 data for register 7

   reg    selreg23;   // Select23 for register (bit significant23)

   
   
   // register addresses23
   
//`define address_config023 5'h00


smc_cfreg_lite23 i_cfreg023 (
  .selreg23           ( selreg23 ),

  .rdata23            ( rdata023 )
);


assign prdata23 = ( rdata023 );

// Generate23 register selects23
always @ (
  psel23 or
  paddr23 or
  penable23
)
begin : p_addr_decode23

  if ( psel23 & penable23 )
    if (paddr23 == 5'h00)
       selreg23 = 1'b1;
    else
       selreg23 = 1'b0;
  else 
       selreg23 = 1'b0;

end // p_addr_decode23
  
endmodule // smc_apb_interface23


