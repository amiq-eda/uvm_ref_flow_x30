//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if20.v                                             ////
////                                                              ////
////                                                              ////
////  This20 file is part of the "UART20 16550 compatible20" project20    ////
////  http20://www20.opencores20.org20/cores20/uart1655020/                   ////
////                                                              ////
////  Documentation20 related20 to this project20:                      ////
////  - http20://www20.opencores20.org20/cores20/uart1655020/                 ////
////                                                              ////
////  Projects20 compatibility20:                                     ////
////  - WISHBONE20                                                  ////
////  RS23220 Protocol20                                              ////
////  16550D uart20 (mostly20 supported)                              ////
////                                                              ////
////  Overview20 (main20 Features20):                                   ////
////  UART20 core20 debug20 interface.                                  ////
////                                                              ////
////  Author20(s):                                                  ////
////      - gorban20@opencores20.org20                                  ////
////      - Jacob20 Gorban20                                          ////
////                                                              ////
////  Created20:        2001/12/02                                  ////
////                  (See log20 for the revision20 history20)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2000, 2001 Authors20                             ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS20 Revision20 History20
//
// $Log: not supported by cvs2svn20 $
// Revision20 1.4  2002/07/22 23:02:23  gorban20
// Bug20 Fixes20:
//  * Possible20 loss of sync and bad20 reception20 of stop bit on slow20 baud20 rates20 fixed20.
//   Problem20 reported20 by Kenny20.Tung20.
//  * Bad (or lack20 of ) loopback20 handling20 fixed20. Reported20 by Cherry20 Withers20.
//
// Improvements20:
//  * Made20 FIFO's as general20 inferrable20 memory where possible20.
//  So20 on FPGA20 they should be inferred20 as RAM20 (Distributed20 RAM20 on Xilinx20).
//  This20 saves20 about20 1/3 of the Slice20 count and reduces20 P&R and synthesis20 times.
//
//  * Added20 optional20 baudrate20 output (baud_o20).
//  This20 is identical20 to BAUDOUT20* signal20 on 16550 chip20.
//  It outputs20 16xbit_clock_rate - the divided20 clock20.
//  It's disabled by default. Define20 UART_HAS_BAUDRATE_OUTPUT20 to use.
//
// Revision20 1.3  2001/12/19 08:40:03  mohor20
// Warnings20 fixed20 (unused20 signals20 removed).
//
// Revision20 1.2  2001/12/12 22:17:30  gorban20
// some20 synthesis20 bugs20 fixed20
//
// Revision20 1.1  2001/12/04 21:14:16  gorban20
// committed20 the debug20 interface file
//

// synopsys20 translate_off20
`include "timescale.v"
// synopsys20 translate_on20

`include "uart_defines20.v"

module uart_debug_if20 (/*AUTOARG20*/
// Outputs20
wb_dat32_o20, 
// Inputs20
wb_adr_i20, ier20, iir20, fcr20, mcr20, lcr20, msr20, 
lsr20, rf_count20, tf_count20, tstate20, rstate
) ;

input [`UART_ADDR_WIDTH20-1:0] 		wb_adr_i20;
output [31:0] 							wb_dat32_o20;
input [3:0] 							ier20;
input [3:0] 							iir20;
input [1:0] 							fcr20;  /// bits 7 and 6 of fcr20. Other20 bits are ignored
input [4:0] 							mcr20;
input [7:0] 							lcr20;
input [7:0] 							msr20;
input [7:0] 							lsr20;
input [`UART_FIFO_COUNTER_W20-1:0] rf_count20;
input [`UART_FIFO_COUNTER_W20-1:0] tf_count20;
input [2:0] 							tstate20;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH20-1:0] 		wb_adr_i20;
reg [31:0] 								wb_dat32_o20;

always @(/*AUTOSENSE20*/fcr20 or ier20 or iir20 or lcr20 or lsr20 or mcr20 or msr20
			or rf_count20 or rstate or tf_count20 or tstate20 or wb_adr_i20)
	case (wb_adr_i20)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o20 = {msr20,lcr20,iir20,ier20,lsr20};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o20 = {8'b0, fcr20,mcr20, rf_count20, rstate, tf_count20, tstate20};
		default: wb_dat32_o20 = 0;
	endcase // case(wb_adr_i20)

endmodule // uart_debug_if20

