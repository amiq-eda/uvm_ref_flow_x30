//File12 name   : smc_defs_lite12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR12 12


//----------------------------------------------------------------------------
// Constants12
//----------------------------------------------------------------------------

// HTRANS12 transfer12 type signal12 encoding12
  `define TRN_IDLE12   2'b00
  `define TRN_BUSY12   2'b01
  `define TRN_NONSEQ12 2'b10
  `define TRN_SEQ12    2'b11
 
// HSIZE12 transfer12 type signal12 encoding12
  `define SZ_BYTE12 3'b000
  `define SZ_HALF12 3'b001
  `define SZ_WORD12 3'b010
 
// HRESP12 transfer12 response signal12 encoding12
  `define RSP_OKAY12  2'b00
  `define RSP_ERROR12 2'b01
  `define RSP_RETRY12 2'b10
  `define RSP_SPLIT12 2'b11 // Not used
 
// SMC12 state machine12 states12
  `define SMC_IDLE12  5'b00001
  `define SMC_LE12    5'b00010
  `define SMC_RW12    5'b00100
  `define SMC_STORE12 5'b01000
  `define SMC_FLOAT12 5'b10000

// Xfer12 Sizes12
  `define XSIZ_812   2'h0
  `define XSIZ_1612  2'h1
  `define XSIZ_3212  2'h2

// Bus12 Sizes12
  `define BSIZ_812   2'h0
  `define BSIZ_1612  2'h1
  `define BSIZ_3212  2'h2
