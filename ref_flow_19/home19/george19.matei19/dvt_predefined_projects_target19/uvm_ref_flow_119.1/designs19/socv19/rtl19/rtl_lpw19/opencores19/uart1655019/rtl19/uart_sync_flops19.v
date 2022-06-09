//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops19.v                                             ////
////                                                              ////
////                                                              ////
////  This19 file is part of the "UART19 16550 compatible19" project19    ////
////  http19://www19.opencores19.org19/cores19/uart1655019/                   ////
////                                                              ////
////  Documentation19 related19 to this project19:                      ////
////  - http19://www19.opencores19.org19/cores19/uart1655019/                 ////
////                                                              ////
////  Projects19 compatibility19:                                     ////
////  - WISHBONE19                                                  ////
////  RS23219 Protocol19                                              ////
////  16550D uart19 (mostly19 supported)                              ////
////                                                              ////
////  Overview19 (main19 Features19):                                   ////
////  UART19 core19 receiver19 logic                                    ////
////                                                              ////
////  Known19 problems19 (limits19):                                    ////
////  None19 known19                                                  ////
////                                                              ////
////  To19 Do19:                                                      ////
////  Thourough19 testing19.                                          ////
////                                                              ////
////  Author19(s):                                                  ////
////      - Andrej19 Erzen19 (andreje19@flextronics19.si19)                 ////
////      - Tadej19 Markovic19 (tadejm19@flextronics19.si19)                ////
////                                                              ////
////  Created19:        2004/05/20                                  ////
////  Last19 Updated19:   2004/05/20                                  ////
////                  (See log19 for the revision19 history19)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2000, 2001 Authors19                             ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS19 Revision19 History19
//
// $Log: not supported by cvs2svn19 $
//


`include "timescale.v"


module uart_sync_flops19
(
  // internal signals19
  rst_i19,
  clk_i19,
  stage1_rst_i19,
  stage1_clk_en_i19,
  async_dat_i19,
  sync_dat_o19
);

parameter Tp19            = 1;
parameter width         = 1;
parameter init_value19    = 1'b0;

input                           rst_i19;                  // reset input
input                           clk_i19;                  // clock19 input
input                           stage1_rst_i19;           // synchronous19 reset for stage19 1 FF19
input                           stage1_clk_en_i19;        // synchronous19 clock19 enable for stage19 1 FF19
input   [width-1:0]             async_dat_i19;            // asynchronous19 data input
output  [width-1:0]             sync_dat_o19;             // synchronous19 data output


//
// Interal19 signal19 declarations19
//

reg     [width-1:0]             sync_dat_o19;
reg     [width-1:0]             flop_019;


// first stage19
always @ (posedge clk_i19 or posedge rst_i19)
begin
    if (rst_i19)
        flop_019 <= #Tp19 {width{init_value19}};
    else
        flop_019 <= #Tp19 async_dat_i19;    
end

// second stage19
always @ (posedge clk_i19 or posedge rst_i19)
begin
    if (rst_i19)
        sync_dat_o19 <= #Tp19 {width{init_value19}};
    else if (stage1_rst_i19)
        sync_dat_o19 <= #Tp19 {width{init_value19}};
    else if (stage1_clk_en_i19)
        sync_dat_o19 <= #Tp19 flop_019;       
end

endmodule
