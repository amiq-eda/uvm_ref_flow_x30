//File22 name   : smc_defs_lite22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR22 12


//----------------------------------------------------------------------------
// Constants22
//----------------------------------------------------------------------------

// HTRANS22 transfer22 type signal22 encoding22
  `define TRN_IDLE22   2'b00
  `define TRN_BUSY22   2'b01
  `define TRN_NONSEQ22 2'b10
  `define TRN_SEQ22    2'b11
 
// HSIZE22 transfer22 type signal22 encoding22
  `define SZ_BYTE22 3'b000
  `define SZ_HALF22 3'b001
  `define SZ_WORD22 3'b010
 
// HRESP22 transfer22 response signal22 encoding22
  `define RSP_OKAY22  2'b00
  `define RSP_ERROR22 2'b01
  `define RSP_RETRY22 2'b10
  `define RSP_SPLIT22 2'b11 // Not used
 
// SMC22 state machine22 states22
  `define SMC_IDLE22  5'b00001
  `define SMC_LE22    5'b00010
  `define SMC_RW22    5'b00100
  `define SMC_STORE22 5'b01000
  `define SMC_FLOAT22 5'b10000

// Xfer22 Sizes22
  `define XSIZ_822   2'h0
  `define XSIZ_1622  2'h1
  `define XSIZ_3222  2'h2

// Bus22 Sizes22
  `define BSIZ_822   2'h0
  `define BSIZ_1622  2'h1
  `define BSIZ_3222  2'h2
