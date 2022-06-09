//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr19.v                                                   ////
////                                                              ////
////                                                              ////
////  This19 file is part of the "UART19 16550 compatible19" project19    ////
////  http19://www19.opencores19.org19/cores19/uart1655019/                   ////
////                                                              ////
////  Documentation19 related19 to this project19:                      ////
////  - http19://www19.opencores19.org19/cores19/uart1655019/                 ////
////                                                              ////
////  Projects19 compatibility19:                                     ////
////  - WISHBONE19                                                  ////
////  RS23219 Protocol19                                              ////
////  16550D uart19 (mostly19 supported)                              ////
////                                                              ////
////  Overview19 (main19 Features19):                                   ////
////  Inferrable19 Distributed19 RAM19 for FIFOs19                        ////
////                                                              ////
////  Known19 problems19 (limits19):                                    ////
////  None19                .                                       ////
////                                                              ////
////  To19 Do19:                                                      ////
////  Nothing so far19.                                             ////
////                                                              ////
////  Author19(s):                                                  ////
////      - gorban19@opencores19.org19                                  ////
////      - Jacob19 Gorban19                                          ////
////                                                              ////
////  Created19:        2002/07/22                                  ////
////  Last19 Updated19:   2002/07/22                                  ////
////                  (See log19 for the revision19 history19)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2000, 2001 Authors19                             ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS19 Revision19 History19
//
// $Log: not supported by cvs2svn19 $
// Revision19 1.1  2002/07/22 23:02:23  gorban19
// Bug19 Fixes19:
//  * Possible19 loss of sync and bad19 reception19 of stop bit on slow19 baud19 rates19 fixed19.
//   Problem19 reported19 by Kenny19.Tung19.
//  * Bad (or lack19 of ) loopback19 handling19 fixed19. Reported19 by Cherry19 Withers19.
//
// Improvements19:
//  * Made19 FIFO's as general19 inferrable19 memory where possible19.
//  So19 on FPGA19 they should be inferred19 as RAM19 (Distributed19 RAM19 on Xilinx19).
//  This19 saves19 about19 1/3 of the Slice19 count and reduces19 P&R and synthesis19 times.
//
//  * Added19 optional19 baudrate19 output (baud_o19).
//  This19 is identical19 to BAUDOUT19* signal19 on 16550 chip19.
//  It outputs19 16xbit_clock_rate - the divided19 clock19.
//  It's disabled by default. Define19 UART_HAS_BAUDRATE_OUTPUT19 to use.
//

//Following19 is the Verilog19 code19 for a dual19-port RAM19 with asynchronous19 read. 
module raminfr19   
        (clk19, we19, a, dpra19, di19, dpo19); 

parameter addr_width19 = 4;
parameter data_width19 = 8;
parameter depth = 16;

input clk19;   
input we19;   
input  [addr_width19-1:0] a;   
input  [addr_width19-1:0] dpra19;   
input  [data_width19-1:0] di19;   
//output [data_width19-1:0] spo19;   
output [data_width19-1:0] dpo19;   
reg    [data_width19-1:0] ram19 [depth-1:0]; 

wire [data_width19-1:0] dpo19;
wire  [data_width19-1:0] di19;   
wire  [addr_width19-1:0] a;   
wire  [addr_width19-1:0] dpra19;   
 
  always @(posedge clk19) begin   
    if (we19)   
      ram19[a] <= di19;   
  end   
//  assign spo19 = ram19[a];   
  assign dpo19 = ram19[dpra19];   
endmodule 

