//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops26.v                                             ////
////                                                              ////
////                                                              ////
////  This26 file is part of the "UART26 16550 compatible26" project26    ////
////  http26://www26.opencores26.org26/cores26/uart1655026/                   ////
////                                                              ////
////  Documentation26 related26 to this project26:                      ////
////  - http26://www26.opencores26.org26/cores26/uart1655026/                 ////
////                                                              ////
////  Projects26 compatibility26:                                     ////
////  - WISHBONE26                                                  ////
////  RS23226 Protocol26                                              ////
////  16550D uart26 (mostly26 supported)                              ////
////                                                              ////
////  Overview26 (main26 Features26):                                   ////
////  UART26 core26 receiver26 logic                                    ////
////                                                              ////
////  Known26 problems26 (limits26):                                    ////
////  None26 known26                                                  ////
////                                                              ////
////  To26 Do26:                                                      ////
////  Thourough26 testing26.                                          ////
////                                                              ////
////  Author26(s):                                                  ////
////      - Andrej26 Erzen26 (andreje26@flextronics26.si26)                 ////
////      - Tadej26 Markovic26 (tadejm26@flextronics26.si26)                ////
////                                                              ////
////  Created26:        2004/05/20                                  ////
////  Last26 Updated26:   2004/05/20                                  ////
////                  (See log26 for the revision26 history26)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2000, 2001 Authors26                             ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS26 Revision26 History26
//
// $Log: not supported by cvs2svn26 $
//


`include "timescale.v"


module uart_sync_flops26
(
  // internal signals26
  rst_i26,
  clk_i26,
  stage1_rst_i26,
  stage1_clk_en_i26,
  async_dat_i26,
  sync_dat_o26
);

parameter Tp26            = 1;
parameter width         = 1;
parameter init_value26    = 1'b0;

input                           rst_i26;                  // reset input
input                           clk_i26;                  // clock26 input
input                           stage1_rst_i26;           // synchronous26 reset for stage26 1 FF26
input                           stage1_clk_en_i26;        // synchronous26 clock26 enable for stage26 1 FF26
input   [width-1:0]             async_dat_i26;            // asynchronous26 data input
output  [width-1:0]             sync_dat_o26;             // synchronous26 data output


//
// Interal26 signal26 declarations26
//

reg     [width-1:0]             sync_dat_o26;
reg     [width-1:0]             flop_026;


// first stage26
always @ (posedge clk_i26 or posedge rst_i26)
begin
    if (rst_i26)
        flop_026 <= #Tp26 {width{init_value26}};
    else
        flop_026 <= #Tp26 async_dat_i26;    
end

// second stage26
always @ (posedge clk_i26 or posedge rst_i26)
begin
    if (rst_i26)
        sync_dat_o26 <= #Tp26 {width{init_value26}};
    else if (stage1_rst_i26)
        sync_dat_o26 <= #Tp26 {width{init_value26}};
    else if (stage1_clk_en_i26)
        sync_dat_o26 <= #Tp26 flop_026;       
end

endmodule
