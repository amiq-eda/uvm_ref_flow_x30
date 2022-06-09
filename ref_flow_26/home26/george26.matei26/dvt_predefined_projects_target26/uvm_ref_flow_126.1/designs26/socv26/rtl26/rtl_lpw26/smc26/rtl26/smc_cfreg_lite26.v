//File26 name   : smc_cfreg_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 : Single26 instance of a config register
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------



module smc_cfreg_lite26 (
  // inputs26
  selreg26,

  // outputs26
  rdata26
);


// Inputs26
input         selreg26;               // select26 the register for read/write access

// Outputs26
output [31:0] rdata26;                 // Read data

wire   [31:0] smc_config26;
wire   [31:0] rdata26;


assign rdata26 = ( selreg26 ) ? smc_config26 : 32'b0;
assign smc_config26 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg26
