//File2 name   : smc_defs_lite2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
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

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR2 12


//----------------------------------------------------------------------------
// Constants2
//----------------------------------------------------------------------------

// HTRANS2 transfer2 type signal2 encoding2
  `define TRN_IDLE2   2'b00
  `define TRN_BUSY2   2'b01
  `define TRN_NONSEQ2 2'b10
  `define TRN_SEQ2    2'b11
 
// HSIZE2 transfer2 type signal2 encoding2
  `define SZ_BYTE2 3'b000
  `define SZ_HALF2 3'b001
  `define SZ_WORD2 3'b010
 
// HRESP2 transfer2 response signal2 encoding2
  `define RSP_OKAY2  2'b00
  `define RSP_ERROR2 2'b01
  `define RSP_RETRY2 2'b10
  `define RSP_SPLIT2 2'b11 // Not used
 
// SMC2 state machine2 states2
  `define SMC_IDLE2  5'b00001
  `define SMC_LE2    5'b00010
  `define SMC_RW2    5'b00100
  `define SMC_STORE2 5'b01000
  `define SMC_FLOAT2 5'b10000

// Xfer2 Sizes2
  `define XSIZ_82   2'h0
  `define XSIZ_162  2'h1
  `define XSIZ_322  2'h2

// Bus2 Sizes2
  `define BSIZ_82   2'h0
  `define BSIZ_162  2'h1
  `define BSIZ_322  2'h2
