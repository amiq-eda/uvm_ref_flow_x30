//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops11.v                                             ////
////                                                              ////
////                                                              ////
////  This11 file is part of the "UART11 16550 compatible11" project11    ////
////  http11://www11.opencores11.org11/cores11/uart1655011/                   ////
////                                                              ////
////  Documentation11 related11 to this project11:                      ////
////  - http11://www11.opencores11.org11/cores11/uart1655011/                 ////
////                                                              ////
////  Projects11 compatibility11:                                     ////
////  - WISHBONE11                                                  ////
////  RS23211 Protocol11                                              ////
////  16550D uart11 (mostly11 supported)                              ////
////                                                              ////
////  Overview11 (main11 Features11):                                   ////
////  UART11 core11 receiver11 logic                                    ////
////                                                              ////
////  Known11 problems11 (limits11):                                    ////
////  None11 known11                                                  ////
////                                                              ////
////  To11 Do11:                                                      ////
////  Thourough11 testing11.                                          ////
////                                                              ////
////  Author11(s):                                                  ////
////      - Andrej11 Erzen11 (andreje11@flextronics11.si11)                 ////
////      - Tadej11 Markovic11 (tadejm11@flextronics11.si11)                ////
////                                                              ////
////  Created11:        2004/05/20                                  ////
////  Last11 Updated11:   2004/05/20                                  ////
////                  (See log11 for the revision11 history11)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2000, 2001 Authors11                             ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS11 Revision11 History11
//
// $Log: not supported by cvs2svn11 $
//


`include "timescale.v"


module uart_sync_flops11
(
  // internal signals11
  rst_i11,
  clk_i11,
  stage1_rst_i11,
  stage1_clk_en_i11,
  async_dat_i11,
  sync_dat_o11
);

parameter Tp11            = 1;
parameter width         = 1;
parameter init_value11    = 1'b0;

input                           rst_i11;                  // reset input
input                           clk_i11;                  // clock11 input
input                           stage1_rst_i11;           // synchronous11 reset for stage11 1 FF11
input                           stage1_clk_en_i11;        // synchronous11 clock11 enable for stage11 1 FF11
input   [width-1:0]             async_dat_i11;            // asynchronous11 data input
output  [width-1:0]             sync_dat_o11;             // synchronous11 data output


//
// Interal11 signal11 declarations11
//

reg     [width-1:0]             sync_dat_o11;
reg     [width-1:0]             flop_011;


// first stage11
always @ (posedge clk_i11 or posedge rst_i11)
begin
    if (rst_i11)
        flop_011 <= #Tp11 {width{init_value11}};
    else
        flop_011 <= #Tp11 async_dat_i11;    
end

// second stage11
always @ (posedge clk_i11 or posedge rst_i11)
begin
    if (rst_i11)
        sync_dat_o11 <= #Tp11 {width{init_value11}};
    else if (stage1_rst_i11)
        sync_dat_o11 <= #Tp11 {width{init_value11}};
    else if (stage1_clk_en_i11)
        sync_dat_o11 <= #Tp11 flop_011;       
end

endmodule
