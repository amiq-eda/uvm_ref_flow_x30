//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops23.v                                             ////
////                                                              ////
////                                                              ////
////  This23 file is part of the "UART23 16550 compatible23" project23    ////
////  http23://www23.opencores23.org23/cores23/uart1655023/                   ////
////                                                              ////
////  Documentation23 related23 to this project23:                      ////
////  - http23://www23.opencores23.org23/cores23/uart1655023/                 ////
////                                                              ////
////  Projects23 compatibility23:                                     ////
////  - WISHBONE23                                                  ////
////  RS23223 Protocol23                                              ////
////  16550D uart23 (mostly23 supported)                              ////
////                                                              ////
////  Overview23 (main23 Features23):                                   ////
////  UART23 core23 receiver23 logic                                    ////
////                                                              ////
////  Known23 problems23 (limits23):                                    ////
////  None23 known23                                                  ////
////                                                              ////
////  To23 Do23:                                                      ////
////  Thourough23 testing23.                                          ////
////                                                              ////
////  Author23(s):                                                  ////
////      - Andrej23 Erzen23 (andreje23@flextronics23.si23)                 ////
////      - Tadej23 Markovic23 (tadejm23@flextronics23.si23)                ////
////                                                              ////
////  Created23:        2004/05/20                                  ////
////  Last23 Updated23:   2004/05/20                                  ////
////                  (See log23 for the revision23 history23)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2000, 2001 Authors23                             ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS23 Revision23 History23
//
// $Log: not supported by cvs2svn23 $
//


`include "timescale.v"


module uart_sync_flops23
(
  // internal signals23
  rst_i23,
  clk_i23,
  stage1_rst_i23,
  stage1_clk_en_i23,
  async_dat_i23,
  sync_dat_o23
);

parameter Tp23            = 1;
parameter width         = 1;
parameter init_value23    = 1'b0;

input                           rst_i23;                  // reset input
input                           clk_i23;                  // clock23 input
input                           stage1_rst_i23;           // synchronous23 reset for stage23 1 FF23
input                           stage1_clk_en_i23;        // synchronous23 clock23 enable for stage23 1 FF23
input   [width-1:0]             async_dat_i23;            // asynchronous23 data input
output  [width-1:0]             sync_dat_o23;             // synchronous23 data output


//
// Interal23 signal23 declarations23
//

reg     [width-1:0]             sync_dat_o23;
reg     [width-1:0]             flop_023;


// first stage23
always @ (posedge clk_i23 or posedge rst_i23)
begin
    if (rst_i23)
        flop_023 <= #Tp23 {width{init_value23}};
    else
        flop_023 <= #Tp23 async_dat_i23;    
end

// second stage23
always @ (posedge clk_i23 or posedge rst_i23)
begin
    if (rst_i23)
        sync_dat_o23 <= #Tp23 {width{init_value23}};
    else if (stage1_rst_i23)
        sync_dat_o23 <= #Tp23 {width{init_value23}};
    else if (stage1_clk_en_i23)
        sync_dat_o23 <= #Tp23 flop_023;       
end

endmodule
