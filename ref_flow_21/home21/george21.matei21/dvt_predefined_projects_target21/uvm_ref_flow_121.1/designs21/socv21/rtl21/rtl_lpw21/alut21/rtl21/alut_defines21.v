//File21 name   : alut_defines21.v
//Title21       : 
//Created21     : 1999
//Description21 : 
//Notes21       : 
//----------------------------------------------------------------------
//   Copyright21 1999-2010 Cadence21 Design21 Systems21, Inc21.
//   All Rights21 Reserved21 Worldwide21
//
//   Licensed21 under the Apache21 License21, Version21 2.0 (the
//   "License21"); you may not use this file except21 in
//   compliance21 with the License21.  You may obtain21 a copy of
//   the License21 at
//
//       http21://www21.apache21.org21/licenses21/LICENSE21-2.0
//
//   Unless21 required21 by applicable21 law21 or agreed21 to in
//   writing, software21 distributed21 under the License21 is
//   distributed21 on an "AS21 IS21" BASIS21, WITHOUT21 WARRANTIES21 OR21
//   CONDITIONS21 OF21 ANY21 KIND21, either21 express21 or implied21.  See
//   the License21 for the specific21 language21 governing21
//   permissions21 and limitations21 under the License21.
//----------------------------------------------------------------------

// Define21 the register address constants21 
`define AL_FRM_D_ADDR_L21         7'h00   //
`define AL_FRM_D_ADDR_U21         7'h04   //
`define AL_FRM_S_ADDR_L21         7'h08   //
`define AL_FRM_S_ADDR_U21         7'h0C   //
`define AL_S_PORT21               7'h10   //
`define AL_D_PORT21               7'h14   // read only
`define AL_MAC_ADDR_L21           7'h18   //
`define AL_MAC_ADDR_U21           7'h1C   //
`define AL_CUR_TIME21             7'h20   // read only
`define AL_BB_AGE21               7'h24   //
`define AL_DIV_CLK21              7'h28   //
`define AL_STATUS21               7'h2C   // read only
`define AL_COMMAND21              7'h30   //
`define AL_LST_INV_ADDR_L21       7'h34   // read only
`define AL_LST_INV_ADDR_U21       7'h38   // read only
`define AL_LST_INV_PORT21         7'h3C   // read only
