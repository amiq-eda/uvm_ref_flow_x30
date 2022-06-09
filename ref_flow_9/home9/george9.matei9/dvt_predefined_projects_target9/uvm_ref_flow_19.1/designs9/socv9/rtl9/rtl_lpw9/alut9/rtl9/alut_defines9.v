//File9 name   : alut_defines9.v
//Title9       : 
//Created9     : 1999
//Description9 : 
//Notes9       : 
//----------------------------------------------------------------------
//   Copyright9 1999-2010 Cadence9 Design9 Systems9, Inc9.
//   All Rights9 Reserved9 Worldwide9
//
//   Licensed9 under the Apache9 License9, Version9 2.0 (the
//   "License9"); you may not use this file except9 in
//   compliance9 with the License9.  You may obtain9 a copy of
//   the License9 at
//
//       http9://www9.apache9.org9/licenses9/LICENSE9-2.0
//
//   Unless9 required9 by applicable9 law9 or agreed9 to in
//   writing, software9 distributed9 under the License9 is
//   distributed9 on an "AS9 IS9" BASIS9, WITHOUT9 WARRANTIES9 OR9
//   CONDITIONS9 OF9 ANY9 KIND9, either9 express9 or implied9.  See
//   the License9 for the specific9 language9 governing9
//   permissions9 and limitations9 under the License9.
//----------------------------------------------------------------------

// Define9 the register address constants9 
`define AL_FRM_D_ADDR_L9         7'h00   //
`define AL_FRM_D_ADDR_U9         7'h04   //
`define AL_FRM_S_ADDR_L9         7'h08   //
`define AL_FRM_S_ADDR_U9         7'h0C   //
`define AL_S_PORT9               7'h10   //
`define AL_D_PORT9               7'h14   // read only
`define AL_MAC_ADDR_L9           7'h18   //
`define AL_MAC_ADDR_U9           7'h1C   //
`define AL_CUR_TIME9             7'h20   // read only
`define AL_BB_AGE9               7'h24   //
`define AL_DIV_CLK9              7'h28   //
`define AL_STATUS9               7'h2C   // read only
`define AL_COMMAND9              7'h30   //
`define AL_LST_INV_ADDR_L9       7'h34   // read only
`define AL_LST_INV_ADDR_U9       7'h38   // read only
`define AL_LST_INV_PORT9         7'h3C   // read only
