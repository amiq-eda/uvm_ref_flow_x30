//File30 name   : smc_apb_lite_if30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------


`include "smc_defs_lite30.v" 
// apb30 interface
module smc_apb_lite_if30 (
                   //Inputs30
                   
                   n_preset30, 
                   pclk30, 
                   psel30, 
                   penable30, 
                   pwrite30, 
                   paddr30, 
                   pwdata30,
 
                   
                   //Outputs30
                   
                   
                   prdata30
                   
                   );
   
    //   // APB30 Inputs30  
   input     n_preset30;           // APBreset30 
   input     pclk30;               // APB30 clock30
   input     psel30;               // APB30 select30
   input     penable30;            // APB30 enable 
   input     pwrite30;             // APB30 write strobe30 
   input [4:0] paddr30;              // APB30 address bus
   input [31:0] pwdata30;             // APB30 write data 
   
   // Outputs30 to SMC30
   
   // APB30 Output30
   output [31:0] prdata30;        //APB30 output
   
   
    // Outputs30 to SMC30
   
   wire   [31:0] prdata30;

   wire   [31:0] rdata030;  // Selected30 data for register 0
   wire   [31:0] rdata130;  // Selected30 data for register 1
   wire   [31:0] rdata230;  // Selected30 data for register 2
   wire   [31:0] rdata330;  // Selected30 data for register 3
   wire   [31:0] rdata430;  // Selected30 data for register 4
   wire   [31:0] rdata530;  // Selected30 data for register 5
   wire   [31:0] rdata630;  // Selected30 data for register 6
   wire   [31:0] rdata730;  // Selected30 data for register 7

   reg    selreg30;   // Select30 for register (bit significant30)

   
   
   // register addresses30
   
//`define address_config030 5'h00


smc_cfreg_lite30 i_cfreg030 (
  .selreg30           ( selreg30 ),

  .rdata30            ( rdata030 )
);


assign prdata30 = ( rdata030 );

// Generate30 register selects30
always @ (
  psel30 or
  paddr30 or
  penable30
)
begin : p_addr_decode30

  if ( psel30 & penable30 )
    if (paddr30 == 5'h00)
       selreg30 = 1'b1;
    else
       selreg30 = 1'b0;
  else 
       selreg30 = 1'b0;

end // p_addr_decode30
  
endmodule // smc_apb_interface30


