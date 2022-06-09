//File5 name   : smc_cfreg_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 : Single5 instance of a config register
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------



module smc_cfreg_lite5 (
  // inputs5
  selreg5,

  // outputs5
  rdata5
);


// Inputs5
input         selreg5;               // select5 the register for read/write access

// Outputs5
output [31:0] rdata5;                 // Read data

wire   [31:0] smc_config5;
wire   [31:0] rdata5;


assign rdata5 = ( selreg5 ) ? smc_config5 : 32'b0;
assign smc_config5 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg5
