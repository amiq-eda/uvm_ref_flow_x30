//File6 name   : alut_defines6.v
//Title6       : 
//Created6     : 1999
//Description6 : 
//Notes6       : 
//----------------------------------------------------------------------
//   Copyright6 1999-2010 Cadence6 Design6 Systems6, Inc6.
//   All Rights6 Reserved6 Worldwide6
//
//   Licensed6 under the Apache6 License6, Version6 2.0 (the
//   "License6"); you may not use this file except6 in
//   compliance6 with the License6.  You may obtain6 a copy of
//   the License6 at
//
//       http6://www6.apache6.org6/licenses6/LICENSE6-2.0
//
//   Unless6 required6 by applicable6 law6 or agreed6 to in
//   writing, software6 distributed6 under the License6 is
//   distributed6 on an "AS6 IS6" BASIS6, WITHOUT6 WARRANTIES6 OR6
//   CONDITIONS6 OF6 ANY6 KIND6, either6 express6 or implied6.  See
//   the License6 for the specific6 language6 governing6
//   permissions6 and limitations6 under the License6.
//----------------------------------------------------------------------

// Define6 the register address constants6 
`define AL_FRM_D_ADDR_L6         7'h00   //
`define AL_FRM_D_ADDR_U6         7'h04   //
`define AL_FRM_S_ADDR_L6         7'h08   //
`define AL_FRM_S_ADDR_U6         7'h0C   //
`define AL_S_PORT6               7'h10   //
`define AL_D_PORT6               7'h14   // read only
`define AL_MAC_ADDR_L6           7'h18   //
`define AL_MAC_ADDR_U6           7'h1C   //
`define AL_CUR_TIME6             7'h20   // read only
`define AL_BB_AGE6               7'h24   //
`define AL_DIV_CLK6              7'h28   //
`define AL_STATUS6               7'h2C   // read only
`define AL_COMMAND6              7'h30   //
`define AL_LST_INV_ADDR_L6       7'h34   // read only
`define AL_LST_INV_ADDR_U6       7'h38   // read only
`define AL_LST_INV_PORT6         7'h3C   // read only
