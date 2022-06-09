//File20 name   : smc_defs_lite20.v
//Title20       : 
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR20 12


//----------------------------------------------------------------------------
// Constants20
//----------------------------------------------------------------------------

// HTRANS20 transfer20 type signal20 encoding20
  `define TRN_IDLE20   2'b00
  `define TRN_BUSY20   2'b01
  `define TRN_NONSEQ20 2'b10
  `define TRN_SEQ20    2'b11
 
// HSIZE20 transfer20 type signal20 encoding20
  `define SZ_BYTE20 3'b000
  `define SZ_HALF20 3'b001
  `define SZ_WORD20 3'b010
 
// HRESP20 transfer20 response signal20 encoding20
  `define RSP_OKAY20  2'b00
  `define RSP_ERROR20 2'b01
  `define RSP_RETRY20 2'b10
  `define RSP_SPLIT20 2'b11 // Not used
 
// SMC20 state machine20 states20
  `define SMC_IDLE20  5'b00001
  `define SMC_LE20    5'b00010
  `define SMC_RW20    5'b00100
  `define SMC_STORE20 5'b01000
  `define SMC_FLOAT20 5'b10000

// Xfer20 Sizes20
  `define XSIZ_820   2'h0
  `define XSIZ_1620  2'h1
  `define XSIZ_3220  2'h2

// Bus20 Sizes20
  `define BSIZ_820   2'h0
  `define BSIZ_1620  2'h1
  `define BSIZ_3220  2'h2
