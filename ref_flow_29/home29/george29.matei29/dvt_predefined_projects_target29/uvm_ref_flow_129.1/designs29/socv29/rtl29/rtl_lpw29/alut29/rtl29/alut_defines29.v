//File29 name   : alut_defines29.v
//Title29       : 
//Created29     : 1999
//Description29 : 
//Notes29       : 
//----------------------------------------------------------------------
//   Copyright29 1999-2010 Cadence29 Design29 Systems29, Inc29.
//   All Rights29 Reserved29 Worldwide29
//
//   Licensed29 under the Apache29 License29, Version29 2.0 (the
//   "License29"); you may not use this file except29 in
//   compliance29 with the License29.  You may obtain29 a copy of
//   the License29 at
//
//       http29://www29.apache29.org29/licenses29/LICENSE29-2.0
//
//   Unless29 required29 by applicable29 law29 or agreed29 to in
//   writing, software29 distributed29 under the License29 is
//   distributed29 on an "AS29 IS29" BASIS29, WITHOUT29 WARRANTIES29 OR29
//   CONDITIONS29 OF29 ANY29 KIND29, either29 express29 or implied29.  See
//   the License29 for the specific29 language29 governing29
//   permissions29 and limitations29 under the License29.
//----------------------------------------------------------------------

// Define29 the register address constants29 
`define AL_FRM_D_ADDR_L29         7'h00   //
`define AL_FRM_D_ADDR_U29         7'h04   //
`define AL_FRM_S_ADDR_L29         7'h08   //
`define AL_FRM_S_ADDR_U29         7'h0C   //
`define AL_S_PORT29               7'h10   //
`define AL_D_PORT29               7'h14   // read only
`define AL_MAC_ADDR_L29           7'h18   //
`define AL_MAC_ADDR_U29           7'h1C   //
`define AL_CUR_TIME29             7'h20   // read only
`define AL_BB_AGE29               7'h24   //
`define AL_DIV_CLK29              7'h28   //
`define AL_STATUS29               7'h2C   // read only
`define AL_COMMAND29              7'h30   //
`define AL_LST_INV_ADDR_L29       7'h34   // read only
`define AL_LST_INV_ADDR_U29       7'h38   // read only
`define AL_LST_INV_PORT29         7'h3C   // read only
