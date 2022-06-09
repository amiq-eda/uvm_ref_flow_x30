//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops29.v                                             ////
////                                                              ////
////                                                              ////
////  This29 file is part of the "UART29 16550 compatible29" project29    ////
////  http29://www29.opencores29.org29/cores29/uart1655029/                   ////
////                                                              ////
////  Documentation29 related29 to this project29:                      ////
////  - http29://www29.opencores29.org29/cores29/uart1655029/                 ////
////                                                              ////
////  Projects29 compatibility29:                                     ////
////  - WISHBONE29                                                  ////
////  RS23229 Protocol29                                              ////
////  16550D uart29 (mostly29 supported)                              ////
////                                                              ////
////  Overview29 (main29 Features29):                                   ////
////  UART29 core29 receiver29 logic                                    ////
////                                                              ////
////  Known29 problems29 (limits29):                                    ////
////  None29 known29                                                  ////
////                                                              ////
////  To29 Do29:                                                      ////
////  Thourough29 testing29.                                          ////
////                                                              ////
////  Author29(s):                                                  ////
////      - Andrej29 Erzen29 (andreje29@flextronics29.si29)                 ////
////      - Tadej29 Markovic29 (tadejm29@flextronics29.si29)                ////
////                                                              ////
////  Created29:        2004/05/20                                  ////
////  Last29 Updated29:   2004/05/20                                  ////
////                  (See log29 for the revision29 history29)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2000, 2001 Authors29                             ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS29 Revision29 History29
//
// $Log: not supported by cvs2svn29 $
//


`include "timescale.v"


module uart_sync_flops29
(
  // internal signals29
  rst_i29,
  clk_i29,
  stage1_rst_i29,
  stage1_clk_en_i29,
  async_dat_i29,
  sync_dat_o29
);

parameter Tp29            = 1;
parameter width         = 1;
parameter init_value29    = 1'b0;

input                           rst_i29;                  // reset input
input                           clk_i29;                  // clock29 input
input                           stage1_rst_i29;           // synchronous29 reset for stage29 1 FF29
input                           stage1_clk_en_i29;        // synchronous29 clock29 enable for stage29 1 FF29
input   [width-1:0]             async_dat_i29;            // asynchronous29 data input
output  [width-1:0]             sync_dat_o29;             // synchronous29 data output


//
// Interal29 signal29 declarations29
//

reg     [width-1:0]             sync_dat_o29;
reg     [width-1:0]             flop_029;


// first stage29
always @ (posedge clk_i29 or posedge rst_i29)
begin
    if (rst_i29)
        flop_029 <= #Tp29 {width{init_value29}};
    else
        flop_029 <= #Tp29 async_dat_i29;    
end

// second stage29
always @ (posedge clk_i29 or posedge rst_i29)
begin
    if (rst_i29)
        sync_dat_o29 <= #Tp29 {width{init_value29}};
    else if (stage1_rst_i29)
        sync_dat_o29 <= #Tp29 {width{init_value29}};
    else if (stage1_clk_en_i29)
        sync_dat_o29 <= #Tp29 flop_029;       
end

endmodule
