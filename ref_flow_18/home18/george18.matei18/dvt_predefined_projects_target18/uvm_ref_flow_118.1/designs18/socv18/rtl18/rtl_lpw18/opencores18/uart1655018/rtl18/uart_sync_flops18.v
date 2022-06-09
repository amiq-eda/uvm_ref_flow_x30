//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops18.v                                             ////
////                                                              ////
////                                                              ////
////  This18 file is part of the "UART18 16550 compatible18" project18    ////
////  http18://www18.opencores18.org18/cores18/uart1655018/                   ////
////                                                              ////
////  Documentation18 related18 to this project18:                      ////
////  - http18://www18.opencores18.org18/cores18/uart1655018/                 ////
////                                                              ////
////  Projects18 compatibility18:                                     ////
////  - WISHBONE18                                                  ////
////  RS23218 Protocol18                                              ////
////  16550D uart18 (mostly18 supported)                              ////
////                                                              ////
////  Overview18 (main18 Features18):                                   ////
////  UART18 core18 receiver18 logic                                    ////
////                                                              ////
////  Known18 problems18 (limits18):                                    ////
////  None18 known18                                                  ////
////                                                              ////
////  To18 Do18:                                                      ////
////  Thourough18 testing18.                                          ////
////                                                              ////
////  Author18(s):                                                  ////
////      - Andrej18 Erzen18 (andreje18@flextronics18.si18)                 ////
////      - Tadej18 Markovic18 (tadejm18@flextronics18.si18)                ////
////                                                              ////
////  Created18:        2004/05/20                                  ////
////  Last18 Updated18:   2004/05/20                                  ////
////                  (See log18 for the revision18 history18)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2000, 2001 Authors18                             ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS18 Revision18 History18
//
// $Log: not supported by cvs2svn18 $
//


`include "timescale.v"


module uart_sync_flops18
(
  // internal signals18
  rst_i18,
  clk_i18,
  stage1_rst_i18,
  stage1_clk_en_i18,
  async_dat_i18,
  sync_dat_o18
);

parameter Tp18            = 1;
parameter width         = 1;
parameter init_value18    = 1'b0;

input                           rst_i18;                  // reset input
input                           clk_i18;                  // clock18 input
input                           stage1_rst_i18;           // synchronous18 reset for stage18 1 FF18
input                           stage1_clk_en_i18;        // synchronous18 clock18 enable for stage18 1 FF18
input   [width-1:0]             async_dat_i18;            // asynchronous18 data input
output  [width-1:0]             sync_dat_o18;             // synchronous18 data output


//
// Interal18 signal18 declarations18
//

reg     [width-1:0]             sync_dat_o18;
reg     [width-1:0]             flop_018;


// first stage18
always @ (posedge clk_i18 or posedge rst_i18)
begin
    if (rst_i18)
        flop_018 <= #Tp18 {width{init_value18}};
    else
        flop_018 <= #Tp18 async_dat_i18;    
end

// second stage18
always @ (posedge clk_i18 or posedge rst_i18)
begin
    if (rst_i18)
        sync_dat_o18 <= #Tp18 {width{init_value18}};
    else if (stage1_rst_i18)
        sync_dat_o18 <= #Tp18 {width{init_value18}};
    else if (stage1_clk_en_i18)
        sync_dat_o18 <= #Tp18 flop_018;       
end

endmodule
