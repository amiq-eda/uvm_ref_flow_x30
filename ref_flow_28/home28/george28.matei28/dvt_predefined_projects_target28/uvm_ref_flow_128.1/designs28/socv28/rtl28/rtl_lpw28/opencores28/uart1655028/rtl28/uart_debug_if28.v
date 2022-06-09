//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if28.v                                             ////
////                                                              ////
////                                                              ////
////  This28 file is part of the "UART28 16550 compatible28" project28    ////
////  http28://www28.opencores28.org28/cores28/uart1655028/                   ////
////                                                              ////
////  Documentation28 related28 to this project28:                      ////
////  - http28://www28.opencores28.org28/cores28/uart1655028/                 ////
////                                                              ////
////  Projects28 compatibility28:                                     ////
////  - WISHBONE28                                                  ////
////  RS23228 Protocol28                                              ////
////  16550D uart28 (mostly28 supported)                              ////
////                                                              ////
////  Overview28 (main28 Features28):                                   ////
////  UART28 core28 debug28 interface.                                  ////
////                                                              ////
////  Author28(s):                                                  ////
////      - gorban28@opencores28.org28                                  ////
////      - Jacob28 Gorban28                                          ////
////                                                              ////
////  Created28:        2001/12/02                                  ////
////                  (See log28 for the revision28 history28)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2000, 2001 Authors28                             ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS28 Revision28 History28
//
// $Log: not supported by cvs2svn28 $
// Revision28 1.4  2002/07/22 23:02:23  gorban28
// Bug28 Fixes28:
//  * Possible28 loss of sync and bad28 reception28 of stop bit on slow28 baud28 rates28 fixed28.
//   Problem28 reported28 by Kenny28.Tung28.
//  * Bad (or lack28 of ) loopback28 handling28 fixed28. Reported28 by Cherry28 Withers28.
//
// Improvements28:
//  * Made28 FIFO's as general28 inferrable28 memory where possible28.
//  So28 on FPGA28 they should be inferred28 as RAM28 (Distributed28 RAM28 on Xilinx28).
//  This28 saves28 about28 1/3 of the Slice28 count and reduces28 P&R and synthesis28 times.
//
//  * Added28 optional28 baudrate28 output (baud_o28).
//  This28 is identical28 to BAUDOUT28* signal28 on 16550 chip28.
//  It outputs28 16xbit_clock_rate - the divided28 clock28.
//  It's disabled by default. Define28 UART_HAS_BAUDRATE_OUTPUT28 to use.
//
// Revision28 1.3  2001/12/19 08:40:03  mohor28
// Warnings28 fixed28 (unused28 signals28 removed).
//
// Revision28 1.2  2001/12/12 22:17:30  gorban28
// some28 synthesis28 bugs28 fixed28
//
// Revision28 1.1  2001/12/04 21:14:16  gorban28
// committed28 the debug28 interface file
//

// synopsys28 translate_off28
`include "timescale.v"
// synopsys28 translate_on28

`include "uart_defines28.v"

module uart_debug_if28 (/*AUTOARG28*/
// Outputs28
wb_dat32_o28, 
// Inputs28
wb_adr_i28, ier28, iir28, fcr28, mcr28, lcr28, msr28, 
lsr28, rf_count28, tf_count28, tstate28, rstate
) ;

input [`UART_ADDR_WIDTH28-1:0] 		wb_adr_i28;
output [31:0] 							wb_dat32_o28;
input [3:0] 							ier28;
input [3:0] 							iir28;
input [1:0] 							fcr28;  /// bits 7 and 6 of fcr28. Other28 bits are ignored
input [4:0] 							mcr28;
input [7:0] 							lcr28;
input [7:0] 							msr28;
input [7:0] 							lsr28;
input [`UART_FIFO_COUNTER_W28-1:0] rf_count28;
input [`UART_FIFO_COUNTER_W28-1:0] tf_count28;
input [2:0] 							tstate28;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH28-1:0] 		wb_adr_i28;
reg [31:0] 								wb_dat32_o28;

always @(/*AUTOSENSE28*/fcr28 or ier28 or iir28 or lcr28 or lsr28 or mcr28 or msr28
			or rf_count28 or rstate or tf_count28 or tstate28 or wb_adr_i28)
	case (wb_adr_i28)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o28 = {msr28,lcr28,iir28,ier28,lsr28};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o28 = {8'b0, fcr28,mcr28, rf_count28, rstate, tf_count28, tstate28};
		default: wb_dat32_o28 = 0;
	endcase // case(wb_adr_i28)

endmodule // uart_debug_if28

