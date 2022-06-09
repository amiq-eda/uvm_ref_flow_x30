//File7 name   : smc_defs_lite7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR7 12


//----------------------------------------------------------------------------
// Constants7
//----------------------------------------------------------------------------

// HTRANS7 transfer7 type signal7 encoding7
  `define TRN_IDLE7   2'b00
  `define TRN_BUSY7   2'b01
  `define TRN_NONSEQ7 2'b10
  `define TRN_SEQ7    2'b11
 
// HSIZE7 transfer7 type signal7 encoding7
  `define SZ_BYTE7 3'b000
  `define SZ_HALF7 3'b001
  `define SZ_WORD7 3'b010
 
// HRESP7 transfer7 response signal7 encoding7
  `define RSP_OKAY7  2'b00
  `define RSP_ERROR7 2'b01
  `define RSP_RETRY7 2'b10
  `define RSP_SPLIT7 2'b11 // Not used
 
// SMC7 state machine7 states7
  `define SMC_IDLE7  5'b00001
  `define SMC_LE7    5'b00010
  `define SMC_RW7    5'b00100
  `define SMC_STORE7 5'b01000
  `define SMC_FLOAT7 5'b10000

// Xfer7 Sizes7
  `define XSIZ_87   2'h0
  `define XSIZ_167  2'h1
  `define XSIZ_327  2'h2

// Bus7 Sizes7
  `define BSIZ_87   2'h0
  `define BSIZ_167  2'h1
  `define BSIZ_327  2'h2
