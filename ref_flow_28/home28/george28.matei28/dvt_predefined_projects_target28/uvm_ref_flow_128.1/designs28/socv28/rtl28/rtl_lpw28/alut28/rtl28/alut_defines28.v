//File28 name   : alut_defines28.v
//Title28       : 
//Created28     : 1999
//Description28 : 
//Notes28       : 
//----------------------------------------------------------------------
//   Copyright28 1999-2010 Cadence28 Design28 Systems28, Inc28.
//   All Rights28 Reserved28 Worldwide28
//
//   Licensed28 under the Apache28 License28, Version28 2.0 (the
//   "License28"); you may not use this file except28 in
//   compliance28 with the License28.  You may obtain28 a copy of
//   the License28 at
//
//       http28://www28.apache28.org28/licenses28/LICENSE28-2.0
//
//   Unless28 required28 by applicable28 law28 or agreed28 to in
//   writing, software28 distributed28 under the License28 is
//   distributed28 on an "AS28 IS28" BASIS28, WITHOUT28 WARRANTIES28 OR28
//   CONDITIONS28 OF28 ANY28 KIND28, either28 express28 or implied28.  See
//   the License28 for the specific28 language28 governing28
//   permissions28 and limitations28 under the License28.
//----------------------------------------------------------------------

// Define28 the register address constants28 
`define AL_FRM_D_ADDR_L28         7'h00   //
`define AL_FRM_D_ADDR_U28         7'h04   //
`define AL_FRM_S_ADDR_L28         7'h08   //
`define AL_FRM_S_ADDR_U28         7'h0C   //
`define AL_S_PORT28               7'h10   //
`define AL_D_PORT28               7'h14   // read only
`define AL_MAC_ADDR_L28           7'h18   //
`define AL_MAC_ADDR_U28           7'h1C   //
`define AL_CUR_TIME28             7'h20   // read only
`define AL_BB_AGE28               7'h24   //
`define AL_DIV_CLK28              7'h28   //
`define AL_STATUS28               7'h2C   // read only
`define AL_COMMAND28              7'h30   //
`define AL_LST_INV_ADDR_L28       7'h34   // read only
`define AL_LST_INV_ADDR_U28       7'h38   // read only
`define AL_LST_INV_PORT28         7'h3C   // read only
