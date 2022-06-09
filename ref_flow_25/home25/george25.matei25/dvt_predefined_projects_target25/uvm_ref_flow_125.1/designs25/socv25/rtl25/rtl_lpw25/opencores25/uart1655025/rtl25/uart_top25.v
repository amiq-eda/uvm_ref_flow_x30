//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top25.v                                                  ////
////                                                              ////
////                                                              ////
////  This25 file is part of the "UART25 16550 compatible25" project25    ////
////  http25://www25.opencores25.org25/cores25/uart1655025/                   ////
////                                                              ////
////  Documentation25 related25 to this project25:                      ////
////  - http25://www25.opencores25.org25/cores25/uart1655025/                 ////
////                                                              ////
////  Projects25 compatibility25:                                     ////
////  - WISHBONE25                                                  ////
////  RS23225 Protocol25                                              ////
////  16550D uart25 (mostly25 supported)                              ////
////                                                              ////
////  Overview25 (main25 Features25):                                   ////
////  UART25 core25 top level.                                        ////
////                                                              ////
////  Known25 problems25 (limits25):                                    ////
////  Note25 that transmitter25 and receiver25 instances25 are inside     ////
////  the uart_regs25.v file.                                       ////
////                                                              ////
////  To25 Do25:                                                      ////
////  Nothing so far25.                                             ////
////                                                              ////
////  Author25(s):                                                  ////
////      - gorban25@opencores25.org25                                  ////
////      - Jacob25 Gorban25                                          ////
////      - Igor25 Mohor25 (igorm25@opencores25.org25)                      ////
////                                                              ////
////  Created25:        2001/05/12                                  ////
////  Last25 Updated25:   2001/05/17                                  ////
////                  (See log25 for the revision25 history25)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2000, 2001 Authors25                             ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS25 Revision25 History25
//
// $Log: not supported by cvs2svn25 $
// Revision25 1.18  2002/07/22 23:02:23  gorban25
// Bug25 Fixes25:
//  * Possible25 loss of sync and bad25 reception25 of stop bit on slow25 baud25 rates25 fixed25.
//   Problem25 reported25 by Kenny25.Tung25.
//  * Bad (or lack25 of ) loopback25 handling25 fixed25. Reported25 by Cherry25 Withers25.
//
// Improvements25:
//  * Made25 FIFO's as general25 inferrable25 memory where possible25.
//  So25 on FPGA25 they should be inferred25 as RAM25 (Distributed25 RAM25 on Xilinx25).
//  This25 saves25 about25 1/3 of the Slice25 count and reduces25 P&R and synthesis25 times.
//
//  * Added25 optional25 baudrate25 output (baud_o25).
//  This25 is identical25 to BAUDOUT25* signal25 on 16550 chip25.
//  It outputs25 16xbit_clock_rate - the divided25 clock25.
//  It's disabled by default. Define25 UART_HAS_BAUDRATE_OUTPUT25 to use.
//
// Revision25 1.17  2001/12/19 08:40:03  mohor25
// Warnings25 fixed25 (unused25 signals25 removed).
//
// Revision25 1.16  2001/12/06 14:51:04  gorban25
// Bug25 in LSR25[0] is fixed25.
// All WISHBONE25 signals25 are now sampled25, so another25 wait-state is introduced25 on all transfers25.
//
// Revision25 1.15  2001/12/03 21:44:29  gorban25
// Updated25 specification25 documentation.
// Added25 full 32-bit data bus interface, now as default.
// Address is 5-bit wide25 in 32-bit data bus mode.
// Added25 wb_sel_i25 input to the core25. It's used in the 32-bit mode.
// Added25 debug25 interface with two25 32-bit read-only registers in 32-bit mode.
// Bits25 5 and 6 of LSR25 are now only cleared25 on TX25 FIFO write.
// My25 small test bench25 is modified to work25 with 32-bit mode.
//
// Revision25 1.14  2001/11/07 17:51:52  gorban25
// Heavily25 rewritten25 interrupt25 and LSR25 subsystems25.
// Many25 bugs25 hopefully25 squashed25.
//
// Revision25 1.13  2001/10/20 09:58:40  gorban25
// Small25 synopsis25 fixes25
//
// Revision25 1.12  2001/08/25 15:46:19  gorban25
// Modified25 port names again25
//
// Revision25 1.11  2001/08/24 21:01:12  mohor25
// Things25 connected25 to parity25 changed.
// Clock25 devider25 changed.
//
// Revision25 1.10  2001/08/23 16:05:05  mohor25
// Stop bit bug25 fixed25.
// Parity25 bug25 fixed25.
// WISHBONE25 read cycle bug25 fixed25,
// OE25 indicator25 (Overrun25 Error) bug25 fixed25.
// PE25 indicator25 (Parity25 Error) bug25 fixed25.
// Register read bug25 fixed25.
//
// Revision25 1.4  2001/05/31 20:08:01  gorban25
// FIFO changes25 and other corrections25.
//
// Revision25 1.3  2001/05/21 19:12:02  gorban25
// Corrected25 some25 Linter25 messages25.
//
// Revision25 1.2  2001/05/17 18:34:18  gorban25
// First25 'stable' release. Should25 be sythesizable25 now. Also25 added new header.
//
// Revision25 1.0  2001-05-17 21:27:12+02  jacob25
// Initial25 revision25
//
//
// synopsys25 translate_off25
`include "timescale.v"
// synopsys25 translate_on25

`include "uart_defines25.v"

module uart_top25	(
	wb_clk_i25, 
	
	// Wishbone25 signals25
	wb_rst_i25, wb_adr_i25, wb_dat_i25, wb_dat_o25, wb_we_i25, wb_stb_i25, wb_cyc_i25, wb_ack_o25, wb_sel_i25,
	int_o25, // interrupt25 request

	// UART25	signals25
	// serial25 input/output
	stx_pad_o25, srx_pad_i25,

	// modem25 signals25
	rts_pad_o25, cts_pad_i25, dtr_pad_o25, dsr_pad_i25, ri_pad_i25, dcd_pad_i25
`ifdef UART_HAS_BAUDRATE_OUTPUT25
	, baud_o25
`endif
	);

parameter 							 uart_data_width25 = `UART_DATA_WIDTH25;
parameter 							 uart_addr_width25 = `UART_ADDR_WIDTH25;

input 								 wb_clk_i25;

// WISHBONE25 interface
input 								 wb_rst_i25;
input [uart_addr_width25-1:0] 	 wb_adr_i25;
input [uart_data_width25-1:0] 	 wb_dat_i25;
output [uart_data_width25-1:0] 	 wb_dat_o25;
input 								 wb_we_i25;
input 								 wb_stb_i25;
input 								 wb_cyc_i25;
input [3:0]							 wb_sel_i25;
output 								 wb_ack_o25;
output 								 int_o25;

// UART25	signals25
input 								 srx_pad_i25;
output 								 stx_pad_o25;
output 								 rts_pad_o25;
input 								 cts_pad_i25;
output 								 dtr_pad_o25;
input 								 dsr_pad_i25;
input 								 ri_pad_i25;
input 								 dcd_pad_i25;

// optional25 baudrate25 output
`ifdef UART_HAS_BAUDRATE_OUTPUT25
output	baud_o25;
`endif


wire 									 stx_pad_o25;
wire 									 rts_pad_o25;
wire 									 dtr_pad_o25;

wire [uart_addr_width25-1:0] 	 wb_adr_i25;
wire [uart_data_width25-1:0] 	 wb_dat_i25;
wire [uart_data_width25-1:0] 	 wb_dat_o25;

wire [7:0] 							 wb_dat8_i25; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o25; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o25; // debug25 interface 32-bit output
wire [3:0] 							 wb_sel_i25;  // WISHBONE25 select25 signal25
wire [uart_addr_width25-1:0] 	 wb_adr_int25;
wire 									 we_o25;	// Write enable for registers
wire		          	     re_o25;	// Read enable for registers
//
// MODULE25 INSTANCES25
//

`ifdef DATA_BUS_WIDTH_825
`else
// debug25 interface wires25
wire	[3:0] ier25;
wire	[3:0] iir25;
wire	[1:0] fcr25;
wire	[4:0] mcr25;
wire	[7:0] lcr25;
wire	[7:0] msr25;
wire	[7:0] lsr25;
wire	[`UART_FIFO_COUNTER_W25-1:0] rf_count25;
wire	[`UART_FIFO_COUNTER_W25-1:0] tf_count25;
wire	[2:0] tstate25;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_825
////  WISHBONE25 interface module
uart_wb25		wb_interface25(
		.clk25(		wb_clk_i25		),
		.wb_rst_i25(	wb_rst_i25	),
	.wb_dat_i25(wb_dat_i25),
	.wb_dat_o25(wb_dat_o25),
	.wb_dat8_i25(wb_dat8_i25),
	.wb_dat8_o25(wb_dat8_o25),
	 .wb_dat32_o25(32'b0),								 
	 .wb_sel_i25(4'b0),
		.wb_we_i25(	wb_we_i25		),
		.wb_stb_i25(	wb_stb_i25	),
		.wb_cyc_i25(	wb_cyc_i25	),
		.wb_ack_o25(	wb_ack_o25	),
	.wb_adr_i25(wb_adr_i25),
	.wb_adr_int25(wb_adr_int25),
		.we_o25(		we_o25		),
		.re_o25(re_o25)
		);
`else
uart_wb25		wb_interface25(
		.clk25(		wb_clk_i25		),
		.wb_rst_i25(	wb_rst_i25	),
	.wb_dat_i25(wb_dat_i25),
	.wb_dat_o25(wb_dat_o25),
	.wb_dat8_i25(wb_dat8_i25),
	.wb_dat8_o25(wb_dat8_o25),
	 .wb_sel_i25(wb_sel_i25),
	 .wb_dat32_o25(wb_dat32_o25),								 
		.wb_we_i25(	wb_we_i25		),
		.wb_stb_i25(	wb_stb_i25	),
		.wb_cyc_i25(	wb_cyc_i25	),
		.wb_ack_o25(	wb_ack_o25	),
	.wb_adr_i25(wb_adr_i25),
	.wb_adr_int25(wb_adr_int25),
		.we_o25(		we_o25		),
		.re_o25(re_o25)
		);
`endif

// Registers25
uart_regs25	regs(
	.clk25(		wb_clk_i25		),
	.wb_rst_i25(	wb_rst_i25	),
	.wb_addr_i25(	wb_adr_int25	),
	.wb_dat_i25(	wb_dat8_i25	),
	.wb_dat_o25(	wb_dat8_o25	),
	.wb_we_i25(	we_o25		),
   .wb_re_i25(re_o25),
	.modem_inputs25(	{cts_pad_i25, dsr_pad_i25,
	ri_pad_i25,  dcd_pad_i25}	),
	.stx_pad_o25(		stx_pad_o25		),
	.srx_pad_i25(		srx_pad_i25		),
`ifdef DATA_BUS_WIDTH_825
`else
// debug25 interface signals25	enabled
.ier25(ier25), 
.iir25(iir25), 
.fcr25(fcr25), 
.mcr25(mcr25), 
.lcr25(lcr25), 
.msr25(msr25), 
.lsr25(lsr25), 
.rf_count25(rf_count25),
.tf_count25(tf_count25),
.tstate25(tstate25),
.rstate(rstate),
`endif					  
	.rts_pad_o25(		rts_pad_o25		),
	.dtr_pad_o25(		dtr_pad_o25		),
	.int_o25(		int_o25		)
`ifdef UART_HAS_BAUDRATE_OUTPUT25
	, .baud_o25(baud_o25)
`endif

);

`ifdef DATA_BUS_WIDTH_825
`else
uart_debug_if25 dbg25(/*AUTOINST25*/
						// Outputs25
						.wb_dat32_o25				 (wb_dat32_o25[31:0]),
						// Inputs25
						.wb_adr_i25				 (wb_adr_int25[`UART_ADDR_WIDTH25-1:0]),
						.ier25						 (ier25[3:0]),
						.iir25						 (iir25[3:0]),
						.fcr25						 (fcr25[1:0]),
						.mcr25						 (mcr25[4:0]),
						.lcr25						 (lcr25[7:0]),
						.msr25						 (msr25[7:0]),
						.lsr25						 (lsr25[7:0]),
						.rf_count25				 (rf_count25[`UART_FIFO_COUNTER_W25-1:0]),
						.tf_count25				 (tf_count25[`UART_FIFO_COUNTER_W25-1:0]),
						.tstate25					 (tstate25[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_825
		$display("(%m) UART25 INFO25: Data bus width is 8. No Debug25 interface.\n");
	`else
		$display("(%m) UART25 INFO25: Data bus width is 32. Debug25 Interface25 present25.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT25
		$display("(%m) UART25 INFO25: Has25 baudrate25 output\n");
	`else
		$display("(%m) UART25 INFO25: Doesn25't have baudrate25 output\n");
	`endif
end

endmodule


