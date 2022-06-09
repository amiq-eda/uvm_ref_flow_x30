//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if23.v                                             ////
////                                                              ////
////                                                              ////
////  This23 file is part of the "UART23 16550 compatible23" project23    ////
////  http23://www23.opencores23.org23/cores23/uart1655023/                   ////
////                                                              ////
////  Documentation23 related23 to this project23:                      ////
////  - http23://www23.opencores23.org23/cores23/uart1655023/                 ////
////                                                              ////
////  Projects23 compatibility23:                                     ////
////  - WISHBONE23                                                  ////
////  RS23223 Protocol23                                              ////
////  16550D uart23 (mostly23 supported)                              ////
////                                                              ////
////  Overview23 (main23 Features23):                                   ////
////  UART23 core23 debug23 interface.                                  ////
////                                                              ////
////  Author23(s):                                                  ////
////      - gorban23@opencores23.org23                                  ////
////      - Jacob23 Gorban23                                          ////
////                                                              ////
////  Created23:        2001/12/02                                  ////
////                  (See log23 for the revision23 history23)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2000, 2001 Authors23                             ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS23 Revision23 History23
//
// $Log: not supported by cvs2svn23 $
// Revision23 1.4  2002/07/22 23:02:23  gorban23
// Bug23 Fixes23:
//  * Possible23 loss of sync and bad23 reception23 of stop bit on slow23 baud23 rates23 fixed23.
//   Problem23 reported23 by Kenny23.Tung23.
//  * Bad (or lack23 of ) loopback23 handling23 fixed23. Reported23 by Cherry23 Withers23.
//
// Improvements23:
//  * Made23 FIFO's as general23 inferrable23 memory where possible23.
//  So23 on FPGA23 they should be inferred23 as RAM23 (Distributed23 RAM23 on Xilinx23).
//  This23 saves23 about23 1/3 of the Slice23 count and reduces23 P&R and synthesis23 times.
//
//  * Added23 optional23 baudrate23 output (baud_o23).
//  This23 is identical23 to BAUDOUT23* signal23 on 16550 chip23.
//  It outputs23 16xbit_clock_rate - the divided23 clock23.
//  It's disabled by default. Define23 UART_HAS_BAUDRATE_OUTPUT23 to use.
//
// Revision23 1.3  2001/12/19 08:40:03  mohor23
// Warnings23 fixed23 (unused23 signals23 removed).
//
// Revision23 1.2  2001/12/12 22:17:30  gorban23
// some23 synthesis23 bugs23 fixed23
//
// Revision23 1.1  2001/12/04 21:14:16  gorban23
// committed23 the debug23 interface file
//

// synopsys23 translate_off23
`include "timescale.v"
// synopsys23 translate_on23

`include "uart_defines23.v"

module uart_debug_if23 (/*AUTOARG23*/
// Outputs23
wb_dat32_o23, 
// Inputs23
wb_adr_i23, ier23, iir23, fcr23, mcr23, lcr23, msr23, 
lsr23, rf_count23, tf_count23, tstate23, rstate
) ;

input [`UART_ADDR_WIDTH23-1:0] 		wb_adr_i23;
output [31:0] 							wb_dat32_o23;
input [3:0] 							ier23;
input [3:0] 							iir23;
input [1:0] 							fcr23;  /// bits 7 and 6 of fcr23. Other23 bits are ignored
input [4:0] 							mcr23;
input [7:0] 							lcr23;
input [7:0] 							msr23;
input [7:0] 							lsr23;
input [`UART_FIFO_COUNTER_W23-1:0] rf_count23;
input [`UART_FIFO_COUNTER_W23-1:0] tf_count23;
input [2:0] 							tstate23;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH23-1:0] 		wb_adr_i23;
reg [31:0] 								wb_dat32_o23;

always @(/*AUTOSENSE23*/fcr23 or ier23 or iir23 or lcr23 or lsr23 or mcr23 or msr23
			or rf_count23 or rstate or tf_count23 or tstate23 or wb_adr_i23)
	case (wb_adr_i23)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o23 = {msr23,lcr23,iir23,ier23,lsr23};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o23 = {8'b0, fcr23,mcr23, rf_count23, rstate, tf_count23, tstate23};
		default: wb_dat32_o23 = 0;
	endcase // case(wb_adr_i23)

endmodule // uart_debug_if23

