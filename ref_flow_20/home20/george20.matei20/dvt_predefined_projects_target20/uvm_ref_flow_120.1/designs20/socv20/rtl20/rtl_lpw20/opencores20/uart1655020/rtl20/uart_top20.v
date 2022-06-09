//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top20.v                                                  ////
////                                                              ////
////                                                              ////
////  This20 file is part of the "UART20 16550 compatible20" project20    ////
////  http20://www20.opencores20.org20/cores20/uart1655020/                   ////
////                                                              ////
////  Documentation20 related20 to this project20:                      ////
////  - http20://www20.opencores20.org20/cores20/uart1655020/                 ////
////                                                              ////
////  Projects20 compatibility20:                                     ////
////  - WISHBONE20                                                  ////
////  RS23220 Protocol20                                              ////
////  16550D uart20 (mostly20 supported)                              ////
////                                                              ////
////  Overview20 (main20 Features20):                                   ////
////  UART20 core20 top level.                                        ////
////                                                              ////
////  Known20 problems20 (limits20):                                    ////
////  Note20 that transmitter20 and receiver20 instances20 are inside     ////
////  the uart_regs20.v file.                                       ////
////                                                              ////
////  To20 Do20:                                                      ////
////  Nothing so far20.                                             ////
////                                                              ////
////  Author20(s):                                                  ////
////      - gorban20@opencores20.org20                                  ////
////      - Jacob20 Gorban20                                          ////
////      - Igor20 Mohor20 (igorm20@opencores20.org20)                      ////
////                                                              ////
////  Created20:        2001/05/12                                  ////
////  Last20 Updated20:   2001/05/17                                  ////
////                  (See log20 for the revision20 history20)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2000, 2001 Authors20                             ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS20 Revision20 History20
//
// $Log: not supported by cvs2svn20 $
// Revision20 1.18  2002/07/22 23:02:23  gorban20
// Bug20 Fixes20:
//  * Possible20 loss of sync and bad20 reception20 of stop bit on slow20 baud20 rates20 fixed20.
//   Problem20 reported20 by Kenny20.Tung20.
//  * Bad (or lack20 of ) loopback20 handling20 fixed20. Reported20 by Cherry20 Withers20.
//
// Improvements20:
//  * Made20 FIFO's as general20 inferrable20 memory where possible20.
//  So20 on FPGA20 they should be inferred20 as RAM20 (Distributed20 RAM20 on Xilinx20).
//  This20 saves20 about20 1/3 of the Slice20 count and reduces20 P&R and synthesis20 times.
//
//  * Added20 optional20 baudrate20 output (baud_o20).
//  This20 is identical20 to BAUDOUT20* signal20 on 16550 chip20.
//  It outputs20 16xbit_clock_rate - the divided20 clock20.
//  It's disabled by default. Define20 UART_HAS_BAUDRATE_OUTPUT20 to use.
//
// Revision20 1.17  2001/12/19 08:40:03  mohor20
// Warnings20 fixed20 (unused20 signals20 removed).
//
// Revision20 1.16  2001/12/06 14:51:04  gorban20
// Bug20 in LSR20[0] is fixed20.
// All WISHBONE20 signals20 are now sampled20, so another20 wait-state is introduced20 on all transfers20.
//
// Revision20 1.15  2001/12/03 21:44:29  gorban20
// Updated20 specification20 documentation.
// Added20 full 32-bit data bus interface, now as default.
// Address is 5-bit wide20 in 32-bit data bus mode.
// Added20 wb_sel_i20 input to the core20. It's used in the 32-bit mode.
// Added20 debug20 interface with two20 32-bit read-only registers in 32-bit mode.
// Bits20 5 and 6 of LSR20 are now only cleared20 on TX20 FIFO write.
// My20 small test bench20 is modified to work20 with 32-bit mode.
//
// Revision20 1.14  2001/11/07 17:51:52  gorban20
// Heavily20 rewritten20 interrupt20 and LSR20 subsystems20.
// Many20 bugs20 hopefully20 squashed20.
//
// Revision20 1.13  2001/10/20 09:58:40  gorban20
// Small20 synopsis20 fixes20
//
// Revision20 1.12  2001/08/25 15:46:19  gorban20
// Modified20 port names again20
//
// Revision20 1.11  2001/08/24 21:01:12  mohor20
// Things20 connected20 to parity20 changed.
// Clock20 devider20 changed.
//
// Revision20 1.10  2001/08/23 16:05:05  mohor20
// Stop bit bug20 fixed20.
// Parity20 bug20 fixed20.
// WISHBONE20 read cycle bug20 fixed20,
// OE20 indicator20 (Overrun20 Error) bug20 fixed20.
// PE20 indicator20 (Parity20 Error) bug20 fixed20.
// Register read bug20 fixed20.
//
// Revision20 1.4  2001/05/31 20:08:01  gorban20
// FIFO changes20 and other corrections20.
//
// Revision20 1.3  2001/05/21 19:12:02  gorban20
// Corrected20 some20 Linter20 messages20.
//
// Revision20 1.2  2001/05/17 18:34:18  gorban20
// First20 'stable' release. Should20 be sythesizable20 now. Also20 added new header.
//
// Revision20 1.0  2001-05-17 21:27:12+02  jacob20
// Initial20 revision20
//
//
// synopsys20 translate_off20
`include "timescale.v"
// synopsys20 translate_on20

`include "uart_defines20.v"

module uart_top20	(
	wb_clk_i20, 
	
	// Wishbone20 signals20
	wb_rst_i20, wb_adr_i20, wb_dat_i20, wb_dat_o20, wb_we_i20, wb_stb_i20, wb_cyc_i20, wb_ack_o20, wb_sel_i20,
	int_o20, // interrupt20 request

	// UART20	signals20
	// serial20 input/output
	stx_pad_o20, srx_pad_i20,

	// modem20 signals20
	rts_pad_o20, cts_pad_i20, dtr_pad_o20, dsr_pad_i20, ri_pad_i20, dcd_pad_i20
`ifdef UART_HAS_BAUDRATE_OUTPUT20
	, baud_o20
`endif
	);

parameter 							 uart_data_width20 = `UART_DATA_WIDTH20;
parameter 							 uart_addr_width20 = `UART_ADDR_WIDTH20;

input 								 wb_clk_i20;

// WISHBONE20 interface
input 								 wb_rst_i20;
input [uart_addr_width20-1:0] 	 wb_adr_i20;
input [uart_data_width20-1:0] 	 wb_dat_i20;
output [uart_data_width20-1:0] 	 wb_dat_o20;
input 								 wb_we_i20;
input 								 wb_stb_i20;
input 								 wb_cyc_i20;
input [3:0]							 wb_sel_i20;
output 								 wb_ack_o20;
output 								 int_o20;

// UART20	signals20
input 								 srx_pad_i20;
output 								 stx_pad_o20;
output 								 rts_pad_o20;
input 								 cts_pad_i20;
output 								 dtr_pad_o20;
input 								 dsr_pad_i20;
input 								 ri_pad_i20;
input 								 dcd_pad_i20;

// optional20 baudrate20 output
`ifdef UART_HAS_BAUDRATE_OUTPUT20
output	baud_o20;
`endif


wire 									 stx_pad_o20;
wire 									 rts_pad_o20;
wire 									 dtr_pad_o20;

wire [uart_addr_width20-1:0] 	 wb_adr_i20;
wire [uart_data_width20-1:0] 	 wb_dat_i20;
wire [uart_data_width20-1:0] 	 wb_dat_o20;

wire [7:0] 							 wb_dat8_i20; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o20; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o20; // debug20 interface 32-bit output
wire [3:0] 							 wb_sel_i20;  // WISHBONE20 select20 signal20
wire [uart_addr_width20-1:0] 	 wb_adr_int20;
wire 									 we_o20;	// Write enable for registers
wire		          	     re_o20;	// Read enable for registers
//
// MODULE20 INSTANCES20
//

`ifdef DATA_BUS_WIDTH_820
`else
// debug20 interface wires20
wire	[3:0] ier20;
wire	[3:0] iir20;
wire	[1:0] fcr20;
wire	[4:0] mcr20;
wire	[7:0] lcr20;
wire	[7:0] msr20;
wire	[7:0] lsr20;
wire	[`UART_FIFO_COUNTER_W20-1:0] rf_count20;
wire	[`UART_FIFO_COUNTER_W20-1:0] tf_count20;
wire	[2:0] tstate20;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_820
////  WISHBONE20 interface module
uart_wb20		wb_interface20(
		.clk20(		wb_clk_i20		),
		.wb_rst_i20(	wb_rst_i20	),
	.wb_dat_i20(wb_dat_i20),
	.wb_dat_o20(wb_dat_o20),
	.wb_dat8_i20(wb_dat8_i20),
	.wb_dat8_o20(wb_dat8_o20),
	 .wb_dat32_o20(32'b0),								 
	 .wb_sel_i20(4'b0),
		.wb_we_i20(	wb_we_i20		),
		.wb_stb_i20(	wb_stb_i20	),
		.wb_cyc_i20(	wb_cyc_i20	),
		.wb_ack_o20(	wb_ack_o20	),
	.wb_adr_i20(wb_adr_i20),
	.wb_adr_int20(wb_adr_int20),
		.we_o20(		we_o20		),
		.re_o20(re_o20)
		);
`else
uart_wb20		wb_interface20(
		.clk20(		wb_clk_i20		),
		.wb_rst_i20(	wb_rst_i20	),
	.wb_dat_i20(wb_dat_i20),
	.wb_dat_o20(wb_dat_o20),
	.wb_dat8_i20(wb_dat8_i20),
	.wb_dat8_o20(wb_dat8_o20),
	 .wb_sel_i20(wb_sel_i20),
	 .wb_dat32_o20(wb_dat32_o20),								 
		.wb_we_i20(	wb_we_i20		),
		.wb_stb_i20(	wb_stb_i20	),
		.wb_cyc_i20(	wb_cyc_i20	),
		.wb_ack_o20(	wb_ack_o20	),
	.wb_adr_i20(wb_adr_i20),
	.wb_adr_int20(wb_adr_int20),
		.we_o20(		we_o20		),
		.re_o20(re_o20)
		);
`endif

// Registers20
uart_regs20	regs(
	.clk20(		wb_clk_i20		),
	.wb_rst_i20(	wb_rst_i20	),
	.wb_addr_i20(	wb_adr_int20	),
	.wb_dat_i20(	wb_dat8_i20	),
	.wb_dat_o20(	wb_dat8_o20	),
	.wb_we_i20(	we_o20		),
   .wb_re_i20(re_o20),
	.modem_inputs20(	{cts_pad_i20, dsr_pad_i20,
	ri_pad_i20,  dcd_pad_i20}	),
	.stx_pad_o20(		stx_pad_o20		),
	.srx_pad_i20(		srx_pad_i20		),
`ifdef DATA_BUS_WIDTH_820
`else
// debug20 interface signals20	enabled
.ier20(ier20), 
.iir20(iir20), 
.fcr20(fcr20), 
.mcr20(mcr20), 
.lcr20(lcr20), 
.msr20(msr20), 
.lsr20(lsr20), 
.rf_count20(rf_count20),
.tf_count20(tf_count20),
.tstate20(tstate20),
.rstate(rstate),
`endif					  
	.rts_pad_o20(		rts_pad_o20		),
	.dtr_pad_o20(		dtr_pad_o20		),
	.int_o20(		int_o20		)
`ifdef UART_HAS_BAUDRATE_OUTPUT20
	, .baud_o20(baud_o20)
`endif

);

`ifdef DATA_BUS_WIDTH_820
`else
uart_debug_if20 dbg20(/*AUTOINST20*/
						// Outputs20
						.wb_dat32_o20				 (wb_dat32_o20[31:0]),
						// Inputs20
						.wb_adr_i20				 (wb_adr_int20[`UART_ADDR_WIDTH20-1:0]),
						.ier20						 (ier20[3:0]),
						.iir20						 (iir20[3:0]),
						.fcr20						 (fcr20[1:0]),
						.mcr20						 (mcr20[4:0]),
						.lcr20						 (lcr20[7:0]),
						.msr20						 (msr20[7:0]),
						.lsr20						 (lsr20[7:0]),
						.rf_count20				 (rf_count20[`UART_FIFO_COUNTER_W20-1:0]),
						.tf_count20				 (tf_count20[`UART_FIFO_COUNTER_W20-1:0]),
						.tstate20					 (tstate20[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_820
		$display("(%m) UART20 INFO20: Data bus width is 8. No Debug20 interface.\n");
	`else
		$display("(%m) UART20 INFO20: Data bus width is 32. Debug20 Interface20 present20.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT20
		$display("(%m) UART20 INFO20: Has20 baudrate20 output\n");
	`else
		$display("(%m) UART20 INFO20: Doesn20't have baudrate20 output\n");
	`endif
end

endmodule


