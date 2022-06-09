//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if17.v                                             ////
////                                                              ////
////                                                              ////
////  This17 file is part of the "UART17 16550 compatible17" project17    ////
////  http17://www17.opencores17.org17/cores17/uart1655017/                   ////
////                                                              ////
////  Documentation17 related17 to this project17:                      ////
////  - http17://www17.opencores17.org17/cores17/uart1655017/                 ////
////                                                              ////
////  Projects17 compatibility17:                                     ////
////  - WISHBONE17                                                  ////
////  RS23217 Protocol17                                              ////
////  16550D uart17 (mostly17 supported)                              ////
////                                                              ////
////  Overview17 (main17 Features17):                                   ////
////  UART17 core17 debug17 interface.                                  ////
////                                                              ////
////  Author17(s):                                                  ////
////      - gorban17@opencores17.org17                                  ////
////      - Jacob17 Gorban17                                          ////
////                                                              ////
////  Created17:        2001/12/02                                  ////
////                  (See log17 for the revision17 history17)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2000, 2001 Authors17                             ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS17 Revision17 History17
//
// $Log: not supported by cvs2svn17 $
// Revision17 1.4  2002/07/22 23:02:23  gorban17
// Bug17 Fixes17:
//  * Possible17 loss of sync and bad17 reception17 of stop bit on slow17 baud17 rates17 fixed17.
//   Problem17 reported17 by Kenny17.Tung17.
//  * Bad (or lack17 of ) loopback17 handling17 fixed17. Reported17 by Cherry17 Withers17.
//
// Improvements17:
//  * Made17 FIFO's as general17 inferrable17 memory where possible17.
//  So17 on FPGA17 they should be inferred17 as RAM17 (Distributed17 RAM17 on Xilinx17).
//  This17 saves17 about17 1/3 of the Slice17 count and reduces17 P&R and synthesis17 times.
//
//  * Added17 optional17 baudrate17 output (baud_o17).
//  This17 is identical17 to BAUDOUT17* signal17 on 16550 chip17.
//  It outputs17 16xbit_clock_rate - the divided17 clock17.
//  It's disabled by default. Define17 UART_HAS_BAUDRATE_OUTPUT17 to use.
//
// Revision17 1.3  2001/12/19 08:40:03  mohor17
// Warnings17 fixed17 (unused17 signals17 removed).
//
// Revision17 1.2  2001/12/12 22:17:30  gorban17
// some17 synthesis17 bugs17 fixed17
//
// Revision17 1.1  2001/12/04 21:14:16  gorban17
// committed17 the debug17 interface file
//

// synopsys17 translate_off17
`include "timescale.v"
// synopsys17 translate_on17

`include "uart_defines17.v"

module uart_debug_if17 (/*AUTOARG17*/
// Outputs17
wb_dat32_o17, 
// Inputs17
wb_adr_i17, ier17, iir17, fcr17, mcr17, lcr17, msr17, 
lsr17, rf_count17, tf_count17, tstate17, rstate
) ;

input [`UART_ADDR_WIDTH17-1:0] 		wb_adr_i17;
output [31:0] 							wb_dat32_o17;
input [3:0] 							ier17;
input [3:0] 							iir17;
input [1:0] 							fcr17;  /// bits 7 and 6 of fcr17. Other17 bits are ignored
input [4:0] 							mcr17;
input [7:0] 							lcr17;
input [7:0] 							msr17;
input [7:0] 							lsr17;
input [`UART_FIFO_COUNTER_W17-1:0] rf_count17;
input [`UART_FIFO_COUNTER_W17-1:0] tf_count17;
input [2:0] 							tstate17;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH17-1:0] 		wb_adr_i17;
reg [31:0] 								wb_dat32_o17;

always @(/*AUTOSENSE17*/fcr17 or ier17 or iir17 or lcr17 or lsr17 or mcr17 or msr17
			or rf_count17 or rstate or tf_count17 or tstate17 or wb_adr_i17)
	case (wb_adr_i17)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o17 = {msr17,lcr17,iir17,ier17,lsr17};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o17 = {8'b0, fcr17,mcr17, rf_count17, rstate, tf_count17, tstate17};
		default: wb_dat32_o17 = 0;
	endcase // case(wb_adr_i17)

endmodule // uart_debug_if17

