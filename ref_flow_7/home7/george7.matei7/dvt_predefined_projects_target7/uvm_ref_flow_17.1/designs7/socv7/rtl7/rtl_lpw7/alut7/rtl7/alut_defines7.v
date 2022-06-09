//File7 name   : alut_defines7.v
//Title7       : 
//Created7     : 1999
//Description7 : 
//Notes7       : 
//----------------------------------------------------------------------
//   Copyright7 1999-2010 Cadence7 Design7 Systems7, Inc7.
//   All Rights7 Reserved7 Worldwide7
//
//   Licensed7 under the Apache7 License7, Version7 2.0 (the
//   "License7"); you may not use this file except7 in
//   compliance7 with the License7.  You may obtain7 a copy of
//   the License7 at
//
//       http7://www7.apache7.org7/licenses7/LICENSE7-2.0
//
//   Unless7 required7 by applicable7 law7 or agreed7 to in
//   writing, software7 distributed7 under the License7 is
//   distributed7 on an "AS7 IS7" BASIS7, WITHOUT7 WARRANTIES7 OR7
//   CONDITIONS7 OF7 ANY7 KIND7, either7 express7 or implied7.  See
//   the License7 for the specific7 language7 governing7
//   permissions7 and limitations7 under the License7.
//----------------------------------------------------------------------

// Define7 the register address constants7 
`define AL_FRM_D_ADDR_L7         7'h00   //
`define AL_FRM_D_ADDR_U7         7'h04   //
`define AL_FRM_S_ADDR_L7         7'h08   //
`define AL_FRM_S_ADDR_U7         7'h0C   //
`define AL_S_PORT7               7'h10   //
`define AL_D_PORT7               7'h14   // read only
`define AL_MAC_ADDR_L7           7'h18   //
`define AL_MAC_ADDR_U7           7'h1C   //
`define AL_CUR_TIME7             7'h20   // read only
`define AL_BB_AGE7               7'h24   //
`define AL_DIV_CLK7              7'h28   //
`define AL_STATUS7               7'h2C   // read only
`define AL_COMMAND7              7'h30   //
`define AL_LST_INV_ADDR_L7       7'h34   // read only
`define AL_LST_INV_ADDR_U7       7'h38   // read only
`define AL_LST_INV_PORT7         7'h3C   // read only
