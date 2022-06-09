//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top11.v                                                  ////
////                                                              ////
////                                                              ////
////  This11 file is part of the "UART11 16550 compatible11" project11    ////
////  http11://www11.opencores11.org11/cores11/uart1655011/                   ////
////                                                              ////
////  Documentation11 related11 to this project11:                      ////
////  - http11://www11.opencores11.org11/cores11/uart1655011/                 ////
////                                                              ////
////  Projects11 compatibility11:                                     ////
////  - WISHBONE11                                                  ////
////  RS23211 Protocol11                                              ////
////  16550D uart11 (mostly11 supported)                              ////
////                                                              ////
////  Overview11 (main11 Features11):                                   ////
////  UART11 core11 top level.                                        ////
////                                                              ////
////  Known11 problems11 (limits11):                                    ////
////  Note11 that transmitter11 and receiver11 instances11 are inside     ////
////  the uart_regs11.v file.                                       ////
////                                                              ////
////  To11 Do11:                                                      ////
////  Nothing so far11.                                             ////
////                                                              ////
////  Author11(s):                                                  ////
////      - gorban11@opencores11.org11                                  ////
////      - Jacob11 Gorban11                                          ////
////      - Igor11 Mohor11 (igorm11@opencores11.org11)                      ////
////                                                              ////
////  Created11:        2001/05/12                                  ////
////  Last11 Updated11:   2001/05/17                                  ////
////                  (See log11 for the revision11 history11)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2000, 2001 Authors11                             ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS11 Revision11 History11
//
// $Log: not supported by cvs2svn11 $
// Revision11 1.18  2002/07/22 23:02:23  gorban11
// Bug11 Fixes11:
//  * Possible11 loss of sync and bad11 reception11 of stop bit on slow11 baud11 rates11 fixed11.
//   Problem11 reported11 by Kenny11.Tung11.
//  * Bad (or lack11 of ) loopback11 handling11 fixed11. Reported11 by Cherry11 Withers11.
//
// Improvements11:
//  * Made11 FIFO's as general11 inferrable11 memory where possible11.
//  So11 on FPGA11 they should be inferred11 as RAM11 (Distributed11 RAM11 on Xilinx11).
//  This11 saves11 about11 1/3 of the Slice11 count and reduces11 P&R and synthesis11 times.
//
//  * Added11 optional11 baudrate11 output (baud_o11).
//  This11 is identical11 to BAUDOUT11* signal11 on 16550 chip11.
//  It outputs11 16xbit_clock_rate - the divided11 clock11.
//  It's disabled by default. Define11 UART_HAS_BAUDRATE_OUTPUT11 to use.
//
// Revision11 1.17  2001/12/19 08:40:03  mohor11
// Warnings11 fixed11 (unused11 signals11 removed).
//
// Revision11 1.16  2001/12/06 14:51:04  gorban11
// Bug11 in LSR11[0] is fixed11.
// All WISHBONE11 signals11 are now sampled11, so another11 wait-state is introduced11 on all transfers11.
//
// Revision11 1.15  2001/12/03 21:44:29  gorban11
// Updated11 specification11 documentation.
// Added11 full 32-bit data bus interface, now as default.
// Address is 5-bit wide11 in 32-bit data bus mode.
// Added11 wb_sel_i11 input to the core11. It's used in the 32-bit mode.
// Added11 debug11 interface with two11 32-bit read-only registers in 32-bit mode.
// Bits11 5 and 6 of LSR11 are now only cleared11 on TX11 FIFO write.
// My11 small test bench11 is modified to work11 with 32-bit mode.
//
// Revision11 1.14  2001/11/07 17:51:52  gorban11
// Heavily11 rewritten11 interrupt11 and LSR11 subsystems11.
// Many11 bugs11 hopefully11 squashed11.
//
// Revision11 1.13  2001/10/20 09:58:40  gorban11
// Small11 synopsis11 fixes11
//
// Revision11 1.12  2001/08/25 15:46:19  gorban11
// Modified11 port names again11
//
// Revision11 1.11  2001/08/24 21:01:12  mohor11
// Things11 connected11 to parity11 changed.
// Clock11 devider11 changed.
//
// Revision11 1.10  2001/08/23 16:05:05  mohor11
// Stop bit bug11 fixed11.
// Parity11 bug11 fixed11.
// WISHBONE11 read cycle bug11 fixed11,
// OE11 indicator11 (Overrun11 Error) bug11 fixed11.
// PE11 indicator11 (Parity11 Error) bug11 fixed11.
// Register read bug11 fixed11.
//
// Revision11 1.4  2001/05/31 20:08:01  gorban11
// FIFO changes11 and other corrections11.
//
// Revision11 1.3  2001/05/21 19:12:02  gorban11
// Corrected11 some11 Linter11 messages11.
//
// Revision11 1.2  2001/05/17 18:34:18  gorban11
// First11 'stable' release. Should11 be sythesizable11 now. Also11 added new header.
//
// Revision11 1.0  2001-05-17 21:27:12+02  jacob11
// Initial11 revision11
//
//
// synopsys11 translate_off11
`include "timescale.v"
// synopsys11 translate_on11

`include "uart_defines11.v"

module uart_top11	(
	wb_clk_i11, 
	
	// Wishbone11 signals11
	wb_rst_i11, wb_adr_i11, wb_dat_i11, wb_dat_o11, wb_we_i11, wb_stb_i11, wb_cyc_i11, wb_ack_o11, wb_sel_i11,
	int_o11, // interrupt11 request

	// UART11	signals11
	// serial11 input/output
	stx_pad_o11, srx_pad_i11,

	// modem11 signals11
	rts_pad_o11, cts_pad_i11, dtr_pad_o11, dsr_pad_i11, ri_pad_i11, dcd_pad_i11
`ifdef UART_HAS_BAUDRATE_OUTPUT11
	, baud_o11
`endif
	);

parameter 							 uart_data_width11 = `UART_DATA_WIDTH11;
parameter 							 uart_addr_width11 = `UART_ADDR_WIDTH11;

input 								 wb_clk_i11;

// WISHBONE11 interface
input 								 wb_rst_i11;
input [uart_addr_width11-1:0] 	 wb_adr_i11;
input [uart_data_width11-1:0] 	 wb_dat_i11;
output [uart_data_width11-1:0] 	 wb_dat_o11;
input 								 wb_we_i11;
input 								 wb_stb_i11;
input 								 wb_cyc_i11;
input [3:0]							 wb_sel_i11;
output 								 wb_ack_o11;
output 								 int_o11;

// UART11	signals11
input 								 srx_pad_i11;
output 								 stx_pad_o11;
output 								 rts_pad_o11;
input 								 cts_pad_i11;
output 								 dtr_pad_o11;
input 								 dsr_pad_i11;
input 								 ri_pad_i11;
input 								 dcd_pad_i11;

// optional11 baudrate11 output
`ifdef UART_HAS_BAUDRATE_OUTPUT11
output	baud_o11;
`endif


wire 									 stx_pad_o11;
wire 									 rts_pad_o11;
wire 									 dtr_pad_o11;

wire [uart_addr_width11-1:0] 	 wb_adr_i11;
wire [uart_data_width11-1:0] 	 wb_dat_i11;
wire [uart_data_width11-1:0] 	 wb_dat_o11;

wire [7:0] 							 wb_dat8_i11; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o11; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o11; // debug11 interface 32-bit output
wire [3:0] 							 wb_sel_i11;  // WISHBONE11 select11 signal11
wire [uart_addr_width11-1:0] 	 wb_adr_int11;
wire 									 we_o11;	// Write enable for registers
wire		          	     re_o11;	// Read enable for registers
//
// MODULE11 INSTANCES11
//

`ifdef DATA_BUS_WIDTH_811
`else
// debug11 interface wires11
wire	[3:0] ier11;
wire	[3:0] iir11;
wire	[1:0] fcr11;
wire	[4:0] mcr11;
wire	[7:0] lcr11;
wire	[7:0] msr11;
wire	[7:0] lsr11;
wire	[`UART_FIFO_COUNTER_W11-1:0] rf_count11;
wire	[`UART_FIFO_COUNTER_W11-1:0] tf_count11;
wire	[2:0] tstate11;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_811
////  WISHBONE11 interface module
uart_wb11		wb_interface11(
		.clk11(		wb_clk_i11		),
		.wb_rst_i11(	wb_rst_i11	),
	.wb_dat_i11(wb_dat_i11),
	.wb_dat_o11(wb_dat_o11),
	.wb_dat8_i11(wb_dat8_i11),
	.wb_dat8_o11(wb_dat8_o11),
	 .wb_dat32_o11(32'b0),								 
	 .wb_sel_i11(4'b0),
		.wb_we_i11(	wb_we_i11		),
		.wb_stb_i11(	wb_stb_i11	),
		.wb_cyc_i11(	wb_cyc_i11	),
		.wb_ack_o11(	wb_ack_o11	),
	.wb_adr_i11(wb_adr_i11),
	.wb_adr_int11(wb_adr_int11),
		.we_o11(		we_o11		),
		.re_o11(re_o11)
		);
`else
uart_wb11		wb_interface11(
		.clk11(		wb_clk_i11		),
		.wb_rst_i11(	wb_rst_i11	),
	.wb_dat_i11(wb_dat_i11),
	.wb_dat_o11(wb_dat_o11),
	.wb_dat8_i11(wb_dat8_i11),
	.wb_dat8_o11(wb_dat8_o11),
	 .wb_sel_i11(wb_sel_i11),
	 .wb_dat32_o11(wb_dat32_o11),								 
		.wb_we_i11(	wb_we_i11		),
		.wb_stb_i11(	wb_stb_i11	),
		.wb_cyc_i11(	wb_cyc_i11	),
		.wb_ack_o11(	wb_ack_o11	),
	.wb_adr_i11(wb_adr_i11),
	.wb_adr_int11(wb_adr_int11),
		.we_o11(		we_o11		),
		.re_o11(re_o11)
		);
`endif

// Registers11
uart_regs11	regs(
	.clk11(		wb_clk_i11		),
	.wb_rst_i11(	wb_rst_i11	),
	.wb_addr_i11(	wb_adr_int11	),
	.wb_dat_i11(	wb_dat8_i11	),
	.wb_dat_o11(	wb_dat8_o11	),
	.wb_we_i11(	we_o11		),
   .wb_re_i11(re_o11),
	.modem_inputs11(	{cts_pad_i11, dsr_pad_i11,
	ri_pad_i11,  dcd_pad_i11}	),
	.stx_pad_o11(		stx_pad_o11		),
	.srx_pad_i11(		srx_pad_i11		),
`ifdef DATA_BUS_WIDTH_811
`else
// debug11 interface signals11	enabled
.ier11(ier11), 
.iir11(iir11), 
.fcr11(fcr11), 
.mcr11(mcr11), 
.lcr11(lcr11), 
.msr11(msr11), 
.lsr11(lsr11), 
.rf_count11(rf_count11),
.tf_count11(tf_count11),
.tstate11(tstate11),
.rstate(rstate),
`endif					  
	.rts_pad_o11(		rts_pad_o11		),
	.dtr_pad_o11(		dtr_pad_o11		),
	.int_o11(		int_o11		)
`ifdef UART_HAS_BAUDRATE_OUTPUT11
	, .baud_o11(baud_o11)
`endif

);

`ifdef DATA_BUS_WIDTH_811
`else
uart_debug_if11 dbg11(/*AUTOINST11*/
						// Outputs11
						.wb_dat32_o11				 (wb_dat32_o11[31:0]),
						// Inputs11
						.wb_adr_i11				 (wb_adr_int11[`UART_ADDR_WIDTH11-1:0]),
						.ier11						 (ier11[3:0]),
						.iir11						 (iir11[3:0]),
						.fcr11						 (fcr11[1:0]),
						.mcr11						 (mcr11[4:0]),
						.lcr11						 (lcr11[7:0]),
						.msr11						 (msr11[7:0]),
						.lsr11						 (lsr11[7:0]),
						.rf_count11				 (rf_count11[`UART_FIFO_COUNTER_W11-1:0]),
						.tf_count11				 (tf_count11[`UART_FIFO_COUNTER_W11-1:0]),
						.tstate11					 (tstate11[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_811
		$display("(%m) UART11 INFO11: Data bus width is 8. No Debug11 interface.\n");
	`else
		$display("(%m) UART11 INFO11: Data bus width is 32. Debug11 Interface11 present11.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT11
		$display("(%m) UART11 INFO11: Has11 baudrate11 output\n");
	`else
		$display("(%m) UART11 INFO11: Doesn11't have baudrate11 output\n");
	`endif
end

endmodule


