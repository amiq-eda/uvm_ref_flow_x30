//File1 name   : smc_cfreg_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 : Single1 instance of a config register
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------



module smc_cfreg_lite1 (
  // inputs1
  selreg1,

  // outputs1
  rdata1
);


// Inputs1
input         selreg1;               // select1 the register for read/write access

// Outputs1
output [31:0] rdata1;                 // Read data

wire   [31:0] smc_config1;
wire   [31:0] rdata1;


assign rdata1 = ( selreg1 ) ? smc_config1 : 32'b0;
assign smc_config1 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg1
