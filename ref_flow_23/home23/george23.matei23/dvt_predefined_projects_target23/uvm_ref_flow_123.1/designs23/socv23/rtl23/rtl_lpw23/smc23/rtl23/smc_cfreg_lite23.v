//File23 name   : smc_cfreg_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 : Single23 instance of a config register
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------



module smc_cfreg_lite23 (
  // inputs23
  selreg23,

  // outputs23
  rdata23
);


// Inputs23
input         selreg23;               // select23 the register for read/write access

// Outputs23
output [31:0] rdata23;                 // Read data

wire   [31:0] smc_config23;
wire   [31:0] rdata23;


assign rdata23 = ( selreg23 ) ? smc_config23 : 32'b0;
assign smc_config23 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg23
