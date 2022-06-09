//File13 name   : smc_cfreg_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 : Single13 instance of a config register
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------



module smc_cfreg_lite13 (
  // inputs13
  selreg13,

  // outputs13
  rdata13
);


// Inputs13
input         selreg13;               // select13 the register for read/write access

// Outputs13
output [31:0] rdata13;                 // Read data

wire   [31:0] smc_config13;
wire   [31:0] rdata13;


assign rdata13 = ( selreg13 ) ? smc_config13 : 32'b0;
assign smc_config13 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg13
