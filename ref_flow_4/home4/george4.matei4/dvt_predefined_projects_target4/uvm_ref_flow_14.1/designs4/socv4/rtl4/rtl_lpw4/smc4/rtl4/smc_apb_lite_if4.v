//File4 name   : smc_apb_lite_if4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------


`include "smc_defs_lite4.v" 
// apb4 interface
module smc_apb_lite_if4 (
                   //Inputs4
                   
                   n_preset4, 
                   pclk4, 
                   psel4, 
                   penable4, 
                   pwrite4, 
                   paddr4, 
                   pwdata4,
 
                   
                   //Outputs4
                   
                   
                   prdata4
                   
                   );
   
    //   // APB4 Inputs4  
   input     n_preset4;           // APBreset4 
   input     pclk4;               // APB4 clock4
   input     psel4;               // APB4 select4
   input     penable4;            // APB4 enable 
   input     pwrite4;             // APB4 write strobe4 
   input [4:0] paddr4;              // APB4 address bus
   input [31:0] pwdata4;             // APB4 write data 
   
   // Outputs4 to SMC4
   
   // APB4 Output4
   output [31:0] prdata4;        //APB4 output
   
   
    // Outputs4 to SMC4
   
   wire   [31:0] prdata4;

   wire   [31:0] rdata04;  // Selected4 data for register 0
   wire   [31:0] rdata14;  // Selected4 data for register 1
   wire   [31:0] rdata24;  // Selected4 data for register 2
   wire   [31:0] rdata34;  // Selected4 data for register 3
   wire   [31:0] rdata44;  // Selected4 data for register 4
   wire   [31:0] rdata54;  // Selected4 data for register 5
   wire   [31:0] rdata64;  // Selected4 data for register 6
   wire   [31:0] rdata74;  // Selected4 data for register 7

   reg    selreg4;   // Select4 for register (bit significant4)

   
   
   // register addresses4
   
//`define address_config04 5'h00


smc_cfreg_lite4 i_cfreg04 (
  .selreg4           ( selreg4 ),

  .rdata4            ( rdata04 )
);


assign prdata4 = ( rdata04 );

// Generate4 register selects4
always @ (
  psel4 or
  paddr4 or
  penable4
)
begin : p_addr_decode4

  if ( psel4 & penable4 )
    if (paddr4 == 5'h00)
       selreg4 = 1'b1;
    else
       selreg4 = 1'b0;
  else 
       selreg4 = 1'b0;

end // p_addr_decode4
  
endmodule // smc_apb_interface4


