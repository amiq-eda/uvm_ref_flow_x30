//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if24.v                                             ////
////                                                              ////
////                                                              ////
////  This24 file is part of the "UART24 16550 compatible24" project24    ////
////  http24://www24.opencores24.org24/cores24/uart1655024/                   ////
////                                                              ////
////  Documentation24 related24 to this project24:                      ////
////  - http24://www24.opencores24.org24/cores24/uart1655024/                 ////
////                                                              ////
////  Projects24 compatibility24:                                     ////
////  - WISHBONE24                                                  ////
////  RS23224 Protocol24                                              ////
////  16550D uart24 (mostly24 supported)                              ////
////                                                              ////
////  Overview24 (main24 Features24):                                   ////
////  UART24 core24 debug24 interface.                                  ////
////                                                              ////
////  Author24(s):                                                  ////
////      - gorban24@opencores24.org24                                  ////
////      - Jacob24 Gorban24                                          ////
////                                                              ////
////  Created24:        2001/12/02                                  ////
////                  (See log24 for the revision24 history24)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright24 (C) 2000, 2001 Authors24                             ////
////                                                              ////
//// This24 source24 file may be used and distributed24 without         ////
//// restriction24 provided that this copyright24 statement24 is not    ////
//// removed from the file and that any derivative24 work24 contains24  ////
//// the original copyright24 notice24 and the associated disclaimer24. ////
////                                                              ////
//// This24 source24 file is free software24; you can redistribute24 it   ////
//// and/or modify it under the terms24 of the GNU24 Lesser24 General24   ////
//// Public24 License24 as published24 by the Free24 Software24 Foundation24; ////
//// either24 version24 2.1 of the License24, or (at your24 option) any   ////
//// later24 version24.                                               ////
////                                                              ////
//// This24 source24 is distributed24 in the hope24 that it will be       ////
//// useful24, but WITHOUT24 ANY24 WARRANTY24; without even24 the implied24   ////
//// warranty24 of MERCHANTABILITY24 or FITNESS24 FOR24 A PARTICULAR24      ////
//// PURPOSE24.  See the GNU24 Lesser24 General24 Public24 License24 for more ////
//// details24.                                                     ////
////                                                              ////
//// You should have received24 a copy of the GNU24 Lesser24 General24    ////
//// Public24 License24 along24 with this source24; if not, download24 it   ////
//// from http24://www24.opencores24.org24/lgpl24.shtml24                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS24 Revision24 History24
//
// $Log: not supported by cvs2svn24 $
// Revision24 1.4  2002/07/22 23:02:23  gorban24
// Bug24 Fixes24:
//  * Possible24 loss of sync and bad24 reception24 of stop bit on slow24 baud24 rates24 fixed24.
//   Problem24 reported24 by Kenny24.Tung24.
//  * Bad (or lack24 of ) loopback24 handling24 fixed24. Reported24 by Cherry24 Withers24.
//
// Improvements24:
//  * Made24 FIFO's as general24 inferrable24 memory where possible24.
//  So24 on FPGA24 they should be inferred24 as RAM24 (Distributed24 RAM24 on Xilinx24).
//  This24 saves24 about24 1/3 of the Slice24 count and reduces24 P&R and synthesis24 times.
//
//  * Added24 optional24 baudrate24 output (baud_o24).
//  This24 is identical24 to BAUDOUT24* signal24 on 16550 chip24.
//  It outputs24 16xbit_clock_rate - the divided24 clock24.
//  It's disabled by default. Define24 UART_HAS_BAUDRATE_OUTPUT24 to use.
//
// Revision24 1.3  2001/12/19 08:40:03  mohor24
// Warnings24 fixed24 (unused24 signals24 removed).
//
// Revision24 1.2  2001/12/12 22:17:30  gorban24
// some24 synthesis24 bugs24 fixed24
//
// Revision24 1.1  2001/12/04 21:14:16  gorban24
// committed24 the debug24 interface file
//

// synopsys24 translate_off24
`include "timescale.v"
// synopsys24 translate_on24

`include "uart_defines24.v"

module uart_debug_if24 (/*AUTOARG24*/
// Outputs24
wb_dat32_o24, 
// Inputs24
wb_adr_i24, ier24, iir24, fcr24, mcr24, lcr24, msr24, 
lsr24, rf_count24, tf_count24, tstate24, rstate
) ;

input [`UART_ADDR_WIDTH24-1:0] 		wb_adr_i24;
output [31:0] 							wb_dat32_o24;
input [3:0] 							ier24;
input [3:0] 							iir24;
input [1:0] 							fcr24;  /// bits 7 and 6 of fcr24. Other24 bits are ignored
input [4:0] 							mcr24;
input [7:0] 							lcr24;
input [7:0] 							msr24;
input [7:0] 							lsr24;
input [`UART_FIFO_COUNTER_W24-1:0] rf_count24;
input [`UART_FIFO_COUNTER_W24-1:0] tf_count24;
input [2:0] 							tstate24;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH24-1:0] 		wb_adr_i24;
reg [31:0] 								wb_dat32_o24;

always @(/*AUTOSENSE24*/fcr24 or ier24 or iir24 or lcr24 or lsr24 or mcr24 or msr24
			or rf_count24 or rstate or tf_count24 or tstate24 or wb_adr_i24)
	case (wb_adr_i24)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o24 = {msr24,lcr24,iir24,ier24,lsr24};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o24 = {8'b0, fcr24,mcr24, rf_count24, rstate, tf_count24, tstate24};
		default: wb_dat32_o24 = 0;
	endcase // case(wb_adr_i24)

endmodule // uart_debug_if24

