//File28 name   : smc_defs_lite28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR28 12


//----------------------------------------------------------------------------
// Constants28
//----------------------------------------------------------------------------

// HTRANS28 transfer28 type signal28 encoding28
  `define TRN_IDLE28   2'b00
  `define TRN_BUSY28   2'b01
  `define TRN_NONSEQ28 2'b10
  `define TRN_SEQ28    2'b11
 
// HSIZE28 transfer28 type signal28 encoding28
  `define SZ_BYTE28 3'b000
  `define SZ_HALF28 3'b001
  `define SZ_WORD28 3'b010
 
// HRESP28 transfer28 response signal28 encoding28
  `define RSP_OKAY28  2'b00
  `define RSP_ERROR28 2'b01
  `define RSP_RETRY28 2'b10
  `define RSP_SPLIT28 2'b11 // Not used
 
// SMC28 state machine28 states28
  `define SMC_IDLE28  5'b00001
  `define SMC_LE28    5'b00010
  `define SMC_RW28    5'b00100
  `define SMC_STORE28 5'b01000
  `define SMC_FLOAT28 5'b10000

// Xfer28 Sizes28
  `define XSIZ_828   2'h0
  `define XSIZ_1628  2'h1
  `define XSIZ_3228  2'h2

// Bus28 Sizes28
  `define BSIZ_828   2'h0
  `define BSIZ_1628  2'h1
  `define BSIZ_3228  2'h2
