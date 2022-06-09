//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if6.v                                             ////
////                                                              ////
////                                                              ////
////  This6 file is part of the "UART6 16550 compatible6" project6    ////
////  http6://www6.opencores6.org6/cores6/uart165506/                   ////
////                                                              ////
////  Documentation6 related6 to this project6:                      ////
////  - http6://www6.opencores6.org6/cores6/uart165506/                 ////
////                                                              ////
////  Projects6 compatibility6:                                     ////
////  - WISHBONE6                                                  ////
////  RS2326 Protocol6                                              ////
////  16550D uart6 (mostly6 supported)                              ////
////                                                              ////
////  Overview6 (main6 Features6):                                   ////
////  UART6 core6 debug6 interface.                                  ////
////                                                              ////
////  Author6(s):                                                  ////
////      - gorban6@opencores6.org6                                  ////
////      - Jacob6 Gorban6                                          ////
////                                                              ////
////  Created6:        2001/12/02                                  ////
////                  (See log6 for the revision6 history6)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2000, 2001 Authors6                             ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS6 Revision6 History6
//
// $Log: not supported by cvs2svn6 $
// Revision6 1.4  2002/07/22 23:02:23  gorban6
// Bug6 Fixes6:
//  * Possible6 loss of sync and bad6 reception6 of stop bit on slow6 baud6 rates6 fixed6.
//   Problem6 reported6 by Kenny6.Tung6.
//  * Bad (or lack6 of ) loopback6 handling6 fixed6. Reported6 by Cherry6 Withers6.
//
// Improvements6:
//  * Made6 FIFO's as general6 inferrable6 memory where possible6.
//  So6 on FPGA6 they should be inferred6 as RAM6 (Distributed6 RAM6 on Xilinx6).
//  This6 saves6 about6 1/3 of the Slice6 count and reduces6 P&R and synthesis6 times.
//
//  * Added6 optional6 baudrate6 output (baud_o6).
//  This6 is identical6 to BAUDOUT6* signal6 on 16550 chip6.
//  It outputs6 16xbit_clock_rate - the divided6 clock6.
//  It's disabled by default. Define6 UART_HAS_BAUDRATE_OUTPUT6 to use.
//
// Revision6 1.3  2001/12/19 08:40:03  mohor6
// Warnings6 fixed6 (unused6 signals6 removed).
//
// Revision6 1.2  2001/12/12 22:17:30  gorban6
// some6 synthesis6 bugs6 fixed6
//
// Revision6 1.1  2001/12/04 21:14:16  gorban6
// committed6 the debug6 interface file
//

// synopsys6 translate_off6
`include "timescale.v"
// synopsys6 translate_on6

`include "uart_defines6.v"

module uart_debug_if6 (/*AUTOARG6*/
// Outputs6
wb_dat32_o6, 
// Inputs6
wb_adr_i6, ier6, iir6, fcr6, mcr6, lcr6, msr6, 
lsr6, rf_count6, tf_count6, tstate6, rstate
) ;

input [`UART_ADDR_WIDTH6-1:0] 		wb_adr_i6;
output [31:0] 							wb_dat32_o6;
input [3:0] 							ier6;
input [3:0] 							iir6;
input [1:0] 							fcr6;  /// bits 7 and 6 of fcr6. Other6 bits are ignored
input [4:0] 							mcr6;
input [7:0] 							lcr6;
input [7:0] 							msr6;
input [7:0] 							lsr6;
input [`UART_FIFO_COUNTER_W6-1:0] rf_count6;
input [`UART_FIFO_COUNTER_W6-1:0] tf_count6;
input [2:0] 							tstate6;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH6-1:0] 		wb_adr_i6;
reg [31:0] 								wb_dat32_o6;

always @(/*AUTOSENSE6*/fcr6 or ier6 or iir6 or lcr6 or lsr6 or mcr6 or msr6
			or rf_count6 or rstate or tf_count6 or tstate6 or wb_adr_i6)
	case (wb_adr_i6)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o6 = {msr6,lcr6,iir6,ier6,lsr6};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o6 = {8'b0, fcr6,mcr6, rf_count6, rstate, tf_count6, tstate6};
		default: wb_dat32_o6 = 0;
	endcase // case(wb_adr_i6)

endmodule // uart_debug_if6

