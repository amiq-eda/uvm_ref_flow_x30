//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr6.v                                                   ////
////                                                              ////
////                                                              ////
////  This6 file is part of the "UART6 16550 compatible6" project6    ////
////  http6://www6.opencores6.org6/cores6/uart165506/                   ////
////                                                              ////
////  Documentation6 related6 to this project6:                      ////
////  - http6://www6.opencores6.org6/cores6/uart165506/                 ////
////                                                              ////
////  Projects6 compatibility6:                                     ////
////  - WISHBONE6                                                  ////
////  RS2326 Protocol6                                              ////
////  16550D uart6 (mostly6 supported)                              ////
////                                                              ////
////  Overview6 (main6 Features6):                                   ////
////  Inferrable6 Distributed6 RAM6 for FIFOs6                        ////
////                                                              ////
////  Known6 problems6 (limits6):                                    ////
////  None6                .                                       ////
////                                                              ////
////  To6 Do6:                                                      ////
////  Nothing so far6.                                             ////
////                                                              ////
////  Author6(s):                                                  ////
////      - gorban6@opencores6.org6                                  ////
////      - Jacob6 Gorban6                                          ////
////                                                              ////
////  Created6:        2002/07/22                                  ////
////  Last6 Updated6:   2002/07/22                                  ////
////                  (See log6 for the revision6 history6)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2000, 2001 Authors6                             ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS6 Revision6 History6
//
// $Log: not supported by cvs2svn6 $
// Revision6 1.1  2002/07/22 23:02:23  gorban6
// Bug6 Fixes6:
//  * Possible6 loss of sync and bad6 reception6 of stop bit on slow6 baud6 rates6 fixed6.
//   Problem6 reported6 by Kenny6.Tung6.
//  * Bad (or lack6 of ) loopback6 handling6 fixed6. Reported6 by Cherry6 Withers6.
//
// Improvements6:
//  * Made6 FIFO's as general6 inferrable6 memory where possible6.
//  So6 on FPGA6 they should be inferred6 as RAM6 (Distributed6 RAM6 on Xilinx6).
//  This6 saves6 about6 1/3 of the Slice6 count and reduces6 P&R and synthesis6 times.
//
//  * Added6 optional6 baudrate6 output (baud_o6).
//  This6 is identical6 to BAUDOUT6* signal6 on 16550 chip6.
//  It outputs6 16xbit_clock_rate - the divided6 clock6.
//  It's disabled by default. Define6 UART_HAS_BAUDRATE_OUTPUT6 to use.
//

//Following6 is the Verilog6 code6 for a dual6-port RAM6 with asynchronous6 read. 
module raminfr6   
        (clk6, we6, a, dpra6, di6, dpo6); 

parameter addr_width6 = 4;
parameter data_width6 = 8;
parameter depth = 16;

input clk6;   
input we6;   
input  [addr_width6-1:0] a;   
input  [addr_width6-1:0] dpra6;   
input  [data_width6-1:0] di6;   
//output [data_width6-1:0] spo6;   
output [data_width6-1:0] dpo6;   
reg    [data_width6-1:0] ram6 [depth-1:0]; 

wire [data_width6-1:0] dpo6;
wire  [data_width6-1:0] di6;   
wire  [addr_width6-1:0] a;   
wire  [addr_width6-1:0] dpra6;   
 
  always @(posedge clk6) begin   
    if (we6)   
      ram6[a] <= di6;   
  end   
//  assign spo6 = ram6[a];   
  assign dpo6 = ram6[dpra6];   
endmodule 

