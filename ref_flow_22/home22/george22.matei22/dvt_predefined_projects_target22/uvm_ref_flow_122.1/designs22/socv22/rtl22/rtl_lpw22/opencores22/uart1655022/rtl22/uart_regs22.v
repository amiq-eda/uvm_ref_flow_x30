//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs22.v                                                 ////
////                                                              ////
////                                                              ////
////  This22 file is part of the "UART22 16550 compatible22" project22    ////
////  http22://www22.opencores22.org22/cores22/uart1655022/                   ////
////                                                              ////
////  Documentation22 related22 to this project22:                      ////
////  - http22://www22.opencores22.org22/cores22/uart1655022/                 ////
////                                                              ////
////  Projects22 compatibility22:                                     ////
////  - WISHBONE22                                                  ////
////  RS23222 Protocol22                                              ////
////  16550D uart22 (mostly22 supported)                              ////
////                                                              ////
////  Overview22 (main22 Features22):                                   ////
////  Registers22 of the uart22 16550 core22                            ////
////                                                              ////
////  Known22 problems22 (limits22):                                    ////
////  Inserts22 1 wait state in all WISHBONE22 transfers22              ////
////                                                              ////
////  To22 Do22:                                                      ////
////  Nothing or verification22.                                    ////
////                                                              ////
////  Author22(s):                                                  ////
////      - gorban22@opencores22.org22                                  ////
////      - Jacob22 Gorban22                                          ////
////      - Igor22 Mohor22 (igorm22@opencores22.org22)                      ////
////                                                              ////
////  Created22:        2001/05/12                                  ////
////  Last22 Updated22:   (See log22 for the revision22 history22           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2000, 2001 Authors22                             ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS22 Revision22 History22
//
// $Log: not supported by cvs2svn22 $
// Revision22 1.41  2004/05/21 11:44:41  tadejm22
// Added22 synchronizer22 flops22 for RX22 input.
//
// Revision22 1.40  2003/06/11 16:37:47  gorban22
// This22 fixes22 errors22 in some22 cases22 when data is being read and put to the FIFO at the same time. Patch22 is submitted22 by Scott22 Furman22. Update is very22 recommended22.
//
// Revision22 1.39  2002/07/29 21:16:18  gorban22
// The uart_defines22.v file is included22 again22 in sources22.
//
// Revision22 1.38  2002/07/22 23:02:23  gorban22
// Bug22 Fixes22:
//  * Possible22 loss of sync and bad22 reception22 of stop bit on slow22 baud22 rates22 fixed22.
//   Problem22 reported22 by Kenny22.Tung22.
//  * Bad (or lack22 of ) loopback22 handling22 fixed22. Reported22 by Cherry22 Withers22.
//
// Improvements22:
//  * Made22 FIFO's as general22 inferrable22 memory where possible22.
//  So22 on FPGA22 they should be inferred22 as RAM22 (Distributed22 RAM22 on Xilinx22).
//  This22 saves22 about22 1/3 of the Slice22 count and reduces22 P&R and synthesis22 times.
//
//  * Added22 optional22 baudrate22 output (baud_o22).
//  This22 is identical22 to BAUDOUT22* signal22 on 16550 chip22.
//  It outputs22 16xbit_clock_rate - the divided22 clock22.
//  It's disabled by default. Define22 UART_HAS_BAUDRATE_OUTPUT22 to use.
//
// Revision22 1.37  2001/12/27 13:24:09  mohor22
// lsr22[7] was not showing22 overrun22 errors22.
//
// Revision22 1.36  2001/12/20 13:25:46  mohor22
// rx22 push22 changed to be only one cycle wide22.
//
// Revision22 1.35  2001/12/19 08:03:34  mohor22
// Warnings22 cleared22.
//
// Revision22 1.34  2001/12/19 07:33:54  mohor22
// Synplicity22 was having22 troubles22 with the comment22.
//
// Revision22 1.33  2001/12/17 10:14:43  mohor22
// Things22 related22 to msr22 register changed. After22 THRE22 IRQ22 occurs22, and one
// character22 is written22 to the transmit22 fifo, the detection22 of the THRE22 bit in the
// LSR22 is delayed22 for one character22 time.
//
// Revision22 1.32  2001/12/14 13:19:24  mohor22
// MSR22 register fixed22.
//
// Revision22 1.31  2001/12/14 10:06:58  mohor22
// After22 reset modem22 status register MSR22 should be reset.
//
// Revision22 1.30  2001/12/13 10:09:13  mohor22
// thre22 irq22 should be cleared22 only when being source22 of interrupt22.
//
// Revision22 1.29  2001/12/12 09:05:46  mohor22
// LSR22 status bit 0 was not cleared22 correctly in case of reseting22 the FCR22 (rx22 fifo).
//
// Revision22 1.28  2001/12/10 19:52:41  gorban22
// Scratch22 register added
//
// Revision22 1.27  2001/12/06 14:51:04  gorban22
// Bug22 in LSR22[0] is fixed22.
// All WISHBONE22 signals22 are now sampled22, so another22 wait-state is introduced22 on all transfers22.
//
// Revision22 1.26  2001/12/03 21:44:29  gorban22
// Updated22 specification22 documentation.
// Added22 full 32-bit data bus interface, now as default.
// Address is 5-bit wide22 in 32-bit data bus mode.
// Added22 wb_sel_i22 input to the core22. It's used in the 32-bit mode.
// Added22 debug22 interface with two22 32-bit read-only registers in 32-bit mode.
// Bits22 5 and 6 of LSR22 are now only cleared22 on TX22 FIFO write.
// My22 small test bench22 is modified to work22 with 32-bit mode.
//
// Revision22 1.25  2001/11/28 19:36:39  gorban22
// Fixed22: timeout and break didn22't pay22 attention22 to current data format22 when counting22 time
//
// Revision22 1.24  2001/11/26 21:38:54  gorban22
// Lots22 of fixes22:
// Break22 condition wasn22't handled22 correctly at all.
// LSR22 bits could lose22 their22 values.
// LSR22 value after reset was wrong22.
// Timing22 of THRE22 interrupt22 signal22 corrected22.
// LSR22 bit 0 timing22 corrected22.
//
// Revision22 1.23  2001/11/12 21:57:29  gorban22
// fixed22 more typo22 bugs22
//
// Revision22 1.22  2001/11/12 15:02:28  mohor22
// lsr1r22 error fixed22.
//
// Revision22 1.21  2001/11/12 14:57:27  mohor22
// ti_int_pnd22 error fixed22.
//
// Revision22 1.20  2001/11/12 14:50:27  mohor22
// ti_int_d22 error fixed22.
//
// Revision22 1.19  2001/11/10 12:43:21  gorban22
// Logic22 Synthesis22 bugs22 fixed22. Some22 other minor22 changes22
//
// Revision22 1.18  2001/11/08 14:54:23  mohor22
// Comments22 in Slovene22 language22 deleted22, few22 small fixes22 for better22 work22 of
// old22 tools22. IRQs22 need to be fix22.
//
// Revision22 1.17  2001/11/07 17:51:52  gorban22
// Heavily22 rewritten22 interrupt22 and LSR22 subsystems22.
// Many22 bugs22 hopefully22 squashed22.
//
// Revision22 1.16  2001/11/02 09:55:16  mohor22
// no message
//
// Revision22 1.15  2001/10/31 15:19:22  gorban22
// Fixes22 to break and timeout conditions22
//
// Revision22 1.14  2001/10/29 17:00:46  gorban22
// fixed22 parity22 sending22 and tx_fifo22 resets22 over- and underrun22
//
// Revision22 1.13  2001/10/20 09:58:40  gorban22
// Small22 synopsis22 fixes22
//
// Revision22 1.12  2001/10/19 16:21:40  gorban22
// Changes22 data_out22 to be synchronous22 again22 as it should have been.
//
// Revision22 1.11  2001/10/18 20:35:45  gorban22
// small fix22
//
// Revision22 1.10  2001/08/24 21:01:12  mohor22
// Things22 connected22 to parity22 changed.
// Clock22 devider22 changed.
//
// Revision22 1.9  2001/08/23 16:05:05  mohor22
// Stop bit bug22 fixed22.
// Parity22 bug22 fixed22.
// WISHBONE22 read cycle bug22 fixed22,
// OE22 indicator22 (Overrun22 Error) bug22 fixed22.
// PE22 indicator22 (Parity22 Error) bug22 fixed22.
// Register read bug22 fixed22.
//
// Revision22 1.10  2001/06/23 11:21:48  gorban22
// DL22 made22 16-bit long22. Fixed22 transmission22/reception22 bugs22.
//
// Revision22 1.9  2001/05/31 20:08:01  gorban22
// FIFO changes22 and other corrections22.
//
// Revision22 1.8  2001/05/29 20:05:04  gorban22
// Fixed22 some22 bugs22 and synthesis22 problems22.
//
// Revision22 1.7  2001/05/27 17:37:49  gorban22
// Fixed22 many22 bugs22. Updated22 spec22. Changed22 FIFO files structure22. See CHANGES22.txt22 file.
//
// Revision22 1.6  2001/05/21 19:12:02  gorban22
// Corrected22 some22 Linter22 messages22.
//
// Revision22 1.5  2001/05/17 18:34:18  gorban22
// First22 'stable' release. Should22 be sythesizable22 now. Also22 added new header.
//
// Revision22 1.0  2001-05-17 21:27:11+02  jacob22
// Initial22 revision22
//
//

// synopsys22 translate_off22
`include "timescale.v"
// synopsys22 translate_on22

`include "uart_defines22.v"

`define UART_DL122 7:0
`define UART_DL222 15:8

module uart_regs22 (clk22,
	wb_rst_i22, wb_addr_i22, wb_dat_i22, wb_dat_o22, wb_we_i22, wb_re_i22, 

// additional22 signals22
	modem_inputs22,
	stx_pad_o22, srx_pad_i22,

`ifdef DATA_BUS_WIDTH_822
`else
// debug22 interface signals22	enabled
ier22, iir22, fcr22, mcr22, lcr22, msr22, lsr22, rf_count22, tf_count22, tstate22, rstate,
`endif				
	rts_pad_o22, dtr_pad_o22, int_o22
`ifdef UART_HAS_BAUDRATE_OUTPUT22
	, baud_o22
`endif

	);

input 									clk22;
input 									wb_rst_i22;
input [`UART_ADDR_WIDTH22-1:0] 		wb_addr_i22;
input [7:0] 							wb_dat_i22;
output [7:0] 							wb_dat_o22;
input 									wb_we_i22;
input 									wb_re_i22;

output 									stx_pad_o22;
input 									srx_pad_i22;

input [3:0] 							modem_inputs22;
output 									rts_pad_o22;
output 									dtr_pad_o22;
output 									int_o22;
`ifdef UART_HAS_BAUDRATE_OUTPUT22
output	baud_o22;
`endif

`ifdef DATA_BUS_WIDTH_822
`else
// if 32-bit databus22 and debug22 interface are enabled
output [3:0]							ier22;
output [3:0]							iir22;
output [1:0]							fcr22;  /// bits 7 and 6 of fcr22. Other22 bits are ignored
output [4:0]							mcr22;
output [7:0]							lcr22;
output [7:0]							msr22;
output [7:0] 							lsr22;
output [`UART_FIFO_COUNTER_W22-1:0] 	rf_count22;
output [`UART_FIFO_COUNTER_W22-1:0] 	tf_count22;
output [2:0] 							tstate22;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs22;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT22
assign baud_o22 = enable; // baud_o22 is actually22 the enable signal22
`endif


wire 										stx_pad_o22;		// received22 from transmitter22 module
wire 										srx_pad_i22;
wire 										srx_pad22;

reg [7:0] 								wb_dat_o22;

wire [`UART_ADDR_WIDTH22-1:0] 		wb_addr_i22;
wire [7:0] 								wb_dat_i22;


reg [3:0] 								ier22;
reg [3:0] 								iir22;
reg [1:0] 								fcr22;  /// bits 7 and 6 of fcr22. Other22 bits are ignored
reg [4:0] 								mcr22;
reg [7:0] 								lcr22;
reg [7:0] 								msr22;
reg [15:0] 								dl22;  // 32-bit divisor22 latch22
reg [7:0] 								scratch22; // UART22 scratch22 register
reg 										start_dlc22; // activate22 dlc22 on writing to UART_DL122
reg 										lsr_mask_d22; // delay for lsr_mask22 condition
reg 										msi_reset22; // reset MSR22 4 lower22 bits indicator22
//reg 										threi_clear22; // THRE22 interrupt22 clear flag22
reg [15:0] 								dlc22;  // 32-bit divisor22 latch22 counter
reg 										int_o22;

reg [3:0] 								trigger_level22; // trigger level of the receiver22 FIFO
reg 										rx_reset22;
reg 										tx_reset22;

wire 										dlab22;			   // divisor22 latch22 access bit
wire 										cts_pad_i22, dsr_pad_i22, ri_pad_i22, dcd_pad_i22; // modem22 status bits
wire 										loopback22;		   // loopback22 bit (MCR22 bit 4)
wire 										cts22, dsr22, ri, dcd22;	   // effective22 signals22
wire                    cts_c22, dsr_c22, ri_c22, dcd_c22; // Complement22 effective22 signals22 (considering22 loopback22)
wire 										rts_pad_o22, dtr_pad_o22;		   // modem22 control22 outputs22

// LSR22 bits wires22 and regs
wire [7:0] 								lsr22;
wire 										lsr022, lsr122, lsr222, lsr322, lsr422, lsr522, lsr622, lsr722;
reg										lsr0r22, lsr1r22, lsr2r22, lsr3r22, lsr4r22, lsr5r22, lsr6r22, lsr7r22;
wire 										lsr_mask22; // lsr_mask22

//
// ASSINGS22
//

assign 									lsr22[7:0] = { lsr7r22, lsr6r22, lsr5r22, lsr4r22, lsr3r22, lsr2r22, lsr1r22, lsr0r22 };

assign 									{cts_pad_i22, dsr_pad_i22, ri_pad_i22, dcd_pad_i22} = modem_inputs22;
assign 									{cts22, dsr22, ri, dcd22} = ~{cts_pad_i22,dsr_pad_i22,ri_pad_i22,dcd_pad_i22};

assign                  {cts_c22, dsr_c22, ri_c22, dcd_c22} = loopback22 ? {mcr22[`UART_MC_RTS22],mcr22[`UART_MC_DTR22],mcr22[`UART_MC_OUT122],mcr22[`UART_MC_OUT222]}
                                                               : {cts_pad_i22,dsr_pad_i22,ri_pad_i22,dcd_pad_i22};

assign 									dlab22 = lcr22[`UART_LC_DL22];
assign 									loopback22 = mcr22[4];

// assign modem22 outputs22
assign 									rts_pad_o22 = mcr22[`UART_MC_RTS22];
assign 									dtr_pad_o22 = mcr22[`UART_MC_DTR22];

// Interrupt22 signals22
wire 										rls_int22;  // receiver22 line status interrupt22
wire 										rda_int22;  // receiver22 data available interrupt22
wire 										ti_int22;   // timeout indicator22 interrupt22
wire										thre_int22; // transmitter22 holding22 register empty22 interrupt22
wire 										ms_int22;   // modem22 status interrupt22

// FIFO signals22
reg 										tf_push22;
reg 										rf_pop22;
wire [`UART_FIFO_REC_WIDTH22-1:0] 	rf_data_out22;
wire 										rf_error_bit22; // an error (parity22 or framing22) is inside the fifo
wire [`UART_FIFO_COUNTER_W22-1:0] 	rf_count22;
wire [`UART_FIFO_COUNTER_W22-1:0] 	tf_count22;
wire [2:0] 								tstate22;
wire [3:0] 								rstate;
wire [9:0] 								counter_t22;

wire                      thre_set_en22; // THRE22 status is delayed22 one character22 time when a character22 is written22 to fifo.
reg  [7:0]                block_cnt22;   // While22 counter counts22, THRE22 status is blocked22 (delayed22 one character22 cycle)
reg  [7:0]                block_value22; // One22 character22 length minus22 stop bit

// Transmitter22 Instance
wire serial_out22;

uart_transmitter22 transmitter22(clk22, wb_rst_i22, lcr22, tf_push22, wb_dat_i22, enable, serial_out22, tstate22, tf_count22, tx_reset22, lsr_mask22);

  // Synchronizing22 and sampling22 serial22 RX22 input
  uart_sync_flops22    i_uart_sync_flops22
  (
    .rst_i22           (wb_rst_i22),
    .clk_i22           (clk22),
    .stage1_rst_i22    (1'b0),
    .stage1_clk_en_i22 (1'b1),
    .async_dat_i22     (srx_pad_i22),
    .sync_dat_o22      (srx_pad22)
  );
  defparam i_uart_sync_flops22.width      = 1;
  defparam i_uart_sync_flops22.init_value22 = 1'b1;

// handle loopback22
wire serial_in22 = loopback22 ? serial_out22 : srx_pad22;
assign stx_pad_o22 = loopback22 ? 1'b1 : serial_out22;

// Receiver22 Instance
uart_receiver22 receiver22(clk22, wb_rst_i22, lcr22, rf_pop22, serial_in22, enable, 
	counter_t22, rf_count22, rf_data_out22, rf_error_bit22, rf_overrun22, rx_reset22, lsr_mask22, rstate, rf_push_pulse22);


// Asynchronous22 reading here22 because the outputs22 are sampled22 in uart_wb22.v file 
always @(dl22 or dlab22 or ier22 or iir22 or scratch22
			or lcr22 or lsr22 or msr22 or rf_data_out22 or wb_addr_i22 or wb_re_i22)   // asynchrounous22 reading
begin
	case (wb_addr_i22)
		`UART_REG_RB22   : wb_dat_o22 = dlab22 ? dl22[`UART_DL122] : rf_data_out22[10:3];
		`UART_REG_IE22	: wb_dat_o22 = dlab22 ? dl22[`UART_DL222] : ier22;
		`UART_REG_II22	: wb_dat_o22 = {4'b1100,iir22};
		`UART_REG_LC22	: wb_dat_o22 = lcr22;
		`UART_REG_LS22	: wb_dat_o22 = lsr22;
		`UART_REG_MS22	: wb_dat_o22 = msr22;
		`UART_REG_SR22	: wb_dat_o22 = scratch22;
		default:  wb_dat_o22 = 8'b0; // ??
	endcase // case(wb_addr_i22)
end // always @ (dl22 or dlab22 or ier22 or iir22 or scratch22...


// rf_pop22 signal22 handling22
always @(posedge clk22 or posedge wb_rst_i22)
begin
	if (wb_rst_i22)
		rf_pop22 <= #1 0; 
	else
	if (rf_pop22)	// restore22 the signal22 to 0 after one clock22 cycle
		rf_pop22 <= #1 0;
	else
	if (wb_re_i22 && wb_addr_i22 == `UART_REG_RB22 && !dlab22)
		rf_pop22 <= #1 1; // advance22 read pointer22
end

wire 	lsr_mask_condition22;
wire 	iir_read22;
wire  msr_read22;
wire	fifo_read22;
wire	fifo_write22;

assign lsr_mask_condition22 = (wb_re_i22 && wb_addr_i22 == `UART_REG_LS22 && !dlab22);
assign iir_read22 = (wb_re_i22 && wb_addr_i22 == `UART_REG_II22 && !dlab22);
assign msr_read22 = (wb_re_i22 && wb_addr_i22 == `UART_REG_MS22 && !dlab22);
assign fifo_read22 = (wb_re_i22 && wb_addr_i22 == `UART_REG_RB22 && !dlab22);
assign fifo_write22 = (wb_we_i22 && wb_addr_i22 == `UART_REG_TR22 && !dlab22);

// lsr_mask_d22 delayed22 signal22 handling22
always @(posedge clk22 or posedge wb_rst_i22)
begin
	if (wb_rst_i22)
		lsr_mask_d22 <= #1 0;
	else // reset bits in the Line22 Status Register
		lsr_mask_d22 <= #1 lsr_mask_condition22;
end

// lsr_mask22 is rise22 detected
assign lsr_mask22 = lsr_mask_condition22 && ~lsr_mask_d22;

// msi_reset22 signal22 handling22
always @(posedge clk22 or posedge wb_rst_i22)
begin
	if (wb_rst_i22)
		msi_reset22 <= #1 1;
	else
	if (msi_reset22)
		msi_reset22 <= #1 0;
	else
	if (msr_read22)
		msi_reset22 <= #1 1; // reset bits in Modem22 Status Register
end


//
//   WRITES22 AND22 RESETS22   //
//
// Line22 Control22 Register
always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22)
		lcr22 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i22 && wb_addr_i22==`UART_REG_LC22)
		lcr22 <= #1 wb_dat_i22;

// Interrupt22 Enable22 Register or UART_DL222
always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22)
	begin
		ier22 <= #1 4'b0000; // no interrupts22 after reset
		dl22[`UART_DL222] <= #1 8'b0;
	end
	else
	if (wb_we_i22 && wb_addr_i22==`UART_REG_IE22)
		if (dlab22)
		begin
			dl22[`UART_DL222] <= #1 wb_dat_i22;
		end
		else
			ier22 <= #1 wb_dat_i22[3:0]; // ier22 uses only 4 lsb


// FIFO Control22 Register and rx_reset22, tx_reset22 signals22
always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) begin
		fcr22 <= #1 2'b11; 
		rx_reset22 <= #1 0;
		tx_reset22 <= #1 0;
	end else
	if (wb_we_i22 && wb_addr_i22==`UART_REG_FC22) begin
		fcr22 <= #1 wb_dat_i22[7:6];
		rx_reset22 <= #1 wb_dat_i22[1];
		tx_reset22 <= #1 wb_dat_i22[2];
	end else begin
		rx_reset22 <= #1 0;
		tx_reset22 <= #1 0;
	end

// Modem22 Control22 Register
always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22)
		mcr22 <= #1 5'b0; 
	else
	if (wb_we_i22 && wb_addr_i22==`UART_REG_MC22)
			mcr22 <= #1 wb_dat_i22[4:0];

// Scratch22 register
// Line22 Control22 Register
always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22)
		scratch22 <= #1 0; // 8n1 setting
	else
	if (wb_we_i22 && wb_addr_i22==`UART_REG_SR22)
		scratch22 <= #1 wb_dat_i22;

// TX_FIFO22 or UART_DL122
always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22)
	begin
		dl22[`UART_DL122]  <= #1 8'b0;
		tf_push22   <= #1 1'b0;
		start_dlc22 <= #1 1'b0;
	end
	else
	if (wb_we_i22 && wb_addr_i22==`UART_REG_TR22)
		if (dlab22)
		begin
			dl22[`UART_DL122] <= #1 wb_dat_i22;
			start_dlc22 <= #1 1'b1; // enable DL22 counter
			tf_push22 <= #1 1'b0;
		end
		else
		begin
			tf_push22   <= #1 1'b1;
			start_dlc22 <= #1 1'b0;
		end // else: !if(dlab22)
	else
	begin
		start_dlc22 <= #1 1'b0;
		tf_push22   <= #1 1'b0;
	end // else: !if(dlab22)

// Receiver22 FIFO trigger level selection logic (asynchronous22 mux22)
always @(fcr22)
	case (fcr22[`UART_FC_TL22])
		2'b00 : trigger_level22 = 1;
		2'b01 : trigger_level22 = 4;
		2'b10 : trigger_level22 = 8;
		2'b11 : trigger_level22 = 14;
	endcase // case(fcr22[`UART_FC_TL22])
	
//
//  STATUS22 REGISTERS22  //
//

// Modem22 Status Register
reg [3:0] delayed_modem_signals22;
always @(posedge clk22 or posedge wb_rst_i22)
begin
	if (wb_rst_i22)
	  begin
  		msr22 <= #1 0;
	  	delayed_modem_signals22[3:0] <= #1 0;
	  end
	else begin
		msr22[`UART_MS_DDCD22:`UART_MS_DCTS22] <= #1 msi_reset22 ? 4'b0 :
			msr22[`UART_MS_DDCD22:`UART_MS_DCTS22] | ({dcd22, ri, dsr22, cts22} ^ delayed_modem_signals22[3:0]);
		msr22[`UART_MS_CDCD22:`UART_MS_CCTS22] <= #1 {dcd_c22, ri_c22, dsr_c22, cts_c22};
		delayed_modem_signals22[3:0] <= #1 {dcd22, ri, dsr22, cts22};
	end
end


// Line22 Status Register

// activation22 conditions22
assign lsr022 = (rf_count22==0 && rf_push_pulse22);  // data in receiver22 fifo available set condition
assign lsr122 = rf_overrun22;     // Receiver22 overrun22 error
assign lsr222 = rf_data_out22[1]; // parity22 error bit
assign lsr322 = rf_data_out22[0]; // framing22 error bit
assign lsr422 = rf_data_out22[2]; // break error in the character22
assign lsr522 = (tf_count22==5'b0 && thre_set_en22);  // transmitter22 fifo is empty22
assign lsr622 = (tf_count22==5'b0 && thre_set_en22 && (tstate22 == /*`S_IDLE22 */ 0)); // transmitter22 empty22
assign lsr722 = rf_error_bit22 | rf_overrun22;

// lsr22 bit022 (receiver22 data available)
reg 	 lsr0_d22;

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr0_d22 <= #1 0;
	else lsr0_d22 <= #1 lsr022;

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr0r22 <= #1 0;
	else lsr0r22 <= #1 (rf_count22==1 && rf_pop22 && !rf_push_pulse22 || rx_reset22) ? 0 : // deassert22 condition
					  lsr0r22 || (lsr022 && ~lsr0_d22); // set on rise22 of lsr022 and keep22 asserted22 until deasserted22 

// lsr22 bit 1 (receiver22 overrun22)
reg lsr1_d22; // delayed22

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr1_d22 <= #1 0;
	else lsr1_d22 <= #1 lsr122;

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr1r22 <= #1 0;
	else	lsr1r22 <= #1	lsr_mask22 ? 0 : lsr1r22 || (lsr122 && ~lsr1_d22); // set on rise22

// lsr22 bit 2 (parity22 error)
reg lsr2_d22; // delayed22

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr2_d22 <= #1 0;
	else lsr2_d22 <= #1 lsr222;

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr2r22 <= #1 0;
	else lsr2r22 <= #1 lsr_mask22 ? 0 : lsr2r22 || (lsr222 && ~lsr2_d22); // set on rise22

// lsr22 bit 3 (framing22 error)
reg lsr3_d22; // delayed22

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr3_d22 <= #1 0;
	else lsr3_d22 <= #1 lsr322;

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr3r22 <= #1 0;
	else lsr3r22 <= #1 lsr_mask22 ? 0 : lsr3r22 || (lsr322 && ~lsr3_d22); // set on rise22

// lsr22 bit 4 (break indicator22)
reg lsr4_d22; // delayed22

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr4_d22 <= #1 0;
	else lsr4_d22 <= #1 lsr422;

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr4r22 <= #1 0;
	else lsr4r22 <= #1 lsr_mask22 ? 0 : lsr4r22 || (lsr422 && ~lsr4_d22);

// lsr22 bit 5 (transmitter22 fifo is empty22)
reg lsr5_d22;

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr5_d22 <= #1 1;
	else lsr5_d22 <= #1 lsr522;

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr5r22 <= #1 1;
	else lsr5r22 <= #1 (fifo_write22) ? 0 :  lsr5r22 || (lsr522 && ~lsr5_d22);

// lsr22 bit 6 (transmitter22 empty22 indicator22)
reg lsr6_d22;

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr6_d22 <= #1 1;
	else lsr6_d22 <= #1 lsr622;

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr6r22 <= #1 1;
	else lsr6r22 <= #1 (fifo_write22) ? 0 : lsr6r22 || (lsr622 && ~lsr6_d22);

// lsr22 bit 7 (error in fifo)
reg lsr7_d22;

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr7_d22 <= #1 0;
	else lsr7_d22 <= #1 lsr722;

always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) lsr7r22 <= #1 0;
	else lsr7r22 <= #1 lsr_mask22 ? 0 : lsr7r22 || (lsr722 && ~lsr7_d22);

// Frequency22 divider22
always @(posedge clk22 or posedge wb_rst_i22) 
begin
	if (wb_rst_i22)
		dlc22 <= #1 0;
	else
		if (start_dlc22 | ~ (|dlc22))
  			dlc22 <= #1 dl22 - 1;               // preset22 counter
		else
			dlc22 <= #1 dlc22 - 1;              // decrement counter
end

// Enable22 signal22 generation22 logic
always @(posedge clk22 or posedge wb_rst_i22)
begin
	if (wb_rst_i22)
		enable <= #1 1'b0;
	else
		if (|dl22 & ~(|dlc22))     // dl22>0 & dlc22==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying22 THRE22 status for one character22 cycle after a character22 is written22 to an empty22 fifo.
always @(lcr22)
  case (lcr22[3:0])
    4'b0000                             : block_value22 =  95; // 6 bits
    4'b0100                             : block_value22 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value22 = 111; // 7 bits
    4'b1100                             : block_value22 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value22 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value22 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value22 = 159; // 10 bits
    4'b1111                             : block_value22 = 175; // 11 bits
  endcase // case(lcr22[3:0])

// Counting22 time of one character22 minus22 stop bit
always @(posedge clk22 or posedge wb_rst_i22)
begin
  if (wb_rst_i22)
    block_cnt22 <= #1 8'd0;
  else
  if(lsr5r22 & fifo_write22)  // THRE22 bit set & write to fifo occured22
    block_cnt22 <= #1 block_value22;
  else
  if (enable & block_cnt22 != 8'b0)  // only work22 on enable times
    block_cnt22 <= #1 block_cnt22 - 1;  // decrement break counter
end // always of break condition detection22

// Generating22 THRE22 status enable signal22
assign thre_set_en22 = ~(|block_cnt22);


//
//	INTERRUPT22 LOGIC22
//

assign rls_int22  = ier22[`UART_IE_RLS22] && (lsr22[`UART_LS_OE22] || lsr22[`UART_LS_PE22] || lsr22[`UART_LS_FE22] || lsr22[`UART_LS_BI22]);
assign rda_int22  = ier22[`UART_IE_RDA22] && (rf_count22 >= {1'b0,trigger_level22});
assign thre_int22 = ier22[`UART_IE_THRE22] && lsr22[`UART_LS_TFE22];
assign ms_int22   = ier22[`UART_IE_MS22] && (| msr22[3:0]);
assign ti_int22   = ier22[`UART_IE_RDA22] && (counter_t22 == 10'b0) && (|rf_count22);

reg 	 rls_int_d22;
reg 	 thre_int_d22;
reg 	 ms_int_d22;
reg 	 ti_int_d22;
reg 	 rda_int_d22;

// delay lines22
always  @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) rls_int_d22 <= #1 0;
	else rls_int_d22 <= #1 rls_int22;

always  @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) rda_int_d22 <= #1 0;
	else rda_int_d22 <= #1 rda_int22;

always  @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) thre_int_d22 <= #1 0;
	else thre_int_d22 <= #1 thre_int22;

always  @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) ms_int_d22 <= #1 0;
	else ms_int_d22 <= #1 ms_int22;

always  @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) ti_int_d22 <= #1 0;
	else ti_int_d22 <= #1 ti_int22;

// rise22 detection22 signals22

wire 	 rls_int_rise22;
wire 	 thre_int_rise22;
wire 	 ms_int_rise22;
wire 	 ti_int_rise22;
wire 	 rda_int_rise22;

assign rda_int_rise22    = rda_int22 & ~rda_int_d22;
assign rls_int_rise22 	  = rls_int22 & ~rls_int_d22;
assign thre_int_rise22   = thre_int22 & ~thre_int_d22;
assign ms_int_rise22 	  = ms_int22 & ~ms_int_d22;
assign ti_int_rise22 	  = ti_int22 & ~ti_int_d22;

// interrupt22 pending flags22
reg 	rls_int_pnd22;
reg	rda_int_pnd22;
reg 	thre_int_pnd22;
reg 	ms_int_pnd22;
reg 	ti_int_pnd22;

// interrupt22 pending flags22 assignments22
always  @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) rls_int_pnd22 <= #1 0; 
	else 
		rls_int_pnd22 <= #1 lsr_mask22 ? 0 :  						// reset condition
							rls_int_rise22 ? 1 :						// latch22 condition
							rls_int_pnd22 && ier22[`UART_IE_RLS22];	// default operation22: remove if masked22

always  @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) rda_int_pnd22 <= #1 0; 
	else 
		rda_int_pnd22 <= #1 ((rf_count22 == {1'b0,trigger_level22}) && fifo_read22) ? 0 :  	// reset condition
							rda_int_rise22 ? 1 :						// latch22 condition
							rda_int_pnd22 && ier22[`UART_IE_RDA22];	// default operation22: remove if masked22

always  @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) thre_int_pnd22 <= #1 0; 
	else 
		thre_int_pnd22 <= #1 fifo_write22 || (iir_read22 & ~iir22[`UART_II_IP22] & iir22[`UART_II_II22] == `UART_II_THRE22)? 0 : 
							thre_int_rise22 ? 1 :
							thre_int_pnd22 && ier22[`UART_IE_THRE22];

always  @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) ms_int_pnd22 <= #1 0; 
	else 
		ms_int_pnd22 <= #1 msr_read22 ? 0 : 
							ms_int_rise22 ? 1 :
							ms_int_pnd22 && ier22[`UART_IE_MS22];

always  @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) ti_int_pnd22 <= #1 0; 
	else 
		ti_int_pnd22 <= #1 fifo_read22 ? 0 : 
							ti_int_rise22 ? 1 :
							ti_int_pnd22 && ier22[`UART_IE_RDA22];
// end of pending flags22

// INT_O22 logic
always @(posedge clk22 or posedge wb_rst_i22)
begin
	if (wb_rst_i22)	
		int_o22 <= #1 1'b0;
	else
		int_o22 <= #1 
					rls_int_pnd22		?	~lsr_mask22					:
					rda_int_pnd22		? 1								:
					ti_int_pnd22		? ~fifo_read22					:
					thre_int_pnd22	? !(fifo_write22 & iir_read22) :
					ms_int_pnd22		? ~msr_read22						:
					0;	// if no interrupt22 are pending
end


// Interrupt22 Identification22 register
always @(posedge clk22 or posedge wb_rst_i22)
begin
	if (wb_rst_i22)
		iir22 <= #1 1;
	else
	if (rls_int_pnd22)  // interrupt22 is pending
	begin
		iir22[`UART_II_II22] <= #1 `UART_II_RLS22;	// set identification22 register to correct22 value
		iir22[`UART_II_IP22] <= #1 1'b0;		// and clear the IIR22 bit 0 (interrupt22 pending)
	end else // the sequence of conditions22 determines22 priority of interrupt22 identification22
	if (rda_int22)
	begin
		iir22[`UART_II_II22] <= #1 `UART_II_RDA22;
		iir22[`UART_II_IP22] <= #1 1'b0;
	end
	else if (ti_int_pnd22)
	begin
		iir22[`UART_II_II22] <= #1 `UART_II_TI22;
		iir22[`UART_II_IP22] <= #1 1'b0;
	end
	else if (thre_int_pnd22)
	begin
		iir22[`UART_II_II22] <= #1 `UART_II_THRE22;
		iir22[`UART_II_IP22] <= #1 1'b0;
	end
	else if (ms_int_pnd22)
	begin
		iir22[`UART_II_II22] <= #1 `UART_II_MS22;
		iir22[`UART_II_IP22] <= #1 1'b0;
	end else	// no interrupt22 is pending
	begin
		iir22[`UART_II_II22] <= #1 0;
		iir22[`UART_II_IP22] <= #1 1'b1;
	end
end

endmodule
