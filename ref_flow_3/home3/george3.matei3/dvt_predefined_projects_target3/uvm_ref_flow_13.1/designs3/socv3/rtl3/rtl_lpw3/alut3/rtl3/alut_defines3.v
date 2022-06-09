//File3 name   : alut_defines3.v
//Title3       : 
//Created3     : 1999
//Description3 : 
//Notes3       : 
//----------------------------------------------------------------------
//   Copyright3 1999-2010 Cadence3 Design3 Systems3, Inc3.
//   All Rights3 Reserved3 Worldwide3
//
//   Licensed3 under the Apache3 License3, Version3 2.0 (the
//   "License3"); you may not use this file except3 in
//   compliance3 with the License3.  You may obtain3 a copy of
//   the License3 at
//
//       http3://www3.apache3.org3/licenses3/LICENSE3-2.0
//
//   Unless3 required3 by applicable3 law3 or agreed3 to in
//   writing, software3 distributed3 under the License3 is
//   distributed3 on an "AS3 IS3" BASIS3, WITHOUT3 WARRANTIES3 OR3
//   CONDITIONS3 OF3 ANY3 KIND3, either3 express3 or implied3.  See
//   the License3 for the specific3 language3 governing3
//   permissions3 and limitations3 under the License3.
//----------------------------------------------------------------------

// Define3 the register address constants3 
`define AL_FRM_D_ADDR_L3         7'h00   //
`define AL_FRM_D_ADDR_U3         7'h04   //
`define AL_FRM_S_ADDR_L3         7'h08   //
`define AL_FRM_S_ADDR_U3         7'h0C   //
`define AL_S_PORT3               7'h10   //
`define AL_D_PORT3               7'h14   // read only
`define AL_MAC_ADDR_L3           7'h18   //
`define AL_MAC_ADDR_U3           7'h1C   //
`define AL_CUR_TIME3             7'h20   // read only
`define AL_BB_AGE3               7'h24   //
`define AL_DIV_CLK3              7'h28   //
`define AL_STATUS3               7'h2C   // read only
`define AL_COMMAND3              7'h30   //
`define AL_LST_INV_ADDR_L3       7'h34   // read only
`define AL_LST_INV_ADDR_U3       7'h38   // read only
`define AL_LST_INV_PORT3         7'h3C   // read only
