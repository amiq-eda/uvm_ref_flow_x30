//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops4.v                                             ////
////                                                              ////
////                                                              ////
////  This4 file is part of the "UART4 16550 compatible4" project4    ////
////  http4://www4.opencores4.org4/cores4/uart165504/                   ////
////                                                              ////
////  Documentation4 related4 to this project4:                      ////
////  - http4://www4.opencores4.org4/cores4/uart165504/                 ////
////                                                              ////
////  Projects4 compatibility4:                                     ////
////  - WISHBONE4                                                  ////
////  RS2324 Protocol4                                              ////
////  16550D uart4 (mostly4 supported)                              ////
////                                                              ////
////  Overview4 (main4 Features4):                                   ////
////  UART4 core4 receiver4 logic                                    ////
////                                                              ////
////  Known4 problems4 (limits4):                                    ////
////  None4 known4                                                  ////
////                                                              ////
////  To4 Do4:                                                      ////
////  Thourough4 testing4.                                          ////
////                                                              ////
////  Author4(s):                                                  ////
////      - Andrej4 Erzen4 (andreje4@flextronics4.si4)                 ////
////      - Tadej4 Markovic4 (tadejm4@flextronics4.si4)                ////
////                                                              ////
////  Created4:        2004/05/20                                  ////
////  Last4 Updated4:   2004/05/20                                  ////
////                  (See log4 for the revision4 history4)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2000, 2001 Authors4                             ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS4 Revision4 History4
//
// $Log: not supported by cvs2svn4 $
//


`include "timescale.v"


module uart_sync_flops4
(
  // internal signals4
  rst_i4,
  clk_i4,
  stage1_rst_i4,
  stage1_clk_en_i4,
  async_dat_i4,
  sync_dat_o4
);

parameter Tp4            = 1;
parameter width         = 1;
parameter init_value4    = 1'b0;

input                           rst_i4;                  // reset input
input                           clk_i4;                  // clock4 input
input                           stage1_rst_i4;           // synchronous4 reset for stage4 1 FF4
input                           stage1_clk_en_i4;        // synchronous4 clock4 enable for stage4 1 FF4
input   [width-1:0]             async_dat_i4;            // asynchronous4 data input
output  [width-1:0]             sync_dat_o4;             // synchronous4 data output


//
// Interal4 signal4 declarations4
//

reg     [width-1:0]             sync_dat_o4;
reg     [width-1:0]             flop_04;


// first stage4
always @ (posedge clk_i4 or posedge rst_i4)
begin
    if (rst_i4)
        flop_04 <= #Tp4 {width{init_value4}};
    else
        flop_04 <= #Tp4 async_dat_i4;    
end

// second stage4
always @ (posedge clk_i4 or posedge rst_i4)
begin
    if (rst_i4)
        sync_dat_o4 <= #Tp4 {width{init_value4}};
    else if (stage1_rst_i4)
        sync_dat_o4 <= #Tp4 {width{init_value4}};
    else if (stage1_clk_en_i4)
        sync_dat_o4 <= #Tp4 flop_04;       
end

endmodule
