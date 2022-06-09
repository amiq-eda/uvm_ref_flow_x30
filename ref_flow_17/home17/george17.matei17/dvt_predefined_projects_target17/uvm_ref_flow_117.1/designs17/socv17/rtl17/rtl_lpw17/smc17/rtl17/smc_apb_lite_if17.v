//File17 name   : smc_apb_lite_if17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------


`include "smc_defs_lite17.v" 
// apb17 interface
module smc_apb_lite_if17 (
                   //Inputs17
                   
                   n_preset17, 
                   pclk17, 
                   psel17, 
                   penable17, 
                   pwrite17, 
                   paddr17, 
                   pwdata17,
 
                   
                   //Outputs17
                   
                   
                   prdata17
                   
                   );
   
    //   // APB17 Inputs17  
   input     n_preset17;           // APBreset17 
   input     pclk17;               // APB17 clock17
   input     psel17;               // APB17 select17
   input     penable17;            // APB17 enable 
   input     pwrite17;             // APB17 write strobe17 
   input [4:0] paddr17;              // APB17 address bus
   input [31:0] pwdata17;             // APB17 write data 
   
   // Outputs17 to SMC17
   
   // APB17 Output17
   output [31:0] prdata17;        //APB17 output
   
   
    // Outputs17 to SMC17
   
   wire   [31:0] prdata17;

   wire   [31:0] rdata017;  // Selected17 data for register 0
   wire   [31:0] rdata117;  // Selected17 data for register 1
   wire   [31:0] rdata217;  // Selected17 data for register 2
   wire   [31:0] rdata317;  // Selected17 data for register 3
   wire   [31:0] rdata417;  // Selected17 data for register 4
   wire   [31:0] rdata517;  // Selected17 data for register 5
   wire   [31:0] rdata617;  // Selected17 data for register 6
   wire   [31:0] rdata717;  // Selected17 data for register 7

   reg    selreg17;   // Select17 for register (bit significant17)

   
   
   // register addresses17
   
//`define address_config017 5'h00


smc_cfreg_lite17 i_cfreg017 (
  .selreg17           ( selreg17 ),

  .rdata17            ( rdata017 )
);


assign prdata17 = ( rdata017 );

// Generate17 register selects17
always @ (
  psel17 or
  paddr17 or
  penable17
)
begin : p_addr_decode17

  if ( psel17 & penable17 )
    if (paddr17 == 5'h00)
       selreg17 = 1'b1;
    else
       selreg17 = 1'b0;
  else 
       selreg17 = 1'b0;

end // p_addr_decode17
  
endmodule // smc_apb_interface17


