//File25 name   : smc_defs_lite25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
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

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR25 12


//----------------------------------------------------------------------------
// Constants25
//----------------------------------------------------------------------------

// HTRANS25 transfer25 type signal25 encoding25
  `define TRN_IDLE25   2'b00
  `define TRN_BUSY25   2'b01
  `define TRN_NONSEQ25 2'b10
  `define TRN_SEQ25    2'b11
 
// HSIZE25 transfer25 type signal25 encoding25
  `define SZ_BYTE25 3'b000
  `define SZ_HALF25 3'b001
  `define SZ_WORD25 3'b010
 
// HRESP25 transfer25 response signal25 encoding25
  `define RSP_OKAY25  2'b00
  `define RSP_ERROR25 2'b01
  `define RSP_RETRY25 2'b10
  `define RSP_SPLIT25 2'b11 // Not used
 
// SMC25 state machine25 states25
  `define SMC_IDLE25  5'b00001
  `define SMC_LE25    5'b00010
  `define SMC_RW25    5'b00100
  `define SMC_STORE25 5'b01000
  `define SMC_FLOAT25 5'b10000

// Xfer25 Sizes25
  `define XSIZ_825   2'h0
  `define XSIZ_1625  2'h1
  `define XSIZ_3225  2'h2

// Bus25 Sizes25
  `define BSIZ_825   2'h0
  `define BSIZ_1625  2'h1
  `define BSIZ_3225  2'h2
