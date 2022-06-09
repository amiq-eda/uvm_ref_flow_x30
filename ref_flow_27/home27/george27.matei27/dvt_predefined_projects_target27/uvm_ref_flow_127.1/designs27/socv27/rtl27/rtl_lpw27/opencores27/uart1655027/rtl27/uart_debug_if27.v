//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if27.v                                             ////
////                                                              ////
////                                                              ////
////  This27 file is part of the "UART27 16550 compatible27" project27    ////
////  http27://www27.opencores27.org27/cores27/uart1655027/                   ////
////                                                              ////
////  Documentation27 related27 to this project27:                      ////
////  - http27://www27.opencores27.org27/cores27/uart1655027/                 ////
////                                                              ////
////  Projects27 compatibility27:                                     ////
////  - WISHBONE27                                                  ////
////  RS23227 Protocol27                                              ////
////  16550D uart27 (mostly27 supported)                              ////
////                                                              ////
////  Overview27 (main27 Features27):                                   ////
////  UART27 core27 debug27 interface.                                  ////
////                                                              ////
////  Author27(s):                                                  ////
////      - gorban27@opencores27.org27                                  ////
////      - Jacob27 Gorban27                                          ////
////                                                              ////
////  Created27:        2001/12/02                                  ////
////                  (See log27 for the revision27 history27)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2000, 2001 Authors27                             ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS27 Revision27 History27
//
// $Log: not supported by cvs2svn27 $
// Revision27 1.4  2002/07/22 23:02:23  gorban27
// Bug27 Fixes27:
//  * Possible27 loss of sync and bad27 reception27 of stop bit on slow27 baud27 rates27 fixed27.
//   Problem27 reported27 by Kenny27.Tung27.
//  * Bad (or lack27 of ) loopback27 handling27 fixed27. Reported27 by Cherry27 Withers27.
//
// Improvements27:
//  * Made27 FIFO's as general27 inferrable27 memory where possible27.
//  So27 on FPGA27 they should be inferred27 as RAM27 (Distributed27 RAM27 on Xilinx27).
//  This27 saves27 about27 1/3 of the Slice27 count and reduces27 P&R and synthesis27 times.
//
//  * Added27 optional27 baudrate27 output (baud_o27).
//  This27 is identical27 to BAUDOUT27* signal27 on 16550 chip27.
//  It outputs27 16xbit_clock_rate - the divided27 clock27.
//  It's disabled by default. Define27 UART_HAS_BAUDRATE_OUTPUT27 to use.
//
// Revision27 1.3  2001/12/19 08:40:03  mohor27
// Warnings27 fixed27 (unused27 signals27 removed).
//
// Revision27 1.2  2001/12/12 22:17:30  gorban27
// some27 synthesis27 bugs27 fixed27
//
// Revision27 1.1  2001/12/04 21:14:16  gorban27
// committed27 the debug27 interface file
//

// synopsys27 translate_off27
`include "timescale.v"
// synopsys27 translate_on27

`include "uart_defines27.v"

module uart_debug_if27 (/*AUTOARG27*/
// Outputs27
wb_dat32_o27, 
// Inputs27
wb_adr_i27, ier27, iir27, fcr27, mcr27, lcr27, msr27, 
lsr27, rf_count27, tf_count27, tstate27, rstate
) ;

input [`UART_ADDR_WIDTH27-1:0] 		wb_adr_i27;
output [31:0] 							wb_dat32_o27;
input [3:0] 							ier27;
input [3:0] 							iir27;
input [1:0] 							fcr27;  /// bits 7 and 6 of fcr27. Other27 bits are ignored
input [4:0] 							mcr27;
input [7:0] 							lcr27;
input [7:0] 							msr27;
input [7:0] 							lsr27;
input [`UART_FIFO_COUNTER_W27-1:0] rf_count27;
input [`UART_FIFO_COUNTER_W27-1:0] tf_count27;
input [2:0] 							tstate27;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH27-1:0] 		wb_adr_i27;
reg [31:0] 								wb_dat32_o27;

always @(/*AUTOSENSE27*/fcr27 or ier27 or iir27 or lcr27 or lsr27 or mcr27 or msr27
			or rf_count27 or rstate or tf_count27 or tstate27 or wb_adr_i27)
	case (wb_adr_i27)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o27 = {msr27,lcr27,iir27,ier27,lsr27};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o27 = {8'b0, fcr27,mcr27, rf_count27, rstate, tf_count27, tstate27};
		default: wb_dat32_o27 = 0;
	endcase // case(wb_adr_i27)

endmodule // uart_debug_if27

