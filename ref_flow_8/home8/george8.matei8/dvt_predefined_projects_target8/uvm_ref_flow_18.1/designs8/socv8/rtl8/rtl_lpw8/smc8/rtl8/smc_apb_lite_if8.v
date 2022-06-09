//File8 name   : smc_apb_lite_if8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------


`include "smc_defs_lite8.v" 
// apb8 interface
module smc_apb_lite_if8 (
                   //Inputs8
                   
                   n_preset8, 
                   pclk8, 
                   psel8, 
                   penable8, 
                   pwrite8, 
                   paddr8, 
                   pwdata8,
 
                   
                   //Outputs8
                   
                   
                   prdata8
                   
                   );
   
    //   // APB8 Inputs8  
   input     n_preset8;           // APBreset8 
   input     pclk8;               // APB8 clock8
   input     psel8;               // APB8 select8
   input     penable8;            // APB8 enable 
   input     pwrite8;             // APB8 write strobe8 
   input [4:0] paddr8;              // APB8 address bus
   input [31:0] pwdata8;             // APB8 write data 
   
   // Outputs8 to SMC8
   
   // APB8 Output8
   output [31:0] prdata8;        //APB8 output
   
   
    // Outputs8 to SMC8
   
   wire   [31:0] prdata8;

   wire   [31:0] rdata08;  // Selected8 data for register 0
   wire   [31:0] rdata18;  // Selected8 data for register 1
   wire   [31:0] rdata28;  // Selected8 data for register 2
   wire   [31:0] rdata38;  // Selected8 data for register 3
   wire   [31:0] rdata48;  // Selected8 data for register 4
   wire   [31:0] rdata58;  // Selected8 data for register 5
   wire   [31:0] rdata68;  // Selected8 data for register 6
   wire   [31:0] rdata78;  // Selected8 data for register 7

   reg    selreg8;   // Select8 for register (bit significant8)

   
   
   // register addresses8
   
//`define address_config08 5'h00


smc_cfreg_lite8 i_cfreg08 (
  .selreg8           ( selreg8 ),

  .rdata8            ( rdata08 )
);


assign prdata8 = ( rdata08 );

// Generate8 register selects8
always @ (
  psel8 or
  paddr8 or
  penable8
)
begin : p_addr_decode8

  if ( psel8 & penable8 )
    if (paddr8 == 5'h00)
       selreg8 = 1'b1;
    else
       selreg8 = 1'b0;
  else 
       selreg8 = 1'b0;

end // p_addr_decode8
  
endmodule // smc_apb_interface8


