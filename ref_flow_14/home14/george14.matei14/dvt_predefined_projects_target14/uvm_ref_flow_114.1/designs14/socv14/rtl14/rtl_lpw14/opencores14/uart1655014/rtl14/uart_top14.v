//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top14.v                                                  ////
////                                                              ////
////                                                              ////
////  This14 file is part of the "UART14 16550 compatible14" project14    ////
////  http14://www14.opencores14.org14/cores14/uart1655014/                   ////
////                                                              ////
////  Documentation14 related14 to this project14:                      ////
////  - http14://www14.opencores14.org14/cores14/uart1655014/                 ////
////                                                              ////
////  Projects14 compatibility14:                                     ////
////  - WISHBONE14                                                  ////
////  RS23214 Protocol14                                              ////
////  16550D uart14 (mostly14 supported)                              ////
////                                                              ////
////  Overview14 (main14 Features14):                                   ////
////  UART14 core14 top level.                                        ////
////                                                              ////
////  Known14 problems14 (limits14):                                    ////
////  Note14 that transmitter14 and receiver14 instances14 are inside     ////
////  the uart_regs14.v file.                                       ////
////                                                              ////
////  To14 Do14:                                                      ////
////  Nothing so far14.                                             ////
////                                                              ////
////  Author14(s):                                                  ////
////      - gorban14@opencores14.org14                                  ////
////      - Jacob14 Gorban14                                          ////
////      - Igor14 Mohor14 (igorm14@opencores14.org14)                      ////
////                                                              ////
////  Created14:        2001/05/12                                  ////
////  Last14 Updated14:   2001/05/17                                  ////
////                  (See log14 for the revision14 history14)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2000, 2001 Authors14                             ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS14 Revision14 History14
//
// $Log: not supported by cvs2svn14 $
// Revision14 1.18  2002/07/22 23:02:23  gorban14
// Bug14 Fixes14:
//  * Possible14 loss of sync and bad14 reception14 of stop bit on slow14 baud14 rates14 fixed14.
//   Problem14 reported14 by Kenny14.Tung14.
//  * Bad (or lack14 of ) loopback14 handling14 fixed14. Reported14 by Cherry14 Withers14.
//
// Improvements14:
//  * Made14 FIFO's as general14 inferrable14 memory where possible14.
//  So14 on FPGA14 they should be inferred14 as RAM14 (Distributed14 RAM14 on Xilinx14).
//  This14 saves14 about14 1/3 of the Slice14 count and reduces14 P&R and synthesis14 times.
//
//  * Added14 optional14 baudrate14 output (baud_o14).
//  This14 is identical14 to BAUDOUT14* signal14 on 16550 chip14.
//  It outputs14 16xbit_clock_rate - the divided14 clock14.
//  It's disabled by default. Define14 UART_HAS_BAUDRATE_OUTPUT14 to use.
//
// Revision14 1.17  2001/12/19 08:40:03  mohor14
// Warnings14 fixed14 (unused14 signals14 removed).
//
// Revision14 1.16  2001/12/06 14:51:04  gorban14
// Bug14 in LSR14[0] is fixed14.
// All WISHBONE14 signals14 are now sampled14, so another14 wait-state is introduced14 on all transfers14.
//
// Revision14 1.15  2001/12/03 21:44:29  gorban14
// Updated14 specification14 documentation.
// Added14 full 32-bit data bus interface, now as default.
// Address is 5-bit wide14 in 32-bit data bus mode.
// Added14 wb_sel_i14 input to the core14. It's used in the 32-bit mode.
// Added14 debug14 interface with two14 32-bit read-only registers in 32-bit mode.
// Bits14 5 and 6 of LSR14 are now only cleared14 on TX14 FIFO write.
// My14 small test bench14 is modified to work14 with 32-bit mode.
//
// Revision14 1.14  2001/11/07 17:51:52  gorban14
// Heavily14 rewritten14 interrupt14 and LSR14 subsystems14.
// Many14 bugs14 hopefully14 squashed14.
//
// Revision14 1.13  2001/10/20 09:58:40  gorban14
// Small14 synopsis14 fixes14
//
// Revision14 1.12  2001/08/25 15:46:19  gorban14
// Modified14 port names again14
//
// Revision14 1.11  2001/08/24 21:01:12  mohor14
// Things14 connected14 to parity14 changed.
// Clock14 devider14 changed.
//
// Revision14 1.10  2001/08/23 16:05:05  mohor14
// Stop bit bug14 fixed14.
// Parity14 bug14 fixed14.
// WISHBONE14 read cycle bug14 fixed14,
// OE14 indicator14 (Overrun14 Error) bug14 fixed14.
// PE14 indicator14 (Parity14 Error) bug14 fixed14.
// Register read bug14 fixed14.
//
// Revision14 1.4  2001/05/31 20:08:01  gorban14
// FIFO changes14 and other corrections14.
//
// Revision14 1.3  2001/05/21 19:12:02  gorban14
// Corrected14 some14 Linter14 messages14.
//
// Revision14 1.2  2001/05/17 18:34:18  gorban14
// First14 'stable' release. Should14 be sythesizable14 now. Also14 added new header.
//
// Revision14 1.0  2001-05-17 21:27:12+02  jacob14
// Initial14 revision14
//
//
// synopsys14 translate_off14
`include "timescale.v"
// synopsys14 translate_on14

`include "uart_defines14.v"

module uart_top14	(
	wb_clk_i14, 
	
	// Wishbone14 signals14
	wb_rst_i14, wb_adr_i14, wb_dat_i14, wb_dat_o14, wb_we_i14, wb_stb_i14, wb_cyc_i14, wb_ack_o14, wb_sel_i14,
	int_o14, // interrupt14 request

	// UART14	signals14
	// serial14 input/output
	stx_pad_o14, srx_pad_i14,

	// modem14 signals14
	rts_pad_o14, cts_pad_i14, dtr_pad_o14, dsr_pad_i14, ri_pad_i14, dcd_pad_i14
`ifdef UART_HAS_BAUDRATE_OUTPUT14
	, baud_o14
`endif
	);

parameter 							 uart_data_width14 = `UART_DATA_WIDTH14;
parameter 							 uart_addr_width14 = `UART_ADDR_WIDTH14;

input 								 wb_clk_i14;

// WISHBONE14 interface
input 								 wb_rst_i14;
input [uart_addr_width14-1:0] 	 wb_adr_i14;
input [uart_data_width14-1:0] 	 wb_dat_i14;
output [uart_data_width14-1:0] 	 wb_dat_o14;
input 								 wb_we_i14;
input 								 wb_stb_i14;
input 								 wb_cyc_i14;
input [3:0]							 wb_sel_i14;
output 								 wb_ack_o14;
output 								 int_o14;

// UART14	signals14
input 								 srx_pad_i14;
output 								 stx_pad_o14;
output 								 rts_pad_o14;
input 								 cts_pad_i14;
output 								 dtr_pad_o14;
input 								 dsr_pad_i14;
input 								 ri_pad_i14;
input 								 dcd_pad_i14;

// optional14 baudrate14 output
`ifdef UART_HAS_BAUDRATE_OUTPUT14
output	baud_o14;
`endif


wire 									 stx_pad_o14;
wire 									 rts_pad_o14;
wire 									 dtr_pad_o14;

wire [uart_addr_width14-1:0] 	 wb_adr_i14;
wire [uart_data_width14-1:0] 	 wb_dat_i14;
wire [uart_data_width14-1:0] 	 wb_dat_o14;

wire [7:0] 							 wb_dat8_i14; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o14; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o14; // debug14 interface 32-bit output
wire [3:0] 							 wb_sel_i14;  // WISHBONE14 select14 signal14
wire [uart_addr_width14-1:0] 	 wb_adr_int14;
wire 									 we_o14;	// Write enable for registers
wire		          	     re_o14;	// Read enable for registers
//
// MODULE14 INSTANCES14
//

`ifdef DATA_BUS_WIDTH_814
`else
// debug14 interface wires14
wire	[3:0] ier14;
wire	[3:0] iir14;
wire	[1:0] fcr14;
wire	[4:0] mcr14;
wire	[7:0] lcr14;
wire	[7:0] msr14;
wire	[7:0] lsr14;
wire	[`UART_FIFO_COUNTER_W14-1:0] rf_count14;
wire	[`UART_FIFO_COUNTER_W14-1:0] tf_count14;
wire	[2:0] tstate14;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_814
////  WISHBONE14 interface module
uart_wb14		wb_interface14(
		.clk14(		wb_clk_i14		),
		.wb_rst_i14(	wb_rst_i14	),
	.wb_dat_i14(wb_dat_i14),
	.wb_dat_o14(wb_dat_o14),
	.wb_dat8_i14(wb_dat8_i14),
	.wb_dat8_o14(wb_dat8_o14),
	 .wb_dat32_o14(32'b0),								 
	 .wb_sel_i14(4'b0),
		.wb_we_i14(	wb_we_i14		),
		.wb_stb_i14(	wb_stb_i14	),
		.wb_cyc_i14(	wb_cyc_i14	),
		.wb_ack_o14(	wb_ack_o14	),
	.wb_adr_i14(wb_adr_i14),
	.wb_adr_int14(wb_adr_int14),
		.we_o14(		we_o14		),
		.re_o14(re_o14)
		);
`else
uart_wb14		wb_interface14(
		.clk14(		wb_clk_i14		),
		.wb_rst_i14(	wb_rst_i14	),
	.wb_dat_i14(wb_dat_i14),
	.wb_dat_o14(wb_dat_o14),
	.wb_dat8_i14(wb_dat8_i14),
	.wb_dat8_o14(wb_dat8_o14),
	 .wb_sel_i14(wb_sel_i14),
	 .wb_dat32_o14(wb_dat32_o14),								 
		.wb_we_i14(	wb_we_i14		),
		.wb_stb_i14(	wb_stb_i14	),
		.wb_cyc_i14(	wb_cyc_i14	),
		.wb_ack_o14(	wb_ack_o14	),
	.wb_adr_i14(wb_adr_i14),
	.wb_adr_int14(wb_adr_int14),
		.we_o14(		we_o14		),
		.re_o14(re_o14)
		);
`endif

// Registers14
uart_regs14	regs(
	.clk14(		wb_clk_i14		),
	.wb_rst_i14(	wb_rst_i14	),
	.wb_addr_i14(	wb_adr_int14	),
	.wb_dat_i14(	wb_dat8_i14	),
	.wb_dat_o14(	wb_dat8_o14	),
	.wb_we_i14(	we_o14		),
   .wb_re_i14(re_o14),
	.modem_inputs14(	{cts_pad_i14, dsr_pad_i14,
	ri_pad_i14,  dcd_pad_i14}	),
	.stx_pad_o14(		stx_pad_o14		),
	.srx_pad_i14(		srx_pad_i14		),
`ifdef DATA_BUS_WIDTH_814
`else
// debug14 interface signals14	enabled
.ier14(ier14), 
.iir14(iir14), 
.fcr14(fcr14), 
.mcr14(mcr14), 
.lcr14(lcr14), 
.msr14(msr14), 
.lsr14(lsr14), 
.rf_count14(rf_count14),
.tf_count14(tf_count14),
.tstate14(tstate14),
.rstate(rstate),
`endif					  
	.rts_pad_o14(		rts_pad_o14		),
	.dtr_pad_o14(		dtr_pad_o14		),
	.int_o14(		int_o14		)
`ifdef UART_HAS_BAUDRATE_OUTPUT14
	, .baud_o14(baud_o14)
`endif

);

`ifdef DATA_BUS_WIDTH_814
`else
uart_debug_if14 dbg14(/*AUTOINST14*/
						// Outputs14
						.wb_dat32_o14				 (wb_dat32_o14[31:0]),
						// Inputs14
						.wb_adr_i14				 (wb_adr_int14[`UART_ADDR_WIDTH14-1:0]),
						.ier14						 (ier14[3:0]),
						.iir14						 (iir14[3:0]),
						.fcr14						 (fcr14[1:0]),
						.mcr14						 (mcr14[4:0]),
						.lcr14						 (lcr14[7:0]),
						.msr14						 (msr14[7:0]),
						.lsr14						 (lsr14[7:0]),
						.rf_count14				 (rf_count14[`UART_FIFO_COUNTER_W14-1:0]),
						.tf_count14				 (tf_count14[`UART_FIFO_COUNTER_W14-1:0]),
						.tstate14					 (tstate14[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_814
		$display("(%m) UART14 INFO14: Data bus width is 8. No Debug14 interface.\n");
	`else
		$display("(%m) UART14 INFO14: Data bus width is 32. Debug14 Interface14 present14.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT14
		$display("(%m) UART14 INFO14: Has14 baudrate14 output\n");
	`else
		$display("(%m) UART14 INFO14: Doesn14't have baudrate14 output\n");
	`endif
end

endmodule


