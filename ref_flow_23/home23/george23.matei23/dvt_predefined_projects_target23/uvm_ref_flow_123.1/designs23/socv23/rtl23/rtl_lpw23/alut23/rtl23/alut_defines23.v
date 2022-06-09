//File23 name   : alut_defines23.v
//Title23       : 
//Created23     : 1999
//Description23 : 
//Notes23       : 
//----------------------------------------------------------------------
//   Copyright23 1999-2010 Cadence23 Design23 Systems23, Inc23.
//   All Rights23 Reserved23 Worldwide23
//
//   Licensed23 under the Apache23 License23, Version23 2.0 (the
//   "License23"); you may not use this file except23 in
//   compliance23 with the License23.  You may obtain23 a copy of
//   the License23 at
//
//       http23://www23.apache23.org23/licenses23/LICENSE23-2.0
//
//   Unless23 required23 by applicable23 law23 or agreed23 to in
//   writing, software23 distributed23 under the License23 is
//   distributed23 on an "AS23 IS23" BASIS23, WITHOUT23 WARRANTIES23 OR23
//   CONDITIONS23 OF23 ANY23 KIND23, either23 express23 or implied23.  See
//   the License23 for the specific23 language23 governing23
//   permissions23 and limitations23 under the License23.
//----------------------------------------------------------------------

// Define23 the register address constants23 
`define AL_FRM_D_ADDR_L23         7'h00   //
`define AL_FRM_D_ADDR_U23         7'h04   //
`define AL_FRM_S_ADDR_L23         7'h08   //
`define AL_FRM_S_ADDR_U23         7'h0C   //
`define AL_S_PORT23               7'h10   //
`define AL_D_PORT23               7'h14   // read only
`define AL_MAC_ADDR_L23           7'h18   //
`define AL_MAC_ADDR_U23           7'h1C   //
`define AL_CUR_TIME23             7'h20   // read only
`define AL_BB_AGE23               7'h24   //
`define AL_DIV_CLK23              7'h28   //
`define AL_STATUS23               7'h2C   // read only
`define AL_COMMAND23              7'h30   //
`define AL_LST_INV_ADDR_L23       7'h34   // read only
`define AL_LST_INV_ADDR_U23       7'h38   // read only
`define AL_LST_INV_PORT23         7'h3C   // read only
