//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if21.v                                             ////
////                                                              ////
////                                                              ////
////  This21 file is part of the "UART21 16550 compatible21" project21    ////
////  http21://www21.opencores21.org21/cores21/uart1655021/                   ////
////                                                              ////
////  Documentation21 related21 to this project21:                      ////
////  - http21://www21.opencores21.org21/cores21/uart1655021/                 ////
////                                                              ////
////  Projects21 compatibility21:                                     ////
////  - WISHBONE21                                                  ////
////  RS23221 Protocol21                                              ////
////  16550D uart21 (mostly21 supported)                              ////
////                                                              ////
////  Overview21 (main21 Features21):                                   ////
////  UART21 core21 debug21 interface.                                  ////
////                                                              ////
////  Author21(s):                                                  ////
////      - gorban21@opencores21.org21                                  ////
////      - Jacob21 Gorban21                                          ////
////                                                              ////
////  Created21:        2001/12/02                                  ////
////                  (See log21 for the revision21 history21)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2000, 2001 Authors21                             ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS21 Revision21 History21
//
// $Log: not supported by cvs2svn21 $
// Revision21 1.4  2002/07/22 23:02:23  gorban21
// Bug21 Fixes21:
//  * Possible21 loss of sync and bad21 reception21 of stop bit on slow21 baud21 rates21 fixed21.
//   Problem21 reported21 by Kenny21.Tung21.
//  * Bad (or lack21 of ) loopback21 handling21 fixed21. Reported21 by Cherry21 Withers21.
//
// Improvements21:
//  * Made21 FIFO's as general21 inferrable21 memory where possible21.
//  So21 on FPGA21 they should be inferred21 as RAM21 (Distributed21 RAM21 on Xilinx21).
//  This21 saves21 about21 1/3 of the Slice21 count and reduces21 P&R and synthesis21 times.
//
//  * Added21 optional21 baudrate21 output (baud_o21).
//  This21 is identical21 to BAUDOUT21* signal21 on 16550 chip21.
//  It outputs21 16xbit_clock_rate - the divided21 clock21.
//  It's disabled by default. Define21 UART_HAS_BAUDRATE_OUTPUT21 to use.
//
// Revision21 1.3  2001/12/19 08:40:03  mohor21
// Warnings21 fixed21 (unused21 signals21 removed).
//
// Revision21 1.2  2001/12/12 22:17:30  gorban21
// some21 synthesis21 bugs21 fixed21
//
// Revision21 1.1  2001/12/04 21:14:16  gorban21
// committed21 the debug21 interface file
//

// synopsys21 translate_off21
`include "timescale.v"
// synopsys21 translate_on21

`include "uart_defines21.v"

module uart_debug_if21 (/*AUTOARG21*/
// Outputs21
wb_dat32_o21, 
// Inputs21
wb_adr_i21, ier21, iir21, fcr21, mcr21, lcr21, msr21, 
lsr21, rf_count21, tf_count21, tstate21, rstate
) ;

input [`UART_ADDR_WIDTH21-1:0] 		wb_adr_i21;
output [31:0] 							wb_dat32_o21;
input [3:0] 							ier21;
input [3:0] 							iir21;
input [1:0] 							fcr21;  /// bits 7 and 6 of fcr21. Other21 bits are ignored
input [4:0] 							mcr21;
input [7:0] 							lcr21;
input [7:0] 							msr21;
input [7:0] 							lsr21;
input [`UART_FIFO_COUNTER_W21-1:0] rf_count21;
input [`UART_FIFO_COUNTER_W21-1:0] tf_count21;
input [2:0] 							tstate21;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH21-1:0] 		wb_adr_i21;
reg [31:0] 								wb_dat32_o21;

always @(/*AUTOSENSE21*/fcr21 or ier21 or iir21 or lcr21 or lsr21 or mcr21 or msr21
			or rf_count21 or rstate or tf_count21 or tstate21 or wb_adr_i21)
	case (wb_adr_i21)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o21 = {msr21,lcr21,iir21,ier21,lsr21};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o21 = {8'b0, fcr21,mcr21, rf_count21, rstate, tf_count21, tstate21};
		default: wb_dat32_o21 = 0;
	endcase // case(wb_adr_i21)

endmodule // uart_debug_if21

