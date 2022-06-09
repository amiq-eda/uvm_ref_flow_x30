//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr29.v                                                   ////
////                                                              ////
////                                                              ////
////  This29 file is part of the "UART29 16550 compatible29" project29    ////
////  http29://www29.opencores29.org29/cores29/uart1655029/                   ////
////                                                              ////
////  Documentation29 related29 to this project29:                      ////
////  - http29://www29.opencores29.org29/cores29/uart1655029/                 ////
////                                                              ////
////  Projects29 compatibility29:                                     ////
////  - WISHBONE29                                                  ////
////  RS23229 Protocol29                                              ////
////  16550D uart29 (mostly29 supported)                              ////
////                                                              ////
////  Overview29 (main29 Features29):                                   ////
////  Inferrable29 Distributed29 RAM29 for FIFOs29                        ////
////                                                              ////
////  Known29 problems29 (limits29):                                    ////
////  None29                .                                       ////
////                                                              ////
////  To29 Do29:                                                      ////
////  Nothing so far29.                                             ////
////                                                              ////
////  Author29(s):                                                  ////
////      - gorban29@opencores29.org29                                  ////
////      - Jacob29 Gorban29                                          ////
////                                                              ////
////  Created29:        2002/07/22                                  ////
////  Last29 Updated29:   2002/07/22                                  ////
////                  (See log29 for the revision29 history29)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2000, 2001 Authors29                             ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS29 Revision29 History29
//
// $Log: not supported by cvs2svn29 $
// Revision29 1.1  2002/07/22 23:02:23  gorban29
// Bug29 Fixes29:
//  * Possible29 loss of sync and bad29 reception29 of stop bit on slow29 baud29 rates29 fixed29.
//   Problem29 reported29 by Kenny29.Tung29.
//  * Bad (or lack29 of ) loopback29 handling29 fixed29. Reported29 by Cherry29 Withers29.
//
// Improvements29:
//  * Made29 FIFO's as general29 inferrable29 memory where possible29.
//  So29 on FPGA29 they should be inferred29 as RAM29 (Distributed29 RAM29 on Xilinx29).
//  This29 saves29 about29 1/3 of the Slice29 count and reduces29 P&R and synthesis29 times.
//
//  * Added29 optional29 baudrate29 output (baud_o29).
//  This29 is identical29 to BAUDOUT29* signal29 on 16550 chip29.
//  It outputs29 16xbit_clock_rate - the divided29 clock29.
//  It's disabled by default. Define29 UART_HAS_BAUDRATE_OUTPUT29 to use.
//

//Following29 is the Verilog29 code29 for a dual29-port RAM29 with asynchronous29 read. 
module raminfr29   
        (clk29, we29, a, dpra29, di29, dpo29); 

parameter addr_width29 = 4;
parameter data_width29 = 8;
parameter depth = 16;

input clk29;   
input we29;   
input  [addr_width29-1:0] a;   
input  [addr_width29-1:0] dpra29;   
input  [data_width29-1:0] di29;   
//output [data_width29-1:0] spo29;   
output [data_width29-1:0] dpo29;   
reg    [data_width29-1:0] ram29 [depth-1:0]; 

wire [data_width29-1:0] dpo29;
wire  [data_width29-1:0] di29;   
wire  [addr_width29-1:0] a;   
wire  [addr_width29-1:0] dpra29;   
 
  always @(posedge clk29) begin   
    if (we29)   
      ram29[a] <= di29;   
  end   
//  assign spo29 = ram29[a];   
  assign dpo29 = ram29[dpra29];   
endmodule 

