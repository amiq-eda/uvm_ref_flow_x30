//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs15.v                                                 ////
////                                                              ////
////                                                              ////
////  This15 file is part of the "UART15 16550 compatible15" project15    ////
////  http15://www15.opencores15.org15/cores15/uart1655015/                   ////
////                                                              ////
////  Documentation15 related15 to this project15:                      ////
////  - http15://www15.opencores15.org15/cores15/uart1655015/                 ////
////                                                              ////
////  Projects15 compatibility15:                                     ////
////  - WISHBONE15                                                  ////
////  RS23215 Protocol15                                              ////
////  16550D uart15 (mostly15 supported)                              ////
////                                                              ////
////  Overview15 (main15 Features15):                                   ////
////  Registers15 of the uart15 16550 core15                            ////
////                                                              ////
////  Known15 problems15 (limits15):                                    ////
////  Inserts15 1 wait state in all WISHBONE15 transfers15              ////
////                                                              ////
////  To15 Do15:                                                      ////
////  Nothing or verification15.                                    ////
////                                                              ////
////  Author15(s):                                                  ////
////      - gorban15@opencores15.org15                                  ////
////      - Jacob15 Gorban15                                          ////
////      - Igor15 Mohor15 (igorm15@opencores15.org15)                      ////
////                                                              ////
////  Created15:        2001/05/12                                  ////
////  Last15 Updated15:   (See log15 for the revision15 history15           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2000, 2001 Authors15                             ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS15 Revision15 History15
//
// $Log: not supported by cvs2svn15 $
// Revision15 1.41  2004/05/21 11:44:41  tadejm15
// Added15 synchronizer15 flops15 for RX15 input.
//
// Revision15 1.40  2003/06/11 16:37:47  gorban15
// This15 fixes15 errors15 in some15 cases15 when data is being read and put to the FIFO at the same time. Patch15 is submitted15 by Scott15 Furman15. Update is very15 recommended15.
//
// Revision15 1.39  2002/07/29 21:16:18  gorban15
// The uart_defines15.v file is included15 again15 in sources15.
//
// Revision15 1.38  2002/07/22 23:02:23  gorban15
// Bug15 Fixes15:
//  * Possible15 loss of sync and bad15 reception15 of stop bit on slow15 baud15 rates15 fixed15.
//   Problem15 reported15 by Kenny15.Tung15.
//  * Bad (or lack15 of ) loopback15 handling15 fixed15. Reported15 by Cherry15 Withers15.
//
// Improvements15:
//  * Made15 FIFO's as general15 inferrable15 memory where possible15.
//  So15 on FPGA15 they should be inferred15 as RAM15 (Distributed15 RAM15 on Xilinx15).
//  This15 saves15 about15 1/3 of the Slice15 count and reduces15 P&R and synthesis15 times.
//
//  * Added15 optional15 baudrate15 output (baud_o15).
//  This15 is identical15 to BAUDOUT15* signal15 on 16550 chip15.
//  It outputs15 16xbit_clock_rate - the divided15 clock15.
//  It's disabled by default. Define15 UART_HAS_BAUDRATE_OUTPUT15 to use.
//
// Revision15 1.37  2001/12/27 13:24:09  mohor15
// lsr15[7] was not showing15 overrun15 errors15.
//
// Revision15 1.36  2001/12/20 13:25:46  mohor15
// rx15 push15 changed to be only one cycle wide15.
//
// Revision15 1.35  2001/12/19 08:03:34  mohor15
// Warnings15 cleared15.
//
// Revision15 1.34  2001/12/19 07:33:54  mohor15
// Synplicity15 was having15 troubles15 with the comment15.
//
// Revision15 1.33  2001/12/17 10:14:43  mohor15
// Things15 related15 to msr15 register changed. After15 THRE15 IRQ15 occurs15, and one
// character15 is written15 to the transmit15 fifo, the detection15 of the THRE15 bit in the
// LSR15 is delayed15 for one character15 time.
//
// Revision15 1.32  2001/12/14 13:19:24  mohor15
// MSR15 register fixed15.
//
// Revision15 1.31  2001/12/14 10:06:58  mohor15
// After15 reset modem15 status register MSR15 should be reset.
//
// Revision15 1.30  2001/12/13 10:09:13  mohor15
// thre15 irq15 should be cleared15 only when being source15 of interrupt15.
//
// Revision15 1.29  2001/12/12 09:05:46  mohor15
// LSR15 status bit 0 was not cleared15 correctly in case of reseting15 the FCR15 (rx15 fifo).
//
// Revision15 1.28  2001/12/10 19:52:41  gorban15
// Scratch15 register added
//
// Revision15 1.27  2001/12/06 14:51:04  gorban15
// Bug15 in LSR15[0] is fixed15.
// All WISHBONE15 signals15 are now sampled15, so another15 wait-state is introduced15 on all transfers15.
//
// Revision15 1.26  2001/12/03 21:44:29  gorban15
// Updated15 specification15 documentation.
// Added15 full 32-bit data bus interface, now as default.
// Address is 5-bit wide15 in 32-bit data bus mode.
// Added15 wb_sel_i15 input to the core15. It's used in the 32-bit mode.
// Added15 debug15 interface with two15 32-bit read-only registers in 32-bit mode.
// Bits15 5 and 6 of LSR15 are now only cleared15 on TX15 FIFO write.
// My15 small test bench15 is modified to work15 with 32-bit mode.
//
// Revision15 1.25  2001/11/28 19:36:39  gorban15
// Fixed15: timeout and break didn15't pay15 attention15 to current data format15 when counting15 time
//
// Revision15 1.24  2001/11/26 21:38:54  gorban15
// Lots15 of fixes15:
// Break15 condition wasn15't handled15 correctly at all.
// LSR15 bits could lose15 their15 values.
// LSR15 value after reset was wrong15.
// Timing15 of THRE15 interrupt15 signal15 corrected15.
// LSR15 bit 0 timing15 corrected15.
//
// Revision15 1.23  2001/11/12 21:57:29  gorban15
// fixed15 more typo15 bugs15
//
// Revision15 1.22  2001/11/12 15:02:28  mohor15
// lsr1r15 error fixed15.
//
// Revision15 1.21  2001/11/12 14:57:27  mohor15
// ti_int_pnd15 error fixed15.
//
// Revision15 1.20  2001/11/12 14:50:27  mohor15
// ti_int_d15 error fixed15.
//
// Revision15 1.19  2001/11/10 12:43:21  gorban15
// Logic15 Synthesis15 bugs15 fixed15. Some15 other minor15 changes15
//
// Revision15 1.18  2001/11/08 14:54:23  mohor15
// Comments15 in Slovene15 language15 deleted15, few15 small fixes15 for better15 work15 of
// old15 tools15. IRQs15 need to be fix15.
//
// Revision15 1.17  2001/11/07 17:51:52  gorban15
// Heavily15 rewritten15 interrupt15 and LSR15 subsystems15.
// Many15 bugs15 hopefully15 squashed15.
//
// Revision15 1.16  2001/11/02 09:55:16  mohor15
// no message
//
// Revision15 1.15  2001/10/31 15:19:22  gorban15
// Fixes15 to break and timeout conditions15
//
// Revision15 1.14  2001/10/29 17:00:46  gorban15
// fixed15 parity15 sending15 and tx_fifo15 resets15 over- and underrun15
//
// Revision15 1.13  2001/10/20 09:58:40  gorban15
// Small15 synopsis15 fixes15
//
// Revision15 1.12  2001/10/19 16:21:40  gorban15
// Changes15 data_out15 to be synchronous15 again15 as it should have been.
//
// Revision15 1.11  2001/10/18 20:35:45  gorban15
// small fix15
//
// Revision15 1.10  2001/08/24 21:01:12  mohor15
// Things15 connected15 to parity15 changed.
// Clock15 devider15 changed.
//
// Revision15 1.9  2001/08/23 16:05:05  mohor15
// Stop bit bug15 fixed15.
// Parity15 bug15 fixed15.
// WISHBONE15 read cycle bug15 fixed15,
// OE15 indicator15 (Overrun15 Error) bug15 fixed15.
// PE15 indicator15 (Parity15 Error) bug15 fixed15.
// Register read bug15 fixed15.
//
// Revision15 1.10  2001/06/23 11:21:48  gorban15
// DL15 made15 16-bit long15. Fixed15 transmission15/reception15 bugs15.
//
// Revision15 1.9  2001/05/31 20:08:01  gorban15
// FIFO changes15 and other corrections15.
//
// Revision15 1.8  2001/05/29 20:05:04  gorban15
// Fixed15 some15 bugs15 and synthesis15 problems15.
//
// Revision15 1.7  2001/05/27 17:37:49  gorban15
// Fixed15 many15 bugs15. Updated15 spec15. Changed15 FIFO files structure15. See CHANGES15.txt15 file.
//
// Revision15 1.6  2001/05/21 19:12:02  gorban15
// Corrected15 some15 Linter15 messages15.
//
// Revision15 1.5  2001/05/17 18:34:18  gorban15
// First15 'stable' release. Should15 be sythesizable15 now. Also15 added new header.
//
// Revision15 1.0  2001-05-17 21:27:11+02  jacob15
// Initial15 revision15
//
//

// synopsys15 translate_off15
`include "timescale.v"
// synopsys15 translate_on15

`include "uart_defines15.v"

`define UART_DL115 7:0
`define UART_DL215 15:8

module uart_regs15 (clk15,
	wb_rst_i15, wb_addr_i15, wb_dat_i15, wb_dat_o15, wb_we_i15, wb_re_i15, 

// additional15 signals15
	modem_inputs15,
	stx_pad_o15, srx_pad_i15,

`ifdef DATA_BUS_WIDTH_815
`else
// debug15 interface signals15	enabled
ier15, iir15, fcr15, mcr15, lcr15, msr15, lsr15, rf_count15, tf_count15, tstate15, rstate,
`endif				
	rts_pad_o15, dtr_pad_o15, int_o15
`ifdef UART_HAS_BAUDRATE_OUTPUT15
	, baud_o15
`endif

	);

input 									clk15;
input 									wb_rst_i15;
input [`UART_ADDR_WIDTH15-1:0] 		wb_addr_i15;
input [7:0] 							wb_dat_i15;
output [7:0] 							wb_dat_o15;
input 									wb_we_i15;
input 									wb_re_i15;

output 									stx_pad_o15;
input 									srx_pad_i15;

input [3:0] 							modem_inputs15;
output 									rts_pad_o15;
output 									dtr_pad_o15;
output 									int_o15;
`ifdef UART_HAS_BAUDRATE_OUTPUT15
output	baud_o15;
`endif

`ifdef DATA_BUS_WIDTH_815
`else
// if 32-bit databus15 and debug15 interface are enabled
output [3:0]							ier15;
output [3:0]							iir15;
output [1:0]							fcr15;  /// bits 7 and 6 of fcr15. Other15 bits are ignored
output [4:0]							mcr15;
output [7:0]							lcr15;
output [7:0]							msr15;
output [7:0] 							lsr15;
output [`UART_FIFO_COUNTER_W15-1:0] 	rf_count15;
output [`UART_FIFO_COUNTER_W15-1:0] 	tf_count15;
output [2:0] 							tstate15;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs15;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT15
assign baud_o15 = enable; // baud_o15 is actually15 the enable signal15
`endif


wire 										stx_pad_o15;		// received15 from transmitter15 module
wire 										srx_pad_i15;
wire 										srx_pad15;

reg [7:0] 								wb_dat_o15;

wire [`UART_ADDR_WIDTH15-1:0] 		wb_addr_i15;
wire [7:0] 								wb_dat_i15;


reg [3:0] 								ier15;
reg [3:0] 								iir15;
reg [1:0] 								fcr15;  /// bits 7 and 6 of fcr15. Other15 bits are ignored
reg [4:0] 								mcr15;
reg [7:0] 								lcr15;
reg [7:0] 								msr15;
reg [15:0] 								dl15;  // 32-bit divisor15 latch15
reg [7:0] 								scratch15; // UART15 scratch15 register
reg 										start_dlc15; // activate15 dlc15 on writing to UART_DL115
reg 										lsr_mask_d15; // delay for lsr_mask15 condition
reg 										msi_reset15; // reset MSR15 4 lower15 bits indicator15
//reg 										threi_clear15; // THRE15 interrupt15 clear flag15
reg [15:0] 								dlc15;  // 32-bit divisor15 latch15 counter
reg 										int_o15;

reg [3:0] 								trigger_level15; // trigger level of the receiver15 FIFO
reg 										rx_reset15;
reg 										tx_reset15;

wire 										dlab15;			   // divisor15 latch15 access bit
wire 										cts_pad_i15, dsr_pad_i15, ri_pad_i15, dcd_pad_i15; // modem15 status bits
wire 										loopback15;		   // loopback15 bit (MCR15 bit 4)
wire 										cts15, dsr15, ri, dcd15;	   // effective15 signals15
wire                    cts_c15, dsr_c15, ri_c15, dcd_c15; // Complement15 effective15 signals15 (considering15 loopback15)
wire 										rts_pad_o15, dtr_pad_o15;		   // modem15 control15 outputs15

// LSR15 bits wires15 and regs
wire [7:0] 								lsr15;
wire 										lsr015, lsr115, lsr215, lsr315, lsr415, lsr515, lsr615, lsr715;
reg										lsr0r15, lsr1r15, lsr2r15, lsr3r15, lsr4r15, lsr5r15, lsr6r15, lsr7r15;
wire 										lsr_mask15; // lsr_mask15

//
// ASSINGS15
//

assign 									lsr15[7:0] = { lsr7r15, lsr6r15, lsr5r15, lsr4r15, lsr3r15, lsr2r15, lsr1r15, lsr0r15 };

assign 									{cts_pad_i15, dsr_pad_i15, ri_pad_i15, dcd_pad_i15} = modem_inputs15;
assign 									{cts15, dsr15, ri, dcd15} = ~{cts_pad_i15,dsr_pad_i15,ri_pad_i15,dcd_pad_i15};

assign                  {cts_c15, dsr_c15, ri_c15, dcd_c15} = loopback15 ? {mcr15[`UART_MC_RTS15],mcr15[`UART_MC_DTR15],mcr15[`UART_MC_OUT115],mcr15[`UART_MC_OUT215]}
                                                               : {cts_pad_i15,dsr_pad_i15,ri_pad_i15,dcd_pad_i15};

assign 									dlab15 = lcr15[`UART_LC_DL15];
assign 									loopback15 = mcr15[4];

// assign modem15 outputs15
assign 									rts_pad_o15 = mcr15[`UART_MC_RTS15];
assign 									dtr_pad_o15 = mcr15[`UART_MC_DTR15];

// Interrupt15 signals15
wire 										rls_int15;  // receiver15 line status interrupt15
wire 										rda_int15;  // receiver15 data available interrupt15
wire 										ti_int15;   // timeout indicator15 interrupt15
wire										thre_int15; // transmitter15 holding15 register empty15 interrupt15
wire 										ms_int15;   // modem15 status interrupt15

// FIFO signals15
reg 										tf_push15;
reg 										rf_pop15;
wire [`UART_FIFO_REC_WIDTH15-1:0] 	rf_data_out15;
wire 										rf_error_bit15; // an error (parity15 or framing15) is inside the fifo
wire [`UART_FIFO_COUNTER_W15-1:0] 	rf_count15;
wire [`UART_FIFO_COUNTER_W15-1:0] 	tf_count15;
wire [2:0] 								tstate15;
wire [3:0] 								rstate;
wire [9:0] 								counter_t15;

wire                      thre_set_en15; // THRE15 status is delayed15 one character15 time when a character15 is written15 to fifo.
reg  [7:0]                block_cnt15;   // While15 counter counts15, THRE15 status is blocked15 (delayed15 one character15 cycle)
reg  [7:0]                block_value15; // One15 character15 length minus15 stop bit

// Transmitter15 Instance
wire serial_out15;

uart_transmitter15 transmitter15(clk15, wb_rst_i15, lcr15, tf_push15, wb_dat_i15, enable, serial_out15, tstate15, tf_count15, tx_reset15, lsr_mask15);

  // Synchronizing15 and sampling15 serial15 RX15 input
  uart_sync_flops15    i_uart_sync_flops15
  (
    .rst_i15           (wb_rst_i15),
    .clk_i15           (clk15),
    .stage1_rst_i15    (1'b0),
    .stage1_clk_en_i15 (1'b1),
    .async_dat_i15     (srx_pad_i15),
    .sync_dat_o15      (srx_pad15)
  );
  defparam i_uart_sync_flops15.width      = 1;
  defparam i_uart_sync_flops15.init_value15 = 1'b1;

// handle loopback15
wire serial_in15 = loopback15 ? serial_out15 : srx_pad15;
assign stx_pad_o15 = loopback15 ? 1'b1 : serial_out15;

// Receiver15 Instance
uart_receiver15 receiver15(clk15, wb_rst_i15, lcr15, rf_pop15, serial_in15, enable, 
	counter_t15, rf_count15, rf_data_out15, rf_error_bit15, rf_overrun15, rx_reset15, lsr_mask15, rstate, rf_push_pulse15);


// Asynchronous15 reading here15 because the outputs15 are sampled15 in uart_wb15.v file 
always @(dl15 or dlab15 or ier15 or iir15 or scratch15
			or lcr15 or lsr15 or msr15 or rf_data_out15 or wb_addr_i15 or wb_re_i15)   // asynchrounous15 reading
begin
	case (wb_addr_i15)
		`UART_REG_RB15   : wb_dat_o15 = dlab15 ? dl15[`UART_DL115] : rf_data_out15[10:3];
		`UART_REG_IE15	: wb_dat_o15 = dlab15 ? dl15[`UART_DL215] : ier15;
		`UART_REG_II15	: wb_dat_o15 = {4'b1100,iir15};
		`UART_REG_LC15	: wb_dat_o15 = lcr15;
		`UART_REG_LS15	: wb_dat_o15 = lsr15;
		`UART_REG_MS15	: wb_dat_o15 = msr15;
		`UART_REG_SR15	: wb_dat_o15 = scratch15;
		default:  wb_dat_o15 = 8'b0; // ??
	endcase // case(wb_addr_i15)
end // always @ (dl15 or dlab15 or ier15 or iir15 or scratch15...


// rf_pop15 signal15 handling15
always @(posedge clk15 or posedge wb_rst_i15)
begin
	if (wb_rst_i15)
		rf_pop15 <= #1 0; 
	else
	if (rf_pop15)	// restore15 the signal15 to 0 after one clock15 cycle
		rf_pop15 <= #1 0;
	else
	if (wb_re_i15 && wb_addr_i15 == `UART_REG_RB15 && !dlab15)
		rf_pop15 <= #1 1; // advance15 read pointer15
end

wire 	lsr_mask_condition15;
wire 	iir_read15;
wire  msr_read15;
wire	fifo_read15;
wire	fifo_write15;

assign lsr_mask_condition15 = (wb_re_i15 && wb_addr_i15 == `UART_REG_LS15 && !dlab15);
assign iir_read15 = (wb_re_i15 && wb_addr_i15 == `UART_REG_II15 && !dlab15);
assign msr_read15 = (wb_re_i15 && wb_addr_i15 == `UART_REG_MS15 && !dlab15);
assign fifo_read15 = (wb_re_i15 && wb_addr_i15 == `UART_REG_RB15 && !dlab15);
assign fifo_write15 = (wb_we_i15 && wb_addr_i15 == `UART_REG_TR15 && !dlab15);

// lsr_mask_d15 delayed15 signal15 handling15
always @(posedge clk15 or posedge wb_rst_i15)
begin
	if (wb_rst_i15)
		lsr_mask_d15 <= #1 0;
	else // reset bits in the Line15 Status Register
		lsr_mask_d15 <= #1 lsr_mask_condition15;
end

// lsr_mask15 is rise15 detected
assign lsr_mask15 = lsr_mask_condition15 && ~lsr_mask_d15;

// msi_reset15 signal15 handling15
always @(posedge clk15 or posedge wb_rst_i15)
begin
	if (wb_rst_i15)
		msi_reset15 <= #1 1;
	else
	if (msi_reset15)
		msi_reset15 <= #1 0;
	else
	if (msr_read15)
		msi_reset15 <= #1 1; // reset bits in Modem15 Status Register
end


//
//   WRITES15 AND15 RESETS15   //
//
// Line15 Control15 Register
always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15)
		lcr15 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i15 && wb_addr_i15==`UART_REG_LC15)
		lcr15 <= #1 wb_dat_i15;

// Interrupt15 Enable15 Register or UART_DL215
always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15)
	begin
		ier15 <= #1 4'b0000; // no interrupts15 after reset
		dl15[`UART_DL215] <= #1 8'b0;
	end
	else
	if (wb_we_i15 && wb_addr_i15==`UART_REG_IE15)
		if (dlab15)
		begin
			dl15[`UART_DL215] <= #1 wb_dat_i15;
		end
		else
			ier15 <= #1 wb_dat_i15[3:0]; // ier15 uses only 4 lsb


// FIFO Control15 Register and rx_reset15, tx_reset15 signals15
always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) begin
		fcr15 <= #1 2'b11; 
		rx_reset15 <= #1 0;
		tx_reset15 <= #1 0;
	end else
	if (wb_we_i15 && wb_addr_i15==`UART_REG_FC15) begin
		fcr15 <= #1 wb_dat_i15[7:6];
		rx_reset15 <= #1 wb_dat_i15[1];
		tx_reset15 <= #1 wb_dat_i15[2];
	end else begin
		rx_reset15 <= #1 0;
		tx_reset15 <= #1 0;
	end

// Modem15 Control15 Register
always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15)
		mcr15 <= #1 5'b0; 
	else
	if (wb_we_i15 && wb_addr_i15==`UART_REG_MC15)
			mcr15 <= #1 wb_dat_i15[4:0];

// Scratch15 register
// Line15 Control15 Register
always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15)
		scratch15 <= #1 0; // 8n1 setting
	else
	if (wb_we_i15 && wb_addr_i15==`UART_REG_SR15)
		scratch15 <= #1 wb_dat_i15;

// TX_FIFO15 or UART_DL115
always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15)
	begin
		dl15[`UART_DL115]  <= #1 8'b0;
		tf_push15   <= #1 1'b0;
		start_dlc15 <= #1 1'b0;
	end
	else
	if (wb_we_i15 && wb_addr_i15==`UART_REG_TR15)
		if (dlab15)
		begin
			dl15[`UART_DL115] <= #1 wb_dat_i15;
			start_dlc15 <= #1 1'b1; // enable DL15 counter
			tf_push15 <= #1 1'b0;
		end
		else
		begin
			tf_push15   <= #1 1'b1;
			start_dlc15 <= #1 1'b0;
		end // else: !if(dlab15)
	else
	begin
		start_dlc15 <= #1 1'b0;
		tf_push15   <= #1 1'b0;
	end // else: !if(dlab15)

// Receiver15 FIFO trigger level selection logic (asynchronous15 mux15)
always @(fcr15)
	case (fcr15[`UART_FC_TL15])
		2'b00 : trigger_level15 = 1;
		2'b01 : trigger_level15 = 4;
		2'b10 : trigger_level15 = 8;
		2'b11 : trigger_level15 = 14;
	endcase // case(fcr15[`UART_FC_TL15])
	
//
//  STATUS15 REGISTERS15  //
//

// Modem15 Status Register
reg [3:0] delayed_modem_signals15;
always @(posedge clk15 or posedge wb_rst_i15)
begin
	if (wb_rst_i15)
	  begin
  		msr15 <= #1 0;
	  	delayed_modem_signals15[3:0] <= #1 0;
	  end
	else begin
		msr15[`UART_MS_DDCD15:`UART_MS_DCTS15] <= #1 msi_reset15 ? 4'b0 :
			msr15[`UART_MS_DDCD15:`UART_MS_DCTS15] | ({dcd15, ri, dsr15, cts15} ^ delayed_modem_signals15[3:0]);
		msr15[`UART_MS_CDCD15:`UART_MS_CCTS15] <= #1 {dcd_c15, ri_c15, dsr_c15, cts_c15};
		delayed_modem_signals15[3:0] <= #1 {dcd15, ri, dsr15, cts15};
	end
end


// Line15 Status Register

// activation15 conditions15
assign lsr015 = (rf_count15==0 && rf_push_pulse15);  // data in receiver15 fifo available set condition
assign lsr115 = rf_overrun15;     // Receiver15 overrun15 error
assign lsr215 = rf_data_out15[1]; // parity15 error bit
assign lsr315 = rf_data_out15[0]; // framing15 error bit
assign lsr415 = rf_data_out15[2]; // break error in the character15
assign lsr515 = (tf_count15==5'b0 && thre_set_en15);  // transmitter15 fifo is empty15
assign lsr615 = (tf_count15==5'b0 && thre_set_en15 && (tstate15 == /*`S_IDLE15 */ 0)); // transmitter15 empty15
assign lsr715 = rf_error_bit15 | rf_overrun15;

// lsr15 bit015 (receiver15 data available)
reg 	 lsr0_d15;

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr0_d15 <= #1 0;
	else lsr0_d15 <= #1 lsr015;

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr0r15 <= #1 0;
	else lsr0r15 <= #1 (rf_count15==1 && rf_pop15 && !rf_push_pulse15 || rx_reset15) ? 0 : // deassert15 condition
					  lsr0r15 || (lsr015 && ~lsr0_d15); // set on rise15 of lsr015 and keep15 asserted15 until deasserted15 

// lsr15 bit 1 (receiver15 overrun15)
reg lsr1_d15; // delayed15

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr1_d15 <= #1 0;
	else lsr1_d15 <= #1 lsr115;

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr1r15 <= #1 0;
	else	lsr1r15 <= #1	lsr_mask15 ? 0 : lsr1r15 || (lsr115 && ~lsr1_d15); // set on rise15

// lsr15 bit 2 (parity15 error)
reg lsr2_d15; // delayed15

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr2_d15 <= #1 0;
	else lsr2_d15 <= #1 lsr215;

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr2r15 <= #1 0;
	else lsr2r15 <= #1 lsr_mask15 ? 0 : lsr2r15 || (lsr215 && ~lsr2_d15); // set on rise15

// lsr15 bit 3 (framing15 error)
reg lsr3_d15; // delayed15

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr3_d15 <= #1 0;
	else lsr3_d15 <= #1 lsr315;

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr3r15 <= #1 0;
	else lsr3r15 <= #1 lsr_mask15 ? 0 : lsr3r15 || (lsr315 && ~lsr3_d15); // set on rise15

// lsr15 bit 4 (break indicator15)
reg lsr4_d15; // delayed15

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr4_d15 <= #1 0;
	else lsr4_d15 <= #1 lsr415;

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr4r15 <= #1 0;
	else lsr4r15 <= #1 lsr_mask15 ? 0 : lsr4r15 || (lsr415 && ~lsr4_d15);

// lsr15 bit 5 (transmitter15 fifo is empty15)
reg lsr5_d15;

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr5_d15 <= #1 1;
	else lsr5_d15 <= #1 lsr515;

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr5r15 <= #1 1;
	else lsr5r15 <= #1 (fifo_write15) ? 0 :  lsr5r15 || (lsr515 && ~lsr5_d15);

// lsr15 bit 6 (transmitter15 empty15 indicator15)
reg lsr6_d15;

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr6_d15 <= #1 1;
	else lsr6_d15 <= #1 lsr615;

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr6r15 <= #1 1;
	else lsr6r15 <= #1 (fifo_write15) ? 0 : lsr6r15 || (lsr615 && ~lsr6_d15);

// lsr15 bit 7 (error in fifo)
reg lsr7_d15;

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr7_d15 <= #1 0;
	else lsr7_d15 <= #1 lsr715;

always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) lsr7r15 <= #1 0;
	else lsr7r15 <= #1 lsr_mask15 ? 0 : lsr7r15 || (lsr715 && ~lsr7_d15);

// Frequency15 divider15
always @(posedge clk15 or posedge wb_rst_i15) 
begin
	if (wb_rst_i15)
		dlc15 <= #1 0;
	else
		if (start_dlc15 | ~ (|dlc15))
  			dlc15 <= #1 dl15 - 1;               // preset15 counter
		else
			dlc15 <= #1 dlc15 - 1;              // decrement counter
end

// Enable15 signal15 generation15 logic
always @(posedge clk15 or posedge wb_rst_i15)
begin
	if (wb_rst_i15)
		enable <= #1 1'b0;
	else
		if (|dl15 & ~(|dlc15))     // dl15>0 & dlc15==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying15 THRE15 status for one character15 cycle after a character15 is written15 to an empty15 fifo.
always @(lcr15)
  case (lcr15[3:0])
    4'b0000                             : block_value15 =  95; // 6 bits
    4'b0100                             : block_value15 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value15 = 111; // 7 bits
    4'b1100                             : block_value15 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value15 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value15 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value15 = 159; // 10 bits
    4'b1111                             : block_value15 = 175; // 11 bits
  endcase // case(lcr15[3:0])

// Counting15 time of one character15 minus15 stop bit
always @(posedge clk15 or posedge wb_rst_i15)
begin
  if (wb_rst_i15)
    block_cnt15 <= #1 8'd0;
  else
  if(lsr5r15 & fifo_write15)  // THRE15 bit set & write to fifo occured15
    block_cnt15 <= #1 block_value15;
  else
  if (enable & block_cnt15 != 8'b0)  // only work15 on enable times
    block_cnt15 <= #1 block_cnt15 - 1;  // decrement break counter
end // always of break condition detection15

// Generating15 THRE15 status enable signal15
assign thre_set_en15 = ~(|block_cnt15);


//
//	INTERRUPT15 LOGIC15
//

assign rls_int15  = ier15[`UART_IE_RLS15] && (lsr15[`UART_LS_OE15] || lsr15[`UART_LS_PE15] || lsr15[`UART_LS_FE15] || lsr15[`UART_LS_BI15]);
assign rda_int15  = ier15[`UART_IE_RDA15] && (rf_count15 >= {1'b0,trigger_level15});
assign thre_int15 = ier15[`UART_IE_THRE15] && lsr15[`UART_LS_TFE15];
assign ms_int15   = ier15[`UART_IE_MS15] && (| msr15[3:0]);
assign ti_int15   = ier15[`UART_IE_RDA15] && (counter_t15 == 10'b0) && (|rf_count15);

reg 	 rls_int_d15;
reg 	 thre_int_d15;
reg 	 ms_int_d15;
reg 	 ti_int_d15;
reg 	 rda_int_d15;

// delay lines15
always  @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) rls_int_d15 <= #1 0;
	else rls_int_d15 <= #1 rls_int15;

always  @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) rda_int_d15 <= #1 0;
	else rda_int_d15 <= #1 rda_int15;

always  @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) thre_int_d15 <= #1 0;
	else thre_int_d15 <= #1 thre_int15;

always  @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) ms_int_d15 <= #1 0;
	else ms_int_d15 <= #1 ms_int15;

always  @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) ti_int_d15 <= #1 0;
	else ti_int_d15 <= #1 ti_int15;

// rise15 detection15 signals15

wire 	 rls_int_rise15;
wire 	 thre_int_rise15;
wire 	 ms_int_rise15;
wire 	 ti_int_rise15;
wire 	 rda_int_rise15;

assign rda_int_rise15    = rda_int15 & ~rda_int_d15;
assign rls_int_rise15 	  = rls_int15 & ~rls_int_d15;
assign thre_int_rise15   = thre_int15 & ~thre_int_d15;
assign ms_int_rise15 	  = ms_int15 & ~ms_int_d15;
assign ti_int_rise15 	  = ti_int15 & ~ti_int_d15;

// interrupt15 pending flags15
reg 	rls_int_pnd15;
reg	rda_int_pnd15;
reg 	thre_int_pnd15;
reg 	ms_int_pnd15;
reg 	ti_int_pnd15;

// interrupt15 pending flags15 assignments15
always  @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) rls_int_pnd15 <= #1 0; 
	else 
		rls_int_pnd15 <= #1 lsr_mask15 ? 0 :  						// reset condition
							rls_int_rise15 ? 1 :						// latch15 condition
							rls_int_pnd15 && ier15[`UART_IE_RLS15];	// default operation15: remove if masked15

always  @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) rda_int_pnd15 <= #1 0; 
	else 
		rda_int_pnd15 <= #1 ((rf_count15 == {1'b0,trigger_level15}) && fifo_read15) ? 0 :  	// reset condition
							rda_int_rise15 ? 1 :						// latch15 condition
							rda_int_pnd15 && ier15[`UART_IE_RDA15];	// default operation15: remove if masked15

always  @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) thre_int_pnd15 <= #1 0; 
	else 
		thre_int_pnd15 <= #1 fifo_write15 || (iir_read15 & ~iir15[`UART_II_IP15] & iir15[`UART_II_II15] == `UART_II_THRE15)? 0 : 
							thre_int_rise15 ? 1 :
							thre_int_pnd15 && ier15[`UART_IE_THRE15];

always  @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) ms_int_pnd15 <= #1 0; 
	else 
		ms_int_pnd15 <= #1 msr_read15 ? 0 : 
							ms_int_rise15 ? 1 :
							ms_int_pnd15 && ier15[`UART_IE_MS15];

always  @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) ti_int_pnd15 <= #1 0; 
	else 
		ti_int_pnd15 <= #1 fifo_read15 ? 0 : 
							ti_int_rise15 ? 1 :
							ti_int_pnd15 && ier15[`UART_IE_RDA15];
// end of pending flags15

// INT_O15 logic
always @(posedge clk15 or posedge wb_rst_i15)
begin
	if (wb_rst_i15)	
		int_o15 <= #1 1'b0;
	else
		int_o15 <= #1 
					rls_int_pnd15		?	~lsr_mask15					:
					rda_int_pnd15		? 1								:
					ti_int_pnd15		? ~fifo_read15					:
					thre_int_pnd15	? !(fifo_write15 & iir_read15) :
					ms_int_pnd15		? ~msr_read15						:
					0;	// if no interrupt15 are pending
end


// Interrupt15 Identification15 register
always @(posedge clk15 or posedge wb_rst_i15)
begin
	if (wb_rst_i15)
		iir15 <= #1 1;
	else
	if (rls_int_pnd15)  // interrupt15 is pending
	begin
		iir15[`UART_II_II15] <= #1 `UART_II_RLS15;	// set identification15 register to correct15 value
		iir15[`UART_II_IP15] <= #1 1'b0;		// and clear the IIR15 bit 0 (interrupt15 pending)
	end else // the sequence of conditions15 determines15 priority of interrupt15 identification15
	if (rda_int15)
	begin
		iir15[`UART_II_II15] <= #1 `UART_II_RDA15;
		iir15[`UART_II_IP15] <= #1 1'b0;
	end
	else if (ti_int_pnd15)
	begin
		iir15[`UART_II_II15] <= #1 `UART_II_TI15;
		iir15[`UART_II_IP15] <= #1 1'b0;
	end
	else if (thre_int_pnd15)
	begin
		iir15[`UART_II_II15] <= #1 `UART_II_THRE15;
		iir15[`UART_II_IP15] <= #1 1'b0;
	end
	else if (ms_int_pnd15)
	begin
		iir15[`UART_II_II15] <= #1 `UART_II_MS15;
		iir15[`UART_II_IP15] <= #1 1'b0;
	end else	// no interrupt15 is pending
	begin
		iir15[`UART_II_II15] <= #1 0;
		iir15[`UART_II_IP15] <= #1 1'b1;
	end
end

endmodule
