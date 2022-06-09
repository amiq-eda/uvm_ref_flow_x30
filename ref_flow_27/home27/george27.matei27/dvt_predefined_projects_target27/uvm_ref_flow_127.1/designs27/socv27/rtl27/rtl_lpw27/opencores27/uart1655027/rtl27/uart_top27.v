//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top27.v                                                  ////
////                                                              ////
////                                                              ////
////  This27 file is part of the "UART27 16550 compatible27" project27    ////
////  http27://www27.opencores27.org27/cores27/uart1655027/                   ////
////                                                              ////
////  Documentation27 related27 to this project27:                      ////
////  - http27://www27.opencores27.org27/cores27/uart1655027/                 ////
////                                                              ////
////  Projects27 compatibility27:                                     ////
////  - WISHBONE27                                                  ////
////  RS23227 Protocol27                                              ////
////  16550D uart27 (mostly27 supported)                              ////
////                                                              ////
////  Overview27 (main27 Features27):                                   ////
////  UART27 core27 top level.                                        ////
////                                                              ////
////  Known27 problems27 (limits27):                                    ////
////  Note27 that transmitter27 and receiver27 instances27 are inside     ////
////  the uart_regs27.v file.                                       ////
////                                                              ////
////  To27 Do27:                                                      ////
////  Nothing so far27.                                             ////
////                                                              ////
////  Author27(s):                                                  ////
////      - gorban27@opencores27.org27                                  ////
////      - Jacob27 Gorban27                                          ////
////      - Igor27 Mohor27 (igorm27@opencores27.org27)                      ////
////                                                              ////
////  Created27:        2001/05/12                                  ////
////  Last27 Updated27:   2001/05/17                                  ////
////                  (See log27 for the revision27 history27)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2000, 2001 Authors27                             ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS27 Revision27 History27
//
// $Log: not supported by cvs2svn27 $
// Revision27 1.18  2002/07/22 23:02:23  gorban27
// Bug27 Fixes27:
//  * Possible27 loss of sync and bad27 reception27 of stop bit on slow27 baud27 rates27 fixed27.
//   Problem27 reported27 by Kenny27.Tung27.
//  * Bad (or lack27 of ) loopback27 handling27 fixed27. Reported27 by Cherry27 Withers27.
//
// Improvements27:
//  * Made27 FIFO's as general27 inferrable27 memory where possible27.
//  So27 on FPGA27 they should be inferred27 as RAM27 (Distributed27 RAM27 on Xilinx27).
//  This27 saves27 about27 1/3 of the Slice27 count and reduces27 P&R and synthesis27 times.
//
//  * Added27 optional27 baudrate27 output (baud_o27).
//  This27 is identical27 to BAUDOUT27* signal27 on 16550 chip27.
//  It outputs27 16xbit_clock_rate - the divided27 clock27.
//  It's disabled by default. Define27 UART_HAS_BAUDRATE_OUTPUT27 to use.
//
// Revision27 1.17  2001/12/19 08:40:03  mohor27
// Warnings27 fixed27 (unused27 signals27 removed).
//
// Revision27 1.16  2001/12/06 14:51:04  gorban27
// Bug27 in LSR27[0] is fixed27.
// All WISHBONE27 signals27 are now sampled27, so another27 wait-state is introduced27 on all transfers27.
//
// Revision27 1.15  2001/12/03 21:44:29  gorban27
// Updated27 specification27 documentation.
// Added27 full 32-bit data bus interface, now as default.
// Address is 5-bit wide27 in 32-bit data bus mode.
// Added27 wb_sel_i27 input to the core27. It's used in the 32-bit mode.
// Added27 debug27 interface with two27 32-bit read-only registers in 32-bit mode.
// Bits27 5 and 6 of LSR27 are now only cleared27 on TX27 FIFO write.
// My27 small test bench27 is modified to work27 with 32-bit mode.
//
// Revision27 1.14  2001/11/07 17:51:52  gorban27
// Heavily27 rewritten27 interrupt27 and LSR27 subsystems27.
// Many27 bugs27 hopefully27 squashed27.
//
// Revision27 1.13  2001/10/20 09:58:40  gorban27
// Small27 synopsis27 fixes27
//
// Revision27 1.12  2001/08/25 15:46:19  gorban27
// Modified27 port names again27
//
// Revision27 1.11  2001/08/24 21:01:12  mohor27
// Things27 connected27 to parity27 changed.
// Clock27 devider27 changed.
//
// Revision27 1.10  2001/08/23 16:05:05  mohor27
// Stop bit bug27 fixed27.
// Parity27 bug27 fixed27.
// WISHBONE27 read cycle bug27 fixed27,
// OE27 indicator27 (Overrun27 Error) bug27 fixed27.
// PE27 indicator27 (Parity27 Error) bug27 fixed27.
// Register read bug27 fixed27.
//
// Revision27 1.4  2001/05/31 20:08:01  gorban27
// FIFO changes27 and other corrections27.
//
// Revision27 1.3  2001/05/21 19:12:02  gorban27
// Corrected27 some27 Linter27 messages27.
//
// Revision27 1.2  2001/05/17 18:34:18  gorban27
// First27 'stable' release. Should27 be sythesizable27 now. Also27 added new header.
//
// Revision27 1.0  2001-05-17 21:27:12+02  jacob27
// Initial27 revision27
//
//
// synopsys27 translate_off27
`include "timescale.v"
// synopsys27 translate_on27

`include "uart_defines27.v"

module uart_top27	(
	wb_clk_i27, 
	
	// Wishbone27 signals27
	wb_rst_i27, wb_adr_i27, wb_dat_i27, wb_dat_o27, wb_we_i27, wb_stb_i27, wb_cyc_i27, wb_ack_o27, wb_sel_i27,
	int_o27, // interrupt27 request

	// UART27	signals27
	// serial27 input/output
	stx_pad_o27, srx_pad_i27,

	// modem27 signals27
	rts_pad_o27, cts_pad_i27, dtr_pad_o27, dsr_pad_i27, ri_pad_i27, dcd_pad_i27
`ifdef UART_HAS_BAUDRATE_OUTPUT27
	, baud_o27
`endif
	);

parameter 							 uart_data_width27 = `UART_DATA_WIDTH27;
parameter 							 uart_addr_width27 = `UART_ADDR_WIDTH27;

input 								 wb_clk_i27;

// WISHBONE27 interface
input 								 wb_rst_i27;
input [uart_addr_width27-1:0] 	 wb_adr_i27;
input [uart_data_width27-1:0] 	 wb_dat_i27;
output [uart_data_width27-1:0] 	 wb_dat_o27;
input 								 wb_we_i27;
input 								 wb_stb_i27;
input 								 wb_cyc_i27;
input [3:0]							 wb_sel_i27;
output 								 wb_ack_o27;
output 								 int_o27;

// UART27	signals27
input 								 srx_pad_i27;
output 								 stx_pad_o27;
output 								 rts_pad_o27;
input 								 cts_pad_i27;
output 								 dtr_pad_o27;
input 								 dsr_pad_i27;
input 								 ri_pad_i27;
input 								 dcd_pad_i27;

// optional27 baudrate27 output
`ifdef UART_HAS_BAUDRATE_OUTPUT27
output	baud_o27;
`endif


wire 									 stx_pad_o27;
wire 									 rts_pad_o27;
wire 									 dtr_pad_o27;

wire [uart_addr_width27-1:0] 	 wb_adr_i27;
wire [uart_data_width27-1:0] 	 wb_dat_i27;
wire [uart_data_width27-1:0] 	 wb_dat_o27;

wire [7:0] 							 wb_dat8_i27; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o27; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o27; // debug27 interface 32-bit output
wire [3:0] 							 wb_sel_i27;  // WISHBONE27 select27 signal27
wire [uart_addr_width27-1:0] 	 wb_adr_int27;
wire 									 we_o27;	// Write enable for registers
wire		          	     re_o27;	// Read enable for registers
//
// MODULE27 INSTANCES27
//

`ifdef DATA_BUS_WIDTH_827
`else
// debug27 interface wires27
wire	[3:0] ier27;
wire	[3:0] iir27;
wire	[1:0] fcr27;
wire	[4:0] mcr27;
wire	[7:0] lcr27;
wire	[7:0] msr27;
wire	[7:0] lsr27;
wire	[`UART_FIFO_COUNTER_W27-1:0] rf_count27;
wire	[`UART_FIFO_COUNTER_W27-1:0] tf_count27;
wire	[2:0] tstate27;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_827
////  WISHBONE27 interface module
uart_wb27		wb_interface27(
		.clk27(		wb_clk_i27		),
		.wb_rst_i27(	wb_rst_i27	),
	.wb_dat_i27(wb_dat_i27),
	.wb_dat_o27(wb_dat_o27),
	.wb_dat8_i27(wb_dat8_i27),
	.wb_dat8_o27(wb_dat8_o27),
	 .wb_dat32_o27(32'b0),								 
	 .wb_sel_i27(4'b0),
		.wb_we_i27(	wb_we_i27		),
		.wb_stb_i27(	wb_stb_i27	),
		.wb_cyc_i27(	wb_cyc_i27	),
		.wb_ack_o27(	wb_ack_o27	),
	.wb_adr_i27(wb_adr_i27),
	.wb_adr_int27(wb_adr_int27),
		.we_o27(		we_o27		),
		.re_o27(re_o27)
		);
`else
uart_wb27		wb_interface27(
		.clk27(		wb_clk_i27		),
		.wb_rst_i27(	wb_rst_i27	),
	.wb_dat_i27(wb_dat_i27),
	.wb_dat_o27(wb_dat_o27),
	.wb_dat8_i27(wb_dat8_i27),
	.wb_dat8_o27(wb_dat8_o27),
	 .wb_sel_i27(wb_sel_i27),
	 .wb_dat32_o27(wb_dat32_o27),								 
		.wb_we_i27(	wb_we_i27		),
		.wb_stb_i27(	wb_stb_i27	),
		.wb_cyc_i27(	wb_cyc_i27	),
		.wb_ack_o27(	wb_ack_o27	),
	.wb_adr_i27(wb_adr_i27),
	.wb_adr_int27(wb_adr_int27),
		.we_o27(		we_o27		),
		.re_o27(re_o27)
		);
`endif

// Registers27
uart_regs27	regs(
	.clk27(		wb_clk_i27		),
	.wb_rst_i27(	wb_rst_i27	),
	.wb_addr_i27(	wb_adr_int27	),
	.wb_dat_i27(	wb_dat8_i27	),
	.wb_dat_o27(	wb_dat8_o27	),
	.wb_we_i27(	we_o27		),
   .wb_re_i27(re_o27),
	.modem_inputs27(	{cts_pad_i27, dsr_pad_i27,
	ri_pad_i27,  dcd_pad_i27}	),
	.stx_pad_o27(		stx_pad_o27		),
	.srx_pad_i27(		srx_pad_i27		),
`ifdef DATA_BUS_WIDTH_827
`else
// debug27 interface signals27	enabled
.ier27(ier27), 
.iir27(iir27), 
.fcr27(fcr27), 
.mcr27(mcr27), 
.lcr27(lcr27), 
.msr27(msr27), 
.lsr27(lsr27), 
.rf_count27(rf_count27),
.tf_count27(tf_count27),
.tstate27(tstate27),
.rstate(rstate),
`endif					  
	.rts_pad_o27(		rts_pad_o27		),
	.dtr_pad_o27(		dtr_pad_o27		),
	.int_o27(		int_o27		)
`ifdef UART_HAS_BAUDRATE_OUTPUT27
	, .baud_o27(baud_o27)
`endif

);

`ifdef DATA_BUS_WIDTH_827
`else
uart_debug_if27 dbg27(/*AUTOINST27*/
						// Outputs27
						.wb_dat32_o27				 (wb_dat32_o27[31:0]),
						// Inputs27
						.wb_adr_i27				 (wb_adr_int27[`UART_ADDR_WIDTH27-1:0]),
						.ier27						 (ier27[3:0]),
						.iir27						 (iir27[3:0]),
						.fcr27						 (fcr27[1:0]),
						.mcr27						 (mcr27[4:0]),
						.lcr27						 (lcr27[7:0]),
						.msr27						 (msr27[7:0]),
						.lsr27						 (lsr27[7:0]),
						.rf_count27				 (rf_count27[`UART_FIFO_COUNTER_W27-1:0]),
						.tf_count27				 (tf_count27[`UART_FIFO_COUNTER_W27-1:0]),
						.tstate27					 (tstate27[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_827
		$display("(%m) UART27 INFO27: Data bus width is 8. No Debug27 interface.\n");
	`else
		$display("(%m) UART27 INFO27: Data bus width is 32. Debug27 Interface27 present27.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT27
		$display("(%m) UART27 INFO27: Has27 baudrate27 output\n");
	`else
		$display("(%m) UART27 INFO27: Doesn27't have baudrate27 output\n");
	`endif
end

endmodule


