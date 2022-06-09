//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top29.v                                                  ////
////                                                              ////
////                                                              ////
////  This29 file is part of the "UART29 16550 compatible29" project29    ////
////  http29://www29.opencores29.org29/cores29/uart1655029/                   ////
////                                                              ////
////  Documentation29 related29 to this project29:                      ////
////  - http29://www29.opencores29.org29/cores29/uart1655029/                 ////
////                                                              ////
////  Projects29 compatibility29:                                     ////
////  - WISHBONE29                                                  ////
////  RS23229 Protocol29                                              ////
////  16550D uart29 (mostly29 supported)                              ////
////                                                              ////
////  Overview29 (main29 Features29):                                   ////
////  UART29 core29 top level.                                        ////
////                                                              ////
////  Known29 problems29 (limits29):                                    ////
////  Note29 that transmitter29 and receiver29 instances29 are inside     ////
////  the uart_regs29.v file.                                       ////
////                                                              ////
////  To29 Do29:                                                      ////
////  Nothing so far29.                                             ////
////                                                              ////
////  Author29(s):                                                  ////
////      - gorban29@opencores29.org29                                  ////
////      - Jacob29 Gorban29                                          ////
////      - Igor29 Mohor29 (igorm29@opencores29.org29)                      ////
////                                                              ////
////  Created29:        2001/05/12                                  ////
////  Last29 Updated29:   2001/05/17                                  ////
////                  (See log29 for the revision29 history29)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2000, 2001 Authors29                             ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS29 Revision29 History29
//
// $Log: not supported by cvs2svn29 $
// Revision29 1.18  2002/07/22 23:02:23  gorban29
// Bug29 Fixes29:
//  * Possible29 loss of sync and bad29 reception29 of stop bit on slow29 baud29 rates29 fixed29.
//   Problem29 reported29 by Kenny29.Tung29.
//  * Bad (or lack29 of ) loopback29 handling29 fixed29. Reported29 by Cherry29 Withers29.
//
// Improvements29:
//  * Made29 FIFO's as general29 inferrable29 memory where possible29.
//  So29 on FPGA29 they should be inferred29 as RAM29 (Distributed29 RAM29 on Xilinx29).
//  This29 saves29 about29 1/3 of the Slice29 count and reduces29 P&R and synthesis29 times.
//
//  * Added29 optional29 baudrate29 output (baud_o29).
//  This29 is identical29 to BAUDOUT29* signal29 on 16550 chip29.
//  It outputs29 16xbit_clock_rate - the divided29 clock29.
//  It's disabled by default. Define29 UART_HAS_BAUDRATE_OUTPUT29 to use.
//
// Revision29 1.17  2001/12/19 08:40:03  mohor29
// Warnings29 fixed29 (unused29 signals29 removed).
//
// Revision29 1.16  2001/12/06 14:51:04  gorban29
// Bug29 in LSR29[0] is fixed29.
// All WISHBONE29 signals29 are now sampled29, so another29 wait-state is introduced29 on all transfers29.
//
// Revision29 1.15  2001/12/03 21:44:29  gorban29
// Updated29 specification29 documentation.
// Added29 full 32-bit data bus interface, now as default.
// Address is 5-bit wide29 in 32-bit data bus mode.
// Added29 wb_sel_i29 input to the core29. It's used in the 32-bit mode.
// Added29 debug29 interface with two29 32-bit read-only registers in 32-bit mode.
// Bits29 5 and 6 of LSR29 are now only cleared29 on TX29 FIFO write.
// My29 small test bench29 is modified to work29 with 32-bit mode.
//
// Revision29 1.14  2001/11/07 17:51:52  gorban29
// Heavily29 rewritten29 interrupt29 and LSR29 subsystems29.
// Many29 bugs29 hopefully29 squashed29.
//
// Revision29 1.13  2001/10/20 09:58:40  gorban29
// Small29 synopsis29 fixes29
//
// Revision29 1.12  2001/08/25 15:46:19  gorban29
// Modified29 port names again29
//
// Revision29 1.11  2001/08/24 21:01:12  mohor29
// Things29 connected29 to parity29 changed.
// Clock29 devider29 changed.
//
// Revision29 1.10  2001/08/23 16:05:05  mohor29
// Stop bit bug29 fixed29.
// Parity29 bug29 fixed29.
// WISHBONE29 read cycle bug29 fixed29,
// OE29 indicator29 (Overrun29 Error) bug29 fixed29.
// PE29 indicator29 (Parity29 Error) bug29 fixed29.
// Register read bug29 fixed29.
//
// Revision29 1.4  2001/05/31 20:08:01  gorban29
// FIFO changes29 and other corrections29.
//
// Revision29 1.3  2001/05/21 19:12:02  gorban29
// Corrected29 some29 Linter29 messages29.
//
// Revision29 1.2  2001/05/17 18:34:18  gorban29
// First29 'stable' release. Should29 be sythesizable29 now. Also29 added new header.
//
// Revision29 1.0  2001-05-17 21:27:12+02  jacob29
// Initial29 revision29
//
//
// synopsys29 translate_off29
`include "timescale.v"
// synopsys29 translate_on29

`include "uart_defines29.v"

module uart_top29	(
	wb_clk_i29, 
	
	// Wishbone29 signals29
	wb_rst_i29, wb_adr_i29, wb_dat_i29, wb_dat_o29, wb_we_i29, wb_stb_i29, wb_cyc_i29, wb_ack_o29, wb_sel_i29,
	int_o29, // interrupt29 request

	// UART29	signals29
	// serial29 input/output
	stx_pad_o29, srx_pad_i29,

	// modem29 signals29
	rts_pad_o29, cts_pad_i29, dtr_pad_o29, dsr_pad_i29, ri_pad_i29, dcd_pad_i29
`ifdef UART_HAS_BAUDRATE_OUTPUT29
	, baud_o29
`endif
	);

parameter 							 uart_data_width29 = `UART_DATA_WIDTH29;
parameter 							 uart_addr_width29 = `UART_ADDR_WIDTH29;

input 								 wb_clk_i29;

// WISHBONE29 interface
input 								 wb_rst_i29;
input [uart_addr_width29-1:0] 	 wb_adr_i29;
input [uart_data_width29-1:0] 	 wb_dat_i29;
output [uart_data_width29-1:0] 	 wb_dat_o29;
input 								 wb_we_i29;
input 								 wb_stb_i29;
input 								 wb_cyc_i29;
input [3:0]							 wb_sel_i29;
output 								 wb_ack_o29;
output 								 int_o29;

// UART29	signals29
input 								 srx_pad_i29;
output 								 stx_pad_o29;
output 								 rts_pad_o29;
input 								 cts_pad_i29;
output 								 dtr_pad_o29;
input 								 dsr_pad_i29;
input 								 ri_pad_i29;
input 								 dcd_pad_i29;

// optional29 baudrate29 output
`ifdef UART_HAS_BAUDRATE_OUTPUT29
output	baud_o29;
`endif


wire 									 stx_pad_o29;
wire 									 rts_pad_o29;
wire 									 dtr_pad_o29;

wire [uart_addr_width29-1:0] 	 wb_adr_i29;
wire [uart_data_width29-1:0] 	 wb_dat_i29;
wire [uart_data_width29-1:0] 	 wb_dat_o29;

wire [7:0] 							 wb_dat8_i29; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o29; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o29; // debug29 interface 32-bit output
wire [3:0] 							 wb_sel_i29;  // WISHBONE29 select29 signal29
wire [uart_addr_width29-1:0] 	 wb_adr_int29;
wire 									 we_o29;	// Write enable for registers
wire		          	     re_o29;	// Read enable for registers
//
// MODULE29 INSTANCES29
//

`ifdef DATA_BUS_WIDTH_829
`else
// debug29 interface wires29
wire	[3:0] ier29;
wire	[3:0] iir29;
wire	[1:0] fcr29;
wire	[4:0] mcr29;
wire	[7:0] lcr29;
wire	[7:0] msr29;
wire	[7:0] lsr29;
wire	[`UART_FIFO_COUNTER_W29-1:0] rf_count29;
wire	[`UART_FIFO_COUNTER_W29-1:0] tf_count29;
wire	[2:0] tstate29;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_829
////  WISHBONE29 interface module
uart_wb29		wb_interface29(
		.clk29(		wb_clk_i29		),
		.wb_rst_i29(	wb_rst_i29	),
	.wb_dat_i29(wb_dat_i29),
	.wb_dat_o29(wb_dat_o29),
	.wb_dat8_i29(wb_dat8_i29),
	.wb_dat8_o29(wb_dat8_o29),
	 .wb_dat32_o29(32'b0),								 
	 .wb_sel_i29(4'b0),
		.wb_we_i29(	wb_we_i29		),
		.wb_stb_i29(	wb_stb_i29	),
		.wb_cyc_i29(	wb_cyc_i29	),
		.wb_ack_o29(	wb_ack_o29	),
	.wb_adr_i29(wb_adr_i29),
	.wb_adr_int29(wb_adr_int29),
		.we_o29(		we_o29		),
		.re_o29(re_o29)
		);
`else
uart_wb29		wb_interface29(
		.clk29(		wb_clk_i29		),
		.wb_rst_i29(	wb_rst_i29	),
	.wb_dat_i29(wb_dat_i29),
	.wb_dat_o29(wb_dat_o29),
	.wb_dat8_i29(wb_dat8_i29),
	.wb_dat8_o29(wb_dat8_o29),
	 .wb_sel_i29(wb_sel_i29),
	 .wb_dat32_o29(wb_dat32_o29),								 
		.wb_we_i29(	wb_we_i29		),
		.wb_stb_i29(	wb_stb_i29	),
		.wb_cyc_i29(	wb_cyc_i29	),
		.wb_ack_o29(	wb_ack_o29	),
	.wb_adr_i29(wb_adr_i29),
	.wb_adr_int29(wb_adr_int29),
		.we_o29(		we_o29		),
		.re_o29(re_o29)
		);
`endif

// Registers29
uart_regs29	regs(
	.clk29(		wb_clk_i29		),
	.wb_rst_i29(	wb_rst_i29	),
	.wb_addr_i29(	wb_adr_int29	),
	.wb_dat_i29(	wb_dat8_i29	),
	.wb_dat_o29(	wb_dat8_o29	),
	.wb_we_i29(	we_o29		),
   .wb_re_i29(re_o29),
	.modem_inputs29(	{cts_pad_i29, dsr_pad_i29,
	ri_pad_i29,  dcd_pad_i29}	),
	.stx_pad_o29(		stx_pad_o29		),
	.srx_pad_i29(		srx_pad_i29		),
`ifdef DATA_BUS_WIDTH_829
`else
// debug29 interface signals29	enabled
.ier29(ier29), 
.iir29(iir29), 
.fcr29(fcr29), 
.mcr29(mcr29), 
.lcr29(lcr29), 
.msr29(msr29), 
.lsr29(lsr29), 
.rf_count29(rf_count29),
.tf_count29(tf_count29),
.tstate29(tstate29),
.rstate(rstate),
`endif					  
	.rts_pad_o29(		rts_pad_o29		),
	.dtr_pad_o29(		dtr_pad_o29		),
	.int_o29(		int_o29		)
`ifdef UART_HAS_BAUDRATE_OUTPUT29
	, .baud_o29(baud_o29)
`endif

);

`ifdef DATA_BUS_WIDTH_829
`else
uart_debug_if29 dbg29(/*AUTOINST29*/
						// Outputs29
						.wb_dat32_o29				 (wb_dat32_o29[31:0]),
						// Inputs29
						.wb_adr_i29				 (wb_adr_int29[`UART_ADDR_WIDTH29-1:0]),
						.ier29						 (ier29[3:0]),
						.iir29						 (iir29[3:0]),
						.fcr29						 (fcr29[1:0]),
						.mcr29						 (mcr29[4:0]),
						.lcr29						 (lcr29[7:0]),
						.msr29						 (msr29[7:0]),
						.lsr29						 (lsr29[7:0]),
						.rf_count29				 (rf_count29[`UART_FIFO_COUNTER_W29-1:0]),
						.tf_count29				 (tf_count29[`UART_FIFO_COUNTER_W29-1:0]),
						.tstate29					 (tstate29[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_829
		$display("(%m) UART29 INFO29: Data bus width is 8. No Debug29 interface.\n");
	`else
		$display("(%m) UART29 INFO29: Data bus width is 32. Debug29 Interface29 present29.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT29
		$display("(%m) UART29 INFO29: Has29 baudrate29 output\n");
	`else
		$display("(%m) UART29 INFO29: Doesn29't have baudrate29 output\n");
	`endif
end

endmodule


