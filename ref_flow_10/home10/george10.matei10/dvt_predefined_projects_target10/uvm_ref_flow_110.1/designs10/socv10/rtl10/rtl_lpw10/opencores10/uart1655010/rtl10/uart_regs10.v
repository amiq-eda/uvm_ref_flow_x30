//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs10.v                                                 ////
////                                                              ////
////                                                              ////
////  This10 file is part of the "UART10 16550 compatible10" project10    ////
////  http10://www10.opencores10.org10/cores10/uart1655010/                   ////
////                                                              ////
////  Documentation10 related10 to this project10:                      ////
////  - http10://www10.opencores10.org10/cores10/uart1655010/                 ////
////                                                              ////
////  Projects10 compatibility10:                                     ////
////  - WISHBONE10                                                  ////
////  RS23210 Protocol10                                              ////
////  16550D uart10 (mostly10 supported)                              ////
////                                                              ////
////  Overview10 (main10 Features10):                                   ////
////  Registers10 of the uart10 16550 core10                            ////
////                                                              ////
////  Known10 problems10 (limits10):                                    ////
////  Inserts10 1 wait state in all WISHBONE10 transfers10              ////
////                                                              ////
////  To10 Do10:                                                      ////
////  Nothing or verification10.                                    ////
////                                                              ////
////  Author10(s):                                                  ////
////      - gorban10@opencores10.org10                                  ////
////      - Jacob10 Gorban10                                          ////
////      - Igor10 Mohor10 (igorm10@opencores10.org10)                      ////
////                                                              ////
////  Created10:        2001/05/12                                  ////
////  Last10 Updated10:   (See log10 for the revision10 history10           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright10 (C) 2000, 2001 Authors10                             ////
////                                                              ////
//// This10 source10 file may be used and distributed10 without         ////
//// restriction10 provided that this copyright10 statement10 is not    ////
//// removed from the file and that any derivative10 work10 contains10  ////
//// the original copyright10 notice10 and the associated disclaimer10. ////
////                                                              ////
//// This10 source10 file is free software10; you can redistribute10 it   ////
//// and/or modify it under the terms10 of the GNU10 Lesser10 General10   ////
//// Public10 License10 as published10 by the Free10 Software10 Foundation10; ////
//// either10 version10 2.1 of the License10, or (at your10 option) any   ////
//// later10 version10.                                               ////
////                                                              ////
//// This10 source10 is distributed10 in the hope10 that it will be       ////
//// useful10, but WITHOUT10 ANY10 WARRANTY10; without even10 the implied10   ////
//// warranty10 of MERCHANTABILITY10 or FITNESS10 FOR10 A PARTICULAR10      ////
//// PURPOSE10.  See the GNU10 Lesser10 General10 Public10 License10 for more ////
//// details10.                                                     ////
////                                                              ////
//// You should have received10 a copy of the GNU10 Lesser10 General10    ////
//// Public10 License10 along10 with this source10; if not, download10 it   ////
//// from http10://www10.opencores10.org10/lgpl10.shtml10                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS10 Revision10 History10
//
// $Log: not supported by cvs2svn10 $
// Revision10 1.41  2004/05/21 11:44:41  tadejm10
// Added10 synchronizer10 flops10 for RX10 input.
//
// Revision10 1.40  2003/06/11 16:37:47  gorban10
// This10 fixes10 errors10 in some10 cases10 when data is being read and put to the FIFO at the same time. Patch10 is submitted10 by Scott10 Furman10. Update is very10 recommended10.
//
// Revision10 1.39  2002/07/29 21:16:18  gorban10
// The uart_defines10.v file is included10 again10 in sources10.
//
// Revision10 1.38  2002/07/22 23:02:23  gorban10
// Bug10 Fixes10:
//  * Possible10 loss of sync and bad10 reception10 of stop bit on slow10 baud10 rates10 fixed10.
//   Problem10 reported10 by Kenny10.Tung10.
//  * Bad (or lack10 of ) loopback10 handling10 fixed10. Reported10 by Cherry10 Withers10.
//
// Improvements10:
//  * Made10 FIFO's as general10 inferrable10 memory where possible10.
//  So10 on FPGA10 they should be inferred10 as RAM10 (Distributed10 RAM10 on Xilinx10).
//  This10 saves10 about10 1/3 of the Slice10 count and reduces10 P&R and synthesis10 times.
//
//  * Added10 optional10 baudrate10 output (baud_o10).
//  This10 is identical10 to BAUDOUT10* signal10 on 16550 chip10.
//  It outputs10 16xbit_clock_rate - the divided10 clock10.
//  It's disabled by default. Define10 UART_HAS_BAUDRATE_OUTPUT10 to use.
//
// Revision10 1.37  2001/12/27 13:24:09  mohor10
// lsr10[7] was not showing10 overrun10 errors10.
//
// Revision10 1.36  2001/12/20 13:25:46  mohor10
// rx10 push10 changed to be only one cycle wide10.
//
// Revision10 1.35  2001/12/19 08:03:34  mohor10
// Warnings10 cleared10.
//
// Revision10 1.34  2001/12/19 07:33:54  mohor10
// Synplicity10 was having10 troubles10 with the comment10.
//
// Revision10 1.33  2001/12/17 10:14:43  mohor10
// Things10 related10 to msr10 register changed. After10 THRE10 IRQ10 occurs10, and one
// character10 is written10 to the transmit10 fifo, the detection10 of the THRE10 bit in the
// LSR10 is delayed10 for one character10 time.
//
// Revision10 1.32  2001/12/14 13:19:24  mohor10
// MSR10 register fixed10.
//
// Revision10 1.31  2001/12/14 10:06:58  mohor10
// After10 reset modem10 status register MSR10 should be reset.
//
// Revision10 1.30  2001/12/13 10:09:13  mohor10
// thre10 irq10 should be cleared10 only when being source10 of interrupt10.
//
// Revision10 1.29  2001/12/12 09:05:46  mohor10
// LSR10 status bit 0 was not cleared10 correctly in case of reseting10 the FCR10 (rx10 fifo).
//
// Revision10 1.28  2001/12/10 19:52:41  gorban10
// Scratch10 register added
//
// Revision10 1.27  2001/12/06 14:51:04  gorban10
// Bug10 in LSR10[0] is fixed10.
// All WISHBONE10 signals10 are now sampled10, so another10 wait-state is introduced10 on all transfers10.
//
// Revision10 1.26  2001/12/03 21:44:29  gorban10
// Updated10 specification10 documentation.
// Added10 full 32-bit data bus interface, now as default.
// Address is 5-bit wide10 in 32-bit data bus mode.
// Added10 wb_sel_i10 input to the core10. It's used in the 32-bit mode.
// Added10 debug10 interface with two10 32-bit read-only registers in 32-bit mode.
// Bits10 5 and 6 of LSR10 are now only cleared10 on TX10 FIFO write.
// My10 small test bench10 is modified to work10 with 32-bit mode.
//
// Revision10 1.25  2001/11/28 19:36:39  gorban10
// Fixed10: timeout and break didn10't pay10 attention10 to current data format10 when counting10 time
//
// Revision10 1.24  2001/11/26 21:38:54  gorban10
// Lots10 of fixes10:
// Break10 condition wasn10't handled10 correctly at all.
// LSR10 bits could lose10 their10 values.
// LSR10 value after reset was wrong10.
// Timing10 of THRE10 interrupt10 signal10 corrected10.
// LSR10 bit 0 timing10 corrected10.
//
// Revision10 1.23  2001/11/12 21:57:29  gorban10
// fixed10 more typo10 bugs10
//
// Revision10 1.22  2001/11/12 15:02:28  mohor10
// lsr1r10 error fixed10.
//
// Revision10 1.21  2001/11/12 14:57:27  mohor10
// ti_int_pnd10 error fixed10.
//
// Revision10 1.20  2001/11/12 14:50:27  mohor10
// ti_int_d10 error fixed10.
//
// Revision10 1.19  2001/11/10 12:43:21  gorban10
// Logic10 Synthesis10 bugs10 fixed10. Some10 other minor10 changes10
//
// Revision10 1.18  2001/11/08 14:54:23  mohor10
// Comments10 in Slovene10 language10 deleted10, few10 small fixes10 for better10 work10 of
// old10 tools10. IRQs10 need to be fix10.
//
// Revision10 1.17  2001/11/07 17:51:52  gorban10
// Heavily10 rewritten10 interrupt10 and LSR10 subsystems10.
// Many10 bugs10 hopefully10 squashed10.
//
// Revision10 1.16  2001/11/02 09:55:16  mohor10
// no message
//
// Revision10 1.15  2001/10/31 15:19:22  gorban10
// Fixes10 to break and timeout conditions10
//
// Revision10 1.14  2001/10/29 17:00:46  gorban10
// fixed10 parity10 sending10 and tx_fifo10 resets10 over- and underrun10
//
// Revision10 1.13  2001/10/20 09:58:40  gorban10
// Small10 synopsis10 fixes10
//
// Revision10 1.12  2001/10/19 16:21:40  gorban10
// Changes10 data_out10 to be synchronous10 again10 as it should have been.
//
// Revision10 1.11  2001/10/18 20:35:45  gorban10
// small fix10
//
// Revision10 1.10  2001/08/24 21:01:12  mohor10
// Things10 connected10 to parity10 changed.
// Clock10 devider10 changed.
//
// Revision10 1.9  2001/08/23 16:05:05  mohor10
// Stop bit bug10 fixed10.
// Parity10 bug10 fixed10.
// WISHBONE10 read cycle bug10 fixed10,
// OE10 indicator10 (Overrun10 Error) bug10 fixed10.
// PE10 indicator10 (Parity10 Error) bug10 fixed10.
// Register read bug10 fixed10.
//
// Revision10 1.10  2001/06/23 11:21:48  gorban10
// DL10 made10 16-bit long10. Fixed10 transmission10/reception10 bugs10.
//
// Revision10 1.9  2001/05/31 20:08:01  gorban10
// FIFO changes10 and other corrections10.
//
// Revision10 1.8  2001/05/29 20:05:04  gorban10
// Fixed10 some10 bugs10 and synthesis10 problems10.
//
// Revision10 1.7  2001/05/27 17:37:49  gorban10
// Fixed10 many10 bugs10. Updated10 spec10. Changed10 FIFO files structure10. See CHANGES10.txt10 file.
//
// Revision10 1.6  2001/05/21 19:12:02  gorban10
// Corrected10 some10 Linter10 messages10.
//
// Revision10 1.5  2001/05/17 18:34:18  gorban10
// First10 'stable' release. Should10 be sythesizable10 now. Also10 added new header.
//
// Revision10 1.0  2001-05-17 21:27:11+02  jacob10
// Initial10 revision10
//
//

// synopsys10 translate_off10
`include "timescale.v"
// synopsys10 translate_on10

`include "uart_defines10.v"

`define UART_DL110 7:0
`define UART_DL210 15:8

module uart_regs10 (clk10,
	wb_rst_i10, wb_addr_i10, wb_dat_i10, wb_dat_o10, wb_we_i10, wb_re_i10, 

// additional10 signals10
	modem_inputs10,
	stx_pad_o10, srx_pad_i10,

`ifdef DATA_BUS_WIDTH_810
`else
// debug10 interface signals10	enabled
ier10, iir10, fcr10, mcr10, lcr10, msr10, lsr10, rf_count10, tf_count10, tstate10, rstate,
`endif				
	rts_pad_o10, dtr_pad_o10, int_o10
`ifdef UART_HAS_BAUDRATE_OUTPUT10
	, baud_o10
`endif

	);

input 									clk10;
input 									wb_rst_i10;
input [`UART_ADDR_WIDTH10-1:0] 		wb_addr_i10;
input [7:0] 							wb_dat_i10;
output [7:0] 							wb_dat_o10;
input 									wb_we_i10;
input 									wb_re_i10;

output 									stx_pad_o10;
input 									srx_pad_i10;

input [3:0] 							modem_inputs10;
output 									rts_pad_o10;
output 									dtr_pad_o10;
output 									int_o10;
`ifdef UART_HAS_BAUDRATE_OUTPUT10
output	baud_o10;
`endif

`ifdef DATA_BUS_WIDTH_810
`else
// if 32-bit databus10 and debug10 interface are enabled
output [3:0]							ier10;
output [3:0]							iir10;
output [1:0]							fcr10;  /// bits 7 and 6 of fcr10. Other10 bits are ignored
output [4:0]							mcr10;
output [7:0]							lcr10;
output [7:0]							msr10;
output [7:0] 							lsr10;
output [`UART_FIFO_COUNTER_W10-1:0] 	rf_count10;
output [`UART_FIFO_COUNTER_W10-1:0] 	tf_count10;
output [2:0] 							tstate10;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs10;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT10
assign baud_o10 = enable; // baud_o10 is actually10 the enable signal10
`endif


wire 										stx_pad_o10;		// received10 from transmitter10 module
wire 										srx_pad_i10;
wire 										srx_pad10;

reg [7:0] 								wb_dat_o10;

wire [`UART_ADDR_WIDTH10-1:0] 		wb_addr_i10;
wire [7:0] 								wb_dat_i10;


reg [3:0] 								ier10;
reg [3:0] 								iir10;
reg [1:0] 								fcr10;  /// bits 7 and 6 of fcr10. Other10 bits are ignored
reg [4:0] 								mcr10;
reg [7:0] 								lcr10;
reg [7:0] 								msr10;
reg [15:0] 								dl10;  // 32-bit divisor10 latch10
reg [7:0] 								scratch10; // UART10 scratch10 register
reg 										start_dlc10; // activate10 dlc10 on writing to UART_DL110
reg 										lsr_mask_d10; // delay for lsr_mask10 condition
reg 										msi_reset10; // reset MSR10 4 lower10 bits indicator10
//reg 										threi_clear10; // THRE10 interrupt10 clear flag10
reg [15:0] 								dlc10;  // 32-bit divisor10 latch10 counter
reg 										int_o10;

reg [3:0] 								trigger_level10; // trigger level of the receiver10 FIFO
reg 										rx_reset10;
reg 										tx_reset10;

wire 										dlab10;			   // divisor10 latch10 access bit
wire 										cts_pad_i10, dsr_pad_i10, ri_pad_i10, dcd_pad_i10; // modem10 status bits
wire 										loopback10;		   // loopback10 bit (MCR10 bit 4)
wire 										cts10, dsr10, ri, dcd10;	   // effective10 signals10
wire                    cts_c10, dsr_c10, ri_c10, dcd_c10; // Complement10 effective10 signals10 (considering10 loopback10)
wire 										rts_pad_o10, dtr_pad_o10;		   // modem10 control10 outputs10

// LSR10 bits wires10 and regs
wire [7:0] 								lsr10;
wire 										lsr010, lsr110, lsr210, lsr310, lsr410, lsr510, lsr610, lsr710;
reg										lsr0r10, lsr1r10, lsr2r10, lsr3r10, lsr4r10, lsr5r10, lsr6r10, lsr7r10;
wire 										lsr_mask10; // lsr_mask10

//
// ASSINGS10
//

assign 									lsr10[7:0] = { lsr7r10, lsr6r10, lsr5r10, lsr4r10, lsr3r10, lsr2r10, lsr1r10, lsr0r10 };

assign 									{cts_pad_i10, dsr_pad_i10, ri_pad_i10, dcd_pad_i10} = modem_inputs10;
assign 									{cts10, dsr10, ri, dcd10} = ~{cts_pad_i10,dsr_pad_i10,ri_pad_i10,dcd_pad_i10};

assign                  {cts_c10, dsr_c10, ri_c10, dcd_c10} = loopback10 ? {mcr10[`UART_MC_RTS10],mcr10[`UART_MC_DTR10],mcr10[`UART_MC_OUT110],mcr10[`UART_MC_OUT210]}
                                                               : {cts_pad_i10,dsr_pad_i10,ri_pad_i10,dcd_pad_i10};

assign 									dlab10 = lcr10[`UART_LC_DL10];
assign 									loopback10 = mcr10[4];

// assign modem10 outputs10
assign 									rts_pad_o10 = mcr10[`UART_MC_RTS10];
assign 									dtr_pad_o10 = mcr10[`UART_MC_DTR10];

// Interrupt10 signals10
wire 										rls_int10;  // receiver10 line status interrupt10
wire 										rda_int10;  // receiver10 data available interrupt10
wire 										ti_int10;   // timeout indicator10 interrupt10
wire										thre_int10; // transmitter10 holding10 register empty10 interrupt10
wire 										ms_int10;   // modem10 status interrupt10

// FIFO signals10
reg 										tf_push10;
reg 										rf_pop10;
wire [`UART_FIFO_REC_WIDTH10-1:0] 	rf_data_out10;
wire 										rf_error_bit10; // an error (parity10 or framing10) is inside the fifo
wire [`UART_FIFO_COUNTER_W10-1:0] 	rf_count10;
wire [`UART_FIFO_COUNTER_W10-1:0] 	tf_count10;
wire [2:0] 								tstate10;
wire [3:0] 								rstate;
wire [9:0] 								counter_t10;

wire                      thre_set_en10; // THRE10 status is delayed10 one character10 time when a character10 is written10 to fifo.
reg  [7:0]                block_cnt10;   // While10 counter counts10, THRE10 status is blocked10 (delayed10 one character10 cycle)
reg  [7:0]                block_value10; // One10 character10 length minus10 stop bit

// Transmitter10 Instance
wire serial_out10;

uart_transmitter10 transmitter10(clk10, wb_rst_i10, lcr10, tf_push10, wb_dat_i10, enable, serial_out10, tstate10, tf_count10, tx_reset10, lsr_mask10);

  // Synchronizing10 and sampling10 serial10 RX10 input
  uart_sync_flops10    i_uart_sync_flops10
  (
    .rst_i10           (wb_rst_i10),
    .clk_i10           (clk10),
    .stage1_rst_i10    (1'b0),
    .stage1_clk_en_i10 (1'b1),
    .async_dat_i10     (srx_pad_i10),
    .sync_dat_o10      (srx_pad10)
  );
  defparam i_uart_sync_flops10.width      = 1;
  defparam i_uart_sync_flops10.init_value10 = 1'b1;

// handle loopback10
wire serial_in10 = loopback10 ? serial_out10 : srx_pad10;
assign stx_pad_o10 = loopback10 ? 1'b1 : serial_out10;

// Receiver10 Instance
uart_receiver10 receiver10(clk10, wb_rst_i10, lcr10, rf_pop10, serial_in10, enable, 
	counter_t10, rf_count10, rf_data_out10, rf_error_bit10, rf_overrun10, rx_reset10, lsr_mask10, rstate, rf_push_pulse10);


// Asynchronous10 reading here10 because the outputs10 are sampled10 in uart_wb10.v file 
always @(dl10 or dlab10 or ier10 or iir10 or scratch10
			or lcr10 or lsr10 or msr10 or rf_data_out10 or wb_addr_i10 or wb_re_i10)   // asynchrounous10 reading
begin
	case (wb_addr_i10)
		`UART_REG_RB10   : wb_dat_o10 = dlab10 ? dl10[`UART_DL110] : rf_data_out10[10:3];
		`UART_REG_IE10	: wb_dat_o10 = dlab10 ? dl10[`UART_DL210] : ier10;
		`UART_REG_II10	: wb_dat_o10 = {4'b1100,iir10};
		`UART_REG_LC10	: wb_dat_o10 = lcr10;
		`UART_REG_LS10	: wb_dat_o10 = lsr10;
		`UART_REG_MS10	: wb_dat_o10 = msr10;
		`UART_REG_SR10	: wb_dat_o10 = scratch10;
		default:  wb_dat_o10 = 8'b0; // ??
	endcase // case(wb_addr_i10)
end // always @ (dl10 or dlab10 or ier10 or iir10 or scratch10...


// rf_pop10 signal10 handling10
always @(posedge clk10 or posedge wb_rst_i10)
begin
	if (wb_rst_i10)
		rf_pop10 <= #1 0; 
	else
	if (rf_pop10)	// restore10 the signal10 to 0 after one clock10 cycle
		rf_pop10 <= #1 0;
	else
	if (wb_re_i10 && wb_addr_i10 == `UART_REG_RB10 && !dlab10)
		rf_pop10 <= #1 1; // advance10 read pointer10
end

wire 	lsr_mask_condition10;
wire 	iir_read10;
wire  msr_read10;
wire	fifo_read10;
wire	fifo_write10;

assign lsr_mask_condition10 = (wb_re_i10 && wb_addr_i10 == `UART_REG_LS10 && !dlab10);
assign iir_read10 = (wb_re_i10 && wb_addr_i10 == `UART_REG_II10 && !dlab10);
assign msr_read10 = (wb_re_i10 && wb_addr_i10 == `UART_REG_MS10 && !dlab10);
assign fifo_read10 = (wb_re_i10 && wb_addr_i10 == `UART_REG_RB10 && !dlab10);
assign fifo_write10 = (wb_we_i10 && wb_addr_i10 == `UART_REG_TR10 && !dlab10);

// lsr_mask_d10 delayed10 signal10 handling10
always @(posedge clk10 or posedge wb_rst_i10)
begin
	if (wb_rst_i10)
		lsr_mask_d10 <= #1 0;
	else // reset bits in the Line10 Status Register
		lsr_mask_d10 <= #1 lsr_mask_condition10;
end

// lsr_mask10 is rise10 detected
assign lsr_mask10 = lsr_mask_condition10 && ~lsr_mask_d10;

// msi_reset10 signal10 handling10
always @(posedge clk10 or posedge wb_rst_i10)
begin
	if (wb_rst_i10)
		msi_reset10 <= #1 1;
	else
	if (msi_reset10)
		msi_reset10 <= #1 0;
	else
	if (msr_read10)
		msi_reset10 <= #1 1; // reset bits in Modem10 Status Register
end


//
//   WRITES10 AND10 RESETS10   //
//
// Line10 Control10 Register
always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10)
		lcr10 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i10 && wb_addr_i10==`UART_REG_LC10)
		lcr10 <= #1 wb_dat_i10;

// Interrupt10 Enable10 Register or UART_DL210
always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10)
	begin
		ier10 <= #1 4'b0000; // no interrupts10 after reset
		dl10[`UART_DL210] <= #1 8'b0;
	end
	else
	if (wb_we_i10 && wb_addr_i10==`UART_REG_IE10)
		if (dlab10)
		begin
			dl10[`UART_DL210] <= #1 wb_dat_i10;
		end
		else
			ier10 <= #1 wb_dat_i10[3:0]; // ier10 uses only 4 lsb


// FIFO Control10 Register and rx_reset10, tx_reset10 signals10
always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) begin
		fcr10 <= #1 2'b11; 
		rx_reset10 <= #1 0;
		tx_reset10 <= #1 0;
	end else
	if (wb_we_i10 && wb_addr_i10==`UART_REG_FC10) begin
		fcr10 <= #1 wb_dat_i10[7:6];
		rx_reset10 <= #1 wb_dat_i10[1];
		tx_reset10 <= #1 wb_dat_i10[2];
	end else begin
		rx_reset10 <= #1 0;
		tx_reset10 <= #1 0;
	end

// Modem10 Control10 Register
always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10)
		mcr10 <= #1 5'b0; 
	else
	if (wb_we_i10 && wb_addr_i10==`UART_REG_MC10)
			mcr10 <= #1 wb_dat_i10[4:0];

// Scratch10 register
// Line10 Control10 Register
always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10)
		scratch10 <= #1 0; // 8n1 setting
	else
	if (wb_we_i10 && wb_addr_i10==`UART_REG_SR10)
		scratch10 <= #1 wb_dat_i10;

// TX_FIFO10 or UART_DL110
always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10)
	begin
		dl10[`UART_DL110]  <= #1 8'b0;
		tf_push10   <= #1 1'b0;
		start_dlc10 <= #1 1'b0;
	end
	else
	if (wb_we_i10 && wb_addr_i10==`UART_REG_TR10)
		if (dlab10)
		begin
			dl10[`UART_DL110] <= #1 wb_dat_i10;
			start_dlc10 <= #1 1'b1; // enable DL10 counter
			tf_push10 <= #1 1'b0;
		end
		else
		begin
			tf_push10   <= #1 1'b1;
			start_dlc10 <= #1 1'b0;
		end // else: !if(dlab10)
	else
	begin
		start_dlc10 <= #1 1'b0;
		tf_push10   <= #1 1'b0;
	end // else: !if(dlab10)

// Receiver10 FIFO trigger level selection logic (asynchronous10 mux10)
always @(fcr10)
	case (fcr10[`UART_FC_TL10])
		2'b00 : trigger_level10 = 1;
		2'b01 : trigger_level10 = 4;
		2'b10 : trigger_level10 = 8;
		2'b11 : trigger_level10 = 14;
	endcase // case(fcr10[`UART_FC_TL10])
	
//
//  STATUS10 REGISTERS10  //
//

// Modem10 Status Register
reg [3:0] delayed_modem_signals10;
always @(posedge clk10 or posedge wb_rst_i10)
begin
	if (wb_rst_i10)
	  begin
  		msr10 <= #1 0;
	  	delayed_modem_signals10[3:0] <= #1 0;
	  end
	else begin
		msr10[`UART_MS_DDCD10:`UART_MS_DCTS10] <= #1 msi_reset10 ? 4'b0 :
			msr10[`UART_MS_DDCD10:`UART_MS_DCTS10] | ({dcd10, ri, dsr10, cts10} ^ delayed_modem_signals10[3:0]);
		msr10[`UART_MS_CDCD10:`UART_MS_CCTS10] <= #1 {dcd_c10, ri_c10, dsr_c10, cts_c10};
		delayed_modem_signals10[3:0] <= #1 {dcd10, ri, dsr10, cts10};
	end
end


// Line10 Status Register

// activation10 conditions10
assign lsr010 = (rf_count10==0 && rf_push_pulse10);  // data in receiver10 fifo available set condition
assign lsr110 = rf_overrun10;     // Receiver10 overrun10 error
assign lsr210 = rf_data_out10[1]; // parity10 error bit
assign lsr310 = rf_data_out10[0]; // framing10 error bit
assign lsr410 = rf_data_out10[2]; // break error in the character10
assign lsr510 = (tf_count10==5'b0 && thre_set_en10);  // transmitter10 fifo is empty10
assign lsr610 = (tf_count10==5'b0 && thre_set_en10 && (tstate10 == /*`S_IDLE10 */ 0)); // transmitter10 empty10
assign lsr710 = rf_error_bit10 | rf_overrun10;

// lsr10 bit010 (receiver10 data available)
reg 	 lsr0_d10;

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr0_d10 <= #1 0;
	else lsr0_d10 <= #1 lsr010;

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr0r10 <= #1 0;
	else lsr0r10 <= #1 (rf_count10==1 && rf_pop10 && !rf_push_pulse10 || rx_reset10) ? 0 : // deassert10 condition
					  lsr0r10 || (lsr010 && ~lsr0_d10); // set on rise10 of lsr010 and keep10 asserted10 until deasserted10 

// lsr10 bit 1 (receiver10 overrun10)
reg lsr1_d10; // delayed10

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr1_d10 <= #1 0;
	else lsr1_d10 <= #1 lsr110;

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr1r10 <= #1 0;
	else	lsr1r10 <= #1	lsr_mask10 ? 0 : lsr1r10 || (lsr110 && ~lsr1_d10); // set on rise10

// lsr10 bit 2 (parity10 error)
reg lsr2_d10; // delayed10

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr2_d10 <= #1 0;
	else lsr2_d10 <= #1 lsr210;

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr2r10 <= #1 0;
	else lsr2r10 <= #1 lsr_mask10 ? 0 : lsr2r10 || (lsr210 && ~lsr2_d10); // set on rise10

// lsr10 bit 3 (framing10 error)
reg lsr3_d10; // delayed10

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr3_d10 <= #1 0;
	else lsr3_d10 <= #1 lsr310;

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr3r10 <= #1 0;
	else lsr3r10 <= #1 lsr_mask10 ? 0 : lsr3r10 || (lsr310 && ~lsr3_d10); // set on rise10

// lsr10 bit 4 (break indicator10)
reg lsr4_d10; // delayed10

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr4_d10 <= #1 0;
	else lsr4_d10 <= #1 lsr410;

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr4r10 <= #1 0;
	else lsr4r10 <= #1 lsr_mask10 ? 0 : lsr4r10 || (lsr410 && ~lsr4_d10);

// lsr10 bit 5 (transmitter10 fifo is empty10)
reg lsr5_d10;

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr5_d10 <= #1 1;
	else lsr5_d10 <= #1 lsr510;

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr5r10 <= #1 1;
	else lsr5r10 <= #1 (fifo_write10) ? 0 :  lsr5r10 || (lsr510 && ~lsr5_d10);

// lsr10 bit 6 (transmitter10 empty10 indicator10)
reg lsr6_d10;

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr6_d10 <= #1 1;
	else lsr6_d10 <= #1 lsr610;

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr6r10 <= #1 1;
	else lsr6r10 <= #1 (fifo_write10) ? 0 : lsr6r10 || (lsr610 && ~lsr6_d10);

// lsr10 bit 7 (error in fifo)
reg lsr7_d10;

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr7_d10 <= #1 0;
	else lsr7_d10 <= #1 lsr710;

always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) lsr7r10 <= #1 0;
	else lsr7r10 <= #1 lsr_mask10 ? 0 : lsr7r10 || (lsr710 && ~lsr7_d10);

// Frequency10 divider10
always @(posedge clk10 or posedge wb_rst_i10) 
begin
	if (wb_rst_i10)
		dlc10 <= #1 0;
	else
		if (start_dlc10 | ~ (|dlc10))
  			dlc10 <= #1 dl10 - 1;               // preset10 counter
		else
			dlc10 <= #1 dlc10 - 1;              // decrement counter
end

// Enable10 signal10 generation10 logic
always @(posedge clk10 or posedge wb_rst_i10)
begin
	if (wb_rst_i10)
		enable <= #1 1'b0;
	else
		if (|dl10 & ~(|dlc10))     // dl10>0 & dlc10==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying10 THRE10 status for one character10 cycle after a character10 is written10 to an empty10 fifo.
always @(lcr10)
  case (lcr10[3:0])
    4'b0000                             : block_value10 =  95; // 6 bits
    4'b0100                             : block_value10 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value10 = 111; // 7 bits
    4'b1100                             : block_value10 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value10 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value10 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value10 = 159; // 10 bits
    4'b1111                             : block_value10 = 175; // 11 bits
  endcase // case(lcr10[3:0])

// Counting10 time of one character10 minus10 stop bit
always @(posedge clk10 or posedge wb_rst_i10)
begin
  if (wb_rst_i10)
    block_cnt10 <= #1 8'd0;
  else
  if(lsr5r10 & fifo_write10)  // THRE10 bit set & write to fifo occured10
    block_cnt10 <= #1 block_value10;
  else
  if (enable & block_cnt10 != 8'b0)  // only work10 on enable times
    block_cnt10 <= #1 block_cnt10 - 1;  // decrement break counter
end // always of break condition detection10

// Generating10 THRE10 status enable signal10
assign thre_set_en10 = ~(|block_cnt10);


//
//	INTERRUPT10 LOGIC10
//

assign rls_int10  = ier10[`UART_IE_RLS10] && (lsr10[`UART_LS_OE10] || lsr10[`UART_LS_PE10] || lsr10[`UART_LS_FE10] || lsr10[`UART_LS_BI10]);
assign rda_int10  = ier10[`UART_IE_RDA10] && (rf_count10 >= {1'b0,trigger_level10});
assign thre_int10 = ier10[`UART_IE_THRE10] && lsr10[`UART_LS_TFE10];
assign ms_int10   = ier10[`UART_IE_MS10] && (| msr10[3:0]);
assign ti_int10   = ier10[`UART_IE_RDA10] && (counter_t10 == 10'b0) && (|rf_count10);

reg 	 rls_int_d10;
reg 	 thre_int_d10;
reg 	 ms_int_d10;
reg 	 ti_int_d10;
reg 	 rda_int_d10;

// delay lines10
always  @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) rls_int_d10 <= #1 0;
	else rls_int_d10 <= #1 rls_int10;

always  @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) rda_int_d10 <= #1 0;
	else rda_int_d10 <= #1 rda_int10;

always  @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) thre_int_d10 <= #1 0;
	else thre_int_d10 <= #1 thre_int10;

always  @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) ms_int_d10 <= #1 0;
	else ms_int_d10 <= #1 ms_int10;

always  @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) ti_int_d10 <= #1 0;
	else ti_int_d10 <= #1 ti_int10;

// rise10 detection10 signals10

wire 	 rls_int_rise10;
wire 	 thre_int_rise10;
wire 	 ms_int_rise10;
wire 	 ti_int_rise10;
wire 	 rda_int_rise10;

assign rda_int_rise10    = rda_int10 & ~rda_int_d10;
assign rls_int_rise10 	  = rls_int10 & ~rls_int_d10;
assign thre_int_rise10   = thre_int10 & ~thre_int_d10;
assign ms_int_rise10 	  = ms_int10 & ~ms_int_d10;
assign ti_int_rise10 	  = ti_int10 & ~ti_int_d10;

// interrupt10 pending flags10
reg 	rls_int_pnd10;
reg	rda_int_pnd10;
reg 	thre_int_pnd10;
reg 	ms_int_pnd10;
reg 	ti_int_pnd10;

// interrupt10 pending flags10 assignments10
always  @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) rls_int_pnd10 <= #1 0; 
	else 
		rls_int_pnd10 <= #1 lsr_mask10 ? 0 :  						// reset condition
							rls_int_rise10 ? 1 :						// latch10 condition
							rls_int_pnd10 && ier10[`UART_IE_RLS10];	// default operation10: remove if masked10

always  @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) rda_int_pnd10 <= #1 0; 
	else 
		rda_int_pnd10 <= #1 ((rf_count10 == {1'b0,trigger_level10}) && fifo_read10) ? 0 :  	// reset condition
							rda_int_rise10 ? 1 :						// latch10 condition
							rda_int_pnd10 && ier10[`UART_IE_RDA10];	// default operation10: remove if masked10

always  @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) thre_int_pnd10 <= #1 0; 
	else 
		thre_int_pnd10 <= #1 fifo_write10 || (iir_read10 & ~iir10[`UART_II_IP10] & iir10[`UART_II_II10] == `UART_II_THRE10)? 0 : 
							thre_int_rise10 ? 1 :
							thre_int_pnd10 && ier10[`UART_IE_THRE10];

always  @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) ms_int_pnd10 <= #1 0; 
	else 
		ms_int_pnd10 <= #1 msr_read10 ? 0 : 
							ms_int_rise10 ? 1 :
							ms_int_pnd10 && ier10[`UART_IE_MS10];

always  @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) ti_int_pnd10 <= #1 0; 
	else 
		ti_int_pnd10 <= #1 fifo_read10 ? 0 : 
							ti_int_rise10 ? 1 :
							ti_int_pnd10 && ier10[`UART_IE_RDA10];
// end of pending flags10

// INT_O10 logic
always @(posedge clk10 or posedge wb_rst_i10)
begin
	if (wb_rst_i10)	
		int_o10 <= #1 1'b0;
	else
		int_o10 <= #1 
					rls_int_pnd10		?	~lsr_mask10					:
					rda_int_pnd10		? 1								:
					ti_int_pnd10		? ~fifo_read10					:
					thre_int_pnd10	? !(fifo_write10 & iir_read10) :
					ms_int_pnd10		? ~msr_read10						:
					0;	// if no interrupt10 are pending
end


// Interrupt10 Identification10 register
always @(posedge clk10 or posedge wb_rst_i10)
begin
	if (wb_rst_i10)
		iir10 <= #1 1;
	else
	if (rls_int_pnd10)  // interrupt10 is pending
	begin
		iir10[`UART_II_II10] <= #1 `UART_II_RLS10;	// set identification10 register to correct10 value
		iir10[`UART_II_IP10] <= #1 1'b0;		// and clear the IIR10 bit 0 (interrupt10 pending)
	end else // the sequence of conditions10 determines10 priority of interrupt10 identification10
	if (rda_int10)
	begin
		iir10[`UART_II_II10] <= #1 `UART_II_RDA10;
		iir10[`UART_II_IP10] <= #1 1'b0;
	end
	else if (ti_int_pnd10)
	begin
		iir10[`UART_II_II10] <= #1 `UART_II_TI10;
		iir10[`UART_II_IP10] <= #1 1'b0;
	end
	else if (thre_int_pnd10)
	begin
		iir10[`UART_II_II10] <= #1 `UART_II_THRE10;
		iir10[`UART_II_IP10] <= #1 1'b0;
	end
	else if (ms_int_pnd10)
	begin
		iir10[`UART_II_II10] <= #1 `UART_II_MS10;
		iir10[`UART_II_IP10] <= #1 1'b0;
	end else	// no interrupt10 is pending
	begin
		iir10[`UART_II_II10] <= #1 0;
		iir10[`UART_II_IP10] <= #1 1'b1;
	end
end

endmodule
