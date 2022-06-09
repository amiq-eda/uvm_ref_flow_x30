//File25 name   : alut_defines25.v
//Title25       : 
//Created25     : 1999
//Description25 : 
//Notes25       : 
//----------------------------------------------------------------------
//   Copyright25 1999-2010 Cadence25 Design25 Systems25, Inc25.
//   All Rights25 Reserved25 Worldwide25
//
//   Licensed25 under the Apache25 License25, Version25 2.0 (the
//   "License25"); you may not use this file except25 in
//   compliance25 with the License25.  You may obtain25 a copy of
//   the License25 at
//
//       http25://www25.apache25.org25/licenses25/LICENSE25-2.0
//
//   Unless25 required25 by applicable25 law25 or agreed25 to in
//   writing, software25 distributed25 under the License25 is
//   distributed25 on an "AS25 IS25" BASIS25, WITHOUT25 WARRANTIES25 OR25
//   CONDITIONS25 OF25 ANY25 KIND25, either25 express25 or implied25.  See
//   the License25 for the specific25 language25 governing25
//   permissions25 and limitations25 under the License25.
//----------------------------------------------------------------------

// Define25 the register address constants25 
`define AL_FRM_D_ADDR_L25         7'h00   //
`define AL_FRM_D_ADDR_U25         7'h04   //
`define AL_FRM_S_ADDR_L25         7'h08   //
`define AL_FRM_S_ADDR_U25         7'h0C   //
`define AL_S_PORT25               7'h10   //
`define AL_D_PORT25               7'h14   // read only
`define AL_MAC_ADDR_L25           7'h18   //
`define AL_MAC_ADDR_U25           7'h1C   //
`define AL_CUR_TIME25             7'h20   // read only
`define AL_BB_AGE25               7'h24   //
`define AL_DIV_CLK25              7'h28   //
`define AL_STATUS25               7'h2C   // read only
`define AL_COMMAND25              7'h30   //
`define AL_LST_INV_ADDR_L25       7'h34   // read only
`define AL_LST_INV_ADDR_U25       7'h38   // read only
`define AL_LST_INV_PORT25         7'h3C   // read only
