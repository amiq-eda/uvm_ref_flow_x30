//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if29.v                                             ////
////                                                              ////
////                                                              ////
////  This29 file is part of the "UART29 16550 compatible29" project29    ////
////  http29://www29.opencores29.org29/cores29/uart1655029/                   ////
////                                                              ////
////  Documentation29 related29 to this project29:                      ////
////  - http29://www29.opencores29.org29/cores29/uart1655029/                 ////
////                                                              ////
////  Projects29 compatibility29:                                     ////
////  - WISHBONE29                                                  ////
////  RS23229 Protocol29                                              ////
////  16550D uart29 (mostly29 supported)                              ////
////                                                              ////
////  Overview29 (main29 Features29):                                   ////
////  UART29 core29 debug29 interface.                                  ////
////                                                              ////
////  Author29(s):                                                  ////
////      - gorban29@opencores29.org29                                  ////
////      - Jacob29 Gorban29                                          ////
////                                                              ////
////  Created29:        2001/12/02                                  ////
////                  (See log29 for the revision29 history29)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2000, 2001 Authors29                             ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS29 Revision29 History29
//
// $Log: not supported by cvs2svn29 $
// Revision29 1.4  2002/07/22 23:02:23  gorban29
// Bug29 Fixes29:
//  * Possible29 loss of sync and bad29 reception29 of stop bit on slow29 baud29 rates29 fixed29.
//   Problem29 reported29 by Kenny29.Tung29.
//  * Bad (or lack29 of ) loopback29 handling29 fixed29. Reported29 by Cherry29 Withers29.
//
// Improvements29:
//  * Made29 FIFO's as general29 inferrable29 memory where possible29.
//  So29 on FPGA29 they should be inferred29 as RAM29 (Distributed29 RAM29 on Xilinx29).
//  This29 saves29 about29 1/3 of the Slice29 count and reduces29 P&R and synthesis29 times.
//
//  * Added29 optional29 baudrate29 output (baud_o29).
//  This29 is identical29 to BAUDOUT29* signal29 on 16550 chip29.
//  It outputs29 16xbit_clock_rate - the divided29 clock29.
//  It's disabled by default. Define29 UART_HAS_BAUDRATE_OUTPUT29 to use.
//
// Revision29 1.3  2001/12/19 08:40:03  mohor29
// Warnings29 fixed29 (unused29 signals29 removed).
//
// Revision29 1.2  2001/12/12 22:17:30  gorban29
// some29 synthesis29 bugs29 fixed29
//
// Revision29 1.1  2001/12/04 21:14:16  gorban29
// committed29 the debug29 interface file
//

// synopsys29 translate_off29
`include "timescale.v"
// synopsys29 translate_on29

`include "uart_defines29.v"

module uart_debug_if29 (/*AUTOARG29*/
// Outputs29
wb_dat32_o29, 
// Inputs29
wb_adr_i29, ier29, iir29, fcr29, mcr29, lcr29, msr29, 
lsr29, rf_count29, tf_count29, tstate29, rstate
) ;

input [`UART_ADDR_WIDTH29-1:0] 		wb_adr_i29;
output [31:0] 							wb_dat32_o29;
input [3:0] 							ier29;
input [3:0] 							iir29;
input [1:0] 							fcr29;  /// bits 7 and 6 of fcr29. Other29 bits are ignored
input [4:0] 							mcr29;
input [7:0] 							lcr29;
input [7:0] 							msr29;
input [7:0] 							lsr29;
input [`UART_FIFO_COUNTER_W29-1:0] rf_count29;
input [`UART_FIFO_COUNTER_W29-1:0] tf_count29;
input [2:0] 							tstate29;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH29-1:0] 		wb_adr_i29;
reg [31:0] 								wb_dat32_o29;

always @(/*AUTOSENSE29*/fcr29 or ier29 or iir29 or lcr29 or lsr29 or mcr29 or msr29
			or rf_count29 or rstate or tf_count29 or tstate29 or wb_adr_i29)
	case (wb_adr_i29)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o29 = {msr29,lcr29,iir29,ier29,lsr29};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o29 = {8'b0, fcr29,mcr29, rf_count29, rstate, tf_count29, tstate29};
		default: wb_dat32_o29 = 0;
	endcase // case(wb_adr_i29)

endmodule // uart_debug_if29

