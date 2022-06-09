//File11 name   : smc_cfreg_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 : Single11 instance of a config register
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------



module smc_cfreg_lite11 (
  // inputs11
  selreg11,

  // outputs11
  rdata11
);


// Inputs11
input         selreg11;               // select11 the register for read/write access

// Outputs11
output [31:0] rdata11;                 // Read data

wire   [31:0] smc_config11;
wire   [31:0] rdata11;


assign rdata11 = ( selreg11 ) ? smc_config11 : 32'b0;
assign smc_config11 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg11
