//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops8.v                                             ////
////                                                              ////
////                                                              ////
////  This8 file is part of the "UART8 16550 compatible8" project8    ////
////  http8://www8.opencores8.org8/cores8/uart165508/                   ////
////                                                              ////
////  Documentation8 related8 to this project8:                      ////
////  - http8://www8.opencores8.org8/cores8/uart165508/                 ////
////                                                              ////
////  Projects8 compatibility8:                                     ////
////  - WISHBONE8                                                  ////
////  RS2328 Protocol8                                              ////
////  16550D uart8 (mostly8 supported)                              ////
////                                                              ////
////  Overview8 (main8 Features8):                                   ////
////  UART8 core8 receiver8 logic                                    ////
////                                                              ////
////  Known8 problems8 (limits8):                                    ////
////  None8 known8                                                  ////
////                                                              ////
////  To8 Do8:                                                      ////
////  Thourough8 testing8.                                          ////
////                                                              ////
////  Author8(s):                                                  ////
////      - Andrej8 Erzen8 (andreje8@flextronics8.si8)                 ////
////      - Tadej8 Markovic8 (tadejm8@flextronics8.si8)                ////
////                                                              ////
////  Created8:        2004/05/20                                  ////
////  Last8 Updated8:   2004/05/20                                  ////
////                  (See log8 for the revision8 history8)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2000, 2001 Authors8                             ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS8 Revision8 History8
//
// $Log: not supported by cvs2svn8 $
//


`include "timescale.v"


module uart_sync_flops8
(
  // internal signals8
  rst_i8,
  clk_i8,
  stage1_rst_i8,
  stage1_clk_en_i8,
  async_dat_i8,
  sync_dat_o8
);

parameter Tp8            = 1;
parameter width         = 1;
parameter init_value8    = 1'b0;

input                           rst_i8;                  // reset input
input                           clk_i8;                  // clock8 input
input                           stage1_rst_i8;           // synchronous8 reset for stage8 1 FF8
input                           stage1_clk_en_i8;        // synchronous8 clock8 enable for stage8 1 FF8
input   [width-1:0]             async_dat_i8;            // asynchronous8 data input
output  [width-1:0]             sync_dat_o8;             // synchronous8 data output


//
// Interal8 signal8 declarations8
//

reg     [width-1:0]             sync_dat_o8;
reg     [width-1:0]             flop_08;


// first stage8
always @ (posedge clk_i8 or posedge rst_i8)
begin
    if (rst_i8)
        flop_08 <= #Tp8 {width{init_value8}};
    else
        flop_08 <= #Tp8 async_dat_i8;    
end

// second stage8
always @ (posedge clk_i8 or posedge rst_i8)
begin
    if (rst_i8)
        sync_dat_o8 <= #Tp8 {width{init_value8}};
    else if (stage1_rst_i8)
        sync_dat_o8 <= #Tp8 {width{init_value8}};
    else if (stage1_clk_en_i8)
        sync_dat_o8 <= #Tp8 flop_08;       
end

endmodule
