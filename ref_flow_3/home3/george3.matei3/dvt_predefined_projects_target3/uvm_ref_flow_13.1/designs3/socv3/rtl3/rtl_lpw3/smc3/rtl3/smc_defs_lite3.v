//File3 name   : smc_defs_lite3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR3 12


//----------------------------------------------------------------------------
// Constants3
//----------------------------------------------------------------------------

// HTRANS3 transfer3 type signal3 encoding3
  `define TRN_IDLE3   2'b00
  `define TRN_BUSY3   2'b01
  `define TRN_NONSEQ3 2'b10
  `define TRN_SEQ3    2'b11
 
// HSIZE3 transfer3 type signal3 encoding3
  `define SZ_BYTE3 3'b000
  `define SZ_HALF3 3'b001
  `define SZ_WORD3 3'b010
 
// HRESP3 transfer3 response signal3 encoding3
  `define RSP_OKAY3  2'b00
  `define RSP_ERROR3 2'b01
  `define RSP_RETRY3 2'b10
  `define RSP_SPLIT3 2'b11 // Not used
 
// SMC3 state machine3 states3
  `define SMC_IDLE3  5'b00001
  `define SMC_LE3    5'b00010
  `define SMC_RW3    5'b00100
  `define SMC_STORE3 5'b01000
  `define SMC_FLOAT3 5'b10000

// Xfer3 Sizes3
  `define XSIZ_83   2'h0
  `define XSIZ_163  2'h1
  `define XSIZ_323  2'h2

// Bus3 Sizes3
  `define BSIZ_83   2'h0
  `define BSIZ_163  2'h1
  `define BSIZ_323  2'h2
