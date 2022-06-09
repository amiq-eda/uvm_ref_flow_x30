//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top6.v                                                  ////
////                                                              ////
////                                                              ////
////  This6 file is part of the "UART6 16550 compatible6" project6    ////
////  http6://www6.opencores6.org6/cores6/uart165506/                   ////
////                                                              ////
////  Documentation6 related6 to this project6:                      ////
////  - http6://www6.opencores6.org6/cores6/uart165506/                 ////
////                                                              ////
////  Projects6 compatibility6:                                     ////
////  - WISHBONE6                                                  ////
////  RS2326 Protocol6                                              ////
////  16550D uart6 (mostly6 supported)                              ////
////                                                              ////
////  Overview6 (main6 Features6):                                   ////
////  UART6 core6 top level.                                        ////
////                                                              ////
////  Known6 problems6 (limits6):                                    ////
////  Note6 that transmitter6 and receiver6 instances6 are inside     ////
////  the uart_regs6.v file.                                       ////
////                                                              ////
////  To6 Do6:                                                      ////
////  Nothing so far6.                                             ////
////                                                              ////
////  Author6(s):                                                  ////
////      - gorban6@opencores6.org6                                  ////
////      - Jacob6 Gorban6                                          ////
////      - Igor6 Mohor6 (igorm6@opencores6.org6)                      ////
////                                                              ////
////  Created6:        2001/05/12                                  ////
////  Last6 Updated6:   2001/05/17                                  ////
////                  (See log6 for the revision6 history6)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2000, 2001 Authors6                             ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS6 Revision6 History6
//
// $Log: not supported by cvs2svn6 $
// Revision6 1.18  2002/07/22 23:02:23  gorban6
// Bug6 Fixes6:
//  * Possible6 loss of sync and bad6 reception6 of stop bit on slow6 baud6 rates6 fixed6.
//   Problem6 reported6 by Kenny6.Tung6.
//  * Bad (or lack6 of ) loopback6 handling6 fixed6. Reported6 by Cherry6 Withers6.
//
// Improvements6:
//  * Made6 FIFO's as general6 inferrable6 memory where possible6.
//  So6 on FPGA6 they should be inferred6 as RAM6 (Distributed6 RAM6 on Xilinx6).
//  This6 saves6 about6 1/3 of the Slice6 count and reduces6 P&R and synthesis6 times.
//
//  * Added6 optional6 baudrate6 output (baud_o6).
//  This6 is identical6 to BAUDOUT6* signal6 on 16550 chip6.
//  It outputs6 16xbit_clock_rate - the divided6 clock6.
//  It's disabled by default. Define6 UART_HAS_BAUDRATE_OUTPUT6 to use.
//
// Revision6 1.17  2001/12/19 08:40:03  mohor6
// Warnings6 fixed6 (unused6 signals6 removed).
//
// Revision6 1.16  2001/12/06 14:51:04  gorban6
// Bug6 in LSR6[0] is fixed6.
// All WISHBONE6 signals6 are now sampled6, so another6 wait-state is introduced6 on all transfers6.
//
// Revision6 1.15  2001/12/03 21:44:29  gorban6
// Updated6 specification6 documentation.
// Added6 full 32-bit data bus interface, now as default.
// Address is 5-bit wide6 in 32-bit data bus mode.
// Added6 wb_sel_i6 input to the core6. It's used in the 32-bit mode.
// Added6 debug6 interface with two6 32-bit read-only registers in 32-bit mode.
// Bits6 5 and 6 of LSR6 are now only cleared6 on TX6 FIFO write.
// My6 small test bench6 is modified to work6 with 32-bit mode.
//
// Revision6 1.14  2001/11/07 17:51:52  gorban6
// Heavily6 rewritten6 interrupt6 and LSR6 subsystems6.
// Many6 bugs6 hopefully6 squashed6.
//
// Revision6 1.13  2001/10/20 09:58:40  gorban6
// Small6 synopsis6 fixes6
//
// Revision6 1.12  2001/08/25 15:46:19  gorban6
// Modified6 port names again6
//
// Revision6 1.11  2001/08/24 21:01:12  mohor6
// Things6 connected6 to parity6 changed.
// Clock6 devider6 changed.
//
// Revision6 1.10  2001/08/23 16:05:05  mohor6
// Stop bit bug6 fixed6.
// Parity6 bug6 fixed6.
// WISHBONE6 read cycle bug6 fixed6,
// OE6 indicator6 (Overrun6 Error) bug6 fixed6.
// PE6 indicator6 (Parity6 Error) bug6 fixed6.
// Register read bug6 fixed6.
//
// Revision6 1.4  2001/05/31 20:08:01  gorban6
// FIFO changes6 and other corrections6.
//
// Revision6 1.3  2001/05/21 19:12:02  gorban6
// Corrected6 some6 Linter6 messages6.
//
// Revision6 1.2  2001/05/17 18:34:18  gorban6
// First6 'stable' release. Should6 be sythesizable6 now. Also6 added new header.
//
// Revision6 1.0  2001-05-17 21:27:12+02  jacob6
// Initial6 revision6
//
//
// synopsys6 translate_off6
`include "timescale.v"
// synopsys6 translate_on6

`include "uart_defines6.v"

module uart_top6	(
	wb_clk_i6, 
	
	// Wishbone6 signals6
	wb_rst_i6, wb_adr_i6, wb_dat_i6, wb_dat_o6, wb_we_i6, wb_stb_i6, wb_cyc_i6, wb_ack_o6, wb_sel_i6,
	int_o6, // interrupt6 request

	// UART6	signals6
	// serial6 input/output
	stx_pad_o6, srx_pad_i6,

	// modem6 signals6
	rts_pad_o6, cts_pad_i6, dtr_pad_o6, dsr_pad_i6, ri_pad_i6, dcd_pad_i6
`ifdef UART_HAS_BAUDRATE_OUTPUT6
	, baud_o6
`endif
	);

parameter 							 uart_data_width6 = `UART_DATA_WIDTH6;
parameter 							 uart_addr_width6 = `UART_ADDR_WIDTH6;

input 								 wb_clk_i6;

// WISHBONE6 interface
input 								 wb_rst_i6;
input [uart_addr_width6-1:0] 	 wb_adr_i6;
input [uart_data_width6-1:0] 	 wb_dat_i6;
output [uart_data_width6-1:0] 	 wb_dat_o6;
input 								 wb_we_i6;
input 								 wb_stb_i6;
input 								 wb_cyc_i6;
input [3:0]							 wb_sel_i6;
output 								 wb_ack_o6;
output 								 int_o6;

// UART6	signals6
input 								 srx_pad_i6;
output 								 stx_pad_o6;
output 								 rts_pad_o6;
input 								 cts_pad_i6;
output 								 dtr_pad_o6;
input 								 dsr_pad_i6;
input 								 ri_pad_i6;
input 								 dcd_pad_i6;

// optional6 baudrate6 output
`ifdef UART_HAS_BAUDRATE_OUTPUT6
output	baud_o6;
`endif


wire 									 stx_pad_o6;
wire 									 rts_pad_o6;
wire 									 dtr_pad_o6;

wire [uart_addr_width6-1:0] 	 wb_adr_i6;
wire [uart_data_width6-1:0] 	 wb_dat_i6;
wire [uart_data_width6-1:0] 	 wb_dat_o6;

wire [7:0] 							 wb_dat8_i6; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o6; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o6; // debug6 interface 32-bit output
wire [3:0] 							 wb_sel_i6;  // WISHBONE6 select6 signal6
wire [uart_addr_width6-1:0] 	 wb_adr_int6;
wire 									 we_o6;	// Write enable for registers
wire		          	     re_o6;	// Read enable for registers
//
// MODULE6 INSTANCES6
//

`ifdef DATA_BUS_WIDTH_86
`else
// debug6 interface wires6
wire	[3:0] ier6;
wire	[3:0] iir6;
wire	[1:0] fcr6;
wire	[4:0] mcr6;
wire	[7:0] lcr6;
wire	[7:0] msr6;
wire	[7:0] lsr6;
wire	[`UART_FIFO_COUNTER_W6-1:0] rf_count6;
wire	[`UART_FIFO_COUNTER_W6-1:0] tf_count6;
wire	[2:0] tstate6;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_86
////  WISHBONE6 interface module
uart_wb6		wb_interface6(
		.clk6(		wb_clk_i6		),
		.wb_rst_i6(	wb_rst_i6	),
	.wb_dat_i6(wb_dat_i6),
	.wb_dat_o6(wb_dat_o6),
	.wb_dat8_i6(wb_dat8_i6),
	.wb_dat8_o6(wb_dat8_o6),
	 .wb_dat32_o6(32'b0),								 
	 .wb_sel_i6(4'b0),
		.wb_we_i6(	wb_we_i6		),
		.wb_stb_i6(	wb_stb_i6	),
		.wb_cyc_i6(	wb_cyc_i6	),
		.wb_ack_o6(	wb_ack_o6	),
	.wb_adr_i6(wb_adr_i6),
	.wb_adr_int6(wb_adr_int6),
		.we_o6(		we_o6		),
		.re_o6(re_o6)
		);
`else
uart_wb6		wb_interface6(
		.clk6(		wb_clk_i6		),
		.wb_rst_i6(	wb_rst_i6	),
	.wb_dat_i6(wb_dat_i6),
	.wb_dat_o6(wb_dat_o6),
	.wb_dat8_i6(wb_dat8_i6),
	.wb_dat8_o6(wb_dat8_o6),
	 .wb_sel_i6(wb_sel_i6),
	 .wb_dat32_o6(wb_dat32_o6),								 
		.wb_we_i6(	wb_we_i6		),
		.wb_stb_i6(	wb_stb_i6	),
		.wb_cyc_i6(	wb_cyc_i6	),
		.wb_ack_o6(	wb_ack_o6	),
	.wb_adr_i6(wb_adr_i6),
	.wb_adr_int6(wb_adr_int6),
		.we_o6(		we_o6		),
		.re_o6(re_o6)
		);
`endif

// Registers6
uart_regs6	regs(
	.clk6(		wb_clk_i6		),
	.wb_rst_i6(	wb_rst_i6	),
	.wb_addr_i6(	wb_adr_int6	),
	.wb_dat_i6(	wb_dat8_i6	),
	.wb_dat_o6(	wb_dat8_o6	),
	.wb_we_i6(	we_o6		),
   .wb_re_i6(re_o6),
	.modem_inputs6(	{cts_pad_i6, dsr_pad_i6,
	ri_pad_i6,  dcd_pad_i6}	),
	.stx_pad_o6(		stx_pad_o6		),
	.srx_pad_i6(		srx_pad_i6		),
`ifdef DATA_BUS_WIDTH_86
`else
// debug6 interface signals6	enabled
.ier6(ier6), 
.iir6(iir6), 
.fcr6(fcr6), 
.mcr6(mcr6), 
.lcr6(lcr6), 
.msr6(msr6), 
.lsr6(lsr6), 
.rf_count6(rf_count6),
.tf_count6(tf_count6),
.tstate6(tstate6),
.rstate(rstate),
`endif					  
	.rts_pad_o6(		rts_pad_o6		),
	.dtr_pad_o6(		dtr_pad_o6		),
	.int_o6(		int_o6		)
`ifdef UART_HAS_BAUDRATE_OUTPUT6
	, .baud_o6(baud_o6)
`endif

);

`ifdef DATA_BUS_WIDTH_86
`else
uart_debug_if6 dbg6(/*AUTOINST6*/
						// Outputs6
						.wb_dat32_o6				 (wb_dat32_o6[31:0]),
						// Inputs6
						.wb_adr_i6				 (wb_adr_int6[`UART_ADDR_WIDTH6-1:0]),
						.ier6						 (ier6[3:0]),
						.iir6						 (iir6[3:0]),
						.fcr6						 (fcr6[1:0]),
						.mcr6						 (mcr6[4:0]),
						.lcr6						 (lcr6[7:0]),
						.msr6						 (msr6[7:0]),
						.lsr6						 (lsr6[7:0]),
						.rf_count6				 (rf_count6[`UART_FIFO_COUNTER_W6-1:0]),
						.tf_count6				 (tf_count6[`UART_FIFO_COUNTER_W6-1:0]),
						.tstate6					 (tstate6[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_86
		$display("(%m) UART6 INFO6: Data bus width is 8. No Debug6 interface.\n");
	`else
		$display("(%m) UART6 INFO6: Data bus width is 32. Debug6 Interface6 present6.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT6
		$display("(%m) UART6 INFO6: Has6 baudrate6 output\n");
	`else
		$display("(%m) UART6 INFO6: Doesn6't have baudrate6 output\n");
	`endif
end

endmodule


