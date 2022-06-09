//File4 name   : alut_defines4.v
//Title4       : 
//Created4     : 1999
//Description4 : 
//Notes4       : 
//----------------------------------------------------------------------
//   Copyright4 1999-2010 Cadence4 Design4 Systems4, Inc4.
//   All Rights4 Reserved4 Worldwide4
//
//   Licensed4 under the Apache4 License4, Version4 2.0 (the
//   "License4"); you may not use this file except4 in
//   compliance4 with the License4.  You may obtain4 a copy of
//   the License4 at
//
//       http4://www4.apache4.org4/licenses4/LICENSE4-2.0
//
//   Unless4 required4 by applicable4 law4 or agreed4 to in
//   writing, software4 distributed4 under the License4 is
//   distributed4 on an "AS4 IS4" BASIS4, WITHOUT4 WARRANTIES4 OR4
//   CONDITIONS4 OF4 ANY4 KIND4, either4 express4 or implied4.  See
//   the License4 for the specific4 language4 governing4
//   permissions4 and limitations4 under the License4.
//----------------------------------------------------------------------

// Define4 the register address constants4 
`define AL_FRM_D_ADDR_L4         7'h00   //
`define AL_FRM_D_ADDR_U4         7'h04   //
`define AL_FRM_S_ADDR_L4         7'h08   //
`define AL_FRM_S_ADDR_U4         7'h0C   //
`define AL_S_PORT4               7'h10   //
`define AL_D_PORT4               7'h14   // read only
`define AL_MAC_ADDR_L4           7'h18   //
`define AL_MAC_ADDR_U4           7'h1C   //
`define AL_CUR_TIME4             7'h20   // read only
`define AL_BB_AGE4               7'h24   //
`define AL_DIV_CLK4              7'h28   //
`define AL_STATUS4               7'h2C   // read only
`define AL_COMMAND4              7'h30   //
`define AL_LST_INV_ADDR_L4       7'h34   // read only
`define AL_LST_INV_ADDR_U4       7'h38   // read only
`define AL_LST_INV_PORT4         7'h3C   // read only
