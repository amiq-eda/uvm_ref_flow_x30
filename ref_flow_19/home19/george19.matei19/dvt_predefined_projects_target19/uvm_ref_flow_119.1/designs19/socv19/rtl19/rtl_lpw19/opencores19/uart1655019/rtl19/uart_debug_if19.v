//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if19.v                                             ////
////                                                              ////
////                                                              ////
////  This19 file is part of the "UART19 16550 compatible19" project19    ////
////  http19://www19.opencores19.org19/cores19/uart1655019/                   ////
////                                                              ////
////  Documentation19 related19 to this project19:                      ////
////  - http19://www19.opencores19.org19/cores19/uart1655019/                 ////
////                                                              ////
////  Projects19 compatibility19:                                     ////
////  - WISHBONE19                                                  ////
////  RS23219 Protocol19                                              ////
////  16550D uart19 (mostly19 supported)                              ////
////                                                              ////
////  Overview19 (main19 Features19):                                   ////
////  UART19 core19 debug19 interface.                                  ////
////                                                              ////
////  Author19(s):                                                  ////
////      - gorban19@opencores19.org19                                  ////
////      - Jacob19 Gorban19                                          ////
////                                                              ////
////  Created19:        2001/12/02                                  ////
////                  (See log19 for the revision19 history19)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2000, 2001 Authors19                             ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS19 Revision19 History19
//
// $Log: not supported by cvs2svn19 $
// Revision19 1.4  2002/07/22 23:02:23  gorban19
// Bug19 Fixes19:
//  * Possible19 loss of sync and bad19 reception19 of stop bit on slow19 baud19 rates19 fixed19.
//   Problem19 reported19 by Kenny19.Tung19.
//  * Bad (or lack19 of ) loopback19 handling19 fixed19. Reported19 by Cherry19 Withers19.
//
// Improvements19:
//  * Made19 FIFO's as general19 inferrable19 memory where possible19.
//  So19 on FPGA19 they should be inferred19 as RAM19 (Distributed19 RAM19 on Xilinx19).
//  This19 saves19 about19 1/3 of the Slice19 count and reduces19 P&R and synthesis19 times.
//
//  * Added19 optional19 baudrate19 output (baud_o19).
//  This19 is identical19 to BAUDOUT19* signal19 on 16550 chip19.
//  It outputs19 16xbit_clock_rate - the divided19 clock19.
//  It's disabled by default. Define19 UART_HAS_BAUDRATE_OUTPUT19 to use.
//
// Revision19 1.3  2001/12/19 08:40:03  mohor19
// Warnings19 fixed19 (unused19 signals19 removed).
//
// Revision19 1.2  2001/12/12 22:17:30  gorban19
// some19 synthesis19 bugs19 fixed19
//
// Revision19 1.1  2001/12/04 21:14:16  gorban19
// committed19 the debug19 interface file
//

// synopsys19 translate_off19
`include "timescale.v"
// synopsys19 translate_on19

`include "uart_defines19.v"

module uart_debug_if19 (/*AUTOARG19*/
// Outputs19
wb_dat32_o19, 
// Inputs19
wb_adr_i19, ier19, iir19, fcr19, mcr19, lcr19, msr19, 
lsr19, rf_count19, tf_count19, tstate19, rstate
) ;

input [`UART_ADDR_WIDTH19-1:0] 		wb_adr_i19;
output [31:0] 							wb_dat32_o19;
input [3:0] 							ier19;
input [3:0] 							iir19;
input [1:0] 							fcr19;  /// bits 7 and 6 of fcr19. Other19 bits are ignored
input [4:0] 							mcr19;
input [7:0] 							lcr19;
input [7:0] 							msr19;
input [7:0] 							lsr19;
input [`UART_FIFO_COUNTER_W19-1:0] rf_count19;
input [`UART_FIFO_COUNTER_W19-1:0] tf_count19;
input [2:0] 							tstate19;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH19-1:0] 		wb_adr_i19;
reg [31:0] 								wb_dat32_o19;

always @(/*AUTOSENSE19*/fcr19 or ier19 or iir19 or lcr19 or lsr19 or mcr19 or msr19
			or rf_count19 or rstate or tf_count19 or tstate19 or wb_adr_i19)
	case (wb_adr_i19)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o19 = {msr19,lcr19,iir19,ier19,lsr19};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o19 = {8'b0, fcr19,mcr19, rf_count19, rstate, tf_count19, tstate19};
		default: wb_dat32_o19 = 0;
	endcase // case(wb_adr_i19)

endmodule // uart_debug_if19

