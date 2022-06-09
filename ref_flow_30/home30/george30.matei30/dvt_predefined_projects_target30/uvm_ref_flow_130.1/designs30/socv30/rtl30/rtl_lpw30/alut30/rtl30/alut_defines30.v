//File30 name   : alut_defines30.v
//Title30       : 
//Created30     : 1999
//Description30 : 
//Notes30       : 
//----------------------------------------------------------------------
//   Copyright30 1999-2010 Cadence30 Design30 Systems30, Inc30.
//   All Rights30 Reserved30 Worldwide30
//
//   Licensed30 under the Apache30 License30, Version30 2.0 (the
//   "License30"); you may not use this file except30 in
//   compliance30 with the License30.  You may obtain30 a copy of
//   the License30 at
//
//       http30://www30.apache30.org30/licenses30/LICENSE30-2.0
//
//   Unless30 required30 by applicable30 law30 or agreed30 to in
//   writing, software30 distributed30 under the License30 is
//   distributed30 on an "AS30 IS30" BASIS30, WITHOUT30 WARRANTIES30 OR30
//   CONDITIONS30 OF30 ANY30 KIND30, either30 express30 or implied30.  See
//   the License30 for the specific30 language30 governing30
//   permissions30 and limitations30 under the License30.
//----------------------------------------------------------------------

// Define30 the register address constants30 
`define AL_FRM_D_ADDR_L30         7'h00   //
`define AL_FRM_D_ADDR_U30         7'h04   //
`define AL_FRM_S_ADDR_L30         7'h08   //
`define AL_FRM_S_ADDR_U30         7'h0C   //
`define AL_S_PORT30               7'h10   //
`define AL_D_PORT30               7'h14   // read only
`define AL_MAC_ADDR_L30           7'h18   //
`define AL_MAC_ADDR_U30           7'h1C   //
`define AL_CUR_TIME30             7'h20   // read only
`define AL_BB_AGE30               7'h24   //
`define AL_DIV_CLK30              7'h28   //
`define AL_STATUS30               7'h2C   // read only
`define AL_COMMAND30              7'h30   //
`define AL_LST_INV_ADDR_L30       7'h34   // read only
`define AL_LST_INV_ADDR_U30       7'h38   // read only
`define AL_LST_INV_PORT30         7'h3C   // read only
