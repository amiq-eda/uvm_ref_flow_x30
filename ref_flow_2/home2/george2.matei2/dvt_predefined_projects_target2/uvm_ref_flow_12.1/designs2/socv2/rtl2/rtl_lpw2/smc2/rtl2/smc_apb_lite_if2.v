//File2 name   : smc_apb_lite_if2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------


`include "smc_defs_lite2.v" 
// apb2 interface
module smc_apb_lite_if2 (
                   //Inputs2
                   
                   n_preset2, 
                   pclk2, 
                   psel2, 
                   penable2, 
                   pwrite2, 
                   paddr2, 
                   pwdata2,
 
                   
                   //Outputs2
                   
                   
                   prdata2
                   
                   );
   
    //   // APB2 Inputs2  
   input     n_preset2;           // APBreset2 
   input     pclk2;               // APB2 clock2
   input     psel2;               // APB2 select2
   input     penable2;            // APB2 enable 
   input     pwrite2;             // APB2 write strobe2 
   input [4:0] paddr2;              // APB2 address bus
   input [31:0] pwdata2;             // APB2 write data 
   
   // Outputs2 to SMC2
   
   // APB2 Output2
   output [31:0] prdata2;        //APB2 output
   
   
    // Outputs2 to SMC2
   
   wire   [31:0] prdata2;

   wire   [31:0] rdata02;  // Selected2 data for register 0
   wire   [31:0] rdata12;  // Selected2 data for register 1
   wire   [31:0] rdata22;  // Selected2 data for register 2
   wire   [31:0] rdata32;  // Selected2 data for register 3
   wire   [31:0] rdata42;  // Selected2 data for register 4
   wire   [31:0] rdata52;  // Selected2 data for register 5
   wire   [31:0] rdata62;  // Selected2 data for register 6
   wire   [31:0] rdata72;  // Selected2 data for register 7

   reg    selreg2;   // Select2 for register (bit significant2)

   
   
   // register addresses2
   
//`define address_config02 5'h00


smc_cfreg_lite2 i_cfreg02 (
  .selreg2           ( selreg2 ),

  .rdata2            ( rdata02 )
);


assign prdata2 = ( rdata02 );

// Generate2 register selects2
always @ (
  psel2 or
  paddr2 or
  penable2
)
begin : p_addr_decode2

  if ( psel2 & penable2 )
    if (paddr2 == 5'h00)
       selreg2 = 1'b1;
    else
       selreg2 = 1'b0;
  else 
       selreg2 = 1'b0;

end // p_addr_decode2
  
endmodule // smc_apb_interface2


