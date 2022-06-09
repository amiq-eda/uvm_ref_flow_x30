//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top9.v                                                  ////
////                                                              ////
////                                                              ////
////  This9 file is part of the "UART9 16550 compatible9" project9    ////
////  http9://www9.opencores9.org9/cores9/uart165509/                   ////
////                                                              ////
////  Documentation9 related9 to this project9:                      ////
////  - http9://www9.opencores9.org9/cores9/uart165509/                 ////
////                                                              ////
////  Projects9 compatibility9:                                     ////
////  - WISHBONE9                                                  ////
////  RS2329 Protocol9                                              ////
////  16550D uart9 (mostly9 supported)                              ////
////                                                              ////
////  Overview9 (main9 Features9):                                   ////
////  UART9 core9 top level.                                        ////
////                                                              ////
////  Known9 problems9 (limits9):                                    ////
////  Note9 that transmitter9 and receiver9 instances9 are inside     ////
////  the uart_regs9.v file.                                       ////
////                                                              ////
////  To9 Do9:                                                      ////
////  Nothing so far9.                                             ////
////                                                              ////
////  Author9(s):                                                  ////
////      - gorban9@opencores9.org9                                  ////
////      - Jacob9 Gorban9                                          ////
////      - Igor9 Mohor9 (igorm9@opencores9.org9)                      ////
////                                                              ////
////  Created9:        2001/05/12                                  ////
////  Last9 Updated9:   2001/05/17                                  ////
////                  (See log9 for the revision9 history9)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2000, 2001 Authors9                             ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS9 Revision9 History9
//
// $Log: not supported by cvs2svn9 $
// Revision9 1.18  2002/07/22 23:02:23  gorban9
// Bug9 Fixes9:
//  * Possible9 loss of sync and bad9 reception9 of stop bit on slow9 baud9 rates9 fixed9.
//   Problem9 reported9 by Kenny9.Tung9.
//  * Bad (or lack9 of ) loopback9 handling9 fixed9. Reported9 by Cherry9 Withers9.
//
// Improvements9:
//  * Made9 FIFO's as general9 inferrable9 memory where possible9.
//  So9 on FPGA9 they should be inferred9 as RAM9 (Distributed9 RAM9 on Xilinx9).
//  This9 saves9 about9 1/3 of the Slice9 count and reduces9 P&R and synthesis9 times.
//
//  * Added9 optional9 baudrate9 output (baud_o9).
//  This9 is identical9 to BAUDOUT9* signal9 on 16550 chip9.
//  It outputs9 16xbit_clock_rate - the divided9 clock9.
//  It's disabled by default. Define9 UART_HAS_BAUDRATE_OUTPUT9 to use.
//
// Revision9 1.17  2001/12/19 08:40:03  mohor9
// Warnings9 fixed9 (unused9 signals9 removed).
//
// Revision9 1.16  2001/12/06 14:51:04  gorban9
// Bug9 in LSR9[0] is fixed9.
// All WISHBONE9 signals9 are now sampled9, so another9 wait-state is introduced9 on all transfers9.
//
// Revision9 1.15  2001/12/03 21:44:29  gorban9
// Updated9 specification9 documentation.
// Added9 full 32-bit data bus interface, now as default.
// Address is 5-bit wide9 in 32-bit data bus mode.
// Added9 wb_sel_i9 input to the core9. It's used in the 32-bit mode.
// Added9 debug9 interface with two9 32-bit read-only registers in 32-bit mode.
// Bits9 5 and 6 of LSR9 are now only cleared9 on TX9 FIFO write.
// My9 small test bench9 is modified to work9 with 32-bit mode.
//
// Revision9 1.14  2001/11/07 17:51:52  gorban9
// Heavily9 rewritten9 interrupt9 and LSR9 subsystems9.
// Many9 bugs9 hopefully9 squashed9.
//
// Revision9 1.13  2001/10/20 09:58:40  gorban9
// Small9 synopsis9 fixes9
//
// Revision9 1.12  2001/08/25 15:46:19  gorban9
// Modified9 port names again9
//
// Revision9 1.11  2001/08/24 21:01:12  mohor9
// Things9 connected9 to parity9 changed.
// Clock9 devider9 changed.
//
// Revision9 1.10  2001/08/23 16:05:05  mohor9
// Stop bit bug9 fixed9.
// Parity9 bug9 fixed9.
// WISHBONE9 read cycle bug9 fixed9,
// OE9 indicator9 (Overrun9 Error) bug9 fixed9.
// PE9 indicator9 (Parity9 Error) bug9 fixed9.
// Register read bug9 fixed9.
//
// Revision9 1.4  2001/05/31 20:08:01  gorban9
// FIFO changes9 and other corrections9.
//
// Revision9 1.3  2001/05/21 19:12:02  gorban9
// Corrected9 some9 Linter9 messages9.
//
// Revision9 1.2  2001/05/17 18:34:18  gorban9
// First9 'stable' release. Should9 be sythesizable9 now. Also9 added new header.
//
// Revision9 1.0  2001-05-17 21:27:12+02  jacob9
// Initial9 revision9
//
//
// synopsys9 translate_off9
`include "timescale.v"
// synopsys9 translate_on9

`include "uart_defines9.v"

module uart_top9	(
	wb_clk_i9, 
	
	// Wishbone9 signals9
	wb_rst_i9, wb_adr_i9, wb_dat_i9, wb_dat_o9, wb_we_i9, wb_stb_i9, wb_cyc_i9, wb_ack_o9, wb_sel_i9,
	int_o9, // interrupt9 request

	// UART9	signals9
	// serial9 input/output
	stx_pad_o9, srx_pad_i9,

	// modem9 signals9
	rts_pad_o9, cts_pad_i9, dtr_pad_o9, dsr_pad_i9, ri_pad_i9, dcd_pad_i9
`ifdef UART_HAS_BAUDRATE_OUTPUT9
	, baud_o9
`endif
	);

parameter 							 uart_data_width9 = `UART_DATA_WIDTH9;
parameter 							 uart_addr_width9 = `UART_ADDR_WIDTH9;

input 								 wb_clk_i9;

// WISHBONE9 interface
input 								 wb_rst_i9;
input [uart_addr_width9-1:0] 	 wb_adr_i9;
input [uart_data_width9-1:0] 	 wb_dat_i9;
output [uart_data_width9-1:0] 	 wb_dat_o9;
input 								 wb_we_i9;
input 								 wb_stb_i9;
input 								 wb_cyc_i9;
input [3:0]							 wb_sel_i9;
output 								 wb_ack_o9;
output 								 int_o9;

// UART9	signals9
input 								 srx_pad_i9;
output 								 stx_pad_o9;
output 								 rts_pad_o9;
input 								 cts_pad_i9;
output 								 dtr_pad_o9;
input 								 dsr_pad_i9;
input 								 ri_pad_i9;
input 								 dcd_pad_i9;

// optional9 baudrate9 output
`ifdef UART_HAS_BAUDRATE_OUTPUT9
output	baud_o9;
`endif


wire 									 stx_pad_o9;
wire 									 rts_pad_o9;
wire 									 dtr_pad_o9;

wire [uart_addr_width9-1:0] 	 wb_adr_i9;
wire [uart_data_width9-1:0] 	 wb_dat_i9;
wire [uart_data_width9-1:0] 	 wb_dat_o9;

wire [7:0] 							 wb_dat8_i9; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o9; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o9; // debug9 interface 32-bit output
wire [3:0] 							 wb_sel_i9;  // WISHBONE9 select9 signal9
wire [uart_addr_width9-1:0] 	 wb_adr_int9;
wire 									 we_o9;	// Write enable for registers
wire		          	     re_o9;	// Read enable for registers
//
// MODULE9 INSTANCES9
//

`ifdef DATA_BUS_WIDTH_89
`else
// debug9 interface wires9
wire	[3:0] ier9;
wire	[3:0] iir9;
wire	[1:0] fcr9;
wire	[4:0] mcr9;
wire	[7:0] lcr9;
wire	[7:0] msr9;
wire	[7:0] lsr9;
wire	[`UART_FIFO_COUNTER_W9-1:0] rf_count9;
wire	[`UART_FIFO_COUNTER_W9-1:0] tf_count9;
wire	[2:0] tstate9;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_89
////  WISHBONE9 interface module
uart_wb9		wb_interface9(
		.clk9(		wb_clk_i9		),
		.wb_rst_i9(	wb_rst_i9	),
	.wb_dat_i9(wb_dat_i9),
	.wb_dat_o9(wb_dat_o9),
	.wb_dat8_i9(wb_dat8_i9),
	.wb_dat8_o9(wb_dat8_o9),
	 .wb_dat32_o9(32'b0),								 
	 .wb_sel_i9(4'b0),
		.wb_we_i9(	wb_we_i9		),
		.wb_stb_i9(	wb_stb_i9	),
		.wb_cyc_i9(	wb_cyc_i9	),
		.wb_ack_o9(	wb_ack_o9	),
	.wb_adr_i9(wb_adr_i9),
	.wb_adr_int9(wb_adr_int9),
		.we_o9(		we_o9		),
		.re_o9(re_o9)
		);
`else
uart_wb9		wb_interface9(
		.clk9(		wb_clk_i9		),
		.wb_rst_i9(	wb_rst_i9	),
	.wb_dat_i9(wb_dat_i9),
	.wb_dat_o9(wb_dat_o9),
	.wb_dat8_i9(wb_dat8_i9),
	.wb_dat8_o9(wb_dat8_o9),
	 .wb_sel_i9(wb_sel_i9),
	 .wb_dat32_o9(wb_dat32_o9),								 
		.wb_we_i9(	wb_we_i9		),
		.wb_stb_i9(	wb_stb_i9	),
		.wb_cyc_i9(	wb_cyc_i9	),
		.wb_ack_o9(	wb_ack_o9	),
	.wb_adr_i9(wb_adr_i9),
	.wb_adr_int9(wb_adr_int9),
		.we_o9(		we_o9		),
		.re_o9(re_o9)
		);
`endif

// Registers9
uart_regs9	regs(
	.clk9(		wb_clk_i9		),
	.wb_rst_i9(	wb_rst_i9	),
	.wb_addr_i9(	wb_adr_int9	),
	.wb_dat_i9(	wb_dat8_i9	),
	.wb_dat_o9(	wb_dat8_o9	),
	.wb_we_i9(	we_o9		),
   .wb_re_i9(re_o9),
	.modem_inputs9(	{cts_pad_i9, dsr_pad_i9,
	ri_pad_i9,  dcd_pad_i9}	),
	.stx_pad_o9(		stx_pad_o9		),
	.srx_pad_i9(		srx_pad_i9		),
`ifdef DATA_BUS_WIDTH_89
`else
// debug9 interface signals9	enabled
.ier9(ier9), 
.iir9(iir9), 
.fcr9(fcr9), 
.mcr9(mcr9), 
.lcr9(lcr9), 
.msr9(msr9), 
.lsr9(lsr9), 
.rf_count9(rf_count9),
.tf_count9(tf_count9),
.tstate9(tstate9),
.rstate(rstate),
`endif					  
	.rts_pad_o9(		rts_pad_o9		),
	.dtr_pad_o9(		dtr_pad_o9		),
	.int_o9(		int_o9		)
`ifdef UART_HAS_BAUDRATE_OUTPUT9
	, .baud_o9(baud_o9)
`endif

);

`ifdef DATA_BUS_WIDTH_89
`else
uart_debug_if9 dbg9(/*AUTOINST9*/
						// Outputs9
						.wb_dat32_o9				 (wb_dat32_o9[31:0]),
						// Inputs9
						.wb_adr_i9				 (wb_adr_int9[`UART_ADDR_WIDTH9-1:0]),
						.ier9						 (ier9[3:0]),
						.iir9						 (iir9[3:0]),
						.fcr9						 (fcr9[1:0]),
						.mcr9						 (mcr9[4:0]),
						.lcr9						 (lcr9[7:0]),
						.msr9						 (msr9[7:0]),
						.lsr9						 (lsr9[7:0]),
						.rf_count9				 (rf_count9[`UART_FIFO_COUNTER_W9-1:0]),
						.tf_count9				 (tf_count9[`UART_FIFO_COUNTER_W9-1:0]),
						.tstate9					 (tstate9[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_89
		$display("(%m) UART9 INFO9: Data bus width is 8. No Debug9 interface.\n");
	`else
		$display("(%m) UART9 INFO9: Data bus width is 32. Debug9 Interface9 present9.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT9
		$display("(%m) UART9 INFO9: Has9 baudrate9 output\n");
	`else
		$display("(%m) UART9 INFO9: Doesn9't have baudrate9 output\n");
	`endif
end

endmodule


