//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top24.v                                                  ////
////                                                              ////
////                                                              ////
////  This24 file is part of the "UART24 16550 compatible24" project24    ////
////  http24://www24.opencores24.org24/cores24/uart1655024/                   ////
////                                                              ////
////  Documentation24 related24 to this project24:                      ////
////  - http24://www24.opencores24.org24/cores24/uart1655024/                 ////
////                                                              ////
////  Projects24 compatibility24:                                     ////
////  - WISHBONE24                                                  ////
////  RS23224 Protocol24                                              ////
////  16550D uart24 (mostly24 supported)                              ////
////                                                              ////
////  Overview24 (main24 Features24):                                   ////
////  UART24 core24 top level.                                        ////
////                                                              ////
////  Known24 problems24 (limits24):                                    ////
////  Note24 that transmitter24 and receiver24 instances24 are inside     ////
////  the uart_regs24.v file.                                       ////
////                                                              ////
////  To24 Do24:                                                      ////
////  Nothing so far24.                                             ////
////                                                              ////
////  Author24(s):                                                  ////
////      - gorban24@opencores24.org24                                  ////
////      - Jacob24 Gorban24                                          ////
////      - Igor24 Mohor24 (igorm24@opencores24.org24)                      ////
////                                                              ////
////  Created24:        2001/05/12                                  ////
////  Last24 Updated24:   2001/05/17                                  ////
////                  (See log24 for the revision24 history24)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright24 (C) 2000, 2001 Authors24                             ////
////                                                              ////
//// This24 source24 file may be used and distributed24 without         ////
//// restriction24 provided that this copyright24 statement24 is not    ////
//// removed from the file and that any derivative24 work24 contains24  ////
//// the original copyright24 notice24 and the associated disclaimer24. ////
////                                                              ////
//// This24 source24 file is free software24; you can redistribute24 it   ////
//// and/or modify it under the terms24 of the GNU24 Lesser24 General24   ////
//// Public24 License24 as published24 by the Free24 Software24 Foundation24; ////
//// either24 version24 2.1 of the License24, or (at your24 option) any   ////
//// later24 version24.                                               ////
////                                                              ////
//// This24 source24 is distributed24 in the hope24 that it will be       ////
//// useful24, but WITHOUT24 ANY24 WARRANTY24; without even24 the implied24   ////
//// warranty24 of MERCHANTABILITY24 or FITNESS24 FOR24 A PARTICULAR24      ////
//// PURPOSE24.  See the GNU24 Lesser24 General24 Public24 License24 for more ////
//// details24.                                                     ////
////                                                              ////
//// You should have received24 a copy of the GNU24 Lesser24 General24    ////
//// Public24 License24 along24 with this source24; if not, download24 it   ////
//// from http24://www24.opencores24.org24/lgpl24.shtml24                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS24 Revision24 History24
//
// $Log: not supported by cvs2svn24 $
// Revision24 1.18  2002/07/22 23:02:23  gorban24
// Bug24 Fixes24:
//  * Possible24 loss of sync and bad24 reception24 of stop bit on slow24 baud24 rates24 fixed24.
//   Problem24 reported24 by Kenny24.Tung24.
//  * Bad (or lack24 of ) loopback24 handling24 fixed24. Reported24 by Cherry24 Withers24.
//
// Improvements24:
//  * Made24 FIFO's as general24 inferrable24 memory where possible24.
//  So24 on FPGA24 they should be inferred24 as RAM24 (Distributed24 RAM24 on Xilinx24).
//  This24 saves24 about24 1/3 of the Slice24 count and reduces24 P&R and synthesis24 times.
//
//  * Added24 optional24 baudrate24 output (baud_o24).
//  This24 is identical24 to BAUDOUT24* signal24 on 16550 chip24.
//  It outputs24 16xbit_clock_rate - the divided24 clock24.
//  It's disabled by default. Define24 UART_HAS_BAUDRATE_OUTPUT24 to use.
//
// Revision24 1.17  2001/12/19 08:40:03  mohor24
// Warnings24 fixed24 (unused24 signals24 removed).
//
// Revision24 1.16  2001/12/06 14:51:04  gorban24
// Bug24 in LSR24[0] is fixed24.
// All WISHBONE24 signals24 are now sampled24, so another24 wait-state is introduced24 on all transfers24.
//
// Revision24 1.15  2001/12/03 21:44:29  gorban24
// Updated24 specification24 documentation.
// Added24 full 32-bit data bus interface, now as default.
// Address is 5-bit wide24 in 32-bit data bus mode.
// Added24 wb_sel_i24 input to the core24. It's used in the 32-bit mode.
// Added24 debug24 interface with two24 32-bit read-only registers in 32-bit mode.
// Bits24 5 and 6 of LSR24 are now only cleared24 on TX24 FIFO write.
// My24 small test bench24 is modified to work24 with 32-bit mode.
//
// Revision24 1.14  2001/11/07 17:51:52  gorban24
// Heavily24 rewritten24 interrupt24 and LSR24 subsystems24.
// Many24 bugs24 hopefully24 squashed24.
//
// Revision24 1.13  2001/10/20 09:58:40  gorban24
// Small24 synopsis24 fixes24
//
// Revision24 1.12  2001/08/25 15:46:19  gorban24
// Modified24 port names again24
//
// Revision24 1.11  2001/08/24 21:01:12  mohor24
// Things24 connected24 to parity24 changed.
// Clock24 devider24 changed.
//
// Revision24 1.10  2001/08/23 16:05:05  mohor24
// Stop bit bug24 fixed24.
// Parity24 bug24 fixed24.
// WISHBONE24 read cycle bug24 fixed24,
// OE24 indicator24 (Overrun24 Error) bug24 fixed24.
// PE24 indicator24 (Parity24 Error) bug24 fixed24.
// Register read bug24 fixed24.
//
// Revision24 1.4  2001/05/31 20:08:01  gorban24
// FIFO changes24 and other corrections24.
//
// Revision24 1.3  2001/05/21 19:12:02  gorban24
// Corrected24 some24 Linter24 messages24.
//
// Revision24 1.2  2001/05/17 18:34:18  gorban24
// First24 'stable' release. Should24 be sythesizable24 now. Also24 added new header.
//
// Revision24 1.0  2001-05-17 21:27:12+02  jacob24
// Initial24 revision24
//
//
// synopsys24 translate_off24
`include "timescale.v"
// synopsys24 translate_on24

`include "uart_defines24.v"

module uart_top24	(
	wb_clk_i24, 
	
	// Wishbone24 signals24
	wb_rst_i24, wb_adr_i24, wb_dat_i24, wb_dat_o24, wb_we_i24, wb_stb_i24, wb_cyc_i24, wb_ack_o24, wb_sel_i24,
	int_o24, // interrupt24 request

	// UART24	signals24
	// serial24 input/output
	stx_pad_o24, srx_pad_i24,

	// modem24 signals24
	rts_pad_o24, cts_pad_i24, dtr_pad_o24, dsr_pad_i24, ri_pad_i24, dcd_pad_i24
`ifdef UART_HAS_BAUDRATE_OUTPUT24
	, baud_o24
`endif
	);

parameter 							 uart_data_width24 = `UART_DATA_WIDTH24;
parameter 							 uart_addr_width24 = `UART_ADDR_WIDTH24;

input 								 wb_clk_i24;

// WISHBONE24 interface
input 								 wb_rst_i24;
input [uart_addr_width24-1:0] 	 wb_adr_i24;
input [uart_data_width24-1:0] 	 wb_dat_i24;
output [uart_data_width24-1:0] 	 wb_dat_o24;
input 								 wb_we_i24;
input 								 wb_stb_i24;
input 								 wb_cyc_i24;
input [3:0]							 wb_sel_i24;
output 								 wb_ack_o24;
output 								 int_o24;

// UART24	signals24
input 								 srx_pad_i24;
output 								 stx_pad_o24;
output 								 rts_pad_o24;
input 								 cts_pad_i24;
output 								 dtr_pad_o24;
input 								 dsr_pad_i24;
input 								 ri_pad_i24;
input 								 dcd_pad_i24;

// optional24 baudrate24 output
`ifdef UART_HAS_BAUDRATE_OUTPUT24
output	baud_o24;
`endif


wire 									 stx_pad_o24;
wire 									 rts_pad_o24;
wire 									 dtr_pad_o24;

wire [uart_addr_width24-1:0] 	 wb_adr_i24;
wire [uart_data_width24-1:0] 	 wb_dat_i24;
wire [uart_data_width24-1:0] 	 wb_dat_o24;

wire [7:0] 							 wb_dat8_i24; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o24; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o24; // debug24 interface 32-bit output
wire [3:0] 							 wb_sel_i24;  // WISHBONE24 select24 signal24
wire [uart_addr_width24-1:0] 	 wb_adr_int24;
wire 									 we_o24;	// Write enable for registers
wire		          	     re_o24;	// Read enable for registers
//
// MODULE24 INSTANCES24
//

`ifdef DATA_BUS_WIDTH_824
`else
// debug24 interface wires24
wire	[3:0] ier24;
wire	[3:0] iir24;
wire	[1:0] fcr24;
wire	[4:0] mcr24;
wire	[7:0] lcr24;
wire	[7:0] msr24;
wire	[7:0] lsr24;
wire	[`UART_FIFO_COUNTER_W24-1:0] rf_count24;
wire	[`UART_FIFO_COUNTER_W24-1:0] tf_count24;
wire	[2:0] tstate24;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_824
////  WISHBONE24 interface module
uart_wb24		wb_interface24(
		.clk24(		wb_clk_i24		),
		.wb_rst_i24(	wb_rst_i24	),
	.wb_dat_i24(wb_dat_i24),
	.wb_dat_o24(wb_dat_o24),
	.wb_dat8_i24(wb_dat8_i24),
	.wb_dat8_o24(wb_dat8_o24),
	 .wb_dat32_o24(32'b0),								 
	 .wb_sel_i24(4'b0),
		.wb_we_i24(	wb_we_i24		),
		.wb_stb_i24(	wb_stb_i24	),
		.wb_cyc_i24(	wb_cyc_i24	),
		.wb_ack_o24(	wb_ack_o24	),
	.wb_adr_i24(wb_adr_i24),
	.wb_adr_int24(wb_adr_int24),
		.we_o24(		we_o24		),
		.re_o24(re_o24)
		);
`else
uart_wb24		wb_interface24(
		.clk24(		wb_clk_i24		),
		.wb_rst_i24(	wb_rst_i24	),
	.wb_dat_i24(wb_dat_i24),
	.wb_dat_o24(wb_dat_o24),
	.wb_dat8_i24(wb_dat8_i24),
	.wb_dat8_o24(wb_dat8_o24),
	 .wb_sel_i24(wb_sel_i24),
	 .wb_dat32_o24(wb_dat32_o24),								 
		.wb_we_i24(	wb_we_i24		),
		.wb_stb_i24(	wb_stb_i24	),
		.wb_cyc_i24(	wb_cyc_i24	),
		.wb_ack_o24(	wb_ack_o24	),
	.wb_adr_i24(wb_adr_i24),
	.wb_adr_int24(wb_adr_int24),
		.we_o24(		we_o24		),
		.re_o24(re_o24)
		);
`endif

// Registers24
uart_regs24	regs(
	.clk24(		wb_clk_i24		),
	.wb_rst_i24(	wb_rst_i24	),
	.wb_addr_i24(	wb_adr_int24	),
	.wb_dat_i24(	wb_dat8_i24	),
	.wb_dat_o24(	wb_dat8_o24	),
	.wb_we_i24(	we_o24		),
   .wb_re_i24(re_o24),
	.modem_inputs24(	{cts_pad_i24, dsr_pad_i24,
	ri_pad_i24,  dcd_pad_i24}	),
	.stx_pad_o24(		stx_pad_o24		),
	.srx_pad_i24(		srx_pad_i24		),
`ifdef DATA_BUS_WIDTH_824
`else
// debug24 interface signals24	enabled
.ier24(ier24), 
.iir24(iir24), 
.fcr24(fcr24), 
.mcr24(mcr24), 
.lcr24(lcr24), 
.msr24(msr24), 
.lsr24(lsr24), 
.rf_count24(rf_count24),
.tf_count24(tf_count24),
.tstate24(tstate24),
.rstate(rstate),
`endif					  
	.rts_pad_o24(		rts_pad_o24		),
	.dtr_pad_o24(		dtr_pad_o24		),
	.int_o24(		int_o24		)
`ifdef UART_HAS_BAUDRATE_OUTPUT24
	, .baud_o24(baud_o24)
`endif

);

`ifdef DATA_BUS_WIDTH_824
`else
uart_debug_if24 dbg24(/*AUTOINST24*/
						// Outputs24
						.wb_dat32_o24				 (wb_dat32_o24[31:0]),
						// Inputs24
						.wb_adr_i24				 (wb_adr_int24[`UART_ADDR_WIDTH24-1:0]),
						.ier24						 (ier24[3:0]),
						.iir24						 (iir24[3:0]),
						.fcr24						 (fcr24[1:0]),
						.mcr24						 (mcr24[4:0]),
						.lcr24						 (lcr24[7:0]),
						.msr24						 (msr24[7:0]),
						.lsr24						 (lsr24[7:0]),
						.rf_count24				 (rf_count24[`UART_FIFO_COUNTER_W24-1:0]),
						.tf_count24				 (tf_count24[`UART_FIFO_COUNTER_W24-1:0]),
						.tstate24					 (tstate24[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_824
		$display("(%m) UART24 INFO24: Data bus width is 8. No Debug24 interface.\n");
	`else
		$display("(%m) UART24 INFO24: Data bus width is 32. Debug24 Interface24 present24.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT24
		$display("(%m) UART24 INFO24: Has24 baudrate24 output\n");
	`else
		$display("(%m) UART24 INFO24: Doesn24't have baudrate24 output\n");
	`endif
end

endmodule


