//File2 name   : smc_cfreg_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 : Single2 instance of a config register
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------



module smc_cfreg_lite2 (
  // inputs2
  selreg2,

  // outputs2
  rdata2
);


// Inputs2
input         selreg2;               // select2 the register for read/write access

// Outputs2
output [31:0] rdata2;                 // Read data

wire   [31:0] smc_config2;
wire   [31:0] rdata2;


assign rdata2 = ( selreg2 ) ? smc_config2 : 32'b0;
assign smc_config2 =  {1'b1,1'b1,8'h00, 2'b00, 2'b00, 2'b00, 2'b00,2'b00,2'b00,2'b00,8'h01};




endmodule // smc_cfreg2
