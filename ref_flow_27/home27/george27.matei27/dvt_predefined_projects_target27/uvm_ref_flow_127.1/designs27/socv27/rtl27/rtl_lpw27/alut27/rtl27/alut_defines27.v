//File27 name   : alut_defines27.v
//Title27       : 
//Created27     : 1999
//Description27 : 
//Notes27       : 
//----------------------------------------------------------------------
//   Copyright27 1999-2010 Cadence27 Design27 Systems27, Inc27.
//   All Rights27 Reserved27 Worldwide27
//
//   Licensed27 under the Apache27 License27, Version27 2.0 (the
//   "License27"); you may not use this file except27 in
//   compliance27 with the License27.  You may obtain27 a copy of
//   the License27 at
//
//       http27://www27.apache27.org27/licenses27/LICENSE27-2.0
//
//   Unless27 required27 by applicable27 law27 or agreed27 to in
//   writing, software27 distributed27 under the License27 is
//   distributed27 on an "AS27 IS27" BASIS27, WITHOUT27 WARRANTIES27 OR27
//   CONDITIONS27 OF27 ANY27 KIND27, either27 express27 or implied27.  See
//   the License27 for the specific27 language27 governing27
//   permissions27 and limitations27 under the License27.
//----------------------------------------------------------------------

// Define27 the register address constants27 
`define AL_FRM_D_ADDR_L27         7'h00   //
`define AL_FRM_D_ADDR_U27         7'h04   //
`define AL_FRM_S_ADDR_L27         7'h08   //
`define AL_FRM_S_ADDR_U27         7'h0C   //
`define AL_S_PORT27               7'h10   //
`define AL_D_PORT27               7'h14   // read only
`define AL_MAC_ADDR_L27           7'h18   //
`define AL_MAC_ADDR_U27           7'h1C   //
`define AL_CUR_TIME27             7'h20   // read only
`define AL_BB_AGE27               7'h24   //
`define AL_DIV_CLK27              7'h28   //
`define AL_STATUS27               7'h2C   // read only
`define AL_COMMAND27              7'h30   //
`define AL_LST_INV_ADDR_L27       7'h34   // read only
`define AL_LST_INV_ADDR_U27       7'h38   // read only
`define AL_LST_INV_PORT27         7'h3C   // read only
