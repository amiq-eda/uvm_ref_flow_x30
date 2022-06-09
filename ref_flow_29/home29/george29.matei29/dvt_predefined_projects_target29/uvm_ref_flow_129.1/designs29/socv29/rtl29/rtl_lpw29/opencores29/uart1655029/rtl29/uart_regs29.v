//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs29.v                                                 ////
////                                                              ////
////                                                              ////
////  This29 file is part of the "UART29 16550 compatible29" project29    ////
////  http29://www29.opencores29.org29/cores29/uart1655029/                   ////
////                                                              ////
////  Documentation29 related29 to this project29:                      ////
////  - http29://www29.opencores29.org29/cores29/uart1655029/                 ////
////                                                              ////
////  Projects29 compatibility29:                                     ////
////  - WISHBONE29                                                  ////
////  RS23229 Protocol29                                              ////
////  16550D uart29 (mostly29 supported)                              ////
////                                                              ////
////  Overview29 (main29 Features29):                                   ////
////  Registers29 of the uart29 16550 core29                            ////
////                                                              ////
////  Known29 problems29 (limits29):                                    ////
////  Inserts29 1 wait state in all WISHBONE29 transfers29              ////
////                                                              ////
////  To29 Do29:                                                      ////
////  Nothing or verification29.                                    ////
////                                                              ////
////  Author29(s):                                                  ////
////      - gorban29@opencores29.org29                                  ////
////      - Jacob29 Gorban29                                          ////
////      - Igor29 Mohor29 (igorm29@opencores29.org29)                      ////
////                                                              ////
////  Created29:        2001/05/12                                  ////
////  Last29 Updated29:   (See log29 for the revision29 history29           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2000, 2001 Authors29                             ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS29 Revision29 History29
//
// $Log: not supported by cvs2svn29 $
// Revision29 1.41  2004/05/21 11:44:41  tadejm29
// Added29 synchronizer29 flops29 for RX29 input.
//
// Revision29 1.40  2003/06/11 16:37:47  gorban29
// This29 fixes29 errors29 in some29 cases29 when data is being read and put to the FIFO at the same time. Patch29 is submitted29 by Scott29 Furman29. Update is very29 recommended29.
//
// Revision29 1.39  2002/07/29 21:16:18  gorban29
// The uart_defines29.v file is included29 again29 in sources29.
//
// Revision29 1.38  2002/07/22 23:02:23  gorban29
// Bug29 Fixes29:
//  * Possible29 loss of sync and bad29 reception29 of stop bit on slow29 baud29 rates29 fixed29.
//   Problem29 reported29 by Kenny29.Tung29.
//  * Bad (or lack29 of ) loopback29 handling29 fixed29. Reported29 by Cherry29 Withers29.
//
// Improvements29:
//  * Made29 FIFO's as general29 inferrable29 memory where possible29.
//  So29 on FPGA29 they should be inferred29 as RAM29 (Distributed29 RAM29 on Xilinx29).
//  This29 saves29 about29 1/3 of the Slice29 count and reduces29 P&R and synthesis29 times.
//
//  * Added29 optional29 baudrate29 output (baud_o29).
//  This29 is identical29 to BAUDOUT29* signal29 on 16550 chip29.
//  It outputs29 16xbit_clock_rate - the divided29 clock29.
//  It's disabled by default. Define29 UART_HAS_BAUDRATE_OUTPUT29 to use.
//
// Revision29 1.37  2001/12/27 13:24:09  mohor29
// lsr29[7] was not showing29 overrun29 errors29.
//
// Revision29 1.36  2001/12/20 13:25:46  mohor29
// rx29 push29 changed to be only one cycle wide29.
//
// Revision29 1.35  2001/12/19 08:03:34  mohor29
// Warnings29 cleared29.
//
// Revision29 1.34  2001/12/19 07:33:54  mohor29
// Synplicity29 was having29 troubles29 with the comment29.
//
// Revision29 1.33  2001/12/17 10:14:43  mohor29
// Things29 related29 to msr29 register changed. After29 THRE29 IRQ29 occurs29, and one
// character29 is written29 to the transmit29 fifo, the detection29 of the THRE29 bit in the
// LSR29 is delayed29 for one character29 time.
//
// Revision29 1.32  2001/12/14 13:19:24  mohor29
// MSR29 register fixed29.
//
// Revision29 1.31  2001/12/14 10:06:58  mohor29
// After29 reset modem29 status register MSR29 should be reset.
//
// Revision29 1.30  2001/12/13 10:09:13  mohor29
// thre29 irq29 should be cleared29 only when being source29 of interrupt29.
//
// Revision29 1.29  2001/12/12 09:05:46  mohor29
// LSR29 status bit 0 was not cleared29 correctly in case of reseting29 the FCR29 (rx29 fifo).
//
// Revision29 1.28  2001/12/10 19:52:41  gorban29
// Scratch29 register added
//
// Revision29 1.27  2001/12/06 14:51:04  gorban29
// Bug29 in LSR29[0] is fixed29.
// All WISHBONE29 signals29 are now sampled29, so another29 wait-state is introduced29 on all transfers29.
//
// Revision29 1.26  2001/12/03 21:44:29  gorban29
// Updated29 specification29 documentation.
// Added29 full 32-bit data bus interface, now as default.
// Address is 5-bit wide29 in 32-bit data bus mode.
// Added29 wb_sel_i29 input to the core29. It's used in the 32-bit mode.
// Added29 debug29 interface with two29 32-bit read-only registers in 32-bit mode.
// Bits29 5 and 6 of LSR29 are now only cleared29 on TX29 FIFO write.
// My29 small test bench29 is modified to work29 with 32-bit mode.
//
// Revision29 1.25  2001/11/28 19:36:39  gorban29
// Fixed29: timeout and break didn29't pay29 attention29 to current data format29 when counting29 time
//
// Revision29 1.24  2001/11/26 21:38:54  gorban29
// Lots29 of fixes29:
// Break29 condition wasn29't handled29 correctly at all.
// LSR29 bits could lose29 their29 values.
// LSR29 value after reset was wrong29.
// Timing29 of THRE29 interrupt29 signal29 corrected29.
// LSR29 bit 0 timing29 corrected29.
//
// Revision29 1.23  2001/11/12 21:57:29  gorban29
// fixed29 more typo29 bugs29
//
// Revision29 1.22  2001/11/12 15:02:28  mohor29
// lsr1r29 error fixed29.
//
// Revision29 1.21  2001/11/12 14:57:27  mohor29
// ti_int_pnd29 error fixed29.
//
// Revision29 1.20  2001/11/12 14:50:27  mohor29
// ti_int_d29 error fixed29.
//
// Revision29 1.19  2001/11/10 12:43:21  gorban29
// Logic29 Synthesis29 bugs29 fixed29. Some29 other minor29 changes29
//
// Revision29 1.18  2001/11/08 14:54:23  mohor29
// Comments29 in Slovene29 language29 deleted29, few29 small fixes29 for better29 work29 of
// old29 tools29. IRQs29 need to be fix29.
//
// Revision29 1.17  2001/11/07 17:51:52  gorban29
// Heavily29 rewritten29 interrupt29 and LSR29 subsystems29.
// Many29 bugs29 hopefully29 squashed29.
//
// Revision29 1.16  2001/11/02 09:55:16  mohor29
// no message
//
// Revision29 1.15  2001/10/31 15:19:22  gorban29
// Fixes29 to break and timeout conditions29
//
// Revision29 1.14  2001/10/29 17:00:46  gorban29
// fixed29 parity29 sending29 and tx_fifo29 resets29 over- and underrun29
//
// Revision29 1.13  2001/10/20 09:58:40  gorban29
// Small29 synopsis29 fixes29
//
// Revision29 1.12  2001/10/19 16:21:40  gorban29
// Changes29 data_out29 to be synchronous29 again29 as it should have been.
//
// Revision29 1.11  2001/10/18 20:35:45  gorban29
// small fix29
//
// Revision29 1.10  2001/08/24 21:01:12  mohor29
// Things29 connected29 to parity29 changed.
// Clock29 devider29 changed.
//
// Revision29 1.9  2001/08/23 16:05:05  mohor29
// Stop bit bug29 fixed29.
// Parity29 bug29 fixed29.
// WISHBONE29 read cycle bug29 fixed29,
// OE29 indicator29 (Overrun29 Error) bug29 fixed29.
// PE29 indicator29 (Parity29 Error) bug29 fixed29.
// Register read bug29 fixed29.
//
// Revision29 1.10  2001/06/23 11:21:48  gorban29
// DL29 made29 16-bit long29. Fixed29 transmission29/reception29 bugs29.
//
// Revision29 1.9  2001/05/31 20:08:01  gorban29
// FIFO changes29 and other corrections29.
//
// Revision29 1.8  2001/05/29 20:05:04  gorban29
// Fixed29 some29 bugs29 and synthesis29 problems29.
//
// Revision29 1.7  2001/05/27 17:37:49  gorban29
// Fixed29 many29 bugs29. Updated29 spec29. Changed29 FIFO files structure29. See CHANGES29.txt29 file.
//
// Revision29 1.6  2001/05/21 19:12:02  gorban29
// Corrected29 some29 Linter29 messages29.
//
// Revision29 1.5  2001/05/17 18:34:18  gorban29
// First29 'stable' release. Should29 be sythesizable29 now. Also29 added new header.
//
// Revision29 1.0  2001-05-17 21:27:11+02  jacob29
// Initial29 revision29
//
//

// synopsys29 translate_off29
`include "timescale.v"
// synopsys29 translate_on29

`include "uart_defines29.v"

`define UART_DL129 7:0
`define UART_DL229 15:8

module uart_regs29 (clk29,
	wb_rst_i29, wb_addr_i29, wb_dat_i29, wb_dat_o29, wb_we_i29, wb_re_i29, 

// additional29 signals29
	modem_inputs29,
	stx_pad_o29, srx_pad_i29,

`ifdef DATA_BUS_WIDTH_829
`else
// debug29 interface signals29	enabled
ier29, iir29, fcr29, mcr29, lcr29, msr29, lsr29, rf_count29, tf_count29, tstate29, rstate,
`endif				
	rts_pad_o29, dtr_pad_o29, int_o29
`ifdef UART_HAS_BAUDRATE_OUTPUT29
	, baud_o29
`endif

	);

input 									clk29;
input 									wb_rst_i29;
input [`UART_ADDR_WIDTH29-1:0] 		wb_addr_i29;
input [7:0] 							wb_dat_i29;
output [7:0] 							wb_dat_o29;
input 									wb_we_i29;
input 									wb_re_i29;

output 									stx_pad_o29;
input 									srx_pad_i29;

input [3:0] 							modem_inputs29;
output 									rts_pad_o29;
output 									dtr_pad_o29;
output 									int_o29;
`ifdef UART_HAS_BAUDRATE_OUTPUT29
output	baud_o29;
`endif

`ifdef DATA_BUS_WIDTH_829
`else
// if 32-bit databus29 and debug29 interface are enabled
output [3:0]							ier29;
output [3:0]							iir29;
output [1:0]							fcr29;  /// bits 7 and 6 of fcr29. Other29 bits are ignored
output [4:0]							mcr29;
output [7:0]							lcr29;
output [7:0]							msr29;
output [7:0] 							lsr29;
output [`UART_FIFO_COUNTER_W29-1:0] 	rf_count29;
output [`UART_FIFO_COUNTER_W29-1:0] 	tf_count29;
output [2:0] 							tstate29;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs29;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT29
assign baud_o29 = enable; // baud_o29 is actually29 the enable signal29
`endif


wire 										stx_pad_o29;		// received29 from transmitter29 module
wire 										srx_pad_i29;
wire 										srx_pad29;

reg [7:0] 								wb_dat_o29;

wire [`UART_ADDR_WIDTH29-1:0] 		wb_addr_i29;
wire [7:0] 								wb_dat_i29;


reg [3:0] 								ier29;
reg [3:0] 								iir29;
reg [1:0] 								fcr29;  /// bits 7 and 6 of fcr29. Other29 bits are ignored
reg [4:0] 								mcr29;
reg [7:0] 								lcr29;
reg [7:0] 								msr29;
reg [15:0] 								dl29;  // 32-bit divisor29 latch29
reg [7:0] 								scratch29; // UART29 scratch29 register
reg 										start_dlc29; // activate29 dlc29 on writing to UART_DL129
reg 										lsr_mask_d29; // delay for lsr_mask29 condition
reg 										msi_reset29; // reset MSR29 4 lower29 bits indicator29
//reg 										threi_clear29; // THRE29 interrupt29 clear flag29
reg [15:0] 								dlc29;  // 32-bit divisor29 latch29 counter
reg 										int_o29;

reg [3:0] 								trigger_level29; // trigger level of the receiver29 FIFO
reg 										rx_reset29;
reg 										tx_reset29;

wire 										dlab29;			   // divisor29 latch29 access bit
wire 										cts_pad_i29, dsr_pad_i29, ri_pad_i29, dcd_pad_i29; // modem29 status bits
wire 										loopback29;		   // loopback29 bit (MCR29 bit 4)
wire 										cts29, dsr29, ri, dcd29;	   // effective29 signals29
wire                    cts_c29, dsr_c29, ri_c29, dcd_c29; // Complement29 effective29 signals29 (considering29 loopback29)
wire 										rts_pad_o29, dtr_pad_o29;		   // modem29 control29 outputs29

// LSR29 bits wires29 and regs
wire [7:0] 								lsr29;
wire 										lsr029, lsr129, lsr229, lsr329, lsr429, lsr529, lsr629, lsr729;
reg										lsr0r29, lsr1r29, lsr2r29, lsr3r29, lsr4r29, lsr5r29, lsr6r29, lsr7r29;
wire 										lsr_mask29; // lsr_mask29

//
// ASSINGS29
//

assign 									lsr29[7:0] = { lsr7r29, lsr6r29, lsr5r29, lsr4r29, lsr3r29, lsr2r29, lsr1r29, lsr0r29 };

assign 									{cts_pad_i29, dsr_pad_i29, ri_pad_i29, dcd_pad_i29} = modem_inputs29;
assign 									{cts29, dsr29, ri, dcd29} = ~{cts_pad_i29,dsr_pad_i29,ri_pad_i29,dcd_pad_i29};

assign                  {cts_c29, dsr_c29, ri_c29, dcd_c29} = loopback29 ? {mcr29[`UART_MC_RTS29],mcr29[`UART_MC_DTR29],mcr29[`UART_MC_OUT129],mcr29[`UART_MC_OUT229]}
                                                               : {cts_pad_i29,dsr_pad_i29,ri_pad_i29,dcd_pad_i29};

assign 									dlab29 = lcr29[`UART_LC_DL29];
assign 									loopback29 = mcr29[4];

// assign modem29 outputs29
assign 									rts_pad_o29 = mcr29[`UART_MC_RTS29];
assign 									dtr_pad_o29 = mcr29[`UART_MC_DTR29];

// Interrupt29 signals29
wire 										rls_int29;  // receiver29 line status interrupt29
wire 										rda_int29;  // receiver29 data available interrupt29
wire 										ti_int29;   // timeout indicator29 interrupt29
wire										thre_int29; // transmitter29 holding29 register empty29 interrupt29
wire 										ms_int29;   // modem29 status interrupt29

// FIFO signals29
reg 										tf_push29;
reg 										rf_pop29;
wire [`UART_FIFO_REC_WIDTH29-1:0] 	rf_data_out29;
wire 										rf_error_bit29; // an error (parity29 or framing29) is inside the fifo
wire [`UART_FIFO_COUNTER_W29-1:0] 	rf_count29;
wire [`UART_FIFO_COUNTER_W29-1:0] 	tf_count29;
wire [2:0] 								tstate29;
wire [3:0] 								rstate;
wire [9:0] 								counter_t29;

wire                      thre_set_en29; // THRE29 status is delayed29 one character29 time when a character29 is written29 to fifo.
reg  [7:0]                block_cnt29;   // While29 counter counts29, THRE29 status is blocked29 (delayed29 one character29 cycle)
reg  [7:0]                block_value29; // One29 character29 length minus29 stop bit

// Transmitter29 Instance
wire serial_out29;

uart_transmitter29 transmitter29(clk29, wb_rst_i29, lcr29, tf_push29, wb_dat_i29, enable, serial_out29, tstate29, tf_count29, tx_reset29, lsr_mask29);

  // Synchronizing29 and sampling29 serial29 RX29 input
  uart_sync_flops29    i_uart_sync_flops29
  (
    .rst_i29           (wb_rst_i29),
    .clk_i29           (clk29),
    .stage1_rst_i29    (1'b0),
    .stage1_clk_en_i29 (1'b1),
    .async_dat_i29     (srx_pad_i29),
    .sync_dat_o29      (srx_pad29)
  );
  defparam i_uart_sync_flops29.width      = 1;
  defparam i_uart_sync_flops29.init_value29 = 1'b1;

// handle loopback29
wire serial_in29 = loopback29 ? serial_out29 : srx_pad29;
assign stx_pad_o29 = loopback29 ? 1'b1 : serial_out29;

// Receiver29 Instance
uart_receiver29 receiver29(clk29, wb_rst_i29, lcr29, rf_pop29, serial_in29, enable, 
	counter_t29, rf_count29, rf_data_out29, rf_error_bit29, rf_overrun29, rx_reset29, lsr_mask29, rstate, rf_push_pulse29);


// Asynchronous29 reading here29 because the outputs29 are sampled29 in uart_wb29.v file 
always @(dl29 or dlab29 or ier29 or iir29 or scratch29
			or lcr29 or lsr29 or msr29 or rf_data_out29 or wb_addr_i29 or wb_re_i29)   // asynchrounous29 reading
begin
	case (wb_addr_i29)
		`UART_REG_RB29   : wb_dat_o29 = dlab29 ? dl29[`UART_DL129] : rf_data_out29[10:3];
		`UART_REG_IE29	: wb_dat_o29 = dlab29 ? dl29[`UART_DL229] : ier29;
		`UART_REG_II29	: wb_dat_o29 = {4'b1100,iir29};
		`UART_REG_LC29	: wb_dat_o29 = lcr29;
		`UART_REG_LS29	: wb_dat_o29 = lsr29;
		`UART_REG_MS29	: wb_dat_o29 = msr29;
		`UART_REG_SR29	: wb_dat_o29 = scratch29;
		default:  wb_dat_o29 = 8'b0; // ??
	endcase // case(wb_addr_i29)
end // always @ (dl29 or dlab29 or ier29 or iir29 or scratch29...


// rf_pop29 signal29 handling29
always @(posedge clk29 or posedge wb_rst_i29)
begin
	if (wb_rst_i29)
		rf_pop29 <= #1 0; 
	else
	if (rf_pop29)	// restore29 the signal29 to 0 after one clock29 cycle
		rf_pop29 <= #1 0;
	else
	if (wb_re_i29 && wb_addr_i29 == `UART_REG_RB29 && !dlab29)
		rf_pop29 <= #1 1; // advance29 read pointer29
end

wire 	lsr_mask_condition29;
wire 	iir_read29;
wire  msr_read29;
wire	fifo_read29;
wire	fifo_write29;

assign lsr_mask_condition29 = (wb_re_i29 && wb_addr_i29 == `UART_REG_LS29 && !dlab29);
assign iir_read29 = (wb_re_i29 && wb_addr_i29 == `UART_REG_II29 && !dlab29);
assign msr_read29 = (wb_re_i29 && wb_addr_i29 == `UART_REG_MS29 && !dlab29);
assign fifo_read29 = (wb_re_i29 && wb_addr_i29 == `UART_REG_RB29 && !dlab29);
assign fifo_write29 = (wb_we_i29 && wb_addr_i29 == `UART_REG_TR29 && !dlab29);

// lsr_mask_d29 delayed29 signal29 handling29
always @(posedge clk29 or posedge wb_rst_i29)
begin
	if (wb_rst_i29)
		lsr_mask_d29 <= #1 0;
	else // reset bits in the Line29 Status Register
		lsr_mask_d29 <= #1 lsr_mask_condition29;
end

// lsr_mask29 is rise29 detected
assign lsr_mask29 = lsr_mask_condition29 && ~lsr_mask_d29;

// msi_reset29 signal29 handling29
always @(posedge clk29 or posedge wb_rst_i29)
begin
	if (wb_rst_i29)
		msi_reset29 <= #1 1;
	else
	if (msi_reset29)
		msi_reset29 <= #1 0;
	else
	if (msr_read29)
		msi_reset29 <= #1 1; // reset bits in Modem29 Status Register
end


//
//   WRITES29 AND29 RESETS29   //
//
// Line29 Control29 Register
always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29)
		lcr29 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i29 && wb_addr_i29==`UART_REG_LC29)
		lcr29 <= #1 wb_dat_i29;

// Interrupt29 Enable29 Register or UART_DL229
always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29)
	begin
		ier29 <= #1 4'b0000; // no interrupts29 after reset
		dl29[`UART_DL229] <= #1 8'b0;
	end
	else
	if (wb_we_i29 && wb_addr_i29==`UART_REG_IE29)
		if (dlab29)
		begin
			dl29[`UART_DL229] <= #1 wb_dat_i29;
		end
		else
			ier29 <= #1 wb_dat_i29[3:0]; // ier29 uses only 4 lsb


// FIFO Control29 Register and rx_reset29, tx_reset29 signals29
always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) begin
		fcr29 <= #1 2'b11; 
		rx_reset29 <= #1 0;
		tx_reset29 <= #1 0;
	end else
	if (wb_we_i29 && wb_addr_i29==`UART_REG_FC29) begin
		fcr29 <= #1 wb_dat_i29[7:6];
		rx_reset29 <= #1 wb_dat_i29[1];
		tx_reset29 <= #1 wb_dat_i29[2];
	end else begin
		rx_reset29 <= #1 0;
		tx_reset29 <= #1 0;
	end

// Modem29 Control29 Register
always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29)
		mcr29 <= #1 5'b0; 
	else
	if (wb_we_i29 && wb_addr_i29==`UART_REG_MC29)
			mcr29 <= #1 wb_dat_i29[4:0];

// Scratch29 register
// Line29 Control29 Register
always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29)
		scratch29 <= #1 0; // 8n1 setting
	else
	if (wb_we_i29 && wb_addr_i29==`UART_REG_SR29)
		scratch29 <= #1 wb_dat_i29;

// TX_FIFO29 or UART_DL129
always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29)
	begin
		dl29[`UART_DL129]  <= #1 8'b0;
		tf_push29   <= #1 1'b0;
		start_dlc29 <= #1 1'b0;
	end
	else
	if (wb_we_i29 && wb_addr_i29==`UART_REG_TR29)
		if (dlab29)
		begin
			dl29[`UART_DL129] <= #1 wb_dat_i29;
			start_dlc29 <= #1 1'b1; // enable DL29 counter
			tf_push29 <= #1 1'b0;
		end
		else
		begin
			tf_push29   <= #1 1'b1;
			start_dlc29 <= #1 1'b0;
		end // else: !if(dlab29)
	else
	begin
		start_dlc29 <= #1 1'b0;
		tf_push29   <= #1 1'b0;
	end // else: !if(dlab29)

// Receiver29 FIFO trigger level selection logic (asynchronous29 mux29)
always @(fcr29)
	case (fcr29[`UART_FC_TL29])
		2'b00 : trigger_level29 = 1;
		2'b01 : trigger_level29 = 4;
		2'b10 : trigger_level29 = 8;
		2'b11 : trigger_level29 = 14;
	endcase // case(fcr29[`UART_FC_TL29])
	
//
//  STATUS29 REGISTERS29  //
//

// Modem29 Status Register
reg [3:0] delayed_modem_signals29;
always @(posedge clk29 or posedge wb_rst_i29)
begin
	if (wb_rst_i29)
	  begin
  		msr29 <= #1 0;
	  	delayed_modem_signals29[3:0] <= #1 0;
	  end
	else begin
		msr29[`UART_MS_DDCD29:`UART_MS_DCTS29] <= #1 msi_reset29 ? 4'b0 :
			msr29[`UART_MS_DDCD29:`UART_MS_DCTS29] | ({dcd29, ri, dsr29, cts29} ^ delayed_modem_signals29[3:0]);
		msr29[`UART_MS_CDCD29:`UART_MS_CCTS29] <= #1 {dcd_c29, ri_c29, dsr_c29, cts_c29};
		delayed_modem_signals29[3:0] <= #1 {dcd29, ri, dsr29, cts29};
	end
end


// Line29 Status Register

// activation29 conditions29
assign lsr029 = (rf_count29==0 && rf_push_pulse29);  // data in receiver29 fifo available set condition
assign lsr129 = rf_overrun29;     // Receiver29 overrun29 error
assign lsr229 = rf_data_out29[1]; // parity29 error bit
assign lsr329 = rf_data_out29[0]; // framing29 error bit
assign lsr429 = rf_data_out29[2]; // break error in the character29
assign lsr529 = (tf_count29==5'b0 && thre_set_en29);  // transmitter29 fifo is empty29
assign lsr629 = (tf_count29==5'b0 && thre_set_en29 && (tstate29 == /*`S_IDLE29 */ 0)); // transmitter29 empty29
assign lsr729 = rf_error_bit29 | rf_overrun29;

// lsr29 bit029 (receiver29 data available)
reg 	 lsr0_d29;

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr0_d29 <= #1 0;
	else lsr0_d29 <= #1 lsr029;

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr0r29 <= #1 0;
	else lsr0r29 <= #1 (rf_count29==1 && rf_pop29 && !rf_push_pulse29 || rx_reset29) ? 0 : // deassert29 condition
					  lsr0r29 || (lsr029 && ~lsr0_d29); // set on rise29 of lsr029 and keep29 asserted29 until deasserted29 

// lsr29 bit 1 (receiver29 overrun29)
reg lsr1_d29; // delayed29

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr1_d29 <= #1 0;
	else lsr1_d29 <= #1 lsr129;

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr1r29 <= #1 0;
	else	lsr1r29 <= #1	lsr_mask29 ? 0 : lsr1r29 || (lsr129 && ~lsr1_d29); // set on rise29

// lsr29 bit 2 (parity29 error)
reg lsr2_d29; // delayed29

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr2_d29 <= #1 0;
	else lsr2_d29 <= #1 lsr229;

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr2r29 <= #1 0;
	else lsr2r29 <= #1 lsr_mask29 ? 0 : lsr2r29 || (lsr229 && ~lsr2_d29); // set on rise29

// lsr29 bit 3 (framing29 error)
reg lsr3_d29; // delayed29

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr3_d29 <= #1 0;
	else lsr3_d29 <= #1 lsr329;

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr3r29 <= #1 0;
	else lsr3r29 <= #1 lsr_mask29 ? 0 : lsr3r29 || (lsr329 && ~lsr3_d29); // set on rise29

// lsr29 bit 4 (break indicator29)
reg lsr4_d29; // delayed29

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr4_d29 <= #1 0;
	else lsr4_d29 <= #1 lsr429;

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr4r29 <= #1 0;
	else lsr4r29 <= #1 lsr_mask29 ? 0 : lsr4r29 || (lsr429 && ~lsr4_d29);

// lsr29 bit 5 (transmitter29 fifo is empty29)
reg lsr5_d29;

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr5_d29 <= #1 1;
	else lsr5_d29 <= #1 lsr529;

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr5r29 <= #1 1;
	else lsr5r29 <= #1 (fifo_write29) ? 0 :  lsr5r29 || (lsr529 && ~lsr5_d29);

// lsr29 bit 6 (transmitter29 empty29 indicator29)
reg lsr6_d29;

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr6_d29 <= #1 1;
	else lsr6_d29 <= #1 lsr629;

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr6r29 <= #1 1;
	else lsr6r29 <= #1 (fifo_write29) ? 0 : lsr6r29 || (lsr629 && ~lsr6_d29);

// lsr29 bit 7 (error in fifo)
reg lsr7_d29;

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr7_d29 <= #1 0;
	else lsr7_d29 <= #1 lsr729;

always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) lsr7r29 <= #1 0;
	else lsr7r29 <= #1 lsr_mask29 ? 0 : lsr7r29 || (lsr729 && ~lsr7_d29);

// Frequency29 divider29
always @(posedge clk29 or posedge wb_rst_i29) 
begin
	if (wb_rst_i29)
		dlc29 <= #1 0;
	else
		if (start_dlc29 | ~ (|dlc29))
  			dlc29 <= #1 dl29 - 1;               // preset29 counter
		else
			dlc29 <= #1 dlc29 - 1;              // decrement counter
end

// Enable29 signal29 generation29 logic
always @(posedge clk29 or posedge wb_rst_i29)
begin
	if (wb_rst_i29)
		enable <= #1 1'b0;
	else
		if (|dl29 & ~(|dlc29))     // dl29>0 & dlc29==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying29 THRE29 status for one character29 cycle after a character29 is written29 to an empty29 fifo.
always @(lcr29)
  case (lcr29[3:0])
    4'b0000                             : block_value29 =  95; // 6 bits
    4'b0100                             : block_value29 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value29 = 111; // 7 bits
    4'b1100                             : block_value29 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value29 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value29 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value29 = 159; // 10 bits
    4'b1111                             : block_value29 = 175; // 11 bits
  endcase // case(lcr29[3:0])

// Counting29 time of one character29 minus29 stop bit
always @(posedge clk29 or posedge wb_rst_i29)
begin
  if (wb_rst_i29)
    block_cnt29 <= #1 8'd0;
  else
  if(lsr5r29 & fifo_write29)  // THRE29 bit set & write to fifo occured29
    block_cnt29 <= #1 block_value29;
  else
  if (enable & block_cnt29 != 8'b0)  // only work29 on enable times
    block_cnt29 <= #1 block_cnt29 - 1;  // decrement break counter
end // always of break condition detection29

// Generating29 THRE29 status enable signal29
assign thre_set_en29 = ~(|block_cnt29);


//
//	INTERRUPT29 LOGIC29
//

assign rls_int29  = ier29[`UART_IE_RLS29] && (lsr29[`UART_LS_OE29] || lsr29[`UART_LS_PE29] || lsr29[`UART_LS_FE29] || lsr29[`UART_LS_BI29]);
assign rda_int29  = ier29[`UART_IE_RDA29] && (rf_count29 >= {1'b0,trigger_level29});
assign thre_int29 = ier29[`UART_IE_THRE29] && lsr29[`UART_LS_TFE29];
assign ms_int29   = ier29[`UART_IE_MS29] && (| msr29[3:0]);
assign ti_int29   = ier29[`UART_IE_RDA29] && (counter_t29 == 10'b0) && (|rf_count29);

reg 	 rls_int_d29;
reg 	 thre_int_d29;
reg 	 ms_int_d29;
reg 	 ti_int_d29;
reg 	 rda_int_d29;

// delay lines29
always  @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) rls_int_d29 <= #1 0;
	else rls_int_d29 <= #1 rls_int29;

always  @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) rda_int_d29 <= #1 0;
	else rda_int_d29 <= #1 rda_int29;

always  @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) thre_int_d29 <= #1 0;
	else thre_int_d29 <= #1 thre_int29;

always  @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) ms_int_d29 <= #1 0;
	else ms_int_d29 <= #1 ms_int29;

always  @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) ti_int_d29 <= #1 0;
	else ti_int_d29 <= #1 ti_int29;

// rise29 detection29 signals29

wire 	 rls_int_rise29;
wire 	 thre_int_rise29;
wire 	 ms_int_rise29;
wire 	 ti_int_rise29;
wire 	 rda_int_rise29;

assign rda_int_rise29    = rda_int29 & ~rda_int_d29;
assign rls_int_rise29 	  = rls_int29 & ~rls_int_d29;
assign thre_int_rise29   = thre_int29 & ~thre_int_d29;
assign ms_int_rise29 	  = ms_int29 & ~ms_int_d29;
assign ti_int_rise29 	  = ti_int29 & ~ti_int_d29;

// interrupt29 pending flags29
reg 	rls_int_pnd29;
reg	rda_int_pnd29;
reg 	thre_int_pnd29;
reg 	ms_int_pnd29;
reg 	ti_int_pnd29;

// interrupt29 pending flags29 assignments29
always  @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) rls_int_pnd29 <= #1 0; 
	else 
		rls_int_pnd29 <= #1 lsr_mask29 ? 0 :  						// reset condition
							rls_int_rise29 ? 1 :						// latch29 condition
							rls_int_pnd29 && ier29[`UART_IE_RLS29];	// default operation29: remove if masked29

always  @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) rda_int_pnd29 <= #1 0; 
	else 
		rda_int_pnd29 <= #1 ((rf_count29 == {1'b0,trigger_level29}) && fifo_read29) ? 0 :  	// reset condition
							rda_int_rise29 ? 1 :						// latch29 condition
							rda_int_pnd29 && ier29[`UART_IE_RDA29];	// default operation29: remove if masked29

always  @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) thre_int_pnd29 <= #1 0; 
	else 
		thre_int_pnd29 <= #1 fifo_write29 || (iir_read29 & ~iir29[`UART_II_IP29] & iir29[`UART_II_II29] == `UART_II_THRE29)? 0 : 
							thre_int_rise29 ? 1 :
							thre_int_pnd29 && ier29[`UART_IE_THRE29];

always  @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) ms_int_pnd29 <= #1 0; 
	else 
		ms_int_pnd29 <= #1 msr_read29 ? 0 : 
							ms_int_rise29 ? 1 :
							ms_int_pnd29 && ier29[`UART_IE_MS29];

always  @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) ti_int_pnd29 <= #1 0; 
	else 
		ti_int_pnd29 <= #1 fifo_read29 ? 0 : 
							ti_int_rise29 ? 1 :
							ti_int_pnd29 && ier29[`UART_IE_RDA29];
// end of pending flags29

// INT_O29 logic
always @(posedge clk29 or posedge wb_rst_i29)
begin
	if (wb_rst_i29)	
		int_o29 <= #1 1'b0;
	else
		int_o29 <= #1 
					rls_int_pnd29		?	~lsr_mask29					:
					rda_int_pnd29		? 1								:
					ti_int_pnd29		? ~fifo_read29					:
					thre_int_pnd29	? !(fifo_write29 & iir_read29) :
					ms_int_pnd29		? ~msr_read29						:
					0;	// if no interrupt29 are pending
end


// Interrupt29 Identification29 register
always @(posedge clk29 or posedge wb_rst_i29)
begin
	if (wb_rst_i29)
		iir29 <= #1 1;
	else
	if (rls_int_pnd29)  // interrupt29 is pending
	begin
		iir29[`UART_II_II29] <= #1 `UART_II_RLS29;	// set identification29 register to correct29 value
		iir29[`UART_II_IP29] <= #1 1'b0;		// and clear the IIR29 bit 0 (interrupt29 pending)
	end else // the sequence of conditions29 determines29 priority of interrupt29 identification29
	if (rda_int29)
	begin
		iir29[`UART_II_II29] <= #1 `UART_II_RDA29;
		iir29[`UART_II_IP29] <= #1 1'b0;
	end
	else if (ti_int_pnd29)
	begin
		iir29[`UART_II_II29] <= #1 `UART_II_TI29;
		iir29[`UART_II_IP29] <= #1 1'b0;
	end
	else if (thre_int_pnd29)
	begin
		iir29[`UART_II_II29] <= #1 `UART_II_THRE29;
		iir29[`UART_II_IP29] <= #1 1'b0;
	end
	else if (ms_int_pnd29)
	begin
		iir29[`UART_II_II29] <= #1 `UART_II_MS29;
		iir29[`UART_II_IP29] <= #1 1'b0;
	end else	// no interrupt29 is pending
	begin
		iir29[`UART_II_II29] <= #1 0;
		iir29[`UART_II_IP29] <= #1 1'b1;
	end
end

endmodule
