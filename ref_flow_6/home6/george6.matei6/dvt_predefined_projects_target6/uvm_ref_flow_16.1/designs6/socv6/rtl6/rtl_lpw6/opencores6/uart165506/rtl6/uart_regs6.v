//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs6.v                                                 ////
////                                                              ////
////                                                              ////
////  This6 file is part of the "UART6 16550 compatible6" project6    ////
////  http6://www6.opencores6.org6/cores6/uart165506/                   ////
////                                                              ////
////  Documentation6 related6 to this project6:                      ////
////  - http6://www6.opencores6.org6/cores6/uart165506/                 ////
////                                                              ////
////  Projects6 compatibility6:                                     ////
////  - WISHBONE6                                                  ////
////  RS2326 Protocol6                                              ////
////  16550D uart6 (mostly6 supported)                              ////
////                                                              ////
////  Overview6 (main6 Features6):                                   ////
////  Registers6 of the uart6 16550 core6                            ////
////                                                              ////
////  Known6 problems6 (limits6):                                    ////
////  Inserts6 1 wait state in all WISHBONE6 transfers6              ////
////                                                              ////
////  To6 Do6:                                                      ////
////  Nothing or verification6.                                    ////
////                                                              ////
////  Author6(s):                                                  ////
////      - gorban6@opencores6.org6                                  ////
////      - Jacob6 Gorban6                                          ////
////      - Igor6 Mohor6 (igorm6@opencores6.org6)                      ////
////                                                              ////
////  Created6:        2001/05/12                                  ////
////  Last6 Updated6:   (See log6 for the revision6 history6           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2000, 2001 Authors6                             ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS6 Revision6 History6
//
// $Log: not supported by cvs2svn6 $
// Revision6 1.41  2004/05/21 11:44:41  tadejm6
// Added6 synchronizer6 flops6 for RX6 input.
//
// Revision6 1.40  2003/06/11 16:37:47  gorban6
// This6 fixes6 errors6 in some6 cases6 when data is being read and put to the FIFO at the same time. Patch6 is submitted6 by Scott6 Furman6. Update is very6 recommended6.
//
// Revision6 1.39  2002/07/29 21:16:18  gorban6
// The uart_defines6.v file is included6 again6 in sources6.
//
// Revision6 1.38  2002/07/22 23:02:23  gorban6
// Bug6 Fixes6:
//  * Possible6 loss of sync and bad6 reception6 of stop bit on slow6 baud6 rates6 fixed6.
//   Problem6 reported6 by Kenny6.Tung6.
//  * Bad (or lack6 of ) loopback6 handling6 fixed6. Reported6 by Cherry6 Withers6.
//
// Improvements6:
//  * Made6 FIFO's as general6 inferrable6 memory where possible6.
//  So6 on FPGA6 they should be inferred6 as RAM6 (Distributed6 RAM6 on Xilinx6).
//  This6 saves6 about6 1/3 of the Slice6 count and reduces6 P&R and synthesis6 times.
//
//  * Added6 optional6 baudrate6 output (baud_o6).
//  This6 is identical6 to BAUDOUT6* signal6 on 16550 chip6.
//  It outputs6 16xbit_clock_rate - the divided6 clock6.
//  It's disabled by default. Define6 UART_HAS_BAUDRATE_OUTPUT6 to use.
//
// Revision6 1.37  2001/12/27 13:24:09  mohor6
// lsr6[7] was not showing6 overrun6 errors6.
//
// Revision6 1.36  2001/12/20 13:25:46  mohor6
// rx6 push6 changed to be only one cycle wide6.
//
// Revision6 1.35  2001/12/19 08:03:34  mohor6
// Warnings6 cleared6.
//
// Revision6 1.34  2001/12/19 07:33:54  mohor6
// Synplicity6 was having6 troubles6 with the comment6.
//
// Revision6 1.33  2001/12/17 10:14:43  mohor6
// Things6 related6 to msr6 register changed. After6 THRE6 IRQ6 occurs6, and one
// character6 is written6 to the transmit6 fifo, the detection6 of the THRE6 bit in the
// LSR6 is delayed6 for one character6 time.
//
// Revision6 1.32  2001/12/14 13:19:24  mohor6
// MSR6 register fixed6.
//
// Revision6 1.31  2001/12/14 10:06:58  mohor6
// After6 reset modem6 status register MSR6 should be reset.
//
// Revision6 1.30  2001/12/13 10:09:13  mohor6
// thre6 irq6 should be cleared6 only when being source6 of interrupt6.
//
// Revision6 1.29  2001/12/12 09:05:46  mohor6
// LSR6 status bit 0 was not cleared6 correctly in case of reseting6 the FCR6 (rx6 fifo).
//
// Revision6 1.28  2001/12/10 19:52:41  gorban6
// Scratch6 register added
//
// Revision6 1.27  2001/12/06 14:51:04  gorban6
// Bug6 in LSR6[0] is fixed6.
// All WISHBONE6 signals6 are now sampled6, so another6 wait-state is introduced6 on all transfers6.
//
// Revision6 1.26  2001/12/03 21:44:29  gorban6
// Updated6 specification6 documentation.
// Added6 full 32-bit data bus interface, now as default.
// Address is 5-bit wide6 in 32-bit data bus mode.
// Added6 wb_sel_i6 input to the core6. It's used in the 32-bit mode.
// Added6 debug6 interface with two6 32-bit read-only registers in 32-bit mode.
// Bits6 5 and 6 of LSR6 are now only cleared6 on TX6 FIFO write.
// My6 small test bench6 is modified to work6 with 32-bit mode.
//
// Revision6 1.25  2001/11/28 19:36:39  gorban6
// Fixed6: timeout and break didn6't pay6 attention6 to current data format6 when counting6 time
//
// Revision6 1.24  2001/11/26 21:38:54  gorban6
// Lots6 of fixes6:
// Break6 condition wasn6't handled6 correctly at all.
// LSR6 bits could lose6 their6 values.
// LSR6 value after reset was wrong6.
// Timing6 of THRE6 interrupt6 signal6 corrected6.
// LSR6 bit 0 timing6 corrected6.
//
// Revision6 1.23  2001/11/12 21:57:29  gorban6
// fixed6 more typo6 bugs6
//
// Revision6 1.22  2001/11/12 15:02:28  mohor6
// lsr1r6 error fixed6.
//
// Revision6 1.21  2001/11/12 14:57:27  mohor6
// ti_int_pnd6 error fixed6.
//
// Revision6 1.20  2001/11/12 14:50:27  mohor6
// ti_int_d6 error fixed6.
//
// Revision6 1.19  2001/11/10 12:43:21  gorban6
// Logic6 Synthesis6 bugs6 fixed6. Some6 other minor6 changes6
//
// Revision6 1.18  2001/11/08 14:54:23  mohor6
// Comments6 in Slovene6 language6 deleted6, few6 small fixes6 for better6 work6 of
// old6 tools6. IRQs6 need to be fix6.
//
// Revision6 1.17  2001/11/07 17:51:52  gorban6
// Heavily6 rewritten6 interrupt6 and LSR6 subsystems6.
// Many6 bugs6 hopefully6 squashed6.
//
// Revision6 1.16  2001/11/02 09:55:16  mohor6
// no message
//
// Revision6 1.15  2001/10/31 15:19:22  gorban6
// Fixes6 to break and timeout conditions6
//
// Revision6 1.14  2001/10/29 17:00:46  gorban6
// fixed6 parity6 sending6 and tx_fifo6 resets6 over- and underrun6
//
// Revision6 1.13  2001/10/20 09:58:40  gorban6
// Small6 synopsis6 fixes6
//
// Revision6 1.12  2001/10/19 16:21:40  gorban6
// Changes6 data_out6 to be synchronous6 again6 as it should have been.
//
// Revision6 1.11  2001/10/18 20:35:45  gorban6
// small fix6
//
// Revision6 1.10  2001/08/24 21:01:12  mohor6
// Things6 connected6 to parity6 changed.
// Clock6 devider6 changed.
//
// Revision6 1.9  2001/08/23 16:05:05  mohor6
// Stop bit bug6 fixed6.
// Parity6 bug6 fixed6.
// WISHBONE6 read cycle bug6 fixed6,
// OE6 indicator6 (Overrun6 Error) bug6 fixed6.
// PE6 indicator6 (Parity6 Error) bug6 fixed6.
// Register read bug6 fixed6.
//
// Revision6 1.10  2001/06/23 11:21:48  gorban6
// DL6 made6 16-bit long6. Fixed6 transmission6/reception6 bugs6.
//
// Revision6 1.9  2001/05/31 20:08:01  gorban6
// FIFO changes6 and other corrections6.
//
// Revision6 1.8  2001/05/29 20:05:04  gorban6
// Fixed6 some6 bugs6 and synthesis6 problems6.
//
// Revision6 1.7  2001/05/27 17:37:49  gorban6
// Fixed6 many6 bugs6. Updated6 spec6. Changed6 FIFO files structure6. See CHANGES6.txt6 file.
//
// Revision6 1.6  2001/05/21 19:12:02  gorban6
// Corrected6 some6 Linter6 messages6.
//
// Revision6 1.5  2001/05/17 18:34:18  gorban6
// First6 'stable' release. Should6 be sythesizable6 now. Also6 added new header.
//
// Revision6 1.0  2001-05-17 21:27:11+02  jacob6
// Initial6 revision6
//
//

// synopsys6 translate_off6
`include "timescale.v"
// synopsys6 translate_on6

`include "uart_defines6.v"

`define UART_DL16 7:0
`define UART_DL26 15:8

module uart_regs6 (clk6,
	wb_rst_i6, wb_addr_i6, wb_dat_i6, wb_dat_o6, wb_we_i6, wb_re_i6, 

// additional6 signals6
	modem_inputs6,
	stx_pad_o6, srx_pad_i6,

`ifdef DATA_BUS_WIDTH_86
`else
// debug6 interface signals6	enabled
ier6, iir6, fcr6, mcr6, lcr6, msr6, lsr6, rf_count6, tf_count6, tstate6, rstate,
`endif				
	rts_pad_o6, dtr_pad_o6, int_o6
`ifdef UART_HAS_BAUDRATE_OUTPUT6
	, baud_o6
`endif

	);

input 									clk6;
input 									wb_rst_i6;
input [`UART_ADDR_WIDTH6-1:0] 		wb_addr_i6;
input [7:0] 							wb_dat_i6;
output [7:0] 							wb_dat_o6;
input 									wb_we_i6;
input 									wb_re_i6;

output 									stx_pad_o6;
input 									srx_pad_i6;

input [3:0] 							modem_inputs6;
output 									rts_pad_o6;
output 									dtr_pad_o6;
output 									int_o6;
`ifdef UART_HAS_BAUDRATE_OUTPUT6
output	baud_o6;
`endif

`ifdef DATA_BUS_WIDTH_86
`else
// if 32-bit databus6 and debug6 interface are enabled
output [3:0]							ier6;
output [3:0]							iir6;
output [1:0]							fcr6;  /// bits 7 and 6 of fcr6. Other6 bits are ignored
output [4:0]							mcr6;
output [7:0]							lcr6;
output [7:0]							msr6;
output [7:0] 							lsr6;
output [`UART_FIFO_COUNTER_W6-1:0] 	rf_count6;
output [`UART_FIFO_COUNTER_W6-1:0] 	tf_count6;
output [2:0] 							tstate6;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs6;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT6
assign baud_o6 = enable; // baud_o6 is actually6 the enable signal6
`endif


wire 										stx_pad_o6;		// received6 from transmitter6 module
wire 										srx_pad_i6;
wire 										srx_pad6;

reg [7:0] 								wb_dat_o6;

wire [`UART_ADDR_WIDTH6-1:0] 		wb_addr_i6;
wire [7:0] 								wb_dat_i6;


reg [3:0] 								ier6;
reg [3:0] 								iir6;
reg [1:0] 								fcr6;  /// bits 7 and 6 of fcr6. Other6 bits are ignored
reg [4:0] 								mcr6;
reg [7:0] 								lcr6;
reg [7:0] 								msr6;
reg [15:0] 								dl6;  // 32-bit divisor6 latch6
reg [7:0] 								scratch6; // UART6 scratch6 register
reg 										start_dlc6; // activate6 dlc6 on writing to UART_DL16
reg 										lsr_mask_d6; // delay for lsr_mask6 condition
reg 										msi_reset6; // reset MSR6 4 lower6 bits indicator6
//reg 										threi_clear6; // THRE6 interrupt6 clear flag6
reg [15:0] 								dlc6;  // 32-bit divisor6 latch6 counter
reg 										int_o6;

reg [3:0] 								trigger_level6; // trigger level of the receiver6 FIFO
reg 										rx_reset6;
reg 										tx_reset6;

wire 										dlab6;			   // divisor6 latch6 access bit
wire 										cts_pad_i6, dsr_pad_i6, ri_pad_i6, dcd_pad_i6; // modem6 status bits
wire 										loopback6;		   // loopback6 bit (MCR6 bit 4)
wire 										cts6, dsr6, ri, dcd6;	   // effective6 signals6
wire                    cts_c6, dsr_c6, ri_c6, dcd_c6; // Complement6 effective6 signals6 (considering6 loopback6)
wire 										rts_pad_o6, dtr_pad_o6;		   // modem6 control6 outputs6

// LSR6 bits wires6 and regs
wire [7:0] 								lsr6;
wire 										lsr06, lsr16, lsr26, lsr36, lsr46, lsr56, lsr66, lsr76;
reg										lsr0r6, lsr1r6, lsr2r6, lsr3r6, lsr4r6, lsr5r6, lsr6r6, lsr7r6;
wire 										lsr_mask6; // lsr_mask6

//
// ASSINGS6
//

assign 									lsr6[7:0] = { lsr7r6, lsr6r6, lsr5r6, lsr4r6, lsr3r6, lsr2r6, lsr1r6, lsr0r6 };

assign 									{cts_pad_i6, dsr_pad_i6, ri_pad_i6, dcd_pad_i6} = modem_inputs6;
assign 									{cts6, dsr6, ri, dcd6} = ~{cts_pad_i6,dsr_pad_i6,ri_pad_i6,dcd_pad_i6};

assign                  {cts_c6, dsr_c6, ri_c6, dcd_c6} = loopback6 ? {mcr6[`UART_MC_RTS6],mcr6[`UART_MC_DTR6],mcr6[`UART_MC_OUT16],mcr6[`UART_MC_OUT26]}
                                                               : {cts_pad_i6,dsr_pad_i6,ri_pad_i6,dcd_pad_i6};

assign 									dlab6 = lcr6[`UART_LC_DL6];
assign 									loopback6 = mcr6[4];

// assign modem6 outputs6
assign 									rts_pad_o6 = mcr6[`UART_MC_RTS6];
assign 									dtr_pad_o6 = mcr6[`UART_MC_DTR6];

// Interrupt6 signals6
wire 										rls_int6;  // receiver6 line status interrupt6
wire 										rda_int6;  // receiver6 data available interrupt6
wire 										ti_int6;   // timeout indicator6 interrupt6
wire										thre_int6; // transmitter6 holding6 register empty6 interrupt6
wire 										ms_int6;   // modem6 status interrupt6

// FIFO signals6
reg 										tf_push6;
reg 										rf_pop6;
wire [`UART_FIFO_REC_WIDTH6-1:0] 	rf_data_out6;
wire 										rf_error_bit6; // an error (parity6 or framing6) is inside the fifo
wire [`UART_FIFO_COUNTER_W6-1:0] 	rf_count6;
wire [`UART_FIFO_COUNTER_W6-1:0] 	tf_count6;
wire [2:0] 								tstate6;
wire [3:0] 								rstate;
wire [9:0] 								counter_t6;

wire                      thre_set_en6; // THRE6 status is delayed6 one character6 time when a character6 is written6 to fifo.
reg  [7:0]                block_cnt6;   // While6 counter counts6, THRE6 status is blocked6 (delayed6 one character6 cycle)
reg  [7:0]                block_value6; // One6 character6 length minus6 stop bit

// Transmitter6 Instance
wire serial_out6;

uart_transmitter6 transmitter6(clk6, wb_rst_i6, lcr6, tf_push6, wb_dat_i6, enable, serial_out6, tstate6, tf_count6, tx_reset6, lsr_mask6);

  // Synchronizing6 and sampling6 serial6 RX6 input
  uart_sync_flops6    i_uart_sync_flops6
  (
    .rst_i6           (wb_rst_i6),
    .clk_i6           (clk6),
    .stage1_rst_i6    (1'b0),
    .stage1_clk_en_i6 (1'b1),
    .async_dat_i6     (srx_pad_i6),
    .sync_dat_o6      (srx_pad6)
  );
  defparam i_uart_sync_flops6.width      = 1;
  defparam i_uart_sync_flops6.init_value6 = 1'b1;

// handle loopback6
wire serial_in6 = loopback6 ? serial_out6 : srx_pad6;
assign stx_pad_o6 = loopback6 ? 1'b1 : serial_out6;

// Receiver6 Instance
uart_receiver6 receiver6(clk6, wb_rst_i6, lcr6, rf_pop6, serial_in6, enable, 
	counter_t6, rf_count6, rf_data_out6, rf_error_bit6, rf_overrun6, rx_reset6, lsr_mask6, rstate, rf_push_pulse6);


// Asynchronous6 reading here6 because the outputs6 are sampled6 in uart_wb6.v file 
always @(dl6 or dlab6 or ier6 or iir6 or scratch6
			or lcr6 or lsr6 or msr6 or rf_data_out6 or wb_addr_i6 or wb_re_i6)   // asynchrounous6 reading
begin
	case (wb_addr_i6)
		`UART_REG_RB6   : wb_dat_o6 = dlab6 ? dl6[`UART_DL16] : rf_data_out6[10:3];
		`UART_REG_IE6	: wb_dat_o6 = dlab6 ? dl6[`UART_DL26] : ier6;
		`UART_REG_II6	: wb_dat_o6 = {4'b1100,iir6};
		`UART_REG_LC6	: wb_dat_o6 = lcr6;
		`UART_REG_LS6	: wb_dat_o6 = lsr6;
		`UART_REG_MS6	: wb_dat_o6 = msr6;
		`UART_REG_SR6	: wb_dat_o6 = scratch6;
		default:  wb_dat_o6 = 8'b0; // ??
	endcase // case(wb_addr_i6)
end // always @ (dl6 or dlab6 or ier6 or iir6 or scratch6...


// rf_pop6 signal6 handling6
always @(posedge clk6 or posedge wb_rst_i6)
begin
	if (wb_rst_i6)
		rf_pop6 <= #1 0; 
	else
	if (rf_pop6)	// restore6 the signal6 to 0 after one clock6 cycle
		rf_pop6 <= #1 0;
	else
	if (wb_re_i6 && wb_addr_i6 == `UART_REG_RB6 && !dlab6)
		rf_pop6 <= #1 1; // advance6 read pointer6
end

wire 	lsr_mask_condition6;
wire 	iir_read6;
wire  msr_read6;
wire	fifo_read6;
wire	fifo_write6;

assign lsr_mask_condition6 = (wb_re_i6 && wb_addr_i6 == `UART_REG_LS6 && !dlab6);
assign iir_read6 = (wb_re_i6 && wb_addr_i6 == `UART_REG_II6 && !dlab6);
assign msr_read6 = (wb_re_i6 && wb_addr_i6 == `UART_REG_MS6 && !dlab6);
assign fifo_read6 = (wb_re_i6 && wb_addr_i6 == `UART_REG_RB6 && !dlab6);
assign fifo_write6 = (wb_we_i6 && wb_addr_i6 == `UART_REG_TR6 && !dlab6);

// lsr_mask_d6 delayed6 signal6 handling6
always @(posedge clk6 or posedge wb_rst_i6)
begin
	if (wb_rst_i6)
		lsr_mask_d6 <= #1 0;
	else // reset bits in the Line6 Status Register
		lsr_mask_d6 <= #1 lsr_mask_condition6;
end

// lsr_mask6 is rise6 detected
assign lsr_mask6 = lsr_mask_condition6 && ~lsr_mask_d6;

// msi_reset6 signal6 handling6
always @(posedge clk6 or posedge wb_rst_i6)
begin
	if (wb_rst_i6)
		msi_reset6 <= #1 1;
	else
	if (msi_reset6)
		msi_reset6 <= #1 0;
	else
	if (msr_read6)
		msi_reset6 <= #1 1; // reset bits in Modem6 Status Register
end


//
//   WRITES6 AND6 RESETS6   //
//
// Line6 Control6 Register
always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6)
		lcr6 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i6 && wb_addr_i6==`UART_REG_LC6)
		lcr6 <= #1 wb_dat_i6;

// Interrupt6 Enable6 Register or UART_DL26
always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6)
	begin
		ier6 <= #1 4'b0000; // no interrupts6 after reset
		dl6[`UART_DL26] <= #1 8'b0;
	end
	else
	if (wb_we_i6 && wb_addr_i6==`UART_REG_IE6)
		if (dlab6)
		begin
			dl6[`UART_DL26] <= #1 wb_dat_i6;
		end
		else
			ier6 <= #1 wb_dat_i6[3:0]; // ier6 uses only 4 lsb


// FIFO Control6 Register and rx_reset6, tx_reset6 signals6
always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) begin
		fcr6 <= #1 2'b11; 
		rx_reset6 <= #1 0;
		tx_reset6 <= #1 0;
	end else
	if (wb_we_i6 && wb_addr_i6==`UART_REG_FC6) begin
		fcr6 <= #1 wb_dat_i6[7:6];
		rx_reset6 <= #1 wb_dat_i6[1];
		tx_reset6 <= #1 wb_dat_i6[2];
	end else begin
		rx_reset6 <= #1 0;
		tx_reset6 <= #1 0;
	end

// Modem6 Control6 Register
always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6)
		mcr6 <= #1 5'b0; 
	else
	if (wb_we_i6 && wb_addr_i6==`UART_REG_MC6)
			mcr6 <= #1 wb_dat_i6[4:0];

// Scratch6 register
// Line6 Control6 Register
always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6)
		scratch6 <= #1 0; // 8n1 setting
	else
	if (wb_we_i6 && wb_addr_i6==`UART_REG_SR6)
		scratch6 <= #1 wb_dat_i6;

// TX_FIFO6 or UART_DL16
always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6)
	begin
		dl6[`UART_DL16]  <= #1 8'b0;
		tf_push6   <= #1 1'b0;
		start_dlc6 <= #1 1'b0;
	end
	else
	if (wb_we_i6 && wb_addr_i6==`UART_REG_TR6)
		if (dlab6)
		begin
			dl6[`UART_DL16] <= #1 wb_dat_i6;
			start_dlc6 <= #1 1'b1; // enable DL6 counter
			tf_push6 <= #1 1'b0;
		end
		else
		begin
			tf_push6   <= #1 1'b1;
			start_dlc6 <= #1 1'b0;
		end // else: !if(dlab6)
	else
	begin
		start_dlc6 <= #1 1'b0;
		tf_push6   <= #1 1'b0;
	end // else: !if(dlab6)

// Receiver6 FIFO trigger level selection logic (asynchronous6 mux6)
always @(fcr6)
	case (fcr6[`UART_FC_TL6])
		2'b00 : trigger_level6 = 1;
		2'b01 : trigger_level6 = 4;
		2'b10 : trigger_level6 = 8;
		2'b11 : trigger_level6 = 14;
	endcase // case(fcr6[`UART_FC_TL6])
	
//
//  STATUS6 REGISTERS6  //
//

// Modem6 Status Register
reg [3:0] delayed_modem_signals6;
always @(posedge clk6 or posedge wb_rst_i6)
begin
	if (wb_rst_i6)
	  begin
  		msr6 <= #1 0;
	  	delayed_modem_signals6[3:0] <= #1 0;
	  end
	else begin
		msr6[`UART_MS_DDCD6:`UART_MS_DCTS6] <= #1 msi_reset6 ? 4'b0 :
			msr6[`UART_MS_DDCD6:`UART_MS_DCTS6] | ({dcd6, ri, dsr6, cts6} ^ delayed_modem_signals6[3:0]);
		msr6[`UART_MS_CDCD6:`UART_MS_CCTS6] <= #1 {dcd_c6, ri_c6, dsr_c6, cts_c6};
		delayed_modem_signals6[3:0] <= #1 {dcd6, ri, dsr6, cts6};
	end
end


// Line6 Status Register

// activation6 conditions6
assign lsr06 = (rf_count6==0 && rf_push_pulse6);  // data in receiver6 fifo available set condition
assign lsr16 = rf_overrun6;     // Receiver6 overrun6 error
assign lsr26 = rf_data_out6[1]; // parity6 error bit
assign lsr36 = rf_data_out6[0]; // framing6 error bit
assign lsr46 = rf_data_out6[2]; // break error in the character6
assign lsr56 = (tf_count6==5'b0 && thre_set_en6);  // transmitter6 fifo is empty6
assign lsr66 = (tf_count6==5'b0 && thre_set_en6 && (tstate6 == /*`S_IDLE6 */ 0)); // transmitter6 empty6
assign lsr76 = rf_error_bit6 | rf_overrun6;

// lsr6 bit06 (receiver6 data available)
reg 	 lsr0_d6;

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr0_d6 <= #1 0;
	else lsr0_d6 <= #1 lsr06;

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr0r6 <= #1 0;
	else lsr0r6 <= #1 (rf_count6==1 && rf_pop6 && !rf_push_pulse6 || rx_reset6) ? 0 : // deassert6 condition
					  lsr0r6 || (lsr06 && ~lsr0_d6); // set on rise6 of lsr06 and keep6 asserted6 until deasserted6 

// lsr6 bit 1 (receiver6 overrun6)
reg lsr1_d6; // delayed6

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr1_d6 <= #1 0;
	else lsr1_d6 <= #1 lsr16;

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr1r6 <= #1 0;
	else	lsr1r6 <= #1	lsr_mask6 ? 0 : lsr1r6 || (lsr16 && ~lsr1_d6); // set on rise6

// lsr6 bit 2 (parity6 error)
reg lsr2_d6; // delayed6

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr2_d6 <= #1 0;
	else lsr2_d6 <= #1 lsr26;

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr2r6 <= #1 0;
	else lsr2r6 <= #1 lsr_mask6 ? 0 : lsr2r6 || (lsr26 && ~lsr2_d6); // set on rise6

// lsr6 bit 3 (framing6 error)
reg lsr3_d6; // delayed6

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr3_d6 <= #1 0;
	else lsr3_d6 <= #1 lsr36;

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr3r6 <= #1 0;
	else lsr3r6 <= #1 lsr_mask6 ? 0 : lsr3r6 || (lsr36 && ~lsr3_d6); // set on rise6

// lsr6 bit 4 (break indicator6)
reg lsr4_d6; // delayed6

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr4_d6 <= #1 0;
	else lsr4_d6 <= #1 lsr46;

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr4r6 <= #1 0;
	else lsr4r6 <= #1 lsr_mask6 ? 0 : lsr4r6 || (lsr46 && ~lsr4_d6);

// lsr6 bit 5 (transmitter6 fifo is empty6)
reg lsr5_d6;

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr5_d6 <= #1 1;
	else lsr5_d6 <= #1 lsr56;

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr5r6 <= #1 1;
	else lsr5r6 <= #1 (fifo_write6) ? 0 :  lsr5r6 || (lsr56 && ~lsr5_d6);

// lsr6 bit 6 (transmitter6 empty6 indicator6)
reg lsr6_d6;

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr6_d6 <= #1 1;
	else lsr6_d6 <= #1 lsr66;

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr6r6 <= #1 1;
	else lsr6r6 <= #1 (fifo_write6) ? 0 : lsr6r6 || (lsr66 && ~lsr6_d6);

// lsr6 bit 7 (error in fifo)
reg lsr7_d6;

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr7_d6 <= #1 0;
	else lsr7_d6 <= #1 lsr76;

always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) lsr7r6 <= #1 0;
	else lsr7r6 <= #1 lsr_mask6 ? 0 : lsr7r6 || (lsr76 && ~lsr7_d6);

// Frequency6 divider6
always @(posedge clk6 or posedge wb_rst_i6) 
begin
	if (wb_rst_i6)
		dlc6 <= #1 0;
	else
		if (start_dlc6 | ~ (|dlc6))
  			dlc6 <= #1 dl6 - 1;               // preset6 counter
		else
			dlc6 <= #1 dlc6 - 1;              // decrement counter
end

// Enable6 signal6 generation6 logic
always @(posedge clk6 or posedge wb_rst_i6)
begin
	if (wb_rst_i6)
		enable <= #1 1'b0;
	else
		if (|dl6 & ~(|dlc6))     // dl6>0 & dlc6==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying6 THRE6 status for one character6 cycle after a character6 is written6 to an empty6 fifo.
always @(lcr6)
  case (lcr6[3:0])
    4'b0000                             : block_value6 =  95; // 6 bits
    4'b0100                             : block_value6 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value6 = 111; // 7 bits
    4'b1100                             : block_value6 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value6 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value6 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value6 = 159; // 10 bits
    4'b1111                             : block_value6 = 175; // 11 bits
  endcase // case(lcr6[3:0])

// Counting6 time of one character6 minus6 stop bit
always @(posedge clk6 or posedge wb_rst_i6)
begin
  if (wb_rst_i6)
    block_cnt6 <= #1 8'd0;
  else
  if(lsr5r6 & fifo_write6)  // THRE6 bit set & write to fifo occured6
    block_cnt6 <= #1 block_value6;
  else
  if (enable & block_cnt6 != 8'b0)  // only work6 on enable times
    block_cnt6 <= #1 block_cnt6 - 1;  // decrement break counter
end // always of break condition detection6

// Generating6 THRE6 status enable signal6
assign thre_set_en6 = ~(|block_cnt6);


//
//	INTERRUPT6 LOGIC6
//

assign rls_int6  = ier6[`UART_IE_RLS6] && (lsr6[`UART_LS_OE6] || lsr6[`UART_LS_PE6] || lsr6[`UART_LS_FE6] || lsr6[`UART_LS_BI6]);
assign rda_int6  = ier6[`UART_IE_RDA6] && (rf_count6 >= {1'b0,trigger_level6});
assign thre_int6 = ier6[`UART_IE_THRE6] && lsr6[`UART_LS_TFE6];
assign ms_int6   = ier6[`UART_IE_MS6] && (| msr6[3:0]);
assign ti_int6   = ier6[`UART_IE_RDA6] && (counter_t6 == 10'b0) && (|rf_count6);

reg 	 rls_int_d6;
reg 	 thre_int_d6;
reg 	 ms_int_d6;
reg 	 ti_int_d6;
reg 	 rda_int_d6;

// delay lines6
always  @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) rls_int_d6 <= #1 0;
	else rls_int_d6 <= #1 rls_int6;

always  @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) rda_int_d6 <= #1 0;
	else rda_int_d6 <= #1 rda_int6;

always  @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) thre_int_d6 <= #1 0;
	else thre_int_d6 <= #1 thre_int6;

always  @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) ms_int_d6 <= #1 0;
	else ms_int_d6 <= #1 ms_int6;

always  @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) ti_int_d6 <= #1 0;
	else ti_int_d6 <= #1 ti_int6;

// rise6 detection6 signals6

wire 	 rls_int_rise6;
wire 	 thre_int_rise6;
wire 	 ms_int_rise6;
wire 	 ti_int_rise6;
wire 	 rda_int_rise6;

assign rda_int_rise6    = rda_int6 & ~rda_int_d6;
assign rls_int_rise6 	  = rls_int6 & ~rls_int_d6;
assign thre_int_rise6   = thre_int6 & ~thre_int_d6;
assign ms_int_rise6 	  = ms_int6 & ~ms_int_d6;
assign ti_int_rise6 	  = ti_int6 & ~ti_int_d6;

// interrupt6 pending flags6
reg 	rls_int_pnd6;
reg	rda_int_pnd6;
reg 	thre_int_pnd6;
reg 	ms_int_pnd6;
reg 	ti_int_pnd6;

// interrupt6 pending flags6 assignments6
always  @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) rls_int_pnd6 <= #1 0; 
	else 
		rls_int_pnd6 <= #1 lsr_mask6 ? 0 :  						// reset condition
							rls_int_rise6 ? 1 :						// latch6 condition
							rls_int_pnd6 && ier6[`UART_IE_RLS6];	// default operation6: remove if masked6

always  @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) rda_int_pnd6 <= #1 0; 
	else 
		rda_int_pnd6 <= #1 ((rf_count6 == {1'b0,trigger_level6}) && fifo_read6) ? 0 :  	// reset condition
							rda_int_rise6 ? 1 :						// latch6 condition
							rda_int_pnd6 && ier6[`UART_IE_RDA6];	// default operation6: remove if masked6

always  @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) thre_int_pnd6 <= #1 0; 
	else 
		thre_int_pnd6 <= #1 fifo_write6 || (iir_read6 & ~iir6[`UART_II_IP6] & iir6[`UART_II_II6] == `UART_II_THRE6)? 0 : 
							thre_int_rise6 ? 1 :
							thre_int_pnd6 && ier6[`UART_IE_THRE6];

always  @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) ms_int_pnd6 <= #1 0; 
	else 
		ms_int_pnd6 <= #1 msr_read6 ? 0 : 
							ms_int_rise6 ? 1 :
							ms_int_pnd6 && ier6[`UART_IE_MS6];

always  @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) ti_int_pnd6 <= #1 0; 
	else 
		ti_int_pnd6 <= #1 fifo_read6 ? 0 : 
							ti_int_rise6 ? 1 :
							ti_int_pnd6 && ier6[`UART_IE_RDA6];
// end of pending flags6

// INT_O6 logic
always @(posedge clk6 or posedge wb_rst_i6)
begin
	if (wb_rst_i6)	
		int_o6 <= #1 1'b0;
	else
		int_o6 <= #1 
					rls_int_pnd6		?	~lsr_mask6					:
					rda_int_pnd6		? 1								:
					ti_int_pnd6		? ~fifo_read6					:
					thre_int_pnd6	? !(fifo_write6 & iir_read6) :
					ms_int_pnd6		? ~msr_read6						:
					0;	// if no interrupt6 are pending
end


// Interrupt6 Identification6 register
always @(posedge clk6 or posedge wb_rst_i6)
begin
	if (wb_rst_i6)
		iir6 <= #1 1;
	else
	if (rls_int_pnd6)  // interrupt6 is pending
	begin
		iir6[`UART_II_II6] <= #1 `UART_II_RLS6;	// set identification6 register to correct6 value
		iir6[`UART_II_IP6] <= #1 1'b0;		// and clear the IIR6 bit 0 (interrupt6 pending)
	end else // the sequence of conditions6 determines6 priority of interrupt6 identification6
	if (rda_int6)
	begin
		iir6[`UART_II_II6] <= #1 `UART_II_RDA6;
		iir6[`UART_II_IP6] <= #1 1'b0;
	end
	else if (ti_int_pnd6)
	begin
		iir6[`UART_II_II6] <= #1 `UART_II_TI6;
		iir6[`UART_II_IP6] <= #1 1'b0;
	end
	else if (thre_int_pnd6)
	begin
		iir6[`UART_II_II6] <= #1 `UART_II_THRE6;
		iir6[`UART_II_IP6] <= #1 1'b0;
	end
	else if (ms_int_pnd6)
	begin
		iir6[`UART_II_II6] <= #1 `UART_II_MS6;
		iir6[`UART_II_IP6] <= #1 1'b0;
	end else	// no interrupt6 is pending
	begin
		iir6[`UART_II_II6] <= #1 0;
		iir6[`UART_II_IP6] <= #1 1'b1;
	end
end

endmodule
