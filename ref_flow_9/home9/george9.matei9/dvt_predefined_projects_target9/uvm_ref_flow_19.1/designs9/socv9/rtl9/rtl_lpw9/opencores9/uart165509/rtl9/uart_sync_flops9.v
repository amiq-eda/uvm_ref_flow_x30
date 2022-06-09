//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops9.v                                             ////
////                                                              ////
////                                                              ////
////  This9 file is part of the "UART9 16550 compatible9" project9    ////
////  http9://www9.opencores9.org9/cores9/uart165509/                   ////
////                                                              ////
////  Documentation9 related9 to this project9:                      ////
////  - http9://www9.opencores9.org9/cores9/uart165509/                 ////
////                                                              ////
////  Projects9 compatibility9:                                     ////
////  - WISHBONE9                                                  ////
////  RS2329 Protocol9                                              ////
////  16550D uart9 (mostly9 supported)                              ////
////                                                              ////
////  Overview9 (main9 Features9):                                   ////
////  UART9 core9 receiver9 logic                                    ////
////                                                              ////
////  Known9 problems9 (limits9):                                    ////
////  None9 known9                                                  ////
////                                                              ////
////  To9 Do9:                                                      ////
////  Thourough9 testing9.                                          ////
////                                                              ////
////  Author9(s):                                                  ////
////      - Andrej9 Erzen9 (andreje9@flextronics9.si9)                 ////
////      - Tadej9 Markovic9 (tadejm9@flextronics9.si9)                ////
////                                                              ////
////  Created9:        2004/05/20                                  ////
////  Last9 Updated9:   2004/05/20                                  ////
////                  (See log9 for the revision9 history9)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2000, 2001 Authors9                             ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS9 Revision9 History9
//
// $Log: not supported by cvs2svn9 $
//


`include "timescale.v"


module uart_sync_flops9
(
  // internal signals9
  rst_i9,
  clk_i9,
  stage1_rst_i9,
  stage1_clk_en_i9,
  async_dat_i9,
  sync_dat_o9
);

parameter Tp9            = 1;
parameter width         = 1;
parameter init_value9    = 1'b0;

input                           rst_i9;                  // reset input
input                           clk_i9;                  // clock9 input
input                           stage1_rst_i9;           // synchronous9 reset for stage9 1 FF9
input                           stage1_clk_en_i9;        // synchronous9 clock9 enable for stage9 1 FF9
input   [width-1:0]             async_dat_i9;            // asynchronous9 data input
output  [width-1:0]             sync_dat_o9;             // synchronous9 data output


//
// Interal9 signal9 declarations9
//

reg     [width-1:0]             sync_dat_o9;
reg     [width-1:0]             flop_09;


// first stage9
always @ (posedge clk_i9 or posedge rst_i9)
begin
    if (rst_i9)
        flop_09 <= #Tp9 {width{init_value9}};
    else
        flop_09 <= #Tp9 async_dat_i9;    
end

// second stage9
always @ (posedge clk_i9 or posedge rst_i9)
begin
    if (rst_i9)
        sync_dat_o9 <= #Tp9 {width{init_value9}};
    else if (stage1_rst_i9)
        sync_dat_o9 <= #Tp9 {width{init_value9}};
    else if (stage1_clk_en_i9)
        sync_dat_o9 <= #Tp9 flop_09;       
end

endmodule
