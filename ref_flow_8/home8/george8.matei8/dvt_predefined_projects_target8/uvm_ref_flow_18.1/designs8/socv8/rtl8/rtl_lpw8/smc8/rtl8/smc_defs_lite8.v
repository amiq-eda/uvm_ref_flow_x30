//File8 name   : smc_defs_lite8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR8 12


//----------------------------------------------------------------------------
// Constants8
//----------------------------------------------------------------------------

// HTRANS8 transfer8 type signal8 encoding8
  `define TRN_IDLE8   2'b00
  `define TRN_BUSY8   2'b01
  `define TRN_NONSEQ8 2'b10
  `define TRN_SEQ8    2'b11
 
// HSIZE8 transfer8 type signal8 encoding8
  `define SZ_BYTE8 3'b000
  `define SZ_HALF8 3'b001
  `define SZ_WORD8 3'b010
 
// HRESP8 transfer8 response signal8 encoding8
  `define RSP_OKAY8  2'b00
  `define RSP_ERROR8 2'b01
  `define RSP_RETRY8 2'b10
  `define RSP_SPLIT8 2'b11 // Not used
 
// SMC8 state machine8 states8
  `define SMC_IDLE8  5'b00001
  `define SMC_LE8    5'b00010
  `define SMC_RW8    5'b00100
  `define SMC_STORE8 5'b01000
  `define SMC_FLOAT8 5'b10000

// Xfer8 Sizes8
  `define XSIZ_88   2'h0
  `define XSIZ_168  2'h1
  `define XSIZ_328  2'h2

// Bus8 Sizes8
  `define BSIZ_88   2'h0
  `define BSIZ_168  2'h1
  `define BSIZ_328  2'h2
