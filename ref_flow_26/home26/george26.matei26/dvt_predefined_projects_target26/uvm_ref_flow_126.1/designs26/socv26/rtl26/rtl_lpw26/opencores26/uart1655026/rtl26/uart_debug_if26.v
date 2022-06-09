//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if26.v                                             ////
////                                                              ////
////                                                              ////
////  This26 file is part of the "UART26 16550 compatible26" project26    ////
////  http26://www26.opencores26.org26/cores26/uart1655026/                   ////
////                                                              ////
////  Documentation26 related26 to this project26:                      ////
////  - http26://www26.opencores26.org26/cores26/uart1655026/                 ////
////                                                              ////
////  Projects26 compatibility26:                                     ////
////  - WISHBONE26                                                  ////
////  RS23226 Protocol26                                              ////
////  16550D uart26 (mostly26 supported)                              ////
////                                                              ////
////  Overview26 (main26 Features26):                                   ////
////  UART26 core26 debug26 interface.                                  ////
////                                                              ////
////  Author26(s):                                                  ////
////      - gorban26@opencores26.org26                                  ////
////      - Jacob26 Gorban26                                          ////
////                                                              ////
////  Created26:        2001/12/02                                  ////
////                  (See log26 for the revision26 history26)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2000, 2001 Authors26                             ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS26 Revision26 History26
//
// $Log: not supported by cvs2svn26 $
// Revision26 1.4  2002/07/22 23:02:23  gorban26
// Bug26 Fixes26:
//  * Possible26 loss of sync and bad26 reception26 of stop bit on slow26 baud26 rates26 fixed26.
//   Problem26 reported26 by Kenny26.Tung26.
//  * Bad (or lack26 of ) loopback26 handling26 fixed26. Reported26 by Cherry26 Withers26.
//
// Improvements26:
//  * Made26 FIFO's as general26 inferrable26 memory where possible26.
//  So26 on FPGA26 they should be inferred26 as RAM26 (Distributed26 RAM26 on Xilinx26).
//  This26 saves26 about26 1/3 of the Slice26 count and reduces26 P&R and synthesis26 times.
//
//  * Added26 optional26 baudrate26 output (baud_o26).
//  This26 is identical26 to BAUDOUT26* signal26 on 16550 chip26.
//  It outputs26 16xbit_clock_rate - the divided26 clock26.
//  It's disabled by default. Define26 UART_HAS_BAUDRATE_OUTPUT26 to use.
//
// Revision26 1.3  2001/12/19 08:40:03  mohor26
// Warnings26 fixed26 (unused26 signals26 removed).
//
// Revision26 1.2  2001/12/12 22:17:30  gorban26
// some26 synthesis26 bugs26 fixed26
//
// Revision26 1.1  2001/12/04 21:14:16  gorban26
// committed26 the debug26 interface file
//

// synopsys26 translate_off26
`include "timescale.v"
// synopsys26 translate_on26

`include "uart_defines26.v"

module uart_debug_if26 (/*AUTOARG26*/
// Outputs26
wb_dat32_o26, 
// Inputs26
wb_adr_i26, ier26, iir26, fcr26, mcr26, lcr26, msr26, 
lsr26, rf_count26, tf_count26, tstate26, rstate
) ;

input [`UART_ADDR_WIDTH26-1:0] 		wb_adr_i26;
output [31:0] 							wb_dat32_o26;
input [3:0] 							ier26;
input [3:0] 							iir26;
input [1:0] 							fcr26;  /// bits 7 and 6 of fcr26. Other26 bits are ignored
input [4:0] 							mcr26;
input [7:0] 							lcr26;
input [7:0] 							msr26;
input [7:0] 							lsr26;
input [`UART_FIFO_COUNTER_W26-1:0] rf_count26;
input [`UART_FIFO_COUNTER_W26-1:0] tf_count26;
input [2:0] 							tstate26;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH26-1:0] 		wb_adr_i26;
reg [31:0] 								wb_dat32_o26;

always @(/*AUTOSENSE26*/fcr26 or ier26 or iir26 or lcr26 or lsr26 or mcr26 or msr26
			or rf_count26 or rstate or tf_count26 or tstate26 or wb_adr_i26)
	case (wb_adr_i26)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o26 = {msr26,lcr26,iir26,ier26,lsr26};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o26 = {8'b0, fcr26,mcr26, rf_count26, rstate, tf_count26, tstate26};
		default: wb_dat32_o26 = 0;
	endcase // case(wb_adr_i26)

endmodule // uart_debug_if26

