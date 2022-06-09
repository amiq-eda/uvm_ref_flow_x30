//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top4.v                                                  ////
////                                                              ////
////                                                              ////
////  This4 file is part of the "UART4 16550 compatible4" project4    ////
////  http4://www4.opencores4.org4/cores4/uart165504/                   ////
////                                                              ////
////  Documentation4 related4 to this project4:                      ////
////  - http4://www4.opencores4.org4/cores4/uart165504/                 ////
////                                                              ////
////  Projects4 compatibility4:                                     ////
////  - WISHBONE4                                                  ////
////  RS2324 Protocol4                                              ////
////  16550D uart4 (mostly4 supported)                              ////
////                                                              ////
////  Overview4 (main4 Features4):                                   ////
////  UART4 core4 top level.                                        ////
////                                                              ////
////  Known4 problems4 (limits4):                                    ////
////  Note4 that transmitter4 and receiver4 instances4 are inside     ////
////  the uart_regs4.v file.                                       ////
////                                                              ////
////  To4 Do4:                                                      ////
////  Nothing so far4.                                             ////
////                                                              ////
////  Author4(s):                                                  ////
////      - gorban4@opencores4.org4                                  ////
////      - Jacob4 Gorban4                                          ////
////      - Igor4 Mohor4 (igorm4@opencores4.org4)                      ////
////                                                              ////
////  Created4:        2001/05/12                                  ////
////  Last4 Updated4:   2001/05/17                                  ////
////                  (See log4 for the revision4 history4)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2000, 2001 Authors4                             ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS4 Revision4 History4
//
// $Log: not supported by cvs2svn4 $
// Revision4 1.18  2002/07/22 23:02:23  gorban4
// Bug4 Fixes4:
//  * Possible4 loss of sync and bad4 reception4 of stop bit on slow4 baud4 rates4 fixed4.
//   Problem4 reported4 by Kenny4.Tung4.
//  * Bad (or lack4 of ) loopback4 handling4 fixed4. Reported4 by Cherry4 Withers4.
//
// Improvements4:
//  * Made4 FIFO's as general4 inferrable4 memory where possible4.
//  So4 on FPGA4 they should be inferred4 as RAM4 (Distributed4 RAM4 on Xilinx4).
//  This4 saves4 about4 1/3 of the Slice4 count and reduces4 P&R and synthesis4 times.
//
//  * Added4 optional4 baudrate4 output (baud_o4).
//  This4 is identical4 to BAUDOUT4* signal4 on 16550 chip4.
//  It outputs4 16xbit_clock_rate - the divided4 clock4.
//  It's disabled by default. Define4 UART_HAS_BAUDRATE_OUTPUT4 to use.
//
// Revision4 1.17  2001/12/19 08:40:03  mohor4
// Warnings4 fixed4 (unused4 signals4 removed).
//
// Revision4 1.16  2001/12/06 14:51:04  gorban4
// Bug4 in LSR4[0] is fixed4.
// All WISHBONE4 signals4 are now sampled4, so another4 wait-state is introduced4 on all transfers4.
//
// Revision4 1.15  2001/12/03 21:44:29  gorban4
// Updated4 specification4 documentation.
// Added4 full 32-bit data bus interface, now as default.
// Address is 5-bit wide4 in 32-bit data bus mode.
// Added4 wb_sel_i4 input to the core4. It's used in the 32-bit mode.
// Added4 debug4 interface with two4 32-bit read-only registers in 32-bit mode.
// Bits4 5 and 6 of LSR4 are now only cleared4 on TX4 FIFO write.
// My4 small test bench4 is modified to work4 with 32-bit mode.
//
// Revision4 1.14  2001/11/07 17:51:52  gorban4
// Heavily4 rewritten4 interrupt4 and LSR4 subsystems4.
// Many4 bugs4 hopefully4 squashed4.
//
// Revision4 1.13  2001/10/20 09:58:40  gorban4
// Small4 synopsis4 fixes4
//
// Revision4 1.12  2001/08/25 15:46:19  gorban4
// Modified4 port names again4
//
// Revision4 1.11  2001/08/24 21:01:12  mohor4
// Things4 connected4 to parity4 changed.
// Clock4 devider4 changed.
//
// Revision4 1.10  2001/08/23 16:05:05  mohor4
// Stop bit bug4 fixed4.
// Parity4 bug4 fixed4.
// WISHBONE4 read cycle bug4 fixed4,
// OE4 indicator4 (Overrun4 Error) bug4 fixed4.
// PE4 indicator4 (Parity4 Error) bug4 fixed4.
// Register read bug4 fixed4.
//
// Revision4 1.4  2001/05/31 20:08:01  gorban4
// FIFO changes4 and other corrections4.
//
// Revision4 1.3  2001/05/21 19:12:02  gorban4
// Corrected4 some4 Linter4 messages4.
//
// Revision4 1.2  2001/05/17 18:34:18  gorban4
// First4 'stable' release. Should4 be sythesizable4 now. Also4 added new header.
//
// Revision4 1.0  2001-05-17 21:27:12+02  jacob4
// Initial4 revision4
//
//
// synopsys4 translate_off4
`include "timescale.v"
// synopsys4 translate_on4

`include "uart_defines4.v"

module uart_top4	(
	wb_clk_i4, 
	
	// Wishbone4 signals4
	wb_rst_i4, wb_adr_i4, wb_dat_i4, wb_dat_o4, wb_we_i4, wb_stb_i4, wb_cyc_i4, wb_ack_o4, wb_sel_i4,
	int_o4, // interrupt4 request

	// UART4	signals4
	// serial4 input/output
	stx_pad_o4, srx_pad_i4,

	// modem4 signals4
	rts_pad_o4, cts_pad_i4, dtr_pad_o4, dsr_pad_i4, ri_pad_i4, dcd_pad_i4
`ifdef UART_HAS_BAUDRATE_OUTPUT4
	, baud_o4
`endif
	);

parameter 							 uart_data_width4 = `UART_DATA_WIDTH4;
parameter 							 uart_addr_width4 = `UART_ADDR_WIDTH4;

input 								 wb_clk_i4;

// WISHBONE4 interface
input 								 wb_rst_i4;
input [uart_addr_width4-1:0] 	 wb_adr_i4;
input [uart_data_width4-1:0] 	 wb_dat_i4;
output [uart_data_width4-1:0] 	 wb_dat_o4;
input 								 wb_we_i4;
input 								 wb_stb_i4;
input 								 wb_cyc_i4;
input [3:0]							 wb_sel_i4;
output 								 wb_ack_o4;
output 								 int_o4;

// UART4	signals4
input 								 srx_pad_i4;
output 								 stx_pad_o4;
output 								 rts_pad_o4;
input 								 cts_pad_i4;
output 								 dtr_pad_o4;
input 								 dsr_pad_i4;
input 								 ri_pad_i4;
input 								 dcd_pad_i4;

// optional4 baudrate4 output
`ifdef UART_HAS_BAUDRATE_OUTPUT4
output	baud_o4;
`endif


wire 									 stx_pad_o4;
wire 									 rts_pad_o4;
wire 									 dtr_pad_o4;

wire [uart_addr_width4-1:0] 	 wb_adr_i4;
wire [uart_data_width4-1:0] 	 wb_dat_i4;
wire [uart_data_width4-1:0] 	 wb_dat_o4;

wire [7:0] 							 wb_dat8_i4; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o4; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o4; // debug4 interface 32-bit output
wire [3:0] 							 wb_sel_i4;  // WISHBONE4 select4 signal4
wire [uart_addr_width4-1:0] 	 wb_adr_int4;
wire 									 we_o4;	// Write enable for registers
wire		          	     re_o4;	// Read enable for registers
//
// MODULE4 INSTANCES4
//

`ifdef DATA_BUS_WIDTH_84
`else
// debug4 interface wires4
wire	[3:0] ier4;
wire	[3:0] iir4;
wire	[1:0] fcr4;
wire	[4:0] mcr4;
wire	[7:0] lcr4;
wire	[7:0] msr4;
wire	[7:0] lsr4;
wire	[`UART_FIFO_COUNTER_W4-1:0] rf_count4;
wire	[`UART_FIFO_COUNTER_W4-1:0] tf_count4;
wire	[2:0] tstate4;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_84
////  WISHBONE4 interface module
uart_wb4		wb_interface4(
		.clk4(		wb_clk_i4		),
		.wb_rst_i4(	wb_rst_i4	),
	.wb_dat_i4(wb_dat_i4),
	.wb_dat_o4(wb_dat_o4),
	.wb_dat8_i4(wb_dat8_i4),
	.wb_dat8_o4(wb_dat8_o4),
	 .wb_dat32_o4(32'b0),								 
	 .wb_sel_i4(4'b0),
		.wb_we_i4(	wb_we_i4		),
		.wb_stb_i4(	wb_stb_i4	),
		.wb_cyc_i4(	wb_cyc_i4	),
		.wb_ack_o4(	wb_ack_o4	),
	.wb_adr_i4(wb_adr_i4),
	.wb_adr_int4(wb_adr_int4),
		.we_o4(		we_o4		),
		.re_o4(re_o4)
		);
`else
uart_wb4		wb_interface4(
		.clk4(		wb_clk_i4		),
		.wb_rst_i4(	wb_rst_i4	),
	.wb_dat_i4(wb_dat_i4),
	.wb_dat_o4(wb_dat_o4),
	.wb_dat8_i4(wb_dat8_i4),
	.wb_dat8_o4(wb_dat8_o4),
	 .wb_sel_i4(wb_sel_i4),
	 .wb_dat32_o4(wb_dat32_o4),								 
		.wb_we_i4(	wb_we_i4		),
		.wb_stb_i4(	wb_stb_i4	),
		.wb_cyc_i4(	wb_cyc_i4	),
		.wb_ack_o4(	wb_ack_o4	),
	.wb_adr_i4(wb_adr_i4),
	.wb_adr_int4(wb_adr_int4),
		.we_o4(		we_o4		),
		.re_o4(re_o4)
		);
`endif

// Registers4
uart_regs4	regs(
	.clk4(		wb_clk_i4		),
	.wb_rst_i4(	wb_rst_i4	),
	.wb_addr_i4(	wb_adr_int4	),
	.wb_dat_i4(	wb_dat8_i4	),
	.wb_dat_o4(	wb_dat8_o4	),
	.wb_we_i4(	we_o4		),
   .wb_re_i4(re_o4),
	.modem_inputs4(	{cts_pad_i4, dsr_pad_i4,
	ri_pad_i4,  dcd_pad_i4}	),
	.stx_pad_o4(		stx_pad_o4		),
	.srx_pad_i4(		srx_pad_i4		),
`ifdef DATA_BUS_WIDTH_84
`else
// debug4 interface signals4	enabled
.ier4(ier4), 
.iir4(iir4), 
.fcr4(fcr4), 
.mcr4(mcr4), 
.lcr4(lcr4), 
.msr4(msr4), 
.lsr4(lsr4), 
.rf_count4(rf_count4),
.tf_count4(tf_count4),
.tstate4(tstate4),
.rstate(rstate),
`endif					  
	.rts_pad_o4(		rts_pad_o4		),
	.dtr_pad_o4(		dtr_pad_o4		),
	.int_o4(		int_o4		)
`ifdef UART_HAS_BAUDRATE_OUTPUT4
	, .baud_o4(baud_o4)
`endif

);

`ifdef DATA_BUS_WIDTH_84
`else
uart_debug_if4 dbg4(/*AUTOINST4*/
						// Outputs4
						.wb_dat32_o4				 (wb_dat32_o4[31:0]),
						// Inputs4
						.wb_adr_i4				 (wb_adr_int4[`UART_ADDR_WIDTH4-1:0]),
						.ier4						 (ier4[3:0]),
						.iir4						 (iir4[3:0]),
						.fcr4						 (fcr4[1:0]),
						.mcr4						 (mcr4[4:0]),
						.lcr4						 (lcr4[7:0]),
						.msr4						 (msr4[7:0]),
						.lsr4						 (lsr4[7:0]),
						.rf_count4				 (rf_count4[`UART_FIFO_COUNTER_W4-1:0]),
						.tf_count4				 (tf_count4[`UART_FIFO_COUNTER_W4-1:0]),
						.tstate4					 (tstate4[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_84
		$display("(%m) UART4 INFO4: Data bus width is 8. No Debug4 interface.\n");
	`else
		$display("(%m) UART4 INFO4: Data bus width is 32. Debug4 Interface4 present4.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT4
		$display("(%m) UART4 INFO4: Has4 baudrate4 output\n");
	`else
		$display("(%m) UART4 INFO4: Doesn4't have baudrate4 output\n");
	`endif
end

endmodule


