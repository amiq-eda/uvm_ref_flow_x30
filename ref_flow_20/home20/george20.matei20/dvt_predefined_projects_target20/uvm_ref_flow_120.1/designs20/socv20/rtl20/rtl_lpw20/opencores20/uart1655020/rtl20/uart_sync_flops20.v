//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops20.v                                             ////
////                                                              ////
////                                                              ////
////  This20 file is part of the "UART20 16550 compatible20" project20    ////
////  http20://www20.opencores20.org20/cores20/uart1655020/                   ////
////                                                              ////
////  Documentation20 related20 to this project20:                      ////
////  - http20://www20.opencores20.org20/cores20/uart1655020/                 ////
////                                                              ////
////  Projects20 compatibility20:                                     ////
////  - WISHBONE20                                                  ////
////  RS23220 Protocol20                                              ////
////  16550D uart20 (mostly20 supported)                              ////
////                                                              ////
////  Overview20 (main20 Features20):                                   ////
////  UART20 core20 receiver20 logic                                    ////
////                                                              ////
////  Known20 problems20 (limits20):                                    ////
////  None20 known20                                                  ////
////                                                              ////
////  To20 Do20:                                                      ////
////  Thourough20 testing20.                                          ////
////                                                              ////
////  Author20(s):                                                  ////
////      - Andrej20 Erzen20 (andreje20@flextronics20.si20)                 ////
////      - Tadej20 Markovic20 (tadejm20@flextronics20.si20)                ////
////                                                              ////
////  Created20:        2004/05/20                                  ////
////  Last20 Updated20:   2004/05/20                                  ////
////                  (See log20 for the revision20 history20)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2000, 2001 Authors20                             ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS20 Revision20 History20
//
// $Log: not supported by cvs2svn20 $
//


`include "timescale.v"


module uart_sync_flops20
(
  // internal signals20
  rst_i20,
  clk_i20,
  stage1_rst_i20,
  stage1_clk_en_i20,
  async_dat_i20,
  sync_dat_o20
);

parameter Tp20            = 1;
parameter width         = 1;
parameter init_value20    = 1'b0;

input                           rst_i20;                  // reset input
input                           clk_i20;                  // clock20 input
input                           stage1_rst_i20;           // synchronous20 reset for stage20 1 FF20
input                           stage1_clk_en_i20;        // synchronous20 clock20 enable for stage20 1 FF20
input   [width-1:0]             async_dat_i20;            // asynchronous20 data input
output  [width-1:0]             sync_dat_o20;             // synchronous20 data output


//
// Interal20 signal20 declarations20
//

reg     [width-1:0]             sync_dat_o20;
reg     [width-1:0]             flop_020;


// first stage20
always @ (posedge clk_i20 or posedge rst_i20)
begin
    if (rst_i20)
        flop_020 <= #Tp20 {width{init_value20}};
    else
        flop_020 <= #Tp20 async_dat_i20;    
end

// second stage20
always @ (posedge clk_i20 or posedge rst_i20)
begin
    if (rst_i20)
        sync_dat_o20 <= #Tp20 {width{init_value20}};
    else if (stage1_rst_i20)
        sync_dat_o20 <= #Tp20 {width{init_value20}};
    else if (stage1_clk_en_i20)
        sync_dat_o20 <= #Tp20 flop_020;       
end

endmodule
