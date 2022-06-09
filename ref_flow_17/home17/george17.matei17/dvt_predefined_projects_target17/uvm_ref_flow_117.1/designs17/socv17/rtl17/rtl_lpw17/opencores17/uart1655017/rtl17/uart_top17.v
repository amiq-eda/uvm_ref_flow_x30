//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top17.v                                                  ////
////                                                              ////
////                                                              ////
////  This17 file is part of the "UART17 16550 compatible17" project17    ////
////  http17://www17.opencores17.org17/cores17/uart1655017/                   ////
////                                                              ////
////  Documentation17 related17 to this project17:                      ////
////  - http17://www17.opencores17.org17/cores17/uart1655017/                 ////
////                                                              ////
////  Projects17 compatibility17:                                     ////
////  - WISHBONE17                                                  ////
////  RS23217 Protocol17                                              ////
////  16550D uart17 (mostly17 supported)                              ////
////                                                              ////
////  Overview17 (main17 Features17):                                   ////
////  UART17 core17 top level.                                        ////
////                                                              ////
////  Known17 problems17 (limits17):                                    ////
////  Note17 that transmitter17 and receiver17 instances17 are inside     ////
////  the uart_regs17.v file.                                       ////
////                                                              ////
////  To17 Do17:                                                      ////
////  Nothing so far17.                                             ////
////                                                              ////
////  Author17(s):                                                  ////
////      - gorban17@opencores17.org17                                  ////
////      - Jacob17 Gorban17                                          ////
////      - Igor17 Mohor17 (igorm17@opencores17.org17)                      ////
////                                                              ////
////  Created17:        2001/05/12                                  ////
////  Last17 Updated17:   2001/05/17                                  ////
////                  (See log17 for the revision17 history17)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2000, 2001 Authors17                             ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS17 Revision17 History17
//
// $Log: not supported by cvs2svn17 $
// Revision17 1.18  2002/07/22 23:02:23  gorban17
// Bug17 Fixes17:
//  * Possible17 loss of sync and bad17 reception17 of stop bit on slow17 baud17 rates17 fixed17.
//   Problem17 reported17 by Kenny17.Tung17.
//  * Bad (or lack17 of ) loopback17 handling17 fixed17. Reported17 by Cherry17 Withers17.
//
// Improvements17:
//  * Made17 FIFO's as general17 inferrable17 memory where possible17.
//  So17 on FPGA17 they should be inferred17 as RAM17 (Distributed17 RAM17 on Xilinx17).
//  This17 saves17 about17 1/3 of the Slice17 count and reduces17 P&R and synthesis17 times.
//
//  * Added17 optional17 baudrate17 output (baud_o17).
//  This17 is identical17 to BAUDOUT17* signal17 on 16550 chip17.
//  It outputs17 16xbit_clock_rate - the divided17 clock17.
//  It's disabled by default. Define17 UART_HAS_BAUDRATE_OUTPUT17 to use.
//
// Revision17 1.17  2001/12/19 08:40:03  mohor17
// Warnings17 fixed17 (unused17 signals17 removed).
//
// Revision17 1.16  2001/12/06 14:51:04  gorban17
// Bug17 in LSR17[0] is fixed17.
// All WISHBONE17 signals17 are now sampled17, so another17 wait-state is introduced17 on all transfers17.
//
// Revision17 1.15  2001/12/03 21:44:29  gorban17
// Updated17 specification17 documentation.
// Added17 full 32-bit data bus interface, now as default.
// Address is 5-bit wide17 in 32-bit data bus mode.
// Added17 wb_sel_i17 input to the core17. It's used in the 32-bit mode.
// Added17 debug17 interface with two17 32-bit read-only registers in 32-bit mode.
// Bits17 5 and 6 of LSR17 are now only cleared17 on TX17 FIFO write.
// My17 small test bench17 is modified to work17 with 32-bit mode.
//
// Revision17 1.14  2001/11/07 17:51:52  gorban17
// Heavily17 rewritten17 interrupt17 and LSR17 subsystems17.
// Many17 bugs17 hopefully17 squashed17.
//
// Revision17 1.13  2001/10/20 09:58:40  gorban17
// Small17 synopsis17 fixes17
//
// Revision17 1.12  2001/08/25 15:46:19  gorban17
// Modified17 port names again17
//
// Revision17 1.11  2001/08/24 21:01:12  mohor17
// Things17 connected17 to parity17 changed.
// Clock17 devider17 changed.
//
// Revision17 1.10  2001/08/23 16:05:05  mohor17
// Stop bit bug17 fixed17.
// Parity17 bug17 fixed17.
// WISHBONE17 read cycle bug17 fixed17,
// OE17 indicator17 (Overrun17 Error) bug17 fixed17.
// PE17 indicator17 (Parity17 Error) bug17 fixed17.
// Register read bug17 fixed17.
//
// Revision17 1.4  2001/05/31 20:08:01  gorban17
// FIFO changes17 and other corrections17.
//
// Revision17 1.3  2001/05/21 19:12:02  gorban17
// Corrected17 some17 Linter17 messages17.
//
// Revision17 1.2  2001/05/17 18:34:18  gorban17
// First17 'stable' release. Should17 be sythesizable17 now. Also17 added new header.
//
// Revision17 1.0  2001-05-17 21:27:12+02  jacob17
// Initial17 revision17
//
//
// synopsys17 translate_off17
`include "timescale.v"
// synopsys17 translate_on17

`include "uart_defines17.v"

module uart_top17	(
	wb_clk_i17, 
	
	// Wishbone17 signals17
	wb_rst_i17, wb_adr_i17, wb_dat_i17, wb_dat_o17, wb_we_i17, wb_stb_i17, wb_cyc_i17, wb_ack_o17, wb_sel_i17,
	int_o17, // interrupt17 request

	// UART17	signals17
	// serial17 input/output
	stx_pad_o17, srx_pad_i17,

	// modem17 signals17
	rts_pad_o17, cts_pad_i17, dtr_pad_o17, dsr_pad_i17, ri_pad_i17, dcd_pad_i17
`ifdef UART_HAS_BAUDRATE_OUTPUT17
	, baud_o17
`endif
	);

parameter 							 uart_data_width17 = `UART_DATA_WIDTH17;
parameter 							 uart_addr_width17 = `UART_ADDR_WIDTH17;

input 								 wb_clk_i17;

// WISHBONE17 interface
input 								 wb_rst_i17;
input [uart_addr_width17-1:0] 	 wb_adr_i17;
input [uart_data_width17-1:0] 	 wb_dat_i17;
output [uart_data_width17-1:0] 	 wb_dat_o17;
input 								 wb_we_i17;
input 								 wb_stb_i17;
input 								 wb_cyc_i17;
input [3:0]							 wb_sel_i17;
output 								 wb_ack_o17;
output 								 int_o17;

// UART17	signals17
input 								 srx_pad_i17;
output 								 stx_pad_o17;
output 								 rts_pad_o17;
input 								 cts_pad_i17;
output 								 dtr_pad_o17;
input 								 dsr_pad_i17;
input 								 ri_pad_i17;
input 								 dcd_pad_i17;

// optional17 baudrate17 output
`ifdef UART_HAS_BAUDRATE_OUTPUT17
output	baud_o17;
`endif


wire 									 stx_pad_o17;
wire 									 rts_pad_o17;
wire 									 dtr_pad_o17;

wire [uart_addr_width17-1:0] 	 wb_adr_i17;
wire [uart_data_width17-1:0] 	 wb_dat_i17;
wire [uart_data_width17-1:0] 	 wb_dat_o17;

wire [7:0] 							 wb_dat8_i17; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o17; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o17; // debug17 interface 32-bit output
wire [3:0] 							 wb_sel_i17;  // WISHBONE17 select17 signal17
wire [uart_addr_width17-1:0] 	 wb_adr_int17;
wire 									 we_o17;	// Write enable for registers
wire		          	     re_o17;	// Read enable for registers
//
// MODULE17 INSTANCES17
//

`ifdef DATA_BUS_WIDTH_817
`else
// debug17 interface wires17
wire	[3:0] ier17;
wire	[3:0] iir17;
wire	[1:0] fcr17;
wire	[4:0] mcr17;
wire	[7:0] lcr17;
wire	[7:0] msr17;
wire	[7:0] lsr17;
wire	[`UART_FIFO_COUNTER_W17-1:0] rf_count17;
wire	[`UART_FIFO_COUNTER_W17-1:0] tf_count17;
wire	[2:0] tstate17;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_817
////  WISHBONE17 interface module
uart_wb17		wb_interface17(
		.clk17(		wb_clk_i17		),
		.wb_rst_i17(	wb_rst_i17	),
	.wb_dat_i17(wb_dat_i17),
	.wb_dat_o17(wb_dat_o17),
	.wb_dat8_i17(wb_dat8_i17),
	.wb_dat8_o17(wb_dat8_o17),
	 .wb_dat32_o17(32'b0),								 
	 .wb_sel_i17(4'b0),
		.wb_we_i17(	wb_we_i17		),
		.wb_stb_i17(	wb_stb_i17	),
		.wb_cyc_i17(	wb_cyc_i17	),
		.wb_ack_o17(	wb_ack_o17	),
	.wb_adr_i17(wb_adr_i17),
	.wb_adr_int17(wb_adr_int17),
		.we_o17(		we_o17		),
		.re_o17(re_o17)
		);
`else
uart_wb17		wb_interface17(
		.clk17(		wb_clk_i17		),
		.wb_rst_i17(	wb_rst_i17	),
	.wb_dat_i17(wb_dat_i17),
	.wb_dat_o17(wb_dat_o17),
	.wb_dat8_i17(wb_dat8_i17),
	.wb_dat8_o17(wb_dat8_o17),
	 .wb_sel_i17(wb_sel_i17),
	 .wb_dat32_o17(wb_dat32_o17),								 
		.wb_we_i17(	wb_we_i17		),
		.wb_stb_i17(	wb_stb_i17	),
		.wb_cyc_i17(	wb_cyc_i17	),
		.wb_ack_o17(	wb_ack_o17	),
	.wb_adr_i17(wb_adr_i17),
	.wb_adr_int17(wb_adr_int17),
		.we_o17(		we_o17		),
		.re_o17(re_o17)
		);
`endif

// Registers17
uart_regs17	regs(
	.clk17(		wb_clk_i17		),
	.wb_rst_i17(	wb_rst_i17	),
	.wb_addr_i17(	wb_adr_int17	),
	.wb_dat_i17(	wb_dat8_i17	),
	.wb_dat_o17(	wb_dat8_o17	),
	.wb_we_i17(	we_o17		),
   .wb_re_i17(re_o17),
	.modem_inputs17(	{cts_pad_i17, dsr_pad_i17,
	ri_pad_i17,  dcd_pad_i17}	),
	.stx_pad_o17(		stx_pad_o17		),
	.srx_pad_i17(		srx_pad_i17		),
`ifdef DATA_BUS_WIDTH_817
`else
// debug17 interface signals17	enabled
.ier17(ier17), 
.iir17(iir17), 
.fcr17(fcr17), 
.mcr17(mcr17), 
.lcr17(lcr17), 
.msr17(msr17), 
.lsr17(lsr17), 
.rf_count17(rf_count17),
.tf_count17(tf_count17),
.tstate17(tstate17),
.rstate(rstate),
`endif					  
	.rts_pad_o17(		rts_pad_o17		),
	.dtr_pad_o17(		dtr_pad_o17		),
	.int_o17(		int_o17		)
`ifdef UART_HAS_BAUDRATE_OUTPUT17
	, .baud_o17(baud_o17)
`endif

);

`ifdef DATA_BUS_WIDTH_817
`else
uart_debug_if17 dbg17(/*AUTOINST17*/
						// Outputs17
						.wb_dat32_o17				 (wb_dat32_o17[31:0]),
						// Inputs17
						.wb_adr_i17				 (wb_adr_int17[`UART_ADDR_WIDTH17-1:0]),
						.ier17						 (ier17[3:0]),
						.iir17						 (iir17[3:0]),
						.fcr17						 (fcr17[1:0]),
						.mcr17						 (mcr17[4:0]),
						.lcr17						 (lcr17[7:0]),
						.msr17						 (msr17[7:0]),
						.lsr17						 (lsr17[7:0]),
						.rf_count17				 (rf_count17[`UART_FIFO_COUNTER_W17-1:0]),
						.tf_count17				 (tf_count17[`UART_FIFO_COUNTER_W17-1:0]),
						.tstate17					 (tstate17[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_817
		$display("(%m) UART17 INFO17: Data bus width is 8. No Debug17 interface.\n");
	`else
		$display("(%m) UART17 INFO17: Data bus width is 32. Debug17 Interface17 present17.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT17
		$display("(%m) UART17 INFO17: Has17 baudrate17 output\n");
	`else
		$display("(%m) UART17 INFO17: Doesn17't have baudrate17 output\n");
	`endif
end

endmodule


