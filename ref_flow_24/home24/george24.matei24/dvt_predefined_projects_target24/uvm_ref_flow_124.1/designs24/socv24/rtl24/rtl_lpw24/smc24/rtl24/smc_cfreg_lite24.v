//File24 name   : smc_cfreg_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 : Single24 instance of a config register
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------



module smc_cfreg_lite24 (
  // inputs24
  selreg24,

  // outputs24
  rdata24
);


// Inputs24
input         selreg24;               // select24 the register for read/write access

// Outputs24
output [31:0] rdata24;                 // Read data

wire   [31:0] smc_config24;
wire   [31:0] rdata24;


assign rdata24 = ( selreg24 ) ? smc_config24 : 32'b0;
assign smc_config24 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg24
