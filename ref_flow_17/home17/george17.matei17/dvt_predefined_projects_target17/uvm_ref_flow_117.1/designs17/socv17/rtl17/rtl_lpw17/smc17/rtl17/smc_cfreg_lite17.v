//File17 name   : smc_cfreg_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 : Single17 instance of a config register
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------



module smc_cfreg_lite17 (
  // inputs17
  selreg17,

  // outputs17
  rdata17
);


// Inputs17
input         selreg17;               // select17 the register for read/write access

// Outputs17
output [31:0] rdata17;                 // Read data

wire   [31:0] smc_config17;
wire   [31:0] rdata17;


assign rdata17 = ( selreg17 ) ? smc_config17 : 32'b0;
assign smc_config17 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg17
