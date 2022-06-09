//File3 name   : smc_apb_lite_if3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------


`include "smc_defs_lite3.v" 
// apb3 interface
module smc_apb_lite_if3 (
                   //Inputs3
                   
                   n_preset3, 
                   pclk3, 
                   psel3, 
                   penable3, 
                   pwrite3, 
                   paddr3, 
                   pwdata3,
 
                   
                   //Outputs3
                   
                   
                   prdata3
                   
                   );
   
    //   // APB3 Inputs3  
   input     n_preset3;           // APBreset3 
   input     pclk3;               // APB3 clock3
   input     psel3;               // APB3 select3
   input     penable3;            // APB3 enable 
   input     pwrite3;             // APB3 write strobe3 
   input [4:0] paddr3;              // APB3 address bus
   input [31:0] pwdata3;             // APB3 write data 
   
   // Outputs3 to SMC3
   
   // APB3 Output3
   output [31:0] prdata3;        //APB3 output
   
   
    // Outputs3 to SMC3
   
   wire   [31:0] prdata3;

   wire   [31:0] rdata03;  // Selected3 data for register 0
   wire   [31:0] rdata13;  // Selected3 data for register 1
   wire   [31:0] rdata23;  // Selected3 data for register 2
   wire   [31:0] rdata33;  // Selected3 data for register 3
   wire   [31:0] rdata43;  // Selected3 data for register 4
   wire   [31:0] rdata53;  // Selected3 data for register 5
   wire   [31:0] rdata63;  // Selected3 data for register 6
   wire   [31:0] rdata73;  // Selected3 data for register 7

   reg    selreg3;   // Select3 for register (bit significant3)

   
   
   // register addresses3
   
//`define address_config03 5'h00


smc_cfreg_lite3 i_cfreg03 (
  .selreg3           ( selreg3 ),

  .rdata3            ( rdata03 )
);


assign prdata3 = ( rdata03 );

// Generate3 register selects3
always @ (
  psel3 or
  paddr3 or
  penable3
)
begin : p_addr_decode3

  if ( psel3 & penable3 )
    if (paddr3 == 5'h00)
       selreg3 = 1'b1;
    else
       selreg3 = 1'b0;
  else 
       selreg3 = 1'b0;

end // p_addr_decode3
  
endmodule // smc_apb_interface3


