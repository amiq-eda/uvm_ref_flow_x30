//File18 name   : alut_defines18.v
//Title18       : 
//Created18     : 1999
//Description18 : 
//Notes18       : 
//----------------------------------------------------------------------
//   Copyright18 1999-2010 Cadence18 Design18 Systems18, Inc18.
//   All Rights18 Reserved18 Worldwide18
//
//   Licensed18 under the Apache18 License18, Version18 2.0 (the
//   "License18"); you may not use this file except18 in
//   compliance18 with the License18.  You may obtain18 a copy of
//   the License18 at
//
//       http18://www18.apache18.org18/licenses18/LICENSE18-2.0
//
//   Unless18 required18 by applicable18 law18 or agreed18 to in
//   writing, software18 distributed18 under the License18 is
//   distributed18 on an "AS18 IS18" BASIS18, WITHOUT18 WARRANTIES18 OR18
//   CONDITIONS18 OF18 ANY18 KIND18, either18 express18 or implied18.  See
//   the License18 for the specific18 language18 governing18
//   permissions18 and limitations18 under the License18.
//----------------------------------------------------------------------

// Define18 the register address constants18 
`define AL_FRM_D_ADDR_L18         7'h00   //
`define AL_FRM_D_ADDR_U18         7'h04   //
`define AL_FRM_S_ADDR_L18         7'h08   //
`define AL_FRM_S_ADDR_U18         7'h0C   //
`define AL_S_PORT18               7'h10   //
`define AL_D_PORT18               7'h14   // read only
`define AL_MAC_ADDR_L18           7'h18   //
`define AL_MAC_ADDR_U18           7'h1C   //
`define AL_CUR_TIME18             7'h20   // read only
`define AL_BB_AGE18               7'h24   //
`define AL_DIV_CLK18              7'h28   //
`define AL_STATUS18               7'h2C   // read only
`define AL_COMMAND18              7'h30   //
`define AL_LST_INV_ADDR_L18       7'h34   // read only
`define AL_LST_INV_ADDR_U18       7'h38   // read only
`define AL_LST_INV_PORT18         7'h3C   // read only
