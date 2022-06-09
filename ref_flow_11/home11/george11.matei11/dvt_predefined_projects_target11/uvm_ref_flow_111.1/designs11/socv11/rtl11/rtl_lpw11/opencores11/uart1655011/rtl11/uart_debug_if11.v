//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if11.v                                             ////
////                                                              ////
////                                                              ////
////  This11 file is part of the "UART11 16550 compatible11" project11    ////
////  http11://www11.opencores11.org11/cores11/uart1655011/                   ////
////                                                              ////
////  Documentation11 related11 to this project11:                      ////
////  - http11://www11.opencores11.org11/cores11/uart1655011/                 ////
////                                                              ////
////  Projects11 compatibility11:                                     ////
////  - WISHBONE11                                                  ////
////  RS23211 Protocol11                                              ////
////  16550D uart11 (mostly11 supported)                              ////
////                                                              ////
////  Overview11 (main11 Features11):                                   ////
////  UART11 core11 debug11 interface.                                  ////
////                                                              ////
////  Author11(s):                                                  ////
////      - gorban11@opencores11.org11                                  ////
////      - Jacob11 Gorban11                                          ////
////                                                              ////
////  Created11:        2001/12/02                                  ////
////                  (See log11 for the revision11 history11)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2000, 2001 Authors11                             ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS11 Revision11 History11
//
// $Log: not supported by cvs2svn11 $
// Revision11 1.4  2002/07/22 23:02:23  gorban11
// Bug11 Fixes11:
//  * Possible11 loss of sync and bad11 reception11 of stop bit on slow11 baud11 rates11 fixed11.
//   Problem11 reported11 by Kenny11.Tung11.
//  * Bad (or lack11 of ) loopback11 handling11 fixed11. Reported11 by Cherry11 Withers11.
//
// Improvements11:
//  * Made11 FIFO's as general11 inferrable11 memory where possible11.
//  So11 on FPGA11 they should be inferred11 as RAM11 (Distributed11 RAM11 on Xilinx11).
//  This11 saves11 about11 1/3 of the Slice11 count and reduces11 P&R and synthesis11 times.
//
//  * Added11 optional11 baudrate11 output (baud_o11).
//  This11 is identical11 to BAUDOUT11* signal11 on 16550 chip11.
//  It outputs11 16xbit_clock_rate - the divided11 clock11.
//  It's disabled by default. Define11 UART_HAS_BAUDRATE_OUTPUT11 to use.
//
// Revision11 1.3  2001/12/19 08:40:03  mohor11
// Warnings11 fixed11 (unused11 signals11 removed).
//
// Revision11 1.2  2001/12/12 22:17:30  gorban11
// some11 synthesis11 bugs11 fixed11
//
// Revision11 1.1  2001/12/04 21:14:16  gorban11
// committed11 the debug11 interface file
//

// synopsys11 translate_off11
`include "timescale.v"
// synopsys11 translate_on11

`include "uart_defines11.v"

module uart_debug_if11 (/*AUTOARG11*/
// Outputs11
wb_dat32_o11, 
// Inputs11
wb_adr_i11, ier11, iir11, fcr11, mcr11, lcr11, msr11, 
lsr11, rf_count11, tf_count11, tstate11, rstate
) ;

input [`UART_ADDR_WIDTH11-1:0] 		wb_adr_i11;
output [31:0] 							wb_dat32_o11;
input [3:0] 							ier11;
input [3:0] 							iir11;
input [1:0] 							fcr11;  /// bits 7 and 6 of fcr11. Other11 bits are ignored
input [4:0] 							mcr11;
input [7:0] 							lcr11;
input [7:0] 							msr11;
input [7:0] 							lsr11;
input [`UART_FIFO_COUNTER_W11-1:0] rf_count11;
input [`UART_FIFO_COUNTER_W11-1:0] tf_count11;
input [2:0] 							tstate11;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH11-1:0] 		wb_adr_i11;
reg [31:0] 								wb_dat32_o11;

always @(/*AUTOSENSE11*/fcr11 or ier11 or iir11 or lcr11 or lsr11 or mcr11 or msr11
			or rf_count11 or rstate or tf_count11 or tstate11 or wb_adr_i11)
	case (wb_adr_i11)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o11 = {msr11,lcr11,iir11,ier11,lsr11};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o11 = {8'b0, fcr11,mcr11, rf_count11, rstate, tf_count11, tstate11};
		default: wb_dat32_o11 = 0;
	endcase // case(wb_adr_i11)

endmodule // uart_debug_if11

