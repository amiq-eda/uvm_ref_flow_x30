//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if30.v                                             ////
////                                                              ////
////                                                              ////
////  This30 file is part of the "UART30 16550 compatible30" project30    ////
////  http30://www30.opencores30.org30/cores30/uart1655030/                   ////
////                                                              ////
////  Documentation30 related30 to this project30:                      ////
////  - http30://www30.opencores30.org30/cores30/uart1655030/                 ////
////                                                              ////
////  Projects30 compatibility30:                                     ////
////  - WISHBONE30                                                  ////
////  RS23230 Protocol30                                              ////
////  16550D uart30 (mostly30 supported)                              ////
////                                                              ////
////  Overview30 (main30 Features30):                                   ////
////  UART30 core30 debug30 interface.                                  ////
////                                                              ////
////  Author30(s):                                                  ////
////      - gorban30@opencores30.org30                                  ////
////      - Jacob30 Gorban30                                          ////
////                                                              ////
////  Created30:        2001/12/02                                  ////
////                  (See log30 for the revision30 history30)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2000, 2001 Authors30                             ////
////                                                              ////
//// This30 source30 file may be used and distributed30 without         ////
//// restriction30 provided that this copyright30 statement30 is not    ////
//// removed from the file and that any derivative30 work30 contains30  ////
//// the original copyright30 notice30 and the associated disclaimer30. ////
////                                                              ////
//// This30 source30 file is free software30; you can redistribute30 it   ////
//// and/or modify it under the terms30 of the GNU30 Lesser30 General30   ////
//// Public30 License30 as published30 by the Free30 Software30 Foundation30; ////
//// either30 version30 2.1 of the License30, or (at your30 option) any   ////
//// later30 version30.                                               ////
////                                                              ////
//// This30 source30 is distributed30 in the hope30 that it will be       ////
//// useful30, but WITHOUT30 ANY30 WARRANTY30; without even30 the implied30   ////
//// warranty30 of MERCHANTABILITY30 or FITNESS30 FOR30 A PARTICULAR30      ////
//// PURPOSE30.  See the GNU30 Lesser30 General30 Public30 License30 for more ////
//// details30.                                                     ////
////                                                              ////
//// You should have received30 a copy of the GNU30 Lesser30 General30    ////
//// Public30 License30 along30 with this source30; if not, download30 it   ////
//// from http30://www30.opencores30.org30/lgpl30.shtml30                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS30 Revision30 History30
//
// $Log: not supported by cvs2svn30 $
// Revision30 1.4  2002/07/22 23:02:23  gorban30
// Bug30 Fixes30:
//  * Possible30 loss of sync and bad30 reception30 of stop bit on slow30 baud30 rates30 fixed30.
//   Problem30 reported30 by Kenny30.Tung30.
//  * Bad (or lack30 of ) loopback30 handling30 fixed30. Reported30 by Cherry30 Withers30.
//
// Improvements30:
//  * Made30 FIFO's as general30 inferrable30 memory where possible30.
//  So30 on FPGA30 they should be inferred30 as RAM30 (Distributed30 RAM30 on Xilinx30).
//  This30 saves30 about30 1/3 of the Slice30 count and reduces30 P&R and synthesis30 times.
//
//  * Added30 optional30 baudrate30 output (baud_o30).
//  This30 is identical30 to BAUDOUT30* signal30 on 16550 chip30.
//  It outputs30 16xbit_clock_rate - the divided30 clock30.
//  It's disabled by default. Define30 UART_HAS_BAUDRATE_OUTPUT30 to use.
//
// Revision30 1.3  2001/12/19 08:40:03  mohor30
// Warnings30 fixed30 (unused30 signals30 removed).
//
// Revision30 1.2  2001/12/12 22:17:30  gorban30
// some30 synthesis30 bugs30 fixed30
//
// Revision30 1.1  2001/12/04 21:14:16  gorban30
// committed30 the debug30 interface file
//

// synopsys30 translate_off30
`include "timescale.v"
// synopsys30 translate_on30

`include "uart_defines30.v"

module uart_debug_if30 (/*AUTOARG30*/
// Outputs30
wb_dat32_o30, 
// Inputs30
wb_adr_i30, ier30, iir30, fcr30, mcr30, lcr30, msr30, 
lsr30, rf_count30, tf_count30, tstate30, rstate
) ;

input [`UART_ADDR_WIDTH30-1:0] 		wb_adr_i30;
output [31:0] 							wb_dat32_o30;
input [3:0] 							ier30;
input [3:0] 							iir30;
input [1:0] 							fcr30;  /// bits 7 and 6 of fcr30. Other30 bits are ignored
input [4:0] 							mcr30;
input [7:0] 							lcr30;
input [7:0] 							msr30;
input [7:0] 							lsr30;
input [`UART_FIFO_COUNTER_W30-1:0] rf_count30;
input [`UART_FIFO_COUNTER_W30-1:0] tf_count30;
input [2:0] 							tstate30;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH30-1:0] 		wb_adr_i30;
reg [31:0] 								wb_dat32_o30;

always @(/*AUTOSENSE30*/fcr30 or ier30 or iir30 or lcr30 or lsr30 or mcr30 or msr30
			or rf_count30 or rstate or tf_count30 or tstate30 or wb_adr_i30)
	case (wb_adr_i30)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o30 = {msr30,lcr30,iir30,ier30,lsr30};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o30 = {8'b0, fcr30,mcr30, rf_count30, rstate, tf_count30, tstate30};
		default: wb_dat32_o30 = 0;
	endcase // case(wb_adr_i30)

endmodule // uart_debug_if30

