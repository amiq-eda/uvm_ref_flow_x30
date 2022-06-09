//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if18.v                                             ////
////                                                              ////
////                                                              ////
////  This18 file is part of the "UART18 16550 compatible18" project18    ////
////  http18://www18.opencores18.org18/cores18/uart1655018/                   ////
////                                                              ////
////  Documentation18 related18 to this project18:                      ////
////  - http18://www18.opencores18.org18/cores18/uart1655018/                 ////
////                                                              ////
////  Projects18 compatibility18:                                     ////
////  - WISHBONE18                                                  ////
////  RS23218 Protocol18                                              ////
////  16550D uart18 (mostly18 supported)                              ////
////                                                              ////
////  Overview18 (main18 Features18):                                   ////
////  UART18 core18 debug18 interface.                                  ////
////                                                              ////
////  Author18(s):                                                  ////
////      - gorban18@opencores18.org18                                  ////
////      - Jacob18 Gorban18                                          ////
////                                                              ////
////  Created18:        2001/12/02                                  ////
////                  (See log18 for the revision18 history18)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2000, 2001 Authors18                             ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS18 Revision18 History18
//
// $Log: not supported by cvs2svn18 $
// Revision18 1.4  2002/07/22 23:02:23  gorban18
// Bug18 Fixes18:
//  * Possible18 loss of sync and bad18 reception18 of stop bit on slow18 baud18 rates18 fixed18.
//   Problem18 reported18 by Kenny18.Tung18.
//  * Bad (or lack18 of ) loopback18 handling18 fixed18. Reported18 by Cherry18 Withers18.
//
// Improvements18:
//  * Made18 FIFO's as general18 inferrable18 memory where possible18.
//  So18 on FPGA18 they should be inferred18 as RAM18 (Distributed18 RAM18 on Xilinx18).
//  This18 saves18 about18 1/3 of the Slice18 count and reduces18 P&R and synthesis18 times.
//
//  * Added18 optional18 baudrate18 output (baud_o18).
//  This18 is identical18 to BAUDOUT18* signal18 on 16550 chip18.
//  It outputs18 16xbit_clock_rate - the divided18 clock18.
//  It's disabled by default. Define18 UART_HAS_BAUDRATE_OUTPUT18 to use.
//
// Revision18 1.3  2001/12/19 08:40:03  mohor18
// Warnings18 fixed18 (unused18 signals18 removed).
//
// Revision18 1.2  2001/12/12 22:17:30  gorban18
// some18 synthesis18 bugs18 fixed18
//
// Revision18 1.1  2001/12/04 21:14:16  gorban18
// committed18 the debug18 interface file
//

// synopsys18 translate_off18
`include "timescale.v"
// synopsys18 translate_on18

`include "uart_defines18.v"

module uart_debug_if18 (/*AUTOARG18*/
// Outputs18
wb_dat32_o18, 
// Inputs18
wb_adr_i18, ier18, iir18, fcr18, mcr18, lcr18, msr18, 
lsr18, rf_count18, tf_count18, tstate18, rstate
) ;

input [`UART_ADDR_WIDTH18-1:0] 		wb_adr_i18;
output [31:0] 							wb_dat32_o18;
input [3:0] 							ier18;
input [3:0] 							iir18;
input [1:0] 							fcr18;  /// bits 7 and 6 of fcr18. Other18 bits are ignored
input [4:0] 							mcr18;
input [7:0] 							lcr18;
input [7:0] 							msr18;
input [7:0] 							lsr18;
input [`UART_FIFO_COUNTER_W18-1:0] rf_count18;
input [`UART_FIFO_COUNTER_W18-1:0] tf_count18;
input [2:0] 							tstate18;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH18-1:0] 		wb_adr_i18;
reg [31:0] 								wb_dat32_o18;

always @(/*AUTOSENSE18*/fcr18 or ier18 or iir18 or lcr18 or lsr18 or mcr18 or msr18
			or rf_count18 or rstate or tf_count18 or tstate18 or wb_adr_i18)
	case (wb_adr_i18)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o18 = {msr18,lcr18,iir18,ier18,lsr18};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o18 = {8'b0, fcr18,mcr18, rf_count18, rstate, tf_count18, tstate18};
		default: wb_dat32_o18 = 0;
	endcase // case(wb_adr_i18)

endmodule // uart_debug_if18

