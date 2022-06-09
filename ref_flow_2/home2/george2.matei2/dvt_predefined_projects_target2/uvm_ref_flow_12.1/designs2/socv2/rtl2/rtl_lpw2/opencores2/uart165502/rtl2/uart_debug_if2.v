//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if2.v                                             ////
////                                                              ////
////                                                              ////
////  This2 file is part of the "UART2 16550 compatible2" project2    ////
////  http2://www2.opencores2.org2/cores2/uart165502/                   ////
////                                                              ////
////  Documentation2 related2 to this project2:                      ////
////  - http2://www2.opencores2.org2/cores2/uart165502/                 ////
////                                                              ////
////  Projects2 compatibility2:                                     ////
////  - WISHBONE2                                                  ////
////  RS2322 Protocol2                                              ////
////  16550D uart2 (mostly2 supported)                              ////
////                                                              ////
////  Overview2 (main2 Features2):                                   ////
////  UART2 core2 debug2 interface.                                  ////
////                                                              ////
////  Author2(s):                                                  ////
////      - gorban2@opencores2.org2                                  ////
////      - Jacob2 Gorban2                                          ////
////                                                              ////
////  Created2:        2001/12/02                                  ////
////                  (See log2 for the revision2 history2)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2000, 2001 Authors2                             ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS2 Revision2 History2
//
// $Log: not supported by cvs2svn2 $
// Revision2 1.4  2002/07/22 23:02:23  gorban2
// Bug2 Fixes2:
//  * Possible2 loss of sync and bad2 reception2 of stop bit on slow2 baud2 rates2 fixed2.
//   Problem2 reported2 by Kenny2.Tung2.
//  * Bad (or lack2 of ) loopback2 handling2 fixed2. Reported2 by Cherry2 Withers2.
//
// Improvements2:
//  * Made2 FIFO's as general2 inferrable2 memory where possible2.
//  So2 on FPGA2 they should be inferred2 as RAM2 (Distributed2 RAM2 on Xilinx2).
//  This2 saves2 about2 1/3 of the Slice2 count and reduces2 P&R and synthesis2 times.
//
//  * Added2 optional2 baudrate2 output (baud_o2).
//  This2 is identical2 to BAUDOUT2* signal2 on 16550 chip2.
//  It outputs2 16xbit_clock_rate - the divided2 clock2.
//  It's disabled by default. Define2 UART_HAS_BAUDRATE_OUTPUT2 to use.
//
// Revision2 1.3  2001/12/19 08:40:03  mohor2
// Warnings2 fixed2 (unused2 signals2 removed).
//
// Revision2 1.2  2001/12/12 22:17:30  gorban2
// some2 synthesis2 bugs2 fixed2
//
// Revision2 1.1  2001/12/04 21:14:16  gorban2
// committed2 the debug2 interface file
//

// synopsys2 translate_off2
`include "timescale.v"
// synopsys2 translate_on2

`include "uart_defines2.v"

module uart_debug_if2 (/*AUTOARG2*/
// Outputs2
wb_dat32_o2, 
// Inputs2
wb_adr_i2, ier2, iir2, fcr2, mcr2, lcr2, msr2, 
lsr2, rf_count2, tf_count2, tstate2, rstate
) ;

input [`UART_ADDR_WIDTH2-1:0] 		wb_adr_i2;
output [31:0] 							wb_dat32_o2;
input [3:0] 							ier2;
input [3:0] 							iir2;
input [1:0] 							fcr2;  /// bits 7 and 6 of fcr2. Other2 bits are ignored
input [4:0] 							mcr2;
input [7:0] 							lcr2;
input [7:0] 							msr2;
input [7:0] 							lsr2;
input [`UART_FIFO_COUNTER_W2-1:0] rf_count2;
input [`UART_FIFO_COUNTER_W2-1:0] tf_count2;
input [2:0] 							tstate2;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH2-1:0] 		wb_adr_i2;
reg [31:0] 								wb_dat32_o2;

always @(/*AUTOSENSE2*/fcr2 or ier2 or iir2 or lcr2 or lsr2 or mcr2 or msr2
			or rf_count2 or rstate or tf_count2 or tstate2 or wb_adr_i2)
	case (wb_adr_i2)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o2 = {msr2,lcr2,iir2,ier2,lsr2};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o2 = {8'b0, fcr2,mcr2, rf_count2, rstate, tf_count2, tstate2};
		default: wb_dat32_o2 = 0;
	endcase // case(wb_adr_i2)

endmodule // uart_debug_if2

