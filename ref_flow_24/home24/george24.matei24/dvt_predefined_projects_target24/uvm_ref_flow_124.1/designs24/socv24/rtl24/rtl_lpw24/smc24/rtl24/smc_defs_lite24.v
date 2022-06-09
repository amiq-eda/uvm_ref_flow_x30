//File24 name   : smc_defs_lite24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR24 12


//----------------------------------------------------------------------------
// Constants24
//----------------------------------------------------------------------------

// HTRANS24 transfer24 type signal24 encoding24
  `define TRN_IDLE24   2'b00
  `define TRN_BUSY24   2'b01
  `define TRN_NONSEQ24 2'b10
  `define TRN_SEQ24    2'b11
 
// HSIZE24 transfer24 type signal24 encoding24
  `define SZ_BYTE24 3'b000
  `define SZ_HALF24 3'b001
  `define SZ_WORD24 3'b010
 
// HRESP24 transfer24 response signal24 encoding24
  `define RSP_OKAY24  2'b00
  `define RSP_ERROR24 2'b01
  `define RSP_RETRY24 2'b10
  `define RSP_SPLIT24 2'b11 // Not used
 
// SMC24 state machine24 states24
  `define SMC_IDLE24  5'b00001
  `define SMC_LE24    5'b00010
  `define SMC_RW24    5'b00100
  `define SMC_STORE24 5'b01000
  `define SMC_FLOAT24 5'b10000

// Xfer24 Sizes24
  `define XSIZ_824   2'h0
  `define XSIZ_1624  2'h1
  `define XSIZ_3224  2'h2

// Bus24 Sizes24
  `define BSIZ_824   2'h0
  `define BSIZ_1624  2'h1
  `define BSIZ_3224  2'h2
