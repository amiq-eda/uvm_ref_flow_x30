//File21 name   : smc_defs_lite21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR21 12


//----------------------------------------------------------------------------
// Constants21
//----------------------------------------------------------------------------

// HTRANS21 transfer21 type signal21 encoding21
  `define TRN_IDLE21   2'b00
  `define TRN_BUSY21   2'b01
  `define TRN_NONSEQ21 2'b10
  `define TRN_SEQ21    2'b11
 
// HSIZE21 transfer21 type signal21 encoding21
  `define SZ_BYTE21 3'b000
  `define SZ_HALF21 3'b001
  `define SZ_WORD21 3'b010
 
// HRESP21 transfer21 response signal21 encoding21
  `define RSP_OKAY21  2'b00
  `define RSP_ERROR21 2'b01
  `define RSP_RETRY21 2'b10
  `define RSP_SPLIT21 2'b11 // Not used
 
// SMC21 state machine21 states21
  `define SMC_IDLE21  5'b00001
  `define SMC_LE21    5'b00010
  `define SMC_RW21    5'b00100
  `define SMC_STORE21 5'b01000
  `define SMC_FLOAT21 5'b10000

// Xfer21 Sizes21
  `define XSIZ_821   2'h0
  `define XSIZ_1621  2'h1
  `define XSIZ_3221  2'h2

// Bus21 Sizes21
  `define BSIZ_821   2'h0
  `define BSIZ_1621  2'h1
  `define BSIZ_3221  2'h2
