//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops2.v                                             ////
////                                                              ////
////                                                              ////
////  This2 file is part of the "UART2 16550 compatible2" project2    ////
////  http2://www2.opencores2.org2/cores2/uart165502/                   ////
////                                                              ////
////  Documentation2 related2 to this project2:                      ////
////  - http2://www2.opencores2.org2/cores2/uart165502/                 ////
////                                                              ////
////  Projects2 compatibility2:                                     ////
////  - WISHBONE2                                                  ////
////  RS2322 Protocol2                                              ////
////  16550D uart2 (mostly2 supported)                              ////
////                                                              ////
////  Overview2 (main2 Features2):                                   ////
////  UART2 core2 receiver2 logic                                    ////
////                                                              ////
////  Known2 problems2 (limits2):                                    ////
////  None2 known2                                                  ////
////                                                              ////
////  To2 Do2:                                                      ////
////  Thourough2 testing2.                                          ////
////                                                              ////
////  Author2(s):                                                  ////
////      - Andrej2 Erzen2 (andreje2@flextronics2.si2)                 ////
////      - Tadej2 Markovic2 (tadejm2@flextronics2.si2)                ////
////                                                              ////
////  Created2:        2004/05/20                                  ////
////  Last2 Updated2:   2004/05/20                                  ////
////                  (See log2 for the revision2 history2)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2000, 2001 Authors2                             ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS2 Revision2 History2
//
// $Log: not supported by cvs2svn2 $
//


`include "timescale.v"


module uart_sync_flops2
(
  // internal signals2
  rst_i2,
  clk_i2,
  stage1_rst_i2,
  stage1_clk_en_i2,
  async_dat_i2,
  sync_dat_o2
);

parameter Tp2            = 1;
parameter width         = 1;
parameter init_value2    = 1'b0;

input                           rst_i2;                  // reset input
input                           clk_i2;                  // clock2 input
input                           stage1_rst_i2;           // synchronous2 reset for stage2 1 FF2
input                           stage1_clk_en_i2;        // synchronous2 clock2 enable for stage2 1 FF2
input   [width-1:0]             async_dat_i2;            // asynchronous2 data input
output  [width-1:0]             sync_dat_o2;             // synchronous2 data output


//
// Interal2 signal2 declarations2
//

reg     [width-1:0]             sync_dat_o2;
reg     [width-1:0]             flop_02;


// first stage2
always @ (posedge clk_i2 or posedge rst_i2)
begin
    if (rst_i2)
        flop_02 <= #Tp2 {width{init_value2}};
    else
        flop_02 <= #Tp2 async_dat_i2;    
end

// second stage2
always @ (posedge clk_i2 or posedge rst_i2)
begin
    if (rst_i2)
        sync_dat_o2 <= #Tp2 {width{init_value2}};
    else if (stage1_rst_i2)
        sync_dat_o2 <= #Tp2 {width{init_value2}};
    else if (stage1_clk_en_i2)
        sync_dat_o2 <= #Tp2 flop_02;       
end

endmodule
