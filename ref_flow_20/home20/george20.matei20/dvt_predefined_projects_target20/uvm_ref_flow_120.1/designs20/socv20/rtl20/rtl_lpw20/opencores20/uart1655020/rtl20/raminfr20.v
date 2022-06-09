//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr20.v                                                   ////
////                                                              ////
////                                                              ////
////  This20 file is part of the "UART20 16550 compatible20" project20    ////
////  http20://www20.opencores20.org20/cores20/uart1655020/                   ////
////                                                              ////
////  Documentation20 related20 to this project20:                      ////
////  - http20://www20.opencores20.org20/cores20/uart1655020/                 ////
////                                                              ////
////  Projects20 compatibility20:                                     ////
////  - WISHBONE20                                                  ////
////  RS23220 Protocol20                                              ////
////  16550D uart20 (mostly20 supported)                              ////
////                                                              ////
////  Overview20 (main20 Features20):                                   ////
////  Inferrable20 Distributed20 RAM20 for FIFOs20                        ////
////                                                              ////
////  Known20 problems20 (limits20):                                    ////
////  None20                .                                       ////
////                                                              ////
////  To20 Do20:                                                      ////
////  Nothing so far20.                                             ////
////                                                              ////
////  Author20(s):                                                  ////
////      - gorban20@opencores20.org20                                  ////
////      - Jacob20 Gorban20                                          ////
////                                                              ////
////  Created20:        2002/07/22                                  ////
////  Last20 Updated20:   2002/07/22                                  ////
////                  (See log20 for the revision20 history20)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2000, 2001 Authors20                             ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS20 Revision20 History20
//
// $Log: not supported by cvs2svn20 $
// Revision20 1.1  2002/07/22 23:02:23  gorban20
// Bug20 Fixes20:
//  * Possible20 loss of sync and bad20 reception20 of stop bit on slow20 baud20 rates20 fixed20.
//   Problem20 reported20 by Kenny20.Tung20.
//  * Bad (or lack20 of ) loopback20 handling20 fixed20. Reported20 by Cherry20 Withers20.
//
// Improvements20:
//  * Made20 FIFO's as general20 inferrable20 memory where possible20.
//  So20 on FPGA20 they should be inferred20 as RAM20 (Distributed20 RAM20 on Xilinx20).
//  This20 saves20 about20 1/3 of the Slice20 count and reduces20 P&R and synthesis20 times.
//
//  * Added20 optional20 baudrate20 output (baud_o20).
//  This20 is identical20 to BAUDOUT20* signal20 on 16550 chip20.
//  It outputs20 16xbit_clock_rate - the divided20 clock20.
//  It's disabled by default. Define20 UART_HAS_BAUDRATE_OUTPUT20 to use.
//

//Following20 is the Verilog20 code20 for a dual20-port RAM20 with asynchronous20 read. 
module raminfr20   
        (clk20, we20, a, dpra20, di20, dpo20); 

parameter addr_width20 = 4;
parameter data_width20 = 8;
parameter depth = 16;

input clk20;   
input we20;   
input  [addr_width20-1:0] a;   
input  [addr_width20-1:0] dpra20;   
input  [data_width20-1:0] di20;   
//output [data_width20-1:0] spo20;   
output [data_width20-1:0] dpo20;   
reg    [data_width20-1:0] ram20 [depth-1:0]; 

wire [data_width20-1:0] dpo20;
wire  [data_width20-1:0] di20;   
wire  [addr_width20-1:0] a;   
wire  [addr_width20-1:0] dpra20;   
 
  always @(posedge clk20) begin   
    if (we20)   
      ram20[a] <= di20;   
  end   
//  assign spo20 = ram20[a];   
  assign dpo20 = ram20[dpra20];   
endmodule 

