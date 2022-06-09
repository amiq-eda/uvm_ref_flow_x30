//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if4.v                                             ////
////                                                              ////
////                                                              ////
////  This4 file is part of the "UART4 16550 compatible4" project4    ////
////  http4://www4.opencores4.org4/cores4/uart165504/                   ////
////                                                              ////
////  Documentation4 related4 to this project4:                      ////
////  - http4://www4.opencores4.org4/cores4/uart165504/                 ////
////                                                              ////
////  Projects4 compatibility4:                                     ////
////  - WISHBONE4                                                  ////
////  RS2324 Protocol4                                              ////
////  16550D uart4 (mostly4 supported)                              ////
////                                                              ////
////  Overview4 (main4 Features4):                                   ////
////  UART4 core4 debug4 interface.                                  ////
////                                                              ////
////  Author4(s):                                                  ////
////      - gorban4@opencores4.org4                                  ////
////      - Jacob4 Gorban4                                          ////
////                                                              ////
////  Created4:        2001/12/02                                  ////
////                  (See log4 for the revision4 history4)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2000, 2001 Authors4                             ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS4 Revision4 History4
//
// $Log: not supported by cvs2svn4 $
// Revision4 1.4  2002/07/22 23:02:23  gorban4
// Bug4 Fixes4:
//  * Possible4 loss of sync and bad4 reception4 of stop bit on slow4 baud4 rates4 fixed4.
//   Problem4 reported4 by Kenny4.Tung4.
//  * Bad (or lack4 of ) loopback4 handling4 fixed4. Reported4 by Cherry4 Withers4.
//
// Improvements4:
//  * Made4 FIFO's as general4 inferrable4 memory where possible4.
//  So4 on FPGA4 they should be inferred4 as RAM4 (Distributed4 RAM4 on Xilinx4).
//  This4 saves4 about4 1/3 of the Slice4 count and reduces4 P&R and synthesis4 times.
//
//  * Added4 optional4 baudrate4 output (baud_o4).
//  This4 is identical4 to BAUDOUT4* signal4 on 16550 chip4.
//  It outputs4 16xbit_clock_rate - the divided4 clock4.
//  It's disabled by default. Define4 UART_HAS_BAUDRATE_OUTPUT4 to use.
//
// Revision4 1.3  2001/12/19 08:40:03  mohor4
// Warnings4 fixed4 (unused4 signals4 removed).
//
// Revision4 1.2  2001/12/12 22:17:30  gorban4
// some4 synthesis4 bugs4 fixed4
//
// Revision4 1.1  2001/12/04 21:14:16  gorban4
// committed4 the debug4 interface file
//

// synopsys4 translate_off4
`include "timescale.v"
// synopsys4 translate_on4

`include "uart_defines4.v"

module uart_debug_if4 (/*AUTOARG4*/
// Outputs4
wb_dat32_o4, 
// Inputs4
wb_adr_i4, ier4, iir4, fcr4, mcr4, lcr4, msr4, 
lsr4, rf_count4, tf_count4, tstate4, rstate
) ;

input [`UART_ADDR_WIDTH4-1:0] 		wb_adr_i4;
output [31:0] 							wb_dat32_o4;
input [3:0] 							ier4;
input [3:0] 							iir4;
input [1:0] 							fcr4;  /// bits 7 and 6 of fcr4. Other4 bits are ignored
input [4:0] 							mcr4;
input [7:0] 							lcr4;
input [7:0] 							msr4;
input [7:0] 							lsr4;
input [`UART_FIFO_COUNTER_W4-1:0] rf_count4;
input [`UART_FIFO_COUNTER_W4-1:0] tf_count4;
input [2:0] 							tstate4;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH4-1:0] 		wb_adr_i4;
reg [31:0] 								wb_dat32_o4;

always @(/*AUTOSENSE4*/fcr4 or ier4 or iir4 or lcr4 or lsr4 or mcr4 or msr4
			or rf_count4 or rstate or tf_count4 or tstate4 or wb_adr_i4)
	case (wb_adr_i4)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o4 = {msr4,lcr4,iir4,ier4,lsr4};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o4 = {8'b0, fcr4,mcr4, rf_count4, rstate, tf_count4, tstate4};
		default: wb_dat32_o4 = 0;
	endcase // case(wb_adr_i4)

endmodule // uart_debug_if4

