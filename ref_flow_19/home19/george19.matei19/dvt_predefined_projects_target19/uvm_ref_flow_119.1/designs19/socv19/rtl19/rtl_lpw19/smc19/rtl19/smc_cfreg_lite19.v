//File19 name   : smc_cfreg_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 : Single19 instance of a config register
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------



module smc_cfreg_lite19 (
  // inputs19
  selreg19,

  // outputs19
  rdata19
);


// Inputs19
input         selreg19;               // select19 the register for read/write access

// Outputs19
output [31:0] rdata19;                 // Read data

wire   [31:0] smc_config19;
wire   [31:0] rdata19;


assign rdata19 = ( selreg19 ) ? smc_config19 : 32'b0;
assign smc_config19 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg19
