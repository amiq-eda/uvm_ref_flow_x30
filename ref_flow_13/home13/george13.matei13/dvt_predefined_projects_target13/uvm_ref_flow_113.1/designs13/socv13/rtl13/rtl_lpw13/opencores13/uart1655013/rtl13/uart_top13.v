//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top13.v                                                  ////
////                                                              ////
////                                                              ////
////  This13 file is part of the "UART13 16550 compatible13" project13    ////
////  http13://www13.opencores13.org13/cores13/uart1655013/                   ////
////                                                              ////
////  Documentation13 related13 to this project13:                      ////
////  - http13://www13.opencores13.org13/cores13/uart1655013/                 ////
////                                                              ////
////  Projects13 compatibility13:                                     ////
////  - WISHBONE13                                                  ////
////  RS23213 Protocol13                                              ////
////  16550D uart13 (mostly13 supported)                              ////
////                                                              ////
////  Overview13 (main13 Features13):                                   ////
////  UART13 core13 top level.                                        ////
////                                                              ////
////  Known13 problems13 (limits13):                                    ////
////  Note13 that transmitter13 and receiver13 instances13 are inside     ////
////  the uart_regs13.v file.                                       ////
////                                                              ////
////  To13 Do13:                                                      ////
////  Nothing so far13.                                             ////
////                                                              ////
////  Author13(s):                                                  ////
////      - gorban13@opencores13.org13                                  ////
////      - Jacob13 Gorban13                                          ////
////      - Igor13 Mohor13 (igorm13@opencores13.org13)                      ////
////                                                              ////
////  Created13:        2001/05/12                                  ////
////  Last13 Updated13:   2001/05/17                                  ////
////                  (See log13 for the revision13 history13)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2000, 2001 Authors13                             ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS13 Revision13 History13
//
// $Log: not supported by cvs2svn13 $
// Revision13 1.18  2002/07/22 23:02:23  gorban13
// Bug13 Fixes13:
//  * Possible13 loss of sync and bad13 reception13 of stop bit on slow13 baud13 rates13 fixed13.
//   Problem13 reported13 by Kenny13.Tung13.
//  * Bad (or lack13 of ) loopback13 handling13 fixed13. Reported13 by Cherry13 Withers13.
//
// Improvements13:
//  * Made13 FIFO's as general13 inferrable13 memory where possible13.
//  So13 on FPGA13 they should be inferred13 as RAM13 (Distributed13 RAM13 on Xilinx13).
//  This13 saves13 about13 1/3 of the Slice13 count and reduces13 P&R and synthesis13 times.
//
//  * Added13 optional13 baudrate13 output (baud_o13).
//  This13 is identical13 to BAUDOUT13* signal13 on 16550 chip13.
//  It outputs13 16xbit_clock_rate - the divided13 clock13.
//  It's disabled by default. Define13 UART_HAS_BAUDRATE_OUTPUT13 to use.
//
// Revision13 1.17  2001/12/19 08:40:03  mohor13
// Warnings13 fixed13 (unused13 signals13 removed).
//
// Revision13 1.16  2001/12/06 14:51:04  gorban13
// Bug13 in LSR13[0] is fixed13.
// All WISHBONE13 signals13 are now sampled13, so another13 wait-state is introduced13 on all transfers13.
//
// Revision13 1.15  2001/12/03 21:44:29  gorban13
// Updated13 specification13 documentation.
// Added13 full 32-bit data bus interface, now as default.
// Address is 5-bit wide13 in 32-bit data bus mode.
// Added13 wb_sel_i13 input to the core13. It's used in the 32-bit mode.
// Added13 debug13 interface with two13 32-bit read-only registers in 32-bit mode.
// Bits13 5 and 6 of LSR13 are now only cleared13 on TX13 FIFO write.
// My13 small test bench13 is modified to work13 with 32-bit mode.
//
// Revision13 1.14  2001/11/07 17:51:52  gorban13
// Heavily13 rewritten13 interrupt13 and LSR13 subsystems13.
// Many13 bugs13 hopefully13 squashed13.
//
// Revision13 1.13  2001/10/20 09:58:40  gorban13
// Small13 synopsis13 fixes13
//
// Revision13 1.12  2001/08/25 15:46:19  gorban13
// Modified13 port names again13
//
// Revision13 1.11  2001/08/24 21:01:12  mohor13
// Things13 connected13 to parity13 changed.
// Clock13 devider13 changed.
//
// Revision13 1.10  2001/08/23 16:05:05  mohor13
// Stop bit bug13 fixed13.
// Parity13 bug13 fixed13.
// WISHBONE13 read cycle bug13 fixed13,
// OE13 indicator13 (Overrun13 Error) bug13 fixed13.
// PE13 indicator13 (Parity13 Error) bug13 fixed13.
// Register read bug13 fixed13.
//
// Revision13 1.4  2001/05/31 20:08:01  gorban13
// FIFO changes13 and other corrections13.
//
// Revision13 1.3  2001/05/21 19:12:02  gorban13
// Corrected13 some13 Linter13 messages13.
//
// Revision13 1.2  2001/05/17 18:34:18  gorban13
// First13 'stable' release. Should13 be sythesizable13 now. Also13 added new header.
//
// Revision13 1.0  2001-05-17 21:27:12+02  jacob13
// Initial13 revision13
//
//
// synopsys13 translate_off13
`include "timescale.v"
// synopsys13 translate_on13

`include "uart_defines13.v"

module uart_top13	(
	wb_clk_i13, 
	
	// Wishbone13 signals13
	wb_rst_i13, wb_adr_i13, wb_dat_i13, wb_dat_o13, wb_we_i13, wb_stb_i13, wb_cyc_i13, wb_ack_o13, wb_sel_i13,
	int_o13, // interrupt13 request

	// UART13	signals13
	// serial13 input/output
	stx_pad_o13, srx_pad_i13,

	// modem13 signals13
	rts_pad_o13, cts_pad_i13, dtr_pad_o13, dsr_pad_i13, ri_pad_i13, dcd_pad_i13
`ifdef UART_HAS_BAUDRATE_OUTPUT13
	, baud_o13
`endif
	);

parameter 							 uart_data_width13 = `UART_DATA_WIDTH13;
parameter 							 uart_addr_width13 = `UART_ADDR_WIDTH13;

input 								 wb_clk_i13;

// WISHBONE13 interface
input 								 wb_rst_i13;
input [uart_addr_width13-1:0] 	 wb_adr_i13;
input [uart_data_width13-1:0] 	 wb_dat_i13;
output [uart_data_width13-1:0] 	 wb_dat_o13;
input 								 wb_we_i13;
input 								 wb_stb_i13;
input 								 wb_cyc_i13;
input [3:0]							 wb_sel_i13;
output 								 wb_ack_o13;
output 								 int_o13;

// UART13	signals13
input 								 srx_pad_i13;
output 								 stx_pad_o13;
output 								 rts_pad_o13;
input 								 cts_pad_i13;
output 								 dtr_pad_o13;
input 								 dsr_pad_i13;
input 								 ri_pad_i13;
input 								 dcd_pad_i13;

// optional13 baudrate13 output
`ifdef UART_HAS_BAUDRATE_OUTPUT13
output	baud_o13;
`endif


wire 									 stx_pad_o13;
wire 									 rts_pad_o13;
wire 									 dtr_pad_o13;

wire [uart_addr_width13-1:0] 	 wb_adr_i13;
wire [uart_data_width13-1:0] 	 wb_dat_i13;
wire [uart_data_width13-1:0] 	 wb_dat_o13;

wire [7:0] 							 wb_dat8_i13; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o13; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o13; // debug13 interface 32-bit output
wire [3:0] 							 wb_sel_i13;  // WISHBONE13 select13 signal13
wire [uart_addr_width13-1:0] 	 wb_adr_int13;
wire 									 we_o13;	// Write enable for registers
wire		          	     re_o13;	// Read enable for registers
//
// MODULE13 INSTANCES13
//

`ifdef DATA_BUS_WIDTH_813
`else
// debug13 interface wires13
wire	[3:0] ier13;
wire	[3:0] iir13;
wire	[1:0] fcr13;
wire	[4:0] mcr13;
wire	[7:0] lcr13;
wire	[7:0] msr13;
wire	[7:0] lsr13;
wire	[`UART_FIFO_COUNTER_W13-1:0] rf_count13;
wire	[`UART_FIFO_COUNTER_W13-1:0] tf_count13;
wire	[2:0] tstate13;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_813
////  WISHBONE13 interface module
uart_wb13		wb_interface13(
		.clk13(		wb_clk_i13		),
		.wb_rst_i13(	wb_rst_i13	),
	.wb_dat_i13(wb_dat_i13),
	.wb_dat_o13(wb_dat_o13),
	.wb_dat8_i13(wb_dat8_i13),
	.wb_dat8_o13(wb_dat8_o13),
	 .wb_dat32_o13(32'b0),								 
	 .wb_sel_i13(4'b0),
		.wb_we_i13(	wb_we_i13		),
		.wb_stb_i13(	wb_stb_i13	),
		.wb_cyc_i13(	wb_cyc_i13	),
		.wb_ack_o13(	wb_ack_o13	),
	.wb_adr_i13(wb_adr_i13),
	.wb_adr_int13(wb_adr_int13),
		.we_o13(		we_o13		),
		.re_o13(re_o13)
		);
`else
uart_wb13		wb_interface13(
		.clk13(		wb_clk_i13		),
		.wb_rst_i13(	wb_rst_i13	),
	.wb_dat_i13(wb_dat_i13),
	.wb_dat_o13(wb_dat_o13),
	.wb_dat8_i13(wb_dat8_i13),
	.wb_dat8_o13(wb_dat8_o13),
	 .wb_sel_i13(wb_sel_i13),
	 .wb_dat32_o13(wb_dat32_o13),								 
		.wb_we_i13(	wb_we_i13		),
		.wb_stb_i13(	wb_stb_i13	),
		.wb_cyc_i13(	wb_cyc_i13	),
		.wb_ack_o13(	wb_ack_o13	),
	.wb_adr_i13(wb_adr_i13),
	.wb_adr_int13(wb_adr_int13),
		.we_o13(		we_o13		),
		.re_o13(re_o13)
		);
`endif

// Registers13
uart_regs13	regs(
	.clk13(		wb_clk_i13		),
	.wb_rst_i13(	wb_rst_i13	),
	.wb_addr_i13(	wb_adr_int13	),
	.wb_dat_i13(	wb_dat8_i13	),
	.wb_dat_o13(	wb_dat8_o13	),
	.wb_we_i13(	we_o13		),
   .wb_re_i13(re_o13),
	.modem_inputs13(	{cts_pad_i13, dsr_pad_i13,
	ri_pad_i13,  dcd_pad_i13}	),
	.stx_pad_o13(		stx_pad_o13		),
	.srx_pad_i13(		srx_pad_i13		),
`ifdef DATA_BUS_WIDTH_813
`else
// debug13 interface signals13	enabled
.ier13(ier13), 
.iir13(iir13), 
.fcr13(fcr13), 
.mcr13(mcr13), 
.lcr13(lcr13), 
.msr13(msr13), 
.lsr13(lsr13), 
.rf_count13(rf_count13),
.tf_count13(tf_count13),
.tstate13(tstate13),
.rstate(rstate),
`endif					  
	.rts_pad_o13(		rts_pad_o13		),
	.dtr_pad_o13(		dtr_pad_o13		),
	.int_o13(		int_o13		)
`ifdef UART_HAS_BAUDRATE_OUTPUT13
	, .baud_o13(baud_o13)
`endif

);

`ifdef DATA_BUS_WIDTH_813
`else
uart_debug_if13 dbg13(/*AUTOINST13*/
						// Outputs13
						.wb_dat32_o13				 (wb_dat32_o13[31:0]),
						// Inputs13
						.wb_adr_i13				 (wb_adr_int13[`UART_ADDR_WIDTH13-1:0]),
						.ier13						 (ier13[3:0]),
						.iir13						 (iir13[3:0]),
						.fcr13						 (fcr13[1:0]),
						.mcr13						 (mcr13[4:0]),
						.lcr13						 (lcr13[7:0]),
						.msr13						 (msr13[7:0]),
						.lsr13						 (lsr13[7:0]),
						.rf_count13				 (rf_count13[`UART_FIFO_COUNTER_W13-1:0]),
						.tf_count13				 (tf_count13[`UART_FIFO_COUNTER_W13-1:0]),
						.tstate13					 (tstate13[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_813
		$display("(%m) UART13 INFO13: Data bus width is 8. No Debug13 interface.\n");
	`else
		$display("(%m) UART13 INFO13: Data bus width is 32. Debug13 Interface13 present13.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT13
		$display("(%m) UART13 INFO13: Has13 baudrate13 output\n");
	`else
		$display("(%m) UART13 INFO13: Doesn13't have baudrate13 output\n");
	`endif
end

endmodule


