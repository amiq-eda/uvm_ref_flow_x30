//File18 name   : smc_defs_lite18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR18 12


//----------------------------------------------------------------------------
// Constants18
//----------------------------------------------------------------------------

// HTRANS18 transfer18 type signal18 encoding18
  `define TRN_IDLE18   2'b00
  `define TRN_BUSY18   2'b01
  `define TRN_NONSEQ18 2'b10
  `define TRN_SEQ18    2'b11
 
// HSIZE18 transfer18 type signal18 encoding18
  `define SZ_BYTE18 3'b000
  `define SZ_HALF18 3'b001
  `define SZ_WORD18 3'b010
 
// HRESP18 transfer18 response signal18 encoding18
  `define RSP_OKAY18  2'b00
  `define RSP_ERROR18 2'b01
  `define RSP_RETRY18 2'b10
  `define RSP_SPLIT18 2'b11 // Not used
 
// SMC18 state machine18 states18
  `define SMC_IDLE18  5'b00001
  `define SMC_LE18    5'b00010
  `define SMC_RW18    5'b00100
  `define SMC_STORE18 5'b01000
  `define SMC_FLOAT18 5'b10000

// Xfer18 Sizes18
  `define XSIZ_818   2'h0
  `define XSIZ_1618  2'h1
  `define XSIZ_3218  2'h2

// Bus18 Sizes18
  `define BSIZ_818   2'h0
  `define BSIZ_1618  2'h1
  `define BSIZ_3218  2'h2
