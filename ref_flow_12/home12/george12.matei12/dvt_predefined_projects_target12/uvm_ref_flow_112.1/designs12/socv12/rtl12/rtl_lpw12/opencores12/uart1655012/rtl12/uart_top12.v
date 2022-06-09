//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top12.v                                                  ////
////                                                              ////
////                                                              ////
////  This12 file is part of the "UART12 16550 compatible12" project12    ////
////  http12://www12.opencores12.org12/cores12/uart1655012/                   ////
////                                                              ////
////  Documentation12 related12 to this project12:                      ////
////  - http12://www12.opencores12.org12/cores12/uart1655012/                 ////
////                                                              ////
////  Projects12 compatibility12:                                     ////
////  - WISHBONE12                                                  ////
////  RS23212 Protocol12                                              ////
////  16550D uart12 (mostly12 supported)                              ////
////                                                              ////
////  Overview12 (main12 Features12):                                   ////
////  UART12 core12 top level.                                        ////
////                                                              ////
////  Known12 problems12 (limits12):                                    ////
////  Note12 that transmitter12 and receiver12 instances12 are inside     ////
////  the uart_regs12.v file.                                       ////
////                                                              ////
////  To12 Do12:                                                      ////
////  Nothing so far12.                                             ////
////                                                              ////
////  Author12(s):                                                  ////
////      - gorban12@opencores12.org12                                  ////
////      - Jacob12 Gorban12                                          ////
////      - Igor12 Mohor12 (igorm12@opencores12.org12)                      ////
////                                                              ////
////  Created12:        2001/05/12                                  ////
////  Last12 Updated12:   2001/05/17                                  ////
////                  (See log12 for the revision12 history12)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright12 (C) 2000, 2001 Authors12                             ////
////                                                              ////
//// This12 source12 file may be used and distributed12 without         ////
//// restriction12 provided that this copyright12 statement12 is not    ////
//// removed from the file and that any derivative12 work12 contains12  ////
//// the original copyright12 notice12 and the associated disclaimer12. ////
////                                                              ////
//// This12 source12 file is free software12; you can redistribute12 it   ////
//// and/or modify it under the terms12 of the GNU12 Lesser12 General12   ////
//// Public12 License12 as published12 by the Free12 Software12 Foundation12; ////
//// either12 version12 2.1 of the License12, or (at your12 option) any   ////
//// later12 version12.                                               ////
////                                                              ////
//// This12 source12 is distributed12 in the hope12 that it will be       ////
//// useful12, but WITHOUT12 ANY12 WARRANTY12; without even12 the implied12   ////
//// warranty12 of MERCHANTABILITY12 or FITNESS12 FOR12 A PARTICULAR12      ////
//// PURPOSE12.  See the GNU12 Lesser12 General12 Public12 License12 for more ////
//// details12.                                                     ////
////                                                              ////
//// You should have received12 a copy of the GNU12 Lesser12 General12    ////
//// Public12 License12 along12 with this source12; if not, download12 it   ////
//// from http12://www12.opencores12.org12/lgpl12.shtml12                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS12 Revision12 History12
//
// $Log: not supported by cvs2svn12 $
// Revision12 1.18  2002/07/22 23:02:23  gorban12
// Bug12 Fixes12:
//  * Possible12 loss of sync and bad12 reception12 of stop bit on slow12 baud12 rates12 fixed12.
//   Problem12 reported12 by Kenny12.Tung12.
//  * Bad (or lack12 of ) loopback12 handling12 fixed12. Reported12 by Cherry12 Withers12.
//
// Improvements12:
//  * Made12 FIFO's as general12 inferrable12 memory where possible12.
//  So12 on FPGA12 they should be inferred12 as RAM12 (Distributed12 RAM12 on Xilinx12).
//  This12 saves12 about12 1/3 of the Slice12 count and reduces12 P&R and synthesis12 times.
//
//  * Added12 optional12 baudrate12 output (baud_o12).
//  This12 is identical12 to BAUDOUT12* signal12 on 16550 chip12.
//  It outputs12 16xbit_clock_rate - the divided12 clock12.
//  It's disabled by default. Define12 UART_HAS_BAUDRATE_OUTPUT12 to use.
//
// Revision12 1.17  2001/12/19 08:40:03  mohor12
// Warnings12 fixed12 (unused12 signals12 removed).
//
// Revision12 1.16  2001/12/06 14:51:04  gorban12
// Bug12 in LSR12[0] is fixed12.
// All WISHBONE12 signals12 are now sampled12, so another12 wait-state is introduced12 on all transfers12.
//
// Revision12 1.15  2001/12/03 21:44:29  gorban12
// Updated12 specification12 documentation.
// Added12 full 32-bit data bus interface, now as default.
// Address is 5-bit wide12 in 32-bit data bus mode.
// Added12 wb_sel_i12 input to the core12. It's used in the 32-bit mode.
// Added12 debug12 interface with two12 32-bit read-only registers in 32-bit mode.
// Bits12 5 and 6 of LSR12 are now only cleared12 on TX12 FIFO write.
// My12 small test bench12 is modified to work12 with 32-bit mode.
//
// Revision12 1.14  2001/11/07 17:51:52  gorban12
// Heavily12 rewritten12 interrupt12 and LSR12 subsystems12.
// Many12 bugs12 hopefully12 squashed12.
//
// Revision12 1.13  2001/10/20 09:58:40  gorban12
// Small12 synopsis12 fixes12
//
// Revision12 1.12  2001/08/25 15:46:19  gorban12
// Modified12 port names again12
//
// Revision12 1.11  2001/08/24 21:01:12  mohor12
// Things12 connected12 to parity12 changed.
// Clock12 devider12 changed.
//
// Revision12 1.10  2001/08/23 16:05:05  mohor12
// Stop bit bug12 fixed12.
// Parity12 bug12 fixed12.
// WISHBONE12 read cycle bug12 fixed12,
// OE12 indicator12 (Overrun12 Error) bug12 fixed12.
// PE12 indicator12 (Parity12 Error) bug12 fixed12.
// Register read bug12 fixed12.
//
// Revision12 1.4  2001/05/31 20:08:01  gorban12
// FIFO changes12 and other corrections12.
//
// Revision12 1.3  2001/05/21 19:12:02  gorban12
// Corrected12 some12 Linter12 messages12.
//
// Revision12 1.2  2001/05/17 18:34:18  gorban12
// First12 'stable' release. Should12 be sythesizable12 now. Also12 added new header.
//
// Revision12 1.0  2001-05-17 21:27:12+02  jacob12
// Initial12 revision12
//
//
// synopsys12 translate_off12
`include "timescale.v"
// synopsys12 translate_on12

`include "uart_defines12.v"

module uart_top12	(
	wb_clk_i12, 
	
	// Wishbone12 signals12
	wb_rst_i12, wb_adr_i12, wb_dat_i12, wb_dat_o12, wb_we_i12, wb_stb_i12, wb_cyc_i12, wb_ack_o12, wb_sel_i12,
	int_o12, // interrupt12 request

	// UART12	signals12
	// serial12 input/output
	stx_pad_o12, srx_pad_i12,

	// modem12 signals12
	rts_pad_o12, cts_pad_i12, dtr_pad_o12, dsr_pad_i12, ri_pad_i12, dcd_pad_i12
`ifdef UART_HAS_BAUDRATE_OUTPUT12
	, baud_o12
`endif
	);

parameter 							 uart_data_width12 = `UART_DATA_WIDTH12;
parameter 							 uart_addr_width12 = `UART_ADDR_WIDTH12;

input 								 wb_clk_i12;

// WISHBONE12 interface
input 								 wb_rst_i12;
input [uart_addr_width12-1:0] 	 wb_adr_i12;
input [uart_data_width12-1:0] 	 wb_dat_i12;
output [uart_data_width12-1:0] 	 wb_dat_o12;
input 								 wb_we_i12;
input 								 wb_stb_i12;
input 								 wb_cyc_i12;
input [3:0]							 wb_sel_i12;
output 								 wb_ack_o12;
output 								 int_o12;

// UART12	signals12
input 								 srx_pad_i12;
output 								 stx_pad_o12;
output 								 rts_pad_o12;
input 								 cts_pad_i12;
output 								 dtr_pad_o12;
input 								 dsr_pad_i12;
input 								 ri_pad_i12;
input 								 dcd_pad_i12;

// optional12 baudrate12 output
`ifdef UART_HAS_BAUDRATE_OUTPUT12
output	baud_o12;
`endif


wire 									 stx_pad_o12;
wire 									 rts_pad_o12;
wire 									 dtr_pad_o12;

wire [uart_addr_width12-1:0] 	 wb_adr_i12;
wire [uart_data_width12-1:0] 	 wb_dat_i12;
wire [uart_data_width12-1:0] 	 wb_dat_o12;

wire [7:0] 							 wb_dat8_i12; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o12; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o12; // debug12 interface 32-bit output
wire [3:0] 							 wb_sel_i12;  // WISHBONE12 select12 signal12
wire [uart_addr_width12-1:0] 	 wb_adr_int12;
wire 									 we_o12;	// Write enable for registers
wire		          	     re_o12;	// Read enable for registers
//
// MODULE12 INSTANCES12
//

`ifdef DATA_BUS_WIDTH_812
`else
// debug12 interface wires12
wire	[3:0] ier12;
wire	[3:0] iir12;
wire	[1:0] fcr12;
wire	[4:0] mcr12;
wire	[7:0] lcr12;
wire	[7:0] msr12;
wire	[7:0] lsr12;
wire	[`UART_FIFO_COUNTER_W12-1:0] rf_count12;
wire	[`UART_FIFO_COUNTER_W12-1:0] tf_count12;
wire	[2:0] tstate12;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_812
////  WISHBONE12 interface module
uart_wb12		wb_interface12(
		.clk12(		wb_clk_i12		),
		.wb_rst_i12(	wb_rst_i12	),
	.wb_dat_i12(wb_dat_i12),
	.wb_dat_o12(wb_dat_o12),
	.wb_dat8_i12(wb_dat8_i12),
	.wb_dat8_o12(wb_dat8_o12),
	 .wb_dat32_o12(32'b0),								 
	 .wb_sel_i12(4'b0),
		.wb_we_i12(	wb_we_i12		),
		.wb_stb_i12(	wb_stb_i12	),
		.wb_cyc_i12(	wb_cyc_i12	),
		.wb_ack_o12(	wb_ack_o12	),
	.wb_adr_i12(wb_adr_i12),
	.wb_adr_int12(wb_adr_int12),
		.we_o12(		we_o12		),
		.re_o12(re_o12)
		);
`else
uart_wb12		wb_interface12(
		.clk12(		wb_clk_i12		),
		.wb_rst_i12(	wb_rst_i12	),
	.wb_dat_i12(wb_dat_i12),
	.wb_dat_o12(wb_dat_o12),
	.wb_dat8_i12(wb_dat8_i12),
	.wb_dat8_o12(wb_dat8_o12),
	 .wb_sel_i12(wb_sel_i12),
	 .wb_dat32_o12(wb_dat32_o12),								 
		.wb_we_i12(	wb_we_i12		),
		.wb_stb_i12(	wb_stb_i12	),
		.wb_cyc_i12(	wb_cyc_i12	),
		.wb_ack_o12(	wb_ack_o12	),
	.wb_adr_i12(wb_adr_i12),
	.wb_adr_int12(wb_adr_int12),
		.we_o12(		we_o12		),
		.re_o12(re_o12)
		);
`endif

// Registers12
uart_regs12	regs(
	.clk12(		wb_clk_i12		),
	.wb_rst_i12(	wb_rst_i12	),
	.wb_addr_i12(	wb_adr_int12	),
	.wb_dat_i12(	wb_dat8_i12	),
	.wb_dat_o12(	wb_dat8_o12	),
	.wb_we_i12(	we_o12		),
   .wb_re_i12(re_o12),
	.modem_inputs12(	{cts_pad_i12, dsr_pad_i12,
	ri_pad_i12,  dcd_pad_i12}	),
	.stx_pad_o12(		stx_pad_o12		),
	.srx_pad_i12(		srx_pad_i12		),
`ifdef DATA_BUS_WIDTH_812
`else
// debug12 interface signals12	enabled
.ier12(ier12), 
.iir12(iir12), 
.fcr12(fcr12), 
.mcr12(mcr12), 
.lcr12(lcr12), 
.msr12(msr12), 
.lsr12(lsr12), 
.rf_count12(rf_count12),
.tf_count12(tf_count12),
.tstate12(tstate12),
.rstate(rstate),
`endif					  
	.rts_pad_o12(		rts_pad_o12		),
	.dtr_pad_o12(		dtr_pad_o12		),
	.int_o12(		int_o12		)
`ifdef UART_HAS_BAUDRATE_OUTPUT12
	, .baud_o12(baud_o12)
`endif

);

`ifdef DATA_BUS_WIDTH_812
`else
uart_debug_if12 dbg12(/*AUTOINST12*/
						// Outputs12
						.wb_dat32_o12				 (wb_dat32_o12[31:0]),
						// Inputs12
						.wb_adr_i12				 (wb_adr_int12[`UART_ADDR_WIDTH12-1:0]),
						.ier12						 (ier12[3:0]),
						.iir12						 (iir12[3:0]),
						.fcr12						 (fcr12[1:0]),
						.mcr12						 (mcr12[4:0]),
						.lcr12						 (lcr12[7:0]),
						.msr12						 (msr12[7:0]),
						.lsr12						 (lsr12[7:0]),
						.rf_count12				 (rf_count12[`UART_FIFO_COUNTER_W12-1:0]),
						.tf_count12				 (tf_count12[`UART_FIFO_COUNTER_W12-1:0]),
						.tstate12					 (tstate12[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_812
		$display("(%m) UART12 INFO12: Data bus width is 8. No Debug12 interface.\n");
	`else
		$display("(%m) UART12 INFO12: Data bus width is 32. Debug12 Interface12 present12.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT12
		$display("(%m) UART12 INFO12: Has12 baudrate12 output\n");
	`else
		$display("(%m) UART12 INFO12: Doesn12't have baudrate12 output\n");
	`endif
end

endmodule


