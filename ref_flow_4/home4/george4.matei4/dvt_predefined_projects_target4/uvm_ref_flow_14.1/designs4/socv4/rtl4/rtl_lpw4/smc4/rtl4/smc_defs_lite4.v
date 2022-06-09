//File4 name   : smc_defs_lite4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR4 12


//----------------------------------------------------------------------------
// Constants4
//----------------------------------------------------------------------------

// HTRANS4 transfer4 type signal4 encoding4
  `define TRN_IDLE4   2'b00
  `define TRN_BUSY4   2'b01
  `define TRN_NONSEQ4 2'b10
  `define TRN_SEQ4    2'b11
 
// HSIZE4 transfer4 type signal4 encoding4
  `define SZ_BYTE4 3'b000
  `define SZ_HALF4 3'b001
  `define SZ_WORD4 3'b010
 
// HRESP4 transfer4 response signal4 encoding4
  `define RSP_OKAY4  2'b00
  `define RSP_ERROR4 2'b01
  `define RSP_RETRY4 2'b10
  `define RSP_SPLIT4 2'b11 // Not used
 
// SMC4 state machine4 states4
  `define SMC_IDLE4  5'b00001
  `define SMC_LE4    5'b00010
  `define SMC_RW4    5'b00100
  `define SMC_STORE4 5'b01000
  `define SMC_FLOAT4 5'b10000

// Xfer4 Sizes4
  `define XSIZ_84   2'h0
  `define XSIZ_164  2'h1
  `define XSIZ_324  2'h2

// Bus4 Sizes4
  `define BSIZ_84   2'h0
  `define BSIZ_164  2'h1
  `define BSIZ_324  2'h2
