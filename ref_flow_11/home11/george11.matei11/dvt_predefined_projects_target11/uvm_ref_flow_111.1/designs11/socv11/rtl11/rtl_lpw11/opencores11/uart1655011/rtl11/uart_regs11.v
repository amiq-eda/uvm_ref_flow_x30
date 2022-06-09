//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs11.v                                                 ////
////                                                              ////
////                                                              ////
////  This11 file is part of the "UART11 16550 compatible11" project11    ////
////  http11://www11.opencores11.org11/cores11/uart1655011/                   ////
////                                                              ////
////  Documentation11 related11 to this project11:                      ////
////  - http11://www11.opencores11.org11/cores11/uart1655011/                 ////
////                                                              ////
////  Projects11 compatibility11:                                     ////
////  - WISHBONE11                                                  ////
////  RS23211 Protocol11                                              ////
////  16550D uart11 (mostly11 supported)                              ////
////                                                              ////
////  Overview11 (main11 Features11):                                   ////
////  Registers11 of the uart11 16550 core11                            ////
////                                                              ////
////  Known11 problems11 (limits11):                                    ////
////  Inserts11 1 wait state in all WISHBONE11 transfers11              ////
////                                                              ////
////  To11 Do11:                                                      ////
////  Nothing or verification11.                                    ////
////                                                              ////
////  Author11(s):                                                  ////
////      - gorban11@opencores11.org11                                  ////
////      - Jacob11 Gorban11                                          ////
////      - Igor11 Mohor11 (igorm11@opencores11.org11)                      ////
////                                                              ////
////  Created11:        2001/05/12                                  ////
////  Last11 Updated11:   (See log11 for the revision11 history11           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2000, 2001 Authors11                             ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS11 Revision11 History11
//
// $Log: not supported by cvs2svn11 $
// Revision11 1.41  2004/05/21 11:44:41  tadejm11
// Added11 synchronizer11 flops11 for RX11 input.
//
// Revision11 1.40  2003/06/11 16:37:47  gorban11
// This11 fixes11 errors11 in some11 cases11 when data is being read and put to the FIFO at the same time. Patch11 is submitted11 by Scott11 Furman11. Update is very11 recommended11.
//
// Revision11 1.39  2002/07/29 21:16:18  gorban11
// The uart_defines11.v file is included11 again11 in sources11.
//
// Revision11 1.38  2002/07/22 23:02:23  gorban11
// Bug11 Fixes11:
//  * Possible11 loss of sync and bad11 reception11 of stop bit on slow11 baud11 rates11 fixed11.
//   Problem11 reported11 by Kenny11.Tung11.
//  * Bad (or lack11 of ) loopback11 handling11 fixed11. Reported11 by Cherry11 Withers11.
//
// Improvements11:
//  * Made11 FIFO's as general11 inferrable11 memory where possible11.
//  So11 on FPGA11 they should be inferred11 as RAM11 (Distributed11 RAM11 on Xilinx11).
//  This11 saves11 about11 1/3 of the Slice11 count and reduces11 P&R and synthesis11 times.
//
//  * Added11 optional11 baudrate11 output (baud_o11).
//  This11 is identical11 to BAUDOUT11* signal11 on 16550 chip11.
//  It outputs11 16xbit_clock_rate - the divided11 clock11.
//  It's disabled by default. Define11 UART_HAS_BAUDRATE_OUTPUT11 to use.
//
// Revision11 1.37  2001/12/27 13:24:09  mohor11
// lsr11[7] was not showing11 overrun11 errors11.
//
// Revision11 1.36  2001/12/20 13:25:46  mohor11
// rx11 push11 changed to be only one cycle wide11.
//
// Revision11 1.35  2001/12/19 08:03:34  mohor11
// Warnings11 cleared11.
//
// Revision11 1.34  2001/12/19 07:33:54  mohor11
// Synplicity11 was having11 troubles11 with the comment11.
//
// Revision11 1.33  2001/12/17 10:14:43  mohor11
// Things11 related11 to msr11 register changed. After11 THRE11 IRQ11 occurs11, and one
// character11 is written11 to the transmit11 fifo, the detection11 of the THRE11 bit in the
// LSR11 is delayed11 for one character11 time.
//
// Revision11 1.32  2001/12/14 13:19:24  mohor11
// MSR11 register fixed11.
//
// Revision11 1.31  2001/12/14 10:06:58  mohor11
// After11 reset modem11 status register MSR11 should be reset.
//
// Revision11 1.30  2001/12/13 10:09:13  mohor11
// thre11 irq11 should be cleared11 only when being source11 of interrupt11.
//
// Revision11 1.29  2001/12/12 09:05:46  mohor11
// LSR11 status bit 0 was not cleared11 correctly in case of reseting11 the FCR11 (rx11 fifo).
//
// Revision11 1.28  2001/12/10 19:52:41  gorban11
// Scratch11 register added
//
// Revision11 1.27  2001/12/06 14:51:04  gorban11
// Bug11 in LSR11[0] is fixed11.
// All WISHBONE11 signals11 are now sampled11, so another11 wait-state is introduced11 on all transfers11.
//
// Revision11 1.26  2001/12/03 21:44:29  gorban11
// Updated11 specification11 documentation.
// Added11 full 32-bit data bus interface, now as default.
// Address is 5-bit wide11 in 32-bit data bus mode.
// Added11 wb_sel_i11 input to the core11. It's used in the 32-bit mode.
// Added11 debug11 interface with two11 32-bit read-only registers in 32-bit mode.
// Bits11 5 and 6 of LSR11 are now only cleared11 on TX11 FIFO write.
// My11 small test bench11 is modified to work11 with 32-bit mode.
//
// Revision11 1.25  2001/11/28 19:36:39  gorban11
// Fixed11: timeout and break didn11't pay11 attention11 to current data format11 when counting11 time
//
// Revision11 1.24  2001/11/26 21:38:54  gorban11
// Lots11 of fixes11:
// Break11 condition wasn11't handled11 correctly at all.
// LSR11 bits could lose11 their11 values.
// LSR11 value after reset was wrong11.
// Timing11 of THRE11 interrupt11 signal11 corrected11.
// LSR11 bit 0 timing11 corrected11.
//
// Revision11 1.23  2001/11/12 21:57:29  gorban11
// fixed11 more typo11 bugs11
//
// Revision11 1.22  2001/11/12 15:02:28  mohor11
// lsr1r11 error fixed11.
//
// Revision11 1.21  2001/11/12 14:57:27  mohor11
// ti_int_pnd11 error fixed11.
//
// Revision11 1.20  2001/11/12 14:50:27  mohor11
// ti_int_d11 error fixed11.
//
// Revision11 1.19  2001/11/10 12:43:21  gorban11
// Logic11 Synthesis11 bugs11 fixed11. Some11 other minor11 changes11
//
// Revision11 1.18  2001/11/08 14:54:23  mohor11
// Comments11 in Slovene11 language11 deleted11, few11 small fixes11 for better11 work11 of
// old11 tools11. IRQs11 need to be fix11.
//
// Revision11 1.17  2001/11/07 17:51:52  gorban11
// Heavily11 rewritten11 interrupt11 and LSR11 subsystems11.
// Many11 bugs11 hopefully11 squashed11.
//
// Revision11 1.16  2001/11/02 09:55:16  mohor11
// no message
//
// Revision11 1.15  2001/10/31 15:19:22  gorban11
// Fixes11 to break and timeout conditions11
//
// Revision11 1.14  2001/10/29 17:00:46  gorban11
// fixed11 parity11 sending11 and tx_fifo11 resets11 over- and underrun11
//
// Revision11 1.13  2001/10/20 09:58:40  gorban11
// Small11 synopsis11 fixes11
//
// Revision11 1.12  2001/10/19 16:21:40  gorban11
// Changes11 data_out11 to be synchronous11 again11 as it should have been.
//
// Revision11 1.11  2001/10/18 20:35:45  gorban11
// small fix11
//
// Revision11 1.10  2001/08/24 21:01:12  mohor11
// Things11 connected11 to parity11 changed.
// Clock11 devider11 changed.
//
// Revision11 1.9  2001/08/23 16:05:05  mohor11
// Stop bit bug11 fixed11.
// Parity11 bug11 fixed11.
// WISHBONE11 read cycle bug11 fixed11,
// OE11 indicator11 (Overrun11 Error) bug11 fixed11.
// PE11 indicator11 (Parity11 Error) bug11 fixed11.
// Register read bug11 fixed11.
//
// Revision11 1.10  2001/06/23 11:21:48  gorban11
// DL11 made11 16-bit long11. Fixed11 transmission11/reception11 bugs11.
//
// Revision11 1.9  2001/05/31 20:08:01  gorban11
// FIFO changes11 and other corrections11.
//
// Revision11 1.8  2001/05/29 20:05:04  gorban11
// Fixed11 some11 bugs11 and synthesis11 problems11.
//
// Revision11 1.7  2001/05/27 17:37:49  gorban11
// Fixed11 many11 bugs11. Updated11 spec11. Changed11 FIFO files structure11. See CHANGES11.txt11 file.
//
// Revision11 1.6  2001/05/21 19:12:02  gorban11
// Corrected11 some11 Linter11 messages11.
//
// Revision11 1.5  2001/05/17 18:34:18  gorban11
// First11 'stable' release. Should11 be sythesizable11 now. Also11 added new header.
//
// Revision11 1.0  2001-05-17 21:27:11+02  jacob11
// Initial11 revision11
//
//

// synopsys11 translate_off11
`include "timescale.v"
// synopsys11 translate_on11

`include "uart_defines11.v"

`define UART_DL111 7:0
`define UART_DL211 15:8

module uart_regs11 (clk11,
	wb_rst_i11, wb_addr_i11, wb_dat_i11, wb_dat_o11, wb_we_i11, wb_re_i11, 

// additional11 signals11
	modem_inputs11,
	stx_pad_o11, srx_pad_i11,

`ifdef DATA_BUS_WIDTH_811
`else
// debug11 interface signals11	enabled
ier11, iir11, fcr11, mcr11, lcr11, msr11, lsr11, rf_count11, tf_count11, tstate11, rstate,
`endif				
	rts_pad_o11, dtr_pad_o11, int_o11
`ifdef UART_HAS_BAUDRATE_OUTPUT11
	, baud_o11
`endif

	);

input 									clk11;
input 									wb_rst_i11;
input [`UART_ADDR_WIDTH11-1:0] 		wb_addr_i11;
input [7:0] 							wb_dat_i11;
output [7:0] 							wb_dat_o11;
input 									wb_we_i11;
input 									wb_re_i11;

output 									stx_pad_o11;
input 									srx_pad_i11;

input [3:0] 							modem_inputs11;
output 									rts_pad_o11;
output 									dtr_pad_o11;
output 									int_o11;
`ifdef UART_HAS_BAUDRATE_OUTPUT11
output	baud_o11;
`endif

`ifdef DATA_BUS_WIDTH_811
`else
// if 32-bit databus11 and debug11 interface are enabled
output [3:0]							ier11;
output [3:0]							iir11;
output [1:0]							fcr11;  /// bits 7 and 6 of fcr11. Other11 bits are ignored
output [4:0]							mcr11;
output [7:0]							lcr11;
output [7:0]							msr11;
output [7:0] 							lsr11;
output [`UART_FIFO_COUNTER_W11-1:0] 	rf_count11;
output [`UART_FIFO_COUNTER_W11-1:0] 	tf_count11;
output [2:0] 							tstate11;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs11;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT11
assign baud_o11 = enable; // baud_o11 is actually11 the enable signal11
`endif


wire 										stx_pad_o11;		// received11 from transmitter11 module
wire 										srx_pad_i11;
wire 										srx_pad11;

reg [7:0] 								wb_dat_o11;

wire [`UART_ADDR_WIDTH11-1:0] 		wb_addr_i11;
wire [7:0] 								wb_dat_i11;


reg [3:0] 								ier11;
reg [3:0] 								iir11;
reg [1:0] 								fcr11;  /// bits 7 and 6 of fcr11. Other11 bits are ignored
reg [4:0] 								mcr11;
reg [7:0] 								lcr11;
reg [7:0] 								msr11;
reg [15:0] 								dl11;  // 32-bit divisor11 latch11
reg [7:0] 								scratch11; // UART11 scratch11 register
reg 										start_dlc11; // activate11 dlc11 on writing to UART_DL111
reg 										lsr_mask_d11; // delay for lsr_mask11 condition
reg 										msi_reset11; // reset MSR11 4 lower11 bits indicator11
//reg 										threi_clear11; // THRE11 interrupt11 clear flag11
reg [15:0] 								dlc11;  // 32-bit divisor11 latch11 counter
reg 										int_o11;

reg [3:0] 								trigger_level11; // trigger level of the receiver11 FIFO
reg 										rx_reset11;
reg 										tx_reset11;

wire 										dlab11;			   // divisor11 latch11 access bit
wire 										cts_pad_i11, dsr_pad_i11, ri_pad_i11, dcd_pad_i11; // modem11 status bits
wire 										loopback11;		   // loopback11 bit (MCR11 bit 4)
wire 										cts11, dsr11, ri, dcd11;	   // effective11 signals11
wire                    cts_c11, dsr_c11, ri_c11, dcd_c11; // Complement11 effective11 signals11 (considering11 loopback11)
wire 										rts_pad_o11, dtr_pad_o11;		   // modem11 control11 outputs11

// LSR11 bits wires11 and regs
wire [7:0] 								lsr11;
wire 										lsr011, lsr111, lsr211, lsr311, lsr411, lsr511, lsr611, lsr711;
reg										lsr0r11, lsr1r11, lsr2r11, lsr3r11, lsr4r11, lsr5r11, lsr6r11, lsr7r11;
wire 										lsr_mask11; // lsr_mask11

//
// ASSINGS11
//

assign 									lsr11[7:0] = { lsr7r11, lsr6r11, lsr5r11, lsr4r11, lsr3r11, lsr2r11, lsr1r11, lsr0r11 };

assign 									{cts_pad_i11, dsr_pad_i11, ri_pad_i11, dcd_pad_i11} = modem_inputs11;
assign 									{cts11, dsr11, ri, dcd11} = ~{cts_pad_i11,dsr_pad_i11,ri_pad_i11,dcd_pad_i11};

assign                  {cts_c11, dsr_c11, ri_c11, dcd_c11} = loopback11 ? {mcr11[`UART_MC_RTS11],mcr11[`UART_MC_DTR11],mcr11[`UART_MC_OUT111],mcr11[`UART_MC_OUT211]}
                                                               : {cts_pad_i11,dsr_pad_i11,ri_pad_i11,dcd_pad_i11};

assign 									dlab11 = lcr11[`UART_LC_DL11];
assign 									loopback11 = mcr11[4];

// assign modem11 outputs11
assign 									rts_pad_o11 = mcr11[`UART_MC_RTS11];
assign 									dtr_pad_o11 = mcr11[`UART_MC_DTR11];

// Interrupt11 signals11
wire 										rls_int11;  // receiver11 line status interrupt11
wire 										rda_int11;  // receiver11 data available interrupt11
wire 										ti_int11;   // timeout indicator11 interrupt11
wire										thre_int11; // transmitter11 holding11 register empty11 interrupt11
wire 										ms_int11;   // modem11 status interrupt11

// FIFO signals11
reg 										tf_push11;
reg 										rf_pop11;
wire [`UART_FIFO_REC_WIDTH11-1:0] 	rf_data_out11;
wire 										rf_error_bit11; // an error (parity11 or framing11) is inside the fifo
wire [`UART_FIFO_COUNTER_W11-1:0] 	rf_count11;
wire [`UART_FIFO_COUNTER_W11-1:0] 	tf_count11;
wire [2:0] 								tstate11;
wire [3:0] 								rstate;
wire [9:0] 								counter_t11;

wire                      thre_set_en11; // THRE11 status is delayed11 one character11 time when a character11 is written11 to fifo.
reg  [7:0]                block_cnt11;   // While11 counter counts11, THRE11 status is blocked11 (delayed11 one character11 cycle)
reg  [7:0]                block_value11; // One11 character11 length minus11 stop bit

// Transmitter11 Instance
wire serial_out11;

uart_transmitter11 transmitter11(clk11, wb_rst_i11, lcr11, tf_push11, wb_dat_i11, enable, serial_out11, tstate11, tf_count11, tx_reset11, lsr_mask11);

  // Synchronizing11 and sampling11 serial11 RX11 input
  uart_sync_flops11    i_uart_sync_flops11
  (
    .rst_i11           (wb_rst_i11),
    .clk_i11           (clk11),
    .stage1_rst_i11    (1'b0),
    .stage1_clk_en_i11 (1'b1),
    .async_dat_i11     (srx_pad_i11),
    .sync_dat_o11      (srx_pad11)
  );
  defparam i_uart_sync_flops11.width      = 1;
  defparam i_uart_sync_flops11.init_value11 = 1'b1;

// handle loopback11
wire serial_in11 = loopback11 ? serial_out11 : srx_pad11;
assign stx_pad_o11 = loopback11 ? 1'b1 : serial_out11;

// Receiver11 Instance
uart_receiver11 receiver11(clk11, wb_rst_i11, lcr11, rf_pop11, serial_in11, enable, 
	counter_t11, rf_count11, rf_data_out11, rf_error_bit11, rf_overrun11, rx_reset11, lsr_mask11, rstate, rf_push_pulse11);


// Asynchronous11 reading here11 because the outputs11 are sampled11 in uart_wb11.v file 
always @(dl11 or dlab11 or ier11 or iir11 or scratch11
			or lcr11 or lsr11 or msr11 or rf_data_out11 or wb_addr_i11 or wb_re_i11)   // asynchrounous11 reading
begin
	case (wb_addr_i11)
		`UART_REG_RB11   : wb_dat_o11 = dlab11 ? dl11[`UART_DL111] : rf_data_out11[10:3];
		`UART_REG_IE11	: wb_dat_o11 = dlab11 ? dl11[`UART_DL211] : ier11;
		`UART_REG_II11	: wb_dat_o11 = {4'b1100,iir11};
		`UART_REG_LC11	: wb_dat_o11 = lcr11;
		`UART_REG_LS11	: wb_dat_o11 = lsr11;
		`UART_REG_MS11	: wb_dat_o11 = msr11;
		`UART_REG_SR11	: wb_dat_o11 = scratch11;
		default:  wb_dat_o11 = 8'b0; // ??
	endcase // case(wb_addr_i11)
end // always @ (dl11 or dlab11 or ier11 or iir11 or scratch11...


// rf_pop11 signal11 handling11
always @(posedge clk11 or posedge wb_rst_i11)
begin
	if (wb_rst_i11)
		rf_pop11 <= #1 0; 
	else
	if (rf_pop11)	// restore11 the signal11 to 0 after one clock11 cycle
		rf_pop11 <= #1 0;
	else
	if (wb_re_i11 && wb_addr_i11 == `UART_REG_RB11 && !dlab11)
		rf_pop11 <= #1 1; // advance11 read pointer11
end

wire 	lsr_mask_condition11;
wire 	iir_read11;
wire  msr_read11;
wire	fifo_read11;
wire	fifo_write11;

assign lsr_mask_condition11 = (wb_re_i11 && wb_addr_i11 == `UART_REG_LS11 && !dlab11);
assign iir_read11 = (wb_re_i11 && wb_addr_i11 == `UART_REG_II11 && !dlab11);
assign msr_read11 = (wb_re_i11 && wb_addr_i11 == `UART_REG_MS11 && !dlab11);
assign fifo_read11 = (wb_re_i11 && wb_addr_i11 == `UART_REG_RB11 && !dlab11);
assign fifo_write11 = (wb_we_i11 && wb_addr_i11 == `UART_REG_TR11 && !dlab11);

// lsr_mask_d11 delayed11 signal11 handling11
always @(posedge clk11 or posedge wb_rst_i11)
begin
	if (wb_rst_i11)
		lsr_mask_d11 <= #1 0;
	else // reset bits in the Line11 Status Register
		lsr_mask_d11 <= #1 lsr_mask_condition11;
end

// lsr_mask11 is rise11 detected
assign lsr_mask11 = lsr_mask_condition11 && ~lsr_mask_d11;

// msi_reset11 signal11 handling11
always @(posedge clk11 or posedge wb_rst_i11)
begin
	if (wb_rst_i11)
		msi_reset11 <= #1 1;
	else
	if (msi_reset11)
		msi_reset11 <= #1 0;
	else
	if (msr_read11)
		msi_reset11 <= #1 1; // reset bits in Modem11 Status Register
end


//
//   WRITES11 AND11 RESETS11   //
//
// Line11 Control11 Register
always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11)
		lcr11 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i11 && wb_addr_i11==`UART_REG_LC11)
		lcr11 <= #1 wb_dat_i11;

// Interrupt11 Enable11 Register or UART_DL211
always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11)
	begin
		ier11 <= #1 4'b0000; // no interrupts11 after reset
		dl11[`UART_DL211] <= #1 8'b0;
	end
	else
	if (wb_we_i11 && wb_addr_i11==`UART_REG_IE11)
		if (dlab11)
		begin
			dl11[`UART_DL211] <= #1 wb_dat_i11;
		end
		else
			ier11 <= #1 wb_dat_i11[3:0]; // ier11 uses only 4 lsb


// FIFO Control11 Register and rx_reset11, tx_reset11 signals11
always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) begin
		fcr11 <= #1 2'b11; 
		rx_reset11 <= #1 0;
		tx_reset11 <= #1 0;
	end else
	if (wb_we_i11 && wb_addr_i11==`UART_REG_FC11) begin
		fcr11 <= #1 wb_dat_i11[7:6];
		rx_reset11 <= #1 wb_dat_i11[1];
		tx_reset11 <= #1 wb_dat_i11[2];
	end else begin
		rx_reset11 <= #1 0;
		tx_reset11 <= #1 0;
	end

// Modem11 Control11 Register
always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11)
		mcr11 <= #1 5'b0; 
	else
	if (wb_we_i11 && wb_addr_i11==`UART_REG_MC11)
			mcr11 <= #1 wb_dat_i11[4:0];

// Scratch11 register
// Line11 Control11 Register
always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11)
		scratch11 <= #1 0; // 8n1 setting
	else
	if (wb_we_i11 && wb_addr_i11==`UART_REG_SR11)
		scratch11 <= #1 wb_dat_i11;

// TX_FIFO11 or UART_DL111
always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11)
	begin
		dl11[`UART_DL111]  <= #1 8'b0;
		tf_push11   <= #1 1'b0;
		start_dlc11 <= #1 1'b0;
	end
	else
	if (wb_we_i11 && wb_addr_i11==`UART_REG_TR11)
		if (dlab11)
		begin
			dl11[`UART_DL111] <= #1 wb_dat_i11;
			start_dlc11 <= #1 1'b1; // enable DL11 counter
			tf_push11 <= #1 1'b0;
		end
		else
		begin
			tf_push11   <= #1 1'b1;
			start_dlc11 <= #1 1'b0;
		end // else: !if(dlab11)
	else
	begin
		start_dlc11 <= #1 1'b0;
		tf_push11   <= #1 1'b0;
	end // else: !if(dlab11)

// Receiver11 FIFO trigger level selection logic (asynchronous11 mux11)
always @(fcr11)
	case (fcr11[`UART_FC_TL11])
		2'b00 : trigger_level11 = 1;
		2'b01 : trigger_level11 = 4;
		2'b10 : trigger_level11 = 8;
		2'b11 : trigger_level11 = 14;
	endcase // case(fcr11[`UART_FC_TL11])
	
//
//  STATUS11 REGISTERS11  //
//

// Modem11 Status Register
reg [3:0] delayed_modem_signals11;
always @(posedge clk11 or posedge wb_rst_i11)
begin
	if (wb_rst_i11)
	  begin
  		msr11 <= #1 0;
	  	delayed_modem_signals11[3:0] <= #1 0;
	  end
	else begin
		msr11[`UART_MS_DDCD11:`UART_MS_DCTS11] <= #1 msi_reset11 ? 4'b0 :
			msr11[`UART_MS_DDCD11:`UART_MS_DCTS11] | ({dcd11, ri, dsr11, cts11} ^ delayed_modem_signals11[3:0]);
		msr11[`UART_MS_CDCD11:`UART_MS_CCTS11] <= #1 {dcd_c11, ri_c11, dsr_c11, cts_c11};
		delayed_modem_signals11[3:0] <= #1 {dcd11, ri, dsr11, cts11};
	end
end


// Line11 Status Register

// activation11 conditions11
assign lsr011 = (rf_count11==0 && rf_push_pulse11);  // data in receiver11 fifo available set condition
assign lsr111 = rf_overrun11;     // Receiver11 overrun11 error
assign lsr211 = rf_data_out11[1]; // parity11 error bit
assign lsr311 = rf_data_out11[0]; // framing11 error bit
assign lsr411 = rf_data_out11[2]; // break error in the character11
assign lsr511 = (tf_count11==5'b0 && thre_set_en11);  // transmitter11 fifo is empty11
assign lsr611 = (tf_count11==5'b0 && thre_set_en11 && (tstate11 == /*`S_IDLE11 */ 0)); // transmitter11 empty11
assign lsr711 = rf_error_bit11 | rf_overrun11;

// lsr11 bit011 (receiver11 data available)
reg 	 lsr0_d11;

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr0_d11 <= #1 0;
	else lsr0_d11 <= #1 lsr011;

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr0r11 <= #1 0;
	else lsr0r11 <= #1 (rf_count11==1 && rf_pop11 && !rf_push_pulse11 || rx_reset11) ? 0 : // deassert11 condition
					  lsr0r11 || (lsr011 && ~lsr0_d11); // set on rise11 of lsr011 and keep11 asserted11 until deasserted11 

// lsr11 bit 1 (receiver11 overrun11)
reg lsr1_d11; // delayed11

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr1_d11 <= #1 0;
	else lsr1_d11 <= #1 lsr111;

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr1r11 <= #1 0;
	else	lsr1r11 <= #1	lsr_mask11 ? 0 : lsr1r11 || (lsr111 && ~lsr1_d11); // set on rise11

// lsr11 bit 2 (parity11 error)
reg lsr2_d11; // delayed11

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr2_d11 <= #1 0;
	else lsr2_d11 <= #1 lsr211;

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr2r11 <= #1 0;
	else lsr2r11 <= #1 lsr_mask11 ? 0 : lsr2r11 || (lsr211 && ~lsr2_d11); // set on rise11

// lsr11 bit 3 (framing11 error)
reg lsr3_d11; // delayed11

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr3_d11 <= #1 0;
	else lsr3_d11 <= #1 lsr311;

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr3r11 <= #1 0;
	else lsr3r11 <= #1 lsr_mask11 ? 0 : lsr3r11 || (lsr311 && ~lsr3_d11); // set on rise11

// lsr11 bit 4 (break indicator11)
reg lsr4_d11; // delayed11

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr4_d11 <= #1 0;
	else lsr4_d11 <= #1 lsr411;

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr4r11 <= #1 0;
	else lsr4r11 <= #1 lsr_mask11 ? 0 : lsr4r11 || (lsr411 && ~lsr4_d11);

// lsr11 bit 5 (transmitter11 fifo is empty11)
reg lsr5_d11;

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr5_d11 <= #1 1;
	else lsr5_d11 <= #1 lsr511;

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr5r11 <= #1 1;
	else lsr5r11 <= #1 (fifo_write11) ? 0 :  lsr5r11 || (lsr511 && ~lsr5_d11);

// lsr11 bit 6 (transmitter11 empty11 indicator11)
reg lsr6_d11;

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr6_d11 <= #1 1;
	else lsr6_d11 <= #1 lsr611;

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr6r11 <= #1 1;
	else lsr6r11 <= #1 (fifo_write11) ? 0 : lsr6r11 || (lsr611 && ~lsr6_d11);

// lsr11 bit 7 (error in fifo)
reg lsr7_d11;

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr7_d11 <= #1 0;
	else lsr7_d11 <= #1 lsr711;

always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) lsr7r11 <= #1 0;
	else lsr7r11 <= #1 lsr_mask11 ? 0 : lsr7r11 || (lsr711 && ~lsr7_d11);

// Frequency11 divider11
always @(posedge clk11 or posedge wb_rst_i11) 
begin
	if (wb_rst_i11)
		dlc11 <= #1 0;
	else
		if (start_dlc11 | ~ (|dlc11))
  			dlc11 <= #1 dl11 - 1;               // preset11 counter
		else
			dlc11 <= #1 dlc11 - 1;              // decrement counter
end

// Enable11 signal11 generation11 logic
always @(posedge clk11 or posedge wb_rst_i11)
begin
	if (wb_rst_i11)
		enable <= #1 1'b0;
	else
		if (|dl11 & ~(|dlc11))     // dl11>0 & dlc11==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying11 THRE11 status for one character11 cycle after a character11 is written11 to an empty11 fifo.
always @(lcr11)
  case (lcr11[3:0])
    4'b0000                             : block_value11 =  95; // 6 bits
    4'b0100                             : block_value11 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value11 = 111; // 7 bits
    4'b1100                             : block_value11 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value11 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value11 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value11 = 159; // 10 bits
    4'b1111                             : block_value11 = 175; // 11 bits
  endcase // case(lcr11[3:0])

// Counting11 time of one character11 minus11 stop bit
always @(posedge clk11 or posedge wb_rst_i11)
begin
  if (wb_rst_i11)
    block_cnt11 <= #1 8'd0;
  else
  if(lsr5r11 & fifo_write11)  // THRE11 bit set & write to fifo occured11
    block_cnt11 <= #1 block_value11;
  else
  if (enable & block_cnt11 != 8'b0)  // only work11 on enable times
    block_cnt11 <= #1 block_cnt11 - 1;  // decrement break counter
end // always of break condition detection11

// Generating11 THRE11 status enable signal11
assign thre_set_en11 = ~(|block_cnt11);


//
//	INTERRUPT11 LOGIC11
//

assign rls_int11  = ier11[`UART_IE_RLS11] && (lsr11[`UART_LS_OE11] || lsr11[`UART_LS_PE11] || lsr11[`UART_LS_FE11] || lsr11[`UART_LS_BI11]);
assign rda_int11  = ier11[`UART_IE_RDA11] && (rf_count11 >= {1'b0,trigger_level11});
assign thre_int11 = ier11[`UART_IE_THRE11] && lsr11[`UART_LS_TFE11];
assign ms_int11   = ier11[`UART_IE_MS11] && (| msr11[3:0]);
assign ti_int11   = ier11[`UART_IE_RDA11] && (counter_t11 == 10'b0) && (|rf_count11);

reg 	 rls_int_d11;
reg 	 thre_int_d11;
reg 	 ms_int_d11;
reg 	 ti_int_d11;
reg 	 rda_int_d11;

// delay lines11
always  @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) rls_int_d11 <= #1 0;
	else rls_int_d11 <= #1 rls_int11;

always  @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) rda_int_d11 <= #1 0;
	else rda_int_d11 <= #1 rda_int11;

always  @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) thre_int_d11 <= #1 0;
	else thre_int_d11 <= #1 thre_int11;

always  @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) ms_int_d11 <= #1 0;
	else ms_int_d11 <= #1 ms_int11;

always  @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) ti_int_d11 <= #1 0;
	else ti_int_d11 <= #1 ti_int11;

// rise11 detection11 signals11

wire 	 rls_int_rise11;
wire 	 thre_int_rise11;
wire 	 ms_int_rise11;
wire 	 ti_int_rise11;
wire 	 rda_int_rise11;

assign rda_int_rise11    = rda_int11 & ~rda_int_d11;
assign rls_int_rise11 	  = rls_int11 & ~rls_int_d11;
assign thre_int_rise11   = thre_int11 & ~thre_int_d11;
assign ms_int_rise11 	  = ms_int11 & ~ms_int_d11;
assign ti_int_rise11 	  = ti_int11 & ~ti_int_d11;

// interrupt11 pending flags11
reg 	rls_int_pnd11;
reg	rda_int_pnd11;
reg 	thre_int_pnd11;
reg 	ms_int_pnd11;
reg 	ti_int_pnd11;

// interrupt11 pending flags11 assignments11
always  @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) rls_int_pnd11 <= #1 0; 
	else 
		rls_int_pnd11 <= #1 lsr_mask11 ? 0 :  						// reset condition
							rls_int_rise11 ? 1 :						// latch11 condition
							rls_int_pnd11 && ier11[`UART_IE_RLS11];	// default operation11: remove if masked11

always  @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) rda_int_pnd11 <= #1 0; 
	else 
		rda_int_pnd11 <= #1 ((rf_count11 == {1'b0,trigger_level11}) && fifo_read11) ? 0 :  	// reset condition
							rda_int_rise11 ? 1 :						// latch11 condition
							rda_int_pnd11 && ier11[`UART_IE_RDA11];	// default operation11: remove if masked11

always  @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) thre_int_pnd11 <= #1 0; 
	else 
		thre_int_pnd11 <= #1 fifo_write11 || (iir_read11 & ~iir11[`UART_II_IP11] & iir11[`UART_II_II11] == `UART_II_THRE11)? 0 : 
							thre_int_rise11 ? 1 :
							thre_int_pnd11 && ier11[`UART_IE_THRE11];

always  @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) ms_int_pnd11 <= #1 0; 
	else 
		ms_int_pnd11 <= #1 msr_read11 ? 0 : 
							ms_int_rise11 ? 1 :
							ms_int_pnd11 && ier11[`UART_IE_MS11];

always  @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) ti_int_pnd11 <= #1 0; 
	else 
		ti_int_pnd11 <= #1 fifo_read11 ? 0 : 
							ti_int_rise11 ? 1 :
							ti_int_pnd11 && ier11[`UART_IE_RDA11];
// end of pending flags11

// INT_O11 logic
always @(posedge clk11 or posedge wb_rst_i11)
begin
	if (wb_rst_i11)	
		int_o11 <= #1 1'b0;
	else
		int_o11 <= #1 
					rls_int_pnd11		?	~lsr_mask11					:
					rda_int_pnd11		? 1								:
					ti_int_pnd11		? ~fifo_read11					:
					thre_int_pnd11	? !(fifo_write11 & iir_read11) :
					ms_int_pnd11		? ~msr_read11						:
					0;	// if no interrupt11 are pending
end


// Interrupt11 Identification11 register
always @(posedge clk11 or posedge wb_rst_i11)
begin
	if (wb_rst_i11)
		iir11 <= #1 1;
	else
	if (rls_int_pnd11)  // interrupt11 is pending
	begin
		iir11[`UART_II_II11] <= #1 `UART_II_RLS11;	// set identification11 register to correct11 value
		iir11[`UART_II_IP11] <= #1 1'b0;		// and clear the IIR11 bit 0 (interrupt11 pending)
	end else // the sequence of conditions11 determines11 priority of interrupt11 identification11
	if (rda_int11)
	begin
		iir11[`UART_II_II11] <= #1 `UART_II_RDA11;
		iir11[`UART_II_IP11] <= #1 1'b0;
	end
	else if (ti_int_pnd11)
	begin
		iir11[`UART_II_II11] <= #1 `UART_II_TI11;
		iir11[`UART_II_IP11] <= #1 1'b0;
	end
	else if (thre_int_pnd11)
	begin
		iir11[`UART_II_II11] <= #1 `UART_II_THRE11;
		iir11[`UART_II_IP11] <= #1 1'b0;
	end
	else if (ms_int_pnd11)
	begin
		iir11[`UART_II_II11] <= #1 `UART_II_MS11;
		iir11[`UART_II_IP11] <= #1 1'b0;
	end else	// no interrupt11 is pending
	begin
		iir11[`UART_II_II11] <= #1 0;
		iir11[`UART_II_IP11] <= #1 1'b1;
	end
end

endmodule
