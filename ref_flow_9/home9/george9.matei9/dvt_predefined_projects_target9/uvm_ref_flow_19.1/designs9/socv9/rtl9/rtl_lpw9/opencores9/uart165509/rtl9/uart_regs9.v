//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs9.v                                                 ////
////                                                              ////
////                                                              ////
////  This9 file is part of the "UART9 16550 compatible9" project9    ////
////  http9://www9.opencores9.org9/cores9/uart165509/                   ////
////                                                              ////
////  Documentation9 related9 to this project9:                      ////
////  - http9://www9.opencores9.org9/cores9/uart165509/                 ////
////                                                              ////
////  Projects9 compatibility9:                                     ////
////  - WISHBONE9                                                  ////
////  RS2329 Protocol9                                              ////
////  16550D uart9 (mostly9 supported)                              ////
////                                                              ////
////  Overview9 (main9 Features9):                                   ////
////  Registers9 of the uart9 16550 core9                            ////
////                                                              ////
////  Known9 problems9 (limits9):                                    ////
////  Inserts9 1 wait state in all WISHBONE9 transfers9              ////
////                                                              ////
////  To9 Do9:                                                      ////
////  Nothing or verification9.                                    ////
////                                                              ////
////  Author9(s):                                                  ////
////      - gorban9@opencores9.org9                                  ////
////      - Jacob9 Gorban9                                          ////
////      - Igor9 Mohor9 (igorm9@opencores9.org9)                      ////
////                                                              ////
////  Created9:        2001/05/12                                  ////
////  Last9 Updated9:   (See log9 for the revision9 history9           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2000, 2001 Authors9                             ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS9 Revision9 History9
//
// $Log: not supported by cvs2svn9 $
// Revision9 1.41  2004/05/21 11:44:41  tadejm9
// Added9 synchronizer9 flops9 for RX9 input.
//
// Revision9 1.40  2003/06/11 16:37:47  gorban9
// This9 fixes9 errors9 in some9 cases9 when data is being read and put to the FIFO at the same time. Patch9 is submitted9 by Scott9 Furman9. Update is very9 recommended9.
//
// Revision9 1.39  2002/07/29 21:16:18  gorban9
// The uart_defines9.v file is included9 again9 in sources9.
//
// Revision9 1.38  2002/07/22 23:02:23  gorban9
// Bug9 Fixes9:
//  * Possible9 loss of sync and bad9 reception9 of stop bit on slow9 baud9 rates9 fixed9.
//   Problem9 reported9 by Kenny9.Tung9.
//  * Bad (or lack9 of ) loopback9 handling9 fixed9. Reported9 by Cherry9 Withers9.
//
// Improvements9:
//  * Made9 FIFO's as general9 inferrable9 memory where possible9.
//  So9 on FPGA9 they should be inferred9 as RAM9 (Distributed9 RAM9 on Xilinx9).
//  This9 saves9 about9 1/3 of the Slice9 count and reduces9 P&R and synthesis9 times.
//
//  * Added9 optional9 baudrate9 output (baud_o9).
//  This9 is identical9 to BAUDOUT9* signal9 on 16550 chip9.
//  It outputs9 16xbit_clock_rate - the divided9 clock9.
//  It's disabled by default. Define9 UART_HAS_BAUDRATE_OUTPUT9 to use.
//
// Revision9 1.37  2001/12/27 13:24:09  mohor9
// lsr9[7] was not showing9 overrun9 errors9.
//
// Revision9 1.36  2001/12/20 13:25:46  mohor9
// rx9 push9 changed to be only one cycle wide9.
//
// Revision9 1.35  2001/12/19 08:03:34  mohor9
// Warnings9 cleared9.
//
// Revision9 1.34  2001/12/19 07:33:54  mohor9
// Synplicity9 was having9 troubles9 with the comment9.
//
// Revision9 1.33  2001/12/17 10:14:43  mohor9
// Things9 related9 to msr9 register changed. After9 THRE9 IRQ9 occurs9, and one
// character9 is written9 to the transmit9 fifo, the detection9 of the THRE9 bit in the
// LSR9 is delayed9 for one character9 time.
//
// Revision9 1.32  2001/12/14 13:19:24  mohor9
// MSR9 register fixed9.
//
// Revision9 1.31  2001/12/14 10:06:58  mohor9
// After9 reset modem9 status register MSR9 should be reset.
//
// Revision9 1.30  2001/12/13 10:09:13  mohor9
// thre9 irq9 should be cleared9 only when being source9 of interrupt9.
//
// Revision9 1.29  2001/12/12 09:05:46  mohor9
// LSR9 status bit 0 was not cleared9 correctly in case of reseting9 the FCR9 (rx9 fifo).
//
// Revision9 1.28  2001/12/10 19:52:41  gorban9
// Scratch9 register added
//
// Revision9 1.27  2001/12/06 14:51:04  gorban9
// Bug9 in LSR9[0] is fixed9.
// All WISHBONE9 signals9 are now sampled9, so another9 wait-state is introduced9 on all transfers9.
//
// Revision9 1.26  2001/12/03 21:44:29  gorban9
// Updated9 specification9 documentation.
// Added9 full 32-bit data bus interface, now as default.
// Address is 5-bit wide9 in 32-bit data bus mode.
// Added9 wb_sel_i9 input to the core9. It's used in the 32-bit mode.
// Added9 debug9 interface with two9 32-bit read-only registers in 32-bit mode.
// Bits9 5 and 6 of LSR9 are now only cleared9 on TX9 FIFO write.
// My9 small test bench9 is modified to work9 with 32-bit mode.
//
// Revision9 1.25  2001/11/28 19:36:39  gorban9
// Fixed9: timeout and break didn9't pay9 attention9 to current data format9 when counting9 time
//
// Revision9 1.24  2001/11/26 21:38:54  gorban9
// Lots9 of fixes9:
// Break9 condition wasn9't handled9 correctly at all.
// LSR9 bits could lose9 their9 values.
// LSR9 value after reset was wrong9.
// Timing9 of THRE9 interrupt9 signal9 corrected9.
// LSR9 bit 0 timing9 corrected9.
//
// Revision9 1.23  2001/11/12 21:57:29  gorban9
// fixed9 more typo9 bugs9
//
// Revision9 1.22  2001/11/12 15:02:28  mohor9
// lsr1r9 error fixed9.
//
// Revision9 1.21  2001/11/12 14:57:27  mohor9
// ti_int_pnd9 error fixed9.
//
// Revision9 1.20  2001/11/12 14:50:27  mohor9
// ti_int_d9 error fixed9.
//
// Revision9 1.19  2001/11/10 12:43:21  gorban9
// Logic9 Synthesis9 bugs9 fixed9. Some9 other minor9 changes9
//
// Revision9 1.18  2001/11/08 14:54:23  mohor9
// Comments9 in Slovene9 language9 deleted9, few9 small fixes9 for better9 work9 of
// old9 tools9. IRQs9 need to be fix9.
//
// Revision9 1.17  2001/11/07 17:51:52  gorban9
// Heavily9 rewritten9 interrupt9 and LSR9 subsystems9.
// Many9 bugs9 hopefully9 squashed9.
//
// Revision9 1.16  2001/11/02 09:55:16  mohor9
// no message
//
// Revision9 1.15  2001/10/31 15:19:22  gorban9
// Fixes9 to break and timeout conditions9
//
// Revision9 1.14  2001/10/29 17:00:46  gorban9
// fixed9 parity9 sending9 and tx_fifo9 resets9 over- and underrun9
//
// Revision9 1.13  2001/10/20 09:58:40  gorban9
// Small9 synopsis9 fixes9
//
// Revision9 1.12  2001/10/19 16:21:40  gorban9
// Changes9 data_out9 to be synchronous9 again9 as it should have been.
//
// Revision9 1.11  2001/10/18 20:35:45  gorban9
// small fix9
//
// Revision9 1.10  2001/08/24 21:01:12  mohor9
// Things9 connected9 to parity9 changed.
// Clock9 devider9 changed.
//
// Revision9 1.9  2001/08/23 16:05:05  mohor9
// Stop bit bug9 fixed9.
// Parity9 bug9 fixed9.
// WISHBONE9 read cycle bug9 fixed9,
// OE9 indicator9 (Overrun9 Error) bug9 fixed9.
// PE9 indicator9 (Parity9 Error) bug9 fixed9.
// Register read bug9 fixed9.
//
// Revision9 1.10  2001/06/23 11:21:48  gorban9
// DL9 made9 16-bit long9. Fixed9 transmission9/reception9 bugs9.
//
// Revision9 1.9  2001/05/31 20:08:01  gorban9
// FIFO changes9 and other corrections9.
//
// Revision9 1.8  2001/05/29 20:05:04  gorban9
// Fixed9 some9 bugs9 and synthesis9 problems9.
//
// Revision9 1.7  2001/05/27 17:37:49  gorban9
// Fixed9 many9 bugs9. Updated9 spec9. Changed9 FIFO files structure9. See CHANGES9.txt9 file.
//
// Revision9 1.6  2001/05/21 19:12:02  gorban9
// Corrected9 some9 Linter9 messages9.
//
// Revision9 1.5  2001/05/17 18:34:18  gorban9
// First9 'stable' release. Should9 be sythesizable9 now. Also9 added new header.
//
// Revision9 1.0  2001-05-17 21:27:11+02  jacob9
// Initial9 revision9
//
//

// synopsys9 translate_off9
`include "timescale.v"
// synopsys9 translate_on9

`include "uart_defines9.v"

`define UART_DL19 7:0
`define UART_DL29 15:8

module uart_regs9 (clk9,
	wb_rst_i9, wb_addr_i9, wb_dat_i9, wb_dat_o9, wb_we_i9, wb_re_i9, 

// additional9 signals9
	modem_inputs9,
	stx_pad_o9, srx_pad_i9,

`ifdef DATA_BUS_WIDTH_89
`else
// debug9 interface signals9	enabled
ier9, iir9, fcr9, mcr9, lcr9, msr9, lsr9, rf_count9, tf_count9, tstate9, rstate,
`endif				
	rts_pad_o9, dtr_pad_o9, int_o9
`ifdef UART_HAS_BAUDRATE_OUTPUT9
	, baud_o9
`endif

	);

input 									clk9;
input 									wb_rst_i9;
input [`UART_ADDR_WIDTH9-1:0] 		wb_addr_i9;
input [7:0] 							wb_dat_i9;
output [7:0] 							wb_dat_o9;
input 									wb_we_i9;
input 									wb_re_i9;

output 									stx_pad_o9;
input 									srx_pad_i9;

input [3:0] 							modem_inputs9;
output 									rts_pad_o9;
output 									dtr_pad_o9;
output 									int_o9;
`ifdef UART_HAS_BAUDRATE_OUTPUT9
output	baud_o9;
`endif

`ifdef DATA_BUS_WIDTH_89
`else
// if 32-bit databus9 and debug9 interface are enabled
output [3:0]							ier9;
output [3:0]							iir9;
output [1:0]							fcr9;  /// bits 7 and 6 of fcr9. Other9 bits are ignored
output [4:0]							mcr9;
output [7:0]							lcr9;
output [7:0]							msr9;
output [7:0] 							lsr9;
output [`UART_FIFO_COUNTER_W9-1:0] 	rf_count9;
output [`UART_FIFO_COUNTER_W9-1:0] 	tf_count9;
output [2:0] 							tstate9;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs9;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT9
assign baud_o9 = enable; // baud_o9 is actually9 the enable signal9
`endif


wire 										stx_pad_o9;		// received9 from transmitter9 module
wire 										srx_pad_i9;
wire 										srx_pad9;

reg [7:0] 								wb_dat_o9;

wire [`UART_ADDR_WIDTH9-1:0] 		wb_addr_i9;
wire [7:0] 								wb_dat_i9;


reg [3:0] 								ier9;
reg [3:0] 								iir9;
reg [1:0] 								fcr9;  /// bits 7 and 6 of fcr9. Other9 bits are ignored
reg [4:0] 								mcr9;
reg [7:0] 								lcr9;
reg [7:0] 								msr9;
reg [15:0] 								dl9;  // 32-bit divisor9 latch9
reg [7:0] 								scratch9; // UART9 scratch9 register
reg 										start_dlc9; // activate9 dlc9 on writing to UART_DL19
reg 										lsr_mask_d9; // delay for lsr_mask9 condition
reg 										msi_reset9; // reset MSR9 4 lower9 bits indicator9
//reg 										threi_clear9; // THRE9 interrupt9 clear flag9
reg [15:0] 								dlc9;  // 32-bit divisor9 latch9 counter
reg 										int_o9;

reg [3:0] 								trigger_level9; // trigger level of the receiver9 FIFO
reg 										rx_reset9;
reg 										tx_reset9;

wire 										dlab9;			   // divisor9 latch9 access bit
wire 										cts_pad_i9, dsr_pad_i9, ri_pad_i9, dcd_pad_i9; // modem9 status bits
wire 										loopback9;		   // loopback9 bit (MCR9 bit 4)
wire 										cts9, dsr9, ri, dcd9;	   // effective9 signals9
wire                    cts_c9, dsr_c9, ri_c9, dcd_c9; // Complement9 effective9 signals9 (considering9 loopback9)
wire 										rts_pad_o9, dtr_pad_o9;		   // modem9 control9 outputs9

// LSR9 bits wires9 and regs
wire [7:0] 								lsr9;
wire 										lsr09, lsr19, lsr29, lsr39, lsr49, lsr59, lsr69, lsr79;
reg										lsr0r9, lsr1r9, lsr2r9, lsr3r9, lsr4r9, lsr5r9, lsr6r9, lsr7r9;
wire 										lsr_mask9; // lsr_mask9

//
// ASSINGS9
//

assign 									lsr9[7:0] = { lsr7r9, lsr6r9, lsr5r9, lsr4r9, lsr3r9, lsr2r9, lsr1r9, lsr0r9 };

assign 									{cts_pad_i9, dsr_pad_i9, ri_pad_i9, dcd_pad_i9} = modem_inputs9;
assign 									{cts9, dsr9, ri, dcd9} = ~{cts_pad_i9,dsr_pad_i9,ri_pad_i9,dcd_pad_i9};

assign                  {cts_c9, dsr_c9, ri_c9, dcd_c9} = loopback9 ? {mcr9[`UART_MC_RTS9],mcr9[`UART_MC_DTR9],mcr9[`UART_MC_OUT19],mcr9[`UART_MC_OUT29]}
                                                               : {cts_pad_i9,dsr_pad_i9,ri_pad_i9,dcd_pad_i9};

assign 									dlab9 = lcr9[`UART_LC_DL9];
assign 									loopback9 = mcr9[4];

// assign modem9 outputs9
assign 									rts_pad_o9 = mcr9[`UART_MC_RTS9];
assign 									dtr_pad_o9 = mcr9[`UART_MC_DTR9];

// Interrupt9 signals9
wire 										rls_int9;  // receiver9 line status interrupt9
wire 										rda_int9;  // receiver9 data available interrupt9
wire 										ti_int9;   // timeout indicator9 interrupt9
wire										thre_int9; // transmitter9 holding9 register empty9 interrupt9
wire 										ms_int9;   // modem9 status interrupt9

// FIFO signals9
reg 										tf_push9;
reg 										rf_pop9;
wire [`UART_FIFO_REC_WIDTH9-1:0] 	rf_data_out9;
wire 										rf_error_bit9; // an error (parity9 or framing9) is inside the fifo
wire [`UART_FIFO_COUNTER_W9-1:0] 	rf_count9;
wire [`UART_FIFO_COUNTER_W9-1:0] 	tf_count9;
wire [2:0] 								tstate9;
wire [3:0] 								rstate;
wire [9:0] 								counter_t9;

wire                      thre_set_en9; // THRE9 status is delayed9 one character9 time when a character9 is written9 to fifo.
reg  [7:0]                block_cnt9;   // While9 counter counts9, THRE9 status is blocked9 (delayed9 one character9 cycle)
reg  [7:0]                block_value9; // One9 character9 length minus9 stop bit

// Transmitter9 Instance
wire serial_out9;

uart_transmitter9 transmitter9(clk9, wb_rst_i9, lcr9, tf_push9, wb_dat_i9, enable, serial_out9, tstate9, tf_count9, tx_reset9, lsr_mask9);

  // Synchronizing9 and sampling9 serial9 RX9 input
  uart_sync_flops9    i_uart_sync_flops9
  (
    .rst_i9           (wb_rst_i9),
    .clk_i9           (clk9),
    .stage1_rst_i9    (1'b0),
    .stage1_clk_en_i9 (1'b1),
    .async_dat_i9     (srx_pad_i9),
    .sync_dat_o9      (srx_pad9)
  );
  defparam i_uart_sync_flops9.width      = 1;
  defparam i_uart_sync_flops9.init_value9 = 1'b1;

// handle loopback9
wire serial_in9 = loopback9 ? serial_out9 : srx_pad9;
assign stx_pad_o9 = loopback9 ? 1'b1 : serial_out9;

// Receiver9 Instance
uart_receiver9 receiver9(clk9, wb_rst_i9, lcr9, rf_pop9, serial_in9, enable, 
	counter_t9, rf_count9, rf_data_out9, rf_error_bit9, rf_overrun9, rx_reset9, lsr_mask9, rstate, rf_push_pulse9);


// Asynchronous9 reading here9 because the outputs9 are sampled9 in uart_wb9.v file 
always @(dl9 or dlab9 or ier9 or iir9 or scratch9
			or lcr9 or lsr9 or msr9 or rf_data_out9 or wb_addr_i9 or wb_re_i9)   // asynchrounous9 reading
begin
	case (wb_addr_i9)
		`UART_REG_RB9   : wb_dat_o9 = dlab9 ? dl9[`UART_DL19] : rf_data_out9[10:3];
		`UART_REG_IE9	: wb_dat_o9 = dlab9 ? dl9[`UART_DL29] : ier9;
		`UART_REG_II9	: wb_dat_o9 = {4'b1100,iir9};
		`UART_REG_LC9	: wb_dat_o9 = lcr9;
		`UART_REG_LS9	: wb_dat_o9 = lsr9;
		`UART_REG_MS9	: wb_dat_o9 = msr9;
		`UART_REG_SR9	: wb_dat_o9 = scratch9;
		default:  wb_dat_o9 = 8'b0; // ??
	endcase // case(wb_addr_i9)
end // always @ (dl9 or dlab9 or ier9 or iir9 or scratch9...


// rf_pop9 signal9 handling9
always @(posedge clk9 or posedge wb_rst_i9)
begin
	if (wb_rst_i9)
		rf_pop9 <= #1 0; 
	else
	if (rf_pop9)	// restore9 the signal9 to 0 after one clock9 cycle
		rf_pop9 <= #1 0;
	else
	if (wb_re_i9 && wb_addr_i9 == `UART_REG_RB9 && !dlab9)
		rf_pop9 <= #1 1; // advance9 read pointer9
end

wire 	lsr_mask_condition9;
wire 	iir_read9;
wire  msr_read9;
wire	fifo_read9;
wire	fifo_write9;

assign lsr_mask_condition9 = (wb_re_i9 && wb_addr_i9 == `UART_REG_LS9 && !dlab9);
assign iir_read9 = (wb_re_i9 && wb_addr_i9 == `UART_REG_II9 && !dlab9);
assign msr_read9 = (wb_re_i9 && wb_addr_i9 == `UART_REG_MS9 && !dlab9);
assign fifo_read9 = (wb_re_i9 && wb_addr_i9 == `UART_REG_RB9 && !dlab9);
assign fifo_write9 = (wb_we_i9 && wb_addr_i9 == `UART_REG_TR9 && !dlab9);

// lsr_mask_d9 delayed9 signal9 handling9
always @(posedge clk9 or posedge wb_rst_i9)
begin
	if (wb_rst_i9)
		lsr_mask_d9 <= #1 0;
	else // reset bits in the Line9 Status Register
		lsr_mask_d9 <= #1 lsr_mask_condition9;
end

// lsr_mask9 is rise9 detected
assign lsr_mask9 = lsr_mask_condition9 && ~lsr_mask_d9;

// msi_reset9 signal9 handling9
always @(posedge clk9 or posedge wb_rst_i9)
begin
	if (wb_rst_i9)
		msi_reset9 <= #1 1;
	else
	if (msi_reset9)
		msi_reset9 <= #1 0;
	else
	if (msr_read9)
		msi_reset9 <= #1 1; // reset bits in Modem9 Status Register
end


//
//   WRITES9 AND9 RESETS9   //
//
// Line9 Control9 Register
always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9)
		lcr9 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i9 && wb_addr_i9==`UART_REG_LC9)
		lcr9 <= #1 wb_dat_i9;

// Interrupt9 Enable9 Register or UART_DL29
always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9)
	begin
		ier9 <= #1 4'b0000; // no interrupts9 after reset
		dl9[`UART_DL29] <= #1 8'b0;
	end
	else
	if (wb_we_i9 && wb_addr_i9==`UART_REG_IE9)
		if (dlab9)
		begin
			dl9[`UART_DL29] <= #1 wb_dat_i9;
		end
		else
			ier9 <= #1 wb_dat_i9[3:0]; // ier9 uses only 4 lsb


// FIFO Control9 Register and rx_reset9, tx_reset9 signals9
always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) begin
		fcr9 <= #1 2'b11; 
		rx_reset9 <= #1 0;
		tx_reset9 <= #1 0;
	end else
	if (wb_we_i9 && wb_addr_i9==`UART_REG_FC9) begin
		fcr9 <= #1 wb_dat_i9[7:6];
		rx_reset9 <= #1 wb_dat_i9[1];
		tx_reset9 <= #1 wb_dat_i9[2];
	end else begin
		rx_reset9 <= #1 0;
		tx_reset9 <= #1 0;
	end

// Modem9 Control9 Register
always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9)
		mcr9 <= #1 5'b0; 
	else
	if (wb_we_i9 && wb_addr_i9==`UART_REG_MC9)
			mcr9 <= #1 wb_dat_i9[4:0];

// Scratch9 register
// Line9 Control9 Register
always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9)
		scratch9 <= #1 0; // 8n1 setting
	else
	if (wb_we_i9 && wb_addr_i9==`UART_REG_SR9)
		scratch9 <= #1 wb_dat_i9;

// TX_FIFO9 or UART_DL19
always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9)
	begin
		dl9[`UART_DL19]  <= #1 8'b0;
		tf_push9   <= #1 1'b0;
		start_dlc9 <= #1 1'b0;
	end
	else
	if (wb_we_i9 && wb_addr_i9==`UART_REG_TR9)
		if (dlab9)
		begin
			dl9[`UART_DL19] <= #1 wb_dat_i9;
			start_dlc9 <= #1 1'b1; // enable DL9 counter
			tf_push9 <= #1 1'b0;
		end
		else
		begin
			tf_push9   <= #1 1'b1;
			start_dlc9 <= #1 1'b0;
		end // else: !if(dlab9)
	else
	begin
		start_dlc9 <= #1 1'b0;
		tf_push9   <= #1 1'b0;
	end // else: !if(dlab9)

// Receiver9 FIFO trigger level selection logic (asynchronous9 mux9)
always @(fcr9)
	case (fcr9[`UART_FC_TL9])
		2'b00 : trigger_level9 = 1;
		2'b01 : trigger_level9 = 4;
		2'b10 : trigger_level9 = 8;
		2'b11 : trigger_level9 = 14;
	endcase // case(fcr9[`UART_FC_TL9])
	
//
//  STATUS9 REGISTERS9  //
//

// Modem9 Status Register
reg [3:0] delayed_modem_signals9;
always @(posedge clk9 or posedge wb_rst_i9)
begin
	if (wb_rst_i9)
	  begin
  		msr9 <= #1 0;
	  	delayed_modem_signals9[3:0] <= #1 0;
	  end
	else begin
		msr9[`UART_MS_DDCD9:`UART_MS_DCTS9] <= #1 msi_reset9 ? 4'b0 :
			msr9[`UART_MS_DDCD9:`UART_MS_DCTS9] | ({dcd9, ri, dsr9, cts9} ^ delayed_modem_signals9[3:0]);
		msr9[`UART_MS_CDCD9:`UART_MS_CCTS9] <= #1 {dcd_c9, ri_c9, dsr_c9, cts_c9};
		delayed_modem_signals9[3:0] <= #1 {dcd9, ri, dsr9, cts9};
	end
end


// Line9 Status Register

// activation9 conditions9
assign lsr09 = (rf_count9==0 && rf_push_pulse9);  // data in receiver9 fifo available set condition
assign lsr19 = rf_overrun9;     // Receiver9 overrun9 error
assign lsr29 = rf_data_out9[1]; // parity9 error bit
assign lsr39 = rf_data_out9[0]; // framing9 error bit
assign lsr49 = rf_data_out9[2]; // break error in the character9
assign lsr59 = (tf_count9==5'b0 && thre_set_en9);  // transmitter9 fifo is empty9
assign lsr69 = (tf_count9==5'b0 && thre_set_en9 && (tstate9 == /*`S_IDLE9 */ 0)); // transmitter9 empty9
assign lsr79 = rf_error_bit9 | rf_overrun9;

// lsr9 bit09 (receiver9 data available)
reg 	 lsr0_d9;

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr0_d9 <= #1 0;
	else lsr0_d9 <= #1 lsr09;

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr0r9 <= #1 0;
	else lsr0r9 <= #1 (rf_count9==1 && rf_pop9 && !rf_push_pulse9 || rx_reset9) ? 0 : // deassert9 condition
					  lsr0r9 || (lsr09 && ~lsr0_d9); // set on rise9 of lsr09 and keep9 asserted9 until deasserted9 

// lsr9 bit 1 (receiver9 overrun9)
reg lsr1_d9; // delayed9

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr1_d9 <= #1 0;
	else lsr1_d9 <= #1 lsr19;

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr1r9 <= #1 0;
	else	lsr1r9 <= #1	lsr_mask9 ? 0 : lsr1r9 || (lsr19 && ~lsr1_d9); // set on rise9

// lsr9 bit 2 (parity9 error)
reg lsr2_d9; // delayed9

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr2_d9 <= #1 0;
	else lsr2_d9 <= #1 lsr29;

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr2r9 <= #1 0;
	else lsr2r9 <= #1 lsr_mask9 ? 0 : lsr2r9 || (lsr29 && ~lsr2_d9); // set on rise9

// lsr9 bit 3 (framing9 error)
reg lsr3_d9; // delayed9

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr3_d9 <= #1 0;
	else lsr3_d9 <= #1 lsr39;

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr3r9 <= #1 0;
	else lsr3r9 <= #1 lsr_mask9 ? 0 : lsr3r9 || (lsr39 && ~lsr3_d9); // set on rise9

// lsr9 bit 4 (break indicator9)
reg lsr4_d9; // delayed9

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr4_d9 <= #1 0;
	else lsr4_d9 <= #1 lsr49;

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr4r9 <= #1 0;
	else lsr4r9 <= #1 lsr_mask9 ? 0 : lsr4r9 || (lsr49 && ~lsr4_d9);

// lsr9 bit 5 (transmitter9 fifo is empty9)
reg lsr5_d9;

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr5_d9 <= #1 1;
	else lsr5_d9 <= #1 lsr59;

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr5r9 <= #1 1;
	else lsr5r9 <= #1 (fifo_write9) ? 0 :  lsr5r9 || (lsr59 && ~lsr5_d9);

// lsr9 bit 6 (transmitter9 empty9 indicator9)
reg lsr6_d9;

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr6_d9 <= #1 1;
	else lsr6_d9 <= #1 lsr69;

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr6r9 <= #1 1;
	else lsr6r9 <= #1 (fifo_write9) ? 0 : lsr6r9 || (lsr69 && ~lsr6_d9);

// lsr9 bit 7 (error in fifo)
reg lsr7_d9;

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr7_d9 <= #1 0;
	else lsr7_d9 <= #1 lsr79;

always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) lsr7r9 <= #1 0;
	else lsr7r9 <= #1 lsr_mask9 ? 0 : lsr7r9 || (lsr79 && ~lsr7_d9);

// Frequency9 divider9
always @(posedge clk9 or posedge wb_rst_i9) 
begin
	if (wb_rst_i9)
		dlc9 <= #1 0;
	else
		if (start_dlc9 | ~ (|dlc9))
  			dlc9 <= #1 dl9 - 1;               // preset9 counter
		else
			dlc9 <= #1 dlc9 - 1;              // decrement counter
end

// Enable9 signal9 generation9 logic
always @(posedge clk9 or posedge wb_rst_i9)
begin
	if (wb_rst_i9)
		enable <= #1 1'b0;
	else
		if (|dl9 & ~(|dlc9))     // dl9>0 & dlc9==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying9 THRE9 status for one character9 cycle after a character9 is written9 to an empty9 fifo.
always @(lcr9)
  case (lcr9[3:0])
    4'b0000                             : block_value9 =  95; // 6 bits
    4'b0100                             : block_value9 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value9 = 111; // 7 bits
    4'b1100                             : block_value9 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value9 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value9 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value9 = 159; // 10 bits
    4'b1111                             : block_value9 = 175; // 11 bits
  endcase // case(lcr9[3:0])

// Counting9 time of one character9 minus9 stop bit
always @(posedge clk9 or posedge wb_rst_i9)
begin
  if (wb_rst_i9)
    block_cnt9 <= #1 8'd0;
  else
  if(lsr5r9 & fifo_write9)  // THRE9 bit set & write to fifo occured9
    block_cnt9 <= #1 block_value9;
  else
  if (enable & block_cnt9 != 8'b0)  // only work9 on enable times
    block_cnt9 <= #1 block_cnt9 - 1;  // decrement break counter
end // always of break condition detection9

// Generating9 THRE9 status enable signal9
assign thre_set_en9 = ~(|block_cnt9);


//
//	INTERRUPT9 LOGIC9
//

assign rls_int9  = ier9[`UART_IE_RLS9] && (lsr9[`UART_LS_OE9] || lsr9[`UART_LS_PE9] || lsr9[`UART_LS_FE9] || lsr9[`UART_LS_BI9]);
assign rda_int9  = ier9[`UART_IE_RDA9] && (rf_count9 >= {1'b0,trigger_level9});
assign thre_int9 = ier9[`UART_IE_THRE9] && lsr9[`UART_LS_TFE9];
assign ms_int9   = ier9[`UART_IE_MS9] && (| msr9[3:0]);
assign ti_int9   = ier9[`UART_IE_RDA9] && (counter_t9 == 10'b0) && (|rf_count9);

reg 	 rls_int_d9;
reg 	 thre_int_d9;
reg 	 ms_int_d9;
reg 	 ti_int_d9;
reg 	 rda_int_d9;

// delay lines9
always  @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) rls_int_d9 <= #1 0;
	else rls_int_d9 <= #1 rls_int9;

always  @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) rda_int_d9 <= #1 0;
	else rda_int_d9 <= #1 rda_int9;

always  @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) thre_int_d9 <= #1 0;
	else thre_int_d9 <= #1 thre_int9;

always  @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) ms_int_d9 <= #1 0;
	else ms_int_d9 <= #1 ms_int9;

always  @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) ti_int_d9 <= #1 0;
	else ti_int_d9 <= #1 ti_int9;

// rise9 detection9 signals9

wire 	 rls_int_rise9;
wire 	 thre_int_rise9;
wire 	 ms_int_rise9;
wire 	 ti_int_rise9;
wire 	 rda_int_rise9;

assign rda_int_rise9    = rda_int9 & ~rda_int_d9;
assign rls_int_rise9 	  = rls_int9 & ~rls_int_d9;
assign thre_int_rise9   = thre_int9 & ~thre_int_d9;
assign ms_int_rise9 	  = ms_int9 & ~ms_int_d9;
assign ti_int_rise9 	  = ti_int9 & ~ti_int_d9;

// interrupt9 pending flags9
reg 	rls_int_pnd9;
reg	rda_int_pnd9;
reg 	thre_int_pnd9;
reg 	ms_int_pnd9;
reg 	ti_int_pnd9;

// interrupt9 pending flags9 assignments9
always  @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) rls_int_pnd9 <= #1 0; 
	else 
		rls_int_pnd9 <= #1 lsr_mask9 ? 0 :  						// reset condition
							rls_int_rise9 ? 1 :						// latch9 condition
							rls_int_pnd9 && ier9[`UART_IE_RLS9];	// default operation9: remove if masked9

always  @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) rda_int_pnd9 <= #1 0; 
	else 
		rda_int_pnd9 <= #1 ((rf_count9 == {1'b0,trigger_level9}) && fifo_read9) ? 0 :  	// reset condition
							rda_int_rise9 ? 1 :						// latch9 condition
							rda_int_pnd9 && ier9[`UART_IE_RDA9];	// default operation9: remove if masked9

always  @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) thre_int_pnd9 <= #1 0; 
	else 
		thre_int_pnd9 <= #1 fifo_write9 || (iir_read9 & ~iir9[`UART_II_IP9] & iir9[`UART_II_II9] == `UART_II_THRE9)? 0 : 
							thre_int_rise9 ? 1 :
							thre_int_pnd9 && ier9[`UART_IE_THRE9];

always  @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) ms_int_pnd9 <= #1 0; 
	else 
		ms_int_pnd9 <= #1 msr_read9 ? 0 : 
							ms_int_rise9 ? 1 :
							ms_int_pnd9 && ier9[`UART_IE_MS9];

always  @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) ti_int_pnd9 <= #1 0; 
	else 
		ti_int_pnd9 <= #1 fifo_read9 ? 0 : 
							ti_int_rise9 ? 1 :
							ti_int_pnd9 && ier9[`UART_IE_RDA9];
// end of pending flags9

// INT_O9 logic
always @(posedge clk9 or posedge wb_rst_i9)
begin
	if (wb_rst_i9)	
		int_o9 <= #1 1'b0;
	else
		int_o9 <= #1 
					rls_int_pnd9		?	~lsr_mask9					:
					rda_int_pnd9		? 1								:
					ti_int_pnd9		? ~fifo_read9					:
					thre_int_pnd9	? !(fifo_write9 & iir_read9) :
					ms_int_pnd9		? ~msr_read9						:
					0;	// if no interrupt9 are pending
end


// Interrupt9 Identification9 register
always @(posedge clk9 or posedge wb_rst_i9)
begin
	if (wb_rst_i9)
		iir9 <= #1 1;
	else
	if (rls_int_pnd9)  // interrupt9 is pending
	begin
		iir9[`UART_II_II9] <= #1 `UART_II_RLS9;	// set identification9 register to correct9 value
		iir9[`UART_II_IP9] <= #1 1'b0;		// and clear the IIR9 bit 0 (interrupt9 pending)
	end else // the sequence of conditions9 determines9 priority of interrupt9 identification9
	if (rda_int9)
	begin
		iir9[`UART_II_II9] <= #1 `UART_II_RDA9;
		iir9[`UART_II_IP9] <= #1 1'b0;
	end
	else if (ti_int_pnd9)
	begin
		iir9[`UART_II_II9] <= #1 `UART_II_TI9;
		iir9[`UART_II_IP9] <= #1 1'b0;
	end
	else if (thre_int_pnd9)
	begin
		iir9[`UART_II_II9] <= #1 `UART_II_THRE9;
		iir9[`UART_II_IP9] <= #1 1'b0;
	end
	else if (ms_int_pnd9)
	begin
		iir9[`UART_II_II9] <= #1 `UART_II_MS9;
		iir9[`UART_II_IP9] <= #1 1'b0;
	end else	// no interrupt9 is pending
	begin
		iir9[`UART_II_II9] <= #1 0;
		iir9[`UART_II_IP9] <= #1 1'b1;
	end
end

endmodule
