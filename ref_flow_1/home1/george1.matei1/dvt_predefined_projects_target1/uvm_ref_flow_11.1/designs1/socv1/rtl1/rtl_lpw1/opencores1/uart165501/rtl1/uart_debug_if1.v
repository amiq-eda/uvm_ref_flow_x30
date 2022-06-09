//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if1.v                                             ////
////                                                              ////
////                                                              ////
////  This1 file is part of the "UART1 16550 compatible1" project1    ////
////  http1://www1.opencores1.org1/cores1/uart165501/                   ////
////                                                              ////
////  Documentation1 related1 to this project1:                      ////
////  - http1://www1.opencores1.org1/cores1/uart165501/                 ////
////                                                              ////
////  Projects1 compatibility1:                                     ////
////  - WISHBONE1                                                  ////
////  RS2321 Protocol1                                              ////
////  16550D uart1 (mostly1 supported)                              ////
////                                                              ////
////  Overview1 (main1 Features1):                                   ////
////  UART1 core1 debug1 interface.                                  ////
////                                                              ////
////  Author1(s):                                                  ////
////      - gorban1@opencores1.org1                                  ////
////      - Jacob1 Gorban1                                          ////
////                                                              ////
////  Created1:        2001/12/02                                  ////
////                  (See log1 for the revision1 history1)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright1 (C) 2000, 2001 Authors1                             ////
////                                                              ////
//// This1 source1 file may be used and distributed1 without         ////
//// restriction1 provided that this copyright1 statement1 is not    ////
//// removed from the file and that any derivative1 work1 contains1  ////
//// the original copyright1 notice1 and the associated disclaimer1. ////
////                                                              ////
//// This1 source1 file is free software1; you can redistribute1 it   ////
//// and/or modify it under the terms1 of the GNU1 Lesser1 General1   ////
//// Public1 License1 as published1 by the Free1 Software1 Foundation1; ////
//// either1 version1 2.1 of the License1, or (at your1 option) any   ////
//// later1 version1.                                               ////
////                                                              ////
//// This1 source1 is distributed1 in the hope1 that it will be       ////
//// useful1, but WITHOUT1 ANY1 WARRANTY1; without even1 the implied1   ////
//// warranty1 of MERCHANTABILITY1 or FITNESS1 FOR1 A PARTICULAR1      ////
//// PURPOSE1.  See the GNU1 Lesser1 General1 Public1 License1 for more ////
//// details1.                                                     ////
////                                                              ////
//// You should have received1 a copy of the GNU1 Lesser1 General1    ////
//// Public1 License1 along1 with this source1; if not, download1 it   ////
//// from http1://www1.opencores1.org1/lgpl1.shtml1                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS1 Revision1 History1
//
// $Log: not supported by cvs2svn1 $
// Revision1 1.4  2002/07/22 23:02:23  gorban1
// Bug1 Fixes1:
//  * Possible1 loss of sync and bad1 reception1 of stop bit on slow1 baud1 rates1 fixed1.
//   Problem1 reported1 by Kenny1.Tung1.
//  * Bad (or lack1 of ) loopback1 handling1 fixed1. Reported1 by Cherry1 Withers1.
//
// Improvements1:
//  * Made1 FIFO's as general1 inferrable1 memory where possible1.
//  So1 on FPGA1 they should be inferred1 as RAM1 (Distributed1 RAM1 on Xilinx1).
//  This1 saves1 about1 1/3 of the Slice1 count and reduces1 P&R and synthesis1 times.
//
//  * Added1 optional1 baudrate1 output (baud_o1).
//  This1 is identical1 to BAUDOUT1* signal1 on 16550 chip1.
//  It outputs1 16xbit_clock_rate - the divided1 clock1.
//  It's disabled by default. Define1 UART_HAS_BAUDRATE_OUTPUT1 to use.
//
// Revision1 1.3  2001/12/19 08:40:03  mohor1
// Warnings1 fixed1 (unused1 signals1 removed).
//
// Revision1 1.2  2001/12/12 22:17:30  gorban1
// some1 synthesis1 bugs1 fixed1
//
// Revision1 1.1  2001/12/04 21:14:16  gorban1
// committed1 the debug1 interface file
//

// synopsys1 translate_off1
`include "timescale.v"
// synopsys1 translate_on1

`include "uart_defines1.v"

module uart_debug_if1 (/*AUTOARG1*/
// Outputs1
wb_dat32_o1, 
// Inputs1
wb_adr_i1, ier1, iir1, fcr1, mcr1, lcr1, msr1, 
lsr1, rf_count1, tf_count1, tstate1, rstate
) ;

input [`UART_ADDR_WIDTH1-1:0] 		wb_adr_i1;
output [31:0] 							wb_dat32_o1;
input [3:0] 							ier1;
input [3:0] 							iir1;
input [1:0] 							fcr1;  /// bits 7 and 6 of fcr1. Other1 bits are ignored
input [4:0] 							mcr1;
input [7:0] 							lcr1;
input [7:0] 							msr1;
input [7:0] 							lsr1;
input [`UART_FIFO_COUNTER_W1-1:0] rf_count1;
input [`UART_FIFO_COUNTER_W1-1:0] tf_count1;
input [2:0] 							tstate1;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH1-1:0] 		wb_adr_i1;
reg [31:0] 								wb_dat32_o1;

always @(/*AUTOSENSE1*/fcr1 or ier1 or iir1 or lcr1 or lsr1 or mcr1 or msr1
			or rf_count1 or rstate or tf_count1 or tstate1 or wb_adr_i1)
	case (wb_adr_i1)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o1 = {msr1,lcr1,iir1,ier1,lsr1};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o1 = {8'b0, fcr1,mcr1, rf_count1, rstate, tf_count1, tstate1};
		default: wb_dat32_o1 = 0;
	endcase // case(wb_adr_i1)

endmodule // uart_debug_if1

