//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr8.v                                                   ////
////                                                              ////
////                                                              ////
////  This8 file is part of the "UART8 16550 compatible8" project8    ////
////  http8://www8.opencores8.org8/cores8/uart165508/                   ////
////                                                              ////
////  Documentation8 related8 to this project8:                      ////
////  - http8://www8.opencores8.org8/cores8/uart165508/                 ////
////                                                              ////
////  Projects8 compatibility8:                                     ////
////  - WISHBONE8                                                  ////
////  RS2328 Protocol8                                              ////
////  16550D uart8 (mostly8 supported)                              ////
////                                                              ////
////  Overview8 (main8 Features8):                                   ////
////  Inferrable8 Distributed8 RAM8 for FIFOs8                        ////
////                                                              ////
////  Known8 problems8 (limits8):                                    ////
////  None8                .                                       ////
////                                                              ////
////  To8 Do8:                                                      ////
////  Nothing so far8.                                             ////
////                                                              ////
////  Author8(s):                                                  ////
////      - gorban8@opencores8.org8                                  ////
////      - Jacob8 Gorban8                                          ////
////                                                              ////
////  Created8:        2002/07/22                                  ////
////  Last8 Updated8:   2002/07/22                                  ////
////                  (See log8 for the revision8 history8)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2000, 2001 Authors8                             ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS8 Revision8 History8
//
// $Log: not supported by cvs2svn8 $
// Revision8 1.1  2002/07/22 23:02:23  gorban8
// Bug8 Fixes8:
//  * Possible8 loss of sync and bad8 reception8 of stop bit on slow8 baud8 rates8 fixed8.
//   Problem8 reported8 by Kenny8.Tung8.
//  * Bad (or lack8 of ) loopback8 handling8 fixed8. Reported8 by Cherry8 Withers8.
//
// Improvements8:
//  * Made8 FIFO's as general8 inferrable8 memory where possible8.
//  So8 on FPGA8 they should be inferred8 as RAM8 (Distributed8 RAM8 on Xilinx8).
//  This8 saves8 about8 1/3 of the Slice8 count and reduces8 P&R and synthesis8 times.
//
//  * Added8 optional8 baudrate8 output (baud_o8).
//  This8 is identical8 to BAUDOUT8* signal8 on 16550 chip8.
//  It outputs8 16xbit_clock_rate - the divided8 clock8.
//  It's disabled by default. Define8 UART_HAS_BAUDRATE_OUTPUT8 to use.
//

//Following8 is the Verilog8 code8 for a dual8-port RAM8 with asynchronous8 read. 
module raminfr8   
        (clk8, we8, a, dpra8, di8, dpo8); 

parameter addr_width8 = 4;
parameter data_width8 = 8;
parameter depth = 16;

input clk8;   
input we8;   
input  [addr_width8-1:0] a;   
input  [addr_width8-1:0] dpra8;   
input  [data_width8-1:0] di8;   
//output [data_width8-1:0] spo8;   
output [data_width8-1:0] dpo8;   
reg    [data_width8-1:0] ram8 [depth-1:0]; 

wire [data_width8-1:0] dpo8;
wire  [data_width8-1:0] di8;   
wire  [addr_width8-1:0] a;   
wire  [addr_width8-1:0] dpra8;   
 
  always @(posedge clk8) begin   
    if (we8)   
      ram8[a] <= di8;   
  end   
//  assign spo8 = ram8[a];   
  assign dpo8 = ram8[dpra8];   
endmodule 

