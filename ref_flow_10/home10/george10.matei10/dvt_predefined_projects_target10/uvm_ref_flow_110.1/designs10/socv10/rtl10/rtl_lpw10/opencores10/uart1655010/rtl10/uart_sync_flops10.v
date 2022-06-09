//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops10.v                                             ////
////                                                              ////
////                                                              ////
////  This10 file is part of the "UART10 16550 compatible10" project10    ////
////  http10://www10.opencores10.org10/cores10/uart1655010/                   ////
////                                                              ////
////  Documentation10 related10 to this project10:                      ////
////  - http10://www10.opencores10.org10/cores10/uart1655010/                 ////
////                                                              ////
////  Projects10 compatibility10:                                     ////
////  - WISHBONE10                                                  ////
////  RS23210 Protocol10                                              ////
////  16550D uart10 (mostly10 supported)                              ////
////                                                              ////
////  Overview10 (main10 Features10):                                   ////
////  UART10 core10 receiver10 logic                                    ////
////                                                              ////
////  Known10 problems10 (limits10):                                    ////
////  None10 known10                                                  ////
////                                                              ////
////  To10 Do10:                                                      ////
////  Thourough10 testing10.                                          ////
////                                                              ////
////  Author10(s):                                                  ////
////      - Andrej10 Erzen10 (andreje10@flextronics10.si10)                 ////
////      - Tadej10 Markovic10 (tadejm10@flextronics10.si10)                ////
////                                                              ////
////  Created10:        2004/05/20                                  ////
////  Last10 Updated10:   2004/05/20                                  ////
////                  (See log10 for the revision10 history10)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright10 (C) 2000, 2001 Authors10                             ////
////                                                              ////
//// This10 source10 file may be used and distributed10 without         ////
//// restriction10 provided that this copyright10 statement10 is not    ////
//// removed from the file and that any derivative10 work10 contains10  ////
//// the original copyright10 notice10 and the associated disclaimer10. ////
////                                                              ////
//// This10 source10 file is free software10; you can redistribute10 it   ////
//// and/or modify it under the terms10 of the GNU10 Lesser10 General10   ////
//// Public10 License10 as published10 by the Free10 Software10 Foundation10; ////
//// either10 version10 2.1 of the License10, or (at your10 option) any   ////
//// later10 version10.                                               ////
////                                                              ////
//// This10 source10 is distributed10 in the hope10 that it will be       ////
//// useful10, but WITHOUT10 ANY10 WARRANTY10; without even10 the implied10   ////
//// warranty10 of MERCHANTABILITY10 or FITNESS10 FOR10 A PARTICULAR10      ////
//// PURPOSE10.  See the GNU10 Lesser10 General10 Public10 License10 for more ////
//// details10.                                                     ////
////                                                              ////
//// You should have received10 a copy of the GNU10 Lesser10 General10    ////
//// Public10 License10 along10 with this source10; if not, download10 it   ////
//// from http10://www10.opencores10.org10/lgpl10.shtml10                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS10 Revision10 History10
//
// $Log: not supported by cvs2svn10 $
//


`include "timescale.v"


module uart_sync_flops10
(
  // internal signals10
  rst_i10,
  clk_i10,
  stage1_rst_i10,
  stage1_clk_en_i10,
  async_dat_i10,
  sync_dat_o10
);

parameter Tp10            = 1;
parameter width         = 1;
parameter init_value10    = 1'b0;

input                           rst_i10;                  // reset input
input                           clk_i10;                  // clock10 input
input                           stage1_rst_i10;           // synchronous10 reset for stage10 1 FF10
input                           stage1_clk_en_i10;        // synchronous10 clock10 enable for stage10 1 FF10
input   [width-1:0]             async_dat_i10;            // asynchronous10 data input
output  [width-1:0]             sync_dat_o10;             // synchronous10 data output


//
// Interal10 signal10 declarations10
//

reg     [width-1:0]             sync_dat_o10;
reg     [width-1:0]             flop_010;


// first stage10
always @ (posedge clk_i10 or posedge rst_i10)
begin
    if (rst_i10)
        flop_010 <= #Tp10 {width{init_value10}};
    else
        flop_010 <= #Tp10 async_dat_i10;    
end

// second stage10
always @ (posedge clk_i10 or posedge rst_i10)
begin
    if (rst_i10)
        sync_dat_o10 <= #Tp10 {width{init_value10}};
    else if (stage1_rst_i10)
        sync_dat_o10 <= #Tp10 {width{init_value10}};
    else if (stage1_clk_en_i10)
        sync_dat_o10 <= #Tp10 flop_010;       
end

endmodule
