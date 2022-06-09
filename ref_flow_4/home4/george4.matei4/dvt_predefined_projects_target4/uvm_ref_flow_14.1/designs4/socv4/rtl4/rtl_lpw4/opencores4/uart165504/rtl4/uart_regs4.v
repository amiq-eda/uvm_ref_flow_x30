//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs4.v                                                 ////
////                                                              ////
////                                                              ////
////  This4 file is part of the "UART4 16550 compatible4" project4    ////
////  http4://www4.opencores4.org4/cores4/uart165504/                   ////
////                                                              ////
////  Documentation4 related4 to this project4:                      ////
////  - http4://www4.opencores4.org4/cores4/uart165504/                 ////
////                                                              ////
////  Projects4 compatibility4:                                     ////
////  - WISHBONE4                                                  ////
////  RS2324 Protocol4                                              ////
////  16550D uart4 (mostly4 supported)                              ////
////                                                              ////
////  Overview4 (main4 Features4):                                   ////
////  Registers4 of the uart4 16550 core4                            ////
////                                                              ////
////  Known4 problems4 (limits4):                                    ////
////  Inserts4 1 wait state in all WISHBONE4 transfers4              ////
////                                                              ////
////  To4 Do4:                                                      ////
////  Nothing or verification4.                                    ////
////                                                              ////
////  Author4(s):                                                  ////
////      - gorban4@opencores4.org4                                  ////
////      - Jacob4 Gorban4                                          ////
////      - Igor4 Mohor4 (igorm4@opencores4.org4)                      ////
////                                                              ////
////  Created4:        2001/05/12                                  ////
////  Last4 Updated4:   (See log4 for the revision4 history4           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2000, 2001 Authors4                             ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS4 Revision4 History4
//
// $Log: not supported by cvs2svn4 $
// Revision4 1.41  2004/05/21 11:44:41  tadejm4
// Added4 synchronizer4 flops4 for RX4 input.
//
// Revision4 1.40  2003/06/11 16:37:47  gorban4
// This4 fixes4 errors4 in some4 cases4 when data is being read and put to the FIFO at the same time. Patch4 is submitted4 by Scott4 Furman4. Update is very4 recommended4.
//
// Revision4 1.39  2002/07/29 21:16:18  gorban4
// The uart_defines4.v file is included4 again4 in sources4.
//
// Revision4 1.38  2002/07/22 23:02:23  gorban4
// Bug4 Fixes4:
//  * Possible4 loss of sync and bad4 reception4 of stop bit on slow4 baud4 rates4 fixed4.
//   Problem4 reported4 by Kenny4.Tung4.
//  * Bad (or lack4 of ) loopback4 handling4 fixed4. Reported4 by Cherry4 Withers4.
//
// Improvements4:
//  * Made4 FIFO's as general4 inferrable4 memory where possible4.
//  So4 on FPGA4 they should be inferred4 as RAM4 (Distributed4 RAM4 on Xilinx4).
//  This4 saves4 about4 1/3 of the Slice4 count and reduces4 P&R and synthesis4 times.
//
//  * Added4 optional4 baudrate4 output (baud_o4).
//  This4 is identical4 to BAUDOUT4* signal4 on 16550 chip4.
//  It outputs4 16xbit_clock_rate - the divided4 clock4.
//  It's disabled by default. Define4 UART_HAS_BAUDRATE_OUTPUT4 to use.
//
// Revision4 1.37  2001/12/27 13:24:09  mohor4
// lsr4[7] was not showing4 overrun4 errors4.
//
// Revision4 1.36  2001/12/20 13:25:46  mohor4
// rx4 push4 changed to be only one cycle wide4.
//
// Revision4 1.35  2001/12/19 08:03:34  mohor4
// Warnings4 cleared4.
//
// Revision4 1.34  2001/12/19 07:33:54  mohor4
// Synplicity4 was having4 troubles4 with the comment4.
//
// Revision4 1.33  2001/12/17 10:14:43  mohor4
// Things4 related4 to msr4 register changed. After4 THRE4 IRQ4 occurs4, and one
// character4 is written4 to the transmit4 fifo, the detection4 of the THRE4 bit in the
// LSR4 is delayed4 for one character4 time.
//
// Revision4 1.32  2001/12/14 13:19:24  mohor4
// MSR4 register fixed4.
//
// Revision4 1.31  2001/12/14 10:06:58  mohor4
// After4 reset modem4 status register MSR4 should be reset.
//
// Revision4 1.30  2001/12/13 10:09:13  mohor4
// thre4 irq4 should be cleared4 only when being source4 of interrupt4.
//
// Revision4 1.29  2001/12/12 09:05:46  mohor4
// LSR4 status bit 0 was not cleared4 correctly in case of reseting4 the FCR4 (rx4 fifo).
//
// Revision4 1.28  2001/12/10 19:52:41  gorban4
// Scratch4 register added
//
// Revision4 1.27  2001/12/06 14:51:04  gorban4
// Bug4 in LSR4[0] is fixed4.
// All WISHBONE4 signals4 are now sampled4, so another4 wait-state is introduced4 on all transfers4.
//
// Revision4 1.26  2001/12/03 21:44:29  gorban4
// Updated4 specification4 documentation.
// Added4 full 32-bit data bus interface, now as default.
// Address is 5-bit wide4 in 32-bit data bus mode.
// Added4 wb_sel_i4 input to the core4. It's used in the 32-bit mode.
// Added4 debug4 interface with two4 32-bit read-only registers in 32-bit mode.
// Bits4 5 and 6 of LSR4 are now only cleared4 on TX4 FIFO write.
// My4 small test bench4 is modified to work4 with 32-bit mode.
//
// Revision4 1.25  2001/11/28 19:36:39  gorban4
// Fixed4: timeout and break didn4't pay4 attention4 to current data format4 when counting4 time
//
// Revision4 1.24  2001/11/26 21:38:54  gorban4
// Lots4 of fixes4:
// Break4 condition wasn4't handled4 correctly at all.
// LSR4 bits could lose4 their4 values.
// LSR4 value after reset was wrong4.
// Timing4 of THRE4 interrupt4 signal4 corrected4.
// LSR4 bit 0 timing4 corrected4.
//
// Revision4 1.23  2001/11/12 21:57:29  gorban4
// fixed4 more typo4 bugs4
//
// Revision4 1.22  2001/11/12 15:02:28  mohor4
// lsr1r4 error fixed4.
//
// Revision4 1.21  2001/11/12 14:57:27  mohor4
// ti_int_pnd4 error fixed4.
//
// Revision4 1.20  2001/11/12 14:50:27  mohor4
// ti_int_d4 error fixed4.
//
// Revision4 1.19  2001/11/10 12:43:21  gorban4
// Logic4 Synthesis4 bugs4 fixed4. Some4 other minor4 changes4
//
// Revision4 1.18  2001/11/08 14:54:23  mohor4
// Comments4 in Slovene4 language4 deleted4, few4 small fixes4 for better4 work4 of
// old4 tools4. IRQs4 need to be fix4.
//
// Revision4 1.17  2001/11/07 17:51:52  gorban4
// Heavily4 rewritten4 interrupt4 and LSR4 subsystems4.
// Many4 bugs4 hopefully4 squashed4.
//
// Revision4 1.16  2001/11/02 09:55:16  mohor4
// no message
//
// Revision4 1.15  2001/10/31 15:19:22  gorban4
// Fixes4 to break and timeout conditions4
//
// Revision4 1.14  2001/10/29 17:00:46  gorban4
// fixed4 parity4 sending4 and tx_fifo4 resets4 over- and underrun4
//
// Revision4 1.13  2001/10/20 09:58:40  gorban4
// Small4 synopsis4 fixes4
//
// Revision4 1.12  2001/10/19 16:21:40  gorban4
// Changes4 data_out4 to be synchronous4 again4 as it should have been.
//
// Revision4 1.11  2001/10/18 20:35:45  gorban4
// small fix4
//
// Revision4 1.10  2001/08/24 21:01:12  mohor4
// Things4 connected4 to parity4 changed.
// Clock4 devider4 changed.
//
// Revision4 1.9  2001/08/23 16:05:05  mohor4
// Stop bit bug4 fixed4.
// Parity4 bug4 fixed4.
// WISHBONE4 read cycle bug4 fixed4,
// OE4 indicator4 (Overrun4 Error) bug4 fixed4.
// PE4 indicator4 (Parity4 Error) bug4 fixed4.
// Register read bug4 fixed4.
//
// Revision4 1.10  2001/06/23 11:21:48  gorban4
// DL4 made4 16-bit long4. Fixed4 transmission4/reception4 bugs4.
//
// Revision4 1.9  2001/05/31 20:08:01  gorban4
// FIFO changes4 and other corrections4.
//
// Revision4 1.8  2001/05/29 20:05:04  gorban4
// Fixed4 some4 bugs4 and synthesis4 problems4.
//
// Revision4 1.7  2001/05/27 17:37:49  gorban4
// Fixed4 many4 bugs4. Updated4 spec4. Changed4 FIFO files structure4. See CHANGES4.txt4 file.
//
// Revision4 1.6  2001/05/21 19:12:02  gorban4
// Corrected4 some4 Linter4 messages4.
//
// Revision4 1.5  2001/05/17 18:34:18  gorban4
// First4 'stable' release. Should4 be sythesizable4 now. Also4 added new header.
//
// Revision4 1.0  2001-05-17 21:27:11+02  jacob4
// Initial4 revision4
//
//

// synopsys4 translate_off4
`include "timescale.v"
// synopsys4 translate_on4

`include "uart_defines4.v"

`define UART_DL14 7:0
`define UART_DL24 15:8

module uart_regs4 (clk4,
	wb_rst_i4, wb_addr_i4, wb_dat_i4, wb_dat_o4, wb_we_i4, wb_re_i4, 

// additional4 signals4
	modem_inputs4,
	stx_pad_o4, srx_pad_i4,

`ifdef DATA_BUS_WIDTH_84
`else
// debug4 interface signals4	enabled
ier4, iir4, fcr4, mcr4, lcr4, msr4, lsr4, rf_count4, tf_count4, tstate4, rstate,
`endif				
	rts_pad_o4, dtr_pad_o4, int_o4
`ifdef UART_HAS_BAUDRATE_OUTPUT4
	, baud_o4
`endif

	);

input 									clk4;
input 									wb_rst_i4;
input [`UART_ADDR_WIDTH4-1:0] 		wb_addr_i4;
input [7:0] 							wb_dat_i4;
output [7:0] 							wb_dat_o4;
input 									wb_we_i4;
input 									wb_re_i4;

output 									stx_pad_o4;
input 									srx_pad_i4;

input [3:0] 							modem_inputs4;
output 									rts_pad_o4;
output 									dtr_pad_o4;
output 									int_o4;
`ifdef UART_HAS_BAUDRATE_OUTPUT4
output	baud_o4;
`endif

`ifdef DATA_BUS_WIDTH_84
`else
// if 32-bit databus4 and debug4 interface are enabled
output [3:0]							ier4;
output [3:0]							iir4;
output [1:0]							fcr4;  /// bits 7 and 6 of fcr4. Other4 bits are ignored
output [4:0]							mcr4;
output [7:0]							lcr4;
output [7:0]							msr4;
output [7:0] 							lsr4;
output [`UART_FIFO_COUNTER_W4-1:0] 	rf_count4;
output [`UART_FIFO_COUNTER_W4-1:0] 	tf_count4;
output [2:0] 							tstate4;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs4;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT4
assign baud_o4 = enable; // baud_o4 is actually4 the enable signal4
`endif


wire 										stx_pad_o4;		// received4 from transmitter4 module
wire 										srx_pad_i4;
wire 										srx_pad4;

reg [7:0] 								wb_dat_o4;

wire [`UART_ADDR_WIDTH4-1:0] 		wb_addr_i4;
wire [7:0] 								wb_dat_i4;


reg [3:0] 								ier4;
reg [3:0] 								iir4;
reg [1:0] 								fcr4;  /// bits 7 and 6 of fcr4. Other4 bits are ignored
reg [4:0] 								mcr4;
reg [7:0] 								lcr4;
reg [7:0] 								msr4;
reg [15:0] 								dl4;  // 32-bit divisor4 latch4
reg [7:0] 								scratch4; // UART4 scratch4 register
reg 										start_dlc4; // activate4 dlc4 on writing to UART_DL14
reg 										lsr_mask_d4; // delay for lsr_mask4 condition
reg 										msi_reset4; // reset MSR4 4 lower4 bits indicator4
//reg 										threi_clear4; // THRE4 interrupt4 clear flag4
reg [15:0] 								dlc4;  // 32-bit divisor4 latch4 counter
reg 										int_o4;

reg [3:0] 								trigger_level4; // trigger level of the receiver4 FIFO
reg 										rx_reset4;
reg 										tx_reset4;

wire 										dlab4;			   // divisor4 latch4 access bit
wire 										cts_pad_i4, dsr_pad_i4, ri_pad_i4, dcd_pad_i4; // modem4 status bits
wire 										loopback4;		   // loopback4 bit (MCR4 bit 4)
wire 										cts4, dsr4, ri, dcd4;	   // effective4 signals4
wire                    cts_c4, dsr_c4, ri_c4, dcd_c4; // Complement4 effective4 signals4 (considering4 loopback4)
wire 										rts_pad_o4, dtr_pad_o4;		   // modem4 control4 outputs4

// LSR4 bits wires4 and regs
wire [7:0] 								lsr4;
wire 										lsr04, lsr14, lsr24, lsr34, lsr44, lsr54, lsr64, lsr74;
reg										lsr0r4, lsr1r4, lsr2r4, lsr3r4, lsr4r4, lsr5r4, lsr6r4, lsr7r4;
wire 										lsr_mask4; // lsr_mask4

//
// ASSINGS4
//

assign 									lsr4[7:0] = { lsr7r4, lsr6r4, lsr5r4, lsr4r4, lsr3r4, lsr2r4, lsr1r4, lsr0r4 };

assign 									{cts_pad_i4, dsr_pad_i4, ri_pad_i4, dcd_pad_i4} = modem_inputs4;
assign 									{cts4, dsr4, ri, dcd4} = ~{cts_pad_i4,dsr_pad_i4,ri_pad_i4,dcd_pad_i4};

assign                  {cts_c4, dsr_c4, ri_c4, dcd_c4} = loopback4 ? {mcr4[`UART_MC_RTS4],mcr4[`UART_MC_DTR4],mcr4[`UART_MC_OUT14],mcr4[`UART_MC_OUT24]}
                                                               : {cts_pad_i4,dsr_pad_i4,ri_pad_i4,dcd_pad_i4};

assign 									dlab4 = lcr4[`UART_LC_DL4];
assign 									loopback4 = mcr4[4];

// assign modem4 outputs4
assign 									rts_pad_o4 = mcr4[`UART_MC_RTS4];
assign 									dtr_pad_o4 = mcr4[`UART_MC_DTR4];

// Interrupt4 signals4
wire 										rls_int4;  // receiver4 line status interrupt4
wire 										rda_int4;  // receiver4 data available interrupt4
wire 										ti_int4;   // timeout indicator4 interrupt4
wire										thre_int4; // transmitter4 holding4 register empty4 interrupt4
wire 										ms_int4;   // modem4 status interrupt4

// FIFO signals4
reg 										tf_push4;
reg 										rf_pop4;
wire [`UART_FIFO_REC_WIDTH4-1:0] 	rf_data_out4;
wire 										rf_error_bit4; // an error (parity4 or framing4) is inside the fifo
wire [`UART_FIFO_COUNTER_W4-1:0] 	rf_count4;
wire [`UART_FIFO_COUNTER_W4-1:0] 	tf_count4;
wire [2:0] 								tstate4;
wire [3:0] 								rstate;
wire [9:0] 								counter_t4;

wire                      thre_set_en4; // THRE4 status is delayed4 one character4 time when a character4 is written4 to fifo.
reg  [7:0]                block_cnt4;   // While4 counter counts4, THRE4 status is blocked4 (delayed4 one character4 cycle)
reg  [7:0]                block_value4; // One4 character4 length minus4 stop bit

// Transmitter4 Instance
wire serial_out4;

uart_transmitter4 transmitter4(clk4, wb_rst_i4, lcr4, tf_push4, wb_dat_i4, enable, serial_out4, tstate4, tf_count4, tx_reset4, lsr_mask4);

  // Synchronizing4 and sampling4 serial4 RX4 input
  uart_sync_flops4    i_uart_sync_flops4
  (
    .rst_i4           (wb_rst_i4),
    .clk_i4           (clk4),
    .stage1_rst_i4    (1'b0),
    .stage1_clk_en_i4 (1'b1),
    .async_dat_i4     (srx_pad_i4),
    .sync_dat_o4      (srx_pad4)
  );
  defparam i_uart_sync_flops4.width      = 1;
  defparam i_uart_sync_flops4.init_value4 = 1'b1;

// handle loopback4
wire serial_in4 = loopback4 ? serial_out4 : srx_pad4;
assign stx_pad_o4 = loopback4 ? 1'b1 : serial_out4;

// Receiver4 Instance
uart_receiver4 receiver4(clk4, wb_rst_i4, lcr4, rf_pop4, serial_in4, enable, 
	counter_t4, rf_count4, rf_data_out4, rf_error_bit4, rf_overrun4, rx_reset4, lsr_mask4, rstate, rf_push_pulse4);


// Asynchronous4 reading here4 because the outputs4 are sampled4 in uart_wb4.v file 
always @(dl4 or dlab4 or ier4 or iir4 or scratch4
			or lcr4 or lsr4 or msr4 or rf_data_out4 or wb_addr_i4 or wb_re_i4)   // asynchrounous4 reading
begin
	case (wb_addr_i4)
		`UART_REG_RB4   : wb_dat_o4 = dlab4 ? dl4[`UART_DL14] : rf_data_out4[10:3];
		`UART_REG_IE4	: wb_dat_o4 = dlab4 ? dl4[`UART_DL24] : ier4;
		`UART_REG_II4	: wb_dat_o4 = {4'b1100,iir4};
		`UART_REG_LC4	: wb_dat_o4 = lcr4;
		`UART_REG_LS4	: wb_dat_o4 = lsr4;
		`UART_REG_MS4	: wb_dat_o4 = msr4;
		`UART_REG_SR4	: wb_dat_o4 = scratch4;
		default:  wb_dat_o4 = 8'b0; // ??
	endcase // case(wb_addr_i4)
end // always @ (dl4 or dlab4 or ier4 or iir4 or scratch4...


// rf_pop4 signal4 handling4
always @(posedge clk4 or posedge wb_rst_i4)
begin
	if (wb_rst_i4)
		rf_pop4 <= #1 0; 
	else
	if (rf_pop4)	// restore4 the signal4 to 0 after one clock4 cycle
		rf_pop4 <= #1 0;
	else
	if (wb_re_i4 && wb_addr_i4 == `UART_REG_RB4 && !dlab4)
		rf_pop4 <= #1 1; // advance4 read pointer4
end

wire 	lsr_mask_condition4;
wire 	iir_read4;
wire  msr_read4;
wire	fifo_read4;
wire	fifo_write4;

assign lsr_mask_condition4 = (wb_re_i4 && wb_addr_i4 == `UART_REG_LS4 && !dlab4);
assign iir_read4 = (wb_re_i4 && wb_addr_i4 == `UART_REG_II4 && !dlab4);
assign msr_read4 = (wb_re_i4 && wb_addr_i4 == `UART_REG_MS4 && !dlab4);
assign fifo_read4 = (wb_re_i4 && wb_addr_i4 == `UART_REG_RB4 && !dlab4);
assign fifo_write4 = (wb_we_i4 && wb_addr_i4 == `UART_REG_TR4 && !dlab4);

// lsr_mask_d4 delayed4 signal4 handling4
always @(posedge clk4 or posedge wb_rst_i4)
begin
	if (wb_rst_i4)
		lsr_mask_d4 <= #1 0;
	else // reset bits in the Line4 Status Register
		lsr_mask_d4 <= #1 lsr_mask_condition4;
end

// lsr_mask4 is rise4 detected
assign lsr_mask4 = lsr_mask_condition4 && ~lsr_mask_d4;

// msi_reset4 signal4 handling4
always @(posedge clk4 or posedge wb_rst_i4)
begin
	if (wb_rst_i4)
		msi_reset4 <= #1 1;
	else
	if (msi_reset4)
		msi_reset4 <= #1 0;
	else
	if (msr_read4)
		msi_reset4 <= #1 1; // reset bits in Modem4 Status Register
end


//
//   WRITES4 AND4 RESETS4   //
//
// Line4 Control4 Register
always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4)
		lcr4 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i4 && wb_addr_i4==`UART_REG_LC4)
		lcr4 <= #1 wb_dat_i4;

// Interrupt4 Enable4 Register or UART_DL24
always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4)
	begin
		ier4 <= #1 4'b0000; // no interrupts4 after reset
		dl4[`UART_DL24] <= #1 8'b0;
	end
	else
	if (wb_we_i4 && wb_addr_i4==`UART_REG_IE4)
		if (dlab4)
		begin
			dl4[`UART_DL24] <= #1 wb_dat_i4;
		end
		else
			ier4 <= #1 wb_dat_i4[3:0]; // ier4 uses only 4 lsb


// FIFO Control4 Register and rx_reset4, tx_reset4 signals4
always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) begin
		fcr4 <= #1 2'b11; 
		rx_reset4 <= #1 0;
		tx_reset4 <= #1 0;
	end else
	if (wb_we_i4 && wb_addr_i4==`UART_REG_FC4) begin
		fcr4 <= #1 wb_dat_i4[7:6];
		rx_reset4 <= #1 wb_dat_i4[1];
		tx_reset4 <= #1 wb_dat_i4[2];
	end else begin
		rx_reset4 <= #1 0;
		tx_reset4 <= #1 0;
	end

// Modem4 Control4 Register
always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4)
		mcr4 <= #1 5'b0; 
	else
	if (wb_we_i4 && wb_addr_i4==`UART_REG_MC4)
			mcr4 <= #1 wb_dat_i4[4:0];

// Scratch4 register
// Line4 Control4 Register
always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4)
		scratch4 <= #1 0; // 8n1 setting
	else
	if (wb_we_i4 && wb_addr_i4==`UART_REG_SR4)
		scratch4 <= #1 wb_dat_i4;

// TX_FIFO4 or UART_DL14
always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4)
	begin
		dl4[`UART_DL14]  <= #1 8'b0;
		tf_push4   <= #1 1'b0;
		start_dlc4 <= #1 1'b0;
	end
	else
	if (wb_we_i4 && wb_addr_i4==`UART_REG_TR4)
		if (dlab4)
		begin
			dl4[`UART_DL14] <= #1 wb_dat_i4;
			start_dlc4 <= #1 1'b1; // enable DL4 counter
			tf_push4 <= #1 1'b0;
		end
		else
		begin
			tf_push4   <= #1 1'b1;
			start_dlc4 <= #1 1'b0;
		end // else: !if(dlab4)
	else
	begin
		start_dlc4 <= #1 1'b0;
		tf_push4   <= #1 1'b0;
	end // else: !if(dlab4)

// Receiver4 FIFO trigger level selection logic (asynchronous4 mux4)
always @(fcr4)
	case (fcr4[`UART_FC_TL4])
		2'b00 : trigger_level4 = 1;
		2'b01 : trigger_level4 = 4;
		2'b10 : trigger_level4 = 8;
		2'b11 : trigger_level4 = 14;
	endcase // case(fcr4[`UART_FC_TL4])
	
//
//  STATUS4 REGISTERS4  //
//

// Modem4 Status Register
reg [3:0] delayed_modem_signals4;
always @(posedge clk4 or posedge wb_rst_i4)
begin
	if (wb_rst_i4)
	  begin
  		msr4 <= #1 0;
	  	delayed_modem_signals4[3:0] <= #1 0;
	  end
	else begin
		msr4[`UART_MS_DDCD4:`UART_MS_DCTS4] <= #1 msi_reset4 ? 4'b0 :
			msr4[`UART_MS_DDCD4:`UART_MS_DCTS4] | ({dcd4, ri, dsr4, cts4} ^ delayed_modem_signals4[3:0]);
		msr4[`UART_MS_CDCD4:`UART_MS_CCTS4] <= #1 {dcd_c4, ri_c4, dsr_c4, cts_c4};
		delayed_modem_signals4[3:0] <= #1 {dcd4, ri, dsr4, cts4};
	end
end


// Line4 Status Register

// activation4 conditions4
assign lsr04 = (rf_count4==0 && rf_push_pulse4);  // data in receiver4 fifo available set condition
assign lsr14 = rf_overrun4;     // Receiver4 overrun4 error
assign lsr24 = rf_data_out4[1]; // parity4 error bit
assign lsr34 = rf_data_out4[0]; // framing4 error bit
assign lsr44 = rf_data_out4[2]; // break error in the character4
assign lsr54 = (tf_count4==5'b0 && thre_set_en4);  // transmitter4 fifo is empty4
assign lsr64 = (tf_count4==5'b0 && thre_set_en4 && (tstate4 == /*`S_IDLE4 */ 0)); // transmitter4 empty4
assign lsr74 = rf_error_bit4 | rf_overrun4;

// lsr4 bit04 (receiver4 data available)
reg 	 lsr0_d4;

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr0_d4 <= #1 0;
	else lsr0_d4 <= #1 lsr04;

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr0r4 <= #1 0;
	else lsr0r4 <= #1 (rf_count4==1 && rf_pop4 && !rf_push_pulse4 || rx_reset4) ? 0 : // deassert4 condition
					  lsr0r4 || (lsr04 && ~lsr0_d4); // set on rise4 of lsr04 and keep4 asserted4 until deasserted4 

// lsr4 bit 1 (receiver4 overrun4)
reg lsr1_d4; // delayed4

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr1_d4 <= #1 0;
	else lsr1_d4 <= #1 lsr14;

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr1r4 <= #1 0;
	else	lsr1r4 <= #1	lsr_mask4 ? 0 : lsr1r4 || (lsr14 && ~lsr1_d4); // set on rise4

// lsr4 bit 2 (parity4 error)
reg lsr2_d4; // delayed4

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr2_d4 <= #1 0;
	else lsr2_d4 <= #1 lsr24;

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr2r4 <= #1 0;
	else lsr2r4 <= #1 lsr_mask4 ? 0 : lsr2r4 || (lsr24 && ~lsr2_d4); // set on rise4

// lsr4 bit 3 (framing4 error)
reg lsr3_d4; // delayed4

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr3_d4 <= #1 0;
	else lsr3_d4 <= #1 lsr34;

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr3r4 <= #1 0;
	else lsr3r4 <= #1 lsr_mask4 ? 0 : lsr3r4 || (lsr34 && ~lsr3_d4); // set on rise4

// lsr4 bit 4 (break indicator4)
reg lsr4_d4; // delayed4

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr4_d4 <= #1 0;
	else lsr4_d4 <= #1 lsr44;

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr4r4 <= #1 0;
	else lsr4r4 <= #1 lsr_mask4 ? 0 : lsr4r4 || (lsr44 && ~lsr4_d4);

// lsr4 bit 5 (transmitter4 fifo is empty4)
reg lsr5_d4;

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr5_d4 <= #1 1;
	else lsr5_d4 <= #1 lsr54;

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr5r4 <= #1 1;
	else lsr5r4 <= #1 (fifo_write4) ? 0 :  lsr5r4 || (lsr54 && ~lsr5_d4);

// lsr4 bit 6 (transmitter4 empty4 indicator4)
reg lsr6_d4;

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr6_d4 <= #1 1;
	else lsr6_d4 <= #1 lsr64;

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr6r4 <= #1 1;
	else lsr6r4 <= #1 (fifo_write4) ? 0 : lsr6r4 || (lsr64 && ~lsr6_d4);

// lsr4 bit 7 (error in fifo)
reg lsr7_d4;

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr7_d4 <= #1 0;
	else lsr7_d4 <= #1 lsr74;

always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) lsr7r4 <= #1 0;
	else lsr7r4 <= #1 lsr_mask4 ? 0 : lsr7r4 || (lsr74 && ~lsr7_d4);

// Frequency4 divider4
always @(posedge clk4 or posedge wb_rst_i4) 
begin
	if (wb_rst_i4)
		dlc4 <= #1 0;
	else
		if (start_dlc4 | ~ (|dlc4))
  			dlc4 <= #1 dl4 - 1;               // preset4 counter
		else
			dlc4 <= #1 dlc4 - 1;              // decrement counter
end

// Enable4 signal4 generation4 logic
always @(posedge clk4 or posedge wb_rst_i4)
begin
	if (wb_rst_i4)
		enable <= #1 1'b0;
	else
		if (|dl4 & ~(|dlc4))     // dl4>0 & dlc4==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying4 THRE4 status for one character4 cycle after a character4 is written4 to an empty4 fifo.
always @(lcr4)
  case (lcr4[3:0])
    4'b0000                             : block_value4 =  95; // 6 bits
    4'b0100                             : block_value4 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value4 = 111; // 7 bits
    4'b1100                             : block_value4 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value4 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value4 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value4 = 159; // 10 bits
    4'b1111                             : block_value4 = 175; // 11 bits
  endcase // case(lcr4[3:0])

// Counting4 time of one character4 minus4 stop bit
always @(posedge clk4 or posedge wb_rst_i4)
begin
  if (wb_rst_i4)
    block_cnt4 <= #1 8'd0;
  else
  if(lsr5r4 & fifo_write4)  // THRE4 bit set & write to fifo occured4
    block_cnt4 <= #1 block_value4;
  else
  if (enable & block_cnt4 != 8'b0)  // only work4 on enable times
    block_cnt4 <= #1 block_cnt4 - 1;  // decrement break counter
end // always of break condition detection4

// Generating4 THRE4 status enable signal4
assign thre_set_en4 = ~(|block_cnt4);


//
//	INTERRUPT4 LOGIC4
//

assign rls_int4  = ier4[`UART_IE_RLS4] && (lsr4[`UART_LS_OE4] || lsr4[`UART_LS_PE4] || lsr4[`UART_LS_FE4] || lsr4[`UART_LS_BI4]);
assign rda_int4  = ier4[`UART_IE_RDA4] && (rf_count4 >= {1'b0,trigger_level4});
assign thre_int4 = ier4[`UART_IE_THRE4] && lsr4[`UART_LS_TFE4];
assign ms_int4   = ier4[`UART_IE_MS4] && (| msr4[3:0]);
assign ti_int4   = ier4[`UART_IE_RDA4] && (counter_t4 == 10'b0) && (|rf_count4);

reg 	 rls_int_d4;
reg 	 thre_int_d4;
reg 	 ms_int_d4;
reg 	 ti_int_d4;
reg 	 rda_int_d4;

// delay lines4
always  @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) rls_int_d4 <= #1 0;
	else rls_int_d4 <= #1 rls_int4;

always  @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) rda_int_d4 <= #1 0;
	else rda_int_d4 <= #1 rda_int4;

always  @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) thre_int_d4 <= #1 0;
	else thre_int_d4 <= #1 thre_int4;

always  @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) ms_int_d4 <= #1 0;
	else ms_int_d4 <= #1 ms_int4;

always  @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) ti_int_d4 <= #1 0;
	else ti_int_d4 <= #1 ti_int4;

// rise4 detection4 signals4

wire 	 rls_int_rise4;
wire 	 thre_int_rise4;
wire 	 ms_int_rise4;
wire 	 ti_int_rise4;
wire 	 rda_int_rise4;

assign rda_int_rise4    = rda_int4 & ~rda_int_d4;
assign rls_int_rise4 	  = rls_int4 & ~rls_int_d4;
assign thre_int_rise4   = thre_int4 & ~thre_int_d4;
assign ms_int_rise4 	  = ms_int4 & ~ms_int_d4;
assign ti_int_rise4 	  = ti_int4 & ~ti_int_d4;

// interrupt4 pending flags4
reg 	rls_int_pnd4;
reg	rda_int_pnd4;
reg 	thre_int_pnd4;
reg 	ms_int_pnd4;
reg 	ti_int_pnd4;

// interrupt4 pending flags4 assignments4
always  @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) rls_int_pnd4 <= #1 0; 
	else 
		rls_int_pnd4 <= #1 lsr_mask4 ? 0 :  						// reset condition
							rls_int_rise4 ? 1 :						// latch4 condition
							rls_int_pnd4 && ier4[`UART_IE_RLS4];	// default operation4: remove if masked4

always  @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) rda_int_pnd4 <= #1 0; 
	else 
		rda_int_pnd4 <= #1 ((rf_count4 == {1'b0,trigger_level4}) && fifo_read4) ? 0 :  	// reset condition
							rda_int_rise4 ? 1 :						// latch4 condition
							rda_int_pnd4 && ier4[`UART_IE_RDA4];	// default operation4: remove if masked4

always  @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) thre_int_pnd4 <= #1 0; 
	else 
		thre_int_pnd4 <= #1 fifo_write4 || (iir_read4 & ~iir4[`UART_II_IP4] & iir4[`UART_II_II4] == `UART_II_THRE4)? 0 : 
							thre_int_rise4 ? 1 :
							thre_int_pnd4 && ier4[`UART_IE_THRE4];

always  @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) ms_int_pnd4 <= #1 0; 
	else 
		ms_int_pnd4 <= #1 msr_read4 ? 0 : 
							ms_int_rise4 ? 1 :
							ms_int_pnd4 && ier4[`UART_IE_MS4];

always  @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) ti_int_pnd4 <= #1 0; 
	else 
		ti_int_pnd4 <= #1 fifo_read4 ? 0 : 
							ti_int_rise4 ? 1 :
							ti_int_pnd4 && ier4[`UART_IE_RDA4];
// end of pending flags4

// INT_O4 logic
always @(posedge clk4 or posedge wb_rst_i4)
begin
	if (wb_rst_i4)	
		int_o4 <= #1 1'b0;
	else
		int_o4 <= #1 
					rls_int_pnd4		?	~lsr_mask4					:
					rda_int_pnd4		? 1								:
					ti_int_pnd4		? ~fifo_read4					:
					thre_int_pnd4	? !(fifo_write4 & iir_read4) :
					ms_int_pnd4		? ~msr_read4						:
					0;	// if no interrupt4 are pending
end


// Interrupt4 Identification4 register
always @(posedge clk4 or posedge wb_rst_i4)
begin
	if (wb_rst_i4)
		iir4 <= #1 1;
	else
	if (rls_int_pnd4)  // interrupt4 is pending
	begin
		iir4[`UART_II_II4] <= #1 `UART_II_RLS4;	// set identification4 register to correct4 value
		iir4[`UART_II_IP4] <= #1 1'b0;		// and clear the IIR4 bit 0 (interrupt4 pending)
	end else // the sequence of conditions4 determines4 priority of interrupt4 identification4
	if (rda_int4)
	begin
		iir4[`UART_II_II4] <= #1 `UART_II_RDA4;
		iir4[`UART_II_IP4] <= #1 1'b0;
	end
	else if (ti_int_pnd4)
	begin
		iir4[`UART_II_II4] <= #1 `UART_II_TI4;
		iir4[`UART_II_IP4] <= #1 1'b0;
	end
	else if (thre_int_pnd4)
	begin
		iir4[`UART_II_II4] <= #1 `UART_II_THRE4;
		iir4[`UART_II_IP4] <= #1 1'b0;
	end
	else if (ms_int_pnd4)
	begin
		iir4[`UART_II_II4] <= #1 `UART_II_MS4;
		iir4[`UART_II_IP4] <= #1 1'b0;
	end else	// no interrupt4 is pending
	begin
		iir4[`UART_II_II4] <= #1 0;
		iir4[`UART_II_IP4] <= #1 1'b1;
	end
end

endmodule
