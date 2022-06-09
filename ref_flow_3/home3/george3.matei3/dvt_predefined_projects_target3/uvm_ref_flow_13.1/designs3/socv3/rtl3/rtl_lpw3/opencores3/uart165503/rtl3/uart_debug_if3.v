//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if3.v                                             ////
////                                                              ////
////                                                              ////
////  This3 file is part of the "UART3 16550 compatible3" project3    ////
////  http3://www3.opencores3.org3/cores3/uart165503/                   ////
////                                                              ////
////  Documentation3 related3 to this project3:                      ////
////  - http3://www3.opencores3.org3/cores3/uart165503/                 ////
////                                                              ////
////  Projects3 compatibility3:                                     ////
////  - WISHBONE3                                                  ////
////  RS2323 Protocol3                                              ////
////  16550D uart3 (mostly3 supported)                              ////
////                                                              ////
////  Overview3 (main3 Features3):                                   ////
////  UART3 core3 debug3 interface.                                  ////
////                                                              ////
////  Author3(s):                                                  ////
////      - gorban3@opencores3.org3                                  ////
////      - Jacob3 Gorban3                                          ////
////                                                              ////
////  Created3:        2001/12/02                                  ////
////                  (See log3 for the revision3 history3)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2000, 2001 Authors3                             ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS3 Revision3 History3
//
// $Log: not supported by cvs2svn3 $
// Revision3 1.4  2002/07/22 23:02:23  gorban3
// Bug3 Fixes3:
//  * Possible3 loss of sync and bad3 reception3 of stop bit on slow3 baud3 rates3 fixed3.
//   Problem3 reported3 by Kenny3.Tung3.
//  * Bad (or lack3 of ) loopback3 handling3 fixed3. Reported3 by Cherry3 Withers3.
//
// Improvements3:
//  * Made3 FIFO's as general3 inferrable3 memory where possible3.
//  So3 on FPGA3 they should be inferred3 as RAM3 (Distributed3 RAM3 on Xilinx3).
//  This3 saves3 about3 1/3 of the Slice3 count and reduces3 P&R and synthesis3 times.
//
//  * Added3 optional3 baudrate3 output (baud_o3).
//  This3 is identical3 to BAUDOUT3* signal3 on 16550 chip3.
//  It outputs3 16xbit_clock_rate - the divided3 clock3.
//  It's disabled by default. Define3 UART_HAS_BAUDRATE_OUTPUT3 to use.
//
// Revision3 1.3  2001/12/19 08:40:03  mohor3
// Warnings3 fixed3 (unused3 signals3 removed).
//
// Revision3 1.2  2001/12/12 22:17:30  gorban3
// some3 synthesis3 bugs3 fixed3
//
// Revision3 1.1  2001/12/04 21:14:16  gorban3
// committed3 the debug3 interface file
//

// synopsys3 translate_off3
`include "timescale.v"
// synopsys3 translate_on3

`include "uart_defines3.v"

module uart_debug_if3 (/*AUTOARG3*/
// Outputs3
wb_dat32_o3, 
// Inputs3
wb_adr_i3, ier3, iir3, fcr3, mcr3, lcr3, msr3, 
lsr3, rf_count3, tf_count3, tstate3, rstate
) ;

input [`UART_ADDR_WIDTH3-1:0] 		wb_adr_i3;
output [31:0] 							wb_dat32_o3;
input [3:0] 							ier3;
input [3:0] 							iir3;
input [1:0] 							fcr3;  /// bits 7 and 6 of fcr3. Other3 bits are ignored
input [4:0] 							mcr3;
input [7:0] 							lcr3;
input [7:0] 							msr3;
input [7:0] 							lsr3;
input [`UART_FIFO_COUNTER_W3-1:0] rf_count3;
input [`UART_FIFO_COUNTER_W3-1:0] tf_count3;
input [2:0] 							tstate3;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH3-1:0] 		wb_adr_i3;
reg [31:0] 								wb_dat32_o3;

always @(/*AUTOSENSE3*/fcr3 or ier3 or iir3 or lcr3 or lsr3 or mcr3 or msr3
			or rf_count3 or rstate or tf_count3 or tstate3 or wb_adr_i3)
	case (wb_adr_i3)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o3 = {msr3,lcr3,iir3,ier3,lsr3};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o3 = {8'b0, fcr3,mcr3, rf_count3, rstate, tf_count3, tstate3};
		default: wb_dat32_o3 = 0;
	endcase // case(wb_adr_i3)

endmodule // uart_debug_if3

