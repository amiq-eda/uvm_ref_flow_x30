//File11 name   : smc_defs_lite11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR11 12


//----------------------------------------------------------------------------
// Constants11
//----------------------------------------------------------------------------

// HTRANS11 transfer11 type signal11 encoding11
  `define TRN_IDLE11   2'b00
  `define TRN_BUSY11   2'b01
  `define TRN_NONSEQ11 2'b10
  `define TRN_SEQ11    2'b11
 
// HSIZE11 transfer11 type signal11 encoding11
  `define SZ_BYTE11 3'b000
  `define SZ_HALF11 3'b001
  `define SZ_WORD11 3'b010
 
// HRESP11 transfer11 response signal11 encoding11
  `define RSP_OKAY11  2'b00
  `define RSP_ERROR11 2'b01
  `define RSP_RETRY11 2'b10
  `define RSP_SPLIT11 2'b11 // Not used
 
// SMC11 state machine11 states11
  `define SMC_IDLE11  5'b00001
  `define SMC_LE11    5'b00010
  `define SMC_RW11    5'b00100
  `define SMC_STORE11 5'b01000
  `define SMC_FLOAT11 5'b10000

// Xfer11 Sizes11
  `define XSIZ_811   2'h0
  `define XSIZ_1611  2'h1
  `define XSIZ_3211  2'h2

// Bus11 Sizes11
  `define BSIZ_811   2'h0
  `define BSIZ_1611  2'h1
  `define BSIZ_3211  2'h2
