//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr15.v                                                   ////
////                                                              ////
////                                                              ////
////  This15 file is part of the "UART15 16550 compatible15" project15    ////
////  http15://www15.opencores15.org15/cores15/uart1655015/                   ////
////                                                              ////
////  Documentation15 related15 to this project15:                      ////
////  - http15://www15.opencores15.org15/cores15/uart1655015/                 ////
////                                                              ////
////  Projects15 compatibility15:                                     ////
////  - WISHBONE15                                                  ////
////  RS23215 Protocol15                                              ////
////  16550D uart15 (mostly15 supported)                              ////
////                                                              ////
////  Overview15 (main15 Features15):                                   ////
////  Inferrable15 Distributed15 RAM15 for FIFOs15                        ////
////                                                              ////
////  Known15 problems15 (limits15):                                    ////
////  None15                .                                       ////
////                                                              ////
////  To15 Do15:                                                      ////
////  Nothing so far15.                                             ////
////                                                              ////
////  Author15(s):                                                  ////
////      - gorban15@opencores15.org15                                  ////
////      - Jacob15 Gorban15                                          ////
////                                                              ////
////  Created15:        2002/07/22                                  ////
////  Last15 Updated15:   2002/07/22                                  ////
////                  (See log15 for the revision15 history15)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2000, 2001 Authors15                             ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS15 Revision15 History15
//
// $Log: not supported by cvs2svn15 $
// Revision15 1.1  2002/07/22 23:02:23  gorban15
// Bug15 Fixes15:
//  * Possible15 loss of sync and bad15 reception15 of stop bit on slow15 baud15 rates15 fixed15.
//   Problem15 reported15 by Kenny15.Tung15.
//  * Bad (or lack15 of ) loopback15 handling15 fixed15. Reported15 by Cherry15 Withers15.
//
// Improvements15:
//  * Made15 FIFO's as general15 inferrable15 memory where possible15.
//  So15 on FPGA15 they should be inferred15 as RAM15 (Distributed15 RAM15 on Xilinx15).
//  This15 saves15 about15 1/3 of the Slice15 count and reduces15 P&R and synthesis15 times.
//
//  * Added15 optional15 baudrate15 output (baud_o15).
//  This15 is identical15 to BAUDOUT15* signal15 on 16550 chip15.
//  It outputs15 16xbit_clock_rate - the divided15 clock15.
//  It's disabled by default. Define15 UART_HAS_BAUDRATE_OUTPUT15 to use.
//

//Following15 is the Verilog15 code15 for a dual15-port RAM15 with asynchronous15 read. 
module raminfr15   
        (clk15, we15, a, dpra15, di15, dpo15); 

parameter addr_width15 = 4;
parameter data_width15 = 8;
parameter depth = 16;

input clk15;   
input we15;   
input  [addr_width15-1:0] a;   
input  [addr_width15-1:0] dpra15;   
input  [data_width15-1:0] di15;   
//output [data_width15-1:0] spo15;   
output [data_width15-1:0] dpo15;   
reg    [data_width15-1:0] ram15 [depth-1:0]; 

wire [data_width15-1:0] dpo15;
wire  [data_width15-1:0] di15;   
wire  [addr_width15-1:0] a;   
wire  [addr_width15-1:0] dpra15;   
 
  always @(posedge clk15) begin   
    if (we15)   
      ram15[a] <= di15;   
  end   
//  assign spo15 = ram15[a];   
  assign dpo15 = ram15[dpra15];   
endmodule 

