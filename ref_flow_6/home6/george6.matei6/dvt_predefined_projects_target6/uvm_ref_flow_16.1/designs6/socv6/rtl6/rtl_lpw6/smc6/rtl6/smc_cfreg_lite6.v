//File6 name   : smc_cfreg_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 : Single6 instance of a config register
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------



module smc_cfreg_lite6 (
  // inputs6
  selreg6,

  // outputs6
  rdata6
);


// Inputs6
input         selreg6;               // select6 the register for read/write access

// Outputs6
output [31:0] rdata6;                 // Read data

wire   [31:0] smc_config6;
wire   [31:0] rdata6;


assign rdata6 = ( selreg6 ) ? smc_config6 : 32'b0;
assign smc_config6 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg6
