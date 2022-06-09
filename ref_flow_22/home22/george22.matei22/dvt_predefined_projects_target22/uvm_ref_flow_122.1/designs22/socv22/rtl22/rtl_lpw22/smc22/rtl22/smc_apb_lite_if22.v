//File22 name   : smc_apb_lite_if22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------


`include "smc_defs_lite22.v" 
// apb22 interface
module smc_apb_lite_if22 (
                   //Inputs22
                   
                   n_preset22, 
                   pclk22, 
                   psel22, 
                   penable22, 
                   pwrite22, 
                   paddr22, 
                   pwdata22,
 
                   
                   //Outputs22
                   
                   
                   prdata22
                   
                   );
   
    //   // APB22 Inputs22  
   input     n_preset22;           // APBreset22 
   input     pclk22;               // APB22 clock22
   input     psel22;               // APB22 select22
   input     penable22;            // APB22 enable 
   input     pwrite22;             // APB22 write strobe22 
   input [4:0] paddr22;              // APB22 address bus
   input [31:0] pwdata22;             // APB22 write data 
   
   // Outputs22 to SMC22
   
   // APB22 Output22
   output [31:0] prdata22;        //APB22 output
   
   
    // Outputs22 to SMC22
   
   wire   [31:0] prdata22;

   wire   [31:0] rdata022;  // Selected22 data for register 0
   wire   [31:0] rdata122;  // Selected22 data for register 1
   wire   [31:0] rdata222;  // Selected22 data for register 2
   wire   [31:0] rdata322;  // Selected22 data for register 3
   wire   [31:0] rdata422;  // Selected22 data for register 4
   wire   [31:0] rdata522;  // Selected22 data for register 5
   wire   [31:0] rdata622;  // Selected22 data for register 6
   wire   [31:0] rdata722;  // Selected22 data for register 7

   reg    selreg22;   // Select22 for register (bit significant22)

   
   
   // register addresses22
   
//`define address_config022 5'h00


smc_cfreg_lite22 i_cfreg022 (
  .selreg22           ( selreg22 ),

  .rdata22            ( rdata022 )
);


assign prdata22 = ( rdata022 );

// Generate22 register selects22
always @ (
  psel22 or
  paddr22 or
  penable22
)
begin : p_addr_decode22

  if ( psel22 & penable22 )
    if (paddr22 == 5'h00)
       selreg22 = 1'b1;
    else
       selreg22 = 1'b0;
  else 
       selreg22 = 1'b0;

end // p_addr_decode22
  
endmodule // smc_apb_interface22


