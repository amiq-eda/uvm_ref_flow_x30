//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top23.v                                                  ////
////                                                              ////
////                                                              ////
////  This23 file is part of the "UART23 16550 compatible23" project23    ////
////  http23://www23.opencores23.org23/cores23/uart1655023/                   ////
////                                                              ////
////  Documentation23 related23 to this project23:                      ////
////  - http23://www23.opencores23.org23/cores23/uart1655023/                 ////
////                                                              ////
////  Projects23 compatibility23:                                     ////
////  - WISHBONE23                                                  ////
////  RS23223 Protocol23                                              ////
////  16550D uart23 (mostly23 supported)                              ////
////                                                              ////
////  Overview23 (main23 Features23):                                   ////
////  UART23 core23 top level.                                        ////
////                                                              ////
////  Known23 problems23 (limits23):                                    ////
////  Note23 that transmitter23 and receiver23 instances23 are inside     ////
////  the uart_regs23.v file.                                       ////
////                                                              ////
////  To23 Do23:                                                      ////
////  Nothing so far23.                                             ////
////                                                              ////
////  Author23(s):                                                  ////
////      - gorban23@opencores23.org23                                  ////
////      - Jacob23 Gorban23                                          ////
////      - Igor23 Mohor23 (igorm23@opencores23.org23)                      ////
////                                                              ////
////  Created23:        2001/05/12                                  ////
////  Last23 Updated23:   2001/05/17                                  ////
////                  (See log23 for the revision23 history23)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2000, 2001 Authors23                             ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS23 Revision23 History23
//
// $Log: not supported by cvs2svn23 $
// Revision23 1.18  2002/07/22 23:02:23  gorban23
// Bug23 Fixes23:
//  * Possible23 loss of sync and bad23 reception23 of stop bit on slow23 baud23 rates23 fixed23.
//   Problem23 reported23 by Kenny23.Tung23.
//  * Bad (or lack23 of ) loopback23 handling23 fixed23. Reported23 by Cherry23 Withers23.
//
// Improvements23:
//  * Made23 FIFO's as general23 inferrable23 memory where possible23.
//  So23 on FPGA23 they should be inferred23 as RAM23 (Distributed23 RAM23 on Xilinx23).
//  This23 saves23 about23 1/3 of the Slice23 count and reduces23 P&R and synthesis23 times.
//
//  * Added23 optional23 baudrate23 output (baud_o23).
//  This23 is identical23 to BAUDOUT23* signal23 on 16550 chip23.
//  It outputs23 16xbit_clock_rate - the divided23 clock23.
//  It's disabled by default. Define23 UART_HAS_BAUDRATE_OUTPUT23 to use.
//
// Revision23 1.17  2001/12/19 08:40:03  mohor23
// Warnings23 fixed23 (unused23 signals23 removed).
//
// Revision23 1.16  2001/12/06 14:51:04  gorban23
// Bug23 in LSR23[0] is fixed23.
// All WISHBONE23 signals23 are now sampled23, so another23 wait-state is introduced23 on all transfers23.
//
// Revision23 1.15  2001/12/03 21:44:29  gorban23
// Updated23 specification23 documentation.
// Added23 full 32-bit data bus interface, now as default.
// Address is 5-bit wide23 in 32-bit data bus mode.
// Added23 wb_sel_i23 input to the core23. It's used in the 32-bit mode.
// Added23 debug23 interface with two23 32-bit read-only registers in 32-bit mode.
// Bits23 5 and 6 of LSR23 are now only cleared23 on TX23 FIFO write.
// My23 small test bench23 is modified to work23 with 32-bit mode.
//
// Revision23 1.14  2001/11/07 17:51:52  gorban23
// Heavily23 rewritten23 interrupt23 and LSR23 subsystems23.
// Many23 bugs23 hopefully23 squashed23.
//
// Revision23 1.13  2001/10/20 09:58:40  gorban23
// Small23 synopsis23 fixes23
//
// Revision23 1.12  2001/08/25 15:46:19  gorban23
// Modified23 port names again23
//
// Revision23 1.11  2001/08/24 21:01:12  mohor23
// Things23 connected23 to parity23 changed.
// Clock23 devider23 changed.
//
// Revision23 1.10  2001/08/23 16:05:05  mohor23
// Stop bit bug23 fixed23.
// Parity23 bug23 fixed23.
// WISHBONE23 read cycle bug23 fixed23,
// OE23 indicator23 (Overrun23 Error) bug23 fixed23.
// PE23 indicator23 (Parity23 Error) bug23 fixed23.
// Register read bug23 fixed23.
//
// Revision23 1.4  2001/05/31 20:08:01  gorban23
// FIFO changes23 and other corrections23.
//
// Revision23 1.3  2001/05/21 19:12:02  gorban23
// Corrected23 some23 Linter23 messages23.
//
// Revision23 1.2  2001/05/17 18:34:18  gorban23
// First23 'stable' release. Should23 be sythesizable23 now. Also23 added new header.
//
// Revision23 1.0  2001-05-17 21:27:12+02  jacob23
// Initial23 revision23
//
//
// synopsys23 translate_off23
`include "timescale.v"
// synopsys23 translate_on23

`include "uart_defines23.v"

module uart_top23	(
	wb_clk_i23, 
	
	// Wishbone23 signals23
	wb_rst_i23, wb_adr_i23, wb_dat_i23, wb_dat_o23, wb_we_i23, wb_stb_i23, wb_cyc_i23, wb_ack_o23, wb_sel_i23,
	int_o23, // interrupt23 request

	// UART23	signals23
	// serial23 input/output
	stx_pad_o23, srx_pad_i23,

	// modem23 signals23
	rts_pad_o23, cts_pad_i23, dtr_pad_o23, dsr_pad_i23, ri_pad_i23, dcd_pad_i23
`ifdef UART_HAS_BAUDRATE_OUTPUT23
	, baud_o23
`endif
	);

parameter 							 uart_data_width23 = `UART_DATA_WIDTH23;
parameter 							 uart_addr_width23 = `UART_ADDR_WIDTH23;

input 								 wb_clk_i23;

// WISHBONE23 interface
input 								 wb_rst_i23;
input [uart_addr_width23-1:0] 	 wb_adr_i23;
input [uart_data_width23-1:0] 	 wb_dat_i23;
output [uart_data_width23-1:0] 	 wb_dat_o23;
input 								 wb_we_i23;
input 								 wb_stb_i23;
input 								 wb_cyc_i23;
input [3:0]							 wb_sel_i23;
output 								 wb_ack_o23;
output 								 int_o23;

// UART23	signals23
input 								 srx_pad_i23;
output 								 stx_pad_o23;
output 								 rts_pad_o23;
input 								 cts_pad_i23;
output 								 dtr_pad_o23;
input 								 dsr_pad_i23;
input 								 ri_pad_i23;
input 								 dcd_pad_i23;

// optional23 baudrate23 output
`ifdef UART_HAS_BAUDRATE_OUTPUT23
output	baud_o23;
`endif


wire 									 stx_pad_o23;
wire 									 rts_pad_o23;
wire 									 dtr_pad_o23;

wire [uart_addr_width23-1:0] 	 wb_adr_i23;
wire [uart_data_width23-1:0] 	 wb_dat_i23;
wire [uart_data_width23-1:0] 	 wb_dat_o23;

wire [7:0] 							 wb_dat8_i23; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o23; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o23; // debug23 interface 32-bit output
wire [3:0] 							 wb_sel_i23;  // WISHBONE23 select23 signal23
wire [uart_addr_width23-1:0] 	 wb_adr_int23;
wire 									 we_o23;	// Write enable for registers
wire		          	     re_o23;	// Read enable for registers
//
// MODULE23 INSTANCES23
//

`ifdef DATA_BUS_WIDTH_823
`else
// debug23 interface wires23
wire	[3:0] ier23;
wire	[3:0] iir23;
wire	[1:0] fcr23;
wire	[4:0] mcr23;
wire	[7:0] lcr23;
wire	[7:0] msr23;
wire	[7:0] lsr23;
wire	[`UART_FIFO_COUNTER_W23-1:0] rf_count23;
wire	[`UART_FIFO_COUNTER_W23-1:0] tf_count23;
wire	[2:0] tstate23;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_823
////  WISHBONE23 interface module
uart_wb23		wb_interface23(
		.clk23(		wb_clk_i23		),
		.wb_rst_i23(	wb_rst_i23	),
	.wb_dat_i23(wb_dat_i23),
	.wb_dat_o23(wb_dat_o23),
	.wb_dat8_i23(wb_dat8_i23),
	.wb_dat8_o23(wb_dat8_o23),
	 .wb_dat32_o23(32'b0),								 
	 .wb_sel_i23(4'b0),
		.wb_we_i23(	wb_we_i23		),
		.wb_stb_i23(	wb_stb_i23	),
		.wb_cyc_i23(	wb_cyc_i23	),
		.wb_ack_o23(	wb_ack_o23	),
	.wb_adr_i23(wb_adr_i23),
	.wb_adr_int23(wb_adr_int23),
		.we_o23(		we_o23		),
		.re_o23(re_o23)
		);
`else
uart_wb23		wb_interface23(
		.clk23(		wb_clk_i23		),
		.wb_rst_i23(	wb_rst_i23	),
	.wb_dat_i23(wb_dat_i23),
	.wb_dat_o23(wb_dat_o23),
	.wb_dat8_i23(wb_dat8_i23),
	.wb_dat8_o23(wb_dat8_o23),
	 .wb_sel_i23(wb_sel_i23),
	 .wb_dat32_o23(wb_dat32_o23),								 
		.wb_we_i23(	wb_we_i23		),
		.wb_stb_i23(	wb_stb_i23	),
		.wb_cyc_i23(	wb_cyc_i23	),
		.wb_ack_o23(	wb_ack_o23	),
	.wb_adr_i23(wb_adr_i23),
	.wb_adr_int23(wb_adr_int23),
		.we_o23(		we_o23		),
		.re_o23(re_o23)
		);
`endif

// Registers23
uart_regs23	regs(
	.clk23(		wb_clk_i23		),
	.wb_rst_i23(	wb_rst_i23	),
	.wb_addr_i23(	wb_adr_int23	),
	.wb_dat_i23(	wb_dat8_i23	),
	.wb_dat_o23(	wb_dat8_o23	),
	.wb_we_i23(	we_o23		),
   .wb_re_i23(re_o23),
	.modem_inputs23(	{cts_pad_i23, dsr_pad_i23,
	ri_pad_i23,  dcd_pad_i23}	),
	.stx_pad_o23(		stx_pad_o23		),
	.srx_pad_i23(		srx_pad_i23		),
`ifdef DATA_BUS_WIDTH_823
`else
// debug23 interface signals23	enabled
.ier23(ier23), 
.iir23(iir23), 
.fcr23(fcr23), 
.mcr23(mcr23), 
.lcr23(lcr23), 
.msr23(msr23), 
.lsr23(lsr23), 
.rf_count23(rf_count23),
.tf_count23(tf_count23),
.tstate23(tstate23),
.rstate(rstate),
`endif					  
	.rts_pad_o23(		rts_pad_o23		),
	.dtr_pad_o23(		dtr_pad_o23		),
	.int_o23(		int_o23		)
`ifdef UART_HAS_BAUDRATE_OUTPUT23
	, .baud_o23(baud_o23)
`endif

);

`ifdef DATA_BUS_WIDTH_823
`else
uart_debug_if23 dbg23(/*AUTOINST23*/
						// Outputs23
						.wb_dat32_o23				 (wb_dat32_o23[31:0]),
						// Inputs23
						.wb_adr_i23				 (wb_adr_int23[`UART_ADDR_WIDTH23-1:0]),
						.ier23						 (ier23[3:0]),
						.iir23						 (iir23[3:0]),
						.fcr23						 (fcr23[1:0]),
						.mcr23						 (mcr23[4:0]),
						.lcr23						 (lcr23[7:0]),
						.msr23						 (msr23[7:0]),
						.lsr23						 (lsr23[7:0]),
						.rf_count23				 (rf_count23[`UART_FIFO_COUNTER_W23-1:0]),
						.tf_count23				 (tf_count23[`UART_FIFO_COUNTER_W23-1:0]),
						.tstate23					 (tstate23[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_823
		$display("(%m) UART23 INFO23: Data bus width is 8. No Debug23 interface.\n");
	`else
		$display("(%m) UART23 INFO23: Data bus width is 32. Debug23 Interface23 present23.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT23
		$display("(%m) UART23 INFO23: Has23 baudrate23 output\n");
	`else
		$display("(%m) UART23 INFO23: Doesn23't have baudrate23 output\n");
	`endif
end

endmodule


