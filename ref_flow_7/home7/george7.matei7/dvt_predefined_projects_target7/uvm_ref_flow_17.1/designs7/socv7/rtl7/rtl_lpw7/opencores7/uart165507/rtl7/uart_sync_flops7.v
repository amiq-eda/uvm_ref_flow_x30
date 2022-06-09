//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops7.v                                             ////
////                                                              ////
////                                                              ////
////  This7 file is part of the "UART7 16550 compatible7" project7    ////
////  http7://www7.opencores7.org7/cores7/uart165507/                   ////
////                                                              ////
////  Documentation7 related7 to this project7:                      ////
////  - http7://www7.opencores7.org7/cores7/uart165507/                 ////
////                                                              ////
////  Projects7 compatibility7:                                     ////
////  - WISHBONE7                                                  ////
////  RS2327 Protocol7                                              ////
////  16550D uart7 (mostly7 supported)                              ////
////                                                              ////
////  Overview7 (main7 Features7):                                   ////
////  UART7 core7 receiver7 logic                                    ////
////                                                              ////
////  Known7 problems7 (limits7):                                    ////
////  None7 known7                                                  ////
////                                                              ////
////  To7 Do7:                                                      ////
////  Thourough7 testing7.                                          ////
////                                                              ////
////  Author7(s):                                                  ////
////      - Andrej7 Erzen7 (andreje7@flextronics7.si7)                 ////
////      - Tadej7 Markovic7 (tadejm7@flextronics7.si7)                ////
////                                                              ////
////  Created7:        2004/05/20                                  ////
////  Last7 Updated7:   2004/05/20                                  ////
////                  (See log7 for the revision7 history7)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2000, 2001 Authors7                             ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS7 Revision7 History7
//
// $Log: not supported by cvs2svn7 $
//


`include "timescale.v"


module uart_sync_flops7
(
  // internal signals7
  rst_i7,
  clk_i7,
  stage1_rst_i7,
  stage1_clk_en_i7,
  async_dat_i7,
  sync_dat_o7
);

parameter Tp7            = 1;
parameter width         = 1;
parameter init_value7    = 1'b0;

input                           rst_i7;                  // reset input
input                           clk_i7;                  // clock7 input
input                           stage1_rst_i7;           // synchronous7 reset for stage7 1 FF7
input                           stage1_clk_en_i7;        // synchronous7 clock7 enable for stage7 1 FF7
input   [width-1:0]             async_dat_i7;            // asynchronous7 data input
output  [width-1:0]             sync_dat_o7;             // synchronous7 data output


//
// Interal7 signal7 declarations7
//

reg     [width-1:0]             sync_dat_o7;
reg     [width-1:0]             flop_07;


// first stage7
always @ (posedge clk_i7 or posedge rst_i7)
begin
    if (rst_i7)
        flop_07 <= #Tp7 {width{init_value7}};
    else
        flop_07 <= #Tp7 async_dat_i7;    
end

// second stage7
always @ (posedge clk_i7 or posedge rst_i7)
begin
    if (rst_i7)
        sync_dat_o7 <= #Tp7 {width{init_value7}};
    else if (stage1_rst_i7)
        sync_dat_o7 <= #Tp7 {width{init_value7}};
    else if (stage1_clk_en_i7)
        sync_dat_o7 <= #Tp7 flop_07;       
end

endmodule
