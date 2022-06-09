//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr16.v                                                   ////
////                                                              ////
////                                                              ////
////  This16 file is part of the "UART16 16550 compatible16" project16    ////
////  http16://www16.opencores16.org16/cores16/uart1655016/                   ////
////                                                              ////
////  Documentation16 related16 to this project16:                      ////
////  - http16://www16.opencores16.org16/cores16/uart1655016/                 ////
////                                                              ////
////  Projects16 compatibility16:                                     ////
////  - WISHBONE16                                                  ////
////  RS23216 Protocol16                                              ////
////  16550D uart16 (mostly16 supported)                              ////
////                                                              ////
////  Overview16 (main16 Features16):                                   ////
////  Inferrable16 Distributed16 RAM16 for FIFOs16                        ////
////                                                              ////
////  Known16 problems16 (limits16):                                    ////
////  None16                .                                       ////
////                                                              ////
////  To16 Do16:                                                      ////
////  Nothing so far16.                                             ////
////                                                              ////
////  Author16(s):                                                  ////
////      - gorban16@opencores16.org16                                  ////
////      - Jacob16 Gorban16                                          ////
////                                                              ////
////  Created16:        2002/07/22                                  ////
////  Last16 Updated16:   2002/07/22                                  ////
////                  (See log16 for the revision16 history16)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2000, 2001 Authors16                             ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS16 Revision16 History16
//
// $Log: not supported by cvs2svn16 $
// Revision16 1.1  2002/07/22 23:02:23  gorban16
// Bug16 Fixes16:
//  * Possible16 loss of sync and bad16 reception16 of stop bit on slow16 baud16 rates16 fixed16.
//   Problem16 reported16 by Kenny16.Tung16.
//  * Bad (or lack16 of ) loopback16 handling16 fixed16. Reported16 by Cherry16 Withers16.
//
// Improvements16:
//  * Made16 FIFO's as general16 inferrable16 memory where possible16.
//  So16 on FPGA16 they should be inferred16 as RAM16 (Distributed16 RAM16 on Xilinx16).
//  This16 saves16 about16 1/3 of the Slice16 count and reduces16 P&R and synthesis16 times.
//
//  * Added16 optional16 baudrate16 output (baud_o16).
//  This16 is identical16 to BAUDOUT16* signal16 on 16550 chip16.
//  It outputs16 16xbit_clock_rate - the divided16 clock16.
//  It's disabled by default. Define16 UART_HAS_BAUDRATE_OUTPUT16 to use.
//

//Following16 is the Verilog16 code16 for a dual16-port RAM16 with asynchronous16 read. 
module raminfr16   
        (clk16, we16, a, dpra16, di16, dpo16); 

parameter addr_width16 = 4;
parameter data_width16 = 8;
parameter depth = 16;

input clk16;   
input we16;   
input  [addr_width16-1:0] a;   
input  [addr_width16-1:0] dpra16;   
input  [data_width16-1:0] di16;   
//output [data_width16-1:0] spo16;   
output [data_width16-1:0] dpo16;   
reg    [data_width16-1:0] ram16 [depth-1:0]; 

wire [data_width16-1:0] dpo16;
wire  [data_width16-1:0] di16;   
wire  [addr_width16-1:0] a;   
wire  [addr_width16-1:0] dpra16;   
 
  always @(posedge clk16) begin   
    if (we16)   
      ram16[a] <= di16;   
  end   
//  assign spo16 = ram16[a];   
  assign dpo16 = ram16[dpra16];   
endmodule 

