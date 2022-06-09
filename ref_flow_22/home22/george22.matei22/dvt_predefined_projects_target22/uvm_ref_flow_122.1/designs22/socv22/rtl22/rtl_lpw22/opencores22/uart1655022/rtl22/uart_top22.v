//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top22.v                                                  ////
////                                                              ////
////                                                              ////
////  This22 file is part of the "UART22 16550 compatible22" project22    ////
////  http22://www22.opencores22.org22/cores22/uart1655022/                   ////
////                                                              ////
////  Documentation22 related22 to this project22:                      ////
////  - http22://www22.opencores22.org22/cores22/uart1655022/                 ////
////                                                              ////
////  Projects22 compatibility22:                                     ////
////  - WISHBONE22                                                  ////
////  RS23222 Protocol22                                              ////
////  16550D uart22 (mostly22 supported)                              ////
////                                                              ////
////  Overview22 (main22 Features22):                                   ////
////  UART22 core22 top level.                                        ////
////                                                              ////
////  Known22 problems22 (limits22):                                    ////
////  Note22 that transmitter22 and receiver22 instances22 are inside     ////
////  the uart_regs22.v file.                                       ////
////                                                              ////
////  To22 Do22:                                                      ////
////  Nothing so far22.                                             ////
////                                                              ////
////  Author22(s):                                                  ////
////      - gorban22@opencores22.org22                                  ////
////      - Jacob22 Gorban22                                          ////
////      - Igor22 Mohor22 (igorm22@opencores22.org22)                      ////
////                                                              ////
////  Created22:        2001/05/12                                  ////
////  Last22 Updated22:   2001/05/17                                  ////
////                  (See log22 for the revision22 history22)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2000, 2001 Authors22                             ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS22 Revision22 History22
//
// $Log: not supported by cvs2svn22 $
// Revision22 1.18  2002/07/22 23:02:23  gorban22
// Bug22 Fixes22:
//  * Possible22 loss of sync and bad22 reception22 of stop bit on slow22 baud22 rates22 fixed22.
//   Problem22 reported22 by Kenny22.Tung22.
//  * Bad (or lack22 of ) loopback22 handling22 fixed22. Reported22 by Cherry22 Withers22.
//
// Improvements22:
//  * Made22 FIFO's as general22 inferrable22 memory where possible22.
//  So22 on FPGA22 they should be inferred22 as RAM22 (Distributed22 RAM22 on Xilinx22).
//  This22 saves22 about22 1/3 of the Slice22 count and reduces22 P&R and synthesis22 times.
//
//  * Added22 optional22 baudrate22 output (baud_o22).
//  This22 is identical22 to BAUDOUT22* signal22 on 16550 chip22.
//  It outputs22 16xbit_clock_rate - the divided22 clock22.
//  It's disabled by default. Define22 UART_HAS_BAUDRATE_OUTPUT22 to use.
//
// Revision22 1.17  2001/12/19 08:40:03  mohor22
// Warnings22 fixed22 (unused22 signals22 removed).
//
// Revision22 1.16  2001/12/06 14:51:04  gorban22
// Bug22 in LSR22[0] is fixed22.
// All WISHBONE22 signals22 are now sampled22, so another22 wait-state is introduced22 on all transfers22.
//
// Revision22 1.15  2001/12/03 21:44:29  gorban22
// Updated22 specification22 documentation.
// Added22 full 32-bit data bus interface, now as default.
// Address is 5-bit wide22 in 32-bit data bus mode.
// Added22 wb_sel_i22 input to the core22. It's used in the 32-bit mode.
// Added22 debug22 interface with two22 32-bit read-only registers in 32-bit mode.
// Bits22 5 and 6 of LSR22 are now only cleared22 on TX22 FIFO write.
// My22 small test bench22 is modified to work22 with 32-bit mode.
//
// Revision22 1.14  2001/11/07 17:51:52  gorban22
// Heavily22 rewritten22 interrupt22 and LSR22 subsystems22.
// Many22 bugs22 hopefully22 squashed22.
//
// Revision22 1.13  2001/10/20 09:58:40  gorban22
// Small22 synopsis22 fixes22
//
// Revision22 1.12  2001/08/25 15:46:19  gorban22
// Modified22 port names again22
//
// Revision22 1.11  2001/08/24 21:01:12  mohor22
// Things22 connected22 to parity22 changed.
// Clock22 devider22 changed.
//
// Revision22 1.10  2001/08/23 16:05:05  mohor22
// Stop bit bug22 fixed22.
// Parity22 bug22 fixed22.
// WISHBONE22 read cycle bug22 fixed22,
// OE22 indicator22 (Overrun22 Error) bug22 fixed22.
// PE22 indicator22 (Parity22 Error) bug22 fixed22.
// Register read bug22 fixed22.
//
// Revision22 1.4  2001/05/31 20:08:01  gorban22
// FIFO changes22 and other corrections22.
//
// Revision22 1.3  2001/05/21 19:12:02  gorban22
// Corrected22 some22 Linter22 messages22.
//
// Revision22 1.2  2001/05/17 18:34:18  gorban22
// First22 'stable' release. Should22 be sythesizable22 now. Also22 added new header.
//
// Revision22 1.0  2001-05-17 21:27:12+02  jacob22
// Initial22 revision22
//
//
// synopsys22 translate_off22
`include "timescale.v"
// synopsys22 translate_on22

`include "uart_defines22.v"

module uart_top22	(
	wb_clk_i22, 
	
	// Wishbone22 signals22
	wb_rst_i22, wb_adr_i22, wb_dat_i22, wb_dat_o22, wb_we_i22, wb_stb_i22, wb_cyc_i22, wb_ack_o22, wb_sel_i22,
	int_o22, // interrupt22 request

	// UART22	signals22
	// serial22 input/output
	stx_pad_o22, srx_pad_i22,

	// modem22 signals22
	rts_pad_o22, cts_pad_i22, dtr_pad_o22, dsr_pad_i22, ri_pad_i22, dcd_pad_i22
`ifdef UART_HAS_BAUDRATE_OUTPUT22
	, baud_o22
`endif
	);

parameter 							 uart_data_width22 = `UART_DATA_WIDTH22;
parameter 							 uart_addr_width22 = `UART_ADDR_WIDTH22;

input 								 wb_clk_i22;

// WISHBONE22 interface
input 								 wb_rst_i22;
input [uart_addr_width22-1:0] 	 wb_adr_i22;
input [uart_data_width22-1:0] 	 wb_dat_i22;
output [uart_data_width22-1:0] 	 wb_dat_o22;
input 								 wb_we_i22;
input 								 wb_stb_i22;
input 								 wb_cyc_i22;
input [3:0]							 wb_sel_i22;
output 								 wb_ack_o22;
output 								 int_o22;

// UART22	signals22
input 								 srx_pad_i22;
output 								 stx_pad_o22;
output 								 rts_pad_o22;
input 								 cts_pad_i22;
output 								 dtr_pad_o22;
input 								 dsr_pad_i22;
input 								 ri_pad_i22;
input 								 dcd_pad_i22;

// optional22 baudrate22 output
`ifdef UART_HAS_BAUDRATE_OUTPUT22
output	baud_o22;
`endif


wire 									 stx_pad_o22;
wire 									 rts_pad_o22;
wire 									 dtr_pad_o22;

wire [uart_addr_width22-1:0] 	 wb_adr_i22;
wire [uart_data_width22-1:0] 	 wb_dat_i22;
wire [uart_data_width22-1:0] 	 wb_dat_o22;

wire [7:0] 							 wb_dat8_i22; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o22; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o22; // debug22 interface 32-bit output
wire [3:0] 							 wb_sel_i22;  // WISHBONE22 select22 signal22
wire [uart_addr_width22-1:0] 	 wb_adr_int22;
wire 									 we_o22;	// Write enable for registers
wire		          	     re_o22;	// Read enable for registers
//
// MODULE22 INSTANCES22
//

`ifdef DATA_BUS_WIDTH_822
`else
// debug22 interface wires22
wire	[3:0] ier22;
wire	[3:0] iir22;
wire	[1:0] fcr22;
wire	[4:0] mcr22;
wire	[7:0] lcr22;
wire	[7:0] msr22;
wire	[7:0] lsr22;
wire	[`UART_FIFO_COUNTER_W22-1:0] rf_count22;
wire	[`UART_FIFO_COUNTER_W22-1:0] tf_count22;
wire	[2:0] tstate22;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_822
////  WISHBONE22 interface module
uart_wb22		wb_interface22(
		.clk22(		wb_clk_i22		),
		.wb_rst_i22(	wb_rst_i22	),
	.wb_dat_i22(wb_dat_i22),
	.wb_dat_o22(wb_dat_o22),
	.wb_dat8_i22(wb_dat8_i22),
	.wb_dat8_o22(wb_dat8_o22),
	 .wb_dat32_o22(32'b0),								 
	 .wb_sel_i22(4'b0),
		.wb_we_i22(	wb_we_i22		),
		.wb_stb_i22(	wb_stb_i22	),
		.wb_cyc_i22(	wb_cyc_i22	),
		.wb_ack_o22(	wb_ack_o22	),
	.wb_adr_i22(wb_adr_i22),
	.wb_adr_int22(wb_adr_int22),
		.we_o22(		we_o22		),
		.re_o22(re_o22)
		);
`else
uart_wb22		wb_interface22(
		.clk22(		wb_clk_i22		),
		.wb_rst_i22(	wb_rst_i22	),
	.wb_dat_i22(wb_dat_i22),
	.wb_dat_o22(wb_dat_o22),
	.wb_dat8_i22(wb_dat8_i22),
	.wb_dat8_o22(wb_dat8_o22),
	 .wb_sel_i22(wb_sel_i22),
	 .wb_dat32_o22(wb_dat32_o22),								 
		.wb_we_i22(	wb_we_i22		),
		.wb_stb_i22(	wb_stb_i22	),
		.wb_cyc_i22(	wb_cyc_i22	),
		.wb_ack_o22(	wb_ack_o22	),
	.wb_adr_i22(wb_adr_i22),
	.wb_adr_int22(wb_adr_int22),
		.we_o22(		we_o22		),
		.re_o22(re_o22)
		);
`endif

// Registers22
uart_regs22	regs(
	.clk22(		wb_clk_i22		),
	.wb_rst_i22(	wb_rst_i22	),
	.wb_addr_i22(	wb_adr_int22	),
	.wb_dat_i22(	wb_dat8_i22	),
	.wb_dat_o22(	wb_dat8_o22	),
	.wb_we_i22(	we_o22		),
   .wb_re_i22(re_o22),
	.modem_inputs22(	{cts_pad_i22, dsr_pad_i22,
	ri_pad_i22,  dcd_pad_i22}	),
	.stx_pad_o22(		stx_pad_o22		),
	.srx_pad_i22(		srx_pad_i22		),
`ifdef DATA_BUS_WIDTH_822
`else
// debug22 interface signals22	enabled
.ier22(ier22), 
.iir22(iir22), 
.fcr22(fcr22), 
.mcr22(mcr22), 
.lcr22(lcr22), 
.msr22(msr22), 
.lsr22(lsr22), 
.rf_count22(rf_count22),
.tf_count22(tf_count22),
.tstate22(tstate22),
.rstate(rstate),
`endif					  
	.rts_pad_o22(		rts_pad_o22		),
	.dtr_pad_o22(		dtr_pad_o22		),
	.int_o22(		int_o22		)
`ifdef UART_HAS_BAUDRATE_OUTPUT22
	, .baud_o22(baud_o22)
`endif

);

`ifdef DATA_BUS_WIDTH_822
`else
uart_debug_if22 dbg22(/*AUTOINST22*/
						// Outputs22
						.wb_dat32_o22				 (wb_dat32_o22[31:0]),
						// Inputs22
						.wb_adr_i22				 (wb_adr_int22[`UART_ADDR_WIDTH22-1:0]),
						.ier22						 (ier22[3:0]),
						.iir22						 (iir22[3:0]),
						.fcr22						 (fcr22[1:0]),
						.mcr22						 (mcr22[4:0]),
						.lcr22						 (lcr22[7:0]),
						.msr22						 (msr22[7:0]),
						.lsr22						 (lsr22[7:0]),
						.rf_count22				 (rf_count22[`UART_FIFO_COUNTER_W22-1:0]),
						.tf_count22				 (tf_count22[`UART_FIFO_COUNTER_W22-1:0]),
						.tstate22					 (tstate22[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_822
		$display("(%m) UART22 INFO22: Data bus width is 8. No Debug22 interface.\n");
	`else
		$display("(%m) UART22 INFO22: Data bus width is 32. Debug22 Interface22 present22.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT22
		$display("(%m) UART22 INFO22: Has22 baudrate22 output\n");
	`else
		$display("(%m) UART22 INFO22: Doesn22't have baudrate22 output\n");
	`endif
end

endmodule


