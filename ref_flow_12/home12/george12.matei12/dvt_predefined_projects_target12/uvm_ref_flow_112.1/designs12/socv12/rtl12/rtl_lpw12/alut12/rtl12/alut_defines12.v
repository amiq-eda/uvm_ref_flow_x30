//File12 name   : alut_defines12.v
//Title12       : 
//Created12     : 1999
//Description12 : 
//Notes12       : 
//----------------------------------------------------------------------
//   Copyright12 1999-2010 Cadence12 Design12 Systems12, Inc12.
//   All Rights12 Reserved12 Worldwide12
//
//   Licensed12 under the Apache12 License12, Version12 2.0 (the
//   "License12"); you may not use this file except12 in
//   compliance12 with the License12.  You may obtain12 a copy of
//   the License12 at
//
//       http12://www12.apache12.org12/licenses12/LICENSE12-2.0
//
//   Unless12 required12 by applicable12 law12 or agreed12 to in
//   writing, software12 distributed12 under the License12 is
//   distributed12 on an "AS12 IS12" BASIS12, WITHOUT12 WARRANTIES12 OR12
//   CONDITIONS12 OF12 ANY12 KIND12, either12 express12 or implied12.  See
//   the License12 for the specific12 language12 governing12
//   permissions12 and limitations12 under the License12.
//----------------------------------------------------------------------

// Define12 the register address constants12 
`define AL_FRM_D_ADDR_L12         7'h00   //
`define AL_FRM_D_ADDR_U12         7'h04   //
`define AL_FRM_S_ADDR_L12         7'h08   //
`define AL_FRM_S_ADDR_U12         7'h0C   //
`define AL_S_PORT12               7'h10   //
`define AL_D_PORT12               7'h14   // read only
`define AL_MAC_ADDR_L12           7'h18   //
`define AL_MAC_ADDR_U12           7'h1C   //
`define AL_CUR_TIME12             7'h20   // read only
`define AL_BB_AGE12               7'h24   //
`define AL_DIV_CLK12              7'h28   //
`define AL_STATUS12               7'h2C   // read only
`define AL_COMMAND12              7'h30   //
`define AL_LST_INV_ADDR_L12       7'h34   // read only
`define AL_LST_INV_ADDR_U12       7'h38   // read only
`define AL_LST_INV_PORT12         7'h3C   // read only
