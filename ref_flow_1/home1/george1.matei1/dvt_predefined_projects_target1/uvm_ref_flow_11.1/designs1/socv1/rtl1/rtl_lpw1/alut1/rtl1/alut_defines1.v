//File1 name   : alut_defines1.v
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

// Define1 the register address constants1 
`define AL_FRM_D_ADDR_L1         7'h00   //
`define AL_FRM_D_ADDR_U1         7'h04   //
`define AL_FRM_S_ADDR_L1         7'h08   //
`define AL_FRM_S_ADDR_U1         7'h0C   //
`define AL_S_PORT1               7'h10   //
`define AL_D_PORT1               7'h14   // read only
`define AL_MAC_ADDR_L1           7'h18   //
`define AL_MAC_ADDR_U1           7'h1C   //
`define AL_CUR_TIME1             7'h20   // read only
`define AL_BB_AGE1               7'h24   //
`define AL_DIV_CLK1              7'h28   //
`define AL_STATUS1               7'h2C   // read only
`define AL_COMMAND1              7'h30   //
`define AL_LST_INV_ADDR_L1       7'h34   // read only
`define AL_LST_INV_ADDR_U1       7'h38   // read only
`define AL_LST_INV_PORT1         7'h3C   // read only
