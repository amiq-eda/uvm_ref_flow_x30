//File27 name   : smc_defs_lite27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR27 12


//----------------------------------------------------------------------------
// Constants27
//----------------------------------------------------------------------------

// HTRANS27 transfer27 type signal27 encoding27
  `define TRN_IDLE27   2'b00
  `define TRN_BUSY27   2'b01
  `define TRN_NONSEQ27 2'b10
  `define TRN_SEQ27    2'b11
 
// HSIZE27 transfer27 type signal27 encoding27
  `define SZ_BYTE27 3'b000
  `define SZ_HALF27 3'b001
  `define SZ_WORD27 3'b010
 
// HRESP27 transfer27 response signal27 encoding27
  `define RSP_OKAY27  2'b00
  `define RSP_ERROR27 2'b01
  `define RSP_RETRY27 2'b10
  `define RSP_SPLIT27 2'b11 // Not used
 
// SMC27 state machine27 states27
  `define SMC_IDLE27  5'b00001
  `define SMC_LE27    5'b00010
  `define SMC_RW27    5'b00100
  `define SMC_STORE27 5'b01000
  `define SMC_FLOAT27 5'b10000

// Xfer27 Sizes27
  `define XSIZ_827   2'h0
  `define XSIZ_1627  2'h1
  `define XSIZ_3227  2'h2

// Bus27 Sizes27
  `define BSIZ_827   2'h0
  `define BSIZ_1627  2'h1
  `define BSIZ_3227  2'h2
