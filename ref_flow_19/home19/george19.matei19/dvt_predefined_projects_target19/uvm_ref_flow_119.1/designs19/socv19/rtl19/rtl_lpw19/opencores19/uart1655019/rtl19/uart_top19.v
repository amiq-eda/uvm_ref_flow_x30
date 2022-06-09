//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top19.v                                                  ////
////                                                              ////
////                                                              ////
////  This19 file is part of the "UART19 16550 compatible19" project19    ////
////  http19://www19.opencores19.org19/cores19/uart1655019/                   ////
////                                                              ////
////  Documentation19 related19 to this project19:                      ////
////  - http19://www19.opencores19.org19/cores19/uart1655019/                 ////
////                                                              ////
////  Projects19 compatibility19:                                     ////
////  - WISHBONE19                                                  ////
////  RS23219 Protocol19                                              ////
////  16550D uart19 (mostly19 supported)                              ////
////                                                              ////
////  Overview19 (main19 Features19):                                   ////
////  UART19 core19 top level.                                        ////
////                                                              ////
////  Known19 problems19 (limits19):                                    ////
////  Note19 that transmitter19 and receiver19 instances19 are inside     ////
////  the uart_regs19.v file.                                       ////
////                                                              ////
////  To19 Do19:                                                      ////
////  Nothing so far19.                                             ////
////                                                              ////
////  Author19(s):                                                  ////
////      - gorban19@opencores19.org19                                  ////
////      - Jacob19 Gorban19                                          ////
////      - Igor19 Mohor19 (igorm19@opencores19.org19)                      ////
////                                                              ////
////  Created19:        2001/05/12                                  ////
////  Last19 Updated19:   2001/05/17                                  ////
////                  (See log19 for the revision19 history19)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2000, 2001 Authors19                             ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS19 Revision19 History19
//
// $Log: not supported by cvs2svn19 $
// Revision19 1.18  2002/07/22 23:02:23  gorban19
// Bug19 Fixes19:
//  * Possible19 loss of sync and bad19 reception19 of stop bit on slow19 baud19 rates19 fixed19.
//   Problem19 reported19 by Kenny19.Tung19.
//  * Bad (or lack19 of ) loopback19 handling19 fixed19. Reported19 by Cherry19 Withers19.
//
// Improvements19:
//  * Made19 FIFO's as general19 inferrable19 memory where possible19.
//  So19 on FPGA19 they should be inferred19 as RAM19 (Distributed19 RAM19 on Xilinx19).
//  This19 saves19 about19 1/3 of the Slice19 count and reduces19 P&R and synthesis19 times.
//
//  * Added19 optional19 baudrate19 output (baud_o19).
//  This19 is identical19 to BAUDOUT19* signal19 on 16550 chip19.
//  It outputs19 16xbit_clock_rate - the divided19 clock19.
//  It's disabled by default. Define19 UART_HAS_BAUDRATE_OUTPUT19 to use.
//
// Revision19 1.17  2001/12/19 08:40:03  mohor19
// Warnings19 fixed19 (unused19 signals19 removed).
//
// Revision19 1.16  2001/12/06 14:51:04  gorban19
// Bug19 in LSR19[0] is fixed19.
// All WISHBONE19 signals19 are now sampled19, so another19 wait-state is introduced19 on all transfers19.
//
// Revision19 1.15  2001/12/03 21:44:29  gorban19
// Updated19 specification19 documentation.
// Added19 full 32-bit data bus interface, now as default.
// Address is 5-bit wide19 in 32-bit data bus mode.
// Added19 wb_sel_i19 input to the core19. It's used in the 32-bit mode.
// Added19 debug19 interface with two19 32-bit read-only registers in 32-bit mode.
// Bits19 5 and 6 of LSR19 are now only cleared19 on TX19 FIFO write.
// My19 small test bench19 is modified to work19 with 32-bit mode.
//
// Revision19 1.14  2001/11/07 17:51:52  gorban19
// Heavily19 rewritten19 interrupt19 and LSR19 subsystems19.
// Many19 bugs19 hopefully19 squashed19.
//
// Revision19 1.13  2001/10/20 09:58:40  gorban19
// Small19 synopsis19 fixes19
//
// Revision19 1.12  2001/08/25 15:46:19  gorban19
// Modified19 port names again19
//
// Revision19 1.11  2001/08/24 21:01:12  mohor19
// Things19 connected19 to parity19 changed.
// Clock19 devider19 changed.
//
// Revision19 1.10  2001/08/23 16:05:05  mohor19
// Stop bit bug19 fixed19.
// Parity19 bug19 fixed19.
// WISHBONE19 read cycle bug19 fixed19,
// OE19 indicator19 (Overrun19 Error) bug19 fixed19.
// PE19 indicator19 (Parity19 Error) bug19 fixed19.
// Register read bug19 fixed19.
//
// Revision19 1.4  2001/05/31 20:08:01  gorban19
// FIFO changes19 and other corrections19.
//
// Revision19 1.3  2001/05/21 19:12:02  gorban19
// Corrected19 some19 Linter19 messages19.
//
// Revision19 1.2  2001/05/17 18:34:18  gorban19
// First19 'stable' release. Should19 be sythesizable19 now. Also19 added new header.
//
// Revision19 1.0  2001-05-17 21:27:12+02  jacob19
// Initial19 revision19
//
//
// synopsys19 translate_off19
`include "timescale.v"
// synopsys19 translate_on19

`include "uart_defines19.v"

module uart_top19	(
	wb_clk_i19, 
	
	// Wishbone19 signals19
	wb_rst_i19, wb_adr_i19, wb_dat_i19, wb_dat_o19, wb_we_i19, wb_stb_i19, wb_cyc_i19, wb_ack_o19, wb_sel_i19,
	int_o19, // interrupt19 request

	// UART19	signals19
	// serial19 input/output
	stx_pad_o19, srx_pad_i19,

	// modem19 signals19
	rts_pad_o19, cts_pad_i19, dtr_pad_o19, dsr_pad_i19, ri_pad_i19, dcd_pad_i19
`ifdef UART_HAS_BAUDRATE_OUTPUT19
	, baud_o19
`endif
	);

parameter 							 uart_data_width19 = `UART_DATA_WIDTH19;
parameter 							 uart_addr_width19 = `UART_ADDR_WIDTH19;

input 								 wb_clk_i19;

// WISHBONE19 interface
input 								 wb_rst_i19;
input [uart_addr_width19-1:0] 	 wb_adr_i19;
input [uart_data_width19-1:0] 	 wb_dat_i19;
output [uart_data_width19-1:0] 	 wb_dat_o19;
input 								 wb_we_i19;
input 								 wb_stb_i19;
input 								 wb_cyc_i19;
input [3:0]							 wb_sel_i19;
output 								 wb_ack_o19;
output 								 int_o19;

// UART19	signals19
input 								 srx_pad_i19;
output 								 stx_pad_o19;
output 								 rts_pad_o19;
input 								 cts_pad_i19;
output 								 dtr_pad_o19;
input 								 dsr_pad_i19;
input 								 ri_pad_i19;
input 								 dcd_pad_i19;

// optional19 baudrate19 output
`ifdef UART_HAS_BAUDRATE_OUTPUT19
output	baud_o19;
`endif


wire 									 stx_pad_o19;
wire 									 rts_pad_o19;
wire 									 dtr_pad_o19;

wire [uart_addr_width19-1:0] 	 wb_adr_i19;
wire [uart_data_width19-1:0] 	 wb_dat_i19;
wire [uart_data_width19-1:0] 	 wb_dat_o19;

wire [7:0] 							 wb_dat8_i19; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o19; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o19; // debug19 interface 32-bit output
wire [3:0] 							 wb_sel_i19;  // WISHBONE19 select19 signal19
wire [uart_addr_width19-1:0] 	 wb_adr_int19;
wire 									 we_o19;	// Write enable for registers
wire		          	     re_o19;	// Read enable for registers
//
// MODULE19 INSTANCES19
//

`ifdef DATA_BUS_WIDTH_819
`else
// debug19 interface wires19
wire	[3:0] ier19;
wire	[3:0] iir19;
wire	[1:0] fcr19;
wire	[4:0] mcr19;
wire	[7:0] lcr19;
wire	[7:0] msr19;
wire	[7:0] lsr19;
wire	[`UART_FIFO_COUNTER_W19-1:0] rf_count19;
wire	[`UART_FIFO_COUNTER_W19-1:0] tf_count19;
wire	[2:0] tstate19;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_819
////  WISHBONE19 interface module
uart_wb19		wb_interface19(
		.clk19(		wb_clk_i19		),
		.wb_rst_i19(	wb_rst_i19	),
	.wb_dat_i19(wb_dat_i19),
	.wb_dat_o19(wb_dat_o19),
	.wb_dat8_i19(wb_dat8_i19),
	.wb_dat8_o19(wb_dat8_o19),
	 .wb_dat32_o19(32'b0),								 
	 .wb_sel_i19(4'b0),
		.wb_we_i19(	wb_we_i19		),
		.wb_stb_i19(	wb_stb_i19	),
		.wb_cyc_i19(	wb_cyc_i19	),
		.wb_ack_o19(	wb_ack_o19	),
	.wb_adr_i19(wb_adr_i19),
	.wb_adr_int19(wb_adr_int19),
		.we_o19(		we_o19		),
		.re_o19(re_o19)
		);
`else
uart_wb19		wb_interface19(
		.clk19(		wb_clk_i19		),
		.wb_rst_i19(	wb_rst_i19	),
	.wb_dat_i19(wb_dat_i19),
	.wb_dat_o19(wb_dat_o19),
	.wb_dat8_i19(wb_dat8_i19),
	.wb_dat8_o19(wb_dat8_o19),
	 .wb_sel_i19(wb_sel_i19),
	 .wb_dat32_o19(wb_dat32_o19),								 
		.wb_we_i19(	wb_we_i19		),
		.wb_stb_i19(	wb_stb_i19	),
		.wb_cyc_i19(	wb_cyc_i19	),
		.wb_ack_o19(	wb_ack_o19	),
	.wb_adr_i19(wb_adr_i19),
	.wb_adr_int19(wb_adr_int19),
		.we_o19(		we_o19		),
		.re_o19(re_o19)
		);
`endif

// Registers19
uart_regs19	regs(
	.clk19(		wb_clk_i19		),
	.wb_rst_i19(	wb_rst_i19	),
	.wb_addr_i19(	wb_adr_int19	),
	.wb_dat_i19(	wb_dat8_i19	),
	.wb_dat_o19(	wb_dat8_o19	),
	.wb_we_i19(	we_o19		),
   .wb_re_i19(re_o19),
	.modem_inputs19(	{cts_pad_i19, dsr_pad_i19,
	ri_pad_i19,  dcd_pad_i19}	),
	.stx_pad_o19(		stx_pad_o19		),
	.srx_pad_i19(		srx_pad_i19		),
`ifdef DATA_BUS_WIDTH_819
`else
// debug19 interface signals19	enabled
.ier19(ier19), 
.iir19(iir19), 
.fcr19(fcr19), 
.mcr19(mcr19), 
.lcr19(lcr19), 
.msr19(msr19), 
.lsr19(lsr19), 
.rf_count19(rf_count19),
.tf_count19(tf_count19),
.tstate19(tstate19),
.rstate(rstate),
`endif					  
	.rts_pad_o19(		rts_pad_o19		),
	.dtr_pad_o19(		dtr_pad_o19		),
	.int_o19(		int_o19		)
`ifdef UART_HAS_BAUDRATE_OUTPUT19
	, .baud_o19(baud_o19)
`endif

);

`ifdef DATA_BUS_WIDTH_819
`else
uart_debug_if19 dbg19(/*AUTOINST19*/
						// Outputs19
						.wb_dat32_o19				 (wb_dat32_o19[31:0]),
						// Inputs19
						.wb_adr_i19				 (wb_adr_int19[`UART_ADDR_WIDTH19-1:0]),
						.ier19						 (ier19[3:0]),
						.iir19						 (iir19[3:0]),
						.fcr19						 (fcr19[1:0]),
						.mcr19						 (mcr19[4:0]),
						.lcr19						 (lcr19[7:0]),
						.msr19						 (msr19[7:0]),
						.lsr19						 (lsr19[7:0]),
						.rf_count19				 (rf_count19[`UART_FIFO_COUNTER_W19-1:0]),
						.tf_count19				 (tf_count19[`UART_FIFO_COUNTER_W19-1:0]),
						.tstate19					 (tstate19[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_819
		$display("(%m) UART19 INFO19: Data bus width is 8. No Debug19 interface.\n");
	`else
		$display("(%m) UART19 INFO19: Data bus width is 32. Debug19 Interface19 present19.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT19
		$display("(%m) UART19 INFO19: Has19 baudrate19 output\n");
	`else
		$display("(%m) UART19 INFO19: Doesn19't have baudrate19 output\n");
	`endif
end

endmodule


