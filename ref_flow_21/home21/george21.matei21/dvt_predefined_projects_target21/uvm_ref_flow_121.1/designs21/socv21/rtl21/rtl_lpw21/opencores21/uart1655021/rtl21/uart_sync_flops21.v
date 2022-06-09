//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops21.v                                             ////
////                                                              ////
////                                                              ////
////  This21 file is part of the "UART21 16550 compatible21" project21    ////
////  http21://www21.opencores21.org21/cores21/uart1655021/                   ////
////                                                              ////
////  Documentation21 related21 to this project21:                      ////
////  - http21://www21.opencores21.org21/cores21/uart1655021/                 ////
////                                                              ////
////  Projects21 compatibility21:                                     ////
////  - WISHBONE21                                                  ////
////  RS23221 Protocol21                                              ////
////  16550D uart21 (mostly21 supported)                              ////
////                                                              ////
////  Overview21 (main21 Features21):                                   ////
////  UART21 core21 receiver21 logic                                    ////
////                                                              ////
////  Known21 problems21 (limits21):                                    ////
////  None21 known21                                                  ////
////                                                              ////
////  To21 Do21:                                                      ////
////  Thourough21 testing21.                                          ////
////                                                              ////
////  Author21(s):                                                  ////
////      - Andrej21 Erzen21 (andreje21@flextronics21.si21)                 ////
////      - Tadej21 Markovic21 (tadejm21@flextronics21.si21)                ////
////                                                              ////
////  Created21:        2004/05/20                                  ////
////  Last21 Updated21:   2004/05/20                                  ////
////                  (See log21 for the revision21 history21)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2000, 2001 Authors21                             ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS21 Revision21 History21
//
// $Log: not supported by cvs2svn21 $
//


`include "timescale.v"


module uart_sync_flops21
(
  // internal signals21
  rst_i21,
  clk_i21,
  stage1_rst_i21,
  stage1_clk_en_i21,
  async_dat_i21,
  sync_dat_o21
);

parameter Tp21            = 1;
parameter width         = 1;
parameter init_value21    = 1'b0;

input                           rst_i21;                  // reset input
input                           clk_i21;                  // clock21 input
input                           stage1_rst_i21;           // synchronous21 reset for stage21 1 FF21
input                           stage1_clk_en_i21;        // synchronous21 clock21 enable for stage21 1 FF21
input   [width-1:0]             async_dat_i21;            // asynchronous21 data input
output  [width-1:0]             sync_dat_o21;             // synchronous21 data output


//
// Interal21 signal21 declarations21
//

reg     [width-1:0]             sync_dat_o21;
reg     [width-1:0]             flop_021;


// first stage21
always @ (posedge clk_i21 or posedge rst_i21)
begin
    if (rst_i21)
        flop_021 <= #Tp21 {width{init_value21}};
    else
        flop_021 <= #Tp21 async_dat_i21;    
end

// second stage21
always @ (posedge clk_i21 or posedge rst_i21)
begin
    if (rst_i21)
        sync_dat_o21 <= #Tp21 {width{init_value21}};
    else if (stage1_rst_i21)
        sync_dat_o21 <= #Tp21 {width{init_value21}};
    else if (stage1_clk_en_i21)
        sync_dat_o21 <= #Tp21 flop_021;       
end

endmodule
