//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr2.v                                                   ////
////                                                              ////
////                                                              ////
////  This2 file is part of the "UART2 16550 compatible2" project2    ////
////  http2://www2.opencores2.org2/cores2/uart165502/                   ////
////                                                              ////
////  Documentation2 related2 to this project2:                      ////
////  - http2://www2.opencores2.org2/cores2/uart165502/                 ////
////                                                              ////
////  Projects2 compatibility2:                                     ////
////  - WISHBONE2                                                  ////
////  RS2322 Protocol2                                              ////
////  16550D uart2 (mostly2 supported)                              ////
////                                                              ////
////  Overview2 (main2 Features2):                                   ////
////  Inferrable2 Distributed2 RAM2 for FIFOs2                        ////
////                                                              ////
////  Known2 problems2 (limits2):                                    ////
////  None2                .                                       ////
////                                                              ////
////  To2 Do2:                                                      ////
////  Nothing so far2.                                             ////
////                                                              ////
////  Author2(s):                                                  ////
////      - gorban2@opencores2.org2                                  ////
////      - Jacob2 Gorban2                                          ////
////                                                              ////
////  Created2:        2002/07/22                                  ////
////  Last2 Updated2:   2002/07/22                                  ////
////                  (See log2 for the revision2 history2)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2000, 2001 Authors2                             ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS2 Revision2 History2
//
// $Log: not supported by cvs2svn2 $
// Revision2 1.1  2002/07/22 23:02:23  gorban2
// Bug2 Fixes2:
//  * Possible2 loss of sync and bad2 reception2 of stop bit on slow2 baud2 rates2 fixed2.
//   Problem2 reported2 by Kenny2.Tung2.
//  * Bad (or lack2 of ) loopback2 handling2 fixed2. Reported2 by Cherry2 Withers2.
//
// Improvements2:
//  * Made2 FIFO's as general2 inferrable2 memory where possible2.
//  So2 on FPGA2 they should be inferred2 as RAM2 (Distributed2 RAM2 on Xilinx2).
//  This2 saves2 about2 1/3 of the Slice2 count and reduces2 P&R and synthesis2 times.
//
//  * Added2 optional2 baudrate2 output (baud_o2).
//  This2 is identical2 to BAUDOUT2* signal2 on 16550 chip2.
//  It outputs2 16xbit_clock_rate - the divided2 clock2.
//  It's disabled by default. Define2 UART_HAS_BAUDRATE_OUTPUT2 to use.
//

//Following2 is the Verilog2 code2 for a dual2-port RAM2 with asynchronous2 read. 
module raminfr2   
        (clk2, we2, a, dpra2, di2, dpo2); 

parameter addr_width2 = 4;
parameter data_width2 = 8;
parameter depth = 16;

input clk2;   
input we2;   
input  [addr_width2-1:0] a;   
input  [addr_width2-1:0] dpra2;   
input  [data_width2-1:0] di2;   
//output [data_width2-1:0] spo2;   
output [data_width2-1:0] dpo2;   
reg    [data_width2-1:0] ram2 [depth-1:0]; 

wire [data_width2-1:0] dpo2;
wire  [data_width2-1:0] di2;   
wire  [addr_width2-1:0] a;   
wire  [addr_width2-1:0] dpra2;   
 
  always @(posedge clk2) begin   
    if (we2)   
      ram2[a] <= di2;   
  end   
//  assign spo2 = ram2[a];   
  assign dpo2 = ram2[dpra2];   
endmodule 

