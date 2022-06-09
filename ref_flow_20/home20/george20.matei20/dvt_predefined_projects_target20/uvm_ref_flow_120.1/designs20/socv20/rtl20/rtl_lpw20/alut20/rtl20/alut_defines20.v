//File20 name   : alut_defines20.v
//Title20       : 
//Created20     : 1999
//Description20 : 
//Notes20       : 
//----------------------------------------------------------------------
//   Copyright20 1999-2010 Cadence20 Design20 Systems20, Inc20.
//   All Rights20 Reserved20 Worldwide20
//
//   Licensed20 under the Apache20 License20, Version20 2.0 (the
//   "License20"); you may not use this file except20 in
//   compliance20 with the License20.  You may obtain20 a copy of
//   the License20 at
//
//       http20://www20.apache20.org20/licenses20/LICENSE20-2.0
//
//   Unless20 required20 by applicable20 law20 or agreed20 to in
//   writing, software20 distributed20 under the License20 is
//   distributed20 on an "AS20 IS20" BASIS20, WITHOUT20 WARRANTIES20 OR20
//   CONDITIONS20 OF20 ANY20 KIND20, either20 express20 or implied20.  See
//   the License20 for the specific20 language20 governing20
//   permissions20 and limitations20 under the License20.
//----------------------------------------------------------------------

// Define20 the register address constants20 
`define AL_FRM_D_ADDR_L20         7'h00   //
`define AL_FRM_D_ADDR_U20         7'h04   //
`define AL_FRM_S_ADDR_L20         7'h08   //
`define AL_FRM_S_ADDR_U20         7'h0C   //
`define AL_S_PORT20               7'h10   //
`define AL_D_PORT20               7'h14   // read only
`define AL_MAC_ADDR_L20           7'h18   //
`define AL_MAC_ADDR_U20           7'h1C   //
`define AL_CUR_TIME20             7'h20   // read only
`define AL_BB_AGE20               7'h24   //
`define AL_DIV_CLK20              7'h28   //
`define AL_STATUS20               7'h2C   // read only
`define AL_COMMAND20              7'h30   //
`define AL_LST_INV_ADDR_L20       7'h34   // read only
`define AL_LST_INV_ADDR_U20       7'h38   // read only
`define AL_LST_INV_PORT20         7'h3C   // read only
