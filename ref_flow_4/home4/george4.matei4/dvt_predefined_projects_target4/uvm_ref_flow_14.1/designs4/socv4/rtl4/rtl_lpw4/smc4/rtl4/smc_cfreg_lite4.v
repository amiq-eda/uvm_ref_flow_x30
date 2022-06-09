//File4 name   : smc_cfreg_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 : Single4 instance of a config register
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



module smc_cfreg_lite4 (
  // inputs4
  selreg4,

  // outputs4
  rdata4
);


// Inputs4
input         selreg4;               // select4 the register for read/write access

// Outputs4
output [31:0] rdata4;                 // Read data

wire   [31:0] smc_config4;
wire   [31:0] rdata4;


assign rdata4 = ( selreg4 ) ? smc_config4 : 32'b0;
assign smc_config4 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg4
