//File16 name   : alut_defines16.v
//Title16       : 
//Created16     : 1999
//Description16 : 
//Notes16       : 
//----------------------------------------------------------------------
//   Copyright16 1999-2010 Cadence16 Design16 Systems16, Inc16.
//   All Rights16 Reserved16 Worldwide16
//
//   Licensed16 under the Apache16 License16, Version16 2.0 (the
//   "License16"); you may not use this file except16 in
//   compliance16 with the License16.  You may obtain16 a copy of
//   the License16 at
//
//       http16://www16.apache16.org16/licenses16/LICENSE16-2.0
//
//   Unless16 required16 by applicable16 law16 or agreed16 to in
//   writing, software16 distributed16 under the License16 is
//   distributed16 on an "AS16 IS16" BASIS16, WITHOUT16 WARRANTIES16 OR16
//   CONDITIONS16 OF16 ANY16 KIND16, either16 express16 or implied16.  See
//   the License16 for the specific16 language16 governing16
//   permissions16 and limitations16 under the License16.
//----------------------------------------------------------------------

// Define16 the register address constants16 
`define AL_FRM_D_ADDR_L16         7'h00   //
`define AL_FRM_D_ADDR_U16         7'h04   //
`define AL_FRM_S_ADDR_L16         7'h08   //
`define AL_FRM_S_ADDR_U16         7'h0C   //
`define AL_S_PORT16               7'h10   //
`define AL_D_PORT16               7'h14   // read only
`define AL_MAC_ADDR_L16           7'h18   //
`define AL_MAC_ADDR_U16           7'h1C   //
`define AL_CUR_TIME16             7'h20   // read only
`define AL_BB_AGE16               7'h24   //
`define AL_DIV_CLK16              7'h28   //
`define AL_STATUS16               7'h2C   // read only
`define AL_COMMAND16              7'h30   //
`define AL_LST_INV_ADDR_L16       7'h34   // read only
`define AL_LST_INV_ADDR_U16       7'h38   // read only
`define AL_LST_INV_PORT16         7'h3C   // read only
