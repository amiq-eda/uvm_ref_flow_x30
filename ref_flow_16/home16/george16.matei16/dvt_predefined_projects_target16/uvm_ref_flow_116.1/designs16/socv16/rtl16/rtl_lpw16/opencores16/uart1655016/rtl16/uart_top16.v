//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top16.v                                                  ////
////                                                              ////
////                                                              ////
////  This16 file is part of the "UART16 16550 compatible16" project16    ////
////  http16://www16.opencores16.org16/cores16/uart1655016/                   ////
////                                                              ////
////  Documentation16 related16 to this project16:                      ////
////  - http16://www16.opencores16.org16/cores16/uart1655016/                 ////
////                                                              ////
////  Projects16 compatibility16:                                     ////
////  - WISHBONE16                                                  ////
////  RS23216 Protocol16                                              ////
////  16550D uart16 (mostly16 supported)                              ////
////                                                              ////
////  Overview16 (main16 Features16):                                   ////
////  UART16 core16 top level.                                        ////
////                                                              ////
////  Known16 problems16 (limits16):                                    ////
////  Note16 that transmitter16 and receiver16 instances16 are inside     ////
////  the uart_regs16.v file.                                       ////
////                                                              ////
////  To16 Do16:                                                      ////
////  Nothing so far16.                                             ////
////                                                              ////
////  Author16(s):                                                  ////
////      - gorban16@opencores16.org16                                  ////
////      - Jacob16 Gorban16                                          ////
////      - Igor16 Mohor16 (igorm16@opencores16.org16)                      ////
////                                                              ////
////  Created16:        2001/05/12                                  ////
////  Last16 Updated16:   2001/05/17                                  ////
////                  (See log16 for the revision16 history16)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2000, 2001 Authors16                             ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS16 Revision16 History16
//
// $Log: not supported by cvs2svn16 $
// Revision16 1.18  2002/07/22 23:02:23  gorban16
// Bug16 Fixes16:
//  * Possible16 loss of sync and bad16 reception16 of stop bit on slow16 baud16 rates16 fixed16.
//   Problem16 reported16 by Kenny16.Tung16.
//  * Bad (or lack16 of ) loopback16 handling16 fixed16. Reported16 by Cherry16 Withers16.
//
// Improvements16:
//  * Made16 FIFO's as general16 inferrable16 memory where possible16.
//  So16 on FPGA16 they should be inferred16 as RAM16 (Distributed16 RAM16 on Xilinx16).
//  This16 saves16 about16 1/3 of the Slice16 count and reduces16 P&R and synthesis16 times.
//
//  * Added16 optional16 baudrate16 output (baud_o16).
//  This16 is identical16 to BAUDOUT16* signal16 on 16550 chip16.
//  It outputs16 16xbit_clock_rate - the divided16 clock16.
//  It's disabled by default. Define16 UART_HAS_BAUDRATE_OUTPUT16 to use.
//
// Revision16 1.17  2001/12/19 08:40:03  mohor16
// Warnings16 fixed16 (unused16 signals16 removed).
//
// Revision16 1.16  2001/12/06 14:51:04  gorban16
// Bug16 in LSR16[0] is fixed16.
// All WISHBONE16 signals16 are now sampled16, so another16 wait-state is introduced16 on all transfers16.
//
// Revision16 1.15  2001/12/03 21:44:29  gorban16
// Updated16 specification16 documentation.
// Added16 full 32-bit data bus interface, now as default.
// Address is 5-bit wide16 in 32-bit data bus mode.
// Added16 wb_sel_i16 input to the core16. It's used in the 32-bit mode.
// Added16 debug16 interface with two16 32-bit read-only registers in 32-bit mode.
// Bits16 5 and 6 of LSR16 are now only cleared16 on TX16 FIFO write.
// My16 small test bench16 is modified to work16 with 32-bit mode.
//
// Revision16 1.14  2001/11/07 17:51:52  gorban16
// Heavily16 rewritten16 interrupt16 and LSR16 subsystems16.
// Many16 bugs16 hopefully16 squashed16.
//
// Revision16 1.13  2001/10/20 09:58:40  gorban16
// Small16 synopsis16 fixes16
//
// Revision16 1.12  2001/08/25 15:46:19  gorban16
// Modified16 port names again16
//
// Revision16 1.11  2001/08/24 21:01:12  mohor16
// Things16 connected16 to parity16 changed.
// Clock16 devider16 changed.
//
// Revision16 1.10  2001/08/23 16:05:05  mohor16
// Stop bit bug16 fixed16.
// Parity16 bug16 fixed16.
// WISHBONE16 read cycle bug16 fixed16,
// OE16 indicator16 (Overrun16 Error) bug16 fixed16.
// PE16 indicator16 (Parity16 Error) bug16 fixed16.
// Register read bug16 fixed16.
//
// Revision16 1.4  2001/05/31 20:08:01  gorban16
// FIFO changes16 and other corrections16.
//
// Revision16 1.3  2001/05/21 19:12:02  gorban16
// Corrected16 some16 Linter16 messages16.
//
// Revision16 1.2  2001/05/17 18:34:18  gorban16
// First16 'stable' release. Should16 be sythesizable16 now. Also16 added new header.
//
// Revision16 1.0  2001-05-17 21:27:12+02  jacob16
// Initial16 revision16
//
//
// synopsys16 translate_off16
`include "timescale.v"
// synopsys16 translate_on16

`include "uart_defines16.v"

module uart_top16	(
	wb_clk_i16, 
	
	// Wishbone16 signals16
	wb_rst_i16, wb_adr_i16, wb_dat_i16, wb_dat_o16, wb_we_i16, wb_stb_i16, wb_cyc_i16, wb_ack_o16, wb_sel_i16,
	int_o16, // interrupt16 request

	// UART16	signals16
	// serial16 input/output
	stx_pad_o16, srx_pad_i16,

	// modem16 signals16
	rts_pad_o16, cts_pad_i16, dtr_pad_o16, dsr_pad_i16, ri_pad_i16, dcd_pad_i16
`ifdef UART_HAS_BAUDRATE_OUTPUT16
	, baud_o16
`endif
	);

parameter 							 uart_data_width16 = `UART_DATA_WIDTH16;
parameter 							 uart_addr_width16 = `UART_ADDR_WIDTH16;

input 								 wb_clk_i16;

// WISHBONE16 interface
input 								 wb_rst_i16;
input [uart_addr_width16-1:0] 	 wb_adr_i16;
input [uart_data_width16-1:0] 	 wb_dat_i16;
output [uart_data_width16-1:0] 	 wb_dat_o16;
input 								 wb_we_i16;
input 								 wb_stb_i16;
input 								 wb_cyc_i16;
input [3:0]							 wb_sel_i16;
output 								 wb_ack_o16;
output 								 int_o16;

// UART16	signals16
input 								 srx_pad_i16;
output 								 stx_pad_o16;
output 								 rts_pad_o16;
input 								 cts_pad_i16;
output 								 dtr_pad_o16;
input 								 dsr_pad_i16;
input 								 ri_pad_i16;
input 								 dcd_pad_i16;

// optional16 baudrate16 output
`ifdef UART_HAS_BAUDRATE_OUTPUT16
output	baud_o16;
`endif


wire 									 stx_pad_o16;
wire 									 rts_pad_o16;
wire 									 dtr_pad_o16;

wire [uart_addr_width16-1:0] 	 wb_adr_i16;
wire [uart_data_width16-1:0] 	 wb_dat_i16;
wire [uart_data_width16-1:0] 	 wb_dat_o16;

wire [7:0] 							 wb_dat8_i16; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o16; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o16; // debug16 interface 32-bit output
wire [3:0] 							 wb_sel_i16;  // WISHBONE16 select16 signal16
wire [uart_addr_width16-1:0] 	 wb_adr_int16;
wire 									 we_o16;	// Write enable for registers
wire		          	     re_o16;	// Read enable for registers
//
// MODULE16 INSTANCES16
//

`ifdef DATA_BUS_WIDTH_816
`else
// debug16 interface wires16
wire	[3:0] ier16;
wire	[3:0] iir16;
wire	[1:0] fcr16;
wire	[4:0] mcr16;
wire	[7:0] lcr16;
wire	[7:0] msr16;
wire	[7:0] lsr16;
wire	[`UART_FIFO_COUNTER_W16-1:0] rf_count16;
wire	[`UART_FIFO_COUNTER_W16-1:0] tf_count16;
wire	[2:0] tstate16;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_816
////  WISHBONE16 interface module
uart_wb16		wb_interface16(
		.clk16(		wb_clk_i16		),
		.wb_rst_i16(	wb_rst_i16	),
	.wb_dat_i16(wb_dat_i16),
	.wb_dat_o16(wb_dat_o16),
	.wb_dat8_i16(wb_dat8_i16),
	.wb_dat8_o16(wb_dat8_o16),
	 .wb_dat32_o16(32'b0),								 
	 .wb_sel_i16(4'b0),
		.wb_we_i16(	wb_we_i16		),
		.wb_stb_i16(	wb_stb_i16	),
		.wb_cyc_i16(	wb_cyc_i16	),
		.wb_ack_o16(	wb_ack_o16	),
	.wb_adr_i16(wb_adr_i16),
	.wb_adr_int16(wb_adr_int16),
		.we_o16(		we_o16		),
		.re_o16(re_o16)
		);
`else
uart_wb16		wb_interface16(
		.clk16(		wb_clk_i16		),
		.wb_rst_i16(	wb_rst_i16	),
	.wb_dat_i16(wb_dat_i16),
	.wb_dat_o16(wb_dat_o16),
	.wb_dat8_i16(wb_dat8_i16),
	.wb_dat8_o16(wb_dat8_o16),
	 .wb_sel_i16(wb_sel_i16),
	 .wb_dat32_o16(wb_dat32_o16),								 
		.wb_we_i16(	wb_we_i16		),
		.wb_stb_i16(	wb_stb_i16	),
		.wb_cyc_i16(	wb_cyc_i16	),
		.wb_ack_o16(	wb_ack_o16	),
	.wb_adr_i16(wb_adr_i16),
	.wb_adr_int16(wb_adr_int16),
		.we_o16(		we_o16		),
		.re_o16(re_o16)
		);
`endif

// Registers16
uart_regs16	regs(
	.clk16(		wb_clk_i16		),
	.wb_rst_i16(	wb_rst_i16	),
	.wb_addr_i16(	wb_adr_int16	),
	.wb_dat_i16(	wb_dat8_i16	),
	.wb_dat_o16(	wb_dat8_o16	),
	.wb_we_i16(	we_o16		),
   .wb_re_i16(re_o16),
	.modem_inputs16(	{cts_pad_i16, dsr_pad_i16,
	ri_pad_i16,  dcd_pad_i16}	),
	.stx_pad_o16(		stx_pad_o16		),
	.srx_pad_i16(		srx_pad_i16		),
`ifdef DATA_BUS_WIDTH_816
`else
// debug16 interface signals16	enabled
.ier16(ier16), 
.iir16(iir16), 
.fcr16(fcr16), 
.mcr16(mcr16), 
.lcr16(lcr16), 
.msr16(msr16), 
.lsr16(lsr16), 
.rf_count16(rf_count16),
.tf_count16(tf_count16),
.tstate16(tstate16),
.rstate(rstate),
`endif					  
	.rts_pad_o16(		rts_pad_o16		),
	.dtr_pad_o16(		dtr_pad_o16		),
	.int_o16(		int_o16		)
`ifdef UART_HAS_BAUDRATE_OUTPUT16
	, .baud_o16(baud_o16)
`endif

);

`ifdef DATA_BUS_WIDTH_816
`else
uart_debug_if16 dbg16(/*AUTOINST16*/
						// Outputs16
						.wb_dat32_o16				 (wb_dat32_o16[31:0]),
						// Inputs16
						.wb_adr_i16				 (wb_adr_int16[`UART_ADDR_WIDTH16-1:0]),
						.ier16						 (ier16[3:0]),
						.iir16						 (iir16[3:0]),
						.fcr16						 (fcr16[1:0]),
						.mcr16						 (mcr16[4:0]),
						.lcr16						 (lcr16[7:0]),
						.msr16						 (msr16[7:0]),
						.lsr16						 (lsr16[7:0]),
						.rf_count16				 (rf_count16[`UART_FIFO_COUNTER_W16-1:0]),
						.tf_count16				 (tf_count16[`UART_FIFO_COUNTER_W16-1:0]),
						.tstate16					 (tstate16[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_816
		$display("(%m) UART16 INFO16: Data bus width is 8. No Debug16 interface.\n");
	`else
		$display("(%m) UART16 INFO16: Data bus width is 32. Debug16 Interface16 present16.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT16
		$display("(%m) UART16 INFO16: Has16 baudrate16 output\n");
	`else
		$display("(%m) UART16 INFO16: Doesn16't have baudrate16 output\n");
	`endif
end

endmodule


