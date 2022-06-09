//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if5.v                                             ////
////                                                              ////
////                                                              ////
////  This5 file is part of the "UART5 16550 compatible5" project5    ////
////  http5://www5.opencores5.org5/cores5/uart165505/                   ////
////                                                              ////
////  Documentation5 related5 to this project5:                      ////
////  - http5://www5.opencores5.org5/cores5/uart165505/                 ////
////                                                              ////
////  Projects5 compatibility5:                                     ////
////  - WISHBONE5                                                  ////
////  RS2325 Protocol5                                              ////
////  16550D uart5 (mostly5 supported)                              ////
////                                                              ////
////  Overview5 (main5 Features5):                                   ////
////  UART5 core5 debug5 interface.                                  ////
////                                                              ////
////  Author5(s):                                                  ////
////      - gorban5@opencores5.org5                                  ////
////      - Jacob5 Gorban5                                          ////
////                                                              ////
////  Created5:        2001/12/02                                  ////
////                  (See log5 for the revision5 history5)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2000, 2001 Authors5                             ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS5 Revision5 History5
//
// $Log: not supported by cvs2svn5 $
// Revision5 1.4  2002/07/22 23:02:23  gorban5
// Bug5 Fixes5:
//  * Possible5 loss of sync and bad5 reception5 of stop bit on slow5 baud5 rates5 fixed5.
//   Problem5 reported5 by Kenny5.Tung5.
//  * Bad (or lack5 of ) loopback5 handling5 fixed5. Reported5 by Cherry5 Withers5.
//
// Improvements5:
//  * Made5 FIFO's as general5 inferrable5 memory where possible5.
//  So5 on FPGA5 they should be inferred5 as RAM5 (Distributed5 RAM5 on Xilinx5).
//  This5 saves5 about5 1/3 of the Slice5 count and reduces5 P&R and synthesis5 times.
//
//  * Added5 optional5 baudrate5 output (baud_o5).
//  This5 is identical5 to BAUDOUT5* signal5 on 16550 chip5.
//  It outputs5 16xbit_clock_rate - the divided5 clock5.
//  It's disabled by default. Define5 UART_HAS_BAUDRATE_OUTPUT5 to use.
//
// Revision5 1.3  2001/12/19 08:40:03  mohor5
// Warnings5 fixed5 (unused5 signals5 removed).
//
// Revision5 1.2  2001/12/12 22:17:30  gorban5
// some5 synthesis5 bugs5 fixed5
//
// Revision5 1.1  2001/12/04 21:14:16  gorban5
// committed5 the debug5 interface file
//

// synopsys5 translate_off5
`include "timescale.v"
// synopsys5 translate_on5

`include "uart_defines5.v"

module uart_debug_if5 (/*AUTOARG5*/
// Outputs5
wb_dat32_o5, 
// Inputs5
wb_adr_i5, ier5, iir5, fcr5, mcr5, lcr5, msr5, 
lsr5, rf_count5, tf_count5, tstate5, rstate
) ;

input [`UART_ADDR_WIDTH5-1:0] 		wb_adr_i5;
output [31:0] 							wb_dat32_o5;
input [3:0] 							ier5;
input [3:0] 							iir5;
input [1:0] 							fcr5;  /// bits 7 and 6 of fcr5. Other5 bits are ignored
input [4:0] 							mcr5;
input [7:0] 							lcr5;
input [7:0] 							msr5;
input [7:0] 							lsr5;
input [`UART_FIFO_COUNTER_W5-1:0] rf_count5;
input [`UART_FIFO_COUNTER_W5-1:0] tf_count5;
input [2:0] 							tstate5;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH5-1:0] 		wb_adr_i5;
reg [31:0] 								wb_dat32_o5;

always @(/*AUTOSENSE5*/fcr5 or ier5 or iir5 or lcr5 or lsr5 or mcr5 or msr5
			or rf_count5 or rstate or tf_count5 or tstate5 or wb_adr_i5)
	case (wb_adr_i5)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o5 = {msr5,lcr5,iir5,ier5,lsr5};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o5 = {8'b0, fcr5,mcr5, rf_count5, rstate, tf_count5, tstate5};
		default: wb_dat32_o5 = 0;
	endcase // case(wb_adr_i5)

endmodule // uart_debug_if5

