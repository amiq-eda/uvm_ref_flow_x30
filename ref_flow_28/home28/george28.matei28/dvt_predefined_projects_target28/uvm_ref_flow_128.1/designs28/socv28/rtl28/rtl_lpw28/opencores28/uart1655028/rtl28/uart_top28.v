//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top28.v                                                  ////
////                                                              ////
////                                                              ////
////  This28 file is part of the "UART28 16550 compatible28" project28    ////
////  http28://www28.opencores28.org28/cores28/uart1655028/                   ////
////                                                              ////
////  Documentation28 related28 to this project28:                      ////
////  - http28://www28.opencores28.org28/cores28/uart1655028/                 ////
////                                                              ////
////  Projects28 compatibility28:                                     ////
////  - WISHBONE28                                                  ////
////  RS23228 Protocol28                                              ////
////  16550D uart28 (mostly28 supported)                              ////
////                                                              ////
////  Overview28 (main28 Features28):                                   ////
////  UART28 core28 top level.                                        ////
////                                                              ////
////  Known28 problems28 (limits28):                                    ////
////  Note28 that transmitter28 and receiver28 instances28 are inside     ////
////  the uart_regs28.v file.                                       ////
////                                                              ////
////  To28 Do28:                                                      ////
////  Nothing so far28.                                             ////
////                                                              ////
////  Author28(s):                                                  ////
////      - gorban28@opencores28.org28                                  ////
////      - Jacob28 Gorban28                                          ////
////      - Igor28 Mohor28 (igorm28@opencores28.org28)                      ////
////                                                              ////
////  Created28:        2001/05/12                                  ////
////  Last28 Updated28:   2001/05/17                                  ////
////                  (See log28 for the revision28 history28)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2000, 2001 Authors28                             ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS28 Revision28 History28
//
// $Log: not supported by cvs2svn28 $
// Revision28 1.18  2002/07/22 23:02:23  gorban28
// Bug28 Fixes28:
//  * Possible28 loss of sync and bad28 reception28 of stop bit on slow28 baud28 rates28 fixed28.
//   Problem28 reported28 by Kenny28.Tung28.
//  * Bad (or lack28 of ) loopback28 handling28 fixed28. Reported28 by Cherry28 Withers28.
//
// Improvements28:
//  * Made28 FIFO's as general28 inferrable28 memory where possible28.
//  So28 on FPGA28 they should be inferred28 as RAM28 (Distributed28 RAM28 on Xilinx28).
//  This28 saves28 about28 1/3 of the Slice28 count and reduces28 P&R and synthesis28 times.
//
//  * Added28 optional28 baudrate28 output (baud_o28).
//  This28 is identical28 to BAUDOUT28* signal28 on 16550 chip28.
//  It outputs28 16xbit_clock_rate - the divided28 clock28.
//  It's disabled by default. Define28 UART_HAS_BAUDRATE_OUTPUT28 to use.
//
// Revision28 1.17  2001/12/19 08:40:03  mohor28
// Warnings28 fixed28 (unused28 signals28 removed).
//
// Revision28 1.16  2001/12/06 14:51:04  gorban28
// Bug28 in LSR28[0] is fixed28.
// All WISHBONE28 signals28 are now sampled28, so another28 wait-state is introduced28 on all transfers28.
//
// Revision28 1.15  2001/12/03 21:44:29  gorban28
// Updated28 specification28 documentation.
// Added28 full 32-bit data bus interface, now as default.
// Address is 5-bit wide28 in 32-bit data bus mode.
// Added28 wb_sel_i28 input to the core28. It's used in the 32-bit mode.
// Added28 debug28 interface with two28 32-bit read-only registers in 32-bit mode.
// Bits28 5 and 6 of LSR28 are now only cleared28 on TX28 FIFO write.
// My28 small test bench28 is modified to work28 with 32-bit mode.
//
// Revision28 1.14  2001/11/07 17:51:52  gorban28
// Heavily28 rewritten28 interrupt28 and LSR28 subsystems28.
// Many28 bugs28 hopefully28 squashed28.
//
// Revision28 1.13  2001/10/20 09:58:40  gorban28
// Small28 synopsis28 fixes28
//
// Revision28 1.12  2001/08/25 15:46:19  gorban28
// Modified28 port names again28
//
// Revision28 1.11  2001/08/24 21:01:12  mohor28
// Things28 connected28 to parity28 changed.
// Clock28 devider28 changed.
//
// Revision28 1.10  2001/08/23 16:05:05  mohor28
// Stop bit bug28 fixed28.
// Parity28 bug28 fixed28.
// WISHBONE28 read cycle bug28 fixed28,
// OE28 indicator28 (Overrun28 Error) bug28 fixed28.
// PE28 indicator28 (Parity28 Error) bug28 fixed28.
// Register read bug28 fixed28.
//
// Revision28 1.4  2001/05/31 20:08:01  gorban28
// FIFO changes28 and other corrections28.
//
// Revision28 1.3  2001/05/21 19:12:02  gorban28
// Corrected28 some28 Linter28 messages28.
//
// Revision28 1.2  2001/05/17 18:34:18  gorban28
// First28 'stable' release. Should28 be sythesizable28 now. Also28 added new header.
//
// Revision28 1.0  2001-05-17 21:27:12+02  jacob28
// Initial28 revision28
//
//
// synopsys28 translate_off28
`include "timescale.v"
// synopsys28 translate_on28

`include "uart_defines28.v"

module uart_top28	(
	wb_clk_i28, 
	
	// Wishbone28 signals28
	wb_rst_i28, wb_adr_i28, wb_dat_i28, wb_dat_o28, wb_we_i28, wb_stb_i28, wb_cyc_i28, wb_ack_o28, wb_sel_i28,
	int_o28, // interrupt28 request

	// UART28	signals28
	// serial28 input/output
	stx_pad_o28, srx_pad_i28,

	// modem28 signals28
	rts_pad_o28, cts_pad_i28, dtr_pad_o28, dsr_pad_i28, ri_pad_i28, dcd_pad_i28
`ifdef UART_HAS_BAUDRATE_OUTPUT28
	, baud_o28
`endif
	);

parameter 							 uart_data_width28 = `UART_DATA_WIDTH28;
parameter 							 uart_addr_width28 = `UART_ADDR_WIDTH28;

input 								 wb_clk_i28;

// WISHBONE28 interface
input 								 wb_rst_i28;
input [uart_addr_width28-1:0] 	 wb_adr_i28;
input [uart_data_width28-1:0] 	 wb_dat_i28;
output [uart_data_width28-1:0] 	 wb_dat_o28;
input 								 wb_we_i28;
input 								 wb_stb_i28;
input 								 wb_cyc_i28;
input [3:0]							 wb_sel_i28;
output 								 wb_ack_o28;
output 								 int_o28;

// UART28	signals28
input 								 srx_pad_i28;
output 								 stx_pad_o28;
output 								 rts_pad_o28;
input 								 cts_pad_i28;
output 								 dtr_pad_o28;
input 								 dsr_pad_i28;
input 								 ri_pad_i28;
input 								 dcd_pad_i28;

// optional28 baudrate28 output
`ifdef UART_HAS_BAUDRATE_OUTPUT28
output	baud_o28;
`endif


wire 									 stx_pad_o28;
wire 									 rts_pad_o28;
wire 									 dtr_pad_o28;

wire [uart_addr_width28-1:0] 	 wb_adr_i28;
wire [uart_data_width28-1:0] 	 wb_dat_i28;
wire [uart_data_width28-1:0] 	 wb_dat_o28;

wire [7:0] 							 wb_dat8_i28; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o28; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o28; // debug28 interface 32-bit output
wire [3:0] 							 wb_sel_i28;  // WISHBONE28 select28 signal28
wire [uart_addr_width28-1:0] 	 wb_adr_int28;
wire 									 we_o28;	// Write enable for registers
wire		          	     re_o28;	// Read enable for registers
//
// MODULE28 INSTANCES28
//

`ifdef DATA_BUS_WIDTH_828
`else
// debug28 interface wires28
wire	[3:0] ier28;
wire	[3:0] iir28;
wire	[1:0] fcr28;
wire	[4:0] mcr28;
wire	[7:0] lcr28;
wire	[7:0] msr28;
wire	[7:0] lsr28;
wire	[`UART_FIFO_COUNTER_W28-1:0] rf_count28;
wire	[`UART_FIFO_COUNTER_W28-1:0] tf_count28;
wire	[2:0] tstate28;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_828
////  WISHBONE28 interface module
uart_wb28		wb_interface28(
		.clk28(		wb_clk_i28		),
		.wb_rst_i28(	wb_rst_i28	),
	.wb_dat_i28(wb_dat_i28),
	.wb_dat_o28(wb_dat_o28),
	.wb_dat8_i28(wb_dat8_i28),
	.wb_dat8_o28(wb_dat8_o28),
	 .wb_dat32_o28(32'b0),								 
	 .wb_sel_i28(4'b0),
		.wb_we_i28(	wb_we_i28		),
		.wb_stb_i28(	wb_stb_i28	),
		.wb_cyc_i28(	wb_cyc_i28	),
		.wb_ack_o28(	wb_ack_o28	),
	.wb_adr_i28(wb_adr_i28),
	.wb_adr_int28(wb_adr_int28),
		.we_o28(		we_o28		),
		.re_o28(re_o28)
		);
`else
uart_wb28		wb_interface28(
		.clk28(		wb_clk_i28		),
		.wb_rst_i28(	wb_rst_i28	),
	.wb_dat_i28(wb_dat_i28),
	.wb_dat_o28(wb_dat_o28),
	.wb_dat8_i28(wb_dat8_i28),
	.wb_dat8_o28(wb_dat8_o28),
	 .wb_sel_i28(wb_sel_i28),
	 .wb_dat32_o28(wb_dat32_o28),								 
		.wb_we_i28(	wb_we_i28		),
		.wb_stb_i28(	wb_stb_i28	),
		.wb_cyc_i28(	wb_cyc_i28	),
		.wb_ack_o28(	wb_ack_o28	),
	.wb_adr_i28(wb_adr_i28),
	.wb_adr_int28(wb_adr_int28),
		.we_o28(		we_o28		),
		.re_o28(re_o28)
		);
`endif

// Registers28
uart_regs28	regs(
	.clk28(		wb_clk_i28		),
	.wb_rst_i28(	wb_rst_i28	),
	.wb_addr_i28(	wb_adr_int28	),
	.wb_dat_i28(	wb_dat8_i28	),
	.wb_dat_o28(	wb_dat8_o28	),
	.wb_we_i28(	we_o28		),
   .wb_re_i28(re_o28),
	.modem_inputs28(	{cts_pad_i28, dsr_pad_i28,
	ri_pad_i28,  dcd_pad_i28}	),
	.stx_pad_o28(		stx_pad_o28		),
	.srx_pad_i28(		srx_pad_i28		),
`ifdef DATA_BUS_WIDTH_828
`else
// debug28 interface signals28	enabled
.ier28(ier28), 
.iir28(iir28), 
.fcr28(fcr28), 
.mcr28(mcr28), 
.lcr28(lcr28), 
.msr28(msr28), 
.lsr28(lsr28), 
.rf_count28(rf_count28),
.tf_count28(tf_count28),
.tstate28(tstate28),
.rstate(rstate),
`endif					  
	.rts_pad_o28(		rts_pad_o28		),
	.dtr_pad_o28(		dtr_pad_o28		),
	.int_o28(		int_o28		)
`ifdef UART_HAS_BAUDRATE_OUTPUT28
	, .baud_o28(baud_o28)
`endif

);

`ifdef DATA_BUS_WIDTH_828
`else
uart_debug_if28 dbg28(/*AUTOINST28*/
						// Outputs28
						.wb_dat32_o28				 (wb_dat32_o28[31:0]),
						// Inputs28
						.wb_adr_i28				 (wb_adr_int28[`UART_ADDR_WIDTH28-1:0]),
						.ier28						 (ier28[3:0]),
						.iir28						 (iir28[3:0]),
						.fcr28						 (fcr28[1:0]),
						.mcr28						 (mcr28[4:0]),
						.lcr28						 (lcr28[7:0]),
						.msr28						 (msr28[7:0]),
						.lsr28						 (lsr28[7:0]),
						.rf_count28				 (rf_count28[`UART_FIFO_COUNTER_W28-1:0]),
						.tf_count28				 (tf_count28[`UART_FIFO_COUNTER_W28-1:0]),
						.tstate28					 (tstate28[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_828
		$display("(%m) UART28 INFO28: Data bus width is 8. No Debug28 interface.\n");
	`else
		$display("(%m) UART28 INFO28: Data bus width is 32. Debug28 Interface28 present28.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT28
		$display("(%m) UART28 INFO28: Has28 baudrate28 output\n");
	`else
		$display("(%m) UART28 INFO28: Doesn28't have baudrate28 output\n");
	`endif
end

endmodule


