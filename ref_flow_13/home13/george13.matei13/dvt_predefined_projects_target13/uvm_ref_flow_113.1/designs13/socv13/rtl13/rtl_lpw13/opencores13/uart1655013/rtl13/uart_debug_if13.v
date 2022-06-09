//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if13.v                                             ////
////                                                              ////
////                                                              ////
////  This13 file is part of the "UART13 16550 compatible13" project13    ////
////  http13://www13.opencores13.org13/cores13/uart1655013/                   ////
////                                                              ////
////  Documentation13 related13 to this project13:                      ////
////  - http13://www13.opencores13.org13/cores13/uart1655013/                 ////
////                                                              ////
////  Projects13 compatibility13:                                     ////
////  - WISHBONE13                                                  ////
////  RS23213 Protocol13                                              ////
////  16550D uart13 (mostly13 supported)                              ////
////                                                              ////
////  Overview13 (main13 Features13):                                   ////
////  UART13 core13 debug13 interface.                                  ////
////                                                              ////
////  Author13(s):                                                  ////
////      - gorban13@opencores13.org13                                  ////
////      - Jacob13 Gorban13                                          ////
////                                                              ////
////  Created13:        2001/12/02                                  ////
////                  (See log13 for the revision13 history13)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2000, 2001 Authors13                             ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS13 Revision13 History13
//
// $Log: not supported by cvs2svn13 $
// Revision13 1.4  2002/07/22 23:02:23  gorban13
// Bug13 Fixes13:
//  * Possible13 loss of sync and bad13 reception13 of stop bit on slow13 baud13 rates13 fixed13.
//   Problem13 reported13 by Kenny13.Tung13.
//  * Bad (or lack13 of ) loopback13 handling13 fixed13. Reported13 by Cherry13 Withers13.
//
// Improvements13:
//  * Made13 FIFO's as general13 inferrable13 memory where possible13.
//  So13 on FPGA13 they should be inferred13 as RAM13 (Distributed13 RAM13 on Xilinx13).
//  This13 saves13 about13 1/3 of the Slice13 count and reduces13 P&R and synthesis13 times.
//
//  * Added13 optional13 baudrate13 output (baud_o13).
//  This13 is identical13 to BAUDOUT13* signal13 on 16550 chip13.
//  It outputs13 16xbit_clock_rate - the divided13 clock13.
//  It's disabled by default. Define13 UART_HAS_BAUDRATE_OUTPUT13 to use.
//
// Revision13 1.3  2001/12/19 08:40:03  mohor13
// Warnings13 fixed13 (unused13 signals13 removed).
//
// Revision13 1.2  2001/12/12 22:17:30  gorban13
// some13 synthesis13 bugs13 fixed13
//
// Revision13 1.1  2001/12/04 21:14:16  gorban13
// committed13 the debug13 interface file
//

// synopsys13 translate_off13
`include "timescale.v"
// synopsys13 translate_on13

`include "uart_defines13.v"

module uart_debug_if13 (/*AUTOARG13*/
// Outputs13
wb_dat32_o13, 
// Inputs13
wb_adr_i13, ier13, iir13, fcr13, mcr13, lcr13, msr13, 
lsr13, rf_count13, tf_count13, tstate13, rstate
) ;

input [`UART_ADDR_WIDTH13-1:0] 		wb_adr_i13;
output [31:0] 							wb_dat32_o13;
input [3:0] 							ier13;
input [3:0] 							iir13;
input [1:0] 							fcr13;  /// bits 7 and 6 of fcr13. Other13 bits are ignored
input [4:0] 							mcr13;
input [7:0] 							lcr13;
input [7:0] 							msr13;
input [7:0] 							lsr13;
input [`UART_FIFO_COUNTER_W13-1:0] rf_count13;
input [`UART_FIFO_COUNTER_W13-1:0] tf_count13;
input [2:0] 							tstate13;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH13-1:0] 		wb_adr_i13;
reg [31:0] 								wb_dat32_o13;

always @(/*AUTOSENSE13*/fcr13 or ier13 or iir13 or lcr13 or lsr13 or mcr13 or msr13
			or rf_count13 or rstate or tf_count13 or tstate13 or wb_adr_i13)
	case (wb_adr_i13)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o13 = {msr13,lcr13,iir13,ier13,lsr13};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o13 = {8'b0, fcr13,mcr13, rf_count13, rstate, tf_count13, tstate13};
		default: wb_dat32_o13 = 0;
	endcase // case(wb_adr_i13)

endmodule // uart_debug_if13

