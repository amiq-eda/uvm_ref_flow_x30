//File11 name   : smc_apb_lite_if11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------


`include "smc_defs_lite11.v" 
// apb11 interface
module smc_apb_lite_if11 (
                   //Inputs11
                   
                   n_preset11, 
                   pclk11, 
                   psel11, 
                   penable11, 
                   pwrite11, 
                   paddr11, 
                   pwdata11,
 
                   
                   //Outputs11
                   
                   
                   prdata11
                   
                   );
   
    //   // APB11 Inputs11  
   input     n_preset11;           // APBreset11 
   input     pclk11;               // APB11 clock11
   input     psel11;               // APB11 select11
   input     penable11;            // APB11 enable 
   input     pwrite11;             // APB11 write strobe11 
   input [4:0] paddr11;              // APB11 address bus
   input [31:0] pwdata11;             // APB11 write data 
   
   // Outputs11 to SMC11
   
   // APB11 Output11
   output [31:0] prdata11;        //APB11 output
   
   
    // Outputs11 to SMC11
   
   wire   [31:0] prdata11;

   wire   [31:0] rdata011;  // Selected11 data for register 0
   wire   [31:0] rdata111;  // Selected11 data for register 1
   wire   [31:0] rdata211;  // Selected11 data for register 2
   wire   [31:0] rdata311;  // Selected11 data for register 3
   wire   [31:0] rdata411;  // Selected11 data for register 4
   wire   [31:0] rdata511;  // Selected11 data for register 5
   wire   [31:0] rdata611;  // Selected11 data for register 6
   wire   [31:0] rdata711;  // Selected11 data for register 7

   reg    selreg11;   // Select11 for register (bit significant11)

   
   
   // register addresses11
   
//`define address_config011 5'h00


smc_cfreg_lite11 i_cfreg011 (
  .selreg11           ( selreg11 ),

  .rdata11            ( rdata011 )
);


assign prdata11 = ( rdata011 );

// Generate11 register selects11
always @ (
  psel11 or
  paddr11 or
  penable11
)
begin : p_addr_decode11

  if ( psel11 & penable11 )
    if (paddr11 == 5'h00)
       selreg11 = 1'b1;
    else
       selreg11 = 1'b0;
  else 
       selreg11 = 1'b0;

end // p_addr_decode11
  
endmodule // smc_apb_interface11


