//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top1.v                                                  ////
////                                                              ////
////                                                              ////
////  This1 file is part of the "UART1 16550 compatible1" project1    ////
////  http1://www1.opencores1.org1/cores1/uart165501/                   ////
////                                                              ////
////  Documentation1 related1 to this project1:                      ////
////  - http1://www1.opencores1.org1/cores1/uart165501/                 ////
////                                                              ////
////  Projects1 compatibility1:                                     ////
////  - WISHBONE1                                                  ////
////  RS2321 Protocol1                                              ////
////  16550D uart1 (mostly1 supported)                              ////
////                                                              ////
////  Overview1 (main1 Features1):                                   ////
////  UART1 core1 top level.                                        ////
////                                                              ////
////  Known1 problems1 (limits1):                                    ////
////  Note1 that transmitter1 and receiver1 instances1 are inside     ////
////  the uart_regs1.v file.                                       ////
////                                                              ////
////  To1 Do1:                                                      ////
////  Nothing so far1.                                             ////
////                                                              ////
////  Author1(s):                                                  ////
////      - gorban1@opencores1.org1                                  ////
////      - Jacob1 Gorban1                                          ////
////      - Igor1 Mohor1 (igorm1@opencores1.org1)                      ////
////                                                              ////
////  Created1:        2001/05/12                                  ////
////  Last1 Updated1:   2001/05/17                                  ////
////                  (See log1 for the revision1 history1)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright1 (C) 2000, 2001 Authors1                             ////
////                                                              ////
//// This1 source1 file may be used and distributed1 without         ////
//// restriction1 provided that this copyright1 statement1 is not    ////
//// removed from the file and that any derivative1 work1 contains1  ////
//// the original copyright1 notice1 and the associated disclaimer1. ////
////                                                              ////
//// This1 source1 file is free software1; you can redistribute1 it   ////
//// and/or modify it under the terms1 of the GNU1 Lesser1 General1   ////
//// Public1 License1 as published1 by the Free1 Software1 Foundation1; ////
//// either1 version1 2.1 of the License1, or (at your1 option) any   ////
//// later1 version1.                                               ////
////                                                              ////
//// This1 source1 is distributed1 in the hope1 that it will be       ////
//// useful1, but WITHOUT1 ANY1 WARRANTY1; without even1 the implied1   ////
//// warranty1 of MERCHANTABILITY1 or FITNESS1 FOR1 A PARTICULAR1      ////
//// PURPOSE1.  See the GNU1 Lesser1 General1 Public1 License1 for more ////
//// details1.                                                     ////
////                                                              ////
//// You should have received1 a copy of the GNU1 Lesser1 General1    ////
//// Public1 License1 along1 with this source1; if not, download1 it   ////
//// from http1://www1.opencores1.org1/lgpl1.shtml1                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS1 Revision1 History1
//
// $Log: not supported by cvs2svn1 $
// Revision1 1.18  2002/07/22 23:02:23  gorban1
// Bug1 Fixes1:
//  * Possible1 loss of sync and bad1 reception1 of stop bit on slow1 baud1 rates1 fixed1.
//   Problem1 reported1 by Kenny1.Tung1.
//  * Bad (or lack1 of ) loopback1 handling1 fixed1. Reported1 by Cherry1 Withers1.
//
// Improvements1:
//  * Made1 FIFO's as general1 inferrable1 memory where possible1.
//  So1 on FPGA1 they should be inferred1 as RAM1 (Distributed1 RAM1 on Xilinx1).
//  This1 saves1 about1 1/3 of the Slice1 count and reduces1 P&R and synthesis1 times.
//
//  * Added1 optional1 baudrate1 output (baud_o1).
//  This1 is identical1 to BAUDOUT1* signal1 on 16550 chip1.
//  It outputs1 16xbit_clock_rate - the divided1 clock1.
//  It's disabled by default. Define1 UART_HAS_BAUDRATE_OUTPUT1 to use.
//
// Revision1 1.17  2001/12/19 08:40:03  mohor1
// Warnings1 fixed1 (unused1 signals1 removed).
//
// Revision1 1.16  2001/12/06 14:51:04  gorban1
// Bug1 in LSR1[0] is fixed1.
// All WISHBONE1 signals1 are now sampled1, so another1 wait-state is introduced1 on all transfers1.
//
// Revision1 1.15  2001/12/03 21:44:29  gorban1
// Updated1 specification1 documentation.
// Added1 full 32-bit data bus interface, now as default.
// Address is 5-bit wide1 in 32-bit data bus mode.
// Added1 wb_sel_i1 input to the core1. It's used in the 32-bit mode.
// Added1 debug1 interface with two1 32-bit read-only registers in 32-bit mode.
// Bits1 5 and 6 of LSR1 are now only cleared1 on TX1 FIFO write.
// My1 small test bench1 is modified to work1 with 32-bit mode.
//
// Revision1 1.14  2001/11/07 17:51:52  gorban1
// Heavily1 rewritten1 interrupt1 and LSR1 subsystems1.
// Many1 bugs1 hopefully1 squashed1.
//
// Revision1 1.13  2001/10/20 09:58:40  gorban1
// Small1 synopsis1 fixes1
//
// Revision1 1.12  2001/08/25 15:46:19  gorban1
// Modified1 port names again1
//
// Revision1 1.11  2001/08/24 21:01:12  mohor1
// Things1 connected1 to parity1 changed.
// Clock1 devider1 changed.
//
// Revision1 1.10  2001/08/23 16:05:05  mohor1
// Stop bit bug1 fixed1.
// Parity1 bug1 fixed1.
// WISHBONE1 read cycle bug1 fixed1,
// OE1 indicator1 (Overrun1 Error) bug1 fixed1.
// PE1 indicator1 (Parity1 Error) bug1 fixed1.
// Register read bug1 fixed1.
//
// Revision1 1.4  2001/05/31 20:08:01  gorban1
// FIFO changes1 and other corrections1.
//
// Revision1 1.3  2001/05/21 19:12:02  gorban1
// Corrected1 some1 Linter1 messages1.
//
// Revision1 1.2  2001/05/17 18:34:18  gorban1
// First1 'stable' release. Should1 be sythesizable1 now. Also1 added new header.
//
// Revision1 1.0  2001-05-17 21:27:12+02  jacob1
// Initial1 revision1
//
//
// synopsys1 translate_off1
`include "timescale.v"
// synopsys1 translate_on1

`include "uart_defines1.v"

module uart_top1	(
	wb_clk_i1, 
	
	// Wishbone1 signals1
	wb_rst_i1, wb_adr_i1, wb_dat_i1, wb_dat_o1, wb_we_i1, wb_stb_i1, wb_cyc_i1, wb_ack_o1, wb_sel_i1,
	int_o1, // interrupt1 request

	// UART1	signals1
	// serial1 input/output
	stx_pad_o1, srx_pad_i1,

	// modem1 signals1
	rts_pad_o1, cts_pad_i1, dtr_pad_o1, dsr_pad_i1, ri_pad_i1, dcd_pad_i1
`ifdef UART_HAS_BAUDRATE_OUTPUT1
	, baud_o1
`endif
	);

parameter 							 uart_data_width1 = `UART_DATA_WIDTH1;
parameter 							 uart_addr_width1 = `UART_ADDR_WIDTH1;

input 								 wb_clk_i1;

// WISHBONE1 interface
input 								 wb_rst_i1;
input [uart_addr_width1-1:0] 	 wb_adr_i1;
input [uart_data_width1-1:0] 	 wb_dat_i1;
output [uart_data_width1-1:0] 	 wb_dat_o1;
input 								 wb_we_i1;
input 								 wb_stb_i1;
input 								 wb_cyc_i1;
input [3:0]							 wb_sel_i1;
output 								 wb_ack_o1;
output 								 int_o1;

// UART1	signals1
input 								 srx_pad_i1;
output 								 stx_pad_o1;
output 								 rts_pad_o1;
input 								 cts_pad_i1;
output 								 dtr_pad_o1;
input 								 dsr_pad_i1;
input 								 ri_pad_i1;
input 								 dcd_pad_i1;

// optional1 baudrate1 output
`ifdef UART_HAS_BAUDRATE_OUTPUT1
output	baud_o1;
`endif


wire 									 stx_pad_o1;
wire 									 rts_pad_o1;
wire 									 dtr_pad_o1;

wire [uart_addr_width1-1:0] 	 wb_adr_i1;
wire [uart_data_width1-1:0] 	 wb_dat_i1;
wire [uart_data_width1-1:0] 	 wb_dat_o1;

wire [7:0] 							 wb_dat8_i1; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o1; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o1; // debug1 interface 32-bit output
wire [3:0] 							 wb_sel_i1;  // WISHBONE1 select1 signal1
wire [uart_addr_width1-1:0] 	 wb_adr_int1;
wire 									 we_o1;	// Write enable for registers
wire		          	     re_o1;	// Read enable for registers
//
// MODULE1 INSTANCES1
//

`ifdef DATA_BUS_WIDTH_81
`else
// debug1 interface wires1
wire	[3:0] ier1;
wire	[3:0] iir1;
wire	[1:0] fcr1;
wire	[4:0] mcr1;
wire	[7:0] lcr1;
wire	[7:0] msr1;
wire	[7:0] lsr1;
wire	[`UART_FIFO_COUNTER_W1-1:0] rf_count1;
wire	[`UART_FIFO_COUNTER_W1-1:0] tf_count1;
wire	[2:0] tstate1;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_81
////  WISHBONE1 interface module
uart_wb1		wb_interface1(
		.clk1(		wb_clk_i1		),
		.wb_rst_i1(	wb_rst_i1	),
	.wb_dat_i1(wb_dat_i1),
	.wb_dat_o1(wb_dat_o1),
	.wb_dat8_i1(wb_dat8_i1),
	.wb_dat8_o1(wb_dat8_o1),
	 .wb_dat32_o1(32'b0),								 
	 .wb_sel_i1(4'b0),
		.wb_we_i1(	wb_we_i1		),
		.wb_stb_i1(	wb_stb_i1	),
		.wb_cyc_i1(	wb_cyc_i1	),
		.wb_ack_o1(	wb_ack_o1	),
	.wb_adr_i1(wb_adr_i1),
	.wb_adr_int1(wb_adr_int1),
		.we_o1(		we_o1		),
		.re_o1(re_o1)
		);
`else
uart_wb1		wb_interface1(
		.clk1(		wb_clk_i1		),
		.wb_rst_i1(	wb_rst_i1	),
	.wb_dat_i1(wb_dat_i1),
	.wb_dat_o1(wb_dat_o1),
	.wb_dat8_i1(wb_dat8_i1),
	.wb_dat8_o1(wb_dat8_o1),
	 .wb_sel_i1(wb_sel_i1),
	 .wb_dat32_o1(wb_dat32_o1),								 
		.wb_we_i1(	wb_we_i1		),
		.wb_stb_i1(	wb_stb_i1	),
		.wb_cyc_i1(	wb_cyc_i1	),
		.wb_ack_o1(	wb_ack_o1	),
	.wb_adr_i1(wb_adr_i1),
	.wb_adr_int1(wb_adr_int1),
		.we_o1(		we_o1		),
		.re_o1(re_o1)
		);
`endif

// Registers1
uart_regs1	regs(
	.clk1(		wb_clk_i1		),
	.wb_rst_i1(	wb_rst_i1	),
	.wb_addr_i1(	wb_adr_int1	),
	.wb_dat_i1(	wb_dat8_i1	),
	.wb_dat_o1(	wb_dat8_o1	),
	.wb_we_i1(	we_o1		),
   .wb_re_i1(re_o1),
	.modem_inputs1(	{cts_pad_i1, dsr_pad_i1,
	ri_pad_i1,  dcd_pad_i1}	),
	.stx_pad_o1(		stx_pad_o1		),
	.srx_pad_i1(		srx_pad_i1		),
`ifdef DATA_BUS_WIDTH_81
`else
// debug1 interface signals1	enabled
.ier1(ier1), 
.iir1(iir1), 
.fcr1(fcr1), 
.mcr1(mcr1), 
.lcr1(lcr1), 
.msr1(msr1), 
.lsr1(lsr1), 
.rf_count1(rf_count1),
.tf_count1(tf_count1),
.tstate1(tstate1),
.rstate(rstate),
`endif					  
	.rts_pad_o1(		rts_pad_o1		),
	.dtr_pad_o1(		dtr_pad_o1		),
	.int_o1(		int_o1		)
`ifdef UART_HAS_BAUDRATE_OUTPUT1
	, .baud_o1(baud_o1)
`endif

);

`ifdef DATA_BUS_WIDTH_81
`else
uart_debug_if1 dbg1(/*AUTOINST1*/
						// Outputs1
						.wb_dat32_o1				 (wb_dat32_o1[31:0]),
						// Inputs1
						.wb_adr_i1				 (wb_adr_int1[`UART_ADDR_WIDTH1-1:0]),
						.ier1						 (ier1[3:0]),
						.iir1						 (iir1[3:0]),
						.fcr1						 (fcr1[1:0]),
						.mcr1						 (mcr1[4:0]),
						.lcr1						 (lcr1[7:0]),
						.msr1						 (msr1[7:0]),
						.lsr1						 (lsr1[7:0]),
						.rf_count1				 (rf_count1[`UART_FIFO_COUNTER_W1-1:0]),
						.tf_count1				 (tf_count1[`UART_FIFO_COUNTER_W1-1:0]),
						.tstate1					 (tstate1[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_81
		$display("(%m) UART1 INFO1: Data bus width is 8. No Debug1 interface.\n");
	`else
		$display("(%m) UART1 INFO1: Data bus width is 32. Debug1 Interface1 present1.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT1
		$display("(%m) UART1 INFO1: Has1 baudrate1 output\n");
	`else
		$display("(%m) UART1 INFO1: Doesn1't have baudrate1 output\n");
	`endif
end

endmodule


