//File26 name   : smc_defs_lite26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR26 12


//----------------------------------------------------------------------------
// Constants26
//----------------------------------------------------------------------------

// HTRANS26 transfer26 type signal26 encoding26
  `define TRN_IDLE26   2'b00
  `define TRN_BUSY26   2'b01
  `define TRN_NONSEQ26 2'b10
  `define TRN_SEQ26    2'b11
 
// HSIZE26 transfer26 type signal26 encoding26
  `define SZ_BYTE26 3'b000
  `define SZ_HALF26 3'b001
  `define SZ_WORD26 3'b010
 
// HRESP26 transfer26 response signal26 encoding26
  `define RSP_OKAY26  2'b00
  `define RSP_ERROR26 2'b01
  `define RSP_RETRY26 2'b10
  `define RSP_SPLIT26 2'b11 // Not used
 
// SMC26 state machine26 states26
  `define SMC_IDLE26  5'b00001
  `define SMC_LE26    5'b00010
  `define SMC_RW26    5'b00100
  `define SMC_STORE26 5'b01000
  `define SMC_FLOAT26 5'b10000

// Xfer26 Sizes26
  `define XSIZ_826   2'h0
  `define XSIZ_1626  2'h1
  `define XSIZ_3226  2'h2

// Bus26 Sizes26
  `define BSIZ_826   2'h0
  `define BSIZ_1626  2'h1
  `define BSIZ_3226  2'h2
