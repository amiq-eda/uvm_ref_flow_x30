//File29 name   : smc_defs_lite29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR29 12


//----------------------------------------------------------------------------
// Constants29
//----------------------------------------------------------------------------

// HTRANS29 transfer29 type signal29 encoding29
  `define TRN_IDLE29   2'b00
  `define TRN_BUSY29   2'b01
  `define TRN_NONSEQ29 2'b10
  `define TRN_SEQ29    2'b11
 
// HSIZE29 transfer29 type signal29 encoding29
  `define SZ_BYTE29 3'b000
  `define SZ_HALF29 3'b001
  `define SZ_WORD29 3'b010
 
// HRESP29 transfer29 response signal29 encoding29
  `define RSP_OKAY29  2'b00
  `define RSP_ERROR29 2'b01
  `define RSP_RETRY29 2'b10
  `define RSP_SPLIT29 2'b11 // Not used
 
// SMC29 state machine29 states29
  `define SMC_IDLE29  5'b00001
  `define SMC_LE29    5'b00010
  `define SMC_RW29    5'b00100
  `define SMC_STORE29 5'b01000
  `define SMC_FLOAT29 5'b10000

// Xfer29 Sizes29
  `define XSIZ_829   2'h0
  `define XSIZ_1629  2'h1
  `define XSIZ_3229  2'h2

// Bus29 Sizes29
  `define BSIZ_829   2'h0
  `define BSIZ_1629  2'h1
  `define BSIZ_3229  2'h2
