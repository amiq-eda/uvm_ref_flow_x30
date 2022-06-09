//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr17.v                                                   ////
////                                                              ////
////                                                              ////
////  This17 file is part of the "UART17 16550 compatible17" project17    ////
////  http17://www17.opencores17.org17/cores17/uart1655017/                   ////
////                                                              ////
////  Documentation17 related17 to this project17:                      ////
////  - http17://www17.opencores17.org17/cores17/uart1655017/                 ////
////                                                              ////
////  Projects17 compatibility17:                                     ////
////  - WISHBONE17                                                  ////
////  RS23217 Protocol17                                              ////
////  16550D uart17 (mostly17 supported)                              ////
////                                                              ////
////  Overview17 (main17 Features17):                                   ////
////  Inferrable17 Distributed17 RAM17 for FIFOs17                        ////
////                                                              ////
////  Known17 problems17 (limits17):                                    ////
////  None17                .                                       ////
////                                                              ////
////  To17 Do17:                                                      ////
////  Nothing so far17.                                             ////
////                                                              ////
////  Author17(s):                                                  ////
////      - gorban17@opencores17.org17                                  ////
////      - Jacob17 Gorban17                                          ////
////                                                              ////
////  Created17:        2002/07/22                                  ////
////  Last17 Updated17:   2002/07/22                                  ////
////                  (See log17 for the revision17 history17)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2000, 2001 Authors17                             ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS17 Revision17 History17
//
// $Log: not supported by cvs2svn17 $
// Revision17 1.1  2002/07/22 23:02:23  gorban17
// Bug17 Fixes17:
//  * Possible17 loss of sync and bad17 reception17 of stop bit on slow17 baud17 rates17 fixed17.
//   Problem17 reported17 by Kenny17.Tung17.
//  * Bad (or lack17 of ) loopback17 handling17 fixed17. Reported17 by Cherry17 Withers17.
//
// Improvements17:
//  * Made17 FIFO's as general17 inferrable17 memory where possible17.
//  So17 on FPGA17 they should be inferred17 as RAM17 (Distributed17 RAM17 on Xilinx17).
//  This17 saves17 about17 1/3 of the Slice17 count and reduces17 P&R and synthesis17 times.
//
//  * Added17 optional17 baudrate17 output (baud_o17).
//  This17 is identical17 to BAUDOUT17* signal17 on 16550 chip17.
//  It outputs17 16xbit_clock_rate - the divided17 clock17.
//  It's disabled by default. Define17 UART_HAS_BAUDRATE_OUTPUT17 to use.
//

//Following17 is the Verilog17 code17 for a dual17-port RAM17 with asynchronous17 read. 
module raminfr17   
        (clk17, we17, a, dpra17, di17, dpo17); 

parameter addr_width17 = 4;
parameter data_width17 = 8;
parameter depth = 16;

input clk17;   
input we17;   
input  [addr_width17-1:0] a;   
input  [addr_width17-1:0] dpra17;   
input  [data_width17-1:0] di17;   
//output [data_width17-1:0] spo17;   
output [data_width17-1:0] dpo17;   
reg    [data_width17-1:0] ram17 [depth-1:0]; 

wire [data_width17-1:0] dpo17;
wire  [data_width17-1:0] di17;   
wire  [addr_width17-1:0] a;   
wire  [addr_width17-1:0] dpra17;   
 
  always @(posedge clk17) begin   
    if (we17)   
      ram17[a] <= di17;   
  end   
//  assign spo17 = ram17[a];   
  assign dpo17 = ram17[dpra17];   
endmodule 

