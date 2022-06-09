//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs25.v                                                 ////
////                                                              ////
////                                                              ////
////  This25 file is part of the "UART25 16550 compatible25" project25    ////
////  http25://www25.opencores25.org25/cores25/uart1655025/                   ////
////                                                              ////
////  Documentation25 related25 to this project25:                      ////
////  - http25://www25.opencores25.org25/cores25/uart1655025/                 ////
////                                                              ////
////  Projects25 compatibility25:                                     ////
////  - WISHBONE25                                                  ////
////  RS23225 Protocol25                                              ////
////  16550D uart25 (mostly25 supported)                              ////
////                                                              ////
////  Overview25 (main25 Features25):                                   ////
////  Registers25 of the uart25 16550 core25                            ////
////                                                              ////
////  Known25 problems25 (limits25):                                    ////
////  Inserts25 1 wait state in all WISHBONE25 transfers25              ////
////                                                              ////
////  To25 Do25:                                                      ////
////  Nothing or verification25.                                    ////
////                                                              ////
////  Author25(s):                                                  ////
////      - gorban25@opencores25.org25                                  ////
////      - Jacob25 Gorban25                                          ////
////      - Igor25 Mohor25 (igorm25@opencores25.org25)                      ////
////                                                              ////
////  Created25:        2001/05/12                                  ////
////  Last25 Updated25:   (See log25 for the revision25 history25           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2000, 2001 Authors25                             ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS25 Revision25 History25
//
// $Log: not supported by cvs2svn25 $
// Revision25 1.41  2004/05/21 11:44:41  tadejm25
// Added25 synchronizer25 flops25 for RX25 input.
//
// Revision25 1.40  2003/06/11 16:37:47  gorban25
// This25 fixes25 errors25 in some25 cases25 when data is being read and put to the FIFO at the same time. Patch25 is submitted25 by Scott25 Furman25. Update is very25 recommended25.
//
// Revision25 1.39  2002/07/29 21:16:18  gorban25
// The uart_defines25.v file is included25 again25 in sources25.
//
// Revision25 1.38  2002/07/22 23:02:23  gorban25
// Bug25 Fixes25:
//  * Possible25 loss of sync and bad25 reception25 of stop bit on slow25 baud25 rates25 fixed25.
//   Problem25 reported25 by Kenny25.Tung25.
//  * Bad (or lack25 of ) loopback25 handling25 fixed25. Reported25 by Cherry25 Withers25.
//
// Improvements25:
//  * Made25 FIFO's as general25 inferrable25 memory where possible25.
//  So25 on FPGA25 they should be inferred25 as RAM25 (Distributed25 RAM25 on Xilinx25).
//  This25 saves25 about25 1/3 of the Slice25 count and reduces25 P&R and synthesis25 times.
//
//  * Added25 optional25 baudrate25 output (baud_o25).
//  This25 is identical25 to BAUDOUT25* signal25 on 16550 chip25.
//  It outputs25 16xbit_clock_rate - the divided25 clock25.
//  It's disabled by default. Define25 UART_HAS_BAUDRATE_OUTPUT25 to use.
//
// Revision25 1.37  2001/12/27 13:24:09  mohor25
// lsr25[7] was not showing25 overrun25 errors25.
//
// Revision25 1.36  2001/12/20 13:25:46  mohor25
// rx25 push25 changed to be only one cycle wide25.
//
// Revision25 1.35  2001/12/19 08:03:34  mohor25
// Warnings25 cleared25.
//
// Revision25 1.34  2001/12/19 07:33:54  mohor25
// Synplicity25 was having25 troubles25 with the comment25.
//
// Revision25 1.33  2001/12/17 10:14:43  mohor25
// Things25 related25 to msr25 register changed. After25 THRE25 IRQ25 occurs25, and one
// character25 is written25 to the transmit25 fifo, the detection25 of the THRE25 bit in the
// LSR25 is delayed25 for one character25 time.
//
// Revision25 1.32  2001/12/14 13:19:24  mohor25
// MSR25 register fixed25.
//
// Revision25 1.31  2001/12/14 10:06:58  mohor25
// After25 reset modem25 status register MSR25 should be reset.
//
// Revision25 1.30  2001/12/13 10:09:13  mohor25
// thre25 irq25 should be cleared25 only when being source25 of interrupt25.
//
// Revision25 1.29  2001/12/12 09:05:46  mohor25
// LSR25 status bit 0 was not cleared25 correctly in case of reseting25 the FCR25 (rx25 fifo).
//
// Revision25 1.28  2001/12/10 19:52:41  gorban25
// Scratch25 register added
//
// Revision25 1.27  2001/12/06 14:51:04  gorban25
// Bug25 in LSR25[0] is fixed25.
// All WISHBONE25 signals25 are now sampled25, so another25 wait-state is introduced25 on all transfers25.
//
// Revision25 1.26  2001/12/03 21:44:29  gorban25
// Updated25 specification25 documentation.
// Added25 full 32-bit data bus interface, now as default.
// Address is 5-bit wide25 in 32-bit data bus mode.
// Added25 wb_sel_i25 input to the core25. It's used in the 32-bit mode.
// Added25 debug25 interface with two25 32-bit read-only registers in 32-bit mode.
// Bits25 5 and 6 of LSR25 are now only cleared25 on TX25 FIFO write.
// My25 small test bench25 is modified to work25 with 32-bit mode.
//
// Revision25 1.25  2001/11/28 19:36:39  gorban25
// Fixed25: timeout and break didn25't pay25 attention25 to current data format25 when counting25 time
//
// Revision25 1.24  2001/11/26 21:38:54  gorban25
// Lots25 of fixes25:
// Break25 condition wasn25't handled25 correctly at all.
// LSR25 bits could lose25 their25 values.
// LSR25 value after reset was wrong25.
// Timing25 of THRE25 interrupt25 signal25 corrected25.
// LSR25 bit 0 timing25 corrected25.
//
// Revision25 1.23  2001/11/12 21:57:29  gorban25
// fixed25 more typo25 bugs25
//
// Revision25 1.22  2001/11/12 15:02:28  mohor25
// lsr1r25 error fixed25.
//
// Revision25 1.21  2001/11/12 14:57:27  mohor25
// ti_int_pnd25 error fixed25.
//
// Revision25 1.20  2001/11/12 14:50:27  mohor25
// ti_int_d25 error fixed25.
//
// Revision25 1.19  2001/11/10 12:43:21  gorban25
// Logic25 Synthesis25 bugs25 fixed25. Some25 other minor25 changes25
//
// Revision25 1.18  2001/11/08 14:54:23  mohor25
// Comments25 in Slovene25 language25 deleted25, few25 small fixes25 for better25 work25 of
// old25 tools25. IRQs25 need to be fix25.
//
// Revision25 1.17  2001/11/07 17:51:52  gorban25
// Heavily25 rewritten25 interrupt25 and LSR25 subsystems25.
// Many25 bugs25 hopefully25 squashed25.
//
// Revision25 1.16  2001/11/02 09:55:16  mohor25
// no message
//
// Revision25 1.15  2001/10/31 15:19:22  gorban25
// Fixes25 to break and timeout conditions25
//
// Revision25 1.14  2001/10/29 17:00:46  gorban25
// fixed25 parity25 sending25 and tx_fifo25 resets25 over- and underrun25
//
// Revision25 1.13  2001/10/20 09:58:40  gorban25
// Small25 synopsis25 fixes25
//
// Revision25 1.12  2001/10/19 16:21:40  gorban25
// Changes25 data_out25 to be synchronous25 again25 as it should have been.
//
// Revision25 1.11  2001/10/18 20:35:45  gorban25
// small fix25
//
// Revision25 1.10  2001/08/24 21:01:12  mohor25
// Things25 connected25 to parity25 changed.
// Clock25 devider25 changed.
//
// Revision25 1.9  2001/08/23 16:05:05  mohor25
// Stop bit bug25 fixed25.
// Parity25 bug25 fixed25.
// WISHBONE25 read cycle bug25 fixed25,
// OE25 indicator25 (Overrun25 Error) bug25 fixed25.
// PE25 indicator25 (Parity25 Error) bug25 fixed25.
// Register read bug25 fixed25.
//
// Revision25 1.10  2001/06/23 11:21:48  gorban25
// DL25 made25 16-bit long25. Fixed25 transmission25/reception25 bugs25.
//
// Revision25 1.9  2001/05/31 20:08:01  gorban25
// FIFO changes25 and other corrections25.
//
// Revision25 1.8  2001/05/29 20:05:04  gorban25
// Fixed25 some25 bugs25 and synthesis25 problems25.
//
// Revision25 1.7  2001/05/27 17:37:49  gorban25
// Fixed25 many25 bugs25. Updated25 spec25. Changed25 FIFO files structure25. See CHANGES25.txt25 file.
//
// Revision25 1.6  2001/05/21 19:12:02  gorban25
// Corrected25 some25 Linter25 messages25.
//
// Revision25 1.5  2001/05/17 18:34:18  gorban25
// First25 'stable' release. Should25 be sythesizable25 now. Also25 added new header.
//
// Revision25 1.0  2001-05-17 21:27:11+02  jacob25
// Initial25 revision25
//
//

// synopsys25 translate_off25
`include "timescale.v"
// synopsys25 translate_on25

`include "uart_defines25.v"

`define UART_DL125 7:0
`define UART_DL225 15:8

module uart_regs25 (clk25,
	wb_rst_i25, wb_addr_i25, wb_dat_i25, wb_dat_o25, wb_we_i25, wb_re_i25, 

// additional25 signals25
	modem_inputs25,
	stx_pad_o25, srx_pad_i25,

`ifdef DATA_BUS_WIDTH_825
`else
// debug25 interface signals25	enabled
ier25, iir25, fcr25, mcr25, lcr25, msr25, lsr25, rf_count25, tf_count25, tstate25, rstate,
`endif				
	rts_pad_o25, dtr_pad_o25, int_o25
`ifdef UART_HAS_BAUDRATE_OUTPUT25
	, baud_o25
`endif

	);

input 									clk25;
input 									wb_rst_i25;
input [`UART_ADDR_WIDTH25-1:0] 		wb_addr_i25;
input [7:0] 							wb_dat_i25;
output [7:0] 							wb_dat_o25;
input 									wb_we_i25;
input 									wb_re_i25;

output 									stx_pad_o25;
input 									srx_pad_i25;

input [3:0] 							modem_inputs25;
output 									rts_pad_o25;
output 									dtr_pad_o25;
output 									int_o25;
`ifdef UART_HAS_BAUDRATE_OUTPUT25
output	baud_o25;
`endif

`ifdef DATA_BUS_WIDTH_825
`else
// if 32-bit databus25 and debug25 interface are enabled
output [3:0]							ier25;
output [3:0]							iir25;
output [1:0]							fcr25;  /// bits 7 and 6 of fcr25. Other25 bits are ignored
output [4:0]							mcr25;
output [7:0]							lcr25;
output [7:0]							msr25;
output [7:0] 							lsr25;
output [`UART_FIFO_COUNTER_W25-1:0] 	rf_count25;
output [`UART_FIFO_COUNTER_W25-1:0] 	tf_count25;
output [2:0] 							tstate25;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs25;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT25
assign baud_o25 = enable; // baud_o25 is actually25 the enable signal25
`endif


wire 										stx_pad_o25;		// received25 from transmitter25 module
wire 										srx_pad_i25;
wire 										srx_pad25;

reg [7:0] 								wb_dat_o25;

wire [`UART_ADDR_WIDTH25-1:0] 		wb_addr_i25;
wire [7:0] 								wb_dat_i25;


reg [3:0] 								ier25;
reg [3:0] 								iir25;
reg [1:0] 								fcr25;  /// bits 7 and 6 of fcr25. Other25 bits are ignored
reg [4:0] 								mcr25;
reg [7:0] 								lcr25;
reg [7:0] 								msr25;
reg [15:0] 								dl25;  // 32-bit divisor25 latch25
reg [7:0] 								scratch25; // UART25 scratch25 register
reg 										start_dlc25; // activate25 dlc25 on writing to UART_DL125
reg 										lsr_mask_d25; // delay for lsr_mask25 condition
reg 										msi_reset25; // reset MSR25 4 lower25 bits indicator25
//reg 										threi_clear25; // THRE25 interrupt25 clear flag25
reg [15:0] 								dlc25;  // 32-bit divisor25 latch25 counter
reg 										int_o25;

reg [3:0] 								trigger_level25; // trigger level of the receiver25 FIFO
reg 										rx_reset25;
reg 										tx_reset25;

wire 										dlab25;			   // divisor25 latch25 access bit
wire 										cts_pad_i25, dsr_pad_i25, ri_pad_i25, dcd_pad_i25; // modem25 status bits
wire 										loopback25;		   // loopback25 bit (MCR25 bit 4)
wire 										cts25, dsr25, ri, dcd25;	   // effective25 signals25
wire                    cts_c25, dsr_c25, ri_c25, dcd_c25; // Complement25 effective25 signals25 (considering25 loopback25)
wire 										rts_pad_o25, dtr_pad_o25;		   // modem25 control25 outputs25

// LSR25 bits wires25 and regs
wire [7:0] 								lsr25;
wire 										lsr025, lsr125, lsr225, lsr325, lsr425, lsr525, lsr625, lsr725;
reg										lsr0r25, lsr1r25, lsr2r25, lsr3r25, lsr4r25, lsr5r25, lsr6r25, lsr7r25;
wire 										lsr_mask25; // lsr_mask25

//
// ASSINGS25
//

assign 									lsr25[7:0] = { lsr7r25, lsr6r25, lsr5r25, lsr4r25, lsr3r25, lsr2r25, lsr1r25, lsr0r25 };

assign 									{cts_pad_i25, dsr_pad_i25, ri_pad_i25, dcd_pad_i25} = modem_inputs25;
assign 									{cts25, dsr25, ri, dcd25} = ~{cts_pad_i25,dsr_pad_i25,ri_pad_i25,dcd_pad_i25};

assign                  {cts_c25, dsr_c25, ri_c25, dcd_c25} = loopback25 ? {mcr25[`UART_MC_RTS25],mcr25[`UART_MC_DTR25],mcr25[`UART_MC_OUT125],mcr25[`UART_MC_OUT225]}
                                                               : {cts_pad_i25,dsr_pad_i25,ri_pad_i25,dcd_pad_i25};

assign 									dlab25 = lcr25[`UART_LC_DL25];
assign 									loopback25 = mcr25[4];

// assign modem25 outputs25
assign 									rts_pad_o25 = mcr25[`UART_MC_RTS25];
assign 									dtr_pad_o25 = mcr25[`UART_MC_DTR25];

// Interrupt25 signals25
wire 										rls_int25;  // receiver25 line status interrupt25
wire 										rda_int25;  // receiver25 data available interrupt25
wire 										ti_int25;   // timeout indicator25 interrupt25
wire										thre_int25; // transmitter25 holding25 register empty25 interrupt25
wire 										ms_int25;   // modem25 status interrupt25

// FIFO signals25
reg 										tf_push25;
reg 										rf_pop25;
wire [`UART_FIFO_REC_WIDTH25-1:0] 	rf_data_out25;
wire 										rf_error_bit25; // an error (parity25 or framing25) is inside the fifo
wire [`UART_FIFO_COUNTER_W25-1:0] 	rf_count25;
wire [`UART_FIFO_COUNTER_W25-1:0] 	tf_count25;
wire [2:0] 								tstate25;
wire [3:0] 								rstate;
wire [9:0] 								counter_t25;

wire                      thre_set_en25; // THRE25 status is delayed25 one character25 time when a character25 is written25 to fifo.
reg  [7:0]                block_cnt25;   // While25 counter counts25, THRE25 status is blocked25 (delayed25 one character25 cycle)
reg  [7:0]                block_value25; // One25 character25 length minus25 stop bit

// Transmitter25 Instance
wire serial_out25;

uart_transmitter25 transmitter25(clk25, wb_rst_i25, lcr25, tf_push25, wb_dat_i25, enable, serial_out25, tstate25, tf_count25, tx_reset25, lsr_mask25);

  // Synchronizing25 and sampling25 serial25 RX25 input
  uart_sync_flops25    i_uart_sync_flops25
  (
    .rst_i25           (wb_rst_i25),
    .clk_i25           (clk25),
    .stage1_rst_i25    (1'b0),
    .stage1_clk_en_i25 (1'b1),
    .async_dat_i25     (srx_pad_i25),
    .sync_dat_o25      (srx_pad25)
  );
  defparam i_uart_sync_flops25.width      = 1;
  defparam i_uart_sync_flops25.init_value25 = 1'b1;

// handle loopback25
wire serial_in25 = loopback25 ? serial_out25 : srx_pad25;
assign stx_pad_o25 = loopback25 ? 1'b1 : serial_out25;

// Receiver25 Instance
uart_receiver25 receiver25(clk25, wb_rst_i25, lcr25, rf_pop25, serial_in25, enable, 
	counter_t25, rf_count25, rf_data_out25, rf_error_bit25, rf_overrun25, rx_reset25, lsr_mask25, rstate, rf_push_pulse25);


// Asynchronous25 reading here25 because the outputs25 are sampled25 in uart_wb25.v file 
always @(dl25 or dlab25 or ier25 or iir25 or scratch25
			or lcr25 or lsr25 or msr25 or rf_data_out25 or wb_addr_i25 or wb_re_i25)   // asynchrounous25 reading
begin
	case (wb_addr_i25)
		`UART_REG_RB25   : wb_dat_o25 = dlab25 ? dl25[`UART_DL125] : rf_data_out25[10:3];
		`UART_REG_IE25	: wb_dat_o25 = dlab25 ? dl25[`UART_DL225] : ier25;
		`UART_REG_II25	: wb_dat_o25 = {4'b1100,iir25};
		`UART_REG_LC25	: wb_dat_o25 = lcr25;
		`UART_REG_LS25	: wb_dat_o25 = lsr25;
		`UART_REG_MS25	: wb_dat_o25 = msr25;
		`UART_REG_SR25	: wb_dat_o25 = scratch25;
		default:  wb_dat_o25 = 8'b0; // ??
	endcase // case(wb_addr_i25)
end // always @ (dl25 or dlab25 or ier25 or iir25 or scratch25...


// rf_pop25 signal25 handling25
always @(posedge clk25 or posedge wb_rst_i25)
begin
	if (wb_rst_i25)
		rf_pop25 <= #1 0; 
	else
	if (rf_pop25)	// restore25 the signal25 to 0 after one clock25 cycle
		rf_pop25 <= #1 0;
	else
	if (wb_re_i25 && wb_addr_i25 == `UART_REG_RB25 && !dlab25)
		rf_pop25 <= #1 1; // advance25 read pointer25
end

wire 	lsr_mask_condition25;
wire 	iir_read25;
wire  msr_read25;
wire	fifo_read25;
wire	fifo_write25;

assign lsr_mask_condition25 = (wb_re_i25 && wb_addr_i25 == `UART_REG_LS25 && !dlab25);
assign iir_read25 = (wb_re_i25 && wb_addr_i25 == `UART_REG_II25 && !dlab25);
assign msr_read25 = (wb_re_i25 && wb_addr_i25 == `UART_REG_MS25 && !dlab25);
assign fifo_read25 = (wb_re_i25 && wb_addr_i25 == `UART_REG_RB25 && !dlab25);
assign fifo_write25 = (wb_we_i25 && wb_addr_i25 == `UART_REG_TR25 && !dlab25);

// lsr_mask_d25 delayed25 signal25 handling25
always @(posedge clk25 or posedge wb_rst_i25)
begin
	if (wb_rst_i25)
		lsr_mask_d25 <= #1 0;
	else // reset bits in the Line25 Status Register
		lsr_mask_d25 <= #1 lsr_mask_condition25;
end

// lsr_mask25 is rise25 detected
assign lsr_mask25 = lsr_mask_condition25 && ~lsr_mask_d25;

// msi_reset25 signal25 handling25
always @(posedge clk25 or posedge wb_rst_i25)
begin
	if (wb_rst_i25)
		msi_reset25 <= #1 1;
	else
	if (msi_reset25)
		msi_reset25 <= #1 0;
	else
	if (msr_read25)
		msi_reset25 <= #1 1; // reset bits in Modem25 Status Register
end


//
//   WRITES25 AND25 RESETS25   //
//
// Line25 Control25 Register
always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25)
		lcr25 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i25 && wb_addr_i25==`UART_REG_LC25)
		lcr25 <= #1 wb_dat_i25;

// Interrupt25 Enable25 Register or UART_DL225
always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25)
	begin
		ier25 <= #1 4'b0000; // no interrupts25 after reset
		dl25[`UART_DL225] <= #1 8'b0;
	end
	else
	if (wb_we_i25 && wb_addr_i25==`UART_REG_IE25)
		if (dlab25)
		begin
			dl25[`UART_DL225] <= #1 wb_dat_i25;
		end
		else
			ier25 <= #1 wb_dat_i25[3:0]; // ier25 uses only 4 lsb


// FIFO Control25 Register and rx_reset25, tx_reset25 signals25
always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) begin
		fcr25 <= #1 2'b11; 
		rx_reset25 <= #1 0;
		tx_reset25 <= #1 0;
	end else
	if (wb_we_i25 && wb_addr_i25==`UART_REG_FC25) begin
		fcr25 <= #1 wb_dat_i25[7:6];
		rx_reset25 <= #1 wb_dat_i25[1];
		tx_reset25 <= #1 wb_dat_i25[2];
	end else begin
		rx_reset25 <= #1 0;
		tx_reset25 <= #1 0;
	end

// Modem25 Control25 Register
always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25)
		mcr25 <= #1 5'b0; 
	else
	if (wb_we_i25 && wb_addr_i25==`UART_REG_MC25)
			mcr25 <= #1 wb_dat_i25[4:0];

// Scratch25 register
// Line25 Control25 Register
always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25)
		scratch25 <= #1 0; // 8n1 setting
	else
	if (wb_we_i25 && wb_addr_i25==`UART_REG_SR25)
		scratch25 <= #1 wb_dat_i25;

// TX_FIFO25 or UART_DL125
always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25)
	begin
		dl25[`UART_DL125]  <= #1 8'b0;
		tf_push25   <= #1 1'b0;
		start_dlc25 <= #1 1'b0;
	end
	else
	if (wb_we_i25 && wb_addr_i25==`UART_REG_TR25)
		if (dlab25)
		begin
			dl25[`UART_DL125] <= #1 wb_dat_i25;
			start_dlc25 <= #1 1'b1; // enable DL25 counter
			tf_push25 <= #1 1'b0;
		end
		else
		begin
			tf_push25   <= #1 1'b1;
			start_dlc25 <= #1 1'b0;
		end // else: !if(dlab25)
	else
	begin
		start_dlc25 <= #1 1'b0;
		tf_push25   <= #1 1'b0;
	end // else: !if(dlab25)

// Receiver25 FIFO trigger level selection logic (asynchronous25 mux25)
always @(fcr25)
	case (fcr25[`UART_FC_TL25])
		2'b00 : trigger_level25 = 1;
		2'b01 : trigger_level25 = 4;
		2'b10 : trigger_level25 = 8;
		2'b11 : trigger_level25 = 14;
	endcase // case(fcr25[`UART_FC_TL25])
	
//
//  STATUS25 REGISTERS25  //
//

// Modem25 Status Register
reg [3:0] delayed_modem_signals25;
always @(posedge clk25 or posedge wb_rst_i25)
begin
	if (wb_rst_i25)
	  begin
  		msr25 <= #1 0;
	  	delayed_modem_signals25[3:0] <= #1 0;
	  end
	else begin
		msr25[`UART_MS_DDCD25:`UART_MS_DCTS25] <= #1 msi_reset25 ? 4'b0 :
			msr25[`UART_MS_DDCD25:`UART_MS_DCTS25] | ({dcd25, ri, dsr25, cts25} ^ delayed_modem_signals25[3:0]);
		msr25[`UART_MS_CDCD25:`UART_MS_CCTS25] <= #1 {dcd_c25, ri_c25, dsr_c25, cts_c25};
		delayed_modem_signals25[3:0] <= #1 {dcd25, ri, dsr25, cts25};
	end
end


// Line25 Status Register

// activation25 conditions25
assign lsr025 = (rf_count25==0 && rf_push_pulse25);  // data in receiver25 fifo available set condition
assign lsr125 = rf_overrun25;     // Receiver25 overrun25 error
assign lsr225 = rf_data_out25[1]; // parity25 error bit
assign lsr325 = rf_data_out25[0]; // framing25 error bit
assign lsr425 = rf_data_out25[2]; // break error in the character25
assign lsr525 = (tf_count25==5'b0 && thre_set_en25);  // transmitter25 fifo is empty25
assign lsr625 = (tf_count25==5'b0 && thre_set_en25 && (tstate25 == /*`S_IDLE25 */ 0)); // transmitter25 empty25
assign lsr725 = rf_error_bit25 | rf_overrun25;

// lsr25 bit025 (receiver25 data available)
reg 	 lsr0_d25;

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr0_d25 <= #1 0;
	else lsr0_d25 <= #1 lsr025;

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr0r25 <= #1 0;
	else lsr0r25 <= #1 (rf_count25==1 && rf_pop25 && !rf_push_pulse25 || rx_reset25) ? 0 : // deassert25 condition
					  lsr0r25 || (lsr025 && ~lsr0_d25); // set on rise25 of lsr025 and keep25 asserted25 until deasserted25 

// lsr25 bit 1 (receiver25 overrun25)
reg lsr1_d25; // delayed25

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr1_d25 <= #1 0;
	else lsr1_d25 <= #1 lsr125;

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr1r25 <= #1 0;
	else	lsr1r25 <= #1	lsr_mask25 ? 0 : lsr1r25 || (lsr125 && ~lsr1_d25); // set on rise25

// lsr25 bit 2 (parity25 error)
reg lsr2_d25; // delayed25

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr2_d25 <= #1 0;
	else lsr2_d25 <= #1 lsr225;

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr2r25 <= #1 0;
	else lsr2r25 <= #1 lsr_mask25 ? 0 : lsr2r25 || (lsr225 && ~lsr2_d25); // set on rise25

// lsr25 bit 3 (framing25 error)
reg lsr3_d25; // delayed25

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr3_d25 <= #1 0;
	else lsr3_d25 <= #1 lsr325;

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr3r25 <= #1 0;
	else lsr3r25 <= #1 lsr_mask25 ? 0 : lsr3r25 || (lsr325 && ~lsr3_d25); // set on rise25

// lsr25 bit 4 (break indicator25)
reg lsr4_d25; // delayed25

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr4_d25 <= #1 0;
	else lsr4_d25 <= #1 lsr425;

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr4r25 <= #1 0;
	else lsr4r25 <= #1 lsr_mask25 ? 0 : lsr4r25 || (lsr425 && ~lsr4_d25);

// lsr25 bit 5 (transmitter25 fifo is empty25)
reg lsr5_d25;

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr5_d25 <= #1 1;
	else lsr5_d25 <= #1 lsr525;

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr5r25 <= #1 1;
	else lsr5r25 <= #1 (fifo_write25) ? 0 :  lsr5r25 || (lsr525 && ~lsr5_d25);

// lsr25 bit 6 (transmitter25 empty25 indicator25)
reg lsr6_d25;

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr6_d25 <= #1 1;
	else lsr6_d25 <= #1 lsr625;

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr6r25 <= #1 1;
	else lsr6r25 <= #1 (fifo_write25) ? 0 : lsr6r25 || (lsr625 && ~lsr6_d25);

// lsr25 bit 7 (error in fifo)
reg lsr7_d25;

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr7_d25 <= #1 0;
	else lsr7_d25 <= #1 lsr725;

always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) lsr7r25 <= #1 0;
	else lsr7r25 <= #1 lsr_mask25 ? 0 : lsr7r25 || (lsr725 && ~lsr7_d25);

// Frequency25 divider25
always @(posedge clk25 or posedge wb_rst_i25) 
begin
	if (wb_rst_i25)
		dlc25 <= #1 0;
	else
		if (start_dlc25 | ~ (|dlc25))
  			dlc25 <= #1 dl25 - 1;               // preset25 counter
		else
			dlc25 <= #1 dlc25 - 1;              // decrement counter
end

// Enable25 signal25 generation25 logic
always @(posedge clk25 or posedge wb_rst_i25)
begin
	if (wb_rst_i25)
		enable <= #1 1'b0;
	else
		if (|dl25 & ~(|dlc25))     // dl25>0 & dlc25==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying25 THRE25 status for one character25 cycle after a character25 is written25 to an empty25 fifo.
always @(lcr25)
  case (lcr25[3:0])
    4'b0000                             : block_value25 =  95; // 6 bits
    4'b0100                             : block_value25 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value25 = 111; // 7 bits
    4'b1100                             : block_value25 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value25 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value25 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value25 = 159; // 10 bits
    4'b1111                             : block_value25 = 175; // 11 bits
  endcase // case(lcr25[3:0])

// Counting25 time of one character25 minus25 stop bit
always @(posedge clk25 or posedge wb_rst_i25)
begin
  if (wb_rst_i25)
    block_cnt25 <= #1 8'd0;
  else
  if(lsr5r25 & fifo_write25)  // THRE25 bit set & write to fifo occured25
    block_cnt25 <= #1 block_value25;
  else
  if (enable & block_cnt25 != 8'b0)  // only work25 on enable times
    block_cnt25 <= #1 block_cnt25 - 1;  // decrement break counter
end // always of break condition detection25

// Generating25 THRE25 status enable signal25
assign thre_set_en25 = ~(|block_cnt25);


//
//	INTERRUPT25 LOGIC25
//

assign rls_int25  = ier25[`UART_IE_RLS25] && (lsr25[`UART_LS_OE25] || lsr25[`UART_LS_PE25] || lsr25[`UART_LS_FE25] || lsr25[`UART_LS_BI25]);
assign rda_int25  = ier25[`UART_IE_RDA25] && (rf_count25 >= {1'b0,trigger_level25});
assign thre_int25 = ier25[`UART_IE_THRE25] && lsr25[`UART_LS_TFE25];
assign ms_int25   = ier25[`UART_IE_MS25] && (| msr25[3:0]);
assign ti_int25   = ier25[`UART_IE_RDA25] && (counter_t25 == 10'b0) && (|rf_count25);

reg 	 rls_int_d25;
reg 	 thre_int_d25;
reg 	 ms_int_d25;
reg 	 ti_int_d25;
reg 	 rda_int_d25;

// delay lines25
always  @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) rls_int_d25 <= #1 0;
	else rls_int_d25 <= #1 rls_int25;

always  @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) rda_int_d25 <= #1 0;
	else rda_int_d25 <= #1 rda_int25;

always  @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) thre_int_d25 <= #1 0;
	else thre_int_d25 <= #1 thre_int25;

always  @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) ms_int_d25 <= #1 0;
	else ms_int_d25 <= #1 ms_int25;

always  @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) ti_int_d25 <= #1 0;
	else ti_int_d25 <= #1 ti_int25;

// rise25 detection25 signals25

wire 	 rls_int_rise25;
wire 	 thre_int_rise25;
wire 	 ms_int_rise25;
wire 	 ti_int_rise25;
wire 	 rda_int_rise25;

assign rda_int_rise25    = rda_int25 & ~rda_int_d25;
assign rls_int_rise25 	  = rls_int25 & ~rls_int_d25;
assign thre_int_rise25   = thre_int25 & ~thre_int_d25;
assign ms_int_rise25 	  = ms_int25 & ~ms_int_d25;
assign ti_int_rise25 	  = ti_int25 & ~ti_int_d25;

// interrupt25 pending flags25
reg 	rls_int_pnd25;
reg	rda_int_pnd25;
reg 	thre_int_pnd25;
reg 	ms_int_pnd25;
reg 	ti_int_pnd25;

// interrupt25 pending flags25 assignments25
always  @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) rls_int_pnd25 <= #1 0; 
	else 
		rls_int_pnd25 <= #1 lsr_mask25 ? 0 :  						// reset condition
							rls_int_rise25 ? 1 :						// latch25 condition
							rls_int_pnd25 && ier25[`UART_IE_RLS25];	// default operation25: remove if masked25

always  @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) rda_int_pnd25 <= #1 0; 
	else 
		rda_int_pnd25 <= #1 ((rf_count25 == {1'b0,trigger_level25}) && fifo_read25) ? 0 :  	// reset condition
							rda_int_rise25 ? 1 :						// latch25 condition
							rda_int_pnd25 && ier25[`UART_IE_RDA25];	// default operation25: remove if masked25

always  @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) thre_int_pnd25 <= #1 0; 
	else 
		thre_int_pnd25 <= #1 fifo_write25 || (iir_read25 & ~iir25[`UART_II_IP25] & iir25[`UART_II_II25] == `UART_II_THRE25)? 0 : 
							thre_int_rise25 ? 1 :
							thre_int_pnd25 && ier25[`UART_IE_THRE25];

always  @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) ms_int_pnd25 <= #1 0; 
	else 
		ms_int_pnd25 <= #1 msr_read25 ? 0 : 
							ms_int_rise25 ? 1 :
							ms_int_pnd25 && ier25[`UART_IE_MS25];

always  @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) ti_int_pnd25 <= #1 0; 
	else 
		ti_int_pnd25 <= #1 fifo_read25 ? 0 : 
							ti_int_rise25 ? 1 :
							ti_int_pnd25 && ier25[`UART_IE_RDA25];
// end of pending flags25

// INT_O25 logic
always @(posedge clk25 or posedge wb_rst_i25)
begin
	if (wb_rst_i25)	
		int_o25 <= #1 1'b0;
	else
		int_o25 <= #1 
					rls_int_pnd25		?	~lsr_mask25					:
					rda_int_pnd25		? 1								:
					ti_int_pnd25		? ~fifo_read25					:
					thre_int_pnd25	? !(fifo_write25 & iir_read25) :
					ms_int_pnd25		? ~msr_read25						:
					0;	// if no interrupt25 are pending
end


// Interrupt25 Identification25 register
always @(posedge clk25 or posedge wb_rst_i25)
begin
	if (wb_rst_i25)
		iir25 <= #1 1;
	else
	if (rls_int_pnd25)  // interrupt25 is pending
	begin
		iir25[`UART_II_II25] <= #1 `UART_II_RLS25;	// set identification25 register to correct25 value
		iir25[`UART_II_IP25] <= #1 1'b0;		// and clear the IIR25 bit 0 (interrupt25 pending)
	end else // the sequence of conditions25 determines25 priority of interrupt25 identification25
	if (rda_int25)
	begin
		iir25[`UART_II_II25] <= #1 `UART_II_RDA25;
		iir25[`UART_II_IP25] <= #1 1'b0;
	end
	else if (ti_int_pnd25)
	begin
		iir25[`UART_II_II25] <= #1 `UART_II_TI25;
		iir25[`UART_II_IP25] <= #1 1'b0;
	end
	else if (thre_int_pnd25)
	begin
		iir25[`UART_II_II25] <= #1 `UART_II_THRE25;
		iir25[`UART_II_IP25] <= #1 1'b0;
	end
	else if (ms_int_pnd25)
	begin
		iir25[`UART_II_II25] <= #1 `UART_II_MS25;
		iir25[`UART_II_IP25] <= #1 1'b0;
	end else	// no interrupt25 is pending
	begin
		iir25[`UART_II_II25] <= #1 0;
		iir25[`UART_II_IP25] <= #1 1'b1;
	end
end

endmodule
