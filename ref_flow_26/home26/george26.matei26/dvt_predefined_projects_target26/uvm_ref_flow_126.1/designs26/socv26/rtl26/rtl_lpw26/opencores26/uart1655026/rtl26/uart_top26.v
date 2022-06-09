//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top26.v                                                  ////
////                                                              ////
////                                                              ////
////  This26 file is part of the "UART26 16550 compatible26" project26    ////
////  http26://www26.opencores26.org26/cores26/uart1655026/                   ////
////                                                              ////
////  Documentation26 related26 to this project26:                      ////
////  - http26://www26.opencores26.org26/cores26/uart1655026/                 ////
////                                                              ////
////  Projects26 compatibility26:                                     ////
////  - WISHBONE26                                                  ////
////  RS23226 Protocol26                                              ////
////  16550D uart26 (mostly26 supported)                              ////
////                                                              ////
////  Overview26 (main26 Features26):                                   ////
////  UART26 core26 top level.                                        ////
////                                                              ////
////  Known26 problems26 (limits26):                                    ////
////  Note26 that transmitter26 and receiver26 instances26 are inside     ////
////  the uart_regs26.v file.                                       ////
////                                                              ////
////  To26 Do26:                                                      ////
////  Nothing so far26.                                             ////
////                                                              ////
////  Author26(s):                                                  ////
////      - gorban26@opencores26.org26                                  ////
////      - Jacob26 Gorban26                                          ////
////      - Igor26 Mohor26 (igorm26@opencores26.org26)                      ////
////                                                              ////
////  Created26:        2001/05/12                                  ////
////  Last26 Updated26:   2001/05/17                                  ////
////                  (See log26 for the revision26 history26)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2000, 2001 Authors26                             ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS26 Revision26 History26
//
// $Log: not supported by cvs2svn26 $
// Revision26 1.18  2002/07/22 23:02:23  gorban26
// Bug26 Fixes26:
//  * Possible26 loss of sync and bad26 reception26 of stop bit on slow26 baud26 rates26 fixed26.
//   Problem26 reported26 by Kenny26.Tung26.
//  * Bad (or lack26 of ) loopback26 handling26 fixed26. Reported26 by Cherry26 Withers26.
//
// Improvements26:
//  * Made26 FIFO's as general26 inferrable26 memory where possible26.
//  So26 on FPGA26 they should be inferred26 as RAM26 (Distributed26 RAM26 on Xilinx26).
//  This26 saves26 about26 1/3 of the Slice26 count and reduces26 P&R and synthesis26 times.
//
//  * Added26 optional26 baudrate26 output (baud_o26).
//  This26 is identical26 to BAUDOUT26* signal26 on 16550 chip26.
//  It outputs26 16xbit_clock_rate - the divided26 clock26.
//  It's disabled by default. Define26 UART_HAS_BAUDRATE_OUTPUT26 to use.
//
// Revision26 1.17  2001/12/19 08:40:03  mohor26
// Warnings26 fixed26 (unused26 signals26 removed).
//
// Revision26 1.16  2001/12/06 14:51:04  gorban26
// Bug26 in LSR26[0] is fixed26.
// All WISHBONE26 signals26 are now sampled26, so another26 wait-state is introduced26 on all transfers26.
//
// Revision26 1.15  2001/12/03 21:44:29  gorban26
// Updated26 specification26 documentation.
// Added26 full 32-bit data bus interface, now as default.
// Address is 5-bit wide26 in 32-bit data bus mode.
// Added26 wb_sel_i26 input to the core26. It's used in the 32-bit mode.
// Added26 debug26 interface with two26 32-bit read-only registers in 32-bit mode.
// Bits26 5 and 6 of LSR26 are now only cleared26 on TX26 FIFO write.
// My26 small test bench26 is modified to work26 with 32-bit mode.
//
// Revision26 1.14  2001/11/07 17:51:52  gorban26
// Heavily26 rewritten26 interrupt26 and LSR26 subsystems26.
// Many26 bugs26 hopefully26 squashed26.
//
// Revision26 1.13  2001/10/20 09:58:40  gorban26
// Small26 synopsis26 fixes26
//
// Revision26 1.12  2001/08/25 15:46:19  gorban26
// Modified26 port names again26
//
// Revision26 1.11  2001/08/24 21:01:12  mohor26
// Things26 connected26 to parity26 changed.
// Clock26 devider26 changed.
//
// Revision26 1.10  2001/08/23 16:05:05  mohor26
// Stop bit bug26 fixed26.
// Parity26 bug26 fixed26.
// WISHBONE26 read cycle bug26 fixed26,
// OE26 indicator26 (Overrun26 Error) bug26 fixed26.
// PE26 indicator26 (Parity26 Error) bug26 fixed26.
// Register read bug26 fixed26.
//
// Revision26 1.4  2001/05/31 20:08:01  gorban26
// FIFO changes26 and other corrections26.
//
// Revision26 1.3  2001/05/21 19:12:02  gorban26
// Corrected26 some26 Linter26 messages26.
//
// Revision26 1.2  2001/05/17 18:34:18  gorban26
// First26 'stable' release. Should26 be sythesizable26 now. Also26 added new header.
//
// Revision26 1.0  2001-05-17 21:27:12+02  jacob26
// Initial26 revision26
//
//
// synopsys26 translate_off26
`include "timescale.v"
// synopsys26 translate_on26

`include "uart_defines26.v"

module uart_top26	(
	wb_clk_i26, 
	
	// Wishbone26 signals26
	wb_rst_i26, wb_adr_i26, wb_dat_i26, wb_dat_o26, wb_we_i26, wb_stb_i26, wb_cyc_i26, wb_ack_o26, wb_sel_i26,
	int_o26, // interrupt26 request

	// UART26	signals26
	// serial26 input/output
	stx_pad_o26, srx_pad_i26,

	// modem26 signals26
	rts_pad_o26, cts_pad_i26, dtr_pad_o26, dsr_pad_i26, ri_pad_i26, dcd_pad_i26
`ifdef UART_HAS_BAUDRATE_OUTPUT26
	, baud_o26
`endif
	);

parameter 							 uart_data_width26 = `UART_DATA_WIDTH26;
parameter 							 uart_addr_width26 = `UART_ADDR_WIDTH26;

input 								 wb_clk_i26;

// WISHBONE26 interface
input 								 wb_rst_i26;
input [uart_addr_width26-1:0] 	 wb_adr_i26;
input [uart_data_width26-1:0] 	 wb_dat_i26;
output [uart_data_width26-1:0] 	 wb_dat_o26;
input 								 wb_we_i26;
input 								 wb_stb_i26;
input 								 wb_cyc_i26;
input [3:0]							 wb_sel_i26;
output 								 wb_ack_o26;
output 								 int_o26;

// UART26	signals26
input 								 srx_pad_i26;
output 								 stx_pad_o26;
output 								 rts_pad_o26;
input 								 cts_pad_i26;
output 								 dtr_pad_o26;
input 								 dsr_pad_i26;
input 								 ri_pad_i26;
input 								 dcd_pad_i26;

// optional26 baudrate26 output
`ifdef UART_HAS_BAUDRATE_OUTPUT26
output	baud_o26;
`endif


wire 									 stx_pad_o26;
wire 									 rts_pad_o26;
wire 									 dtr_pad_o26;

wire [uart_addr_width26-1:0] 	 wb_adr_i26;
wire [uart_data_width26-1:0] 	 wb_dat_i26;
wire [uart_data_width26-1:0] 	 wb_dat_o26;

wire [7:0] 							 wb_dat8_i26; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o26; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o26; // debug26 interface 32-bit output
wire [3:0] 							 wb_sel_i26;  // WISHBONE26 select26 signal26
wire [uart_addr_width26-1:0] 	 wb_adr_int26;
wire 									 we_o26;	// Write enable for registers
wire		          	     re_o26;	// Read enable for registers
//
// MODULE26 INSTANCES26
//

`ifdef DATA_BUS_WIDTH_826
`else
// debug26 interface wires26
wire	[3:0] ier26;
wire	[3:0] iir26;
wire	[1:0] fcr26;
wire	[4:0] mcr26;
wire	[7:0] lcr26;
wire	[7:0] msr26;
wire	[7:0] lsr26;
wire	[`UART_FIFO_COUNTER_W26-1:0] rf_count26;
wire	[`UART_FIFO_COUNTER_W26-1:0] tf_count26;
wire	[2:0] tstate26;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_826
////  WISHBONE26 interface module
uart_wb26		wb_interface26(
		.clk26(		wb_clk_i26		),
		.wb_rst_i26(	wb_rst_i26	),
	.wb_dat_i26(wb_dat_i26),
	.wb_dat_o26(wb_dat_o26),
	.wb_dat8_i26(wb_dat8_i26),
	.wb_dat8_o26(wb_dat8_o26),
	 .wb_dat32_o26(32'b0),								 
	 .wb_sel_i26(4'b0),
		.wb_we_i26(	wb_we_i26		),
		.wb_stb_i26(	wb_stb_i26	),
		.wb_cyc_i26(	wb_cyc_i26	),
		.wb_ack_o26(	wb_ack_o26	),
	.wb_adr_i26(wb_adr_i26),
	.wb_adr_int26(wb_adr_int26),
		.we_o26(		we_o26		),
		.re_o26(re_o26)
		);
`else
uart_wb26		wb_interface26(
		.clk26(		wb_clk_i26		),
		.wb_rst_i26(	wb_rst_i26	),
	.wb_dat_i26(wb_dat_i26),
	.wb_dat_o26(wb_dat_o26),
	.wb_dat8_i26(wb_dat8_i26),
	.wb_dat8_o26(wb_dat8_o26),
	 .wb_sel_i26(wb_sel_i26),
	 .wb_dat32_o26(wb_dat32_o26),								 
		.wb_we_i26(	wb_we_i26		),
		.wb_stb_i26(	wb_stb_i26	),
		.wb_cyc_i26(	wb_cyc_i26	),
		.wb_ack_o26(	wb_ack_o26	),
	.wb_adr_i26(wb_adr_i26),
	.wb_adr_int26(wb_adr_int26),
		.we_o26(		we_o26		),
		.re_o26(re_o26)
		);
`endif

// Registers26
uart_regs26	regs(
	.clk26(		wb_clk_i26		),
	.wb_rst_i26(	wb_rst_i26	),
	.wb_addr_i26(	wb_adr_int26	),
	.wb_dat_i26(	wb_dat8_i26	),
	.wb_dat_o26(	wb_dat8_o26	),
	.wb_we_i26(	we_o26		),
   .wb_re_i26(re_o26),
	.modem_inputs26(	{cts_pad_i26, dsr_pad_i26,
	ri_pad_i26,  dcd_pad_i26}	),
	.stx_pad_o26(		stx_pad_o26		),
	.srx_pad_i26(		srx_pad_i26		),
`ifdef DATA_BUS_WIDTH_826
`else
// debug26 interface signals26	enabled
.ier26(ier26), 
.iir26(iir26), 
.fcr26(fcr26), 
.mcr26(mcr26), 
.lcr26(lcr26), 
.msr26(msr26), 
.lsr26(lsr26), 
.rf_count26(rf_count26),
.tf_count26(tf_count26),
.tstate26(tstate26),
.rstate(rstate),
`endif					  
	.rts_pad_o26(		rts_pad_o26		),
	.dtr_pad_o26(		dtr_pad_o26		),
	.int_o26(		int_o26		)
`ifdef UART_HAS_BAUDRATE_OUTPUT26
	, .baud_o26(baud_o26)
`endif

);

`ifdef DATA_BUS_WIDTH_826
`else
uart_debug_if26 dbg26(/*AUTOINST26*/
						// Outputs26
						.wb_dat32_o26				 (wb_dat32_o26[31:0]),
						// Inputs26
						.wb_adr_i26				 (wb_adr_int26[`UART_ADDR_WIDTH26-1:0]),
						.ier26						 (ier26[3:0]),
						.iir26						 (iir26[3:0]),
						.fcr26						 (fcr26[1:0]),
						.mcr26						 (mcr26[4:0]),
						.lcr26						 (lcr26[7:0]),
						.msr26						 (msr26[7:0]),
						.lsr26						 (lsr26[7:0]),
						.rf_count26				 (rf_count26[`UART_FIFO_COUNTER_W26-1:0]),
						.tf_count26				 (tf_count26[`UART_FIFO_COUNTER_W26-1:0]),
						.tstate26					 (tstate26[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_826
		$display("(%m) UART26 INFO26: Data bus width is 8. No Debug26 interface.\n");
	`else
		$display("(%m) UART26 INFO26: Data bus width is 32. Debug26 Interface26 present26.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT26
		$display("(%m) UART26 INFO26: Has26 baudrate26 output\n");
	`else
		$display("(%m) UART26 INFO26: Doesn26't have baudrate26 output\n");
	`endif
end

endmodule


