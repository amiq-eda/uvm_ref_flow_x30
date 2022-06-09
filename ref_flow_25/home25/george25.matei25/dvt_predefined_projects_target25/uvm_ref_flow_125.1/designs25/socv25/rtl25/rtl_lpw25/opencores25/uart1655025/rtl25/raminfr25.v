//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr25.v                                                   ////
////                                                              ////
////                                                              ////
////  This25 file is part of the "UART25 16550 compatible25" project25    ////
////  http25://www25.opencores25.org25/cores25/uart1655025/                   ////
////                                                              ////
////  Documentation25 related25 to this project25:                      ////
////  - http25://www25.opencores25.org25/cores25/uart1655025/                 ////
////                                                              ////
////  Projects25 compatibility25:                                     ////
////  - WISHBONE25                                                  ////
////  RS23225 Protocol25                                              ////
////  16550D uart25 (mostly25 supported)                              ////
////                                                              ////
////  Overview25 (main25 Features25):                                   ////
////  Inferrable25 Distributed25 RAM25 for FIFOs25                        ////
////                                                              ////
////  Known25 problems25 (limits25):                                    ////
////  None25                .                                       ////
////                                                              ////
////  To25 Do25:                                                      ////
////  Nothing so far25.                                             ////
////                                                              ////
////  Author25(s):                                                  ////
////      - gorban25@opencores25.org25                                  ////
////      - Jacob25 Gorban25                                          ////
////                                                              ////
////  Created25:        2002/07/22                                  ////
////  Last25 Updated25:   2002/07/22                                  ////
////                  (See log25 for the revision25 history25)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2000, 2001 Authors25                             ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS25 Revision25 History25
//
// $Log: not supported by cvs2svn25 $
// Revision25 1.1  2002/07/22 23:02:23  gorban25
// Bug25 Fixes25:
//  * Possible25 loss of sync and bad25 reception25 of stop bit on slow25 baud25 rates25 fixed25.
//   Problem25 reported25 by Kenny25.Tung25.
//  * Bad (or lack25 of ) loopback25 handling25 fixed25. Reported25 by Cherry25 Withers25.
//
// Improvements25:
//  * Made25 FIFO's as general25 inferrable25 memory where possible25.
//  So25 on FPGA25 they should be inferred25 as RAM25 (Distributed25 RAM25 on Xilinx25).
//  This25 saves25 about25 1/3 of the Slice25 count and reduces25 P&R and synthesis25 times.
//
//  * Added25 optional25 baudrate25 output (baud_o25).
//  This25 is identical25 to BAUDOUT25* signal25 on 16550 chip25.
//  It outputs25 16xbit_clock_rate - the divided25 clock25.
//  It's disabled by default. Define25 UART_HAS_BAUDRATE_OUTPUT25 to use.
//

//Following25 is the Verilog25 code25 for a dual25-port RAM25 with asynchronous25 read. 
module raminfr25   
        (clk25, we25, a, dpra25, di25, dpo25); 

parameter addr_width25 = 4;
parameter data_width25 = 8;
parameter depth = 16;

input clk25;   
input we25;   
input  [addr_width25-1:0] a;   
input  [addr_width25-1:0] dpra25;   
input  [data_width25-1:0] di25;   
//output [data_width25-1:0] spo25;   
output [data_width25-1:0] dpo25;   
reg    [data_width25-1:0] ram25 [depth-1:0]; 

wire [data_width25-1:0] dpo25;
wire  [data_width25-1:0] di25;   
wire  [addr_width25-1:0] a;   
wire  [addr_width25-1:0] dpra25;   
 
  always @(posedge clk25) begin   
    if (we25)   
      ram25[a] <= di25;   
  end   
//  assign spo25 = ram25[a];   
  assign dpo25 = ram25[dpra25];   
endmodule 

