//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs27.v                                                 ////
////                                                              ////
////                                                              ////
////  This27 file is part of the "UART27 16550 compatible27" project27    ////
////  http27://www27.opencores27.org27/cores27/uart1655027/                   ////
////                                                              ////
////  Documentation27 related27 to this project27:                      ////
////  - http27://www27.opencores27.org27/cores27/uart1655027/                 ////
////                                                              ////
////  Projects27 compatibility27:                                     ////
////  - WISHBONE27                                                  ////
////  RS23227 Protocol27                                              ////
////  16550D uart27 (mostly27 supported)                              ////
////                                                              ////
////  Overview27 (main27 Features27):                                   ////
////  Registers27 of the uart27 16550 core27                            ////
////                                                              ////
////  Known27 problems27 (limits27):                                    ////
////  Inserts27 1 wait state in all WISHBONE27 transfers27              ////
////                                                              ////
////  To27 Do27:                                                      ////
////  Nothing or verification27.                                    ////
////                                                              ////
////  Author27(s):                                                  ////
////      - gorban27@opencores27.org27                                  ////
////      - Jacob27 Gorban27                                          ////
////      - Igor27 Mohor27 (igorm27@opencores27.org27)                      ////
////                                                              ////
////  Created27:        2001/05/12                                  ////
////  Last27 Updated27:   (See log27 for the revision27 history27           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2000, 2001 Authors27                             ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS27 Revision27 History27
//
// $Log: not supported by cvs2svn27 $
// Revision27 1.41  2004/05/21 11:44:41  tadejm27
// Added27 synchronizer27 flops27 for RX27 input.
//
// Revision27 1.40  2003/06/11 16:37:47  gorban27
// This27 fixes27 errors27 in some27 cases27 when data is being read and put to the FIFO at the same time. Patch27 is submitted27 by Scott27 Furman27. Update is very27 recommended27.
//
// Revision27 1.39  2002/07/29 21:16:18  gorban27
// The uart_defines27.v file is included27 again27 in sources27.
//
// Revision27 1.38  2002/07/22 23:02:23  gorban27
// Bug27 Fixes27:
//  * Possible27 loss of sync and bad27 reception27 of stop bit on slow27 baud27 rates27 fixed27.
//   Problem27 reported27 by Kenny27.Tung27.
//  * Bad (or lack27 of ) loopback27 handling27 fixed27. Reported27 by Cherry27 Withers27.
//
// Improvements27:
//  * Made27 FIFO's as general27 inferrable27 memory where possible27.
//  So27 on FPGA27 they should be inferred27 as RAM27 (Distributed27 RAM27 on Xilinx27).
//  This27 saves27 about27 1/3 of the Slice27 count and reduces27 P&R and synthesis27 times.
//
//  * Added27 optional27 baudrate27 output (baud_o27).
//  This27 is identical27 to BAUDOUT27* signal27 on 16550 chip27.
//  It outputs27 16xbit_clock_rate - the divided27 clock27.
//  It's disabled by default. Define27 UART_HAS_BAUDRATE_OUTPUT27 to use.
//
// Revision27 1.37  2001/12/27 13:24:09  mohor27
// lsr27[7] was not showing27 overrun27 errors27.
//
// Revision27 1.36  2001/12/20 13:25:46  mohor27
// rx27 push27 changed to be only one cycle wide27.
//
// Revision27 1.35  2001/12/19 08:03:34  mohor27
// Warnings27 cleared27.
//
// Revision27 1.34  2001/12/19 07:33:54  mohor27
// Synplicity27 was having27 troubles27 with the comment27.
//
// Revision27 1.33  2001/12/17 10:14:43  mohor27
// Things27 related27 to msr27 register changed. After27 THRE27 IRQ27 occurs27, and one
// character27 is written27 to the transmit27 fifo, the detection27 of the THRE27 bit in the
// LSR27 is delayed27 for one character27 time.
//
// Revision27 1.32  2001/12/14 13:19:24  mohor27
// MSR27 register fixed27.
//
// Revision27 1.31  2001/12/14 10:06:58  mohor27
// After27 reset modem27 status register MSR27 should be reset.
//
// Revision27 1.30  2001/12/13 10:09:13  mohor27
// thre27 irq27 should be cleared27 only when being source27 of interrupt27.
//
// Revision27 1.29  2001/12/12 09:05:46  mohor27
// LSR27 status bit 0 was not cleared27 correctly in case of reseting27 the FCR27 (rx27 fifo).
//
// Revision27 1.28  2001/12/10 19:52:41  gorban27
// Scratch27 register added
//
// Revision27 1.27  2001/12/06 14:51:04  gorban27
// Bug27 in LSR27[0] is fixed27.
// All WISHBONE27 signals27 are now sampled27, so another27 wait-state is introduced27 on all transfers27.
//
// Revision27 1.26  2001/12/03 21:44:29  gorban27
// Updated27 specification27 documentation.
// Added27 full 32-bit data bus interface, now as default.
// Address is 5-bit wide27 in 32-bit data bus mode.
// Added27 wb_sel_i27 input to the core27. It's used in the 32-bit mode.
// Added27 debug27 interface with two27 32-bit read-only registers in 32-bit mode.
// Bits27 5 and 6 of LSR27 are now only cleared27 on TX27 FIFO write.
// My27 small test bench27 is modified to work27 with 32-bit mode.
//
// Revision27 1.25  2001/11/28 19:36:39  gorban27
// Fixed27: timeout and break didn27't pay27 attention27 to current data format27 when counting27 time
//
// Revision27 1.24  2001/11/26 21:38:54  gorban27
// Lots27 of fixes27:
// Break27 condition wasn27't handled27 correctly at all.
// LSR27 bits could lose27 their27 values.
// LSR27 value after reset was wrong27.
// Timing27 of THRE27 interrupt27 signal27 corrected27.
// LSR27 bit 0 timing27 corrected27.
//
// Revision27 1.23  2001/11/12 21:57:29  gorban27
// fixed27 more typo27 bugs27
//
// Revision27 1.22  2001/11/12 15:02:28  mohor27
// lsr1r27 error fixed27.
//
// Revision27 1.21  2001/11/12 14:57:27  mohor27
// ti_int_pnd27 error fixed27.
//
// Revision27 1.20  2001/11/12 14:50:27  mohor27
// ti_int_d27 error fixed27.
//
// Revision27 1.19  2001/11/10 12:43:21  gorban27
// Logic27 Synthesis27 bugs27 fixed27. Some27 other minor27 changes27
//
// Revision27 1.18  2001/11/08 14:54:23  mohor27
// Comments27 in Slovene27 language27 deleted27, few27 small fixes27 for better27 work27 of
// old27 tools27. IRQs27 need to be fix27.
//
// Revision27 1.17  2001/11/07 17:51:52  gorban27
// Heavily27 rewritten27 interrupt27 and LSR27 subsystems27.
// Many27 bugs27 hopefully27 squashed27.
//
// Revision27 1.16  2001/11/02 09:55:16  mohor27
// no message
//
// Revision27 1.15  2001/10/31 15:19:22  gorban27
// Fixes27 to break and timeout conditions27
//
// Revision27 1.14  2001/10/29 17:00:46  gorban27
// fixed27 parity27 sending27 and tx_fifo27 resets27 over- and underrun27
//
// Revision27 1.13  2001/10/20 09:58:40  gorban27
// Small27 synopsis27 fixes27
//
// Revision27 1.12  2001/10/19 16:21:40  gorban27
// Changes27 data_out27 to be synchronous27 again27 as it should have been.
//
// Revision27 1.11  2001/10/18 20:35:45  gorban27
// small fix27
//
// Revision27 1.10  2001/08/24 21:01:12  mohor27
// Things27 connected27 to parity27 changed.
// Clock27 devider27 changed.
//
// Revision27 1.9  2001/08/23 16:05:05  mohor27
// Stop bit bug27 fixed27.
// Parity27 bug27 fixed27.
// WISHBONE27 read cycle bug27 fixed27,
// OE27 indicator27 (Overrun27 Error) bug27 fixed27.
// PE27 indicator27 (Parity27 Error) bug27 fixed27.
// Register read bug27 fixed27.
//
// Revision27 1.10  2001/06/23 11:21:48  gorban27
// DL27 made27 16-bit long27. Fixed27 transmission27/reception27 bugs27.
//
// Revision27 1.9  2001/05/31 20:08:01  gorban27
// FIFO changes27 and other corrections27.
//
// Revision27 1.8  2001/05/29 20:05:04  gorban27
// Fixed27 some27 bugs27 and synthesis27 problems27.
//
// Revision27 1.7  2001/05/27 17:37:49  gorban27
// Fixed27 many27 bugs27. Updated27 spec27. Changed27 FIFO files structure27. See CHANGES27.txt27 file.
//
// Revision27 1.6  2001/05/21 19:12:02  gorban27
// Corrected27 some27 Linter27 messages27.
//
// Revision27 1.5  2001/05/17 18:34:18  gorban27
// First27 'stable' release. Should27 be sythesizable27 now. Also27 added new header.
//
// Revision27 1.0  2001-05-17 21:27:11+02  jacob27
// Initial27 revision27
//
//

// synopsys27 translate_off27
`include "timescale.v"
// synopsys27 translate_on27

`include "uart_defines27.v"

`define UART_DL127 7:0
`define UART_DL227 15:8

module uart_regs27 (clk27,
	wb_rst_i27, wb_addr_i27, wb_dat_i27, wb_dat_o27, wb_we_i27, wb_re_i27, 

// additional27 signals27
	modem_inputs27,
	stx_pad_o27, srx_pad_i27,

`ifdef DATA_BUS_WIDTH_827
`else
// debug27 interface signals27	enabled
ier27, iir27, fcr27, mcr27, lcr27, msr27, lsr27, rf_count27, tf_count27, tstate27, rstate,
`endif				
	rts_pad_o27, dtr_pad_o27, int_o27
`ifdef UART_HAS_BAUDRATE_OUTPUT27
	, baud_o27
`endif

	);

input 									clk27;
input 									wb_rst_i27;
input [`UART_ADDR_WIDTH27-1:0] 		wb_addr_i27;
input [7:0] 							wb_dat_i27;
output [7:0] 							wb_dat_o27;
input 									wb_we_i27;
input 									wb_re_i27;

output 									stx_pad_o27;
input 									srx_pad_i27;

input [3:0] 							modem_inputs27;
output 									rts_pad_o27;
output 									dtr_pad_o27;
output 									int_o27;
`ifdef UART_HAS_BAUDRATE_OUTPUT27
output	baud_o27;
`endif

`ifdef DATA_BUS_WIDTH_827
`else
// if 32-bit databus27 and debug27 interface are enabled
output [3:0]							ier27;
output [3:0]							iir27;
output [1:0]							fcr27;  /// bits 7 and 6 of fcr27. Other27 bits are ignored
output [4:0]							mcr27;
output [7:0]							lcr27;
output [7:0]							msr27;
output [7:0] 							lsr27;
output [`UART_FIFO_COUNTER_W27-1:0] 	rf_count27;
output [`UART_FIFO_COUNTER_W27-1:0] 	tf_count27;
output [2:0] 							tstate27;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs27;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT27
assign baud_o27 = enable; // baud_o27 is actually27 the enable signal27
`endif


wire 										stx_pad_o27;		// received27 from transmitter27 module
wire 										srx_pad_i27;
wire 										srx_pad27;

reg [7:0] 								wb_dat_o27;

wire [`UART_ADDR_WIDTH27-1:0] 		wb_addr_i27;
wire [7:0] 								wb_dat_i27;


reg [3:0] 								ier27;
reg [3:0] 								iir27;
reg [1:0] 								fcr27;  /// bits 7 and 6 of fcr27. Other27 bits are ignored
reg [4:0] 								mcr27;
reg [7:0] 								lcr27;
reg [7:0] 								msr27;
reg [15:0] 								dl27;  // 32-bit divisor27 latch27
reg [7:0] 								scratch27; // UART27 scratch27 register
reg 										start_dlc27; // activate27 dlc27 on writing to UART_DL127
reg 										lsr_mask_d27; // delay for lsr_mask27 condition
reg 										msi_reset27; // reset MSR27 4 lower27 bits indicator27
//reg 										threi_clear27; // THRE27 interrupt27 clear flag27
reg [15:0] 								dlc27;  // 32-bit divisor27 latch27 counter
reg 										int_o27;

reg [3:0] 								trigger_level27; // trigger level of the receiver27 FIFO
reg 										rx_reset27;
reg 										tx_reset27;

wire 										dlab27;			   // divisor27 latch27 access bit
wire 										cts_pad_i27, dsr_pad_i27, ri_pad_i27, dcd_pad_i27; // modem27 status bits
wire 										loopback27;		   // loopback27 bit (MCR27 bit 4)
wire 										cts27, dsr27, ri, dcd27;	   // effective27 signals27
wire                    cts_c27, dsr_c27, ri_c27, dcd_c27; // Complement27 effective27 signals27 (considering27 loopback27)
wire 										rts_pad_o27, dtr_pad_o27;		   // modem27 control27 outputs27

// LSR27 bits wires27 and regs
wire [7:0] 								lsr27;
wire 										lsr027, lsr127, lsr227, lsr327, lsr427, lsr527, lsr627, lsr727;
reg										lsr0r27, lsr1r27, lsr2r27, lsr3r27, lsr4r27, lsr5r27, lsr6r27, lsr7r27;
wire 										lsr_mask27; // lsr_mask27

//
// ASSINGS27
//

assign 									lsr27[7:0] = { lsr7r27, lsr6r27, lsr5r27, lsr4r27, lsr3r27, lsr2r27, lsr1r27, lsr0r27 };

assign 									{cts_pad_i27, dsr_pad_i27, ri_pad_i27, dcd_pad_i27} = modem_inputs27;
assign 									{cts27, dsr27, ri, dcd27} = ~{cts_pad_i27,dsr_pad_i27,ri_pad_i27,dcd_pad_i27};

assign                  {cts_c27, dsr_c27, ri_c27, dcd_c27} = loopback27 ? {mcr27[`UART_MC_RTS27],mcr27[`UART_MC_DTR27],mcr27[`UART_MC_OUT127],mcr27[`UART_MC_OUT227]}
                                                               : {cts_pad_i27,dsr_pad_i27,ri_pad_i27,dcd_pad_i27};

assign 									dlab27 = lcr27[`UART_LC_DL27];
assign 									loopback27 = mcr27[4];

// assign modem27 outputs27
assign 									rts_pad_o27 = mcr27[`UART_MC_RTS27];
assign 									dtr_pad_o27 = mcr27[`UART_MC_DTR27];

// Interrupt27 signals27
wire 										rls_int27;  // receiver27 line status interrupt27
wire 										rda_int27;  // receiver27 data available interrupt27
wire 										ti_int27;   // timeout indicator27 interrupt27
wire										thre_int27; // transmitter27 holding27 register empty27 interrupt27
wire 										ms_int27;   // modem27 status interrupt27

// FIFO signals27
reg 										tf_push27;
reg 										rf_pop27;
wire [`UART_FIFO_REC_WIDTH27-1:0] 	rf_data_out27;
wire 										rf_error_bit27; // an error (parity27 or framing27) is inside the fifo
wire [`UART_FIFO_COUNTER_W27-1:0] 	rf_count27;
wire [`UART_FIFO_COUNTER_W27-1:0] 	tf_count27;
wire [2:0] 								tstate27;
wire [3:0] 								rstate;
wire [9:0] 								counter_t27;

wire                      thre_set_en27; // THRE27 status is delayed27 one character27 time when a character27 is written27 to fifo.
reg  [7:0]                block_cnt27;   // While27 counter counts27, THRE27 status is blocked27 (delayed27 one character27 cycle)
reg  [7:0]                block_value27; // One27 character27 length minus27 stop bit

// Transmitter27 Instance
wire serial_out27;

uart_transmitter27 transmitter27(clk27, wb_rst_i27, lcr27, tf_push27, wb_dat_i27, enable, serial_out27, tstate27, tf_count27, tx_reset27, lsr_mask27);

  // Synchronizing27 and sampling27 serial27 RX27 input
  uart_sync_flops27    i_uart_sync_flops27
  (
    .rst_i27           (wb_rst_i27),
    .clk_i27           (clk27),
    .stage1_rst_i27    (1'b0),
    .stage1_clk_en_i27 (1'b1),
    .async_dat_i27     (srx_pad_i27),
    .sync_dat_o27      (srx_pad27)
  );
  defparam i_uart_sync_flops27.width      = 1;
  defparam i_uart_sync_flops27.init_value27 = 1'b1;

// handle loopback27
wire serial_in27 = loopback27 ? serial_out27 : srx_pad27;
assign stx_pad_o27 = loopback27 ? 1'b1 : serial_out27;

// Receiver27 Instance
uart_receiver27 receiver27(clk27, wb_rst_i27, lcr27, rf_pop27, serial_in27, enable, 
	counter_t27, rf_count27, rf_data_out27, rf_error_bit27, rf_overrun27, rx_reset27, lsr_mask27, rstate, rf_push_pulse27);


// Asynchronous27 reading here27 because the outputs27 are sampled27 in uart_wb27.v file 
always @(dl27 or dlab27 or ier27 or iir27 or scratch27
			or lcr27 or lsr27 or msr27 or rf_data_out27 or wb_addr_i27 or wb_re_i27)   // asynchrounous27 reading
begin
	case (wb_addr_i27)
		`UART_REG_RB27   : wb_dat_o27 = dlab27 ? dl27[`UART_DL127] : rf_data_out27[10:3];
		`UART_REG_IE27	: wb_dat_o27 = dlab27 ? dl27[`UART_DL227] : ier27;
		`UART_REG_II27	: wb_dat_o27 = {4'b1100,iir27};
		`UART_REG_LC27	: wb_dat_o27 = lcr27;
		`UART_REG_LS27	: wb_dat_o27 = lsr27;
		`UART_REG_MS27	: wb_dat_o27 = msr27;
		`UART_REG_SR27	: wb_dat_o27 = scratch27;
		default:  wb_dat_o27 = 8'b0; // ??
	endcase // case(wb_addr_i27)
end // always @ (dl27 or dlab27 or ier27 or iir27 or scratch27...


// rf_pop27 signal27 handling27
always @(posedge clk27 or posedge wb_rst_i27)
begin
	if (wb_rst_i27)
		rf_pop27 <= #1 0; 
	else
	if (rf_pop27)	// restore27 the signal27 to 0 after one clock27 cycle
		rf_pop27 <= #1 0;
	else
	if (wb_re_i27 && wb_addr_i27 == `UART_REG_RB27 && !dlab27)
		rf_pop27 <= #1 1; // advance27 read pointer27
end

wire 	lsr_mask_condition27;
wire 	iir_read27;
wire  msr_read27;
wire	fifo_read27;
wire	fifo_write27;

assign lsr_mask_condition27 = (wb_re_i27 && wb_addr_i27 == `UART_REG_LS27 && !dlab27);
assign iir_read27 = (wb_re_i27 && wb_addr_i27 == `UART_REG_II27 && !dlab27);
assign msr_read27 = (wb_re_i27 && wb_addr_i27 == `UART_REG_MS27 && !dlab27);
assign fifo_read27 = (wb_re_i27 && wb_addr_i27 == `UART_REG_RB27 && !dlab27);
assign fifo_write27 = (wb_we_i27 && wb_addr_i27 == `UART_REG_TR27 && !dlab27);

// lsr_mask_d27 delayed27 signal27 handling27
always @(posedge clk27 or posedge wb_rst_i27)
begin
	if (wb_rst_i27)
		lsr_mask_d27 <= #1 0;
	else // reset bits in the Line27 Status Register
		lsr_mask_d27 <= #1 lsr_mask_condition27;
end

// lsr_mask27 is rise27 detected
assign lsr_mask27 = lsr_mask_condition27 && ~lsr_mask_d27;

// msi_reset27 signal27 handling27
always @(posedge clk27 or posedge wb_rst_i27)
begin
	if (wb_rst_i27)
		msi_reset27 <= #1 1;
	else
	if (msi_reset27)
		msi_reset27 <= #1 0;
	else
	if (msr_read27)
		msi_reset27 <= #1 1; // reset bits in Modem27 Status Register
end


//
//   WRITES27 AND27 RESETS27   //
//
// Line27 Control27 Register
always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27)
		lcr27 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i27 && wb_addr_i27==`UART_REG_LC27)
		lcr27 <= #1 wb_dat_i27;

// Interrupt27 Enable27 Register or UART_DL227
always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27)
	begin
		ier27 <= #1 4'b0000; // no interrupts27 after reset
		dl27[`UART_DL227] <= #1 8'b0;
	end
	else
	if (wb_we_i27 && wb_addr_i27==`UART_REG_IE27)
		if (dlab27)
		begin
			dl27[`UART_DL227] <= #1 wb_dat_i27;
		end
		else
			ier27 <= #1 wb_dat_i27[3:0]; // ier27 uses only 4 lsb


// FIFO Control27 Register and rx_reset27, tx_reset27 signals27
always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) begin
		fcr27 <= #1 2'b11; 
		rx_reset27 <= #1 0;
		tx_reset27 <= #1 0;
	end else
	if (wb_we_i27 && wb_addr_i27==`UART_REG_FC27) begin
		fcr27 <= #1 wb_dat_i27[7:6];
		rx_reset27 <= #1 wb_dat_i27[1];
		tx_reset27 <= #1 wb_dat_i27[2];
	end else begin
		rx_reset27 <= #1 0;
		tx_reset27 <= #1 0;
	end

// Modem27 Control27 Register
always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27)
		mcr27 <= #1 5'b0; 
	else
	if (wb_we_i27 && wb_addr_i27==`UART_REG_MC27)
			mcr27 <= #1 wb_dat_i27[4:0];

// Scratch27 register
// Line27 Control27 Register
always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27)
		scratch27 <= #1 0; // 8n1 setting
	else
	if (wb_we_i27 && wb_addr_i27==`UART_REG_SR27)
		scratch27 <= #1 wb_dat_i27;

// TX_FIFO27 or UART_DL127
always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27)
	begin
		dl27[`UART_DL127]  <= #1 8'b0;
		tf_push27   <= #1 1'b0;
		start_dlc27 <= #1 1'b0;
	end
	else
	if (wb_we_i27 && wb_addr_i27==`UART_REG_TR27)
		if (dlab27)
		begin
			dl27[`UART_DL127] <= #1 wb_dat_i27;
			start_dlc27 <= #1 1'b1; // enable DL27 counter
			tf_push27 <= #1 1'b0;
		end
		else
		begin
			tf_push27   <= #1 1'b1;
			start_dlc27 <= #1 1'b0;
		end // else: !if(dlab27)
	else
	begin
		start_dlc27 <= #1 1'b0;
		tf_push27   <= #1 1'b0;
	end // else: !if(dlab27)

// Receiver27 FIFO trigger level selection logic (asynchronous27 mux27)
always @(fcr27)
	case (fcr27[`UART_FC_TL27])
		2'b00 : trigger_level27 = 1;
		2'b01 : trigger_level27 = 4;
		2'b10 : trigger_level27 = 8;
		2'b11 : trigger_level27 = 14;
	endcase // case(fcr27[`UART_FC_TL27])
	
//
//  STATUS27 REGISTERS27  //
//

// Modem27 Status Register
reg [3:0] delayed_modem_signals27;
always @(posedge clk27 or posedge wb_rst_i27)
begin
	if (wb_rst_i27)
	  begin
  		msr27 <= #1 0;
	  	delayed_modem_signals27[3:0] <= #1 0;
	  end
	else begin
		msr27[`UART_MS_DDCD27:`UART_MS_DCTS27] <= #1 msi_reset27 ? 4'b0 :
			msr27[`UART_MS_DDCD27:`UART_MS_DCTS27] | ({dcd27, ri, dsr27, cts27} ^ delayed_modem_signals27[3:0]);
		msr27[`UART_MS_CDCD27:`UART_MS_CCTS27] <= #1 {dcd_c27, ri_c27, dsr_c27, cts_c27};
		delayed_modem_signals27[3:0] <= #1 {dcd27, ri, dsr27, cts27};
	end
end


// Line27 Status Register

// activation27 conditions27
assign lsr027 = (rf_count27==0 && rf_push_pulse27);  // data in receiver27 fifo available set condition
assign lsr127 = rf_overrun27;     // Receiver27 overrun27 error
assign lsr227 = rf_data_out27[1]; // parity27 error bit
assign lsr327 = rf_data_out27[0]; // framing27 error bit
assign lsr427 = rf_data_out27[2]; // break error in the character27
assign lsr527 = (tf_count27==5'b0 && thre_set_en27);  // transmitter27 fifo is empty27
assign lsr627 = (tf_count27==5'b0 && thre_set_en27 && (tstate27 == /*`S_IDLE27 */ 0)); // transmitter27 empty27
assign lsr727 = rf_error_bit27 | rf_overrun27;

// lsr27 bit027 (receiver27 data available)
reg 	 lsr0_d27;

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr0_d27 <= #1 0;
	else lsr0_d27 <= #1 lsr027;

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr0r27 <= #1 0;
	else lsr0r27 <= #1 (rf_count27==1 && rf_pop27 && !rf_push_pulse27 || rx_reset27) ? 0 : // deassert27 condition
					  lsr0r27 || (lsr027 && ~lsr0_d27); // set on rise27 of lsr027 and keep27 asserted27 until deasserted27 

// lsr27 bit 1 (receiver27 overrun27)
reg lsr1_d27; // delayed27

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr1_d27 <= #1 0;
	else lsr1_d27 <= #1 lsr127;

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr1r27 <= #1 0;
	else	lsr1r27 <= #1	lsr_mask27 ? 0 : lsr1r27 || (lsr127 && ~lsr1_d27); // set on rise27

// lsr27 bit 2 (parity27 error)
reg lsr2_d27; // delayed27

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr2_d27 <= #1 0;
	else lsr2_d27 <= #1 lsr227;

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr2r27 <= #1 0;
	else lsr2r27 <= #1 lsr_mask27 ? 0 : lsr2r27 || (lsr227 && ~lsr2_d27); // set on rise27

// lsr27 bit 3 (framing27 error)
reg lsr3_d27; // delayed27

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr3_d27 <= #1 0;
	else lsr3_d27 <= #1 lsr327;

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr3r27 <= #1 0;
	else lsr3r27 <= #1 lsr_mask27 ? 0 : lsr3r27 || (lsr327 && ~lsr3_d27); // set on rise27

// lsr27 bit 4 (break indicator27)
reg lsr4_d27; // delayed27

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr4_d27 <= #1 0;
	else lsr4_d27 <= #1 lsr427;

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr4r27 <= #1 0;
	else lsr4r27 <= #1 lsr_mask27 ? 0 : lsr4r27 || (lsr427 && ~lsr4_d27);

// lsr27 bit 5 (transmitter27 fifo is empty27)
reg lsr5_d27;

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr5_d27 <= #1 1;
	else lsr5_d27 <= #1 lsr527;

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr5r27 <= #1 1;
	else lsr5r27 <= #1 (fifo_write27) ? 0 :  lsr5r27 || (lsr527 && ~lsr5_d27);

// lsr27 bit 6 (transmitter27 empty27 indicator27)
reg lsr6_d27;

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr6_d27 <= #1 1;
	else lsr6_d27 <= #1 lsr627;

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr6r27 <= #1 1;
	else lsr6r27 <= #1 (fifo_write27) ? 0 : lsr6r27 || (lsr627 && ~lsr6_d27);

// lsr27 bit 7 (error in fifo)
reg lsr7_d27;

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr7_d27 <= #1 0;
	else lsr7_d27 <= #1 lsr727;

always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) lsr7r27 <= #1 0;
	else lsr7r27 <= #1 lsr_mask27 ? 0 : lsr7r27 || (lsr727 && ~lsr7_d27);

// Frequency27 divider27
always @(posedge clk27 or posedge wb_rst_i27) 
begin
	if (wb_rst_i27)
		dlc27 <= #1 0;
	else
		if (start_dlc27 | ~ (|dlc27))
  			dlc27 <= #1 dl27 - 1;               // preset27 counter
		else
			dlc27 <= #1 dlc27 - 1;              // decrement counter
end

// Enable27 signal27 generation27 logic
always @(posedge clk27 or posedge wb_rst_i27)
begin
	if (wb_rst_i27)
		enable <= #1 1'b0;
	else
		if (|dl27 & ~(|dlc27))     // dl27>0 & dlc27==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying27 THRE27 status for one character27 cycle after a character27 is written27 to an empty27 fifo.
always @(lcr27)
  case (lcr27[3:0])
    4'b0000                             : block_value27 =  95; // 6 bits
    4'b0100                             : block_value27 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value27 = 111; // 7 bits
    4'b1100                             : block_value27 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value27 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value27 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value27 = 159; // 10 bits
    4'b1111                             : block_value27 = 175; // 11 bits
  endcase // case(lcr27[3:0])

// Counting27 time of one character27 minus27 stop bit
always @(posedge clk27 or posedge wb_rst_i27)
begin
  if (wb_rst_i27)
    block_cnt27 <= #1 8'd0;
  else
  if(lsr5r27 & fifo_write27)  // THRE27 bit set & write to fifo occured27
    block_cnt27 <= #1 block_value27;
  else
  if (enable & block_cnt27 != 8'b0)  // only work27 on enable times
    block_cnt27 <= #1 block_cnt27 - 1;  // decrement break counter
end // always of break condition detection27

// Generating27 THRE27 status enable signal27
assign thre_set_en27 = ~(|block_cnt27);


//
//	INTERRUPT27 LOGIC27
//

assign rls_int27  = ier27[`UART_IE_RLS27] && (lsr27[`UART_LS_OE27] || lsr27[`UART_LS_PE27] || lsr27[`UART_LS_FE27] || lsr27[`UART_LS_BI27]);
assign rda_int27  = ier27[`UART_IE_RDA27] && (rf_count27 >= {1'b0,trigger_level27});
assign thre_int27 = ier27[`UART_IE_THRE27] && lsr27[`UART_LS_TFE27];
assign ms_int27   = ier27[`UART_IE_MS27] && (| msr27[3:0]);
assign ti_int27   = ier27[`UART_IE_RDA27] && (counter_t27 == 10'b0) && (|rf_count27);

reg 	 rls_int_d27;
reg 	 thre_int_d27;
reg 	 ms_int_d27;
reg 	 ti_int_d27;
reg 	 rda_int_d27;

// delay lines27
always  @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) rls_int_d27 <= #1 0;
	else rls_int_d27 <= #1 rls_int27;

always  @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) rda_int_d27 <= #1 0;
	else rda_int_d27 <= #1 rda_int27;

always  @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) thre_int_d27 <= #1 0;
	else thre_int_d27 <= #1 thre_int27;

always  @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) ms_int_d27 <= #1 0;
	else ms_int_d27 <= #1 ms_int27;

always  @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) ti_int_d27 <= #1 0;
	else ti_int_d27 <= #1 ti_int27;

// rise27 detection27 signals27

wire 	 rls_int_rise27;
wire 	 thre_int_rise27;
wire 	 ms_int_rise27;
wire 	 ti_int_rise27;
wire 	 rda_int_rise27;

assign rda_int_rise27    = rda_int27 & ~rda_int_d27;
assign rls_int_rise27 	  = rls_int27 & ~rls_int_d27;
assign thre_int_rise27   = thre_int27 & ~thre_int_d27;
assign ms_int_rise27 	  = ms_int27 & ~ms_int_d27;
assign ti_int_rise27 	  = ti_int27 & ~ti_int_d27;

// interrupt27 pending flags27
reg 	rls_int_pnd27;
reg	rda_int_pnd27;
reg 	thre_int_pnd27;
reg 	ms_int_pnd27;
reg 	ti_int_pnd27;

// interrupt27 pending flags27 assignments27
always  @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) rls_int_pnd27 <= #1 0; 
	else 
		rls_int_pnd27 <= #1 lsr_mask27 ? 0 :  						// reset condition
							rls_int_rise27 ? 1 :						// latch27 condition
							rls_int_pnd27 && ier27[`UART_IE_RLS27];	// default operation27: remove if masked27

always  @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) rda_int_pnd27 <= #1 0; 
	else 
		rda_int_pnd27 <= #1 ((rf_count27 == {1'b0,trigger_level27}) && fifo_read27) ? 0 :  	// reset condition
							rda_int_rise27 ? 1 :						// latch27 condition
							rda_int_pnd27 && ier27[`UART_IE_RDA27];	// default operation27: remove if masked27

always  @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) thre_int_pnd27 <= #1 0; 
	else 
		thre_int_pnd27 <= #1 fifo_write27 || (iir_read27 & ~iir27[`UART_II_IP27] & iir27[`UART_II_II27] == `UART_II_THRE27)? 0 : 
							thre_int_rise27 ? 1 :
							thre_int_pnd27 && ier27[`UART_IE_THRE27];

always  @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) ms_int_pnd27 <= #1 0; 
	else 
		ms_int_pnd27 <= #1 msr_read27 ? 0 : 
							ms_int_rise27 ? 1 :
							ms_int_pnd27 && ier27[`UART_IE_MS27];

always  @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) ti_int_pnd27 <= #1 0; 
	else 
		ti_int_pnd27 <= #1 fifo_read27 ? 0 : 
							ti_int_rise27 ? 1 :
							ti_int_pnd27 && ier27[`UART_IE_RDA27];
// end of pending flags27

// INT_O27 logic
always @(posedge clk27 or posedge wb_rst_i27)
begin
	if (wb_rst_i27)	
		int_o27 <= #1 1'b0;
	else
		int_o27 <= #1 
					rls_int_pnd27		?	~lsr_mask27					:
					rda_int_pnd27		? 1								:
					ti_int_pnd27		? ~fifo_read27					:
					thre_int_pnd27	? !(fifo_write27 & iir_read27) :
					ms_int_pnd27		? ~msr_read27						:
					0;	// if no interrupt27 are pending
end


// Interrupt27 Identification27 register
always @(posedge clk27 or posedge wb_rst_i27)
begin
	if (wb_rst_i27)
		iir27 <= #1 1;
	else
	if (rls_int_pnd27)  // interrupt27 is pending
	begin
		iir27[`UART_II_II27] <= #1 `UART_II_RLS27;	// set identification27 register to correct27 value
		iir27[`UART_II_IP27] <= #1 1'b0;		// and clear the IIR27 bit 0 (interrupt27 pending)
	end else // the sequence of conditions27 determines27 priority of interrupt27 identification27
	if (rda_int27)
	begin
		iir27[`UART_II_II27] <= #1 `UART_II_RDA27;
		iir27[`UART_II_IP27] <= #1 1'b0;
	end
	else if (ti_int_pnd27)
	begin
		iir27[`UART_II_II27] <= #1 `UART_II_TI27;
		iir27[`UART_II_IP27] <= #1 1'b0;
	end
	else if (thre_int_pnd27)
	begin
		iir27[`UART_II_II27] <= #1 `UART_II_THRE27;
		iir27[`UART_II_IP27] <= #1 1'b0;
	end
	else if (ms_int_pnd27)
	begin
		iir27[`UART_II_II27] <= #1 `UART_II_MS27;
		iir27[`UART_II_IP27] <= #1 1'b0;
	end else	// no interrupt27 is pending
	begin
		iir27[`UART_II_II27] <= #1 0;
		iir27[`UART_II_IP27] <= #1 1'b1;
	end
end

endmodule
