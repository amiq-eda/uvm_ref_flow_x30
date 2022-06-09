//File30 name   : smc_defs_lite30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR30 12


//----------------------------------------------------------------------------
// Constants30
//----------------------------------------------------------------------------

// HTRANS30 transfer30 type signal30 encoding30
  `define TRN_IDLE30   2'b00
  `define TRN_BUSY30   2'b01
  `define TRN_NONSEQ30 2'b10
  `define TRN_SEQ30    2'b11
 
// HSIZE30 transfer30 type signal30 encoding30
  `define SZ_BYTE30 3'b000
  `define SZ_HALF30 3'b001
  `define SZ_WORD30 3'b010
 
// HRESP30 transfer30 response signal30 encoding30
  `define RSP_OKAY30  2'b00
  `define RSP_ERROR30 2'b01
  `define RSP_RETRY30 2'b10
  `define RSP_SPLIT30 2'b11 // Not used
 
// SMC30 state machine30 states30
  `define SMC_IDLE30  5'b00001
  `define SMC_LE30    5'b00010
  `define SMC_RW30    5'b00100
  `define SMC_STORE30 5'b01000
  `define SMC_FLOAT30 5'b10000

// Xfer30 Sizes30
  `define XSIZ_830   2'h0
  `define XSIZ_1630  2'h1
  `define XSIZ_3230  2'h2

// Bus30 Sizes30
  `define BSIZ_830   2'h0
  `define BSIZ_1630  2'h1
  `define BSIZ_3230  2'h2
