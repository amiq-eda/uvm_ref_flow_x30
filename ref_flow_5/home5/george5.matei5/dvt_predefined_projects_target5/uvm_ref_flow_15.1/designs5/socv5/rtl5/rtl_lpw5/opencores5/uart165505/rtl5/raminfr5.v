//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr5.v                                                   ////
////                                                              ////
////                                                              ////
////  This5 file is part of the "UART5 16550 compatible5" project5    ////
////  http5://www5.opencores5.org5/cores5/uart165505/                   ////
////                                                              ////
////  Documentation5 related5 to this project5:                      ////
////  - http5://www5.opencores5.org5/cores5/uart165505/                 ////
////                                                              ////
////  Projects5 compatibility5:                                     ////
////  - WISHBONE5                                                  ////
////  RS2325 Protocol5                                              ////
////  16550D uart5 (mostly5 supported)                              ////
////                                                              ////
////  Overview5 (main5 Features5):                                   ////
////  Inferrable5 Distributed5 RAM5 for FIFOs5                        ////
////                                                              ////
////  Known5 problems5 (limits5):                                    ////
////  None5                .                                       ////
////                                                              ////
////  To5 Do5:                                                      ////
////  Nothing so far5.                                             ////
////                                                              ////
////  Author5(s):                                                  ////
////      - gorban5@opencores5.org5                                  ////
////      - Jacob5 Gorban5                                          ////
////                                                              ////
////  Created5:        2002/07/22                                  ////
////  Last5 Updated5:   2002/07/22                                  ////
////                  (See log5 for the revision5 history5)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2000, 2001 Authors5                             ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS5 Revision5 History5
//
// $Log: not supported by cvs2svn5 $
// Revision5 1.1  2002/07/22 23:02:23  gorban5
// Bug5 Fixes5:
//  * Possible5 loss of sync and bad5 reception5 of stop bit on slow5 baud5 rates5 fixed5.
//   Problem5 reported5 by Kenny5.Tung5.
//  * Bad (or lack5 of ) loopback5 handling5 fixed5. Reported5 by Cherry5 Withers5.
//
// Improvements5:
//  * Made5 FIFO's as general5 inferrable5 memory where possible5.
//  So5 on FPGA5 they should be inferred5 as RAM5 (Distributed5 RAM5 on Xilinx5).
//  This5 saves5 about5 1/3 of the Slice5 count and reduces5 P&R and synthesis5 times.
//
//  * Added5 optional5 baudrate5 output (baud_o5).
//  This5 is identical5 to BAUDOUT5* signal5 on 16550 chip5.
//  It outputs5 16xbit_clock_rate - the divided5 clock5.
//  It's disabled by default. Define5 UART_HAS_BAUDRATE_OUTPUT5 to use.
//

//Following5 is the Verilog5 code5 for a dual5-port RAM5 with asynchronous5 read. 
module raminfr5   
        (clk5, we5, a, dpra5, di5, dpo5); 

parameter addr_width5 = 4;
parameter data_width5 = 8;
parameter depth = 16;

input clk5;   
input we5;   
input  [addr_width5-1:0] a;   
input  [addr_width5-1:0] dpra5;   
input  [data_width5-1:0] di5;   
//output [data_width5-1:0] spo5;   
output [data_width5-1:0] dpo5;   
reg    [data_width5-1:0] ram5 [depth-1:0]; 

wire [data_width5-1:0] dpo5;
wire  [data_width5-1:0] di5;   
wire  [addr_width5-1:0] a;   
wire  [addr_width5-1:0] dpra5;   
 
  always @(posedge clk5) begin   
    if (we5)   
      ram5[a] <= di5;   
  end   
//  assign spo5 = ram5[a];   
  assign dpo5 = ram5[dpra5];   
endmodule 

