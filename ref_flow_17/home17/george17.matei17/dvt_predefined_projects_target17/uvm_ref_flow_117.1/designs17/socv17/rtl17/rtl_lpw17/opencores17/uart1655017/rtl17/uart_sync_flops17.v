//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops17.v                                             ////
////                                                              ////
////                                                              ////
////  This17 file is part of the "UART17 16550 compatible17" project17    ////
////  http17://www17.opencores17.org17/cores17/uart1655017/                   ////
////                                                              ////
////  Documentation17 related17 to this project17:                      ////
////  - http17://www17.opencores17.org17/cores17/uart1655017/                 ////
////                                                              ////
////  Projects17 compatibility17:                                     ////
////  - WISHBONE17                                                  ////
////  RS23217 Protocol17                                              ////
////  16550D uart17 (mostly17 supported)                              ////
////                                                              ////
////  Overview17 (main17 Features17):                                   ////
////  UART17 core17 receiver17 logic                                    ////
////                                                              ////
////  Known17 problems17 (limits17):                                    ////
////  None17 known17                                                  ////
////                                                              ////
////  To17 Do17:                                                      ////
////  Thourough17 testing17.                                          ////
////                                                              ////
////  Author17(s):                                                  ////
////      - Andrej17 Erzen17 (andreje17@flextronics17.si17)                 ////
////      - Tadej17 Markovic17 (tadejm17@flextronics17.si17)                ////
////                                                              ////
////  Created17:        2004/05/20                                  ////
////  Last17 Updated17:   2004/05/20                                  ////
////                  (See log17 for the revision17 history17)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2000, 2001 Authors17                             ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS17 Revision17 History17
//
// $Log: not supported by cvs2svn17 $
//


`include "timescale.v"


module uart_sync_flops17
(
  // internal signals17
  rst_i17,
  clk_i17,
  stage1_rst_i17,
  stage1_clk_en_i17,
  async_dat_i17,
  sync_dat_o17
);

parameter Tp17            = 1;
parameter width         = 1;
parameter init_value17    = 1'b0;

input                           rst_i17;                  // reset input
input                           clk_i17;                  // clock17 input
input                           stage1_rst_i17;           // synchronous17 reset for stage17 1 FF17
input                           stage1_clk_en_i17;        // synchronous17 clock17 enable for stage17 1 FF17
input   [width-1:0]             async_dat_i17;            // asynchronous17 data input
output  [width-1:0]             sync_dat_o17;             // synchronous17 data output


//
// Interal17 signal17 declarations17
//

reg     [width-1:0]             sync_dat_o17;
reg     [width-1:0]             flop_017;


// first stage17
always @ (posedge clk_i17 or posedge rst_i17)
begin
    if (rst_i17)
        flop_017 <= #Tp17 {width{init_value17}};
    else
        flop_017 <= #Tp17 async_dat_i17;    
end

// second stage17
always @ (posedge clk_i17 or posedge rst_i17)
begin
    if (rst_i17)
        sync_dat_o17 <= #Tp17 {width{init_value17}};
    else if (stage1_rst_i17)
        sync_dat_o17 <= #Tp17 {width{init_value17}};
    else if (stage1_clk_en_i17)
        sync_dat_o17 <= #Tp17 flop_017;       
end

endmodule
