//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs2.v                                                 ////
////                                                              ////
////                                                              ////
////  This2 file is part of the "UART2 16550 compatible2" project2    ////
////  http2://www2.opencores2.org2/cores2/uart165502/                   ////
////                                                              ////
////  Documentation2 related2 to this project2:                      ////
////  - http2://www2.opencores2.org2/cores2/uart165502/                 ////
////                                                              ////
////  Projects2 compatibility2:                                     ////
////  - WISHBONE2                                                  ////
////  RS2322 Protocol2                                              ////
////  16550D uart2 (mostly2 supported)                              ////
////                                                              ////
////  Overview2 (main2 Features2):                                   ////
////  Registers2 of the uart2 16550 core2                            ////
////                                                              ////
////  Known2 problems2 (limits2):                                    ////
////  Inserts2 1 wait state in all WISHBONE2 transfers2              ////
////                                                              ////
////  To2 Do2:                                                      ////
////  Nothing or verification2.                                    ////
////                                                              ////
////  Author2(s):                                                  ////
////      - gorban2@opencores2.org2                                  ////
////      - Jacob2 Gorban2                                          ////
////      - Igor2 Mohor2 (igorm2@opencores2.org2)                      ////
////                                                              ////
////  Created2:        2001/05/12                                  ////
////  Last2 Updated2:   (See log2 for the revision2 history2           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2000, 2001 Authors2                             ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS2 Revision2 History2
//
// $Log: not supported by cvs2svn2 $
// Revision2 1.41  2004/05/21 11:44:41  tadejm2
// Added2 synchronizer2 flops2 for RX2 input.
//
// Revision2 1.40  2003/06/11 16:37:47  gorban2
// This2 fixes2 errors2 in some2 cases2 when data is being read and put to the FIFO at the same time. Patch2 is submitted2 by Scott2 Furman2. Update is very2 recommended2.
//
// Revision2 1.39  2002/07/29 21:16:18  gorban2
// The uart_defines2.v file is included2 again2 in sources2.
//
// Revision2 1.38  2002/07/22 23:02:23  gorban2
// Bug2 Fixes2:
//  * Possible2 loss of sync and bad2 reception2 of stop bit on slow2 baud2 rates2 fixed2.
//   Problem2 reported2 by Kenny2.Tung2.
//  * Bad (or lack2 of ) loopback2 handling2 fixed2. Reported2 by Cherry2 Withers2.
//
// Improvements2:
//  * Made2 FIFO's as general2 inferrable2 memory where possible2.
//  So2 on FPGA2 they should be inferred2 as RAM2 (Distributed2 RAM2 on Xilinx2).
//  This2 saves2 about2 1/3 of the Slice2 count and reduces2 P&R and synthesis2 times.
//
//  * Added2 optional2 baudrate2 output (baud_o2).
//  This2 is identical2 to BAUDOUT2* signal2 on 16550 chip2.
//  It outputs2 16xbit_clock_rate - the divided2 clock2.
//  It's disabled by default. Define2 UART_HAS_BAUDRATE_OUTPUT2 to use.
//
// Revision2 1.37  2001/12/27 13:24:09  mohor2
// lsr2[7] was not showing2 overrun2 errors2.
//
// Revision2 1.36  2001/12/20 13:25:46  mohor2
// rx2 push2 changed to be only one cycle wide2.
//
// Revision2 1.35  2001/12/19 08:03:34  mohor2
// Warnings2 cleared2.
//
// Revision2 1.34  2001/12/19 07:33:54  mohor2
// Synplicity2 was having2 troubles2 with the comment2.
//
// Revision2 1.33  2001/12/17 10:14:43  mohor2
// Things2 related2 to msr2 register changed. After2 THRE2 IRQ2 occurs2, and one
// character2 is written2 to the transmit2 fifo, the detection2 of the THRE2 bit in the
// LSR2 is delayed2 for one character2 time.
//
// Revision2 1.32  2001/12/14 13:19:24  mohor2
// MSR2 register fixed2.
//
// Revision2 1.31  2001/12/14 10:06:58  mohor2
// After2 reset modem2 status register MSR2 should be reset.
//
// Revision2 1.30  2001/12/13 10:09:13  mohor2
// thre2 irq2 should be cleared2 only when being source2 of interrupt2.
//
// Revision2 1.29  2001/12/12 09:05:46  mohor2
// LSR2 status bit 0 was not cleared2 correctly in case of reseting2 the FCR2 (rx2 fifo).
//
// Revision2 1.28  2001/12/10 19:52:41  gorban2
// Scratch2 register added
//
// Revision2 1.27  2001/12/06 14:51:04  gorban2
// Bug2 in LSR2[0] is fixed2.
// All WISHBONE2 signals2 are now sampled2, so another2 wait-state is introduced2 on all transfers2.
//
// Revision2 1.26  2001/12/03 21:44:29  gorban2
// Updated2 specification2 documentation.
// Added2 full 32-bit data bus interface, now as default.
// Address is 5-bit wide2 in 32-bit data bus mode.
// Added2 wb_sel_i2 input to the core2. It's used in the 32-bit mode.
// Added2 debug2 interface with two2 32-bit read-only registers in 32-bit mode.
// Bits2 5 and 6 of LSR2 are now only cleared2 on TX2 FIFO write.
// My2 small test bench2 is modified to work2 with 32-bit mode.
//
// Revision2 1.25  2001/11/28 19:36:39  gorban2
// Fixed2: timeout and break didn2't pay2 attention2 to current data format2 when counting2 time
//
// Revision2 1.24  2001/11/26 21:38:54  gorban2
// Lots2 of fixes2:
// Break2 condition wasn2't handled2 correctly at all.
// LSR2 bits could lose2 their2 values.
// LSR2 value after reset was wrong2.
// Timing2 of THRE2 interrupt2 signal2 corrected2.
// LSR2 bit 0 timing2 corrected2.
//
// Revision2 1.23  2001/11/12 21:57:29  gorban2
// fixed2 more typo2 bugs2
//
// Revision2 1.22  2001/11/12 15:02:28  mohor2
// lsr1r2 error fixed2.
//
// Revision2 1.21  2001/11/12 14:57:27  mohor2
// ti_int_pnd2 error fixed2.
//
// Revision2 1.20  2001/11/12 14:50:27  mohor2
// ti_int_d2 error fixed2.
//
// Revision2 1.19  2001/11/10 12:43:21  gorban2
// Logic2 Synthesis2 bugs2 fixed2. Some2 other minor2 changes2
//
// Revision2 1.18  2001/11/08 14:54:23  mohor2
// Comments2 in Slovene2 language2 deleted2, few2 small fixes2 for better2 work2 of
// old2 tools2. IRQs2 need to be fix2.
//
// Revision2 1.17  2001/11/07 17:51:52  gorban2
// Heavily2 rewritten2 interrupt2 and LSR2 subsystems2.
// Many2 bugs2 hopefully2 squashed2.
//
// Revision2 1.16  2001/11/02 09:55:16  mohor2
// no message
//
// Revision2 1.15  2001/10/31 15:19:22  gorban2
// Fixes2 to break and timeout conditions2
//
// Revision2 1.14  2001/10/29 17:00:46  gorban2
// fixed2 parity2 sending2 and tx_fifo2 resets2 over- and underrun2
//
// Revision2 1.13  2001/10/20 09:58:40  gorban2
// Small2 synopsis2 fixes2
//
// Revision2 1.12  2001/10/19 16:21:40  gorban2
// Changes2 data_out2 to be synchronous2 again2 as it should have been.
//
// Revision2 1.11  2001/10/18 20:35:45  gorban2
// small fix2
//
// Revision2 1.10  2001/08/24 21:01:12  mohor2
// Things2 connected2 to parity2 changed.
// Clock2 devider2 changed.
//
// Revision2 1.9  2001/08/23 16:05:05  mohor2
// Stop bit bug2 fixed2.
// Parity2 bug2 fixed2.
// WISHBONE2 read cycle bug2 fixed2,
// OE2 indicator2 (Overrun2 Error) bug2 fixed2.
// PE2 indicator2 (Parity2 Error) bug2 fixed2.
// Register read bug2 fixed2.
//
// Revision2 1.10  2001/06/23 11:21:48  gorban2
// DL2 made2 16-bit long2. Fixed2 transmission2/reception2 bugs2.
//
// Revision2 1.9  2001/05/31 20:08:01  gorban2
// FIFO changes2 and other corrections2.
//
// Revision2 1.8  2001/05/29 20:05:04  gorban2
// Fixed2 some2 bugs2 and synthesis2 problems2.
//
// Revision2 1.7  2001/05/27 17:37:49  gorban2
// Fixed2 many2 bugs2. Updated2 spec2. Changed2 FIFO files structure2. See CHANGES2.txt2 file.
//
// Revision2 1.6  2001/05/21 19:12:02  gorban2
// Corrected2 some2 Linter2 messages2.
//
// Revision2 1.5  2001/05/17 18:34:18  gorban2
// First2 'stable' release. Should2 be sythesizable2 now. Also2 added new header.
//
// Revision2 1.0  2001-05-17 21:27:11+02  jacob2
// Initial2 revision2
//
//

// synopsys2 translate_off2
`include "timescale.v"
// synopsys2 translate_on2

`include "uart_defines2.v"

`define UART_DL12 7:0
`define UART_DL22 15:8

module uart_regs2 (clk2,
	wb_rst_i2, wb_addr_i2, wb_dat_i2, wb_dat_o2, wb_we_i2, wb_re_i2, 

// additional2 signals2
	modem_inputs2,
	stx_pad_o2, srx_pad_i2,

`ifdef DATA_BUS_WIDTH_82
`else
// debug2 interface signals2	enabled
ier2, iir2, fcr2, mcr2, lcr2, msr2, lsr2, rf_count2, tf_count2, tstate2, rstate,
`endif				
	rts_pad_o2, dtr_pad_o2, int_o2
`ifdef UART_HAS_BAUDRATE_OUTPUT2
	, baud_o2
`endif

	);

input 									clk2;
input 									wb_rst_i2;
input [`UART_ADDR_WIDTH2-1:0] 		wb_addr_i2;
input [7:0] 							wb_dat_i2;
output [7:0] 							wb_dat_o2;
input 									wb_we_i2;
input 									wb_re_i2;

output 									stx_pad_o2;
input 									srx_pad_i2;

input [3:0] 							modem_inputs2;
output 									rts_pad_o2;
output 									dtr_pad_o2;
output 									int_o2;
`ifdef UART_HAS_BAUDRATE_OUTPUT2
output	baud_o2;
`endif

`ifdef DATA_BUS_WIDTH_82
`else
// if 32-bit databus2 and debug2 interface are enabled
output [3:0]							ier2;
output [3:0]							iir2;
output [1:0]							fcr2;  /// bits 7 and 6 of fcr2. Other2 bits are ignored
output [4:0]							mcr2;
output [7:0]							lcr2;
output [7:0]							msr2;
output [7:0] 							lsr2;
output [`UART_FIFO_COUNTER_W2-1:0] 	rf_count2;
output [`UART_FIFO_COUNTER_W2-1:0] 	tf_count2;
output [2:0] 							tstate2;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs2;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT2
assign baud_o2 = enable; // baud_o2 is actually2 the enable signal2
`endif


wire 										stx_pad_o2;		// received2 from transmitter2 module
wire 										srx_pad_i2;
wire 										srx_pad2;

reg [7:0] 								wb_dat_o2;

wire [`UART_ADDR_WIDTH2-1:0] 		wb_addr_i2;
wire [7:0] 								wb_dat_i2;


reg [3:0] 								ier2;
reg [3:0] 								iir2;
reg [1:0] 								fcr2;  /// bits 7 and 6 of fcr2. Other2 bits are ignored
reg [4:0] 								mcr2;
reg [7:0] 								lcr2;
reg [7:0] 								msr2;
reg [15:0] 								dl2;  // 32-bit divisor2 latch2
reg [7:0] 								scratch2; // UART2 scratch2 register
reg 										start_dlc2; // activate2 dlc2 on writing to UART_DL12
reg 										lsr_mask_d2; // delay for lsr_mask2 condition
reg 										msi_reset2; // reset MSR2 4 lower2 bits indicator2
//reg 										threi_clear2; // THRE2 interrupt2 clear flag2
reg [15:0] 								dlc2;  // 32-bit divisor2 latch2 counter
reg 										int_o2;

reg [3:0] 								trigger_level2; // trigger level of the receiver2 FIFO
reg 										rx_reset2;
reg 										tx_reset2;

wire 										dlab2;			   // divisor2 latch2 access bit
wire 										cts_pad_i2, dsr_pad_i2, ri_pad_i2, dcd_pad_i2; // modem2 status bits
wire 										loopback2;		   // loopback2 bit (MCR2 bit 4)
wire 										cts2, dsr2, ri, dcd2;	   // effective2 signals2
wire                    cts_c2, dsr_c2, ri_c2, dcd_c2; // Complement2 effective2 signals2 (considering2 loopback2)
wire 										rts_pad_o2, dtr_pad_o2;		   // modem2 control2 outputs2

// LSR2 bits wires2 and regs
wire [7:0] 								lsr2;
wire 										lsr02, lsr12, lsr22, lsr32, lsr42, lsr52, lsr62, lsr72;
reg										lsr0r2, lsr1r2, lsr2r2, lsr3r2, lsr4r2, lsr5r2, lsr6r2, lsr7r2;
wire 										lsr_mask2; // lsr_mask2

//
// ASSINGS2
//

assign 									lsr2[7:0] = { lsr7r2, lsr6r2, lsr5r2, lsr4r2, lsr3r2, lsr2r2, lsr1r2, lsr0r2 };

assign 									{cts_pad_i2, dsr_pad_i2, ri_pad_i2, dcd_pad_i2} = modem_inputs2;
assign 									{cts2, dsr2, ri, dcd2} = ~{cts_pad_i2,dsr_pad_i2,ri_pad_i2,dcd_pad_i2};

assign                  {cts_c2, dsr_c2, ri_c2, dcd_c2} = loopback2 ? {mcr2[`UART_MC_RTS2],mcr2[`UART_MC_DTR2],mcr2[`UART_MC_OUT12],mcr2[`UART_MC_OUT22]}
                                                               : {cts_pad_i2,dsr_pad_i2,ri_pad_i2,dcd_pad_i2};

assign 									dlab2 = lcr2[`UART_LC_DL2];
assign 									loopback2 = mcr2[4];

// assign modem2 outputs2
assign 									rts_pad_o2 = mcr2[`UART_MC_RTS2];
assign 									dtr_pad_o2 = mcr2[`UART_MC_DTR2];

// Interrupt2 signals2
wire 										rls_int2;  // receiver2 line status interrupt2
wire 										rda_int2;  // receiver2 data available interrupt2
wire 										ti_int2;   // timeout indicator2 interrupt2
wire										thre_int2; // transmitter2 holding2 register empty2 interrupt2
wire 										ms_int2;   // modem2 status interrupt2

// FIFO signals2
reg 										tf_push2;
reg 										rf_pop2;
wire [`UART_FIFO_REC_WIDTH2-1:0] 	rf_data_out2;
wire 										rf_error_bit2; // an error (parity2 or framing2) is inside the fifo
wire [`UART_FIFO_COUNTER_W2-1:0] 	rf_count2;
wire [`UART_FIFO_COUNTER_W2-1:0] 	tf_count2;
wire [2:0] 								tstate2;
wire [3:0] 								rstate;
wire [9:0] 								counter_t2;

wire                      thre_set_en2; // THRE2 status is delayed2 one character2 time when a character2 is written2 to fifo.
reg  [7:0]                block_cnt2;   // While2 counter counts2, THRE2 status is blocked2 (delayed2 one character2 cycle)
reg  [7:0]                block_value2; // One2 character2 length minus2 stop bit

// Transmitter2 Instance
wire serial_out2;

uart_transmitter2 transmitter2(clk2, wb_rst_i2, lcr2, tf_push2, wb_dat_i2, enable, serial_out2, tstate2, tf_count2, tx_reset2, lsr_mask2);

  // Synchronizing2 and sampling2 serial2 RX2 input
  uart_sync_flops2    i_uart_sync_flops2
  (
    .rst_i2           (wb_rst_i2),
    .clk_i2           (clk2),
    .stage1_rst_i2    (1'b0),
    .stage1_clk_en_i2 (1'b1),
    .async_dat_i2     (srx_pad_i2),
    .sync_dat_o2      (srx_pad2)
  );
  defparam i_uart_sync_flops2.width      = 1;
  defparam i_uart_sync_flops2.init_value2 = 1'b1;

// handle loopback2
wire serial_in2 = loopback2 ? serial_out2 : srx_pad2;
assign stx_pad_o2 = loopback2 ? 1'b1 : serial_out2;

// Receiver2 Instance
uart_receiver2 receiver2(clk2, wb_rst_i2, lcr2, rf_pop2, serial_in2, enable, 
	counter_t2, rf_count2, rf_data_out2, rf_error_bit2, rf_overrun2, rx_reset2, lsr_mask2, rstate, rf_push_pulse2);


// Asynchronous2 reading here2 because the outputs2 are sampled2 in uart_wb2.v file 
always @(dl2 or dlab2 or ier2 or iir2 or scratch2
			or lcr2 or lsr2 or msr2 or rf_data_out2 or wb_addr_i2 or wb_re_i2)   // asynchrounous2 reading
begin
	case (wb_addr_i2)
		`UART_REG_RB2   : wb_dat_o2 = dlab2 ? dl2[`UART_DL12] : rf_data_out2[10:3];
		`UART_REG_IE2	: wb_dat_o2 = dlab2 ? dl2[`UART_DL22] : ier2;
		`UART_REG_II2	: wb_dat_o2 = {4'b1100,iir2};
		`UART_REG_LC2	: wb_dat_o2 = lcr2;
		`UART_REG_LS2	: wb_dat_o2 = lsr2;
		`UART_REG_MS2	: wb_dat_o2 = msr2;
		`UART_REG_SR2	: wb_dat_o2 = scratch2;
		default:  wb_dat_o2 = 8'b0; // ??
	endcase // case(wb_addr_i2)
end // always @ (dl2 or dlab2 or ier2 or iir2 or scratch2...


// rf_pop2 signal2 handling2
always @(posedge clk2 or posedge wb_rst_i2)
begin
	if (wb_rst_i2)
		rf_pop2 <= #1 0; 
	else
	if (rf_pop2)	// restore2 the signal2 to 0 after one clock2 cycle
		rf_pop2 <= #1 0;
	else
	if (wb_re_i2 && wb_addr_i2 == `UART_REG_RB2 && !dlab2)
		rf_pop2 <= #1 1; // advance2 read pointer2
end

wire 	lsr_mask_condition2;
wire 	iir_read2;
wire  msr_read2;
wire	fifo_read2;
wire	fifo_write2;

assign lsr_mask_condition2 = (wb_re_i2 && wb_addr_i2 == `UART_REG_LS2 && !dlab2);
assign iir_read2 = (wb_re_i2 && wb_addr_i2 == `UART_REG_II2 && !dlab2);
assign msr_read2 = (wb_re_i2 && wb_addr_i2 == `UART_REG_MS2 && !dlab2);
assign fifo_read2 = (wb_re_i2 && wb_addr_i2 == `UART_REG_RB2 && !dlab2);
assign fifo_write2 = (wb_we_i2 && wb_addr_i2 == `UART_REG_TR2 && !dlab2);

// lsr_mask_d2 delayed2 signal2 handling2
always @(posedge clk2 or posedge wb_rst_i2)
begin
	if (wb_rst_i2)
		lsr_mask_d2 <= #1 0;
	else // reset bits in the Line2 Status Register
		lsr_mask_d2 <= #1 lsr_mask_condition2;
end

// lsr_mask2 is rise2 detected
assign lsr_mask2 = lsr_mask_condition2 && ~lsr_mask_d2;

// msi_reset2 signal2 handling2
always @(posedge clk2 or posedge wb_rst_i2)
begin
	if (wb_rst_i2)
		msi_reset2 <= #1 1;
	else
	if (msi_reset2)
		msi_reset2 <= #1 0;
	else
	if (msr_read2)
		msi_reset2 <= #1 1; // reset bits in Modem2 Status Register
end


//
//   WRITES2 AND2 RESETS2   //
//
// Line2 Control2 Register
always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2)
		lcr2 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i2 && wb_addr_i2==`UART_REG_LC2)
		lcr2 <= #1 wb_dat_i2;

// Interrupt2 Enable2 Register or UART_DL22
always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2)
	begin
		ier2 <= #1 4'b0000; // no interrupts2 after reset
		dl2[`UART_DL22] <= #1 8'b0;
	end
	else
	if (wb_we_i2 && wb_addr_i2==`UART_REG_IE2)
		if (dlab2)
		begin
			dl2[`UART_DL22] <= #1 wb_dat_i2;
		end
		else
			ier2 <= #1 wb_dat_i2[3:0]; // ier2 uses only 4 lsb


// FIFO Control2 Register and rx_reset2, tx_reset2 signals2
always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) begin
		fcr2 <= #1 2'b11; 
		rx_reset2 <= #1 0;
		tx_reset2 <= #1 0;
	end else
	if (wb_we_i2 && wb_addr_i2==`UART_REG_FC2) begin
		fcr2 <= #1 wb_dat_i2[7:6];
		rx_reset2 <= #1 wb_dat_i2[1];
		tx_reset2 <= #1 wb_dat_i2[2];
	end else begin
		rx_reset2 <= #1 0;
		tx_reset2 <= #1 0;
	end

// Modem2 Control2 Register
always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2)
		mcr2 <= #1 5'b0; 
	else
	if (wb_we_i2 && wb_addr_i2==`UART_REG_MC2)
			mcr2 <= #1 wb_dat_i2[4:0];

// Scratch2 register
// Line2 Control2 Register
always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2)
		scratch2 <= #1 0; // 8n1 setting
	else
	if (wb_we_i2 && wb_addr_i2==`UART_REG_SR2)
		scratch2 <= #1 wb_dat_i2;

// TX_FIFO2 or UART_DL12
always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2)
	begin
		dl2[`UART_DL12]  <= #1 8'b0;
		tf_push2   <= #1 1'b0;
		start_dlc2 <= #1 1'b0;
	end
	else
	if (wb_we_i2 && wb_addr_i2==`UART_REG_TR2)
		if (dlab2)
		begin
			dl2[`UART_DL12] <= #1 wb_dat_i2;
			start_dlc2 <= #1 1'b1; // enable DL2 counter
			tf_push2 <= #1 1'b0;
		end
		else
		begin
			tf_push2   <= #1 1'b1;
			start_dlc2 <= #1 1'b0;
		end // else: !if(dlab2)
	else
	begin
		start_dlc2 <= #1 1'b0;
		tf_push2   <= #1 1'b0;
	end // else: !if(dlab2)

// Receiver2 FIFO trigger level selection logic (asynchronous2 mux2)
always @(fcr2)
	case (fcr2[`UART_FC_TL2])
		2'b00 : trigger_level2 = 1;
		2'b01 : trigger_level2 = 4;
		2'b10 : trigger_level2 = 8;
		2'b11 : trigger_level2 = 14;
	endcase // case(fcr2[`UART_FC_TL2])
	
//
//  STATUS2 REGISTERS2  //
//

// Modem2 Status Register
reg [3:0] delayed_modem_signals2;
always @(posedge clk2 or posedge wb_rst_i2)
begin
	if (wb_rst_i2)
	  begin
  		msr2 <= #1 0;
	  	delayed_modem_signals2[3:0] <= #1 0;
	  end
	else begin
		msr2[`UART_MS_DDCD2:`UART_MS_DCTS2] <= #1 msi_reset2 ? 4'b0 :
			msr2[`UART_MS_DDCD2:`UART_MS_DCTS2] | ({dcd2, ri, dsr2, cts2} ^ delayed_modem_signals2[3:0]);
		msr2[`UART_MS_CDCD2:`UART_MS_CCTS2] <= #1 {dcd_c2, ri_c2, dsr_c2, cts_c2};
		delayed_modem_signals2[3:0] <= #1 {dcd2, ri, dsr2, cts2};
	end
end


// Line2 Status Register

// activation2 conditions2
assign lsr02 = (rf_count2==0 && rf_push_pulse2);  // data in receiver2 fifo available set condition
assign lsr12 = rf_overrun2;     // Receiver2 overrun2 error
assign lsr22 = rf_data_out2[1]; // parity2 error bit
assign lsr32 = rf_data_out2[0]; // framing2 error bit
assign lsr42 = rf_data_out2[2]; // break error in the character2
assign lsr52 = (tf_count2==5'b0 && thre_set_en2);  // transmitter2 fifo is empty2
assign lsr62 = (tf_count2==5'b0 && thre_set_en2 && (tstate2 == /*`S_IDLE2 */ 0)); // transmitter2 empty2
assign lsr72 = rf_error_bit2 | rf_overrun2;

// lsr2 bit02 (receiver2 data available)
reg 	 lsr0_d2;

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr0_d2 <= #1 0;
	else lsr0_d2 <= #1 lsr02;

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr0r2 <= #1 0;
	else lsr0r2 <= #1 (rf_count2==1 && rf_pop2 && !rf_push_pulse2 || rx_reset2) ? 0 : // deassert2 condition
					  lsr0r2 || (lsr02 && ~lsr0_d2); // set on rise2 of lsr02 and keep2 asserted2 until deasserted2 

// lsr2 bit 1 (receiver2 overrun2)
reg lsr1_d2; // delayed2

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr1_d2 <= #1 0;
	else lsr1_d2 <= #1 lsr12;

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr1r2 <= #1 0;
	else	lsr1r2 <= #1	lsr_mask2 ? 0 : lsr1r2 || (lsr12 && ~lsr1_d2); // set on rise2

// lsr2 bit 2 (parity2 error)
reg lsr2_d2; // delayed2

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr2_d2 <= #1 0;
	else lsr2_d2 <= #1 lsr22;

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr2r2 <= #1 0;
	else lsr2r2 <= #1 lsr_mask2 ? 0 : lsr2r2 || (lsr22 && ~lsr2_d2); // set on rise2

// lsr2 bit 3 (framing2 error)
reg lsr3_d2; // delayed2

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr3_d2 <= #1 0;
	else lsr3_d2 <= #1 lsr32;

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr3r2 <= #1 0;
	else lsr3r2 <= #1 lsr_mask2 ? 0 : lsr3r2 || (lsr32 && ~lsr3_d2); // set on rise2

// lsr2 bit 4 (break indicator2)
reg lsr4_d2; // delayed2

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr4_d2 <= #1 0;
	else lsr4_d2 <= #1 lsr42;

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr4r2 <= #1 0;
	else lsr4r2 <= #1 lsr_mask2 ? 0 : lsr4r2 || (lsr42 && ~lsr4_d2);

// lsr2 bit 5 (transmitter2 fifo is empty2)
reg lsr5_d2;

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr5_d2 <= #1 1;
	else lsr5_d2 <= #1 lsr52;

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr5r2 <= #1 1;
	else lsr5r2 <= #1 (fifo_write2) ? 0 :  lsr5r2 || (lsr52 && ~lsr5_d2);

// lsr2 bit 6 (transmitter2 empty2 indicator2)
reg lsr6_d2;

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr6_d2 <= #1 1;
	else lsr6_d2 <= #1 lsr62;

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr6r2 <= #1 1;
	else lsr6r2 <= #1 (fifo_write2) ? 0 : lsr6r2 || (lsr62 && ~lsr6_d2);

// lsr2 bit 7 (error in fifo)
reg lsr7_d2;

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr7_d2 <= #1 0;
	else lsr7_d2 <= #1 lsr72;

always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) lsr7r2 <= #1 0;
	else lsr7r2 <= #1 lsr_mask2 ? 0 : lsr7r2 || (lsr72 && ~lsr7_d2);

// Frequency2 divider2
always @(posedge clk2 or posedge wb_rst_i2) 
begin
	if (wb_rst_i2)
		dlc2 <= #1 0;
	else
		if (start_dlc2 | ~ (|dlc2))
  			dlc2 <= #1 dl2 - 1;               // preset2 counter
		else
			dlc2 <= #1 dlc2 - 1;              // decrement counter
end

// Enable2 signal2 generation2 logic
always @(posedge clk2 or posedge wb_rst_i2)
begin
	if (wb_rst_i2)
		enable <= #1 1'b0;
	else
		if (|dl2 & ~(|dlc2))     // dl2>0 & dlc2==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying2 THRE2 status for one character2 cycle after a character2 is written2 to an empty2 fifo.
always @(lcr2)
  case (lcr2[3:0])
    4'b0000                             : block_value2 =  95; // 6 bits
    4'b0100                             : block_value2 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value2 = 111; // 7 bits
    4'b1100                             : block_value2 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value2 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value2 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value2 = 159; // 10 bits
    4'b1111                             : block_value2 = 175; // 11 bits
  endcase // case(lcr2[3:0])

// Counting2 time of one character2 minus2 stop bit
always @(posedge clk2 or posedge wb_rst_i2)
begin
  if (wb_rst_i2)
    block_cnt2 <= #1 8'd0;
  else
  if(lsr5r2 & fifo_write2)  // THRE2 bit set & write to fifo occured2
    block_cnt2 <= #1 block_value2;
  else
  if (enable & block_cnt2 != 8'b0)  // only work2 on enable times
    block_cnt2 <= #1 block_cnt2 - 1;  // decrement break counter
end // always of break condition detection2

// Generating2 THRE2 status enable signal2
assign thre_set_en2 = ~(|block_cnt2);


//
//	INTERRUPT2 LOGIC2
//

assign rls_int2  = ier2[`UART_IE_RLS2] && (lsr2[`UART_LS_OE2] || lsr2[`UART_LS_PE2] || lsr2[`UART_LS_FE2] || lsr2[`UART_LS_BI2]);
assign rda_int2  = ier2[`UART_IE_RDA2] && (rf_count2 >= {1'b0,trigger_level2});
assign thre_int2 = ier2[`UART_IE_THRE2] && lsr2[`UART_LS_TFE2];
assign ms_int2   = ier2[`UART_IE_MS2] && (| msr2[3:0]);
assign ti_int2   = ier2[`UART_IE_RDA2] && (counter_t2 == 10'b0) && (|rf_count2);

reg 	 rls_int_d2;
reg 	 thre_int_d2;
reg 	 ms_int_d2;
reg 	 ti_int_d2;
reg 	 rda_int_d2;

// delay lines2
always  @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) rls_int_d2 <= #1 0;
	else rls_int_d2 <= #1 rls_int2;

always  @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) rda_int_d2 <= #1 0;
	else rda_int_d2 <= #1 rda_int2;

always  @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) thre_int_d2 <= #1 0;
	else thre_int_d2 <= #1 thre_int2;

always  @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) ms_int_d2 <= #1 0;
	else ms_int_d2 <= #1 ms_int2;

always  @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) ti_int_d2 <= #1 0;
	else ti_int_d2 <= #1 ti_int2;

// rise2 detection2 signals2

wire 	 rls_int_rise2;
wire 	 thre_int_rise2;
wire 	 ms_int_rise2;
wire 	 ti_int_rise2;
wire 	 rda_int_rise2;

assign rda_int_rise2    = rda_int2 & ~rda_int_d2;
assign rls_int_rise2 	  = rls_int2 & ~rls_int_d2;
assign thre_int_rise2   = thre_int2 & ~thre_int_d2;
assign ms_int_rise2 	  = ms_int2 & ~ms_int_d2;
assign ti_int_rise2 	  = ti_int2 & ~ti_int_d2;

// interrupt2 pending flags2
reg 	rls_int_pnd2;
reg	rda_int_pnd2;
reg 	thre_int_pnd2;
reg 	ms_int_pnd2;
reg 	ti_int_pnd2;

// interrupt2 pending flags2 assignments2
always  @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) rls_int_pnd2 <= #1 0; 
	else 
		rls_int_pnd2 <= #1 lsr_mask2 ? 0 :  						// reset condition
							rls_int_rise2 ? 1 :						// latch2 condition
							rls_int_pnd2 && ier2[`UART_IE_RLS2];	// default operation2: remove if masked2

always  @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) rda_int_pnd2 <= #1 0; 
	else 
		rda_int_pnd2 <= #1 ((rf_count2 == {1'b0,trigger_level2}) && fifo_read2) ? 0 :  	// reset condition
							rda_int_rise2 ? 1 :						// latch2 condition
							rda_int_pnd2 && ier2[`UART_IE_RDA2];	// default operation2: remove if masked2

always  @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) thre_int_pnd2 <= #1 0; 
	else 
		thre_int_pnd2 <= #1 fifo_write2 || (iir_read2 & ~iir2[`UART_II_IP2] & iir2[`UART_II_II2] == `UART_II_THRE2)? 0 : 
							thre_int_rise2 ? 1 :
							thre_int_pnd2 && ier2[`UART_IE_THRE2];

always  @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) ms_int_pnd2 <= #1 0; 
	else 
		ms_int_pnd2 <= #1 msr_read2 ? 0 : 
							ms_int_rise2 ? 1 :
							ms_int_pnd2 && ier2[`UART_IE_MS2];

always  @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) ti_int_pnd2 <= #1 0; 
	else 
		ti_int_pnd2 <= #1 fifo_read2 ? 0 : 
							ti_int_rise2 ? 1 :
							ti_int_pnd2 && ier2[`UART_IE_RDA2];
// end of pending flags2

// INT_O2 logic
always @(posedge clk2 or posedge wb_rst_i2)
begin
	if (wb_rst_i2)	
		int_o2 <= #1 1'b0;
	else
		int_o2 <= #1 
					rls_int_pnd2		?	~lsr_mask2					:
					rda_int_pnd2		? 1								:
					ti_int_pnd2		? ~fifo_read2					:
					thre_int_pnd2	? !(fifo_write2 & iir_read2) :
					ms_int_pnd2		? ~msr_read2						:
					0;	// if no interrupt2 are pending
end


// Interrupt2 Identification2 register
always @(posedge clk2 or posedge wb_rst_i2)
begin
	if (wb_rst_i2)
		iir2 <= #1 1;
	else
	if (rls_int_pnd2)  // interrupt2 is pending
	begin
		iir2[`UART_II_II2] <= #1 `UART_II_RLS2;	// set identification2 register to correct2 value
		iir2[`UART_II_IP2] <= #1 1'b0;		// and clear the IIR2 bit 0 (interrupt2 pending)
	end else // the sequence of conditions2 determines2 priority of interrupt2 identification2
	if (rda_int2)
	begin
		iir2[`UART_II_II2] <= #1 `UART_II_RDA2;
		iir2[`UART_II_IP2] <= #1 1'b0;
	end
	else if (ti_int_pnd2)
	begin
		iir2[`UART_II_II2] <= #1 `UART_II_TI2;
		iir2[`UART_II_IP2] <= #1 1'b0;
	end
	else if (thre_int_pnd2)
	begin
		iir2[`UART_II_II2] <= #1 `UART_II_THRE2;
		iir2[`UART_II_IP2] <= #1 1'b0;
	end
	else if (ms_int_pnd2)
	begin
		iir2[`UART_II_II2] <= #1 `UART_II_MS2;
		iir2[`UART_II_IP2] <= #1 1'b0;
	end else	// no interrupt2 is pending
	begin
		iir2[`UART_II_II2] <= #1 0;
		iir2[`UART_II_IP2] <= #1 1'b1;
	end
end

endmodule
