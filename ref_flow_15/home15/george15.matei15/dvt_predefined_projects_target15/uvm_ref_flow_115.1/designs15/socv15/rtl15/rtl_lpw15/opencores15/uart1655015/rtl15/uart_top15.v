//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top15.v                                                  ////
////                                                              ////
////                                                              ////
////  This15 file is part of the "UART15 16550 compatible15" project15    ////
////  http15://www15.opencores15.org15/cores15/uart1655015/                   ////
////                                                              ////
////  Documentation15 related15 to this project15:                      ////
////  - http15://www15.opencores15.org15/cores15/uart1655015/                 ////
////                                                              ////
////  Projects15 compatibility15:                                     ////
////  - WISHBONE15                                                  ////
////  RS23215 Protocol15                                              ////
////  16550D uart15 (mostly15 supported)                              ////
////                                                              ////
////  Overview15 (main15 Features15):                                   ////
////  UART15 core15 top level.                                        ////
////                                                              ////
////  Known15 problems15 (limits15):                                    ////
////  Note15 that transmitter15 and receiver15 instances15 are inside     ////
////  the uart_regs15.v file.                                       ////
////                                                              ////
////  To15 Do15:                                                      ////
////  Nothing so far15.                                             ////
////                                                              ////
////  Author15(s):                                                  ////
////      - gorban15@opencores15.org15                                  ////
////      - Jacob15 Gorban15                                          ////
////      - Igor15 Mohor15 (igorm15@opencores15.org15)                      ////
////                                                              ////
////  Created15:        2001/05/12                                  ////
////  Last15 Updated15:   2001/05/17                                  ////
////                  (See log15 for the revision15 history15)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2000, 2001 Authors15                             ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS15 Revision15 History15
//
// $Log: not supported by cvs2svn15 $
// Revision15 1.18  2002/07/22 23:02:23  gorban15
// Bug15 Fixes15:
//  * Possible15 loss of sync and bad15 reception15 of stop bit on slow15 baud15 rates15 fixed15.
//   Problem15 reported15 by Kenny15.Tung15.
//  * Bad (or lack15 of ) loopback15 handling15 fixed15. Reported15 by Cherry15 Withers15.
//
// Improvements15:
//  * Made15 FIFO's as general15 inferrable15 memory where possible15.
//  So15 on FPGA15 they should be inferred15 as RAM15 (Distributed15 RAM15 on Xilinx15).
//  This15 saves15 about15 1/3 of the Slice15 count and reduces15 P&R and synthesis15 times.
//
//  * Added15 optional15 baudrate15 output (baud_o15).
//  This15 is identical15 to BAUDOUT15* signal15 on 16550 chip15.
//  It outputs15 16xbit_clock_rate - the divided15 clock15.
//  It's disabled by default. Define15 UART_HAS_BAUDRATE_OUTPUT15 to use.
//
// Revision15 1.17  2001/12/19 08:40:03  mohor15
// Warnings15 fixed15 (unused15 signals15 removed).
//
// Revision15 1.16  2001/12/06 14:51:04  gorban15
// Bug15 in LSR15[0] is fixed15.
// All WISHBONE15 signals15 are now sampled15, so another15 wait-state is introduced15 on all transfers15.
//
// Revision15 1.15  2001/12/03 21:44:29  gorban15
// Updated15 specification15 documentation.
// Added15 full 32-bit data bus interface, now as default.
// Address is 5-bit wide15 in 32-bit data bus mode.
// Added15 wb_sel_i15 input to the core15. It's used in the 32-bit mode.
// Added15 debug15 interface with two15 32-bit read-only registers in 32-bit mode.
// Bits15 5 and 6 of LSR15 are now only cleared15 on TX15 FIFO write.
// My15 small test bench15 is modified to work15 with 32-bit mode.
//
// Revision15 1.14  2001/11/07 17:51:52  gorban15
// Heavily15 rewritten15 interrupt15 and LSR15 subsystems15.
// Many15 bugs15 hopefully15 squashed15.
//
// Revision15 1.13  2001/10/20 09:58:40  gorban15
// Small15 synopsis15 fixes15
//
// Revision15 1.12  2001/08/25 15:46:19  gorban15
// Modified15 port names again15
//
// Revision15 1.11  2001/08/24 21:01:12  mohor15
// Things15 connected15 to parity15 changed.
// Clock15 devider15 changed.
//
// Revision15 1.10  2001/08/23 16:05:05  mohor15
// Stop bit bug15 fixed15.
// Parity15 bug15 fixed15.
// WISHBONE15 read cycle bug15 fixed15,
// OE15 indicator15 (Overrun15 Error) bug15 fixed15.
// PE15 indicator15 (Parity15 Error) bug15 fixed15.
// Register read bug15 fixed15.
//
// Revision15 1.4  2001/05/31 20:08:01  gorban15
// FIFO changes15 and other corrections15.
//
// Revision15 1.3  2001/05/21 19:12:02  gorban15
// Corrected15 some15 Linter15 messages15.
//
// Revision15 1.2  2001/05/17 18:34:18  gorban15
// First15 'stable' release. Should15 be sythesizable15 now. Also15 added new header.
//
// Revision15 1.0  2001-05-17 21:27:12+02  jacob15
// Initial15 revision15
//
//
// synopsys15 translate_off15
`include "timescale.v"
// synopsys15 translate_on15

`include "uart_defines15.v"

module uart_top15	(
	wb_clk_i15, 
	
	// Wishbone15 signals15
	wb_rst_i15, wb_adr_i15, wb_dat_i15, wb_dat_o15, wb_we_i15, wb_stb_i15, wb_cyc_i15, wb_ack_o15, wb_sel_i15,
	int_o15, // interrupt15 request

	// UART15	signals15
	// serial15 input/output
	stx_pad_o15, srx_pad_i15,

	// modem15 signals15
	rts_pad_o15, cts_pad_i15, dtr_pad_o15, dsr_pad_i15, ri_pad_i15, dcd_pad_i15
`ifdef UART_HAS_BAUDRATE_OUTPUT15
	, baud_o15
`endif
	);

parameter 							 uart_data_width15 = `UART_DATA_WIDTH15;
parameter 							 uart_addr_width15 = `UART_ADDR_WIDTH15;

input 								 wb_clk_i15;

// WISHBONE15 interface
input 								 wb_rst_i15;
input [uart_addr_width15-1:0] 	 wb_adr_i15;
input [uart_data_width15-1:0] 	 wb_dat_i15;
output [uart_data_width15-1:0] 	 wb_dat_o15;
input 								 wb_we_i15;
input 								 wb_stb_i15;
input 								 wb_cyc_i15;
input [3:0]							 wb_sel_i15;
output 								 wb_ack_o15;
output 								 int_o15;

// UART15	signals15
input 								 srx_pad_i15;
output 								 stx_pad_o15;
output 								 rts_pad_o15;
input 								 cts_pad_i15;
output 								 dtr_pad_o15;
input 								 dsr_pad_i15;
input 								 ri_pad_i15;
input 								 dcd_pad_i15;

// optional15 baudrate15 output
`ifdef UART_HAS_BAUDRATE_OUTPUT15
output	baud_o15;
`endif


wire 									 stx_pad_o15;
wire 									 rts_pad_o15;
wire 									 dtr_pad_o15;

wire [uart_addr_width15-1:0] 	 wb_adr_i15;
wire [uart_data_width15-1:0] 	 wb_dat_i15;
wire [uart_data_width15-1:0] 	 wb_dat_o15;

wire [7:0] 							 wb_dat8_i15; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o15; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o15; // debug15 interface 32-bit output
wire [3:0] 							 wb_sel_i15;  // WISHBONE15 select15 signal15
wire [uart_addr_width15-1:0] 	 wb_adr_int15;
wire 									 we_o15;	// Write enable for registers
wire		          	     re_o15;	// Read enable for registers
//
// MODULE15 INSTANCES15
//

`ifdef DATA_BUS_WIDTH_815
`else
// debug15 interface wires15
wire	[3:0] ier15;
wire	[3:0] iir15;
wire	[1:0] fcr15;
wire	[4:0] mcr15;
wire	[7:0] lcr15;
wire	[7:0] msr15;
wire	[7:0] lsr15;
wire	[`UART_FIFO_COUNTER_W15-1:0] rf_count15;
wire	[`UART_FIFO_COUNTER_W15-1:0] tf_count15;
wire	[2:0] tstate15;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_815
////  WISHBONE15 interface module
uart_wb15		wb_interface15(
		.clk15(		wb_clk_i15		),
		.wb_rst_i15(	wb_rst_i15	),
	.wb_dat_i15(wb_dat_i15),
	.wb_dat_o15(wb_dat_o15),
	.wb_dat8_i15(wb_dat8_i15),
	.wb_dat8_o15(wb_dat8_o15),
	 .wb_dat32_o15(32'b0),								 
	 .wb_sel_i15(4'b0),
		.wb_we_i15(	wb_we_i15		),
		.wb_stb_i15(	wb_stb_i15	),
		.wb_cyc_i15(	wb_cyc_i15	),
		.wb_ack_o15(	wb_ack_o15	),
	.wb_adr_i15(wb_adr_i15),
	.wb_adr_int15(wb_adr_int15),
		.we_o15(		we_o15		),
		.re_o15(re_o15)
		);
`else
uart_wb15		wb_interface15(
		.clk15(		wb_clk_i15		),
		.wb_rst_i15(	wb_rst_i15	),
	.wb_dat_i15(wb_dat_i15),
	.wb_dat_o15(wb_dat_o15),
	.wb_dat8_i15(wb_dat8_i15),
	.wb_dat8_o15(wb_dat8_o15),
	 .wb_sel_i15(wb_sel_i15),
	 .wb_dat32_o15(wb_dat32_o15),								 
		.wb_we_i15(	wb_we_i15		),
		.wb_stb_i15(	wb_stb_i15	),
		.wb_cyc_i15(	wb_cyc_i15	),
		.wb_ack_o15(	wb_ack_o15	),
	.wb_adr_i15(wb_adr_i15),
	.wb_adr_int15(wb_adr_int15),
		.we_o15(		we_o15		),
		.re_o15(re_o15)
		);
`endif

// Registers15
uart_regs15	regs(
	.clk15(		wb_clk_i15		),
	.wb_rst_i15(	wb_rst_i15	),
	.wb_addr_i15(	wb_adr_int15	),
	.wb_dat_i15(	wb_dat8_i15	),
	.wb_dat_o15(	wb_dat8_o15	),
	.wb_we_i15(	we_o15		),
   .wb_re_i15(re_o15),
	.modem_inputs15(	{cts_pad_i15, dsr_pad_i15,
	ri_pad_i15,  dcd_pad_i15}	),
	.stx_pad_o15(		stx_pad_o15		),
	.srx_pad_i15(		srx_pad_i15		),
`ifdef DATA_BUS_WIDTH_815
`else
// debug15 interface signals15	enabled
.ier15(ier15), 
.iir15(iir15), 
.fcr15(fcr15), 
.mcr15(mcr15), 
.lcr15(lcr15), 
.msr15(msr15), 
.lsr15(lsr15), 
.rf_count15(rf_count15),
.tf_count15(tf_count15),
.tstate15(tstate15),
.rstate(rstate),
`endif					  
	.rts_pad_o15(		rts_pad_o15		),
	.dtr_pad_o15(		dtr_pad_o15		),
	.int_o15(		int_o15		)
`ifdef UART_HAS_BAUDRATE_OUTPUT15
	, .baud_o15(baud_o15)
`endif

);

`ifdef DATA_BUS_WIDTH_815
`else
uart_debug_if15 dbg15(/*AUTOINST15*/
						// Outputs15
						.wb_dat32_o15				 (wb_dat32_o15[31:0]),
						// Inputs15
						.wb_adr_i15				 (wb_adr_int15[`UART_ADDR_WIDTH15-1:0]),
						.ier15						 (ier15[3:0]),
						.iir15						 (iir15[3:0]),
						.fcr15						 (fcr15[1:0]),
						.mcr15						 (mcr15[4:0]),
						.lcr15						 (lcr15[7:0]),
						.msr15						 (msr15[7:0]),
						.lsr15						 (lsr15[7:0]),
						.rf_count15				 (rf_count15[`UART_FIFO_COUNTER_W15-1:0]),
						.tf_count15				 (tf_count15[`UART_FIFO_COUNTER_W15-1:0]),
						.tstate15					 (tstate15[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_815
		$display("(%m) UART15 INFO15: Data bus width is 8. No Debug15 interface.\n");
	`else
		$display("(%m) UART15 INFO15: Data bus width is 32. Debug15 Interface15 present15.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT15
		$display("(%m) UART15 INFO15: Has15 baudrate15 output\n");
	`else
		$display("(%m) UART15 INFO15: Doesn15't have baudrate15 output\n");
	`endif
end

endmodule


