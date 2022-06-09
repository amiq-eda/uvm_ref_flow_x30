//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top8.v                                                  ////
////                                                              ////
////                                                              ////
////  This8 file is part of the "UART8 16550 compatible8" project8    ////
////  http8://www8.opencores8.org8/cores8/uart165508/                   ////
////                                                              ////
////  Documentation8 related8 to this project8:                      ////
////  - http8://www8.opencores8.org8/cores8/uart165508/                 ////
////                                                              ////
////  Projects8 compatibility8:                                     ////
////  - WISHBONE8                                                  ////
////  RS2328 Protocol8                                              ////
////  16550D uart8 (mostly8 supported)                              ////
////                                                              ////
////  Overview8 (main8 Features8):                                   ////
////  UART8 core8 top level.                                        ////
////                                                              ////
////  Known8 problems8 (limits8):                                    ////
////  Note8 that transmitter8 and receiver8 instances8 are inside     ////
////  the uart_regs8.v file.                                       ////
////                                                              ////
////  To8 Do8:                                                      ////
////  Nothing so far8.                                             ////
////                                                              ////
////  Author8(s):                                                  ////
////      - gorban8@opencores8.org8                                  ////
////      - Jacob8 Gorban8                                          ////
////      - Igor8 Mohor8 (igorm8@opencores8.org8)                      ////
////                                                              ////
////  Created8:        2001/05/12                                  ////
////  Last8 Updated8:   2001/05/17                                  ////
////                  (See log8 for the revision8 history8)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2000, 2001 Authors8                             ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS8 Revision8 History8
//
// $Log: not supported by cvs2svn8 $
// Revision8 1.18  2002/07/22 23:02:23  gorban8
// Bug8 Fixes8:
//  * Possible8 loss of sync and bad8 reception8 of stop bit on slow8 baud8 rates8 fixed8.
//   Problem8 reported8 by Kenny8.Tung8.
//  * Bad (or lack8 of ) loopback8 handling8 fixed8. Reported8 by Cherry8 Withers8.
//
// Improvements8:
//  * Made8 FIFO's as general8 inferrable8 memory where possible8.
//  So8 on FPGA8 they should be inferred8 as RAM8 (Distributed8 RAM8 on Xilinx8).
//  This8 saves8 about8 1/3 of the Slice8 count and reduces8 P&R and synthesis8 times.
//
//  * Added8 optional8 baudrate8 output (baud_o8).
//  This8 is identical8 to BAUDOUT8* signal8 on 16550 chip8.
//  It outputs8 16xbit_clock_rate - the divided8 clock8.
//  It's disabled by default. Define8 UART_HAS_BAUDRATE_OUTPUT8 to use.
//
// Revision8 1.17  2001/12/19 08:40:03  mohor8
// Warnings8 fixed8 (unused8 signals8 removed).
//
// Revision8 1.16  2001/12/06 14:51:04  gorban8
// Bug8 in LSR8[0] is fixed8.
// All WISHBONE8 signals8 are now sampled8, so another8 wait-state is introduced8 on all transfers8.
//
// Revision8 1.15  2001/12/03 21:44:29  gorban8
// Updated8 specification8 documentation.
// Added8 full 32-bit data bus interface, now as default.
// Address is 5-bit wide8 in 32-bit data bus mode.
// Added8 wb_sel_i8 input to the core8. It's used in the 32-bit mode.
// Added8 debug8 interface with two8 32-bit read-only registers in 32-bit mode.
// Bits8 5 and 6 of LSR8 are now only cleared8 on TX8 FIFO write.
// My8 small test bench8 is modified to work8 with 32-bit mode.
//
// Revision8 1.14  2001/11/07 17:51:52  gorban8
// Heavily8 rewritten8 interrupt8 and LSR8 subsystems8.
// Many8 bugs8 hopefully8 squashed8.
//
// Revision8 1.13  2001/10/20 09:58:40  gorban8
// Small8 synopsis8 fixes8
//
// Revision8 1.12  2001/08/25 15:46:19  gorban8
// Modified8 port names again8
//
// Revision8 1.11  2001/08/24 21:01:12  mohor8
// Things8 connected8 to parity8 changed.
// Clock8 devider8 changed.
//
// Revision8 1.10  2001/08/23 16:05:05  mohor8
// Stop bit bug8 fixed8.
// Parity8 bug8 fixed8.
// WISHBONE8 read cycle bug8 fixed8,
// OE8 indicator8 (Overrun8 Error) bug8 fixed8.
// PE8 indicator8 (Parity8 Error) bug8 fixed8.
// Register read bug8 fixed8.
//
// Revision8 1.4  2001/05/31 20:08:01  gorban8
// FIFO changes8 and other corrections8.
//
// Revision8 1.3  2001/05/21 19:12:02  gorban8
// Corrected8 some8 Linter8 messages8.
//
// Revision8 1.2  2001/05/17 18:34:18  gorban8
// First8 'stable' release. Should8 be sythesizable8 now. Also8 added new header.
//
// Revision8 1.0  2001-05-17 21:27:12+02  jacob8
// Initial8 revision8
//
//
// synopsys8 translate_off8
`include "timescale.v"
// synopsys8 translate_on8

`include "uart_defines8.v"

module uart_top8	(
	wb_clk_i8, 
	
	// Wishbone8 signals8
	wb_rst_i8, wb_adr_i8, wb_dat_i8, wb_dat_o8, wb_we_i8, wb_stb_i8, wb_cyc_i8, wb_ack_o8, wb_sel_i8,
	int_o8, // interrupt8 request

	// UART8	signals8
	// serial8 input/output
	stx_pad_o8, srx_pad_i8,

	// modem8 signals8
	rts_pad_o8, cts_pad_i8, dtr_pad_o8, dsr_pad_i8, ri_pad_i8, dcd_pad_i8
`ifdef UART_HAS_BAUDRATE_OUTPUT8
	, baud_o8
`endif
	);

parameter 							 uart_data_width8 = `UART_DATA_WIDTH8;
parameter 							 uart_addr_width8 = `UART_ADDR_WIDTH8;

input 								 wb_clk_i8;

// WISHBONE8 interface
input 								 wb_rst_i8;
input [uart_addr_width8-1:0] 	 wb_adr_i8;
input [uart_data_width8-1:0] 	 wb_dat_i8;
output [uart_data_width8-1:0] 	 wb_dat_o8;
input 								 wb_we_i8;
input 								 wb_stb_i8;
input 								 wb_cyc_i8;
input [3:0]							 wb_sel_i8;
output 								 wb_ack_o8;
output 								 int_o8;

// UART8	signals8
input 								 srx_pad_i8;
output 								 stx_pad_o8;
output 								 rts_pad_o8;
input 								 cts_pad_i8;
output 								 dtr_pad_o8;
input 								 dsr_pad_i8;
input 								 ri_pad_i8;
input 								 dcd_pad_i8;

// optional8 baudrate8 output
`ifdef UART_HAS_BAUDRATE_OUTPUT8
output	baud_o8;
`endif


wire 									 stx_pad_o8;
wire 									 rts_pad_o8;
wire 									 dtr_pad_o8;

wire [uart_addr_width8-1:0] 	 wb_adr_i8;
wire [uart_data_width8-1:0] 	 wb_dat_i8;
wire [uart_data_width8-1:0] 	 wb_dat_o8;

wire [7:0] 							 wb_dat8_i8; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o8; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o8; // debug8 interface 32-bit output
wire [3:0] 							 wb_sel_i8;  // WISHBONE8 select8 signal8
wire [uart_addr_width8-1:0] 	 wb_adr_int8;
wire 									 we_o8;	// Write enable for registers
wire		          	     re_o8;	// Read enable for registers
//
// MODULE8 INSTANCES8
//

`ifdef DATA_BUS_WIDTH_88
`else
// debug8 interface wires8
wire	[3:0] ier8;
wire	[3:0] iir8;
wire	[1:0] fcr8;
wire	[4:0] mcr8;
wire	[7:0] lcr8;
wire	[7:0] msr8;
wire	[7:0] lsr8;
wire	[`UART_FIFO_COUNTER_W8-1:0] rf_count8;
wire	[`UART_FIFO_COUNTER_W8-1:0] tf_count8;
wire	[2:0] tstate8;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_88
////  WISHBONE8 interface module
uart_wb8		wb_interface8(
		.clk8(		wb_clk_i8		),
		.wb_rst_i8(	wb_rst_i8	),
	.wb_dat_i8(wb_dat_i8),
	.wb_dat_o8(wb_dat_o8),
	.wb_dat8_i8(wb_dat8_i8),
	.wb_dat8_o8(wb_dat8_o8),
	 .wb_dat32_o8(32'b0),								 
	 .wb_sel_i8(4'b0),
		.wb_we_i8(	wb_we_i8		),
		.wb_stb_i8(	wb_stb_i8	),
		.wb_cyc_i8(	wb_cyc_i8	),
		.wb_ack_o8(	wb_ack_o8	),
	.wb_adr_i8(wb_adr_i8),
	.wb_adr_int8(wb_adr_int8),
		.we_o8(		we_o8		),
		.re_o8(re_o8)
		);
`else
uart_wb8		wb_interface8(
		.clk8(		wb_clk_i8		),
		.wb_rst_i8(	wb_rst_i8	),
	.wb_dat_i8(wb_dat_i8),
	.wb_dat_o8(wb_dat_o8),
	.wb_dat8_i8(wb_dat8_i8),
	.wb_dat8_o8(wb_dat8_o8),
	 .wb_sel_i8(wb_sel_i8),
	 .wb_dat32_o8(wb_dat32_o8),								 
		.wb_we_i8(	wb_we_i8		),
		.wb_stb_i8(	wb_stb_i8	),
		.wb_cyc_i8(	wb_cyc_i8	),
		.wb_ack_o8(	wb_ack_o8	),
	.wb_adr_i8(wb_adr_i8),
	.wb_adr_int8(wb_adr_int8),
		.we_o8(		we_o8		),
		.re_o8(re_o8)
		);
`endif

// Registers8
uart_regs8	regs(
	.clk8(		wb_clk_i8		),
	.wb_rst_i8(	wb_rst_i8	),
	.wb_addr_i8(	wb_adr_int8	),
	.wb_dat_i8(	wb_dat8_i8	),
	.wb_dat_o8(	wb_dat8_o8	),
	.wb_we_i8(	we_o8		),
   .wb_re_i8(re_o8),
	.modem_inputs8(	{cts_pad_i8, dsr_pad_i8,
	ri_pad_i8,  dcd_pad_i8}	),
	.stx_pad_o8(		stx_pad_o8		),
	.srx_pad_i8(		srx_pad_i8		),
`ifdef DATA_BUS_WIDTH_88
`else
// debug8 interface signals8	enabled
.ier8(ier8), 
.iir8(iir8), 
.fcr8(fcr8), 
.mcr8(mcr8), 
.lcr8(lcr8), 
.msr8(msr8), 
.lsr8(lsr8), 
.rf_count8(rf_count8),
.tf_count8(tf_count8),
.tstate8(tstate8),
.rstate(rstate),
`endif					  
	.rts_pad_o8(		rts_pad_o8		),
	.dtr_pad_o8(		dtr_pad_o8		),
	.int_o8(		int_o8		)
`ifdef UART_HAS_BAUDRATE_OUTPUT8
	, .baud_o8(baud_o8)
`endif

);

`ifdef DATA_BUS_WIDTH_88
`else
uart_debug_if8 dbg8(/*AUTOINST8*/
						// Outputs8
						.wb_dat32_o8				 (wb_dat32_o8[31:0]),
						// Inputs8
						.wb_adr_i8				 (wb_adr_int8[`UART_ADDR_WIDTH8-1:0]),
						.ier8						 (ier8[3:0]),
						.iir8						 (iir8[3:0]),
						.fcr8						 (fcr8[1:0]),
						.mcr8						 (mcr8[4:0]),
						.lcr8						 (lcr8[7:0]),
						.msr8						 (msr8[7:0]),
						.lsr8						 (lsr8[7:0]),
						.rf_count8				 (rf_count8[`UART_FIFO_COUNTER_W8-1:0]),
						.tf_count8				 (tf_count8[`UART_FIFO_COUNTER_W8-1:0]),
						.tstate8					 (tstate8[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_88
		$display("(%m) UART8 INFO8: Data bus width is 8. No Debug8 interface.\n");
	`else
		$display("(%m) UART8 INFO8: Data bus width is 32. Debug8 Interface8 present8.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT8
		$display("(%m) UART8 INFO8: Has8 baudrate8 output\n");
	`else
		$display("(%m) UART8 INFO8: Doesn8't have baudrate8 output\n");
	`endif
end

endmodule


