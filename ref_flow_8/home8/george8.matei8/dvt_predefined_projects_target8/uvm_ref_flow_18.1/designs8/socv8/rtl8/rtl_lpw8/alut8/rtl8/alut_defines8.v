//File8 name   : alut_defines8.v
//Title8       : 
//Created8     : 1999
//Description8 : 
//Notes8       : 
//----------------------------------------------------------------------
//   Copyright8 1999-2010 Cadence8 Design8 Systems8, Inc8.
//   All Rights8 Reserved8 Worldwide8
//
//   Licensed8 under the Apache8 License8, Version8 2.0 (the
//   "License8"); you may not use this file except8 in
//   compliance8 with the License8.  You may obtain8 a copy of
//   the License8 at
//
//       http8://www8.apache8.org8/licenses8/LICENSE8-2.0
//
//   Unless8 required8 by applicable8 law8 or agreed8 to in
//   writing, software8 distributed8 under the License8 is
//   distributed8 on an "AS8 IS8" BASIS8, WITHOUT8 WARRANTIES8 OR8
//   CONDITIONS8 OF8 ANY8 KIND8, either8 express8 or implied8.  See
//   the License8 for the specific8 language8 governing8
//   permissions8 and limitations8 under the License8.
//----------------------------------------------------------------------

// Define8 the register address constants8 
`define AL_FRM_D_ADDR_L8         7'h00   //
`define AL_FRM_D_ADDR_U8         7'h04   //
`define AL_FRM_S_ADDR_L8         7'h08   //
`define AL_FRM_S_ADDR_U8         7'h0C   //
`define AL_S_PORT8               7'h10   //
`define AL_D_PORT8               7'h14   // read only
`define AL_MAC_ADDR_L8           7'h18   //
`define AL_MAC_ADDR_U8           7'h1C   //
`define AL_CUR_TIME8             7'h20   // read only
`define AL_BB_AGE8               7'h24   //
`define AL_DIV_CLK8              7'h28   //
`define AL_STATUS8               7'h2C   // read only
`define AL_COMMAND8              7'h30   //
`define AL_LST_INV_ADDR_L8       7'h34   // read only
`define AL_LST_INV_ADDR_U8       7'h38   // read only
`define AL_LST_INV_PORT8         7'h3C   // read only
