//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr26.v                                                   ////
////                                                              ////
////                                                              ////
////  This26 file is part of the "UART26 16550 compatible26" project26    ////
////  http26://www26.opencores26.org26/cores26/uart1655026/                   ////
////                                                              ////
////  Documentation26 related26 to this project26:                      ////
////  - http26://www26.opencores26.org26/cores26/uart1655026/                 ////
////                                                              ////
////  Projects26 compatibility26:                                     ////
////  - WISHBONE26                                                  ////
////  RS23226 Protocol26                                              ////
////  16550D uart26 (mostly26 supported)                              ////
////                                                              ////
////  Overview26 (main26 Features26):                                   ////
////  Inferrable26 Distributed26 RAM26 for FIFOs26                        ////
////                                                              ////
////  Known26 problems26 (limits26):                                    ////
////  None26                .                                       ////
////                                                              ////
////  To26 Do26:                                                      ////
////  Nothing so far26.                                             ////
////                                                              ////
////  Author26(s):                                                  ////
////      - gorban26@opencores26.org26                                  ////
////      - Jacob26 Gorban26                                          ////
////                                                              ////
////  Created26:        2002/07/22                                  ////
////  Last26 Updated26:   2002/07/22                                  ////
////                  (See log26 for the revision26 history26)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2000, 2001 Authors26                             ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS26 Revision26 History26
//
// $Log: not supported by cvs2svn26 $
// Revision26 1.1  2002/07/22 23:02:23  gorban26
// Bug26 Fixes26:
//  * Possible26 loss of sync and bad26 reception26 of stop bit on slow26 baud26 rates26 fixed26.
//   Problem26 reported26 by Kenny26.Tung26.
//  * Bad (or lack26 of ) loopback26 handling26 fixed26. Reported26 by Cherry26 Withers26.
//
// Improvements26:
//  * Made26 FIFO's as general26 inferrable26 memory where possible26.
//  So26 on FPGA26 they should be inferred26 as RAM26 (Distributed26 RAM26 on Xilinx26).
//  This26 saves26 about26 1/3 of the Slice26 count and reduces26 P&R and synthesis26 times.
//
//  * Added26 optional26 baudrate26 output (baud_o26).
//  This26 is identical26 to BAUDOUT26* signal26 on 16550 chip26.
//  It outputs26 16xbit_clock_rate - the divided26 clock26.
//  It's disabled by default. Define26 UART_HAS_BAUDRATE_OUTPUT26 to use.
//

//Following26 is the Verilog26 code26 for a dual26-port RAM26 with asynchronous26 read. 
module raminfr26   
        (clk26, we26, a, dpra26, di26, dpo26); 

parameter addr_width26 = 4;
parameter data_width26 = 8;
parameter depth = 16;

input clk26;   
input we26;   
input  [addr_width26-1:0] a;   
input  [addr_width26-1:0] dpra26;   
input  [data_width26-1:0] di26;   
//output [data_width26-1:0] spo26;   
output [data_width26-1:0] dpo26;   
reg    [data_width26-1:0] ram26 [depth-1:0]; 

wire [data_width26-1:0] dpo26;
wire  [data_width26-1:0] di26;   
wire  [addr_width26-1:0] a;   
wire  [addr_width26-1:0] dpra26;   
 
  always @(posedge clk26) begin   
    if (we26)   
      ram26[a] <= di26;   
  end   
//  assign spo26 = ram26[a];   
  assign dpo26 = ram26[dpra26];   
endmodule 

