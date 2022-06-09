//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs14.v                                                 ////
////                                                              ////
////                                                              ////
////  This14 file is part of the "UART14 16550 compatible14" project14    ////
////  http14://www14.opencores14.org14/cores14/uart1655014/                   ////
////                                                              ////
////  Documentation14 related14 to this project14:                      ////
////  - http14://www14.opencores14.org14/cores14/uart1655014/                 ////
////                                                              ////
////  Projects14 compatibility14:                                     ////
////  - WISHBONE14                                                  ////
////  RS23214 Protocol14                                              ////
////  16550D uart14 (mostly14 supported)                              ////
////                                                              ////
////  Overview14 (main14 Features14):                                   ////
////  Registers14 of the uart14 16550 core14                            ////
////                                                              ////
////  Known14 problems14 (limits14):                                    ////
////  Inserts14 1 wait state in all WISHBONE14 transfers14              ////
////                                                              ////
////  To14 Do14:                                                      ////
////  Nothing or verification14.                                    ////
////                                                              ////
////  Author14(s):                                                  ////
////      - gorban14@opencores14.org14                                  ////
////      - Jacob14 Gorban14                                          ////
////      - Igor14 Mohor14 (igorm14@opencores14.org14)                      ////
////                                                              ////
////  Created14:        2001/05/12                                  ////
////  Last14 Updated14:   (See log14 for the revision14 history14           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2000, 2001 Authors14                             ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS14 Revision14 History14
//
// $Log: not supported by cvs2svn14 $
// Revision14 1.41  2004/05/21 11:44:41  tadejm14
// Added14 synchronizer14 flops14 for RX14 input.
//
// Revision14 1.40  2003/06/11 16:37:47  gorban14
// This14 fixes14 errors14 in some14 cases14 when data is being read and put to the FIFO at the same time. Patch14 is submitted14 by Scott14 Furman14. Update is very14 recommended14.
//
// Revision14 1.39  2002/07/29 21:16:18  gorban14
// The uart_defines14.v file is included14 again14 in sources14.
//
// Revision14 1.38  2002/07/22 23:02:23  gorban14
// Bug14 Fixes14:
//  * Possible14 loss of sync and bad14 reception14 of stop bit on slow14 baud14 rates14 fixed14.
//   Problem14 reported14 by Kenny14.Tung14.
//  * Bad (or lack14 of ) loopback14 handling14 fixed14. Reported14 by Cherry14 Withers14.
//
// Improvements14:
//  * Made14 FIFO's as general14 inferrable14 memory where possible14.
//  So14 on FPGA14 they should be inferred14 as RAM14 (Distributed14 RAM14 on Xilinx14).
//  This14 saves14 about14 1/3 of the Slice14 count and reduces14 P&R and synthesis14 times.
//
//  * Added14 optional14 baudrate14 output (baud_o14).
//  This14 is identical14 to BAUDOUT14* signal14 on 16550 chip14.
//  It outputs14 16xbit_clock_rate - the divided14 clock14.
//  It's disabled by default. Define14 UART_HAS_BAUDRATE_OUTPUT14 to use.
//
// Revision14 1.37  2001/12/27 13:24:09  mohor14
// lsr14[7] was not showing14 overrun14 errors14.
//
// Revision14 1.36  2001/12/20 13:25:46  mohor14
// rx14 push14 changed to be only one cycle wide14.
//
// Revision14 1.35  2001/12/19 08:03:34  mohor14
// Warnings14 cleared14.
//
// Revision14 1.34  2001/12/19 07:33:54  mohor14
// Synplicity14 was having14 troubles14 with the comment14.
//
// Revision14 1.33  2001/12/17 10:14:43  mohor14
// Things14 related14 to msr14 register changed. After14 THRE14 IRQ14 occurs14, and one
// character14 is written14 to the transmit14 fifo, the detection14 of the THRE14 bit in the
// LSR14 is delayed14 for one character14 time.
//
// Revision14 1.32  2001/12/14 13:19:24  mohor14
// MSR14 register fixed14.
//
// Revision14 1.31  2001/12/14 10:06:58  mohor14
// After14 reset modem14 status register MSR14 should be reset.
//
// Revision14 1.30  2001/12/13 10:09:13  mohor14
// thre14 irq14 should be cleared14 only when being source14 of interrupt14.
//
// Revision14 1.29  2001/12/12 09:05:46  mohor14
// LSR14 status bit 0 was not cleared14 correctly in case of reseting14 the FCR14 (rx14 fifo).
//
// Revision14 1.28  2001/12/10 19:52:41  gorban14
// Scratch14 register added
//
// Revision14 1.27  2001/12/06 14:51:04  gorban14
// Bug14 in LSR14[0] is fixed14.
// All WISHBONE14 signals14 are now sampled14, so another14 wait-state is introduced14 on all transfers14.
//
// Revision14 1.26  2001/12/03 21:44:29  gorban14
// Updated14 specification14 documentation.
// Added14 full 32-bit data bus interface, now as default.
// Address is 5-bit wide14 in 32-bit data bus mode.
// Added14 wb_sel_i14 input to the core14. It's used in the 32-bit mode.
// Added14 debug14 interface with two14 32-bit read-only registers in 32-bit mode.
// Bits14 5 and 6 of LSR14 are now only cleared14 on TX14 FIFO write.
// My14 small test bench14 is modified to work14 with 32-bit mode.
//
// Revision14 1.25  2001/11/28 19:36:39  gorban14
// Fixed14: timeout and break didn14't pay14 attention14 to current data format14 when counting14 time
//
// Revision14 1.24  2001/11/26 21:38:54  gorban14
// Lots14 of fixes14:
// Break14 condition wasn14't handled14 correctly at all.
// LSR14 bits could lose14 their14 values.
// LSR14 value after reset was wrong14.
// Timing14 of THRE14 interrupt14 signal14 corrected14.
// LSR14 bit 0 timing14 corrected14.
//
// Revision14 1.23  2001/11/12 21:57:29  gorban14
// fixed14 more typo14 bugs14
//
// Revision14 1.22  2001/11/12 15:02:28  mohor14
// lsr1r14 error fixed14.
//
// Revision14 1.21  2001/11/12 14:57:27  mohor14
// ti_int_pnd14 error fixed14.
//
// Revision14 1.20  2001/11/12 14:50:27  mohor14
// ti_int_d14 error fixed14.
//
// Revision14 1.19  2001/11/10 12:43:21  gorban14
// Logic14 Synthesis14 bugs14 fixed14. Some14 other minor14 changes14
//
// Revision14 1.18  2001/11/08 14:54:23  mohor14
// Comments14 in Slovene14 language14 deleted14, few14 small fixes14 for better14 work14 of
// old14 tools14. IRQs14 need to be fix14.
//
// Revision14 1.17  2001/11/07 17:51:52  gorban14
// Heavily14 rewritten14 interrupt14 and LSR14 subsystems14.
// Many14 bugs14 hopefully14 squashed14.
//
// Revision14 1.16  2001/11/02 09:55:16  mohor14
// no message
//
// Revision14 1.15  2001/10/31 15:19:22  gorban14
// Fixes14 to break and timeout conditions14
//
// Revision14 1.14  2001/10/29 17:00:46  gorban14
// fixed14 parity14 sending14 and tx_fifo14 resets14 over- and underrun14
//
// Revision14 1.13  2001/10/20 09:58:40  gorban14
// Small14 synopsis14 fixes14
//
// Revision14 1.12  2001/10/19 16:21:40  gorban14
// Changes14 data_out14 to be synchronous14 again14 as it should have been.
//
// Revision14 1.11  2001/10/18 20:35:45  gorban14
// small fix14
//
// Revision14 1.10  2001/08/24 21:01:12  mohor14
// Things14 connected14 to parity14 changed.
// Clock14 devider14 changed.
//
// Revision14 1.9  2001/08/23 16:05:05  mohor14
// Stop bit bug14 fixed14.
// Parity14 bug14 fixed14.
// WISHBONE14 read cycle bug14 fixed14,
// OE14 indicator14 (Overrun14 Error) bug14 fixed14.
// PE14 indicator14 (Parity14 Error) bug14 fixed14.
// Register read bug14 fixed14.
//
// Revision14 1.10  2001/06/23 11:21:48  gorban14
// DL14 made14 16-bit long14. Fixed14 transmission14/reception14 bugs14.
//
// Revision14 1.9  2001/05/31 20:08:01  gorban14
// FIFO changes14 and other corrections14.
//
// Revision14 1.8  2001/05/29 20:05:04  gorban14
// Fixed14 some14 bugs14 and synthesis14 problems14.
//
// Revision14 1.7  2001/05/27 17:37:49  gorban14
// Fixed14 many14 bugs14. Updated14 spec14. Changed14 FIFO files structure14. See CHANGES14.txt14 file.
//
// Revision14 1.6  2001/05/21 19:12:02  gorban14
// Corrected14 some14 Linter14 messages14.
//
// Revision14 1.5  2001/05/17 18:34:18  gorban14
// First14 'stable' release. Should14 be sythesizable14 now. Also14 added new header.
//
// Revision14 1.0  2001-05-17 21:27:11+02  jacob14
// Initial14 revision14
//
//

// synopsys14 translate_off14
`include "timescale.v"
// synopsys14 translate_on14

`include "uart_defines14.v"

`define UART_DL114 7:0
`define UART_DL214 15:8

module uart_regs14 (clk14,
	wb_rst_i14, wb_addr_i14, wb_dat_i14, wb_dat_o14, wb_we_i14, wb_re_i14, 

// additional14 signals14
	modem_inputs14,
	stx_pad_o14, srx_pad_i14,

`ifdef DATA_BUS_WIDTH_814
`else
// debug14 interface signals14	enabled
ier14, iir14, fcr14, mcr14, lcr14, msr14, lsr14, rf_count14, tf_count14, tstate14, rstate,
`endif				
	rts_pad_o14, dtr_pad_o14, int_o14
`ifdef UART_HAS_BAUDRATE_OUTPUT14
	, baud_o14
`endif

	);

input 									clk14;
input 									wb_rst_i14;
input [`UART_ADDR_WIDTH14-1:0] 		wb_addr_i14;
input [7:0] 							wb_dat_i14;
output [7:0] 							wb_dat_o14;
input 									wb_we_i14;
input 									wb_re_i14;

output 									stx_pad_o14;
input 									srx_pad_i14;

input [3:0] 							modem_inputs14;
output 									rts_pad_o14;
output 									dtr_pad_o14;
output 									int_o14;
`ifdef UART_HAS_BAUDRATE_OUTPUT14
output	baud_o14;
`endif

`ifdef DATA_BUS_WIDTH_814
`else
// if 32-bit databus14 and debug14 interface are enabled
output [3:0]							ier14;
output [3:0]							iir14;
output [1:0]							fcr14;  /// bits 7 and 6 of fcr14. Other14 bits are ignored
output [4:0]							mcr14;
output [7:0]							lcr14;
output [7:0]							msr14;
output [7:0] 							lsr14;
output [`UART_FIFO_COUNTER_W14-1:0] 	rf_count14;
output [`UART_FIFO_COUNTER_W14-1:0] 	tf_count14;
output [2:0] 							tstate14;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs14;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT14
assign baud_o14 = enable; // baud_o14 is actually14 the enable signal14
`endif


wire 										stx_pad_o14;		// received14 from transmitter14 module
wire 										srx_pad_i14;
wire 										srx_pad14;

reg [7:0] 								wb_dat_o14;

wire [`UART_ADDR_WIDTH14-1:0] 		wb_addr_i14;
wire [7:0] 								wb_dat_i14;


reg [3:0] 								ier14;
reg [3:0] 								iir14;
reg [1:0] 								fcr14;  /// bits 7 and 6 of fcr14. Other14 bits are ignored
reg [4:0] 								mcr14;
reg [7:0] 								lcr14;
reg [7:0] 								msr14;
reg [15:0] 								dl14;  // 32-bit divisor14 latch14
reg [7:0] 								scratch14; // UART14 scratch14 register
reg 										start_dlc14; // activate14 dlc14 on writing to UART_DL114
reg 										lsr_mask_d14; // delay for lsr_mask14 condition
reg 										msi_reset14; // reset MSR14 4 lower14 bits indicator14
//reg 										threi_clear14; // THRE14 interrupt14 clear flag14
reg [15:0] 								dlc14;  // 32-bit divisor14 latch14 counter
reg 										int_o14;

reg [3:0] 								trigger_level14; // trigger level of the receiver14 FIFO
reg 										rx_reset14;
reg 										tx_reset14;

wire 										dlab14;			   // divisor14 latch14 access bit
wire 										cts_pad_i14, dsr_pad_i14, ri_pad_i14, dcd_pad_i14; // modem14 status bits
wire 										loopback14;		   // loopback14 bit (MCR14 bit 4)
wire 										cts14, dsr14, ri, dcd14;	   // effective14 signals14
wire                    cts_c14, dsr_c14, ri_c14, dcd_c14; // Complement14 effective14 signals14 (considering14 loopback14)
wire 										rts_pad_o14, dtr_pad_o14;		   // modem14 control14 outputs14

// LSR14 bits wires14 and regs
wire [7:0] 								lsr14;
wire 										lsr014, lsr114, lsr214, lsr314, lsr414, lsr514, lsr614, lsr714;
reg										lsr0r14, lsr1r14, lsr2r14, lsr3r14, lsr4r14, lsr5r14, lsr6r14, lsr7r14;
wire 										lsr_mask14; // lsr_mask14

//
// ASSINGS14
//

assign 									lsr14[7:0] = { lsr7r14, lsr6r14, lsr5r14, lsr4r14, lsr3r14, lsr2r14, lsr1r14, lsr0r14 };

assign 									{cts_pad_i14, dsr_pad_i14, ri_pad_i14, dcd_pad_i14} = modem_inputs14;
assign 									{cts14, dsr14, ri, dcd14} = ~{cts_pad_i14,dsr_pad_i14,ri_pad_i14,dcd_pad_i14};

assign                  {cts_c14, dsr_c14, ri_c14, dcd_c14} = loopback14 ? {mcr14[`UART_MC_RTS14],mcr14[`UART_MC_DTR14],mcr14[`UART_MC_OUT114],mcr14[`UART_MC_OUT214]}
                                                               : {cts_pad_i14,dsr_pad_i14,ri_pad_i14,dcd_pad_i14};

assign 									dlab14 = lcr14[`UART_LC_DL14];
assign 									loopback14 = mcr14[4];

// assign modem14 outputs14
assign 									rts_pad_o14 = mcr14[`UART_MC_RTS14];
assign 									dtr_pad_o14 = mcr14[`UART_MC_DTR14];

// Interrupt14 signals14
wire 										rls_int14;  // receiver14 line status interrupt14
wire 										rda_int14;  // receiver14 data available interrupt14
wire 										ti_int14;   // timeout indicator14 interrupt14
wire										thre_int14; // transmitter14 holding14 register empty14 interrupt14
wire 										ms_int14;   // modem14 status interrupt14

// FIFO signals14
reg 										tf_push14;
reg 										rf_pop14;
wire [`UART_FIFO_REC_WIDTH14-1:0] 	rf_data_out14;
wire 										rf_error_bit14; // an error (parity14 or framing14) is inside the fifo
wire [`UART_FIFO_COUNTER_W14-1:0] 	rf_count14;
wire [`UART_FIFO_COUNTER_W14-1:0] 	tf_count14;
wire [2:0] 								tstate14;
wire [3:0] 								rstate;
wire [9:0] 								counter_t14;

wire                      thre_set_en14; // THRE14 status is delayed14 one character14 time when a character14 is written14 to fifo.
reg  [7:0]                block_cnt14;   // While14 counter counts14, THRE14 status is blocked14 (delayed14 one character14 cycle)
reg  [7:0]                block_value14; // One14 character14 length minus14 stop bit

// Transmitter14 Instance
wire serial_out14;

uart_transmitter14 transmitter14(clk14, wb_rst_i14, lcr14, tf_push14, wb_dat_i14, enable, serial_out14, tstate14, tf_count14, tx_reset14, lsr_mask14);

  // Synchronizing14 and sampling14 serial14 RX14 input
  uart_sync_flops14    i_uart_sync_flops14
  (
    .rst_i14           (wb_rst_i14),
    .clk_i14           (clk14),
    .stage1_rst_i14    (1'b0),
    .stage1_clk_en_i14 (1'b1),
    .async_dat_i14     (srx_pad_i14),
    .sync_dat_o14      (srx_pad14)
  );
  defparam i_uart_sync_flops14.width      = 1;
  defparam i_uart_sync_flops14.init_value14 = 1'b1;

// handle loopback14
wire serial_in14 = loopback14 ? serial_out14 : srx_pad14;
assign stx_pad_o14 = loopback14 ? 1'b1 : serial_out14;

// Receiver14 Instance
uart_receiver14 receiver14(clk14, wb_rst_i14, lcr14, rf_pop14, serial_in14, enable, 
	counter_t14, rf_count14, rf_data_out14, rf_error_bit14, rf_overrun14, rx_reset14, lsr_mask14, rstate, rf_push_pulse14);


// Asynchronous14 reading here14 because the outputs14 are sampled14 in uart_wb14.v file 
always @(dl14 or dlab14 or ier14 or iir14 or scratch14
			or lcr14 or lsr14 or msr14 or rf_data_out14 or wb_addr_i14 or wb_re_i14)   // asynchrounous14 reading
begin
	case (wb_addr_i14)
		`UART_REG_RB14   : wb_dat_o14 = dlab14 ? dl14[`UART_DL114] : rf_data_out14[10:3];
		`UART_REG_IE14	: wb_dat_o14 = dlab14 ? dl14[`UART_DL214] : ier14;
		`UART_REG_II14	: wb_dat_o14 = {4'b1100,iir14};
		`UART_REG_LC14	: wb_dat_o14 = lcr14;
		`UART_REG_LS14	: wb_dat_o14 = lsr14;
		`UART_REG_MS14	: wb_dat_o14 = msr14;
		`UART_REG_SR14	: wb_dat_o14 = scratch14;
		default:  wb_dat_o14 = 8'b0; // ??
	endcase // case(wb_addr_i14)
end // always @ (dl14 or dlab14 or ier14 or iir14 or scratch14...


// rf_pop14 signal14 handling14
always @(posedge clk14 or posedge wb_rst_i14)
begin
	if (wb_rst_i14)
		rf_pop14 <= #1 0; 
	else
	if (rf_pop14)	// restore14 the signal14 to 0 after one clock14 cycle
		rf_pop14 <= #1 0;
	else
	if (wb_re_i14 && wb_addr_i14 == `UART_REG_RB14 && !dlab14)
		rf_pop14 <= #1 1; // advance14 read pointer14
end

wire 	lsr_mask_condition14;
wire 	iir_read14;
wire  msr_read14;
wire	fifo_read14;
wire	fifo_write14;

assign lsr_mask_condition14 = (wb_re_i14 && wb_addr_i14 == `UART_REG_LS14 && !dlab14);
assign iir_read14 = (wb_re_i14 && wb_addr_i14 == `UART_REG_II14 && !dlab14);
assign msr_read14 = (wb_re_i14 && wb_addr_i14 == `UART_REG_MS14 && !dlab14);
assign fifo_read14 = (wb_re_i14 && wb_addr_i14 == `UART_REG_RB14 && !dlab14);
assign fifo_write14 = (wb_we_i14 && wb_addr_i14 == `UART_REG_TR14 && !dlab14);

// lsr_mask_d14 delayed14 signal14 handling14
always @(posedge clk14 or posedge wb_rst_i14)
begin
	if (wb_rst_i14)
		lsr_mask_d14 <= #1 0;
	else // reset bits in the Line14 Status Register
		lsr_mask_d14 <= #1 lsr_mask_condition14;
end

// lsr_mask14 is rise14 detected
assign lsr_mask14 = lsr_mask_condition14 && ~lsr_mask_d14;

// msi_reset14 signal14 handling14
always @(posedge clk14 or posedge wb_rst_i14)
begin
	if (wb_rst_i14)
		msi_reset14 <= #1 1;
	else
	if (msi_reset14)
		msi_reset14 <= #1 0;
	else
	if (msr_read14)
		msi_reset14 <= #1 1; // reset bits in Modem14 Status Register
end


//
//   WRITES14 AND14 RESETS14   //
//
// Line14 Control14 Register
always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14)
		lcr14 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i14 && wb_addr_i14==`UART_REG_LC14)
		lcr14 <= #1 wb_dat_i14;

// Interrupt14 Enable14 Register or UART_DL214
always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14)
	begin
		ier14 <= #1 4'b0000; // no interrupts14 after reset
		dl14[`UART_DL214] <= #1 8'b0;
	end
	else
	if (wb_we_i14 && wb_addr_i14==`UART_REG_IE14)
		if (dlab14)
		begin
			dl14[`UART_DL214] <= #1 wb_dat_i14;
		end
		else
			ier14 <= #1 wb_dat_i14[3:0]; // ier14 uses only 4 lsb


// FIFO Control14 Register and rx_reset14, tx_reset14 signals14
always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) begin
		fcr14 <= #1 2'b11; 
		rx_reset14 <= #1 0;
		tx_reset14 <= #1 0;
	end else
	if (wb_we_i14 && wb_addr_i14==`UART_REG_FC14) begin
		fcr14 <= #1 wb_dat_i14[7:6];
		rx_reset14 <= #1 wb_dat_i14[1];
		tx_reset14 <= #1 wb_dat_i14[2];
	end else begin
		rx_reset14 <= #1 0;
		tx_reset14 <= #1 0;
	end

// Modem14 Control14 Register
always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14)
		mcr14 <= #1 5'b0; 
	else
	if (wb_we_i14 && wb_addr_i14==`UART_REG_MC14)
			mcr14 <= #1 wb_dat_i14[4:0];

// Scratch14 register
// Line14 Control14 Register
always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14)
		scratch14 <= #1 0; // 8n1 setting
	else
	if (wb_we_i14 && wb_addr_i14==`UART_REG_SR14)
		scratch14 <= #1 wb_dat_i14;

// TX_FIFO14 or UART_DL114
always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14)
	begin
		dl14[`UART_DL114]  <= #1 8'b0;
		tf_push14   <= #1 1'b0;
		start_dlc14 <= #1 1'b0;
	end
	else
	if (wb_we_i14 && wb_addr_i14==`UART_REG_TR14)
		if (dlab14)
		begin
			dl14[`UART_DL114] <= #1 wb_dat_i14;
			start_dlc14 <= #1 1'b1; // enable DL14 counter
			tf_push14 <= #1 1'b0;
		end
		else
		begin
			tf_push14   <= #1 1'b1;
			start_dlc14 <= #1 1'b0;
		end // else: !if(dlab14)
	else
	begin
		start_dlc14 <= #1 1'b0;
		tf_push14   <= #1 1'b0;
	end // else: !if(dlab14)

// Receiver14 FIFO trigger level selection logic (asynchronous14 mux14)
always @(fcr14)
	case (fcr14[`UART_FC_TL14])
		2'b00 : trigger_level14 = 1;
		2'b01 : trigger_level14 = 4;
		2'b10 : trigger_level14 = 8;
		2'b11 : trigger_level14 = 14;
	endcase // case(fcr14[`UART_FC_TL14])
	
//
//  STATUS14 REGISTERS14  //
//

// Modem14 Status Register
reg [3:0] delayed_modem_signals14;
always @(posedge clk14 or posedge wb_rst_i14)
begin
	if (wb_rst_i14)
	  begin
  		msr14 <= #1 0;
	  	delayed_modem_signals14[3:0] <= #1 0;
	  end
	else begin
		msr14[`UART_MS_DDCD14:`UART_MS_DCTS14] <= #1 msi_reset14 ? 4'b0 :
			msr14[`UART_MS_DDCD14:`UART_MS_DCTS14] | ({dcd14, ri, dsr14, cts14} ^ delayed_modem_signals14[3:0]);
		msr14[`UART_MS_CDCD14:`UART_MS_CCTS14] <= #1 {dcd_c14, ri_c14, dsr_c14, cts_c14};
		delayed_modem_signals14[3:0] <= #1 {dcd14, ri, dsr14, cts14};
	end
end


// Line14 Status Register

// activation14 conditions14
assign lsr014 = (rf_count14==0 && rf_push_pulse14);  // data in receiver14 fifo available set condition
assign lsr114 = rf_overrun14;     // Receiver14 overrun14 error
assign lsr214 = rf_data_out14[1]; // parity14 error bit
assign lsr314 = rf_data_out14[0]; // framing14 error bit
assign lsr414 = rf_data_out14[2]; // break error in the character14
assign lsr514 = (tf_count14==5'b0 && thre_set_en14);  // transmitter14 fifo is empty14
assign lsr614 = (tf_count14==5'b0 && thre_set_en14 && (tstate14 == /*`S_IDLE14 */ 0)); // transmitter14 empty14
assign lsr714 = rf_error_bit14 | rf_overrun14;

// lsr14 bit014 (receiver14 data available)
reg 	 lsr0_d14;

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr0_d14 <= #1 0;
	else lsr0_d14 <= #1 lsr014;

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr0r14 <= #1 0;
	else lsr0r14 <= #1 (rf_count14==1 && rf_pop14 && !rf_push_pulse14 || rx_reset14) ? 0 : // deassert14 condition
					  lsr0r14 || (lsr014 && ~lsr0_d14); // set on rise14 of lsr014 and keep14 asserted14 until deasserted14 

// lsr14 bit 1 (receiver14 overrun14)
reg lsr1_d14; // delayed14

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr1_d14 <= #1 0;
	else lsr1_d14 <= #1 lsr114;

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr1r14 <= #1 0;
	else	lsr1r14 <= #1	lsr_mask14 ? 0 : lsr1r14 || (lsr114 && ~lsr1_d14); // set on rise14

// lsr14 bit 2 (parity14 error)
reg lsr2_d14; // delayed14

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr2_d14 <= #1 0;
	else lsr2_d14 <= #1 lsr214;

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr2r14 <= #1 0;
	else lsr2r14 <= #1 lsr_mask14 ? 0 : lsr2r14 || (lsr214 && ~lsr2_d14); // set on rise14

// lsr14 bit 3 (framing14 error)
reg lsr3_d14; // delayed14

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr3_d14 <= #1 0;
	else lsr3_d14 <= #1 lsr314;

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr3r14 <= #1 0;
	else lsr3r14 <= #1 lsr_mask14 ? 0 : lsr3r14 || (lsr314 && ~lsr3_d14); // set on rise14

// lsr14 bit 4 (break indicator14)
reg lsr4_d14; // delayed14

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr4_d14 <= #1 0;
	else lsr4_d14 <= #1 lsr414;

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr4r14 <= #1 0;
	else lsr4r14 <= #1 lsr_mask14 ? 0 : lsr4r14 || (lsr414 && ~lsr4_d14);

// lsr14 bit 5 (transmitter14 fifo is empty14)
reg lsr5_d14;

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr5_d14 <= #1 1;
	else lsr5_d14 <= #1 lsr514;

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr5r14 <= #1 1;
	else lsr5r14 <= #1 (fifo_write14) ? 0 :  lsr5r14 || (lsr514 && ~lsr5_d14);

// lsr14 bit 6 (transmitter14 empty14 indicator14)
reg lsr6_d14;

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr6_d14 <= #1 1;
	else lsr6_d14 <= #1 lsr614;

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr6r14 <= #1 1;
	else lsr6r14 <= #1 (fifo_write14) ? 0 : lsr6r14 || (lsr614 && ~lsr6_d14);

// lsr14 bit 7 (error in fifo)
reg lsr7_d14;

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr7_d14 <= #1 0;
	else lsr7_d14 <= #1 lsr714;

always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) lsr7r14 <= #1 0;
	else lsr7r14 <= #1 lsr_mask14 ? 0 : lsr7r14 || (lsr714 && ~lsr7_d14);

// Frequency14 divider14
always @(posedge clk14 or posedge wb_rst_i14) 
begin
	if (wb_rst_i14)
		dlc14 <= #1 0;
	else
		if (start_dlc14 | ~ (|dlc14))
  			dlc14 <= #1 dl14 - 1;               // preset14 counter
		else
			dlc14 <= #1 dlc14 - 1;              // decrement counter
end

// Enable14 signal14 generation14 logic
always @(posedge clk14 or posedge wb_rst_i14)
begin
	if (wb_rst_i14)
		enable <= #1 1'b0;
	else
		if (|dl14 & ~(|dlc14))     // dl14>0 & dlc14==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying14 THRE14 status for one character14 cycle after a character14 is written14 to an empty14 fifo.
always @(lcr14)
  case (lcr14[3:0])
    4'b0000                             : block_value14 =  95; // 6 bits
    4'b0100                             : block_value14 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value14 = 111; // 7 bits
    4'b1100                             : block_value14 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value14 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value14 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value14 = 159; // 10 bits
    4'b1111                             : block_value14 = 175; // 11 bits
  endcase // case(lcr14[3:0])

// Counting14 time of one character14 minus14 stop bit
always @(posedge clk14 or posedge wb_rst_i14)
begin
  if (wb_rst_i14)
    block_cnt14 <= #1 8'd0;
  else
  if(lsr5r14 & fifo_write14)  // THRE14 bit set & write to fifo occured14
    block_cnt14 <= #1 block_value14;
  else
  if (enable & block_cnt14 != 8'b0)  // only work14 on enable times
    block_cnt14 <= #1 block_cnt14 - 1;  // decrement break counter
end // always of break condition detection14

// Generating14 THRE14 status enable signal14
assign thre_set_en14 = ~(|block_cnt14);


//
//	INTERRUPT14 LOGIC14
//

assign rls_int14  = ier14[`UART_IE_RLS14] && (lsr14[`UART_LS_OE14] || lsr14[`UART_LS_PE14] || lsr14[`UART_LS_FE14] || lsr14[`UART_LS_BI14]);
assign rda_int14  = ier14[`UART_IE_RDA14] && (rf_count14 >= {1'b0,trigger_level14});
assign thre_int14 = ier14[`UART_IE_THRE14] && lsr14[`UART_LS_TFE14];
assign ms_int14   = ier14[`UART_IE_MS14] && (| msr14[3:0]);
assign ti_int14   = ier14[`UART_IE_RDA14] && (counter_t14 == 10'b0) && (|rf_count14);

reg 	 rls_int_d14;
reg 	 thre_int_d14;
reg 	 ms_int_d14;
reg 	 ti_int_d14;
reg 	 rda_int_d14;

// delay lines14
always  @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) rls_int_d14 <= #1 0;
	else rls_int_d14 <= #1 rls_int14;

always  @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) rda_int_d14 <= #1 0;
	else rda_int_d14 <= #1 rda_int14;

always  @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) thre_int_d14 <= #1 0;
	else thre_int_d14 <= #1 thre_int14;

always  @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) ms_int_d14 <= #1 0;
	else ms_int_d14 <= #1 ms_int14;

always  @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) ti_int_d14 <= #1 0;
	else ti_int_d14 <= #1 ti_int14;

// rise14 detection14 signals14

wire 	 rls_int_rise14;
wire 	 thre_int_rise14;
wire 	 ms_int_rise14;
wire 	 ti_int_rise14;
wire 	 rda_int_rise14;

assign rda_int_rise14    = rda_int14 & ~rda_int_d14;
assign rls_int_rise14 	  = rls_int14 & ~rls_int_d14;
assign thre_int_rise14   = thre_int14 & ~thre_int_d14;
assign ms_int_rise14 	  = ms_int14 & ~ms_int_d14;
assign ti_int_rise14 	  = ti_int14 & ~ti_int_d14;

// interrupt14 pending flags14
reg 	rls_int_pnd14;
reg	rda_int_pnd14;
reg 	thre_int_pnd14;
reg 	ms_int_pnd14;
reg 	ti_int_pnd14;

// interrupt14 pending flags14 assignments14
always  @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) rls_int_pnd14 <= #1 0; 
	else 
		rls_int_pnd14 <= #1 lsr_mask14 ? 0 :  						// reset condition
							rls_int_rise14 ? 1 :						// latch14 condition
							rls_int_pnd14 && ier14[`UART_IE_RLS14];	// default operation14: remove if masked14

always  @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) rda_int_pnd14 <= #1 0; 
	else 
		rda_int_pnd14 <= #1 ((rf_count14 == {1'b0,trigger_level14}) && fifo_read14) ? 0 :  	// reset condition
							rda_int_rise14 ? 1 :						// latch14 condition
							rda_int_pnd14 && ier14[`UART_IE_RDA14];	// default operation14: remove if masked14

always  @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) thre_int_pnd14 <= #1 0; 
	else 
		thre_int_pnd14 <= #1 fifo_write14 || (iir_read14 & ~iir14[`UART_II_IP14] & iir14[`UART_II_II14] == `UART_II_THRE14)? 0 : 
							thre_int_rise14 ? 1 :
							thre_int_pnd14 && ier14[`UART_IE_THRE14];

always  @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) ms_int_pnd14 <= #1 0; 
	else 
		ms_int_pnd14 <= #1 msr_read14 ? 0 : 
							ms_int_rise14 ? 1 :
							ms_int_pnd14 && ier14[`UART_IE_MS14];

always  @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) ti_int_pnd14 <= #1 0; 
	else 
		ti_int_pnd14 <= #1 fifo_read14 ? 0 : 
							ti_int_rise14 ? 1 :
							ti_int_pnd14 && ier14[`UART_IE_RDA14];
// end of pending flags14

// INT_O14 logic
always @(posedge clk14 or posedge wb_rst_i14)
begin
	if (wb_rst_i14)	
		int_o14 <= #1 1'b0;
	else
		int_o14 <= #1 
					rls_int_pnd14		?	~lsr_mask14					:
					rda_int_pnd14		? 1								:
					ti_int_pnd14		? ~fifo_read14					:
					thre_int_pnd14	? !(fifo_write14 & iir_read14) :
					ms_int_pnd14		? ~msr_read14						:
					0;	// if no interrupt14 are pending
end


// Interrupt14 Identification14 register
always @(posedge clk14 or posedge wb_rst_i14)
begin
	if (wb_rst_i14)
		iir14 <= #1 1;
	else
	if (rls_int_pnd14)  // interrupt14 is pending
	begin
		iir14[`UART_II_II14] <= #1 `UART_II_RLS14;	// set identification14 register to correct14 value
		iir14[`UART_II_IP14] <= #1 1'b0;		// and clear the IIR14 bit 0 (interrupt14 pending)
	end else // the sequence of conditions14 determines14 priority of interrupt14 identification14
	if (rda_int14)
	begin
		iir14[`UART_II_II14] <= #1 `UART_II_RDA14;
		iir14[`UART_II_IP14] <= #1 1'b0;
	end
	else if (ti_int_pnd14)
	begin
		iir14[`UART_II_II14] <= #1 `UART_II_TI14;
		iir14[`UART_II_IP14] <= #1 1'b0;
	end
	else if (thre_int_pnd14)
	begin
		iir14[`UART_II_II14] <= #1 `UART_II_THRE14;
		iir14[`UART_II_IP14] <= #1 1'b0;
	end
	else if (ms_int_pnd14)
	begin
		iir14[`UART_II_II14] <= #1 `UART_II_MS14;
		iir14[`UART_II_IP14] <= #1 1'b0;
	end else	// no interrupt14 is pending
	begin
		iir14[`UART_II_II14] <= #1 0;
		iir14[`UART_II_IP14] <= #1 1'b1;
	end
end

endmodule
