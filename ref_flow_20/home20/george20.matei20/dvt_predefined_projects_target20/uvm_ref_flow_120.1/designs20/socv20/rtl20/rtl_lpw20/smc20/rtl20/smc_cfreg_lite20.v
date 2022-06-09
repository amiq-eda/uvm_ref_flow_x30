//File20 name   : smc_cfreg_lite20.v
//Title20       : 
//Created20     : 1999
//Description20 : Single20 instance of a config register
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------



module smc_cfreg_lite20 (
  // inputs20
  selreg20,

  // outputs20
  rdata20
);


// Inputs20
input         selreg20;               // select20 the register for read/write access

// Outputs20
output [31:0] rdata20;                 // Read data

wire   [31:0] smc_config20;
wire   [31:0] rdata20;


assign rdata20 = ( selreg20 ) ? smc_config20 : 32'b0;
assign smc_config20 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg20
