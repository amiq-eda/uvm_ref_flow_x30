//File10 name   : smc_apb_lite_if10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------


`include "smc_defs_lite10.v" 
// apb10 interface
module smc_apb_lite_if10 (
                   //Inputs10
                   
                   n_preset10, 
                   pclk10, 
                   psel10, 
                   penable10, 
                   pwrite10, 
                   paddr10, 
                   pwdata10,
 
                   
                   //Outputs10
                   
                   
                   prdata10
                   
                   );
   
    //   // APB10 Inputs10  
   input     n_preset10;           // APBreset10 
   input     pclk10;               // APB10 clock10
   input     psel10;               // APB10 select10
   input     penable10;            // APB10 enable 
   input     pwrite10;             // APB10 write strobe10 
   input [4:0] paddr10;              // APB10 address bus
   input [31:0] pwdata10;             // APB10 write data 
   
   // Outputs10 to SMC10
   
   // APB10 Output10
   output [31:0] prdata10;        //APB10 output
   
   
    // Outputs10 to SMC10
   
   wire   [31:0] prdata10;

   wire   [31:0] rdata010;  // Selected10 data for register 0
   wire   [31:0] rdata110;  // Selected10 data for register 1
   wire   [31:0] rdata210;  // Selected10 data for register 2
   wire   [31:0] rdata310;  // Selected10 data for register 3
   wire   [31:0] rdata410;  // Selected10 data for register 4
   wire   [31:0] rdata510;  // Selected10 data for register 5
   wire   [31:0] rdata610;  // Selected10 data for register 6
   wire   [31:0] rdata710;  // Selected10 data for register 7

   reg    selreg10;   // Select10 for register (bit significant10)

   
   
   // register addresses10
   
//`define address_config010 5'h00


smc_cfreg_lite10 i_cfreg010 (
  .selreg10           ( selreg10 ),

  .rdata10            ( rdata010 )
);


assign prdata10 = ( rdata010 );

// Generate10 register selects10
always @ (
  psel10 or
  paddr10 or
  penable10
)
begin : p_addr_decode10

  if ( psel10 & penable10 )
    if (paddr10 == 5'h00)
       selreg10 = 1'b1;
    else
       selreg10 = 1'b0;
  else 
       selreg10 = 1'b0;

end // p_addr_decode10
  
endmodule // smc_apb_interface10


