//File6 name   : smc_defs_lite6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR6 12


//----------------------------------------------------------------------------
// Constants6
//----------------------------------------------------------------------------

// HTRANS6 transfer6 type signal6 encoding6
  `define TRN_IDLE6   2'b00
  `define TRN_BUSY6   2'b01
  `define TRN_NONSEQ6 2'b10
  `define TRN_SEQ6    2'b11
 
// HSIZE6 transfer6 type signal6 encoding6
  `define SZ_BYTE6 3'b000
  `define SZ_HALF6 3'b001
  `define SZ_WORD6 3'b010
 
// HRESP6 transfer6 response signal6 encoding6
  `define RSP_OKAY6  2'b00
  `define RSP_ERROR6 2'b01
  `define RSP_RETRY6 2'b10
  `define RSP_SPLIT6 2'b11 // Not used
 
// SMC6 state machine6 states6
  `define SMC_IDLE6  5'b00001
  `define SMC_LE6    5'b00010
  `define SMC_RW6    5'b00100
  `define SMC_STORE6 5'b01000
  `define SMC_FLOAT6 5'b10000

// Xfer6 Sizes6
  `define XSIZ_86   2'h0
  `define XSIZ_166  2'h1
  `define XSIZ_326  2'h2

// Bus6 Sizes6
  `define BSIZ_86   2'h0
  `define BSIZ_166  2'h1
  `define BSIZ_326  2'h2
