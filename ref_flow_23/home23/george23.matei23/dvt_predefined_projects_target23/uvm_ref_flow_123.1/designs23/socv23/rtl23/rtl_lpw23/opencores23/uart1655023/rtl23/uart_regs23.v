//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs23.v                                                 ////
////                                                              ////
////                                                              ////
////  This23 file is part of the "UART23 16550 compatible23" project23    ////
////  http23://www23.opencores23.org23/cores23/uart1655023/                   ////
////                                                              ////
////  Documentation23 related23 to this project23:                      ////
////  - http23://www23.opencores23.org23/cores23/uart1655023/                 ////
////                                                              ////
////  Projects23 compatibility23:                                     ////
////  - WISHBONE23                                                  ////
////  RS23223 Protocol23                                              ////
////  16550D uart23 (mostly23 supported)                              ////
////                                                              ////
////  Overview23 (main23 Features23):                                   ////
////  Registers23 of the uart23 16550 core23                            ////
////                                                              ////
////  Known23 problems23 (limits23):                                    ////
////  Inserts23 1 wait state in all WISHBONE23 transfers23              ////
////                                                              ////
////  To23 Do23:                                                      ////
////  Nothing or verification23.                                    ////
////                                                              ////
////  Author23(s):                                                  ////
////      - gorban23@opencores23.org23                                  ////
////      - Jacob23 Gorban23                                          ////
////      - Igor23 Mohor23 (igorm23@opencores23.org23)                      ////
////                                                              ////
////  Created23:        2001/05/12                                  ////
////  Last23 Updated23:   (See log23 for the revision23 history23           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2000, 2001 Authors23                             ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS23 Revision23 History23
//
// $Log: not supported by cvs2svn23 $
// Revision23 1.41  2004/05/21 11:44:41  tadejm23
// Added23 synchronizer23 flops23 for RX23 input.
//
// Revision23 1.40  2003/06/11 16:37:47  gorban23
// This23 fixes23 errors23 in some23 cases23 when data is being read and put to the FIFO at the same time. Patch23 is submitted23 by Scott23 Furman23. Update is very23 recommended23.
//
// Revision23 1.39  2002/07/29 21:16:18  gorban23
// The uart_defines23.v file is included23 again23 in sources23.
//
// Revision23 1.38  2002/07/22 23:02:23  gorban23
// Bug23 Fixes23:
//  * Possible23 loss of sync and bad23 reception23 of stop bit on slow23 baud23 rates23 fixed23.
//   Problem23 reported23 by Kenny23.Tung23.
//  * Bad (or lack23 of ) loopback23 handling23 fixed23. Reported23 by Cherry23 Withers23.
//
// Improvements23:
//  * Made23 FIFO's as general23 inferrable23 memory where possible23.
//  So23 on FPGA23 they should be inferred23 as RAM23 (Distributed23 RAM23 on Xilinx23).
//  This23 saves23 about23 1/3 of the Slice23 count and reduces23 P&R and synthesis23 times.
//
//  * Added23 optional23 baudrate23 output (baud_o23).
//  This23 is identical23 to BAUDOUT23* signal23 on 16550 chip23.
//  It outputs23 16xbit_clock_rate - the divided23 clock23.
//  It's disabled by default. Define23 UART_HAS_BAUDRATE_OUTPUT23 to use.
//
// Revision23 1.37  2001/12/27 13:24:09  mohor23
// lsr23[7] was not showing23 overrun23 errors23.
//
// Revision23 1.36  2001/12/20 13:25:46  mohor23
// rx23 push23 changed to be only one cycle wide23.
//
// Revision23 1.35  2001/12/19 08:03:34  mohor23
// Warnings23 cleared23.
//
// Revision23 1.34  2001/12/19 07:33:54  mohor23
// Synplicity23 was having23 troubles23 with the comment23.
//
// Revision23 1.33  2001/12/17 10:14:43  mohor23
// Things23 related23 to msr23 register changed. After23 THRE23 IRQ23 occurs23, and one
// character23 is written23 to the transmit23 fifo, the detection23 of the THRE23 bit in the
// LSR23 is delayed23 for one character23 time.
//
// Revision23 1.32  2001/12/14 13:19:24  mohor23
// MSR23 register fixed23.
//
// Revision23 1.31  2001/12/14 10:06:58  mohor23
// After23 reset modem23 status register MSR23 should be reset.
//
// Revision23 1.30  2001/12/13 10:09:13  mohor23
// thre23 irq23 should be cleared23 only when being source23 of interrupt23.
//
// Revision23 1.29  2001/12/12 09:05:46  mohor23
// LSR23 status bit 0 was not cleared23 correctly in case of reseting23 the FCR23 (rx23 fifo).
//
// Revision23 1.28  2001/12/10 19:52:41  gorban23
// Scratch23 register added
//
// Revision23 1.27  2001/12/06 14:51:04  gorban23
// Bug23 in LSR23[0] is fixed23.
// All WISHBONE23 signals23 are now sampled23, so another23 wait-state is introduced23 on all transfers23.
//
// Revision23 1.26  2001/12/03 21:44:29  gorban23
// Updated23 specification23 documentation.
// Added23 full 32-bit data bus interface, now as default.
// Address is 5-bit wide23 in 32-bit data bus mode.
// Added23 wb_sel_i23 input to the core23. It's used in the 32-bit mode.
// Added23 debug23 interface with two23 32-bit read-only registers in 32-bit mode.
// Bits23 5 and 6 of LSR23 are now only cleared23 on TX23 FIFO write.
// My23 small test bench23 is modified to work23 with 32-bit mode.
//
// Revision23 1.25  2001/11/28 19:36:39  gorban23
// Fixed23: timeout and break didn23't pay23 attention23 to current data format23 when counting23 time
//
// Revision23 1.24  2001/11/26 21:38:54  gorban23
// Lots23 of fixes23:
// Break23 condition wasn23't handled23 correctly at all.
// LSR23 bits could lose23 their23 values.
// LSR23 value after reset was wrong23.
// Timing23 of THRE23 interrupt23 signal23 corrected23.
// LSR23 bit 0 timing23 corrected23.
//
// Revision23 1.23  2001/11/12 21:57:29  gorban23
// fixed23 more typo23 bugs23
//
// Revision23 1.22  2001/11/12 15:02:28  mohor23
// lsr1r23 error fixed23.
//
// Revision23 1.21  2001/11/12 14:57:27  mohor23
// ti_int_pnd23 error fixed23.
//
// Revision23 1.20  2001/11/12 14:50:27  mohor23
// ti_int_d23 error fixed23.
//
// Revision23 1.19  2001/11/10 12:43:21  gorban23
// Logic23 Synthesis23 bugs23 fixed23. Some23 other minor23 changes23
//
// Revision23 1.18  2001/11/08 14:54:23  mohor23
// Comments23 in Slovene23 language23 deleted23, few23 small fixes23 for better23 work23 of
// old23 tools23. IRQs23 need to be fix23.
//
// Revision23 1.17  2001/11/07 17:51:52  gorban23
// Heavily23 rewritten23 interrupt23 and LSR23 subsystems23.
// Many23 bugs23 hopefully23 squashed23.
//
// Revision23 1.16  2001/11/02 09:55:16  mohor23
// no message
//
// Revision23 1.15  2001/10/31 15:19:22  gorban23
// Fixes23 to break and timeout conditions23
//
// Revision23 1.14  2001/10/29 17:00:46  gorban23
// fixed23 parity23 sending23 and tx_fifo23 resets23 over- and underrun23
//
// Revision23 1.13  2001/10/20 09:58:40  gorban23
// Small23 synopsis23 fixes23
//
// Revision23 1.12  2001/10/19 16:21:40  gorban23
// Changes23 data_out23 to be synchronous23 again23 as it should have been.
//
// Revision23 1.11  2001/10/18 20:35:45  gorban23
// small fix23
//
// Revision23 1.10  2001/08/24 21:01:12  mohor23
// Things23 connected23 to parity23 changed.
// Clock23 devider23 changed.
//
// Revision23 1.9  2001/08/23 16:05:05  mohor23
// Stop bit bug23 fixed23.
// Parity23 bug23 fixed23.
// WISHBONE23 read cycle bug23 fixed23,
// OE23 indicator23 (Overrun23 Error) bug23 fixed23.
// PE23 indicator23 (Parity23 Error) bug23 fixed23.
// Register read bug23 fixed23.
//
// Revision23 1.10  2001/06/23 11:21:48  gorban23
// DL23 made23 16-bit long23. Fixed23 transmission23/reception23 bugs23.
//
// Revision23 1.9  2001/05/31 20:08:01  gorban23
// FIFO changes23 and other corrections23.
//
// Revision23 1.8  2001/05/29 20:05:04  gorban23
// Fixed23 some23 bugs23 and synthesis23 problems23.
//
// Revision23 1.7  2001/05/27 17:37:49  gorban23
// Fixed23 many23 bugs23. Updated23 spec23. Changed23 FIFO files structure23. See CHANGES23.txt23 file.
//
// Revision23 1.6  2001/05/21 19:12:02  gorban23
// Corrected23 some23 Linter23 messages23.
//
// Revision23 1.5  2001/05/17 18:34:18  gorban23
// First23 'stable' release. Should23 be sythesizable23 now. Also23 added new header.
//
// Revision23 1.0  2001-05-17 21:27:11+02  jacob23
// Initial23 revision23
//
//

// synopsys23 translate_off23
`include "timescale.v"
// synopsys23 translate_on23

`include "uart_defines23.v"

`define UART_DL123 7:0
`define UART_DL223 15:8

module uart_regs23 (clk23,
	wb_rst_i23, wb_addr_i23, wb_dat_i23, wb_dat_o23, wb_we_i23, wb_re_i23, 

// additional23 signals23
	modem_inputs23,
	stx_pad_o23, srx_pad_i23,

`ifdef DATA_BUS_WIDTH_823
`else
// debug23 interface signals23	enabled
ier23, iir23, fcr23, mcr23, lcr23, msr23, lsr23, rf_count23, tf_count23, tstate23, rstate,
`endif				
	rts_pad_o23, dtr_pad_o23, int_o23
`ifdef UART_HAS_BAUDRATE_OUTPUT23
	, baud_o23
`endif

	);

input 									clk23;
input 									wb_rst_i23;
input [`UART_ADDR_WIDTH23-1:0] 		wb_addr_i23;
input [7:0] 							wb_dat_i23;
output [7:0] 							wb_dat_o23;
input 									wb_we_i23;
input 									wb_re_i23;

output 									stx_pad_o23;
input 									srx_pad_i23;

input [3:0] 							modem_inputs23;
output 									rts_pad_o23;
output 									dtr_pad_o23;
output 									int_o23;
`ifdef UART_HAS_BAUDRATE_OUTPUT23
output	baud_o23;
`endif

`ifdef DATA_BUS_WIDTH_823
`else
// if 32-bit databus23 and debug23 interface are enabled
output [3:0]							ier23;
output [3:0]							iir23;
output [1:0]							fcr23;  /// bits 7 and 6 of fcr23. Other23 bits are ignored
output [4:0]							mcr23;
output [7:0]							lcr23;
output [7:0]							msr23;
output [7:0] 							lsr23;
output [`UART_FIFO_COUNTER_W23-1:0] 	rf_count23;
output [`UART_FIFO_COUNTER_W23-1:0] 	tf_count23;
output [2:0] 							tstate23;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs23;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT23
assign baud_o23 = enable; // baud_o23 is actually23 the enable signal23
`endif


wire 										stx_pad_o23;		// received23 from transmitter23 module
wire 										srx_pad_i23;
wire 										srx_pad23;

reg [7:0] 								wb_dat_o23;

wire [`UART_ADDR_WIDTH23-1:0] 		wb_addr_i23;
wire [7:0] 								wb_dat_i23;


reg [3:0] 								ier23;
reg [3:0] 								iir23;
reg [1:0] 								fcr23;  /// bits 7 and 6 of fcr23. Other23 bits are ignored
reg [4:0] 								mcr23;
reg [7:0] 								lcr23;
reg [7:0] 								msr23;
reg [15:0] 								dl23;  // 32-bit divisor23 latch23
reg [7:0] 								scratch23; // UART23 scratch23 register
reg 										start_dlc23; // activate23 dlc23 on writing to UART_DL123
reg 										lsr_mask_d23; // delay for lsr_mask23 condition
reg 										msi_reset23; // reset MSR23 4 lower23 bits indicator23
//reg 										threi_clear23; // THRE23 interrupt23 clear flag23
reg [15:0] 								dlc23;  // 32-bit divisor23 latch23 counter
reg 										int_o23;

reg [3:0] 								trigger_level23; // trigger level of the receiver23 FIFO
reg 										rx_reset23;
reg 										tx_reset23;

wire 										dlab23;			   // divisor23 latch23 access bit
wire 										cts_pad_i23, dsr_pad_i23, ri_pad_i23, dcd_pad_i23; // modem23 status bits
wire 										loopback23;		   // loopback23 bit (MCR23 bit 4)
wire 										cts23, dsr23, ri, dcd23;	   // effective23 signals23
wire                    cts_c23, dsr_c23, ri_c23, dcd_c23; // Complement23 effective23 signals23 (considering23 loopback23)
wire 										rts_pad_o23, dtr_pad_o23;		   // modem23 control23 outputs23

// LSR23 bits wires23 and regs
wire [7:0] 								lsr23;
wire 										lsr023, lsr123, lsr223, lsr323, lsr423, lsr523, lsr623, lsr723;
reg										lsr0r23, lsr1r23, lsr2r23, lsr3r23, lsr4r23, lsr5r23, lsr6r23, lsr7r23;
wire 										lsr_mask23; // lsr_mask23

//
// ASSINGS23
//

assign 									lsr23[7:0] = { lsr7r23, lsr6r23, lsr5r23, lsr4r23, lsr3r23, lsr2r23, lsr1r23, lsr0r23 };

assign 									{cts_pad_i23, dsr_pad_i23, ri_pad_i23, dcd_pad_i23} = modem_inputs23;
assign 									{cts23, dsr23, ri, dcd23} = ~{cts_pad_i23,dsr_pad_i23,ri_pad_i23,dcd_pad_i23};

assign                  {cts_c23, dsr_c23, ri_c23, dcd_c23} = loopback23 ? {mcr23[`UART_MC_RTS23],mcr23[`UART_MC_DTR23],mcr23[`UART_MC_OUT123],mcr23[`UART_MC_OUT223]}
                                                               : {cts_pad_i23,dsr_pad_i23,ri_pad_i23,dcd_pad_i23};

assign 									dlab23 = lcr23[`UART_LC_DL23];
assign 									loopback23 = mcr23[4];

// assign modem23 outputs23
assign 									rts_pad_o23 = mcr23[`UART_MC_RTS23];
assign 									dtr_pad_o23 = mcr23[`UART_MC_DTR23];

// Interrupt23 signals23
wire 										rls_int23;  // receiver23 line status interrupt23
wire 										rda_int23;  // receiver23 data available interrupt23
wire 										ti_int23;   // timeout indicator23 interrupt23
wire										thre_int23; // transmitter23 holding23 register empty23 interrupt23
wire 										ms_int23;   // modem23 status interrupt23

// FIFO signals23
reg 										tf_push23;
reg 										rf_pop23;
wire [`UART_FIFO_REC_WIDTH23-1:0] 	rf_data_out23;
wire 										rf_error_bit23; // an error (parity23 or framing23) is inside the fifo
wire [`UART_FIFO_COUNTER_W23-1:0] 	rf_count23;
wire [`UART_FIFO_COUNTER_W23-1:0] 	tf_count23;
wire [2:0] 								tstate23;
wire [3:0] 								rstate;
wire [9:0] 								counter_t23;

wire                      thre_set_en23; // THRE23 status is delayed23 one character23 time when a character23 is written23 to fifo.
reg  [7:0]                block_cnt23;   // While23 counter counts23, THRE23 status is blocked23 (delayed23 one character23 cycle)
reg  [7:0]                block_value23; // One23 character23 length minus23 stop bit

// Transmitter23 Instance
wire serial_out23;

uart_transmitter23 transmitter23(clk23, wb_rst_i23, lcr23, tf_push23, wb_dat_i23, enable, serial_out23, tstate23, tf_count23, tx_reset23, lsr_mask23);

  // Synchronizing23 and sampling23 serial23 RX23 input
  uart_sync_flops23    i_uart_sync_flops23
  (
    .rst_i23           (wb_rst_i23),
    .clk_i23           (clk23),
    .stage1_rst_i23    (1'b0),
    .stage1_clk_en_i23 (1'b1),
    .async_dat_i23     (srx_pad_i23),
    .sync_dat_o23      (srx_pad23)
  );
  defparam i_uart_sync_flops23.width      = 1;
  defparam i_uart_sync_flops23.init_value23 = 1'b1;

// handle loopback23
wire serial_in23 = loopback23 ? serial_out23 : srx_pad23;
assign stx_pad_o23 = loopback23 ? 1'b1 : serial_out23;

// Receiver23 Instance
uart_receiver23 receiver23(clk23, wb_rst_i23, lcr23, rf_pop23, serial_in23, enable, 
	counter_t23, rf_count23, rf_data_out23, rf_error_bit23, rf_overrun23, rx_reset23, lsr_mask23, rstate, rf_push_pulse23);


// Asynchronous23 reading here23 because the outputs23 are sampled23 in uart_wb23.v file 
always @(dl23 or dlab23 or ier23 or iir23 or scratch23
			or lcr23 or lsr23 or msr23 or rf_data_out23 or wb_addr_i23 or wb_re_i23)   // asynchrounous23 reading
begin
	case (wb_addr_i23)
		`UART_REG_RB23   : wb_dat_o23 = dlab23 ? dl23[`UART_DL123] : rf_data_out23[10:3];
		`UART_REG_IE23	: wb_dat_o23 = dlab23 ? dl23[`UART_DL223] : ier23;
		`UART_REG_II23	: wb_dat_o23 = {4'b1100,iir23};
		`UART_REG_LC23	: wb_dat_o23 = lcr23;
		`UART_REG_LS23	: wb_dat_o23 = lsr23;
		`UART_REG_MS23	: wb_dat_o23 = msr23;
		`UART_REG_SR23	: wb_dat_o23 = scratch23;
		default:  wb_dat_o23 = 8'b0; // ??
	endcase // case(wb_addr_i23)
end // always @ (dl23 or dlab23 or ier23 or iir23 or scratch23...


// rf_pop23 signal23 handling23
always @(posedge clk23 or posedge wb_rst_i23)
begin
	if (wb_rst_i23)
		rf_pop23 <= #1 0; 
	else
	if (rf_pop23)	// restore23 the signal23 to 0 after one clock23 cycle
		rf_pop23 <= #1 0;
	else
	if (wb_re_i23 && wb_addr_i23 == `UART_REG_RB23 && !dlab23)
		rf_pop23 <= #1 1; // advance23 read pointer23
end

wire 	lsr_mask_condition23;
wire 	iir_read23;
wire  msr_read23;
wire	fifo_read23;
wire	fifo_write23;

assign lsr_mask_condition23 = (wb_re_i23 && wb_addr_i23 == `UART_REG_LS23 && !dlab23);
assign iir_read23 = (wb_re_i23 && wb_addr_i23 == `UART_REG_II23 && !dlab23);
assign msr_read23 = (wb_re_i23 && wb_addr_i23 == `UART_REG_MS23 && !dlab23);
assign fifo_read23 = (wb_re_i23 && wb_addr_i23 == `UART_REG_RB23 && !dlab23);
assign fifo_write23 = (wb_we_i23 && wb_addr_i23 == `UART_REG_TR23 && !dlab23);

// lsr_mask_d23 delayed23 signal23 handling23
always @(posedge clk23 or posedge wb_rst_i23)
begin
	if (wb_rst_i23)
		lsr_mask_d23 <= #1 0;
	else // reset bits in the Line23 Status Register
		lsr_mask_d23 <= #1 lsr_mask_condition23;
end

// lsr_mask23 is rise23 detected
assign lsr_mask23 = lsr_mask_condition23 && ~lsr_mask_d23;

// msi_reset23 signal23 handling23
always @(posedge clk23 or posedge wb_rst_i23)
begin
	if (wb_rst_i23)
		msi_reset23 <= #1 1;
	else
	if (msi_reset23)
		msi_reset23 <= #1 0;
	else
	if (msr_read23)
		msi_reset23 <= #1 1; // reset bits in Modem23 Status Register
end


//
//   WRITES23 AND23 RESETS23   //
//
// Line23 Control23 Register
always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23)
		lcr23 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i23 && wb_addr_i23==`UART_REG_LC23)
		lcr23 <= #1 wb_dat_i23;

// Interrupt23 Enable23 Register or UART_DL223
always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23)
	begin
		ier23 <= #1 4'b0000; // no interrupts23 after reset
		dl23[`UART_DL223] <= #1 8'b0;
	end
	else
	if (wb_we_i23 && wb_addr_i23==`UART_REG_IE23)
		if (dlab23)
		begin
			dl23[`UART_DL223] <= #1 wb_dat_i23;
		end
		else
			ier23 <= #1 wb_dat_i23[3:0]; // ier23 uses only 4 lsb


// FIFO Control23 Register and rx_reset23, tx_reset23 signals23
always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) begin
		fcr23 <= #1 2'b11; 
		rx_reset23 <= #1 0;
		tx_reset23 <= #1 0;
	end else
	if (wb_we_i23 && wb_addr_i23==`UART_REG_FC23) begin
		fcr23 <= #1 wb_dat_i23[7:6];
		rx_reset23 <= #1 wb_dat_i23[1];
		tx_reset23 <= #1 wb_dat_i23[2];
	end else begin
		rx_reset23 <= #1 0;
		tx_reset23 <= #1 0;
	end

// Modem23 Control23 Register
always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23)
		mcr23 <= #1 5'b0; 
	else
	if (wb_we_i23 && wb_addr_i23==`UART_REG_MC23)
			mcr23 <= #1 wb_dat_i23[4:0];

// Scratch23 register
// Line23 Control23 Register
always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23)
		scratch23 <= #1 0; // 8n1 setting
	else
	if (wb_we_i23 && wb_addr_i23==`UART_REG_SR23)
		scratch23 <= #1 wb_dat_i23;

// TX_FIFO23 or UART_DL123
always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23)
	begin
		dl23[`UART_DL123]  <= #1 8'b0;
		tf_push23   <= #1 1'b0;
		start_dlc23 <= #1 1'b0;
	end
	else
	if (wb_we_i23 && wb_addr_i23==`UART_REG_TR23)
		if (dlab23)
		begin
			dl23[`UART_DL123] <= #1 wb_dat_i23;
			start_dlc23 <= #1 1'b1; // enable DL23 counter
			tf_push23 <= #1 1'b0;
		end
		else
		begin
			tf_push23   <= #1 1'b1;
			start_dlc23 <= #1 1'b0;
		end // else: !if(dlab23)
	else
	begin
		start_dlc23 <= #1 1'b0;
		tf_push23   <= #1 1'b0;
	end // else: !if(dlab23)

// Receiver23 FIFO trigger level selection logic (asynchronous23 mux23)
always @(fcr23)
	case (fcr23[`UART_FC_TL23])
		2'b00 : trigger_level23 = 1;
		2'b01 : trigger_level23 = 4;
		2'b10 : trigger_level23 = 8;
		2'b11 : trigger_level23 = 14;
	endcase // case(fcr23[`UART_FC_TL23])
	
//
//  STATUS23 REGISTERS23  //
//

// Modem23 Status Register
reg [3:0] delayed_modem_signals23;
always @(posedge clk23 or posedge wb_rst_i23)
begin
	if (wb_rst_i23)
	  begin
  		msr23 <= #1 0;
	  	delayed_modem_signals23[3:0] <= #1 0;
	  end
	else begin
		msr23[`UART_MS_DDCD23:`UART_MS_DCTS23] <= #1 msi_reset23 ? 4'b0 :
			msr23[`UART_MS_DDCD23:`UART_MS_DCTS23] | ({dcd23, ri, dsr23, cts23} ^ delayed_modem_signals23[3:0]);
		msr23[`UART_MS_CDCD23:`UART_MS_CCTS23] <= #1 {dcd_c23, ri_c23, dsr_c23, cts_c23};
		delayed_modem_signals23[3:0] <= #1 {dcd23, ri, dsr23, cts23};
	end
end


// Line23 Status Register

// activation23 conditions23
assign lsr023 = (rf_count23==0 && rf_push_pulse23);  // data in receiver23 fifo available set condition
assign lsr123 = rf_overrun23;     // Receiver23 overrun23 error
assign lsr223 = rf_data_out23[1]; // parity23 error bit
assign lsr323 = rf_data_out23[0]; // framing23 error bit
assign lsr423 = rf_data_out23[2]; // break error in the character23
assign lsr523 = (tf_count23==5'b0 && thre_set_en23);  // transmitter23 fifo is empty23
assign lsr623 = (tf_count23==5'b0 && thre_set_en23 && (tstate23 == /*`S_IDLE23 */ 0)); // transmitter23 empty23
assign lsr723 = rf_error_bit23 | rf_overrun23;

// lsr23 bit023 (receiver23 data available)
reg 	 lsr0_d23;

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr0_d23 <= #1 0;
	else lsr0_d23 <= #1 lsr023;

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr0r23 <= #1 0;
	else lsr0r23 <= #1 (rf_count23==1 && rf_pop23 && !rf_push_pulse23 || rx_reset23) ? 0 : // deassert23 condition
					  lsr0r23 || (lsr023 && ~lsr0_d23); // set on rise23 of lsr023 and keep23 asserted23 until deasserted23 

// lsr23 bit 1 (receiver23 overrun23)
reg lsr1_d23; // delayed23

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr1_d23 <= #1 0;
	else lsr1_d23 <= #1 lsr123;

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr1r23 <= #1 0;
	else	lsr1r23 <= #1	lsr_mask23 ? 0 : lsr1r23 || (lsr123 && ~lsr1_d23); // set on rise23

// lsr23 bit 2 (parity23 error)
reg lsr2_d23; // delayed23

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr2_d23 <= #1 0;
	else lsr2_d23 <= #1 lsr223;

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr2r23 <= #1 0;
	else lsr2r23 <= #1 lsr_mask23 ? 0 : lsr2r23 || (lsr223 && ~lsr2_d23); // set on rise23

// lsr23 bit 3 (framing23 error)
reg lsr3_d23; // delayed23

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr3_d23 <= #1 0;
	else lsr3_d23 <= #1 lsr323;

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr3r23 <= #1 0;
	else lsr3r23 <= #1 lsr_mask23 ? 0 : lsr3r23 || (lsr323 && ~lsr3_d23); // set on rise23

// lsr23 bit 4 (break indicator23)
reg lsr4_d23; // delayed23

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr4_d23 <= #1 0;
	else lsr4_d23 <= #1 lsr423;

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr4r23 <= #1 0;
	else lsr4r23 <= #1 lsr_mask23 ? 0 : lsr4r23 || (lsr423 && ~lsr4_d23);

// lsr23 bit 5 (transmitter23 fifo is empty23)
reg lsr5_d23;

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr5_d23 <= #1 1;
	else lsr5_d23 <= #1 lsr523;

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr5r23 <= #1 1;
	else lsr5r23 <= #1 (fifo_write23) ? 0 :  lsr5r23 || (lsr523 && ~lsr5_d23);

// lsr23 bit 6 (transmitter23 empty23 indicator23)
reg lsr6_d23;

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr6_d23 <= #1 1;
	else lsr6_d23 <= #1 lsr623;

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr6r23 <= #1 1;
	else lsr6r23 <= #1 (fifo_write23) ? 0 : lsr6r23 || (lsr623 && ~lsr6_d23);

// lsr23 bit 7 (error in fifo)
reg lsr7_d23;

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr7_d23 <= #1 0;
	else lsr7_d23 <= #1 lsr723;

always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) lsr7r23 <= #1 0;
	else lsr7r23 <= #1 lsr_mask23 ? 0 : lsr7r23 || (lsr723 && ~lsr7_d23);

// Frequency23 divider23
always @(posedge clk23 or posedge wb_rst_i23) 
begin
	if (wb_rst_i23)
		dlc23 <= #1 0;
	else
		if (start_dlc23 | ~ (|dlc23))
  			dlc23 <= #1 dl23 - 1;               // preset23 counter
		else
			dlc23 <= #1 dlc23 - 1;              // decrement counter
end

// Enable23 signal23 generation23 logic
always @(posedge clk23 or posedge wb_rst_i23)
begin
	if (wb_rst_i23)
		enable <= #1 1'b0;
	else
		if (|dl23 & ~(|dlc23))     // dl23>0 & dlc23==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying23 THRE23 status for one character23 cycle after a character23 is written23 to an empty23 fifo.
always @(lcr23)
  case (lcr23[3:0])
    4'b0000                             : block_value23 =  95; // 6 bits
    4'b0100                             : block_value23 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value23 = 111; // 7 bits
    4'b1100                             : block_value23 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value23 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value23 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value23 = 159; // 10 bits
    4'b1111                             : block_value23 = 175; // 11 bits
  endcase // case(lcr23[3:0])

// Counting23 time of one character23 minus23 stop bit
always @(posedge clk23 or posedge wb_rst_i23)
begin
  if (wb_rst_i23)
    block_cnt23 <= #1 8'd0;
  else
  if(lsr5r23 & fifo_write23)  // THRE23 bit set & write to fifo occured23
    block_cnt23 <= #1 block_value23;
  else
  if (enable & block_cnt23 != 8'b0)  // only work23 on enable times
    block_cnt23 <= #1 block_cnt23 - 1;  // decrement break counter
end // always of break condition detection23

// Generating23 THRE23 status enable signal23
assign thre_set_en23 = ~(|block_cnt23);


//
//	INTERRUPT23 LOGIC23
//

assign rls_int23  = ier23[`UART_IE_RLS23] && (lsr23[`UART_LS_OE23] || lsr23[`UART_LS_PE23] || lsr23[`UART_LS_FE23] || lsr23[`UART_LS_BI23]);
assign rda_int23  = ier23[`UART_IE_RDA23] && (rf_count23 >= {1'b0,trigger_level23});
assign thre_int23 = ier23[`UART_IE_THRE23] && lsr23[`UART_LS_TFE23];
assign ms_int23   = ier23[`UART_IE_MS23] && (| msr23[3:0]);
assign ti_int23   = ier23[`UART_IE_RDA23] && (counter_t23 == 10'b0) && (|rf_count23);

reg 	 rls_int_d23;
reg 	 thre_int_d23;
reg 	 ms_int_d23;
reg 	 ti_int_d23;
reg 	 rda_int_d23;

// delay lines23
always  @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) rls_int_d23 <= #1 0;
	else rls_int_d23 <= #1 rls_int23;

always  @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) rda_int_d23 <= #1 0;
	else rda_int_d23 <= #1 rda_int23;

always  @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) thre_int_d23 <= #1 0;
	else thre_int_d23 <= #1 thre_int23;

always  @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) ms_int_d23 <= #1 0;
	else ms_int_d23 <= #1 ms_int23;

always  @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) ti_int_d23 <= #1 0;
	else ti_int_d23 <= #1 ti_int23;

// rise23 detection23 signals23

wire 	 rls_int_rise23;
wire 	 thre_int_rise23;
wire 	 ms_int_rise23;
wire 	 ti_int_rise23;
wire 	 rda_int_rise23;

assign rda_int_rise23    = rda_int23 & ~rda_int_d23;
assign rls_int_rise23 	  = rls_int23 & ~rls_int_d23;
assign thre_int_rise23   = thre_int23 & ~thre_int_d23;
assign ms_int_rise23 	  = ms_int23 & ~ms_int_d23;
assign ti_int_rise23 	  = ti_int23 & ~ti_int_d23;

// interrupt23 pending flags23
reg 	rls_int_pnd23;
reg	rda_int_pnd23;
reg 	thre_int_pnd23;
reg 	ms_int_pnd23;
reg 	ti_int_pnd23;

// interrupt23 pending flags23 assignments23
always  @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) rls_int_pnd23 <= #1 0; 
	else 
		rls_int_pnd23 <= #1 lsr_mask23 ? 0 :  						// reset condition
							rls_int_rise23 ? 1 :						// latch23 condition
							rls_int_pnd23 && ier23[`UART_IE_RLS23];	// default operation23: remove if masked23

always  @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) rda_int_pnd23 <= #1 0; 
	else 
		rda_int_pnd23 <= #1 ((rf_count23 == {1'b0,trigger_level23}) && fifo_read23) ? 0 :  	// reset condition
							rda_int_rise23 ? 1 :						// latch23 condition
							rda_int_pnd23 && ier23[`UART_IE_RDA23];	// default operation23: remove if masked23

always  @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) thre_int_pnd23 <= #1 0; 
	else 
		thre_int_pnd23 <= #1 fifo_write23 || (iir_read23 & ~iir23[`UART_II_IP23] & iir23[`UART_II_II23] == `UART_II_THRE23)? 0 : 
							thre_int_rise23 ? 1 :
							thre_int_pnd23 && ier23[`UART_IE_THRE23];

always  @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) ms_int_pnd23 <= #1 0; 
	else 
		ms_int_pnd23 <= #1 msr_read23 ? 0 : 
							ms_int_rise23 ? 1 :
							ms_int_pnd23 && ier23[`UART_IE_MS23];

always  @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) ti_int_pnd23 <= #1 0; 
	else 
		ti_int_pnd23 <= #1 fifo_read23 ? 0 : 
							ti_int_rise23 ? 1 :
							ti_int_pnd23 && ier23[`UART_IE_RDA23];
// end of pending flags23

// INT_O23 logic
always @(posedge clk23 or posedge wb_rst_i23)
begin
	if (wb_rst_i23)	
		int_o23 <= #1 1'b0;
	else
		int_o23 <= #1 
					rls_int_pnd23		?	~lsr_mask23					:
					rda_int_pnd23		? 1								:
					ti_int_pnd23		? ~fifo_read23					:
					thre_int_pnd23	? !(fifo_write23 & iir_read23) :
					ms_int_pnd23		? ~msr_read23						:
					0;	// if no interrupt23 are pending
end


// Interrupt23 Identification23 register
always @(posedge clk23 or posedge wb_rst_i23)
begin
	if (wb_rst_i23)
		iir23 <= #1 1;
	else
	if (rls_int_pnd23)  // interrupt23 is pending
	begin
		iir23[`UART_II_II23] <= #1 `UART_II_RLS23;	// set identification23 register to correct23 value
		iir23[`UART_II_IP23] <= #1 1'b0;		// and clear the IIR23 bit 0 (interrupt23 pending)
	end else // the sequence of conditions23 determines23 priority of interrupt23 identification23
	if (rda_int23)
	begin
		iir23[`UART_II_II23] <= #1 `UART_II_RDA23;
		iir23[`UART_II_IP23] <= #1 1'b0;
	end
	else if (ti_int_pnd23)
	begin
		iir23[`UART_II_II23] <= #1 `UART_II_TI23;
		iir23[`UART_II_IP23] <= #1 1'b0;
	end
	else if (thre_int_pnd23)
	begin
		iir23[`UART_II_II23] <= #1 `UART_II_THRE23;
		iir23[`UART_II_IP23] <= #1 1'b0;
	end
	else if (ms_int_pnd23)
	begin
		iir23[`UART_II_II23] <= #1 `UART_II_MS23;
		iir23[`UART_II_IP23] <= #1 1'b0;
	end else	// no interrupt23 is pending
	begin
		iir23[`UART_II_II23] <= #1 0;
		iir23[`UART_II_IP23] <= #1 1'b1;
	end
end

endmodule
