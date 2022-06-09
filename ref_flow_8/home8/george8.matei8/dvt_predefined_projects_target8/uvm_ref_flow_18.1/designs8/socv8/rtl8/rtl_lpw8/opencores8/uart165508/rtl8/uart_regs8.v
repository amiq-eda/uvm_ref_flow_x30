//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs8.v                                                 ////
////                                                              ////
////                                                              ////
////  This8 file is part of the "UART8 16550 compatible8" project8    ////
////  http8://www8.opencores8.org8/cores8/uart165508/                   ////
////                                                              ////
////  Documentation8 related8 to this project8:                      ////
////  - http8://www8.opencores8.org8/cores8/uart165508/                 ////
////                                                              ////
////  Projects8 compatibility8:                                     ////
////  - WISHBONE8                                                  ////
////  RS2328 Protocol8                                              ////
////  16550D uart8 (mostly8 supported)                              ////
////                                                              ////
////  Overview8 (main8 Features8):                                   ////
////  Registers8 of the uart8 16550 core8                            ////
////                                                              ////
////  Known8 problems8 (limits8):                                    ////
////  Inserts8 1 wait state in all WISHBONE8 transfers8              ////
////                                                              ////
////  To8 Do8:                                                      ////
////  Nothing or verification8.                                    ////
////                                                              ////
////  Author8(s):                                                  ////
////      - gorban8@opencores8.org8                                  ////
////      - Jacob8 Gorban8                                          ////
////      - Igor8 Mohor8 (igorm8@opencores8.org8)                      ////
////                                                              ////
////  Created8:        2001/05/12                                  ////
////  Last8 Updated8:   (See log8 for the revision8 history8           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2000, 2001 Authors8                             ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS8 Revision8 History8
//
// $Log: not supported by cvs2svn8 $
// Revision8 1.41  2004/05/21 11:44:41  tadejm8
// Added8 synchronizer8 flops8 for RX8 input.
//
// Revision8 1.40  2003/06/11 16:37:47  gorban8
// This8 fixes8 errors8 in some8 cases8 when data is being read and put to the FIFO at the same time. Patch8 is submitted8 by Scott8 Furman8. Update is very8 recommended8.
//
// Revision8 1.39  2002/07/29 21:16:18  gorban8
// The uart_defines8.v file is included8 again8 in sources8.
//
// Revision8 1.38  2002/07/22 23:02:23  gorban8
// Bug8 Fixes8:
//  * Possible8 loss of sync and bad8 reception8 of stop bit on slow8 baud8 rates8 fixed8.
//   Problem8 reported8 by Kenny8.Tung8.
//  * Bad (or lack8 of ) loopback8 handling8 fixed8. Reported8 by Cherry8 Withers8.
//
// Improvements8:
//  * Made8 FIFO's as general8 inferrable8 memory where possible8.
//  So8 on FPGA8 they should be inferred8 as RAM8 (Distributed8 RAM8 on Xilinx8).
//  This8 saves8 about8 1/3 of the Slice8 count and reduces8 P&R and synthesis8 times.
//
//  * Added8 optional8 baudrate8 output (baud_o8).
//  This8 is identical8 to BAUDOUT8* signal8 on 16550 chip8.
//  It outputs8 16xbit_clock_rate - the divided8 clock8.
//  It's disabled by default. Define8 UART_HAS_BAUDRATE_OUTPUT8 to use.
//
// Revision8 1.37  2001/12/27 13:24:09  mohor8
// lsr8[7] was not showing8 overrun8 errors8.
//
// Revision8 1.36  2001/12/20 13:25:46  mohor8
// rx8 push8 changed to be only one cycle wide8.
//
// Revision8 1.35  2001/12/19 08:03:34  mohor8
// Warnings8 cleared8.
//
// Revision8 1.34  2001/12/19 07:33:54  mohor8
// Synplicity8 was having8 troubles8 with the comment8.
//
// Revision8 1.33  2001/12/17 10:14:43  mohor8
// Things8 related8 to msr8 register changed. After8 THRE8 IRQ8 occurs8, and one
// character8 is written8 to the transmit8 fifo, the detection8 of the THRE8 bit in the
// LSR8 is delayed8 for one character8 time.
//
// Revision8 1.32  2001/12/14 13:19:24  mohor8
// MSR8 register fixed8.
//
// Revision8 1.31  2001/12/14 10:06:58  mohor8
// After8 reset modem8 status register MSR8 should be reset.
//
// Revision8 1.30  2001/12/13 10:09:13  mohor8
// thre8 irq8 should be cleared8 only when being source8 of interrupt8.
//
// Revision8 1.29  2001/12/12 09:05:46  mohor8
// LSR8 status bit 0 was not cleared8 correctly in case of reseting8 the FCR8 (rx8 fifo).
//
// Revision8 1.28  2001/12/10 19:52:41  gorban8
// Scratch8 register added
//
// Revision8 1.27  2001/12/06 14:51:04  gorban8
// Bug8 in LSR8[0] is fixed8.
// All WISHBONE8 signals8 are now sampled8, so another8 wait-state is introduced8 on all transfers8.
//
// Revision8 1.26  2001/12/03 21:44:29  gorban8
// Updated8 specification8 documentation.
// Added8 full 32-bit data bus interface, now as default.
// Address is 5-bit wide8 in 32-bit data bus mode.
// Added8 wb_sel_i8 input to the core8. It's used in the 32-bit mode.
// Added8 debug8 interface with two8 32-bit read-only registers in 32-bit mode.
// Bits8 5 and 6 of LSR8 are now only cleared8 on TX8 FIFO write.
// My8 small test bench8 is modified to work8 with 32-bit mode.
//
// Revision8 1.25  2001/11/28 19:36:39  gorban8
// Fixed8: timeout and break didn8't pay8 attention8 to current data format8 when counting8 time
//
// Revision8 1.24  2001/11/26 21:38:54  gorban8
// Lots8 of fixes8:
// Break8 condition wasn8't handled8 correctly at all.
// LSR8 bits could lose8 their8 values.
// LSR8 value after reset was wrong8.
// Timing8 of THRE8 interrupt8 signal8 corrected8.
// LSR8 bit 0 timing8 corrected8.
//
// Revision8 1.23  2001/11/12 21:57:29  gorban8
// fixed8 more typo8 bugs8
//
// Revision8 1.22  2001/11/12 15:02:28  mohor8
// lsr1r8 error fixed8.
//
// Revision8 1.21  2001/11/12 14:57:27  mohor8
// ti_int_pnd8 error fixed8.
//
// Revision8 1.20  2001/11/12 14:50:27  mohor8
// ti_int_d8 error fixed8.
//
// Revision8 1.19  2001/11/10 12:43:21  gorban8
// Logic8 Synthesis8 bugs8 fixed8. Some8 other minor8 changes8
//
// Revision8 1.18  2001/11/08 14:54:23  mohor8
// Comments8 in Slovene8 language8 deleted8, few8 small fixes8 for better8 work8 of
// old8 tools8. IRQs8 need to be fix8.
//
// Revision8 1.17  2001/11/07 17:51:52  gorban8
// Heavily8 rewritten8 interrupt8 and LSR8 subsystems8.
// Many8 bugs8 hopefully8 squashed8.
//
// Revision8 1.16  2001/11/02 09:55:16  mohor8
// no message
//
// Revision8 1.15  2001/10/31 15:19:22  gorban8
// Fixes8 to break and timeout conditions8
//
// Revision8 1.14  2001/10/29 17:00:46  gorban8
// fixed8 parity8 sending8 and tx_fifo8 resets8 over- and underrun8
//
// Revision8 1.13  2001/10/20 09:58:40  gorban8
// Small8 synopsis8 fixes8
//
// Revision8 1.12  2001/10/19 16:21:40  gorban8
// Changes8 data_out8 to be synchronous8 again8 as it should have been.
//
// Revision8 1.11  2001/10/18 20:35:45  gorban8
// small fix8
//
// Revision8 1.10  2001/08/24 21:01:12  mohor8
// Things8 connected8 to parity8 changed.
// Clock8 devider8 changed.
//
// Revision8 1.9  2001/08/23 16:05:05  mohor8
// Stop bit bug8 fixed8.
// Parity8 bug8 fixed8.
// WISHBONE8 read cycle bug8 fixed8,
// OE8 indicator8 (Overrun8 Error) bug8 fixed8.
// PE8 indicator8 (Parity8 Error) bug8 fixed8.
// Register read bug8 fixed8.
//
// Revision8 1.10  2001/06/23 11:21:48  gorban8
// DL8 made8 16-bit long8. Fixed8 transmission8/reception8 bugs8.
//
// Revision8 1.9  2001/05/31 20:08:01  gorban8
// FIFO changes8 and other corrections8.
//
// Revision8 1.8  2001/05/29 20:05:04  gorban8
// Fixed8 some8 bugs8 and synthesis8 problems8.
//
// Revision8 1.7  2001/05/27 17:37:49  gorban8
// Fixed8 many8 bugs8. Updated8 spec8. Changed8 FIFO files structure8. See CHANGES8.txt8 file.
//
// Revision8 1.6  2001/05/21 19:12:02  gorban8
// Corrected8 some8 Linter8 messages8.
//
// Revision8 1.5  2001/05/17 18:34:18  gorban8
// First8 'stable' release. Should8 be sythesizable8 now. Also8 added new header.
//
// Revision8 1.0  2001-05-17 21:27:11+02  jacob8
// Initial8 revision8
//
//

// synopsys8 translate_off8
`include "timescale.v"
// synopsys8 translate_on8

`include "uart_defines8.v"

`define UART_DL18 7:0
`define UART_DL28 15:8

module uart_regs8 (clk8,
	wb_rst_i8, wb_addr_i8, wb_dat_i8, wb_dat_o8, wb_we_i8, wb_re_i8, 

// additional8 signals8
	modem_inputs8,
	stx_pad_o8, srx_pad_i8,

`ifdef DATA_BUS_WIDTH_88
`else
// debug8 interface signals8	enabled
ier8, iir8, fcr8, mcr8, lcr8, msr8, lsr8, rf_count8, tf_count8, tstate8, rstate,
`endif				
	rts_pad_o8, dtr_pad_o8, int_o8
`ifdef UART_HAS_BAUDRATE_OUTPUT8
	, baud_o8
`endif

	);

input 									clk8;
input 									wb_rst_i8;
input [`UART_ADDR_WIDTH8-1:0] 		wb_addr_i8;
input [7:0] 							wb_dat_i8;
output [7:0] 							wb_dat_o8;
input 									wb_we_i8;
input 									wb_re_i8;

output 									stx_pad_o8;
input 									srx_pad_i8;

input [3:0] 							modem_inputs8;
output 									rts_pad_o8;
output 									dtr_pad_o8;
output 									int_o8;
`ifdef UART_HAS_BAUDRATE_OUTPUT8
output	baud_o8;
`endif

`ifdef DATA_BUS_WIDTH_88
`else
// if 32-bit databus8 and debug8 interface are enabled
output [3:0]							ier8;
output [3:0]							iir8;
output [1:0]							fcr8;  /// bits 7 and 6 of fcr8. Other8 bits are ignored
output [4:0]							mcr8;
output [7:0]							lcr8;
output [7:0]							msr8;
output [7:0] 							lsr8;
output [`UART_FIFO_COUNTER_W8-1:0] 	rf_count8;
output [`UART_FIFO_COUNTER_W8-1:0] 	tf_count8;
output [2:0] 							tstate8;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs8;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT8
assign baud_o8 = enable; // baud_o8 is actually8 the enable signal8
`endif


wire 										stx_pad_o8;		// received8 from transmitter8 module
wire 										srx_pad_i8;
wire 										srx_pad8;

reg [7:0] 								wb_dat_o8;

wire [`UART_ADDR_WIDTH8-1:0] 		wb_addr_i8;
wire [7:0] 								wb_dat_i8;


reg [3:0] 								ier8;
reg [3:0] 								iir8;
reg [1:0] 								fcr8;  /// bits 7 and 6 of fcr8. Other8 bits are ignored
reg [4:0] 								mcr8;
reg [7:0] 								lcr8;
reg [7:0] 								msr8;
reg [15:0] 								dl8;  // 32-bit divisor8 latch8
reg [7:0] 								scratch8; // UART8 scratch8 register
reg 										start_dlc8; // activate8 dlc8 on writing to UART_DL18
reg 										lsr_mask_d8; // delay for lsr_mask8 condition
reg 										msi_reset8; // reset MSR8 4 lower8 bits indicator8
//reg 										threi_clear8; // THRE8 interrupt8 clear flag8
reg [15:0] 								dlc8;  // 32-bit divisor8 latch8 counter
reg 										int_o8;

reg [3:0] 								trigger_level8; // trigger level of the receiver8 FIFO
reg 										rx_reset8;
reg 										tx_reset8;

wire 										dlab8;			   // divisor8 latch8 access bit
wire 										cts_pad_i8, dsr_pad_i8, ri_pad_i8, dcd_pad_i8; // modem8 status bits
wire 										loopback8;		   // loopback8 bit (MCR8 bit 4)
wire 										cts8, dsr8, ri, dcd8;	   // effective8 signals8
wire                    cts_c8, dsr_c8, ri_c8, dcd_c8; // Complement8 effective8 signals8 (considering8 loopback8)
wire 										rts_pad_o8, dtr_pad_o8;		   // modem8 control8 outputs8

// LSR8 bits wires8 and regs
wire [7:0] 								lsr8;
wire 										lsr08, lsr18, lsr28, lsr38, lsr48, lsr58, lsr68, lsr78;
reg										lsr0r8, lsr1r8, lsr2r8, lsr3r8, lsr4r8, lsr5r8, lsr6r8, lsr7r8;
wire 										lsr_mask8; // lsr_mask8

//
// ASSINGS8
//

assign 									lsr8[7:0] = { lsr7r8, lsr6r8, lsr5r8, lsr4r8, lsr3r8, lsr2r8, lsr1r8, lsr0r8 };

assign 									{cts_pad_i8, dsr_pad_i8, ri_pad_i8, dcd_pad_i8} = modem_inputs8;
assign 									{cts8, dsr8, ri, dcd8} = ~{cts_pad_i8,dsr_pad_i8,ri_pad_i8,dcd_pad_i8};

assign                  {cts_c8, dsr_c8, ri_c8, dcd_c8} = loopback8 ? {mcr8[`UART_MC_RTS8],mcr8[`UART_MC_DTR8],mcr8[`UART_MC_OUT18],mcr8[`UART_MC_OUT28]}
                                                               : {cts_pad_i8,dsr_pad_i8,ri_pad_i8,dcd_pad_i8};

assign 									dlab8 = lcr8[`UART_LC_DL8];
assign 									loopback8 = mcr8[4];

// assign modem8 outputs8
assign 									rts_pad_o8 = mcr8[`UART_MC_RTS8];
assign 									dtr_pad_o8 = mcr8[`UART_MC_DTR8];

// Interrupt8 signals8
wire 										rls_int8;  // receiver8 line status interrupt8
wire 										rda_int8;  // receiver8 data available interrupt8
wire 										ti_int8;   // timeout indicator8 interrupt8
wire										thre_int8; // transmitter8 holding8 register empty8 interrupt8
wire 										ms_int8;   // modem8 status interrupt8

// FIFO signals8
reg 										tf_push8;
reg 										rf_pop8;
wire [`UART_FIFO_REC_WIDTH8-1:0] 	rf_data_out8;
wire 										rf_error_bit8; // an error (parity8 or framing8) is inside the fifo
wire [`UART_FIFO_COUNTER_W8-1:0] 	rf_count8;
wire [`UART_FIFO_COUNTER_W8-1:0] 	tf_count8;
wire [2:0] 								tstate8;
wire [3:0] 								rstate;
wire [9:0] 								counter_t8;

wire                      thre_set_en8; // THRE8 status is delayed8 one character8 time when a character8 is written8 to fifo.
reg  [7:0]                block_cnt8;   // While8 counter counts8, THRE8 status is blocked8 (delayed8 one character8 cycle)
reg  [7:0]                block_value8; // One8 character8 length minus8 stop bit

// Transmitter8 Instance
wire serial_out8;

uart_transmitter8 transmitter8(clk8, wb_rst_i8, lcr8, tf_push8, wb_dat_i8, enable, serial_out8, tstate8, tf_count8, tx_reset8, lsr_mask8);

  // Synchronizing8 and sampling8 serial8 RX8 input
  uart_sync_flops8    i_uart_sync_flops8
  (
    .rst_i8           (wb_rst_i8),
    .clk_i8           (clk8),
    .stage1_rst_i8    (1'b0),
    .stage1_clk_en_i8 (1'b1),
    .async_dat_i8     (srx_pad_i8),
    .sync_dat_o8      (srx_pad8)
  );
  defparam i_uart_sync_flops8.width      = 1;
  defparam i_uart_sync_flops8.init_value8 = 1'b1;

// handle loopback8
wire serial_in8 = loopback8 ? serial_out8 : srx_pad8;
assign stx_pad_o8 = loopback8 ? 1'b1 : serial_out8;

// Receiver8 Instance
uart_receiver8 receiver8(clk8, wb_rst_i8, lcr8, rf_pop8, serial_in8, enable, 
	counter_t8, rf_count8, rf_data_out8, rf_error_bit8, rf_overrun8, rx_reset8, lsr_mask8, rstate, rf_push_pulse8);


// Asynchronous8 reading here8 because the outputs8 are sampled8 in uart_wb8.v file 
always @(dl8 or dlab8 or ier8 or iir8 or scratch8
			or lcr8 or lsr8 or msr8 or rf_data_out8 or wb_addr_i8 or wb_re_i8)   // asynchrounous8 reading
begin
	case (wb_addr_i8)
		`UART_REG_RB8   : wb_dat_o8 = dlab8 ? dl8[`UART_DL18] : rf_data_out8[10:3];
		`UART_REG_IE8	: wb_dat_o8 = dlab8 ? dl8[`UART_DL28] : ier8;
		`UART_REG_II8	: wb_dat_o8 = {4'b1100,iir8};
		`UART_REG_LC8	: wb_dat_o8 = lcr8;
		`UART_REG_LS8	: wb_dat_o8 = lsr8;
		`UART_REG_MS8	: wb_dat_o8 = msr8;
		`UART_REG_SR8	: wb_dat_o8 = scratch8;
		default:  wb_dat_o8 = 8'b0; // ??
	endcase // case(wb_addr_i8)
end // always @ (dl8 or dlab8 or ier8 or iir8 or scratch8...


// rf_pop8 signal8 handling8
always @(posedge clk8 or posedge wb_rst_i8)
begin
	if (wb_rst_i8)
		rf_pop8 <= #1 0; 
	else
	if (rf_pop8)	// restore8 the signal8 to 0 after one clock8 cycle
		rf_pop8 <= #1 0;
	else
	if (wb_re_i8 && wb_addr_i8 == `UART_REG_RB8 && !dlab8)
		rf_pop8 <= #1 1; // advance8 read pointer8
end

wire 	lsr_mask_condition8;
wire 	iir_read8;
wire  msr_read8;
wire	fifo_read8;
wire	fifo_write8;

assign lsr_mask_condition8 = (wb_re_i8 && wb_addr_i8 == `UART_REG_LS8 && !dlab8);
assign iir_read8 = (wb_re_i8 && wb_addr_i8 == `UART_REG_II8 && !dlab8);
assign msr_read8 = (wb_re_i8 && wb_addr_i8 == `UART_REG_MS8 && !dlab8);
assign fifo_read8 = (wb_re_i8 && wb_addr_i8 == `UART_REG_RB8 && !dlab8);
assign fifo_write8 = (wb_we_i8 && wb_addr_i8 == `UART_REG_TR8 && !dlab8);

// lsr_mask_d8 delayed8 signal8 handling8
always @(posedge clk8 or posedge wb_rst_i8)
begin
	if (wb_rst_i8)
		lsr_mask_d8 <= #1 0;
	else // reset bits in the Line8 Status Register
		lsr_mask_d8 <= #1 lsr_mask_condition8;
end

// lsr_mask8 is rise8 detected
assign lsr_mask8 = lsr_mask_condition8 && ~lsr_mask_d8;

// msi_reset8 signal8 handling8
always @(posedge clk8 or posedge wb_rst_i8)
begin
	if (wb_rst_i8)
		msi_reset8 <= #1 1;
	else
	if (msi_reset8)
		msi_reset8 <= #1 0;
	else
	if (msr_read8)
		msi_reset8 <= #1 1; // reset bits in Modem8 Status Register
end


//
//   WRITES8 AND8 RESETS8   //
//
// Line8 Control8 Register
always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8)
		lcr8 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i8 && wb_addr_i8==`UART_REG_LC8)
		lcr8 <= #1 wb_dat_i8;

// Interrupt8 Enable8 Register or UART_DL28
always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8)
	begin
		ier8 <= #1 4'b0000; // no interrupts8 after reset
		dl8[`UART_DL28] <= #1 8'b0;
	end
	else
	if (wb_we_i8 && wb_addr_i8==`UART_REG_IE8)
		if (dlab8)
		begin
			dl8[`UART_DL28] <= #1 wb_dat_i8;
		end
		else
			ier8 <= #1 wb_dat_i8[3:0]; // ier8 uses only 4 lsb


// FIFO Control8 Register and rx_reset8, tx_reset8 signals8
always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) begin
		fcr8 <= #1 2'b11; 
		rx_reset8 <= #1 0;
		tx_reset8 <= #1 0;
	end else
	if (wb_we_i8 && wb_addr_i8==`UART_REG_FC8) begin
		fcr8 <= #1 wb_dat_i8[7:6];
		rx_reset8 <= #1 wb_dat_i8[1];
		tx_reset8 <= #1 wb_dat_i8[2];
	end else begin
		rx_reset8 <= #1 0;
		tx_reset8 <= #1 0;
	end

// Modem8 Control8 Register
always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8)
		mcr8 <= #1 5'b0; 
	else
	if (wb_we_i8 && wb_addr_i8==`UART_REG_MC8)
			mcr8 <= #1 wb_dat_i8[4:0];

// Scratch8 register
// Line8 Control8 Register
always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8)
		scratch8 <= #1 0; // 8n1 setting
	else
	if (wb_we_i8 && wb_addr_i8==`UART_REG_SR8)
		scratch8 <= #1 wb_dat_i8;

// TX_FIFO8 or UART_DL18
always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8)
	begin
		dl8[`UART_DL18]  <= #1 8'b0;
		tf_push8   <= #1 1'b0;
		start_dlc8 <= #1 1'b0;
	end
	else
	if (wb_we_i8 && wb_addr_i8==`UART_REG_TR8)
		if (dlab8)
		begin
			dl8[`UART_DL18] <= #1 wb_dat_i8;
			start_dlc8 <= #1 1'b1; // enable DL8 counter
			tf_push8 <= #1 1'b0;
		end
		else
		begin
			tf_push8   <= #1 1'b1;
			start_dlc8 <= #1 1'b0;
		end // else: !if(dlab8)
	else
	begin
		start_dlc8 <= #1 1'b0;
		tf_push8   <= #1 1'b0;
	end // else: !if(dlab8)

// Receiver8 FIFO trigger level selection logic (asynchronous8 mux8)
always @(fcr8)
	case (fcr8[`UART_FC_TL8])
		2'b00 : trigger_level8 = 1;
		2'b01 : trigger_level8 = 4;
		2'b10 : trigger_level8 = 8;
		2'b11 : trigger_level8 = 14;
	endcase // case(fcr8[`UART_FC_TL8])
	
//
//  STATUS8 REGISTERS8  //
//

// Modem8 Status Register
reg [3:0] delayed_modem_signals8;
always @(posedge clk8 or posedge wb_rst_i8)
begin
	if (wb_rst_i8)
	  begin
  		msr8 <= #1 0;
	  	delayed_modem_signals8[3:0] <= #1 0;
	  end
	else begin
		msr8[`UART_MS_DDCD8:`UART_MS_DCTS8] <= #1 msi_reset8 ? 4'b0 :
			msr8[`UART_MS_DDCD8:`UART_MS_DCTS8] | ({dcd8, ri, dsr8, cts8} ^ delayed_modem_signals8[3:0]);
		msr8[`UART_MS_CDCD8:`UART_MS_CCTS8] <= #1 {dcd_c8, ri_c8, dsr_c8, cts_c8};
		delayed_modem_signals8[3:0] <= #1 {dcd8, ri, dsr8, cts8};
	end
end


// Line8 Status Register

// activation8 conditions8
assign lsr08 = (rf_count8==0 && rf_push_pulse8);  // data in receiver8 fifo available set condition
assign lsr18 = rf_overrun8;     // Receiver8 overrun8 error
assign lsr28 = rf_data_out8[1]; // parity8 error bit
assign lsr38 = rf_data_out8[0]; // framing8 error bit
assign lsr48 = rf_data_out8[2]; // break error in the character8
assign lsr58 = (tf_count8==5'b0 && thre_set_en8);  // transmitter8 fifo is empty8
assign lsr68 = (tf_count8==5'b0 && thre_set_en8 && (tstate8 == /*`S_IDLE8 */ 0)); // transmitter8 empty8
assign lsr78 = rf_error_bit8 | rf_overrun8;

// lsr8 bit08 (receiver8 data available)
reg 	 lsr0_d8;

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr0_d8 <= #1 0;
	else lsr0_d8 <= #1 lsr08;

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr0r8 <= #1 0;
	else lsr0r8 <= #1 (rf_count8==1 && rf_pop8 && !rf_push_pulse8 || rx_reset8) ? 0 : // deassert8 condition
					  lsr0r8 || (lsr08 && ~lsr0_d8); // set on rise8 of lsr08 and keep8 asserted8 until deasserted8 

// lsr8 bit 1 (receiver8 overrun8)
reg lsr1_d8; // delayed8

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr1_d8 <= #1 0;
	else lsr1_d8 <= #1 lsr18;

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr1r8 <= #1 0;
	else	lsr1r8 <= #1	lsr_mask8 ? 0 : lsr1r8 || (lsr18 && ~lsr1_d8); // set on rise8

// lsr8 bit 2 (parity8 error)
reg lsr2_d8; // delayed8

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr2_d8 <= #1 0;
	else lsr2_d8 <= #1 lsr28;

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr2r8 <= #1 0;
	else lsr2r8 <= #1 lsr_mask8 ? 0 : lsr2r8 || (lsr28 && ~lsr2_d8); // set on rise8

// lsr8 bit 3 (framing8 error)
reg lsr3_d8; // delayed8

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr3_d8 <= #1 0;
	else lsr3_d8 <= #1 lsr38;

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr3r8 <= #1 0;
	else lsr3r8 <= #1 lsr_mask8 ? 0 : lsr3r8 || (lsr38 && ~lsr3_d8); // set on rise8

// lsr8 bit 4 (break indicator8)
reg lsr4_d8; // delayed8

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr4_d8 <= #1 0;
	else lsr4_d8 <= #1 lsr48;

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr4r8 <= #1 0;
	else lsr4r8 <= #1 lsr_mask8 ? 0 : lsr4r8 || (lsr48 && ~lsr4_d8);

// lsr8 bit 5 (transmitter8 fifo is empty8)
reg lsr5_d8;

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr5_d8 <= #1 1;
	else lsr5_d8 <= #1 lsr58;

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr5r8 <= #1 1;
	else lsr5r8 <= #1 (fifo_write8) ? 0 :  lsr5r8 || (lsr58 && ~lsr5_d8);

// lsr8 bit 6 (transmitter8 empty8 indicator8)
reg lsr6_d8;

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr6_d8 <= #1 1;
	else lsr6_d8 <= #1 lsr68;

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr6r8 <= #1 1;
	else lsr6r8 <= #1 (fifo_write8) ? 0 : lsr6r8 || (lsr68 && ~lsr6_d8);

// lsr8 bit 7 (error in fifo)
reg lsr7_d8;

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr7_d8 <= #1 0;
	else lsr7_d8 <= #1 lsr78;

always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) lsr7r8 <= #1 0;
	else lsr7r8 <= #1 lsr_mask8 ? 0 : lsr7r8 || (lsr78 && ~lsr7_d8);

// Frequency8 divider8
always @(posedge clk8 or posedge wb_rst_i8) 
begin
	if (wb_rst_i8)
		dlc8 <= #1 0;
	else
		if (start_dlc8 | ~ (|dlc8))
  			dlc8 <= #1 dl8 - 1;               // preset8 counter
		else
			dlc8 <= #1 dlc8 - 1;              // decrement counter
end

// Enable8 signal8 generation8 logic
always @(posedge clk8 or posedge wb_rst_i8)
begin
	if (wb_rst_i8)
		enable <= #1 1'b0;
	else
		if (|dl8 & ~(|dlc8))     // dl8>0 & dlc8==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying8 THRE8 status for one character8 cycle after a character8 is written8 to an empty8 fifo.
always @(lcr8)
  case (lcr8[3:0])
    4'b0000                             : block_value8 =  95; // 6 bits
    4'b0100                             : block_value8 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value8 = 111; // 7 bits
    4'b1100                             : block_value8 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value8 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value8 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value8 = 159; // 10 bits
    4'b1111                             : block_value8 = 175; // 11 bits
  endcase // case(lcr8[3:0])

// Counting8 time of one character8 minus8 stop bit
always @(posedge clk8 or posedge wb_rst_i8)
begin
  if (wb_rst_i8)
    block_cnt8 <= #1 8'd0;
  else
  if(lsr5r8 & fifo_write8)  // THRE8 bit set & write to fifo occured8
    block_cnt8 <= #1 block_value8;
  else
  if (enable & block_cnt8 != 8'b0)  // only work8 on enable times
    block_cnt8 <= #1 block_cnt8 - 1;  // decrement break counter
end // always of break condition detection8

// Generating8 THRE8 status enable signal8
assign thre_set_en8 = ~(|block_cnt8);


//
//	INTERRUPT8 LOGIC8
//

assign rls_int8  = ier8[`UART_IE_RLS8] && (lsr8[`UART_LS_OE8] || lsr8[`UART_LS_PE8] || lsr8[`UART_LS_FE8] || lsr8[`UART_LS_BI8]);
assign rda_int8  = ier8[`UART_IE_RDA8] && (rf_count8 >= {1'b0,trigger_level8});
assign thre_int8 = ier8[`UART_IE_THRE8] && lsr8[`UART_LS_TFE8];
assign ms_int8   = ier8[`UART_IE_MS8] && (| msr8[3:0]);
assign ti_int8   = ier8[`UART_IE_RDA8] && (counter_t8 == 10'b0) && (|rf_count8);

reg 	 rls_int_d8;
reg 	 thre_int_d8;
reg 	 ms_int_d8;
reg 	 ti_int_d8;
reg 	 rda_int_d8;

// delay lines8
always  @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) rls_int_d8 <= #1 0;
	else rls_int_d8 <= #1 rls_int8;

always  @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) rda_int_d8 <= #1 0;
	else rda_int_d8 <= #1 rda_int8;

always  @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) thre_int_d8 <= #1 0;
	else thre_int_d8 <= #1 thre_int8;

always  @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) ms_int_d8 <= #1 0;
	else ms_int_d8 <= #1 ms_int8;

always  @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) ti_int_d8 <= #1 0;
	else ti_int_d8 <= #1 ti_int8;

// rise8 detection8 signals8

wire 	 rls_int_rise8;
wire 	 thre_int_rise8;
wire 	 ms_int_rise8;
wire 	 ti_int_rise8;
wire 	 rda_int_rise8;

assign rda_int_rise8    = rda_int8 & ~rda_int_d8;
assign rls_int_rise8 	  = rls_int8 & ~rls_int_d8;
assign thre_int_rise8   = thre_int8 & ~thre_int_d8;
assign ms_int_rise8 	  = ms_int8 & ~ms_int_d8;
assign ti_int_rise8 	  = ti_int8 & ~ti_int_d8;

// interrupt8 pending flags8
reg 	rls_int_pnd8;
reg	rda_int_pnd8;
reg 	thre_int_pnd8;
reg 	ms_int_pnd8;
reg 	ti_int_pnd8;

// interrupt8 pending flags8 assignments8
always  @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) rls_int_pnd8 <= #1 0; 
	else 
		rls_int_pnd8 <= #1 lsr_mask8 ? 0 :  						// reset condition
							rls_int_rise8 ? 1 :						// latch8 condition
							rls_int_pnd8 && ier8[`UART_IE_RLS8];	// default operation8: remove if masked8

always  @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) rda_int_pnd8 <= #1 0; 
	else 
		rda_int_pnd8 <= #1 ((rf_count8 == {1'b0,trigger_level8}) && fifo_read8) ? 0 :  	// reset condition
							rda_int_rise8 ? 1 :						// latch8 condition
							rda_int_pnd8 && ier8[`UART_IE_RDA8];	// default operation8: remove if masked8

always  @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) thre_int_pnd8 <= #1 0; 
	else 
		thre_int_pnd8 <= #1 fifo_write8 || (iir_read8 & ~iir8[`UART_II_IP8] & iir8[`UART_II_II8] == `UART_II_THRE8)? 0 : 
							thre_int_rise8 ? 1 :
							thre_int_pnd8 && ier8[`UART_IE_THRE8];

always  @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) ms_int_pnd8 <= #1 0; 
	else 
		ms_int_pnd8 <= #1 msr_read8 ? 0 : 
							ms_int_rise8 ? 1 :
							ms_int_pnd8 && ier8[`UART_IE_MS8];

always  @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) ti_int_pnd8 <= #1 0; 
	else 
		ti_int_pnd8 <= #1 fifo_read8 ? 0 : 
							ti_int_rise8 ? 1 :
							ti_int_pnd8 && ier8[`UART_IE_RDA8];
// end of pending flags8

// INT_O8 logic
always @(posedge clk8 or posedge wb_rst_i8)
begin
	if (wb_rst_i8)	
		int_o8 <= #1 1'b0;
	else
		int_o8 <= #1 
					rls_int_pnd8		?	~lsr_mask8					:
					rda_int_pnd8		? 1								:
					ti_int_pnd8		? ~fifo_read8					:
					thre_int_pnd8	? !(fifo_write8 & iir_read8) :
					ms_int_pnd8		? ~msr_read8						:
					0;	// if no interrupt8 are pending
end


// Interrupt8 Identification8 register
always @(posedge clk8 or posedge wb_rst_i8)
begin
	if (wb_rst_i8)
		iir8 <= #1 1;
	else
	if (rls_int_pnd8)  // interrupt8 is pending
	begin
		iir8[`UART_II_II8] <= #1 `UART_II_RLS8;	// set identification8 register to correct8 value
		iir8[`UART_II_IP8] <= #1 1'b0;		// and clear the IIR8 bit 0 (interrupt8 pending)
	end else // the sequence of conditions8 determines8 priority of interrupt8 identification8
	if (rda_int8)
	begin
		iir8[`UART_II_II8] <= #1 `UART_II_RDA8;
		iir8[`UART_II_IP8] <= #1 1'b0;
	end
	else if (ti_int_pnd8)
	begin
		iir8[`UART_II_II8] <= #1 `UART_II_TI8;
		iir8[`UART_II_IP8] <= #1 1'b0;
	end
	else if (thre_int_pnd8)
	begin
		iir8[`UART_II_II8] <= #1 `UART_II_THRE8;
		iir8[`UART_II_IP8] <= #1 1'b0;
	end
	else if (ms_int_pnd8)
	begin
		iir8[`UART_II_II8] <= #1 `UART_II_MS8;
		iir8[`UART_II_IP8] <= #1 1'b0;
	end else	// no interrupt8 is pending
	begin
		iir8[`UART_II_II8] <= #1 0;
		iir8[`UART_II_IP8] <= #1 1'b1;
	end
end

endmodule
