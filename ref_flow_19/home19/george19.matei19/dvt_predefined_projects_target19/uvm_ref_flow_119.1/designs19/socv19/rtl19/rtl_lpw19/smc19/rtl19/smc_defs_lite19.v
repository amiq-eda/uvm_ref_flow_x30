//File19 name   : smc_defs_lite19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
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

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR19 12


//----------------------------------------------------------------------------
// Constants19
//----------------------------------------------------------------------------

// HTRANS19 transfer19 type signal19 encoding19
  `define TRN_IDLE19   2'b00
  `define TRN_BUSY19   2'b01
  `define TRN_NONSEQ19 2'b10
  `define TRN_SEQ19    2'b11
 
// HSIZE19 transfer19 type signal19 encoding19
  `define SZ_BYTE19 3'b000
  `define SZ_HALF19 3'b001
  `define SZ_WORD19 3'b010
 
// HRESP19 transfer19 response signal19 encoding19
  `define RSP_OKAY19  2'b00
  `define RSP_ERROR19 2'b01
  `define RSP_RETRY19 2'b10
  `define RSP_SPLIT19 2'b11 // Not used
 
// SMC19 state machine19 states19
  `define SMC_IDLE19  5'b00001
  `define SMC_LE19    5'b00010
  `define SMC_RW19    5'b00100
  `define SMC_STORE19 5'b01000
  `define SMC_FLOAT19 5'b10000

// Xfer19 Sizes19
  `define XSIZ_819   2'h0
  `define XSIZ_1619  2'h1
  `define XSIZ_3219  2'h2

// Bus19 Sizes19
  `define BSIZ_819   2'h0
  `define BSIZ_1619  2'h1
  `define BSIZ_3219  2'h2
