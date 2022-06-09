//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top2.v                                                  ////
////                                                              ////
////                                                              ////
////  This2 file is part of the "UART2 16550 compatible2" project2    ////
////  http2://www2.opencores2.org2/cores2/uart165502/                   ////
////                                                              ////
////  Documentation2 related2 to this project2:                      ////
////  - http2://www2.opencores2.org2/cores2/uart165502/                 ////
////                                                              ////
////  Projects2 compatibility2:                                     ////
////  - WISHBONE2                                                  ////
////  RS2322 Protocol2                                              ////
////  16550D uart2 (mostly2 supported)                              ////
////                                                              ////
////  Overview2 (main2 Features2):                                   ////
////  UART2 core2 top level.                                        ////
////                                                              ////
////  Known2 problems2 (limits2):                                    ////
////  Note2 that transmitter2 and receiver2 instances2 are inside     ////
////  the uart_regs2.v file.                                       ////
////                                                              ////
////  To2 Do2:                                                      ////
////  Nothing so far2.                                             ////
////                                                              ////
////  Author2(s):                                                  ////
////      - gorban2@opencores2.org2                                  ////
////      - Jacob2 Gorban2                                          ////
////      - Igor2 Mohor2 (igorm2@opencores2.org2)                      ////
////                                                              ////
////  Created2:        2001/05/12                                  ////
////  Last2 Updated2:   2001/05/17                                  ////
////                  (See log2 for the revision2 history2)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2000, 2001 Authors2                             ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS2 Revision2 History2
//
// $Log: not supported by cvs2svn2 $
// Revision2 1.18  2002/07/22 23:02:23  gorban2
// Bug2 Fixes2:
//  * Possible2 loss of sync and bad2 reception2 of stop bit on slow2 baud2 rates2 fixed2.
//   Problem2 reported2 by Kenny2.Tung2.
//  * Bad (or lack2 of ) loopback2 handling2 fixed2. Reported2 by Cherry2 Withers2.
//
// Improvements2:
//  * Made2 FIFO's as general2 inferrable2 memory where possible2.
//  So2 on FPGA2 they should be inferred2 as RAM2 (Distributed2 RAM2 on Xilinx2).
//  This2 saves2 about2 1/3 of the Slice2 count and reduces2 P&R and synthesis2 times.
//
//  * Added2 optional2 baudrate2 output (baud_o2).
//  This2 is identical2 to BAUDOUT2* signal2 on 16550 chip2.
//  It outputs2 16xbit_clock_rate - the divided2 clock2.
//  It's disabled by default. Define2 UART_HAS_BAUDRATE_OUTPUT2 to use.
//
// Revision2 1.17  2001/12/19 08:40:03  mohor2
// Warnings2 fixed2 (unused2 signals2 removed).
//
// Revision2 1.16  2001/12/06 14:51:04  gorban2
// Bug2 in LSR2[0] is fixed2.
// All WISHBONE2 signals2 are now sampled2, so another2 wait-state is introduced2 on all transfers2.
//
// Revision2 1.15  2001/12/03 21:44:29  gorban2
// Updated2 specification2 documentation.
// Added2 full 32-bit data bus interface, now as default.
// Address is 5-bit wide2 in 32-bit data bus mode.
// Added2 wb_sel_i2 input to the core2. It's used in the 32-bit mode.
// Added2 debug2 interface with two2 32-bit read-only registers in 32-bit mode.
// Bits2 5 and 6 of LSR2 are now only cleared2 on TX2 FIFO write.
// My2 small test bench2 is modified to work2 with 32-bit mode.
//
// Revision2 1.14  2001/11/07 17:51:52  gorban2
// Heavily2 rewritten2 interrupt2 and LSR2 subsystems2.
// Many2 bugs2 hopefully2 squashed2.
//
// Revision2 1.13  2001/10/20 09:58:40  gorban2
// Small2 synopsis2 fixes2
//
// Revision2 1.12  2001/08/25 15:46:19  gorban2
// Modified2 port names again2
//
// Revision2 1.11  2001/08/24 21:01:12  mohor2
// Things2 connected2 to parity2 changed.
// Clock2 devider2 changed.
//
// Revision2 1.10  2001/08/23 16:05:05  mohor2
// Stop bit bug2 fixed2.
// Parity2 bug2 fixed2.
// WISHBONE2 read cycle bug2 fixed2,
// OE2 indicator2 (Overrun2 Error) bug2 fixed2.
// PE2 indicator2 (Parity2 Error) bug2 fixed2.
// Register read bug2 fixed2.
//
// Revision2 1.4  2001/05/31 20:08:01  gorban2
// FIFO changes2 and other corrections2.
//
// Revision2 1.3  2001/05/21 19:12:02  gorban2
// Corrected2 some2 Linter2 messages2.
//
// Revision2 1.2  2001/05/17 18:34:18  gorban2
// First2 'stable' release. Should2 be sythesizable2 now. Also2 added new header.
//
// Revision2 1.0  2001-05-17 21:27:12+02  jacob2
// Initial2 revision2
//
//
// synopsys2 translate_off2
`include "timescale.v"
// synopsys2 translate_on2

`include "uart_defines2.v"

module uart_top2	(
	wb_clk_i2, 
	
	// Wishbone2 signals2
	wb_rst_i2, wb_adr_i2, wb_dat_i2, wb_dat_o2, wb_we_i2, wb_stb_i2, wb_cyc_i2, wb_ack_o2, wb_sel_i2,
	int_o2, // interrupt2 request

	// UART2	signals2
	// serial2 input/output
	stx_pad_o2, srx_pad_i2,

	// modem2 signals2
	rts_pad_o2, cts_pad_i2, dtr_pad_o2, dsr_pad_i2, ri_pad_i2, dcd_pad_i2
`ifdef UART_HAS_BAUDRATE_OUTPUT2
	, baud_o2
`endif
	);

parameter 							 uart_data_width2 = `UART_DATA_WIDTH2;
parameter 							 uart_addr_width2 = `UART_ADDR_WIDTH2;

input 								 wb_clk_i2;

// WISHBONE2 interface
input 								 wb_rst_i2;
input [uart_addr_width2-1:0] 	 wb_adr_i2;
input [uart_data_width2-1:0] 	 wb_dat_i2;
output [uart_data_width2-1:0] 	 wb_dat_o2;
input 								 wb_we_i2;
input 								 wb_stb_i2;
input 								 wb_cyc_i2;
input [3:0]							 wb_sel_i2;
output 								 wb_ack_o2;
output 								 int_o2;

// UART2	signals2
input 								 srx_pad_i2;
output 								 stx_pad_o2;
output 								 rts_pad_o2;
input 								 cts_pad_i2;
output 								 dtr_pad_o2;
input 								 dsr_pad_i2;
input 								 ri_pad_i2;
input 								 dcd_pad_i2;

// optional2 baudrate2 output
`ifdef UART_HAS_BAUDRATE_OUTPUT2
output	baud_o2;
`endif


wire 									 stx_pad_o2;
wire 									 rts_pad_o2;
wire 									 dtr_pad_o2;

wire [uart_addr_width2-1:0] 	 wb_adr_i2;
wire [uart_data_width2-1:0] 	 wb_dat_i2;
wire [uart_data_width2-1:0] 	 wb_dat_o2;

wire [7:0] 							 wb_dat8_i2; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o2; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o2; // debug2 interface 32-bit output
wire [3:0] 							 wb_sel_i2;  // WISHBONE2 select2 signal2
wire [uart_addr_width2-1:0] 	 wb_adr_int2;
wire 									 we_o2;	// Write enable for registers
wire		          	     re_o2;	// Read enable for registers
//
// MODULE2 INSTANCES2
//

`ifdef DATA_BUS_WIDTH_82
`else
// debug2 interface wires2
wire	[3:0] ier2;
wire	[3:0] iir2;
wire	[1:0] fcr2;
wire	[4:0] mcr2;
wire	[7:0] lcr2;
wire	[7:0] msr2;
wire	[7:0] lsr2;
wire	[`UART_FIFO_COUNTER_W2-1:0] rf_count2;
wire	[`UART_FIFO_COUNTER_W2-1:0] tf_count2;
wire	[2:0] tstate2;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_82
////  WISHBONE2 interface module
uart_wb2		wb_interface2(
		.clk2(		wb_clk_i2		),
		.wb_rst_i2(	wb_rst_i2	),
	.wb_dat_i2(wb_dat_i2),
	.wb_dat_o2(wb_dat_o2),
	.wb_dat8_i2(wb_dat8_i2),
	.wb_dat8_o2(wb_dat8_o2),
	 .wb_dat32_o2(32'b0),								 
	 .wb_sel_i2(4'b0),
		.wb_we_i2(	wb_we_i2		),
		.wb_stb_i2(	wb_stb_i2	),
		.wb_cyc_i2(	wb_cyc_i2	),
		.wb_ack_o2(	wb_ack_o2	),
	.wb_adr_i2(wb_adr_i2),
	.wb_adr_int2(wb_adr_int2),
		.we_o2(		we_o2		),
		.re_o2(re_o2)
		);
`else
uart_wb2		wb_interface2(
		.clk2(		wb_clk_i2		),
		.wb_rst_i2(	wb_rst_i2	),
	.wb_dat_i2(wb_dat_i2),
	.wb_dat_o2(wb_dat_o2),
	.wb_dat8_i2(wb_dat8_i2),
	.wb_dat8_o2(wb_dat8_o2),
	 .wb_sel_i2(wb_sel_i2),
	 .wb_dat32_o2(wb_dat32_o2),								 
		.wb_we_i2(	wb_we_i2		),
		.wb_stb_i2(	wb_stb_i2	),
		.wb_cyc_i2(	wb_cyc_i2	),
		.wb_ack_o2(	wb_ack_o2	),
	.wb_adr_i2(wb_adr_i2),
	.wb_adr_int2(wb_adr_int2),
		.we_o2(		we_o2		),
		.re_o2(re_o2)
		);
`endif

// Registers2
uart_regs2	regs(
	.clk2(		wb_clk_i2		),
	.wb_rst_i2(	wb_rst_i2	),
	.wb_addr_i2(	wb_adr_int2	),
	.wb_dat_i2(	wb_dat8_i2	),
	.wb_dat_o2(	wb_dat8_o2	),
	.wb_we_i2(	we_o2		),
   .wb_re_i2(re_o2),
	.modem_inputs2(	{cts_pad_i2, dsr_pad_i2,
	ri_pad_i2,  dcd_pad_i2}	),
	.stx_pad_o2(		stx_pad_o2		),
	.srx_pad_i2(		srx_pad_i2		),
`ifdef DATA_BUS_WIDTH_82
`else
// debug2 interface signals2	enabled
.ier2(ier2), 
.iir2(iir2), 
.fcr2(fcr2), 
.mcr2(mcr2), 
.lcr2(lcr2), 
.msr2(msr2), 
.lsr2(lsr2), 
.rf_count2(rf_count2),
.tf_count2(tf_count2),
.tstate2(tstate2),
.rstate(rstate),
`endif					  
	.rts_pad_o2(		rts_pad_o2		),
	.dtr_pad_o2(		dtr_pad_o2		),
	.int_o2(		int_o2		)
`ifdef UART_HAS_BAUDRATE_OUTPUT2
	, .baud_o2(baud_o2)
`endif

);

`ifdef DATA_BUS_WIDTH_82
`else
uart_debug_if2 dbg2(/*AUTOINST2*/
						// Outputs2
						.wb_dat32_o2				 (wb_dat32_o2[31:0]),
						// Inputs2
						.wb_adr_i2				 (wb_adr_int2[`UART_ADDR_WIDTH2-1:0]),
						.ier2						 (ier2[3:0]),
						.iir2						 (iir2[3:0]),
						.fcr2						 (fcr2[1:0]),
						.mcr2						 (mcr2[4:0]),
						.lcr2						 (lcr2[7:0]),
						.msr2						 (msr2[7:0]),
						.lsr2						 (lsr2[7:0]),
						.rf_count2				 (rf_count2[`UART_FIFO_COUNTER_W2-1:0]),
						.tf_count2				 (tf_count2[`UART_FIFO_COUNTER_W2-1:0]),
						.tstate2					 (tstate2[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_82
		$display("(%m) UART2 INFO2: Data bus width is 8. No Debug2 interface.\n");
	`else
		$display("(%m) UART2 INFO2: Data bus width is 32. Debug2 Interface2 present2.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT2
		$display("(%m) UART2 INFO2: Has2 baudrate2 output\n");
	`else
		$display("(%m) UART2 INFO2: Doesn2't have baudrate2 output\n");
	`endif
end

endmodule


