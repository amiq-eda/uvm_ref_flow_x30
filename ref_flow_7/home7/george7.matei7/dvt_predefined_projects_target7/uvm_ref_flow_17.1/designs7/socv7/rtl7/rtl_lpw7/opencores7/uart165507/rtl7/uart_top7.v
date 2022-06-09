//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top7.v                                                  ////
////                                                              ////
////                                                              ////
////  This7 file is part of the "UART7 16550 compatible7" project7    ////
////  http7://www7.opencores7.org7/cores7/uart165507/                   ////
////                                                              ////
////  Documentation7 related7 to this project7:                      ////
////  - http7://www7.opencores7.org7/cores7/uart165507/                 ////
////                                                              ////
////  Projects7 compatibility7:                                     ////
////  - WISHBONE7                                                  ////
////  RS2327 Protocol7                                              ////
////  16550D uart7 (mostly7 supported)                              ////
////                                                              ////
////  Overview7 (main7 Features7):                                   ////
////  UART7 core7 top level.                                        ////
////                                                              ////
////  Known7 problems7 (limits7):                                    ////
////  Note7 that transmitter7 and receiver7 instances7 are inside     ////
////  the uart_regs7.v file.                                       ////
////                                                              ////
////  To7 Do7:                                                      ////
////  Nothing so far7.                                             ////
////                                                              ////
////  Author7(s):                                                  ////
////      - gorban7@opencores7.org7                                  ////
////      - Jacob7 Gorban7                                          ////
////      - Igor7 Mohor7 (igorm7@opencores7.org7)                      ////
////                                                              ////
////  Created7:        2001/05/12                                  ////
////  Last7 Updated7:   2001/05/17                                  ////
////                  (See log7 for the revision7 history7)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2000, 2001 Authors7                             ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS7 Revision7 History7
//
// $Log: not supported by cvs2svn7 $
// Revision7 1.18  2002/07/22 23:02:23  gorban7
// Bug7 Fixes7:
//  * Possible7 loss of sync and bad7 reception7 of stop bit on slow7 baud7 rates7 fixed7.
//   Problem7 reported7 by Kenny7.Tung7.
//  * Bad (or lack7 of ) loopback7 handling7 fixed7. Reported7 by Cherry7 Withers7.
//
// Improvements7:
//  * Made7 FIFO's as general7 inferrable7 memory where possible7.
//  So7 on FPGA7 they should be inferred7 as RAM7 (Distributed7 RAM7 on Xilinx7).
//  This7 saves7 about7 1/3 of the Slice7 count and reduces7 P&R and synthesis7 times.
//
//  * Added7 optional7 baudrate7 output (baud_o7).
//  This7 is identical7 to BAUDOUT7* signal7 on 16550 chip7.
//  It outputs7 16xbit_clock_rate - the divided7 clock7.
//  It's disabled by default. Define7 UART_HAS_BAUDRATE_OUTPUT7 to use.
//
// Revision7 1.17  2001/12/19 08:40:03  mohor7
// Warnings7 fixed7 (unused7 signals7 removed).
//
// Revision7 1.16  2001/12/06 14:51:04  gorban7
// Bug7 in LSR7[0] is fixed7.
// All WISHBONE7 signals7 are now sampled7, so another7 wait-state is introduced7 on all transfers7.
//
// Revision7 1.15  2001/12/03 21:44:29  gorban7
// Updated7 specification7 documentation.
// Added7 full 32-bit data bus interface, now as default.
// Address is 5-bit wide7 in 32-bit data bus mode.
// Added7 wb_sel_i7 input to the core7. It's used in the 32-bit mode.
// Added7 debug7 interface with two7 32-bit read-only registers in 32-bit mode.
// Bits7 5 and 6 of LSR7 are now only cleared7 on TX7 FIFO write.
// My7 small test bench7 is modified to work7 with 32-bit mode.
//
// Revision7 1.14  2001/11/07 17:51:52  gorban7
// Heavily7 rewritten7 interrupt7 and LSR7 subsystems7.
// Many7 bugs7 hopefully7 squashed7.
//
// Revision7 1.13  2001/10/20 09:58:40  gorban7
// Small7 synopsis7 fixes7
//
// Revision7 1.12  2001/08/25 15:46:19  gorban7
// Modified7 port names again7
//
// Revision7 1.11  2001/08/24 21:01:12  mohor7
// Things7 connected7 to parity7 changed.
// Clock7 devider7 changed.
//
// Revision7 1.10  2001/08/23 16:05:05  mohor7
// Stop bit bug7 fixed7.
// Parity7 bug7 fixed7.
// WISHBONE7 read cycle bug7 fixed7,
// OE7 indicator7 (Overrun7 Error) bug7 fixed7.
// PE7 indicator7 (Parity7 Error) bug7 fixed7.
// Register read bug7 fixed7.
//
// Revision7 1.4  2001/05/31 20:08:01  gorban7
// FIFO changes7 and other corrections7.
//
// Revision7 1.3  2001/05/21 19:12:02  gorban7
// Corrected7 some7 Linter7 messages7.
//
// Revision7 1.2  2001/05/17 18:34:18  gorban7
// First7 'stable' release. Should7 be sythesizable7 now. Also7 added new header.
//
// Revision7 1.0  2001-05-17 21:27:12+02  jacob7
// Initial7 revision7
//
//
// synopsys7 translate_off7
`include "timescale.v"
// synopsys7 translate_on7

`include "uart_defines7.v"

module uart_top7	(
	wb_clk_i7, 
	
	// Wishbone7 signals7
	wb_rst_i7, wb_adr_i7, wb_dat_i7, wb_dat_o7, wb_we_i7, wb_stb_i7, wb_cyc_i7, wb_ack_o7, wb_sel_i7,
	int_o7, // interrupt7 request

	// UART7	signals7
	// serial7 input/output
	stx_pad_o7, srx_pad_i7,

	// modem7 signals7
	rts_pad_o7, cts_pad_i7, dtr_pad_o7, dsr_pad_i7, ri_pad_i7, dcd_pad_i7
`ifdef UART_HAS_BAUDRATE_OUTPUT7
	, baud_o7
`endif
	);

parameter 							 uart_data_width7 = `UART_DATA_WIDTH7;
parameter 							 uart_addr_width7 = `UART_ADDR_WIDTH7;

input 								 wb_clk_i7;

// WISHBONE7 interface
input 								 wb_rst_i7;
input [uart_addr_width7-1:0] 	 wb_adr_i7;
input [uart_data_width7-1:0] 	 wb_dat_i7;
output [uart_data_width7-1:0] 	 wb_dat_o7;
input 								 wb_we_i7;
input 								 wb_stb_i7;
input 								 wb_cyc_i7;
input [3:0]							 wb_sel_i7;
output 								 wb_ack_o7;
output 								 int_o7;

// UART7	signals7
input 								 srx_pad_i7;
output 								 stx_pad_o7;
output 								 rts_pad_o7;
input 								 cts_pad_i7;
output 								 dtr_pad_o7;
input 								 dsr_pad_i7;
input 								 ri_pad_i7;
input 								 dcd_pad_i7;

// optional7 baudrate7 output
`ifdef UART_HAS_BAUDRATE_OUTPUT7
output	baud_o7;
`endif


wire 									 stx_pad_o7;
wire 									 rts_pad_o7;
wire 									 dtr_pad_o7;

wire [uart_addr_width7-1:0] 	 wb_adr_i7;
wire [uart_data_width7-1:0] 	 wb_dat_i7;
wire [uart_data_width7-1:0] 	 wb_dat_o7;

wire [7:0] 							 wb_dat8_i7; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o7; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o7; // debug7 interface 32-bit output
wire [3:0] 							 wb_sel_i7;  // WISHBONE7 select7 signal7
wire [uart_addr_width7-1:0] 	 wb_adr_int7;
wire 									 we_o7;	// Write enable for registers
wire		          	     re_o7;	// Read enable for registers
//
// MODULE7 INSTANCES7
//

`ifdef DATA_BUS_WIDTH_87
`else
// debug7 interface wires7
wire	[3:0] ier7;
wire	[3:0] iir7;
wire	[1:0] fcr7;
wire	[4:0] mcr7;
wire	[7:0] lcr7;
wire	[7:0] msr7;
wire	[7:0] lsr7;
wire	[`UART_FIFO_COUNTER_W7-1:0] rf_count7;
wire	[`UART_FIFO_COUNTER_W7-1:0] tf_count7;
wire	[2:0] tstate7;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_87
////  WISHBONE7 interface module
uart_wb7		wb_interface7(
		.clk7(		wb_clk_i7		),
		.wb_rst_i7(	wb_rst_i7	),
	.wb_dat_i7(wb_dat_i7),
	.wb_dat_o7(wb_dat_o7),
	.wb_dat8_i7(wb_dat8_i7),
	.wb_dat8_o7(wb_dat8_o7),
	 .wb_dat32_o7(32'b0),								 
	 .wb_sel_i7(4'b0),
		.wb_we_i7(	wb_we_i7		),
		.wb_stb_i7(	wb_stb_i7	),
		.wb_cyc_i7(	wb_cyc_i7	),
		.wb_ack_o7(	wb_ack_o7	),
	.wb_adr_i7(wb_adr_i7),
	.wb_adr_int7(wb_adr_int7),
		.we_o7(		we_o7		),
		.re_o7(re_o7)
		);
`else
uart_wb7		wb_interface7(
		.clk7(		wb_clk_i7		),
		.wb_rst_i7(	wb_rst_i7	),
	.wb_dat_i7(wb_dat_i7),
	.wb_dat_o7(wb_dat_o7),
	.wb_dat8_i7(wb_dat8_i7),
	.wb_dat8_o7(wb_dat8_o7),
	 .wb_sel_i7(wb_sel_i7),
	 .wb_dat32_o7(wb_dat32_o7),								 
		.wb_we_i7(	wb_we_i7		),
		.wb_stb_i7(	wb_stb_i7	),
		.wb_cyc_i7(	wb_cyc_i7	),
		.wb_ack_o7(	wb_ack_o7	),
	.wb_adr_i7(wb_adr_i7),
	.wb_adr_int7(wb_adr_int7),
		.we_o7(		we_o7		),
		.re_o7(re_o7)
		);
`endif

// Registers7
uart_regs7	regs(
	.clk7(		wb_clk_i7		),
	.wb_rst_i7(	wb_rst_i7	),
	.wb_addr_i7(	wb_adr_int7	),
	.wb_dat_i7(	wb_dat8_i7	),
	.wb_dat_o7(	wb_dat8_o7	),
	.wb_we_i7(	we_o7		),
   .wb_re_i7(re_o7),
	.modem_inputs7(	{cts_pad_i7, dsr_pad_i7,
	ri_pad_i7,  dcd_pad_i7}	),
	.stx_pad_o7(		stx_pad_o7		),
	.srx_pad_i7(		srx_pad_i7		),
`ifdef DATA_BUS_WIDTH_87
`else
// debug7 interface signals7	enabled
.ier7(ier7), 
.iir7(iir7), 
.fcr7(fcr7), 
.mcr7(mcr7), 
.lcr7(lcr7), 
.msr7(msr7), 
.lsr7(lsr7), 
.rf_count7(rf_count7),
.tf_count7(tf_count7),
.tstate7(tstate7),
.rstate(rstate),
`endif					  
	.rts_pad_o7(		rts_pad_o7		),
	.dtr_pad_o7(		dtr_pad_o7		),
	.int_o7(		int_o7		)
`ifdef UART_HAS_BAUDRATE_OUTPUT7
	, .baud_o7(baud_o7)
`endif

);

`ifdef DATA_BUS_WIDTH_87
`else
uart_debug_if7 dbg7(/*AUTOINST7*/
						// Outputs7
						.wb_dat32_o7				 (wb_dat32_o7[31:0]),
						// Inputs7
						.wb_adr_i7				 (wb_adr_int7[`UART_ADDR_WIDTH7-1:0]),
						.ier7						 (ier7[3:0]),
						.iir7						 (iir7[3:0]),
						.fcr7						 (fcr7[1:0]),
						.mcr7						 (mcr7[4:0]),
						.lcr7						 (lcr7[7:0]),
						.msr7						 (msr7[7:0]),
						.lsr7						 (lsr7[7:0]),
						.rf_count7				 (rf_count7[`UART_FIFO_COUNTER_W7-1:0]),
						.tf_count7				 (tf_count7[`UART_FIFO_COUNTER_W7-1:0]),
						.tstate7					 (tstate7[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_87
		$display("(%m) UART7 INFO7: Data bus width is 8. No Debug7 interface.\n");
	`else
		$display("(%m) UART7 INFO7: Data bus width is 32. Debug7 Interface7 present7.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT7
		$display("(%m) UART7 INFO7: Has7 baudrate7 output\n");
	`else
		$display("(%m) UART7 INFO7: Doesn7't have baudrate7 output\n");
	`endif
end

endmodule


