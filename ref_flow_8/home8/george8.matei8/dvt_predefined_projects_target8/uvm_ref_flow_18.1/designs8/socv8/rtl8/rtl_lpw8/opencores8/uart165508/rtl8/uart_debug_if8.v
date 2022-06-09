//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if8.v                                             ////
////                                                              ////
////                                                              ////
////  This8 file is part of the "UART8 16550 compatible8" project8    ////
////  http8://www8.opencores8.org8/cores8/uart165508/                   ////
////                                                              ////
////  Documentation8 related8 to this project8:                      ////
////  - http8://www8.opencores8.org8/cores8/uart165508/                 ////
////                                                              ////
////  Projects8 compatibility8:                                     ////
////  - WISHBONE8                                                  ////
////  RS2328 Protocol8                                              ////
////  16550D uart8 (mostly8 supported)                              ////
////                                                              ////
////  Overview8 (main8 Features8):                                   ////
////  UART8 core8 debug8 interface.                                  ////
////                                                              ////
////  Author8(s):                                                  ////
////      - gorban8@opencores8.org8                                  ////
////      - Jacob8 Gorban8                                          ////
////                                                              ////
////  Created8:        2001/12/02                                  ////
////                  (See log8 for the revision8 history8)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2000, 2001 Authors8                             ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS8 Revision8 History8
//
// $Log: not supported by cvs2svn8 $
// Revision8 1.4  2002/07/22 23:02:23  gorban8
// Bug8 Fixes8:
//  * Possible8 loss of sync and bad8 reception8 of stop bit on slow8 baud8 rates8 fixed8.
//   Problem8 reported8 by Kenny8.Tung8.
//  * Bad (or lack8 of ) loopback8 handling8 fixed8. Reported8 by Cherry8 Withers8.
//
// Improvements8:
//  * Made8 FIFO's as general8 inferrable8 memory where possible8.
//  So8 on FPGA8 they should be inferred8 as RAM8 (Distributed8 RAM8 on Xilinx8).
//  This8 saves8 about8 1/3 of the Slice8 count and reduces8 P&R and synthesis8 times.
//
//  * Added8 optional8 baudrate8 output (baud_o8).
//  This8 is identical8 to BAUDOUT8* signal8 on 16550 chip8.
//  It outputs8 16xbit_clock_rate - the divided8 clock8.
//  It's disabled by default. Define8 UART_HAS_BAUDRATE_OUTPUT8 to use.
//
// Revision8 1.3  2001/12/19 08:40:03  mohor8
// Warnings8 fixed8 (unused8 signals8 removed).
//
// Revision8 1.2  2001/12/12 22:17:30  gorban8
// some8 synthesis8 bugs8 fixed8
//
// Revision8 1.1  2001/12/04 21:14:16  gorban8
// committed8 the debug8 interface file
//

// synopsys8 translate_off8
`include "timescale.v"
// synopsys8 translate_on8

`include "uart_defines8.v"

module uart_debug_if8 (/*AUTOARG8*/
// Outputs8
wb_dat32_o8, 
// Inputs8
wb_adr_i8, ier8, iir8, fcr8, mcr8, lcr8, msr8, 
lsr8, rf_count8, tf_count8, tstate8, rstate
) ;

input [`UART_ADDR_WIDTH8-1:0] 		wb_adr_i8;
output [31:0] 							wb_dat32_o8;
input [3:0] 							ier8;
input [3:0] 							iir8;
input [1:0] 							fcr8;  /// bits 7 and 6 of fcr8. Other8 bits are ignored
input [4:0] 							mcr8;
input [7:0] 							lcr8;
input [7:0] 							msr8;
input [7:0] 							lsr8;
input [`UART_FIFO_COUNTER_W8-1:0] rf_count8;
input [`UART_FIFO_COUNTER_W8-1:0] tf_count8;
input [2:0] 							tstate8;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH8-1:0] 		wb_adr_i8;
reg [31:0] 								wb_dat32_o8;

always @(/*AUTOSENSE8*/fcr8 or ier8 or iir8 or lcr8 or lsr8 or mcr8 or msr8
			or rf_count8 or rstate or tf_count8 or tstate8 or wb_adr_i8)
	case (wb_adr_i8)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o8 = {msr8,lcr8,iir8,ier8,lsr8};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o8 = {8'b0, fcr8,mcr8, rf_count8, rstate, tf_count8, tstate8};
		default: wb_dat32_o8 = 0;
	endcase // case(wb_adr_i8)

endmodule // uart_debug_if8

