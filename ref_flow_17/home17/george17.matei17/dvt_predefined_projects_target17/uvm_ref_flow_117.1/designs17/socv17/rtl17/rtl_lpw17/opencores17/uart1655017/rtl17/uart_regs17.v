//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs17.v                                                 ////
////                                                              ////
////                                                              ////
////  This17 file is part of the "UART17 16550 compatible17" project17    ////
////  http17://www17.opencores17.org17/cores17/uart1655017/                   ////
////                                                              ////
////  Documentation17 related17 to this project17:                      ////
////  - http17://www17.opencores17.org17/cores17/uart1655017/                 ////
////                                                              ////
////  Projects17 compatibility17:                                     ////
////  - WISHBONE17                                                  ////
////  RS23217 Protocol17                                              ////
////  16550D uart17 (mostly17 supported)                              ////
////                                                              ////
////  Overview17 (main17 Features17):                                   ////
////  Registers17 of the uart17 16550 core17                            ////
////                                                              ////
////  Known17 problems17 (limits17):                                    ////
////  Inserts17 1 wait state in all WISHBONE17 transfers17              ////
////                                                              ////
////  To17 Do17:                                                      ////
////  Nothing or verification17.                                    ////
////                                                              ////
////  Author17(s):                                                  ////
////      - gorban17@opencores17.org17                                  ////
////      - Jacob17 Gorban17                                          ////
////      - Igor17 Mohor17 (igorm17@opencores17.org17)                      ////
////                                                              ////
////  Created17:        2001/05/12                                  ////
////  Last17 Updated17:   (See log17 for the revision17 history17           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2000, 2001 Authors17                             ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS17 Revision17 History17
//
// $Log: not supported by cvs2svn17 $
// Revision17 1.41  2004/05/21 11:44:41  tadejm17
// Added17 synchronizer17 flops17 for RX17 input.
//
// Revision17 1.40  2003/06/11 16:37:47  gorban17
// This17 fixes17 errors17 in some17 cases17 when data is being read and put to the FIFO at the same time. Patch17 is submitted17 by Scott17 Furman17. Update is very17 recommended17.
//
// Revision17 1.39  2002/07/29 21:16:18  gorban17
// The uart_defines17.v file is included17 again17 in sources17.
//
// Revision17 1.38  2002/07/22 23:02:23  gorban17
// Bug17 Fixes17:
//  * Possible17 loss of sync and bad17 reception17 of stop bit on slow17 baud17 rates17 fixed17.
//   Problem17 reported17 by Kenny17.Tung17.
//  * Bad (or lack17 of ) loopback17 handling17 fixed17. Reported17 by Cherry17 Withers17.
//
// Improvements17:
//  * Made17 FIFO's as general17 inferrable17 memory where possible17.
//  So17 on FPGA17 they should be inferred17 as RAM17 (Distributed17 RAM17 on Xilinx17).
//  This17 saves17 about17 1/3 of the Slice17 count and reduces17 P&R and synthesis17 times.
//
//  * Added17 optional17 baudrate17 output (baud_o17).
//  This17 is identical17 to BAUDOUT17* signal17 on 16550 chip17.
//  It outputs17 16xbit_clock_rate - the divided17 clock17.
//  It's disabled by default. Define17 UART_HAS_BAUDRATE_OUTPUT17 to use.
//
// Revision17 1.37  2001/12/27 13:24:09  mohor17
// lsr17[7] was not showing17 overrun17 errors17.
//
// Revision17 1.36  2001/12/20 13:25:46  mohor17
// rx17 push17 changed to be only one cycle wide17.
//
// Revision17 1.35  2001/12/19 08:03:34  mohor17
// Warnings17 cleared17.
//
// Revision17 1.34  2001/12/19 07:33:54  mohor17
// Synplicity17 was having17 troubles17 with the comment17.
//
// Revision17 1.33  2001/12/17 10:14:43  mohor17
// Things17 related17 to msr17 register changed. After17 THRE17 IRQ17 occurs17, and one
// character17 is written17 to the transmit17 fifo, the detection17 of the THRE17 bit in the
// LSR17 is delayed17 for one character17 time.
//
// Revision17 1.32  2001/12/14 13:19:24  mohor17
// MSR17 register fixed17.
//
// Revision17 1.31  2001/12/14 10:06:58  mohor17
// After17 reset modem17 status register MSR17 should be reset.
//
// Revision17 1.30  2001/12/13 10:09:13  mohor17
// thre17 irq17 should be cleared17 only when being source17 of interrupt17.
//
// Revision17 1.29  2001/12/12 09:05:46  mohor17
// LSR17 status bit 0 was not cleared17 correctly in case of reseting17 the FCR17 (rx17 fifo).
//
// Revision17 1.28  2001/12/10 19:52:41  gorban17
// Scratch17 register added
//
// Revision17 1.27  2001/12/06 14:51:04  gorban17
// Bug17 in LSR17[0] is fixed17.
// All WISHBONE17 signals17 are now sampled17, so another17 wait-state is introduced17 on all transfers17.
//
// Revision17 1.26  2001/12/03 21:44:29  gorban17
// Updated17 specification17 documentation.
// Added17 full 32-bit data bus interface, now as default.
// Address is 5-bit wide17 in 32-bit data bus mode.
// Added17 wb_sel_i17 input to the core17. It's used in the 32-bit mode.
// Added17 debug17 interface with two17 32-bit read-only registers in 32-bit mode.
// Bits17 5 and 6 of LSR17 are now only cleared17 on TX17 FIFO write.
// My17 small test bench17 is modified to work17 with 32-bit mode.
//
// Revision17 1.25  2001/11/28 19:36:39  gorban17
// Fixed17: timeout and break didn17't pay17 attention17 to current data format17 when counting17 time
//
// Revision17 1.24  2001/11/26 21:38:54  gorban17
// Lots17 of fixes17:
// Break17 condition wasn17't handled17 correctly at all.
// LSR17 bits could lose17 their17 values.
// LSR17 value after reset was wrong17.
// Timing17 of THRE17 interrupt17 signal17 corrected17.
// LSR17 bit 0 timing17 corrected17.
//
// Revision17 1.23  2001/11/12 21:57:29  gorban17
// fixed17 more typo17 bugs17
//
// Revision17 1.22  2001/11/12 15:02:28  mohor17
// lsr1r17 error fixed17.
//
// Revision17 1.21  2001/11/12 14:57:27  mohor17
// ti_int_pnd17 error fixed17.
//
// Revision17 1.20  2001/11/12 14:50:27  mohor17
// ti_int_d17 error fixed17.
//
// Revision17 1.19  2001/11/10 12:43:21  gorban17
// Logic17 Synthesis17 bugs17 fixed17. Some17 other minor17 changes17
//
// Revision17 1.18  2001/11/08 14:54:23  mohor17
// Comments17 in Slovene17 language17 deleted17, few17 small fixes17 for better17 work17 of
// old17 tools17. IRQs17 need to be fix17.
//
// Revision17 1.17  2001/11/07 17:51:52  gorban17
// Heavily17 rewritten17 interrupt17 and LSR17 subsystems17.
// Many17 bugs17 hopefully17 squashed17.
//
// Revision17 1.16  2001/11/02 09:55:16  mohor17
// no message
//
// Revision17 1.15  2001/10/31 15:19:22  gorban17
// Fixes17 to break and timeout conditions17
//
// Revision17 1.14  2001/10/29 17:00:46  gorban17
// fixed17 parity17 sending17 and tx_fifo17 resets17 over- and underrun17
//
// Revision17 1.13  2001/10/20 09:58:40  gorban17
// Small17 synopsis17 fixes17
//
// Revision17 1.12  2001/10/19 16:21:40  gorban17
// Changes17 data_out17 to be synchronous17 again17 as it should have been.
//
// Revision17 1.11  2001/10/18 20:35:45  gorban17
// small fix17
//
// Revision17 1.10  2001/08/24 21:01:12  mohor17
// Things17 connected17 to parity17 changed.
// Clock17 devider17 changed.
//
// Revision17 1.9  2001/08/23 16:05:05  mohor17
// Stop bit bug17 fixed17.
// Parity17 bug17 fixed17.
// WISHBONE17 read cycle bug17 fixed17,
// OE17 indicator17 (Overrun17 Error) bug17 fixed17.
// PE17 indicator17 (Parity17 Error) bug17 fixed17.
// Register read bug17 fixed17.
//
// Revision17 1.10  2001/06/23 11:21:48  gorban17
// DL17 made17 16-bit long17. Fixed17 transmission17/reception17 bugs17.
//
// Revision17 1.9  2001/05/31 20:08:01  gorban17
// FIFO changes17 and other corrections17.
//
// Revision17 1.8  2001/05/29 20:05:04  gorban17
// Fixed17 some17 bugs17 and synthesis17 problems17.
//
// Revision17 1.7  2001/05/27 17:37:49  gorban17
// Fixed17 many17 bugs17. Updated17 spec17. Changed17 FIFO files structure17. See CHANGES17.txt17 file.
//
// Revision17 1.6  2001/05/21 19:12:02  gorban17
// Corrected17 some17 Linter17 messages17.
//
// Revision17 1.5  2001/05/17 18:34:18  gorban17
// First17 'stable' release. Should17 be sythesizable17 now. Also17 added new header.
//
// Revision17 1.0  2001-05-17 21:27:11+02  jacob17
// Initial17 revision17
//
//

// synopsys17 translate_off17
`include "timescale.v"
// synopsys17 translate_on17

`include "uart_defines17.v"

`define UART_DL117 7:0
`define UART_DL217 15:8

module uart_regs17 (clk17,
	wb_rst_i17, wb_addr_i17, wb_dat_i17, wb_dat_o17, wb_we_i17, wb_re_i17, 

// additional17 signals17
	modem_inputs17,
	stx_pad_o17, srx_pad_i17,

`ifdef DATA_BUS_WIDTH_817
`else
// debug17 interface signals17	enabled
ier17, iir17, fcr17, mcr17, lcr17, msr17, lsr17, rf_count17, tf_count17, tstate17, rstate,
`endif				
	rts_pad_o17, dtr_pad_o17, int_o17
`ifdef UART_HAS_BAUDRATE_OUTPUT17
	, baud_o17
`endif

	);

input 									clk17;
input 									wb_rst_i17;
input [`UART_ADDR_WIDTH17-1:0] 		wb_addr_i17;
input [7:0] 							wb_dat_i17;
output [7:0] 							wb_dat_o17;
input 									wb_we_i17;
input 									wb_re_i17;

output 									stx_pad_o17;
input 									srx_pad_i17;

input [3:0] 							modem_inputs17;
output 									rts_pad_o17;
output 									dtr_pad_o17;
output 									int_o17;
`ifdef UART_HAS_BAUDRATE_OUTPUT17
output	baud_o17;
`endif

`ifdef DATA_BUS_WIDTH_817
`else
// if 32-bit databus17 and debug17 interface are enabled
output [3:0]							ier17;
output [3:0]							iir17;
output [1:0]							fcr17;  /// bits 7 and 6 of fcr17. Other17 bits are ignored
output [4:0]							mcr17;
output [7:0]							lcr17;
output [7:0]							msr17;
output [7:0] 							lsr17;
output [`UART_FIFO_COUNTER_W17-1:0] 	rf_count17;
output [`UART_FIFO_COUNTER_W17-1:0] 	tf_count17;
output [2:0] 							tstate17;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs17;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT17
assign baud_o17 = enable; // baud_o17 is actually17 the enable signal17
`endif


wire 										stx_pad_o17;		// received17 from transmitter17 module
wire 										srx_pad_i17;
wire 										srx_pad17;

reg [7:0] 								wb_dat_o17;

wire [`UART_ADDR_WIDTH17-1:0] 		wb_addr_i17;
wire [7:0] 								wb_dat_i17;


reg [3:0] 								ier17;
reg [3:0] 								iir17;
reg [1:0] 								fcr17;  /// bits 7 and 6 of fcr17. Other17 bits are ignored
reg [4:0] 								mcr17;
reg [7:0] 								lcr17;
reg [7:0] 								msr17;
reg [15:0] 								dl17;  // 32-bit divisor17 latch17
reg [7:0] 								scratch17; // UART17 scratch17 register
reg 										start_dlc17; // activate17 dlc17 on writing to UART_DL117
reg 										lsr_mask_d17; // delay for lsr_mask17 condition
reg 										msi_reset17; // reset MSR17 4 lower17 bits indicator17
//reg 										threi_clear17; // THRE17 interrupt17 clear flag17
reg [15:0] 								dlc17;  // 32-bit divisor17 latch17 counter
reg 										int_o17;

reg [3:0] 								trigger_level17; // trigger level of the receiver17 FIFO
reg 										rx_reset17;
reg 										tx_reset17;

wire 										dlab17;			   // divisor17 latch17 access bit
wire 										cts_pad_i17, dsr_pad_i17, ri_pad_i17, dcd_pad_i17; // modem17 status bits
wire 										loopback17;		   // loopback17 bit (MCR17 bit 4)
wire 										cts17, dsr17, ri, dcd17;	   // effective17 signals17
wire                    cts_c17, dsr_c17, ri_c17, dcd_c17; // Complement17 effective17 signals17 (considering17 loopback17)
wire 										rts_pad_o17, dtr_pad_o17;		   // modem17 control17 outputs17

// LSR17 bits wires17 and regs
wire [7:0] 								lsr17;
wire 										lsr017, lsr117, lsr217, lsr317, lsr417, lsr517, lsr617, lsr717;
reg										lsr0r17, lsr1r17, lsr2r17, lsr3r17, lsr4r17, lsr5r17, lsr6r17, lsr7r17;
wire 										lsr_mask17; // lsr_mask17

//
// ASSINGS17
//

assign 									lsr17[7:0] = { lsr7r17, lsr6r17, lsr5r17, lsr4r17, lsr3r17, lsr2r17, lsr1r17, lsr0r17 };

assign 									{cts_pad_i17, dsr_pad_i17, ri_pad_i17, dcd_pad_i17} = modem_inputs17;
assign 									{cts17, dsr17, ri, dcd17} = ~{cts_pad_i17,dsr_pad_i17,ri_pad_i17,dcd_pad_i17};

assign                  {cts_c17, dsr_c17, ri_c17, dcd_c17} = loopback17 ? {mcr17[`UART_MC_RTS17],mcr17[`UART_MC_DTR17],mcr17[`UART_MC_OUT117],mcr17[`UART_MC_OUT217]}
                                                               : {cts_pad_i17,dsr_pad_i17,ri_pad_i17,dcd_pad_i17};

assign 									dlab17 = lcr17[`UART_LC_DL17];
assign 									loopback17 = mcr17[4];

// assign modem17 outputs17
assign 									rts_pad_o17 = mcr17[`UART_MC_RTS17];
assign 									dtr_pad_o17 = mcr17[`UART_MC_DTR17];

// Interrupt17 signals17
wire 										rls_int17;  // receiver17 line status interrupt17
wire 										rda_int17;  // receiver17 data available interrupt17
wire 										ti_int17;   // timeout indicator17 interrupt17
wire										thre_int17; // transmitter17 holding17 register empty17 interrupt17
wire 										ms_int17;   // modem17 status interrupt17

// FIFO signals17
reg 										tf_push17;
reg 										rf_pop17;
wire [`UART_FIFO_REC_WIDTH17-1:0] 	rf_data_out17;
wire 										rf_error_bit17; // an error (parity17 or framing17) is inside the fifo
wire [`UART_FIFO_COUNTER_W17-1:0] 	rf_count17;
wire [`UART_FIFO_COUNTER_W17-1:0] 	tf_count17;
wire [2:0] 								tstate17;
wire [3:0] 								rstate;
wire [9:0] 								counter_t17;

wire                      thre_set_en17; // THRE17 status is delayed17 one character17 time when a character17 is written17 to fifo.
reg  [7:0]                block_cnt17;   // While17 counter counts17, THRE17 status is blocked17 (delayed17 one character17 cycle)
reg  [7:0]                block_value17; // One17 character17 length minus17 stop bit

// Transmitter17 Instance
wire serial_out17;

uart_transmitter17 transmitter17(clk17, wb_rst_i17, lcr17, tf_push17, wb_dat_i17, enable, serial_out17, tstate17, tf_count17, tx_reset17, lsr_mask17);

  // Synchronizing17 and sampling17 serial17 RX17 input
  uart_sync_flops17    i_uart_sync_flops17
  (
    .rst_i17           (wb_rst_i17),
    .clk_i17           (clk17),
    .stage1_rst_i17    (1'b0),
    .stage1_clk_en_i17 (1'b1),
    .async_dat_i17     (srx_pad_i17),
    .sync_dat_o17      (srx_pad17)
  );
  defparam i_uart_sync_flops17.width      = 1;
  defparam i_uart_sync_flops17.init_value17 = 1'b1;

// handle loopback17
wire serial_in17 = loopback17 ? serial_out17 : srx_pad17;
assign stx_pad_o17 = loopback17 ? 1'b1 : serial_out17;

// Receiver17 Instance
uart_receiver17 receiver17(clk17, wb_rst_i17, lcr17, rf_pop17, serial_in17, enable, 
	counter_t17, rf_count17, rf_data_out17, rf_error_bit17, rf_overrun17, rx_reset17, lsr_mask17, rstate, rf_push_pulse17);


// Asynchronous17 reading here17 because the outputs17 are sampled17 in uart_wb17.v file 
always @(dl17 or dlab17 or ier17 or iir17 or scratch17
			or lcr17 or lsr17 or msr17 or rf_data_out17 or wb_addr_i17 or wb_re_i17)   // asynchrounous17 reading
begin
	case (wb_addr_i17)
		`UART_REG_RB17   : wb_dat_o17 = dlab17 ? dl17[`UART_DL117] : rf_data_out17[10:3];
		`UART_REG_IE17	: wb_dat_o17 = dlab17 ? dl17[`UART_DL217] : ier17;
		`UART_REG_II17	: wb_dat_o17 = {4'b1100,iir17};
		`UART_REG_LC17	: wb_dat_o17 = lcr17;
		`UART_REG_LS17	: wb_dat_o17 = lsr17;
		`UART_REG_MS17	: wb_dat_o17 = msr17;
		`UART_REG_SR17	: wb_dat_o17 = scratch17;
		default:  wb_dat_o17 = 8'b0; // ??
	endcase // case(wb_addr_i17)
end // always @ (dl17 or dlab17 or ier17 or iir17 or scratch17...


// rf_pop17 signal17 handling17
always @(posedge clk17 or posedge wb_rst_i17)
begin
	if (wb_rst_i17)
		rf_pop17 <= #1 0; 
	else
	if (rf_pop17)	// restore17 the signal17 to 0 after one clock17 cycle
		rf_pop17 <= #1 0;
	else
	if (wb_re_i17 && wb_addr_i17 == `UART_REG_RB17 && !dlab17)
		rf_pop17 <= #1 1; // advance17 read pointer17
end

wire 	lsr_mask_condition17;
wire 	iir_read17;
wire  msr_read17;
wire	fifo_read17;
wire	fifo_write17;

assign lsr_mask_condition17 = (wb_re_i17 && wb_addr_i17 == `UART_REG_LS17 && !dlab17);
assign iir_read17 = (wb_re_i17 && wb_addr_i17 == `UART_REG_II17 && !dlab17);
assign msr_read17 = (wb_re_i17 && wb_addr_i17 == `UART_REG_MS17 && !dlab17);
assign fifo_read17 = (wb_re_i17 && wb_addr_i17 == `UART_REG_RB17 && !dlab17);
assign fifo_write17 = (wb_we_i17 && wb_addr_i17 == `UART_REG_TR17 && !dlab17);

// lsr_mask_d17 delayed17 signal17 handling17
always @(posedge clk17 or posedge wb_rst_i17)
begin
	if (wb_rst_i17)
		lsr_mask_d17 <= #1 0;
	else // reset bits in the Line17 Status Register
		lsr_mask_d17 <= #1 lsr_mask_condition17;
end

// lsr_mask17 is rise17 detected
assign lsr_mask17 = lsr_mask_condition17 && ~lsr_mask_d17;

// msi_reset17 signal17 handling17
always @(posedge clk17 or posedge wb_rst_i17)
begin
	if (wb_rst_i17)
		msi_reset17 <= #1 1;
	else
	if (msi_reset17)
		msi_reset17 <= #1 0;
	else
	if (msr_read17)
		msi_reset17 <= #1 1; // reset bits in Modem17 Status Register
end


//
//   WRITES17 AND17 RESETS17   //
//
// Line17 Control17 Register
always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17)
		lcr17 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i17 && wb_addr_i17==`UART_REG_LC17)
		lcr17 <= #1 wb_dat_i17;

// Interrupt17 Enable17 Register or UART_DL217
always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17)
	begin
		ier17 <= #1 4'b0000; // no interrupts17 after reset
		dl17[`UART_DL217] <= #1 8'b0;
	end
	else
	if (wb_we_i17 && wb_addr_i17==`UART_REG_IE17)
		if (dlab17)
		begin
			dl17[`UART_DL217] <= #1 wb_dat_i17;
		end
		else
			ier17 <= #1 wb_dat_i17[3:0]; // ier17 uses only 4 lsb


// FIFO Control17 Register and rx_reset17, tx_reset17 signals17
always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) begin
		fcr17 <= #1 2'b11; 
		rx_reset17 <= #1 0;
		tx_reset17 <= #1 0;
	end else
	if (wb_we_i17 && wb_addr_i17==`UART_REG_FC17) begin
		fcr17 <= #1 wb_dat_i17[7:6];
		rx_reset17 <= #1 wb_dat_i17[1];
		tx_reset17 <= #1 wb_dat_i17[2];
	end else begin
		rx_reset17 <= #1 0;
		tx_reset17 <= #1 0;
	end

// Modem17 Control17 Register
always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17)
		mcr17 <= #1 5'b0; 
	else
	if (wb_we_i17 && wb_addr_i17==`UART_REG_MC17)
			mcr17 <= #1 wb_dat_i17[4:0];

// Scratch17 register
// Line17 Control17 Register
always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17)
		scratch17 <= #1 0; // 8n1 setting
	else
	if (wb_we_i17 && wb_addr_i17==`UART_REG_SR17)
		scratch17 <= #1 wb_dat_i17;

// TX_FIFO17 or UART_DL117
always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17)
	begin
		dl17[`UART_DL117]  <= #1 8'b0;
		tf_push17   <= #1 1'b0;
		start_dlc17 <= #1 1'b0;
	end
	else
	if (wb_we_i17 && wb_addr_i17==`UART_REG_TR17)
		if (dlab17)
		begin
			dl17[`UART_DL117] <= #1 wb_dat_i17;
			start_dlc17 <= #1 1'b1; // enable DL17 counter
			tf_push17 <= #1 1'b0;
		end
		else
		begin
			tf_push17   <= #1 1'b1;
			start_dlc17 <= #1 1'b0;
		end // else: !if(dlab17)
	else
	begin
		start_dlc17 <= #1 1'b0;
		tf_push17   <= #1 1'b0;
	end // else: !if(dlab17)

// Receiver17 FIFO trigger level selection logic (asynchronous17 mux17)
always @(fcr17)
	case (fcr17[`UART_FC_TL17])
		2'b00 : trigger_level17 = 1;
		2'b01 : trigger_level17 = 4;
		2'b10 : trigger_level17 = 8;
		2'b11 : trigger_level17 = 14;
	endcase // case(fcr17[`UART_FC_TL17])
	
//
//  STATUS17 REGISTERS17  //
//

// Modem17 Status Register
reg [3:0] delayed_modem_signals17;
always @(posedge clk17 or posedge wb_rst_i17)
begin
	if (wb_rst_i17)
	  begin
  		msr17 <= #1 0;
	  	delayed_modem_signals17[3:0] <= #1 0;
	  end
	else begin
		msr17[`UART_MS_DDCD17:`UART_MS_DCTS17] <= #1 msi_reset17 ? 4'b0 :
			msr17[`UART_MS_DDCD17:`UART_MS_DCTS17] | ({dcd17, ri, dsr17, cts17} ^ delayed_modem_signals17[3:0]);
		msr17[`UART_MS_CDCD17:`UART_MS_CCTS17] <= #1 {dcd_c17, ri_c17, dsr_c17, cts_c17};
		delayed_modem_signals17[3:0] <= #1 {dcd17, ri, dsr17, cts17};
	end
end


// Line17 Status Register

// activation17 conditions17
assign lsr017 = (rf_count17==0 && rf_push_pulse17);  // data in receiver17 fifo available set condition
assign lsr117 = rf_overrun17;     // Receiver17 overrun17 error
assign lsr217 = rf_data_out17[1]; // parity17 error bit
assign lsr317 = rf_data_out17[0]; // framing17 error bit
assign lsr417 = rf_data_out17[2]; // break error in the character17
assign lsr517 = (tf_count17==5'b0 && thre_set_en17);  // transmitter17 fifo is empty17
assign lsr617 = (tf_count17==5'b0 && thre_set_en17 && (tstate17 == /*`S_IDLE17 */ 0)); // transmitter17 empty17
assign lsr717 = rf_error_bit17 | rf_overrun17;

// lsr17 bit017 (receiver17 data available)
reg 	 lsr0_d17;

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr0_d17 <= #1 0;
	else lsr0_d17 <= #1 lsr017;

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr0r17 <= #1 0;
	else lsr0r17 <= #1 (rf_count17==1 && rf_pop17 && !rf_push_pulse17 || rx_reset17) ? 0 : // deassert17 condition
					  lsr0r17 || (lsr017 && ~lsr0_d17); // set on rise17 of lsr017 and keep17 asserted17 until deasserted17 

// lsr17 bit 1 (receiver17 overrun17)
reg lsr1_d17; // delayed17

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr1_d17 <= #1 0;
	else lsr1_d17 <= #1 lsr117;

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr1r17 <= #1 0;
	else	lsr1r17 <= #1	lsr_mask17 ? 0 : lsr1r17 || (lsr117 && ~lsr1_d17); // set on rise17

// lsr17 bit 2 (parity17 error)
reg lsr2_d17; // delayed17

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr2_d17 <= #1 0;
	else lsr2_d17 <= #1 lsr217;

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr2r17 <= #1 0;
	else lsr2r17 <= #1 lsr_mask17 ? 0 : lsr2r17 || (lsr217 && ~lsr2_d17); // set on rise17

// lsr17 bit 3 (framing17 error)
reg lsr3_d17; // delayed17

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr3_d17 <= #1 0;
	else lsr3_d17 <= #1 lsr317;

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr3r17 <= #1 0;
	else lsr3r17 <= #1 lsr_mask17 ? 0 : lsr3r17 || (lsr317 && ~lsr3_d17); // set on rise17

// lsr17 bit 4 (break indicator17)
reg lsr4_d17; // delayed17

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr4_d17 <= #1 0;
	else lsr4_d17 <= #1 lsr417;

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr4r17 <= #1 0;
	else lsr4r17 <= #1 lsr_mask17 ? 0 : lsr4r17 || (lsr417 && ~lsr4_d17);

// lsr17 bit 5 (transmitter17 fifo is empty17)
reg lsr5_d17;

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr5_d17 <= #1 1;
	else lsr5_d17 <= #1 lsr517;

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr5r17 <= #1 1;
	else lsr5r17 <= #1 (fifo_write17) ? 0 :  lsr5r17 || (lsr517 && ~lsr5_d17);

// lsr17 bit 6 (transmitter17 empty17 indicator17)
reg lsr6_d17;

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr6_d17 <= #1 1;
	else lsr6_d17 <= #1 lsr617;

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr6r17 <= #1 1;
	else lsr6r17 <= #1 (fifo_write17) ? 0 : lsr6r17 || (lsr617 && ~lsr6_d17);

// lsr17 bit 7 (error in fifo)
reg lsr7_d17;

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr7_d17 <= #1 0;
	else lsr7_d17 <= #1 lsr717;

always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) lsr7r17 <= #1 0;
	else lsr7r17 <= #1 lsr_mask17 ? 0 : lsr7r17 || (lsr717 && ~lsr7_d17);

// Frequency17 divider17
always @(posedge clk17 or posedge wb_rst_i17) 
begin
	if (wb_rst_i17)
		dlc17 <= #1 0;
	else
		if (start_dlc17 | ~ (|dlc17))
  			dlc17 <= #1 dl17 - 1;               // preset17 counter
		else
			dlc17 <= #1 dlc17 - 1;              // decrement counter
end

// Enable17 signal17 generation17 logic
always @(posedge clk17 or posedge wb_rst_i17)
begin
	if (wb_rst_i17)
		enable <= #1 1'b0;
	else
		if (|dl17 & ~(|dlc17))     // dl17>0 & dlc17==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying17 THRE17 status for one character17 cycle after a character17 is written17 to an empty17 fifo.
always @(lcr17)
  case (lcr17[3:0])
    4'b0000                             : block_value17 =  95; // 6 bits
    4'b0100                             : block_value17 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value17 = 111; // 7 bits
    4'b1100                             : block_value17 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value17 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value17 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value17 = 159; // 10 bits
    4'b1111                             : block_value17 = 175; // 11 bits
  endcase // case(lcr17[3:0])

// Counting17 time of one character17 minus17 stop bit
always @(posedge clk17 or posedge wb_rst_i17)
begin
  if (wb_rst_i17)
    block_cnt17 <= #1 8'd0;
  else
  if(lsr5r17 & fifo_write17)  // THRE17 bit set & write to fifo occured17
    block_cnt17 <= #1 block_value17;
  else
  if (enable & block_cnt17 != 8'b0)  // only work17 on enable times
    block_cnt17 <= #1 block_cnt17 - 1;  // decrement break counter
end // always of break condition detection17

// Generating17 THRE17 status enable signal17
assign thre_set_en17 = ~(|block_cnt17);


//
//	INTERRUPT17 LOGIC17
//

assign rls_int17  = ier17[`UART_IE_RLS17] && (lsr17[`UART_LS_OE17] || lsr17[`UART_LS_PE17] || lsr17[`UART_LS_FE17] || lsr17[`UART_LS_BI17]);
assign rda_int17  = ier17[`UART_IE_RDA17] && (rf_count17 >= {1'b0,trigger_level17});
assign thre_int17 = ier17[`UART_IE_THRE17] && lsr17[`UART_LS_TFE17];
assign ms_int17   = ier17[`UART_IE_MS17] && (| msr17[3:0]);
assign ti_int17   = ier17[`UART_IE_RDA17] && (counter_t17 == 10'b0) && (|rf_count17);

reg 	 rls_int_d17;
reg 	 thre_int_d17;
reg 	 ms_int_d17;
reg 	 ti_int_d17;
reg 	 rda_int_d17;

// delay lines17
always  @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) rls_int_d17 <= #1 0;
	else rls_int_d17 <= #1 rls_int17;

always  @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) rda_int_d17 <= #1 0;
	else rda_int_d17 <= #1 rda_int17;

always  @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) thre_int_d17 <= #1 0;
	else thre_int_d17 <= #1 thre_int17;

always  @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) ms_int_d17 <= #1 0;
	else ms_int_d17 <= #1 ms_int17;

always  @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) ti_int_d17 <= #1 0;
	else ti_int_d17 <= #1 ti_int17;

// rise17 detection17 signals17

wire 	 rls_int_rise17;
wire 	 thre_int_rise17;
wire 	 ms_int_rise17;
wire 	 ti_int_rise17;
wire 	 rda_int_rise17;

assign rda_int_rise17    = rda_int17 & ~rda_int_d17;
assign rls_int_rise17 	  = rls_int17 & ~rls_int_d17;
assign thre_int_rise17   = thre_int17 & ~thre_int_d17;
assign ms_int_rise17 	  = ms_int17 & ~ms_int_d17;
assign ti_int_rise17 	  = ti_int17 & ~ti_int_d17;

// interrupt17 pending flags17
reg 	rls_int_pnd17;
reg	rda_int_pnd17;
reg 	thre_int_pnd17;
reg 	ms_int_pnd17;
reg 	ti_int_pnd17;

// interrupt17 pending flags17 assignments17
always  @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) rls_int_pnd17 <= #1 0; 
	else 
		rls_int_pnd17 <= #1 lsr_mask17 ? 0 :  						// reset condition
							rls_int_rise17 ? 1 :						// latch17 condition
							rls_int_pnd17 && ier17[`UART_IE_RLS17];	// default operation17: remove if masked17

always  @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) rda_int_pnd17 <= #1 0; 
	else 
		rda_int_pnd17 <= #1 ((rf_count17 == {1'b0,trigger_level17}) && fifo_read17) ? 0 :  	// reset condition
							rda_int_rise17 ? 1 :						// latch17 condition
							rda_int_pnd17 && ier17[`UART_IE_RDA17];	// default operation17: remove if masked17

always  @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) thre_int_pnd17 <= #1 0; 
	else 
		thre_int_pnd17 <= #1 fifo_write17 || (iir_read17 & ~iir17[`UART_II_IP17] & iir17[`UART_II_II17] == `UART_II_THRE17)? 0 : 
							thre_int_rise17 ? 1 :
							thre_int_pnd17 && ier17[`UART_IE_THRE17];

always  @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) ms_int_pnd17 <= #1 0; 
	else 
		ms_int_pnd17 <= #1 msr_read17 ? 0 : 
							ms_int_rise17 ? 1 :
							ms_int_pnd17 && ier17[`UART_IE_MS17];

always  @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) ti_int_pnd17 <= #1 0; 
	else 
		ti_int_pnd17 <= #1 fifo_read17 ? 0 : 
							ti_int_rise17 ? 1 :
							ti_int_pnd17 && ier17[`UART_IE_RDA17];
// end of pending flags17

// INT_O17 logic
always @(posedge clk17 or posedge wb_rst_i17)
begin
	if (wb_rst_i17)	
		int_o17 <= #1 1'b0;
	else
		int_o17 <= #1 
					rls_int_pnd17		?	~lsr_mask17					:
					rda_int_pnd17		? 1								:
					ti_int_pnd17		? ~fifo_read17					:
					thre_int_pnd17	? !(fifo_write17 & iir_read17) :
					ms_int_pnd17		? ~msr_read17						:
					0;	// if no interrupt17 are pending
end


// Interrupt17 Identification17 register
always @(posedge clk17 or posedge wb_rst_i17)
begin
	if (wb_rst_i17)
		iir17 <= #1 1;
	else
	if (rls_int_pnd17)  // interrupt17 is pending
	begin
		iir17[`UART_II_II17] <= #1 `UART_II_RLS17;	// set identification17 register to correct17 value
		iir17[`UART_II_IP17] <= #1 1'b0;		// and clear the IIR17 bit 0 (interrupt17 pending)
	end else // the sequence of conditions17 determines17 priority of interrupt17 identification17
	if (rda_int17)
	begin
		iir17[`UART_II_II17] <= #1 `UART_II_RDA17;
		iir17[`UART_II_IP17] <= #1 1'b0;
	end
	else if (ti_int_pnd17)
	begin
		iir17[`UART_II_II17] <= #1 `UART_II_TI17;
		iir17[`UART_II_IP17] <= #1 1'b0;
	end
	else if (thre_int_pnd17)
	begin
		iir17[`UART_II_II17] <= #1 `UART_II_THRE17;
		iir17[`UART_II_IP17] <= #1 1'b0;
	end
	else if (ms_int_pnd17)
	begin
		iir17[`UART_II_II17] <= #1 `UART_II_MS17;
		iir17[`UART_II_IP17] <= #1 1'b0;
	end else	// no interrupt17 is pending
	begin
		iir17[`UART_II_II17] <= #1 0;
		iir17[`UART_II_IP17] <= #1 1'b1;
	end
end

endmodule
