//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs16.v                                                 ////
////                                                              ////
////                                                              ////
////  This16 file is part of the "UART16 16550 compatible16" project16    ////
////  http16://www16.opencores16.org16/cores16/uart1655016/                   ////
////                                                              ////
////  Documentation16 related16 to this project16:                      ////
////  - http16://www16.opencores16.org16/cores16/uart1655016/                 ////
////                                                              ////
////  Projects16 compatibility16:                                     ////
////  - WISHBONE16                                                  ////
////  RS23216 Protocol16                                              ////
////  16550D uart16 (mostly16 supported)                              ////
////                                                              ////
////  Overview16 (main16 Features16):                                   ////
////  Registers16 of the uart16 16550 core16                            ////
////                                                              ////
////  Known16 problems16 (limits16):                                    ////
////  Inserts16 1 wait state in all WISHBONE16 transfers16              ////
////                                                              ////
////  To16 Do16:                                                      ////
////  Nothing or verification16.                                    ////
////                                                              ////
////  Author16(s):                                                  ////
////      - gorban16@opencores16.org16                                  ////
////      - Jacob16 Gorban16                                          ////
////      - Igor16 Mohor16 (igorm16@opencores16.org16)                      ////
////                                                              ////
////  Created16:        2001/05/12                                  ////
////  Last16 Updated16:   (See log16 for the revision16 history16           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2000, 2001 Authors16                             ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS16 Revision16 History16
//
// $Log: not supported by cvs2svn16 $
// Revision16 1.41  2004/05/21 11:44:41  tadejm16
// Added16 synchronizer16 flops16 for RX16 input.
//
// Revision16 1.40  2003/06/11 16:37:47  gorban16
// This16 fixes16 errors16 in some16 cases16 when data is being read and put to the FIFO at the same time. Patch16 is submitted16 by Scott16 Furman16. Update is very16 recommended16.
//
// Revision16 1.39  2002/07/29 21:16:18  gorban16
// The uart_defines16.v file is included16 again16 in sources16.
//
// Revision16 1.38  2002/07/22 23:02:23  gorban16
// Bug16 Fixes16:
//  * Possible16 loss of sync and bad16 reception16 of stop bit on slow16 baud16 rates16 fixed16.
//   Problem16 reported16 by Kenny16.Tung16.
//  * Bad (or lack16 of ) loopback16 handling16 fixed16. Reported16 by Cherry16 Withers16.
//
// Improvements16:
//  * Made16 FIFO's as general16 inferrable16 memory where possible16.
//  So16 on FPGA16 they should be inferred16 as RAM16 (Distributed16 RAM16 on Xilinx16).
//  This16 saves16 about16 1/3 of the Slice16 count and reduces16 P&R and synthesis16 times.
//
//  * Added16 optional16 baudrate16 output (baud_o16).
//  This16 is identical16 to BAUDOUT16* signal16 on 16550 chip16.
//  It outputs16 16xbit_clock_rate - the divided16 clock16.
//  It's disabled by default. Define16 UART_HAS_BAUDRATE_OUTPUT16 to use.
//
// Revision16 1.37  2001/12/27 13:24:09  mohor16
// lsr16[7] was not showing16 overrun16 errors16.
//
// Revision16 1.36  2001/12/20 13:25:46  mohor16
// rx16 push16 changed to be only one cycle wide16.
//
// Revision16 1.35  2001/12/19 08:03:34  mohor16
// Warnings16 cleared16.
//
// Revision16 1.34  2001/12/19 07:33:54  mohor16
// Synplicity16 was having16 troubles16 with the comment16.
//
// Revision16 1.33  2001/12/17 10:14:43  mohor16
// Things16 related16 to msr16 register changed. After16 THRE16 IRQ16 occurs16, and one
// character16 is written16 to the transmit16 fifo, the detection16 of the THRE16 bit in the
// LSR16 is delayed16 for one character16 time.
//
// Revision16 1.32  2001/12/14 13:19:24  mohor16
// MSR16 register fixed16.
//
// Revision16 1.31  2001/12/14 10:06:58  mohor16
// After16 reset modem16 status register MSR16 should be reset.
//
// Revision16 1.30  2001/12/13 10:09:13  mohor16
// thre16 irq16 should be cleared16 only when being source16 of interrupt16.
//
// Revision16 1.29  2001/12/12 09:05:46  mohor16
// LSR16 status bit 0 was not cleared16 correctly in case of reseting16 the FCR16 (rx16 fifo).
//
// Revision16 1.28  2001/12/10 19:52:41  gorban16
// Scratch16 register added
//
// Revision16 1.27  2001/12/06 14:51:04  gorban16
// Bug16 in LSR16[0] is fixed16.
// All WISHBONE16 signals16 are now sampled16, so another16 wait-state is introduced16 on all transfers16.
//
// Revision16 1.26  2001/12/03 21:44:29  gorban16
// Updated16 specification16 documentation.
// Added16 full 32-bit data bus interface, now as default.
// Address is 5-bit wide16 in 32-bit data bus mode.
// Added16 wb_sel_i16 input to the core16. It's used in the 32-bit mode.
// Added16 debug16 interface with two16 32-bit read-only registers in 32-bit mode.
// Bits16 5 and 6 of LSR16 are now only cleared16 on TX16 FIFO write.
// My16 small test bench16 is modified to work16 with 32-bit mode.
//
// Revision16 1.25  2001/11/28 19:36:39  gorban16
// Fixed16: timeout and break didn16't pay16 attention16 to current data format16 when counting16 time
//
// Revision16 1.24  2001/11/26 21:38:54  gorban16
// Lots16 of fixes16:
// Break16 condition wasn16't handled16 correctly at all.
// LSR16 bits could lose16 their16 values.
// LSR16 value after reset was wrong16.
// Timing16 of THRE16 interrupt16 signal16 corrected16.
// LSR16 bit 0 timing16 corrected16.
//
// Revision16 1.23  2001/11/12 21:57:29  gorban16
// fixed16 more typo16 bugs16
//
// Revision16 1.22  2001/11/12 15:02:28  mohor16
// lsr1r16 error fixed16.
//
// Revision16 1.21  2001/11/12 14:57:27  mohor16
// ti_int_pnd16 error fixed16.
//
// Revision16 1.20  2001/11/12 14:50:27  mohor16
// ti_int_d16 error fixed16.
//
// Revision16 1.19  2001/11/10 12:43:21  gorban16
// Logic16 Synthesis16 bugs16 fixed16. Some16 other minor16 changes16
//
// Revision16 1.18  2001/11/08 14:54:23  mohor16
// Comments16 in Slovene16 language16 deleted16, few16 small fixes16 for better16 work16 of
// old16 tools16. IRQs16 need to be fix16.
//
// Revision16 1.17  2001/11/07 17:51:52  gorban16
// Heavily16 rewritten16 interrupt16 and LSR16 subsystems16.
// Many16 bugs16 hopefully16 squashed16.
//
// Revision16 1.16  2001/11/02 09:55:16  mohor16
// no message
//
// Revision16 1.15  2001/10/31 15:19:22  gorban16
// Fixes16 to break and timeout conditions16
//
// Revision16 1.14  2001/10/29 17:00:46  gorban16
// fixed16 parity16 sending16 and tx_fifo16 resets16 over- and underrun16
//
// Revision16 1.13  2001/10/20 09:58:40  gorban16
// Small16 synopsis16 fixes16
//
// Revision16 1.12  2001/10/19 16:21:40  gorban16
// Changes16 data_out16 to be synchronous16 again16 as it should have been.
//
// Revision16 1.11  2001/10/18 20:35:45  gorban16
// small fix16
//
// Revision16 1.10  2001/08/24 21:01:12  mohor16
// Things16 connected16 to parity16 changed.
// Clock16 devider16 changed.
//
// Revision16 1.9  2001/08/23 16:05:05  mohor16
// Stop bit bug16 fixed16.
// Parity16 bug16 fixed16.
// WISHBONE16 read cycle bug16 fixed16,
// OE16 indicator16 (Overrun16 Error) bug16 fixed16.
// PE16 indicator16 (Parity16 Error) bug16 fixed16.
// Register read bug16 fixed16.
//
// Revision16 1.10  2001/06/23 11:21:48  gorban16
// DL16 made16 16-bit long16. Fixed16 transmission16/reception16 bugs16.
//
// Revision16 1.9  2001/05/31 20:08:01  gorban16
// FIFO changes16 and other corrections16.
//
// Revision16 1.8  2001/05/29 20:05:04  gorban16
// Fixed16 some16 bugs16 and synthesis16 problems16.
//
// Revision16 1.7  2001/05/27 17:37:49  gorban16
// Fixed16 many16 bugs16. Updated16 spec16. Changed16 FIFO files structure16. See CHANGES16.txt16 file.
//
// Revision16 1.6  2001/05/21 19:12:02  gorban16
// Corrected16 some16 Linter16 messages16.
//
// Revision16 1.5  2001/05/17 18:34:18  gorban16
// First16 'stable' release. Should16 be sythesizable16 now. Also16 added new header.
//
// Revision16 1.0  2001-05-17 21:27:11+02  jacob16
// Initial16 revision16
//
//

// synopsys16 translate_off16
`include "timescale.v"
// synopsys16 translate_on16

`include "uart_defines16.v"

`define UART_DL116 7:0
`define UART_DL216 15:8

module uart_regs16 (clk16,
	wb_rst_i16, wb_addr_i16, wb_dat_i16, wb_dat_o16, wb_we_i16, wb_re_i16, 

// additional16 signals16
	modem_inputs16,
	stx_pad_o16, srx_pad_i16,

`ifdef DATA_BUS_WIDTH_816
`else
// debug16 interface signals16	enabled
ier16, iir16, fcr16, mcr16, lcr16, msr16, lsr16, rf_count16, tf_count16, tstate16, rstate,
`endif				
	rts_pad_o16, dtr_pad_o16, int_o16
`ifdef UART_HAS_BAUDRATE_OUTPUT16
	, baud_o16
`endif

	);

input 									clk16;
input 									wb_rst_i16;
input [`UART_ADDR_WIDTH16-1:0] 		wb_addr_i16;
input [7:0] 							wb_dat_i16;
output [7:0] 							wb_dat_o16;
input 									wb_we_i16;
input 									wb_re_i16;

output 									stx_pad_o16;
input 									srx_pad_i16;

input [3:0] 							modem_inputs16;
output 									rts_pad_o16;
output 									dtr_pad_o16;
output 									int_o16;
`ifdef UART_HAS_BAUDRATE_OUTPUT16
output	baud_o16;
`endif

`ifdef DATA_BUS_WIDTH_816
`else
// if 32-bit databus16 and debug16 interface are enabled
output [3:0]							ier16;
output [3:0]							iir16;
output [1:0]							fcr16;  /// bits 7 and 6 of fcr16. Other16 bits are ignored
output [4:0]							mcr16;
output [7:0]							lcr16;
output [7:0]							msr16;
output [7:0] 							lsr16;
output [`UART_FIFO_COUNTER_W16-1:0] 	rf_count16;
output [`UART_FIFO_COUNTER_W16-1:0] 	tf_count16;
output [2:0] 							tstate16;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs16;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT16
assign baud_o16 = enable; // baud_o16 is actually16 the enable signal16
`endif


wire 										stx_pad_o16;		// received16 from transmitter16 module
wire 										srx_pad_i16;
wire 										srx_pad16;

reg [7:0] 								wb_dat_o16;

wire [`UART_ADDR_WIDTH16-1:0] 		wb_addr_i16;
wire [7:0] 								wb_dat_i16;


reg [3:0] 								ier16;
reg [3:0] 								iir16;
reg [1:0] 								fcr16;  /// bits 7 and 6 of fcr16. Other16 bits are ignored
reg [4:0] 								mcr16;
reg [7:0] 								lcr16;
reg [7:0] 								msr16;
reg [15:0] 								dl16;  // 32-bit divisor16 latch16
reg [7:0] 								scratch16; // UART16 scratch16 register
reg 										start_dlc16; // activate16 dlc16 on writing to UART_DL116
reg 										lsr_mask_d16; // delay for lsr_mask16 condition
reg 										msi_reset16; // reset MSR16 4 lower16 bits indicator16
//reg 										threi_clear16; // THRE16 interrupt16 clear flag16
reg [15:0] 								dlc16;  // 32-bit divisor16 latch16 counter
reg 										int_o16;

reg [3:0] 								trigger_level16; // trigger level of the receiver16 FIFO
reg 										rx_reset16;
reg 										tx_reset16;

wire 										dlab16;			   // divisor16 latch16 access bit
wire 										cts_pad_i16, dsr_pad_i16, ri_pad_i16, dcd_pad_i16; // modem16 status bits
wire 										loopback16;		   // loopback16 bit (MCR16 bit 4)
wire 										cts16, dsr16, ri, dcd16;	   // effective16 signals16
wire                    cts_c16, dsr_c16, ri_c16, dcd_c16; // Complement16 effective16 signals16 (considering16 loopback16)
wire 										rts_pad_o16, dtr_pad_o16;		   // modem16 control16 outputs16

// LSR16 bits wires16 and regs
wire [7:0] 								lsr16;
wire 										lsr016, lsr116, lsr216, lsr316, lsr416, lsr516, lsr616, lsr716;
reg										lsr0r16, lsr1r16, lsr2r16, lsr3r16, lsr4r16, lsr5r16, lsr6r16, lsr7r16;
wire 										lsr_mask16; // lsr_mask16

//
// ASSINGS16
//

assign 									lsr16[7:0] = { lsr7r16, lsr6r16, lsr5r16, lsr4r16, lsr3r16, lsr2r16, lsr1r16, lsr0r16 };

assign 									{cts_pad_i16, dsr_pad_i16, ri_pad_i16, dcd_pad_i16} = modem_inputs16;
assign 									{cts16, dsr16, ri, dcd16} = ~{cts_pad_i16,dsr_pad_i16,ri_pad_i16,dcd_pad_i16};

assign                  {cts_c16, dsr_c16, ri_c16, dcd_c16} = loopback16 ? {mcr16[`UART_MC_RTS16],mcr16[`UART_MC_DTR16],mcr16[`UART_MC_OUT116],mcr16[`UART_MC_OUT216]}
                                                               : {cts_pad_i16,dsr_pad_i16,ri_pad_i16,dcd_pad_i16};

assign 									dlab16 = lcr16[`UART_LC_DL16];
assign 									loopback16 = mcr16[4];

// assign modem16 outputs16
assign 									rts_pad_o16 = mcr16[`UART_MC_RTS16];
assign 									dtr_pad_o16 = mcr16[`UART_MC_DTR16];

// Interrupt16 signals16
wire 										rls_int16;  // receiver16 line status interrupt16
wire 										rda_int16;  // receiver16 data available interrupt16
wire 										ti_int16;   // timeout indicator16 interrupt16
wire										thre_int16; // transmitter16 holding16 register empty16 interrupt16
wire 										ms_int16;   // modem16 status interrupt16

// FIFO signals16
reg 										tf_push16;
reg 										rf_pop16;
wire [`UART_FIFO_REC_WIDTH16-1:0] 	rf_data_out16;
wire 										rf_error_bit16; // an error (parity16 or framing16) is inside the fifo
wire [`UART_FIFO_COUNTER_W16-1:0] 	rf_count16;
wire [`UART_FIFO_COUNTER_W16-1:0] 	tf_count16;
wire [2:0] 								tstate16;
wire [3:0] 								rstate;
wire [9:0] 								counter_t16;

wire                      thre_set_en16; // THRE16 status is delayed16 one character16 time when a character16 is written16 to fifo.
reg  [7:0]                block_cnt16;   // While16 counter counts16, THRE16 status is blocked16 (delayed16 one character16 cycle)
reg  [7:0]                block_value16; // One16 character16 length minus16 stop bit

// Transmitter16 Instance
wire serial_out16;

uart_transmitter16 transmitter16(clk16, wb_rst_i16, lcr16, tf_push16, wb_dat_i16, enable, serial_out16, tstate16, tf_count16, tx_reset16, lsr_mask16);

  // Synchronizing16 and sampling16 serial16 RX16 input
  uart_sync_flops16    i_uart_sync_flops16
  (
    .rst_i16           (wb_rst_i16),
    .clk_i16           (clk16),
    .stage1_rst_i16    (1'b0),
    .stage1_clk_en_i16 (1'b1),
    .async_dat_i16     (srx_pad_i16),
    .sync_dat_o16      (srx_pad16)
  );
  defparam i_uart_sync_flops16.width      = 1;
  defparam i_uart_sync_flops16.init_value16 = 1'b1;

// handle loopback16
wire serial_in16 = loopback16 ? serial_out16 : srx_pad16;
assign stx_pad_o16 = loopback16 ? 1'b1 : serial_out16;

// Receiver16 Instance
uart_receiver16 receiver16(clk16, wb_rst_i16, lcr16, rf_pop16, serial_in16, enable, 
	counter_t16, rf_count16, rf_data_out16, rf_error_bit16, rf_overrun16, rx_reset16, lsr_mask16, rstate, rf_push_pulse16);


// Asynchronous16 reading here16 because the outputs16 are sampled16 in uart_wb16.v file 
always @(dl16 or dlab16 or ier16 or iir16 or scratch16
			or lcr16 or lsr16 or msr16 or rf_data_out16 or wb_addr_i16 or wb_re_i16)   // asynchrounous16 reading
begin
	case (wb_addr_i16)
		`UART_REG_RB16   : wb_dat_o16 = dlab16 ? dl16[`UART_DL116] : rf_data_out16[10:3];
		`UART_REG_IE16	: wb_dat_o16 = dlab16 ? dl16[`UART_DL216] : ier16;
		`UART_REG_II16	: wb_dat_o16 = {4'b1100,iir16};
		`UART_REG_LC16	: wb_dat_o16 = lcr16;
		`UART_REG_LS16	: wb_dat_o16 = lsr16;
		`UART_REG_MS16	: wb_dat_o16 = msr16;
		`UART_REG_SR16	: wb_dat_o16 = scratch16;
		default:  wb_dat_o16 = 8'b0; // ??
	endcase // case(wb_addr_i16)
end // always @ (dl16 or dlab16 or ier16 or iir16 or scratch16...


// rf_pop16 signal16 handling16
always @(posedge clk16 or posedge wb_rst_i16)
begin
	if (wb_rst_i16)
		rf_pop16 <= #1 0; 
	else
	if (rf_pop16)	// restore16 the signal16 to 0 after one clock16 cycle
		rf_pop16 <= #1 0;
	else
	if (wb_re_i16 && wb_addr_i16 == `UART_REG_RB16 && !dlab16)
		rf_pop16 <= #1 1; // advance16 read pointer16
end

wire 	lsr_mask_condition16;
wire 	iir_read16;
wire  msr_read16;
wire	fifo_read16;
wire	fifo_write16;

assign lsr_mask_condition16 = (wb_re_i16 && wb_addr_i16 == `UART_REG_LS16 && !dlab16);
assign iir_read16 = (wb_re_i16 && wb_addr_i16 == `UART_REG_II16 && !dlab16);
assign msr_read16 = (wb_re_i16 && wb_addr_i16 == `UART_REG_MS16 && !dlab16);
assign fifo_read16 = (wb_re_i16 && wb_addr_i16 == `UART_REG_RB16 && !dlab16);
assign fifo_write16 = (wb_we_i16 && wb_addr_i16 == `UART_REG_TR16 && !dlab16);

// lsr_mask_d16 delayed16 signal16 handling16
always @(posedge clk16 or posedge wb_rst_i16)
begin
	if (wb_rst_i16)
		lsr_mask_d16 <= #1 0;
	else // reset bits in the Line16 Status Register
		lsr_mask_d16 <= #1 lsr_mask_condition16;
end

// lsr_mask16 is rise16 detected
assign lsr_mask16 = lsr_mask_condition16 && ~lsr_mask_d16;

// msi_reset16 signal16 handling16
always @(posedge clk16 or posedge wb_rst_i16)
begin
	if (wb_rst_i16)
		msi_reset16 <= #1 1;
	else
	if (msi_reset16)
		msi_reset16 <= #1 0;
	else
	if (msr_read16)
		msi_reset16 <= #1 1; // reset bits in Modem16 Status Register
end


//
//   WRITES16 AND16 RESETS16   //
//
// Line16 Control16 Register
always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16)
		lcr16 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i16 && wb_addr_i16==`UART_REG_LC16)
		lcr16 <= #1 wb_dat_i16;

// Interrupt16 Enable16 Register or UART_DL216
always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16)
	begin
		ier16 <= #1 4'b0000; // no interrupts16 after reset
		dl16[`UART_DL216] <= #1 8'b0;
	end
	else
	if (wb_we_i16 && wb_addr_i16==`UART_REG_IE16)
		if (dlab16)
		begin
			dl16[`UART_DL216] <= #1 wb_dat_i16;
		end
		else
			ier16 <= #1 wb_dat_i16[3:0]; // ier16 uses only 4 lsb


// FIFO Control16 Register and rx_reset16, tx_reset16 signals16
always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) begin
		fcr16 <= #1 2'b11; 
		rx_reset16 <= #1 0;
		tx_reset16 <= #1 0;
	end else
	if (wb_we_i16 && wb_addr_i16==`UART_REG_FC16) begin
		fcr16 <= #1 wb_dat_i16[7:6];
		rx_reset16 <= #1 wb_dat_i16[1];
		tx_reset16 <= #1 wb_dat_i16[2];
	end else begin
		rx_reset16 <= #1 0;
		tx_reset16 <= #1 0;
	end

// Modem16 Control16 Register
always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16)
		mcr16 <= #1 5'b0; 
	else
	if (wb_we_i16 && wb_addr_i16==`UART_REG_MC16)
			mcr16 <= #1 wb_dat_i16[4:0];

// Scratch16 register
// Line16 Control16 Register
always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16)
		scratch16 <= #1 0; // 8n1 setting
	else
	if (wb_we_i16 && wb_addr_i16==`UART_REG_SR16)
		scratch16 <= #1 wb_dat_i16;

// TX_FIFO16 or UART_DL116
always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16)
	begin
		dl16[`UART_DL116]  <= #1 8'b0;
		tf_push16   <= #1 1'b0;
		start_dlc16 <= #1 1'b0;
	end
	else
	if (wb_we_i16 && wb_addr_i16==`UART_REG_TR16)
		if (dlab16)
		begin
			dl16[`UART_DL116] <= #1 wb_dat_i16;
			start_dlc16 <= #1 1'b1; // enable DL16 counter
			tf_push16 <= #1 1'b0;
		end
		else
		begin
			tf_push16   <= #1 1'b1;
			start_dlc16 <= #1 1'b0;
		end // else: !if(dlab16)
	else
	begin
		start_dlc16 <= #1 1'b0;
		tf_push16   <= #1 1'b0;
	end // else: !if(dlab16)

// Receiver16 FIFO trigger level selection logic (asynchronous16 mux16)
always @(fcr16)
	case (fcr16[`UART_FC_TL16])
		2'b00 : trigger_level16 = 1;
		2'b01 : trigger_level16 = 4;
		2'b10 : trigger_level16 = 8;
		2'b11 : trigger_level16 = 14;
	endcase // case(fcr16[`UART_FC_TL16])
	
//
//  STATUS16 REGISTERS16  //
//

// Modem16 Status Register
reg [3:0] delayed_modem_signals16;
always @(posedge clk16 or posedge wb_rst_i16)
begin
	if (wb_rst_i16)
	  begin
  		msr16 <= #1 0;
	  	delayed_modem_signals16[3:0] <= #1 0;
	  end
	else begin
		msr16[`UART_MS_DDCD16:`UART_MS_DCTS16] <= #1 msi_reset16 ? 4'b0 :
			msr16[`UART_MS_DDCD16:`UART_MS_DCTS16] | ({dcd16, ri, dsr16, cts16} ^ delayed_modem_signals16[3:0]);
		msr16[`UART_MS_CDCD16:`UART_MS_CCTS16] <= #1 {dcd_c16, ri_c16, dsr_c16, cts_c16};
		delayed_modem_signals16[3:0] <= #1 {dcd16, ri, dsr16, cts16};
	end
end


// Line16 Status Register

// activation16 conditions16
assign lsr016 = (rf_count16==0 && rf_push_pulse16);  // data in receiver16 fifo available set condition
assign lsr116 = rf_overrun16;     // Receiver16 overrun16 error
assign lsr216 = rf_data_out16[1]; // parity16 error bit
assign lsr316 = rf_data_out16[0]; // framing16 error bit
assign lsr416 = rf_data_out16[2]; // break error in the character16
assign lsr516 = (tf_count16==5'b0 && thre_set_en16);  // transmitter16 fifo is empty16
assign lsr616 = (tf_count16==5'b0 && thre_set_en16 && (tstate16 == /*`S_IDLE16 */ 0)); // transmitter16 empty16
assign lsr716 = rf_error_bit16 | rf_overrun16;

// lsr16 bit016 (receiver16 data available)
reg 	 lsr0_d16;

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr0_d16 <= #1 0;
	else lsr0_d16 <= #1 lsr016;

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr0r16 <= #1 0;
	else lsr0r16 <= #1 (rf_count16==1 && rf_pop16 && !rf_push_pulse16 || rx_reset16) ? 0 : // deassert16 condition
					  lsr0r16 || (lsr016 && ~lsr0_d16); // set on rise16 of lsr016 and keep16 asserted16 until deasserted16 

// lsr16 bit 1 (receiver16 overrun16)
reg lsr1_d16; // delayed16

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr1_d16 <= #1 0;
	else lsr1_d16 <= #1 lsr116;

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr1r16 <= #1 0;
	else	lsr1r16 <= #1	lsr_mask16 ? 0 : lsr1r16 || (lsr116 && ~lsr1_d16); // set on rise16

// lsr16 bit 2 (parity16 error)
reg lsr2_d16; // delayed16

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr2_d16 <= #1 0;
	else lsr2_d16 <= #1 lsr216;

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr2r16 <= #1 0;
	else lsr2r16 <= #1 lsr_mask16 ? 0 : lsr2r16 || (lsr216 && ~lsr2_d16); // set on rise16

// lsr16 bit 3 (framing16 error)
reg lsr3_d16; // delayed16

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr3_d16 <= #1 0;
	else lsr3_d16 <= #1 lsr316;

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr3r16 <= #1 0;
	else lsr3r16 <= #1 lsr_mask16 ? 0 : lsr3r16 || (lsr316 && ~lsr3_d16); // set on rise16

// lsr16 bit 4 (break indicator16)
reg lsr4_d16; // delayed16

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr4_d16 <= #1 0;
	else lsr4_d16 <= #1 lsr416;

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr4r16 <= #1 0;
	else lsr4r16 <= #1 lsr_mask16 ? 0 : lsr4r16 || (lsr416 && ~lsr4_d16);

// lsr16 bit 5 (transmitter16 fifo is empty16)
reg lsr5_d16;

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr5_d16 <= #1 1;
	else lsr5_d16 <= #1 lsr516;

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr5r16 <= #1 1;
	else lsr5r16 <= #1 (fifo_write16) ? 0 :  lsr5r16 || (lsr516 && ~lsr5_d16);

// lsr16 bit 6 (transmitter16 empty16 indicator16)
reg lsr6_d16;

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr6_d16 <= #1 1;
	else lsr6_d16 <= #1 lsr616;

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr6r16 <= #1 1;
	else lsr6r16 <= #1 (fifo_write16) ? 0 : lsr6r16 || (lsr616 && ~lsr6_d16);

// lsr16 bit 7 (error in fifo)
reg lsr7_d16;

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr7_d16 <= #1 0;
	else lsr7_d16 <= #1 lsr716;

always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) lsr7r16 <= #1 0;
	else lsr7r16 <= #1 lsr_mask16 ? 0 : lsr7r16 || (lsr716 && ~lsr7_d16);

// Frequency16 divider16
always @(posedge clk16 or posedge wb_rst_i16) 
begin
	if (wb_rst_i16)
		dlc16 <= #1 0;
	else
		if (start_dlc16 | ~ (|dlc16))
  			dlc16 <= #1 dl16 - 1;               // preset16 counter
		else
			dlc16 <= #1 dlc16 - 1;              // decrement counter
end

// Enable16 signal16 generation16 logic
always @(posedge clk16 or posedge wb_rst_i16)
begin
	if (wb_rst_i16)
		enable <= #1 1'b0;
	else
		if (|dl16 & ~(|dlc16))     // dl16>0 & dlc16==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying16 THRE16 status for one character16 cycle after a character16 is written16 to an empty16 fifo.
always @(lcr16)
  case (lcr16[3:0])
    4'b0000                             : block_value16 =  95; // 6 bits
    4'b0100                             : block_value16 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value16 = 111; // 7 bits
    4'b1100                             : block_value16 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value16 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value16 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value16 = 159; // 10 bits
    4'b1111                             : block_value16 = 175; // 11 bits
  endcase // case(lcr16[3:0])

// Counting16 time of one character16 minus16 stop bit
always @(posedge clk16 or posedge wb_rst_i16)
begin
  if (wb_rst_i16)
    block_cnt16 <= #1 8'd0;
  else
  if(lsr5r16 & fifo_write16)  // THRE16 bit set & write to fifo occured16
    block_cnt16 <= #1 block_value16;
  else
  if (enable & block_cnt16 != 8'b0)  // only work16 on enable times
    block_cnt16 <= #1 block_cnt16 - 1;  // decrement break counter
end // always of break condition detection16

// Generating16 THRE16 status enable signal16
assign thre_set_en16 = ~(|block_cnt16);


//
//	INTERRUPT16 LOGIC16
//

assign rls_int16  = ier16[`UART_IE_RLS16] && (lsr16[`UART_LS_OE16] || lsr16[`UART_LS_PE16] || lsr16[`UART_LS_FE16] || lsr16[`UART_LS_BI16]);
assign rda_int16  = ier16[`UART_IE_RDA16] && (rf_count16 >= {1'b0,trigger_level16});
assign thre_int16 = ier16[`UART_IE_THRE16] && lsr16[`UART_LS_TFE16];
assign ms_int16   = ier16[`UART_IE_MS16] && (| msr16[3:0]);
assign ti_int16   = ier16[`UART_IE_RDA16] && (counter_t16 == 10'b0) && (|rf_count16);

reg 	 rls_int_d16;
reg 	 thre_int_d16;
reg 	 ms_int_d16;
reg 	 ti_int_d16;
reg 	 rda_int_d16;

// delay lines16
always  @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) rls_int_d16 <= #1 0;
	else rls_int_d16 <= #1 rls_int16;

always  @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) rda_int_d16 <= #1 0;
	else rda_int_d16 <= #1 rda_int16;

always  @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) thre_int_d16 <= #1 0;
	else thre_int_d16 <= #1 thre_int16;

always  @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) ms_int_d16 <= #1 0;
	else ms_int_d16 <= #1 ms_int16;

always  @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) ti_int_d16 <= #1 0;
	else ti_int_d16 <= #1 ti_int16;

// rise16 detection16 signals16

wire 	 rls_int_rise16;
wire 	 thre_int_rise16;
wire 	 ms_int_rise16;
wire 	 ti_int_rise16;
wire 	 rda_int_rise16;

assign rda_int_rise16    = rda_int16 & ~rda_int_d16;
assign rls_int_rise16 	  = rls_int16 & ~rls_int_d16;
assign thre_int_rise16   = thre_int16 & ~thre_int_d16;
assign ms_int_rise16 	  = ms_int16 & ~ms_int_d16;
assign ti_int_rise16 	  = ti_int16 & ~ti_int_d16;

// interrupt16 pending flags16
reg 	rls_int_pnd16;
reg	rda_int_pnd16;
reg 	thre_int_pnd16;
reg 	ms_int_pnd16;
reg 	ti_int_pnd16;

// interrupt16 pending flags16 assignments16
always  @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) rls_int_pnd16 <= #1 0; 
	else 
		rls_int_pnd16 <= #1 lsr_mask16 ? 0 :  						// reset condition
							rls_int_rise16 ? 1 :						// latch16 condition
							rls_int_pnd16 && ier16[`UART_IE_RLS16];	// default operation16: remove if masked16

always  @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) rda_int_pnd16 <= #1 0; 
	else 
		rda_int_pnd16 <= #1 ((rf_count16 == {1'b0,trigger_level16}) && fifo_read16) ? 0 :  	// reset condition
							rda_int_rise16 ? 1 :						// latch16 condition
							rda_int_pnd16 && ier16[`UART_IE_RDA16];	// default operation16: remove if masked16

always  @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) thre_int_pnd16 <= #1 0; 
	else 
		thre_int_pnd16 <= #1 fifo_write16 || (iir_read16 & ~iir16[`UART_II_IP16] & iir16[`UART_II_II16] == `UART_II_THRE16)? 0 : 
							thre_int_rise16 ? 1 :
							thre_int_pnd16 && ier16[`UART_IE_THRE16];

always  @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) ms_int_pnd16 <= #1 0; 
	else 
		ms_int_pnd16 <= #1 msr_read16 ? 0 : 
							ms_int_rise16 ? 1 :
							ms_int_pnd16 && ier16[`UART_IE_MS16];

always  @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) ti_int_pnd16 <= #1 0; 
	else 
		ti_int_pnd16 <= #1 fifo_read16 ? 0 : 
							ti_int_rise16 ? 1 :
							ti_int_pnd16 && ier16[`UART_IE_RDA16];
// end of pending flags16

// INT_O16 logic
always @(posedge clk16 or posedge wb_rst_i16)
begin
	if (wb_rst_i16)	
		int_o16 <= #1 1'b0;
	else
		int_o16 <= #1 
					rls_int_pnd16		?	~lsr_mask16					:
					rda_int_pnd16		? 1								:
					ti_int_pnd16		? ~fifo_read16					:
					thre_int_pnd16	? !(fifo_write16 & iir_read16) :
					ms_int_pnd16		? ~msr_read16						:
					0;	// if no interrupt16 are pending
end


// Interrupt16 Identification16 register
always @(posedge clk16 or posedge wb_rst_i16)
begin
	if (wb_rst_i16)
		iir16 <= #1 1;
	else
	if (rls_int_pnd16)  // interrupt16 is pending
	begin
		iir16[`UART_II_II16] <= #1 `UART_II_RLS16;	// set identification16 register to correct16 value
		iir16[`UART_II_IP16] <= #1 1'b0;		// and clear the IIR16 bit 0 (interrupt16 pending)
	end else // the sequence of conditions16 determines16 priority of interrupt16 identification16
	if (rda_int16)
	begin
		iir16[`UART_II_II16] <= #1 `UART_II_RDA16;
		iir16[`UART_II_IP16] <= #1 1'b0;
	end
	else if (ti_int_pnd16)
	begin
		iir16[`UART_II_II16] <= #1 `UART_II_TI16;
		iir16[`UART_II_IP16] <= #1 1'b0;
	end
	else if (thre_int_pnd16)
	begin
		iir16[`UART_II_II16] <= #1 `UART_II_THRE16;
		iir16[`UART_II_IP16] <= #1 1'b0;
	end
	else if (ms_int_pnd16)
	begin
		iir16[`UART_II_II16] <= #1 `UART_II_MS16;
		iir16[`UART_II_IP16] <= #1 1'b0;
	end else	// no interrupt16 is pending
	begin
		iir16[`UART_II_II16] <= #1 0;
		iir16[`UART_II_IP16] <= #1 1'b1;
	end
end

endmodule
