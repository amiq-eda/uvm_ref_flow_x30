//File14 name   : smc_apb_lite_if14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------


`include "smc_defs_lite14.v" 
// apb14 interface
module smc_apb_lite_if14 (
                   //Inputs14
                   
                   n_preset14, 
                   pclk14, 
                   psel14, 
                   penable14, 
                   pwrite14, 
                   paddr14, 
                   pwdata14,
 
                   
                   //Outputs14
                   
                   
                   prdata14
                   
                   );
   
    //   // APB14 Inputs14  
   input     n_preset14;           // APBreset14 
   input     pclk14;               // APB14 clock14
   input     psel14;               // APB14 select14
   input     penable14;            // APB14 enable 
   input     pwrite14;             // APB14 write strobe14 
   input [4:0] paddr14;              // APB14 address bus
   input [31:0] pwdata14;             // APB14 write data 
   
   // Outputs14 to SMC14
   
   // APB14 Output14
   output [31:0] prdata14;        //APB14 output
   
   
    // Outputs14 to SMC14
   
   wire   [31:0] prdata14;

   wire   [31:0] rdata014;  // Selected14 data for register 0
   wire   [31:0] rdata114;  // Selected14 data for register 1
   wire   [31:0] rdata214;  // Selected14 data for register 2
   wire   [31:0] rdata314;  // Selected14 data for register 3
   wire   [31:0] rdata414;  // Selected14 data for register 4
   wire   [31:0] rdata514;  // Selected14 data for register 5
   wire   [31:0] rdata614;  // Selected14 data for register 6
   wire   [31:0] rdata714;  // Selected14 data for register 7

   reg    selreg14;   // Select14 for register (bit significant14)

   
   
   // register addresses14
   
//`define address_config014 5'h00


smc_cfreg_lite14 i_cfreg014 (
  .selreg14           ( selreg14 ),

  .rdata14            ( rdata014 )
);


assign prdata14 = ( rdata014 );

// Generate14 register selects14
always @ (
  psel14 or
  paddr14 or
  penable14
)
begin : p_addr_decode14

  if ( psel14 & penable14 )
    if (paddr14 == 5'h00)
       selreg14 = 1'b1;
    else
       selreg14 = 1'b0;
  else 
       selreg14 = 1'b0;

end // p_addr_decode14
  
endmodule // smc_apb_interface14


