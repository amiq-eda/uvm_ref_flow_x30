//File5 name   : smc_apb_lite_if5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------


`include "smc_defs_lite5.v" 
// apb5 interface
module smc_apb_lite_if5 (
                   //Inputs5
                   
                   n_preset5, 
                   pclk5, 
                   psel5, 
                   penable5, 
                   pwrite5, 
                   paddr5, 
                   pwdata5,
 
                   
                   //Outputs5
                   
                   
                   prdata5
                   
                   );
   
    //   // APB5 Inputs5  
   input     n_preset5;           // APBreset5 
   input     pclk5;               // APB5 clock5
   input     psel5;               // APB5 select5
   input     penable5;            // APB5 enable 
   input     pwrite5;             // APB5 write strobe5 
   input [4:0] paddr5;              // APB5 address bus
   input [31:0] pwdata5;             // APB5 write data 
   
   // Outputs5 to SMC5
   
   // APB5 Output5
   output [31:0] prdata5;        //APB5 output
   
   
    // Outputs5 to SMC5
   
   wire   [31:0] prdata5;

   wire   [31:0] rdata05;  // Selected5 data for register 0
   wire   [31:0] rdata15;  // Selected5 data for register 1
   wire   [31:0] rdata25;  // Selected5 data for register 2
   wire   [31:0] rdata35;  // Selected5 data for register 3
   wire   [31:0] rdata45;  // Selected5 data for register 4
   wire   [31:0] rdata55;  // Selected5 data for register 5
   wire   [31:0] rdata65;  // Selected5 data for register 6
   wire   [31:0] rdata75;  // Selected5 data for register 7

   reg    selreg5;   // Select5 for register (bit significant5)

   
   
   // register addresses5
   
//`define address_config05 5'h00


smc_cfreg_lite5 i_cfreg05 (
  .selreg5           ( selreg5 ),

  .rdata5            ( rdata05 )
);


assign prdata5 = ( rdata05 );

// Generate5 register selects5
always @ (
  psel5 or
  paddr5 or
  penable5
)
begin : p_addr_decode5

  if ( psel5 & penable5 )
    if (paddr5 == 5'h00)
       selreg5 = 1'b1;
    else
       selreg5 = 1'b0;
  else 
       selreg5 = 1'b0;

end // p_addr_decode5
  
endmodule // smc_apb_interface5


