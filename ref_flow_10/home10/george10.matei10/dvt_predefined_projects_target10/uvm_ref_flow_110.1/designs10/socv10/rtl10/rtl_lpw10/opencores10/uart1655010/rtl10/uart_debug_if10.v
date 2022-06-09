//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if10.v                                             ////
////                                                              ////
////                                                              ////
////  This10 file is part of the "UART10 16550 compatible10" project10    ////
////  http10://www10.opencores10.org10/cores10/uart1655010/                   ////
////                                                              ////
////  Documentation10 related10 to this project10:                      ////
////  - http10://www10.opencores10.org10/cores10/uart1655010/                 ////
////                                                              ////
////  Projects10 compatibility10:                                     ////
////  - WISHBONE10                                                  ////
////  RS23210 Protocol10                                              ////
////  16550D uart10 (mostly10 supported)                              ////
////                                                              ////
////  Overview10 (main10 Features10):                                   ////
////  UART10 core10 debug10 interface.                                  ////
////                                                              ////
////  Author10(s):                                                  ////
////      - gorban10@opencores10.org10                                  ////
////      - Jacob10 Gorban10                                          ////
////                                                              ////
////  Created10:        2001/12/02                                  ////
////                  (See log10 for the revision10 history10)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright10 (C) 2000, 2001 Authors10                             ////
////                                                              ////
//// This10 source10 file may be used and distributed10 without         ////
//// restriction10 provided that this copyright10 statement10 is not    ////
//// removed from the file and that any derivative10 work10 contains10  ////
//// the original copyright10 notice10 and the associated disclaimer10. ////
////                                                              ////
//// This10 source10 file is free software10; you can redistribute10 it   ////
//// and/or modify it under the terms10 of the GNU10 Lesser10 General10   ////
//// Public10 License10 as published10 by the Free10 Software10 Foundation10; ////
//// either10 version10 2.1 of the License10, or (at your10 option) any   ////
//// later10 version10.                                               ////
////                                                              ////
//// This10 source10 is distributed10 in the hope10 that it will be       ////
//// useful10, but WITHOUT10 ANY10 WARRANTY10; without even10 the implied10   ////
//// warranty10 of MERCHANTABILITY10 or FITNESS10 FOR10 A PARTICULAR10      ////
//// PURPOSE10.  See the GNU10 Lesser10 General10 Public10 License10 for more ////
//// details10.                                                     ////
////                                                              ////
//// You should have received10 a copy of the GNU10 Lesser10 General10    ////
//// Public10 License10 along10 with this source10; if not, download10 it   ////
//// from http10://www10.opencores10.org10/lgpl10.shtml10                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS10 Revision10 History10
//
// $Log: not supported by cvs2svn10 $
// Revision10 1.4  2002/07/22 23:02:23  gorban10
// Bug10 Fixes10:
//  * Possible10 loss of sync and bad10 reception10 of stop bit on slow10 baud10 rates10 fixed10.
//   Problem10 reported10 by Kenny10.Tung10.
//  * Bad (or lack10 of ) loopback10 handling10 fixed10. Reported10 by Cherry10 Withers10.
//
// Improvements10:
//  * Made10 FIFO's as general10 inferrable10 memory where possible10.
//  So10 on FPGA10 they should be inferred10 as RAM10 (Distributed10 RAM10 on Xilinx10).
//  This10 saves10 about10 1/3 of the Slice10 count and reduces10 P&R and synthesis10 times.
//
//  * Added10 optional10 baudrate10 output (baud_o10).
//  This10 is identical10 to BAUDOUT10* signal10 on 16550 chip10.
//  It outputs10 16xbit_clock_rate - the divided10 clock10.
//  It's disabled by default. Define10 UART_HAS_BAUDRATE_OUTPUT10 to use.
//
// Revision10 1.3  2001/12/19 08:40:03  mohor10
// Warnings10 fixed10 (unused10 signals10 removed).
//
// Revision10 1.2  2001/12/12 22:17:30  gorban10
// some10 synthesis10 bugs10 fixed10
//
// Revision10 1.1  2001/12/04 21:14:16  gorban10
// committed10 the debug10 interface file
//

// synopsys10 translate_off10
`include "timescale.v"
// synopsys10 translate_on10

`include "uart_defines10.v"

module uart_debug_if10 (/*AUTOARG10*/
// Outputs10
wb_dat32_o10, 
// Inputs10
wb_adr_i10, ier10, iir10, fcr10, mcr10, lcr10, msr10, 
lsr10, rf_count10, tf_count10, tstate10, rstate
) ;

input [`UART_ADDR_WIDTH10-1:0] 		wb_adr_i10;
output [31:0] 							wb_dat32_o10;
input [3:0] 							ier10;
input [3:0] 							iir10;
input [1:0] 							fcr10;  /// bits 7 and 6 of fcr10. Other10 bits are ignored
input [4:0] 							mcr10;
input [7:0] 							lcr10;
input [7:0] 							msr10;
input [7:0] 							lsr10;
input [`UART_FIFO_COUNTER_W10-1:0] rf_count10;
input [`UART_FIFO_COUNTER_W10-1:0] tf_count10;
input [2:0] 							tstate10;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH10-1:0] 		wb_adr_i10;
reg [31:0] 								wb_dat32_o10;

always @(/*AUTOSENSE10*/fcr10 or ier10 or iir10 or lcr10 or lsr10 or mcr10 or msr10
			or rf_count10 or rstate or tf_count10 or tstate10 or wb_adr_i10)
	case (wb_adr_i10)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o10 = {msr10,lcr10,iir10,ier10,lsr10};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o10 = {8'b0, fcr10,mcr10, rf_count10, rstate, tf_count10, tstate10};
		default: wb_dat32_o10 = 0;
	endcase // case(wb_adr_i10)

endmodule // uart_debug_if10

