//File15 name   : smc_cfreg_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 : Single15 instance of a config register
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------



module smc_cfreg_lite15 (
  // inputs15
  selreg15,

  // outputs15
  rdata15
);


// Inputs15
input         selreg15;               // select15 the register for read/write access

// Outputs15
output [31:0] rdata15;                 // Read data

wire   [31:0] smc_config15;
wire   [31:0] rdata15;


assign rdata15 = ( selreg15 ) ? smc_config15 : 32'b0;
assign smc_config15 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg15
