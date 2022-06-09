//File7 name   : smc_apb_lite_if7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------


`include "smc_defs_lite7.v" 
// apb7 interface
module smc_apb_lite_if7 (
                   //Inputs7
                   
                   n_preset7, 
                   pclk7, 
                   psel7, 
                   penable7, 
                   pwrite7, 
                   paddr7, 
                   pwdata7,
 
                   
                   //Outputs7
                   
                   
                   prdata7
                   
                   );
   
    //   // APB7 Inputs7  
   input     n_preset7;           // APBreset7 
   input     pclk7;               // APB7 clock7
   input     psel7;               // APB7 select7
   input     penable7;            // APB7 enable 
   input     pwrite7;             // APB7 write strobe7 
   input [4:0] paddr7;              // APB7 address bus
   input [31:0] pwdata7;             // APB7 write data 
   
   // Outputs7 to SMC7
   
   // APB7 Output7
   output [31:0] prdata7;        //APB7 output
   
   
    // Outputs7 to SMC7
   
   wire   [31:0] prdata7;

   wire   [31:0] rdata07;  // Selected7 data for register 0
   wire   [31:0] rdata17;  // Selected7 data for register 1
   wire   [31:0] rdata27;  // Selected7 data for register 2
   wire   [31:0] rdata37;  // Selected7 data for register 3
   wire   [31:0] rdata47;  // Selected7 data for register 4
   wire   [31:0] rdata57;  // Selected7 data for register 5
   wire   [31:0] rdata67;  // Selected7 data for register 6
   wire   [31:0] rdata77;  // Selected7 data for register 7

   reg    selreg7;   // Select7 for register (bit significant7)

   
   
   // register addresses7
   
//`define address_config07 5'h00


smc_cfreg_lite7 i_cfreg07 (
  .selreg7           ( selreg7 ),

  .rdata7            ( rdata07 )
);


assign prdata7 = ( rdata07 );

// Generate7 register selects7
always @ (
  psel7 or
  paddr7 or
  penable7
)
begin : p_addr_decode7

  if ( psel7 & penable7 )
    if (paddr7 == 5'h00)
       selreg7 = 1'b1;
    else
       selreg7 = 1'b0;
  else 
       selreg7 = 1'b0;

end // p_addr_decode7
  
endmodule // smc_apb_interface7


