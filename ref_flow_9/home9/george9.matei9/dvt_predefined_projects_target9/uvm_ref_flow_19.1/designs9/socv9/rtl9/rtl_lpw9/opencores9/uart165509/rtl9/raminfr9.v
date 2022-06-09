//////////////////////////////////////////////////////////////////////
////                                                              ////
////  raminfr9.v                                                   ////
////                                                              ////
////                                                              ////
////  This9 file is part of the "UART9 16550 compatible9" project9    ////
////  http9://www9.opencores9.org9/cores9/uart165509/                   ////
////                                                              ////
////  Documentation9 related9 to this project9:                      ////
////  - http9://www9.opencores9.org9/cores9/uart165509/                 ////
////                                                              ////
////  Projects9 compatibility9:                                     ////
////  - WISHBONE9                                                  ////
////  RS2329 Protocol9                                              ////
////  16550D uart9 (mostly9 supported)                              ////
////                                                              ////
////  Overview9 (main9 Features9):                                   ////
////  Inferrable9 Distributed9 RAM9 for FIFOs9                        ////
////                                                              ////
////  Known9 problems9 (limits9):                                    ////
////  None9                .                                       ////
////                                                              ////
////  To9 Do9:                                                      ////
////  Nothing so far9.                                             ////
////                                                              ////
////  Author9(s):                                                  ////
////      - gorban9@opencores9.org9                                  ////
////      - Jacob9 Gorban9                                          ////
////                                                              ////
////  Created9:        2002/07/22                                  ////
////  Last9 Updated9:   2002/07/22                                  ////
////                  (See log9 for the revision9 history9)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2000, 2001 Authors9                             ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS9 Revision9 History9
//
// $Log: not supported by cvs2svn9 $
// Revision9 1.1  2002/07/22 23:02:23  gorban9
// Bug9 Fixes9:
//  * Possible9 loss of sync and bad9 reception9 of stop bit on slow9 baud9 rates9 fixed9.
//   Problem9 reported9 by Kenny9.Tung9.
//  * Bad (or lack9 of ) loopback9 handling9 fixed9. Reported9 by Cherry9 Withers9.
//
// Improvements9:
//  * Made9 FIFO's as general9 inferrable9 memory where possible9.
//  So9 on FPGA9 they should be inferred9 as RAM9 (Distributed9 RAM9 on Xilinx9).
//  This9 saves9 about9 1/3 of the Slice9 count and reduces9 P&R and synthesis9 times.
//
//  * Added9 optional9 baudrate9 output (baud_o9).
//  This9 is identical9 to BAUDOUT9* signal9 on 16550 chip9.
//  It outputs9 16xbit_clock_rate - the divided9 clock9.
//  It's disabled by default. Define9 UART_HAS_BAUDRATE_OUTPUT9 to use.
//

//Following9 is the Verilog9 code9 for a dual9-port RAM9 with asynchronous9 read. 
module raminfr9   
        (clk9, we9, a, dpra9, di9, dpo9); 

parameter addr_width9 = 4;
parameter data_width9 = 8;
parameter depth = 16;

input clk9;   
input we9;   
input  [addr_width9-1:0] a;   
input  [addr_width9-1:0] dpra9;   
input  [data_width9-1:0] di9;   
//output [data_width9-1:0] spo9;   
output [data_width9-1:0] dpo9;   
reg    [data_width9-1:0] ram9 [depth-1:0]; 

wire [data_width9-1:0] dpo9;
wire  [data_width9-1:0] di9;   
wire  [addr_width9-1:0] a;   
wire  [addr_width9-1:0] dpra9;   
 
  always @(posedge clk9) begin   
    if (we9)   
      ram9[a] <= di9;   
  end   
//  assign spo9 = ram9[a];   
  assign dpo9 = ram9[dpra9];   
endmodule 

