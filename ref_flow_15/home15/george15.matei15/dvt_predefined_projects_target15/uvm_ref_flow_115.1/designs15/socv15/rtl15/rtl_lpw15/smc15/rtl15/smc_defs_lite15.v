//File15 name   : smc_defs_lite15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR15 12


//----------------------------------------------------------------------------
// Constants15
//----------------------------------------------------------------------------

// HTRANS15 transfer15 type signal15 encoding15
  `define TRN_IDLE15   2'b00
  `define TRN_BUSY15   2'b01
  `define TRN_NONSEQ15 2'b10
  `define TRN_SEQ15    2'b11
 
// HSIZE15 transfer15 type signal15 encoding15
  `define SZ_BYTE15 3'b000
  `define SZ_HALF15 3'b001
  `define SZ_WORD15 3'b010
 
// HRESP15 transfer15 response signal15 encoding15
  `define RSP_OKAY15  2'b00
  `define RSP_ERROR15 2'b01
  `define RSP_RETRY15 2'b10
  `define RSP_SPLIT15 2'b11 // Not used
 
// SMC15 state machine15 states15
  `define SMC_IDLE15  5'b00001
  `define SMC_LE15    5'b00010
  `define SMC_RW15    5'b00100
  `define SMC_STORE15 5'b01000
  `define SMC_FLOAT15 5'b10000

// Xfer15 Sizes15
  `define XSIZ_815   2'h0
  `define XSIZ_1615  2'h1
  `define XSIZ_3215  2'h2

// Bus15 Sizes15
  `define BSIZ_815   2'h0
  `define BSIZ_1615  2'h1
  `define BSIZ_3215  2'h2
