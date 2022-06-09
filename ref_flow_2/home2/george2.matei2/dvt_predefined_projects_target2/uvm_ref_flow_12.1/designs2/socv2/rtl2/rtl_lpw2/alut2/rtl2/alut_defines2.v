//File2 name   : alut_defines2.v
//Title2       : 
//Created2     : 1999
//Description2 : 
//Notes2       : 
//----------------------------------------------------------------------
//   Copyright2 1999-2010 Cadence2 Design2 Systems2, Inc2.
//   All Rights2 Reserved2 Worldwide2
//
//   Licensed2 under the Apache2 License2, Version2 2.0 (the
//   "License2"); you may not use this file except2 in
//   compliance2 with the License2.  You may obtain2 a copy of
//   the License2 at
//
//       http2://www2.apache2.org2/licenses2/LICENSE2-2.0
//
//   Unless2 required2 by applicable2 law2 or agreed2 to in
//   writing, software2 distributed2 under the License2 is
//   distributed2 on an "AS2 IS2" BASIS2, WITHOUT2 WARRANTIES2 OR2
//   CONDITIONS2 OF2 ANY2 KIND2, either2 express2 or implied2.  See
//   the License2 for the specific2 language2 governing2
//   permissions2 and limitations2 under the License2.
//----------------------------------------------------------------------

// Define2 the register address constants2 
`define AL_FRM_D_ADDR_L2         7'h00   //
`define AL_FRM_D_ADDR_U2         7'h04   //
`define AL_FRM_S_ADDR_L2         7'h08   //
`define AL_FRM_S_ADDR_U2         7'h0C   //
`define AL_S_PORT2               7'h10   //
`define AL_D_PORT2               7'h14   // read only
`define AL_MAC_ADDR_L2           7'h18   //
`define AL_MAC_ADDR_U2           7'h1C   //
`define AL_CUR_TIME2             7'h20   // read only
`define AL_BB_AGE2               7'h24   //
`define AL_DIV_CLK2              7'h28   //
`define AL_STATUS2               7'h2C   // read only
`define AL_COMMAND2              7'h30   //
`define AL_LST_INV_ADDR_L2       7'h34   // read only
`define AL_LST_INV_ADDR_U2       7'h38   // read only
`define AL_LST_INV_PORT2         7'h3C   // read only
