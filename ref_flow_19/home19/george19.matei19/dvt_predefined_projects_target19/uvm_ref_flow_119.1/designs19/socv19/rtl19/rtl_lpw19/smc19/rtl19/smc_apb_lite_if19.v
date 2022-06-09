//File19 name   : smc_apb_lite_if19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------


`include "smc_defs_lite19.v" 
// apb19 interface
module smc_apb_lite_if19 (
                   //Inputs19
                   
                   n_preset19, 
                   pclk19, 
                   psel19, 
                   penable19, 
                   pwrite19, 
                   paddr19, 
                   pwdata19,
 
                   
                   //Outputs19
                   
                   
                   prdata19
                   
                   );
   
    //   // APB19 Inputs19  
   input     n_preset19;           // APBreset19 
   input     pclk19;               // APB19 clock19
   input     psel19;               // APB19 select19
   input     penable19;            // APB19 enable 
   input     pwrite19;             // APB19 write strobe19 
   input [4:0] paddr19;              // APB19 address bus
   input [31:0] pwdata19;             // APB19 write data 
   
   // Outputs19 to SMC19
   
   // APB19 Output19
   output [31:0] prdata19;        //APB19 output
   
   
    // Outputs19 to SMC19
   
   wire   [31:0] prdata19;

   wire   [31:0] rdata019;  // Selected19 data for register 0
   wire   [31:0] rdata119;  // Selected19 data for register 1
   wire   [31:0] rdata219;  // Selected19 data for register 2
   wire   [31:0] rdata319;  // Selected19 data for register 3
   wire   [31:0] rdata419;  // Selected19 data for register 4
   wire   [31:0] rdata519;  // Selected19 data for register 5
   wire   [31:0] rdata619;  // Selected19 data for register 6
   wire   [31:0] rdata719;  // Selected19 data for register 7

   reg    selreg19;   // Select19 for register (bit significant19)

   
   
   // register addresses19
   
//`define address_config019 5'h00


smc_cfreg_lite19 i_cfreg019 (
  .selreg19           ( selreg19 ),

  .rdata19            ( rdata019 )
);


assign prdata19 = ( rdata019 );

// Generate19 register selects19
always @ (
  psel19 or
  paddr19 or
  penable19
)
begin : p_addr_decode19

  if ( psel19 & penable19 )
    if (paddr19 == 5'h00)
       selreg19 = 1'b1;
    else
       selreg19 = 1'b0;
  else 
       selreg19 = 1'b0;

end // p_addr_decode19
  
endmodule // smc_apb_interface19


