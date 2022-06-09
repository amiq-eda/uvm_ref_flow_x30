//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs7.v                                                 ////
////                                                              ////
////                                                              ////
////  This7 file is part of the "UART7 16550 compatible7" project7    ////
////  http7://www7.opencores7.org7/cores7/uart165507/                   ////
////                                                              ////
////  Documentation7 related7 to this project7:                      ////
////  - http7://www7.opencores7.org7/cores7/uart165507/                 ////
////                                                              ////
////  Projects7 compatibility7:                                     ////
////  - WISHBONE7                                                  ////
////  RS2327 Protocol7                                              ////
////  16550D uart7 (mostly7 supported)                              ////
////                                                              ////
////  Overview7 (main7 Features7):                                   ////
////  Registers7 of the uart7 16550 core7                            ////
////                                                              ////
////  Known7 problems7 (limits7):                                    ////
////  Inserts7 1 wait state in all WISHBONE7 transfers7              ////
////                                                              ////
////  To7 Do7:                                                      ////
////  Nothing or verification7.                                    ////
////                                                              ////
////  Author7(s):                                                  ////
////      - gorban7@opencores7.org7                                  ////
////      - Jacob7 Gorban7                                          ////
////      - Igor7 Mohor7 (igorm7@opencores7.org7)                      ////
////                                                              ////
////  Created7:        2001/05/12                                  ////
////  Last7 Updated7:   (See log7 for the revision7 history7           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2000, 2001 Authors7                             ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS7 Revision7 History7
//
// $Log: not supported by cvs2svn7 $
// Revision7 1.41  2004/05/21 11:44:41  tadejm7
// Added7 synchronizer7 flops7 for RX7 input.
//
// Revision7 1.40  2003/06/11 16:37:47  gorban7
// This7 fixes7 errors7 in some7 cases7 when data is being read and put to the FIFO at the same time. Patch7 is submitted7 by Scott7 Furman7. Update is very7 recommended7.
//
// Revision7 1.39  2002/07/29 21:16:18  gorban7
// The uart_defines7.v file is included7 again7 in sources7.
//
// Revision7 1.38  2002/07/22 23:02:23  gorban7
// Bug7 Fixes7:
//  * Possible7 loss of sync and bad7 reception7 of stop bit on slow7 baud7 rates7 fixed7.
//   Problem7 reported7 by Kenny7.Tung7.
//  * Bad (or lack7 of ) loopback7 handling7 fixed7. Reported7 by Cherry7 Withers7.
//
// Improvements7:
//  * Made7 FIFO's as general7 inferrable7 memory where possible7.
//  So7 on FPGA7 they should be inferred7 as RAM7 (Distributed7 RAM7 on Xilinx7).
//  This7 saves7 about7 1/3 of the Slice7 count and reduces7 P&R and synthesis7 times.
//
//  * Added7 optional7 baudrate7 output (baud_o7).
//  This7 is identical7 to BAUDOUT7* signal7 on 16550 chip7.
//  It outputs7 16xbit_clock_rate - the divided7 clock7.
//  It's disabled by default. Define7 UART_HAS_BAUDRATE_OUTPUT7 to use.
//
// Revision7 1.37  2001/12/27 13:24:09  mohor7
// lsr7[7] was not showing7 overrun7 errors7.
//
// Revision7 1.36  2001/12/20 13:25:46  mohor7
// rx7 push7 changed to be only one cycle wide7.
//
// Revision7 1.35  2001/12/19 08:03:34  mohor7
// Warnings7 cleared7.
//
// Revision7 1.34  2001/12/19 07:33:54  mohor7
// Synplicity7 was having7 troubles7 with the comment7.
//
// Revision7 1.33  2001/12/17 10:14:43  mohor7
// Things7 related7 to msr7 register changed. After7 THRE7 IRQ7 occurs7, and one
// character7 is written7 to the transmit7 fifo, the detection7 of the THRE7 bit in the
// LSR7 is delayed7 for one character7 time.
//
// Revision7 1.32  2001/12/14 13:19:24  mohor7
// MSR7 register fixed7.
//
// Revision7 1.31  2001/12/14 10:06:58  mohor7
// After7 reset modem7 status register MSR7 should be reset.
//
// Revision7 1.30  2001/12/13 10:09:13  mohor7
// thre7 irq7 should be cleared7 only when being source7 of interrupt7.
//
// Revision7 1.29  2001/12/12 09:05:46  mohor7
// LSR7 status bit 0 was not cleared7 correctly in case of reseting7 the FCR7 (rx7 fifo).
//
// Revision7 1.28  2001/12/10 19:52:41  gorban7
// Scratch7 register added
//
// Revision7 1.27  2001/12/06 14:51:04  gorban7
// Bug7 in LSR7[0] is fixed7.
// All WISHBONE7 signals7 are now sampled7, so another7 wait-state is introduced7 on all transfers7.
//
// Revision7 1.26  2001/12/03 21:44:29  gorban7
// Updated7 specification7 documentation.
// Added7 full 32-bit data bus interface, now as default.
// Address is 5-bit wide7 in 32-bit data bus mode.
// Added7 wb_sel_i7 input to the core7. It's used in the 32-bit mode.
// Added7 debug7 interface with two7 32-bit read-only registers in 32-bit mode.
// Bits7 5 and 6 of LSR7 are now only cleared7 on TX7 FIFO write.
// My7 small test bench7 is modified to work7 with 32-bit mode.
//
// Revision7 1.25  2001/11/28 19:36:39  gorban7
// Fixed7: timeout and break didn7't pay7 attention7 to current data format7 when counting7 time
//
// Revision7 1.24  2001/11/26 21:38:54  gorban7
// Lots7 of fixes7:
// Break7 condition wasn7't handled7 correctly at all.
// LSR7 bits could lose7 their7 values.
// LSR7 value after reset was wrong7.
// Timing7 of THRE7 interrupt7 signal7 corrected7.
// LSR7 bit 0 timing7 corrected7.
//
// Revision7 1.23  2001/11/12 21:57:29  gorban7
// fixed7 more typo7 bugs7
//
// Revision7 1.22  2001/11/12 15:02:28  mohor7
// lsr1r7 error fixed7.
//
// Revision7 1.21  2001/11/12 14:57:27  mohor7
// ti_int_pnd7 error fixed7.
//
// Revision7 1.20  2001/11/12 14:50:27  mohor7
// ti_int_d7 error fixed7.
//
// Revision7 1.19  2001/11/10 12:43:21  gorban7
// Logic7 Synthesis7 bugs7 fixed7. Some7 other minor7 changes7
//
// Revision7 1.18  2001/11/08 14:54:23  mohor7
// Comments7 in Slovene7 language7 deleted7, few7 small fixes7 for better7 work7 of
// old7 tools7. IRQs7 need to be fix7.
//
// Revision7 1.17  2001/11/07 17:51:52  gorban7
// Heavily7 rewritten7 interrupt7 and LSR7 subsystems7.
// Many7 bugs7 hopefully7 squashed7.
//
// Revision7 1.16  2001/11/02 09:55:16  mohor7
// no message
//
// Revision7 1.15  2001/10/31 15:19:22  gorban7
// Fixes7 to break and timeout conditions7
//
// Revision7 1.14  2001/10/29 17:00:46  gorban7
// fixed7 parity7 sending7 and tx_fifo7 resets7 over- and underrun7
//
// Revision7 1.13  2001/10/20 09:58:40  gorban7
// Small7 synopsis7 fixes7
//
// Revision7 1.12  2001/10/19 16:21:40  gorban7
// Changes7 data_out7 to be synchronous7 again7 as it should have been.
//
// Revision7 1.11  2001/10/18 20:35:45  gorban7
// small fix7
//
// Revision7 1.10  2001/08/24 21:01:12  mohor7
// Things7 connected7 to parity7 changed.
// Clock7 devider7 changed.
//
// Revision7 1.9  2001/08/23 16:05:05  mohor7
// Stop bit bug7 fixed7.
// Parity7 bug7 fixed7.
// WISHBONE7 read cycle bug7 fixed7,
// OE7 indicator7 (Overrun7 Error) bug7 fixed7.
// PE7 indicator7 (Parity7 Error) bug7 fixed7.
// Register read bug7 fixed7.
//
// Revision7 1.10  2001/06/23 11:21:48  gorban7
// DL7 made7 16-bit long7. Fixed7 transmission7/reception7 bugs7.
//
// Revision7 1.9  2001/05/31 20:08:01  gorban7
// FIFO changes7 and other corrections7.
//
// Revision7 1.8  2001/05/29 20:05:04  gorban7
// Fixed7 some7 bugs7 and synthesis7 problems7.
//
// Revision7 1.7  2001/05/27 17:37:49  gorban7
// Fixed7 many7 bugs7. Updated7 spec7. Changed7 FIFO files structure7. See CHANGES7.txt7 file.
//
// Revision7 1.6  2001/05/21 19:12:02  gorban7
// Corrected7 some7 Linter7 messages7.
//
// Revision7 1.5  2001/05/17 18:34:18  gorban7
// First7 'stable' release. Should7 be sythesizable7 now. Also7 added new header.
//
// Revision7 1.0  2001-05-17 21:27:11+02  jacob7
// Initial7 revision7
//
//

// synopsys7 translate_off7
`include "timescale.v"
// synopsys7 translate_on7

`include "uart_defines7.v"

`define UART_DL17 7:0
`define UART_DL27 15:8

module uart_regs7 (clk7,
	wb_rst_i7, wb_addr_i7, wb_dat_i7, wb_dat_o7, wb_we_i7, wb_re_i7, 

// additional7 signals7
	modem_inputs7,
	stx_pad_o7, srx_pad_i7,

`ifdef DATA_BUS_WIDTH_87
`else
// debug7 interface signals7	enabled
ier7, iir7, fcr7, mcr7, lcr7, msr7, lsr7, rf_count7, tf_count7, tstate7, rstate,
`endif				
	rts_pad_o7, dtr_pad_o7, int_o7
`ifdef UART_HAS_BAUDRATE_OUTPUT7
	, baud_o7
`endif

	);

input 									clk7;
input 									wb_rst_i7;
input [`UART_ADDR_WIDTH7-1:0] 		wb_addr_i7;
input [7:0] 							wb_dat_i7;
output [7:0] 							wb_dat_o7;
input 									wb_we_i7;
input 									wb_re_i7;

output 									stx_pad_o7;
input 									srx_pad_i7;

input [3:0] 							modem_inputs7;
output 									rts_pad_o7;
output 									dtr_pad_o7;
output 									int_o7;
`ifdef UART_HAS_BAUDRATE_OUTPUT7
output	baud_o7;
`endif

`ifdef DATA_BUS_WIDTH_87
`else
// if 32-bit databus7 and debug7 interface are enabled
output [3:0]							ier7;
output [3:0]							iir7;
output [1:0]							fcr7;  /// bits 7 and 6 of fcr7. Other7 bits are ignored
output [4:0]							mcr7;
output [7:0]							lcr7;
output [7:0]							msr7;
output [7:0] 							lsr7;
output [`UART_FIFO_COUNTER_W7-1:0] 	rf_count7;
output [`UART_FIFO_COUNTER_W7-1:0] 	tf_count7;
output [2:0] 							tstate7;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs7;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT7
assign baud_o7 = enable; // baud_o7 is actually7 the enable signal7
`endif


wire 										stx_pad_o7;		// received7 from transmitter7 module
wire 										srx_pad_i7;
wire 										srx_pad7;

reg [7:0] 								wb_dat_o7;

wire [`UART_ADDR_WIDTH7-1:0] 		wb_addr_i7;
wire [7:0] 								wb_dat_i7;


reg [3:0] 								ier7;
reg [3:0] 								iir7;
reg [1:0] 								fcr7;  /// bits 7 and 6 of fcr7. Other7 bits are ignored
reg [4:0] 								mcr7;
reg [7:0] 								lcr7;
reg [7:0] 								msr7;
reg [15:0] 								dl7;  // 32-bit divisor7 latch7
reg [7:0] 								scratch7; // UART7 scratch7 register
reg 										start_dlc7; // activate7 dlc7 on writing to UART_DL17
reg 										lsr_mask_d7; // delay for lsr_mask7 condition
reg 										msi_reset7; // reset MSR7 4 lower7 bits indicator7
//reg 										threi_clear7; // THRE7 interrupt7 clear flag7
reg [15:0] 								dlc7;  // 32-bit divisor7 latch7 counter
reg 										int_o7;

reg [3:0] 								trigger_level7; // trigger level of the receiver7 FIFO
reg 										rx_reset7;
reg 										tx_reset7;

wire 										dlab7;			   // divisor7 latch7 access bit
wire 										cts_pad_i7, dsr_pad_i7, ri_pad_i7, dcd_pad_i7; // modem7 status bits
wire 										loopback7;		   // loopback7 bit (MCR7 bit 4)
wire 										cts7, dsr7, ri, dcd7;	   // effective7 signals7
wire                    cts_c7, dsr_c7, ri_c7, dcd_c7; // Complement7 effective7 signals7 (considering7 loopback7)
wire 										rts_pad_o7, dtr_pad_o7;		   // modem7 control7 outputs7

// LSR7 bits wires7 and regs
wire [7:0] 								lsr7;
wire 										lsr07, lsr17, lsr27, lsr37, lsr47, lsr57, lsr67, lsr77;
reg										lsr0r7, lsr1r7, lsr2r7, lsr3r7, lsr4r7, lsr5r7, lsr6r7, lsr7r7;
wire 										lsr_mask7; // lsr_mask7

//
// ASSINGS7
//

assign 									lsr7[7:0] = { lsr7r7, lsr6r7, lsr5r7, lsr4r7, lsr3r7, lsr2r7, lsr1r7, lsr0r7 };

assign 									{cts_pad_i7, dsr_pad_i7, ri_pad_i7, dcd_pad_i7} = modem_inputs7;
assign 									{cts7, dsr7, ri, dcd7} = ~{cts_pad_i7,dsr_pad_i7,ri_pad_i7,dcd_pad_i7};

assign                  {cts_c7, dsr_c7, ri_c7, dcd_c7} = loopback7 ? {mcr7[`UART_MC_RTS7],mcr7[`UART_MC_DTR7],mcr7[`UART_MC_OUT17],mcr7[`UART_MC_OUT27]}
                                                               : {cts_pad_i7,dsr_pad_i7,ri_pad_i7,dcd_pad_i7};

assign 									dlab7 = lcr7[`UART_LC_DL7];
assign 									loopback7 = mcr7[4];

// assign modem7 outputs7
assign 									rts_pad_o7 = mcr7[`UART_MC_RTS7];
assign 									dtr_pad_o7 = mcr7[`UART_MC_DTR7];

// Interrupt7 signals7
wire 										rls_int7;  // receiver7 line status interrupt7
wire 										rda_int7;  // receiver7 data available interrupt7
wire 										ti_int7;   // timeout indicator7 interrupt7
wire										thre_int7; // transmitter7 holding7 register empty7 interrupt7
wire 										ms_int7;   // modem7 status interrupt7

// FIFO signals7
reg 										tf_push7;
reg 										rf_pop7;
wire [`UART_FIFO_REC_WIDTH7-1:0] 	rf_data_out7;
wire 										rf_error_bit7; // an error (parity7 or framing7) is inside the fifo
wire [`UART_FIFO_COUNTER_W7-1:0] 	rf_count7;
wire [`UART_FIFO_COUNTER_W7-1:0] 	tf_count7;
wire [2:0] 								tstate7;
wire [3:0] 								rstate;
wire [9:0] 								counter_t7;

wire                      thre_set_en7; // THRE7 status is delayed7 one character7 time when a character7 is written7 to fifo.
reg  [7:0]                block_cnt7;   // While7 counter counts7, THRE7 status is blocked7 (delayed7 one character7 cycle)
reg  [7:0]                block_value7; // One7 character7 length minus7 stop bit

// Transmitter7 Instance
wire serial_out7;

uart_transmitter7 transmitter7(clk7, wb_rst_i7, lcr7, tf_push7, wb_dat_i7, enable, serial_out7, tstate7, tf_count7, tx_reset7, lsr_mask7);

  // Synchronizing7 and sampling7 serial7 RX7 input
  uart_sync_flops7    i_uart_sync_flops7
  (
    .rst_i7           (wb_rst_i7),
    .clk_i7           (clk7),
    .stage1_rst_i7    (1'b0),
    .stage1_clk_en_i7 (1'b1),
    .async_dat_i7     (srx_pad_i7),
    .sync_dat_o7      (srx_pad7)
  );
  defparam i_uart_sync_flops7.width      = 1;
  defparam i_uart_sync_flops7.init_value7 = 1'b1;

// handle loopback7
wire serial_in7 = loopback7 ? serial_out7 : srx_pad7;
assign stx_pad_o7 = loopback7 ? 1'b1 : serial_out7;

// Receiver7 Instance
uart_receiver7 receiver7(clk7, wb_rst_i7, lcr7, rf_pop7, serial_in7, enable, 
	counter_t7, rf_count7, rf_data_out7, rf_error_bit7, rf_overrun7, rx_reset7, lsr_mask7, rstate, rf_push_pulse7);


// Asynchronous7 reading here7 because the outputs7 are sampled7 in uart_wb7.v file 
always @(dl7 or dlab7 or ier7 or iir7 or scratch7
			or lcr7 or lsr7 or msr7 or rf_data_out7 or wb_addr_i7 or wb_re_i7)   // asynchrounous7 reading
begin
	case (wb_addr_i7)
		`UART_REG_RB7   : wb_dat_o7 = dlab7 ? dl7[`UART_DL17] : rf_data_out7[10:3];
		`UART_REG_IE7	: wb_dat_o7 = dlab7 ? dl7[`UART_DL27] : ier7;
		`UART_REG_II7	: wb_dat_o7 = {4'b1100,iir7};
		`UART_REG_LC7	: wb_dat_o7 = lcr7;
		`UART_REG_LS7	: wb_dat_o7 = lsr7;
		`UART_REG_MS7	: wb_dat_o7 = msr7;
		`UART_REG_SR7	: wb_dat_o7 = scratch7;
		default:  wb_dat_o7 = 8'b0; // ??
	endcase // case(wb_addr_i7)
end // always @ (dl7 or dlab7 or ier7 or iir7 or scratch7...


// rf_pop7 signal7 handling7
always @(posedge clk7 or posedge wb_rst_i7)
begin
	if (wb_rst_i7)
		rf_pop7 <= #1 0; 
	else
	if (rf_pop7)	// restore7 the signal7 to 0 after one clock7 cycle
		rf_pop7 <= #1 0;
	else
	if (wb_re_i7 && wb_addr_i7 == `UART_REG_RB7 && !dlab7)
		rf_pop7 <= #1 1; // advance7 read pointer7
end

wire 	lsr_mask_condition7;
wire 	iir_read7;
wire  msr_read7;
wire	fifo_read7;
wire	fifo_write7;

assign lsr_mask_condition7 = (wb_re_i7 && wb_addr_i7 == `UART_REG_LS7 && !dlab7);
assign iir_read7 = (wb_re_i7 && wb_addr_i7 == `UART_REG_II7 && !dlab7);
assign msr_read7 = (wb_re_i7 && wb_addr_i7 == `UART_REG_MS7 && !dlab7);
assign fifo_read7 = (wb_re_i7 && wb_addr_i7 == `UART_REG_RB7 && !dlab7);
assign fifo_write7 = (wb_we_i7 && wb_addr_i7 == `UART_REG_TR7 && !dlab7);

// lsr_mask_d7 delayed7 signal7 handling7
always @(posedge clk7 or posedge wb_rst_i7)
begin
	if (wb_rst_i7)
		lsr_mask_d7 <= #1 0;
	else // reset bits in the Line7 Status Register
		lsr_mask_d7 <= #1 lsr_mask_condition7;
end

// lsr_mask7 is rise7 detected
assign lsr_mask7 = lsr_mask_condition7 && ~lsr_mask_d7;

// msi_reset7 signal7 handling7
always @(posedge clk7 or posedge wb_rst_i7)
begin
	if (wb_rst_i7)
		msi_reset7 <= #1 1;
	else
	if (msi_reset7)
		msi_reset7 <= #1 0;
	else
	if (msr_read7)
		msi_reset7 <= #1 1; // reset bits in Modem7 Status Register
end


//
//   WRITES7 AND7 RESETS7   //
//
// Line7 Control7 Register
always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7)
		lcr7 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i7 && wb_addr_i7==`UART_REG_LC7)
		lcr7 <= #1 wb_dat_i7;

// Interrupt7 Enable7 Register or UART_DL27
always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7)
	begin
		ier7 <= #1 4'b0000; // no interrupts7 after reset
		dl7[`UART_DL27] <= #1 8'b0;
	end
	else
	if (wb_we_i7 && wb_addr_i7==`UART_REG_IE7)
		if (dlab7)
		begin
			dl7[`UART_DL27] <= #1 wb_dat_i7;
		end
		else
			ier7 <= #1 wb_dat_i7[3:0]; // ier7 uses only 4 lsb


// FIFO Control7 Register and rx_reset7, tx_reset7 signals7
always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) begin
		fcr7 <= #1 2'b11; 
		rx_reset7 <= #1 0;
		tx_reset7 <= #1 0;
	end else
	if (wb_we_i7 && wb_addr_i7==`UART_REG_FC7) begin
		fcr7 <= #1 wb_dat_i7[7:6];
		rx_reset7 <= #1 wb_dat_i7[1];
		tx_reset7 <= #1 wb_dat_i7[2];
	end else begin
		rx_reset7 <= #1 0;
		tx_reset7 <= #1 0;
	end

// Modem7 Control7 Register
always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7)
		mcr7 <= #1 5'b0; 
	else
	if (wb_we_i7 && wb_addr_i7==`UART_REG_MC7)
			mcr7 <= #1 wb_dat_i7[4:0];

// Scratch7 register
// Line7 Control7 Register
always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7)
		scratch7 <= #1 0; // 8n1 setting
	else
	if (wb_we_i7 && wb_addr_i7==`UART_REG_SR7)
		scratch7 <= #1 wb_dat_i7;

// TX_FIFO7 or UART_DL17
always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7)
	begin
		dl7[`UART_DL17]  <= #1 8'b0;
		tf_push7   <= #1 1'b0;
		start_dlc7 <= #1 1'b0;
	end
	else
	if (wb_we_i7 && wb_addr_i7==`UART_REG_TR7)
		if (dlab7)
		begin
			dl7[`UART_DL17] <= #1 wb_dat_i7;
			start_dlc7 <= #1 1'b1; // enable DL7 counter
			tf_push7 <= #1 1'b0;
		end
		else
		begin
			tf_push7   <= #1 1'b1;
			start_dlc7 <= #1 1'b0;
		end // else: !if(dlab7)
	else
	begin
		start_dlc7 <= #1 1'b0;
		tf_push7   <= #1 1'b0;
	end // else: !if(dlab7)

// Receiver7 FIFO trigger level selection logic (asynchronous7 mux7)
always @(fcr7)
	case (fcr7[`UART_FC_TL7])
		2'b00 : trigger_level7 = 1;
		2'b01 : trigger_level7 = 4;
		2'b10 : trigger_level7 = 8;
		2'b11 : trigger_level7 = 14;
	endcase // case(fcr7[`UART_FC_TL7])
	
//
//  STATUS7 REGISTERS7  //
//

// Modem7 Status Register
reg [3:0] delayed_modem_signals7;
always @(posedge clk7 or posedge wb_rst_i7)
begin
	if (wb_rst_i7)
	  begin
  		msr7 <= #1 0;
	  	delayed_modem_signals7[3:0] <= #1 0;
	  end
	else begin
		msr7[`UART_MS_DDCD7:`UART_MS_DCTS7] <= #1 msi_reset7 ? 4'b0 :
			msr7[`UART_MS_DDCD7:`UART_MS_DCTS7] | ({dcd7, ri, dsr7, cts7} ^ delayed_modem_signals7[3:0]);
		msr7[`UART_MS_CDCD7:`UART_MS_CCTS7] <= #1 {dcd_c7, ri_c7, dsr_c7, cts_c7};
		delayed_modem_signals7[3:0] <= #1 {dcd7, ri, dsr7, cts7};
	end
end


// Line7 Status Register

// activation7 conditions7
assign lsr07 = (rf_count7==0 && rf_push_pulse7);  // data in receiver7 fifo available set condition
assign lsr17 = rf_overrun7;     // Receiver7 overrun7 error
assign lsr27 = rf_data_out7[1]; // parity7 error bit
assign lsr37 = rf_data_out7[0]; // framing7 error bit
assign lsr47 = rf_data_out7[2]; // break error in the character7
assign lsr57 = (tf_count7==5'b0 && thre_set_en7);  // transmitter7 fifo is empty7
assign lsr67 = (tf_count7==5'b0 && thre_set_en7 && (tstate7 == /*`S_IDLE7 */ 0)); // transmitter7 empty7
assign lsr77 = rf_error_bit7 | rf_overrun7;

// lsr7 bit07 (receiver7 data available)
reg 	 lsr0_d7;

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr0_d7 <= #1 0;
	else lsr0_d7 <= #1 lsr07;

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr0r7 <= #1 0;
	else lsr0r7 <= #1 (rf_count7==1 && rf_pop7 && !rf_push_pulse7 || rx_reset7) ? 0 : // deassert7 condition
					  lsr0r7 || (lsr07 && ~lsr0_d7); // set on rise7 of lsr07 and keep7 asserted7 until deasserted7 

// lsr7 bit 1 (receiver7 overrun7)
reg lsr1_d7; // delayed7

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr1_d7 <= #1 0;
	else lsr1_d7 <= #1 lsr17;

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr1r7 <= #1 0;
	else	lsr1r7 <= #1	lsr_mask7 ? 0 : lsr1r7 || (lsr17 && ~lsr1_d7); // set on rise7

// lsr7 bit 2 (parity7 error)
reg lsr2_d7; // delayed7

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr2_d7 <= #1 0;
	else lsr2_d7 <= #1 lsr27;

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr2r7 <= #1 0;
	else lsr2r7 <= #1 lsr_mask7 ? 0 : lsr2r7 || (lsr27 && ~lsr2_d7); // set on rise7

// lsr7 bit 3 (framing7 error)
reg lsr3_d7; // delayed7

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr3_d7 <= #1 0;
	else lsr3_d7 <= #1 lsr37;

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr3r7 <= #1 0;
	else lsr3r7 <= #1 lsr_mask7 ? 0 : lsr3r7 || (lsr37 && ~lsr3_d7); // set on rise7

// lsr7 bit 4 (break indicator7)
reg lsr4_d7; // delayed7

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr4_d7 <= #1 0;
	else lsr4_d7 <= #1 lsr47;

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr4r7 <= #1 0;
	else lsr4r7 <= #1 lsr_mask7 ? 0 : lsr4r7 || (lsr47 && ~lsr4_d7);

// lsr7 bit 5 (transmitter7 fifo is empty7)
reg lsr5_d7;

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr5_d7 <= #1 1;
	else lsr5_d7 <= #1 lsr57;

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr5r7 <= #1 1;
	else lsr5r7 <= #1 (fifo_write7) ? 0 :  lsr5r7 || (lsr57 && ~lsr5_d7);

// lsr7 bit 6 (transmitter7 empty7 indicator7)
reg lsr6_d7;

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr6_d7 <= #1 1;
	else lsr6_d7 <= #1 lsr67;

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr6r7 <= #1 1;
	else lsr6r7 <= #1 (fifo_write7) ? 0 : lsr6r7 || (lsr67 && ~lsr6_d7);

// lsr7 bit 7 (error in fifo)
reg lsr7_d7;

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr7_d7 <= #1 0;
	else lsr7_d7 <= #1 lsr77;

always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) lsr7r7 <= #1 0;
	else lsr7r7 <= #1 lsr_mask7 ? 0 : lsr7r7 || (lsr77 && ~lsr7_d7);

// Frequency7 divider7
always @(posedge clk7 or posedge wb_rst_i7) 
begin
	if (wb_rst_i7)
		dlc7 <= #1 0;
	else
		if (start_dlc7 | ~ (|dlc7))
  			dlc7 <= #1 dl7 - 1;               // preset7 counter
		else
			dlc7 <= #1 dlc7 - 1;              // decrement counter
end

// Enable7 signal7 generation7 logic
always @(posedge clk7 or posedge wb_rst_i7)
begin
	if (wb_rst_i7)
		enable <= #1 1'b0;
	else
		if (|dl7 & ~(|dlc7))     // dl7>0 & dlc7==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying7 THRE7 status for one character7 cycle after a character7 is written7 to an empty7 fifo.
always @(lcr7)
  case (lcr7[3:0])
    4'b0000                             : block_value7 =  95; // 6 bits
    4'b0100                             : block_value7 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value7 = 111; // 7 bits
    4'b1100                             : block_value7 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value7 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value7 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value7 = 159; // 10 bits
    4'b1111                             : block_value7 = 175; // 11 bits
  endcase // case(lcr7[3:0])

// Counting7 time of one character7 minus7 stop bit
always @(posedge clk7 or posedge wb_rst_i7)
begin
  if (wb_rst_i7)
    block_cnt7 <= #1 8'd0;
  else
  if(lsr5r7 & fifo_write7)  // THRE7 bit set & write to fifo occured7
    block_cnt7 <= #1 block_value7;
  else
  if (enable & block_cnt7 != 8'b0)  // only work7 on enable times
    block_cnt7 <= #1 block_cnt7 - 1;  // decrement break counter
end // always of break condition detection7

// Generating7 THRE7 status enable signal7
assign thre_set_en7 = ~(|block_cnt7);


//
//	INTERRUPT7 LOGIC7
//

assign rls_int7  = ier7[`UART_IE_RLS7] && (lsr7[`UART_LS_OE7] || lsr7[`UART_LS_PE7] || lsr7[`UART_LS_FE7] || lsr7[`UART_LS_BI7]);
assign rda_int7  = ier7[`UART_IE_RDA7] && (rf_count7 >= {1'b0,trigger_level7});
assign thre_int7 = ier7[`UART_IE_THRE7] && lsr7[`UART_LS_TFE7];
assign ms_int7   = ier7[`UART_IE_MS7] && (| msr7[3:0]);
assign ti_int7   = ier7[`UART_IE_RDA7] && (counter_t7 == 10'b0) && (|rf_count7);

reg 	 rls_int_d7;
reg 	 thre_int_d7;
reg 	 ms_int_d7;
reg 	 ti_int_d7;
reg 	 rda_int_d7;

// delay lines7
always  @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) rls_int_d7 <= #1 0;
	else rls_int_d7 <= #1 rls_int7;

always  @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) rda_int_d7 <= #1 0;
	else rda_int_d7 <= #1 rda_int7;

always  @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) thre_int_d7 <= #1 0;
	else thre_int_d7 <= #1 thre_int7;

always  @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) ms_int_d7 <= #1 0;
	else ms_int_d7 <= #1 ms_int7;

always  @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) ti_int_d7 <= #1 0;
	else ti_int_d7 <= #1 ti_int7;

// rise7 detection7 signals7

wire 	 rls_int_rise7;
wire 	 thre_int_rise7;
wire 	 ms_int_rise7;
wire 	 ti_int_rise7;
wire 	 rda_int_rise7;

assign rda_int_rise7    = rda_int7 & ~rda_int_d7;
assign rls_int_rise7 	  = rls_int7 & ~rls_int_d7;
assign thre_int_rise7   = thre_int7 & ~thre_int_d7;
assign ms_int_rise7 	  = ms_int7 & ~ms_int_d7;
assign ti_int_rise7 	  = ti_int7 & ~ti_int_d7;

// interrupt7 pending flags7
reg 	rls_int_pnd7;
reg	rda_int_pnd7;
reg 	thre_int_pnd7;
reg 	ms_int_pnd7;
reg 	ti_int_pnd7;

// interrupt7 pending flags7 assignments7
always  @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) rls_int_pnd7 <= #1 0; 
	else 
		rls_int_pnd7 <= #1 lsr_mask7 ? 0 :  						// reset condition
							rls_int_rise7 ? 1 :						// latch7 condition
							rls_int_pnd7 && ier7[`UART_IE_RLS7];	// default operation7: remove if masked7

always  @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) rda_int_pnd7 <= #1 0; 
	else 
		rda_int_pnd7 <= #1 ((rf_count7 == {1'b0,trigger_level7}) && fifo_read7) ? 0 :  	// reset condition
							rda_int_rise7 ? 1 :						// latch7 condition
							rda_int_pnd7 && ier7[`UART_IE_RDA7];	// default operation7: remove if masked7

always  @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) thre_int_pnd7 <= #1 0; 
	else 
		thre_int_pnd7 <= #1 fifo_write7 || (iir_read7 & ~iir7[`UART_II_IP7] & iir7[`UART_II_II7] == `UART_II_THRE7)? 0 : 
							thre_int_rise7 ? 1 :
							thre_int_pnd7 && ier7[`UART_IE_THRE7];

always  @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) ms_int_pnd7 <= #1 0; 
	else 
		ms_int_pnd7 <= #1 msr_read7 ? 0 : 
							ms_int_rise7 ? 1 :
							ms_int_pnd7 && ier7[`UART_IE_MS7];

always  @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) ti_int_pnd7 <= #1 0; 
	else 
		ti_int_pnd7 <= #1 fifo_read7 ? 0 : 
							ti_int_rise7 ? 1 :
							ti_int_pnd7 && ier7[`UART_IE_RDA7];
// end of pending flags7

// INT_O7 logic
always @(posedge clk7 or posedge wb_rst_i7)
begin
	if (wb_rst_i7)	
		int_o7 <= #1 1'b0;
	else
		int_o7 <= #1 
					rls_int_pnd7		?	~lsr_mask7					:
					rda_int_pnd7		? 1								:
					ti_int_pnd7		? ~fifo_read7					:
					thre_int_pnd7	? !(fifo_write7 & iir_read7) :
					ms_int_pnd7		? ~msr_read7						:
					0;	// if no interrupt7 are pending
end


// Interrupt7 Identification7 register
always @(posedge clk7 or posedge wb_rst_i7)
begin
	if (wb_rst_i7)
		iir7 <= #1 1;
	else
	if (rls_int_pnd7)  // interrupt7 is pending
	begin
		iir7[`UART_II_II7] <= #1 `UART_II_RLS7;	// set identification7 register to correct7 value
		iir7[`UART_II_IP7] <= #1 1'b0;		// and clear the IIR7 bit 0 (interrupt7 pending)
	end else // the sequence of conditions7 determines7 priority of interrupt7 identification7
	if (rda_int7)
	begin
		iir7[`UART_II_II7] <= #1 `UART_II_RDA7;
		iir7[`UART_II_IP7] <= #1 1'b0;
	end
	else if (ti_int_pnd7)
	begin
		iir7[`UART_II_II7] <= #1 `UART_II_TI7;
		iir7[`UART_II_IP7] <= #1 1'b0;
	end
	else if (thre_int_pnd7)
	begin
		iir7[`UART_II_II7] <= #1 `UART_II_THRE7;
		iir7[`UART_II_IP7] <= #1 1'b0;
	end
	else if (ms_int_pnd7)
	begin
		iir7[`UART_II_II7] <= #1 `UART_II_MS7;
		iir7[`UART_II_IP7] <= #1 1'b0;
	end else	// no interrupt7 is pending
	begin
		iir7[`UART_II_II7] <= #1 0;
		iir7[`UART_II_IP7] <= #1 1'b1;
	end
end

endmodule
