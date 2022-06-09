//File16 name   : smc_defs_lite16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR16 12


//----------------------------------------------------------------------------
// Constants16
//----------------------------------------------------------------------------

// HTRANS16 transfer16 type signal16 encoding16
  `define TRN_IDLE16   2'b00
  `define TRN_BUSY16   2'b01
  `define TRN_NONSEQ16 2'b10
  `define TRN_SEQ16    2'b11
 
// HSIZE16 transfer16 type signal16 encoding16
  `define SZ_BYTE16 3'b000
  `define SZ_HALF16 3'b001
  `define SZ_WORD16 3'b010
 
// HRESP16 transfer16 response signal16 encoding16
  `define RSP_OKAY16  2'b00
  `define RSP_ERROR16 2'b01
  `define RSP_RETRY16 2'b10
  `define RSP_SPLIT16 2'b11 // Not used
 
// SMC16 state machine16 states16
  `define SMC_IDLE16  5'b00001
  `define SMC_LE16    5'b00010
  `define SMC_RW16    5'b00100
  `define SMC_STORE16 5'b01000
  `define SMC_FLOAT16 5'b10000

// Xfer16 Sizes16
  `define XSIZ_816   2'h0
  `define XSIZ_1616  2'h1
  `define XSIZ_3216  2'h2

// Bus16 Sizes16
  `define BSIZ_816   2'h0
  `define BSIZ_1616  2'h1
  `define BSIZ_3216  2'h2
