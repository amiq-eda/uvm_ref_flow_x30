//File13 name   : smc_apb_lite_if13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------


`include "smc_defs_lite13.v" 
// apb13 interface
module smc_apb_lite_if13 (
                   //Inputs13
                   
                   n_preset13, 
                   pclk13, 
                   psel13, 
                   penable13, 
                   pwrite13, 
                   paddr13, 
                   pwdata13,
 
                   
                   //Outputs13
                   
                   
                   prdata13
                   
                   );
   
    //   // APB13 Inputs13  
   input     n_preset13;           // APBreset13 
   input     pclk13;               // APB13 clock13
   input     psel13;               // APB13 select13
   input     penable13;            // APB13 enable 
   input     pwrite13;             // APB13 write strobe13 
   input [4:0] paddr13;              // APB13 address bus
   input [31:0] pwdata13;             // APB13 write data 
   
   // Outputs13 to SMC13
   
   // APB13 Output13
   output [31:0] prdata13;        //APB13 output
   
   
    // Outputs13 to SMC13
   
   wire   [31:0] prdata13;

   wire   [31:0] rdata013;  // Selected13 data for register 0
   wire   [31:0] rdata113;  // Selected13 data for register 1
   wire   [31:0] rdata213;  // Selected13 data for register 2
   wire   [31:0] rdata313;  // Selected13 data for register 3
   wire   [31:0] rdata413;  // Selected13 data for register 4
   wire   [31:0] rdata513;  // Selected13 data for register 5
   wire   [31:0] rdata613;  // Selected13 data for register 6
   wire   [31:0] rdata713;  // Selected13 data for register 7

   reg    selreg13;   // Select13 for register (bit significant13)

   
   
   // register addresses13
   
//`define address_config013 5'h00


smc_cfreg_lite13 i_cfreg013 (
  .selreg13           ( selreg13 ),

  .rdata13            ( rdata013 )
);


assign prdata13 = ( rdata013 );

// Generate13 register selects13
always @ (
  psel13 or
  paddr13 or
  penable13
)
begin : p_addr_decode13

  if ( psel13 & penable13 )
    if (paddr13 == 5'h00)
       selreg13 = 1'b1;
    else
       selreg13 = 1'b0;
  else 
       selreg13 = 1'b0;

end // p_addr_decode13
  
endmodule // smc_apb_interface13


