//File16 name   : smc_cfreg_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 : Single16 instance of a config register
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------



module smc_cfreg_lite16 (
  // inputs16
  selreg16,

  // outputs16
  rdata16
);


// Inputs16
input         selreg16;               // select16 the register for read/write access

// Outputs16
output [31:0] rdata16;                 // Read data

wire   [31:0] smc_config16;
wire   [31:0] rdata16;


assign rdata16 = ( selreg16 ) ? smc_config16 : 32'b0;
assign smc_config16 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg16
