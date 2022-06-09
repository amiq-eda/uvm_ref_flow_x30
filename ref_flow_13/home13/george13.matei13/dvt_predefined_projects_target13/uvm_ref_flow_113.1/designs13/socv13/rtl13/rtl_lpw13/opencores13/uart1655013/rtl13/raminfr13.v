//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr13.v                                                   ////
////                                                              ////
////                                                              ////
////  This13 file is part of the "UART13 16550 compatible13" project13    ////
////  http13://www13.opencores13.org13/cores13/uart1655013/                   ////
////                                                              ////
////  Documentation13 related13 to this project13:                      ////
////  - http13://www13.opencores13.org13/cores13/uart1655013/                 ////
////                                                              ////
////  Projects13 compatibility13:                                     ////
////  - WISHBONE13                                                  ////
////  RS23213 Protocol13                                              ////
////  16550D uart13 (mostly13 supported)                              ////
////                                                              ////
////  Overview13 (main13 Features13):                                   ////
////  Inferrable13 Distributed13 RAM13 for FIFOs13                        ////
////                                                              ////
////  Known13 problems13 (limits13):                                    ////
////  None13                .                                       ////
////                                                              ////
////  To13 Do13:                                                      ////
////  Nothing so far13.                                             ////
////                                                              ////
////  Author13(s):                                                  ////
////      - gorban13@opencores13.org13                                  ////
////      - Jacob13 Gorban13                                          ////
////                                                              ////
////  Created13:        2002/07/22                                  ////
////  Last13 Updated13:   2002/07/22                                  ////
////                  (See log13 for the revision13 history13)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2000, 2001 Authors13                             ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS13 Revision13 History13
//
// $Log: not supported by cvs2svn13 $
// Revision13 1.1  2002/07/22 23:02:23  gorban13
// Bug13 Fixes13:
//  * Possible13 loss of sync and bad13 reception13 of stop bit on slow13 baud13 rates13 fixed13.
//   Problem13 reported13 by Kenny13.Tung13.
//  * Bad (or lack13 of ) loopback13 handling13 fixed13. Reported13 by Cherry13 Withers13.
//
// Improvements13:
//  * Made13 FIFO's as general13 inferrable13 memory where possible13.
//  So13 on FPGA13 they should be inferred13 as RAM13 (Distributed13 RAM13 on Xilinx13).
//  This13 saves13 about13 1/3 of the Slice13 count and reduces13 P&R and synthesis13 times.
//
//  * Added13 optional13 baudrate13 output (baud_o13).
//  This13 is identical13 to BAUDOUT13* signal13 on 16550 chip13.
//  It outputs13 16xbit_clock_rate - the divided13 clock13.
//  It's disabled by default. Define13 UART_HAS_BAUDRATE_OUTPUT13 to use.
//

//Following13 is the Verilog13 code13 for a dual13-port RAM13 with asynchronous13 read. 
module raminfr13   
        (clk13, we13, a, dpra13, di13, dpo13); 

parameter addr_width13 = 4;
parameter data_width13 = 8;
parameter depth = 16;

input clk13;   
input we13;   
input  [addr_width13-1:0] a;   
input  [addr_width13-1:0] dpra13;   
input  [data_width13-1:0] di13;   
//output [data_width13-1:0] spo13;   
output [data_width13-1:0] dpo13;   
reg    [data_width13-1:0] ram13 [depth-1:0]; 

wire [data_width13-1:0] dpo13;
wire  [data_width13-1:0] di13;   
wire  [addr_width13-1:0] a;   
wire  [addr_width13-1:0] dpra13;   
 
  always @(posedge clk13) begin   
    if (we13)   
      ram13[a] <= di13;   
  end   
//  assign spo13 = ram13[a];   
  assign dpo13 = ram13[dpra13];   
endmodule 

