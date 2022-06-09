//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops3.v                                             ////
////                                                              ////
////                                                              ////
////  This3 file is part of the "UART3 16550 compatible3" project3    ////
////  http3://www3.opencores3.org3/cores3/uart165503/                   ////
////                                                              ////
////  Documentation3 related3 to this project3:                      ////
////  - http3://www3.opencores3.org3/cores3/uart165503/                 ////
////                                                              ////
////  Projects3 compatibility3:                                     ////
////  - WISHBONE3                                                  ////
////  RS2323 Protocol3                                              ////
////  16550D uart3 (mostly3 supported)                              ////
////                                                              ////
////  Overview3 (main3 Features3):                                   ////
////  UART3 core3 receiver3 logic                                    ////
////                                                              ////
////  Known3 problems3 (limits3):                                    ////
////  None3 known3                                                  ////
////                                                              ////
////  To3 Do3:                                                      ////
////  Thourough3 testing3.                                          ////
////                                                              ////
////  Author3(s):                                                  ////
////      - Andrej3 Erzen3 (andreje3@flextronics3.si3)                 ////
////      - Tadej3 Markovic3 (tadejm3@flextronics3.si3)                ////
////                                                              ////
////  Created3:        2004/05/20                                  ////
////  Last3 Updated3:   2004/05/20                                  ////
////                  (See log3 for the revision3 history3)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2000, 2001 Authors3                             ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS3 Revision3 History3
//
// $Log: not supported by cvs2svn3 $
//


`include "timescale.v"


module uart_sync_flops3
(
  // internal signals3
  rst_i3,
  clk_i3,
  stage1_rst_i3,
  stage1_clk_en_i3,
  async_dat_i3,
  sync_dat_o3
);

parameter Tp3            = 1;
parameter width         = 1;
parameter init_value3    = 1'b0;

input                           rst_i3;                  // reset input
input                           clk_i3;                  // clock3 input
input                           stage1_rst_i3;           // synchronous3 reset for stage3 1 FF3
input                           stage1_clk_en_i3;        // synchronous3 clock3 enable for stage3 1 FF3
input   [width-1:0]             async_dat_i3;            // asynchronous3 data input
output  [width-1:0]             sync_dat_o3;             // synchronous3 data output


//
// Interal3 signal3 declarations3
//

reg     [width-1:0]             sync_dat_o3;
reg     [width-1:0]             flop_03;


// first stage3
always @ (posedge clk_i3 or posedge rst_i3)
begin
    if (rst_i3)
        flop_03 <= #Tp3 {width{init_value3}};
    else
        flop_03 <= #Tp3 async_dat_i3;    
end

// second stage3
always @ (posedge clk_i3 or posedge rst_i3)
begin
    if (rst_i3)
        sync_dat_o3 <= #Tp3 {width{init_value3}};
    else if (stage1_rst_i3)
        sync_dat_o3 <= #Tp3 {width{init_value3}};
    else if (stage1_clk_en_i3)
        sync_dat_o3 <= #Tp3 flop_03;       
end

endmodule
