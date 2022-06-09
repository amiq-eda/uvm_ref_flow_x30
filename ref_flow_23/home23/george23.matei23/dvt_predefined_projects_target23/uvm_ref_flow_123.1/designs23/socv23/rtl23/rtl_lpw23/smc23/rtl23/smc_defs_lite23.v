//File23 name   : smc_defs_lite23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR23 12


//----------------------------------------------------------------------------
// Constants23
//----------------------------------------------------------------------------

// HTRANS23 transfer23 type signal23 encoding23
  `define TRN_IDLE23   2'b00
  `define TRN_BUSY23   2'b01
  `define TRN_NONSEQ23 2'b10
  `define TRN_SEQ23    2'b11
 
// HSIZE23 transfer23 type signal23 encoding23
  `define SZ_BYTE23 3'b000
  `define SZ_HALF23 3'b001
  `define SZ_WORD23 3'b010
 
// HRESP23 transfer23 response signal23 encoding23
  `define RSP_OKAY23  2'b00
  `define RSP_ERROR23 2'b01
  `define RSP_RETRY23 2'b10
  `define RSP_SPLIT23 2'b11 // Not used
 
// SMC23 state machine23 states23
  `define SMC_IDLE23  5'b00001
  `define SMC_LE23    5'b00010
  `define SMC_RW23    5'b00100
  `define SMC_STORE23 5'b01000
  `define SMC_FLOAT23 5'b10000

// Xfer23 Sizes23
  `define XSIZ_823   2'h0
  `define XSIZ_1623  2'h1
  `define XSIZ_3223  2'h2

// Bus23 Sizes23
  `define BSIZ_823   2'h0
  `define BSIZ_1623  2'h1
  `define BSIZ_3223  2'h2
