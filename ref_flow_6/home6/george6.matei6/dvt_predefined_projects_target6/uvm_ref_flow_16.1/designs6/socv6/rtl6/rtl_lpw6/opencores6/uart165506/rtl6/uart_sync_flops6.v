//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_sync_flops6.v                                             ////
////                                                              ////
////                                                              ////
////  This6 file is part of the "UART6 16550 compatible6" project6    ////
////  http6://www6.opencores6.org6/cores6/uart165506/                   ////
////                                                              ////
////  Documentation6 related6 to this project6:                      ////
////  - http6://www6.opencores6.org6/cores6/uart165506/                 ////
////                                                              ////
////  Projects6 compatibility6:                                     ////
////  - WISHBONE6                                                  ////
////  RS2326 Protocol6                                              ////
////  16550D uart6 (mostly6 supported)                              ////
////                                                              ////
////  Overview6 (main6 Features6):                                   ////
////  UART6 core6 receiver6 logic                                    ////
////                                                              ////
////  Known6 problems6 (limits6):                                    ////
////  None6 known6                                                  ////
////                                                              ////
////  To6 Do6:                                                      ////
////  Thourough6 testing6.                                          ////
////                                                              ////
////  Author6(s):                                                  ////
////      - Andrej6 Erzen6 (andreje6@flextronics6.si6)                 ////
////      - Tadej6 Markovic6 (tadejm6@flextronics6.si6)                ////
////                                                              ////
////  Created6:        2004/05/20                                  ////
////  Last6 Updated6:   2004/05/20                                  ////
////                  (See log6 for the revision6 history6)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2000, 2001 Authors6                             ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS6 Revision6 History6
//
// $Log: not supported by cvs2svn6 $
//


`include "timescale.v"


module uart_sync_flops6
(
  // internal signals6
  rst_i6,
  clk_i6,
  stage1_rst_i6,
  stage1_clk_en_i6,
  async_dat_i6,
  sync_dat_o6
);

parameter Tp6            = 1;
parameter width         = 1;
parameter init_value6    = 1'b0;

input                           rst_i6;                  // reset input
input                           clk_i6;                  // clock6 input
input                           stage1_rst_i6;           // synchronous6 reset for stage6 1 FF6
input                           stage1_clk_en_i6;        // synchronous6 clock6 enable for stage6 1 FF6
input   [width-1:0]             async_dat_i6;            // asynchronous6 data input
output  [width-1:0]             sync_dat_o6;             // synchronous6 data output


//
// Interal6 signal6 declarations6
//

reg     [width-1:0]             sync_dat_o6;
reg     [width-1:0]             flop_06;


// first stage6
always @ (posedge clk_i6 or posedge rst_i6)
begin
    if (rst_i6)
        flop_06 <= #Tp6 {width{init_value6}};
    else
        flop_06 <= #Tp6 async_dat_i6;    
end

// second stage6
always @ (posedge clk_i6 or posedge rst_i6)
begin
    if (rst_i6)
        sync_dat_o6 <= #Tp6 {width{init_value6}};
    else if (stage1_rst_i6)
        sync_dat_o6 <= #Tp6 {width{init_value6}};
    else if (stage1_clk_en_i6)
        sync_dat_o6 <= #Tp6 flop_06;       
end

endmodule
