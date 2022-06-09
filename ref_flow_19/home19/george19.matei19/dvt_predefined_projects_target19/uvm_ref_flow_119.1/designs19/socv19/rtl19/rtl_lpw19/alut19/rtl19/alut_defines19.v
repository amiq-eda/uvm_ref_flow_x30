//File19 name   : alut_defines19.v
//Title19       : 
//Created19     : 1999
//Description19 : 
//Notes19       : 
//----------------------------------------------------------------------
//   Copyright19 1999-2010 Cadence19 Design19 Systems19, Inc19.
//   All Rights19 Reserved19 Worldwide19
//
//   Licensed19 under the Apache19 License19, Version19 2.0 (the
//   "License19"); you may not use this file except19 in
//   compliance19 with the License19.  You may obtain19 a copy of
//   the License19 at
//
//       http19://www19.apache19.org19/licenses19/LICENSE19-2.0
//
//   Unless19 required19 by applicable19 law19 or agreed19 to in
//   writing, software19 distributed19 under the License19 is
//   distributed19 on an "AS19 IS19" BASIS19, WITHOUT19 WARRANTIES19 OR19
//   CONDITIONS19 OF19 ANY19 KIND19, either19 express19 or implied19.  See
//   the License19 for the specific19 language19 governing19
//   permissions19 and limitations19 under the License19.
//----------------------------------------------------------------------

// Define19 the register address constants19 
`define AL_FRM_D_ADDR_L19         7'h00   //
`define AL_FRM_D_ADDR_U19         7'h04   //
`define AL_FRM_S_ADDR_L19         7'h08   //
`define AL_FRM_S_ADDR_U19         7'h0C   //
`define AL_S_PORT19               7'h10   //
`define AL_D_PORT19               7'h14   // read only
`define AL_MAC_ADDR_L19           7'h18   //
`define AL_MAC_ADDR_U19           7'h1C   //
`define AL_CUR_TIME19             7'h20   // read only
`define AL_BB_AGE19               7'h24   //
`define AL_DIV_CLK19              7'h28   //
`define AL_STATUS19               7'h2C   // read only
`define AL_COMMAND19              7'h30   //
`define AL_LST_INV_ADDR_L19       7'h34   // read only
`define AL_LST_INV_ADDR_U19       7'h38   // read only
`define AL_LST_INV_PORT19         7'h3C   // read only
