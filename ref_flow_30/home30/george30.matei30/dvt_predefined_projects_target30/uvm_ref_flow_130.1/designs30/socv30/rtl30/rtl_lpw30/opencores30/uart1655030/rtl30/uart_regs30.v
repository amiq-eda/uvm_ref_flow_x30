//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs30.v                                                 ////
////                                                              ////
////                                                              ////
////  This30 file is part of the "UART30 16550 compatible30" project30    ////
////  http30://www30.opencores30.org30/cores30/uart1655030/                   ////
////                                                              ////
////  Documentation30 related30 to this project30:                      ////
////  - http30://www30.opencores30.org30/cores30/uart1655030/                 ////
////                                                              ////
////  Projects30 compatibility30:                                     ////
////  - WISHBONE30                                                  ////
////  RS23230 Protocol30                                              ////
////  16550D uart30 (mostly30 supported)                              ////
////                                                              ////
////  Overview30 (main30 Features30):                                   ////
////  Registers30 of the uart30 16550 core30                            ////
////                                                              ////
////  Known30 problems30 (limits30):                                    ////
////  Inserts30 1 wait state in all WISHBONE30 transfers30              ////
////                                                              ////
////  To30 Do30:                                                      ////
////  Nothing or verification30.                                    ////
////                                                              ////
////  Author30(s):                                                  ////
////      - gorban30@opencores30.org30                                  ////
////      - Jacob30 Gorban30                                          ////
////      - Igor30 Mohor30 (igorm30@opencores30.org30)                      ////
////                                                              ////
////  Created30:        2001/05/12                                  ////
////  Last30 Updated30:   (See log30 for the revision30 history30           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2000, 2001 Authors30                             ////
////                                                              ////
//// This30 source30 file may be used and distributed30 without         ////
//// restriction30 provided that this copyright30 statement30 is not    ////
//// removed from the file and that any derivative30 work30 contains30  ////
//// the original copyright30 notice30 and the associated disclaimer30. ////
////                                                              ////
//// This30 source30 file is free software30; you can redistribute30 it   ////
//// and/or modify it under the terms30 of the GNU30 Lesser30 General30   ////
//// Public30 License30 as published30 by the Free30 Software30 Foundation30; ////
//// either30 version30 2.1 of the License30, or (at your30 option) any   ////
//// later30 version30.                                               ////
////                                                              ////
//// This30 source30 is distributed30 in the hope30 that it will be       ////
//// useful30, but WITHOUT30 ANY30 WARRANTY30; without even30 the implied30   ////
//// warranty30 of MERCHANTABILITY30 or FITNESS30 FOR30 A PARTICULAR30      ////
//// PURPOSE30.  See the GNU30 Lesser30 General30 Public30 License30 for more ////
//// details30.                                                     ////
////                                                              ////
//// You should have received30 a copy of the GNU30 Lesser30 General30    ////
//// Public30 License30 along30 with this source30; if not, download30 it   ////
//// from http30://www30.opencores30.org30/lgpl30.shtml30                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS30 Revision30 History30
//
// $Log: not supported by cvs2svn30 $
// Revision30 1.41  2004/05/21 11:44:41  tadejm30
// Added30 synchronizer30 flops30 for RX30 input.
//
// Revision30 1.40  2003/06/11 16:37:47  gorban30
// This30 fixes30 errors30 in some30 cases30 when data is being read and put to the FIFO at the same time. Patch30 is submitted30 by Scott30 Furman30. Update is very30 recommended30.
//
// Revision30 1.39  2002/07/29 21:16:18  gorban30
// The uart_defines30.v file is included30 again30 in sources30.
//
// Revision30 1.38  2002/07/22 23:02:23  gorban30
// Bug30 Fixes30:
//  * Possible30 loss of sync and bad30 reception30 of stop bit on slow30 baud30 rates30 fixed30.
//   Problem30 reported30 by Kenny30.Tung30.
//  * Bad (or lack30 of ) loopback30 handling30 fixed30. Reported30 by Cherry30 Withers30.
//
// Improvements30:
//  * Made30 FIFO's as general30 inferrable30 memory where possible30.
//  So30 on FPGA30 they should be inferred30 as RAM30 (Distributed30 RAM30 on Xilinx30).
//  This30 saves30 about30 1/3 of the Slice30 count and reduces30 P&R and synthesis30 times.
//
//  * Added30 optional30 baudrate30 output (baud_o30).
//  This30 is identical30 to BAUDOUT30* signal30 on 16550 chip30.
//  It outputs30 16xbit_clock_rate - the divided30 clock30.
//  It's disabled by default. Define30 UART_HAS_BAUDRATE_OUTPUT30 to use.
//
// Revision30 1.37  2001/12/27 13:24:09  mohor30
// lsr30[7] was not showing30 overrun30 errors30.
//
// Revision30 1.36  2001/12/20 13:25:46  mohor30
// rx30 push30 changed to be only one cycle wide30.
//
// Revision30 1.35  2001/12/19 08:03:34  mohor30
// Warnings30 cleared30.
//
// Revision30 1.34  2001/12/19 07:33:54  mohor30
// Synplicity30 was having30 troubles30 with the comment30.
//
// Revision30 1.33  2001/12/17 10:14:43  mohor30
// Things30 related30 to msr30 register changed. After30 THRE30 IRQ30 occurs30, and one
// character30 is written30 to the transmit30 fifo, the detection30 of the THRE30 bit in the
// LSR30 is delayed30 for one character30 time.
//
// Revision30 1.32  2001/12/14 13:19:24  mohor30
// MSR30 register fixed30.
//
// Revision30 1.31  2001/12/14 10:06:58  mohor30
// After30 reset modem30 status register MSR30 should be reset.
//
// Revision30 1.30  2001/12/13 10:09:13  mohor30
// thre30 irq30 should be cleared30 only when being source30 of interrupt30.
//
// Revision30 1.29  2001/12/12 09:05:46  mohor30
// LSR30 status bit 0 was not cleared30 correctly in case of reseting30 the FCR30 (rx30 fifo).
//
// Revision30 1.28  2001/12/10 19:52:41  gorban30
// Scratch30 register added
//
// Revision30 1.27  2001/12/06 14:51:04  gorban30
// Bug30 in LSR30[0] is fixed30.
// All WISHBONE30 signals30 are now sampled30, so another30 wait-state is introduced30 on all transfers30.
//
// Revision30 1.26  2001/12/03 21:44:29  gorban30
// Updated30 specification30 documentation.
// Added30 full 32-bit data bus interface, now as default.
// Address is 5-bit wide30 in 32-bit data bus mode.
// Added30 wb_sel_i30 input to the core30. It's used in the 32-bit mode.
// Added30 debug30 interface with two30 32-bit read-only registers in 32-bit mode.
// Bits30 5 and 6 of LSR30 are now only cleared30 on TX30 FIFO write.
// My30 small test bench30 is modified to work30 with 32-bit mode.
//
// Revision30 1.25  2001/11/28 19:36:39  gorban30
// Fixed30: timeout and break didn30't pay30 attention30 to current data format30 when counting30 time
//
// Revision30 1.24  2001/11/26 21:38:54  gorban30
// Lots30 of fixes30:
// Break30 condition wasn30't handled30 correctly at all.
// LSR30 bits could lose30 their30 values.
// LSR30 value after reset was wrong30.
// Timing30 of THRE30 interrupt30 signal30 corrected30.
// LSR30 bit 0 timing30 corrected30.
//
// Revision30 1.23  2001/11/12 21:57:29  gorban30
// fixed30 more typo30 bugs30
//
// Revision30 1.22  2001/11/12 15:02:28  mohor30
// lsr1r30 error fixed30.
//
// Revision30 1.21  2001/11/12 14:57:27  mohor30
// ti_int_pnd30 error fixed30.
//
// Revision30 1.20  2001/11/12 14:50:27  mohor30
// ti_int_d30 error fixed30.
//
// Revision30 1.19  2001/11/10 12:43:21  gorban30
// Logic30 Synthesis30 bugs30 fixed30. Some30 other minor30 changes30
//
// Revision30 1.18  2001/11/08 14:54:23  mohor30
// Comments30 in Slovene30 language30 deleted30, few30 small fixes30 for better30 work30 of
// old30 tools30. IRQs30 need to be fix30.
//
// Revision30 1.17  2001/11/07 17:51:52  gorban30
// Heavily30 rewritten30 interrupt30 and LSR30 subsystems30.
// Many30 bugs30 hopefully30 squashed30.
//
// Revision30 1.16  2001/11/02 09:55:16  mohor30
// no message
//
// Revision30 1.15  2001/10/31 15:19:22  gorban30
// Fixes30 to break and timeout conditions30
//
// Revision30 1.14  2001/10/29 17:00:46  gorban30
// fixed30 parity30 sending30 and tx_fifo30 resets30 over- and underrun30
//
// Revision30 1.13  2001/10/20 09:58:40  gorban30
// Small30 synopsis30 fixes30
//
// Revision30 1.12  2001/10/19 16:21:40  gorban30
// Changes30 data_out30 to be synchronous30 again30 as it should have been.
//
// Revision30 1.11  2001/10/18 20:35:45  gorban30
// small fix30
//
// Revision30 1.10  2001/08/24 21:01:12  mohor30
// Things30 connected30 to parity30 changed.
// Clock30 devider30 changed.
//
// Revision30 1.9  2001/08/23 16:05:05  mohor30
// Stop bit bug30 fixed30.
// Parity30 bug30 fixed30.
// WISHBONE30 read cycle bug30 fixed30,
// OE30 indicator30 (Overrun30 Error) bug30 fixed30.
// PE30 indicator30 (Parity30 Error) bug30 fixed30.
// Register read bug30 fixed30.
//
// Revision30 1.10  2001/06/23 11:21:48  gorban30
// DL30 made30 16-bit long30. Fixed30 transmission30/reception30 bugs30.
//
// Revision30 1.9  2001/05/31 20:08:01  gorban30
// FIFO changes30 and other corrections30.
//
// Revision30 1.8  2001/05/29 20:05:04  gorban30
// Fixed30 some30 bugs30 and synthesis30 problems30.
//
// Revision30 1.7  2001/05/27 17:37:49  gorban30
// Fixed30 many30 bugs30. Updated30 spec30. Changed30 FIFO files structure30. See CHANGES30.txt30 file.
//
// Revision30 1.6  2001/05/21 19:12:02  gorban30
// Corrected30 some30 Linter30 messages30.
//
// Revision30 1.5  2001/05/17 18:34:18  gorban30
// First30 'stable' release. Should30 be sythesizable30 now. Also30 added new header.
//
// Revision30 1.0  2001-05-17 21:27:11+02  jacob30
// Initial30 revision30
//
//

// synopsys30 translate_off30
`include "timescale.v"
// synopsys30 translate_on30

`include "uart_defines30.v"

`define UART_DL130 7:0
`define UART_DL230 15:8

module uart_regs30 (clk30,
	wb_rst_i30, wb_addr_i30, wb_dat_i30, wb_dat_o30, wb_we_i30, wb_re_i30, 

// additional30 signals30
	modem_inputs30,
	stx_pad_o30, srx_pad_i30,

`ifdef DATA_BUS_WIDTH_830
`else
// debug30 interface signals30	enabled
ier30, iir30, fcr30, mcr30, lcr30, msr30, lsr30, rf_count30, tf_count30, tstate30, rstate,
`endif				
	rts_pad_o30, dtr_pad_o30, int_o30
`ifdef UART_HAS_BAUDRATE_OUTPUT30
	, baud_o30
`endif

	);

input 									clk30;
input 									wb_rst_i30;
input [`UART_ADDR_WIDTH30-1:0] 		wb_addr_i30;
input [7:0] 							wb_dat_i30;
output [7:0] 							wb_dat_o30;
input 									wb_we_i30;
input 									wb_re_i30;

output 									stx_pad_o30;
input 									srx_pad_i30;

input [3:0] 							modem_inputs30;
output 									rts_pad_o30;
output 									dtr_pad_o30;
output 									int_o30;
`ifdef UART_HAS_BAUDRATE_OUTPUT30
output	baud_o30;
`endif

`ifdef DATA_BUS_WIDTH_830
`else
// if 32-bit databus30 and debug30 interface are enabled
output [3:0]							ier30;
output [3:0]							iir30;
output [1:0]							fcr30;  /// bits 7 and 6 of fcr30. Other30 bits are ignored
output [4:0]							mcr30;
output [7:0]							lcr30;
output [7:0]							msr30;
output [7:0] 							lsr30;
output [`UART_FIFO_COUNTER_W30-1:0] 	rf_count30;
output [`UART_FIFO_COUNTER_W30-1:0] 	tf_count30;
output [2:0] 							tstate30;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs30;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT30
assign baud_o30 = enable; // baud_o30 is actually30 the enable signal30
`endif


wire 										stx_pad_o30;		// received30 from transmitter30 module
wire 										srx_pad_i30;
wire 										srx_pad30;

reg [7:0] 								wb_dat_o30;

wire [`UART_ADDR_WIDTH30-1:0] 		wb_addr_i30;
wire [7:0] 								wb_dat_i30;


reg [3:0] 								ier30;
reg [3:0] 								iir30;
reg [1:0] 								fcr30;  /// bits 7 and 6 of fcr30. Other30 bits are ignored
reg [4:0] 								mcr30;
reg [7:0] 								lcr30;
reg [7:0] 								msr30;
reg [15:0] 								dl30;  // 32-bit divisor30 latch30
reg [7:0] 								scratch30; // UART30 scratch30 register
reg 										start_dlc30; // activate30 dlc30 on writing to UART_DL130
reg 										lsr_mask_d30; // delay for lsr_mask30 condition
reg 										msi_reset30; // reset MSR30 4 lower30 bits indicator30
//reg 										threi_clear30; // THRE30 interrupt30 clear flag30
reg [15:0] 								dlc30;  // 32-bit divisor30 latch30 counter
reg 										int_o30;

reg [3:0] 								trigger_level30; // trigger level of the receiver30 FIFO
reg 										rx_reset30;
reg 										tx_reset30;

wire 										dlab30;			   // divisor30 latch30 access bit
wire 										cts_pad_i30, dsr_pad_i30, ri_pad_i30, dcd_pad_i30; // modem30 status bits
wire 										loopback30;		   // loopback30 bit (MCR30 bit 4)
wire 										cts30, dsr30, ri, dcd30;	   // effective30 signals30
wire                    cts_c30, dsr_c30, ri_c30, dcd_c30; // Complement30 effective30 signals30 (considering30 loopback30)
wire 										rts_pad_o30, dtr_pad_o30;		   // modem30 control30 outputs30

// LSR30 bits wires30 and regs
wire [7:0] 								lsr30;
wire 										lsr030, lsr130, lsr230, lsr330, lsr430, lsr530, lsr630, lsr730;
reg										lsr0r30, lsr1r30, lsr2r30, lsr3r30, lsr4r30, lsr5r30, lsr6r30, lsr7r30;
wire 										lsr_mask30; // lsr_mask30

//
// ASSINGS30
//

assign 									lsr30[7:0] = { lsr7r30, lsr6r30, lsr5r30, lsr4r30, lsr3r30, lsr2r30, lsr1r30, lsr0r30 };

assign 									{cts_pad_i30, dsr_pad_i30, ri_pad_i30, dcd_pad_i30} = modem_inputs30;
assign 									{cts30, dsr30, ri, dcd30} = ~{cts_pad_i30,dsr_pad_i30,ri_pad_i30,dcd_pad_i30};

assign                  {cts_c30, dsr_c30, ri_c30, dcd_c30} = loopback30 ? {mcr30[`UART_MC_RTS30],mcr30[`UART_MC_DTR30],mcr30[`UART_MC_OUT130],mcr30[`UART_MC_OUT230]}
                                                               : {cts_pad_i30,dsr_pad_i30,ri_pad_i30,dcd_pad_i30};

assign 									dlab30 = lcr30[`UART_LC_DL30];
assign 									loopback30 = mcr30[4];

// assign modem30 outputs30
assign 									rts_pad_o30 = mcr30[`UART_MC_RTS30];
assign 									dtr_pad_o30 = mcr30[`UART_MC_DTR30];

// Interrupt30 signals30
wire 										rls_int30;  // receiver30 line status interrupt30
wire 										rda_int30;  // receiver30 data available interrupt30
wire 										ti_int30;   // timeout indicator30 interrupt30
wire										thre_int30; // transmitter30 holding30 register empty30 interrupt30
wire 										ms_int30;   // modem30 status interrupt30

// FIFO signals30
reg 										tf_push30;
reg 										rf_pop30;
wire [`UART_FIFO_REC_WIDTH30-1:0] 	rf_data_out30;
wire 										rf_error_bit30; // an error (parity30 or framing30) is inside the fifo
wire [`UART_FIFO_COUNTER_W30-1:0] 	rf_count30;
wire [`UART_FIFO_COUNTER_W30-1:0] 	tf_count30;
wire [2:0] 								tstate30;
wire [3:0] 								rstate;
wire [9:0] 								counter_t30;

wire                      thre_set_en30; // THRE30 status is delayed30 one character30 time when a character30 is written30 to fifo.
reg  [7:0]                block_cnt30;   // While30 counter counts30, THRE30 status is blocked30 (delayed30 one character30 cycle)
reg  [7:0]                block_value30; // One30 character30 length minus30 stop bit

// Transmitter30 Instance
wire serial_out30;

uart_transmitter30 transmitter30(clk30, wb_rst_i30, lcr30, tf_push30, wb_dat_i30, enable, serial_out30, tstate30, tf_count30, tx_reset30, lsr_mask30);

  // Synchronizing30 and sampling30 serial30 RX30 input
  uart_sync_flops30    i_uart_sync_flops30
  (
    .rst_i30           (wb_rst_i30),
    .clk_i30           (clk30),
    .stage1_rst_i30    (1'b0),
    .stage1_clk_en_i30 (1'b1),
    .async_dat_i30     (srx_pad_i30),
    .sync_dat_o30      (srx_pad30)
  );
  defparam i_uart_sync_flops30.width      = 1;
  defparam i_uart_sync_flops30.init_value30 = 1'b1;

// handle loopback30
wire serial_in30 = loopback30 ? serial_out30 : srx_pad30;
assign stx_pad_o30 = loopback30 ? 1'b1 : serial_out30;

// Receiver30 Instance
uart_receiver30 receiver30(clk30, wb_rst_i30, lcr30, rf_pop30, serial_in30, enable, 
	counter_t30, rf_count30, rf_data_out30, rf_error_bit30, rf_overrun30, rx_reset30, lsr_mask30, rstate, rf_push_pulse30);


// Asynchronous30 reading here30 because the outputs30 are sampled30 in uart_wb30.v file 
always @(dl30 or dlab30 or ier30 or iir30 or scratch30
			or lcr30 or lsr30 or msr30 or rf_data_out30 or wb_addr_i30 or wb_re_i30)   // asynchrounous30 reading
begin
	case (wb_addr_i30)
		`UART_REG_RB30   : wb_dat_o30 = dlab30 ? dl30[`UART_DL130] : rf_data_out30[10:3];
		`UART_REG_IE30	: wb_dat_o30 = dlab30 ? dl30[`UART_DL230] : ier30;
		`UART_REG_II30	: wb_dat_o30 = {4'b1100,iir30};
		`UART_REG_LC30	: wb_dat_o30 = lcr30;
		`UART_REG_LS30	: wb_dat_o30 = lsr30;
		`UART_REG_MS30	: wb_dat_o30 = msr30;
		`UART_REG_SR30	: wb_dat_o30 = scratch30;
		default:  wb_dat_o30 = 8'b0; // ??
	endcase // case(wb_addr_i30)
end // always @ (dl30 or dlab30 or ier30 or iir30 or scratch30...


// rf_pop30 signal30 handling30
always @(posedge clk30 or posedge wb_rst_i30)
begin
	if (wb_rst_i30)
		rf_pop30 <= #1 0; 
	else
	if (rf_pop30)	// restore30 the signal30 to 0 after one clock30 cycle
		rf_pop30 <= #1 0;
	else
	if (wb_re_i30 && wb_addr_i30 == `UART_REG_RB30 && !dlab30)
		rf_pop30 <= #1 1; // advance30 read pointer30
end

wire 	lsr_mask_condition30;
wire 	iir_read30;
wire  msr_read30;
wire	fifo_read30;
wire	fifo_write30;

assign lsr_mask_condition30 = (wb_re_i30 && wb_addr_i30 == `UART_REG_LS30 && !dlab30);
assign iir_read30 = (wb_re_i30 && wb_addr_i30 == `UART_REG_II30 && !dlab30);
assign msr_read30 = (wb_re_i30 && wb_addr_i30 == `UART_REG_MS30 && !dlab30);
assign fifo_read30 = (wb_re_i30 && wb_addr_i30 == `UART_REG_RB30 && !dlab30);
assign fifo_write30 = (wb_we_i30 && wb_addr_i30 == `UART_REG_TR30 && !dlab30);

// lsr_mask_d30 delayed30 signal30 handling30
always @(posedge clk30 or posedge wb_rst_i30)
begin
	if (wb_rst_i30)
		lsr_mask_d30 <= #1 0;
	else // reset bits in the Line30 Status Register
		lsr_mask_d30 <= #1 lsr_mask_condition30;
end

// lsr_mask30 is rise30 detected
assign lsr_mask30 = lsr_mask_condition30 && ~lsr_mask_d30;

// msi_reset30 signal30 handling30
always @(posedge clk30 or posedge wb_rst_i30)
begin
	if (wb_rst_i30)
		msi_reset30 <= #1 1;
	else
	if (msi_reset30)
		msi_reset30 <= #1 0;
	else
	if (msr_read30)
		msi_reset30 <= #1 1; // reset bits in Modem30 Status Register
end


//
//   WRITES30 AND30 RESETS30   //
//
// Line30 Control30 Register
always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30)
		lcr30 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i30 && wb_addr_i30==`UART_REG_LC30)
		lcr30 <= #1 wb_dat_i30;

// Interrupt30 Enable30 Register or UART_DL230
always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30)
	begin
		ier30 <= #1 4'b0000; // no interrupts30 after reset
		dl30[`UART_DL230] <= #1 8'b0;
	end
	else
	if (wb_we_i30 && wb_addr_i30==`UART_REG_IE30)
		if (dlab30)
		begin
			dl30[`UART_DL230] <= #1 wb_dat_i30;
		end
		else
			ier30 <= #1 wb_dat_i30[3:0]; // ier30 uses only 4 lsb


// FIFO Control30 Register and rx_reset30, tx_reset30 signals30
always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) begin
		fcr30 <= #1 2'b11; 
		rx_reset30 <= #1 0;
		tx_reset30 <= #1 0;
	end else
	if (wb_we_i30 && wb_addr_i30==`UART_REG_FC30) begin
		fcr30 <= #1 wb_dat_i30[7:6];
		rx_reset30 <= #1 wb_dat_i30[1];
		tx_reset30 <= #1 wb_dat_i30[2];
	end else begin
		rx_reset30 <= #1 0;
		tx_reset30 <= #1 0;
	end

// Modem30 Control30 Register
always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30)
		mcr30 <= #1 5'b0; 
	else
	if (wb_we_i30 && wb_addr_i30==`UART_REG_MC30)
			mcr30 <= #1 wb_dat_i30[4:0];

// Scratch30 register
// Line30 Control30 Register
always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30)
		scratch30 <= #1 0; // 8n1 setting
	else
	if (wb_we_i30 && wb_addr_i30==`UART_REG_SR30)
		scratch30 <= #1 wb_dat_i30;

// TX_FIFO30 or UART_DL130
always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30)
	begin
		dl30[`UART_DL130]  <= #1 8'b0;
		tf_push30   <= #1 1'b0;
		start_dlc30 <= #1 1'b0;
	end
	else
	if (wb_we_i30 && wb_addr_i30==`UART_REG_TR30)
		if (dlab30)
		begin
			dl30[`UART_DL130] <= #1 wb_dat_i30;
			start_dlc30 <= #1 1'b1; // enable DL30 counter
			tf_push30 <= #1 1'b0;
		end
		else
		begin
			tf_push30   <= #1 1'b1;
			start_dlc30 <= #1 1'b0;
		end // else: !if(dlab30)
	else
	begin
		start_dlc30 <= #1 1'b0;
		tf_push30   <= #1 1'b0;
	end // else: !if(dlab30)

// Receiver30 FIFO trigger level selection logic (asynchronous30 mux30)
always @(fcr30)
	case (fcr30[`UART_FC_TL30])
		2'b00 : trigger_level30 = 1;
		2'b01 : trigger_level30 = 4;
		2'b10 : trigger_level30 = 8;
		2'b11 : trigger_level30 = 14;
	endcase // case(fcr30[`UART_FC_TL30])
	
//
//  STATUS30 REGISTERS30  //
//

// Modem30 Status Register
reg [3:0] delayed_modem_signals30;
always @(posedge clk30 or posedge wb_rst_i30)
begin
	if (wb_rst_i30)
	  begin
  		msr30 <= #1 0;
	  	delayed_modem_signals30[3:0] <= #1 0;
	  end
	else begin
		msr30[`UART_MS_DDCD30:`UART_MS_DCTS30] <= #1 msi_reset30 ? 4'b0 :
			msr30[`UART_MS_DDCD30:`UART_MS_DCTS30] | ({dcd30, ri, dsr30, cts30} ^ delayed_modem_signals30[3:0]);
		msr30[`UART_MS_CDCD30:`UART_MS_CCTS30] <= #1 {dcd_c30, ri_c30, dsr_c30, cts_c30};
		delayed_modem_signals30[3:0] <= #1 {dcd30, ri, dsr30, cts30};
	end
end


// Line30 Status Register

// activation30 conditions30
assign lsr030 = (rf_count30==0 && rf_push_pulse30);  // data in receiver30 fifo available set condition
assign lsr130 = rf_overrun30;     // Receiver30 overrun30 error
assign lsr230 = rf_data_out30[1]; // parity30 error bit
assign lsr330 = rf_data_out30[0]; // framing30 error bit
assign lsr430 = rf_data_out30[2]; // break error in the character30
assign lsr530 = (tf_count30==5'b0 && thre_set_en30);  // transmitter30 fifo is empty30
assign lsr630 = (tf_count30==5'b0 && thre_set_en30 && (tstate30 == /*`S_IDLE30 */ 0)); // transmitter30 empty30
assign lsr730 = rf_error_bit30 | rf_overrun30;

// lsr30 bit030 (receiver30 data available)
reg 	 lsr0_d30;

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr0_d30 <= #1 0;
	else lsr0_d30 <= #1 lsr030;

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr0r30 <= #1 0;
	else lsr0r30 <= #1 (rf_count30==1 && rf_pop30 && !rf_push_pulse30 || rx_reset30) ? 0 : // deassert30 condition
					  lsr0r30 || (lsr030 && ~lsr0_d30); // set on rise30 of lsr030 and keep30 asserted30 until deasserted30 

// lsr30 bit 1 (receiver30 overrun30)
reg lsr1_d30; // delayed30

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr1_d30 <= #1 0;
	else lsr1_d30 <= #1 lsr130;

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr1r30 <= #1 0;
	else	lsr1r30 <= #1	lsr_mask30 ? 0 : lsr1r30 || (lsr130 && ~lsr1_d30); // set on rise30

// lsr30 bit 2 (parity30 error)
reg lsr2_d30; // delayed30

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr2_d30 <= #1 0;
	else lsr2_d30 <= #1 lsr230;

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr2r30 <= #1 0;
	else lsr2r30 <= #1 lsr_mask30 ? 0 : lsr2r30 || (lsr230 && ~lsr2_d30); // set on rise30

// lsr30 bit 3 (framing30 error)
reg lsr3_d30; // delayed30

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr3_d30 <= #1 0;
	else lsr3_d30 <= #1 lsr330;

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr3r30 <= #1 0;
	else lsr3r30 <= #1 lsr_mask30 ? 0 : lsr3r30 || (lsr330 && ~lsr3_d30); // set on rise30

// lsr30 bit 4 (break indicator30)
reg lsr4_d30; // delayed30

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr4_d30 <= #1 0;
	else lsr4_d30 <= #1 lsr430;

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr4r30 <= #1 0;
	else lsr4r30 <= #1 lsr_mask30 ? 0 : lsr4r30 || (lsr430 && ~lsr4_d30);

// lsr30 bit 5 (transmitter30 fifo is empty30)
reg lsr5_d30;

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr5_d30 <= #1 1;
	else lsr5_d30 <= #1 lsr530;

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr5r30 <= #1 1;
	else lsr5r30 <= #1 (fifo_write30) ? 0 :  lsr5r30 || (lsr530 && ~lsr5_d30);

// lsr30 bit 6 (transmitter30 empty30 indicator30)
reg lsr6_d30;

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr6_d30 <= #1 1;
	else lsr6_d30 <= #1 lsr630;

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr6r30 <= #1 1;
	else lsr6r30 <= #1 (fifo_write30) ? 0 : lsr6r30 || (lsr630 && ~lsr6_d30);

// lsr30 bit 7 (error in fifo)
reg lsr7_d30;

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr7_d30 <= #1 0;
	else lsr7_d30 <= #1 lsr730;

always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) lsr7r30 <= #1 0;
	else lsr7r30 <= #1 lsr_mask30 ? 0 : lsr7r30 || (lsr730 && ~lsr7_d30);

// Frequency30 divider30
always @(posedge clk30 or posedge wb_rst_i30) 
begin
	if (wb_rst_i30)
		dlc30 <= #1 0;
	else
		if (start_dlc30 | ~ (|dlc30))
  			dlc30 <= #1 dl30 - 1;               // preset30 counter
		else
			dlc30 <= #1 dlc30 - 1;              // decrement counter
end

// Enable30 signal30 generation30 logic
always @(posedge clk30 or posedge wb_rst_i30)
begin
	if (wb_rst_i30)
		enable <= #1 1'b0;
	else
		if (|dl30 & ~(|dlc30))     // dl30>0 & dlc30==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying30 THRE30 status for one character30 cycle after a character30 is written30 to an empty30 fifo.
always @(lcr30)
  case (lcr30[3:0])
    4'b0000                             : block_value30 =  95; // 6 bits
    4'b0100                             : block_value30 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value30 = 111; // 7 bits
    4'b1100                             : block_value30 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value30 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value30 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value30 = 159; // 10 bits
    4'b1111                             : block_value30 = 175; // 11 bits
  endcase // case(lcr30[3:0])

// Counting30 time of one character30 minus30 stop bit
always @(posedge clk30 or posedge wb_rst_i30)
begin
  if (wb_rst_i30)
    block_cnt30 <= #1 8'd0;
  else
  if(lsr5r30 & fifo_write30)  // THRE30 bit set & write to fifo occured30
    block_cnt30 <= #1 block_value30;
  else
  if (enable & block_cnt30 != 8'b0)  // only work30 on enable times
    block_cnt30 <= #1 block_cnt30 - 1;  // decrement break counter
end // always of break condition detection30

// Generating30 THRE30 status enable signal30
assign thre_set_en30 = ~(|block_cnt30);


//
//	INTERRUPT30 LOGIC30
//

assign rls_int30  = ier30[`UART_IE_RLS30] && (lsr30[`UART_LS_OE30] || lsr30[`UART_LS_PE30] || lsr30[`UART_LS_FE30] || lsr30[`UART_LS_BI30]);
assign rda_int30  = ier30[`UART_IE_RDA30] && (rf_count30 >= {1'b0,trigger_level30});
assign thre_int30 = ier30[`UART_IE_THRE30] && lsr30[`UART_LS_TFE30];
assign ms_int30   = ier30[`UART_IE_MS30] && (| msr30[3:0]);
assign ti_int30   = ier30[`UART_IE_RDA30] && (counter_t30 == 10'b0) && (|rf_count30);

reg 	 rls_int_d30;
reg 	 thre_int_d30;
reg 	 ms_int_d30;
reg 	 ti_int_d30;
reg 	 rda_int_d30;

// delay lines30
always  @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) rls_int_d30 <= #1 0;
	else rls_int_d30 <= #1 rls_int30;

always  @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) rda_int_d30 <= #1 0;
	else rda_int_d30 <= #1 rda_int30;

always  @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) thre_int_d30 <= #1 0;
	else thre_int_d30 <= #1 thre_int30;

always  @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) ms_int_d30 <= #1 0;
	else ms_int_d30 <= #1 ms_int30;

always  @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) ti_int_d30 <= #1 0;
	else ti_int_d30 <= #1 ti_int30;

// rise30 detection30 signals30

wire 	 rls_int_rise30;
wire 	 thre_int_rise30;
wire 	 ms_int_rise30;
wire 	 ti_int_rise30;
wire 	 rda_int_rise30;

assign rda_int_rise30    = rda_int30 & ~rda_int_d30;
assign rls_int_rise30 	  = rls_int30 & ~rls_int_d30;
assign thre_int_rise30   = thre_int30 & ~thre_int_d30;
assign ms_int_rise30 	  = ms_int30 & ~ms_int_d30;
assign ti_int_rise30 	  = ti_int30 & ~ti_int_d30;

// interrupt30 pending flags30
reg 	rls_int_pnd30;
reg	rda_int_pnd30;
reg 	thre_int_pnd30;
reg 	ms_int_pnd30;
reg 	ti_int_pnd30;

// interrupt30 pending flags30 assignments30
always  @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) rls_int_pnd30 <= #1 0; 
	else 
		rls_int_pnd30 <= #1 lsr_mask30 ? 0 :  						// reset condition
							rls_int_rise30 ? 1 :						// latch30 condition
							rls_int_pnd30 && ier30[`UART_IE_RLS30];	// default operation30: remove if masked30

always  @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) rda_int_pnd30 <= #1 0; 
	else 
		rda_int_pnd30 <= #1 ((rf_count30 == {1'b0,trigger_level30}) && fifo_read30) ? 0 :  	// reset condition
							rda_int_rise30 ? 1 :						// latch30 condition
							rda_int_pnd30 && ier30[`UART_IE_RDA30];	// default operation30: remove if masked30

always  @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) thre_int_pnd30 <= #1 0; 
	else 
		thre_int_pnd30 <= #1 fifo_write30 || (iir_read30 & ~iir30[`UART_II_IP30] & iir30[`UART_II_II30] == `UART_II_THRE30)? 0 : 
							thre_int_rise30 ? 1 :
							thre_int_pnd30 && ier30[`UART_IE_THRE30];

always  @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) ms_int_pnd30 <= #1 0; 
	else 
		ms_int_pnd30 <= #1 msr_read30 ? 0 : 
							ms_int_rise30 ? 1 :
							ms_int_pnd30 && ier30[`UART_IE_MS30];

always  @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) ti_int_pnd30 <= #1 0; 
	else 
		ti_int_pnd30 <= #1 fifo_read30 ? 0 : 
							ti_int_rise30 ? 1 :
							ti_int_pnd30 && ier30[`UART_IE_RDA30];
// end of pending flags30

// INT_O30 logic
always @(posedge clk30 or posedge wb_rst_i30)
begin
	if (wb_rst_i30)	
		int_o30 <= #1 1'b0;
	else
		int_o30 <= #1 
					rls_int_pnd30		?	~lsr_mask30					:
					rda_int_pnd30		? 1								:
					ti_int_pnd30		? ~fifo_read30					:
					thre_int_pnd30	? !(fifo_write30 & iir_read30) :
					ms_int_pnd30		? ~msr_read30						:
					0;	// if no interrupt30 are pending
end


// Interrupt30 Identification30 register
always @(posedge clk30 or posedge wb_rst_i30)
begin
	if (wb_rst_i30)
		iir30 <= #1 1;
	else
	if (rls_int_pnd30)  // interrupt30 is pending
	begin
		iir30[`UART_II_II30] <= #1 `UART_II_RLS30;	// set identification30 register to correct30 value
		iir30[`UART_II_IP30] <= #1 1'b0;		// and clear the IIR30 bit 0 (interrupt30 pending)
	end else // the sequence of conditions30 determines30 priority of interrupt30 identification30
	if (rda_int30)
	begin
		iir30[`UART_II_II30] <= #1 `UART_II_RDA30;
		iir30[`UART_II_IP30] <= #1 1'b0;
	end
	else if (ti_int_pnd30)
	begin
		iir30[`UART_II_II30] <= #1 `UART_II_TI30;
		iir30[`UART_II_IP30] <= #1 1'b0;
	end
	else if (thre_int_pnd30)
	begin
		iir30[`UART_II_II30] <= #1 `UART_II_THRE30;
		iir30[`UART_II_IP30] <= #1 1'b0;
	end
	else if (ms_int_pnd30)
	begin
		iir30[`UART_II_II30] <= #1 `UART_II_MS30;
		iir30[`UART_II_IP30] <= #1 1'b0;
	end else	// no interrupt30 is pending
	begin
		iir30[`UART_II_II30] <= #1 0;
		iir30[`UART_II_IP30] <= #1 1'b1;
	end
end

endmodule
