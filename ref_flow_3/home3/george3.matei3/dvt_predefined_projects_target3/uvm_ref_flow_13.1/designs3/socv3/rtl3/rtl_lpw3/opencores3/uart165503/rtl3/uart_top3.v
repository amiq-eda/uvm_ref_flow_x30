//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top3.v                                                  ////
////                                                              ////
////                                                              ////
////  This3 file is part of the "UART3 16550 compatible3" project3    ////
////  http3://www3.opencores3.org3/cores3/uart165503/                   ////
////                                                              ////
////  Documentation3 related3 to this project3:                      ////
////  - http3://www3.opencores3.org3/cores3/uart165503/                 ////
////                                                              ////
////  Projects3 compatibility3:                                     ////
////  - WISHBONE3                                                  ////
////  RS2323 Protocol3                                              ////
////  16550D uart3 (mostly3 supported)                              ////
////                                                              ////
////  Overview3 (main3 Features3):                                   ////
////  UART3 core3 top level.                                        ////
////                                                              ////
////  Known3 problems3 (limits3):                                    ////
////  Note3 that transmitter3 and receiver3 instances3 are inside     ////
////  the uart_regs3.v file.                                       ////
////                                                              ////
////  To3 Do3:                                                      ////
////  Nothing so far3.                                             ////
////                                                              ////
////  Author3(s):                                                  ////
////      - gorban3@opencores3.org3                                  ////
////      - Jacob3 Gorban3                                          ////
////      - Igor3 Mohor3 (igorm3@opencores3.org3)                      ////
////                                                              ////
////  Created3:        2001/05/12                                  ////
////  Last3 Updated3:   2001/05/17                                  ////
////                  (See log3 for the revision3 history3)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2000, 2001 Authors3                             ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS3 Revision3 History3
//
// $Log: not supported by cvs2svn3 $
// Revision3 1.18  2002/07/22 23:02:23  gorban3
// Bug3 Fixes3:
//  * Possible3 loss of sync and bad3 reception3 of stop bit on slow3 baud3 rates3 fixed3.
//   Problem3 reported3 by Kenny3.Tung3.
//  * Bad (or lack3 of ) loopback3 handling3 fixed3. Reported3 by Cherry3 Withers3.
//
// Improvements3:
//  * Made3 FIFO's as general3 inferrable3 memory where possible3.
//  So3 on FPGA3 they should be inferred3 as RAM3 (Distributed3 RAM3 on Xilinx3).
//  This3 saves3 about3 1/3 of the Slice3 count and reduces3 P&R and synthesis3 times.
//
//  * Added3 optional3 baudrate3 output (baud_o3).
//  This3 is identical3 to BAUDOUT3* signal3 on 16550 chip3.
//  It outputs3 16xbit_clock_rate - the divided3 clock3.
//  It's disabled by default. Define3 UART_HAS_BAUDRATE_OUTPUT3 to use.
//
// Revision3 1.17  2001/12/19 08:40:03  mohor3
// Warnings3 fixed3 (unused3 signals3 removed).
//
// Revision3 1.16  2001/12/06 14:51:04  gorban3
// Bug3 in LSR3[0] is fixed3.
// All WISHBONE3 signals3 are now sampled3, so another3 wait-state is introduced3 on all transfers3.
//
// Revision3 1.15  2001/12/03 21:44:29  gorban3
// Updated3 specification3 documentation.
// Added3 full 32-bit data bus interface, now as default.
// Address is 5-bit wide3 in 32-bit data bus mode.
// Added3 wb_sel_i3 input to the core3. It's used in the 32-bit mode.
// Added3 debug3 interface with two3 32-bit read-only registers in 32-bit mode.
// Bits3 5 and 6 of LSR3 are now only cleared3 on TX3 FIFO write.
// My3 small test bench3 is modified to work3 with 32-bit mode.
//
// Revision3 1.14  2001/11/07 17:51:52  gorban3
// Heavily3 rewritten3 interrupt3 and LSR3 subsystems3.
// Many3 bugs3 hopefully3 squashed3.
//
// Revision3 1.13  2001/10/20 09:58:40  gorban3
// Small3 synopsis3 fixes3
//
// Revision3 1.12  2001/08/25 15:46:19  gorban3
// Modified3 port names again3
//
// Revision3 1.11  2001/08/24 21:01:12  mohor3
// Things3 connected3 to parity3 changed.
// Clock3 devider3 changed.
//
// Revision3 1.10  2001/08/23 16:05:05  mohor3
// Stop bit bug3 fixed3.
// Parity3 bug3 fixed3.
// WISHBONE3 read cycle bug3 fixed3,
// OE3 indicator3 (Overrun3 Error) bug3 fixed3.
// PE3 indicator3 (Parity3 Error) bug3 fixed3.
// Register read bug3 fixed3.
//
// Revision3 1.4  2001/05/31 20:08:01  gorban3
// FIFO changes3 and other corrections3.
//
// Revision3 1.3  2001/05/21 19:12:02  gorban3
// Corrected3 some3 Linter3 messages3.
//
// Revision3 1.2  2001/05/17 18:34:18  gorban3
// First3 'stable' release. Should3 be sythesizable3 now. Also3 added new header.
//
// Revision3 1.0  2001-05-17 21:27:12+02  jacob3
// Initial3 revision3
//
//
// synopsys3 translate_off3
`include "timescale.v"
// synopsys3 translate_on3

`include "uart_defines3.v"

module uart_top3	(
	wb_clk_i3, 
	
	// Wishbone3 signals3
	wb_rst_i3, wb_adr_i3, wb_dat_i3, wb_dat_o3, wb_we_i3, wb_stb_i3, wb_cyc_i3, wb_ack_o3, wb_sel_i3,
	int_o3, // interrupt3 request

	// UART3	signals3
	// serial3 input/output
	stx_pad_o3, srx_pad_i3,

	// modem3 signals3
	rts_pad_o3, cts_pad_i3, dtr_pad_o3, dsr_pad_i3, ri_pad_i3, dcd_pad_i3
`ifdef UART_HAS_BAUDRATE_OUTPUT3
	, baud_o3
`endif
	);

parameter 							 uart_data_width3 = `UART_DATA_WIDTH3;
parameter 							 uart_addr_width3 = `UART_ADDR_WIDTH3;

input 								 wb_clk_i3;

// WISHBONE3 interface
input 								 wb_rst_i3;
input [uart_addr_width3-1:0] 	 wb_adr_i3;
input [uart_data_width3-1:0] 	 wb_dat_i3;
output [uart_data_width3-1:0] 	 wb_dat_o3;
input 								 wb_we_i3;
input 								 wb_stb_i3;
input 								 wb_cyc_i3;
input [3:0]							 wb_sel_i3;
output 								 wb_ack_o3;
output 								 int_o3;

// UART3	signals3
input 								 srx_pad_i3;
output 								 stx_pad_o3;
output 								 rts_pad_o3;
input 								 cts_pad_i3;
output 								 dtr_pad_o3;
input 								 dsr_pad_i3;
input 								 ri_pad_i3;
input 								 dcd_pad_i3;

// optional3 baudrate3 output
`ifdef UART_HAS_BAUDRATE_OUTPUT3
output	baud_o3;
`endif


wire 									 stx_pad_o3;
wire 									 rts_pad_o3;
wire 									 dtr_pad_o3;

wire [uart_addr_width3-1:0] 	 wb_adr_i3;
wire [uart_data_width3-1:0] 	 wb_dat_i3;
wire [uart_data_width3-1:0] 	 wb_dat_o3;

wire [7:0] 							 wb_dat8_i3; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o3; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o3; // debug3 interface 32-bit output
wire [3:0] 							 wb_sel_i3;  // WISHBONE3 select3 signal3
wire [uart_addr_width3-1:0] 	 wb_adr_int3;
wire 									 we_o3;	// Write enable for registers
wire		          	     re_o3;	// Read enable for registers
//
// MODULE3 INSTANCES3
//

`ifdef DATA_BUS_WIDTH_83
`else
// debug3 interface wires3
wire	[3:0] ier3;
wire	[3:0] iir3;
wire	[1:0] fcr3;
wire	[4:0] mcr3;
wire	[7:0] lcr3;
wire	[7:0] msr3;
wire	[7:0] lsr3;
wire	[`UART_FIFO_COUNTER_W3-1:0] rf_count3;
wire	[`UART_FIFO_COUNTER_W3-1:0] tf_count3;
wire	[2:0] tstate3;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_83
////  WISHBONE3 interface module
uart_wb3		wb_interface3(
		.clk3(		wb_clk_i3		),
		.wb_rst_i3(	wb_rst_i3	),
	.wb_dat_i3(wb_dat_i3),
	.wb_dat_o3(wb_dat_o3),
	.wb_dat8_i3(wb_dat8_i3),
	.wb_dat8_o3(wb_dat8_o3),
	 .wb_dat32_o3(32'b0),								 
	 .wb_sel_i3(4'b0),
		.wb_we_i3(	wb_we_i3		),
		.wb_stb_i3(	wb_stb_i3	),
		.wb_cyc_i3(	wb_cyc_i3	),
		.wb_ack_o3(	wb_ack_o3	),
	.wb_adr_i3(wb_adr_i3),
	.wb_adr_int3(wb_adr_int3),
		.we_o3(		we_o3		),
		.re_o3(re_o3)
		);
`else
uart_wb3		wb_interface3(
		.clk3(		wb_clk_i3		),
		.wb_rst_i3(	wb_rst_i3	),
	.wb_dat_i3(wb_dat_i3),
	.wb_dat_o3(wb_dat_o3),
	.wb_dat8_i3(wb_dat8_i3),
	.wb_dat8_o3(wb_dat8_o3),
	 .wb_sel_i3(wb_sel_i3),
	 .wb_dat32_o3(wb_dat32_o3),								 
		.wb_we_i3(	wb_we_i3		),
		.wb_stb_i3(	wb_stb_i3	),
		.wb_cyc_i3(	wb_cyc_i3	),
		.wb_ack_o3(	wb_ack_o3	),
	.wb_adr_i3(wb_adr_i3),
	.wb_adr_int3(wb_adr_int3),
		.we_o3(		we_o3		),
		.re_o3(re_o3)
		);
`endif

// Registers3
uart_regs3	regs(
	.clk3(		wb_clk_i3		),
	.wb_rst_i3(	wb_rst_i3	),
	.wb_addr_i3(	wb_adr_int3	),
	.wb_dat_i3(	wb_dat8_i3	),
	.wb_dat_o3(	wb_dat8_o3	),
	.wb_we_i3(	we_o3		),
   .wb_re_i3(re_o3),
	.modem_inputs3(	{cts_pad_i3, dsr_pad_i3,
	ri_pad_i3,  dcd_pad_i3}	),
	.stx_pad_o3(		stx_pad_o3		),
	.srx_pad_i3(		srx_pad_i3		),
`ifdef DATA_BUS_WIDTH_83
`else
// debug3 interface signals3	enabled
.ier3(ier3), 
.iir3(iir3), 
.fcr3(fcr3), 
.mcr3(mcr3), 
.lcr3(lcr3), 
.msr3(msr3), 
.lsr3(lsr3), 
.rf_count3(rf_count3),
.tf_count3(tf_count3),
.tstate3(tstate3),
.rstate(rstate),
`endif					  
	.rts_pad_o3(		rts_pad_o3		),
	.dtr_pad_o3(		dtr_pad_o3		),
	.int_o3(		int_o3		)
`ifdef UART_HAS_BAUDRATE_OUTPUT3
	, .baud_o3(baud_o3)
`endif

);

`ifdef DATA_BUS_WIDTH_83
`else
uart_debug_if3 dbg3(/*AUTOINST3*/
						// Outputs3
						.wb_dat32_o3				 (wb_dat32_o3[31:0]),
						// Inputs3
						.wb_adr_i3				 (wb_adr_int3[`UART_ADDR_WIDTH3-1:0]),
						.ier3						 (ier3[3:0]),
						.iir3						 (iir3[3:0]),
						.fcr3						 (fcr3[1:0]),
						.mcr3						 (mcr3[4:0]),
						.lcr3						 (lcr3[7:0]),
						.msr3						 (msr3[7:0]),
						.lsr3						 (lsr3[7:0]),
						.rf_count3				 (rf_count3[`UART_FIFO_COUNTER_W3-1:0]),
						.tf_count3				 (tf_count3[`UART_FIFO_COUNTER_W3-1:0]),
						.tstate3					 (tstate3[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_83
		$display("(%m) UART3 INFO3: Data bus width is 8. No Debug3 interface.\n");
	`else
		$display("(%m) UART3 INFO3: Data bus width is 32. Debug3 Interface3 present3.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT3
		$display("(%m) UART3 INFO3: Has3 baudrate3 output\n");
	`else
		$display("(%m) UART3 INFO3: Doesn3't have baudrate3 output\n");
	`endif
end

endmodule


