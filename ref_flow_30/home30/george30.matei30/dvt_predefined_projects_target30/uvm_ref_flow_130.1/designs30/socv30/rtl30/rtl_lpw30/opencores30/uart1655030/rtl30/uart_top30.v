//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_top30.v                                                  ////
////                                                              ////
////                                                              ////
////  This30 file is part of the "UART30 16550 compatible30" project30    ////
////  http30://www30.opencores30.org30/cores30/uart1655030/                   ////
////                                                              ////
////  Documentation30 related30 to this project30:                      ////
////  - http30://www30.opencores30.org30/cores30/uart1655030/                 ////
////                                                              ////
////  Projects30 compatibility30:                                     ////
////  - WISHBONE30                                                  ////
////  RS23230 Protocol30                                              ////
////  16550D uart30 (mostly30 supported)                              ////
////                                                              ////
////  Overview30 (main30 Features30):                                   ////
////  UART30 core30 top level.                                        ////
////                                                              ////
////  Known30 problems30 (limits30):                                    ////
////  Note30 that transmitter30 and receiver30 instances30 are inside     ////
////  the uart_regs30.v file.                                       ////
////                                                              ////
////  To30 Do30:                                                      ////
////  Nothing so far30.                                             ////
////                                                              ////
////  Author30(s):                                                  ////
////      - gorban30@opencores30.org30                                  ////
////      - Jacob30 Gorban30                                          ////
////      - Igor30 Mohor30 (igorm30@opencores30.org30)                      ////
////                                                              ////
////  Created30:        2001/05/12                                  ////
////  Last30 Updated30:   2001/05/17                                  ////
////                  (See log30 for the revision30 history30)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2000, 2001 Authors30                             ////
////                                                              ////
//// This30 source30 file may be used and distributed30 without         ////
//// restriction30 provided that this copyright30 statement30 is not    ////
//// removed from the file and that any derivative30 work30 contains30  ////
//// the original copyright30 notice30 and the associated disclaimer30. ////
////                                                              ////
//// This30 source30 file is free software30; you can redistribute30 it   ////
//// and/or modify it under the terms30 of the GNU30 Lesser30 General30   ////
//// Public30 License30 as published30 by the Free30 Software30 Foundation30; ////
//// either30 version30 2.1 of the License30, or (at your30 option) any   ////
//// later30 version30.                                               ////
////                                                              ////
//// This30 source30 is distributed30 in the hope30 that it will be       ////
//// useful30, but WITHOUT30 ANY30 WARRANTY30; without even30 the implied30   ////
//// warranty30 of MERCHANTABILITY30 or FITNESS30 FOR30 A PARTICULAR30      ////
//// PURPOSE30.  See the GNU30 Lesser30 General30 Public30 License30 for more ////
//// details30.                                                     ////
////                                                              ////
//// You should have received30 a copy of the GNU30 Lesser30 General30    ////
//// Public30 License30 along30 with this source30; if not, download30 it   ////
//// from http30://www30.opencores30.org30/lgpl30.shtml30                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS30 Revision30 History30
//
// $Log: not supported by cvs2svn30 $
// Revision30 1.18  2002/07/22 23:02:23  gorban30
// Bug30 Fixes30:
//  * Possible30 loss of sync and bad30 reception30 of stop bit on slow30 baud30 rates30 fixed30.
//   Problem30 reported30 by Kenny30.Tung30.
//  * Bad (or lack30 of ) loopback30 handling30 fixed30. Reported30 by Cherry30 Withers30.
//
// Improvements30:
//  * Made30 FIFO's as general30 inferrable30 memory where possible30.
//  So30 on FPGA30 they should be inferred30 as RAM30 (Distributed30 RAM30 on Xilinx30).
//  This30 saves30 about30 1/3 of the Slice30 count and reduces30 P&R and synthesis30 times.
//
//  * Added30 optional30 baudrate30 output (baud_o30).
//  This30 is identical30 to BAUDOUT30* signal30 on 16550 chip30.
//  It outputs30 16xbit_clock_rate - the divided30 clock30.
//  It's disabled by default. Define30 UART_HAS_BAUDRATE_OUTPUT30 to use.
//
// Revision30 1.17  2001/12/19 08:40:03  mohor30
// Warnings30 fixed30 (unused30 signals30 removed).
//
// Revision30 1.16  2001/12/06 14:51:04  gorban30
// Bug30 in LSR30[0] is fixed30.
// All WISHBONE30 signals30 are now sampled30, so another30 wait-state is introduced30 on all transfers30.
//
// Revision30 1.15  2001/12/03 21:44:29  gorban30
// Updated30 specification30 documentation.
// Added30 full 32-bit data bus interface, now as default.
// Address is 5-bit wide30 in 32-bit data bus mode.
// Added30 wb_sel_i30 input to the core30. It's used in the 32-bit mode.
// Added30 debug30 interface with two30 32-bit read-only registers in 32-bit mode.
// Bits30 5 and 6 of LSR30 are now only cleared30 on TX30 FIFO write.
// My30 small test bench30 is modified to work30 with 32-bit mode.
//
// Revision30 1.14  2001/11/07 17:51:52  gorban30
// Heavily30 rewritten30 interrupt30 and LSR30 subsystems30.
// Many30 bugs30 hopefully30 squashed30.
//
// Revision30 1.13  2001/10/20 09:58:40  gorban30
// Small30 synopsis30 fixes30
//
// Revision30 1.12  2001/08/25 15:46:19  gorban30
// Modified30 port names again30
//
// Revision30 1.11  2001/08/24 21:01:12  mohor30
// Things30 connected30 to parity30 changed.
// Clock30 devider30 changed.
//
// Revision30 1.10  2001/08/23 16:05:05  mohor30
// Stop bit bug30 fixed30.
// Parity30 bug30 fixed30.
// WISHBONE30 read cycle bug30 fixed30,
// OE30 indicator30 (Overrun30 Error) bug30 fixed30.
// PE30 indicator30 (Parity30 Error) bug30 fixed30.
// Register read bug30 fixed30.
//
// Revision30 1.4  2001/05/31 20:08:01  gorban30
// FIFO changes30 and other corrections30.
//
// Revision30 1.3  2001/05/21 19:12:02  gorban30
// Corrected30 some30 Linter30 messages30.
//
// Revision30 1.2  2001/05/17 18:34:18  gorban30
// First30 'stable' release. Should30 be sythesizable30 now. Also30 added new header.
//
// Revision30 1.0  2001-05-17 21:27:12+02  jacob30
// Initial30 revision30
//
//
// synopsys30 translate_off30
`include "timescale.v"
// synopsys30 translate_on30

`include "uart_defines30.v"

module uart_top30	(
	wb_clk_i30, 
	
	// Wishbone30 signals30
	wb_rst_i30, wb_adr_i30, wb_dat_i30, wb_dat_o30, wb_we_i30, wb_stb_i30, wb_cyc_i30, wb_ack_o30, wb_sel_i30,
	int_o30, // interrupt30 request

	// UART30	signals30
	// serial30 input/output
	stx_pad_o30, srx_pad_i30,

	// modem30 signals30
	rts_pad_o30, cts_pad_i30, dtr_pad_o30, dsr_pad_i30, ri_pad_i30, dcd_pad_i30
`ifdef UART_HAS_BAUDRATE_OUTPUT30
	, baud_o30
`endif
	);

parameter 							 uart_data_width30 = `UART_DATA_WIDTH30;
parameter 							 uart_addr_width30 = `UART_ADDR_WIDTH30;

input 								 wb_clk_i30;

// WISHBONE30 interface
input 								 wb_rst_i30;
input [uart_addr_width30-1:0] 	 wb_adr_i30;
input [uart_data_width30-1:0] 	 wb_dat_i30;
output [uart_data_width30-1:0] 	 wb_dat_o30;
input 								 wb_we_i30;
input 								 wb_stb_i30;
input 								 wb_cyc_i30;
input [3:0]							 wb_sel_i30;
output 								 wb_ack_o30;
output 								 int_o30;

// UART30	signals30
input 								 srx_pad_i30;
output 								 stx_pad_o30;
output 								 rts_pad_o30;
input 								 cts_pad_i30;
output 								 dtr_pad_o30;
input 								 dsr_pad_i30;
input 								 ri_pad_i30;
input 								 dcd_pad_i30;

// optional30 baudrate30 output
`ifdef UART_HAS_BAUDRATE_OUTPUT30
output	baud_o30;
`endif


wire 									 stx_pad_o30;
wire 									 rts_pad_o30;
wire 									 dtr_pad_o30;

wire [uart_addr_width30-1:0] 	 wb_adr_i30;
wire [uart_data_width30-1:0] 	 wb_dat_i30;
wire [uart_data_width30-1:0] 	 wb_dat_o30;

wire [7:0] 							 wb_dat8_i30; // 8-bit internal data input
wire [7:0] 							 wb_dat8_o30; // 8-bit internal data output
wire [31:0] 						 wb_dat32_o30; // debug30 interface 32-bit output
wire [3:0] 							 wb_sel_i30;  // WISHBONE30 select30 signal30
wire [uart_addr_width30-1:0] 	 wb_adr_int30;
wire 									 we_o30;	// Write enable for registers
wire		          	     re_o30;	// Read enable for registers
//
// MODULE30 INSTANCES30
//

`ifdef DATA_BUS_WIDTH_830
`else
// debug30 interface wires30
wire	[3:0] ier30;
wire	[3:0] iir30;
wire	[1:0] fcr30;
wire	[4:0] mcr30;
wire	[7:0] lcr30;
wire	[7:0] msr30;
wire	[7:0] lsr30;
wire	[`UART_FIFO_COUNTER_W30-1:0] rf_count30;
wire	[`UART_FIFO_COUNTER_W30-1:0] tf_count30;
wire	[2:0] tstate30;
wire	[3:0] rstate; 
`endif

`ifdef DATA_BUS_WIDTH_830
////  WISHBONE30 interface module
uart_wb30		wb_interface30(
		.clk30(		wb_clk_i30		),
		.wb_rst_i30(	wb_rst_i30	),
	.wb_dat_i30(wb_dat_i30),
	.wb_dat_o30(wb_dat_o30),
	.wb_dat8_i30(wb_dat8_i30),
	.wb_dat8_o30(wb_dat8_o30),
	 .wb_dat32_o30(32'b0),								 
	 .wb_sel_i30(4'b0),
		.wb_we_i30(	wb_we_i30		),
		.wb_stb_i30(	wb_stb_i30	),
		.wb_cyc_i30(	wb_cyc_i30	),
		.wb_ack_o30(	wb_ack_o30	),
	.wb_adr_i30(wb_adr_i30),
	.wb_adr_int30(wb_adr_int30),
		.we_o30(		we_o30		),
		.re_o30(re_o30)
		);
`else
uart_wb30		wb_interface30(
		.clk30(		wb_clk_i30		),
		.wb_rst_i30(	wb_rst_i30	),
	.wb_dat_i30(wb_dat_i30),
	.wb_dat_o30(wb_dat_o30),
	.wb_dat8_i30(wb_dat8_i30),
	.wb_dat8_o30(wb_dat8_o30),
	 .wb_sel_i30(wb_sel_i30),
	 .wb_dat32_o30(wb_dat32_o30),								 
		.wb_we_i30(	wb_we_i30		),
		.wb_stb_i30(	wb_stb_i30	),
		.wb_cyc_i30(	wb_cyc_i30	),
		.wb_ack_o30(	wb_ack_o30	),
	.wb_adr_i30(wb_adr_i30),
	.wb_adr_int30(wb_adr_int30),
		.we_o30(		we_o30		),
		.re_o30(re_o30)
		);
`endif

// Registers30
uart_regs30	regs(
	.clk30(		wb_clk_i30		),
	.wb_rst_i30(	wb_rst_i30	),
	.wb_addr_i30(	wb_adr_int30	),
	.wb_dat_i30(	wb_dat8_i30	),
	.wb_dat_o30(	wb_dat8_o30	),
	.wb_we_i30(	we_o30		),
   .wb_re_i30(re_o30),
	.modem_inputs30(	{cts_pad_i30, dsr_pad_i30,
	ri_pad_i30,  dcd_pad_i30}	),
	.stx_pad_o30(		stx_pad_o30		),
	.srx_pad_i30(		srx_pad_i30		),
`ifdef DATA_BUS_WIDTH_830
`else
// debug30 interface signals30	enabled
.ier30(ier30), 
.iir30(iir30), 
.fcr30(fcr30), 
.mcr30(mcr30), 
.lcr30(lcr30), 
.msr30(msr30), 
.lsr30(lsr30), 
.rf_count30(rf_count30),
.tf_count30(tf_count30),
.tstate30(tstate30),
.rstate(rstate),
`endif					  
	.rts_pad_o30(		rts_pad_o30		),
	.dtr_pad_o30(		dtr_pad_o30		),
	.int_o30(		int_o30		)
`ifdef UART_HAS_BAUDRATE_OUTPUT30
	, .baud_o30(baud_o30)
`endif

);

`ifdef DATA_BUS_WIDTH_830
`else
uart_debug_if30 dbg30(/*AUTOINST30*/
						// Outputs30
						.wb_dat32_o30				 (wb_dat32_o30[31:0]),
						// Inputs30
						.wb_adr_i30				 (wb_adr_int30[`UART_ADDR_WIDTH30-1:0]),
						.ier30						 (ier30[3:0]),
						.iir30						 (iir30[3:0]),
						.fcr30						 (fcr30[1:0]),
						.mcr30						 (mcr30[4:0]),
						.lcr30						 (lcr30[7:0]),
						.msr30						 (msr30[7:0]),
						.lsr30						 (lsr30[7:0]),
						.rf_count30				 (rf_count30[`UART_FIFO_COUNTER_W30-1:0]),
						.tf_count30				 (tf_count30[`UART_FIFO_COUNTER_W30-1:0]),
						.tstate30					 (tstate30[2:0]),
						.rstate					 (rstate[3:0]));
`endif 

initial
begin
	`ifdef DATA_BUS_WIDTH_830
		$display("(%m) UART30 INFO30: Data bus width is 8. No Debug30 interface.\n");
	`else
		$display("(%m) UART30 INFO30: Data bus width is 32. Debug30 Interface30 present30.\n");
	`endif
	`ifdef UART_HAS_BAUDRATE_OUTPUT30
		$display("(%m) UART30 INFO30: Has30 baudrate30 output\n");
	`else
		$display("(%m) UART30 INFO30: Doesn30't have baudrate30 output\n");
	`endif
end

endmodule


