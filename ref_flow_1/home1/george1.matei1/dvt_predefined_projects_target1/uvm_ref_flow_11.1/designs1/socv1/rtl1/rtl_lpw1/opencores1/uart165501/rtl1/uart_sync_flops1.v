//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops1.v                                             ////
////                                                              ////
////                                                              ////
////  This1 file is part of the "UART1 16550 compatible1" project1    ////
////  http1://www1.opencores1.org1/cores1/uart165501/                   ////
////                                                              ////
////  Documentation1 related1 to this project1:                      ////
////  - http1://www1.opencores1.org1/cores1/uart165501/                 ////
////                                                              ////
////  Projects1 compatibility1:                                     ////
////  - WISHBONE1                                                  ////
////  RS2321 Protocol1                                              ////
////  16550D uart1 (mostly1 supported)                              ////
////                                                              ////
////  Overview1 (main1 Features1):                                   ////
////  UART1 core1 receiver1 logic                                    ////
////                                                              ////
////  Known1 problems1 (limits1):                                    ////
////  None1 known1                                                  ////
////                                                              ////
////  To1 Do1:                                                      ////
////  Thourough1 testing1.                                          ////
////                                                              ////
////  Author1(s):                                                  ////
////      - Andrej1 Erzen1 (andreje1@flextronics1.si1)                 ////
////      - Tadej1 Markovic1 (tadejm1@flextronics1.si1)                ////
////                                                              ////
////  Created1:        2004/05/20                                  ////
////  Last1 Updated1:   2004/05/20                                  ////
////                  (See log1 for the revision1 history1)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright1 (C) 2000, 2001 Authors1                             ////
////                                                              ////
//// This1 source1 file may be used and distributed1 without         ////
//// restriction1 provided that this copyright1 statement1 is not    ////
//// removed from the file and that any derivative1 work1 contains1  ////
//// the original copyright1 notice1 and the associated disclaimer1. ////
////                                                              ////
//// This1 source1 file is free software1; you can redistribute1 it   ////
//// and/or modify it under the terms1 of the GNU1 Lesser1 General1   ////
//// Public1 License1 as published1 by the Free1 Software1 Foundation1; ////
//// either1 version1 2.1 of the License1, or (at your1 option) any   ////
//// later1 version1.                                               ////
////                                                              ////
//// This1 source1 is distributed1 in the hope1 that it will be       ////
//// useful1, but WITHOUT1 ANY1 WARRANTY1; without even1 the implied1   ////
//// warranty1 of MERCHANTABILITY1 or FITNESS1 FOR1 A PARTICULAR1      ////
//// PURPOSE1.  See the GNU1 Lesser1 General1 Public1 License1 for more ////
//// details1.                                                     ////
////                                                              ////
//// You should have received1 a copy of the GNU1 Lesser1 General1    ////
//// Public1 License1 along1 with this source1; if not, download1 it   ////
//// from http1://www1.opencores1.org1/lgpl1.shtml1                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS1 Revision1 History1
//
// $Log: not supported by cvs2svn1 $
//


`include "timescale.v"


module uart_sync_flops1
(
  // internal signals1
  rst_i1,
  clk_i1,
  stage1_rst_i1,
  stage1_clk_en_i1,
  async_dat_i1,
  sync_dat_o1
);

parameter Tp1            = 1;
parameter width         = 1;
parameter init_value1    = 1'b0;

input                           rst_i1;                  // reset input
input                           clk_i1;                  // clock1 input
input                           stage1_rst_i1;           // synchronous1 reset for stage1 1 FF1
input                           stage1_clk_en_i1;        // synchronous1 clock1 enable for stage1 1 FF1
input   [width-1:0]             async_dat_i1;            // asynchronous1 data input
output  [width-1:0]             sync_dat_o1;             // synchronous1 data output


//
// Interal1 signal1 declarations1
//

reg     [width-1:0]             sync_dat_o1;
reg     [width-1:0]             flop_01;


// first stage1
always @ (posedge clk_i1 or posedge rst_i1)
begin
    if (rst_i1)
        flop_01 <= #Tp1 {width{init_value1}};
    else
        flop_01 <= #Tp1 async_dat_i1;    
end

// second stage1
always @ (posedge clk_i1 or posedge rst_i1)
begin
    if (rst_i1)
        sync_dat_o1 <= #Tp1 {width{init_value1}};
    else if (stage1_rst_i1)
        sync_dat_o1 <= #Tp1 {width{init_value1}};
    else if (stage1_clk_en_i1)
        sync_dat_o1 <= #Tp1 flop_01;       
end

endmodule
