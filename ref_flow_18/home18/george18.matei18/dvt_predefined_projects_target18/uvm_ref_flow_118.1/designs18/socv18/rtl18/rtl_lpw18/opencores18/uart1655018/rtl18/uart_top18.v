//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top18.v                                                  ////
////                                                              ////
////                                                              ////
////  This18 file is part of the "UART18 16550 compatible18" project18    ////
////  http18://www18.opencores18.org18/cores18/uart1655018/                   ////
////                                                              ////
////  Documentation18 related18 to this project18:                      ////
////  - http18://www18.opencores18.org18/cores18/uart1655018/                 ////
////                                                              ////
////  Projects18 compatibility18:                                     ////
////  - WISHBONE18                                                  ////
////  RS23218 Protocol18                                              ////
////  16550D uart18 (mostly18 supported)                              ////
////                                                              ////
////  Overview18 (main18 Features18):                                   ////
////  UART18 core18 top level.                                        ////
////                                                              ////
////  Known18 problems18 (limits18):                                    ////
////  Note18 that transmitter18 and receiver18 instances18 are inside     ////
////  the uart_regs18.v file.                                       ////
////                                                              ////
////  To18 Do18:                                                      ////
////  Nothing so far18.                                             ////
////                                                              ////
////  Author18(s):                                                  ////
////      - gorban18@opencores18.org18                                  ////
////      - Jacob18 Gorban18                                          ////
////      - Igor18 Mohor18 (igorm18@opencores18.org18)                      ////
////                                                              ////
////  Created18:        2001/05/12                                  ////
////  Last18 Updated18:   2001/05/17                                  ////
////                  (See log18 for the revision18 history18)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2000, 2001 Authors18                             ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS18 Revision18 History18
//
// $Log: not supported by cvs2svn18 $
// Revision18 1.18  2002/07/22 23:02:23  gorban18
// Bug18 Fixes18:
//  * Possible18 loss of sync and bad18 reception18 of stop bit on slow18 baud18 rates18 fixed18.
//   Problem18 reported18 by Kenny18.Tung18.
//  * Bad (or lack18 of ) loopback18 handling18 fixed18. Reported18 by Cherry18 Withers18.
//
// Improvements18:
//  * Made18 FIFO's as general18 inferrable18 memory where possible18.
//  So18 on FPGA18 they should be inferred18 as RAM18 (Distributed18 RAM18 on Xilinx18).
//  This18 saves18 about18 1/3 of the Slice18 count and reduces18 P&R and synthesis18 times.
//
//  * Added18 optional18 baudrate18 output (baud_o18).
//  This18 is identical18 to BAUDOUT18* signal18 on 16550 chip18.
//  It outputs18 16xbit_clock_rate - the divided18 clock18.
//  It's disabled by default. Define18 UART_HAS_BAUDRATE_OUTPUT18 to use.
//
// Revision18 1.17  2001/12/19 08:40:03  mohor18
// Warnings18 fixed18 (unused18 signals18 removed).
//
// Revision18 1.16  2001/12/06 14:51:04  gorban18
// Bug18 in LSR18[0] is fixed18.
// All WISHBONE18 signals18 are now sampled18, so another18 wait-state is introduced18 on all transfers18.
//
// Revision18 1.15  2001/12/03 21:44:29  gorban18
// Updated18 specification18 documentation.
// Added18 full 32-bit data bus interface, now as default.
// Address is 5-bit wide18 in 32-bit data bus mode.
// Added18 wb_sel_i18 input to the core18. It's used in the 32-bit mode.
// Added18 debug18 interface with two18 32-bit read-only registers in 32-bit mode.
// Bits18 5 and 6 of LSR18 are now only cleared18 on TX18 FIFO write.
// My18 small test bench18 is modified to work18 with 32-bit mode.
//
// Revision18 1.14  2001/11/07 17:51:52  gorban18
// Heavily18 rewritten18 interrupt18 and LSR18 subsystems18.
// Many18 bugs18 hopefully18 squashed18.
//
// Revision18 1.13  2001/10/20 09:58:40  gorban18
// Small18 synopsis18 fixes18
//
// Revision18 1.12  2001/08/25 15:46:19  gorban18
// Modified18 port names again18
//
// Revision18 1.11  2001/08/24 21:01:12  mohor18
// Things18 connected18 to parity18 changed.
// Clock18 devider18 changed.
//
// Revision18 1.10  2001/08/23 16:05:05  mohor18
// Stop bit bug18 fixed18.
// Parity18 bug18 fixed18.
// WISHBONE18 read cycle bug18 fixed18,
// OE18 indicator18 (Overrun18 Error) bug18 fixed18.
// PE18 indicator18 (Parity18 Error) bug18 fixed18.
// Register read bug18 fixed18.
//
// Revision18 1.4  2001/05/31 20:08:01  gorban18
// FIFO changes18 and other corrections18.
//
// Revision18 1.3  2001/05/21 19:12:02  gorban18
// Corrected18 some18 Linter18 messages18.
//
// Revision18 1.2  2001/05/17 18:34:18  gorban18
// First18 'stable' release. Should18 be sythesizable18 now. Also18 added new header.
//
// Revision18 1.0  2001-05-17 21:27:12+02  jacob18
// Initial18 revision18
//
//
// synopsys18 translate_off18
`include "timescale.v"
// synopsys18 translate_on18

`include "uart_defines18.v"

module uart_top18	(
	wb_clk_i18, 
	
	// Wishbone18 signals18
	wb_rst_i18, wb_adr_i18, wb_dat_i18, wb_dat_o18, wb_we_i18, wb_stb_i18, wb_cyc_i18, wb_ack_o18, wb_sel_i18,
	int_o18, // interrupt18 request

	// UART18	signals18
	// serial18 input/output
	stx_pad_o18, srx_pad_i18,

	// modem18 signals18
	rts_pad_o18, cts_pad_i18, dtr_pad_o18, dsr_pad_i18, ri_pad_i18, dcd_pad_i18
`ifdef UART_HAS_BAUDRATE_OUTPUT18
	, baud_o18
`endif
	);

parameter 							 uart_data_width18 = `UART_DATA_WIDTH18;
parameter 							 uart_addr_width18 = `UART_ADDR_WIDTH18;

input 								 wb_clk_i18;

// WISHBONE18 interface
input 								 wb_rst_i18;
input [uart_addr_width18-1:0] 	 wb_adr_i18;
input [uart_data_width18-1:0] 	 wb_dat_i18;
output [uart_data_width18-1:0] 	 wb_dat_o18;
input 								 wb_we_i18;
input 								 wb_stb_i18;
input 								 wb_cyc_i18;
input [3:0]							 wb_sel_i18;
output 								 wb_ack_o18;
output 								 int_o18;

// UART18	signals18
input 								 srx_pad_i18;
output 								 stx_pad_o18;
output 								 rts_pad_o18;
input 								 cts_pad_i18;
output 								 dtr_pad_o18;
input 								 dsr_pad_i18;
input 								 ri_pad_i18;
input 								 dcd_pad_i18;

// optional18 baudrate18 output
`ifdef UART_HAS_BAUDRATE_OUTPUT18
output	baud_o18;
`endif


wire 									 stx_pad_o18;
wire 									 rts_pad_o18;
wire 									 dtr_pad_o18;

wire [uart_addr_width18-1:0] 	 wb_adr_i18;
wire [uart_data_width18-1:0] 	 wb_dat_i18;
wire [uart_data_width18-1:0] 	 wb_dat_o18;

wire [7:0] 							 wb_dat8_i18; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o18; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o18; // debug18 interface 32-bit output
wire [3:0] 							 wb_sel_i18;  // WISHBONE18 select18 signal18
wire [uart_addr_width18-1:0] 	 wb_adr_int18;
wire 									 we_o18;	// Write enable for registers
wire		          	     re_o18;	// Read enable for registers
//
// MODULE18 INSTANCES18
//

`ifdef DATA_BUS_WIDTH_818
`else
// debug18 interface wires18
wire	[3:0] ier18;
wire	[3:0] iir18;
wire	[1:0] fcr18;
wire	[4:0] mcr18;
wire	[7:0] lcr18;
wire	[7:0] msr18;
wire	[7:0] lsr18;
wire	[`UART_FIFO_COUNTER_W18-1:0] rf_count18;
wire	[`UART_FIFO_COUNTER_W18-1:0] tf_count18;
wire	[2:0] tstate18;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_818
////  WISHBONE18 interface module
uart_wb18		wb_interface18(
		.clk18(		wb_clk_i18		),
		.wb_rst_i18(	wb_rst_i18	),
	.wb_dat_i18(wb_dat_i18),
	.wb_dat_o18(wb_dat_o18),
	.wb_dat8_i18(wb_dat8_i18),
	.wb_dat8_o18(wb_dat8_o18),
	 .wb_dat32_o18(32'b0),								 
	 .wb_sel_i18(4'b0),
		.wb_we_i18(	wb_we_i18		),
		.wb_stb_i18(	wb_stb_i18	),
		.wb_cyc_i18(	wb_cyc_i18	),
		.wb_ack_o18(	wb_ack_o18	),
	.wb_adr_i18(wb_adr_i18),
	.wb_adr_int18(wb_adr_int18),
		.we_o18(		we_o18		),
		.re_o18(re_o18)
		);
`else
uart_wb18		wb_interface18(
		.clk18(		wb_clk_i18		),
		.wb_rst_i18(	wb_rst_i18	),
	.wb_dat_i18(wb_dat_i18),
	.wb_dat_o18(wb_dat_o18),
	.wb_dat8_i18(wb_dat8_i18),
	.wb_dat8_o18(wb_dat8_o18),
	 .wb_sel_i18(wb_sel_i18),
	 .wb_dat32_o18(wb_dat32_o18),								 
		.wb_we_i18(	wb_we_i18		),
		.wb_stb_i18(	wb_stb_i18	),
		.wb_cyc_i18(	wb_cyc_i18	),
		.wb_ack_o18(	wb_ack_o18	),
	.wb_adr_i18(wb_adr_i18),
	.wb_adr_int18(wb_adr_int18),
		.we_o18(		we_o18		),
		.re_o18(re_o18)
		);
`endif

// Registers18
uart_regs18	regs(
	.clk18(		wb_clk_i18		),
	.wb_rst_i18(	wb_rst_i18	),
	.wb_addr_i18(	wb_adr_int18	),
	.wb_dat_i18(	wb_dat8_i18	),
	.wb_dat_o18(	wb_dat8_o18	),
	.wb_we_i18(	we_o18		),
   .wb_re_i18(re_o18),
	.modem_inputs18(	{cts_pad_i18, dsr_pad_i18,
	ri_pad_i18,  dcd_pad_i18}	),
	.stx_pad_o18(		stx_pad_o18		),
	.srx_pad_i18(		srx_pad_i18		),
`ifdef DATA_BUS_WIDTH_818
`else
// debug18 interface signals18	enabled
.ier18(ier18), 
.iir18(iir18), 
.fcr18(fcr18), 
.mcr18(mcr18), 
.lcr18(lcr18), 
.msr18(msr18), 
.lsr18(lsr18), 
.rf_count18(rf_count18),
.tf_count18(tf_count18),
.tstate18(tstate18),
.rstate(rstate),
`endif					  
	.rts_pad_o18(		rts_pad_o18		),
	.dtr_pad_o18(		dtr_pad_o18		),
	.int_o18(		int_o18		)
`ifdef UART_HAS_BAUDRATE_OUTPUT18
	, .baud_o18(baud_o18)
`endif

);

`ifdef DATA_BUS_WIDTH_818
`else
uart_debug_if18 dbg18(/*AUTOINST18*/
						// Outputs18
						.wb_dat32_o18				 (wb_dat32_o18[31:0]),
						// Inputs18
						.wb_adr_i18				 (wb_adr_int18[`UART_ADDR_WIDTH18-1:0]),
						.ier18						 (ier18[3:0]),
						.iir18						 (iir18[3:0]),
						.fcr18						 (fcr18[1:0]),
						.mcr18						 (mcr18[4:0]),
						.lcr18						 (lcr18[7:0]),
						.msr18						 (msr18[7:0]),
						.lsr18						 (lsr18[7:0]),
						.rf_count18				 (rf_count18[`UART_FIFO_COUNTER_W18-1:0]),
						.tf_count18				 (tf_count18[`UART_FIFO_COUNTER_W18-1:0]),
						.tstate18					 (tstate18[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_818
		$display("(%m) UART18 INFO18: Data bus width is 8. No Debug18 interface.\n");
	`else
		$display("(%m) UART18 INFO18: Data bus width is 32. Debug18 Interface18 present18.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT18
		$display("(%m) UART18 INFO18: Has18 baudrate18 output\n");
	`else
		$display("(%m) UART18 INFO18: Doesn18't have baudrate18 output\n");
	`endif
end

endmodule


