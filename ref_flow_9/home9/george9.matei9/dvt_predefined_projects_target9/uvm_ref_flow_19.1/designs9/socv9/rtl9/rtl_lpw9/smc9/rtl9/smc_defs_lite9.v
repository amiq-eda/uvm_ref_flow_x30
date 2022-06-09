//File9 name   : smc_defs_lite9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR9 12


//----------------------------------------------------------------------------
// Constants9
//----------------------------------------------------------------------------

// HTRANS9 transfer9 type signal9 encoding9
  `define TRN_IDLE9   2'b00
  `define TRN_BUSY9   2'b01
  `define TRN_NONSEQ9 2'b10
  `define TRN_SEQ9    2'b11
 
// HSIZE9 transfer9 type signal9 encoding9
  `define SZ_BYTE9 3'b000
  `define SZ_HALF9 3'b001
  `define SZ_WORD9 3'b010
 
// HRESP9 transfer9 response signal9 encoding9
  `define RSP_OKAY9  2'b00
  `define RSP_ERROR9 2'b01
  `define RSP_RETRY9 2'b10
  `define RSP_SPLIT9 2'b11 // Not used
 
// SMC9 state machine9 states9
  `define SMC_IDLE9  5'b00001
  `define SMC_LE9    5'b00010
  `define SMC_RW9    5'b00100
  `define SMC_STORE9 5'b01000
  `define SMC_FLOAT9 5'b10000

// Xfer9 Sizes9
  `define XSIZ_89   2'h0
  `define XSIZ_169  2'h1
  `define XSIZ_329  2'h2

// Bus9 Sizes9
  `define BSIZ_89   2'h0
  `define BSIZ_169  2'h1
  `define BSIZ_329  2'h2
