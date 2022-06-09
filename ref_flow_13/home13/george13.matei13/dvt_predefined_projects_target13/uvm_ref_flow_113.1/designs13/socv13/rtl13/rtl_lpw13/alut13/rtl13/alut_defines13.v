//File13 name   : alut_defines13.v
//Title13       : 
//Created13     : 1999
//Description13 : 
//Notes13       : 
//----------------------------------------------------------------------
//   Copyright13 1999-2010 Cadence13 Design13 Systems13, Inc13.
//   All Rights13 Reserved13 Worldwide13
//
//   Licensed13 under the Apache13 License13, Version13 2.0 (the
//   "License13"); you may not use this file except13 in
//   compliance13 with the License13.  You may obtain13 a copy of
//   the License13 at
//
//       http13://www13.apache13.org13/licenses13/LICENSE13-2.0
//
//   Unless13 required13 by applicable13 law13 or agreed13 to in
//   writing, software13 distributed13 under the License13 is
//   distributed13 on an "AS13 IS13" BASIS13, WITHOUT13 WARRANTIES13 OR13
//   CONDITIONS13 OF13 ANY13 KIND13, either13 express13 or implied13.  See
//   the License13 for the specific13 language13 governing13
//   permissions13 and limitations13 under the License13.
//----------------------------------------------------------------------

// Define13 the register address constants13 
`define AL_FRM_D_ADDR_L13         7'h00   //
`define AL_FRM_D_ADDR_U13         7'h04   //
`define AL_FRM_S_ADDR_L13         7'h08   //
`define AL_FRM_S_ADDR_U13         7'h0C   //
`define AL_S_PORT13               7'h10   //
`define AL_D_PORT13               7'h14   // read only
`define AL_MAC_ADDR_L13           7'h18   //
`define AL_MAC_ADDR_U13           7'h1C   //
`define AL_CUR_TIME13             7'h20   // read only
`define AL_BB_AGE13               7'h24   //
`define AL_DIV_CLK13              7'h28   //
`define AL_STATUS13               7'h2C   // read only
`define AL_COMMAND13              7'h30   //
`define AL_LST_INV_ADDR_L13       7'h34   // read only
`define AL_LST_INV_ADDR_U13       7'h38   // read only
`define AL_LST_INV_PORT13         7'h3C   // read only
