//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top10.v                                                  ////
////                                                              ////
////                                                              ////
////  This10 file is part of the "UART10 16550 compatible10" project10    ////
////  http10://www10.opencores10.org10/cores10/uart1655010/                   ////
////                                                              ////
////  Documentation10 related10 to this project10:                      ////
////  - http10://www10.opencores10.org10/cores10/uart1655010/                 ////
////                                                              ////
////  Projects10 compatibility10:                                     ////
////  - WISHBONE10                                                  ////
////  RS23210 Protocol10                                              ////
////  16550D uart10 (mostly10 supported)                              ////
////                                                              ////
////  Overview10 (main10 Features10):                                   ////
////  UART10 core10 top level.                                        ////
////                                                              ////
////  Known10 problems10 (limits10):                                    ////
////  Note10 that transmitter10 and receiver10 instances10 are inside     ////
////  the uart_regs10.v file.                                       ////
////                                                              ////
////  To10 Do10:                                                      ////
////  Nothing so far10.                                             ////
////                                                              ////
////  Author10(s):                                                  ////
////      - gorban10@opencores10.org10                                  ////
////      - Jacob10 Gorban10                                          ////
////      - Igor10 Mohor10 (igorm10@opencores10.org10)                      ////
////                                                              ////
////  Created10:        2001/05/12                                  ////
////  Last10 Updated10:   2001/05/17                                  ////
////                  (See log10 for the revision10 history10)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright10 (C) 2000, 2001 Authors10                             ////
////                                                              ////
//// This10 source10 file may be used and distributed10 without         ////
//// restriction10 provided that this copyright10 statement10 is not    ////
//// removed from the file and that any derivative10 work10 contains10  ////
//// the original copyright10 notice10 and the associated disclaimer10. ////
////                                                              ////
//// This10 source10 file is free software10; you can redistribute10 it   ////
//// and/or modify it under the terms10 of the GNU10 Lesser10 General10   ////
//// Public10 License10 as published10 by the Free10 Software10 Foundation10; ////
//// either10 version10 2.1 of the License10, or (at your10 option) any   ////
//// later10 version10.                                               ////
////                                                              ////
//// This10 source10 is distributed10 in the hope10 that it will be       ////
//// useful10, but WITHOUT10 ANY10 WARRANTY10; without even10 the implied10   ////
//// warranty10 of MERCHANTABILITY10 or FITNESS10 FOR10 A PARTICULAR10      ////
//// PURPOSE10.  See the GNU10 Lesser10 General10 Public10 License10 for more ////
//// details10.                                                     ////
////                                                              ////
//// You should have received10 a copy of the GNU10 Lesser10 General10    ////
//// Public10 License10 along10 with this source10; if not, download10 it   ////
//// from http10://www10.opencores10.org10/lgpl10.shtml10                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS10 Revision10 History10
//
// $Log: not supported by cvs2svn10 $
// Revision10 1.18  2002/07/22 23:02:23  gorban10
// Bug10 Fixes10:
//  * Possible10 loss of sync and bad10 reception10 of stop bit on slow10 baud10 rates10 fixed10.
//   Problem10 reported10 by Kenny10.Tung10.
//  * Bad (or lack10 of ) loopback10 handling10 fixed10. Reported10 by Cherry10 Withers10.
//
// Improvements10:
//  * Made10 FIFO's as general10 inferrable10 memory where possible10.
//  So10 on FPGA10 they should be inferred10 as RAM10 (Distributed10 RAM10 on Xilinx10).
//  This10 saves10 about10 1/3 of the Slice10 count and reduces10 P&R and synthesis10 times.
//
//  * Added10 optional10 baudrate10 output (baud_o10).
//  This10 is identical10 to BAUDOUT10* signal10 on 16550 chip10.
//  It outputs10 16xbit_clock_rate - the divided10 clock10.
//  It's disabled by default. Define10 UART_HAS_BAUDRATE_OUTPUT10 to use.
//
// Revision10 1.17  2001/12/19 08:40:03  mohor10
// Warnings10 fixed10 (unused10 signals10 removed).
//
// Revision10 1.16  2001/12/06 14:51:04  gorban10
// Bug10 in LSR10[0] is fixed10.
// All WISHBONE10 signals10 are now sampled10, so another10 wait-state is introduced10 on all transfers10.
//
// Revision10 1.15  2001/12/03 21:44:29  gorban10
// Updated10 specification10 documentation.
// Added10 full 32-bit data bus interface, now as default.
// Address is 5-bit wide10 in 32-bit data bus mode.
// Added10 wb_sel_i10 input to the core10. It's used in the 32-bit mode.
// Added10 debug10 interface with two10 32-bit read-only registers in 32-bit mode.
// Bits10 5 and 6 of LSR10 are now only cleared10 on TX10 FIFO write.
// My10 small test bench10 is modified to work10 with 32-bit mode.
//
// Revision10 1.14  2001/11/07 17:51:52  gorban10
// Heavily10 rewritten10 interrupt10 and LSR10 subsystems10.
// Many10 bugs10 hopefully10 squashed10.
//
// Revision10 1.13  2001/10/20 09:58:40  gorban10
// Small10 synopsis10 fixes10
//
// Revision10 1.12  2001/08/25 15:46:19  gorban10
// Modified10 port names again10
//
// Revision10 1.11  2001/08/24 21:01:12  mohor10
// Things10 connected10 to parity10 changed.
// Clock10 devider10 changed.
//
// Revision10 1.10  2001/08/23 16:05:05  mohor10
// Stop bit bug10 fixed10.
// Parity10 bug10 fixed10.
// WISHBONE10 read cycle bug10 fixed10,
// OE10 indicator10 (Overrun10 Error) bug10 fixed10.
// PE10 indicator10 (Parity10 Error) bug10 fixed10.
// Register read bug10 fixed10.
//
// Revision10 1.4  2001/05/31 20:08:01  gorban10
// FIFO changes10 and other corrections10.
//
// Revision10 1.3  2001/05/21 19:12:02  gorban10
// Corrected10 some10 Linter10 messages10.
//
// Revision10 1.2  2001/05/17 18:34:18  gorban10
// First10 'stable' release. Should10 be sythesizable10 now. Also10 added new header.
//
// Revision10 1.0  2001-05-17 21:27:12+02  jacob10
// Initial10 revision10
//
//
// synopsys10 translate_off10
`include "timescale.v"
// synopsys10 translate_on10

`include "uart_defines10.v"

module uart_top10	(
	wb_clk_i10, 
	
	// Wishbone10 signals10
	wb_rst_i10, wb_adr_i10, wb_dat_i10, wb_dat_o10, wb_we_i10, wb_stb_i10, wb_cyc_i10, wb_ack_o10, wb_sel_i10,
	int_o10, // interrupt10 request

	// UART10	signals10
	// serial10 input/output
	stx_pad_o10, srx_pad_i10,

	// modem10 signals10
	rts_pad_o10, cts_pad_i10, dtr_pad_o10, dsr_pad_i10, ri_pad_i10, dcd_pad_i10
`ifdef UART_HAS_BAUDRATE_OUTPUT10
	, baud_o10
`endif
	);

parameter 							 uart_data_width10 = `UART_DATA_WIDTH10;
parameter 							 uart_addr_width10 = `UART_ADDR_WIDTH10;

input 								 wb_clk_i10;

// WISHBONE10 interface
input 								 wb_rst_i10;
input [uart_addr_width10-1:0] 	 wb_adr_i10;
input [uart_data_width10-1:0] 	 wb_dat_i10;
output [uart_data_width10-1:0] 	 wb_dat_o10;
input 								 wb_we_i10;
input 								 wb_stb_i10;
input 								 wb_cyc_i10;
input [3:0]							 wb_sel_i10;
output 								 wb_ack_o10;
output 								 int_o10;

// UART10	signals10
input 								 srx_pad_i10;
output 								 stx_pad_o10;
output 								 rts_pad_o10;
input 								 cts_pad_i10;
output 								 dtr_pad_o10;
input 								 dsr_pad_i10;
input 								 ri_pad_i10;
input 								 dcd_pad_i10;

// optional10 baudrate10 output
`ifdef UART_HAS_BAUDRATE_OUTPUT10
output	baud_o10;
`endif


wire 									 stx_pad_o10;
wire 									 rts_pad_o10;
wire 									 dtr_pad_o10;

wire [uart_addr_width10-1:0] 	 wb_adr_i10;
wire [uart_data_width10-1:0] 	 wb_dat_i10;
wire [uart_data_width10-1:0] 	 wb_dat_o10;

wire [7:0] 							 wb_dat8_i10; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o10; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o10; // debug10 interface 32-bit output
wire [3:0] 							 wb_sel_i10;  // WISHBONE10 select10 signal10
wire [uart_addr_width10-1:0] 	 wb_adr_int10;
wire 									 we_o10;	// Write enable for registers
wire		          	     re_o10;	// Read enable for registers
//
// MODULE10 INSTANCES10
//

`ifdef DATA_BUS_WIDTH_810
`else
// debug10 interface wires10
wire	[3:0] ier10;
wire	[3:0] iir10;
wire	[1:0] fcr10;
wire	[4:0] mcr10;
wire	[7:0] lcr10;
wire	[7:0] msr10;
wire	[7:0] lsr10;
wire	[`UART_FIFO_COUNTER_W10-1:0] rf_count10;
wire	[`UART_FIFO_COUNTER_W10-1:0] tf_count10;
wire	[2:0] tstate10;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_810
////  WISHBONE10 interface module
uart_wb10		wb_interface10(
		.clk10(		wb_clk_i10		),
		.wb_rst_i10(	wb_rst_i10	),
	.wb_dat_i10(wb_dat_i10),
	.wb_dat_o10(wb_dat_o10),
	.wb_dat8_i10(wb_dat8_i10),
	.wb_dat8_o10(wb_dat8_o10),
	 .wb_dat32_o10(32'b0),								 
	 .wb_sel_i10(4'b0),
		.wb_we_i10(	wb_we_i10		),
		.wb_stb_i10(	wb_stb_i10	),
		.wb_cyc_i10(	wb_cyc_i10	),
		.wb_ack_o10(	wb_ack_o10	),
	.wb_adr_i10(wb_adr_i10),
	.wb_adr_int10(wb_adr_int10),
		.we_o10(		we_o10		),
		.re_o10(re_o10)
		);
`else
uart_wb10		wb_interface10(
		.clk10(		wb_clk_i10		),
		.wb_rst_i10(	wb_rst_i10	),
	.wb_dat_i10(wb_dat_i10),
	.wb_dat_o10(wb_dat_o10),
	.wb_dat8_i10(wb_dat8_i10),
	.wb_dat8_o10(wb_dat8_o10),
	 .wb_sel_i10(wb_sel_i10),
	 .wb_dat32_o10(wb_dat32_o10),								 
		.wb_we_i10(	wb_we_i10		),
		.wb_stb_i10(	wb_stb_i10	),
		.wb_cyc_i10(	wb_cyc_i10	),
		.wb_ack_o10(	wb_ack_o10	),
	.wb_adr_i10(wb_adr_i10),
	.wb_adr_int10(wb_adr_int10),
		.we_o10(		we_o10		),
		.re_o10(re_o10)
		);
`endif

// Registers10
uart_regs10	regs(
	.clk10(		wb_clk_i10		),
	.wb_rst_i10(	wb_rst_i10	),
	.wb_addr_i10(	wb_adr_int10	),
	.wb_dat_i10(	wb_dat8_i10	),
	.wb_dat_o10(	wb_dat8_o10	),
	.wb_we_i10(	we_o10		),
   .wb_re_i10(re_o10),
	.modem_inputs10(	{cts_pad_i10, dsr_pad_i10,
	ri_pad_i10,  dcd_pad_i10}	),
	.stx_pad_o10(		stx_pad_o10		),
	.srx_pad_i10(		srx_pad_i10		),
`ifdef DATA_BUS_WIDTH_810
`else
// debug10 interface signals10	enabled
.ier10(ier10), 
.iir10(iir10), 
.fcr10(fcr10), 
.mcr10(mcr10), 
.lcr10(lcr10), 
.msr10(msr10), 
.lsr10(lsr10), 
.rf_count10(rf_count10),
.tf_count10(tf_count10),
.tstate10(tstate10),
.rstate(rstate),
`endif					  
	.rts_pad_o10(		rts_pad_o10		),
	.dtr_pad_o10(		dtr_pad_o10		),
	.int_o10(		int_o10		)
`ifdef UART_HAS_BAUDRATE_OUTPUT10
	, .baud_o10(baud_o10)
`endif

);

`ifdef DATA_BUS_WIDTH_810
`else
uart_debug_if10 dbg10(/*AUTOINST10*/
						// Outputs10
						.wb_dat32_o10				 (wb_dat32_o10[31:0]),
						// Inputs10
						.wb_adr_i10				 (wb_adr_int10[`UART_ADDR_WIDTH10-1:0]),
						.ier10						 (ier10[3:0]),
						.iir10						 (iir10[3:0]),
						.fcr10						 (fcr10[1:0]),
						.mcr10						 (mcr10[4:0]),
						.lcr10						 (lcr10[7:0]),
						.msr10						 (msr10[7:0]),
						.lsr10						 (lsr10[7:0]),
						.rf_count10				 (rf_count10[`UART_FIFO_COUNTER_W10-1:0]),
						.tf_count10				 (tf_count10[`UART_FIFO_COUNTER_W10-1:0]),
						.tstate10					 (tstate10[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_810
		$display("(%m) UART10 INFO10: Data bus width is 8. No Debug10 interface.\n");
	`else
		$display("(%m) UART10 INFO10: Data bus width is 32. Debug10 Interface10 present10.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT10
		$display("(%m) UART10 INFO10: Has10 baudrate10 output\n");
	`else
		$display("(%m) UART10 INFO10: Doesn10't have baudrate10 output\n");
	`endif
end

endmodule


