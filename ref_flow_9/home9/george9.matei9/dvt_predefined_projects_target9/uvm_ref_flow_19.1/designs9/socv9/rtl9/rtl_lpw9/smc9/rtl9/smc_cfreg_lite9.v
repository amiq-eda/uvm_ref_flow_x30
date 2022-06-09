//File9 name   : smc_cfreg_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 : Single9 instance of a config register
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------



module smc_cfreg_lite9 (
  // inputs9
  selreg9,

  // outputs9
  rdata9
);


// Inputs9
input         selreg9;               // select9 the register for read/write access

// Outputs9
output [31:0] rdata9;                 // Read data

wire   [31:0] smc_config9;
wire   [31:0] rdata9;


assign rdata9 = ( selreg9 ) ? smc_config9 : 32'b0;
assign smc_config9 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg9
