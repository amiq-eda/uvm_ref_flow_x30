//File22 name   : alut_defines22.v
//Title22       : 
//Created22     : 1999
//Description22 : 
//Notes22       : 
//----------------------------------------------------------------------
//   Copyright22 1999-2010 Cadence22 Design22 Systems22, Inc22.
//   All Rights22 Reserved22 Worldwide22
//
//   Licensed22 under the Apache22 License22, Version22 2.0 (the
//   "License22"); you may not use this file except22 in
//   compliance22 with the License22.  You may obtain22 a copy of
//   the License22 at
//
//       http22://www22.apache22.org22/licenses22/LICENSE22-2.0
//
//   Unless22 required22 by applicable22 law22 or agreed22 to in
//   writing, software22 distributed22 under the License22 is
//   distributed22 on an "AS22 IS22" BASIS22, WITHOUT22 WARRANTIES22 OR22
//   CONDITIONS22 OF22 ANY22 KIND22, either22 express22 or implied22.  See
//   the License22 for the specific22 language22 governing22
//   permissions22 and limitations22 under the License22.
//----------------------------------------------------------------------

// Define22 the register address constants22 
`define AL_FRM_D_ADDR_L22         7'h00   //
`define AL_FRM_D_ADDR_U22         7'h04   //
`define AL_FRM_S_ADDR_L22         7'h08   //
`define AL_FRM_S_ADDR_U22         7'h0C   //
`define AL_S_PORT22               7'h10   //
`define AL_D_PORT22               7'h14   // read only
`define AL_MAC_ADDR_L22           7'h18   //
`define AL_MAC_ADDR_U22           7'h1C   //
`define AL_CUR_TIME22             7'h20   // read only
`define AL_BB_AGE22               7'h24   //
`define AL_DIV_CLK22              7'h28   //
`define AL_STATUS22               7'h2C   // read only
`define AL_COMMAND22              7'h30   //
`define AL_LST_INV_ADDR_L22       7'h34   // read only
`define AL_LST_INV_ADDR_U22       7'h38   // read only
`define AL_LST_INV_PORT22         7'h3C   // read only
