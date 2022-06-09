//File26 name   : alut_defines26.v
//Title26       : 
//Created26     : 1999
//Description26 : 
//Notes26       : 
//----------------------------------------------------------------------
//   Copyright26 1999-2010 Cadence26 Design26 Systems26, Inc26.
//   All Rights26 Reserved26 Worldwide26
//
//   Licensed26 under the Apache26 License26, Version26 2.0 (the
//   "License26"); you may not use this file except26 in
//   compliance26 with the License26.  You may obtain26 a copy of
//   the License26 at
//
//       http26://www26.apache26.org26/licenses26/LICENSE26-2.0
//
//   Unless26 required26 by applicable26 law26 or agreed26 to in
//   writing, software26 distributed26 under the License26 is
//   distributed26 on an "AS26 IS26" BASIS26, WITHOUT26 WARRANTIES26 OR26
//   CONDITIONS26 OF26 ANY26 KIND26, either26 express26 or implied26.  See
//   the License26 for the specific26 language26 governing26
//   permissions26 and limitations26 under the License26.
//----------------------------------------------------------------------

// Define26 the register address constants26 
`define AL_FRM_D_ADDR_L26         7'h00   //
`define AL_FRM_D_ADDR_U26         7'h04   //
`define AL_FRM_S_ADDR_L26         7'h08   //
`define AL_FRM_S_ADDR_U26         7'h0C   //
`define AL_S_PORT26               7'h10   //
`define AL_D_PORT26               7'h14   // read only
`define AL_MAC_ADDR_L26           7'h18   //
`define AL_MAC_ADDR_U26           7'h1C   //
`define AL_CUR_TIME26             7'h20   // read only
`define AL_BB_AGE26               7'h24   //
`define AL_DIV_CLK26              7'h28   //
`define AL_STATUS26               7'h2C   // read only
`define AL_COMMAND26              7'h30   //
`define AL_LST_INV_ADDR_L26       7'h34   // read only
`define AL_LST_INV_ADDR_U26       7'h38   // read only
`define AL_LST_INV_PORT26         7'h3C   // read only
