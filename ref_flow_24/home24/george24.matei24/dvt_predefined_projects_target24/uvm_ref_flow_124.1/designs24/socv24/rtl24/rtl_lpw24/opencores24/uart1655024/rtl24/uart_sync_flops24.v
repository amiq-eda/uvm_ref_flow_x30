//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops24.v                                             ////
////                                                              ////
////                                                              ////
////  This24 file is part of the "UART24 16550 compatible24" project24    ////
////  http24://www24.opencores24.org24/cores24/uart1655024/                   ////
////                                                              ////
////  Documentation24 related24 to this project24:                      ////
////  - http24://www24.opencores24.org24/cores24/uart1655024/                 ////
////                                                              ////
////  Projects24 compatibility24:                                     ////
////  - WISHBONE24                                                  ////
////  RS23224 Protocol24                                              ////
////  16550D uart24 (mostly24 supported)                              ////
////                                                              ////
////  Overview24 (main24 Features24):                                   ////
////  UART24 core24 receiver24 logic                                    ////
////                                                              ////
////  Known24 problems24 (limits24):                                    ////
////  None24 known24                                                  ////
////                                                              ////
////  To24 Do24:                                                      ////
////  Thourough24 testing24.                                          ////
////                                                              ////
////  Author24(s):                                                  ////
////      - Andrej24 Erzen24 (andreje24@flextronics24.si24)                 ////
////      - Tadej24 Markovic24 (tadejm24@flextronics24.si24)                ////
////                                                              ////
////  Created24:        2004/05/20                                  ////
////  Last24 Updated24:   2004/05/20                                  ////
////                  (See log24 for the revision24 history24)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright24 (C) 2000, 2001 Authors24                             ////
////                                                              ////
//// This24 source24 file may be used and distributed24 without         ////
//// restriction24 provided that this copyright24 statement24 is not    ////
//// removed from the file and that any derivative24 work24 contains24  ////
//// the original copyright24 notice24 and the associated disclaimer24. ////
////                                                              ////
//// This24 source24 file is free software24; you can redistribute24 it   ////
//// and/or modify it under the terms24 of the GNU24 Lesser24 General24   ////
//// Public24 License24 as published24 by the Free24 Software24 Foundation24; ////
//// either24 version24 2.1 of the License24, or (at your24 option) any   ////
//// later24 version24.                                               ////
////                                                              ////
//// This24 source24 is distributed24 in the hope24 that it will be       ////
//// useful24, but WITHOUT24 ANY24 WARRANTY24; without even24 the implied24   ////
//// warranty24 of MERCHANTABILITY24 or FITNESS24 FOR24 A PARTICULAR24      ////
//// PURPOSE24.  See the GNU24 Lesser24 General24 Public24 License24 for more ////
//// details24.                                                     ////
////                                                              ////
//// You should have received24 a copy of the GNU24 Lesser24 General24    ////
//// Public24 License24 along24 with this source24; if not, download24 it   ////
//// from http24://www24.opencores24.org24/lgpl24.shtml24                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS24 Revision24 History24
//
// $Log: not supported by cvs2svn24 $
//


`include "timescale.v"


module uart_sync_flops24
(
  // internal signals24
  rst_i24,
  clk_i24,
  stage1_rst_i24,
  stage1_clk_en_i24,
  async_dat_i24,
  sync_dat_o24
);

parameter Tp24            = 1;
parameter width         = 1;
parameter init_value24    = 1'b0;

input                           rst_i24;                  // reset input
input                           clk_i24;                  // clock24 input
input                           stage1_rst_i24;           // synchronous24 reset for stage24 1 FF24
input                           stage1_clk_en_i24;        // synchronous24 clock24 enable for stage24 1 FF24
input   [width-1:0]             async_dat_i24;            // asynchronous24 data input
output  [width-1:0]             sync_dat_o24;             // synchronous24 data output


//
// Interal24 signal24 declarations24
//

reg     [width-1:0]             sync_dat_o24;
reg     [width-1:0]             flop_024;


// first stage24
always @ (posedge clk_i24 or posedge rst_i24)
begin
    if (rst_i24)
        flop_024 <= #Tp24 {width{init_value24}};
    else
        flop_024 <= #Tp24 async_dat_i24;    
end

// second stage24
always @ (posedge clk_i24 or posedge rst_i24)
begin
    if (rst_i24)
        sync_dat_o24 <= #Tp24 {width{init_value24}};
    else if (stage1_rst_i24)
        sync_dat_o24 <= #Tp24 {width{init_value24}};
    else if (stage1_clk_en_i24)
        sync_dat_o24 <= #Tp24 flop_024;       
end

endmodule
