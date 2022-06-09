//File13 name   : smc_defs_lite13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR13 12


//----------------------------------------------------------------------------
// Constants13
//----------------------------------------------------------------------------

// HTRANS13 transfer13 type signal13 encoding13
  `define TRN_IDLE13   2'b00
  `define TRN_BUSY13   2'b01
  `define TRN_NONSEQ13 2'b10
  `define TRN_SEQ13    2'b11
 
// HSIZE13 transfer13 type signal13 encoding13
  `define SZ_BYTE13 3'b000
  `define SZ_HALF13 3'b001
  `define SZ_WORD13 3'b010
 
// HRESP13 transfer13 response signal13 encoding13
  `define RSP_OKAY13  2'b00
  `define RSP_ERROR13 2'b01
  `define RSP_RETRY13 2'b10
  `define RSP_SPLIT13 2'b11 // Not used
 
// SMC13 state machine13 states13
  `define SMC_IDLE13  5'b00001
  `define SMC_LE13    5'b00010
  `define SMC_RW13    5'b00100
  `define SMC_STORE13 5'b01000
  `define SMC_FLOAT13 5'b10000

// Xfer13 Sizes13
  `define XSIZ_813   2'h0
  `define XSIZ_1613  2'h1
  `define XSIZ_3213  2'h2

// Bus13 Sizes13
  `define BSIZ_813   2'h0
  `define BSIZ_1613  2'h1
  `define BSIZ_3213  2'h2
