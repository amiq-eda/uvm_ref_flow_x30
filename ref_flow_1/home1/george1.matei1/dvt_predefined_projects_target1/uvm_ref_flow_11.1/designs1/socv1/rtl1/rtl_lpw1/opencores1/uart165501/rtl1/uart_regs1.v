//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs1.v                                                 ////
////                                                              ////
////                                                              ////
////  This1 file is part of the "UART1 16550 compatible1" project1    ////
////  http1://www1.opencores1.org1/cores1/uart165501/                   ////
////                                                              ////
////  Documentation1 related1 to this project1:                      ////
////  - http1://www1.opencores1.org1/cores1/uart165501/                 ////
////                                                              ////
////  Projects1 compatibility1:                                     ////
////  - WISHBONE1                                                  ////
////  RS2321 Protocol1                                              ////
////  16550D uart1 (mostly1 supported)                              ////
////                                                              ////
////  Overview1 (main1 Features1):                                   ////
////  Registers1 of the uart1 16550 core1                            ////
////                                                              ////
////  Known1 problems1 (limits1):                                    ////
////  Inserts1 1 wait state in all WISHBONE1 transfers1              ////
////                                                              ////
////  To1 Do1:                                                      ////
////  Nothing or verification1.                                    ////
////                                                              ////
////  Author1(s):                                                  ////
////      - gorban1@opencores1.org1                                  ////
////      - Jacob1 Gorban1                                          ////
////      - Igor1 Mohor1 (igorm1@opencores1.org1)                      ////
////                                                              ////
////  Created1:        2001/05/12                                  ////
////  Last1 Updated1:   (See log1 for the revision1 history1           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright1 (C) 2000, 2001 Authors1                             ////
////                                                              ////
//// This1 source1 file may be used and distributed1 without         ////
//// restriction1 provided that this copyright1 statement1 is not    ////
//// removed from the file and that any derivative1 work1 contains1  ////
//// the original copyright1 notice1 and the associated disclaimer1. ////
////                                                              ////
//// This1 source1 file is free software1; you can redistribute1 it   ////
//// and/or modify it under the terms1 of the GNU1 Lesser1 General1   ////
//// Public1 License1 as published1 by the Free1 Software1 Foundation1; ////
//// either1 version1 2.1 of the License1, or (at your1 option) any   ////
//// later1 version1.                                               ////
////                                                              ////
//// This1 source1 is distributed1 in the hope1 that it will be       ////
//// useful1, but WITHOUT1 ANY1 WARRANTY1; without even1 the implied1   ////
//// warranty1 of MERCHANTABILITY1 or FITNESS1 FOR1 A PARTICULAR1      ////
//// PURPOSE1.  See the GNU1 Lesser1 General1 Public1 License1 for more ////
//// details1.                                                     ////
////                                                              ////
//// You should have received1 a copy of the GNU1 Lesser1 General1    ////
//// Public1 License1 along1 with this source1; if not, download1 it   ////
//// from http1://www1.opencores1.org1/lgpl1.shtml1                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS1 Revision1 History1
//
// $Log: not supported by cvs2svn1 $
// Revision1 1.41  2004/05/21 11:44:41  tadejm1
// Added1 synchronizer1 flops1 for RX1 input.
//
// Revision1 1.40  2003/06/11 16:37:47  gorban1
// This1 fixes1 errors1 in some1 cases1 when data is being read and put to the FIFO at the same time. Patch1 is submitted1 by Scott1 Furman1. Update is very1 recommended1.
//
// Revision1 1.39  2002/07/29 21:16:18  gorban1
// The uart_defines1.v file is included1 again1 in sources1.
//
// Revision1 1.38  2002/07/22 23:02:23  gorban1
// Bug1 Fixes1:
//  * Possible1 loss of sync and bad1 reception1 of stop bit on slow1 baud1 rates1 fixed1.
//   Problem1 reported1 by Kenny1.Tung1.
//  * Bad (or lack1 of ) loopback1 handling1 fixed1. Reported1 by Cherry1 Withers1.
//
// Improvements1:
//  * Made1 FIFO's as general1 inferrable1 memory where possible1.
//  So1 on FPGA1 they should be inferred1 as RAM1 (Distributed1 RAM1 on Xilinx1).
//  This1 saves1 about1 1/3 of the Slice1 count and reduces1 P&R and synthesis1 times.
//
//  * Added1 optional1 baudrate1 output (baud_o1).
//  This1 is identical1 to BAUDOUT1* signal1 on 16550 chip1.
//  It outputs1 16xbit_clock_rate - the divided1 clock1.
//  It's disabled by default. Define1 UART_HAS_BAUDRATE_OUTPUT1 to use.
//
// Revision1 1.37  2001/12/27 13:24:09  mohor1
// lsr1[7] was not showing1 overrun1 errors1.
//
// Revision1 1.36  2001/12/20 13:25:46  mohor1
// rx1 push1 changed to be only one cycle wide1.
//
// Revision1 1.35  2001/12/19 08:03:34  mohor1
// Warnings1 cleared1.
//
// Revision1 1.34  2001/12/19 07:33:54  mohor1
// Synplicity1 was having1 troubles1 with the comment1.
//
// Revision1 1.33  2001/12/17 10:14:43  mohor1
// Things1 related1 to msr1 register changed. After1 THRE1 IRQ1 occurs1, and one
// character1 is written1 to the transmit1 fifo, the detection1 of the THRE1 bit in the
// LSR1 is delayed1 for one character1 time.
//
// Revision1 1.32  2001/12/14 13:19:24  mohor1
// MSR1 register fixed1.
//
// Revision1 1.31  2001/12/14 10:06:58  mohor1
// After1 reset modem1 status register MSR1 should be reset.
//
// Revision1 1.30  2001/12/13 10:09:13  mohor1
// thre1 irq1 should be cleared1 only when being source1 of interrupt1.
//
// Revision1 1.29  2001/12/12 09:05:46  mohor1
// LSR1 status bit 0 was not cleared1 correctly in case of reseting1 the FCR1 (rx1 fifo).
//
// Revision1 1.28  2001/12/10 19:52:41  gorban1
// Scratch1 register added
//
// Revision1 1.27  2001/12/06 14:51:04  gorban1
// Bug1 in LSR1[0] is fixed1.
// All WISHBONE1 signals1 are now sampled1, so another1 wait-state is introduced1 on all transfers1.
//
// Revision1 1.26  2001/12/03 21:44:29  gorban1
// Updated1 specification1 documentation.
// Added1 full 32-bit data bus interface, now as default.
// Address is 5-bit wide1 in 32-bit data bus mode.
// Added1 wb_sel_i1 input to the core1. It's used in the 32-bit mode.
// Added1 debug1 interface with two1 32-bit read-only registers in 32-bit mode.
// Bits1 5 and 6 of LSR1 are now only cleared1 on TX1 FIFO write.
// My1 small test bench1 is modified to work1 with 32-bit mode.
//
// Revision1 1.25  2001/11/28 19:36:39  gorban1
// Fixed1: timeout and break didn1't pay1 attention1 to current data format1 when counting1 time
//
// Revision1 1.24  2001/11/26 21:38:54  gorban1
// Lots1 of fixes1:
// Break1 condition wasn1't handled1 correctly at all.
// LSR1 bits could lose1 their1 values.
// LSR1 value after reset was wrong1.
// Timing1 of THRE1 interrupt1 signal1 corrected1.
// LSR1 bit 0 timing1 corrected1.
//
// Revision1 1.23  2001/11/12 21:57:29  gorban1
// fixed1 more typo1 bugs1
//
// Revision1 1.22  2001/11/12 15:02:28  mohor1
// lsr1r1 error fixed1.
//
// Revision1 1.21  2001/11/12 14:57:27  mohor1
// ti_int_pnd1 error fixed1.
//
// Revision1 1.20  2001/11/12 14:50:27  mohor1
// ti_int_d1 error fixed1.
//
// Revision1 1.19  2001/11/10 12:43:21  gorban1
// Logic1 Synthesis1 bugs1 fixed1. Some1 other minor1 changes1
//
// Revision1 1.18  2001/11/08 14:54:23  mohor1
// Comments1 in Slovene1 language1 deleted1, few1 small fixes1 for better1 work1 of
// old1 tools1. IRQs1 need to be fix1.
//
// Revision1 1.17  2001/11/07 17:51:52  gorban1
// Heavily1 rewritten1 interrupt1 and LSR1 subsystems1.
// Many1 bugs1 hopefully1 squashed1.
//
// Revision1 1.16  2001/11/02 09:55:16  mohor1
// no message
//
// Revision1 1.15  2001/10/31 15:19:22  gorban1
// Fixes1 to break and timeout conditions1
//
// Revision1 1.14  2001/10/29 17:00:46  gorban1
// fixed1 parity1 sending1 and tx_fifo1 resets1 over- and underrun1
//
// Revision1 1.13  2001/10/20 09:58:40  gorban1
// Small1 synopsis1 fixes1
//
// Revision1 1.12  2001/10/19 16:21:40  gorban1
// Changes1 data_out1 to be synchronous1 again1 as it should have been.
//
// Revision1 1.11  2001/10/18 20:35:45  gorban1
// small fix1
//
// Revision1 1.10  2001/08/24 21:01:12  mohor1
// Things1 connected1 to parity1 changed.
// Clock1 devider1 changed.
//
// Revision1 1.9  2001/08/23 16:05:05  mohor1
// Stop bit bug1 fixed1.
// Parity1 bug1 fixed1.
// WISHBONE1 read cycle bug1 fixed1,
// OE1 indicator1 (Overrun1 Error) bug1 fixed1.
// PE1 indicator1 (Parity1 Error) bug1 fixed1.
// Register read bug1 fixed1.
//
// Revision1 1.10  2001/06/23 11:21:48  gorban1
// DL1 made1 16-bit long1. Fixed1 transmission1/reception1 bugs1.
//
// Revision1 1.9  2001/05/31 20:08:01  gorban1
// FIFO changes1 and other corrections1.
//
// Revision1 1.8  2001/05/29 20:05:04  gorban1
// Fixed1 some1 bugs1 and synthesis1 problems1.
//
// Revision1 1.7  2001/05/27 17:37:49  gorban1
// Fixed1 many1 bugs1. Updated1 spec1. Changed1 FIFO files structure1. See CHANGES1.txt1 file.
//
// Revision1 1.6  2001/05/21 19:12:02  gorban1
// Corrected1 some1 Linter1 messages1.
//
// Revision1 1.5  2001/05/17 18:34:18  gorban1
// First1 'stable' release. Should1 be sythesizable1 now. Also1 added new header.
//
// Revision1 1.0  2001-05-17 21:27:11+02  jacob1
// Initial1 revision1
//
//

// synopsys1 translate_off1
`include "timescale.v"
// synopsys1 translate_on1

`include "uart_defines1.v"

`define UART_DL11 7:0
`define UART_DL21 15:8

module uart_regs1 (clk1,
	wb_rst_i1, wb_addr_i1, wb_dat_i1, wb_dat_o1, wb_we_i1, wb_re_i1, 

// additional1 signals1
	modem_inputs1,
	stx_pad_o1, srx_pad_i1,

`ifdef DATA_BUS_WIDTH_81
`else
// debug1 interface signals1	enabled
ier1, iir1, fcr1, mcr1, lcr1, msr1, lsr1, rf_count1, tf_count1, tstate1, rstate,
`endif				
	rts_pad_o1, dtr_pad_o1, int_o1
`ifdef UART_HAS_BAUDRATE_OUTPUT1
	, baud_o1
`endif

	);

input 									clk1;
input 									wb_rst_i1;
input [`UART_ADDR_WIDTH1-1:0] 		wb_addr_i1;
input [7:0] 							wb_dat_i1;
output [7:0] 							wb_dat_o1;
input 									wb_we_i1;
input 									wb_re_i1;

output 									stx_pad_o1;
input 									srx_pad_i1;

input [3:0] 							modem_inputs1;
output 									rts_pad_o1;
output 									dtr_pad_o1;
output 									int_o1;
`ifdef UART_HAS_BAUDRATE_OUTPUT1
output	baud_o1;
`endif

`ifdef DATA_BUS_WIDTH_81
`else
// if 32-bit databus1 and debug1 interface are enabled
output [3:0]							ier1;
output [3:0]							iir1;
output [1:0]							fcr1;  /// bits 7 and 6 of fcr1. Other1 bits are ignored
output [4:0]							mcr1;
output [7:0]							lcr1;
output [7:0]							msr1;
output [7:0] 							lsr1;
output [`UART_FIFO_COUNTER_W1-1:0] 	rf_count1;
output [`UART_FIFO_COUNTER_W1-1:0] 	tf_count1;
output [2:0] 							tstate1;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs1;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT1
assign baud_o1 = enable; // baud_o1 is actually1 the enable signal1
`endif


wire 										stx_pad_o1;		// received1 from transmitter1 module
wire 										srx_pad_i1;
wire 										srx_pad1;

reg [7:0] 								wb_dat_o1;

wire [`UART_ADDR_WIDTH1-1:0] 		wb_addr_i1;
wire [7:0] 								wb_dat_i1;


reg [3:0] 								ier1;
reg [3:0] 								iir1;
reg [1:0] 								fcr1;  /// bits 7 and 6 of fcr1. Other1 bits are ignored
reg [4:0] 								mcr1;
reg [7:0] 								lcr1;
reg [7:0] 								msr1;
reg [15:0] 								dl1;  // 32-bit divisor1 latch1
reg [7:0] 								scratch1; // UART1 scratch1 register
reg 										start_dlc1; // activate1 dlc1 on writing to UART_DL11
reg 										lsr_mask_d1; // delay for lsr_mask1 condition
reg 										msi_reset1; // reset MSR1 4 lower1 bits indicator1
//reg 										threi_clear1; // THRE1 interrupt1 clear flag1
reg [15:0] 								dlc1;  // 32-bit divisor1 latch1 counter
reg 										int_o1;

reg [3:0] 								trigger_level1; // trigger level of the receiver1 FIFO
reg 										rx_reset1;
reg 										tx_reset1;

wire 										dlab1;			   // divisor1 latch1 access bit
wire 										cts_pad_i1, dsr_pad_i1, ri_pad_i1, dcd_pad_i1; // modem1 status bits
wire 										loopback1;		   // loopback1 bit (MCR1 bit 4)
wire 										cts1, dsr1, ri, dcd1;	   // effective1 signals1
wire                    cts_c1, dsr_c1, ri_c1, dcd_c1; // Complement1 effective1 signals1 (considering1 loopback1)
wire 										rts_pad_o1, dtr_pad_o1;		   // modem1 control1 outputs1

// LSR1 bits wires1 and regs
wire [7:0] 								lsr1;
wire 										lsr01, lsr11, lsr21, lsr31, lsr41, lsr51, lsr61, lsr71;
reg										lsr0r1, lsr1r1, lsr2r1, lsr3r1, lsr4r1, lsr5r1, lsr6r1, lsr7r1;
wire 										lsr_mask1; // lsr_mask1

//
// ASSINGS1
//

assign 									lsr1[7:0] = { lsr7r1, lsr6r1, lsr5r1, lsr4r1, lsr3r1, lsr2r1, lsr1r1, lsr0r1 };

assign 									{cts_pad_i1, dsr_pad_i1, ri_pad_i1, dcd_pad_i1} = modem_inputs1;
assign 									{cts1, dsr1, ri, dcd1} = ~{cts_pad_i1,dsr_pad_i1,ri_pad_i1,dcd_pad_i1};

assign                  {cts_c1, dsr_c1, ri_c1, dcd_c1} = loopback1 ? {mcr1[`UART_MC_RTS1],mcr1[`UART_MC_DTR1],mcr1[`UART_MC_OUT11],mcr1[`UART_MC_OUT21]}
                                                               : {cts_pad_i1,dsr_pad_i1,ri_pad_i1,dcd_pad_i1};

assign 									dlab1 = lcr1[`UART_LC_DL1];
assign 									loopback1 = mcr1[4];

// assign modem1 outputs1
assign 									rts_pad_o1 = mcr1[`UART_MC_RTS1];
assign 									dtr_pad_o1 = mcr1[`UART_MC_DTR1];

// Interrupt1 signals1
wire 										rls_int1;  // receiver1 line status interrupt1
wire 										rda_int1;  // receiver1 data available interrupt1
wire 										ti_int1;   // timeout indicator1 interrupt1
wire										thre_int1; // transmitter1 holding1 register empty1 interrupt1
wire 										ms_int1;   // modem1 status interrupt1

// FIFO signals1
reg 										tf_push1;
reg 										rf_pop1;
wire [`UART_FIFO_REC_WIDTH1-1:0] 	rf_data_out1;
wire 										rf_error_bit1; // an error (parity1 or framing1) is inside the fifo
wire [`UART_FIFO_COUNTER_W1-1:0] 	rf_count1;
wire [`UART_FIFO_COUNTER_W1-1:0] 	tf_count1;
wire [2:0] 								tstate1;
wire [3:0] 								rstate;
wire [9:0] 								counter_t1;

wire                      thre_set_en1; // THRE1 status is delayed1 one character1 time when a character1 is written1 to fifo.
reg  [7:0]                block_cnt1;   // While1 counter counts1, THRE1 status is blocked1 (delayed1 one character1 cycle)
reg  [7:0]                block_value1; // One1 character1 length minus1 stop bit

// Transmitter1 Instance
wire serial_out1;

uart_transmitter1 transmitter1(clk1, wb_rst_i1, lcr1, tf_push1, wb_dat_i1, enable, serial_out1, tstate1, tf_count1, tx_reset1, lsr_mask1);

  // Synchronizing1 and sampling1 serial1 RX1 input
  uart_sync_flops1    i_uart_sync_flops1
  (
    .rst_i1           (wb_rst_i1),
    .clk_i1           (clk1),
    .stage1_rst_i1    (1'b0),
    .stage1_clk_en_i1 (1'b1),
    .async_dat_i1     (srx_pad_i1),
    .sync_dat_o1      (srx_pad1)
  );
  defparam i_uart_sync_flops1.width      = 1;
  defparam i_uart_sync_flops1.init_value1 = 1'b1;

// handle loopback1
wire serial_in1 = loopback1 ? serial_out1 : srx_pad1;
assign stx_pad_o1 = loopback1 ? 1'b1 : serial_out1;

// Receiver1 Instance
uart_receiver1 receiver1(clk1, wb_rst_i1, lcr1, rf_pop1, serial_in1, enable, 
	counter_t1, rf_count1, rf_data_out1, rf_error_bit1, rf_overrun1, rx_reset1, lsr_mask1, rstate, rf_push_pulse1);


// Asynchronous1 reading here1 because the outputs1 are sampled1 in uart_wb1.v file 
always @(dl1 or dlab1 or ier1 or iir1 or scratch1
			or lcr1 or lsr1 or msr1 or rf_data_out1 or wb_addr_i1 or wb_re_i1)   // asynchrounous1 reading
begin
	case (wb_addr_i1)
		`UART_REG_RB1   : wb_dat_o1 = dlab1 ? dl1[`UART_DL11] : rf_data_out1[10:3];
		`UART_REG_IE1	: wb_dat_o1 = dlab1 ? dl1[`UART_DL21] : ier1;
		`UART_REG_II1	: wb_dat_o1 = {4'b1100,iir1};
		`UART_REG_LC1	: wb_dat_o1 = lcr1;
		`UART_REG_LS1	: wb_dat_o1 = lsr1;
		`UART_REG_MS1	: wb_dat_o1 = msr1;
		`UART_REG_SR1	: wb_dat_o1 = scratch1;
		default:  wb_dat_o1 = 8'b0; // ??
	endcase // case(wb_addr_i1)
end // always @ (dl1 or dlab1 or ier1 or iir1 or scratch1...


// rf_pop1 signal1 handling1
always @(posedge clk1 or posedge wb_rst_i1)
begin
	if (wb_rst_i1)
		rf_pop1 <= #1 0; 
	else
	if (rf_pop1)	// restore1 the signal1 to 0 after one clock1 cycle
		rf_pop1 <= #1 0;
	else
	if (wb_re_i1 && wb_addr_i1 == `UART_REG_RB1 && !dlab1)
		rf_pop1 <= #1 1; // advance1 read pointer1
end

wire 	lsr_mask_condition1;
wire 	iir_read1;
wire  msr_read1;
wire	fifo_read1;
wire	fifo_write1;

assign lsr_mask_condition1 = (wb_re_i1 && wb_addr_i1 == `UART_REG_LS1 && !dlab1);
assign iir_read1 = (wb_re_i1 && wb_addr_i1 == `UART_REG_II1 && !dlab1);
assign msr_read1 = (wb_re_i1 && wb_addr_i1 == `UART_REG_MS1 && !dlab1);
assign fifo_read1 = (wb_re_i1 && wb_addr_i1 == `UART_REG_RB1 && !dlab1);
assign fifo_write1 = (wb_we_i1 && wb_addr_i1 == `UART_REG_TR1 && !dlab1);

// lsr_mask_d1 delayed1 signal1 handling1
always @(posedge clk1 or posedge wb_rst_i1)
begin
	if (wb_rst_i1)
		lsr_mask_d1 <= #1 0;
	else // reset bits in the Line1 Status Register
		lsr_mask_d1 <= #1 lsr_mask_condition1;
end

// lsr_mask1 is rise1 detected
assign lsr_mask1 = lsr_mask_condition1 && ~lsr_mask_d1;

// msi_reset1 signal1 handling1
always @(posedge clk1 or posedge wb_rst_i1)
begin
	if (wb_rst_i1)
		msi_reset1 <= #1 1;
	else
	if (msi_reset1)
		msi_reset1 <= #1 0;
	else
	if (msr_read1)
		msi_reset1 <= #1 1; // reset bits in Modem1 Status Register
end


//
//   WRITES1 AND1 RESETS1   //
//
// Line1 Control1 Register
always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1)
		lcr1 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i1 && wb_addr_i1==`UART_REG_LC1)
		lcr1 <= #1 wb_dat_i1;

// Interrupt1 Enable1 Register or UART_DL21
always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1)
	begin
		ier1 <= #1 4'b0000; // no interrupts1 after reset
		dl1[`UART_DL21] <= #1 8'b0;
	end
	else
	if (wb_we_i1 && wb_addr_i1==`UART_REG_IE1)
		if (dlab1)
		begin
			dl1[`UART_DL21] <= #1 wb_dat_i1;
		end
		else
			ier1 <= #1 wb_dat_i1[3:0]; // ier1 uses only 4 lsb


// FIFO Control1 Register and rx_reset1, tx_reset1 signals1
always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) begin
		fcr1 <= #1 2'b11; 
		rx_reset1 <= #1 0;
		tx_reset1 <= #1 0;
	end else
	if (wb_we_i1 && wb_addr_i1==`UART_REG_FC1) begin
		fcr1 <= #1 wb_dat_i1[7:6];
		rx_reset1 <= #1 wb_dat_i1[1];
		tx_reset1 <= #1 wb_dat_i1[2];
	end else begin
		rx_reset1 <= #1 0;
		tx_reset1 <= #1 0;
	end

// Modem1 Control1 Register
always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1)
		mcr1 <= #1 5'b0; 
	else
	if (wb_we_i1 && wb_addr_i1==`UART_REG_MC1)
			mcr1 <= #1 wb_dat_i1[4:0];

// Scratch1 register
// Line1 Control1 Register
always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1)
		scratch1 <= #1 0; // 8n1 setting
	else
	if (wb_we_i1 && wb_addr_i1==`UART_REG_SR1)
		scratch1 <= #1 wb_dat_i1;

// TX_FIFO1 or UART_DL11
always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1)
	begin
		dl1[`UART_DL11]  <= #1 8'b0;
		tf_push1   <= #1 1'b0;
		start_dlc1 <= #1 1'b0;
	end
	else
	if (wb_we_i1 && wb_addr_i1==`UART_REG_TR1)
		if (dlab1)
		begin
			dl1[`UART_DL11] <= #1 wb_dat_i1;
			start_dlc1 <= #1 1'b1; // enable DL1 counter
			tf_push1 <= #1 1'b0;
		end
		else
		begin
			tf_push1   <= #1 1'b1;
			start_dlc1 <= #1 1'b0;
		end // else: !if(dlab1)
	else
	begin
		start_dlc1 <= #1 1'b0;
		tf_push1   <= #1 1'b0;
	end // else: !if(dlab1)

// Receiver1 FIFO trigger level selection logic (asynchronous1 mux1)
always @(fcr1)
	case (fcr1[`UART_FC_TL1])
		2'b00 : trigger_level1 = 1;
		2'b01 : trigger_level1 = 4;
		2'b10 : trigger_level1 = 8;
		2'b11 : trigger_level1 = 14;
	endcase // case(fcr1[`UART_FC_TL1])
	
//
//  STATUS1 REGISTERS1  //
//

// Modem1 Status Register
reg [3:0] delayed_modem_signals1;
always @(posedge clk1 or posedge wb_rst_i1)
begin
	if (wb_rst_i1)
	  begin
  		msr1 <= #1 0;
	  	delayed_modem_signals1[3:0] <= #1 0;
	  end
	else begin
		msr1[`UART_MS_DDCD1:`UART_MS_DCTS1] <= #1 msi_reset1 ? 4'b0 :
			msr1[`UART_MS_DDCD1:`UART_MS_DCTS1] | ({dcd1, ri, dsr1, cts1} ^ delayed_modem_signals1[3:0]);
		msr1[`UART_MS_CDCD1:`UART_MS_CCTS1] <= #1 {dcd_c1, ri_c1, dsr_c1, cts_c1};
		delayed_modem_signals1[3:0] <= #1 {dcd1, ri, dsr1, cts1};
	end
end


// Line1 Status Register

// activation1 conditions1
assign lsr01 = (rf_count1==0 && rf_push_pulse1);  // data in receiver1 fifo available set condition
assign lsr11 = rf_overrun1;     // Receiver1 overrun1 error
assign lsr21 = rf_data_out1[1]; // parity1 error bit
assign lsr31 = rf_data_out1[0]; // framing1 error bit
assign lsr41 = rf_data_out1[2]; // break error in the character1
assign lsr51 = (tf_count1==5'b0 && thre_set_en1);  // transmitter1 fifo is empty1
assign lsr61 = (tf_count1==5'b0 && thre_set_en1 && (tstate1 == /*`S_IDLE1 */ 0)); // transmitter1 empty1
assign lsr71 = rf_error_bit1 | rf_overrun1;

// lsr1 bit01 (receiver1 data available)
reg 	 lsr0_d1;

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr0_d1 <= #1 0;
	else lsr0_d1 <= #1 lsr01;

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr0r1 <= #1 0;
	else lsr0r1 <= #1 (rf_count1==1 && rf_pop1 && !rf_push_pulse1 || rx_reset1) ? 0 : // deassert1 condition
					  lsr0r1 || (lsr01 && ~lsr0_d1); // set on rise1 of lsr01 and keep1 asserted1 until deasserted1 

// lsr1 bit 1 (receiver1 overrun1)
reg lsr1_d1; // delayed1

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr1_d1 <= #1 0;
	else lsr1_d1 <= #1 lsr11;

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr1r1 <= #1 0;
	else	lsr1r1 <= #1	lsr_mask1 ? 0 : lsr1r1 || (lsr11 && ~lsr1_d1); // set on rise1

// lsr1 bit 2 (parity1 error)
reg lsr2_d1; // delayed1

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr2_d1 <= #1 0;
	else lsr2_d1 <= #1 lsr21;

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr2r1 <= #1 0;
	else lsr2r1 <= #1 lsr_mask1 ? 0 : lsr2r1 || (lsr21 && ~lsr2_d1); // set on rise1

// lsr1 bit 3 (framing1 error)
reg lsr3_d1; // delayed1

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr3_d1 <= #1 0;
	else lsr3_d1 <= #1 lsr31;

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr3r1 <= #1 0;
	else lsr3r1 <= #1 lsr_mask1 ? 0 : lsr3r1 || (lsr31 && ~lsr3_d1); // set on rise1

// lsr1 bit 4 (break indicator1)
reg lsr4_d1; // delayed1

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr4_d1 <= #1 0;
	else lsr4_d1 <= #1 lsr41;

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr4r1 <= #1 0;
	else lsr4r1 <= #1 lsr_mask1 ? 0 : lsr4r1 || (lsr41 && ~lsr4_d1);

// lsr1 bit 5 (transmitter1 fifo is empty1)
reg lsr5_d1;

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr5_d1 <= #1 1;
	else lsr5_d1 <= #1 lsr51;

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr5r1 <= #1 1;
	else lsr5r1 <= #1 (fifo_write1) ? 0 :  lsr5r1 || (lsr51 && ~lsr5_d1);

// lsr1 bit 6 (transmitter1 empty1 indicator1)
reg lsr6_d1;

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr6_d1 <= #1 1;
	else lsr6_d1 <= #1 lsr61;

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr6r1 <= #1 1;
	else lsr6r1 <= #1 (fifo_write1) ? 0 : lsr6r1 || (lsr61 && ~lsr6_d1);

// lsr1 bit 7 (error in fifo)
reg lsr7_d1;

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr7_d1 <= #1 0;
	else lsr7_d1 <= #1 lsr71;

always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) lsr7r1 <= #1 0;
	else lsr7r1 <= #1 lsr_mask1 ? 0 : lsr7r1 || (lsr71 && ~lsr7_d1);

// Frequency1 divider1
always @(posedge clk1 or posedge wb_rst_i1) 
begin
	if (wb_rst_i1)
		dlc1 <= #1 0;
	else
		if (start_dlc1 | ~ (|dlc1))
  			dlc1 <= #1 dl1 - 1;               // preset1 counter
		else
			dlc1 <= #1 dlc1 - 1;              // decrement counter
end

// Enable1 signal1 generation1 logic
always @(posedge clk1 or posedge wb_rst_i1)
begin
	if (wb_rst_i1)
		enable <= #1 1'b0;
	else
		if (|dl1 & ~(|dlc1))     // dl1>0 & dlc1==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying1 THRE1 status for one character1 cycle after a character1 is written1 to an empty1 fifo.
always @(lcr1)
  case (lcr1[3:0])
    4'b0000                             : block_value1 =  95; // 6 bits
    4'b0100                             : block_value1 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value1 = 111; // 7 bits
    4'b1100                             : block_value1 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value1 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value1 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value1 = 159; // 10 bits
    4'b1111                             : block_value1 = 175; // 11 bits
  endcase // case(lcr1[3:0])

// Counting1 time of one character1 minus1 stop bit
always @(posedge clk1 or posedge wb_rst_i1)
begin
  if (wb_rst_i1)
    block_cnt1 <= #1 8'd0;
  else
  if(lsr5r1 & fifo_write1)  // THRE1 bit set & write to fifo occured1
    block_cnt1 <= #1 block_value1;
  else
  if (enable & block_cnt1 != 8'b0)  // only work1 on enable times
    block_cnt1 <= #1 block_cnt1 - 1;  // decrement break counter
end // always of break condition detection1

// Generating1 THRE1 status enable signal1
assign thre_set_en1 = ~(|block_cnt1);


//
//	INTERRUPT1 LOGIC1
//

assign rls_int1  = ier1[`UART_IE_RLS1] && (lsr1[`UART_LS_OE1] || lsr1[`UART_LS_PE1] || lsr1[`UART_LS_FE1] || lsr1[`UART_LS_BI1]);
assign rda_int1  = ier1[`UART_IE_RDA1] && (rf_count1 >= {1'b0,trigger_level1});
assign thre_int1 = ier1[`UART_IE_THRE1] && lsr1[`UART_LS_TFE1];
assign ms_int1   = ier1[`UART_IE_MS1] && (| msr1[3:0]);
assign ti_int1   = ier1[`UART_IE_RDA1] && (counter_t1 == 10'b0) && (|rf_count1);

reg 	 rls_int_d1;
reg 	 thre_int_d1;
reg 	 ms_int_d1;
reg 	 ti_int_d1;
reg 	 rda_int_d1;

// delay lines1
always  @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) rls_int_d1 <= #1 0;
	else rls_int_d1 <= #1 rls_int1;

always  @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) rda_int_d1 <= #1 0;
	else rda_int_d1 <= #1 rda_int1;

always  @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) thre_int_d1 <= #1 0;
	else thre_int_d1 <= #1 thre_int1;

always  @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) ms_int_d1 <= #1 0;
	else ms_int_d1 <= #1 ms_int1;

always  @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) ti_int_d1 <= #1 0;
	else ti_int_d1 <= #1 ti_int1;

// rise1 detection1 signals1

wire 	 rls_int_rise1;
wire 	 thre_int_rise1;
wire 	 ms_int_rise1;
wire 	 ti_int_rise1;
wire 	 rda_int_rise1;

assign rda_int_rise1    = rda_int1 & ~rda_int_d1;
assign rls_int_rise1 	  = rls_int1 & ~rls_int_d1;
assign thre_int_rise1   = thre_int1 & ~thre_int_d1;
assign ms_int_rise1 	  = ms_int1 & ~ms_int_d1;
assign ti_int_rise1 	  = ti_int1 & ~ti_int_d1;

// interrupt1 pending flags1
reg 	rls_int_pnd1;
reg	rda_int_pnd1;
reg 	thre_int_pnd1;
reg 	ms_int_pnd1;
reg 	ti_int_pnd1;

// interrupt1 pending flags1 assignments1
always  @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) rls_int_pnd1 <= #1 0; 
	else 
		rls_int_pnd1 <= #1 lsr_mask1 ? 0 :  						// reset condition
							rls_int_rise1 ? 1 :						// latch1 condition
							rls_int_pnd1 && ier1[`UART_IE_RLS1];	// default operation1: remove if masked1

always  @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) rda_int_pnd1 <= #1 0; 
	else 
		rda_int_pnd1 <= #1 ((rf_count1 == {1'b0,trigger_level1}) && fifo_read1) ? 0 :  	// reset condition
							rda_int_rise1 ? 1 :						// latch1 condition
							rda_int_pnd1 && ier1[`UART_IE_RDA1];	// default operation1: remove if masked1

always  @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) thre_int_pnd1 <= #1 0; 
	else 
		thre_int_pnd1 <= #1 fifo_write1 || (iir_read1 & ~iir1[`UART_II_IP1] & iir1[`UART_II_II1] == `UART_II_THRE1)? 0 : 
							thre_int_rise1 ? 1 :
							thre_int_pnd1 && ier1[`UART_IE_THRE1];

always  @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) ms_int_pnd1 <= #1 0; 
	else 
		ms_int_pnd1 <= #1 msr_read1 ? 0 : 
							ms_int_rise1 ? 1 :
							ms_int_pnd1 && ier1[`UART_IE_MS1];

always  @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) ti_int_pnd1 <= #1 0; 
	else 
		ti_int_pnd1 <= #1 fifo_read1 ? 0 : 
							ti_int_rise1 ? 1 :
							ti_int_pnd1 && ier1[`UART_IE_RDA1];
// end of pending flags1

// INT_O1 logic
always @(posedge clk1 or posedge wb_rst_i1)
begin
	if (wb_rst_i1)	
		int_o1 <= #1 1'b0;
	else
		int_o1 <= #1 
					rls_int_pnd1		?	~lsr_mask1					:
					rda_int_pnd1		? 1								:
					ti_int_pnd1		? ~fifo_read1					:
					thre_int_pnd1	? !(fifo_write1 & iir_read1) :
					ms_int_pnd1		? ~msr_read1						:
					0;	// if no interrupt1 are pending
end


// Interrupt1 Identification1 register
always @(posedge clk1 or posedge wb_rst_i1)
begin
	if (wb_rst_i1)
		iir1 <= #1 1;
	else
	if (rls_int_pnd1)  // interrupt1 is pending
	begin
		iir1[`UART_II_II1] <= #1 `UART_II_RLS1;	// set identification1 register to correct1 value
		iir1[`UART_II_IP1] <= #1 1'b0;		// and clear the IIR1 bit 0 (interrupt1 pending)
	end else // the sequence of conditions1 determines1 priority of interrupt1 identification1
	if (rda_int1)
	begin
		iir1[`UART_II_II1] <= #1 `UART_II_RDA1;
		iir1[`UART_II_IP1] <= #1 1'b0;
	end
	else if (ti_int_pnd1)
	begin
		iir1[`UART_II_II1] <= #1 `UART_II_TI1;
		iir1[`UART_II_IP1] <= #1 1'b0;
	end
	else if (thre_int_pnd1)
	begin
		iir1[`UART_II_II1] <= #1 `UART_II_THRE1;
		iir1[`UART_II_IP1] <= #1 1'b0;
	end
	else if (ms_int_pnd1)
	begin
		iir1[`UART_II_II1] <= #1 `UART_II_MS1;
		iir1[`UART_II_IP1] <= #1 1'b0;
	end else	// no interrupt1 is pending
	begin
		iir1[`UART_II_II1] <= #1 0;
		iir1[`UART_II_IP1] <= #1 1'b1;
	end
end

endmodule
