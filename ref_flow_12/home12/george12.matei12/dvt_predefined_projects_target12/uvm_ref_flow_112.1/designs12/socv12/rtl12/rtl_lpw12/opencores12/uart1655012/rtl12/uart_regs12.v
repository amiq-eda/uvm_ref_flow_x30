//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs12.v                                                 ////
////                                                              ////
////                                                              ////
////  This12 file is part of the "UART12 16550 compatible12" project12    ////
////  http12://www12.opencores12.org12/cores12/uart1655012/                   ////
////                                                              ////
////  Documentation12 related12 to this project12:                      ////
////  - http12://www12.opencores12.org12/cores12/uart1655012/                 ////
////                                                              ////
////  Projects12 compatibility12:                                     ////
////  - WISHBONE12                                                  ////
////  RS23212 Protocol12                                              ////
////  16550D uart12 (mostly12 supported)                              ////
////                                                              ////
////  Overview12 (main12 Features12):                                   ////
////  Registers12 of the uart12 16550 core12                            ////
////                                                              ////
////  Known12 problems12 (limits12):                                    ////
////  Inserts12 1 wait state in all WISHBONE12 transfers12              ////
////                                                              ////
////  To12 Do12:                                                      ////
////  Nothing or verification12.                                    ////
////                                                              ////
////  Author12(s):                                                  ////
////      - gorban12@opencores12.org12                                  ////
////      - Jacob12 Gorban12                                          ////
////      - Igor12 Mohor12 (igorm12@opencores12.org12)                      ////
////                                                              ////
////  Created12:        2001/05/12                                  ////
////  Last12 Updated12:   (See log12 for the revision12 history12           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright12 (C) 2000, 2001 Authors12                             ////
////                                                              ////
//// This12 source12 file may be used and distributed12 without         ////
//// restriction12 provided that this copyright12 statement12 is not    ////
//// removed from the file and that any derivative12 work12 contains12  ////
//// the original copyright12 notice12 and the associated disclaimer12. ////
////                                                              ////
//// This12 source12 file is free software12; you can redistribute12 it   ////
//// and/or modify it under the terms12 of the GNU12 Lesser12 General12   ////
//// Public12 License12 as published12 by the Free12 Software12 Foundation12; ////
//// either12 version12 2.1 of the License12, or (at your12 option) any   ////
//// later12 version12.                                               ////
////                                                              ////
//// This12 source12 is distributed12 in the hope12 that it will be       ////
//// useful12, but WITHOUT12 ANY12 WARRANTY12; without even12 the implied12   ////
//// warranty12 of MERCHANTABILITY12 or FITNESS12 FOR12 A PARTICULAR12      ////
//// PURPOSE12.  See the GNU12 Lesser12 General12 Public12 License12 for more ////
//// details12.                                                     ////
////                                                              ////
//// You should have received12 a copy of the GNU12 Lesser12 General12    ////
//// Public12 License12 along12 with this source12; if not, download12 it   ////
//// from http12://www12.opencores12.org12/lgpl12.shtml12                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS12 Revision12 History12
//
// $Log: not supported by cvs2svn12 $
// Revision12 1.41  2004/05/21 11:44:41  tadejm12
// Added12 synchronizer12 flops12 for RX12 input.
//
// Revision12 1.40  2003/06/11 16:37:47  gorban12
// This12 fixes12 errors12 in some12 cases12 when data is being read and put to the FIFO at the same time. Patch12 is submitted12 by Scott12 Furman12. Update is very12 recommended12.
//
// Revision12 1.39  2002/07/29 21:16:18  gorban12
// The uart_defines12.v file is included12 again12 in sources12.
//
// Revision12 1.38  2002/07/22 23:02:23  gorban12
// Bug12 Fixes12:
//  * Possible12 loss of sync and bad12 reception12 of stop bit on slow12 baud12 rates12 fixed12.
//   Problem12 reported12 by Kenny12.Tung12.
//  * Bad (or lack12 of ) loopback12 handling12 fixed12. Reported12 by Cherry12 Withers12.
//
// Improvements12:
//  * Made12 FIFO's as general12 inferrable12 memory where possible12.
//  So12 on FPGA12 they should be inferred12 as RAM12 (Distributed12 RAM12 on Xilinx12).
//  This12 saves12 about12 1/3 of the Slice12 count and reduces12 P&R and synthesis12 times.
//
//  * Added12 optional12 baudrate12 output (baud_o12).
//  This12 is identical12 to BAUDOUT12* signal12 on 16550 chip12.
//  It outputs12 16xbit_clock_rate - the divided12 clock12.
//  It's disabled by default. Define12 UART_HAS_BAUDRATE_OUTPUT12 to use.
//
// Revision12 1.37  2001/12/27 13:24:09  mohor12
// lsr12[7] was not showing12 overrun12 errors12.
//
// Revision12 1.36  2001/12/20 13:25:46  mohor12
// rx12 push12 changed to be only one cycle wide12.
//
// Revision12 1.35  2001/12/19 08:03:34  mohor12
// Warnings12 cleared12.
//
// Revision12 1.34  2001/12/19 07:33:54  mohor12
// Synplicity12 was having12 troubles12 with the comment12.
//
// Revision12 1.33  2001/12/17 10:14:43  mohor12
// Things12 related12 to msr12 register changed. After12 THRE12 IRQ12 occurs12, and one
// character12 is written12 to the transmit12 fifo, the detection12 of the THRE12 bit in the
// LSR12 is delayed12 for one character12 time.
//
// Revision12 1.32  2001/12/14 13:19:24  mohor12
// MSR12 register fixed12.
//
// Revision12 1.31  2001/12/14 10:06:58  mohor12
// After12 reset modem12 status register MSR12 should be reset.
//
// Revision12 1.30  2001/12/13 10:09:13  mohor12
// thre12 irq12 should be cleared12 only when being source12 of interrupt12.
//
// Revision12 1.29  2001/12/12 09:05:46  mohor12
// LSR12 status bit 0 was not cleared12 correctly in case of reseting12 the FCR12 (rx12 fifo).
//
// Revision12 1.28  2001/12/10 19:52:41  gorban12
// Scratch12 register added
//
// Revision12 1.27  2001/12/06 14:51:04  gorban12
// Bug12 in LSR12[0] is fixed12.
// All WISHBONE12 signals12 are now sampled12, so another12 wait-state is introduced12 on all transfers12.
//
// Revision12 1.26  2001/12/03 21:44:29  gorban12
// Updated12 specification12 documentation.
// Added12 full 32-bit data bus interface, now as default.
// Address is 5-bit wide12 in 32-bit data bus mode.
// Added12 wb_sel_i12 input to the core12. It's used in the 32-bit mode.
// Added12 debug12 interface with two12 32-bit read-only registers in 32-bit mode.
// Bits12 5 and 6 of LSR12 are now only cleared12 on TX12 FIFO write.
// My12 small test bench12 is modified to work12 with 32-bit mode.
//
// Revision12 1.25  2001/11/28 19:36:39  gorban12
// Fixed12: timeout and break didn12't pay12 attention12 to current data format12 when counting12 time
//
// Revision12 1.24  2001/11/26 21:38:54  gorban12
// Lots12 of fixes12:
// Break12 condition wasn12't handled12 correctly at all.
// LSR12 bits could lose12 their12 values.
// LSR12 value after reset was wrong12.
// Timing12 of THRE12 interrupt12 signal12 corrected12.
// LSR12 bit 0 timing12 corrected12.
//
// Revision12 1.23  2001/11/12 21:57:29  gorban12
// fixed12 more typo12 bugs12
//
// Revision12 1.22  2001/11/12 15:02:28  mohor12
// lsr1r12 error fixed12.
//
// Revision12 1.21  2001/11/12 14:57:27  mohor12
// ti_int_pnd12 error fixed12.
//
// Revision12 1.20  2001/11/12 14:50:27  mohor12
// ti_int_d12 error fixed12.
//
// Revision12 1.19  2001/11/10 12:43:21  gorban12
// Logic12 Synthesis12 bugs12 fixed12. Some12 other minor12 changes12
//
// Revision12 1.18  2001/11/08 14:54:23  mohor12
// Comments12 in Slovene12 language12 deleted12, few12 small fixes12 for better12 work12 of
// old12 tools12. IRQs12 need to be fix12.
//
// Revision12 1.17  2001/11/07 17:51:52  gorban12
// Heavily12 rewritten12 interrupt12 and LSR12 subsystems12.
// Many12 bugs12 hopefully12 squashed12.
//
// Revision12 1.16  2001/11/02 09:55:16  mohor12
// no message
//
// Revision12 1.15  2001/10/31 15:19:22  gorban12
// Fixes12 to break and timeout conditions12
//
// Revision12 1.14  2001/10/29 17:00:46  gorban12
// fixed12 parity12 sending12 and tx_fifo12 resets12 over- and underrun12
//
// Revision12 1.13  2001/10/20 09:58:40  gorban12
// Small12 synopsis12 fixes12
//
// Revision12 1.12  2001/10/19 16:21:40  gorban12
// Changes12 data_out12 to be synchronous12 again12 as it should have been.
//
// Revision12 1.11  2001/10/18 20:35:45  gorban12
// small fix12
//
// Revision12 1.10  2001/08/24 21:01:12  mohor12
// Things12 connected12 to parity12 changed.
// Clock12 devider12 changed.
//
// Revision12 1.9  2001/08/23 16:05:05  mohor12
// Stop bit bug12 fixed12.
// Parity12 bug12 fixed12.
// WISHBONE12 read cycle bug12 fixed12,
// OE12 indicator12 (Overrun12 Error) bug12 fixed12.
// PE12 indicator12 (Parity12 Error) bug12 fixed12.
// Register read bug12 fixed12.
//
// Revision12 1.10  2001/06/23 11:21:48  gorban12
// DL12 made12 16-bit long12. Fixed12 transmission12/reception12 bugs12.
//
// Revision12 1.9  2001/05/31 20:08:01  gorban12
// FIFO changes12 and other corrections12.
//
// Revision12 1.8  2001/05/29 20:05:04  gorban12
// Fixed12 some12 bugs12 and synthesis12 problems12.
//
// Revision12 1.7  2001/05/27 17:37:49  gorban12
// Fixed12 many12 bugs12. Updated12 spec12. Changed12 FIFO files structure12. See CHANGES12.txt12 file.
//
// Revision12 1.6  2001/05/21 19:12:02  gorban12
// Corrected12 some12 Linter12 messages12.
//
// Revision12 1.5  2001/05/17 18:34:18  gorban12
// First12 'stable' release. Should12 be sythesizable12 now. Also12 added new header.
//
// Revision12 1.0  2001-05-17 21:27:11+02  jacob12
// Initial12 revision12
//
//

// synopsys12 translate_off12
`include "timescale.v"
// synopsys12 translate_on12

`include "uart_defines12.v"

`define UART_DL112 7:0
`define UART_DL212 15:8

module uart_regs12 (clk12,
	wb_rst_i12, wb_addr_i12, wb_dat_i12, wb_dat_o12, wb_we_i12, wb_re_i12, 

// additional12 signals12
	modem_inputs12,
	stx_pad_o12, srx_pad_i12,

`ifdef DATA_BUS_WIDTH_812
`else
// debug12 interface signals12	enabled
ier12, iir12, fcr12, mcr12, lcr12, msr12, lsr12, rf_count12, tf_count12, tstate12, rstate,
`endif				
	rts_pad_o12, dtr_pad_o12, int_o12
`ifdef UART_HAS_BAUDRATE_OUTPUT12
	, baud_o12
`endif

	);

input 									clk12;
input 									wb_rst_i12;
input [`UART_ADDR_WIDTH12-1:0] 		wb_addr_i12;
input [7:0] 							wb_dat_i12;
output [7:0] 							wb_dat_o12;
input 									wb_we_i12;
input 									wb_re_i12;

output 									stx_pad_o12;
input 									srx_pad_i12;

input [3:0] 							modem_inputs12;
output 									rts_pad_o12;
output 									dtr_pad_o12;
output 									int_o12;
`ifdef UART_HAS_BAUDRATE_OUTPUT12
output	baud_o12;
`endif

`ifdef DATA_BUS_WIDTH_812
`else
// if 32-bit databus12 and debug12 interface are enabled
output [3:0]							ier12;
output [3:0]							iir12;
output [1:0]							fcr12;  /// bits 7 and 6 of fcr12. Other12 bits are ignored
output [4:0]							mcr12;
output [7:0]							lcr12;
output [7:0]							msr12;
output [7:0] 							lsr12;
output [`UART_FIFO_COUNTER_W12-1:0] 	rf_count12;
output [`UART_FIFO_COUNTER_W12-1:0] 	tf_count12;
output [2:0] 							tstate12;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs12;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT12
assign baud_o12 = enable; // baud_o12 is actually12 the enable signal12
`endif


wire 										stx_pad_o12;		// received12 from transmitter12 module
wire 										srx_pad_i12;
wire 										srx_pad12;

reg [7:0] 								wb_dat_o12;

wire [`UART_ADDR_WIDTH12-1:0] 		wb_addr_i12;
wire [7:0] 								wb_dat_i12;


reg [3:0] 								ier12;
reg [3:0] 								iir12;
reg [1:0] 								fcr12;  /// bits 7 and 6 of fcr12. Other12 bits are ignored
reg [4:0] 								mcr12;
reg [7:0] 								lcr12;
reg [7:0] 								msr12;
reg [15:0] 								dl12;  // 32-bit divisor12 latch12
reg [7:0] 								scratch12; // UART12 scratch12 register
reg 										start_dlc12; // activate12 dlc12 on writing to UART_DL112
reg 										lsr_mask_d12; // delay for lsr_mask12 condition
reg 										msi_reset12; // reset MSR12 4 lower12 bits indicator12
//reg 										threi_clear12; // THRE12 interrupt12 clear flag12
reg [15:0] 								dlc12;  // 32-bit divisor12 latch12 counter
reg 										int_o12;

reg [3:0] 								trigger_level12; // trigger level of the receiver12 FIFO
reg 										rx_reset12;
reg 										tx_reset12;

wire 										dlab12;			   // divisor12 latch12 access bit
wire 										cts_pad_i12, dsr_pad_i12, ri_pad_i12, dcd_pad_i12; // modem12 status bits
wire 										loopback12;		   // loopback12 bit (MCR12 bit 4)
wire 										cts12, dsr12, ri, dcd12;	   // effective12 signals12
wire                    cts_c12, dsr_c12, ri_c12, dcd_c12; // Complement12 effective12 signals12 (considering12 loopback12)
wire 										rts_pad_o12, dtr_pad_o12;		   // modem12 control12 outputs12

// LSR12 bits wires12 and regs
wire [7:0] 								lsr12;
wire 										lsr012, lsr112, lsr212, lsr312, lsr412, lsr512, lsr612, lsr712;
reg										lsr0r12, lsr1r12, lsr2r12, lsr3r12, lsr4r12, lsr5r12, lsr6r12, lsr7r12;
wire 										lsr_mask12; // lsr_mask12

//
// ASSINGS12
//

assign 									lsr12[7:0] = { lsr7r12, lsr6r12, lsr5r12, lsr4r12, lsr3r12, lsr2r12, lsr1r12, lsr0r12 };

assign 									{cts_pad_i12, dsr_pad_i12, ri_pad_i12, dcd_pad_i12} = modem_inputs12;
assign 									{cts12, dsr12, ri, dcd12} = ~{cts_pad_i12,dsr_pad_i12,ri_pad_i12,dcd_pad_i12};

assign                  {cts_c12, dsr_c12, ri_c12, dcd_c12} = loopback12 ? {mcr12[`UART_MC_RTS12],mcr12[`UART_MC_DTR12],mcr12[`UART_MC_OUT112],mcr12[`UART_MC_OUT212]}
                                                               : {cts_pad_i12,dsr_pad_i12,ri_pad_i12,dcd_pad_i12};

assign 									dlab12 = lcr12[`UART_LC_DL12];
assign 									loopback12 = mcr12[4];

// assign modem12 outputs12
assign 									rts_pad_o12 = mcr12[`UART_MC_RTS12];
assign 									dtr_pad_o12 = mcr12[`UART_MC_DTR12];

// Interrupt12 signals12
wire 										rls_int12;  // receiver12 line status interrupt12
wire 										rda_int12;  // receiver12 data available interrupt12
wire 										ti_int12;   // timeout indicator12 interrupt12
wire										thre_int12; // transmitter12 holding12 register empty12 interrupt12
wire 										ms_int12;   // modem12 status interrupt12

// FIFO signals12
reg 										tf_push12;
reg 										rf_pop12;
wire [`UART_FIFO_REC_WIDTH12-1:0] 	rf_data_out12;
wire 										rf_error_bit12; // an error (parity12 or framing12) is inside the fifo
wire [`UART_FIFO_COUNTER_W12-1:0] 	rf_count12;
wire [`UART_FIFO_COUNTER_W12-1:0] 	tf_count12;
wire [2:0] 								tstate12;
wire [3:0] 								rstate;
wire [9:0] 								counter_t12;

wire                      thre_set_en12; // THRE12 status is delayed12 one character12 time when a character12 is written12 to fifo.
reg  [7:0]                block_cnt12;   // While12 counter counts12, THRE12 status is blocked12 (delayed12 one character12 cycle)
reg  [7:0]                block_value12; // One12 character12 length minus12 stop bit

// Transmitter12 Instance
wire serial_out12;

uart_transmitter12 transmitter12(clk12, wb_rst_i12, lcr12, tf_push12, wb_dat_i12, enable, serial_out12, tstate12, tf_count12, tx_reset12, lsr_mask12);

  // Synchronizing12 and sampling12 serial12 RX12 input
  uart_sync_flops12    i_uart_sync_flops12
  (
    .rst_i12           (wb_rst_i12),
    .clk_i12           (clk12),
    .stage1_rst_i12    (1'b0),
    .stage1_clk_en_i12 (1'b1),
    .async_dat_i12     (srx_pad_i12),
    .sync_dat_o12      (srx_pad12)
  );
  defparam i_uart_sync_flops12.width      = 1;
  defparam i_uart_sync_flops12.init_value12 = 1'b1;

// handle loopback12
wire serial_in12 = loopback12 ? serial_out12 : srx_pad12;
assign stx_pad_o12 = loopback12 ? 1'b1 : serial_out12;

// Receiver12 Instance
uart_receiver12 receiver12(clk12, wb_rst_i12, lcr12, rf_pop12, serial_in12, enable, 
	counter_t12, rf_count12, rf_data_out12, rf_error_bit12, rf_overrun12, rx_reset12, lsr_mask12, rstate, rf_push_pulse12);


// Asynchronous12 reading here12 because the outputs12 are sampled12 in uart_wb12.v file 
always @(dl12 or dlab12 or ier12 or iir12 or scratch12
			or lcr12 or lsr12 or msr12 or rf_data_out12 or wb_addr_i12 or wb_re_i12)   // asynchrounous12 reading
begin
	case (wb_addr_i12)
		`UART_REG_RB12   : wb_dat_o12 = dlab12 ? dl12[`UART_DL112] : rf_data_out12[10:3];
		`UART_REG_IE12	: wb_dat_o12 = dlab12 ? dl12[`UART_DL212] : ier12;
		`UART_REG_II12	: wb_dat_o12 = {4'b1100,iir12};
		`UART_REG_LC12	: wb_dat_o12 = lcr12;
		`UART_REG_LS12	: wb_dat_o12 = lsr12;
		`UART_REG_MS12	: wb_dat_o12 = msr12;
		`UART_REG_SR12	: wb_dat_o12 = scratch12;
		default:  wb_dat_o12 = 8'b0; // ??
	endcase // case(wb_addr_i12)
end // always @ (dl12 or dlab12 or ier12 or iir12 or scratch12...


// rf_pop12 signal12 handling12
always @(posedge clk12 or posedge wb_rst_i12)
begin
	if (wb_rst_i12)
		rf_pop12 <= #1 0; 
	else
	if (rf_pop12)	// restore12 the signal12 to 0 after one clock12 cycle
		rf_pop12 <= #1 0;
	else
	if (wb_re_i12 && wb_addr_i12 == `UART_REG_RB12 && !dlab12)
		rf_pop12 <= #1 1; // advance12 read pointer12
end

wire 	lsr_mask_condition12;
wire 	iir_read12;
wire  msr_read12;
wire	fifo_read12;
wire	fifo_write12;

assign lsr_mask_condition12 = (wb_re_i12 && wb_addr_i12 == `UART_REG_LS12 && !dlab12);
assign iir_read12 = (wb_re_i12 && wb_addr_i12 == `UART_REG_II12 && !dlab12);
assign msr_read12 = (wb_re_i12 && wb_addr_i12 == `UART_REG_MS12 && !dlab12);
assign fifo_read12 = (wb_re_i12 && wb_addr_i12 == `UART_REG_RB12 && !dlab12);
assign fifo_write12 = (wb_we_i12 && wb_addr_i12 == `UART_REG_TR12 && !dlab12);

// lsr_mask_d12 delayed12 signal12 handling12
always @(posedge clk12 or posedge wb_rst_i12)
begin
	if (wb_rst_i12)
		lsr_mask_d12 <= #1 0;
	else // reset bits in the Line12 Status Register
		lsr_mask_d12 <= #1 lsr_mask_condition12;
end

// lsr_mask12 is rise12 detected
assign lsr_mask12 = lsr_mask_condition12 && ~lsr_mask_d12;

// msi_reset12 signal12 handling12
always @(posedge clk12 or posedge wb_rst_i12)
begin
	if (wb_rst_i12)
		msi_reset12 <= #1 1;
	else
	if (msi_reset12)
		msi_reset12 <= #1 0;
	else
	if (msr_read12)
		msi_reset12 <= #1 1; // reset bits in Modem12 Status Register
end


//
//   WRITES12 AND12 RESETS12   //
//
// Line12 Control12 Register
always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12)
		lcr12 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i12 && wb_addr_i12==`UART_REG_LC12)
		lcr12 <= #1 wb_dat_i12;

// Interrupt12 Enable12 Register or UART_DL212
always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12)
	begin
		ier12 <= #1 4'b0000; // no interrupts12 after reset
		dl12[`UART_DL212] <= #1 8'b0;
	end
	else
	if (wb_we_i12 && wb_addr_i12==`UART_REG_IE12)
		if (dlab12)
		begin
			dl12[`UART_DL212] <= #1 wb_dat_i12;
		end
		else
			ier12 <= #1 wb_dat_i12[3:0]; // ier12 uses only 4 lsb


// FIFO Control12 Register and rx_reset12, tx_reset12 signals12
always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) begin
		fcr12 <= #1 2'b11; 
		rx_reset12 <= #1 0;
		tx_reset12 <= #1 0;
	end else
	if (wb_we_i12 && wb_addr_i12==`UART_REG_FC12) begin
		fcr12 <= #1 wb_dat_i12[7:6];
		rx_reset12 <= #1 wb_dat_i12[1];
		tx_reset12 <= #1 wb_dat_i12[2];
	end else begin
		rx_reset12 <= #1 0;
		tx_reset12 <= #1 0;
	end

// Modem12 Control12 Register
always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12)
		mcr12 <= #1 5'b0; 
	else
	if (wb_we_i12 && wb_addr_i12==`UART_REG_MC12)
			mcr12 <= #1 wb_dat_i12[4:0];

// Scratch12 register
// Line12 Control12 Register
always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12)
		scratch12 <= #1 0; // 8n1 setting
	else
	if (wb_we_i12 && wb_addr_i12==`UART_REG_SR12)
		scratch12 <= #1 wb_dat_i12;

// TX_FIFO12 or UART_DL112
always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12)
	begin
		dl12[`UART_DL112]  <= #1 8'b0;
		tf_push12   <= #1 1'b0;
		start_dlc12 <= #1 1'b0;
	end
	else
	if (wb_we_i12 && wb_addr_i12==`UART_REG_TR12)
		if (dlab12)
		begin
			dl12[`UART_DL112] <= #1 wb_dat_i12;
			start_dlc12 <= #1 1'b1; // enable DL12 counter
			tf_push12 <= #1 1'b0;
		end
		else
		begin
			tf_push12   <= #1 1'b1;
			start_dlc12 <= #1 1'b0;
		end // else: !if(dlab12)
	else
	begin
		start_dlc12 <= #1 1'b0;
		tf_push12   <= #1 1'b0;
	end // else: !if(dlab12)

// Receiver12 FIFO trigger level selection logic (asynchronous12 mux12)
always @(fcr12)
	case (fcr12[`UART_FC_TL12])
		2'b00 : trigger_level12 = 1;
		2'b01 : trigger_level12 = 4;
		2'b10 : trigger_level12 = 8;
		2'b11 : trigger_level12 = 14;
	endcase // case(fcr12[`UART_FC_TL12])
	
//
//  STATUS12 REGISTERS12  //
//

// Modem12 Status Register
reg [3:0] delayed_modem_signals12;
always @(posedge clk12 or posedge wb_rst_i12)
begin
	if (wb_rst_i12)
	  begin
  		msr12 <= #1 0;
	  	delayed_modem_signals12[3:0] <= #1 0;
	  end
	else begin
		msr12[`UART_MS_DDCD12:`UART_MS_DCTS12] <= #1 msi_reset12 ? 4'b0 :
			msr12[`UART_MS_DDCD12:`UART_MS_DCTS12] | ({dcd12, ri, dsr12, cts12} ^ delayed_modem_signals12[3:0]);
		msr12[`UART_MS_CDCD12:`UART_MS_CCTS12] <= #1 {dcd_c12, ri_c12, dsr_c12, cts_c12};
		delayed_modem_signals12[3:0] <= #1 {dcd12, ri, dsr12, cts12};
	end
end


// Line12 Status Register

// activation12 conditions12
assign lsr012 = (rf_count12==0 && rf_push_pulse12);  // data in receiver12 fifo available set condition
assign lsr112 = rf_overrun12;     // Receiver12 overrun12 error
assign lsr212 = rf_data_out12[1]; // parity12 error bit
assign lsr312 = rf_data_out12[0]; // framing12 error bit
assign lsr412 = rf_data_out12[2]; // break error in the character12
assign lsr512 = (tf_count12==5'b0 && thre_set_en12);  // transmitter12 fifo is empty12
assign lsr612 = (tf_count12==5'b0 && thre_set_en12 && (tstate12 == /*`S_IDLE12 */ 0)); // transmitter12 empty12
assign lsr712 = rf_error_bit12 | rf_overrun12;

// lsr12 bit012 (receiver12 data available)
reg 	 lsr0_d12;

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr0_d12 <= #1 0;
	else lsr0_d12 <= #1 lsr012;

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr0r12 <= #1 0;
	else lsr0r12 <= #1 (rf_count12==1 && rf_pop12 && !rf_push_pulse12 || rx_reset12) ? 0 : // deassert12 condition
					  lsr0r12 || (lsr012 && ~lsr0_d12); // set on rise12 of lsr012 and keep12 asserted12 until deasserted12 

// lsr12 bit 1 (receiver12 overrun12)
reg lsr1_d12; // delayed12

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr1_d12 <= #1 0;
	else lsr1_d12 <= #1 lsr112;

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr1r12 <= #1 0;
	else	lsr1r12 <= #1	lsr_mask12 ? 0 : lsr1r12 || (lsr112 && ~lsr1_d12); // set on rise12

// lsr12 bit 2 (parity12 error)
reg lsr2_d12; // delayed12

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr2_d12 <= #1 0;
	else lsr2_d12 <= #1 lsr212;

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr2r12 <= #1 0;
	else lsr2r12 <= #1 lsr_mask12 ? 0 : lsr2r12 || (lsr212 && ~lsr2_d12); // set on rise12

// lsr12 bit 3 (framing12 error)
reg lsr3_d12; // delayed12

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr3_d12 <= #1 0;
	else lsr3_d12 <= #1 lsr312;

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr3r12 <= #1 0;
	else lsr3r12 <= #1 lsr_mask12 ? 0 : lsr3r12 || (lsr312 && ~lsr3_d12); // set on rise12

// lsr12 bit 4 (break indicator12)
reg lsr4_d12; // delayed12

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr4_d12 <= #1 0;
	else lsr4_d12 <= #1 lsr412;

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr4r12 <= #1 0;
	else lsr4r12 <= #1 lsr_mask12 ? 0 : lsr4r12 || (lsr412 && ~lsr4_d12);

// lsr12 bit 5 (transmitter12 fifo is empty12)
reg lsr5_d12;

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr5_d12 <= #1 1;
	else lsr5_d12 <= #1 lsr512;

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr5r12 <= #1 1;
	else lsr5r12 <= #1 (fifo_write12) ? 0 :  lsr5r12 || (lsr512 && ~lsr5_d12);

// lsr12 bit 6 (transmitter12 empty12 indicator12)
reg lsr6_d12;

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr6_d12 <= #1 1;
	else lsr6_d12 <= #1 lsr612;

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr6r12 <= #1 1;
	else lsr6r12 <= #1 (fifo_write12) ? 0 : lsr6r12 || (lsr612 && ~lsr6_d12);

// lsr12 bit 7 (error in fifo)
reg lsr7_d12;

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr7_d12 <= #1 0;
	else lsr7_d12 <= #1 lsr712;

always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) lsr7r12 <= #1 0;
	else lsr7r12 <= #1 lsr_mask12 ? 0 : lsr7r12 || (lsr712 && ~lsr7_d12);

// Frequency12 divider12
always @(posedge clk12 or posedge wb_rst_i12) 
begin
	if (wb_rst_i12)
		dlc12 <= #1 0;
	else
		if (start_dlc12 | ~ (|dlc12))
  			dlc12 <= #1 dl12 - 1;               // preset12 counter
		else
			dlc12 <= #1 dlc12 - 1;              // decrement counter
end

// Enable12 signal12 generation12 logic
always @(posedge clk12 or posedge wb_rst_i12)
begin
	if (wb_rst_i12)
		enable <= #1 1'b0;
	else
		if (|dl12 & ~(|dlc12))     // dl12>0 & dlc12==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying12 THRE12 status for one character12 cycle after a character12 is written12 to an empty12 fifo.
always @(lcr12)
  case (lcr12[3:0])
    4'b0000                             : block_value12 =  95; // 6 bits
    4'b0100                             : block_value12 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value12 = 111; // 7 bits
    4'b1100                             : block_value12 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value12 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value12 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value12 = 159; // 10 bits
    4'b1111                             : block_value12 = 175; // 11 bits
  endcase // case(lcr12[3:0])

// Counting12 time of one character12 minus12 stop bit
always @(posedge clk12 or posedge wb_rst_i12)
begin
  if (wb_rst_i12)
    block_cnt12 <= #1 8'd0;
  else
  if(lsr5r12 & fifo_write12)  // THRE12 bit set & write to fifo occured12
    block_cnt12 <= #1 block_value12;
  else
  if (enable & block_cnt12 != 8'b0)  // only work12 on enable times
    block_cnt12 <= #1 block_cnt12 - 1;  // decrement break counter
end // always of break condition detection12

// Generating12 THRE12 status enable signal12
assign thre_set_en12 = ~(|block_cnt12);


//
//	INTERRUPT12 LOGIC12
//

assign rls_int12  = ier12[`UART_IE_RLS12] && (lsr12[`UART_LS_OE12] || lsr12[`UART_LS_PE12] || lsr12[`UART_LS_FE12] || lsr12[`UART_LS_BI12]);
assign rda_int12  = ier12[`UART_IE_RDA12] && (rf_count12 >= {1'b0,trigger_level12});
assign thre_int12 = ier12[`UART_IE_THRE12] && lsr12[`UART_LS_TFE12];
assign ms_int12   = ier12[`UART_IE_MS12] && (| msr12[3:0]);
assign ti_int12   = ier12[`UART_IE_RDA12] && (counter_t12 == 10'b0) && (|rf_count12);

reg 	 rls_int_d12;
reg 	 thre_int_d12;
reg 	 ms_int_d12;
reg 	 ti_int_d12;
reg 	 rda_int_d12;

// delay lines12
always  @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) rls_int_d12 <= #1 0;
	else rls_int_d12 <= #1 rls_int12;

always  @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) rda_int_d12 <= #1 0;
	else rda_int_d12 <= #1 rda_int12;

always  @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) thre_int_d12 <= #1 0;
	else thre_int_d12 <= #1 thre_int12;

always  @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) ms_int_d12 <= #1 0;
	else ms_int_d12 <= #1 ms_int12;

always  @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) ti_int_d12 <= #1 0;
	else ti_int_d12 <= #1 ti_int12;

// rise12 detection12 signals12

wire 	 rls_int_rise12;
wire 	 thre_int_rise12;
wire 	 ms_int_rise12;
wire 	 ti_int_rise12;
wire 	 rda_int_rise12;

assign rda_int_rise12    = rda_int12 & ~rda_int_d12;
assign rls_int_rise12 	  = rls_int12 & ~rls_int_d12;
assign thre_int_rise12   = thre_int12 & ~thre_int_d12;
assign ms_int_rise12 	  = ms_int12 & ~ms_int_d12;
assign ti_int_rise12 	  = ti_int12 & ~ti_int_d12;

// interrupt12 pending flags12
reg 	rls_int_pnd12;
reg	rda_int_pnd12;
reg 	thre_int_pnd12;
reg 	ms_int_pnd12;
reg 	ti_int_pnd12;

// interrupt12 pending flags12 assignments12
always  @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) rls_int_pnd12 <= #1 0; 
	else 
		rls_int_pnd12 <= #1 lsr_mask12 ? 0 :  						// reset condition
							rls_int_rise12 ? 1 :						// latch12 condition
							rls_int_pnd12 && ier12[`UART_IE_RLS12];	// default operation12: remove if masked12

always  @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) rda_int_pnd12 <= #1 0; 
	else 
		rda_int_pnd12 <= #1 ((rf_count12 == {1'b0,trigger_level12}) && fifo_read12) ? 0 :  	// reset condition
							rda_int_rise12 ? 1 :						// latch12 condition
							rda_int_pnd12 && ier12[`UART_IE_RDA12];	// default operation12: remove if masked12

always  @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) thre_int_pnd12 <= #1 0; 
	else 
		thre_int_pnd12 <= #1 fifo_write12 || (iir_read12 & ~iir12[`UART_II_IP12] & iir12[`UART_II_II12] == `UART_II_THRE12)? 0 : 
							thre_int_rise12 ? 1 :
							thre_int_pnd12 && ier12[`UART_IE_THRE12];

always  @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) ms_int_pnd12 <= #1 0; 
	else 
		ms_int_pnd12 <= #1 msr_read12 ? 0 : 
							ms_int_rise12 ? 1 :
							ms_int_pnd12 && ier12[`UART_IE_MS12];

always  @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) ti_int_pnd12 <= #1 0; 
	else 
		ti_int_pnd12 <= #1 fifo_read12 ? 0 : 
							ti_int_rise12 ? 1 :
							ti_int_pnd12 && ier12[`UART_IE_RDA12];
// end of pending flags12

// INT_O12 logic
always @(posedge clk12 or posedge wb_rst_i12)
begin
	if (wb_rst_i12)	
		int_o12 <= #1 1'b0;
	else
		int_o12 <= #1 
					rls_int_pnd12		?	~lsr_mask12					:
					rda_int_pnd12		? 1								:
					ti_int_pnd12		? ~fifo_read12					:
					thre_int_pnd12	? !(fifo_write12 & iir_read12) :
					ms_int_pnd12		? ~msr_read12						:
					0;	// if no interrupt12 are pending
end


// Interrupt12 Identification12 register
always @(posedge clk12 or posedge wb_rst_i12)
begin
	if (wb_rst_i12)
		iir12 <= #1 1;
	else
	if (rls_int_pnd12)  // interrupt12 is pending
	begin
		iir12[`UART_II_II12] <= #1 `UART_II_RLS12;	// set identification12 register to correct12 value
		iir12[`UART_II_IP12] <= #1 1'b0;		// and clear the IIR12 bit 0 (interrupt12 pending)
	end else // the sequence of conditions12 determines12 priority of interrupt12 identification12
	if (rda_int12)
	begin
		iir12[`UART_II_II12] <= #1 `UART_II_RDA12;
		iir12[`UART_II_IP12] <= #1 1'b0;
	end
	else if (ti_int_pnd12)
	begin
		iir12[`UART_II_II12] <= #1 `UART_II_TI12;
		iir12[`UART_II_IP12] <= #1 1'b0;
	end
	else if (thre_int_pnd12)
	begin
		iir12[`UART_II_II12] <= #1 `UART_II_THRE12;
		iir12[`UART_II_IP12] <= #1 1'b0;
	end
	else if (ms_int_pnd12)
	begin
		iir12[`UART_II_II12] <= #1 `UART_II_MS12;
		iir12[`UART_II_IP12] <= #1 1'b0;
	end else	// no interrupt12 is pending
	begin
		iir12[`UART_II_II12] <= #1 0;
		iir12[`UART_II_IP12] <= #1 1'b1;
	end
end

endmodule
