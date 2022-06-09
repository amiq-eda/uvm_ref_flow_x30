//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if25.v                                             ////
////                                                              ////
////                                                              ////
////  This25 file is part of the "UART25 16550 compatible25" project25    ////
////  http25://www25.opencores25.org25/cores25/uart1655025/                   ////
////                                                              ////
////  Documentation25 related25 to this project25:                      ////
////  - http25://www25.opencores25.org25/cores25/uart1655025/                 ////
////                                                              ////
////  Projects25 compatibility25:                                     ////
////  - WISHBONE25                                                  ////
////  RS23225 Protocol25                                              ////
////  16550D uart25 (mostly25 supported)                              ////
////                                                              ////
////  Overview25 (main25 Features25):                                   ////
////  UART25 core25 debug25 interface.                                  ////
////                                                              ////
////  Author25(s):                                                  ////
////      - gorban25@opencores25.org25                                  ////
////      - Jacob25 Gorban25                                          ////
////                                                              ////
////  Created25:        2001/12/02                                  ////
////                  (See log25 for the revision25 history25)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2000, 2001 Authors25                             ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS25 Revision25 History25
//
// $Log: not supported by cvs2svn25 $
// Revision25 1.4  2002/07/22 23:02:23  gorban25
// Bug25 Fixes25:
//  * Possible25 loss of sync and bad25 reception25 of stop bit on slow25 baud25 rates25 fixed25.
//   Problem25 reported25 by Kenny25.Tung25.
//  * Bad (or lack25 of ) loopback25 handling25 fixed25. Reported25 by Cherry25 Withers25.
//
// Improvements25:
//  * Made25 FIFO's as general25 inferrable25 memory where possible25.
//  So25 on FPGA25 they should be inferred25 as RAM25 (Distributed25 RAM25 on Xilinx25).
//  This25 saves25 about25 1/3 of the Slice25 count and reduces25 P&R and synthesis25 times.
//
//  * Added25 optional25 baudrate25 output (baud_o25).
//  This25 is identical25 to BAUDOUT25* signal25 on 16550 chip25.
//  It outputs25 16xbit_clock_rate - the divided25 clock25.
//  It's disabled by default. Define25 UART_HAS_BAUDRATE_OUTPUT25 to use.
//
// Revision25 1.3  2001/12/19 08:40:03  mohor25
// Warnings25 fixed25 (unused25 signals25 removed).
//
// Revision25 1.2  2001/12/12 22:17:30  gorban25
// some25 synthesis25 bugs25 fixed25
//
// Revision25 1.1  2001/12/04 21:14:16  gorban25
// committed25 the debug25 interface file
//

// synopsys25 translate_off25
`include "timescale.v"
// synopsys25 translate_on25

`include "uart_defines25.v"

module uart_debug_if25 (/*AUTOARG25*/
// Outputs25
wb_dat32_o25, 
// Inputs25
wb_adr_i25, ier25, iir25, fcr25, mcr25, lcr25, msr25, 
lsr25, rf_count25, tf_count25, tstate25, rstate
) ;

input [`UART_ADDR_WIDTH25-1:0] 		wb_adr_i25;
output [31:0] 							wb_dat32_o25;
input [3:0] 							ier25;
input [3:0] 							iir25;
input [1:0] 							fcr25;  /// bits 7 and 6 of fcr25. Other25 bits are ignored
input [4:0] 							mcr25;
input [7:0] 							lcr25;
input [7:0] 							msr25;
input [7:0] 							lsr25;
input [`UART_FIFO_COUNTER_W25-1:0] rf_count25;
input [`UART_FIFO_COUNTER_W25-1:0] tf_count25;
input [2:0] 							tstate25;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH25-1:0] 		wb_adr_i25;
reg [31:0] 								wb_dat32_o25;

always @(/*AUTOSENSE25*/fcr25 or ier25 or iir25 or lcr25 or lsr25 or mcr25 or msr25
			or rf_count25 or rstate or tf_count25 or tstate25 or wb_adr_i25)
	case (wb_adr_i25)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o25 = {msr25,lcr25,iir25,ier25,lsr25};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o25 = {8'b0, fcr25,mcr25, rf_count25, rstate, tf_count25, tstate25};
		default: wb_dat32_o25 = 0;
	endcase // case(wb_adr_i25)

endmodule // uart_debug_if25

