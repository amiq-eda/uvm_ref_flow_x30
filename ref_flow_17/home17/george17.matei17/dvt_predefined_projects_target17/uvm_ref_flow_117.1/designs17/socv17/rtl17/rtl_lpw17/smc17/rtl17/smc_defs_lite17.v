//File17 name   : smc_defs_lite17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR17 12


//----------------------------------------------------------------------------
// Constants17
//----------------------------------------------------------------------------

// HTRANS17 transfer17 type signal17 encoding17
  `define TRN_IDLE17   2'b00
  `define TRN_BUSY17   2'b01
  `define TRN_NONSEQ17 2'b10
  `define TRN_SEQ17    2'b11
 
// HSIZE17 transfer17 type signal17 encoding17
  `define SZ_BYTE17 3'b000
  `define SZ_HALF17 3'b001
  `define SZ_WORD17 3'b010
 
// HRESP17 transfer17 response signal17 encoding17
  `define RSP_OKAY17  2'b00
  `define RSP_ERROR17 2'b01
  `define RSP_RETRY17 2'b10
  `define RSP_SPLIT17 2'b11 // Not used
 
// SMC17 state machine17 states17
  `define SMC_IDLE17  5'b00001
  `define SMC_LE17    5'b00010
  `define SMC_RW17    5'b00100
  `define SMC_STORE17 5'b01000
  `define SMC_FLOAT17 5'b10000

// Xfer17 Sizes17
  `define XSIZ_817   2'h0
  `define XSIZ_1617  2'h1
  `define XSIZ_3217  2'h2

// Bus17 Sizes17
  `define BSIZ_817   2'h0
  `define BSIZ_1617  2'h1
  `define BSIZ_3217  2'h2
