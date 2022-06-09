//File29 name   : smc_cfreg_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 : Single29 instance of a config register
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------



module smc_cfreg_lite29 (
  // inputs29
  selreg29,

  // outputs29
  rdata29
);


// Inputs29
input         selreg29;               // select29 the register for read/write access

// Outputs29
output [31:0] rdata29;                 // Read data

wire   [31:0] smc_config29;
wire   [31:0] rdata29;


assign rdata29 = ( selreg29 ) ? smc_config29 : 32'b0;
assign smc_config29 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg29
