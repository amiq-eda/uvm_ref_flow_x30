//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops13.v                                             ////
////                                                              ////
////                                                              ////
////  This13 file is part of the "UART13 16550 compatible13" project13    ////
////  http13://www13.opencores13.org13/cores13/uart1655013/                   ////
////                                                              ////
////  Documentation13 related13 to this project13:                      ////
////  - http13://www13.opencores13.org13/cores13/uart1655013/                 ////
////                                                              ////
////  Projects13 compatibility13:                                     ////
////  - WISHBONE13                                                  ////
////  RS23213 Protocol13                                              ////
////  16550D uart13 (mostly13 supported)                              ////
////                                                              ////
////  Overview13 (main13 Features13):                                   ////
////  UART13 core13 receiver13 logic                                    ////
////                                                              ////
////  Known13 problems13 (limits13):                                    ////
////  None13 known13                                                  ////
////                                                              ////
////  To13 Do13:                                                      ////
////  Thourough13 testing13.                                          ////
////                                                              ////
////  Author13(s):                                                  ////
////      - Andrej13 Erzen13 (andreje13@flextronics13.si13)                 ////
////      - Tadej13 Markovic13 (tadejm13@flextronics13.si13)                ////
////                                                              ////
////  Created13:        2004/05/20                                  ////
////  Last13 Updated13:   2004/05/20                                  ////
////                  (See log13 for the revision13 history13)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2000, 2001 Authors13                             ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS13 Revision13 History13
//
// $Log: not supported by cvs2svn13 $
//


`include "timescale.v"


module uart_sync_flops13
(
  // internal signals13
  rst_i13,
  clk_i13,
  stage1_rst_i13,
  stage1_clk_en_i13,
  async_dat_i13,
  sync_dat_o13
);

parameter Tp13            = 1;
parameter width         = 1;
parameter init_value13    = 1'b0;

input                           rst_i13;                  // reset input
input                           clk_i13;                  // clock13 input
input                           stage1_rst_i13;           // synchronous13 reset for stage13 1 FF13
input                           stage1_clk_en_i13;        // synchronous13 clock13 enable for stage13 1 FF13
input   [width-1:0]             async_dat_i13;            // asynchronous13 data input
output  [width-1:0]             sync_dat_o13;             // synchronous13 data output


//
// Interal13 signal13 declarations13
//

reg     [width-1:0]             sync_dat_o13;
reg     [width-1:0]             flop_013;


// first stage13
always @ (posedge clk_i13 or posedge rst_i13)
begin
    if (rst_i13)
        flop_013 <= #Tp13 {width{init_value13}};
    else
        flop_013 <= #Tp13 async_dat_i13;    
end

// second stage13
always @ (posedge clk_i13 or posedge rst_i13)
begin
    if (rst_i13)
        sync_dat_o13 <= #Tp13 {width{init_value13}};
    else if (stage1_rst_i13)
        sync_dat_o13 <= #Tp13 {width{init_value13}};
    else if (stage1_clk_en_i13)
        sync_dat_o13 <= #Tp13 flop_013;       
end

endmodule
