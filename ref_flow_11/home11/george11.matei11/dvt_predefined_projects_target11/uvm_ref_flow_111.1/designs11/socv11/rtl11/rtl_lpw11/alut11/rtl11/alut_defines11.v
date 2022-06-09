//File11 name   : alut_defines11.v
//Title11       : 
//Created11     : 1999
//Description11 : 
//Notes11       : 
//----------------------------------------------------------------------
//   Copyright11 1999-2010 Cadence11 Design11 Systems11, Inc11.
//   All Rights11 Reserved11 Worldwide11
//
//   Licensed11 under the Apache11 License11, Version11 2.0 (the
//   "License11"); you may not use this file except11 in
//   compliance11 with the License11.  You may obtain11 a copy of
//   the License11 at
//
//       http11://www11.apache11.org11/licenses11/LICENSE11-2.0
//
//   Unless11 required11 by applicable11 law11 or agreed11 to in
//   writing, software11 distributed11 under the License11 is
//   distributed11 on an "AS11 IS11" BASIS11, WITHOUT11 WARRANTIES11 OR11
//   CONDITIONS11 OF11 ANY11 KIND11, either11 express11 or implied11.  See
//   the License11 for the specific11 language11 governing11
//   permissions11 and limitations11 under the License11.
//----------------------------------------------------------------------

// Define11 the register address constants11 
`define AL_FRM_D_ADDR_L11         7'h00   //
`define AL_FRM_D_ADDR_U11         7'h04   //
`define AL_FRM_S_ADDR_L11         7'h08   //
`define AL_FRM_S_ADDR_U11         7'h0C   //
`define AL_S_PORT11               7'h10   //
`define AL_D_PORT11               7'h14   // read only
`define AL_MAC_ADDR_L11           7'h18   //
`define AL_MAC_ADDR_U11           7'h1C   //
`define AL_CUR_TIME11             7'h20   // read only
`define AL_BB_AGE11               7'h24   //
`define AL_DIV_CLK11              7'h28   //
`define AL_STATUS11               7'h2C   // read only
`define AL_COMMAND11              7'h30   //
`define AL_LST_INV_ADDR_L11       7'h34   // read only
`define AL_LST_INV_ADDR_U11       7'h38   // read only
`define AL_LST_INV_PORT11         7'h3C   // read only
