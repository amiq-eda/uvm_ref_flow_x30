//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs3.v                                                 ////
////                                                              ////
////                                                              ////
////  This3 file is part of the "UART3 16550 compatible3" project3    ////
////  http3://www3.opencores3.org3/cores3/uart165503/                   ////
////                                                              ////
////  Documentation3 related3 to this project3:                      ////
////  - http3://www3.opencores3.org3/cores3/uart165503/                 ////
////                                                              ////
////  Projects3 compatibility3:                                     ////
////  - WISHBONE3                                                  ////
////  RS2323 Protocol3                                              ////
////  16550D uart3 (mostly3 supported)                              ////
////                                                              ////
////  Overview3 (main3 Features3):                                   ////
////  Registers3 of the uart3 16550 core3                            ////
////                                                              ////
////  Known3 problems3 (limits3):                                    ////
////  Inserts3 1 wait state in all WISHBONE3 transfers3              ////
////                                                              ////
////  To3 Do3:                                                      ////
////  Nothing or verification3.                                    ////
////                                                              ////
////  Author3(s):                                                  ////
////      - gorban3@opencores3.org3                                  ////
////      - Jacob3 Gorban3                                          ////
////      - Igor3 Mohor3 (igorm3@opencores3.org3)                      ////
////                                                              ////
////  Created3:        2001/05/12                                  ////
////  Last3 Updated3:   (See log3 for the revision3 history3           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2000, 2001 Authors3                             ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS3 Revision3 History3
//
// $Log: not supported by cvs2svn3 $
// Revision3 1.41  2004/05/21 11:44:41  tadejm3
// Added3 synchronizer3 flops3 for RX3 input.
//
// Revision3 1.40  2003/06/11 16:37:47  gorban3
// This3 fixes3 errors3 in some3 cases3 when data is being read and put to the FIFO at the same time. Patch3 is submitted3 by Scott3 Furman3. Update is very3 recommended3.
//
// Revision3 1.39  2002/07/29 21:16:18  gorban3
// The uart_defines3.v file is included3 again3 in sources3.
//
// Revision3 1.38  2002/07/22 23:02:23  gorban3
// Bug3 Fixes3:
//  * Possible3 loss of sync and bad3 reception3 of stop bit on slow3 baud3 rates3 fixed3.
//   Problem3 reported3 by Kenny3.Tung3.
//  * Bad (or lack3 of ) loopback3 handling3 fixed3. Reported3 by Cherry3 Withers3.
//
// Improvements3:
//  * Made3 FIFO's as general3 inferrable3 memory where possible3.
//  So3 on FPGA3 they should be inferred3 as RAM3 (Distributed3 RAM3 on Xilinx3).
//  This3 saves3 about3 1/3 of the Slice3 count and reduces3 P&R and synthesis3 times.
//
//  * Added3 optional3 baudrate3 output (baud_o3).
//  This3 is identical3 to BAUDOUT3* signal3 on 16550 chip3.
//  It outputs3 16xbit_clock_rate - the divided3 clock3.
//  It's disabled by default. Define3 UART_HAS_BAUDRATE_OUTPUT3 to use.
//
// Revision3 1.37  2001/12/27 13:24:09  mohor3
// lsr3[7] was not showing3 overrun3 errors3.
//
// Revision3 1.36  2001/12/20 13:25:46  mohor3
// rx3 push3 changed to be only one cycle wide3.
//
// Revision3 1.35  2001/12/19 08:03:34  mohor3
// Warnings3 cleared3.
//
// Revision3 1.34  2001/12/19 07:33:54  mohor3
// Synplicity3 was having3 troubles3 with the comment3.
//
// Revision3 1.33  2001/12/17 10:14:43  mohor3
// Things3 related3 to msr3 register changed. After3 THRE3 IRQ3 occurs3, and one
// character3 is written3 to the transmit3 fifo, the detection3 of the THRE3 bit in the
// LSR3 is delayed3 for one character3 time.
//
// Revision3 1.32  2001/12/14 13:19:24  mohor3
// MSR3 register fixed3.
//
// Revision3 1.31  2001/12/14 10:06:58  mohor3
// After3 reset modem3 status register MSR3 should be reset.
//
// Revision3 1.30  2001/12/13 10:09:13  mohor3
// thre3 irq3 should be cleared3 only when being source3 of interrupt3.
//
// Revision3 1.29  2001/12/12 09:05:46  mohor3
// LSR3 status bit 0 was not cleared3 correctly in case of reseting3 the FCR3 (rx3 fifo).
//
// Revision3 1.28  2001/12/10 19:52:41  gorban3
// Scratch3 register added
//
// Revision3 1.27  2001/12/06 14:51:04  gorban3
// Bug3 in LSR3[0] is fixed3.
// All WISHBONE3 signals3 are now sampled3, so another3 wait-state is introduced3 on all transfers3.
//
// Revision3 1.26  2001/12/03 21:44:29  gorban3
// Updated3 specification3 documentation.
// Added3 full 32-bit data bus interface, now as default.
// Address is 5-bit wide3 in 32-bit data bus mode.
// Added3 wb_sel_i3 input to the core3. It's used in the 32-bit mode.
// Added3 debug3 interface with two3 32-bit read-only registers in 32-bit mode.
// Bits3 5 and 6 of LSR3 are now only cleared3 on TX3 FIFO write.
// My3 small test bench3 is modified to work3 with 32-bit mode.
//
// Revision3 1.25  2001/11/28 19:36:39  gorban3
// Fixed3: timeout and break didn3't pay3 attention3 to current data format3 when counting3 time
//
// Revision3 1.24  2001/11/26 21:38:54  gorban3
// Lots3 of fixes3:
// Break3 condition wasn3't handled3 correctly at all.
// LSR3 bits could lose3 their3 values.
// LSR3 value after reset was wrong3.
// Timing3 of THRE3 interrupt3 signal3 corrected3.
// LSR3 bit 0 timing3 corrected3.
//
// Revision3 1.23  2001/11/12 21:57:29  gorban3
// fixed3 more typo3 bugs3
//
// Revision3 1.22  2001/11/12 15:02:28  mohor3
// lsr1r3 error fixed3.
//
// Revision3 1.21  2001/11/12 14:57:27  mohor3
// ti_int_pnd3 error fixed3.
//
// Revision3 1.20  2001/11/12 14:50:27  mohor3
// ti_int_d3 error fixed3.
//
// Revision3 1.19  2001/11/10 12:43:21  gorban3
// Logic3 Synthesis3 bugs3 fixed3. Some3 other minor3 changes3
//
// Revision3 1.18  2001/11/08 14:54:23  mohor3
// Comments3 in Slovene3 language3 deleted3, few3 small fixes3 for better3 work3 of
// old3 tools3. IRQs3 need to be fix3.
//
// Revision3 1.17  2001/11/07 17:51:52  gorban3
// Heavily3 rewritten3 interrupt3 and LSR3 subsystems3.
// Many3 bugs3 hopefully3 squashed3.
//
// Revision3 1.16  2001/11/02 09:55:16  mohor3
// no message
//
// Revision3 1.15  2001/10/31 15:19:22  gorban3
// Fixes3 to break and timeout conditions3
//
// Revision3 1.14  2001/10/29 17:00:46  gorban3
// fixed3 parity3 sending3 and tx_fifo3 resets3 over- and underrun3
//
// Revision3 1.13  2001/10/20 09:58:40  gorban3
// Small3 synopsis3 fixes3
//
// Revision3 1.12  2001/10/19 16:21:40  gorban3
// Changes3 data_out3 to be synchronous3 again3 as it should have been.
//
// Revision3 1.11  2001/10/18 20:35:45  gorban3
// small fix3
//
// Revision3 1.10  2001/08/24 21:01:12  mohor3
// Things3 connected3 to parity3 changed.
// Clock3 devider3 changed.
//
// Revision3 1.9  2001/08/23 16:05:05  mohor3
// Stop bit bug3 fixed3.
// Parity3 bug3 fixed3.
// WISHBONE3 read cycle bug3 fixed3,
// OE3 indicator3 (Overrun3 Error) bug3 fixed3.
// PE3 indicator3 (Parity3 Error) bug3 fixed3.
// Register read bug3 fixed3.
//
// Revision3 1.10  2001/06/23 11:21:48  gorban3
// DL3 made3 16-bit long3. Fixed3 transmission3/reception3 bugs3.
//
// Revision3 1.9  2001/05/31 20:08:01  gorban3
// FIFO changes3 and other corrections3.
//
// Revision3 1.8  2001/05/29 20:05:04  gorban3
// Fixed3 some3 bugs3 and synthesis3 problems3.
//
// Revision3 1.7  2001/05/27 17:37:49  gorban3
// Fixed3 many3 bugs3. Updated3 spec3. Changed3 FIFO files structure3. See CHANGES3.txt3 file.
//
// Revision3 1.6  2001/05/21 19:12:02  gorban3
// Corrected3 some3 Linter3 messages3.
//
// Revision3 1.5  2001/05/17 18:34:18  gorban3
// First3 'stable' release. Should3 be sythesizable3 now. Also3 added new header.
//
// Revision3 1.0  2001-05-17 21:27:11+02  jacob3
// Initial3 revision3
//
//

// synopsys3 translate_off3
`include "timescale.v"
// synopsys3 translate_on3

`include "uart_defines3.v"

`define UART_DL13 7:0
`define UART_DL23 15:8

module uart_regs3 (clk3,
	wb_rst_i3, wb_addr_i3, wb_dat_i3, wb_dat_o3, wb_we_i3, wb_re_i3, 

// additional3 signals3
	modem_inputs3,
	stx_pad_o3, srx_pad_i3,

`ifdef DATA_BUS_WIDTH_83
`else
// debug3 interface signals3	enabled
ier3, iir3, fcr3, mcr3, lcr3, msr3, lsr3, rf_count3, tf_count3, tstate3, rstate,
`endif				
	rts_pad_o3, dtr_pad_o3, int_o3
`ifdef UART_HAS_BAUDRATE_OUTPUT3
	, baud_o3
`endif

	);

input 									clk3;
input 									wb_rst_i3;
input [`UART_ADDR_WIDTH3-1:0] 		wb_addr_i3;
input [7:0] 							wb_dat_i3;
output [7:0] 							wb_dat_o3;
input 									wb_we_i3;
input 									wb_re_i3;

output 									stx_pad_o3;
input 									srx_pad_i3;

input [3:0] 							modem_inputs3;
output 									rts_pad_o3;
output 									dtr_pad_o3;
output 									int_o3;
`ifdef UART_HAS_BAUDRATE_OUTPUT3
output	baud_o3;
`endif

`ifdef DATA_BUS_WIDTH_83
`else
// if 32-bit databus3 and debug3 interface are enabled
output [3:0]							ier3;
output [3:0]							iir3;
output [1:0]							fcr3;  /// bits 7 and 6 of fcr3. Other3 bits are ignored
output [4:0]							mcr3;
output [7:0]							lcr3;
output [7:0]							msr3;
output [7:0] 							lsr3;
output [`UART_FIFO_COUNTER_W3-1:0] 	rf_count3;
output [`UART_FIFO_COUNTER_W3-1:0] 	tf_count3;
output [2:0] 							tstate3;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs3;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT3
assign baud_o3 = enable; // baud_o3 is actually3 the enable signal3
`endif


wire 										stx_pad_o3;		// received3 from transmitter3 module
wire 										srx_pad_i3;
wire 										srx_pad3;

reg [7:0] 								wb_dat_o3;

wire [`UART_ADDR_WIDTH3-1:0] 		wb_addr_i3;
wire [7:0] 								wb_dat_i3;


reg [3:0] 								ier3;
reg [3:0] 								iir3;
reg [1:0] 								fcr3;  /// bits 7 and 6 of fcr3. Other3 bits are ignored
reg [4:0] 								mcr3;
reg [7:0] 								lcr3;
reg [7:0] 								msr3;
reg [15:0] 								dl3;  // 32-bit divisor3 latch3
reg [7:0] 								scratch3; // UART3 scratch3 register
reg 										start_dlc3; // activate3 dlc3 on writing to UART_DL13
reg 										lsr_mask_d3; // delay for lsr_mask3 condition
reg 										msi_reset3; // reset MSR3 4 lower3 bits indicator3
//reg 										threi_clear3; // THRE3 interrupt3 clear flag3
reg [15:0] 								dlc3;  // 32-bit divisor3 latch3 counter
reg 										int_o3;

reg [3:0] 								trigger_level3; // trigger level of the receiver3 FIFO
reg 										rx_reset3;
reg 										tx_reset3;

wire 										dlab3;			   // divisor3 latch3 access bit
wire 										cts_pad_i3, dsr_pad_i3, ri_pad_i3, dcd_pad_i3; // modem3 status bits
wire 										loopback3;		   // loopback3 bit (MCR3 bit 4)
wire 										cts3, dsr3, ri, dcd3;	   // effective3 signals3
wire                    cts_c3, dsr_c3, ri_c3, dcd_c3; // Complement3 effective3 signals3 (considering3 loopback3)
wire 										rts_pad_o3, dtr_pad_o3;		   // modem3 control3 outputs3

// LSR3 bits wires3 and regs
wire [7:0] 								lsr3;
wire 										lsr03, lsr13, lsr23, lsr33, lsr43, lsr53, lsr63, lsr73;
reg										lsr0r3, lsr1r3, lsr2r3, lsr3r3, lsr4r3, lsr5r3, lsr6r3, lsr7r3;
wire 										lsr_mask3; // lsr_mask3

//
// ASSINGS3
//

assign 									lsr3[7:0] = { lsr7r3, lsr6r3, lsr5r3, lsr4r3, lsr3r3, lsr2r3, lsr1r3, lsr0r3 };

assign 									{cts_pad_i3, dsr_pad_i3, ri_pad_i3, dcd_pad_i3} = modem_inputs3;
assign 									{cts3, dsr3, ri, dcd3} = ~{cts_pad_i3,dsr_pad_i3,ri_pad_i3,dcd_pad_i3};

assign                  {cts_c3, dsr_c3, ri_c3, dcd_c3} = loopback3 ? {mcr3[`UART_MC_RTS3],mcr3[`UART_MC_DTR3],mcr3[`UART_MC_OUT13],mcr3[`UART_MC_OUT23]}
                                                               : {cts_pad_i3,dsr_pad_i3,ri_pad_i3,dcd_pad_i3};

assign 									dlab3 = lcr3[`UART_LC_DL3];
assign 									loopback3 = mcr3[4];

// assign modem3 outputs3
assign 									rts_pad_o3 = mcr3[`UART_MC_RTS3];
assign 									dtr_pad_o3 = mcr3[`UART_MC_DTR3];

// Interrupt3 signals3
wire 										rls_int3;  // receiver3 line status interrupt3
wire 										rda_int3;  // receiver3 data available interrupt3
wire 										ti_int3;   // timeout indicator3 interrupt3
wire										thre_int3; // transmitter3 holding3 register empty3 interrupt3
wire 										ms_int3;   // modem3 status interrupt3

// FIFO signals3
reg 										tf_push3;
reg 										rf_pop3;
wire [`UART_FIFO_REC_WIDTH3-1:0] 	rf_data_out3;
wire 										rf_error_bit3; // an error (parity3 or framing3) is inside the fifo
wire [`UART_FIFO_COUNTER_W3-1:0] 	rf_count3;
wire [`UART_FIFO_COUNTER_W3-1:0] 	tf_count3;
wire [2:0] 								tstate3;
wire [3:0] 								rstate;
wire [9:0] 								counter_t3;

wire                      thre_set_en3; // THRE3 status is delayed3 one character3 time when a character3 is written3 to fifo.
reg  [7:0]                block_cnt3;   // While3 counter counts3, THRE3 status is blocked3 (delayed3 one character3 cycle)
reg  [7:0]                block_value3; // One3 character3 length minus3 stop bit

// Transmitter3 Instance
wire serial_out3;

uart_transmitter3 transmitter3(clk3, wb_rst_i3, lcr3, tf_push3, wb_dat_i3, enable, serial_out3, tstate3, tf_count3, tx_reset3, lsr_mask3);

  // Synchronizing3 and sampling3 serial3 RX3 input
  uart_sync_flops3    i_uart_sync_flops3
  (
    .rst_i3           (wb_rst_i3),
    .clk_i3           (clk3),
    .stage1_rst_i3    (1'b0),
    .stage1_clk_en_i3 (1'b1),
    .async_dat_i3     (srx_pad_i3),
    .sync_dat_o3      (srx_pad3)
  );
  defparam i_uart_sync_flops3.width      = 1;
  defparam i_uart_sync_flops3.init_value3 = 1'b1;

// handle loopback3
wire serial_in3 = loopback3 ? serial_out3 : srx_pad3;
assign stx_pad_o3 = loopback3 ? 1'b1 : serial_out3;

// Receiver3 Instance
uart_receiver3 receiver3(clk3, wb_rst_i3, lcr3, rf_pop3, serial_in3, enable, 
	counter_t3, rf_count3, rf_data_out3, rf_error_bit3, rf_overrun3, rx_reset3, lsr_mask3, rstate, rf_push_pulse3);


// Asynchronous3 reading here3 because the outputs3 are sampled3 in uart_wb3.v file 
always @(dl3 or dlab3 or ier3 or iir3 or scratch3
			or lcr3 or lsr3 or msr3 or rf_data_out3 or wb_addr_i3 or wb_re_i3)   // asynchrounous3 reading
begin
	case (wb_addr_i3)
		`UART_REG_RB3   : wb_dat_o3 = dlab3 ? dl3[`UART_DL13] : rf_data_out3[10:3];
		`UART_REG_IE3	: wb_dat_o3 = dlab3 ? dl3[`UART_DL23] : ier3;
		`UART_REG_II3	: wb_dat_o3 = {4'b1100,iir3};
		`UART_REG_LC3	: wb_dat_o3 = lcr3;
		`UART_REG_LS3	: wb_dat_o3 = lsr3;
		`UART_REG_MS3	: wb_dat_o3 = msr3;
		`UART_REG_SR3	: wb_dat_o3 = scratch3;
		default:  wb_dat_o3 = 8'b0; // ??
	endcase // case(wb_addr_i3)
end // always @ (dl3 or dlab3 or ier3 or iir3 or scratch3...


// rf_pop3 signal3 handling3
always @(posedge clk3 or posedge wb_rst_i3)
begin
	if (wb_rst_i3)
		rf_pop3 <= #1 0; 
	else
	if (rf_pop3)	// restore3 the signal3 to 0 after one clock3 cycle
		rf_pop3 <= #1 0;
	else
	if (wb_re_i3 && wb_addr_i3 == `UART_REG_RB3 && !dlab3)
		rf_pop3 <= #1 1; // advance3 read pointer3
end

wire 	lsr_mask_condition3;
wire 	iir_read3;
wire  msr_read3;
wire	fifo_read3;
wire	fifo_write3;

assign lsr_mask_condition3 = (wb_re_i3 && wb_addr_i3 == `UART_REG_LS3 && !dlab3);
assign iir_read3 = (wb_re_i3 && wb_addr_i3 == `UART_REG_II3 && !dlab3);
assign msr_read3 = (wb_re_i3 && wb_addr_i3 == `UART_REG_MS3 && !dlab3);
assign fifo_read3 = (wb_re_i3 && wb_addr_i3 == `UART_REG_RB3 && !dlab3);
assign fifo_write3 = (wb_we_i3 && wb_addr_i3 == `UART_REG_TR3 && !dlab3);

// lsr_mask_d3 delayed3 signal3 handling3
always @(posedge clk3 or posedge wb_rst_i3)
begin
	if (wb_rst_i3)
		lsr_mask_d3 <= #1 0;
	else // reset bits in the Line3 Status Register
		lsr_mask_d3 <= #1 lsr_mask_condition3;
end

// lsr_mask3 is rise3 detected
assign lsr_mask3 = lsr_mask_condition3 && ~lsr_mask_d3;

// msi_reset3 signal3 handling3
always @(posedge clk3 or posedge wb_rst_i3)
begin
	if (wb_rst_i3)
		msi_reset3 <= #1 1;
	else
	if (msi_reset3)
		msi_reset3 <= #1 0;
	else
	if (msr_read3)
		msi_reset3 <= #1 1; // reset bits in Modem3 Status Register
end


//
//   WRITES3 AND3 RESETS3   //
//
// Line3 Control3 Register
always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3)
		lcr3 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i3 && wb_addr_i3==`UART_REG_LC3)
		lcr3 <= #1 wb_dat_i3;

// Interrupt3 Enable3 Register or UART_DL23
always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3)
	begin
		ier3 <= #1 4'b0000; // no interrupts3 after reset
		dl3[`UART_DL23] <= #1 8'b0;
	end
	else
	if (wb_we_i3 && wb_addr_i3==`UART_REG_IE3)
		if (dlab3)
		begin
			dl3[`UART_DL23] <= #1 wb_dat_i3;
		end
		else
			ier3 <= #1 wb_dat_i3[3:0]; // ier3 uses only 4 lsb


// FIFO Control3 Register and rx_reset3, tx_reset3 signals3
always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) begin
		fcr3 <= #1 2'b11; 
		rx_reset3 <= #1 0;
		tx_reset3 <= #1 0;
	end else
	if (wb_we_i3 && wb_addr_i3==`UART_REG_FC3) begin
		fcr3 <= #1 wb_dat_i3[7:6];
		rx_reset3 <= #1 wb_dat_i3[1];
		tx_reset3 <= #1 wb_dat_i3[2];
	end else begin
		rx_reset3 <= #1 0;
		tx_reset3 <= #1 0;
	end

// Modem3 Control3 Register
always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3)
		mcr3 <= #1 5'b0; 
	else
	if (wb_we_i3 && wb_addr_i3==`UART_REG_MC3)
			mcr3 <= #1 wb_dat_i3[4:0];

// Scratch3 register
// Line3 Control3 Register
always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3)
		scratch3 <= #1 0; // 8n1 setting
	else
	if (wb_we_i3 && wb_addr_i3==`UART_REG_SR3)
		scratch3 <= #1 wb_dat_i3;

// TX_FIFO3 or UART_DL13
always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3)
	begin
		dl3[`UART_DL13]  <= #1 8'b0;
		tf_push3   <= #1 1'b0;
		start_dlc3 <= #1 1'b0;
	end
	else
	if (wb_we_i3 && wb_addr_i3==`UART_REG_TR3)
		if (dlab3)
		begin
			dl3[`UART_DL13] <= #1 wb_dat_i3;
			start_dlc3 <= #1 1'b1; // enable DL3 counter
			tf_push3 <= #1 1'b0;
		end
		else
		begin
			tf_push3   <= #1 1'b1;
			start_dlc3 <= #1 1'b0;
		end // else: !if(dlab3)
	else
	begin
		start_dlc3 <= #1 1'b0;
		tf_push3   <= #1 1'b0;
	end // else: !if(dlab3)

// Receiver3 FIFO trigger level selection logic (asynchronous3 mux3)
always @(fcr3)
	case (fcr3[`UART_FC_TL3])
		2'b00 : trigger_level3 = 1;
		2'b01 : trigger_level3 = 4;
		2'b10 : trigger_level3 = 8;
		2'b11 : trigger_level3 = 14;
	endcase // case(fcr3[`UART_FC_TL3])
	
//
//  STATUS3 REGISTERS3  //
//

// Modem3 Status Register
reg [3:0] delayed_modem_signals3;
always @(posedge clk3 or posedge wb_rst_i3)
begin
	if (wb_rst_i3)
	  begin
  		msr3 <= #1 0;
	  	delayed_modem_signals3[3:0] <= #1 0;
	  end
	else begin
		msr3[`UART_MS_DDCD3:`UART_MS_DCTS3] <= #1 msi_reset3 ? 4'b0 :
			msr3[`UART_MS_DDCD3:`UART_MS_DCTS3] | ({dcd3, ri, dsr3, cts3} ^ delayed_modem_signals3[3:0]);
		msr3[`UART_MS_CDCD3:`UART_MS_CCTS3] <= #1 {dcd_c3, ri_c3, dsr_c3, cts_c3};
		delayed_modem_signals3[3:0] <= #1 {dcd3, ri, dsr3, cts3};
	end
end


// Line3 Status Register

// activation3 conditions3
assign lsr03 = (rf_count3==0 && rf_push_pulse3);  // data in receiver3 fifo available set condition
assign lsr13 = rf_overrun3;     // Receiver3 overrun3 error
assign lsr23 = rf_data_out3[1]; // parity3 error bit
assign lsr33 = rf_data_out3[0]; // framing3 error bit
assign lsr43 = rf_data_out3[2]; // break error in the character3
assign lsr53 = (tf_count3==5'b0 && thre_set_en3);  // transmitter3 fifo is empty3
assign lsr63 = (tf_count3==5'b0 && thre_set_en3 && (tstate3 == /*`S_IDLE3 */ 0)); // transmitter3 empty3
assign lsr73 = rf_error_bit3 | rf_overrun3;

// lsr3 bit03 (receiver3 data available)
reg 	 lsr0_d3;

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr0_d3 <= #1 0;
	else lsr0_d3 <= #1 lsr03;

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr0r3 <= #1 0;
	else lsr0r3 <= #1 (rf_count3==1 && rf_pop3 && !rf_push_pulse3 || rx_reset3) ? 0 : // deassert3 condition
					  lsr0r3 || (lsr03 && ~lsr0_d3); // set on rise3 of lsr03 and keep3 asserted3 until deasserted3 

// lsr3 bit 1 (receiver3 overrun3)
reg lsr1_d3; // delayed3

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr1_d3 <= #1 0;
	else lsr1_d3 <= #1 lsr13;

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr1r3 <= #1 0;
	else	lsr1r3 <= #1	lsr_mask3 ? 0 : lsr1r3 || (lsr13 && ~lsr1_d3); // set on rise3

// lsr3 bit 2 (parity3 error)
reg lsr2_d3; // delayed3

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr2_d3 <= #1 0;
	else lsr2_d3 <= #1 lsr23;

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr2r3 <= #1 0;
	else lsr2r3 <= #1 lsr_mask3 ? 0 : lsr2r3 || (lsr23 && ~lsr2_d3); // set on rise3

// lsr3 bit 3 (framing3 error)
reg lsr3_d3; // delayed3

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr3_d3 <= #1 0;
	else lsr3_d3 <= #1 lsr33;

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr3r3 <= #1 0;
	else lsr3r3 <= #1 lsr_mask3 ? 0 : lsr3r3 || (lsr33 && ~lsr3_d3); // set on rise3

// lsr3 bit 4 (break indicator3)
reg lsr4_d3; // delayed3

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr4_d3 <= #1 0;
	else lsr4_d3 <= #1 lsr43;

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr4r3 <= #1 0;
	else lsr4r3 <= #1 lsr_mask3 ? 0 : lsr4r3 || (lsr43 && ~lsr4_d3);

// lsr3 bit 5 (transmitter3 fifo is empty3)
reg lsr5_d3;

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr5_d3 <= #1 1;
	else lsr5_d3 <= #1 lsr53;

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr5r3 <= #1 1;
	else lsr5r3 <= #1 (fifo_write3) ? 0 :  lsr5r3 || (lsr53 && ~lsr5_d3);

// lsr3 bit 6 (transmitter3 empty3 indicator3)
reg lsr6_d3;

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr6_d3 <= #1 1;
	else lsr6_d3 <= #1 lsr63;

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr6r3 <= #1 1;
	else lsr6r3 <= #1 (fifo_write3) ? 0 : lsr6r3 || (lsr63 && ~lsr6_d3);

// lsr3 bit 7 (error in fifo)
reg lsr7_d3;

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr7_d3 <= #1 0;
	else lsr7_d3 <= #1 lsr73;

always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) lsr7r3 <= #1 0;
	else lsr7r3 <= #1 lsr_mask3 ? 0 : lsr7r3 || (lsr73 && ~lsr7_d3);

// Frequency3 divider3
always @(posedge clk3 or posedge wb_rst_i3) 
begin
	if (wb_rst_i3)
		dlc3 <= #1 0;
	else
		if (start_dlc3 | ~ (|dlc3))
  			dlc3 <= #1 dl3 - 1;               // preset3 counter
		else
			dlc3 <= #1 dlc3 - 1;              // decrement counter
end

// Enable3 signal3 generation3 logic
always @(posedge clk3 or posedge wb_rst_i3)
begin
	if (wb_rst_i3)
		enable <= #1 1'b0;
	else
		if (|dl3 & ~(|dlc3))     // dl3>0 & dlc3==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying3 THRE3 status for one character3 cycle after a character3 is written3 to an empty3 fifo.
always @(lcr3)
  case (lcr3[3:0])
    4'b0000                             : block_value3 =  95; // 6 bits
    4'b0100                             : block_value3 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value3 = 111; // 7 bits
    4'b1100                             : block_value3 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value3 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value3 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value3 = 159; // 10 bits
    4'b1111                             : block_value3 = 175; // 11 bits
  endcase // case(lcr3[3:0])

// Counting3 time of one character3 minus3 stop bit
always @(posedge clk3 or posedge wb_rst_i3)
begin
  if (wb_rst_i3)
    block_cnt3 <= #1 8'd0;
  else
  if(lsr5r3 & fifo_write3)  // THRE3 bit set & write to fifo occured3
    block_cnt3 <= #1 block_value3;
  else
  if (enable & block_cnt3 != 8'b0)  // only work3 on enable times
    block_cnt3 <= #1 block_cnt3 - 1;  // decrement break counter
end // always of break condition detection3

// Generating3 THRE3 status enable signal3
assign thre_set_en3 = ~(|block_cnt3);


//
//	INTERRUPT3 LOGIC3
//

assign rls_int3  = ier3[`UART_IE_RLS3] && (lsr3[`UART_LS_OE3] || lsr3[`UART_LS_PE3] || lsr3[`UART_LS_FE3] || lsr3[`UART_LS_BI3]);
assign rda_int3  = ier3[`UART_IE_RDA3] && (rf_count3 >= {1'b0,trigger_level3});
assign thre_int3 = ier3[`UART_IE_THRE3] && lsr3[`UART_LS_TFE3];
assign ms_int3   = ier3[`UART_IE_MS3] && (| msr3[3:0]);
assign ti_int3   = ier3[`UART_IE_RDA3] && (counter_t3 == 10'b0) && (|rf_count3);

reg 	 rls_int_d3;
reg 	 thre_int_d3;
reg 	 ms_int_d3;
reg 	 ti_int_d3;
reg 	 rda_int_d3;

// delay lines3
always  @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) rls_int_d3 <= #1 0;
	else rls_int_d3 <= #1 rls_int3;

always  @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) rda_int_d3 <= #1 0;
	else rda_int_d3 <= #1 rda_int3;

always  @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) thre_int_d3 <= #1 0;
	else thre_int_d3 <= #1 thre_int3;

always  @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) ms_int_d3 <= #1 0;
	else ms_int_d3 <= #1 ms_int3;

always  @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) ti_int_d3 <= #1 0;
	else ti_int_d3 <= #1 ti_int3;

// rise3 detection3 signals3

wire 	 rls_int_rise3;
wire 	 thre_int_rise3;
wire 	 ms_int_rise3;
wire 	 ti_int_rise3;
wire 	 rda_int_rise3;

assign rda_int_rise3    = rda_int3 & ~rda_int_d3;
assign rls_int_rise3 	  = rls_int3 & ~rls_int_d3;
assign thre_int_rise3   = thre_int3 & ~thre_int_d3;
assign ms_int_rise3 	  = ms_int3 & ~ms_int_d3;
assign ti_int_rise3 	  = ti_int3 & ~ti_int_d3;

// interrupt3 pending flags3
reg 	rls_int_pnd3;
reg	rda_int_pnd3;
reg 	thre_int_pnd3;
reg 	ms_int_pnd3;
reg 	ti_int_pnd3;

// interrupt3 pending flags3 assignments3
always  @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) rls_int_pnd3 <= #1 0; 
	else 
		rls_int_pnd3 <= #1 lsr_mask3 ? 0 :  						// reset condition
							rls_int_rise3 ? 1 :						// latch3 condition
							rls_int_pnd3 && ier3[`UART_IE_RLS3];	// default operation3: remove if masked3

always  @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) rda_int_pnd3 <= #1 0; 
	else 
		rda_int_pnd3 <= #1 ((rf_count3 == {1'b0,trigger_level3}) && fifo_read3) ? 0 :  	// reset condition
							rda_int_rise3 ? 1 :						// latch3 condition
							rda_int_pnd3 && ier3[`UART_IE_RDA3];	// default operation3: remove if masked3

always  @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) thre_int_pnd3 <= #1 0; 
	else 
		thre_int_pnd3 <= #1 fifo_write3 || (iir_read3 & ~iir3[`UART_II_IP3] & iir3[`UART_II_II3] == `UART_II_THRE3)? 0 : 
							thre_int_rise3 ? 1 :
							thre_int_pnd3 && ier3[`UART_IE_THRE3];

always  @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) ms_int_pnd3 <= #1 0; 
	else 
		ms_int_pnd3 <= #1 msr_read3 ? 0 : 
							ms_int_rise3 ? 1 :
							ms_int_pnd3 && ier3[`UART_IE_MS3];

always  @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) ti_int_pnd3 <= #1 0; 
	else 
		ti_int_pnd3 <= #1 fifo_read3 ? 0 : 
							ti_int_rise3 ? 1 :
							ti_int_pnd3 && ier3[`UART_IE_RDA3];
// end of pending flags3

// INT_O3 logic
always @(posedge clk3 or posedge wb_rst_i3)
begin
	if (wb_rst_i3)	
		int_o3 <= #1 1'b0;
	else
		int_o3 <= #1 
					rls_int_pnd3		?	~lsr_mask3					:
					rda_int_pnd3		? 1								:
					ti_int_pnd3		? ~fifo_read3					:
					thre_int_pnd3	? !(fifo_write3 & iir_read3) :
					ms_int_pnd3		? ~msr_read3						:
					0;	// if no interrupt3 are pending
end


// Interrupt3 Identification3 register
always @(posedge clk3 or posedge wb_rst_i3)
begin
	if (wb_rst_i3)
		iir3 <= #1 1;
	else
	if (rls_int_pnd3)  // interrupt3 is pending
	begin
		iir3[`UART_II_II3] <= #1 `UART_II_RLS3;	// set identification3 register to correct3 value
		iir3[`UART_II_IP3] <= #1 1'b0;		// and clear the IIR3 bit 0 (interrupt3 pending)
	end else // the sequence of conditions3 determines3 priority of interrupt3 identification3
	if (rda_int3)
	begin
		iir3[`UART_II_II3] <= #1 `UART_II_RDA3;
		iir3[`UART_II_IP3] <= #1 1'b0;
	end
	else if (ti_int_pnd3)
	begin
		iir3[`UART_II_II3] <= #1 `UART_II_TI3;
		iir3[`UART_II_IP3] <= #1 1'b0;
	end
	else if (thre_int_pnd3)
	begin
		iir3[`UART_II_II3] <= #1 `UART_II_THRE3;
		iir3[`UART_II_IP3] <= #1 1'b0;
	end
	else if (ms_int_pnd3)
	begin
		iir3[`UART_II_II3] <= #1 `UART_II_MS3;
		iir3[`UART_II_IP3] <= #1 1'b0;
	end else	// no interrupt3 is pending
	begin
		iir3[`UART_II_II3] <= #1 0;
		iir3[`UART_II_IP3] <= #1 1'b1;
	end
end

endmodule
