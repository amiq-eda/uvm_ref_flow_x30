//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs26.v                                                 ////
////                                                              ////
////                                                              ////
////  This26 file is part of the "UART26 16550 compatible26" project26    ////
////  http26://www26.opencores26.org26/cores26/uart1655026/                   ////
////                                                              ////
////  Documentation26 related26 to this project26:                      ////
////  - http26://www26.opencores26.org26/cores26/uart1655026/                 ////
////                                                              ////
////  Projects26 compatibility26:                                     ////
////  - WISHBONE26                                                  ////
////  RS23226 Protocol26                                              ////
////  16550D uart26 (mostly26 supported)                              ////
////                                                              ////
////  Overview26 (main26 Features26):                                   ////
////  Registers26 of the uart26 16550 core26                            ////
////                                                              ////
////  Known26 problems26 (limits26):                                    ////
////  Inserts26 1 wait state in all WISHBONE26 transfers26              ////
////                                                              ////
////  To26 Do26:                                                      ////
////  Nothing or verification26.                                    ////
////                                                              ////
////  Author26(s):                                                  ////
////      - gorban26@opencores26.org26                                  ////
////      - Jacob26 Gorban26                                          ////
////      - Igor26 Mohor26 (igorm26@opencores26.org26)                      ////
////                                                              ////
////  Created26:        2001/05/12                                  ////
////  Last26 Updated26:   (See log26 for the revision26 history26           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2000, 2001 Authors26                             ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS26 Revision26 History26
//
// $Log: not supported by cvs2svn26 $
// Revision26 1.41  2004/05/21 11:44:41  tadejm26
// Added26 synchronizer26 flops26 for RX26 input.
//
// Revision26 1.40  2003/06/11 16:37:47  gorban26
// This26 fixes26 errors26 in some26 cases26 when data is being read and put to the FIFO at the same time. Patch26 is submitted26 by Scott26 Furman26. Update is very26 recommended26.
//
// Revision26 1.39  2002/07/29 21:16:18  gorban26
// The uart_defines26.v file is included26 again26 in sources26.
//
// Revision26 1.38  2002/07/22 23:02:23  gorban26
// Bug26 Fixes26:
//  * Possible26 loss of sync and bad26 reception26 of stop bit on slow26 baud26 rates26 fixed26.
//   Problem26 reported26 by Kenny26.Tung26.
//  * Bad (or lack26 of ) loopback26 handling26 fixed26. Reported26 by Cherry26 Withers26.
//
// Improvements26:
//  * Made26 FIFO's as general26 inferrable26 memory where possible26.
//  So26 on FPGA26 they should be inferred26 as RAM26 (Distributed26 RAM26 on Xilinx26).
//  This26 saves26 about26 1/3 of the Slice26 count and reduces26 P&R and synthesis26 times.
//
//  * Added26 optional26 baudrate26 output (baud_o26).
//  This26 is identical26 to BAUDOUT26* signal26 on 16550 chip26.
//  It outputs26 16xbit_clock_rate - the divided26 clock26.
//  It's disabled by default. Define26 UART_HAS_BAUDRATE_OUTPUT26 to use.
//
// Revision26 1.37  2001/12/27 13:24:09  mohor26
// lsr26[7] was not showing26 overrun26 errors26.
//
// Revision26 1.36  2001/12/20 13:25:46  mohor26
// rx26 push26 changed to be only one cycle wide26.
//
// Revision26 1.35  2001/12/19 08:03:34  mohor26
// Warnings26 cleared26.
//
// Revision26 1.34  2001/12/19 07:33:54  mohor26
// Synplicity26 was having26 troubles26 with the comment26.
//
// Revision26 1.33  2001/12/17 10:14:43  mohor26
// Things26 related26 to msr26 register changed. After26 THRE26 IRQ26 occurs26, and one
// character26 is written26 to the transmit26 fifo, the detection26 of the THRE26 bit in the
// LSR26 is delayed26 for one character26 time.
//
// Revision26 1.32  2001/12/14 13:19:24  mohor26
// MSR26 register fixed26.
//
// Revision26 1.31  2001/12/14 10:06:58  mohor26
// After26 reset modem26 status register MSR26 should be reset.
//
// Revision26 1.30  2001/12/13 10:09:13  mohor26
// thre26 irq26 should be cleared26 only when being source26 of interrupt26.
//
// Revision26 1.29  2001/12/12 09:05:46  mohor26
// LSR26 status bit 0 was not cleared26 correctly in case of reseting26 the FCR26 (rx26 fifo).
//
// Revision26 1.28  2001/12/10 19:52:41  gorban26
// Scratch26 register added
//
// Revision26 1.27  2001/12/06 14:51:04  gorban26
// Bug26 in LSR26[0] is fixed26.
// All WISHBONE26 signals26 are now sampled26, so another26 wait-state is introduced26 on all transfers26.
//
// Revision26 1.26  2001/12/03 21:44:29  gorban26
// Updated26 specification26 documentation.
// Added26 full 32-bit data bus interface, now as default.
// Address is 5-bit wide26 in 32-bit data bus mode.
// Added26 wb_sel_i26 input to the core26. It's used in the 32-bit mode.
// Added26 debug26 interface with two26 32-bit read-only registers in 32-bit mode.
// Bits26 5 and 6 of LSR26 are now only cleared26 on TX26 FIFO write.
// My26 small test bench26 is modified to work26 with 32-bit mode.
//
// Revision26 1.25  2001/11/28 19:36:39  gorban26
// Fixed26: timeout and break didn26't pay26 attention26 to current data format26 when counting26 time
//
// Revision26 1.24  2001/11/26 21:38:54  gorban26
// Lots26 of fixes26:
// Break26 condition wasn26't handled26 correctly at all.
// LSR26 bits could lose26 their26 values.
// LSR26 value after reset was wrong26.
// Timing26 of THRE26 interrupt26 signal26 corrected26.
// LSR26 bit 0 timing26 corrected26.
//
// Revision26 1.23  2001/11/12 21:57:29  gorban26
// fixed26 more typo26 bugs26
//
// Revision26 1.22  2001/11/12 15:02:28  mohor26
// lsr1r26 error fixed26.
//
// Revision26 1.21  2001/11/12 14:57:27  mohor26
// ti_int_pnd26 error fixed26.
//
// Revision26 1.20  2001/11/12 14:50:27  mohor26
// ti_int_d26 error fixed26.
//
// Revision26 1.19  2001/11/10 12:43:21  gorban26
// Logic26 Synthesis26 bugs26 fixed26. Some26 other minor26 changes26
//
// Revision26 1.18  2001/11/08 14:54:23  mohor26
// Comments26 in Slovene26 language26 deleted26, few26 small fixes26 for better26 work26 of
// old26 tools26. IRQs26 need to be fix26.
//
// Revision26 1.17  2001/11/07 17:51:52  gorban26
// Heavily26 rewritten26 interrupt26 and LSR26 subsystems26.
// Many26 bugs26 hopefully26 squashed26.
//
// Revision26 1.16  2001/11/02 09:55:16  mohor26
// no message
//
// Revision26 1.15  2001/10/31 15:19:22  gorban26
// Fixes26 to break and timeout conditions26
//
// Revision26 1.14  2001/10/29 17:00:46  gorban26
// fixed26 parity26 sending26 and tx_fifo26 resets26 over- and underrun26
//
// Revision26 1.13  2001/10/20 09:58:40  gorban26
// Small26 synopsis26 fixes26
//
// Revision26 1.12  2001/10/19 16:21:40  gorban26
// Changes26 data_out26 to be synchronous26 again26 as it should have been.
//
// Revision26 1.11  2001/10/18 20:35:45  gorban26
// small fix26
//
// Revision26 1.10  2001/08/24 21:01:12  mohor26
// Things26 connected26 to parity26 changed.
// Clock26 devider26 changed.
//
// Revision26 1.9  2001/08/23 16:05:05  mohor26
// Stop bit bug26 fixed26.
// Parity26 bug26 fixed26.
// WISHBONE26 read cycle bug26 fixed26,
// OE26 indicator26 (Overrun26 Error) bug26 fixed26.
// PE26 indicator26 (Parity26 Error) bug26 fixed26.
// Register read bug26 fixed26.
//
// Revision26 1.10  2001/06/23 11:21:48  gorban26
// DL26 made26 16-bit long26. Fixed26 transmission26/reception26 bugs26.
//
// Revision26 1.9  2001/05/31 20:08:01  gorban26
// FIFO changes26 and other corrections26.
//
// Revision26 1.8  2001/05/29 20:05:04  gorban26
// Fixed26 some26 bugs26 and synthesis26 problems26.
//
// Revision26 1.7  2001/05/27 17:37:49  gorban26
// Fixed26 many26 bugs26. Updated26 spec26. Changed26 FIFO files structure26. See CHANGES26.txt26 file.
//
// Revision26 1.6  2001/05/21 19:12:02  gorban26
// Corrected26 some26 Linter26 messages26.
//
// Revision26 1.5  2001/05/17 18:34:18  gorban26
// First26 'stable' release. Should26 be sythesizable26 now. Also26 added new header.
//
// Revision26 1.0  2001-05-17 21:27:11+02  jacob26
// Initial26 revision26
//
//

// synopsys26 translate_off26
`include "timescale.v"
// synopsys26 translate_on26

`include "uart_defines26.v"

`define UART_DL126 7:0
`define UART_DL226 15:8

module uart_regs26 (clk26,
	wb_rst_i26, wb_addr_i26, wb_dat_i26, wb_dat_o26, wb_we_i26, wb_re_i26, 

// additional26 signals26
	modem_inputs26,
	stx_pad_o26, srx_pad_i26,

`ifdef DATA_BUS_WIDTH_826
`else
// debug26 interface signals26	enabled
ier26, iir26, fcr26, mcr26, lcr26, msr26, lsr26, rf_count26, tf_count26, tstate26, rstate,
`endif				
	rts_pad_o26, dtr_pad_o26, int_o26
`ifdef UART_HAS_BAUDRATE_OUTPUT26
	, baud_o26
`endif

	);

input 									clk26;
input 									wb_rst_i26;
input [`UART_ADDR_WIDTH26-1:0] 		wb_addr_i26;
input [7:0] 							wb_dat_i26;
output [7:0] 							wb_dat_o26;
input 									wb_we_i26;
input 									wb_re_i26;

output 									stx_pad_o26;
input 									srx_pad_i26;

input [3:0] 							modem_inputs26;
output 									rts_pad_o26;
output 									dtr_pad_o26;
output 									int_o26;
`ifdef UART_HAS_BAUDRATE_OUTPUT26
output	baud_o26;
`endif

`ifdef DATA_BUS_WIDTH_826
`else
// if 32-bit databus26 and debug26 interface are enabled
output [3:0]							ier26;
output [3:0]							iir26;
output [1:0]							fcr26;  /// bits 7 and 6 of fcr26. Other26 bits are ignored
output [4:0]							mcr26;
output [7:0]							lcr26;
output [7:0]							msr26;
output [7:0] 							lsr26;
output [`UART_FIFO_COUNTER_W26-1:0] 	rf_count26;
output [`UART_FIFO_COUNTER_W26-1:0] 	tf_count26;
output [2:0] 							tstate26;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs26;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT26
assign baud_o26 = enable; // baud_o26 is actually26 the enable signal26
`endif


wire 										stx_pad_o26;		// received26 from transmitter26 module
wire 										srx_pad_i26;
wire 										srx_pad26;

reg [7:0] 								wb_dat_o26;

wire [`UART_ADDR_WIDTH26-1:0] 		wb_addr_i26;
wire [7:0] 								wb_dat_i26;


reg [3:0] 								ier26;
reg [3:0] 								iir26;
reg [1:0] 								fcr26;  /// bits 7 and 6 of fcr26. Other26 bits are ignored
reg [4:0] 								mcr26;
reg [7:0] 								lcr26;
reg [7:0] 								msr26;
reg [15:0] 								dl26;  // 32-bit divisor26 latch26
reg [7:0] 								scratch26; // UART26 scratch26 register
reg 										start_dlc26; // activate26 dlc26 on writing to UART_DL126
reg 										lsr_mask_d26; // delay for lsr_mask26 condition
reg 										msi_reset26; // reset MSR26 4 lower26 bits indicator26
//reg 										threi_clear26; // THRE26 interrupt26 clear flag26
reg [15:0] 								dlc26;  // 32-bit divisor26 latch26 counter
reg 										int_o26;

reg [3:0] 								trigger_level26; // trigger level of the receiver26 FIFO
reg 										rx_reset26;
reg 										tx_reset26;

wire 										dlab26;			   // divisor26 latch26 access bit
wire 										cts_pad_i26, dsr_pad_i26, ri_pad_i26, dcd_pad_i26; // modem26 status bits
wire 										loopback26;		   // loopback26 bit (MCR26 bit 4)
wire 										cts26, dsr26, ri, dcd26;	   // effective26 signals26
wire                    cts_c26, dsr_c26, ri_c26, dcd_c26; // Complement26 effective26 signals26 (considering26 loopback26)
wire 										rts_pad_o26, dtr_pad_o26;		   // modem26 control26 outputs26

// LSR26 bits wires26 and regs
wire [7:0] 								lsr26;
wire 										lsr026, lsr126, lsr226, lsr326, lsr426, lsr526, lsr626, lsr726;
reg										lsr0r26, lsr1r26, lsr2r26, lsr3r26, lsr4r26, lsr5r26, lsr6r26, lsr7r26;
wire 										lsr_mask26; // lsr_mask26

//
// ASSINGS26
//

assign 									lsr26[7:0] = { lsr7r26, lsr6r26, lsr5r26, lsr4r26, lsr3r26, lsr2r26, lsr1r26, lsr0r26 };

assign 									{cts_pad_i26, dsr_pad_i26, ri_pad_i26, dcd_pad_i26} = modem_inputs26;
assign 									{cts26, dsr26, ri, dcd26} = ~{cts_pad_i26,dsr_pad_i26,ri_pad_i26,dcd_pad_i26};

assign                  {cts_c26, dsr_c26, ri_c26, dcd_c26} = loopback26 ? {mcr26[`UART_MC_RTS26],mcr26[`UART_MC_DTR26],mcr26[`UART_MC_OUT126],mcr26[`UART_MC_OUT226]}
                                                               : {cts_pad_i26,dsr_pad_i26,ri_pad_i26,dcd_pad_i26};

assign 									dlab26 = lcr26[`UART_LC_DL26];
assign 									loopback26 = mcr26[4];

// assign modem26 outputs26
assign 									rts_pad_o26 = mcr26[`UART_MC_RTS26];
assign 									dtr_pad_o26 = mcr26[`UART_MC_DTR26];

// Interrupt26 signals26
wire 										rls_int26;  // receiver26 line status interrupt26
wire 										rda_int26;  // receiver26 data available interrupt26
wire 										ti_int26;   // timeout indicator26 interrupt26
wire										thre_int26; // transmitter26 holding26 register empty26 interrupt26
wire 										ms_int26;   // modem26 status interrupt26

// FIFO signals26
reg 										tf_push26;
reg 										rf_pop26;
wire [`UART_FIFO_REC_WIDTH26-1:0] 	rf_data_out26;
wire 										rf_error_bit26; // an error (parity26 or framing26) is inside the fifo
wire [`UART_FIFO_COUNTER_W26-1:0] 	rf_count26;
wire [`UART_FIFO_COUNTER_W26-1:0] 	tf_count26;
wire [2:0] 								tstate26;
wire [3:0] 								rstate;
wire [9:0] 								counter_t26;

wire                      thre_set_en26; // THRE26 status is delayed26 one character26 time when a character26 is written26 to fifo.
reg  [7:0]                block_cnt26;   // While26 counter counts26, THRE26 status is blocked26 (delayed26 one character26 cycle)
reg  [7:0]                block_value26; // One26 character26 length minus26 stop bit

// Transmitter26 Instance
wire serial_out26;

uart_transmitter26 transmitter26(clk26, wb_rst_i26, lcr26, tf_push26, wb_dat_i26, enable, serial_out26, tstate26, tf_count26, tx_reset26, lsr_mask26);

  // Synchronizing26 and sampling26 serial26 RX26 input
  uart_sync_flops26    i_uart_sync_flops26
  (
    .rst_i26           (wb_rst_i26),
    .clk_i26           (clk26),
    .stage1_rst_i26    (1'b0),
    .stage1_clk_en_i26 (1'b1),
    .async_dat_i26     (srx_pad_i26),
    .sync_dat_o26      (srx_pad26)
  );
  defparam i_uart_sync_flops26.width      = 1;
  defparam i_uart_sync_flops26.init_value26 = 1'b1;

// handle loopback26
wire serial_in26 = loopback26 ? serial_out26 : srx_pad26;
assign stx_pad_o26 = loopback26 ? 1'b1 : serial_out26;

// Receiver26 Instance
uart_receiver26 receiver26(clk26, wb_rst_i26, lcr26, rf_pop26, serial_in26, enable, 
	counter_t26, rf_count26, rf_data_out26, rf_error_bit26, rf_overrun26, rx_reset26, lsr_mask26, rstate, rf_push_pulse26);


// Asynchronous26 reading here26 because the outputs26 are sampled26 in uart_wb26.v file 
always @(dl26 or dlab26 or ier26 or iir26 or scratch26
			or lcr26 or lsr26 or msr26 or rf_data_out26 or wb_addr_i26 or wb_re_i26)   // asynchrounous26 reading
begin
	case (wb_addr_i26)
		`UART_REG_RB26   : wb_dat_o26 = dlab26 ? dl26[`UART_DL126] : rf_data_out26[10:3];
		`UART_REG_IE26	: wb_dat_o26 = dlab26 ? dl26[`UART_DL226] : ier26;
		`UART_REG_II26	: wb_dat_o26 = {4'b1100,iir26};
		`UART_REG_LC26	: wb_dat_o26 = lcr26;
		`UART_REG_LS26	: wb_dat_o26 = lsr26;
		`UART_REG_MS26	: wb_dat_o26 = msr26;
		`UART_REG_SR26	: wb_dat_o26 = scratch26;
		default:  wb_dat_o26 = 8'b0; // ??
	endcase // case(wb_addr_i26)
end // always @ (dl26 or dlab26 or ier26 or iir26 or scratch26...


// rf_pop26 signal26 handling26
always @(posedge clk26 or posedge wb_rst_i26)
begin
	if (wb_rst_i26)
		rf_pop26 <= #1 0; 
	else
	if (rf_pop26)	// restore26 the signal26 to 0 after one clock26 cycle
		rf_pop26 <= #1 0;
	else
	if (wb_re_i26 && wb_addr_i26 == `UART_REG_RB26 && !dlab26)
		rf_pop26 <= #1 1; // advance26 read pointer26
end

wire 	lsr_mask_condition26;
wire 	iir_read26;
wire  msr_read26;
wire	fifo_read26;
wire	fifo_write26;

assign lsr_mask_condition26 = (wb_re_i26 && wb_addr_i26 == `UART_REG_LS26 && !dlab26);
assign iir_read26 = (wb_re_i26 && wb_addr_i26 == `UART_REG_II26 && !dlab26);
assign msr_read26 = (wb_re_i26 && wb_addr_i26 == `UART_REG_MS26 && !dlab26);
assign fifo_read26 = (wb_re_i26 && wb_addr_i26 == `UART_REG_RB26 && !dlab26);
assign fifo_write26 = (wb_we_i26 && wb_addr_i26 == `UART_REG_TR26 && !dlab26);

// lsr_mask_d26 delayed26 signal26 handling26
always @(posedge clk26 or posedge wb_rst_i26)
begin
	if (wb_rst_i26)
		lsr_mask_d26 <= #1 0;
	else // reset bits in the Line26 Status Register
		lsr_mask_d26 <= #1 lsr_mask_condition26;
end

// lsr_mask26 is rise26 detected
assign lsr_mask26 = lsr_mask_condition26 && ~lsr_mask_d26;

// msi_reset26 signal26 handling26
always @(posedge clk26 or posedge wb_rst_i26)
begin
	if (wb_rst_i26)
		msi_reset26 <= #1 1;
	else
	if (msi_reset26)
		msi_reset26 <= #1 0;
	else
	if (msr_read26)
		msi_reset26 <= #1 1; // reset bits in Modem26 Status Register
end


//
//   WRITES26 AND26 RESETS26   //
//
// Line26 Control26 Register
always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26)
		lcr26 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i26 && wb_addr_i26==`UART_REG_LC26)
		lcr26 <= #1 wb_dat_i26;

// Interrupt26 Enable26 Register or UART_DL226
always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26)
	begin
		ier26 <= #1 4'b0000; // no interrupts26 after reset
		dl26[`UART_DL226] <= #1 8'b0;
	end
	else
	if (wb_we_i26 && wb_addr_i26==`UART_REG_IE26)
		if (dlab26)
		begin
			dl26[`UART_DL226] <= #1 wb_dat_i26;
		end
		else
			ier26 <= #1 wb_dat_i26[3:0]; // ier26 uses only 4 lsb


// FIFO Control26 Register and rx_reset26, tx_reset26 signals26
always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) begin
		fcr26 <= #1 2'b11; 
		rx_reset26 <= #1 0;
		tx_reset26 <= #1 0;
	end else
	if (wb_we_i26 && wb_addr_i26==`UART_REG_FC26) begin
		fcr26 <= #1 wb_dat_i26[7:6];
		rx_reset26 <= #1 wb_dat_i26[1];
		tx_reset26 <= #1 wb_dat_i26[2];
	end else begin
		rx_reset26 <= #1 0;
		tx_reset26 <= #1 0;
	end

// Modem26 Control26 Register
always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26)
		mcr26 <= #1 5'b0; 
	else
	if (wb_we_i26 && wb_addr_i26==`UART_REG_MC26)
			mcr26 <= #1 wb_dat_i26[4:0];

// Scratch26 register
// Line26 Control26 Register
always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26)
		scratch26 <= #1 0; // 8n1 setting
	else
	if (wb_we_i26 && wb_addr_i26==`UART_REG_SR26)
		scratch26 <= #1 wb_dat_i26;

// TX_FIFO26 or UART_DL126
always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26)
	begin
		dl26[`UART_DL126]  <= #1 8'b0;
		tf_push26   <= #1 1'b0;
		start_dlc26 <= #1 1'b0;
	end
	else
	if (wb_we_i26 && wb_addr_i26==`UART_REG_TR26)
		if (dlab26)
		begin
			dl26[`UART_DL126] <= #1 wb_dat_i26;
			start_dlc26 <= #1 1'b1; // enable DL26 counter
			tf_push26 <= #1 1'b0;
		end
		else
		begin
			tf_push26   <= #1 1'b1;
			start_dlc26 <= #1 1'b0;
		end // else: !if(dlab26)
	else
	begin
		start_dlc26 <= #1 1'b0;
		tf_push26   <= #1 1'b0;
	end // else: !if(dlab26)

// Receiver26 FIFO trigger level selection logic (asynchronous26 mux26)
always @(fcr26)
	case (fcr26[`UART_FC_TL26])
		2'b00 : trigger_level26 = 1;
		2'b01 : trigger_level26 = 4;
		2'b10 : trigger_level26 = 8;
		2'b11 : trigger_level26 = 14;
	endcase // case(fcr26[`UART_FC_TL26])
	
//
//  STATUS26 REGISTERS26  //
//

// Modem26 Status Register
reg [3:0] delayed_modem_signals26;
always @(posedge clk26 or posedge wb_rst_i26)
begin
	if (wb_rst_i26)
	  begin
  		msr26 <= #1 0;
	  	delayed_modem_signals26[3:0] <= #1 0;
	  end
	else begin
		msr26[`UART_MS_DDCD26:`UART_MS_DCTS26] <= #1 msi_reset26 ? 4'b0 :
			msr26[`UART_MS_DDCD26:`UART_MS_DCTS26] | ({dcd26, ri, dsr26, cts26} ^ delayed_modem_signals26[3:0]);
		msr26[`UART_MS_CDCD26:`UART_MS_CCTS26] <= #1 {dcd_c26, ri_c26, dsr_c26, cts_c26};
		delayed_modem_signals26[3:0] <= #1 {dcd26, ri, dsr26, cts26};
	end
end


// Line26 Status Register

// activation26 conditions26
assign lsr026 = (rf_count26==0 && rf_push_pulse26);  // data in receiver26 fifo available set condition
assign lsr126 = rf_overrun26;     // Receiver26 overrun26 error
assign lsr226 = rf_data_out26[1]; // parity26 error bit
assign lsr326 = rf_data_out26[0]; // framing26 error bit
assign lsr426 = rf_data_out26[2]; // break error in the character26
assign lsr526 = (tf_count26==5'b0 && thre_set_en26);  // transmitter26 fifo is empty26
assign lsr626 = (tf_count26==5'b0 && thre_set_en26 && (tstate26 == /*`S_IDLE26 */ 0)); // transmitter26 empty26
assign lsr726 = rf_error_bit26 | rf_overrun26;

// lsr26 bit026 (receiver26 data available)
reg 	 lsr0_d26;

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr0_d26 <= #1 0;
	else lsr0_d26 <= #1 lsr026;

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr0r26 <= #1 0;
	else lsr0r26 <= #1 (rf_count26==1 && rf_pop26 && !rf_push_pulse26 || rx_reset26) ? 0 : // deassert26 condition
					  lsr0r26 || (lsr026 && ~lsr0_d26); // set on rise26 of lsr026 and keep26 asserted26 until deasserted26 

// lsr26 bit 1 (receiver26 overrun26)
reg lsr1_d26; // delayed26

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr1_d26 <= #1 0;
	else lsr1_d26 <= #1 lsr126;

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr1r26 <= #1 0;
	else	lsr1r26 <= #1	lsr_mask26 ? 0 : lsr1r26 || (lsr126 && ~lsr1_d26); // set on rise26

// lsr26 bit 2 (parity26 error)
reg lsr2_d26; // delayed26

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr2_d26 <= #1 0;
	else lsr2_d26 <= #1 lsr226;

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr2r26 <= #1 0;
	else lsr2r26 <= #1 lsr_mask26 ? 0 : lsr2r26 || (lsr226 && ~lsr2_d26); // set on rise26

// lsr26 bit 3 (framing26 error)
reg lsr3_d26; // delayed26

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr3_d26 <= #1 0;
	else lsr3_d26 <= #1 lsr326;

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr3r26 <= #1 0;
	else lsr3r26 <= #1 lsr_mask26 ? 0 : lsr3r26 || (lsr326 && ~lsr3_d26); // set on rise26

// lsr26 bit 4 (break indicator26)
reg lsr4_d26; // delayed26

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr4_d26 <= #1 0;
	else lsr4_d26 <= #1 lsr426;

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr4r26 <= #1 0;
	else lsr4r26 <= #1 lsr_mask26 ? 0 : lsr4r26 || (lsr426 && ~lsr4_d26);

// lsr26 bit 5 (transmitter26 fifo is empty26)
reg lsr5_d26;

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr5_d26 <= #1 1;
	else lsr5_d26 <= #1 lsr526;

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr5r26 <= #1 1;
	else lsr5r26 <= #1 (fifo_write26) ? 0 :  lsr5r26 || (lsr526 && ~lsr5_d26);

// lsr26 bit 6 (transmitter26 empty26 indicator26)
reg lsr6_d26;

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr6_d26 <= #1 1;
	else lsr6_d26 <= #1 lsr626;

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr6r26 <= #1 1;
	else lsr6r26 <= #1 (fifo_write26) ? 0 : lsr6r26 || (lsr626 && ~lsr6_d26);

// lsr26 bit 7 (error in fifo)
reg lsr7_d26;

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr7_d26 <= #1 0;
	else lsr7_d26 <= #1 lsr726;

always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) lsr7r26 <= #1 0;
	else lsr7r26 <= #1 lsr_mask26 ? 0 : lsr7r26 || (lsr726 && ~lsr7_d26);

// Frequency26 divider26
always @(posedge clk26 or posedge wb_rst_i26) 
begin
	if (wb_rst_i26)
		dlc26 <= #1 0;
	else
		if (start_dlc26 | ~ (|dlc26))
  			dlc26 <= #1 dl26 - 1;               // preset26 counter
		else
			dlc26 <= #1 dlc26 - 1;              // decrement counter
end

// Enable26 signal26 generation26 logic
always @(posedge clk26 or posedge wb_rst_i26)
begin
	if (wb_rst_i26)
		enable <= #1 1'b0;
	else
		if (|dl26 & ~(|dlc26))     // dl26>0 & dlc26==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying26 THRE26 status for one character26 cycle after a character26 is written26 to an empty26 fifo.
always @(lcr26)
  case (lcr26[3:0])
    4'b0000                             : block_value26 =  95; // 6 bits
    4'b0100                             : block_value26 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value26 = 111; // 7 bits
    4'b1100                             : block_value26 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value26 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value26 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value26 = 159; // 10 bits
    4'b1111                             : block_value26 = 175; // 11 bits
  endcase // case(lcr26[3:0])

// Counting26 time of one character26 minus26 stop bit
always @(posedge clk26 or posedge wb_rst_i26)
begin
  if (wb_rst_i26)
    block_cnt26 <= #1 8'd0;
  else
  if(lsr5r26 & fifo_write26)  // THRE26 bit set & write to fifo occured26
    block_cnt26 <= #1 block_value26;
  else
  if (enable & block_cnt26 != 8'b0)  // only work26 on enable times
    block_cnt26 <= #1 block_cnt26 - 1;  // decrement break counter
end // always of break condition detection26

// Generating26 THRE26 status enable signal26
assign thre_set_en26 = ~(|block_cnt26);


//
//	INTERRUPT26 LOGIC26
//

assign rls_int26  = ier26[`UART_IE_RLS26] && (lsr26[`UART_LS_OE26] || lsr26[`UART_LS_PE26] || lsr26[`UART_LS_FE26] || lsr26[`UART_LS_BI26]);
assign rda_int26  = ier26[`UART_IE_RDA26] && (rf_count26 >= {1'b0,trigger_level26});
assign thre_int26 = ier26[`UART_IE_THRE26] && lsr26[`UART_LS_TFE26];
assign ms_int26   = ier26[`UART_IE_MS26] && (| msr26[3:0]);
assign ti_int26   = ier26[`UART_IE_RDA26] && (counter_t26 == 10'b0) && (|rf_count26);

reg 	 rls_int_d26;
reg 	 thre_int_d26;
reg 	 ms_int_d26;
reg 	 ti_int_d26;
reg 	 rda_int_d26;

// delay lines26
always  @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) rls_int_d26 <= #1 0;
	else rls_int_d26 <= #1 rls_int26;

always  @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) rda_int_d26 <= #1 0;
	else rda_int_d26 <= #1 rda_int26;

always  @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) thre_int_d26 <= #1 0;
	else thre_int_d26 <= #1 thre_int26;

always  @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) ms_int_d26 <= #1 0;
	else ms_int_d26 <= #1 ms_int26;

always  @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) ti_int_d26 <= #1 0;
	else ti_int_d26 <= #1 ti_int26;

// rise26 detection26 signals26

wire 	 rls_int_rise26;
wire 	 thre_int_rise26;
wire 	 ms_int_rise26;
wire 	 ti_int_rise26;
wire 	 rda_int_rise26;

assign rda_int_rise26    = rda_int26 & ~rda_int_d26;
assign rls_int_rise26 	  = rls_int26 & ~rls_int_d26;
assign thre_int_rise26   = thre_int26 & ~thre_int_d26;
assign ms_int_rise26 	  = ms_int26 & ~ms_int_d26;
assign ti_int_rise26 	  = ti_int26 & ~ti_int_d26;

// interrupt26 pending flags26
reg 	rls_int_pnd26;
reg	rda_int_pnd26;
reg 	thre_int_pnd26;
reg 	ms_int_pnd26;
reg 	ti_int_pnd26;

// interrupt26 pending flags26 assignments26
always  @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) rls_int_pnd26 <= #1 0; 
	else 
		rls_int_pnd26 <= #1 lsr_mask26 ? 0 :  						// reset condition
							rls_int_rise26 ? 1 :						// latch26 condition
							rls_int_pnd26 && ier26[`UART_IE_RLS26];	// default operation26: remove if masked26

always  @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) rda_int_pnd26 <= #1 0; 
	else 
		rda_int_pnd26 <= #1 ((rf_count26 == {1'b0,trigger_level26}) && fifo_read26) ? 0 :  	// reset condition
							rda_int_rise26 ? 1 :						// latch26 condition
							rda_int_pnd26 && ier26[`UART_IE_RDA26];	// default operation26: remove if masked26

always  @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) thre_int_pnd26 <= #1 0; 
	else 
		thre_int_pnd26 <= #1 fifo_write26 || (iir_read26 & ~iir26[`UART_II_IP26] & iir26[`UART_II_II26] == `UART_II_THRE26)? 0 : 
							thre_int_rise26 ? 1 :
							thre_int_pnd26 && ier26[`UART_IE_THRE26];

always  @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) ms_int_pnd26 <= #1 0; 
	else 
		ms_int_pnd26 <= #1 msr_read26 ? 0 : 
							ms_int_rise26 ? 1 :
							ms_int_pnd26 && ier26[`UART_IE_MS26];

always  @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) ti_int_pnd26 <= #1 0; 
	else 
		ti_int_pnd26 <= #1 fifo_read26 ? 0 : 
							ti_int_rise26 ? 1 :
							ti_int_pnd26 && ier26[`UART_IE_RDA26];
// end of pending flags26

// INT_O26 logic
always @(posedge clk26 or posedge wb_rst_i26)
begin
	if (wb_rst_i26)	
		int_o26 <= #1 1'b0;
	else
		int_o26 <= #1 
					rls_int_pnd26		?	~lsr_mask26					:
					rda_int_pnd26		? 1								:
					ti_int_pnd26		? ~fifo_read26					:
					thre_int_pnd26	? !(fifo_write26 & iir_read26) :
					ms_int_pnd26		? ~msr_read26						:
					0;	// if no interrupt26 are pending
end


// Interrupt26 Identification26 register
always @(posedge clk26 or posedge wb_rst_i26)
begin
	if (wb_rst_i26)
		iir26 <= #1 1;
	else
	if (rls_int_pnd26)  // interrupt26 is pending
	begin
		iir26[`UART_II_II26] <= #1 `UART_II_RLS26;	// set identification26 register to correct26 value
		iir26[`UART_II_IP26] <= #1 1'b0;		// and clear the IIR26 bit 0 (interrupt26 pending)
	end else // the sequence of conditions26 determines26 priority of interrupt26 identification26
	if (rda_int26)
	begin
		iir26[`UART_II_II26] <= #1 `UART_II_RDA26;
		iir26[`UART_II_IP26] <= #1 1'b0;
	end
	else if (ti_int_pnd26)
	begin
		iir26[`UART_II_II26] <= #1 `UART_II_TI26;
		iir26[`UART_II_IP26] <= #1 1'b0;
	end
	else if (thre_int_pnd26)
	begin
		iir26[`UART_II_II26] <= #1 `UART_II_THRE26;
		iir26[`UART_II_IP26] <= #1 1'b0;
	end
	else if (ms_int_pnd26)
	begin
		iir26[`UART_II_II26] <= #1 `UART_II_MS26;
		iir26[`UART_II_IP26] <= #1 1'b0;
	end else	// no interrupt26 is pending
	begin
		iir26[`UART_II_II26] <= #1 0;
		iir26[`UART_II_IP26] <= #1 1'b1;
	end
end

endmodule
