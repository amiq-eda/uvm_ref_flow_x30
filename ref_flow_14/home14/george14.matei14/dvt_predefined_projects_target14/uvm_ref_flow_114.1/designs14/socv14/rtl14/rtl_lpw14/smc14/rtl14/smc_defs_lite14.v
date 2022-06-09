//File14 name   : smc_defs_lite14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR14 12


//----------------------------------------------------------------------------
// Constants14
//----------------------------------------------------------------------------

// HTRANS14 transfer14 type signal14 encoding14
  `define TRN_IDLE14   2'b00
  `define TRN_BUSY14   2'b01
  `define TRN_NONSEQ14 2'b10
  `define TRN_SEQ14    2'b11
 
// HSIZE14 transfer14 type signal14 encoding14
  `define SZ_BYTE14 3'b000
  `define SZ_HALF14 3'b001
  `define SZ_WORD14 3'b010
 
// HRESP14 transfer14 response signal14 encoding14
  `define RSP_OKAY14  2'b00
  `define RSP_ERROR14 2'b01
  `define RSP_RETRY14 2'b10
  `define RSP_SPLIT14 2'b11 // Not used
 
// SMC14 state machine14 states14
  `define SMC_IDLE14  5'b00001
  `define SMC_LE14    5'b00010
  `define SMC_RW14    5'b00100
  `define SMC_STORE14 5'b01000
  `define SMC_FLOAT14 5'b10000

// Xfer14 Sizes14
  `define XSIZ_814   2'h0
  `define XSIZ_1614  2'h1
  `define XSIZ_3214  2'h2

// Bus14 Sizes14
  `define BSIZ_814   2'h0
  `define BSIZ_1614  2'h1
  `define BSIZ_3214  2'h2
