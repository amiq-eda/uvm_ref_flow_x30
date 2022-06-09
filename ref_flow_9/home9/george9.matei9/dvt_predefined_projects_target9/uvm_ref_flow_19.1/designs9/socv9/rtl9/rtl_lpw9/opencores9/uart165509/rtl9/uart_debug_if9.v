//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if9.v                                             ////
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
////  UART9 core9 debug9 interface.                                  ////
////                                                              ////
////  Author9(s):                                                  ////
////      - gorban9@opencores9.org9                                  ////
////      - Jacob9 Gorban9                                          ////
////                                                              ////
////  Created9:        2001/12/02                                  ////
////                  (See log9 for the revision9 history9)          ////
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
// Revision9 1.4  2002/07/22 23:02:23  gorban9
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
// Revision9 1.3  2001/12/19 08:40:03  mohor9
// Warnings9 fixed9 (unused9 signals9 removed).
//
// Revision9 1.2  2001/12/12 22:17:30  gorban9
// some9 synthesis9 bugs9 fixed9
//
// Revision9 1.1  2001/12/04 21:14:16  gorban9
// committed9 the debug9 interface file
//

// synopsys9 translate_off9
`include "timescale.v"
// synopsys9 translate_on9

`include "uart_defines9.v"

module uart_debug_if9 (/*AUTOARG9*/
// Outputs9
wb_dat32_o9, 
// Inputs9
wb_adr_i9, ier9, iir9, fcr9, mcr9, lcr9, msr9, 
lsr9, rf_count9, tf_count9, tstate9, rstate
) ;

input [`UART_ADDR_WIDTH9-1:0] 		wb_adr_i9;
output [31:0] 							wb_dat32_o9;
input [3:0] 							ier9;
input [3:0] 							iir9;
input [1:0] 							fcr9;  /// bits 7 and 6 of fcr9. Other9 bits are ignored
input [4:0] 							mcr9;
input [7:0] 							lcr9;
input [7:0] 							msr9;
input [7:0] 							lsr9;
input [`UART_FIFO_COUNTER_W9-1:0] rf_count9;
input [`UART_FIFO_COUNTER_W9-1:0] tf_count9;
input [2:0] 							tstate9;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH9-1:0] 		wb_adr_i9;
reg [31:0] 								wb_dat32_o9;

always @(/*AUTOSENSE9*/fcr9 or ier9 or iir9 or lcr9 or lsr9 or mcr9 or msr9
			or rf_count9 or rstate or tf_count9 or tstate9 or wb_adr_i9)
	case (wb_adr_i9)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o9 = {msr9,lcr9,iir9,ier9,lsr9};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o9 = {8'b0, fcr9,mcr9, rf_count9, rstate, tf_count9, tstate9};
		default: wb_dat32_o9 = 0;
	endcase // case(wb_adr_i9)

endmodule // uart_debug_if9

