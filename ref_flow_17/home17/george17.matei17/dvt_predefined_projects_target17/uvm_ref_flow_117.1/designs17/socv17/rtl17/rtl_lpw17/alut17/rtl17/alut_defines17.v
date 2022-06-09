//File17 name   : alut_defines17.v
//Title17       : 
//Created17     : 1999
//Description17 : 
//Notes17       : 
//----------------------------------------------------------------------
//   Copyright17 1999-2010 Cadence17 Design17 Systems17, Inc17.
//   All Rights17 Reserved17 Worldwide17
//
//   Licensed17 under the Apache17 License17, Version17 2.0 (the
//   "License17"); you may not use this file except17 in
//   compliance17 with the License17.  You may obtain17 a copy of
//   the License17 at
//
//       http17://www17.apache17.org17/licenses17/LICENSE17-2.0
//
//   Unless17 required17 by applicable17 law17 or agreed17 to in
//   writing, software17 distributed17 under the License17 is
//   distributed17 on an "AS17 IS17" BASIS17, WITHOUT17 WARRANTIES17 OR17
//   CONDITIONS17 OF17 ANY17 KIND17, either17 express17 or implied17.  See
//   the License17 for the specific17 language17 governing17
//   permissions17 and limitations17 under the License17.
//----------------------------------------------------------------------

// Define17 the register address constants17 
`define AL_FRM_D_ADDR_L17         7'h00   //
`define AL_FRM_D_ADDR_U17         7'h04   //
`define AL_FRM_S_ADDR_L17         7'h08   //
`define AL_FRM_S_ADDR_U17         7'h0C   //
`define AL_S_PORT17               7'h10   //
`define AL_D_PORT17               7'h14   // read only
`define AL_MAC_ADDR_L17           7'h18   //
`define AL_MAC_ADDR_U17           7'h1C   //
`define AL_CUR_TIME17             7'h20   // read only
`define AL_BB_AGE17               7'h24   //
`define AL_DIV_CLK17              7'h28   //
`define AL_STATUS17               7'h2C   // read only
`define AL_COMMAND17              7'h30   //
`define AL_LST_INV_ADDR_L17       7'h34   // read only
`define AL_LST_INV_ADDR_U17       7'h38   // read only
`define AL_LST_INV_PORT17         7'h3C   // read only
