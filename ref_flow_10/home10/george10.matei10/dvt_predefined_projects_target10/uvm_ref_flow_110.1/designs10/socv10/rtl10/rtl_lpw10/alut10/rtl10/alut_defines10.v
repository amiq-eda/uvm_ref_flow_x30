//File10 name   : alut_defines10.v
//Title10       : 
//Created10     : 1999
//Description10 : 
//Notes10       : 
//----------------------------------------------------------------------
//   Copyright10 1999-2010 Cadence10 Design10 Systems10, Inc10.
//   All Rights10 Reserved10 Worldwide10
//
//   Licensed10 under the Apache10 License10, Version10 2.0 (the
//   "License10"); you may not use this file except10 in
//   compliance10 with the License10.  You may obtain10 a copy of
//   the License10 at
//
//       http10://www10.apache10.org10/licenses10/LICENSE10-2.0
//
//   Unless10 required10 by applicable10 law10 or agreed10 to in
//   writing, software10 distributed10 under the License10 is
//   distributed10 on an "AS10 IS10" BASIS10, WITHOUT10 WARRANTIES10 OR10
//   CONDITIONS10 OF10 ANY10 KIND10, either10 express10 or implied10.  See
//   the License10 for the specific10 language10 governing10
//   permissions10 and limitations10 under the License10.
//----------------------------------------------------------------------

// Define10 the register address constants10 
`define AL_FRM_D_ADDR_L10         7'h00   //
`define AL_FRM_D_ADDR_U10         7'h04   //
`define AL_FRM_S_ADDR_L10         7'h08   //
`define AL_FRM_S_ADDR_U10         7'h0C   //
`define AL_S_PORT10               7'h10   //
`define AL_D_PORT10               7'h14   // read only
`define AL_MAC_ADDR_L10           7'h18   //
`define AL_MAC_ADDR_U10           7'h1C   //
`define AL_CUR_TIME10             7'h20   // read only
`define AL_BB_AGE10               7'h24   //
`define AL_DIV_CLK10              7'h28   //
`define AL_STATUS10               7'h2C   // read only
`define AL_COMMAND10              7'h30   //
`define AL_LST_INV_ADDR_L10       7'h34   // read only
`define AL_LST_INV_ADDR_U10       7'h38   // read only
`define AL_LST_INV_PORT10         7'h3C   // read only
