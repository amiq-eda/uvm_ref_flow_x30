//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if15.v                                             ////
////                                                              ////
////                                                              ////
////  This15 file is part of the "UART15 16550 compatible15" project15    ////
////  http15://www15.opencores15.org15/cores15/uart1655015/                   ////
////                                                              ////
////  Documentation15 related15 to this project15:                      ////
////  - http15://www15.opencores15.org15/cores15/uart1655015/                 ////
////                                                              ////
////  Projects15 compatibility15:                                     ////
////  - WISHBONE15                                                  ////
////  RS23215 Protocol15                                              ////
////  16550D uart15 (mostly15 supported)                              ////
////                                                              ////
////  Overview15 (main15 Features15):                                   ////
////  UART15 core15 debug15 interface.                                  ////
////                                                              ////
////  Author15(s):                                                  ////
////      - gorban15@opencores15.org15                                  ////
////      - Jacob15 Gorban15                                          ////
////                                                              ////
////  Created15:        2001/12/02                                  ////
////                  (See log15 for the revision15 history15)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2000, 2001 Authors15                             ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS15 Revision15 History15
//
// $Log: not supported by cvs2svn15 $
// Revision15 1.4  2002/07/22 23:02:23  gorban15
// Bug15 Fixes15:
//  * Possible15 loss of sync and bad15 reception15 of stop bit on slow15 baud15 rates15 fixed15.
//   Problem15 reported15 by Kenny15.Tung15.
//  * Bad (or lack15 of ) loopback15 handling15 fixed15. Reported15 by Cherry15 Withers15.
//
// Improvements15:
//  * Made15 FIFO's as general15 inferrable15 memory where possible15.
//  So15 on FPGA15 they should be inferred15 as RAM15 (Distributed15 RAM15 on Xilinx15).
//  This15 saves15 about15 1/3 of the Slice15 count and reduces15 P&R and synthesis15 times.
//
//  * Added15 optional15 baudrate15 output (baud_o15).
//  This15 is identical15 to BAUDOUT15* signal15 on 16550 chip15.
//  It outputs15 16xbit_clock_rate - the divided15 clock15.
//  It's disabled by default. Define15 UART_HAS_BAUDRATE_OUTPUT15 to use.
//
// Revision15 1.3  2001/12/19 08:40:03  mohor15
// Warnings15 fixed15 (unused15 signals15 removed).
//
// Revision15 1.2  2001/12/12 22:17:30  gorban15
// some15 synthesis15 bugs15 fixed15
//
// Revision15 1.1  2001/12/04 21:14:16  gorban15
// committed15 the debug15 interface file
//

// synopsys15 translate_off15
`include "timescale.v"
// synopsys15 translate_on15

`include "uart_defines15.v"

module uart_debug_if15 (/*AUTOARG15*/
// Outputs15
wb_dat32_o15, 
// Inputs15
wb_adr_i15, ier15, iir15, fcr15, mcr15, lcr15, msr15, 
lsr15, rf_count15, tf_count15, tstate15, rstate
) ;

input [`UART_ADDR_WIDTH15-1:0] 		wb_adr_i15;
output [31:0] 							wb_dat32_o15;
input [3:0] 							ier15;
input [3:0] 							iir15;
input [1:0] 							fcr15;  /// bits 7 and 6 of fcr15. Other15 bits are ignored
input [4:0] 							mcr15;
input [7:0] 							lcr15;
input [7:0] 							msr15;
input [7:0] 							lsr15;
input [`UART_FIFO_COUNTER_W15-1:0] rf_count15;
input [`UART_FIFO_COUNTER_W15-1:0] tf_count15;
input [2:0] 							tstate15;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH15-1:0] 		wb_adr_i15;
reg [31:0] 								wb_dat32_o15;

always @(/*AUTOSENSE15*/fcr15 or ier15 or iir15 or lcr15 or lsr15 or mcr15 or msr15
			or rf_count15 or rstate or tf_count15 or tstate15 or wb_adr_i15)
	case (wb_adr_i15)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o15 = {msr15,lcr15,iir15,ier15,lsr15};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o15 = {8'b0, fcr15,mcr15, rf_count15, rstate, tf_count15, tstate15};
		default: wb_dat32_o15 = 0;
	endcase // case(wb_adr_i15)

endmodule // uart_debug_if15

