//File10 name   : smc_defs_lite10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR10 12


//----------------------------------------------------------------------------
// Constants10
//----------------------------------------------------------------------------

// HTRANS10 transfer10 type signal10 encoding10
  `define TRN_IDLE10   2'b00
  `define TRN_BUSY10   2'b01
  `define TRN_NONSEQ10 2'b10
  `define TRN_SEQ10    2'b11
 
// HSIZE10 transfer10 type signal10 encoding10
  `define SZ_BYTE10 3'b000
  `define SZ_HALF10 3'b001
  `define SZ_WORD10 3'b010
 
// HRESP10 transfer10 response signal10 encoding10
  `define RSP_OKAY10  2'b00
  `define RSP_ERROR10 2'b01
  `define RSP_RETRY10 2'b10
  `define RSP_SPLIT10 2'b11 // Not used
 
// SMC10 state machine10 states10
  `define SMC_IDLE10  5'b00001
  `define SMC_LE10    5'b00010
  `define SMC_RW10    5'b00100
  `define SMC_STORE10 5'b01000
  `define SMC_FLOAT10 5'b10000

// Xfer10 Sizes10
  `define XSIZ_810   2'h0
  `define XSIZ_1610  2'h1
  `define XSIZ_3210  2'h2

// Bus10 Sizes10
  `define BSIZ_810   2'h0
  `define BSIZ_1610  2'h1
  `define BSIZ_3210  2'h2
