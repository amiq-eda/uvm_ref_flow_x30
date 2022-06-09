//File5 name   : smc_defs_lite5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR5 12


//----------------------------------------------------------------------------
// Constants5
//----------------------------------------------------------------------------

// HTRANS5 transfer5 type signal5 encoding5
  `define TRN_IDLE5   2'b00
  `define TRN_BUSY5   2'b01
  `define TRN_NONSEQ5 2'b10
  `define TRN_SEQ5    2'b11
 
// HSIZE5 transfer5 type signal5 encoding5
  `define SZ_BYTE5 3'b000
  `define SZ_HALF5 3'b001
  `define SZ_WORD5 3'b010
 
// HRESP5 transfer5 response signal5 encoding5
  `define RSP_OKAY5  2'b00
  `define RSP_ERROR5 2'b01
  `define RSP_RETRY5 2'b10
  `define RSP_SPLIT5 2'b11 // Not used
 
// SMC5 state machine5 states5
  `define SMC_IDLE5  5'b00001
  `define SMC_LE5    5'b00010
  `define SMC_RW5    5'b00100
  `define SMC_STORE5 5'b01000
  `define SMC_FLOAT5 5'b10000

// Xfer5 Sizes5
  `define XSIZ_85   2'h0
  `define XSIZ_165  2'h1
  `define XSIZ_325  2'h2

// Bus5 Sizes5
  `define BSIZ_85   2'h0
  `define BSIZ_165  2'h1
  `define BSIZ_325  2'h2
