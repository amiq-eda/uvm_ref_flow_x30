//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr18.v                                                   ////
////                                                              ////
////                                                              ////
////  This18 file is part of the "UART18 16550 compatible18" project18    ////
////  http18://www18.opencores18.org18/cores18/uart1655018/                   ////
////                                                              ////
////  Documentation18 related18 to this project18:                      ////
////  - http18://www18.opencores18.org18/cores18/uart1655018/                 ////
////                                                              ////
////  Projects18 compatibility18:                                     ////
////  - WISHBONE18                                                  ////
////  RS23218 Protocol18                                              ////
////  16550D uart18 (mostly18 supported)                              ////
////                                                              ////
////  Overview18 (main18 Features18):                                   ////
////  Inferrable18 Distributed18 RAM18 for FIFOs18                        ////
////                                                              ////
////  Known18 problems18 (limits18):                                    ////
////  None18                .                                       ////
////                                                              ////
////  To18 Do18:                                                      ////
////  Nothing so far18.                                             ////
////                                                              ////
////  Author18(s):                                                  ////
////      - gorban18@opencores18.org18                                  ////
////      - Jacob18 Gorban18                                          ////
////                                                              ////
////  Created18:        2002/07/22                                  ////
////  Last18 Updated18:   2002/07/22                                  ////
////                  (See log18 for the revision18 history18)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2000, 2001 Authors18                             ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS18 Revision18 History18
//
// $Log: not supported by cvs2svn18 $
// Revision18 1.1  2002/07/22 23:02:23  gorban18
// Bug18 Fixes18:
//  * Possible18 loss of sync and bad18 reception18 of stop bit on slow18 baud18 rates18 fixed18.
//   Problem18 reported18 by Kenny18.Tung18.
//  * Bad (or lack18 of ) loopback18 handling18 fixed18. Reported18 by Cherry18 Withers18.
//
// Improvements18:
//  * Made18 FIFO's as general18 inferrable18 memory where possible18.
//  So18 on FPGA18 they should be inferred18 as RAM18 (Distributed18 RAM18 on Xilinx18).
//  This18 saves18 about18 1/3 of the Slice18 count and reduces18 P&R and synthesis18 times.
//
//  * Added18 optional18 baudrate18 output (baud_o18).
//  This18 is identical18 to BAUDOUT18* signal18 on 16550 chip18.
//  It outputs18 16xbit_clock_rate - the divided18 clock18.
//  It's disabled by default. Define18 UART_HAS_BAUDRATE_OUTPUT18 to use.
//

//Following18 is the Verilog18 code18 for a dual18-port RAM18 with asynchronous18 read. 
module raminfr18   
        (clk18, we18, a, dpra18, di18, dpo18); 

parameter addr_width18 = 4;
parameter data_width18 = 8;
parameter depth = 16;

input clk18;   
input we18;   
input  [addr_width18-1:0] a;   
input  [addr_width18-1:0] dpra18;   
input  [data_width18-1:0] di18;   
//output [data_width18-1:0] spo18;   
output [data_width18-1:0] dpo18;   
reg    [data_width18-1:0] ram18 [depth-1:0]; 

wire [data_width18-1:0] dpo18;
wire  [data_width18-1:0] di18;   
wire  [addr_width18-1:0] a;   
wire  [addr_width18-1:0] dpra18;   
 
  always @(posedge clk18) begin   
    if (we18)   
      ram18[a] <= di18;   
  end   
//  assign spo18 = ram18[a];   
  assign dpo18 = ram18[dpra18];   
endmodule 

