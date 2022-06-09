//File12 name   : smc_cfreg_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 : Single12 instance of a config register
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



module smc_cfreg_lite12 (
  // inputs12
  selreg12,

  // outputs12
  rdata12
);


// Inputs12
input         selreg12;               // select12 the register for read/write access

// Outputs12
output [31:0] rdata12;                 // Read data

wire   [31:0] smc_config12;
wire   [31:0] rdata12;


assign rdata12 = ( selreg12 ) ? smc_config12 : 32'b0;
assign smc_config12 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg12
