//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top5.v                                                  ////
////                                                              ////
////                                                              ////
////  This5 file is part of the "UART5 16550 compatible5" project5    ////
////  http5://www5.opencores5.org5/cores5/uart165505/                   ////
////                                                              ////
////  Documentation5 related5 to this project5:                      ////
////  - http5://www5.opencores5.org5/cores5/uart165505/                 ////
////                                                              ////
////  Projects5 compatibility5:                                     ////
////  - WISHBONE5                                                  ////
////  RS2325 Protocol5                                              ////
////  16550D uart5 (mostly5 supported)                              ////
////                                                              ////
////  Overview5 (main5 Features5):                                   ////
////  UART5 core5 top level.                                        ////
////                                                              ////
////  Known5 problems5 (limits5):                                    ////
////  Note5 that transmitter5 and receiver5 instances5 are inside     ////
////  the uart_regs5.v file.                                       ////
////                                                              ////
////  To5 Do5:                                                      ////
////  Nothing so far5.                                             ////
////                                                              ////
////  Author5(s):                                                  ////
////      - gorban5@opencores5.org5                                  ////
////      - Jacob5 Gorban5                                          ////
////      - Igor5 Mohor5 (igorm5@opencores5.org5)                      ////
////                                                              ////
////  Created5:        2001/05/12                                  ////
////  Last5 Updated5:   2001/05/17                                  ////
////                  (See log5 for the revision5 history5)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2000, 2001 Authors5                             ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS5 Revision5 History5
//
// $Log: not supported by cvs2svn5 $
// Revision5 1.18  2002/07/22 23:02:23  gorban5
// Bug5 Fixes5:
//  * Possible5 loss of sync and bad5 reception5 of stop bit on slow5 baud5 rates5 fixed5.
//   Problem5 reported5 by Kenny5.Tung5.
//  * Bad (or lack5 of ) loopback5 handling5 fixed5. Reported5 by Cherry5 Withers5.
//
// Improvements5:
//  * Made5 FIFO's as general5 inferrable5 memory where possible5.
//  So5 on FPGA5 they should be inferred5 as RAM5 (Distributed5 RAM5 on Xilinx5).
//  This5 saves5 about5 1/3 of the Slice5 count and reduces5 P&R and synthesis5 times.
//
//  * Added5 optional5 baudrate5 output (baud_o5).
//  This5 is identical5 to BAUDOUT5* signal5 on 16550 chip5.
//  It outputs5 16xbit_clock_rate - the divided5 clock5.
//  It's disabled by default. Define5 UART_HAS_BAUDRATE_OUTPUT5 to use.
//
// Revision5 1.17  2001/12/19 08:40:03  mohor5
// Warnings5 fixed5 (unused5 signals5 removed).
//
// Revision5 1.16  2001/12/06 14:51:04  gorban5
// Bug5 in LSR5[0] is fixed5.
// All WISHBONE5 signals5 are now sampled5, so another5 wait-state is introduced5 on all transfers5.
//
// Revision5 1.15  2001/12/03 21:44:29  gorban5
// Updated5 specification5 documentation.
// Added5 full 32-bit data bus interface, now as default.
// Address is 5-bit wide5 in 32-bit data bus mode.
// Added5 wb_sel_i5 input to the core5. It's used in the 32-bit mode.
// Added5 debug5 interface with two5 32-bit read-only registers in 32-bit mode.
// Bits5 5 and 6 of LSR5 are now only cleared5 on TX5 FIFO write.
// My5 small test bench5 is modified to work5 with 32-bit mode.
//
// Revision5 1.14  2001/11/07 17:51:52  gorban5
// Heavily5 rewritten5 interrupt5 and LSR5 subsystems5.
// Many5 bugs5 hopefully5 squashed5.
//
// Revision5 1.13  2001/10/20 09:58:40  gorban5
// Small5 synopsis5 fixes5
//
// Revision5 1.12  2001/08/25 15:46:19  gorban5
// Modified5 port names again5
//
// Revision5 1.11  2001/08/24 21:01:12  mohor5
// Things5 connected5 to parity5 changed.
// Clock5 devider5 changed.
//
// Revision5 1.10  2001/08/23 16:05:05  mohor5
// Stop bit bug5 fixed5.
// Parity5 bug5 fixed5.
// WISHBONE5 read cycle bug5 fixed5,
// OE5 indicator5 (Overrun5 Error) bug5 fixed5.
// PE5 indicator5 (Parity5 Error) bug5 fixed5.
// Register read bug5 fixed5.
//
// Revision5 1.4  2001/05/31 20:08:01  gorban5
// FIFO changes5 and other corrections5.
//
// Revision5 1.3  2001/05/21 19:12:02  gorban5
// Corrected5 some5 Linter5 messages5.
//
// Revision5 1.2  2001/05/17 18:34:18  gorban5
// First5 'stable' release. Should5 be sythesizable5 now. Also5 added new header.
//
// Revision5 1.0  2001-05-17 21:27:12+02  jacob5
// Initial5 revision5
//
//
// synopsys5 translate_off5
`include "timescale.v"
// synopsys5 translate_on5

`include "uart_defines5.v"

module uart_top5	(
	wb_clk_i5, 
	
	// Wishbone5 signals5
	wb_rst_i5, wb_adr_i5, wb_dat_i5, wb_dat_o5, wb_we_i5, wb_stb_i5, wb_cyc_i5, wb_ack_o5, wb_sel_i5,
	int_o5, // interrupt5 request

	// UART5	signals5
	// serial5 input/output
	stx_pad_o5, srx_pad_i5,

	// modem5 signals5
	rts_pad_o5, cts_pad_i5, dtr_pad_o5, dsr_pad_i5, ri_pad_i5, dcd_pad_i5
`ifdef UART_HAS_BAUDRATE_OUTPUT5
	, baud_o5
`endif
	);

parameter 							 uart_data_width5 = `UART_DATA_WIDTH5;
parameter 							 uart_addr_width5 = `UART_ADDR_WIDTH5;

input 								 wb_clk_i5;

// WISHBONE5 interface
input 								 wb_rst_i5;
input [uart_addr_width5-1:0] 	 wb_adr_i5;
input [uart_data_width5-1:0] 	 wb_dat_i5;
output [uart_data_width5-1:0] 	 wb_dat_o5;
input 								 wb_we_i5;
input 								 wb_stb_i5;
input 								 wb_cyc_i5;
input [3:0]							 wb_sel_i5;
output 								 wb_ack_o5;
output 								 int_o5;

// UART5	signals5
input 								 srx_pad_i5;
output 								 stx_pad_o5;
output 								 rts_pad_o5;
input 								 cts_pad_i5;
output 								 dtr_pad_o5;
input 								 dsr_pad_i5;
input 								 ri_pad_i5;
input 								 dcd_pad_i5;

// optional5 baudrate5 output
`ifdef UART_HAS_BAUDRATE_OUTPUT5
output	baud_o5;
`endif


wire 									 stx_pad_o5;
wire 									 rts_pad_o5;
wire 									 dtr_pad_o5;

wire [uart_addr_width5-1:0] 	 wb_adr_i5;
wire [uart_data_width5-1:0] 	 wb_dat_i5;
wire [uart_data_width5-1:0] 	 wb_dat_o5;

wire [7:0] 							 wb_dat8_i5; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o5; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o5; // debug5 interface 32-bit output
wire [3:0] 							 wb_sel_i5;  // WISHBONE5 select5 signal5
wire [uart_addr_width5-1:0] 	 wb_adr_int5;
wire 									 we_o5;	// Write enable for registers
wire		          	     re_o5;	// Read enable for registers
//
// MODULE5 INSTANCES5
//

`ifdef DATA_BUS_WIDTH_85
`else
// debug5 interface wires5
wire	[3:0] ier5;
wire	[3:0] iir5;
wire	[1:0] fcr5;
wire	[4:0] mcr5;
wire	[7:0] lcr5;
wire	[7:0] msr5;
wire	[7:0] lsr5;
wire	[`UART_FIFO_COUNTER_W5-1:0] rf_count5;
wire	[`UART_FIFO_COUNTER_W5-1:0] tf_count5;
wire	[2:0] tstate5;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_85
////  WISHBONE5 interface module
uart_wb5		wb_interface5(
		.clk5(		wb_clk_i5		),
		.wb_rst_i5(	wb_rst_i5	),
	.wb_dat_i5(wb_dat_i5),
	.wb_dat_o5(wb_dat_o5),
	.wb_dat8_i5(wb_dat8_i5),
	.wb_dat8_o5(wb_dat8_o5),
	 .wb_dat32_o5(32'b0),								 
	 .wb_sel_i5(4'b0),
		.wb_we_i5(	wb_we_i5		),
		.wb_stb_i5(	wb_stb_i5	),
		.wb_cyc_i5(	wb_cyc_i5	),
		.wb_ack_o5(	wb_ack_o5	),
	.wb_adr_i5(wb_adr_i5),
	.wb_adr_int5(wb_adr_int5),
		.we_o5(		we_o5		),
		.re_o5(re_o5)
		);
`else
uart_wb5		wb_interface5(
		.clk5(		wb_clk_i5		),
		.wb_rst_i5(	wb_rst_i5	),
	.wb_dat_i5(wb_dat_i5),
	.wb_dat_o5(wb_dat_o5),
	.wb_dat8_i5(wb_dat8_i5),
	.wb_dat8_o5(wb_dat8_o5),
	 .wb_sel_i5(wb_sel_i5),
	 .wb_dat32_o5(wb_dat32_o5),								 
		.wb_we_i5(	wb_we_i5		),
		.wb_stb_i5(	wb_stb_i5	),
		.wb_cyc_i5(	wb_cyc_i5	),
		.wb_ack_o5(	wb_ack_o5	),
	.wb_adr_i5(wb_adr_i5),
	.wb_adr_int5(wb_adr_int5),
		.we_o5(		we_o5		),
		.re_o5(re_o5)
		);
`endif

// Registers5
uart_regs5	regs(
	.clk5(		wb_clk_i5		),
	.wb_rst_i5(	wb_rst_i5	),
	.wb_addr_i5(	wb_adr_int5	),
	.wb_dat_i5(	wb_dat8_i5	),
	.wb_dat_o5(	wb_dat8_o5	),
	.wb_we_i5(	we_o5		),
   .wb_re_i5(re_o5),
	.modem_inputs5(	{cts_pad_i5, dsr_pad_i5,
	ri_pad_i5,  dcd_pad_i5}	),
	.stx_pad_o5(		stx_pad_o5		),
	.srx_pad_i5(		srx_pad_i5		),
`ifdef DATA_BUS_WIDTH_85
`else
// debug5 interface signals5	enabled
.ier5(ier5), 
.iir5(iir5), 
.fcr5(fcr5), 
.mcr5(mcr5), 
.lcr5(lcr5), 
.msr5(msr5), 
.lsr5(lsr5), 
.rf_count5(rf_count5),
.tf_count5(tf_count5),
.tstate5(tstate5),
.rstate(rstate),
`endif					  
	.rts_pad_o5(		rts_pad_o5		),
	.dtr_pad_o5(		dtr_pad_o5		),
	.int_o5(		int_o5		)
`ifdef UART_HAS_BAUDRATE_OUTPUT5
	, .baud_o5(baud_o5)
`endif

);

`ifdef DATA_BUS_WIDTH_85
`else
uart_debug_if5 dbg5(/*AUTOINST5*/
						// Outputs5
						.wb_dat32_o5				 (wb_dat32_o5[31:0]),
						// Inputs5
						.wb_adr_i5				 (wb_adr_int5[`UART_ADDR_WIDTH5-1:0]),
						.ier5						 (ier5[3:0]),
						.iir5						 (iir5[3:0]),
						.fcr5						 (fcr5[1:0]),
						.mcr5						 (mcr5[4:0]),
						.lcr5						 (lcr5[7:0]),
						.msr5						 (msr5[7:0]),
						.lsr5						 (lsr5[7:0]),
						.rf_count5				 (rf_count5[`UART_FIFO_COUNTER_W5-1:0]),
						.tf_count5				 (tf_count5[`UART_FIFO_COUNTER_W5-1:0]),
						.tstate5					 (tstate5[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_85
		$display("(%m) UART5 INFO5: Data bus width is 8. No Debug5 interface.\n");
	`else
		$display("(%m) UART5 INFO5: Data bus width is 32. Debug5 Interface5 present5.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT5
		$display("(%m) UART5 INFO5: Has5 baudrate5 output\n");
	`else
		$display("(%m) UART5 INFO5: Doesn5't have baudrate5 output\n");
	`endif
end

endmodule


