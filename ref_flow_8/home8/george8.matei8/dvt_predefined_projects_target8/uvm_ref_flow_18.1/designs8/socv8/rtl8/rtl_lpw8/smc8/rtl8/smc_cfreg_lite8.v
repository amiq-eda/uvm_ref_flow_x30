//File8 name   : smc_cfreg_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 : Single8 instance of a config register
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------



module smc_cfreg_lite8 (
  // inputs8
  selreg8,

  // outputs8
  rdata8
);


// Inputs8
input         selreg8;               // select8 the register for read/write access

// Outputs8
output [31:0] rdata8;                 // Read data

wire   [31:0] smc_config8;
wire   [31:0] rdata8;


assign rdata8 = ( selreg8 ) ? smc_config8 : 32'b0;
assign smc_config8 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg8
