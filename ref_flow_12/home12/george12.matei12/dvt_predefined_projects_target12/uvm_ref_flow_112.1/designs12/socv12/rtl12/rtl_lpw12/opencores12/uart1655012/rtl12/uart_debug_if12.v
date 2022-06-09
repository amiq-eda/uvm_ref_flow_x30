//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if12.v                                             ////
////                                                              ////
////                                                              ////
////  This12 file is part of the "UART12 16550 compatible12" project12    ////
////  http12://www12.opencores12.org12/cores12/uart1655012/                   ////
////                                                              ////
////  Documentation12 related12 to this project12:                      ////
////  - http12://www12.opencores12.org12/cores12/uart1655012/                 ////
////                                                              ////
////  Projects12 compatibility12:                                     ////
////  - WISHBONE12                                                  ////
////  RS23212 Protocol12                                              ////
////  16550D uart12 (mostly12 supported)                              ////
////                                                              ////
////  Overview12 (main12 Features12):                                   ////
////  UART12 core12 debug12 interface.                                  ////
////                                                              ////
////  Author12(s):                                                  ////
////      - gorban12@opencores12.org12                                  ////
////      - Jacob12 Gorban12                                          ////
////                                                              ////
////  Created12:        2001/12/02                                  ////
////                  (See log12 for the revision12 history12)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright12 (C) 2000, 2001 Authors12                             ////
////                                                              ////
//// This12 source12 file may be used and distributed12 without         ////
//// restriction12 provided that this copyright12 statement12 is not    ////
//// removed from the file and that any derivative12 work12 contains12  ////
//// the original copyright12 notice12 and the associated disclaimer12. ////
////                                                              ////
//// This12 source12 file is free software12; you can redistribute12 it   ////
//// and/or modify it under the terms12 of the GNU12 Lesser12 General12   ////
//// Public12 License12 as published12 by the Free12 Software12 Foundation12; ////
//// either12 version12 2.1 of the License12, or (at your12 option) any   ////
//// later12 version12.                                               ////
////                                                              ////
//// This12 source12 is distributed12 in the hope12 that it will be       ////
//// useful12, but WITHOUT12 ANY12 WARRANTY12; without even12 the implied12   ////
//// warranty12 of MERCHANTABILITY12 or FITNESS12 FOR12 A PARTICULAR12      ////
//// PURPOSE12.  See the GNU12 Lesser12 General12 Public12 License12 for more ////
//// details12.                                                     ////
////                                                              ////
//// You should have received12 a copy of the GNU12 Lesser12 General12    ////
//// Public12 License12 along12 with this source12; if not, download12 it   ////
//// from http12://www12.opencores12.org12/lgpl12.shtml12                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS12 Revision12 History12
//
// $Log: not supported by cvs2svn12 $
// Revision12 1.4  2002/07/22 23:02:23  gorban12
// Bug12 Fixes12:
//  * Possible12 loss of sync and bad12 reception12 of stop bit on slow12 baud12 rates12 fixed12.
//   Problem12 reported12 by Kenny12.Tung12.
//  * Bad (or lack12 of ) loopback12 handling12 fixed12. Reported12 by Cherry12 Withers12.
//
// Improvements12:
//  * Made12 FIFO's as general12 inferrable12 memory where possible12.
//  So12 on FPGA12 they should be inferred12 as RAM12 (Distributed12 RAM12 on Xilinx12).
//  This12 saves12 about12 1/3 of the Slice12 count and reduces12 P&R and synthesis12 times.
//
//  * Added12 optional12 baudrate12 output (baud_o12).
//  This12 is identical12 to BAUDOUT12* signal12 on 16550 chip12.
//  It outputs12 16xbit_clock_rate - the divided12 clock12.
//  It's disabled by default. Define12 UART_HAS_BAUDRATE_OUTPUT12 to use.
//
// Revision12 1.3  2001/12/19 08:40:03  mohor12
// Warnings12 fixed12 (unused12 signals12 removed).
//
// Revision12 1.2  2001/12/12 22:17:30  gorban12
// some12 synthesis12 bugs12 fixed12
//
// Revision12 1.1  2001/12/04 21:14:16  gorban12
// committed12 the debug12 interface file
//

// synopsys12 translate_off12
`include "timescale.v"
// synopsys12 translate_on12

`include "uart_defines12.v"

module uart_debug_if12 (/*AUTOARG12*/
// Outputs12
wb_dat32_o12, 
// Inputs12
wb_adr_i12, ier12, iir12, fcr12, mcr12, lcr12, msr12, 
lsr12, rf_count12, tf_count12, tstate12, rstate
) ;

input [`UART_ADDR_WIDTH12-1:0] 		wb_adr_i12;
output [31:0] 							wb_dat32_o12;
input [3:0] 							ier12;
input [3:0] 							iir12;
input [1:0] 							fcr12;  /// bits 7 and 6 of fcr12. Other12 bits are ignored
input [4:0] 							mcr12;
input [7:0] 							lcr12;
input [7:0] 							msr12;
input [7:0] 							lsr12;
input [`UART_FIFO_COUNTER_W12-1:0] rf_count12;
input [`UART_FIFO_COUNTER_W12-1:0] tf_count12;
input [2:0] 							tstate12;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH12-1:0] 		wb_adr_i12;
reg [31:0] 								wb_dat32_o12;

always @(/*AUTOSENSE12*/fcr12 or ier12 or iir12 or lcr12 or lsr12 or mcr12 or msr12
			or rf_count12 or rstate or tf_count12 or tstate12 or wb_adr_i12)
	case (wb_adr_i12)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o12 = {msr12,lcr12,iir12,ier12,lsr12};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o12 = {8'b0, fcr12,mcr12, rf_count12, rstate, tf_count12, tstate12};
		default: wb_dat32_o12 = 0;
	endcase // case(wb_adr_i12)

endmodule // uart_debug_if12

