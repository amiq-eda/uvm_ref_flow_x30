//File21 name   : smc_cfreg_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 : Single21 instance of a config register
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------



module smc_cfreg_lite21 (
  // inputs21
  selreg21,

  // outputs21
  rdata21
);


// Inputs21
input         selreg21;               // select21 the register for read/write access

// Outputs21
output [31:0] rdata21;                 // Read data

wire   [31:0] smc_config21;
wire   [31:0] rdata21;


assign rdata21 = ( selreg21 ) ? smc_config21 : 32'b0;
assign smc_config21 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg21
