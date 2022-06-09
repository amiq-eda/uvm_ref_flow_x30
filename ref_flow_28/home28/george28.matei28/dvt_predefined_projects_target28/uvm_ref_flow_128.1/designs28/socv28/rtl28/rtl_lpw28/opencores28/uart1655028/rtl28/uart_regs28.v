//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs28.v                                                 ////
////                                                              ////
////                                                              ////
////  This28 file is part of the "UART28 16550 compatible28" project28    ////
////  http28://www28.opencores28.org28/cores28/uart1655028/                   ////
////                                                              ////
////  Documentation28 related28 to this project28:                      ////
////  - http28://www28.opencores28.org28/cores28/uart1655028/                 ////
////                                                              ////
////  Projects28 compatibility28:                                     ////
////  - WISHBONE28                                                  ////
////  RS23228 Protocol28                                              ////
////  16550D uart28 (mostly28 supported)                              ////
////                                                              ////
////  Overview28 (main28 Features28):                                   ////
////  Registers28 of the uart28 16550 core28                            ////
////                                                              ////
////  Known28 problems28 (limits28):                                    ////
////  Inserts28 1 wait state in all WISHBONE28 transfers28              ////
////                                                              ////
////  To28 Do28:                                                      ////
////  Nothing or verification28.                                    ////
////                                                              ////
////  Author28(s):                                                  ////
////      - gorban28@opencores28.org28                                  ////
////      - Jacob28 Gorban28                                          ////
////      - Igor28 Mohor28 (igorm28@opencores28.org28)                      ////
////                                                              ////
////  Created28:        2001/05/12                                  ////
////  Last28 Updated28:   (See log28 for the revision28 history28           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2000, 2001 Authors28                             ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS28 Revision28 History28
//
// $Log: not supported by cvs2svn28 $
// Revision28 1.41  2004/05/21 11:44:41  tadejm28
// Added28 synchronizer28 flops28 for RX28 input.
//
// Revision28 1.40  2003/06/11 16:37:47  gorban28
// This28 fixes28 errors28 in some28 cases28 when data is being read and put to the FIFO at the same time. Patch28 is submitted28 by Scott28 Furman28. Update is very28 recommended28.
//
// Revision28 1.39  2002/07/29 21:16:18  gorban28
// The uart_defines28.v file is included28 again28 in sources28.
//
// Revision28 1.38  2002/07/22 23:02:23  gorban28
// Bug28 Fixes28:
//  * Possible28 loss of sync and bad28 reception28 of stop bit on slow28 baud28 rates28 fixed28.
//   Problem28 reported28 by Kenny28.Tung28.
//  * Bad (or lack28 of ) loopback28 handling28 fixed28. Reported28 by Cherry28 Withers28.
//
// Improvements28:
//  * Made28 FIFO's as general28 inferrable28 memory where possible28.
//  So28 on FPGA28 they should be inferred28 as RAM28 (Distributed28 RAM28 on Xilinx28).
//  This28 saves28 about28 1/3 of the Slice28 count and reduces28 P&R and synthesis28 times.
//
//  * Added28 optional28 baudrate28 output (baud_o28).
//  This28 is identical28 to BAUDOUT28* signal28 on 16550 chip28.
//  It outputs28 16xbit_clock_rate - the divided28 clock28.
//  It's disabled by default. Define28 UART_HAS_BAUDRATE_OUTPUT28 to use.
//
// Revision28 1.37  2001/12/27 13:24:09  mohor28
// lsr28[7] was not showing28 overrun28 errors28.
//
// Revision28 1.36  2001/12/20 13:25:46  mohor28
// rx28 push28 changed to be only one cycle wide28.
//
// Revision28 1.35  2001/12/19 08:03:34  mohor28
// Warnings28 cleared28.
//
// Revision28 1.34  2001/12/19 07:33:54  mohor28
// Synplicity28 was having28 troubles28 with the comment28.
//
// Revision28 1.33  2001/12/17 10:14:43  mohor28
// Things28 related28 to msr28 register changed. After28 THRE28 IRQ28 occurs28, and one
// character28 is written28 to the transmit28 fifo, the detection28 of the THRE28 bit in the
// LSR28 is delayed28 for one character28 time.
//
// Revision28 1.32  2001/12/14 13:19:24  mohor28
// MSR28 register fixed28.
//
// Revision28 1.31  2001/12/14 10:06:58  mohor28
// After28 reset modem28 status register MSR28 should be reset.
//
// Revision28 1.30  2001/12/13 10:09:13  mohor28
// thre28 irq28 should be cleared28 only when being source28 of interrupt28.
//
// Revision28 1.29  2001/12/12 09:05:46  mohor28
// LSR28 status bit 0 was not cleared28 correctly in case of reseting28 the FCR28 (rx28 fifo).
//
// Revision28 1.28  2001/12/10 19:52:41  gorban28
// Scratch28 register added
//
// Revision28 1.27  2001/12/06 14:51:04  gorban28
// Bug28 in LSR28[0] is fixed28.
// All WISHBONE28 signals28 are now sampled28, so another28 wait-state is introduced28 on all transfers28.
//
// Revision28 1.26  2001/12/03 21:44:29  gorban28
// Updated28 specification28 documentation.
// Added28 full 32-bit data bus interface, now as default.
// Address is 5-bit wide28 in 32-bit data bus mode.
// Added28 wb_sel_i28 input to the core28. It's used in the 32-bit mode.
// Added28 debug28 interface with two28 32-bit read-only registers in 32-bit mode.
// Bits28 5 and 6 of LSR28 are now only cleared28 on TX28 FIFO write.
// My28 small test bench28 is modified to work28 with 32-bit mode.
//
// Revision28 1.25  2001/11/28 19:36:39  gorban28
// Fixed28: timeout and break didn28't pay28 attention28 to current data format28 when counting28 time
//
// Revision28 1.24  2001/11/26 21:38:54  gorban28
// Lots28 of fixes28:
// Break28 condition wasn28't handled28 correctly at all.
// LSR28 bits could lose28 their28 values.
// LSR28 value after reset was wrong28.
// Timing28 of THRE28 interrupt28 signal28 corrected28.
// LSR28 bit 0 timing28 corrected28.
//
// Revision28 1.23  2001/11/12 21:57:29  gorban28
// fixed28 more typo28 bugs28
//
// Revision28 1.22  2001/11/12 15:02:28  mohor28
// lsr1r28 error fixed28.
//
// Revision28 1.21  2001/11/12 14:57:27  mohor28
// ti_int_pnd28 error fixed28.
//
// Revision28 1.20  2001/11/12 14:50:27  mohor28
// ti_int_d28 error fixed28.
//
// Revision28 1.19  2001/11/10 12:43:21  gorban28
// Logic28 Synthesis28 bugs28 fixed28. Some28 other minor28 changes28
//
// Revision28 1.18  2001/11/08 14:54:23  mohor28
// Comments28 in Slovene28 language28 deleted28, few28 small fixes28 for better28 work28 of
// old28 tools28. IRQs28 need to be fix28.
//
// Revision28 1.17  2001/11/07 17:51:52  gorban28
// Heavily28 rewritten28 interrupt28 and LSR28 subsystems28.
// Many28 bugs28 hopefully28 squashed28.
//
// Revision28 1.16  2001/11/02 09:55:16  mohor28
// no message
//
// Revision28 1.15  2001/10/31 15:19:22  gorban28
// Fixes28 to break and timeout conditions28
//
// Revision28 1.14  2001/10/29 17:00:46  gorban28
// fixed28 parity28 sending28 and tx_fifo28 resets28 over- and underrun28
//
// Revision28 1.13  2001/10/20 09:58:40  gorban28
// Small28 synopsis28 fixes28
//
// Revision28 1.12  2001/10/19 16:21:40  gorban28
// Changes28 data_out28 to be synchronous28 again28 as it should have been.
//
// Revision28 1.11  2001/10/18 20:35:45  gorban28
// small fix28
//
// Revision28 1.10  2001/08/24 21:01:12  mohor28
// Things28 connected28 to parity28 changed.
// Clock28 devider28 changed.
//
// Revision28 1.9  2001/08/23 16:05:05  mohor28
// Stop bit bug28 fixed28.
// Parity28 bug28 fixed28.
// WISHBONE28 read cycle bug28 fixed28,
// OE28 indicator28 (Overrun28 Error) bug28 fixed28.
// PE28 indicator28 (Parity28 Error) bug28 fixed28.
// Register read bug28 fixed28.
//
// Revision28 1.10  2001/06/23 11:21:48  gorban28
// DL28 made28 16-bit long28. Fixed28 transmission28/reception28 bugs28.
//
// Revision28 1.9  2001/05/31 20:08:01  gorban28
// FIFO changes28 and other corrections28.
//
// Revision28 1.8  2001/05/29 20:05:04  gorban28
// Fixed28 some28 bugs28 and synthesis28 problems28.
//
// Revision28 1.7  2001/05/27 17:37:49  gorban28
// Fixed28 many28 bugs28. Updated28 spec28. Changed28 FIFO files structure28. See CHANGES28.txt28 file.
//
// Revision28 1.6  2001/05/21 19:12:02  gorban28
// Corrected28 some28 Linter28 messages28.
//
// Revision28 1.5  2001/05/17 18:34:18  gorban28
// First28 'stable' release. Should28 be sythesizable28 now. Also28 added new header.
//
// Revision28 1.0  2001-05-17 21:27:11+02  jacob28
// Initial28 revision28
//
//

// synopsys28 translate_off28
`include "timescale.v"
// synopsys28 translate_on28

`include "uart_defines28.v"

`define UART_DL128 7:0
`define UART_DL228 15:8

module uart_regs28 (clk28,
	wb_rst_i28, wb_addr_i28, wb_dat_i28, wb_dat_o28, wb_we_i28, wb_re_i28, 

// additional28 signals28
	modem_inputs28,
	stx_pad_o28, srx_pad_i28,

`ifdef DATA_BUS_WIDTH_828
`else
// debug28 interface signals28	enabled
ier28, iir28, fcr28, mcr28, lcr28, msr28, lsr28, rf_count28, tf_count28, tstate28, rstate,
`endif				
	rts_pad_o28, dtr_pad_o28, int_o28
`ifdef UART_HAS_BAUDRATE_OUTPUT28
	, baud_o28
`endif

	);

input 									clk28;
input 									wb_rst_i28;
input [`UART_ADDR_WIDTH28-1:0] 		wb_addr_i28;
input [7:0] 							wb_dat_i28;
output [7:0] 							wb_dat_o28;
input 									wb_we_i28;
input 									wb_re_i28;

output 									stx_pad_o28;
input 									srx_pad_i28;

input [3:0] 							modem_inputs28;
output 									rts_pad_o28;
output 									dtr_pad_o28;
output 									int_o28;
`ifdef UART_HAS_BAUDRATE_OUTPUT28
output	baud_o28;
`endif

`ifdef DATA_BUS_WIDTH_828
`else
// if 32-bit databus28 and debug28 interface are enabled
output [3:0]							ier28;
output [3:0]							iir28;
output [1:0]							fcr28;  /// bits 7 and 6 of fcr28. Other28 bits are ignored
output [4:0]							mcr28;
output [7:0]							lcr28;
output [7:0]							msr28;
output [7:0] 							lsr28;
output [`UART_FIFO_COUNTER_W28-1:0] 	rf_count28;
output [`UART_FIFO_COUNTER_W28-1:0] 	tf_count28;
output [2:0] 							tstate28;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs28;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT28
assign baud_o28 = enable; // baud_o28 is actually28 the enable signal28
`endif


wire 										stx_pad_o28;		// received28 from transmitter28 module
wire 										srx_pad_i28;
wire 										srx_pad28;

reg [7:0] 								wb_dat_o28;

wire [`UART_ADDR_WIDTH28-1:0] 		wb_addr_i28;
wire [7:0] 								wb_dat_i28;


reg [3:0] 								ier28;
reg [3:0] 								iir28;
reg [1:0] 								fcr28;  /// bits 7 and 6 of fcr28. Other28 bits are ignored
reg [4:0] 								mcr28;
reg [7:0] 								lcr28;
reg [7:0] 								msr28;
reg [15:0] 								dl28;  // 32-bit divisor28 latch28
reg [7:0] 								scratch28; // UART28 scratch28 register
reg 										start_dlc28; // activate28 dlc28 on writing to UART_DL128
reg 										lsr_mask_d28; // delay for lsr_mask28 condition
reg 										msi_reset28; // reset MSR28 4 lower28 bits indicator28
//reg 										threi_clear28; // THRE28 interrupt28 clear flag28
reg [15:0] 								dlc28;  // 32-bit divisor28 latch28 counter
reg 										int_o28;

reg [3:0] 								trigger_level28; // trigger level of the receiver28 FIFO
reg 										rx_reset28;
reg 										tx_reset28;

wire 										dlab28;			   // divisor28 latch28 access bit
wire 										cts_pad_i28, dsr_pad_i28, ri_pad_i28, dcd_pad_i28; // modem28 status bits
wire 										loopback28;		   // loopback28 bit (MCR28 bit 4)
wire 										cts28, dsr28, ri, dcd28;	   // effective28 signals28
wire                    cts_c28, dsr_c28, ri_c28, dcd_c28; // Complement28 effective28 signals28 (considering28 loopback28)
wire 										rts_pad_o28, dtr_pad_o28;		   // modem28 control28 outputs28

// LSR28 bits wires28 and regs
wire [7:0] 								lsr28;
wire 										lsr028, lsr128, lsr228, lsr328, lsr428, lsr528, lsr628, lsr728;
reg										lsr0r28, lsr1r28, lsr2r28, lsr3r28, lsr4r28, lsr5r28, lsr6r28, lsr7r28;
wire 										lsr_mask28; // lsr_mask28

//
// ASSINGS28
//

assign 									lsr28[7:0] = { lsr7r28, lsr6r28, lsr5r28, lsr4r28, lsr3r28, lsr2r28, lsr1r28, lsr0r28 };

assign 									{cts_pad_i28, dsr_pad_i28, ri_pad_i28, dcd_pad_i28} = modem_inputs28;
assign 									{cts28, dsr28, ri, dcd28} = ~{cts_pad_i28,dsr_pad_i28,ri_pad_i28,dcd_pad_i28};

assign                  {cts_c28, dsr_c28, ri_c28, dcd_c28} = loopback28 ? {mcr28[`UART_MC_RTS28],mcr28[`UART_MC_DTR28],mcr28[`UART_MC_OUT128],mcr28[`UART_MC_OUT228]}
                                                               : {cts_pad_i28,dsr_pad_i28,ri_pad_i28,dcd_pad_i28};

assign 									dlab28 = lcr28[`UART_LC_DL28];
assign 									loopback28 = mcr28[4];

// assign modem28 outputs28
assign 									rts_pad_o28 = mcr28[`UART_MC_RTS28];
assign 									dtr_pad_o28 = mcr28[`UART_MC_DTR28];

// Interrupt28 signals28
wire 										rls_int28;  // receiver28 line status interrupt28
wire 										rda_int28;  // receiver28 data available interrupt28
wire 										ti_int28;   // timeout indicator28 interrupt28
wire										thre_int28; // transmitter28 holding28 register empty28 interrupt28
wire 										ms_int28;   // modem28 status interrupt28

// FIFO signals28
reg 										tf_push28;
reg 										rf_pop28;
wire [`UART_FIFO_REC_WIDTH28-1:0] 	rf_data_out28;
wire 										rf_error_bit28; // an error (parity28 or framing28) is inside the fifo
wire [`UART_FIFO_COUNTER_W28-1:0] 	rf_count28;
wire [`UART_FIFO_COUNTER_W28-1:0] 	tf_count28;
wire [2:0] 								tstate28;
wire [3:0] 								rstate;
wire [9:0] 								counter_t28;

wire                      thre_set_en28; // THRE28 status is delayed28 one character28 time when a character28 is written28 to fifo.
reg  [7:0]                block_cnt28;   // While28 counter counts28, THRE28 status is blocked28 (delayed28 one character28 cycle)
reg  [7:0]                block_value28; // One28 character28 length minus28 stop bit

// Transmitter28 Instance
wire serial_out28;

uart_transmitter28 transmitter28(clk28, wb_rst_i28, lcr28, tf_push28, wb_dat_i28, enable, serial_out28, tstate28, tf_count28, tx_reset28, lsr_mask28);

  // Synchronizing28 and sampling28 serial28 RX28 input
  uart_sync_flops28    i_uart_sync_flops28
  (
    .rst_i28           (wb_rst_i28),
    .clk_i28           (clk28),
    .stage1_rst_i28    (1'b0),
    .stage1_clk_en_i28 (1'b1),
    .async_dat_i28     (srx_pad_i28),
    .sync_dat_o28      (srx_pad28)
  );
  defparam i_uart_sync_flops28.width      = 1;
  defparam i_uart_sync_flops28.init_value28 = 1'b1;

// handle loopback28
wire serial_in28 = loopback28 ? serial_out28 : srx_pad28;
assign stx_pad_o28 = loopback28 ? 1'b1 : serial_out28;

// Receiver28 Instance
uart_receiver28 receiver28(clk28, wb_rst_i28, lcr28, rf_pop28, serial_in28, enable, 
	counter_t28, rf_count28, rf_data_out28, rf_error_bit28, rf_overrun28, rx_reset28, lsr_mask28, rstate, rf_push_pulse28);


// Asynchronous28 reading here28 because the outputs28 are sampled28 in uart_wb28.v file 
always @(dl28 or dlab28 or ier28 or iir28 or scratch28
			or lcr28 or lsr28 or msr28 or rf_data_out28 or wb_addr_i28 or wb_re_i28)   // asynchrounous28 reading
begin
	case (wb_addr_i28)
		`UART_REG_RB28   : wb_dat_o28 = dlab28 ? dl28[`UART_DL128] : rf_data_out28[10:3];
		`UART_REG_IE28	: wb_dat_o28 = dlab28 ? dl28[`UART_DL228] : ier28;
		`UART_REG_II28	: wb_dat_o28 = {4'b1100,iir28};
		`UART_REG_LC28	: wb_dat_o28 = lcr28;
		`UART_REG_LS28	: wb_dat_o28 = lsr28;
		`UART_REG_MS28	: wb_dat_o28 = msr28;
		`UART_REG_SR28	: wb_dat_o28 = scratch28;
		default:  wb_dat_o28 = 8'b0; // ??
	endcase // case(wb_addr_i28)
end // always @ (dl28 or dlab28 or ier28 or iir28 or scratch28...


// rf_pop28 signal28 handling28
always @(posedge clk28 or posedge wb_rst_i28)
begin
	if (wb_rst_i28)
		rf_pop28 <= #1 0; 
	else
	if (rf_pop28)	// restore28 the signal28 to 0 after one clock28 cycle
		rf_pop28 <= #1 0;
	else
	if (wb_re_i28 && wb_addr_i28 == `UART_REG_RB28 && !dlab28)
		rf_pop28 <= #1 1; // advance28 read pointer28
end

wire 	lsr_mask_condition28;
wire 	iir_read28;
wire  msr_read28;
wire	fifo_read28;
wire	fifo_write28;

assign lsr_mask_condition28 = (wb_re_i28 && wb_addr_i28 == `UART_REG_LS28 && !dlab28);
assign iir_read28 = (wb_re_i28 && wb_addr_i28 == `UART_REG_II28 && !dlab28);
assign msr_read28 = (wb_re_i28 && wb_addr_i28 == `UART_REG_MS28 && !dlab28);
assign fifo_read28 = (wb_re_i28 && wb_addr_i28 == `UART_REG_RB28 && !dlab28);
assign fifo_write28 = (wb_we_i28 && wb_addr_i28 == `UART_REG_TR28 && !dlab28);

// lsr_mask_d28 delayed28 signal28 handling28
always @(posedge clk28 or posedge wb_rst_i28)
begin
	if (wb_rst_i28)
		lsr_mask_d28 <= #1 0;
	else // reset bits in the Line28 Status Register
		lsr_mask_d28 <= #1 lsr_mask_condition28;
end

// lsr_mask28 is rise28 detected
assign lsr_mask28 = lsr_mask_condition28 && ~lsr_mask_d28;

// msi_reset28 signal28 handling28
always @(posedge clk28 or posedge wb_rst_i28)
begin
	if (wb_rst_i28)
		msi_reset28 <= #1 1;
	else
	if (msi_reset28)
		msi_reset28 <= #1 0;
	else
	if (msr_read28)
		msi_reset28 <= #1 1; // reset bits in Modem28 Status Register
end


//
//   WRITES28 AND28 RESETS28   //
//
// Line28 Control28 Register
always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28)
		lcr28 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i28 && wb_addr_i28==`UART_REG_LC28)
		lcr28 <= #1 wb_dat_i28;

// Interrupt28 Enable28 Register or UART_DL228
always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28)
	begin
		ier28 <= #1 4'b0000; // no interrupts28 after reset
		dl28[`UART_DL228] <= #1 8'b0;
	end
	else
	if (wb_we_i28 && wb_addr_i28==`UART_REG_IE28)
		if (dlab28)
		begin
			dl28[`UART_DL228] <= #1 wb_dat_i28;
		end
		else
			ier28 <= #1 wb_dat_i28[3:0]; // ier28 uses only 4 lsb


// FIFO Control28 Register and rx_reset28, tx_reset28 signals28
always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) begin
		fcr28 <= #1 2'b11; 
		rx_reset28 <= #1 0;
		tx_reset28 <= #1 0;
	end else
	if (wb_we_i28 && wb_addr_i28==`UART_REG_FC28) begin
		fcr28 <= #1 wb_dat_i28[7:6];
		rx_reset28 <= #1 wb_dat_i28[1];
		tx_reset28 <= #1 wb_dat_i28[2];
	end else begin
		rx_reset28 <= #1 0;
		tx_reset28 <= #1 0;
	end

// Modem28 Control28 Register
always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28)
		mcr28 <= #1 5'b0; 
	else
	if (wb_we_i28 && wb_addr_i28==`UART_REG_MC28)
			mcr28 <= #1 wb_dat_i28[4:0];

// Scratch28 register
// Line28 Control28 Register
always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28)
		scratch28 <= #1 0; // 8n1 setting
	else
	if (wb_we_i28 && wb_addr_i28==`UART_REG_SR28)
		scratch28 <= #1 wb_dat_i28;

// TX_FIFO28 or UART_DL128
always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28)
	begin
		dl28[`UART_DL128]  <= #1 8'b0;
		tf_push28   <= #1 1'b0;
		start_dlc28 <= #1 1'b0;
	end
	else
	if (wb_we_i28 && wb_addr_i28==`UART_REG_TR28)
		if (dlab28)
		begin
			dl28[`UART_DL128] <= #1 wb_dat_i28;
			start_dlc28 <= #1 1'b1; // enable DL28 counter
			tf_push28 <= #1 1'b0;
		end
		else
		begin
			tf_push28   <= #1 1'b1;
			start_dlc28 <= #1 1'b0;
		end // else: !if(dlab28)
	else
	begin
		start_dlc28 <= #1 1'b0;
		tf_push28   <= #1 1'b0;
	end // else: !if(dlab28)

// Receiver28 FIFO trigger level selection logic (asynchronous28 mux28)
always @(fcr28)
	case (fcr28[`UART_FC_TL28])
		2'b00 : trigger_level28 = 1;
		2'b01 : trigger_level28 = 4;
		2'b10 : trigger_level28 = 8;
		2'b11 : trigger_level28 = 14;
	endcase // case(fcr28[`UART_FC_TL28])
	
//
//  STATUS28 REGISTERS28  //
//

// Modem28 Status Register
reg [3:0] delayed_modem_signals28;
always @(posedge clk28 or posedge wb_rst_i28)
begin
	if (wb_rst_i28)
	  begin
  		msr28 <= #1 0;
	  	delayed_modem_signals28[3:0] <= #1 0;
	  end
	else begin
		msr28[`UART_MS_DDCD28:`UART_MS_DCTS28] <= #1 msi_reset28 ? 4'b0 :
			msr28[`UART_MS_DDCD28:`UART_MS_DCTS28] | ({dcd28, ri, dsr28, cts28} ^ delayed_modem_signals28[3:0]);
		msr28[`UART_MS_CDCD28:`UART_MS_CCTS28] <= #1 {dcd_c28, ri_c28, dsr_c28, cts_c28};
		delayed_modem_signals28[3:0] <= #1 {dcd28, ri, dsr28, cts28};
	end
end


// Line28 Status Register

// activation28 conditions28
assign lsr028 = (rf_count28==0 && rf_push_pulse28);  // data in receiver28 fifo available set condition
assign lsr128 = rf_overrun28;     // Receiver28 overrun28 error
assign lsr228 = rf_data_out28[1]; // parity28 error bit
assign lsr328 = rf_data_out28[0]; // framing28 error bit
assign lsr428 = rf_data_out28[2]; // break error in the character28
assign lsr528 = (tf_count28==5'b0 && thre_set_en28);  // transmitter28 fifo is empty28
assign lsr628 = (tf_count28==5'b0 && thre_set_en28 && (tstate28 == /*`S_IDLE28 */ 0)); // transmitter28 empty28
assign lsr728 = rf_error_bit28 | rf_overrun28;

// lsr28 bit028 (receiver28 data available)
reg 	 lsr0_d28;

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr0_d28 <= #1 0;
	else lsr0_d28 <= #1 lsr028;

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr0r28 <= #1 0;
	else lsr0r28 <= #1 (rf_count28==1 && rf_pop28 && !rf_push_pulse28 || rx_reset28) ? 0 : // deassert28 condition
					  lsr0r28 || (lsr028 && ~lsr0_d28); // set on rise28 of lsr028 and keep28 asserted28 until deasserted28 

// lsr28 bit 1 (receiver28 overrun28)
reg lsr1_d28; // delayed28

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr1_d28 <= #1 0;
	else lsr1_d28 <= #1 lsr128;

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr1r28 <= #1 0;
	else	lsr1r28 <= #1	lsr_mask28 ? 0 : lsr1r28 || (lsr128 && ~lsr1_d28); // set on rise28

// lsr28 bit 2 (parity28 error)
reg lsr2_d28; // delayed28

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr2_d28 <= #1 0;
	else lsr2_d28 <= #1 lsr228;

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr2r28 <= #1 0;
	else lsr2r28 <= #1 lsr_mask28 ? 0 : lsr2r28 || (lsr228 && ~lsr2_d28); // set on rise28

// lsr28 bit 3 (framing28 error)
reg lsr3_d28; // delayed28

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr3_d28 <= #1 0;
	else lsr3_d28 <= #1 lsr328;

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr3r28 <= #1 0;
	else lsr3r28 <= #1 lsr_mask28 ? 0 : lsr3r28 || (lsr328 && ~lsr3_d28); // set on rise28

// lsr28 bit 4 (break indicator28)
reg lsr4_d28; // delayed28

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr4_d28 <= #1 0;
	else lsr4_d28 <= #1 lsr428;

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr4r28 <= #1 0;
	else lsr4r28 <= #1 lsr_mask28 ? 0 : lsr4r28 || (lsr428 && ~lsr4_d28);

// lsr28 bit 5 (transmitter28 fifo is empty28)
reg lsr5_d28;

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr5_d28 <= #1 1;
	else lsr5_d28 <= #1 lsr528;

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr5r28 <= #1 1;
	else lsr5r28 <= #1 (fifo_write28) ? 0 :  lsr5r28 || (lsr528 && ~lsr5_d28);

// lsr28 bit 6 (transmitter28 empty28 indicator28)
reg lsr6_d28;

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr6_d28 <= #1 1;
	else lsr6_d28 <= #1 lsr628;

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr6r28 <= #1 1;
	else lsr6r28 <= #1 (fifo_write28) ? 0 : lsr6r28 || (lsr628 && ~lsr6_d28);

// lsr28 bit 7 (error in fifo)
reg lsr7_d28;

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr7_d28 <= #1 0;
	else lsr7_d28 <= #1 lsr728;

always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) lsr7r28 <= #1 0;
	else lsr7r28 <= #1 lsr_mask28 ? 0 : lsr7r28 || (lsr728 && ~lsr7_d28);

// Frequency28 divider28
always @(posedge clk28 or posedge wb_rst_i28) 
begin
	if (wb_rst_i28)
		dlc28 <= #1 0;
	else
		if (start_dlc28 | ~ (|dlc28))
  			dlc28 <= #1 dl28 - 1;               // preset28 counter
		else
			dlc28 <= #1 dlc28 - 1;              // decrement counter
end

// Enable28 signal28 generation28 logic
always @(posedge clk28 or posedge wb_rst_i28)
begin
	if (wb_rst_i28)
		enable <= #1 1'b0;
	else
		if (|dl28 & ~(|dlc28))     // dl28>0 & dlc28==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying28 THRE28 status for one character28 cycle after a character28 is written28 to an empty28 fifo.
always @(lcr28)
  case (lcr28[3:0])
    4'b0000                             : block_value28 =  95; // 6 bits
    4'b0100                             : block_value28 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value28 = 111; // 7 bits
    4'b1100                             : block_value28 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value28 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value28 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value28 = 159; // 10 bits
    4'b1111                             : block_value28 = 175; // 11 bits
  endcase // case(lcr28[3:0])

// Counting28 time of one character28 minus28 stop bit
always @(posedge clk28 or posedge wb_rst_i28)
begin
  if (wb_rst_i28)
    block_cnt28 <= #1 8'd0;
  else
  if(lsr5r28 & fifo_write28)  // THRE28 bit set & write to fifo occured28
    block_cnt28 <= #1 block_value28;
  else
  if (enable & block_cnt28 != 8'b0)  // only work28 on enable times
    block_cnt28 <= #1 block_cnt28 - 1;  // decrement break counter
end // always of break condition detection28

// Generating28 THRE28 status enable signal28
assign thre_set_en28 = ~(|block_cnt28);


//
//	INTERRUPT28 LOGIC28
//

assign rls_int28  = ier28[`UART_IE_RLS28] && (lsr28[`UART_LS_OE28] || lsr28[`UART_LS_PE28] || lsr28[`UART_LS_FE28] || lsr28[`UART_LS_BI28]);
assign rda_int28  = ier28[`UART_IE_RDA28] && (rf_count28 >= {1'b0,trigger_level28});
assign thre_int28 = ier28[`UART_IE_THRE28] && lsr28[`UART_LS_TFE28];
assign ms_int28   = ier28[`UART_IE_MS28] && (| msr28[3:0]);
assign ti_int28   = ier28[`UART_IE_RDA28] && (counter_t28 == 10'b0) && (|rf_count28);

reg 	 rls_int_d28;
reg 	 thre_int_d28;
reg 	 ms_int_d28;
reg 	 ti_int_d28;
reg 	 rda_int_d28;

// delay lines28
always  @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) rls_int_d28 <= #1 0;
	else rls_int_d28 <= #1 rls_int28;

always  @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) rda_int_d28 <= #1 0;
	else rda_int_d28 <= #1 rda_int28;

always  @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) thre_int_d28 <= #1 0;
	else thre_int_d28 <= #1 thre_int28;

always  @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) ms_int_d28 <= #1 0;
	else ms_int_d28 <= #1 ms_int28;

always  @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) ti_int_d28 <= #1 0;
	else ti_int_d28 <= #1 ti_int28;

// rise28 detection28 signals28

wire 	 rls_int_rise28;
wire 	 thre_int_rise28;
wire 	 ms_int_rise28;
wire 	 ti_int_rise28;
wire 	 rda_int_rise28;

assign rda_int_rise28    = rda_int28 & ~rda_int_d28;
assign rls_int_rise28 	  = rls_int28 & ~rls_int_d28;
assign thre_int_rise28   = thre_int28 & ~thre_int_d28;
assign ms_int_rise28 	  = ms_int28 & ~ms_int_d28;
assign ti_int_rise28 	  = ti_int28 & ~ti_int_d28;

// interrupt28 pending flags28
reg 	rls_int_pnd28;
reg	rda_int_pnd28;
reg 	thre_int_pnd28;
reg 	ms_int_pnd28;
reg 	ti_int_pnd28;

// interrupt28 pending flags28 assignments28
always  @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) rls_int_pnd28 <= #1 0; 
	else 
		rls_int_pnd28 <= #1 lsr_mask28 ? 0 :  						// reset condition
							rls_int_rise28 ? 1 :						// latch28 condition
							rls_int_pnd28 && ier28[`UART_IE_RLS28];	// default operation28: remove if masked28

always  @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) rda_int_pnd28 <= #1 0; 
	else 
		rda_int_pnd28 <= #1 ((rf_count28 == {1'b0,trigger_level28}) && fifo_read28) ? 0 :  	// reset condition
							rda_int_rise28 ? 1 :						// latch28 condition
							rda_int_pnd28 && ier28[`UART_IE_RDA28];	// default operation28: remove if masked28

always  @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) thre_int_pnd28 <= #1 0; 
	else 
		thre_int_pnd28 <= #1 fifo_write28 || (iir_read28 & ~iir28[`UART_II_IP28] & iir28[`UART_II_II28] == `UART_II_THRE28)? 0 : 
							thre_int_rise28 ? 1 :
							thre_int_pnd28 && ier28[`UART_IE_THRE28];

always  @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) ms_int_pnd28 <= #1 0; 
	else 
		ms_int_pnd28 <= #1 msr_read28 ? 0 : 
							ms_int_rise28 ? 1 :
							ms_int_pnd28 && ier28[`UART_IE_MS28];

always  @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) ti_int_pnd28 <= #1 0; 
	else 
		ti_int_pnd28 <= #1 fifo_read28 ? 0 : 
							ti_int_rise28 ? 1 :
							ti_int_pnd28 && ier28[`UART_IE_RDA28];
// end of pending flags28

// INT_O28 logic
always @(posedge clk28 or posedge wb_rst_i28)
begin
	if (wb_rst_i28)	
		int_o28 <= #1 1'b0;
	else
		int_o28 <= #1 
					rls_int_pnd28		?	~lsr_mask28					:
					rda_int_pnd28		? 1								:
					ti_int_pnd28		? ~fifo_read28					:
					thre_int_pnd28	? !(fifo_write28 & iir_read28) :
					ms_int_pnd28		? ~msr_read28						:
					0;	// if no interrupt28 are pending
end


// Interrupt28 Identification28 register
always @(posedge clk28 or posedge wb_rst_i28)
begin
	if (wb_rst_i28)
		iir28 <= #1 1;
	else
	if (rls_int_pnd28)  // interrupt28 is pending
	begin
		iir28[`UART_II_II28] <= #1 `UART_II_RLS28;	// set identification28 register to correct28 value
		iir28[`UART_II_IP28] <= #1 1'b0;		// and clear the IIR28 bit 0 (interrupt28 pending)
	end else // the sequence of conditions28 determines28 priority of interrupt28 identification28
	if (rda_int28)
	begin
		iir28[`UART_II_II28] <= #1 `UART_II_RDA28;
		iir28[`UART_II_IP28] <= #1 1'b0;
	end
	else if (ti_int_pnd28)
	begin
		iir28[`UART_II_II28] <= #1 `UART_II_TI28;
		iir28[`UART_II_IP28] <= #1 1'b0;
	end
	else if (thre_int_pnd28)
	begin
		iir28[`UART_II_II28] <= #1 `UART_II_THRE28;
		iir28[`UART_II_IP28] <= #1 1'b0;
	end
	else if (ms_int_pnd28)
	begin
		iir28[`UART_II_II28] <= #1 `UART_II_MS28;
		iir28[`UART_II_IP28] <= #1 1'b0;
	end else	// no interrupt28 is pending
	begin
		iir28[`UART_II_II28] <= #1 0;
		iir28[`UART_II_IP28] <= #1 1'b1;
	end
end

endmodule
