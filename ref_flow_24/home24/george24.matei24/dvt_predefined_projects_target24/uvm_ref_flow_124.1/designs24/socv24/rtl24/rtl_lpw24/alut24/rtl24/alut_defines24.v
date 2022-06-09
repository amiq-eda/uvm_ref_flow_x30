//File24 name   : alut_defines24.v
//Title24       : 
//Created24     : 1999
//Description24 : 
//Notes24       : 
//----------------------------------------------------------------------
//   Copyright24 1999-2010 Cadence24 Design24 Systems24, Inc24.
//   All Rights24 Reserved24 Worldwide24
//
//   Licensed24 under the Apache24 License24, Version24 2.0 (the
//   "License24"); you may not use this file except24 in
//   compliance24 with the License24.  You may obtain24 a copy of
//   the License24 at
//
//       http24://www24.apache24.org24/licenses24/LICENSE24-2.0
//
//   Unless24 required24 by applicable24 law24 or agreed24 to in
//   writing, software24 distributed24 under the License24 is
//   distributed24 on an "AS24 IS24" BASIS24, WITHOUT24 WARRANTIES24 OR24
//   CONDITIONS24 OF24 ANY24 KIND24, either24 express24 or implied24.  See
//   the License24 for the specific24 language24 governing24
//   permissions24 and limitations24 under the License24.
//----------------------------------------------------------------------

// Define24 the register address constants24 
`define AL_FRM_D_ADDR_L24         7'h00   //
`define AL_FRM_D_ADDR_U24         7'h04   //
`define AL_FRM_S_ADDR_L24         7'h08   //
`define AL_FRM_S_ADDR_U24         7'h0C   //
`define AL_S_PORT24               7'h10   //
`define AL_D_PORT24               7'h14   // read only
`define AL_MAC_ADDR_L24           7'h18   //
`define AL_MAC_ADDR_U24           7'h1C   //
`define AL_CUR_TIME24             7'h20   // read only
`define AL_BB_AGE24               7'h24   //
`define AL_DIV_CLK24              7'h28   //
`define AL_STATUS24               7'h2C   // read only
`define AL_COMMAND24              7'h30   //
`define AL_LST_INV_ADDR_L24       7'h34   // read only
`define AL_LST_INV_ADDR_U24       7'h38   // read only
`define AL_LST_INV_PORT24         7'h3C   // read only
