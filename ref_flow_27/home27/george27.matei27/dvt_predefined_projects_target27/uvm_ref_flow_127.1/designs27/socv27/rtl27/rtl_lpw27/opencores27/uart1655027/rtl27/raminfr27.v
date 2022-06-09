//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr27.v                                                   ////
////                                                              ////
////                                                              ////
////  This27 file is part of the "UART27 16550 compatible27" project27    ////
////  http27://www27.opencores27.org27/cores27/uart1655027/                   ////
////                                                              ////
////  Documentation27 related27 to this project27:                      ////
////  - http27://www27.opencores27.org27/cores27/uart1655027/                 ////
////                                                              ////
////  Projects27 compatibility27:                                     ////
////  - WISHBONE27                                                  ////
////  RS23227 Protocol27                                              ////
////  16550D uart27 (mostly27 supported)                              ////
////                                                              ////
////  Overview27 (main27 Features27):                                   ////
////  Inferrable27 Distributed27 RAM27 for FIFOs27                        ////
////                                                              ////
////  Known27 problems27 (limits27):                                    ////
////  None27                .                                       ////
////                                                              ////
////  To27 Do27:                                                      ////
////  Nothing so far27.                                             ////
////                                                              ////
////  Author27(s):                                                  ////
////      - gorban27@opencores27.org27                                  ////
////      - Jacob27 Gorban27                                          ////
////                                                              ////
////  Created27:        2002/07/22                                  ////
////  Last27 Updated27:   2002/07/22                                  ////
////                  (See log27 for the revision27 history27)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2000, 2001 Authors27                             ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS27 Revision27 History27
//
// $Log: not supported by cvs2svn27 $
// Revision27 1.1  2002/07/22 23:02:23  gorban27
// Bug27 Fixes27:
//  * Possible27 loss of sync and bad27 reception27 of stop bit on slow27 baud27 rates27 fixed27.
//   Problem27 reported27 by Kenny27.Tung27.
//  * Bad (or lack27 of ) loopback27 handling27 fixed27. Reported27 by Cherry27 Withers27.
//
// Improvements27:
//  * Made27 FIFO's as general27 inferrable27 memory where possible27.
//  So27 on FPGA27 they should be inferred27 as RAM27 (Distributed27 RAM27 on Xilinx27).
//  This27 saves27 about27 1/3 of the Slice27 count and reduces27 P&R and synthesis27 times.
//
//  * Added27 optional27 baudrate27 output (baud_o27).
//  This27 is identical27 to BAUDOUT27* signal27 on 16550 chip27.
//  It outputs27 16xbit_clock_rate - the divided27 clock27.
//  It's disabled by default. Define27 UART_HAS_BAUDRATE_OUTPUT27 to use.
//

//Following27 is the Verilog27 code27 for a dual27-port RAM27 with asynchronous27 read. 
module raminfr27   
        (clk27, we27, a, dpra27, di27, dpo27); 

parameter addr_width27 = 4;
parameter data_width27 = 8;
parameter depth = 16;

input clk27;   
input we27;   
input  [addr_width27-1:0] a;   
input  [addr_width27-1:0] dpra27;   
input  [data_width27-1:0] di27;   
//output [data_width27-1:0] spo27;   
output [data_width27-1:0] dpo27;   
reg    [data_width27-1:0] ram27 [depth-1:0]; 

wire [data_width27-1:0] dpo27;
wire  [data_width27-1:0] di27;   
wire  [addr_width27-1:0] a;   
wire  [addr_width27-1:0] dpra27;   
 
  always @(posedge clk27) begin   
    if (we27)   
      ram27[a] <= di27;   
  end   
//  assign spo27 = ram27[a];   
  assign dpo27 = ram27[dpra27];   
endmodule 

