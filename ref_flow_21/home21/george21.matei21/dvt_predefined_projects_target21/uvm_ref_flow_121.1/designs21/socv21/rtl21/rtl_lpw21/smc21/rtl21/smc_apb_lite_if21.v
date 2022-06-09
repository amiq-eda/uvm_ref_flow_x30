//File21 name   : smc_apb_lite_if21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------


`include "smc_defs_lite21.v" 
// apb21 interface
module smc_apb_lite_if21 (
                   //Inputs21
                   
                   n_preset21, 
                   pclk21, 
                   psel21, 
                   penable21, 
                   pwrite21, 
                   paddr21, 
                   pwdata21,
 
                   
                   //Outputs21
                   
                   
                   prdata21
                   
                   );
   
    //   // APB21 Inputs21  
   input     n_preset21;           // APBreset21 
   input     pclk21;               // APB21 clock21
   input     psel21;               // APB21 select21
   input     penable21;            // APB21 enable 
   input     pwrite21;             // APB21 write strobe21 
   input [4:0] paddr21;              // APB21 address bus
   input [31:0] pwdata21;             // APB21 write data 
   
   // Outputs21 to SMC21
   
   // APB21 Output21
   output [31:0] prdata21;        //APB21 output
   
   
    // Outputs21 to SMC21
   
   wire   [31:0] prdata21;

   wire   [31:0] rdata021;  // Selected21 data for register 0
   wire   [31:0] rdata121;  // Selected21 data for register 1
   wire   [31:0] rdata221;  // Selected21 data for register 2
   wire   [31:0] rdata321;  // Selected21 data for register 3
   wire   [31:0] rdata421;  // Selected21 data for register 4
   wire   [31:0] rdata521;  // Selected21 data for register 5
   wire   [31:0] rdata621;  // Selected21 data for register 6
   wire   [31:0] rdata721;  // Selected21 data for register 7

   reg    selreg21;   // Select21 for register (bit significant21)

   
   
   // register addresses21
   
//`define address_config021 5'h00


smc_cfreg_lite21 i_cfreg021 (
  .selreg21           ( selreg21 ),

  .rdata21            ( rdata021 )
);


assign prdata21 = ( rdata021 );

// Generate21 register selects21
always @ (
  psel21 or
  paddr21 or
  penable21
)
begin : p_addr_decode21

  if ( psel21 & penable21 )
    if (paddr21 == 5'h00)
       selreg21 = 1'b1;
    else
       selreg21 = 1'b0;
  else 
       selreg21 = 1'b0;

end // p_addr_decode21
  
endmodule // smc_apb_interface21


