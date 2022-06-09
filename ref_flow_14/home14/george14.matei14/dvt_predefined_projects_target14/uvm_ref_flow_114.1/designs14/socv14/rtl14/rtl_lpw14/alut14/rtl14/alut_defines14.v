//File14 name   : alut_defines14.v
//Title14       : 
//Created14     : 1999
//Description14 : 
//Notes14       : 
//----------------------------------------------------------------------
//   Copyright14 1999-2010 Cadence14 Design14 Systems14, Inc14.
//   All Rights14 Reserved14 Worldwide14
//
//   Licensed14 under the Apache14 License14, Version14 2.0 (the
//   "License14"); you may not use this file except14 in
//   compliance14 with the License14.  You may obtain14 a copy of
//   the License14 at
//
//       http14://www14.apache14.org14/licenses14/LICENSE14-2.0
//
//   Unless14 required14 by applicable14 law14 or agreed14 to in
//   writing, software14 distributed14 under the License14 is
//   distributed14 on an "AS14 IS14" BASIS14, WITHOUT14 WARRANTIES14 OR14
//   CONDITIONS14 OF14 ANY14 KIND14, either14 express14 or implied14.  See
//   the License14 for the specific14 language14 governing14
//   permissions14 and limitations14 under the License14.
//----------------------------------------------------------------------

// Define14 the register address constants14 
`define AL_FRM_D_ADDR_L14         7'h00   //
`define AL_FRM_D_ADDR_U14         7'h04   //
`define AL_FRM_S_ADDR_L14         7'h08   //
`define AL_FRM_S_ADDR_U14         7'h0C   //
`define AL_S_PORT14               7'h10   //
`define AL_D_PORT14               7'h14   // read only
`define AL_MAC_ADDR_L14           7'h18   //
`define AL_MAC_ADDR_U14           7'h1C   //
`define AL_CUR_TIME14             7'h20   // read only
`define AL_BB_AGE14               7'h24   //
`define AL_DIV_CLK14              7'h28   //
`define AL_STATUS14               7'h2C   // read only
`define AL_COMMAND14              7'h30   //
`define AL_LST_INV_ADDR_L14       7'h34   // read only
`define AL_LST_INV_ADDR_U14       7'h38   // read only
`define AL_LST_INV_PORT14         7'h3C   // read only
