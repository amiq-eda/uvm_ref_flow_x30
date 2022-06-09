//File3 name   : smc_cfreg_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 : Single3 instance of a config register
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------



module smc_cfreg_lite3 (
  // inputs3
  selreg3,

  // outputs3
  rdata3
);


// Inputs3
input         selreg3;               // select3 the register for read/write access

// Outputs3
output [31:0] rdata3;                 // Read data

wire   [31:0] smc_config3;
wire   [31:0] rdata3;


assign rdata3 = ( selreg3 ) ? smc_config3 : 32'b0;
assign smc_config3 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg3
