//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr28.v                                                   ////
////                                                              ////
////                                                              ////
////  This28 file is part of the "UART28 16550 compatible28" project28    ////
////  http28://www28.opencores28.org28/cores28/uart1655028/                   ////
////                                                              ////
////  Documentation28 related28 to this project28:                      ////
////  - http28://www28.opencores28.org28/cores28/uart1655028/                 ////
////                                                              ////
////  Projects28 compatibility28:                                     ////
////  - WISHBONE28                                                  ////
////  RS23228 Protocol28                                              ////
////  16550D uart28 (mostly28 supported)                              ////
////                                                              ////
////  Overview28 (main28 Features28):                                   ////
////  Inferrable28 Distributed28 RAM28 for FIFOs28                        ////
////                                                              ////
////  Known28 problems28 (limits28):                                    ////
////  None28                .                                       ////
////                                                              ////
////  To28 Do28:                                                      ////
////  Nothing so far28.                                             ////
////                                                              ////
////  Author28(s):                                                  ////
////      - gorban28@opencores28.org28                                  ////
////      - Jacob28 Gorban28                                          ////
////                                                              ////
////  Created28:        2002/07/22                                  ////
////  Last28 Updated28:   2002/07/22                                  ////
////                  (See log28 for the revision28 history28)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2000, 2001 Authors28                             ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS28 Revision28 History28
//
// $Log: not supported by cvs2svn28 $
// Revision28 1.1  2002/07/22 23:02:23  gorban28
// Bug28 Fixes28:
//  * Possible28 loss of sync and bad28 reception28 of stop bit on slow28 baud28 rates28 fixed28.
//   Problem28 reported28 by Kenny28.Tung28.
//  * Bad (or lack28 of ) loopback28 handling28 fixed28. Reported28 by Cherry28 Withers28.
//
// Improvements28:
//  * Made28 FIFO's as general28 inferrable28 memory where possible28.
//  So28 on FPGA28 they should be inferred28 as RAM28 (Distributed28 RAM28 on Xilinx28).
//  This28 saves28 about28 1/3 of the Slice28 count and reduces28 P&R and synthesis28 times.
//
//  * Added28 optional28 baudrate28 output (baud_o28).
//  This28 is identical28 to BAUDOUT28* signal28 on 16550 chip28.
//  It outputs28 16xbit_clock_rate - the divided28 clock28.
//  It's disabled by default. Define28 UART_HAS_BAUDRATE_OUTPUT28 to use.
//

//Following28 is the Verilog28 code28 for a dual28-port RAM28 with asynchronous28 read. 
module raminfr28   
        (clk28, we28, a, dpra28, di28, dpo28); 

parameter addr_width28 = 4;
parameter data_width28 = 8;
parameter depth = 16;

input clk28;   
input we28;   
input  [addr_width28-1:0] a;   
input  [addr_width28-1:0] dpra28;   
input  [data_width28-1:0] di28;   
//output [data_width28-1:0] spo28;   
output [data_width28-1:0] dpo28;   
reg    [data_width28-1:0] ram28 [depth-1:0]; 

wire [data_width28-1:0] dpo28;
wire  [data_width28-1:0] di28;   
wire  [addr_width28-1:0] a;   
wire  [addr_width28-1:0] dpra28;   
 
  always @(posedge clk28) begin   
    if (we28)   
      ram28[a] <= di28;   
  end   
//  assign spo28 = ram28[a];   
  assign dpo28 = ram28[dpra28];   
endmodule 

