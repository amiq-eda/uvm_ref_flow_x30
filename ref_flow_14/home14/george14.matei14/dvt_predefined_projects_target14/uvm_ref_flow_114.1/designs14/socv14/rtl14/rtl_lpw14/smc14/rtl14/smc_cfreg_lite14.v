//File14 name   : smc_cfreg_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 : Single14 instance of a config register
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------



module smc_cfreg_lite14 (
  // inputs14
  selreg14,

  // outputs14
  rdata14
);


// Inputs14
input         selreg14;               // select14 the register for read/write access

// Outputs14
output [31:0] rdata14;                 // Read data

wire   [31:0] smc_config14;
wire   [31:0] rdata14;


assign rdata14 = ( selreg14 ) ? smc_config14 : 32'b0;
assign smc_config14 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg14
