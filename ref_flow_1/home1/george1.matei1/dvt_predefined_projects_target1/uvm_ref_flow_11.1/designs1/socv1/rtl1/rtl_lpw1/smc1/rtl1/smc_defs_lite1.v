//File1 name   : smc_defs_lite1.v
//Title1       : 
//Created1     : 1999
//Description1 : 
//Notes1       : 
//----------------------------------------------------------------------
//   Copyright1 1999-2010 Cadence1 Design1 Systems1, Inc1.
//   All Rights1 Reserved1 Worldwide1
//
//   Licensed1 under the Apache1 License1, Version1 2.0 (the
//   "License1"); you may not use this file except1 in
//   compliance1 with the License1.  You may obtain1 a copy of
//   the License1 at
//
//       http1://www1.apache1.org1/licenses1/LICENSE1-2.0
//
//   Unless1 required1 by applicable1 law1 or agreed1 to in
//   writing, software1 distributed1 under the License1 is
//   distributed1 on an "AS1 IS1" BASIS1, WITHOUT1 WARRANTIES1 OR1
//   CONDITIONS1 OF1 ANY1 KIND1, either1 express1 or implied1.  See
//   the License1 for the specific1 language1 governing1
//   permissions1 and limitations1 under the License1.
//----------------------------------------------------------------------

//----------------------------------------------------------------------------

`define DEFINE_SMC_ADDR1 12


//----------------------------------------------------------------------------
// Constants1
//----------------------------------------------------------------------------

// HTRANS1 transfer1 type signal1 encoding1
  `define TRN_IDLE1   2'b00
  `define TRN_BUSY1   2'b01
  `define TRN_NONSEQ1 2'b10
  `define TRN_SEQ1    2'b11
 
// HSIZE1 transfer1 type signal1 encoding1
  `define SZ_BYTE1 3'b000
  `define SZ_HALF1 3'b001
  `define SZ_WORD1 3'b010
 
// HRESP1 transfer1 response signal1 encoding1
  `define RSP_OKAY1  2'b00
  `define RSP_ERROR1 2'b01
  `define RSP_RETRY1 2'b10
  `define RSP_SPLIT1 2'b11 // Not used
 
// SMC1 state machine1 states1
  `define SMC_IDLE1  5'b00001
  `define SMC_LE1    5'b00010
  `define SMC_RW1    5'b00100
  `define SMC_STORE1 5'b01000
  `define SMC_FLOAT1 5'b10000

// Xfer1 Sizes1
  `define XSIZ_81   2'h0
  `define XSIZ_161  2'h1
  `define XSIZ_321  2'h2

// Bus1 Sizes1
  `define BSIZ_81   2'h0
  `define BSIZ_161  2'h1
  `define BSIZ_321  2'h2
