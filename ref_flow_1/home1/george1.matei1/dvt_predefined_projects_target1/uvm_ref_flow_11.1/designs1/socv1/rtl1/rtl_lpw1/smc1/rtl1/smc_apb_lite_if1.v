//File1 name   : smc_apb_lite_if1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------


`include "smc_defs_lite1.v" 
// apb1 interface
module smc_apb_lite_if1 (
                   //Inputs1
                   
                   n_preset1, 
                   pclk1, 
                   psel1, 
                   penable1, 
                   pwrite1, 
                   paddr1, 
                   pwdata1,
 
                   
                   //Outputs1
                   
                   
                   prdata1
                   
                   );
   
    //   // APB1 Inputs1  
   input     n_preset1;           // APBreset1 
   input     pclk1;               // APB1 clock1
   input     psel1;               // APB1 select1
   input     penable1;            // APB1 enable 
   input     pwrite1;             // APB1 write strobe1 
   input [4:0] paddr1;              // APB1 address bus
   input [31:0] pwdata1;             // APB1 write data 
   
   // Outputs1 to SMC1
   
   // APB1 Output1
   output [31:0] prdata1;        //APB1 output
   
   
    // Outputs1 to SMC1
   
   wire   [31:0] prdata1;

   wire   [31:0] rdata01;  // Selected1 data for register 0
   wire   [31:0] rdata11;  // Selected1 data for register 1
   wire   [31:0] rdata21;  // Selected1 data for register 2
   wire   [31:0] rdata31;  // Selected1 data for register 3
   wire   [31:0] rdata41;  // Selected1 data for register 4
   wire   [31:0] rdata51;  // Selected1 data for register 5
   wire   [31:0] rdata61;  // Selected1 data for register 6
   wire   [31:0] rdata71;  // Selected1 data for register 7

   reg    selreg1;   // Select1 for register (bit significant1)

   
   
   // register addresses1
   
//`define address_config01 5'h00


smc_cfreg_lite1 i_cfreg01 (
  .selreg1           ( selreg1 ),

  .rdata1            ( rdata01 )
);


assign prdata1 = ( rdata01 );

// Generate1 register selects1
always @ (
  psel1 or
  paddr1 or
  penable1
)
begin : p_addr_decode1

  if ( psel1 & penable1 )
    if (paddr1 == 5'h00)
       selreg1 = 1'b1;
    else
       selreg1 = 1'b0;
  else 
       selreg1 = 1'b0;

end // p_addr_decode1
  
endmodule // smc_apb_interface1


