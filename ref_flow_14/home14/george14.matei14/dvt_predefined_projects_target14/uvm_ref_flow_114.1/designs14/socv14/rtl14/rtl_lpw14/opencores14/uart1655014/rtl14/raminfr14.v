//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr14.v                                                   ////
////                                                              ////
////                                                              ////
////  This14 file is part of the "UART14 16550 compatible14" project14    ////
////  http14://www14.opencores14.org14/cores14/uart1655014/                   ////
////                                                              ////
////  Documentation14 related14 to this project14:                      ////
////  - http14://www14.opencores14.org14/cores14/uart1655014/                 ////
////                                                              ////
////  Projects14 compatibility14:                                     ////
////  - WISHBONE14                                                  ////
////  RS23214 Protocol14                                              ////
////  16550D uart14 (mostly14 supported)                              ////
////                                                              ////
////  Overview14 (main14 Features14):                                   ////
////  Inferrable14 Distributed14 RAM14 for FIFOs14                        ////
////                                                              ////
////  Known14 problems14 (limits14):                                    ////
////  None14                .                                       ////
////                                                              ////
////  To14 Do14:                                                      ////
////  Nothing so far14.                                             ////
////                                                              ////
////  Author14(s):                                                  ////
////      - gorban14@opencores14.org14                                  ////
////      - Jacob14 Gorban14                                          ////
////                                                              ////
////  Created14:        2002/07/22                                  ////
////  Last14 Updated14:   2002/07/22                                  ////
////                  (See log14 for the revision14 history14)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2000, 2001 Authors14                             ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS14 Revision14 History14
//
// $Log: not supported by cvs2svn14 $
// Revision14 1.1  2002/07/22 23:02:23  gorban14
// Bug14 Fixes14:
//  * Possible14 loss of sync and bad14 reception14 of stop bit on slow14 baud14 rates14 fixed14.
//   Problem14 reported14 by Kenny14.Tung14.
//  * Bad (or lack14 of ) loopback14 handling14 fixed14. Reported14 by Cherry14 Withers14.
//
// Improvements14:
//  * Made14 FIFO's as general14 inferrable14 memory where possible14.
//  So14 on FPGA14 they should be inferred14 as RAM14 (Distributed14 RAM14 on Xilinx14).
//  This14 saves14 about14 1/3 of the Slice14 count and reduces14 P&R and synthesis14 times.
//
//  * Added14 optional14 baudrate14 output (baud_o14).
//  This14 is identical14 to BAUDOUT14* signal14 on 16550 chip14.
//  It outputs14 16xbit_clock_rate - the divided14 clock14.
//  It's disabled by default. Define14 UART_HAS_BAUDRATE_OUTPUT14 to use.
//

//Following14 is the Verilog14 code14 for a dual14-port RAM14 with asynchronous14 read. 
module raminfr14   
        (clk14, we14, a, dpra14, di14, dpo14); 

parameter addr_width14 = 4;
parameter data_width14 = 8;
parameter depth = 16;

input clk14;   
input we14;   
input  [addr_width14-1:0] a;   
input  [addr_width14-1:0] dpra14;   
input  [data_width14-1:0] di14;   
//output [data_width14-1:0] spo14;   
output [data_width14-1:0] dpo14;   
reg    [data_width14-1:0] ram14 [depth-1:0]; 

wire [data_width14-1:0] dpo14;
wire  [data_width14-1:0] di14;   
wire  [addr_width14-1:0] a;   
wire  [addr_width14-1:0] dpra14;   
 
  always @(posedge clk14) begin   
    if (we14)   
      ram14[a] <= di14;   
  end   
//  assign spo14 = ram14[a];   
  assign dpo14 = ram14[dpra14];   
endmodule 

