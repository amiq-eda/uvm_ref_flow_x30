//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops5.v                                             ////
////                                                              ////
////                                                              ////
////  This5 file is part of the "UART5 16550 compatible5" project5    ////
////  http5://www5.opencores5.org5/cores5/uart165505/                   ////
////                                                              ////
////  Documentation5 related5 to this project5:                      ////
////  - http5://www5.opencores5.org5/cores5/uart165505/                 ////
////                                                              ////
////  Projects5 compatibility5:                                     ////
////  - WISHBONE5                                                  ////
////  RS2325 Protocol5                                              ////
////  16550D uart5 (mostly5 supported)                              ////
////                                                              ////
////  Overview5 (main5 Features5):                                   ////
////  UART5 core5 receiver5 logic                                    ////
////                                                              ////
////  Known5 problems5 (limits5):                                    ////
////  None5 known5                                                  ////
////                                                              ////
////  To5 Do5:                                                      ////
////  Thourough5 testing5.                                          ////
////                                                              ////
////  Author5(s):                                                  ////
////      - Andrej5 Erzen5 (andreje5@flextronics5.si5)                 ////
////      - Tadej5 Markovic5 (tadejm5@flextronics5.si5)                ////
////                                                              ////
////  Created5:        2004/05/20                                  ////
////  Last5 Updated5:   2004/05/20                                  ////
////                  (See log5 for the revision5 history5)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2000, 2001 Authors5                             ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS5 Revision5 History5
//
// $Log: not supported by cvs2svn5 $
//


`include "timescale.v"


module uart_sync_flops5
(
  // internal signals5
  rst_i5,
  clk_i5,
  stage1_rst_i5,
  stage1_clk_en_i5,
  async_dat_i5,
  sync_dat_o5
);

parameter Tp5            = 1;
parameter width         = 1;
parameter init_value5    = 1'b0;

input                           rst_i5;                  // reset input
input                           clk_i5;                  // clock5 input
input                           stage1_rst_i5;           // synchronous5 reset for stage5 1 FF5
input                           stage1_clk_en_i5;        // synchronous5 clock5 enable for stage5 1 FF5
input   [width-1:0]             async_dat_i5;            // asynchronous5 data input
output  [width-1:0]             sync_dat_o5;             // synchronous5 data output


//
// Interal5 signal5 declarations5
//

reg     [width-1:0]             sync_dat_o5;
reg     [width-1:0]             flop_05;


// first stage5
always @ (posedge clk_i5 or posedge rst_i5)
begin
    if (rst_i5)
        flop_05 <= #Tp5 {width{init_value5}};
    else
        flop_05 <= #Tp5 async_dat_i5;    
end

// second stage5
always @ (posedge clk_i5 or posedge rst_i5)
begin
    if (rst_i5)
        sync_dat_o5 <= #Tp5 {width{init_value5}};
    else if (stage1_rst_i5)
        sync_dat_o5 <= #Tp5 {width{init_value5}};
    else if (stage1_clk_en_i5)
        sync_dat_o5 <= #Tp5 flop_05;       
end

endmodule
