//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs21.v                                                 ////
////                                                              ////
////                                                              ////
////  This21 file is part of the "UART21 16550 compatible21" project21    ////
////  http21://www21.opencores21.org21/cores21/uart1655021/                   ////
////                                                              ////
////  Documentation21 related21 to this project21:                      ////
////  - http21://www21.opencores21.org21/cores21/uart1655021/                 ////
////                                                              ////
////  Projects21 compatibility21:                                     ////
////  - WISHBONE21                                                  ////
////  RS23221 Protocol21                                              ////
////  16550D uart21 (mostly21 supported)                              ////
////                                                              ////
////  Overview21 (main21 Features21):                                   ////
////  Registers21 of the uart21 16550 core21                            ////
////                                                              ////
////  Known21 problems21 (limits21):                                    ////
////  Inserts21 1 wait state in all WISHBONE21 transfers21              ////
////                                                              ////
////  To21 Do21:                                                      ////
////  Nothing or verification21.                                    ////
////                                                              ////
////  Author21(s):                                                  ////
////      - gorban21@opencores21.org21                                  ////
////      - Jacob21 Gorban21                                          ////
////      - Igor21 Mohor21 (igorm21@opencores21.org21)                      ////
////                                                              ////
////  Created21:        2001/05/12                                  ////
////  Last21 Updated21:   (See log21 for the revision21 history21           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2000, 2001 Authors21                             ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS21 Revision21 History21
//
// $Log: not supported by cvs2svn21 $
// Revision21 1.41  2004/05/21 11:44:41  tadejm21
// Added21 synchronizer21 flops21 for RX21 input.
//
// Revision21 1.40  2003/06/11 16:37:47  gorban21
// This21 fixes21 errors21 in some21 cases21 when data is being read and put to the FIFO at the same time. Patch21 is submitted21 by Scott21 Furman21. Update is very21 recommended21.
//
// Revision21 1.39  2002/07/29 21:16:18  gorban21
// The uart_defines21.v file is included21 again21 in sources21.
//
// Revision21 1.38  2002/07/22 23:02:23  gorban21
// Bug21 Fixes21:
//  * Possible21 loss of sync and bad21 reception21 of stop bit on slow21 baud21 rates21 fixed21.
//   Problem21 reported21 by Kenny21.Tung21.
//  * Bad (or lack21 of ) loopback21 handling21 fixed21. Reported21 by Cherry21 Withers21.
//
// Improvements21:
//  * Made21 FIFO's as general21 inferrable21 memory where possible21.
//  So21 on FPGA21 they should be inferred21 as RAM21 (Distributed21 RAM21 on Xilinx21).
//  This21 saves21 about21 1/3 of the Slice21 count and reduces21 P&R and synthesis21 times.
//
//  * Added21 optional21 baudrate21 output (baud_o21).
//  This21 is identical21 to BAUDOUT21* signal21 on 16550 chip21.
//  It outputs21 16xbit_clock_rate - the divided21 clock21.
//  It's disabled by default. Define21 UART_HAS_BAUDRATE_OUTPUT21 to use.
//
// Revision21 1.37  2001/12/27 13:24:09  mohor21
// lsr21[7] was not showing21 overrun21 errors21.
//
// Revision21 1.36  2001/12/20 13:25:46  mohor21
// rx21 push21 changed to be only one cycle wide21.
//
// Revision21 1.35  2001/12/19 08:03:34  mohor21
// Warnings21 cleared21.
//
// Revision21 1.34  2001/12/19 07:33:54  mohor21
// Synplicity21 was having21 troubles21 with the comment21.
//
// Revision21 1.33  2001/12/17 10:14:43  mohor21
// Things21 related21 to msr21 register changed. After21 THRE21 IRQ21 occurs21, and one
// character21 is written21 to the transmit21 fifo, the detection21 of the THRE21 bit in the
// LSR21 is delayed21 for one character21 time.
//
// Revision21 1.32  2001/12/14 13:19:24  mohor21
// MSR21 register fixed21.
//
// Revision21 1.31  2001/12/14 10:06:58  mohor21
// After21 reset modem21 status register MSR21 should be reset.
//
// Revision21 1.30  2001/12/13 10:09:13  mohor21
// thre21 irq21 should be cleared21 only when being source21 of interrupt21.
//
// Revision21 1.29  2001/12/12 09:05:46  mohor21
// LSR21 status bit 0 was not cleared21 correctly in case of reseting21 the FCR21 (rx21 fifo).
//
// Revision21 1.28  2001/12/10 19:52:41  gorban21
// Scratch21 register added
//
// Revision21 1.27  2001/12/06 14:51:04  gorban21
// Bug21 in LSR21[0] is fixed21.
// All WISHBONE21 signals21 are now sampled21, so another21 wait-state is introduced21 on all transfers21.
//
// Revision21 1.26  2001/12/03 21:44:29  gorban21
// Updated21 specification21 documentation.
// Added21 full 32-bit data bus interface, now as default.
// Address is 5-bit wide21 in 32-bit data bus mode.
// Added21 wb_sel_i21 input to the core21. It's used in the 32-bit mode.
// Added21 debug21 interface with two21 32-bit read-only registers in 32-bit mode.
// Bits21 5 and 6 of LSR21 are now only cleared21 on TX21 FIFO write.
// My21 small test bench21 is modified to work21 with 32-bit mode.
//
// Revision21 1.25  2001/11/28 19:36:39  gorban21
// Fixed21: timeout and break didn21't pay21 attention21 to current data format21 when counting21 time
//
// Revision21 1.24  2001/11/26 21:38:54  gorban21
// Lots21 of fixes21:
// Break21 condition wasn21't handled21 correctly at all.
// LSR21 bits could lose21 their21 values.
// LSR21 value after reset was wrong21.
// Timing21 of THRE21 interrupt21 signal21 corrected21.
// LSR21 bit 0 timing21 corrected21.
//
// Revision21 1.23  2001/11/12 21:57:29  gorban21
// fixed21 more typo21 bugs21
//
// Revision21 1.22  2001/11/12 15:02:28  mohor21
// lsr1r21 error fixed21.
//
// Revision21 1.21  2001/11/12 14:57:27  mohor21
// ti_int_pnd21 error fixed21.
//
// Revision21 1.20  2001/11/12 14:50:27  mohor21
// ti_int_d21 error fixed21.
//
// Revision21 1.19  2001/11/10 12:43:21  gorban21
// Logic21 Synthesis21 bugs21 fixed21. Some21 other minor21 changes21
//
// Revision21 1.18  2001/11/08 14:54:23  mohor21
// Comments21 in Slovene21 language21 deleted21, few21 small fixes21 for better21 work21 of
// old21 tools21. IRQs21 need to be fix21.
//
// Revision21 1.17  2001/11/07 17:51:52  gorban21
// Heavily21 rewritten21 interrupt21 and LSR21 subsystems21.
// Many21 bugs21 hopefully21 squashed21.
//
// Revision21 1.16  2001/11/02 09:55:16  mohor21
// no message
//
// Revision21 1.15  2001/10/31 15:19:22  gorban21
// Fixes21 to break and timeout conditions21
//
// Revision21 1.14  2001/10/29 17:00:46  gorban21
// fixed21 parity21 sending21 and tx_fifo21 resets21 over- and underrun21
//
// Revision21 1.13  2001/10/20 09:58:40  gorban21
// Small21 synopsis21 fixes21
//
// Revision21 1.12  2001/10/19 16:21:40  gorban21
// Changes21 data_out21 to be synchronous21 again21 as it should have been.
//
// Revision21 1.11  2001/10/18 20:35:45  gorban21
// small fix21
//
// Revision21 1.10  2001/08/24 21:01:12  mohor21
// Things21 connected21 to parity21 changed.
// Clock21 devider21 changed.
//
// Revision21 1.9  2001/08/23 16:05:05  mohor21
// Stop bit bug21 fixed21.
// Parity21 bug21 fixed21.
// WISHBONE21 read cycle bug21 fixed21,
// OE21 indicator21 (Overrun21 Error) bug21 fixed21.
// PE21 indicator21 (Parity21 Error) bug21 fixed21.
// Register read bug21 fixed21.
//
// Revision21 1.10  2001/06/23 11:21:48  gorban21
// DL21 made21 16-bit long21. Fixed21 transmission21/reception21 bugs21.
//
// Revision21 1.9  2001/05/31 20:08:01  gorban21
// FIFO changes21 and other corrections21.
//
// Revision21 1.8  2001/05/29 20:05:04  gorban21
// Fixed21 some21 bugs21 and synthesis21 problems21.
//
// Revision21 1.7  2001/05/27 17:37:49  gorban21
// Fixed21 many21 bugs21. Updated21 spec21. Changed21 FIFO files structure21. See CHANGES21.txt21 file.
//
// Revision21 1.6  2001/05/21 19:12:02  gorban21
// Corrected21 some21 Linter21 messages21.
//
// Revision21 1.5  2001/05/17 18:34:18  gorban21
// First21 'stable' release. Should21 be sythesizable21 now. Also21 added new header.
//
// Revision21 1.0  2001-05-17 21:27:11+02  jacob21
// Initial21 revision21
//
//

// synopsys21 translate_off21
`include "timescale.v"
// synopsys21 translate_on21

`include "uart_defines21.v"

`define UART_DL121 7:0
`define UART_DL221 15:8

module uart_regs21 (clk21,
	wb_rst_i21, wb_addr_i21, wb_dat_i21, wb_dat_o21, wb_we_i21, wb_re_i21, 

// additional21 signals21
	modem_inputs21,
	stx_pad_o21, srx_pad_i21,

`ifdef DATA_BUS_WIDTH_821
`else
// debug21 interface signals21	enabled
ier21, iir21, fcr21, mcr21, lcr21, msr21, lsr21, rf_count21, tf_count21, tstate21, rstate,
`endif				
	rts_pad_o21, dtr_pad_o21, int_o21
`ifdef UART_HAS_BAUDRATE_OUTPUT21
	, baud_o21
`endif

	);

input 									clk21;
input 									wb_rst_i21;
input [`UART_ADDR_WIDTH21-1:0] 		wb_addr_i21;
input [7:0] 							wb_dat_i21;
output [7:0] 							wb_dat_o21;
input 									wb_we_i21;
input 									wb_re_i21;

output 									stx_pad_o21;
input 									srx_pad_i21;

input [3:0] 							modem_inputs21;
output 									rts_pad_o21;
output 									dtr_pad_o21;
output 									int_o21;
`ifdef UART_HAS_BAUDRATE_OUTPUT21
output	baud_o21;
`endif

`ifdef DATA_BUS_WIDTH_821
`else
// if 32-bit databus21 and debug21 interface are enabled
output [3:0]							ier21;
output [3:0]							iir21;
output [1:0]							fcr21;  /// bits 7 and 6 of fcr21. Other21 bits are ignored
output [4:0]							mcr21;
output [7:0]							lcr21;
output [7:0]							msr21;
output [7:0] 							lsr21;
output [`UART_FIFO_COUNTER_W21-1:0] 	rf_count21;
output [`UART_FIFO_COUNTER_W21-1:0] 	tf_count21;
output [2:0] 							tstate21;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs21;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT21
assign baud_o21 = enable; // baud_o21 is actually21 the enable signal21
`endif


wire 										stx_pad_o21;		// received21 from transmitter21 module
wire 										srx_pad_i21;
wire 										srx_pad21;

reg [7:0] 								wb_dat_o21;

wire [`UART_ADDR_WIDTH21-1:0] 		wb_addr_i21;
wire [7:0] 								wb_dat_i21;


reg [3:0] 								ier21;
reg [3:0] 								iir21;
reg [1:0] 								fcr21;  /// bits 7 and 6 of fcr21. Other21 bits are ignored
reg [4:0] 								mcr21;
reg [7:0] 								lcr21;
reg [7:0] 								msr21;
reg [15:0] 								dl21;  // 32-bit divisor21 latch21
reg [7:0] 								scratch21; // UART21 scratch21 register
reg 										start_dlc21; // activate21 dlc21 on writing to UART_DL121
reg 										lsr_mask_d21; // delay for lsr_mask21 condition
reg 										msi_reset21; // reset MSR21 4 lower21 bits indicator21
//reg 										threi_clear21; // THRE21 interrupt21 clear flag21
reg [15:0] 								dlc21;  // 32-bit divisor21 latch21 counter
reg 										int_o21;

reg [3:0] 								trigger_level21; // trigger level of the receiver21 FIFO
reg 										rx_reset21;
reg 										tx_reset21;

wire 										dlab21;			   // divisor21 latch21 access bit
wire 										cts_pad_i21, dsr_pad_i21, ri_pad_i21, dcd_pad_i21; // modem21 status bits
wire 										loopback21;		   // loopback21 bit (MCR21 bit 4)
wire 										cts21, dsr21, ri, dcd21;	   // effective21 signals21
wire                    cts_c21, dsr_c21, ri_c21, dcd_c21; // Complement21 effective21 signals21 (considering21 loopback21)
wire 										rts_pad_o21, dtr_pad_o21;		   // modem21 control21 outputs21

// LSR21 bits wires21 and regs
wire [7:0] 								lsr21;
wire 										lsr021, lsr121, lsr221, lsr321, lsr421, lsr521, lsr621, lsr721;
reg										lsr0r21, lsr1r21, lsr2r21, lsr3r21, lsr4r21, lsr5r21, lsr6r21, lsr7r21;
wire 										lsr_mask21; // lsr_mask21

//
// ASSINGS21
//

assign 									lsr21[7:0] = { lsr7r21, lsr6r21, lsr5r21, lsr4r21, lsr3r21, lsr2r21, lsr1r21, lsr0r21 };

assign 									{cts_pad_i21, dsr_pad_i21, ri_pad_i21, dcd_pad_i21} = modem_inputs21;
assign 									{cts21, dsr21, ri, dcd21} = ~{cts_pad_i21,dsr_pad_i21,ri_pad_i21,dcd_pad_i21};

assign                  {cts_c21, dsr_c21, ri_c21, dcd_c21} = loopback21 ? {mcr21[`UART_MC_RTS21],mcr21[`UART_MC_DTR21],mcr21[`UART_MC_OUT121],mcr21[`UART_MC_OUT221]}
                                                               : {cts_pad_i21,dsr_pad_i21,ri_pad_i21,dcd_pad_i21};

assign 									dlab21 = lcr21[`UART_LC_DL21];
assign 									loopback21 = mcr21[4];

// assign modem21 outputs21
assign 									rts_pad_o21 = mcr21[`UART_MC_RTS21];
assign 									dtr_pad_o21 = mcr21[`UART_MC_DTR21];

// Interrupt21 signals21
wire 										rls_int21;  // receiver21 line status interrupt21
wire 										rda_int21;  // receiver21 data available interrupt21
wire 										ti_int21;   // timeout indicator21 interrupt21
wire										thre_int21; // transmitter21 holding21 register empty21 interrupt21
wire 										ms_int21;   // modem21 status interrupt21

// FIFO signals21
reg 										tf_push21;
reg 										rf_pop21;
wire [`UART_FIFO_REC_WIDTH21-1:0] 	rf_data_out21;
wire 										rf_error_bit21; // an error (parity21 or framing21) is inside the fifo
wire [`UART_FIFO_COUNTER_W21-1:0] 	rf_count21;
wire [`UART_FIFO_COUNTER_W21-1:0] 	tf_count21;
wire [2:0] 								tstate21;
wire [3:0] 								rstate;
wire [9:0] 								counter_t21;

wire                      thre_set_en21; // THRE21 status is delayed21 one character21 time when a character21 is written21 to fifo.
reg  [7:0]                block_cnt21;   // While21 counter counts21, THRE21 status is blocked21 (delayed21 one character21 cycle)
reg  [7:0]                block_value21; // One21 character21 length minus21 stop bit

// Transmitter21 Instance
wire serial_out21;

uart_transmitter21 transmitter21(clk21, wb_rst_i21, lcr21, tf_push21, wb_dat_i21, enable, serial_out21, tstate21, tf_count21, tx_reset21, lsr_mask21);

  // Synchronizing21 and sampling21 serial21 RX21 input
  uart_sync_flops21    i_uart_sync_flops21
  (
    .rst_i21           (wb_rst_i21),
    .clk_i21           (clk21),
    .stage1_rst_i21    (1'b0),
    .stage1_clk_en_i21 (1'b1),
    .async_dat_i21     (srx_pad_i21),
    .sync_dat_o21      (srx_pad21)
  );
  defparam i_uart_sync_flops21.width      = 1;
  defparam i_uart_sync_flops21.init_value21 = 1'b1;

// handle loopback21
wire serial_in21 = loopback21 ? serial_out21 : srx_pad21;
assign stx_pad_o21 = loopback21 ? 1'b1 : serial_out21;

// Receiver21 Instance
uart_receiver21 receiver21(clk21, wb_rst_i21, lcr21, rf_pop21, serial_in21, enable, 
	counter_t21, rf_count21, rf_data_out21, rf_error_bit21, rf_overrun21, rx_reset21, lsr_mask21, rstate, rf_push_pulse21);


// Asynchronous21 reading here21 because the outputs21 are sampled21 in uart_wb21.v file 
always @(dl21 or dlab21 or ier21 or iir21 or scratch21
			or lcr21 or lsr21 or msr21 or rf_data_out21 or wb_addr_i21 or wb_re_i21)   // asynchrounous21 reading
begin
	case (wb_addr_i21)
		`UART_REG_RB21   : wb_dat_o21 = dlab21 ? dl21[`UART_DL121] : rf_data_out21[10:3];
		`UART_REG_IE21	: wb_dat_o21 = dlab21 ? dl21[`UART_DL221] : ier21;
		`UART_REG_II21	: wb_dat_o21 = {4'b1100,iir21};
		`UART_REG_LC21	: wb_dat_o21 = lcr21;
		`UART_REG_LS21	: wb_dat_o21 = lsr21;
		`UART_REG_MS21	: wb_dat_o21 = msr21;
		`UART_REG_SR21	: wb_dat_o21 = scratch21;
		default:  wb_dat_o21 = 8'b0; // ??
	endcase // case(wb_addr_i21)
end // always @ (dl21 or dlab21 or ier21 or iir21 or scratch21...


// rf_pop21 signal21 handling21
always @(posedge clk21 or posedge wb_rst_i21)
begin
	if (wb_rst_i21)
		rf_pop21 <= #1 0; 
	else
	if (rf_pop21)	// restore21 the signal21 to 0 after one clock21 cycle
		rf_pop21 <= #1 0;
	else
	if (wb_re_i21 && wb_addr_i21 == `UART_REG_RB21 && !dlab21)
		rf_pop21 <= #1 1; // advance21 read pointer21
end

wire 	lsr_mask_condition21;
wire 	iir_read21;
wire  msr_read21;
wire	fifo_read21;
wire	fifo_write21;

assign lsr_mask_condition21 = (wb_re_i21 && wb_addr_i21 == `UART_REG_LS21 && !dlab21);
assign iir_read21 = (wb_re_i21 && wb_addr_i21 == `UART_REG_II21 && !dlab21);
assign msr_read21 = (wb_re_i21 && wb_addr_i21 == `UART_REG_MS21 && !dlab21);
assign fifo_read21 = (wb_re_i21 && wb_addr_i21 == `UART_REG_RB21 && !dlab21);
assign fifo_write21 = (wb_we_i21 && wb_addr_i21 == `UART_REG_TR21 && !dlab21);

// lsr_mask_d21 delayed21 signal21 handling21
always @(posedge clk21 or posedge wb_rst_i21)
begin
	if (wb_rst_i21)
		lsr_mask_d21 <= #1 0;
	else // reset bits in the Line21 Status Register
		lsr_mask_d21 <= #1 lsr_mask_condition21;
end

// lsr_mask21 is rise21 detected
assign lsr_mask21 = lsr_mask_condition21 && ~lsr_mask_d21;

// msi_reset21 signal21 handling21
always @(posedge clk21 or posedge wb_rst_i21)
begin
	if (wb_rst_i21)
		msi_reset21 <= #1 1;
	else
	if (msi_reset21)
		msi_reset21 <= #1 0;
	else
	if (msr_read21)
		msi_reset21 <= #1 1; // reset bits in Modem21 Status Register
end


//
//   WRITES21 AND21 RESETS21   //
//
// Line21 Control21 Register
always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21)
		lcr21 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i21 && wb_addr_i21==`UART_REG_LC21)
		lcr21 <= #1 wb_dat_i21;

// Interrupt21 Enable21 Register or UART_DL221
always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21)
	begin
		ier21 <= #1 4'b0000; // no interrupts21 after reset
		dl21[`UART_DL221] <= #1 8'b0;
	end
	else
	if (wb_we_i21 && wb_addr_i21==`UART_REG_IE21)
		if (dlab21)
		begin
			dl21[`UART_DL221] <= #1 wb_dat_i21;
		end
		else
			ier21 <= #1 wb_dat_i21[3:0]; // ier21 uses only 4 lsb


// FIFO Control21 Register and rx_reset21, tx_reset21 signals21
always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) begin
		fcr21 <= #1 2'b11; 
		rx_reset21 <= #1 0;
		tx_reset21 <= #1 0;
	end else
	if (wb_we_i21 && wb_addr_i21==`UART_REG_FC21) begin
		fcr21 <= #1 wb_dat_i21[7:6];
		rx_reset21 <= #1 wb_dat_i21[1];
		tx_reset21 <= #1 wb_dat_i21[2];
	end else begin
		rx_reset21 <= #1 0;
		tx_reset21 <= #1 0;
	end

// Modem21 Control21 Register
always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21)
		mcr21 <= #1 5'b0; 
	else
	if (wb_we_i21 && wb_addr_i21==`UART_REG_MC21)
			mcr21 <= #1 wb_dat_i21[4:0];

// Scratch21 register
// Line21 Control21 Register
always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21)
		scratch21 <= #1 0; // 8n1 setting
	else
	if (wb_we_i21 && wb_addr_i21==`UART_REG_SR21)
		scratch21 <= #1 wb_dat_i21;

// TX_FIFO21 or UART_DL121
always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21)
	begin
		dl21[`UART_DL121]  <= #1 8'b0;
		tf_push21   <= #1 1'b0;
		start_dlc21 <= #1 1'b0;
	end
	else
	if (wb_we_i21 && wb_addr_i21==`UART_REG_TR21)
		if (dlab21)
		begin
			dl21[`UART_DL121] <= #1 wb_dat_i21;
			start_dlc21 <= #1 1'b1; // enable DL21 counter
			tf_push21 <= #1 1'b0;
		end
		else
		begin
			tf_push21   <= #1 1'b1;
			start_dlc21 <= #1 1'b0;
		end // else: !if(dlab21)
	else
	begin
		start_dlc21 <= #1 1'b0;
		tf_push21   <= #1 1'b0;
	end // else: !if(dlab21)

// Receiver21 FIFO trigger level selection logic (asynchronous21 mux21)
always @(fcr21)
	case (fcr21[`UART_FC_TL21])
		2'b00 : trigger_level21 = 1;
		2'b01 : trigger_level21 = 4;
		2'b10 : trigger_level21 = 8;
		2'b11 : trigger_level21 = 14;
	endcase // case(fcr21[`UART_FC_TL21])
	
//
//  STATUS21 REGISTERS21  //
//

// Modem21 Status Register
reg [3:0] delayed_modem_signals21;
always @(posedge clk21 or posedge wb_rst_i21)
begin
	if (wb_rst_i21)
	  begin
  		msr21 <= #1 0;
	  	delayed_modem_signals21[3:0] <= #1 0;
	  end
	else begin
		msr21[`UART_MS_DDCD21:`UART_MS_DCTS21] <= #1 msi_reset21 ? 4'b0 :
			msr21[`UART_MS_DDCD21:`UART_MS_DCTS21] | ({dcd21, ri, dsr21, cts21} ^ delayed_modem_signals21[3:0]);
		msr21[`UART_MS_CDCD21:`UART_MS_CCTS21] <= #1 {dcd_c21, ri_c21, dsr_c21, cts_c21};
		delayed_modem_signals21[3:0] <= #1 {dcd21, ri, dsr21, cts21};
	end
end


// Line21 Status Register

// activation21 conditions21
assign lsr021 = (rf_count21==0 && rf_push_pulse21);  // data in receiver21 fifo available set condition
assign lsr121 = rf_overrun21;     // Receiver21 overrun21 error
assign lsr221 = rf_data_out21[1]; // parity21 error bit
assign lsr321 = rf_data_out21[0]; // framing21 error bit
assign lsr421 = rf_data_out21[2]; // break error in the character21
assign lsr521 = (tf_count21==5'b0 && thre_set_en21);  // transmitter21 fifo is empty21
assign lsr621 = (tf_count21==5'b0 && thre_set_en21 && (tstate21 == /*`S_IDLE21 */ 0)); // transmitter21 empty21
assign lsr721 = rf_error_bit21 | rf_overrun21;

// lsr21 bit021 (receiver21 data available)
reg 	 lsr0_d21;

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr0_d21 <= #1 0;
	else lsr0_d21 <= #1 lsr021;

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr0r21 <= #1 0;
	else lsr0r21 <= #1 (rf_count21==1 && rf_pop21 && !rf_push_pulse21 || rx_reset21) ? 0 : // deassert21 condition
					  lsr0r21 || (lsr021 && ~lsr0_d21); // set on rise21 of lsr021 and keep21 asserted21 until deasserted21 

// lsr21 bit 1 (receiver21 overrun21)
reg lsr1_d21; // delayed21

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr1_d21 <= #1 0;
	else lsr1_d21 <= #1 lsr121;

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr1r21 <= #1 0;
	else	lsr1r21 <= #1	lsr_mask21 ? 0 : lsr1r21 || (lsr121 && ~lsr1_d21); // set on rise21

// lsr21 bit 2 (parity21 error)
reg lsr2_d21; // delayed21

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr2_d21 <= #1 0;
	else lsr2_d21 <= #1 lsr221;

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr2r21 <= #1 0;
	else lsr2r21 <= #1 lsr_mask21 ? 0 : lsr2r21 || (lsr221 && ~lsr2_d21); // set on rise21

// lsr21 bit 3 (framing21 error)
reg lsr3_d21; // delayed21

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr3_d21 <= #1 0;
	else lsr3_d21 <= #1 lsr321;

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr3r21 <= #1 0;
	else lsr3r21 <= #1 lsr_mask21 ? 0 : lsr3r21 || (lsr321 && ~lsr3_d21); // set on rise21

// lsr21 bit 4 (break indicator21)
reg lsr4_d21; // delayed21

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr4_d21 <= #1 0;
	else lsr4_d21 <= #1 lsr421;

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr4r21 <= #1 0;
	else lsr4r21 <= #1 lsr_mask21 ? 0 : lsr4r21 || (lsr421 && ~lsr4_d21);

// lsr21 bit 5 (transmitter21 fifo is empty21)
reg lsr5_d21;

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr5_d21 <= #1 1;
	else lsr5_d21 <= #1 lsr521;

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr5r21 <= #1 1;
	else lsr5r21 <= #1 (fifo_write21) ? 0 :  lsr5r21 || (lsr521 && ~lsr5_d21);

// lsr21 bit 6 (transmitter21 empty21 indicator21)
reg lsr6_d21;

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr6_d21 <= #1 1;
	else lsr6_d21 <= #1 lsr621;

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr6r21 <= #1 1;
	else lsr6r21 <= #1 (fifo_write21) ? 0 : lsr6r21 || (lsr621 && ~lsr6_d21);

// lsr21 bit 7 (error in fifo)
reg lsr7_d21;

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr7_d21 <= #1 0;
	else lsr7_d21 <= #1 lsr721;

always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) lsr7r21 <= #1 0;
	else lsr7r21 <= #1 lsr_mask21 ? 0 : lsr7r21 || (lsr721 && ~lsr7_d21);

// Frequency21 divider21
always @(posedge clk21 or posedge wb_rst_i21) 
begin
	if (wb_rst_i21)
		dlc21 <= #1 0;
	else
		if (start_dlc21 | ~ (|dlc21))
  			dlc21 <= #1 dl21 - 1;               // preset21 counter
		else
			dlc21 <= #1 dlc21 - 1;              // decrement counter
end

// Enable21 signal21 generation21 logic
always @(posedge clk21 or posedge wb_rst_i21)
begin
	if (wb_rst_i21)
		enable <= #1 1'b0;
	else
		if (|dl21 & ~(|dlc21))     // dl21>0 & dlc21==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying21 THRE21 status for one character21 cycle after a character21 is written21 to an empty21 fifo.
always @(lcr21)
  case (lcr21[3:0])
    4'b0000                             : block_value21 =  95; // 6 bits
    4'b0100                             : block_value21 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value21 = 111; // 7 bits
    4'b1100                             : block_value21 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value21 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value21 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value21 = 159; // 10 bits
    4'b1111                             : block_value21 = 175; // 11 bits
  endcase // case(lcr21[3:0])

// Counting21 time of one character21 minus21 stop bit
always @(posedge clk21 or posedge wb_rst_i21)
begin
  if (wb_rst_i21)
    block_cnt21 <= #1 8'd0;
  else
  if(lsr5r21 & fifo_write21)  // THRE21 bit set & write to fifo occured21
    block_cnt21 <= #1 block_value21;
  else
  if (enable & block_cnt21 != 8'b0)  // only work21 on enable times
    block_cnt21 <= #1 block_cnt21 - 1;  // decrement break counter
end // always of break condition detection21

// Generating21 THRE21 status enable signal21
assign thre_set_en21 = ~(|block_cnt21);


//
//	INTERRUPT21 LOGIC21
//

assign rls_int21  = ier21[`UART_IE_RLS21] && (lsr21[`UART_LS_OE21] || lsr21[`UART_LS_PE21] || lsr21[`UART_LS_FE21] || lsr21[`UART_LS_BI21]);
assign rda_int21  = ier21[`UART_IE_RDA21] && (rf_count21 >= {1'b0,trigger_level21});
assign thre_int21 = ier21[`UART_IE_THRE21] && lsr21[`UART_LS_TFE21];
assign ms_int21   = ier21[`UART_IE_MS21] && (| msr21[3:0]);
assign ti_int21   = ier21[`UART_IE_RDA21] && (counter_t21 == 10'b0) && (|rf_count21);

reg 	 rls_int_d21;
reg 	 thre_int_d21;
reg 	 ms_int_d21;
reg 	 ti_int_d21;
reg 	 rda_int_d21;

// delay lines21
always  @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) rls_int_d21 <= #1 0;
	else rls_int_d21 <= #1 rls_int21;

always  @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) rda_int_d21 <= #1 0;
	else rda_int_d21 <= #1 rda_int21;

always  @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) thre_int_d21 <= #1 0;
	else thre_int_d21 <= #1 thre_int21;

always  @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) ms_int_d21 <= #1 0;
	else ms_int_d21 <= #1 ms_int21;

always  @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) ti_int_d21 <= #1 0;
	else ti_int_d21 <= #1 ti_int21;

// rise21 detection21 signals21

wire 	 rls_int_rise21;
wire 	 thre_int_rise21;
wire 	 ms_int_rise21;
wire 	 ti_int_rise21;
wire 	 rda_int_rise21;

assign rda_int_rise21    = rda_int21 & ~rda_int_d21;
assign rls_int_rise21 	  = rls_int21 & ~rls_int_d21;
assign thre_int_rise21   = thre_int21 & ~thre_int_d21;
assign ms_int_rise21 	  = ms_int21 & ~ms_int_d21;
assign ti_int_rise21 	  = ti_int21 & ~ti_int_d21;

// interrupt21 pending flags21
reg 	rls_int_pnd21;
reg	rda_int_pnd21;
reg 	thre_int_pnd21;
reg 	ms_int_pnd21;
reg 	ti_int_pnd21;

// interrupt21 pending flags21 assignments21
always  @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) rls_int_pnd21 <= #1 0; 
	else 
		rls_int_pnd21 <= #1 lsr_mask21 ? 0 :  						// reset condition
							rls_int_rise21 ? 1 :						// latch21 condition
							rls_int_pnd21 && ier21[`UART_IE_RLS21];	// default operation21: remove if masked21

always  @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) rda_int_pnd21 <= #1 0; 
	else 
		rda_int_pnd21 <= #1 ((rf_count21 == {1'b0,trigger_level21}) && fifo_read21) ? 0 :  	// reset condition
							rda_int_rise21 ? 1 :						// latch21 condition
							rda_int_pnd21 && ier21[`UART_IE_RDA21];	// default operation21: remove if masked21

always  @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) thre_int_pnd21 <= #1 0; 
	else 
		thre_int_pnd21 <= #1 fifo_write21 || (iir_read21 & ~iir21[`UART_II_IP21] & iir21[`UART_II_II21] == `UART_II_THRE21)? 0 : 
							thre_int_rise21 ? 1 :
							thre_int_pnd21 && ier21[`UART_IE_THRE21];

always  @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) ms_int_pnd21 <= #1 0; 
	else 
		ms_int_pnd21 <= #1 msr_read21 ? 0 : 
							ms_int_rise21 ? 1 :
							ms_int_pnd21 && ier21[`UART_IE_MS21];

always  @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) ti_int_pnd21 <= #1 0; 
	else 
		ti_int_pnd21 <= #1 fifo_read21 ? 0 : 
							ti_int_rise21 ? 1 :
							ti_int_pnd21 && ier21[`UART_IE_RDA21];
// end of pending flags21

// INT_O21 logic
always @(posedge clk21 or posedge wb_rst_i21)
begin
	if (wb_rst_i21)	
		int_o21 <= #1 1'b0;
	else
		int_o21 <= #1 
					rls_int_pnd21		?	~lsr_mask21					:
					rda_int_pnd21		? 1								:
					ti_int_pnd21		? ~fifo_read21					:
					thre_int_pnd21	? !(fifo_write21 & iir_read21) :
					ms_int_pnd21		? ~msr_read21						:
					0;	// if no interrupt21 are pending
end


// Interrupt21 Identification21 register
always @(posedge clk21 or posedge wb_rst_i21)
begin
	if (wb_rst_i21)
		iir21 <= #1 1;
	else
	if (rls_int_pnd21)  // interrupt21 is pending
	begin
		iir21[`UART_II_II21] <= #1 `UART_II_RLS21;	// set identification21 register to correct21 value
		iir21[`UART_II_IP21] <= #1 1'b0;		// and clear the IIR21 bit 0 (interrupt21 pending)
	end else // the sequence of conditions21 determines21 priority of interrupt21 identification21
	if (rda_int21)
	begin
		iir21[`UART_II_II21] <= #1 `UART_II_RDA21;
		iir21[`UART_II_IP21] <= #1 1'b0;
	end
	else if (ti_int_pnd21)
	begin
		iir21[`UART_II_II21] <= #1 `UART_II_TI21;
		iir21[`UART_II_IP21] <= #1 1'b0;
	end
	else if (thre_int_pnd21)
	begin
		iir21[`UART_II_II21] <= #1 `UART_II_THRE21;
		iir21[`UART_II_IP21] <= #1 1'b0;
	end
	else if (ms_int_pnd21)
	begin
		iir21[`UART_II_II21] <= #1 `UART_II_MS21;
		iir21[`UART_II_IP21] <= #1 1'b0;
	end else	// no interrupt21 is pending
	begin
		iir21[`UART_II_II21] <= #1 0;
		iir21[`UART_II_IP21] <= #1 1'b1;
	end
end

endmodule
