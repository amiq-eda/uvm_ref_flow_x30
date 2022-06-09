//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs18.v                                                 ////
////                                                              ////
////                                                              ////
////  This18 file is part of the "UART18 16550 compatible18" project18    ////
////  http18://www18.opencores18.org18/cores18/uart1655018/                   ////
////                                                              ////
////  Documentation18 related18 to this project18:                      ////
////  - http18://www18.opencores18.org18/cores18/uart1655018/                 ////
////                                                              ////
////  Projects18 compatibility18:                                     ////
////  - WISHBONE18                                                  ////
////  RS23218 Protocol18                                              ////
////  16550D uart18 (mostly18 supported)                              ////
////                                                              ////
////  Overview18 (main18 Features18):                                   ////
////  Registers18 of the uart18 16550 core18                            ////
////                                                              ////
////  Known18 problems18 (limits18):                                    ////
////  Inserts18 1 wait state in all WISHBONE18 transfers18              ////
////                                                              ////
////  To18 Do18:                                                      ////
////  Nothing or verification18.                                    ////
////                                                              ////
////  Author18(s):                                                  ////
////      - gorban18@opencores18.org18                                  ////
////      - Jacob18 Gorban18                                          ////
////      - Igor18 Mohor18 (igorm18@opencores18.org18)                      ////
////                                                              ////
////  Created18:        2001/05/12                                  ////
////  Last18 Updated18:   (See log18 for the revision18 history18           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2000, 2001 Authors18                             ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS18 Revision18 History18
//
// $Log: not supported by cvs2svn18 $
// Revision18 1.41  2004/05/21 11:44:41  tadejm18
// Added18 synchronizer18 flops18 for RX18 input.
//
// Revision18 1.40  2003/06/11 16:37:47  gorban18
// This18 fixes18 errors18 in some18 cases18 when data is being read and put to the FIFO at the same time. Patch18 is submitted18 by Scott18 Furman18. Update is very18 recommended18.
//
// Revision18 1.39  2002/07/29 21:16:18  gorban18
// The uart_defines18.v file is included18 again18 in sources18.
//
// Revision18 1.38  2002/07/22 23:02:23  gorban18
// Bug18 Fixes18:
//  * Possible18 loss of sync and bad18 reception18 of stop bit on slow18 baud18 rates18 fixed18.
//   Problem18 reported18 by Kenny18.Tung18.
//  * Bad (or lack18 of ) loopback18 handling18 fixed18. Reported18 by Cherry18 Withers18.
//
// Improvements18:
//  * Made18 FIFO's as general18 inferrable18 memory where possible18.
//  So18 on FPGA18 they should be inferred18 as RAM18 (Distributed18 RAM18 on Xilinx18).
//  This18 saves18 about18 1/3 of the Slice18 count and reduces18 P&R and synthesis18 times.
//
//  * Added18 optional18 baudrate18 output (baud_o18).
//  This18 is identical18 to BAUDOUT18* signal18 on 16550 chip18.
//  It outputs18 16xbit_clock_rate - the divided18 clock18.
//  It's disabled by default. Define18 UART_HAS_BAUDRATE_OUTPUT18 to use.
//
// Revision18 1.37  2001/12/27 13:24:09  mohor18
// lsr18[7] was not showing18 overrun18 errors18.
//
// Revision18 1.36  2001/12/20 13:25:46  mohor18
// rx18 push18 changed to be only one cycle wide18.
//
// Revision18 1.35  2001/12/19 08:03:34  mohor18
// Warnings18 cleared18.
//
// Revision18 1.34  2001/12/19 07:33:54  mohor18
// Synplicity18 was having18 troubles18 with the comment18.
//
// Revision18 1.33  2001/12/17 10:14:43  mohor18
// Things18 related18 to msr18 register changed. After18 THRE18 IRQ18 occurs18, and one
// character18 is written18 to the transmit18 fifo, the detection18 of the THRE18 bit in the
// LSR18 is delayed18 for one character18 time.
//
// Revision18 1.32  2001/12/14 13:19:24  mohor18
// MSR18 register fixed18.
//
// Revision18 1.31  2001/12/14 10:06:58  mohor18
// After18 reset modem18 status register MSR18 should be reset.
//
// Revision18 1.30  2001/12/13 10:09:13  mohor18
// thre18 irq18 should be cleared18 only when being source18 of interrupt18.
//
// Revision18 1.29  2001/12/12 09:05:46  mohor18
// LSR18 status bit 0 was not cleared18 correctly in case of reseting18 the FCR18 (rx18 fifo).
//
// Revision18 1.28  2001/12/10 19:52:41  gorban18
// Scratch18 register added
//
// Revision18 1.27  2001/12/06 14:51:04  gorban18
// Bug18 in LSR18[0] is fixed18.
// All WISHBONE18 signals18 are now sampled18, so another18 wait-state is introduced18 on all transfers18.
//
// Revision18 1.26  2001/12/03 21:44:29  gorban18
// Updated18 specification18 documentation.
// Added18 full 32-bit data bus interface, now as default.
// Address is 5-bit wide18 in 32-bit data bus mode.
// Added18 wb_sel_i18 input to the core18. It's used in the 32-bit mode.
// Added18 debug18 interface with two18 32-bit read-only registers in 32-bit mode.
// Bits18 5 and 6 of LSR18 are now only cleared18 on TX18 FIFO write.
// My18 small test bench18 is modified to work18 with 32-bit mode.
//
// Revision18 1.25  2001/11/28 19:36:39  gorban18
// Fixed18: timeout and break didn18't pay18 attention18 to current data format18 when counting18 time
//
// Revision18 1.24  2001/11/26 21:38:54  gorban18
// Lots18 of fixes18:
// Break18 condition wasn18't handled18 correctly at all.
// LSR18 bits could lose18 their18 values.
// LSR18 value after reset was wrong18.
// Timing18 of THRE18 interrupt18 signal18 corrected18.
// LSR18 bit 0 timing18 corrected18.
//
// Revision18 1.23  2001/11/12 21:57:29  gorban18
// fixed18 more typo18 bugs18
//
// Revision18 1.22  2001/11/12 15:02:28  mohor18
// lsr1r18 error fixed18.
//
// Revision18 1.21  2001/11/12 14:57:27  mohor18
// ti_int_pnd18 error fixed18.
//
// Revision18 1.20  2001/11/12 14:50:27  mohor18
// ti_int_d18 error fixed18.
//
// Revision18 1.19  2001/11/10 12:43:21  gorban18
// Logic18 Synthesis18 bugs18 fixed18. Some18 other minor18 changes18
//
// Revision18 1.18  2001/11/08 14:54:23  mohor18
// Comments18 in Slovene18 language18 deleted18, few18 small fixes18 for better18 work18 of
// old18 tools18. IRQs18 need to be fix18.
//
// Revision18 1.17  2001/11/07 17:51:52  gorban18
// Heavily18 rewritten18 interrupt18 and LSR18 subsystems18.
// Many18 bugs18 hopefully18 squashed18.
//
// Revision18 1.16  2001/11/02 09:55:16  mohor18
// no message
//
// Revision18 1.15  2001/10/31 15:19:22  gorban18
// Fixes18 to break and timeout conditions18
//
// Revision18 1.14  2001/10/29 17:00:46  gorban18
// fixed18 parity18 sending18 and tx_fifo18 resets18 over- and underrun18
//
// Revision18 1.13  2001/10/20 09:58:40  gorban18
// Small18 synopsis18 fixes18
//
// Revision18 1.12  2001/10/19 16:21:40  gorban18
// Changes18 data_out18 to be synchronous18 again18 as it should have been.
//
// Revision18 1.11  2001/10/18 20:35:45  gorban18
// small fix18
//
// Revision18 1.10  2001/08/24 21:01:12  mohor18
// Things18 connected18 to parity18 changed.
// Clock18 devider18 changed.
//
// Revision18 1.9  2001/08/23 16:05:05  mohor18
// Stop bit bug18 fixed18.
// Parity18 bug18 fixed18.
// WISHBONE18 read cycle bug18 fixed18,
// OE18 indicator18 (Overrun18 Error) bug18 fixed18.
// PE18 indicator18 (Parity18 Error) bug18 fixed18.
// Register read bug18 fixed18.
//
// Revision18 1.10  2001/06/23 11:21:48  gorban18
// DL18 made18 16-bit long18. Fixed18 transmission18/reception18 bugs18.
//
// Revision18 1.9  2001/05/31 20:08:01  gorban18
// FIFO changes18 and other corrections18.
//
// Revision18 1.8  2001/05/29 20:05:04  gorban18
// Fixed18 some18 bugs18 and synthesis18 problems18.
//
// Revision18 1.7  2001/05/27 17:37:49  gorban18
// Fixed18 many18 bugs18. Updated18 spec18. Changed18 FIFO files structure18. See CHANGES18.txt18 file.
//
// Revision18 1.6  2001/05/21 19:12:02  gorban18
// Corrected18 some18 Linter18 messages18.
//
// Revision18 1.5  2001/05/17 18:34:18  gorban18
// First18 'stable' release. Should18 be sythesizable18 now. Also18 added new header.
//
// Revision18 1.0  2001-05-17 21:27:11+02  jacob18
// Initial18 revision18
//
//

// synopsys18 translate_off18
`include "timescale.v"
// synopsys18 translate_on18

`include "uart_defines18.v"

`define UART_DL118 7:0
`define UART_DL218 15:8

module uart_regs18 (clk18,
	wb_rst_i18, wb_addr_i18, wb_dat_i18, wb_dat_o18, wb_we_i18, wb_re_i18, 

// additional18 signals18
	modem_inputs18,
	stx_pad_o18, srx_pad_i18,

`ifdef DATA_BUS_WIDTH_818
`else
// debug18 interface signals18	enabled
ier18, iir18, fcr18, mcr18, lcr18, msr18, lsr18, rf_count18, tf_count18, tstate18, rstate,
`endif				
	rts_pad_o18, dtr_pad_o18, int_o18
`ifdef UART_HAS_BAUDRATE_OUTPUT18
	, baud_o18
`endif

	);

input 									clk18;
input 									wb_rst_i18;
input [`UART_ADDR_WIDTH18-1:0] 		wb_addr_i18;
input [7:0] 							wb_dat_i18;
output [7:0] 							wb_dat_o18;
input 									wb_we_i18;
input 									wb_re_i18;

output 									stx_pad_o18;
input 									srx_pad_i18;

input [3:0] 							modem_inputs18;
output 									rts_pad_o18;
output 									dtr_pad_o18;
output 									int_o18;
`ifdef UART_HAS_BAUDRATE_OUTPUT18
output	baud_o18;
`endif

`ifdef DATA_BUS_WIDTH_818
`else
// if 32-bit databus18 and debug18 interface are enabled
output [3:0]							ier18;
output [3:0]							iir18;
output [1:0]							fcr18;  /// bits 7 and 6 of fcr18. Other18 bits are ignored
output [4:0]							mcr18;
output [7:0]							lcr18;
output [7:0]							msr18;
output [7:0] 							lsr18;
output [`UART_FIFO_COUNTER_W18-1:0] 	rf_count18;
output [`UART_FIFO_COUNTER_W18-1:0] 	tf_count18;
output [2:0] 							tstate18;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs18;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT18
assign baud_o18 = enable; // baud_o18 is actually18 the enable signal18
`endif


wire 										stx_pad_o18;		// received18 from transmitter18 module
wire 										srx_pad_i18;
wire 										srx_pad18;

reg [7:0] 								wb_dat_o18;

wire [`UART_ADDR_WIDTH18-1:0] 		wb_addr_i18;
wire [7:0] 								wb_dat_i18;


reg [3:0] 								ier18;
reg [3:0] 								iir18;
reg [1:0] 								fcr18;  /// bits 7 and 6 of fcr18. Other18 bits are ignored
reg [4:0] 								mcr18;
reg [7:0] 								lcr18;
reg [7:0] 								msr18;
reg [15:0] 								dl18;  // 32-bit divisor18 latch18
reg [7:0] 								scratch18; // UART18 scratch18 register
reg 										start_dlc18; // activate18 dlc18 on writing to UART_DL118
reg 										lsr_mask_d18; // delay for lsr_mask18 condition
reg 										msi_reset18; // reset MSR18 4 lower18 bits indicator18
//reg 										threi_clear18; // THRE18 interrupt18 clear flag18
reg [15:0] 								dlc18;  // 32-bit divisor18 latch18 counter
reg 										int_o18;

reg [3:0] 								trigger_level18; // trigger level of the receiver18 FIFO
reg 										rx_reset18;
reg 										tx_reset18;

wire 										dlab18;			   // divisor18 latch18 access bit
wire 										cts_pad_i18, dsr_pad_i18, ri_pad_i18, dcd_pad_i18; // modem18 status bits
wire 										loopback18;		   // loopback18 bit (MCR18 bit 4)
wire 										cts18, dsr18, ri, dcd18;	   // effective18 signals18
wire                    cts_c18, dsr_c18, ri_c18, dcd_c18; // Complement18 effective18 signals18 (considering18 loopback18)
wire 										rts_pad_o18, dtr_pad_o18;		   // modem18 control18 outputs18

// LSR18 bits wires18 and regs
wire [7:0] 								lsr18;
wire 										lsr018, lsr118, lsr218, lsr318, lsr418, lsr518, lsr618, lsr718;
reg										lsr0r18, lsr1r18, lsr2r18, lsr3r18, lsr4r18, lsr5r18, lsr6r18, lsr7r18;
wire 										lsr_mask18; // lsr_mask18

//
// ASSINGS18
//

assign 									lsr18[7:0] = { lsr7r18, lsr6r18, lsr5r18, lsr4r18, lsr3r18, lsr2r18, lsr1r18, lsr0r18 };

assign 									{cts_pad_i18, dsr_pad_i18, ri_pad_i18, dcd_pad_i18} = modem_inputs18;
assign 									{cts18, dsr18, ri, dcd18} = ~{cts_pad_i18,dsr_pad_i18,ri_pad_i18,dcd_pad_i18};

assign                  {cts_c18, dsr_c18, ri_c18, dcd_c18} = loopback18 ? {mcr18[`UART_MC_RTS18],mcr18[`UART_MC_DTR18],mcr18[`UART_MC_OUT118],mcr18[`UART_MC_OUT218]}
                                                               : {cts_pad_i18,dsr_pad_i18,ri_pad_i18,dcd_pad_i18};

assign 									dlab18 = lcr18[`UART_LC_DL18];
assign 									loopback18 = mcr18[4];

// assign modem18 outputs18
assign 									rts_pad_o18 = mcr18[`UART_MC_RTS18];
assign 									dtr_pad_o18 = mcr18[`UART_MC_DTR18];

// Interrupt18 signals18
wire 										rls_int18;  // receiver18 line status interrupt18
wire 										rda_int18;  // receiver18 data available interrupt18
wire 										ti_int18;   // timeout indicator18 interrupt18
wire										thre_int18; // transmitter18 holding18 register empty18 interrupt18
wire 										ms_int18;   // modem18 status interrupt18

// FIFO signals18
reg 										tf_push18;
reg 										rf_pop18;
wire [`UART_FIFO_REC_WIDTH18-1:0] 	rf_data_out18;
wire 										rf_error_bit18; // an error (parity18 or framing18) is inside the fifo
wire [`UART_FIFO_COUNTER_W18-1:0] 	rf_count18;
wire [`UART_FIFO_COUNTER_W18-1:0] 	tf_count18;
wire [2:0] 								tstate18;
wire [3:0] 								rstate;
wire [9:0] 								counter_t18;

wire                      thre_set_en18; // THRE18 status is delayed18 one character18 time when a character18 is written18 to fifo.
reg  [7:0]                block_cnt18;   // While18 counter counts18, THRE18 status is blocked18 (delayed18 one character18 cycle)
reg  [7:0]                block_value18; // One18 character18 length minus18 stop bit

// Transmitter18 Instance
wire serial_out18;

uart_transmitter18 transmitter18(clk18, wb_rst_i18, lcr18, tf_push18, wb_dat_i18, enable, serial_out18, tstate18, tf_count18, tx_reset18, lsr_mask18);

  // Synchronizing18 and sampling18 serial18 RX18 input
  uart_sync_flops18    i_uart_sync_flops18
  (
    .rst_i18           (wb_rst_i18),
    .clk_i18           (clk18),
    .stage1_rst_i18    (1'b0),
    .stage1_clk_en_i18 (1'b1),
    .async_dat_i18     (srx_pad_i18),
    .sync_dat_o18      (srx_pad18)
  );
  defparam i_uart_sync_flops18.width      = 1;
  defparam i_uart_sync_flops18.init_value18 = 1'b1;

// handle loopback18
wire serial_in18 = loopback18 ? serial_out18 : srx_pad18;
assign stx_pad_o18 = loopback18 ? 1'b1 : serial_out18;

// Receiver18 Instance
uart_receiver18 receiver18(clk18, wb_rst_i18, lcr18, rf_pop18, serial_in18, enable, 
	counter_t18, rf_count18, rf_data_out18, rf_error_bit18, rf_overrun18, rx_reset18, lsr_mask18, rstate, rf_push_pulse18);


// Asynchronous18 reading here18 because the outputs18 are sampled18 in uart_wb18.v file 
always @(dl18 or dlab18 or ier18 or iir18 or scratch18
			or lcr18 or lsr18 or msr18 or rf_data_out18 or wb_addr_i18 or wb_re_i18)   // asynchrounous18 reading
begin
	case (wb_addr_i18)
		`UART_REG_RB18   : wb_dat_o18 = dlab18 ? dl18[`UART_DL118] : rf_data_out18[10:3];
		`UART_REG_IE18	: wb_dat_o18 = dlab18 ? dl18[`UART_DL218] : ier18;
		`UART_REG_II18	: wb_dat_o18 = {4'b1100,iir18};
		`UART_REG_LC18	: wb_dat_o18 = lcr18;
		`UART_REG_LS18	: wb_dat_o18 = lsr18;
		`UART_REG_MS18	: wb_dat_o18 = msr18;
		`UART_REG_SR18	: wb_dat_o18 = scratch18;
		default:  wb_dat_o18 = 8'b0; // ??
	endcase // case(wb_addr_i18)
end // always @ (dl18 or dlab18 or ier18 or iir18 or scratch18...


// rf_pop18 signal18 handling18
always @(posedge clk18 or posedge wb_rst_i18)
begin
	if (wb_rst_i18)
		rf_pop18 <= #1 0; 
	else
	if (rf_pop18)	// restore18 the signal18 to 0 after one clock18 cycle
		rf_pop18 <= #1 0;
	else
	if (wb_re_i18 && wb_addr_i18 == `UART_REG_RB18 && !dlab18)
		rf_pop18 <= #1 1; // advance18 read pointer18
end

wire 	lsr_mask_condition18;
wire 	iir_read18;
wire  msr_read18;
wire	fifo_read18;
wire	fifo_write18;

assign lsr_mask_condition18 = (wb_re_i18 && wb_addr_i18 == `UART_REG_LS18 && !dlab18);
assign iir_read18 = (wb_re_i18 && wb_addr_i18 == `UART_REG_II18 && !dlab18);
assign msr_read18 = (wb_re_i18 && wb_addr_i18 == `UART_REG_MS18 && !dlab18);
assign fifo_read18 = (wb_re_i18 && wb_addr_i18 == `UART_REG_RB18 && !dlab18);
assign fifo_write18 = (wb_we_i18 && wb_addr_i18 == `UART_REG_TR18 && !dlab18);

// lsr_mask_d18 delayed18 signal18 handling18
always @(posedge clk18 or posedge wb_rst_i18)
begin
	if (wb_rst_i18)
		lsr_mask_d18 <= #1 0;
	else // reset bits in the Line18 Status Register
		lsr_mask_d18 <= #1 lsr_mask_condition18;
end

// lsr_mask18 is rise18 detected
assign lsr_mask18 = lsr_mask_condition18 && ~lsr_mask_d18;

// msi_reset18 signal18 handling18
always @(posedge clk18 or posedge wb_rst_i18)
begin
	if (wb_rst_i18)
		msi_reset18 <= #1 1;
	else
	if (msi_reset18)
		msi_reset18 <= #1 0;
	else
	if (msr_read18)
		msi_reset18 <= #1 1; // reset bits in Modem18 Status Register
end


//
//   WRITES18 AND18 RESETS18   //
//
// Line18 Control18 Register
always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18)
		lcr18 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i18 && wb_addr_i18==`UART_REG_LC18)
		lcr18 <= #1 wb_dat_i18;

// Interrupt18 Enable18 Register or UART_DL218
always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18)
	begin
		ier18 <= #1 4'b0000; // no interrupts18 after reset
		dl18[`UART_DL218] <= #1 8'b0;
	end
	else
	if (wb_we_i18 && wb_addr_i18==`UART_REG_IE18)
		if (dlab18)
		begin
			dl18[`UART_DL218] <= #1 wb_dat_i18;
		end
		else
			ier18 <= #1 wb_dat_i18[3:0]; // ier18 uses only 4 lsb


// FIFO Control18 Register and rx_reset18, tx_reset18 signals18
always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) begin
		fcr18 <= #1 2'b11; 
		rx_reset18 <= #1 0;
		tx_reset18 <= #1 0;
	end else
	if (wb_we_i18 && wb_addr_i18==`UART_REG_FC18) begin
		fcr18 <= #1 wb_dat_i18[7:6];
		rx_reset18 <= #1 wb_dat_i18[1];
		tx_reset18 <= #1 wb_dat_i18[2];
	end else begin
		rx_reset18 <= #1 0;
		tx_reset18 <= #1 0;
	end

// Modem18 Control18 Register
always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18)
		mcr18 <= #1 5'b0; 
	else
	if (wb_we_i18 && wb_addr_i18==`UART_REG_MC18)
			mcr18 <= #1 wb_dat_i18[4:0];

// Scratch18 register
// Line18 Control18 Register
always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18)
		scratch18 <= #1 0; // 8n1 setting
	else
	if (wb_we_i18 && wb_addr_i18==`UART_REG_SR18)
		scratch18 <= #1 wb_dat_i18;

// TX_FIFO18 or UART_DL118
always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18)
	begin
		dl18[`UART_DL118]  <= #1 8'b0;
		tf_push18   <= #1 1'b0;
		start_dlc18 <= #1 1'b0;
	end
	else
	if (wb_we_i18 && wb_addr_i18==`UART_REG_TR18)
		if (dlab18)
		begin
			dl18[`UART_DL118] <= #1 wb_dat_i18;
			start_dlc18 <= #1 1'b1; // enable DL18 counter
			tf_push18 <= #1 1'b0;
		end
		else
		begin
			tf_push18   <= #1 1'b1;
			start_dlc18 <= #1 1'b0;
		end // else: !if(dlab18)
	else
	begin
		start_dlc18 <= #1 1'b0;
		tf_push18   <= #1 1'b0;
	end // else: !if(dlab18)

// Receiver18 FIFO trigger level selection logic (asynchronous18 mux18)
always @(fcr18)
	case (fcr18[`UART_FC_TL18])
		2'b00 : trigger_level18 = 1;
		2'b01 : trigger_level18 = 4;
		2'b10 : trigger_level18 = 8;
		2'b11 : trigger_level18 = 14;
	endcase // case(fcr18[`UART_FC_TL18])
	
//
//  STATUS18 REGISTERS18  //
//

// Modem18 Status Register
reg [3:0] delayed_modem_signals18;
always @(posedge clk18 or posedge wb_rst_i18)
begin
	if (wb_rst_i18)
	  begin
  		msr18 <= #1 0;
	  	delayed_modem_signals18[3:0] <= #1 0;
	  end
	else begin
		msr18[`UART_MS_DDCD18:`UART_MS_DCTS18] <= #1 msi_reset18 ? 4'b0 :
			msr18[`UART_MS_DDCD18:`UART_MS_DCTS18] | ({dcd18, ri, dsr18, cts18} ^ delayed_modem_signals18[3:0]);
		msr18[`UART_MS_CDCD18:`UART_MS_CCTS18] <= #1 {dcd_c18, ri_c18, dsr_c18, cts_c18};
		delayed_modem_signals18[3:0] <= #1 {dcd18, ri, dsr18, cts18};
	end
end


// Line18 Status Register

// activation18 conditions18
assign lsr018 = (rf_count18==0 && rf_push_pulse18);  // data in receiver18 fifo available set condition
assign lsr118 = rf_overrun18;     // Receiver18 overrun18 error
assign lsr218 = rf_data_out18[1]; // parity18 error bit
assign lsr318 = rf_data_out18[0]; // framing18 error bit
assign lsr418 = rf_data_out18[2]; // break error in the character18
assign lsr518 = (tf_count18==5'b0 && thre_set_en18);  // transmitter18 fifo is empty18
assign lsr618 = (tf_count18==5'b0 && thre_set_en18 && (tstate18 == /*`S_IDLE18 */ 0)); // transmitter18 empty18
assign lsr718 = rf_error_bit18 | rf_overrun18;

// lsr18 bit018 (receiver18 data available)
reg 	 lsr0_d18;

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr0_d18 <= #1 0;
	else lsr0_d18 <= #1 lsr018;

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr0r18 <= #1 0;
	else lsr0r18 <= #1 (rf_count18==1 && rf_pop18 && !rf_push_pulse18 || rx_reset18) ? 0 : // deassert18 condition
					  lsr0r18 || (lsr018 && ~lsr0_d18); // set on rise18 of lsr018 and keep18 asserted18 until deasserted18 

// lsr18 bit 1 (receiver18 overrun18)
reg lsr1_d18; // delayed18

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr1_d18 <= #1 0;
	else lsr1_d18 <= #1 lsr118;

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr1r18 <= #1 0;
	else	lsr1r18 <= #1	lsr_mask18 ? 0 : lsr1r18 || (lsr118 && ~lsr1_d18); // set on rise18

// lsr18 bit 2 (parity18 error)
reg lsr2_d18; // delayed18

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr2_d18 <= #1 0;
	else lsr2_d18 <= #1 lsr218;

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr2r18 <= #1 0;
	else lsr2r18 <= #1 lsr_mask18 ? 0 : lsr2r18 || (lsr218 && ~lsr2_d18); // set on rise18

// lsr18 bit 3 (framing18 error)
reg lsr3_d18; // delayed18

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr3_d18 <= #1 0;
	else lsr3_d18 <= #1 lsr318;

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr3r18 <= #1 0;
	else lsr3r18 <= #1 lsr_mask18 ? 0 : lsr3r18 || (lsr318 && ~lsr3_d18); // set on rise18

// lsr18 bit 4 (break indicator18)
reg lsr4_d18; // delayed18

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr4_d18 <= #1 0;
	else lsr4_d18 <= #1 lsr418;

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr4r18 <= #1 0;
	else lsr4r18 <= #1 lsr_mask18 ? 0 : lsr4r18 || (lsr418 && ~lsr4_d18);

// lsr18 bit 5 (transmitter18 fifo is empty18)
reg lsr5_d18;

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr5_d18 <= #1 1;
	else lsr5_d18 <= #1 lsr518;

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr5r18 <= #1 1;
	else lsr5r18 <= #1 (fifo_write18) ? 0 :  lsr5r18 || (lsr518 && ~lsr5_d18);

// lsr18 bit 6 (transmitter18 empty18 indicator18)
reg lsr6_d18;

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr6_d18 <= #1 1;
	else lsr6_d18 <= #1 lsr618;

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr6r18 <= #1 1;
	else lsr6r18 <= #1 (fifo_write18) ? 0 : lsr6r18 || (lsr618 && ~lsr6_d18);

// lsr18 bit 7 (error in fifo)
reg lsr7_d18;

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr7_d18 <= #1 0;
	else lsr7_d18 <= #1 lsr718;

always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) lsr7r18 <= #1 0;
	else lsr7r18 <= #1 lsr_mask18 ? 0 : lsr7r18 || (lsr718 && ~lsr7_d18);

// Frequency18 divider18
always @(posedge clk18 or posedge wb_rst_i18) 
begin
	if (wb_rst_i18)
		dlc18 <= #1 0;
	else
		if (start_dlc18 | ~ (|dlc18))
  			dlc18 <= #1 dl18 - 1;               // preset18 counter
		else
			dlc18 <= #1 dlc18 - 1;              // decrement counter
end

// Enable18 signal18 generation18 logic
always @(posedge clk18 or posedge wb_rst_i18)
begin
	if (wb_rst_i18)
		enable <= #1 1'b0;
	else
		if (|dl18 & ~(|dlc18))     // dl18>0 & dlc18==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying18 THRE18 status for one character18 cycle after a character18 is written18 to an empty18 fifo.
always @(lcr18)
  case (lcr18[3:0])
    4'b0000                             : block_value18 =  95; // 6 bits
    4'b0100                             : block_value18 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value18 = 111; // 7 bits
    4'b1100                             : block_value18 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value18 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value18 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value18 = 159; // 10 bits
    4'b1111                             : block_value18 = 175; // 11 bits
  endcase // case(lcr18[3:0])

// Counting18 time of one character18 minus18 stop bit
always @(posedge clk18 or posedge wb_rst_i18)
begin
  if (wb_rst_i18)
    block_cnt18 <= #1 8'd0;
  else
  if(lsr5r18 & fifo_write18)  // THRE18 bit set & write to fifo occured18
    block_cnt18 <= #1 block_value18;
  else
  if (enable & block_cnt18 != 8'b0)  // only work18 on enable times
    block_cnt18 <= #1 block_cnt18 - 1;  // decrement break counter
end // always of break condition detection18

// Generating18 THRE18 status enable signal18
assign thre_set_en18 = ~(|block_cnt18);


//
//	INTERRUPT18 LOGIC18
//

assign rls_int18  = ier18[`UART_IE_RLS18] && (lsr18[`UART_LS_OE18] || lsr18[`UART_LS_PE18] || lsr18[`UART_LS_FE18] || lsr18[`UART_LS_BI18]);
assign rda_int18  = ier18[`UART_IE_RDA18] && (rf_count18 >= {1'b0,trigger_level18});
assign thre_int18 = ier18[`UART_IE_THRE18] && lsr18[`UART_LS_TFE18];
assign ms_int18   = ier18[`UART_IE_MS18] && (| msr18[3:0]);
assign ti_int18   = ier18[`UART_IE_RDA18] && (counter_t18 == 10'b0) && (|rf_count18);

reg 	 rls_int_d18;
reg 	 thre_int_d18;
reg 	 ms_int_d18;
reg 	 ti_int_d18;
reg 	 rda_int_d18;

// delay lines18
always  @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) rls_int_d18 <= #1 0;
	else rls_int_d18 <= #1 rls_int18;

always  @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) rda_int_d18 <= #1 0;
	else rda_int_d18 <= #1 rda_int18;

always  @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) thre_int_d18 <= #1 0;
	else thre_int_d18 <= #1 thre_int18;

always  @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) ms_int_d18 <= #1 0;
	else ms_int_d18 <= #1 ms_int18;

always  @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) ti_int_d18 <= #1 0;
	else ti_int_d18 <= #1 ti_int18;

// rise18 detection18 signals18

wire 	 rls_int_rise18;
wire 	 thre_int_rise18;
wire 	 ms_int_rise18;
wire 	 ti_int_rise18;
wire 	 rda_int_rise18;

assign rda_int_rise18    = rda_int18 & ~rda_int_d18;
assign rls_int_rise18 	  = rls_int18 & ~rls_int_d18;
assign thre_int_rise18   = thre_int18 & ~thre_int_d18;
assign ms_int_rise18 	  = ms_int18 & ~ms_int_d18;
assign ti_int_rise18 	  = ti_int18 & ~ti_int_d18;

// interrupt18 pending flags18
reg 	rls_int_pnd18;
reg	rda_int_pnd18;
reg 	thre_int_pnd18;
reg 	ms_int_pnd18;
reg 	ti_int_pnd18;

// interrupt18 pending flags18 assignments18
always  @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) rls_int_pnd18 <= #1 0; 
	else 
		rls_int_pnd18 <= #1 lsr_mask18 ? 0 :  						// reset condition
							rls_int_rise18 ? 1 :						// latch18 condition
							rls_int_pnd18 && ier18[`UART_IE_RLS18];	// default operation18: remove if masked18

always  @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) rda_int_pnd18 <= #1 0; 
	else 
		rda_int_pnd18 <= #1 ((rf_count18 == {1'b0,trigger_level18}) && fifo_read18) ? 0 :  	// reset condition
							rda_int_rise18 ? 1 :						// latch18 condition
							rda_int_pnd18 && ier18[`UART_IE_RDA18];	// default operation18: remove if masked18

always  @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) thre_int_pnd18 <= #1 0; 
	else 
		thre_int_pnd18 <= #1 fifo_write18 || (iir_read18 & ~iir18[`UART_II_IP18] & iir18[`UART_II_II18] == `UART_II_THRE18)? 0 : 
							thre_int_rise18 ? 1 :
							thre_int_pnd18 && ier18[`UART_IE_THRE18];

always  @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) ms_int_pnd18 <= #1 0; 
	else 
		ms_int_pnd18 <= #1 msr_read18 ? 0 : 
							ms_int_rise18 ? 1 :
							ms_int_pnd18 && ier18[`UART_IE_MS18];

always  @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) ti_int_pnd18 <= #1 0; 
	else 
		ti_int_pnd18 <= #1 fifo_read18 ? 0 : 
							ti_int_rise18 ? 1 :
							ti_int_pnd18 && ier18[`UART_IE_RDA18];
// end of pending flags18

// INT_O18 logic
always @(posedge clk18 or posedge wb_rst_i18)
begin
	if (wb_rst_i18)	
		int_o18 <= #1 1'b0;
	else
		int_o18 <= #1 
					rls_int_pnd18		?	~lsr_mask18					:
					rda_int_pnd18		? 1								:
					ti_int_pnd18		? ~fifo_read18					:
					thre_int_pnd18	? !(fifo_write18 & iir_read18) :
					ms_int_pnd18		? ~msr_read18						:
					0;	// if no interrupt18 are pending
end


// Interrupt18 Identification18 register
always @(posedge clk18 or posedge wb_rst_i18)
begin
	if (wb_rst_i18)
		iir18 <= #1 1;
	else
	if (rls_int_pnd18)  // interrupt18 is pending
	begin
		iir18[`UART_II_II18] <= #1 `UART_II_RLS18;	// set identification18 register to correct18 value
		iir18[`UART_II_IP18] <= #1 1'b0;		// and clear the IIR18 bit 0 (interrupt18 pending)
	end else // the sequence of conditions18 determines18 priority of interrupt18 identification18
	if (rda_int18)
	begin
		iir18[`UART_II_II18] <= #1 `UART_II_RDA18;
		iir18[`UART_II_IP18] <= #1 1'b0;
	end
	else if (ti_int_pnd18)
	begin
		iir18[`UART_II_II18] <= #1 `UART_II_TI18;
		iir18[`UART_II_IP18] <= #1 1'b0;
	end
	else if (thre_int_pnd18)
	begin
		iir18[`UART_II_II18] <= #1 `UART_II_THRE18;
		iir18[`UART_II_IP18] <= #1 1'b0;
	end
	else if (ms_int_pnd18)
	begin
		iir18[`UART_II_II18] <= #1 `UART_II_MS18;
		iir18[`UART_II_IP18] <= #1 1'b0;
	end else	// no interrupt18 is pending
	begin
		iir18[`UART_II_II18] <= #1 0;
		iir18[`UART_II_IP18] <= #1 1'b1;
	end
end

endmodule
