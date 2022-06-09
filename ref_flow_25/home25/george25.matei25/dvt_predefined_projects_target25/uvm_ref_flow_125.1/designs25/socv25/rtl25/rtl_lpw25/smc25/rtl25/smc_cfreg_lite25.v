//File25 name   : smc_cfreg_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 : Single25 instance of a config register
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------



module smc_cfreg_lite25 (
  // inputs25
  selreg25,

  // outputs25
  rdata25
);


// Inputs25
input         selreg25;               // select25 the register for read/write access

// Outputs25
output [31:0] rdata25;                 // Read data

wire   [31:0] smc_config25;
wire   [31:0] rdata25;


assign rdata25 = ( selreg25 ) ? smc_config25 : 32'b0;
assign smc_config25 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg25
