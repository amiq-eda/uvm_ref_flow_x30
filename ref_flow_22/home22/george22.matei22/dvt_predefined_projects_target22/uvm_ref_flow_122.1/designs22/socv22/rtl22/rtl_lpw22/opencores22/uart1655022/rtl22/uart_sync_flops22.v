//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops22.v                                             ////
////                                                              ////
////                                                              ////
////  This22 file is part of the "UART22 16550 compatible22" project22    ////
////  http22://www22.opencores22.org22/cores22/uart1655022/                   ////
////                                                              ////
////  Documentation22 related22 to this project22:                      ////
////  - http22://www22.opencores22.org22/cores22/uart1655022/                 ////
////                                                              ////
////  Projects22 compatibility22:                                     ////
////  - WISHBONE22                                                  ////
////  RS23222 Protocol22                                              ////
////  16550D uart22 (mostly22 supported)                              ////
////                                                              ////
////  Overview22 (main22 Features22):                                   ////
////  UART22 core22 receiver22 logic                                    ////
////                                                              ////
////  Known22 problems22 (limits22):                                    ////
////  None22 known22                                                  ////
////                                                              ////
////  To22 Do22:                                                      ////
////  Thourough22 testing22.                                          ////
////                                                              ////
////  Author22(s):                                                  ////
////      - Andrej22 Erzen22 (andreje22@flextronics22.si22)                 ////
////      - Tadej22 Markovic22 (tadejm22@flextronics22.si22)                ////
////                                                              ////
////  Created22:        2004/05/20                                  ////
////  Last22 Updated22:   2004/05/20                                  ////
////                  (See log22 for the revision22 history22)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2000, 2001 Authors22                             ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS22 Revision22 History22
//
// $Log: not supported by cvs2svn22 $
//


`include "timescale.v"


module uart_sync_flops22
(
  // internal signals22
  rst_i22,
  clk_i22,
  stage1_rst_i22,
  stage1_clk_en_i22,
  async_dat_i22,
  sync_dat_o22
);

parameter Tp22            = 1;
parameter width         = 1;
parameter init_value22    = 1'b0;

input                           rst_i22;                  // reset input
input                           clk_i22;                  // clock22 input
input                           stage1_rst_i22;           // synchronous22 reset for stage22 1 FF22
input                           stage1_clk_en_i22;        // synchronous22 clock22 enable for stage22 1 FF22
input   [width-1:0]             async_dat_i22;            // asynchronous22 data input
output  [width-1:0]             sync_dat_o22;             // synchronous22 data output


//
// Interal22 signal22 declarations22
//

reg     [width-1:0]             sync_dat_o22;
reg     [width-1:0]             flop_022;


// first stage22
always @ (posedge clk_i22 or posedge rst_i22)
begin
    if (rst_i22)
        flop_022 <= #Tp22 {width{init_value22}};
    else
        flop_022 <= #Tp22 async_dat_i22;    
end

// second stage22
always @ (posedge clk_i22 or posedge rst_i22)
begin
    if (rst_i22)
        sync_dat_o22 <= #Tp22 {width{init_value22}};
    else if (stage1_rst_i22)
        sync_dat_o22 <= #Tp22 {width{init_value22}};
    else if (stage1_clk_en_i22)
        sync_dat_o22 <= #Tp22 flop_022;       
end

endmodule
