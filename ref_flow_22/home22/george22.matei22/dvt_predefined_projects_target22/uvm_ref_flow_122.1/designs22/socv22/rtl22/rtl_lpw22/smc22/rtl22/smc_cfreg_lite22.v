//File22 name   : smc_cfreg_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 : Single22 instance of a config register
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------



module smc_cfreg_lite22 (
  // inputs22
  selreg22,

  // outputs22
  rdata22
);


// Inputs22
input         selreg22;               // select22 the register for read/write access

// Outputs22
output [31:0] rdata22;                 // Read data

wire   [31:0] smc_config22;
wire   [31:0] rdata22;


assign rdata22 = ( selreg22 ) ? smc_config22 : 32'b0;
assign smc_config22 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg22
