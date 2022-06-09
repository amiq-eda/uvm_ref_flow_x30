//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs24.v                                                 ////
////                                                              ////
////                                                              ////
////  This24 file is part of the "UART24 16550 compatible24" project24    ////
////  http24://www24.opencores24.org24/cores24/uart1655024/                   ////
////                                                              ////
////  Documentation24 related24 to this project24:                      ////
////  - http24://www24.opencores24.org24/cores24/uart1655024/                 ////
////                                                              ////
////  Projects24 compatibility24:                                     ////
////  - WISHBONE24                                                  ////
////  RS23224 Protocol24                                              ////
////  16550D uart24 (mostly24 supported)                              ////
////                                                              ////
////  Overview24 (main24 Features24):                                   ////
////  Registers24 of the uart24 16550 core24                            ////
////                                                              ////
////  Known24 problems24 (limits24):                                    ////
////  Inserts24 1 wait state in all WISHBONE24 transfers24              ////
////                                                              ////
////  To24 Do24:                                                      ////
////  Nothing or verification24.                                    ////
////                                                              ////
////  Author24(s):                                                  ////
////      - gorban24@opencores24.org24                                  ////
////      - Jacob24 Gorban24                                          ////
////      - Igor24 Mohor24 (igorm24@opencores24.org24)                      ////
////                                                              ////
////  Created24:        2001/05/12                                  ////
////  Last24 Updated24:   (See log24 for the revision24 history24           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright24 (C) 2000, 2001 Authors24                             ////
////                                                              ////
//// This24 source24 file may be used and distributed24 without         ////
//// restriction24 provided that this copyright24 statement24 is not    ////
//// removed from the file and that any derivative24 work24 contains24  ////
//// the original copyright24 notice24 and the associated disclaimer24. ////
////                                                              ////
//// This24 source24 file is free software24; you can redistribute24 it   ////
//// and/or modify it under the terms24 of the GNU24 Lesser24 General24   ////
//// Public24 License24 as published24 by the Free24 Software24 Foundation24; ////
//// either24 version24 2.1 of the License24, or (at your24 option) any   ////
//// later24 version24.                                               ////
////                                                              ////
//// This24 source24 is distributed24 in the hope24 that it will be       ////
//// useful24, but WITHOUT24 ANY24 WARRANTY24; without even24 the implied24   ////
//// warranty24 of MERCHANTABILITY24 or FITNESS24 FOR24 A PARTICULAR24      ////
//// PURPOSE24.  See the GNU24 Lesser24 General24 Public24 License24 for more ////
//// details24.                                                     ////
////                                                              ////
//// You should have received24 a copy of the GNU24 Lesser24 General24    ////
//// Public24 License24 along24 with this source24; if not, download24 it   ////
//// from http24://www24.opencores24.org24/lgpl24.shtml24                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS24 Revision24 History24
//
// $Log: not supported by cvs2svn24 $
// Revision24 1.41  2004/05/21 11:44:41  tadejm24
// Added24 synchronizer24 flops24 for RX24 input.
//
// Revision24 1.40  2003/06/11 16:37:47  gorban24
// This24 fixes24 errors24 in some24 cases24 when data is being read and put to the FIFO at the same time. Patch24 is submitted24 by Scott24 Furman24. Update is very24 recommended24.
//
// Revision24 1.39  2002/07/29 21:16:18  gorban24
// The uart_defines24.v file is included24 again24 in sources24.
//
// Revision24 1.38  2002/07/22 23:02:23  gorban24
// Bug24 Fixes24:
//  * Possible24 loss of sync and bad24 reception24 of stop bit on slow24 baud24 rates24 fixed24.
//   Problem24 reported24 by Kenny24.Tung24.
//  * Bad (or lack24 of ) loopback24 handling24 fixed24. Reported24 by Cherry24 Withers24.
//
// Improvements24:
//  * Made24 FIFO's as general24 inferrable24 memory where possible24.
//  So24 on FPGA24 they should be inferred24 as RAM24 (Distributed24 RAM24 on Xilinx24).
//  This24 saves24 about24 1/3 of the Slice24 count and reduces24 P&R and synthesis24 times.
//
//  * Added24 optional24 baudrate24 output (baud_o24).
//  This24 is identical24 to BAUDOUT24* signal24 on 16550 chip24.
//  It outputs24 16xbit_clock_rate - the divided24 clock24.
//  It's disabled by default. Define24 UART_HAS_BAUDRATE_OUTPUT24 to use.
//
// Revision24 1.37  2001/12/27 13:24:09  mohor24
// lsr24[7] was not showing24 overrun24 errors24.
//
// Revision24 1.36  2001/12/20 13:25:46  mohor24
// rx24 push24 changed to be only one cycle wide24.
//
// Revision24 1.35  2001/12/19 08:03:34  mohor24
// Warnings24 cleared24.
//
// Revision24 1.34  2001/12/19 07:33:54  mohor24
// Synplicity24 was having24 troubles24 with the comment24.
//
// Revision24 1.33  2001/12/17 10:14:43  mohor24
// Things24 related24 to msr24 register changed. After24 THRE24 IRQ24 occurs24, and one
// character24 is written24 to the transmit24 fifo, the detection24 of the THRE24 bit in the
// LSR24 is delayed24 for one character24 time.
//
// Revision24 1.32  2001/12/14 13:19:24  mohor24
// MSR24 register fixed24.
//
// Revision24 1.31  2001/12/14 10:06:58  mohor24
// After24 reset modem24 status register MSR24 should be reset.
//
// Revision24 1.30  2001/12/13 10:09:13  mohor24
// thre24 irq24 should be cleared24 only when being source24 of interrupt24.
//
// Revision24 1.29  2001/12/12 09:05:46  mohor24
// LSR24 status bit 0 was not cleared24 correctly in case of reseting24 the FCR24 (rx24 fifo).
//
// Revision24 1.28  2001/12/10 19:52:41  gorban24
// Scratch24 register added
//
// Revision24 1.27  2001/12/06 14:51:04  gorban24
// Bug24 in LSR24[0] is fixed24.
// All WISHBONE24 signals24 are now sampled24, so another24 wait-state is introduced24 on all transfers24.
//
// Revision24 1.26  2001/12/03 21:44:29  gorban24
// Updated24 specification24 documentation.
// Added24 full 32-bit data bus interface, now as default.
// Address is 5-bit wide24 in 32-bit data bus mode.
// Added24 wb_sel_i24 input to the core24. It's used in the 32-bit mode.
// Added24 debug24 interface with two24 32-bit read-only registers in 32-bit mode.
// Bits24 5 and 6 of LSR24 are now only cleared24 on TX24 FIFO write.
// My24 small test bench24 is modified to work24 with 32-bit mode.
//
// Revision24 1.25  2001/11/28 19:36:39  gorban24
// Fixed24: timeout and break didn24't pay24 attention24 to current data format24 when counting24 time
//
// Revision24 1.24  2001/11/26 21:38:54  gorban24
// Lots24 of fixes24:
// Break24 condition wasn24't handled24 correctly at all.
// LSR24 bits could lose24 their24 values.
// LSR24 value after reset was wrong24.
// Timing24 of THRE24 interrupt24 signal24 corrected24.
// LSR24 bit 0 timing24 corrected24.
//
// Revision24 1.23  2001/11/12 21:57:29  gorban24
// fixed24 more typo24 bugs24
//
// Revision24 1.22  2001/11/12 15:02:28  mohor24
// lsr1r24 error fixed24.
//
// Revision24 1.21  2001/11/12 14:57:27  mohor24
// ti_int_pnd24 error fixed24.
//
// Revision24 1.20  2001/11/12 14:50:27  mohor24
// ti_int_d24 error fixed24.
//
// Revision24 1.19  2001/11/10 12:43:21  gorban24
// Logic24 Synthesis24 bugs24 fixed24. Some24 other minor24 changes24
//
// Revision24 1.18  2001/11/08 14:54:23  mohor24
// Comments24 in Slovene24 language24 deleted24, few24 small fixes24 for better24 work24 of
// old24 tools24. IRQs24 need to be fix24.
//
// Revision24 1.17  2001/11/07 17:51:52  gorban24
// Heavily24 rewritten24 interrupt24 and LSR24 subsystems24.
// Many24 bugs24 hopefully24 squashed24.
//
// Revision24 1.16  2001/11/02 09:55:16  mohor24
// no message
//
// Revision24 1.15  2001/10/31 15:19:22  gorban24
// Fixes24 to break and timeout conditions24
//
// Revision24 1.14  2001/10/29 17:00:46  gorban24
// fixed24 parity24 sending24 and tx_fifo24 resets24 over- and underrun24
//
// Revision24 1.13  2001/10/20 09:58:40  gorban24
// Small24 synopsis24 fixes24
//
// Revision24 1.12  2001/10/19 16:21:40  gorban24
// Changes24 data_out24 to be synchronous24 again24 as it should have been.
//
// Revision24 1.11  2001/10/18 20:35:45  gorban24
// small fix24
//
// Revision24 1.10  2001/08/24 21:01:12  mohor24
// Things24 connected24 to parity24 changed.
// Clock24 devider24 changed.
//
// Revision24 1.9  2001/08/23 16:05:05  mohor24
// Stop bit bug24 fixed24.
// Parity24 bug24 fixed24.
// WISHBONE24 read cycle bug24 fixed24,
// OE24 indicator24 (Overrun24 Error) bug24 fixed24.
// PE24 indicator24 (Parity24 Error) bug24 fixed24.
// Register read bug24 fixed24.
//
// Revision24 1.10  2001/06/23 11:21:48  gorban24
// DL24 made24 16-bit long24. Fixed24 transmission24/reception24 bugs24.
//
// Revision24 1.9  2001/05/31 20:08:01  gorban24
// FIFO changes24 and other corrections24.
//
// Revision24 1.8  2001/05/29 20:05:04  gorban24
// Fixed24 some24 bugs24 and synthesis24 problems24.
//
// Revision24 1.7  2001/05/27 17:37:49  gorban24
// Fixed24 many24 bugs24. Updated24 spec24. Changed24 FIFO files structure24. See CHANGES24.txt24 file.
//
// Revision24 1.6  2001/05/21 19:12:02  gorban24
// Corrected24 some24 Linter24 messages24.
//
// Revision24 1.5  2001/05/17 18:34:18  gorban24
// First24 'stable' release. Should24 be sythesizable24 now. Also24 added new header.
//
// Revision24 1.0  2001-05-17 21:27:11+02  jacob24
// Initial24 revision24
//
//

// synopsys24 translate_off24
`include "timescale.v"
// synopsys24 translate_on24

`include "uart_defines24.v"

`define UART_DL124 7:0
`define UART_DL224 15:8

module uart_regs24 (clk24,
	wb_rst_i24, wb_addr_i24, wb_dat_i24, wb_dat_o24, wb_we_i24, wb_re_i24, 

// additional24 signals24
	modem_inputs24,
	stx_pad_o24, srx_pad_i24,

`ifdef DATA_BUS_WIDTH_824
`else
// debug24 interface signals24	enabled
ier24, iir24, fcr24, mcr24, lcr24, msr24, lsr24, rf_count24, tf_count24, tstate24, rstate,
`endif				
	rts_pad_o24, dtr_pad_o24, int_o24
`ifdef UART_HAS_BAUDRATE_OUTPUT24
	, baud_o24
`endif

	);

input 									clk24;
input 									wb_rst_i24;
input [`UART_ADDR_WIDTH24-1:0] 		wb_addr_i24;
input [7:0] 							wb_dat_i24;
output [7:0] 							wb_dat_o24;
input 									wb_we_i24;
input 									wb_re_i24;

output 									stx_pad_o24;
input 									srx_pad_i24;

input [3:0] 							modem_inputs24;
output 									rts_pad_o24;
output 									dtr_pad_o24;
output 									int_o24;
`ifdef UART_HAS_BAUDRATE_OUTPUT24
output	baud_o24;
`endif

`ifdef DATA_BUS_WIDTH_824
`else
// if 32-bit databus24 and debug24 interface are enabled
output [3:0]							ier24;
output [3:0]							iir24;
output [1:0]							fcr24;  /// bits 7 and 6 of fcr24. Other24 bits are ignored
output [4:0]							mcr24;
output [7:0]							lcr24;
output [7:0]							msr24;
output [7:0] 							lsr24;
output [`UART_FIFO_COUNTER_W24-1:0] 	rf_count24;
output [`UART_FIFO_COUNTER_W24-1:0] 	tf_count24;
output [2:0] 							tstate24;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs24;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT24
assign baud_o24 = enable; // baud_o24 is actually24 the enable signal24
`endif


wire 										stx_pad_o24;		// received24 from transmitter24 module
wire 										srx_pad_i24;
wire 										srx_pad24;

reg [7:0] 								wb_dat_o24;

wire [`UART_ADDR_WIDTH24-1:0] 		wb_addr_i24;
wire [7:0] 								wb_dat_i24;


reg [3:0] 								ier24;
reg [3:0] 								iir24;
reg [1:0] 								fcr24;  /// bits 7 and 6 of fcr24. Other24 bits are ignored
reg [4:0] 								mcr24;
reg [7:0] 								lcr24;
reg [7:0] 								msr24;
reg [15:0] 								dl24;  // 32-bit divisor24 latch24
reg [7:0] 								scratch24; // UART24 scratch24 register
reg 										start_dlc24; // activate24 dlc24 on writing to UART_DL124
reg 										lsr_mask_d24; // delay for lsr_mask24 condition
reg 										msi_reset24; // reset MSR24 4 lower24 bits indicator24
//reg 										threi_clear24; // THRE24 interrupt24 clear flag24
reg [15:0] 								dlc24;  // 32-bit divisor24 latch24 counter
reg 										int_o24;

reg [3:0] 								trigger_level24; // trigger level of the receiver24 FIFO
reg 										rx_reset24;
reg 										tx_reset24;

wire 										dlab24;			   // divisor24 latch24 access bit
wire 										cts_pad_i24, dsr_pad_i24, ri_pad_i24, dcd_pad_i24; // modem24 status bits
wire 										loopback24;		   // loopback24 bit (MCR24 bit 4)
wire 										cts24, dsr24, ri, dcd24;	   // effective24 signals24
wire                    cts_c24, dsr_c24, ri_c24, dcd_c24; // Complement24 effective24 signals24 (considering24 loopback24)
wire 										rts_pad_o24, dtr_pad_o24;		   // modem24 control24 outputs24

// LSR24 bits wires24 and regs
wire [7:0] 								lsr24;
wire 										lsr024, lsr124, lsr224, lsr324, lsr424, lsr524, lsr624, lsr724;
reg										lsr0r24, lsr1r24, lsr2r24, lsr3r24, lsr4r24, lsr5r24, lsr6r24, lsr7r24;
wire 										lsr_mask24; // lsr_mask24

//
// ASSINGS24
//

assign 									lsr24[7:0] = { lsr7r24, lsr6r24, lsr5r24, lsr4r24, lsr3r24, lsr2r24, lsr1r24, lsr0r24 };

assign 									{cts_pad_i24, dsr_pad_i24, ri_pad_i24, dcd_pad_i24} = modem_inputs24;
assign 									{cts24, dsr24, ri, dcd24} = ~{cts_pad_i24,dsr_pad_i24,ri_pad_i24,dcd_pad_i24};

assign                  {cts_c24, dsr_c24, ri_c24, dcd_c24} = loopback24 ? {mcr24[`UART_MC_RTS24],mcr24[`UART_MC_DTR24],mcr24[`UART_MC_OUT124],mcr24[`UART_MC_OUT224]}
                                                               : {cts_pad_i24,dsr_pad_i24,ri_pad_i24,dcd_pad_i24};

assign 									dlab24 = lcr24[`UART_LC_DL24];
assign 									loopback24 = mcr24[4];

// assign modem24 outputs24
assign 									rts_pad_o24 = mcr24[`UART_MC_RTS24];
assign 									dtr_pad_o24 = mcr24[`UART_MC_DTR24];

// Interrupt24 signals24
wire 										rls_int24;  // receiver24 line status interrupt24
wire 										rda_int24;  // receiver24 data available interrupt24
wire 										ti_int24;   // timeout indicator24 interrupt24
wire										thre_int24; // transmitter24 holding24 register empty24 interrupt24
wire 										ms_int24;   // modem24 status interrupt24

// FIFO signals24
reg 										tf_push24;
reg 										rf_pop24;
wire [`UART_FIFO_REC_WIDTH24-1:0] 	rf_data_out24;
wire 										rf_error_bit24; // an error (parity24 or framing24) is inside the fifo
wire [`UART_FIFO_COUNTER_W24-1:0] 	rf_count24;
wire [`UART_FIFO_COUNTER_W24-1:0] 	tf_count24;
wire [2:0] 								tstate24;
wire [3:0] 								rstate;
wire [9:0] 								counter_t24;

wire                      thre_set_en24; // THRE24 status is delayed24 one character24 time when a character24 is written24 to fifo.
reg  [7:0]                block_cnt24;   // While24 counter counts24, THRE24 status is blocked24 (delayed24 one character24 cycle)
reg  [7:0]                block_value24; // One24 character24 length minus24 stop bit

// Transmitter24 Instance
wire serial_out24;

uart_transmitter24 transmitter24(clk24, wb_rst_i24, lcr24, tf_push24, wb_dat_i24, enable, serial_out24, tstate24, tf_count24, tx_reset24, lsr_mask24);

  // Synchronizing24 and sampling24 serial24 RX24 input
  uart_sync_flops24    i_uart_sync_flops24
  (
    .rst_i24           (wb_rst_i24),
    .clk_i24           (clk24),
    .stage1_rst_i24    (1'b0),
    .stage1_clk_en_i24 (1'b1),
    .async_dat_i24     (srx_pad_i24),
    .sync_dat_o24      (srx_pad24)
  );
  defparam i_uart_sync_flops24.width      = 1;
  defparam i_uart_sync_flops24.init_value24 = 1'b1;

// handle loopback24
wire serial_in24 = loopback24 ? serial_out24 : srx_pad24;
assign stx_pad_o24 = loopback24 ? 1'b1 : serial_out24;

// Receiver24 Instance
uart_receiver24 receiver24(clk24, wb_rst_i24, lcr24, rf_pop24, serial_in24, enable, 
	counter_t24, rf_count24, rf_data_out24, rf_error_bit24, rf_overrun24, rx_reset24, lsr_mask24, rstate, rf_push_pulse24);


// Asynchronous24 reading here24 because the outputs24 are sampled24 in uart_wb24.v file 
always @(dl24 or dlab24 or ier24 or iir24 or scratch24
			or lcr24 or lsr24 or msr24 or rf_data_out24 or wb_addr_i24 or wb_re_i24)   // asynchrounous24 reading
begin
	case (wb_addr_i24)
		`UART_REG_RB24   : wb_dat_o24 = dlab24 ? dl24[`UART_DL124] : rf_data_out24[10:3];
		`UART_REG_IE24	: wb_dat_o24 = dlab24 ? dl24[`UART_DL224] : ier24;
		`UART_REG_II24	: wb_dat_o24 = {4'b1100,iir24};
		`UART_REG_LC24	: wb_dat_o24 = lcr24;
		`UART_REG_LS24	: wb_dat_o24 = lsr24;
		`UART_REG_MS24	: wb_dat_o24 = msr24;
		`UART_REG_SR24	: wb_dat_o24 = scratch24;
		default:  wb_dat_o24 = 8'b0; // ??
	endcase // case(wb_addr_i24)
end // always @ (dl24 or dlab24 or ier24 or iir24 or scratch24...


// rf_pop24 signal24 handling24
always @(posedge clk24 or posedge wb_rst_i24)
begin
	if (wb_rst_i24)
		rf_pop24 <= #1 0; 
	else
	if (rf_pop24)	// restore24 the signal24 to 0 after one clock24 cycle
		rf_pop24 <= #1 0;
	else
	if (wb_re_i24 && wb_addr_i24 == `UART_REG_RB24 && !dlab24)
		rf_pop24 <= #1 1; // advance24 read pointer24
end

wire 	lsr_mask_condition24;
wire 	iir_read24;
wire  msr_read24;
wire	fifo_read24;
wire	fifo_write24;

assign lsr_mask_condition24 = (wb_re_i24 && wb_addr_i24 == `UART_REG_LS24 && !dlab24);
assign iir_read24 = (wb_re_i24 && wb_addr_i24 == `UART_REG_II24 && !dlab24);
assign msr_read24 = (wb_re_i24 && wb_addr_i24 == `UART_REG_MS24 && !dlab24);
assign fifo_read24 = (wb_re_i24 && wb_addr_i24 == `UART_REG_RB24 && !dlab24);
assign fifo_write24 = (wb_we_i24 && wb_addr_i24 == `UART_REG_TR24 && !dlab24);

// lsr_mask_d24 delayed24 signal24 handling24
always @(posedge clk24 or posedge wb_rst_i24)
begin
	if (wb_rst_i24)
		lsr_mask_d24 <= #1 0;
	else // reset bits in the Line24 Status Register
		lsr_mask_d24 <= #1 lsr_mask_condition24;
end

// lsr_mask24 is rise24 detected
assign lsr_mask24 = lsr_mask_condition24 && ~lsr_mask_d24;

// msi_reset24 signal24 handling24
always @(posedge clk24 or posedge wb_rst_i24)
begin
	if (wb_rst_i24)
		msi_reset24 <= #1 1;
	else
	if (msi_reset24)
		msi_reset24 <= #1 0;
	else
	if (msr_read24)
		msi_reset24 <= #1 1; // reset bits in Modem24 Status Register
end


//
//   WRITES24 AND24 RESETS24   //
//
// Line24 Control24 Register
always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24)
		lcr24 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i24 && wb_addr_i24==`UART_REG_LC24)
		lcr24 <= #1 wb_dat_i24;

// Interrupt24 Enable24 Register or UART_DL224
always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24)
	begin
		ier24 <= #1 4'b0000; // no interrupts24 after reset
		dl24[`UART_DL224] <= #1 8'b0;
	end
	else
	if (wb_we_i24 && wb_addr_i24==`UART_REG_IE24)
		if (dlab24)
		begin
			dl24[`UART_DL224] <= #1 wb_dat_i24;
		end
		else
			ier24 <= #1 wb_dat_i24[3:0]; // ier24 uses only 4 lsb


// FIFO Control24 Register and rx_reset24, tx_reset24 signals24
always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) begin
		fcr24 <= #1 2'b11; 
		rx_reset24 <= #1 0;
		tx_reset24 <= #1 0;
	end else
	if (wb_we_i24 && wb_addr_i24==`UART_REG_FC24) begin
		fcr24 <= #1 wb_dat_i24[7:6];
		rx_reset24 <= #1 wb_dat_i24[1];
		tx_reset24 <= #1 wb_dat_i24[2];
	end else begin
		rx_reset24 <= #1 0;
		tx_reset24 <= #1 0;
	end

// Modem24 Control24 Register
always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24)
		mcr24 <= #1 5'b0; 
	else
	if (wb_we_i24 && wb_addr_i24==`UART_REG_MC24)
			mcr24 <= #1 wb_dat_i24[4:0];

// Scratch24 register
// Line24 Control24 Register
always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24)
		scratch24 <= #1 0; // 8n1 setting
	else
	if (wb_we_i24 && wb_addr_i24==`UART_REG_SR24)
		scratch24 <= #1 wb_dat_i24;

// TX_FIFO24 or UART_DL124
always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24)
	begin
		dl24[`UART_DL124]  <= #1 8'b0;
		tf_push24   <= #1 1'b0;
		start_dlc24 <= #1 1'b0;
	end
	else
	if (wb_we_i24 && wb_addr_i24==`UART_REG_TR24)
		if (dlab24)
		begin
			dl24[`UART_DL124] <= #1 wb_dat_i24;
			start_dlc24 <= #1 1'b1; // enable DL24 counter
			tf_push24 <= #1 1'b0;
		end
		else
		begin
			tf_push24   <= #1 1'b1;
			start_dlc24 <= #1 1'b0;
		end // else: !if(dlab24)
	else
	begin
		start_dlc24 <= #1 1'b0;
		tf_push24   <= #1 1'b0;
	end // else: !if(dlab24)

// Receiver24 FIFO trigger level selection logic (asynchronous24 mux24)
always @(fcr24)
	case (fcr24[`UART_FC_TL24])
		2'b00 : trigger_level24 = 1;
		2'b01 : trigger_level24 = 4;
		2'b10 : trigger_level24 = 8;
		2'b11 : trigger_level24 = 14;
	endcase // case(fcr24[`UART_FC_TL24])
	
//
//  STATUS24 REGISTERS24  //
//

// Modem24 Status Register
reg [3:0] delayed_modem_signals24;
always @(posedge clk24 or posedge wb_rst_i24)
begin
	if (wb_rst_i24)
	  begin
  		msr24 <= #1 0;
	  	delayed_modem_signals24[3:0] <= #1 0;
	  end
	else begin
		msr24[`UART_MS_DDCD24:`UART_MS_DCTS24] <= #1 msi_reset24 ? 4'b0 :
			msr24[`UART_MS_DDCD24:`UART_MS_DCTS24] | ({dcd24, ri, dsr24, cts24} ^ delayed_modem_signals24[3:0]);
		msr24[`UART_MS_CDCD24:`UART_MS_CCTS24] <= #1 {dcd_c24, ri_c24, dsr_c24, cts_c24};
		delayed_modem_signals24[3:0] <= #1 {dcd24, ri, dsr24, cts24};
	end
end


// Line24 Status Register

// activation24 conditions24
assign lsr024 = (rf_count24==0 && rf_push_pulse24);  // data in receiver24 fifo available set condition
assign lsr124 = rf_overrun24;     // Receiver24 overrun24 error
assign lsr224 = rf_data_out24[1]; // parity24 error bit
assign lsr324 = rf_data_out24[0]; // framing24 error bit
assign lsr424 = rf_data_out24[2]; // break error in the character24
assign lsr524 = (tf_count24==5'b0 && thre_set_en24);  // transmitter24 fifo is empty24
assign lsr624 = (tf_count24==5'b0 && thre_set_en24 && (tstate24 == /*`S_IDLE24 */ 0)); // transmitter24 empty24
assign lsr724 = rf_error_bit24 | rf_overrun24;

// lsr24 bit024 (receiver24 data available)
reg 	 lsr0_d24;

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr0_d24 <= #1 0;
	else lsr0_d24 <= #1 lsr024;

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr0r24 <= #1 0;
	else lsr0r24 <= #1 (rf_count24==1 && rf_pop24 && !rf_push_pulse24 || rx_reset24) ? 0 : // deassert24 condition
					  lsr0r24 || (lsr024 && ~lsr0_d24); // set on rise24 of lsr024 and keep24 asserted24 until deasserted24 

// lsr24 bit 1 (receiver24 overrun24)
reg lsr1_d24; // delayed24

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr1_d24 <= #1 0;
	else lsr1_d24 <= #1 lsr124;

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr1r24 <= #1 0;
	else	lsr1r24 <= #1	lsr_mask24 ? 0 : lsr1r24 || (lsr124 && ~lsr1_d24); // set on rise24

// lsr24 bit 2 (parity24 error)
reg lsr2_d24; // delayed24

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr2_d24 <= #1 0;
	else lsr2_d24 <= #1 lsr224;

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr2r24 <= #1 0;
	else lsr2r24 <= #1 lsr_mask24 ? 0 : lsr2r24 || (lsr224 && ~lsr2_d24); // set on rise24

// lsr24 bit 3 (framing24 error)
reg lsr3_d24; // delayed24

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr3_d24 <= #1 0;
	else lsr3_d24 <= #1 lsr324;

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr3r24 <= #1 0;
	else lsr3r24 <= #1 lsr_mask24 ? 0 : lsr3r24 || (lsr324 && ~lsr3_d24); // set on rise24

// lsr24 bit 4 (break indicator24)
reg lsr4_d24; // delayed24

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr4_d24 <= #1 0;
	else lsr4_d24 <= #1 lsr424;

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr4r24 <= #1 0;
	else lsr4r24 <= #1 lsr_mask24 ? 0 : lsr4r24 || (lsr424 && ~lsr4_d24);

// lsr24 bit 5 (transmitter24 fifo is empty24)
reg lsr5_d24;

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr5_d24 <= #1 1;
	else lsr5_d24 <= #1 lsr524;

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr5r24 <= #1 1;
	else lsr5r24 <= #1 (fifo_write24) ? 0 :  lsr5r24 || (lsr524 && ~lsr5_d24);

// lsr24 bit 6 (transmitter24 empty24 indicator24)
reg lsr6_d24;

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr6_d24 <= #1 1;
	else lsr6_d24 <= #1 lsr624;

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr6r24 <= #1 1;
	else lsr6r24 <= #1 (fifo_write24) ? 0 : lsr6r24 || (lsr624 && ~lsr6_d24);

// lsr24 bit 7 (error in fifo)
reg lsr7_d24;

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr7_d24 <= #1 0;
	else lsr7_d24 <= #1 lsr724;

always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) lsr7r24 <= #1 0;
	else lsr7r24 <= #1 lsr_mask24 ? 0 : lsr7r24 || (lsr724 && ~lsr7_d24);

// Frequency24 divider24
always @(posedge clk24 or posedge wb_rst_i24) 
begin
	if (wb_rst_i24)
		dlc24 <= #1 0;
	else
		if (start_dlc24 | ~ (|dlc24))
  			dlc24 <= #1 dl24 - 1;               // preset24 counter
		else
			dlc24 <= #1 dlc24 - 1;              // decrement counter
end

// Enable24 signal24 generation24 logic
always @(posedge clk24 or posedge wb_rst_i24)
begin
	if (wb_rst_i24)
		enable <= #1 1'b0;
	else
		if (|dl24 & ~(|dlc24))     // dl24>0 & dlc24==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying24 THRE24 status for one character24 cycle after a character24 is written24 to an empty24 fifo.
always @(lcr24)
  case (lcr24[3:0])
    4'b0000                             : block_value24 =  95; // 6 bits
    4'b0100                             : block_value24 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value24 = 111; // 7 bits
    4'b1100                             : block_value24 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value24 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value24 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value24 = 159; // 10 bits
    4'b1111                             : block_value24 = 175; // 11 bits
  endcase // case(lcr24[3:0])

// Counting24 time of one character24 minus24 stop bit
always @(posedge clk24 or posedge wb_rst_i24)
begin
  if (wb_rst_i24)
    block_cnt24 <= #1 8'd0;
  else
  if(lsr5r24 & fifo_write24)  // THRE24 bit set & write to fifo occured24
    block_cnt24 <= #1 block_value24;
  else
  if (enable & block_cnt24 != 8'b0)  // only work24 on enable times
    block_cnt24 <= #1 block_cnt24 - 1;  // decrement break counter
end // always of break condition detection24

// Generating24 THRE24 status enable signal24
assign thre_set_en24 = ~(|block_cnt24);


//
//	INTERRUPT24 LOGIC24
//

assign rls_int24  = ier24[`UART_IE_RLS24] && (lsr24[`UART_LS_OE24] || lsr24[`UART_LS_PE24] || lsr24[`UART_LS_FE24] || lsr24[`UART_LS_BI24]);
assign rda_int24  = ier24[`UART_IE_RDA24] && (rf_count24 >= {1'b0,trigger_level24});
assign thre_int24 = ier24[`UART_IE_THRE24] && lsr24[`UART_LS_TFE24];
assign ms_int24   = ier24[`UART_IE_MS24] && (| msr24[3:0]);
assign ti_int24   = ier24[`UART_IE_RDA24] && (counter_t24 == 10'b0) && (|rf_count24);

reg 	 rls_int_d24;
reg 	 thre_int_d24;
reg 	 ms_int_d24;
reg 	 ti_int_d24;
reg 	 rda_int_d24;

// delay lines24
always  @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) rls_int_d24 <= #1 0;
	else rls_int_d24 <= #1 rls_int24;

always  @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) rda_int_d24 <= #1 0;
	else rda_int_d24 <= #1 rda_int24;

always  @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) thre_int_d24 <= #1 0;
	else thre_int_d24 <= #1 thre_int24;

always  @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) ms_int_d24 <= #1 0;
	else ms_int_d24 <= #1 ms_int24;

always  @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) ti_int_d24 <= #1 0;
	else ti_int_d24 <= #1 ti_int24;

// rise24 detection24 signals24

wire 	 rls_int_rise24;
wire 	 thre_int_rise24;
wire 	 ms_int_rise24;
wire 	 ti_int_rise24;
wire 	 rda_int_rise24;

assign rda_int_rise24    = rda_int24 & ~rda_int_d24;
assign rls_int_rise24 	  = rls_int24 & ~rls_int_d24;
assign thre_int_rise24   = thre_int24 & ~thre_int_d24;
assign ms_int_rise24 	  = ms_int24 & ~ms_int_d24;
assign ti_int_rise24 	  = ti_int24 & ~ti_int_d24;

// interrupt24 pending flags24
reg 	rls_int_pnd24;
reg	rda_int_pnd24;
reg 	thre_int_pnd24;
reg 	ms_int_pnd24;
reg 	ti_int_pnd24;

// interrupt24 pending flags24 assignments24
always  @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) rls_int_pnd24 <= #1 0; 
	else 
		rls_int_pnd24 <= #1 lsr_mask24 ? 0 :  						// reset condition
							rls_int_rise24 ? 1 :						// latch24 condition
							rls_int_pnd24 && ier24[`UART_IE_RLS24];	// default operation24: remove if masked24

always  @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) rda_int_pnd24 <= #1 0; 
	else 
		rda_int_pnd24 <= #1 ((rf_count24 == {1'b0,trigger_level24}) && fifo_read24) ? 0 :  	// reset condition
							rda_int_rise24 ? 1 :						// latch24 condition
							rda_int_pnd24 && ier24[`UART_IE_RDA24];	// default operation24: remove if masked24

always  @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) thre_int_pnd24 <= #1 0; 
	else 
		thre_int_pnd24 <= #1 fifo_write24 || (iir_read24 & ~iir24[`UART_II_IP24] & iir24[`UART_II_II24] == `UART_II_THRE24)? 0 : 
							thre_int_rise24 ? 1 :
							thre_int_pnd24 && ier24[`UART_IE_THRE24];

always  @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) ms_int_pnd24 <= #1 0; 
	else 
		ms_int_pnd24 <= #1 msr_read24 ? 0 : 
							ms_int_rise24 ? 1 :
							ms_int_pnd24 && ier24[`UART_IE_MS24];

always  @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) ti_int_pnd24 <= #1 0; 
	else 
		ti_int_pnd24 <= #1 fifo_read24 ? 0 : 
							ti_int_rise24 ? 1 :
							ti_int_pnd24 && ier24[`UART_IE_RDA24];
// end of pending flags24

// INT_O24 logic
always @(posedge clk24 or posedge wb_rst_i24)
begin
	if (wb_rst_i24)	
		int_o24 <= #1 1'b0;
	else
		int_o24 <= #1 
					rls_int_pnd24		?	~lsr_mask24					:
					rda_int_pnd24		? 1								:
					ti_int_pnd24		? ~fifo_read24					:
					thre_int_pnd24	? !(fifo_write24 & iir_read24) :
					ms_int_pnd24		? ~msr_read24						:
					0;	// if no interrupt24 are pending
end


// Interrupt24 Identification24 register
always @(posedge clk24 or posedge wb_rst_i24)
begin
	if (wb_rst_i24)
		iir24 <= #1 1;
	else
	if (rls_int_pnd24)  // interrupt24 is pending
	begin
		iir24[`UART_II_II24] <= #1 `UART_II_RLS24;	// set identification24 register to correct24 value
		iir24[`UART_II_IP24] <= #1 1'b0;		// and clear the IIR24 bit 0 (interrupt24 pending)
	end else // the sequence of conditions24 determines24 priority of interrupt24 identification24
	if (rda_int24)
	begin
		iir24[`UART_II_II24] <= #1 `UART_II_RDA24;
		iir24[`UART_II_IP24] <= #1 1'b0;
	end
	else if (ti_int_pnd24)
	begin
		iir24[`UART_II_II24] <= #1 `UART_II_TI24;
		iir24[`UART_II_IP24] <= #1 1'b0;
	end
	else if (thre_int_pnd24)
	begin
		iir24[`UART_II_II24] <= #1 `UART_II_THRE24;
		iir24[`UART_II_IP24] <= #1 1'b0;
	end
	else if (ms_int_pnd24)
	begin
		iir24[`UART_II_II24] <= #1 `UART_II_MS24;
		iir24[`UART_II_IP24] <= #1 1'b0;
	end else	// no interrupt24 is pending
	begin
		iir24[`UART_II_II24] <= #1 0;
		iir24[`UART_II_IP24] <= #1 1'b1;
	end
end

endmodule
