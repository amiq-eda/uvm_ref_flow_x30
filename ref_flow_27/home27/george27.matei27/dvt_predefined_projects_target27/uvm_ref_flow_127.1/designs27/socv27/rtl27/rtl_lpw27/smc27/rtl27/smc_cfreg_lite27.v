//File27 name   : smc_cfreg_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 : Single27 instance of a config register
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------



module smc_cfreg_lite27 (
  // inputs27
  selreg27,

  // outputs27
  rdata27
);


// Inputs27
input         selreg27;               // select27 the register for read/write access

// Outputs27
output [31:0] rdata27;                 // Read data

wire   [31:0] smc_config27;
wire   [31:0] rdata27;


assign rdata27 = ( selreg27 ) ? smc_config27 : 32'b0;
assign smc_config27 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg27
