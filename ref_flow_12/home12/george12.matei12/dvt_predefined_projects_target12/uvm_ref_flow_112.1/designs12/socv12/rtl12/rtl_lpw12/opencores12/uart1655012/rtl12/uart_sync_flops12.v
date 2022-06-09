//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops12.v                                             ////
////                                                              ////
////                                                              ////
////  This12 file is part of the "UART12 16550 compatible12" project12    ////
////  http12://www12.opencores12.org12/cores12/uart1655012/                   ////
////                                                              ////
////  Documentation12 related12 to this project12:                      ////
////  - http12://www12.opencores12.org12/cores12/uart1655012/                 ////
////                                                              ////
////  Projects12 compatibility12:                                     ////
////  - WISHBONE12                                                  ////
////  RS23212 Protocol12                                              ////
////  16550D uart12 (mostly12 supported)                              ////
////                                                              ////
////  Overview12 (main12 Features12):                                   ////
////  UART12 core12 receiver12 logic                                    ////
////                                                              ////
////  Known12 problems12 (limits12):                                    ////
////  None12 known12                                                  ////
////                                                              ////
////  To12 Do12:                                                      ////
////  Thourough12 testing12.                                          ////
////                                                              ////
////  Author12(s):                                                  ////
////      - Andrej12 Erzen12 (andreje12@flextronics12.si12)                 ////
////      - Tadej12 Markovic12 (tadejm12@flextronics12.si12)                ////
////                                                              ////
////  Created12:        2004/05/20                                  ////
////  Last12 Updated12:   2004/05/20                                  ////
////                  (See log12 for the revision12 history12)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright12 (C) 2000, 2001 Authors12                             ////
////                                                              ////
//// This12 source12 file may be used and distributed12 without         ////
//// restriction12 provided that this copyright12 statement12 is not    ////
//// removed from the file and that any derivative12 work12 contains12  ////
//// the original copyright12 notice12 and the associated disclaimer12. ////
////                                                              ////
//// This12 source12 file is free software12; you can redistribute12 it   ////
//// and/or modify it under the terms12 of the GNU12 Lesser12 General12   ////
//// Public12 License12 as published12 by the Free12 Software12 Foundation12; ////
//// either12 version12 2.1 of the License12, or (at your12 option) any   ////
//// later12 version12.                                               ////
////                                                              ////
//// This12 source12 is distributed12 in the hope12 that it will be       ////
//// useful12, but WITHOUT12 ANY12 WARRANTY12; without even12 the implied12   ////
//// warranty12 of MERCHANTABILITY12 or FITNESS12 FOR12 A PARTICULAR12      ////
//// PURPOSE12.  See the GNU12 Lesser12 General12 Public12 License12 for more ////
//// details12.                                                     ////
////                                                              ////
//// You should have received12 a copy of the GNU12 Lesser12 General12    ////
//// Public12 License12 along12 with this source12; if not, download12 it   ////
//// from http12://www12.opencores12.org12/lgpl12.shtml12                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS12 Revision12 History12
//
// $Log: not supported by cvs2svn12 $
//


`include "timescale.v"


module uart_sync_flops12
(
  // internal signals12
  rst_i12,
  clk_i12,
  stage1_rst_i12,
  stage1_clk_en_i12,
  async_dat_i12,
  sync_dat_o12
);

parameter Tp12            = 1;
parameter width         = 1;
parameter init_value12    = 1'b0;

input                           rst_i12;                  // reset input
input                           clk_i12;                  // clock12 input
input                           stage1_rst_i12;           // synchronous12 reset for stage12 1 FF12
input                           stage1_clk_en_i12;        // synchronous12 clock12 enable for stage12 1 FF12
input   [width-1:0]             async_dat_i12;            // asynchronous12 data input
output  [width-1:0]             sync_dat_o12;             // synchronous12 data output


//
// Interal12 signal12 declarations12
//

reg     [width-1:0]             sync_dat_o12;
reg     [width-1:0]             flop_012;


// first stage12
always @ (posedge clk_i12 or posedge rst_i12)
begin
    if (rst_i12)
        flop_012 <= #Tp12 {width{init_value12}};
    else
        flop_012 <= #Tp12 async_dat_i12;    
end

// second stage12
always @ (posedge clk_i12 or posedge rst_i12)
begin
    if (rst_i12)
        sync_dat_o12 <= #Tp12 {width{init_value12}};
    else if (stage1_rst_i12)
        sync_dat_o12 <= #Tp12 {width{init_value12}};
    else if (stage1_clk_en_i12)
        sync_dat_o12 <= #Tp12 flop_012;       
end

endmodule
