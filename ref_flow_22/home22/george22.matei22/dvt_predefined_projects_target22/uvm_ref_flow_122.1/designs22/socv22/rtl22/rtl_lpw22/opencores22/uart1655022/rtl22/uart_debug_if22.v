//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if22.v                                             ////
////                                                              ////
////                                                              ////
////  This22 file is part of the "UART22 16550 compatible22" project22    ////
////  http22://www22.opencores22.org22/cores22/uart1655022/                   ////
////                                                              ////
////  Documentation22 related22 to this project22:                      ////
////  - http22://www22.opencores22.org22/cores22/uart1655022/                 ////
////                                                              ////
////  Projects22 compatibility22:                                     ////
////  - WISHBONE22                                                  ////
////  RS23222 Protocol22                                              ////
////  16550D uart22 (mostly22 supported)                              ////
////                                                              ////
////  Overview22 (main22 Features22):                                   ////
////  UART22 core22 debug22 interface.                                  ////
////                                                              ////
////  Author22(s):                                                  ////
////      - gorban22@opencores22.org22                                  ////
////      - Jacob22 Gorban22                                          ////
////                                                              ////
////  Created22:        2001/12/02                                  ////
////                  (See log22 for the revision22 history22)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2000, 2001 Authors22                             ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS22 Revision22 History22
//
// $Log: not supported by cvs2svn22 $
// Revision22 1.4  2002/07/22 23:02:23  gorban22
// Bug22 Fixes22:
//  * Possible22 loss of sync and bad22 reception22 of stop bit on slow22 baud22 rates22 fixed22.
//   Problem22 reported22 by Kenny22.Tung22.
//  * Bad (or lack22 of ) loopback22 handling22 fixed22. Reported22 by Cherry22 Withers22.
//
// Improvements22:
//  * Made22 FIFO's as general22 inferrable22 memory where possible22.
//  So22 on FPGA22 they should be inferred22 as RAM22 (Distributed22 RAM22 on Xilinx22).
//  This22 saves22 about22 1/3 of the Slice22 count and reduces22 P&R and synthesis22 times.
//
//  * Added22 optional22 baudrate22 output (baud_o22).
//  This22 is identical22 to BAUDOUT22* signal22 on 16550 chip22.
//  It outputs22 16xbit_clock_rate - the divided22 clock22.
//  It's disabled by default. Define22 UART_HAS_BAUDRATE_OUTPUT22 to use.
//
// Revision22 1.3  2001/12/19 08:40:03  mohor22
// Warnings22 fixed22 (unused22 signals22 removed).
//
// Revision22 1.2  2001/12/12 22:17:30  gorban22
// some22 synthesis22 bugs22 fixed22
//
// Revision22 1.1  2001/12/04 21:14:16  gorban22
// committed22 the debug22 interface file
//

// synopsys22 translate_off22
`include "timescale.v"
// synopsys22 translate_on22

`include "uart_defines22.v"

module uart_debug_if22 (/*AUTOARG22*/
// Outputs22
wb_dat32_o22, 
// Inputs22
wb_adr_i22, ier22, iir22, fcr22, mcr22, lcr22, msr22, 
lsr22, rf_count22, tf_count22, tstate22, rstate
) ;

input [`UART_ADDR_WIDTH22-1:0] 		wb_adr_i22;
output [31:0] 							wb_dat32_o22;
input [3:0] 							ier22;
input [3:0] 							iir22;
input [1:0] 							fcr22;  /// bits 7 and 6 of fcr22. Other22 bits are ignored
input [4:0] 							mcr22;
input [7:0] 							lcr22;
input [7:0] 							msr22;
input [7:0] 							lsr22;
input [`UART_FIFO_COUNTER_W22-1:0] rf_count22;
input [`UART_FIFO_COUNTER_W22-1:0] tf_count22;
input [2:0] 							tstate22;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH22-1:0] 		wb_adr_i22;
reg [31:0] 								wb_dat32_o22;

always @(/*AUTOSENSE22*/fcr22 or ier22 or iir22 or lcr22 or lsr22 or mcr22 or msr22
			or rf_count22 or rstate or tf_count22 or tstate22 or wb_adr_i22)
	case (wb_adr_i22)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o22 = {msr22,lcr22,iir22,ier22,lsr22};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o22 = {8'b0, fcr22,mcr22, rf_count22, rstate, tf_count22, tstate22};
		default: wb_dat32_o22 = 0;
	endcase // case(wb_adr_i22)

endmodule // uart_debug_if22

