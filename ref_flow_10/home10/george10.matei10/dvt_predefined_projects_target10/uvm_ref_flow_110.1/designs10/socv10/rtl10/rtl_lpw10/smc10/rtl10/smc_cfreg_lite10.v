//File10 name   : smc_cfreg_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 : Single10 instance of a config register
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------



module smc_cfreg_lite10 (
  // inputs10
  selreg10,

  // outputs10
  rdata10
);


// Inputs10
input         selreg10;               // select10 the register for read/write access

// Outputs10
output [31:0] rdata10;                 // Read data

wire   [31:0] smc_config10;
wire   [31:0] rdata10;


assign rdata10 = ( selreg10 ) ? smc_config10 : 32'b0;
assign smc_config10 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg10
