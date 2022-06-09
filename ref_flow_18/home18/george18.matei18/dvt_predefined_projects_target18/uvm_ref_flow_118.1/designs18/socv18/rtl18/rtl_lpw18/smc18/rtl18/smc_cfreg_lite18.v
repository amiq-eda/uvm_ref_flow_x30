//File18 name   : smc_cfreg_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 : Single18 instance of a config register
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------



module smc_cfreg_lite18 (
  // inputs18
  selreg18,

  // outputs18
  rdata18
);


// Inputs18
input         selreg18;               // select18 the register for read/write access

// Outputs18
output [31:0] rdata18;                 // Read data

wire   [31:0] smc_config18;
wire   [31:0] rdata18;


assign rdata18 = ( selreg18 ) ? smc_config18 : 32'b0;
assign smc_config18 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg18
