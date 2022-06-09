//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops27.v                                             ////
////                                                              ////
////                                                              ////
////  This27 file is part of the "UART27 16550 compatible27" project27    ////
////  http27://www27.opencores27.org27/cores27/uart1655027/                   ////
////                                                              ////
////  Documentation27 related27 to this project27:                      ////
////  - http27://www27.opencores27.org27/cores27/uart1655027/                 ////
////                                                              ////
////  Projects27 compatibility27:                                     ////
////  - WISHBONE27                                                  ////
////  RS23227 Protocol27                                              ////
////  16550D uart27 (mostly27 supported)                              ////
////                                                              ////
////  Overview27 (main27 Features27):                                   ////
////  UART27 core27 receiver27 logic                                    ////
////                                                              ////
////  Known27 problems27 (limits27):                                    ////
////  None27 known27                                                  ////
////                                                              ////
////  To27 Do27:                                                      ////
////  Thourough27 testing27.                                          ////
////                                                              ////
////  Author27(s):                                                  ////
////      - Andrej27 Erzen27 (andreje27@flextronics27.si27)                 ////
////      - Tadej27 Markovic27 (tadejm27@flextronics27.si27)                ////
////                                                              ////
////  Created27:        2004/05/20                                  ////
////  Last27 Updated27:   2004/05/20                                  ////
////                  (See log27 for the revision27 history27)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2000, 2001 Authors27                             ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS27 Revision27 History27
//
// $Log: not supported by cvs2svn27 $
//


`include "timescale.v"


module uart_sync_flops27
(
  // internal signals27
  rst_i27,
  clk_i27,
  stage1_rst_i27,
  stage1_clk_en_i27,
  async_dat_i27,
  sync_dat_o27
);

parameter Tp27            = 1;
parameter width         = 1;
parameter init_value27    = 1'b0;

input                           rst_i27;                  // reset input
input                           clk_i27;                  // clock27 input
input                           stage1_rst_i27;           // synchronous27 reset for stage27 1 FF27
input                           stage1_clk_en_i27;        // synchronous27 clock27 enable for stage27 1 FF27
input   [width-1:0]             async_dat_i27;            // asynchronous27 data input
output  [width-1:0]             sync_dat_o27;             // synchronous27 data output


//
// Interal27 signal27 declarations27
//

reg     [width-1:0]             sync_dat_o27;
reg     [width-1:0]             flop_027;


// first stage27
always @ (posedge clk_i27 or posedge rst_i27)
begin
    if (rst_i27)
        flop_027 <= #Tp27 {width{init_value27}};
    else
        flop_027 <= #Tp27 async_dat_i27;    
end

// second stage27
always @ (posedge clk_i27 or posedge rst_i27)
begin
    if (rst_i27)
        sync_dat_o27 <= #Tp27 {width{init_value27}};
    else if (stage1_rst_i27)
        sync_dat_o27 <= #Tp27 {width{init_value27}};
    else if (stage1_clk_en_i27)
        sync_dat_o27 <= #Tp27 flop_027;       
end

endmodule
