//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops14.v                                             ////
////                                                              ////
////                                                              ////
////  This14 file is part of the "UART14 16550 compatible14" project14    ////
////  http14://www14.opencores14.org14/cores14/uart1655014/                   ////
////                                                              ////
////  Documentation14 related14 to this project14:                      ////
////  - http14://www14.opencores14.org14/cores14/uart1655014/                 ////
////                                                              ////
////  Projects14 compatibility14:                                     ////
////  - WISHBONE14                                                  ////
////  RS23214 Protocol14                                              ////
////  16550D uart14 (mostly14 supported)                              ////
////                                                              ////
////  Overview14 (main14 Features14):                                   ////
////  UART14 core14 receiver14 logic                                    ////
////                                                              ////
////  Known14 problems14 (limits14):                                    ////
////  None14 known14                                                  ////
////                                                              ////
////  To14 Do14:                                                      ////
////  Thourough14 testing14.                                          ////
////                                                              ////
////  Author14(s):                                                  ////
////      - Andrej14 Erzen14 (andreje14@flextronics14.si14)                 ////
////      - Tadej14 Markovic14 (tadejm14@flextronics14.si14)                ////
////                                                              ////
////  Created14:        2004/05/20                                  ////
////  Last14 Updated14:   2004/05/20                                  ////
////                  (See log14 for the revision14 history14)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2000, 2001 Authors14                             ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS14 Revision14 History14
//
// $Log: not supported by cvs2svn14 $
//


`include "timescale.v"


module uart_sync_flops14
(
  // internal signals14
  rst_i14,
  clk_i14,
  stage1_rst_i14,
  stage1_clk_en_i14,
  async_dat_i14,
  sync_dat_o14
);

parameter Tp14            = 1;
parameter width         = 1;
parameter init_value14    = 1'b0;

input                           rst_i14;                  // reset input
input                           clk_i14;                  // clock14 input
input                           stage1_rst_i14;           // synchronous14 reset for stage14 1 FF14
input                           stage1_clk_en_i14;        // synchronous14 clock14 enable for stage14 1 FF14
input   [width-1:0]             async_dat_i14;            // asynchronous14 data input
output  [width-1:0]             sync_dat_o14;             // synchronous14 data output


//
// Interal14 signal14 declarations14
//

reg     [width-1:0]             sync_dat_o14;
reg     [width-1:0]             flop_014;


// first stage14
always @ (posedge clk_i14 or posedge rst_i14)
begin
    if (rst_i14)
        flop_014 <= #Tp14 {width{init_value14}};
    else
        flop_014 <= #Tp14 async_dat_i14;    
end

// second stage14
always @ (posedge clk_i14 or posedge rst_i14)
begin
    if (rst_i14)
        sync_dat_o14 <= #Tp14 {width{init_value14}};
    else if (stage1_rst_i14)
        sync_dat_o14 <= #Tp14 {width{init_value14}};
    else if (stage1_clk_en_i14)
        sync_dat_o14 <= #Tp14 flop_014;       
end

endmodule
