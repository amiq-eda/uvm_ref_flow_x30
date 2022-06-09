//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr7.v                                                   ////
////                                                              ////
////                                                              ////
////  This7 file is part of the "UART7 16550 compatible7" project7    ////
////  http7://www7.opencores7.org7/cores7/uart165507/                   ////
////                                                              ////
////  Documentation7 related7 to this project7:                      ////
////  - http7://www7.opencores7.org7/cores7/uart165507/                 ////
////                                                              ////
////  Projects7 compatibility7:                                     ////
////  - WISHBONE7                                                  ////
////  RS2327 Protocol7                                              ////
////  16550D uart7 (mostly7 supported)                              ////
////                                                              ////
////  Overview7 (main7 Features7):                                   ////
////  Inferrable7 Distributed7 RAM7 for FIFOs7                        ////
////                                                              ////
////  Known7 problems7 (limits7):                                    ////
////  None7                .                                       ////
////                                                              ////
////  To7 Do7:                                                      ////
////  Nothing so far7.                                             ////
////                                                              ////
////  Author7(s):                                                  ////
////      - gorban7@opencores7.org7                                  ////
////      - Jacob7 Gorban7                                          ////
////                                                              ////
////  Created7:        2002/07/22                                  ////
////  Last7 Updated7:   2002/07/22                                  ////
////                  (See log7 for the revision7 history7)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2000, 2001 Authors7                             ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS7 Revision7 History7
//
// $Log: not supported by cvs2svn7 $
// Revision7 1.1  2002/07/22 23:02:23  gorban7
// Bug7 Fixes7:
//  * Possible7 loss of sync and bad7 reception7 of stop bit on slow7 baud7 rates7 fixed7.
//   Problem7 reported7 by Kenny7.Tung7.
//  * Bad (or lack7 of ) loopback7 handling7 fixed7. Reported7 by Cherry7 Withers7.
//
// Improvements7:
//  * Made7 FIFO's as general7 inferrable7 memory where possible7.
//  So7 on FPGA7 they should be inferred7 as RAM7 (Distributed7 RAM7 on Xilinx7).
//  This7 saves7 about7 1/3 of the Slice7 count and reduces7 P&R and synthesis7 times.
//
//  * Added7 optional7 baudrate7 output (baud_o7).
//  This7 is identical7 to BAUDOUT7* signal7 on 16550 chip7.
//  It outputs7 16xbit_clock_rate - the divided7 clock7.
//  It's disabled by default. Define7 UART_HAS_BAUDRATE_OUTPUT7 to use.
//

//Following7 is the Verilog7 code7 for a dual7-port RAM7 with asynchronous7 read. 
module raminfr7   
        (clk7, we7, a, dpra7, di7, dpo7); 

parameter addr_width7 = 4;
parameter data_width7 = 8;
parameter depth = 16;

input clk7;   
input we7;   
input  [addr_width7-1:0] a;   
input  [addr_width7-1:0] dpra7;   
input  [data_width7-1:0] di7;   
//output [data_width7-1:0] spo7;   
output [data_width7-1:0] dpo7;   
reg    [data_width7-1:0] ram7 [depth-1:0]; 

wire [data_width7-1:0] dpo7;
wire  [data_width7-1:0] di7;   
wire  [addr_width7-1:0] a;   
wire  [addr_width7-1:0] dpra7;   
 
  always @(posedge clk7) begin   
    if (we7)   
      ram7[a] <= di7;   
  end   
//  assign spo7 = ram7[a];   
  assign dpo7 = ram7[dpra7];   
endmodule 

