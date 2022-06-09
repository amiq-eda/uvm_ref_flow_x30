//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops25.v                                             ////
////                                                              ////
////                                                              ////
////  This25 file is part of the "UART25 16550 compatible25" project25    ////
////  http25://www25.opencores25.org25/cores25/uart1655025/                   ////
////                                                              ////
////  Documentation25 related25 to this project25:                      ////
////  - http25://www25.opencores25.org25/cores25/uart1655025/                 ////
////                                                              ////
////  Projects25 compatibility25:                                     ////
////  - WISHBONE25                                                  ////
////  RS23225 Protocol25                                              ////
////  16550D uart25 (mostly25 supported)                              ////
////                                                              ////
////  Overview25 (main25 Features25):                                   ////
////  UART25 core25 receiver25 logic                                    ////
////                                                              ////
////  Known25 problems25 (limits25):                                    ////
////  None25 known25                                                  ////
////                                                              ////
////  To25 Do25:                                                      ////
////  Thourough25 testing25.                                          ////
////                                                              ////
////  Author25(s):                                                  ////
////      - Andrej25 Erzen25 (andreje25@flextronics25.si25)                 ////
////      - Tadej25 Markovic25 (tadejm25@flextronics25.si25)                ////
////                                                              ////
////  Created25:        2004/05/20                                  ////
////  Last25 Updated25:   2004/05/20                                  ////
////                  (See log25 for the revision25 history25)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2000, 2001 Authors25                             ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS25 Revision25 History25
//
// $Log: not supported by cvs2svn25 $
//


`include "timescale.v"


module uart_sync_flops25
(
  // internal signals25
  rst_i25,
  clk_i25,
  stage1_rst_i25,
  stage1_clk_en_i25,
  async_dat_i25,
  sync_dat_o25
);

parameter Tp25            = 1;
parameter width         = 1;
parameter init_value25    = 1'b0;

input                           rst_i25;                  // reset input
input                           clk_i25;                  // clock25 input
input                           stage1_rst_i25;           // synchronous25 reset for stage25 1 FF25
input                           stage1_clk_en_i25;        // synchronous25 clock25 enable for stage25 1 FF25
input   [width-1:0]             async_dat_i25;            // asynchronous25 data input
output  [width-1:0]             sync_dat_o25;             // synchronous25 data output


//
// Interal25 signal25 declarations25
//

reg     [width-1:0]             sync_dat_o25;
reg     [width-1:0]             flop_025;


// first stage25
always @ (posedge clk_i25 or posedge rst_i25)
begin
    if (rst_i25)
        flop_025 <= #Tp25 {width{init_value25}};
    else
        flop_025 <= #Tp25 async_dat_i25;    
end

// second stage25
always @ (posedge clk_i25 or posedge rst_i25)
begin
    if (rst_i25)
        sync_dat_o25 <= #Tp25 {width{init_value25}};
    else if (stage1_rst_i25)
        sync_dat_o25 <= #Tp25 {width{init_value25}};
    else if (stage1_clk_en_i25)
        sync_dat_o25 <= #Tp25 flop_025;       
end

endmodule
