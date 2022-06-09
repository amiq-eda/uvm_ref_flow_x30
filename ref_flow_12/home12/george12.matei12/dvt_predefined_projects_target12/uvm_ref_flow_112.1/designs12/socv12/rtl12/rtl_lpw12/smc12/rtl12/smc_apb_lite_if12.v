//File12 name   : smc_apb_lite_if12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------


`include "smc_defs_lite12.v" 
// apb12 interface
module smc_apb_lite_if12 (
                   //Inputs12
                   
                   n_preset12, 
                   pclk12, 
                   psel12, 
                   penable12, 
                   pwrite12, 
                   paddr12, 
                   pwdata12,
 
                   
                   //Outputs12
                   
                   
                   prdata12
                   
                   );
   
    //   // APB12 Inputs12  
   input     n_preset12;           // APBreset12 
   input     pclk12;               // APB12 clock12
   input     psel12;               // APB12 select12
   input     penable12;            // APB12 enable 
   input     pwrite12;             // APB12 write strobe12 
   input [4:0] paddr12;              // APB12 address bus
   input [31:0] pwdata12;             // APB12 write data 
   
   // Outputs12 to SMC12
   
   // APB12 Output12
   output [31:0] prdata12;        //APB12 output
   
   
    // Outputs12 to SMC12
   
   wire   [31:0] prdata12;

   wire   [31:0] rdata012;  // Selected12 data for register 0
   wire   [31:0] rdata112;  // Selected12 data for register 1
   wire   [31:0] rdata212;  // Selected12 data for register 2
   wire   [31:0] rdata312;  // Selected12 data for register 3
   wire   [31:0] rdata412;  // Selected12 data for register 4
   wire   [31:0] rdata512;  // Selected12 data for register 5
   wire   [31:0] rdata612;  // Selected12 data for register 6
   wire   [31:0] rdata712;  // Selected12 data for register 7

   reg    selreg12;   // Select12 for register (bit significant12)

   
   
   // register addresses12
   
//`define address_config012 5'h00


smc_cfreg_lite12 i_cfreg012 (
  .selreg12           ( selreg12 ),

  .rdata12            ( rdata012 )
);


assign prdata12 = ( rdata012 );

// Generate12 register selects12
always @ (
  psel12 or
  paddr12 or
  penable12
)
begin : p_addr_decode12

  if ( psel12 & penable12 )
    if (paddr12 == 5'h00)
       selreg12 = 1'b1;
    else
       selreg12 = 1'b0;
  else 
       selreg12 = 1'b0;

end // p_addr_decode12
  
endmodule // smc_apb_interface12


