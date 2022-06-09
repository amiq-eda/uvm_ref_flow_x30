//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops16.v                                             ////
////                                                              ////
////                                                              ////
////  This16 file is part of the "UART16 16550 compatible16" project16    ////
////  http16://www16.opencores16.org16/cores16/uart1655016/                   ////
////                                                              ////
////  Documentation16 related16 to this project16:                      ////
////  - http16://www16.opencores16.org16/cores16/uart1655016/                 ////
////                                                              ////
////  Projects16 compatibility16:                                     ////
////  - WISHBONE16                                                  ////
////  RS23216 Protocol16                                              ////
////  16550D uart16 (mostly16 supported)                              ////
////                                                              ////
////  Overview16 (main16 Features16):                                   ////
////  UART16 core16 receiver16 logic                                    ////
////                                                              ////
////  Known16 problems16 (limits16):                                    ////
////  None16 known16                                                  ////
////                                                              ////
////  To16 Do16:                                                      ////
////  Thourough16 testing16.                                          ////
////                                                              ////
////  Author16(s):                                                  ////
////      - Andrej16 Erzen16 (andreje16@flextronics16.si16)                 ////
////      - Tadej16 Markovic16 (tadejm16@flextronics16.si16)                ////
////                                                              ////
////  Created16:        2004/05/20                                  ////
////  Last16 Updated16:   2004/05/20                                  ////
////                  (See log16 for the revision16 history16)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2000, 2001 Authors16                             ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS16 Revision16 History16
//
// $Log: not supported by cvs2svn16 $
//


`include "timescale.v"


module uart_sync_flops16
(
  // internal signals16
  rst_i16,
  clk_i16,
  stage1_rst_i16,
  stage1_clk_en_i16,
  async_dat_i16,
  sync_dat_o16
);

parameter Tp16            = 1;
parameter width         = 1;
parameter init_value16    = 1'b0;

input                           rst_i16;                  // reset input
input                           clk_i16;                  // clock16 input
input                           stage1_rst_i16;           // synchronous16 reset for stage16 1 FF16
input                           stage1_clk_en_i16;        // synchronous16 clock16 enable for stage16 1 FF16
input   [width-1:0]             async_dat_i16;            // asynchronous16 data input
output  [width-1:0]             sync_dat_o16;             // synchronous16 data output


//
// Interal16 signal16 declarations16
//

reg     [width-1:0]             sync_dat_o16;
reg     [width-1:0]             flop_016;


// first stage16
always @ (posedge clk_i16 or posedge rst_i16)
begin
    if (rst_i16)
        flop_016 <= #Tp16 {width{init_value16}};
    else
        flop_016 <= #Tp16 async_dat_i16;    
end

// second stage16
always @ (posedge clk_i16 or posedge rst_i16)
begin
    if (rst_i16)
        sync_dat_o16 <= #Tp16 {width{init_value16}};
    else if (stage1_rst_i16)
        sync_dat_o16 <= #Tp16 {width{init_value16}};
    else if (stage1_clk_en_i16)
        sync_dat_o16 <= #Tp16 flop_016;       
end

endmodule
