//File28 name   : smc_cfreg_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 : Single28 instance of a config register
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------



module smc_cfreg_lite28 (
  // inputs28
  selreg28,

  // outputs28
  rdata28
);


// Inputs28
input         selreg28;               // select28 the register for read/write access

// Outputs28
output [31:0] rdata28;                 // Read data

wire   [31:0] smc_config28;
wire   [31:0] rdata28;


assign rdata28 = ( selreg28 ) ? smc_config28 : 32'b0;
assign smc_config28 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg28
