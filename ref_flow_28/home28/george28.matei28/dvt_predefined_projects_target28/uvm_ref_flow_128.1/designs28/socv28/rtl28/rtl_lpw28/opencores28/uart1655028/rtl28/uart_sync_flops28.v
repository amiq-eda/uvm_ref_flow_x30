//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops28.v                                             ////
////                                                              ////
////                                                              ////
////  This28 file is part of the "UART28 16550 compatible28" project28    ////
////  http28://www28.opencores28.org28/cores28/uart1655028/                   ////
////                                                              ////
////  Documentation28 related28 to this project28:                      ////
////  - http28://www28.opencores28.org28/cores28/uart1655028/                 ////
////                                                              ////
////  Projects28 compatibility28:                                     ////
////  - WISHBONE28                                                  ////
////  RS23228 Protocol28                                              ////
////  16550D uart28 (mostly28 supported)                              ////
////                                                              ////
////  Overview28 (main28 Features28):                                   ////
////  UART28 core28 receiver28 logic                                    ////
////                                                              ////
////  Known28 problems28 (limits28):                                    ////
////  None28 known28                                                  ////
////                                                              ////
////  To28 Do28:                                                      ////
////  Thourough28 testing28.                                          ////
////                                                              ////
////  Author28(s):                                                  ////
////      - Andrej28 Erzen28 (andreje28@flextronics28.si28)                 ////
////      - Tadej28 Markovic28 (tadejm28@flextronics28.si28)                ////
////                                                              ////
////  Created28:        2004/05/20                                  ////
////  Last28 Updated28:   2004/05/20                                  ////
////                  (See log28 for the revision28 history28)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2000, 2001 Authors28                             ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS28 Revision28 History28
//
// $Log: not supported by cvs2svn28 $
//


`include "timescale.v"


module uart_sync_flops28
(
  // internal signals28
  rst_i28,
  clk_i28,
  stage1_rst_i28,
  stage1_clk_en_i28,
  async_dat_i28,
  sync_dat_o28
);

parameter Tp28            = 1;
parameter width         = 1;
parameter init_value28    = 1'b0;

input                           rst_i28;                  // reset input
input                           clk_i28;                  // clock28 input
input                           stage1_rst_i28;           // synchronous28 reset for stage28 1 FF28
input                           stage1_clk_en_i28;        // synchronous28 clock28 enable for stage28 1 FF28
input   [width-1:0]             async_dat_i28;            // asynchronous28 data input
output  [width-1:0]             sync_dat_o28;             // synchronous28 data output


//
// Interal28 signal28 declarations28
//

reg     [width-1:0]             sync_dat_o28;
reg     [width-1:0]             flop_028;


// first stage28
always @ (posedge clk_i28 or posedge rst_i28)
begin
    if (rst_i28)
        flop_028 <= #Tp28 {width{init_value28}};
    else
        flop_028 <= #Tp28 async_dat_i28;    
end

// second stage28
always @ (posedge clk_i28 or posedge rst_i28)
begin
    if (rst_i28)
        sync_dat_o28 <= #Tp28 {width{init_value28}};
    else if (stage1_rst_i28)
        sync_dat_o28 <= #Tp28 {width{init_value28}};
    else if (stage1_clk_en_i28)
        sync_dat_o28 <= #Tp28 flop_028;       
end

endmodule
