//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs20.v                                                 ////
////                                                              ////
////                                                              ////
////  This20 file is part of the "UART20 16550 compatible20" project20    ////
////  http20://www20.opencores20.org20/cores20/uart1655020/                   ////
////                                                              ////
////  Documentation20 related20 to this project20:                      ////
////  - http20://www20.opencores20.org20/cores20/uart1655020/                 ////
////                                                              ////
////  Projects20 compatibility20:                                     ////
////  - WISHBONE20                                                  ////
////  RS23220 Protocol20                                              ////
////  16550D uart20 (mostly20 supported)                              ////
////                                                              ////
////  Overview20 (main20 Features20):                                   ////
////  Registers20 of the uart20 16550 core20                            ////
////                                                              ////
////  Known20 problems20 (limits20):                                    ////
////  Inserts20 1 wait state in all WISHBONE20 transfers20              ////
////                                                              ////
////  To20 Do20:                                                      ////
////  Nothing or verification20.                                    ////
////                                                              ////
////  Author20(s):                                                  ////
////      - gorban20@opencores20.org20                                  ////
////      - Jacob20 Gorban20                                          ////
////      - Igor20 Mohor20 (igorm20@opencores20.org20)                      ////
////                                                              ////
////  Created20:        2001/05/12                                  ////
////  Last20 Updated20:   (See log20 for the revision20 history20           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2000, 2001 Authors20                             ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS20 Revision20 History20
//
// $Log: not supported by cvs2svn20 $
// Revision20 1.41  2004/05/21 11:44:41  tadejm20
// Added20 synchronizer20 flops20 for RX20 input.
//
// Revision20 1.40  2003/06/11 16:37:47  gorban20
// This20 fixes20 errors20 in some20 cases20 when data is being read and put to the FIFO at the same time. Patch20 is submitted20 by Scott20 Furman20. Update is very20 recommended20.
//
// Revision20 1.39  2002/07/29 21:16:18  gorban20
// The uart_defines20.v file is included20 again20 in sources20.
//
// Revision20 1.38  2002/07/22 23:02:23  gorban20
// Bug20 Fixes20:
//  * Possible20 loss of sync and bad20 reception20 of stop bit on slow20 baud20 rates20 fixed20.
//   Problem20 reported20 by Kenny20.Tung20.
//  * Bad (or lack20 of ) loopback20 handling20 fixed20. Reported20 by Cherry20 Withers20.
//
// Improvements20:
//  * Made20 FIFO's as general20 inferrable20 memory where possible20.
//  So20 on FPGA20 they should be inferred20 as RAM20 (Distributed20 RAM20 on Xilinx20).
//  This20 saves20 about20 1/3 of the Slice20 count and reduces20 P&R and synthesis20 times.
//
//  * Added20 optional20 baudrate20 output (baud_o20).
//  This20 is identical20 to BAUDOUT20* signal20 on 16550 chip20.
//  It outputs20 16xbit_clock_rate - the divided20 clock20.
//  It's disabled by default. Define20 UART_HAS_BAUDRATE_OUTPUT20 to use.
//
// Revision20 1.37  2001/12/27 13:24:09  mohor20
// lsr20[7] was not showing20 overrun20 errors20.
//
// Revision20 1.36  2001/12/20 13:25:46  mohor20
// rx20 push20 changed to be only one cycle wide20.
//
// Revision20 1.35  2001/12/19 08:03:34  mohor20
// Warnings20 cleared20.
//
// Revision20 1.34  2001/12/19 07:33:54  mohor20
// Synplicity20 was having20 troubles20 with the comment20.
//
// Revision20 1.33  2001/12/17 10:14:43  mohor20
// Things20 related20 to msr20 register changed. After20 THRE20 IRQ20 occurs20, and one
// character20 is written20 to the transmit20 fifo, the detection20 of the THRE20 bit in the
// LSR20 is delayed20 for one character20 time.
//
// Revision20 1.32  2001/12/14 13:19:24  mohor20
// MSR20 register fixed20.
//
// Revision20 1.31  2001/12/14 10:06:58  mohor20
// After20 reset modem20 status register MSR20 should be reset.
//
// Revision20 1.30  2001/12/13 10:09:13  mohor20
// thre20 irq20 should be cleared20 only when being source20 of interrupt20.
//
// Revision20 1.29  2001/12/12 09:05:46  mohor20
// LSR20 status bit 0 was not cleared20 correctly in case of reseting20 the FCR20 (rx20 fifo).
//
// Revision20 1.28  2001/12/10 19:52:41  gorban20
// Scratch20 register added
//
// Revision20 1.27  2001/12/06 14:51:04  gorban20
// Bug20 in LSR20[0] is fixed20.
// All WISHBONE20 signals20 are now sampled20, so another20 wait-state is introduced20 on all transfers20.
//
// Revision20 1.26  2001/12/03 21:44:29  gorban20
// Updated20 specification20 documentation.
// Added20 full 32-bit data bus interface, now as default.
// Address is 5-bit wide20 in 32-bit data bus mode.
// Added20 wb_sel_i20 input to the core20. It's used in the 32-bit mode.
// Added20 debug20 interface with two20 32-bit read-only registers in 32-bit mode.
// Bits20 5 and 6 of LSR20 are now only cleared20 on TX20 FIFO write.
// My20 small test bench20 is modified to work20 with 32-bit mode.
//
// Revision20 1.25  2001/11/28 19:36:39  gorban20
// Fixed20: timeout and break didn20't pay20 attention20 to current data format20 when counting20 time
//
// Revision20 1.24  2001/11/26 21:38:54  gorban20
// Lots20 of fixes20:
// Break20 condition wasn20't handled20 correctly at all.
// LSR20 bits could lose20 their20 values.
// LSR20 value after reset was wrong20.
// Timing20 of THRE20 interrupt20 signal20 corrected20.
// LSR20 bit 0 timing20 corrected20.
//
// Revision20 1.23  2001/11/12 21:57:29  gorban20
// fixed20 more typo20 bugs20
//
// Revision20 1.22  2001/11/12 15:02:28  mohor20
// lsr1r20 error fixed20.
//
// Revision20 1.21  2001/11/12 14:57:27  mohor20
// ti_int_pnd20 error fixed20.
//
// Revision20 1.20  2001/11/12 14:50:27  mohor20
// ti_int_d20 error fixed20.
//
// Revision20 1.19  2001/11/10 12:43:21  gorban20
// Logic20 Synthesis20 bugs20 fixed20. Some20 other minor20 changes20
//
// Revision20 1.18  2001/11/08 14:54:23  mohor20
// Comments20 in Slovene20 language20 deleted20, few20 small fixes20 for better20 work20 of
// old20 tools20. IRQs20 need to be fix20.
//
// Revision20 1.17  2001/11/07 17:51:52  gorban20
// Heavily20 rewritten20 interrupt20 and LSR20 subsystems20.
// Many20 bugs20 hopefully20 squashed20.
//
// Revision20 1.16  2001/11/02 09:55:16  mohor20
// no message
//
// Revision20 1.15  2001/10/31 15:19:22  gorban20
// Fixes20 to break and timeout conditions20
//
// Revision20 1.14  2001/10/29 17:00:46  gorban20
// fixed20 parity20 sending20 and tx_fifo20 resets20 over- and underrun20
//
// Revision20 1.13  2001/10/20 09:58:40  gorban20
// Small20 synopsis20 fixes20
//
// Revision20 1.12  2001/10/19 16:21:40  gorban20
// Changes20 data_out20 to be synchronous20 again20 as it should have been.
//
// Revision20 1.11  2001/10/18 20:35:45  gorban20
// small fix20
//
// Revision20 1.10  2001/08/24 21:01:12  mohor20
// Things20 connected20 to parity20 changed.
// Clock20 devider20 changed.
//
// Revision20 1.9  2001/08/23 16:05:05  mohor20
// Stop bit bug20 fixed20.
// Parity20 bug20 fixed20.
// WISHBONE20 read cycle bug20 fixed20,
// OE20 indicator20 (Overrun20 Error) bug20 fixed20.
// PE20 indicator20 (Parity20 Error) bug20 fixed20.
// Register read bug20 fixed20.
//
// Revision20 1.10  2001/06/23 11:21:48  gorban20
// DL20 made20 16-bit long20. Fixed20 transmission20/reception20 bugs20.
//
// Revision20 1.9  2001/05/31 20:08:01  gorban20
// FIFO changes20 and other corrections20.
//
// Revision20 1.8  2001/05/29 20:05:04  gorban20
// Fixed20 some20 bugs20 and synthesis20 problems20.
//
// Revision20 1.7  2001/05/27 17:37:49  gorban20
// Fixed20 many20 bugs20. Updated20 spec20. Changed20 FIFO files structure20. See CHANGES20.txt20 file.
//
// Revision20 1.6  2001/05/21 19:12:02  gorban20
// Corrected20 some20 Linter20 messages20.
//
// Revision20 1.5  2001/05/17 18:34:18  gorban20
// First20 'stable' release. Should20 be sythesizable20 now. Also20 added new header.
//
// Revision20 1.0  2001-05-17 21:27:11+02  jacob20
// Initial20 revision20
//
//

// synopsys20 translate_off20
`include "timescale.v"
// synopsys20 translate_on20

`include "uart_defines20.v"

`define UART_DL120 7:0
`define UART_DL220 15:8

module uart_regs20 (clk20,
	wb_rst_i20, wb_addr_i20, wb_dat_i20, wb_dat_o20, wb_we_i20, wb_re_i20, 

// additional20 signals20
	modem_inputs20,
	stx_pad_o20, srx_pad_i20,

`ifdef DATA_BUS_WIDTH_820
`else
// debug20 interface signals20	enabled
ier20, iir20, fcr20, mcr20, lcr20, msr20, lsr20, rf_count20, tf_count20, tstate20, rstate,
`endif				
	rts_pad_o20, dtr_pad_o20, int_o20
`ifdef UART_HAS_BAUDRATE_OUTPUT20
	, baud_o20
`endif

	);

input 									clk20;
input 									wb_rst_i20;
input [`UART_ADDR_WIDTH20-1:0] 		wb_addr_i20;
input [7:0] 							wb_dat_i20;
output [7:0] 							wb_dat_o20;
input 									wb_we_i20;
input 									wb_re_i20;

output 									stx_pad_o20;
input 									srx_pad_i20;

input [3:0] 							modem_inputs20;
output 									rts_pad_o20;
output 									dtr_pad_o20;
output 									int_o20;
`ifdef UART_HAS_BAUDRATE_OUTPUT20
output	baud_o20;
`endif

`ifdef DATA_BUS_WIDTH_820
`else
// if 32-bit databus20 and debug20 interface are enabled
output [3:0]							ier20;
output [3:0]							iir20;
output [1:0]							fcr20;  /// bits 7 and 6 of fcr20. Other20 bits are ignored
output [4:0]							mcr20;
output [7:0]							lcr20;
output [7:0]							msr20;
output [7:0] 							lsr20;
output [`UART_FIFO_COUNTER_W20-1:0] 	rf_count20;
output [`UART_FIFO_COUNTER_W20-1:0] 	tf_count20;
output [2:0] 							tstate20;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs20;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT20
assign baud_o20 = enable; // baud_o20 is actually20 the enable signal20
`endif


wire 										stx_pad_o20;		// received20 from transmitter20 module
wire 										srx_pad_i20;
wire 										srx_pad20;

reg [7:0] 								wb_dat_o20;

wire [`UART_ADDR_WIDTH20-1:0] 		wb_addr_i20;
wire [7:0] 								wb_dat_i20;


reg [3:0] 								ier20;
reg [3:0] 								iir20;
reg [1:0] 								fcr20;  /// bits 7 and 6 of fcr20. Other20 bits are ignored
reg [4:0] 								mcr20;
reg [7:0] 								lcr20;
reg [7:0] 								msr20;
reg [15:0] 								dl20;  // 32-bit divisor20 latch20
reg [7:0] 								scratch20; // UART20 scratch20 register
reg 										start_dlc20; // activate20 dlc20 on writing to UART_DL120
reg 										lsr_mask_d20; // delay for lsr_mask20 condition
reg 										msi_reset20; // reset MSR20 4 lower20 bits indicator20
//reg 										threi_clear20; // THRE20 interrupt20 clear flag20
reg [15:0] 								dlc20;  // 32-bit divisor20 latch20 counter
reg 										int_o20;

reg [3:0] 								trigger_level20; // trigger level of the receiver20 FIFO
reg 										rx_reset20;
reg 										tx_reset20;

wire 										dlab20;			   // divisor20 latch20 access bit
wire 										cts_pad_i20, dsr_pad_i20, ri_pad_i20, dcd_pad_i20; // modem20 status bits
wire 										loopback20;		   // loopback20 bit (MCR20 bit 4)
wire 										cts20, dsr20, ri, dcd20;	   // effective20 signals20
wire                    cts_c20, dsr_c20, ri_c20, dcd_c20; // Complement20 effective20 signals20 (considering20 loopback20)
wire 										rts_pad_o20, dtr_pad_o20;		   // modem20 control20 outputs20

// LSR20 bits wires20 and regs
wire [7:0] 								lsr20;
wire 										lsr020, lsr120, lsr220, lsr320, lsr420, lsr520, lsr620, lsr720;
reg										lsr0r20, lsr1r20, lsr2r20, lsr3r20, lsr4r20, lsr5r20, lsr6r20, lsr7r20;
wire 										lsr_mask20; // lsr_mask20

//
// ASSINGS20
//

assign 									lsr20[7:0] = { lsr7r20, lsr6r20, lsr5r20, lsr4r20, lsr3r20, lsr2r20, lsr1r20, lsr0r20 };

assign 									{cts_pad_i20, dsr_pad_i20, ri_pad_i20, dcd_pad_i20} = modem_inputs20;
assign 									{cts20, dsr20, ri, dcd20} = ~{cts_pad_i20,dsr_pad_i20,ri_pad_i20,dcd_pad_i20};

assign                  {cts_c20, dsr_c20, ri_c20, dcd_c20} = loopback20 ? {mcr20[`UART_MC_RTS20],mcr20[`UART_MC_DTR20],mcr20[`UART_MC_OUT120],mcr20[`UART_MC_OUT220]}
                                                               : {cts_pad_i20,dsr_pad_i20,ri_pad_i20,dcd_pad_i20};

assign 									dlab20 = lcr20[`UART_LC_DL20];
assign 									loopback20 = mcr20[4];

// assign modem20 outputs20
assign 									rts_pad_o20 = mcr20[`UART_MC_RTS20];
assign 									dtr_pad_o20 = mcr20[`UART_MC_DTR20];

// Interrupt20 signals20
wire 										rls_int20;  // receiver20 line status interrupt20
wire 										rda_int20;  // receiver20 data available interrupt20
wire 										ti_int20;   // timeout indicator20 interrupt20
wire										thre_int20; // transmitter20 holding20 register empty20 interrupt20
wire 										ms_int20;   // modem20 status interrupt20

// FIFO signals20
reg 										tf_push20;
reg 										rf_pop20;
wire [`UART_FIFO_REC_WIDTH20-1:0] 	rf_data_out20;
wire 										rf_error_bit20; // an error (parity20 or framing20) is inside the fifo
wire [`UART_FIFO_COUNTER_W20-1:0] 	rf_count20;
wire [`UART_FIFO_COUNTER_W20-1:0] 	tf_count20;
wire [2:0] 								tstate20;
wire [3:0] 								rstate;
wire [9:0] 								counter_t20;

wire                      thre_set_en20; // THRE20 status is delayed20 one character20 time when a character20 is written20 to fifo.
reg  [7:0]                block_cnt20;   // While20 counter counts20, THRE20 status is blocked20 (delayed20 one character20 cycle)
reg  [7:0]                block_value20; // One20 character20 length minus20 stop bit

// Transmitter20 Instance
wire serial_out20;

uart_transmitter20 transmitter20(clk20, wb_rst_i20, lcr20, tf_push20, wb_dat_i20, enable, serial_out20, tstate20, tf_count20, tx_reset20, lsr_mask20);

  // Synchronizing20 and sampling20 serial20 RX20 input
  uart_sync_flops20    i_uart_sync_flops20
  (
    .rst_i20           (wb_rst_i20),
    .clk_i20           (clk20),
    .stage1_rst_i20    (1'b0),
    .stage1_clk_en_i20 (1'b1),
    .async_dat_i20     (srx_pad_i20),
    .sync_dat_o20      (srx_pad20)
  );
  defparam i_uart_sync_flops20.width      = 1;
  defparam i_uart_sync_flops20.init_value20 = 1'b1;

// handle loopback20
wire serial_in20 = loopback20 ? serial_out20 : srx_pad20;
assign stx_pad_o20 = loopback20 ? 1'b1 : serial_out20;

// Receiver20 Instance
uart_receiver20 receiver20(clk20, wb_rst_i20, lcr20, rf_pop20, serial_in20, enable, 
	counter_t20, rf_count20, rf_data_out20, rf_error_bit20, rf_overrun20, rx_reset20, lsr_mask20, rstate, rf_push_pulse20);


// Asynchronous20 reading here20 because the outputs20 are sampled20 in uart_wb20.v file 
always @(dl20 or dlab20 or ier20 or iir20 or scratch20
			or lcr20 or lsr20 or msr20 or rf_data_out20 or wb_addr_i20 or wb_re_i20)   // asynchrounous20 reading
begin
	case (wb_addr_i20)
		`UART_REG_RB20   : wb_dat_o20 = dlab20 ? dl20[`UART_DL120] : rf_data_out20[10:3];
		`UART_REG_IE20	: wb_dat_o20 = dlab20 ? dl20[`UART_DL220] : ier20;
		`UART_REG_II20	: wb_dat_o20 = {4'b1100,iir20};
		`UART_REG_LC20	: wb_dat_o20 = lcr20;
		`UART_REG_LS20	: wb_dat_o20 = lsr20;
		`UART_REG_MS20	: wb_dat_o20 = msr20;
		`UART_REG_SR20	: wb_dat_o20 = scratch20;
		default:  wb_dat_o20 = 8'b0; // ??
	endcase // case(wb_addr_i20)
end // always @ (dl20 or dlab20 or ier20 or iir20 or scratch20...


// rf_pop20 signal20 handling20
always @(posedge clk20 or posedge wb_rst_i20)
begin
	if (wb_rst_i20)
		rf_pop20 <= #1 0; 
	else
	if (rf_pop20)	// restore20 the signal20 to 0 after one clock20 cycle
		rf_pop20 <= #1 0;
	else
	if (wb_re_i20 && wb_addr_i20 == `UART_REG_RB20 && !dlab20)
		rf_pop20 <= #1 1; // advance20 read pointer20
end

wire 	lsr_mask_condition20;
wire 	iir_read20;
wire  msr_read20;
wire	fifo_read20;
wire	fifo_write20;

assign lsr_mask_condition20 = (wb_re_i20 && wb_addr_i20 == `UART_REG_LS20 && !dlab20);
assign iir_read20 = (wb_re_i20 && wb_addr_i20 == `UART_REG_II20 && !dlab20);
assign msr_read20 = (wb_re_i20 && wb_addr_i20 == `UART_REG_MS20 && !dlab20);
assign fifo_read20 = (wb_re_i20 && wb_addr_i20 == `UART_REG_RB20 && !dlab20);
assign fifo_write20 = (wb_we_i20 && wb_addr_i20 == `UART_REG_TR20 && !dlab20);

// lsr_mask_d20 delayed20 signal20 handling20
always @(posedge clk20 or posedge wb_rst_i20)
begin
	if (wb_rst_i20)
		lsr_mask_d20 <= #1 0;
	else // reset bits in the Line20 Status Register
		lsr_mask_d20 <= #1 lsr_mask_condition20;
end

// lsr_mask20 is rise20 detected
assign lsr_mask20 = lsr_mask_condition20 && ~lsr_mask_d20;

// msi_reset20 signal20 handling20
always @(posedge clk20 or posedge wb_rst_i20)
begin
	if (wb_rst_i20)
		msi_reset20 <= #1 1;
	else
	if (msi_reset20)
		msi_reset20 <= #1 0;
	else
	if (msr_read20)
		msi_reset20 <= #1 1; // reset bits in Modem20 Status Register
end


//
//   WRITES20 AND20 RESETS20   //
//
// Line20 Control20 Register
always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20)
		lcr20 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i20 && wb_addr_i20==`UART_REG_LC20)
		lcr20 <= #1 wb_dat_i20;

// Interrupt20 Enable20 Register or UART_DL220
always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20)
	begin
		ier20 <= #1 4'b0000; // no interrupts20 after reset
		dl20[`UART_DL220] <= #1 8'b0;
	end
	else
	if (wb_we_i20 && wb_addr_i20==`UART_REG_IE20)
		if (dlab20)
		begin
			dl20[`UART_DL220] <= #1 wb_dat_i20;
		end
		else
			ier20 <= #1 wb_dat_i20[3:0]; // ier20 uses only 4 lsb


// FIFO Control20 Register and rx_reset20, tx_reset20 signals20
always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) begin
		fcr20 <= #1 2'b11; 
		rx_reset20 <= #1 0;
		tx_reset20 <= #1 0;
	end else
	if (wb_we_i20 && wb_addr_i20==`UART_REG_FC20) begin
		fcr20 <= #1 wb_dat_i20[7:6];
		rx_reset20 <= #1 wb_dat_i20[1];
		tx_reset20 <= #1 wb_dat_i20[2];
	end else begin
		rx_reset20 <= #1 0;
		tx_reset20 <= #1 0;
	end

// Modem20 Control20 Register
always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20)
		mcr20 <= #1 5'b0; 
	else
	if (wb_we_i20 && wb_addr_i20==`UART_REG_MC20)
			mcr20 <= #1 wb_dat_i20[4:0];

// Scratch20 register
// Line20 Control20 Register
always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20)
		scratch20 <= #1 0; // 8n1 setting
	else
	if (wb_we_i20 && wb_addr_i20==`UART_REG_SR20)
		scratch20 <= #1 wb_dat_i20;

// TX_FIFO20 or UART_DL120
always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20)
	begin
		dl20[`UART_DL120]  <= #1 8'b0;
		tf_push20   <= #1 1'b0;
		start_dlc20 <= #1 1'b0;
	end
	else
	if (wb_we_i20 && wb_addr_i20==`UART_REG_TR20)
		if (dlab20)
		begin
			dl20[`UART_DL120] <= #1 wb_dat_i20;
			start_dlc20 <= #1 1'b1; // enable DL20 counter
			tf_push20 <= #1 1'b0;
		end
		else
		begin
			tf_push20   <= #1 1'b1;
			start_dlc20 <= #1 1'b0;
		end // else: !if(dlab20)
	else
	begin
		start_dlc20 <= #1 1'b0;
		tf_push20   <= #1 1'b0;
	end // else: !if(dlab20)

// Receiver20 FIFO trigger level selection logic (asynchronous20 mux20)
always @(fcr20)
	case (fcr20[`UART_FC_TL20])
		2'b00 : trigger_level20 = 1;
		2'b01 : trigger_level20 = 4;
		2'b10 : trigger_level20 = 8;
		2'b11 : trigger_level20 = 14;
	endcase // case(fcr20[`UART_FC_TL20])
	
//
//  STATUS20 REGISTERS20  //
//

// Modem20 Status Register
reg [3:0] delayed_modem_signals20;
always @(posedge clk20 or posedge wb_rst_i20)
begin
	if (wb_rst_i20)
	  begin
  		msr20 <= #1 0;
	  	delayed_modem_signals20[3:0] <= #1 0;
	  end
	else begin
		msr20[`UART_MS_DDCD20:`UART_MS_DCTS20] <= #1 msi_reset20 ? 4'b0 :
			msr20[`UART_MS_DDCD20:`UART_MS_DCTS20] | ({dcd20, ri, dsr20, cts20} ^ delayed_modem_signals20[3:0]);
		msr20[`UART_MS_CDCD20:`UART_MS_CCTS20] <= #1 {dcd_c20, ri_c20, dsr_c20, cts_c20};
		delayed_modem_signals20[3:0] <= #1 {dcd20, ri, dsr20, cts20};
	end
end


// Line20 Status Register

// activation20 conditions20
assign lsr020 = (rf_count20==0 && rf_push_pulse20);  // data in receiver20 fifo available set condition
assign lsr120 = rf_overrun20;     // Receiver20 overrun20 error
assign lsr220 = rf_data_out20[1]; // parity20 error bit
assign lsr320 = rf_data_out20[0]; // framing20 error bit
assign lsr420 = rf_data_out20[2]; // break error in the character20
assign lsr520 = (tf_count20==5'b0 && thre_set_en20);  // transmitter20 fifo is empty20
assign lsr620 = (tf_count20==5'b0 && thre_set_en20 && (tstate20 == /*`S_IDLE20 */ 0)); // transmitter20 empty20
assign lsr720 = rf_error_bit20 | rf_overrun20;

// lsr20 bit020 (receiver20 data available)
reg 	 lsr0_d20;

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr0_d20 <= #1 0;
	else lsr0_d20 <= #1 lsr020;

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr0r20 <= #1 0;
	else lsr0r20 <= #1 (rf_count20==1 && rf_pop20 && !rf_push_pulse20 || rx_reset20) ? 0 : // deassert20 condition
					  lsr0r20 || (lsr020 && ~lsr0_d20); // set on rise20 of lsr020 and keep20 asserted20 until deasserted20 

// lsr20 bit 1 (receiver20 overrun20)
reg lsr1_d20; // delayed20

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr1_d20 <= #1 0;
	else lsr1_d20 <= #1 lsr120;

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr1r20 <= #1 0;
	else	lsr1r20 <= #1	lsr_mask20 ? 0 : lsr1r20 || (lsr120 && ~lsr1_d20); // set on rise20

// lsr20 bit 2 (parity20 error)
reg lsr2_d20; // delayed20

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr2_d20 <= #1 0;
	else lsr2_d20 <= #1 lsr220;

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr2r20 <= #1 0;
	else lsr2r20 <= #1 lsr_mask20 ? 0 : lsr2r20 || (lsr220 && ~lsr2_d20); // set on rise20

// lsr20 bit 3 (framing20 error)
reg lsr3_d20; // delayed20

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr3_d20 <= #1 0;
	else lsr3_d20 <= #1 lsr320;

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr3r20 <= #1 0;
	else lsr3r20 <= #1 lsr_mask20 ? 0 : lsr3r20 || (lsr320 && ~lsr3_d20); // set on rise20

// lsr20 bit 4 (break indicator20)
reg lsr4_d20; // delayed20

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr4_d20 <= #1 0;
	else lsr4_d20 <= #1 lsr420;

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr4r20 <= #1 0;
	else lsr4r20 <= #1 lsr_mask20 ? 0 : lsr4r20 || (lsr420 && ~lsr4_d20);

// lsr20 bit 5 (transmitter20 fifo is empty20)
reg lsr5_d20;

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr5_d20 <= #1 1;
	else lsr5_d20 <= #1 lsr520;

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr5r20 <= #1 1;
	else lsr5r20 <= #1 (fifo_write20) ? 0 :  lsr5r20 || (lsr520 && ~lsr5_d20);

// lsr20 bit 6 (transmitter20 empty20 indicator20)
reg lsr6_d20;

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr6_d20 <= #1 1;
	else lsr6_d20 <= #1 lsr620;

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr6r20 <= #1 1;
	else lsr6r20 <= #1 (fifo_write20) ? 0 : lsr6r20 || (lsr620 && ~lsr6_d20);

// lsr20 bit 7 (error in fifo)
reg lsr7_d20;

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr7_d20 <= #1 0;
	else lsr7_d20 <= #1 lsr720;

always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) lsr7r20 <= #1 0;
	else lsr7r20 <= #1 lsr_mask20 ? 0 : lsr7r20 || (lsr720 && ~lsr7_d20);

// Frequency20 divider20
always @(posedge clk20 or posedge wb_rst_i20) 
begin
	if (wb_rst_i20)
		dlc20 <= #1 0;
	else
		if (start_dlc20 | ~ (|dlc20))
  			dlc20 <= #1 dl20 - 1;               // preset20 counter
		else
			dlc20 <= #1 dlc20 - 1;              // decrement counter
end

// Enable20 signal20 generation20 logic
always @(posedge clk20 or posedge wb_rst_i20)
begin
	if (wb_rst_i20)
		enable <= #1 1'b0;
	else
		if (|dl20 & ~(|dlc20))     // dl20>0 & dlc20==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying20 THRE20 status for one character20 cycle after a character20 is written20 to an empty20 fifo.
always @(lcr20)
  case (lcr20[3:0])
    4'b0000                             : block_value20 =  95; // 6 bits
    4'b0100                             : block_value20 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value20 = 111; // 7 bits
    4'b1100                             : block_value20 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value20 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value20 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value20 = 159; // 10 bits
    4'b1111                             : block_value20 = 175; // 11 bits
  endcase // case(lcr20[3:0])

// Counting20 time of one character20 minus20 stop bit
always @(posedge clk20 or posedge wb_rst_i20)
begin
  if (wb_rst_i20)
    block_cnt20 <= #1 8'd0;
  else
  if(lsr5r20 & fifo_write20)  // THRE20 bit set & write to fifo occured20
    block_cnt20 <= #1 block_value20;
  else
  if (enable & block_cnt20 != 8'b0)  // only work20 on enable times
    block_cnt20 <= #1 block_cnt20 - 1;  // decrement break counter
end // always of break condition detection20

// Generating20 THRE20 status enable signal20
assign thre_set_en20 = ~(|block_cnt20);


//
//	INTERRUPT20 LOGIC20
//

assign rls_int20  = ier20[`UART_IE_RLS20] && (lsr20[`UART_LS_OE20] || lsr20[`UART_LS_PE20] || lsr20[`UART_LS_FE20] || lsr20[`UART_LS_BI20]);
assign rda_int20  = ier20[`UART_IE_RDA20] && (rf_count20 >= {1'b0,trigger_level20});
assign thre_int20 = ier20[`UART_IE_THRE20] && lsr20[`UART_LS_TFE20];
assign ms_int20   = ier20[`UART_IE_MS20] && (| msr20[3:0]);
assign ti_int20   = ier20[`UART_IE_RDA20] && (counter_t20 == 10'b0) && (|rf_count20);

reg 	 rls_int_d20;
reg 	 thre_int_d20;
reg 	 ms_int_d20;
reg 	 ti_int_d20;
reg 	 rda_int_d20;

// delay lines20
always  @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) rls_int_d20 <= #1 0;
	else rls_int_d20 <= #1 rls_int20;

always  @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) rda_int_d20 <= #1 0;
	else rda_int_d20 <= #1 rda_int20;

always  @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) thre_int_d20 <= #1 0;
	else thre_int_d20 <= #1 thre_int20;

always  @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) ms_int_d20 <= #1 0;
	else ms_int_d20 <= #1 ms_int20;

always  @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) ti_int_d20 <= #1 0;
	else ti_int_d20 <= #1 ti_int20;

// rise20 detection20 signals20

wire 	 rls_int_rise20;
wire 	 thre_int_rise20;
wire 	 ms_int_rise20;
wire 	 ti_int_rise20;
wire 	 rda_int_rise20;

assign rda_int_rise20    = rda_int20 & ~rda_int_d20;
assign rls_int_rise20 	  = rls_int20 & ~rls_int_d20;
assign thre_int_rise20   = thre_int20 & ~thre_int_d20;
assign ms_int_rise20 	  = ms_int20 & ~ms_int_d20;
assign ti_int_rise20 	  = ti_int20 & ~ti_int_d20;

// interrupt20 pending flags20
reg 	rls_int_pnd20;
reg	rda_int_pnd20;
reg 	thre_int_pnd20;
reg 	ms_int_pnd20;
reg 	ti_int_pnd20;

// interrupt20 pending flags20 assignments20
always  @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) rls_int_pnd20 <= #1 0; 
	else 
		rls_int_pnd20 <= #1 lsr_mask20 ? 0 :  						// reset condition
							rls_int_rise20 ? 1 :						// latch20 condition
							rls_int_pnd20 && ier20[`UART_IE_RLS20];	// default operation20: remove if masked20

always  @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) rda_int_pnd20 <= #1 0; 
	else 
		rda_int_pnd20 <= #1 ((rf_count20 == {1'b0,trigger_level20}) && fifo_read20) ? 0 :  	// reset condition
							rda_int_rise20 ? 1 :						// latch20 condition
							rda_int_pnd20 && ier20[`UART_IE_RDA20];	// default operation20: remove if masked20

always  @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) thre_int_pnd20 <= #1 0; 
	else 
		thre_int_pnd20 <= #1 fifo_write20 || (iir_read20 & ~iir20[`UART_II_IP20] & iir20[`UART_II_II20] == `UART_II_THRE20)? 0 : 
							thre_int_rise20 ? 1 :
							thre_int_pnd20 && ier20[`UART_IE_THRE20];

always  @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) ms_int_pnd20 <= #1 0; 
	else 
		ms_int_pnd20 <= #1 msr_read20 ? 0 : 
							ms_int_rise20 ? 1 :
							ms_int_pnd20 && ier20[`UART_IE_MS20];

always  @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) ti_int_pnd20 <= #1 0; 
	else 
		ti_int_pnd20 <= #1 fifo_read20 ? 0 : 
							ti_int_rise20 ? 1 :
							ti_int_pnd20 && ier20[`UART_IE_RDA20];
// end of pending flags20

// INT_O20 logic
always @(posedge clk20 or posedge wb_rst_i20)
begin
	if (wb_rst_i20)	
		int_o20 <= #1 1'b0;
	else
		int_o20 <= #1 
					rls_int_pnd20		?	~lsr_mask20					:
					rda_int_pnd20		? 1								:
					ti_int_pnd20		? ~fifo_read20					:
					thre_int_pnd20	? !(fifo_write20 & iir_read20) :
					ms_int_pnd20		? ~msr_read20						:
					0;	// if no interrupt20 are pending
end


// Interrupt20 Identification20 register
always @(posedge clk20 or posedge wb_rst_i20)
begin
	if (wb_rst_i20)
		iir20 <= #1 1;
	else
	if (rls_int_pnd20)  // interrupt20 is pending
	begin
		iir20[`UART_II_II20] <= #1 `UART_II_RLS20;	// set identification20 register to correct20 value
		iir20[`UART_II_IP20] <= #1 1'b0;		// and clear the IIR20 bit 0 (interrupt20 pending)
	end else // the sequence of conditions20 determines20 priority of interrupt20 identification20
	if (rda_int20)
	begin
		iir20[`UART_II_II20] <= #1 `UART_II_RDA20;
		iir20[`UART_II_IP20] <= #1 1'b0;
	end
	else if (ti_int_pnd20)
	begin
		iir20[`UART_II_II20] <= #1 `UART_II_TI20;
		iir20[`UART_II_IP20] <= #1 1'b0;
	end
	else if (thre_int_pnd20)
	begin
		iir20[`UART_II_II20] <= #1 `UART_II_THRE20;
		iir20[`UART_II_IP20] <= #1 1'b0;
	end
	else if (ms_int_pnd20)
	begin
		iir20[`UART_II_II20] <= #1 `UART_II_MS20;
		iir20[`UART_II_IP20] <= #1 1'b0;
	end else	// no interrupt20 is pending
	begin
		iir20[`UART_II_II20] <= #1 0;
		iir20[`UART_II_IP20] <= #1 1'b1;
	end
end

endmodule
