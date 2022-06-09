//File30 name   : smc_cfreg_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 : Single30 instance of a config register
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------



module smc_cfreg_lite30 (
  // inputs30
  selreg30,

  // outputs30
  rdata30
);


// Inputs30
input         selreg30;               // select30 the register for read/write access

// Outputs30
output [31:0] rdata30;                 // Read data

wire   [31:0] smc_config30;
wire   [31:0] rdata30;


assign rdata30 = ( selreg30 ) ? smc_config30 : 32'b0;
assign smc_config30 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg30
