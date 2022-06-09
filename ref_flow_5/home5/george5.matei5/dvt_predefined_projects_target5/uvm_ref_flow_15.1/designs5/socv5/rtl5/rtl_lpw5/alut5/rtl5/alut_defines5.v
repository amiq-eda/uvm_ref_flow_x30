//File5 name   : alut_defines5.v
//Title5       : 
//Created5     : 1999
//Description5 : 
//Notes5       : 
//----------------------------------------------------------------------
//   Copyright5 1999-2010 Cadence5 Design5 Systems5, Inc5.
//   All Rights5 Reserved5 Worldwide5
//
//   Licensed5 under the Apache5 License5, Version5 2.0 (the
//   "License5"); you may not use this file except5 in
//   compliance5 with the License5.  You may obtain5 a copy of
//   the License5 at
//
//       http5://www5.apache5.org5/licenses5/LICENSE5-2.0
//
//   Unless5 required5 by applicable5 law5 or agreed5 to in
//   writing, software5 distributed5 under the License5 is
//   distributed5 on an "AS5 IS5" BASIS5, WITHOUT5 WARRANTIES5 OR5
//   CONDITIONS5 OF5 ANY5 KIND5, either5 express5 or implied5.  See
//   the License5 for the specific5 language5 governing5
//   permissions5 and limitations5 under the License5.
//----------------------------------------------------------------------

// Define5 the register address constants5 
`define AL_FRM_D_ADDR_L5         7'h00   //
`define AL_FRM_D_ADDR_U5         7'h04   //
`define AL_FRM_S_ADDR_L5         7'h08   //
`define AL_FRM_S_ADDR_U5         7'h0C   //
`define AL_S_PORT5               7'h10   //
`define AL_D_PORT5               7'h14   // read only
`define AL_MAC_ADDR_L5           7'h18   //
`define AL_MAC_ADDR_U5           7'h1C   //
`define AL_CUR_TIME5             7'h20   // read only
`define AL_BB_AGE5               7'h24   //
`define AL_DIV_CLK5              7'h28   //
`define AL_STATUS5               7'h2C   // read only
`define AL_COMMAND5              7'h30   //
`define AL_LST_INV_ADDR_L5       7'h34   // read only
`define AL_LST_INV_ADDR_U5       7'h38   // read only
`define AL_LST_INV_PORT5         7'h3C   // read only
