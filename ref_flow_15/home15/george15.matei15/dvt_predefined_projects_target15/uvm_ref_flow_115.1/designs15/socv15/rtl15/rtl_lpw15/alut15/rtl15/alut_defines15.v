//File15 name   : alut_defines15.v
//Title15       : 
//Created15     : 1999
//Description15 : 
//Notes15       : 
//----------------------------------------------------------------------
//   Copyright15 1999-2010 Cadence15 Design15 Systems15, Inc15.
//   All Rights15 Reserved15 Worldwide15
//
//   Licensed15 under the Apache15 License15, Version15 2.0 (the
//   "License15"); you may not use this file except15 in
//   compliance15 with the License15.  You may obtain15 a copy of
//   the License15 at
//
//       http15://www15.apache15.org15/licenses15/LICENSE15-2.0
//
//   Unless15 required15 by applicable15 law15 or agreed15 to in
//   writing, software15 distributed15 under the License15 is
//   distributed15 on an "AS15 IS15" BASIS15, WITHOUT15 WARRANTIES15 OR15
//   CONDITIONS15 OF15 ANY15 KIND15, either15 express15 or implied15.  See
//   the License15 for the specific15 language15 governing15
//   permissions15 and limitations15 under the License15.
//----------------------------------------------------------------------

// Define15 the register address constants15 
`define AL_FRM_D_ADDR_L15         7'h00   //
`define AL_FRM_D_ADDR_U15         7'h04   //
`define AL_FRM_S_ADDR_L15         7'h08   //
`define AL_FRM_S_ADDR_U15         7'h0C   //
`define AL_S_PORT15               7'h10   //
`define AL_D_PORT15               7'h14   // read only
`define AL_MAC_ADDR_L15           7'h18   //
`define AL_MAC_ADDR_U15           7'h1C   //
`define AL_CUR_TIME15             7'h20   // read only
`define AL_BB_AGE15               7'h24   //
`define AL_DIV_CLK15              7'h28   //
`define AL_STATUS15               7'h2C   // read only
`define AL_COMMAND15              7'h30   //
`define AL_LST_INV_ADDR_L15       7'h34   // read only
`define AL_LST_INV_ADDR_U15       7'h38   // read only
`define AL_LST_INV_PORT15         7'h3C   // read only
