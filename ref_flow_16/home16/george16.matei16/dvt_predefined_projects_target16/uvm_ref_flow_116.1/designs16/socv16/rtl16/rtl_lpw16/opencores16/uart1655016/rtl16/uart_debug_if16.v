//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if16.v                                             ////
////                                                              ////
////                                                              ////
////  This16 file is part of the "UART16 16550 compatible16" project16    ////
////  http16://www16.opencores16.org16/cores16/uart1655016/                   ////
////                                                              ////
////  Documentation16 related16 to this project16:                      ////
////  - http16://www16.opencores16.org16/cores16/uart1655016/                 ////
////                                                              ////
////  Projects16 compatibility16:                                     ////
////  - WISHBONE16                                                  ////
////  RS23216 Protocol16                                              ////
////  16550D uart16 (mostly16 supported)                              ////
////                                                              ////
////  Overview16 (main16 Features16):                                   ////
////  UART16 core16 debug16 interface.                                  ////
////                                                              ////
////  Author16(s):                                                  ////
////      - gorban16@opencores16.org16                                  ////
////      - Jacob16 Gorban16                                          ////
////                                                              ////
////  Created16:        2001/12/02                                  ////
////                  (See log16 for the revision16 history16)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2000, 2001 Authors16                             ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS16 Revision16 History16
//
// $Log: not supported by cvs2svn16 $
// Revision16 1.4  2002/07/22 23:02:23  gorban16
// Bug16 Fixes16:
//  * Possible16 loss of sync and bad16 reception16 of stop bit on slow16 baud16 rates16 fixed16.
//   Problem16 reported16 by Kenny16.Tung16.
//  * Bad (or lack16 of ) loopback16 handling16 fixed16. Reported16 by Cherry16 Withers16.
//
// Improvements16:
//  * Made16 FIFO's as general16 inferrable16 memory where possible16.
//  So16 on FPGA16 they should be inferred16 as RAM16 (Distributed16 RAM16 on Xilinx16).
//  This16 saves16 about16 1/3 of the Slice16 count and reduces16 P&R and synthesis16 times.
//
//  * Added16 optional16 baudrate16 output (baud_o16).
//  This16 is identical16 to BAUDOUT16* signal16 on 16550 chip16.
//  It outputs16 16xbit_clock_rate - the divided16 clock16.
//  It's disabled by default. Define16 UART_HAS_BAUDRATE_OUTPUT16 to use.
//
// Revision16 1.3  2001/12/19 08:40:03  mohor16
// Warnings16 fixed16 (unused16 signals16 removed).
//
// Revision16 1.2  2001/12/12 22:17:30  gorban16
// some16 synthesis16 bugs16 fixed16
//
// Revision16 1.1  2001/12/04 21:14:16  gorban16
// committed16 the debug16 interface file
//

// synopsys16 translate_off16
`include "timescale.v"
// synopsys16 translate_on16

`include "uart_defines16.v"

module uart_debug_if16 (/*AUTOARG16*/
// Outputs16
wb_dat32_o16, 
// Inputs16
wb_adr_i16, ier16, iir16, fcr16, mcr16, lcr16, msr16, 
lsr16, rf_count16, tf_count16, tstate16, rstate
) ;

input [`UART_ADDR_WIDTH16-1:0] 		wb_adr_i16;
output [31:0] 							wb_dat32_o16;
input [3:0] 							ier16;
input [3:0] 							iir16;
input [1:0] 							fcr16;  /// bits 7 and 6 of fcr16. Other16 bits are ignored
input [4:0] 							mcr16;
input [7:0] 							lcr16;
input [7:0] 							msr16;
input [7:0] 							lsr16;
input [`UART_FIFO_COUNTER_W16-1:0] rf_count16;
input [`UART_FIFO_COUNTER_W16-1:0] tf_count16;
input [2:0] 							tstate16;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH16-1:0] 		wb_adr_i16;
reg [31:0] 								wb_dat32_o16;

always @(/*AUTOSENSE16*/fcr16 or ier16 or iir16 or lcr16 or lsr16 or mcr16 or msr16
			or rf_count16 or rstate or tf_count16 or tstate16 or wb_adr_i16)
	case (wb_adr_i16)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o16 = {msr16,lcr16,iir16,ier16,lsr16};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o16 = {8'b0, fcr16,mcr16, rf_count16, rstate, tf_count16, tstate16};
		default: wb_dat32_o16 = 0;
	endcase // case(wb_adr_i16)

endmodule // uart_debug_if16

