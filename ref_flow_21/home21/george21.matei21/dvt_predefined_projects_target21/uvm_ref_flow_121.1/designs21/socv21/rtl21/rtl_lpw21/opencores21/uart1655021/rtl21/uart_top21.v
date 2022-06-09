//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top21.v                                                  ////
////                                                              ////
////                                                              ////
////  This21 file is part of the "UART21 16550 compatible21" project21    ////
////  http21://www21.opencores21.org21/cores21/uart1655021/                   ////
////                                                              ////
////  Documentation21 related21 to this project21:                      ////
////  - http21://www21.opencores21.org21/cores21/uart1655021/                 ////
////                                                              ////
////  Projects21 compatibility21:                                     ////
////  - WISHBONE21                                                  ////
////  RS23221 Protocol21                                              ////
////  16550D uart21 (mostly21 supported)                              ////
////                                                              ////
////  Overview21 (main21 Features21):                                   ////
////  UART21 core21 top level.                                        ////
////                                                              ////
////  Known21 problems21 (limits21):                                    ////
////  Note21 that transmitter21 and receiver21 instances21 are inside     ////
////  the uart_regs21.v file.                                       ////
////                                                              ////
////  To21 Do21:                                                      ////
////  Nothing so far21.                                             ////
////                                                              ////
////  Author21(s):                                                  ////
////      - gorban21@opencores21.org21                                  ////
////      - Jacob21 Gorban21                                          ////
////      - Igor21 Mohor21 (igorm21@opencores21.org21)                      ////
////                                                              ////
////  Created21:        2001/05/12                                  ////
////  Last21 Updated21:   2001/05/17                                  ////
////                  (See log21 for the revision21 history21)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2000, 2001 Authors21                             ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS21 Revision21 History21
//
// $Log: not supported by cvs2svn21 $
// Revision21 1.18  2002/07/22 23:02:23  gorban21
// Bug21 Fixes21:
//  * Possible21 loss of sync and bad21 reception21 of stop bit on slow21 baud21 rates21 fixed21.
//   Problem21 reported21 by Kenny21.Tung21.
//  * Bad (or lack21 of ) loopback21 handling21 fixed21. Reported21 by Cherry21 Withers21.
//
// Improvements21:
//  * Made21 FIFO's as general21 inferrable21 memory where possible21.
//  So21 on FPGA21 they should be inferred21 as RAM21 (Distributed21 RAM21 on Xilinx21).
//  This21 saves21 about21 1/3 of the Slice21 count and reduces21 P&R and synthesis21 times.
//
//  * Added21 optional21 baudrate21 output (baud_o21).
//  This21 is identical21 to BAUDOUT21* signal21 on 16550 chip21.
//  It outputs21 16xbit_clock_rate - the divided21 clock21.
//  It's disabled by default. Define21 UART_HAS_BAUDRATE_OUTPUT21 to use.
//
// Revision21 1.17  2001/12/19 08:40:03  mohor21
// Warnings21 fixed21 (unused21 signals21 removed).
//
// Revision21 1.16  2001/12/06 14:51:04  gorban21
// Bug21 in LSR21[0] is fixed21.
// All WISHBONE21 signals21 are now sampled21, so another21 wait-state is introduced21 on all transfers21.
//
// Revision21 1.15  2001/12/03 21:44:29  gorban21
// Updated21 specification21 documentation.
// Added21 full 32-bit data bus interface, now as default.
// Address is 5-bit wide21 in 32-bit data bus mode.
// Added21 wb_sel_i21 input to the core21. It's used in the 32-bit mode.
// Added21 debug21 interface with two21 32-bit read-only registers in 32-bit mode.
// Bits21 5 and 6 of LSR21 are now only cleared21 on TX21 FIFO write.
// My21 small test bench21 is modified to work21 with 32-bit mode.
//
// Revision21 1.14  2001/11/07 17:51:52  gorban21
// Heavily21 rewritten21 interrupt21 and LSR21 subsystems21.
// Many21 bugs21 hopefully21 squashed21.
//
// Revision21 1.13  2001/10/20 09:58:40  gorban21
// Small21 synopsis21 fixes21
//
// Revision21 1.12  2001/08/25 15:46:19  gorban21
// Modified21 port names again21
//
// Revision21 1.11  2001/08/24 21:01:12  mohor21
// Things21 connected21 to parity21 changed.
// Clock21 devider21 changed.
//
// Revision21 1.10  2001/08/23 16:05:05  mohor21
// Stop bit bug21 fixed21.
// Parity21 bug21 fixed21.
// WISHBONE21 read cycle bug21 fixed21,
// OE21 indicator21 (Overrun21 Error) bug21 fixed21.
// PE21 indicator21 (Parity21 Error) bug21 fixed21.
// Register read bug21 fixed21.
//
// Revision21 1.4  2001/05/31 20:08:01  gorban21
// FIFO changes21 and other corrections21.
//
// Revision21 1.3  2001/05/21 19:12:02  gorban21
// Corrected21 some21 Linter21 messages21.
//
// Revision21 1.2  2001/05/17 18:34:18  gorban21
// First21 'stable' release. Should21 be sythesizable21 now. Also21 added new header.
//
// Revision21 1.0  2001-05-17 21:27:12+02  jacob21
// Initial21 revision21
//
//
// synopsys21 translate_off21
`include "timescale.v"
// synopsys21 translate_on21

`include "uart_defines21.v"

module uart_top21	(
	wb_clk_i21, 
	
	// Wishbone21 signals21
	wb_rst_i21, wb_adr_i21, wb_dat_i21, wb_dat_o21, wb_we_i21, wb_stb_i21, wb_cyc_i21, wb_ack_o21, wb_sel_i21,
	int_o21, // interrupt21 request

	// UART21	signals21
	// serial21 input/output
	stx_pad_o21, srx_pad_i21,

	// modem21 signals21
	rts_pad_o21, cts_pad_i21, dtr_pad_o21, dsr_pad_i21, ri_pad_i21, dcd_pad_i21
`ifdef UART_HAS_BAUDRATE_OUTPUT21
	, baud_o21
`endif
	);

parameter 							 uart_data_width21 = `UART_DATA_WIDTH21;
parameter 							 uart_addr_width21 = `UART_ADDR_WIDTH21;

input 								 wb_clk_i21;

// WISHBONE21 interface
input 								 wb_rst_i21;
input [uart_addr_width21-1:0] 	 wb_adr_i21;
input [uart_data_width21-1:0] 	 wb_dat_i21;
output [uart_data_width21-1:0] 	 wb_dat_o21;
input 								 wb_we_i21;
input 								 wb_stb_i21;
input 								 wb_cyc_i21;
input [3:0]							 wb_sel_i21;
output 								 wb_ack_o21;
output 								 int_o21;

// UART21	signals21
input 								 srx_pad_i21;
output 								 stx_pad_o21;
output 								 rts_pad_o21;
input 								 cts_pad_i21;
output 								 dtr_pad_o21;
input 								 dsr_pad_i21;
input 								 ri_pad_i21;
input 								 dcd_pad_i21;

// optional21 baudrate21 output
`ifdef UART_HAS_BAUDRATE_OUTPUT21
output	baud_o21;
`endif


wire 									 stx_pad_o21;
wire 									 rts_pad_o21;
wire 									 dtr_pad_o21;

wire [uart_addr_width21-1:0] 	 wb_adr_i21;
wire [uart_data_width21-1:0] 	 wb_dat_i21;
wire [uart_data_width21-1:0] 	 wb_dat_o21;

wire [7:0] 							 wb_dat8_i21; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o21; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o21; // debug21 interface 32-bit output
wire [3:0] 							 wb_sel_i21;  // WISHBONE21 select21 signal21
wire [uart_addr_width21-1:0] 	 wb_adr_int21;
wire 									 we_o21;	// Write enable for registers
wire		          	     re_o21;	// Read enable for registers
//
// MODULE21 INSTANCES21
//

`ifdef DATA_BUS_WIDTH_821
`else
// debug21 interface wires21
wire	[3:0] ier21;
wire	[3:0] iir21;
wire	[1:0] fcr21;
wire	[4:0] mcr21;
wire	[7:0] lcr21;
wire	[7:0] msr21;
wire	[7:0] lsr21;
wire	[`UART_FIFO_COUNTER_W21-1:0] rf_count21;
wire	[`UART_FIFO_COUNTER_W21-1:0] tf_count21;
wire	[2:0] tstate21;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_821
////  WISHBONE21 interface module
uart_wb21		wb_interface21(
		.clk21(		wb_clk_i21		),
		.wb_rst_i21(	wb_rst_i21	),
	.wb_dat_i21(wb_dat_i21),
	.wb_dat_o21(wb_dat_o21),
	.wb_dat8_i21(wb_dat8_i21),
	.wb_dat8_o21(wb_dat8_o21),
	 .wb_dat32_o21(32'b0),								 
	 .wb_sel_i21(4'b0),
		.wb_we_i21(	wb_we_i21		),
		.wb_stb_i21(	wb_stb_i21	),
		.wb_cyc_i21(	wb_cyc_i21	),
		.wb_ack_o21(	wb_ack_o21	),
	.wb_adr_i21(wb_adr_i21),
	.wb_adr_int21(wb_adr_int21),
		.we_o21(		we_o21		),
		.re_o21(re_o21)
		);
`else
uart_wb21		wb_interface21(
		.clk21(		wb_clk_i21		),
		.wb_rst_i21(	wb_rst_i21	),
	.wb_dat_i21(wb_dat_i21),
	.wb_dat_o21(wb_dat_o21),
	.wb_dat8_i21(wb_dat8_i21),
	.wb_dat8_o21(wb_dat8_o21),
	 .wb_sel_i21(wb_sel_i21),
	 .wb_dat32_o21(wb_dat32_o21),								 
		.wb_we_i21(	wb_we_i21		),
		.wb_stb_i21(	wb_stb_i21	),
		.wb_cyc_i21(	wb_cyc_i21	),
		.wb_ack_o21(	wb_ack_o21	),
	.wb_adr_i21(wb_adr_i21),
	.wb_adr_int21(wb_adr_int21),
		.we_o21(		we_o21		),
		.re_o21(re_o21)
		);
`endif

// Registers21
uart_regs21	regs(
	.clk21(		wb_clk_i21		),
	.wb_rst_i21(	wb_rst_i21	),
	.wb_addr_i21(	wb_adr_int21	),
	.wb_dat_i21(	wb_dat8_i21	),
	.wb_dat_o21(	wb_dat8_o21	),
	.wb_we_i21(	we_o21		),
   .wb_re_i21(re_o21),
	.modem_inputs21(	{cts_pad_i21, dsr_pad_i21,
	ri_pad_i21,  dcd_pad_i21}	),
	.stx_pad_o21(		stx_pad_o21		),
	.srx_pad_i21(		srx_pad_i21		),
`ifdef DATA_BUS_WIDTH_821
`else
// debug21 interface signals21	enabled
.ier21(ier21), 
.iir21(iir21), 
.fcr21(fcr21), 
.mcr21(mcr21), 
.lcr21(lcr21), 
.msr21(msr21), 
.lsr21(lsr21), 
.rf_count21(rf_count21),
.tf_count21(tf_count21),
.tstate21(tstate21),
.rstate(rstate),
`endif					  
	.rts_pad_o21(		rts_pad_o21		),
	.dtr_pad_o21(		dtr_pad_o21		),
	.int_o21(		int_o21		)
`ifdef UART_HAS_BAUDRATE_OUTPUT21
	, .baud_o21(baud_o21)
`endif

);

`ifdef DATA_BUS_WIDTH_821
`else
uart_debug_if21 dbg21(/*AUTOINST21*/
						// Outputs21
						.wb_dat32_o21				 (wb_dat32_o21[31:0]),
						// Inputs21
						.wb_adr_i21				 (wb_adr_int21[`UART_ADDR_WIDTH21-1:0]),
						.ier21						 (ier21[3:0]),
						.iir21						 (iir21[3:0]),
						.fcr21						 (fcr21[1:0]),
						.mcr21						 (mcr21[4:0]),
						.lcr21						 (lcr21[7:0]),
						.msr21						 (msr21[7:0]),
						.lsr21						 (lsr21[7:0]),
						.rf_count21				 (rf_count21[`UART_FIFO_COUNTER_W21-1:0]),
						.tf_count21				 (tf_count21[`UART_FIFO_COUNTER_W21-1:0]),
						.tstate21					 (tstate21[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_821
		$display("(%m) UART21 INFO21: Data bus width is 8. No Debug21 interface.\n");
	`else
		$display("(%m) UART21 INFO21: Data bus width is 32. Debug21 Interface21 present21.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT21
		$display("(%m) UART21 INFO21: Has21 baudrate21 output\n");
	`else
		$display("(%m) UART21 INFO21: Doesn21't have baudrate21 output\n");
	`endif
end

endmodule


