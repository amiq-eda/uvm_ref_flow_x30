//File7 name   : smc_cfreg_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 : Single7 instance of a config register
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------



module smc_cfreg_lite7 (
  // inputs7
  selreg7,

  // outputs7
  rdata7
);


// Inputs7
input         selreg7;               // select7 the register for read/write access

// Outputs7
output [31:0] rdata7;                 // Read data

wire   [31:0] smc_config7;
wire   [31:0] rdata7;


assign rdata7 = ( selreg7 ) ? smc_config7 : 32'b0;
assign smc_config7 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg7
