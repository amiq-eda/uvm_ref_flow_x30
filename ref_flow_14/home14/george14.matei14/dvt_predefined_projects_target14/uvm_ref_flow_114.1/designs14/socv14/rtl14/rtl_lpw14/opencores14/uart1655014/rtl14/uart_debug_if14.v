//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if14.v                                             ////
////                                                              ////
////                                                              ////
////  This14 file is part of the "UART14 16550 compatible14" project14    ////
////  http14://www14.opencores14.org14/cores14/uart1655014/                   ////
////                                                              ////
////  Documentation14 related14 to this project14:                      ////
////  - http14://www14.opencores14.org14/cores14/uart1655014/                 ////
////                                                              ////
////  Projects14 compatibility14:                                     ////
////  - WISHBONE14                                                  ////
////  RS23214 Protocol14                                              ////
////  16550D uart14 (mostly14 supported)                              ////
////                                                              ////
////  Overview14 (main14 Features14):                                   ////
////  UART14 core14 debug14 interface.                                  ////
////                                                              ////
////  Author14(s):                                                  ////
////      - gorban14@opencores14.org14                                  ////
////      - Jacob14 Gorban14                                          ////
////                                                              ////
////  Created14:        2001/12/02                                  ////
////                  (See log14 for the revision14 history14)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2000, 2001 Authors14                             ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS14 Revision14 History14
//
// $Log: not supported by cvs2svn14 $
// Revision14 1.4  2002/07/22 23:02:23  gorban14
// Bug14 Fixes14:
//  * Possible14 loss of sync and bad14 reception14 of stop bit on slow14 baud14 rates14 fixed14.
//   Problem14 reported14 by Kenny14.Tung14.
//  * Bad (or lack14 of ) loopback14 handling14 fixed14. Reported14 by Cherry14 Withers14.
//
// Improvements14:
//  * Made14 FIFO's as general14 inferrable14 memory where possible14.
//  So14 on FPGA14 they should be inferred14 as RAM14 (Distributed14 RAM14 on Xilinx14).
//  This14 saves14 about14 1/3 of the Slice14 count and reduces14 P&R and synthesis14 times.
//
//  * Added14 optional14 baudrate14 output (baud_o14).
//  This14 is identical14 to BAUDOUT14* signal14 on 16550 chip14.
//  It outputs14 16xbit_clock_rate - the divided14 clock14.
//  It's disabled by default. Define14 UART_HAS_BAUDRATE_OUTPUT14 to use.
//
// Revision14 1.3  2001/12/19 08:40:03  mohor14
// Warnings14 fixed14 (unused14 signals14 removed).
//
// Revision14 1.2  2001/12/12 22:17:30  gorban14
// some14 synthesis14 bugs14 fixed14
//
// Revision14 1.1  2001/12/04 21:14:16  gorban14
// committed14 the debug14 interface file
//

// synopsys14 translate_off14
`include "timescale.v"
// synopsys14 translate_on14

`include "uart_defines14.v"

module uart_debug_if14 (/*AUTOARG14*/
// Outputs14
wb_dat32_o14, 
// Inputs14
wb_adr_i14, ier14, iir14, fcr14, mcr14, lcr14, msr14, 
lsr14, rf_count14, tf_count14, tstate14, rstate
) ;

input [`UART_ADDR_WIDTH14-1:0] 		wb_adr_i14;
output [31:0] 							wb_dat32_o14;
input [3:0] 							ier14;
input [3:0] 							iir14;
input [1:0] 							fcr14;  /// bits 7 and 6 of fcr14. Other14 bits are ignored
input [4:0] 							mcr14;
input [7:0] 							lcr14;
input [7:0] 							msr14;
input [7:0] 							lsr14;
input [`UART_FIFO_COUNTER_W14-1:0] rf_count14;
input [`UART_FIFO_COUNTER_W14-1:0] tf_count14;
input [2:0] 							tstate14;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH14-1:0] 		wb_adr_i14;
reg [31:0] 								wb_dat32_o14;

always @(/*AUTOSENSE14*/fcr14 or ier14 or iir14 or lcr14 or lsr14 or mcr14 or msr14
			or rf_count14 or rstate or tf_count14 or tstate14 or wb_adr_i14)
	case (wb_adr_i14)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o14 = {msr14,lcr14,iir14,ier14,lsr14};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o14 = {8'b0, fcr14,mcr14, rf_count14, rstate, tf_count14, tstate14};
		default: wb_dat32_o14 = 0;
	endcase // case(wb_adr_i14)

endmodule // uart_debug_if14

