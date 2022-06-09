//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops15.v                                             ////
////                                                              ////
////                                                              ////
////  This15 file is part of the "UART15 16550 compatible15" project15    ////
////  http15://www15.opencores15.org15/cores15/uart1655015/                   ////
////                                                              ////
////  Documentation15 related15 to this project15:                      ////
////  - http15://www15.opencores15.org15/cores15/uart1655015/                 ////
////                                                              ////
////  Projects15 compatibility15:                                     ////
////  - WISHBONE15                                                  ////
////  RS23215 Protocol15                                              ////
////  16550D uart15 (mostly15 supported)                              ////
////                                                              ////
////  Overview15 (main15 Features15):                                   ////
////  UART15 core15 receiver15 logic                                    ////
////                                                              ////
////  Known15 problems15 (limits15):                                    ////
////  None15 known15                                                  ////
////                                                              ////
////  To15 Do15:                                                      ////
////  Thourough15 testing15.                                          ////
////                                                              ////
////  Author15(s):                                                  ////
////      - Andrej15 Erzen15 (andreje15@flextronics15.si15)                 ////
////      - Tadej15 Markovic15 (tadejm15@flextronics15.si15)                ////
////                                                              ////
////  Created15:        2004/05/20                                  ////
////  Last15 Updated15:   2004/05/20                                  ////
////                  (See log15 for the revision15 history15)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2000, 2001 Authors15                             ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS15 Revision15 History15
//
// $Log: not supported by cvs2svn15 $
//


`include "timescale.v"


module uart_sync_flops15
(
  // internal signals15
  rst_i15,
  clk_i15,
  stage1_rst_i15,
  stage1_clk_en_i15,
  async_dat_i15,
  sync_dat_o15
);

parameter Tp15            = 1;
parameter width         = 1;
parameter init_value15    = 1'b0;

input                           rst_i15;                  // reset input
input                           clk_i15;                  // clock15 input
input                           stage1_rst_i15;           // synchronous15 reset for stage15 1 FF15
input                           stage1_clk_en_i15;        // synchronous15 clock15 enable for stage15 1 FF15
input   [width-1:0]             async_dat_i15;            // asynchronous15 data input
output  [width-1:0]             sync_dat_o15;             // synchronous15 data output


//
// Interal15 signal15 declarations15
//

reg     [width-1:0]             sync_dat_o15;
reg     [width-1:0]             flop_015;


// first stage15
always @ (posedge clk_i15 or posedge rst_i15)
begin
    if (rst_i15)
        flop_015 <= #Tp15 {width{init_value15}};
    else
        flop_015 <= #Tp15 async_dat_i15;    
end

// second stage15
always @ (posedge clk_i15 or posedge rst_i15)
begin
    if (rst_i15)
        sync_dat_o15 <= #Tp15 {width{init_value15}};
    else if (stage1_rst_i15)
        sync_dat_o15 <= #Tp15 {width{init_value15}};
    else if (stage1_clk_en_i15)
        sync_dat_o15 <= #Tp15 flop_015;       
end

endmodule
