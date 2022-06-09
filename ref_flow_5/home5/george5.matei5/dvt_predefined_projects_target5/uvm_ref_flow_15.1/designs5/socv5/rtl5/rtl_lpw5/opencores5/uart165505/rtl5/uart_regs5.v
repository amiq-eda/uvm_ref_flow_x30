//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs5.v                                                 ////
////                                                              ////
////                                                              ////
////  This5 file is part of the "UART5 16550 compatible5" project5    ////
////  http5://www5.opencores5.org5/cores5/uart165505/                   ////
////                                                              ////
////  Documentation5 related5 to this project5:                      ////
////  - http5://www5.opencores5.org5/cores5/uart165505/                 ////
////                                                              ////
////  Projects5 compatibility5:                                     ////
////  - WISHBONE5                                                  ////
////  RS2325 Protocol5                                              ////
////  16550D uart5 (mostly5 supported)                              ////
////                                                              ////
////  Overview5 (main5 Features5):                                   ////
////  Registers5 of the uart5 16550 core5                            ////
////                                                              ////
////  Known5 problems5 (limits5):                                    ////
////  Inserts5 1 wait state in all WISHBONE5 transfers5              ////
////                                                              ////
////  To5 Do5:                                                      ////
////  Nothing or verification5.                                    ////
////                                                              ////
////  Author5(s):                                                  ////
////      - gorban5@opencores5.org5                                  ////
////      - Jacob5 Gorban5                                          ////
////      - Igor5 Mohor5 (igorm5@opencores5.org5)                      ////
////                                                              ////
////  Created5:        2001/05/12                                  ////
////  Last5 Updated5:   (See log5 for the revision5 history5           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2000, 2001 Authors5                             ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS5 Revision5 History5
//
// $Log: not supported by cvs2svn5 $
// Revision5 1.41  2004/05/21 11:44:41  tadejm5
// Added5 synchronizer5 flops5 for RX5 input.
//
// Revision5 1.40  2003/06/11 16:37:47  gorban5
// This5 fixes5 errors5 in some5 cases5 when data is being read and put to the FIFO at the same time. Patch5 is submitted5 by Scott5 Furman5. Update is very5 recommended5.
//
// Revision5 1.39  2002/07/29 21:16:18  gorban5
// The uart_defines5.v file is included5 again5 in sources5.
//
// Revision5 1.38  2002/07/22 23:02:23  gorban5
// Bug5 Fixes5:
//  * Possible5 loss of sync and bad5 reception5 of stop bit on slow5 baud5 rates5 fixed5.
//   Problem5 reported5 by Kenny5.Tung5.
//  * Bad (or lack5 of ) loopback5 handling5 fixed5. Reported5 by Cherry5 Withers5.
//
// Improvements5:
//  * Made5 FIFO's as general5 inferrable5 memory where possible5.
//  So5 on FPGA5 they should be inferred5 as RAM5 (Distributed5 RAM5 on Xilinx5).
//  This5 saves5 about5 1/3 of the Slice5 count and reduces5 P&R and synthesis5 times.
//
//  * Added5 optional5 baudrate5 output (baud_o5).
//  This5 is identical5 to BAUDOUT5* signal5 on 16550 chip5.
//  It outputs5 16xbit_clock_rate - the divided5 clock5.
//  It's disabled by default. Define5 UART_HAS_BAUDRATE_OUTPUT5 to use.
//
// Revision5 1.37  2001/12/27 13:24:09  mohor5
// lsr5[7] was not showing5 overrun5 errors5.
//
// Revision5 1.36  2001/12/20 13:25:46  mohor5
// rx5 push5 changed to be only one cycle wide5.
//
// Revision5 1.35  2001/12/19 08:03:34  mohor5
// Warnings5 cleared5.
//
// Revision5 1.34  2001/12/19 07:33:54  mohor5
// Synplicity5 was having5 troubles5 with the comment5.
//
// Revision5 1.33  2001/12/17 10:14:43  mohor5
// Things5 related5 to msr5 register changed. After5 THRE5 IRQ5 occurs5, and one
// character5 is written5 to the transmit5 fifo, the detection5 of the THRE5 bit in the
// LSR5 is delayed5 for one character5 time.
//
// Revision5 1.32  2001/12/14 13:19:24  mohor5
// MSR5 register fixed5.
//
// Revision5 1.31  2001/12/14 10:06:58  mohor5
// After5 reset modem5 status register MSR5 should be reset.
//
// Revision5 1.30  2001/12/13 10:09:13  mohor5
// thre5 irq5 should be cleared5 only when being source5 of interrupt5.
//
// Revision5 1.29  2001/12/12 09:05:46  mohor5
// LSR5 status bit 0 was not cleared5 correctly in case of reseting5 the FCR5 (rx5 fifo).
//
// Revision5 1.28  2001/12/10 19:52:41  gorban5
// Scratch5 register added
//
// Revision5 1.27  2001/12/06 14:51:04  gorban5
// Bug5 in LSR5[0] is fixed5.
// All WISHBONE5 signals5 are now sampled5, so another5 wait-state is introduced5 on all transfers5.
//
// Revision5 1.26  2001/12/03 21:44:29  gorban5
// Updated5 specification5 documentation.
// Added5 full 32-bit data bus interface, now as default.
// Address is 5-bit wide5 in 32-bit data bus mode.
// Added5 wb_sel_i5 input to the core5. It's used in the 32-bit mode.
// Added5 debug5 interface with two5 32-bit read-only registers in 32-bit mode.
// Bits5 5 and 6 of LSR5 are now only cleared5 on TX5 FIFO write.
// My5 small test bench5 is modified to work5 with 32-bit mode.
//
// Revision5 1.25  2001/11/28 19:36:39  gorban5
// Fixed5: timeout and break didn5't pay5 attention5 to current data format5 when counting5 time
//
// Revision5 1.24  2001/11/26 21:38:54  gorban5
// Lots5 of fixes5:
// Break5 condition wasn5't handled5 correctly at all.
// LSR5 bits could lose5 their5 values.
// LSR5 value after reset was wrong5.
// Timing5 of THRE5 interrupt5 signal5 corrected5.
// LSR5 bit 0 timing5 corrected5.
//
// Revision5 1.23  2001/11/12 21:57:29  gorban5
// fixed5 more typo5 bugs5
//
// Revision5 1.22  2001/11/12 15:02:28  mohor5
// lsr1r5 error fixed5.
//
// Revision5 1.21  2001/11/12 14:57:27  mohor5
// ti_int_pnd5 error fixed5.
//
// Revision5 1.20  2001/11/12 14:50:27  mohor5
// ti_int_d5 error fixed5.
//
// Revision5 1.19  2001/11/10 12:43:21  gorban5
// Logic5 Synthesis5 bugs5 fixed5. Some5 other minor5 changes5
//
// Revision5 1.18  2001/11/08 14:54:23  mohor5
// Comments5 in Slovene5 language5 deleted5, few5 small fixes5 for better5 work5 of
// old5 tools5. IRQs5 need to be fix5.
//
// Revision5 1.17  2001/11/07 17:51:52  gorban5
// Heavily5 rewritten5 interrupt5 and LSR5 subsystems5.
// Many5 bugs5 hopefully5 squashed5.
//
// Revision5 1.16  2001/11/02 09:55:16  mohor5
// no message
//
// Revision5 1.15  2001/10/31 15:19:22  gorban5
// Fixes5 to break and timeout conditions5
//
// Revision5 1.14  2001/10/29 17:00:46  gorban5
// fixed5 parity5 sending5 and tx_fifo5 resets5 over- and underrun5
//
// Revision5 1.13  2001/10/20 09:58:40  gorban5
// Small5 synopsis5 fixes5
//
// Revision5 1.12  2001/10/19 16:21:40  gorban5
// Changes5 data_out5 to be synchronous5 again5 as it should have been.
//
// Revision5 1.11  2001/10/18 20:35:45  gorban5
// small fix5
//
// Revision5 1.10  2001/08/24 21:01:12  mohor5
// Things5 connected5 to parity5 changed.
// Clock5 devider5 changed.
//
// Revision5 1.9  2001/08/23 16:05:05  mohor5
// Stop bit bug5 fixed5.
// Parity5 bug5 fixed5.
// WISHBONE5 read cycle bug5 fixed5,
// OE5 indicator5 (Overrun5 Error) bug5 fixed5.
// PE5 indicator5 (Parity5 Error) bug5 fixed5.
// Register read bug5 fixed5.
//
// Revision5 1.10  2001/06/23 11:21:48  gorban5
// DL5 made5 16-bit long5. Fixed5 transmission5/reception5 bugs5.
//
// Revision5 1.9  2001/05/31 20:08:01  gorban5
// FIFO changes5 and other corrections5.
//
// Revision5 1.8  2001/05/29 20:05:04  gorban5
// Fixed5 some5 bugs5 and synthesis5 problems5.
//
// Revision5 1.7  2001/05/27 17:37:49  gorban5
// Fixed5 many5 bugs5. Updated5 spec5. Changed5 FIFO files structure5. See CHANGES5.txt5 file.
//
// Revision5 1.6  2001/05/21 19:12:02  gorban5
// Corrected5 some5 Linter5 messages5.
//
// Revision5 1.5  2001/05/17 18:34:18  gorban5
// First5 'stable' release. Should5 be sythesizable5 now. Also5 added new header.
//
// Revision5 1.0  2001-05-17 21:27:11+02  jacob5
// Initial5 revision5
//
//

// synopsys5 translate_off5
`include "timescale.v"
// synopsys5 translate_on5

`include "uart_defines5.v"

`define UART_DL15 7:0
`define UART_DL25 15:8

module uart_regs5 (clk5,
	wb_rst_i5, wb_addr_i5, wb_dat_i5, wb_dat_o5, wb_we_i5, wb_re_i5, 

// additional5 signals5
	modem_inputs5,
	stx_pad_o5, srx_pad_i5,

`ifdef DATA_BUS_WIDTH_85
`else
// debug5 interface signals5	enabled
ier5, iir5, fcr5, mcr5, lcr5, msr5, lsr5, rf_count5, tf_count5, tstate5, rstate,
`endif				
	rts_pad_o5, dtr_pad_o5, int_o5
`ifdef UART_HAS_BAUDRATE_OUTPUT5
	, baud_o5
`endif

	);

input 									clk5;
input 									wb_rst_i5;
input [`UART_ADDR_WIDTH5-1:0] 		wb_addr_i5;
input [7:0] 							wb_dat_i5;
output [7:0] 							wb_dat_o5;
input 									wb_we_i5;
input 									wb_re_i5;

output 									stx_pad_o5;
input 									srx_pad_i5;

input [3:0] 							modem_inputs5;
output 									rts_pad_o5;
output 									dtr_pad_o5;
output 									int_o5;
`ifdef UART_HAS_BAUDRATE_OUTPUT5
output	baud_o5;
`endif

`ifdef DATA_BUS_WIDTH_85
`else
// if 32-bit databus5 and debug5 interface are enabled
output [3:0]							ier5;
output [3:0]							iir5;
output [1:0]							fcr5;  /// bits 7 and 6 of fcr5. Other5 bits are ignored
output [4:0]							mcr5;
output [7:0]							lcr5;
output [7:0]							msr5;
output [7:0] 							lsr5;
output [`UART_FIFO_COUNTER_W5-1:0] 	rf_count5;
output [`UART_FIFO_COUNTER_W5-1:0] 	tf_count5;
output [2:0] 							tstate5;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs5;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT5
assign baud_o5 = enable; // baud_o5 is actually5 the enable signal5
`endif


wire 										stx_pad_o5;		// received5 from transmitter5 module
wire 										srx_pad_i5;
wire 										srx_pad5;

reg [7:0] 								wb_dat_o5;

wire [`UART_ADDR_WIDTH5-1:0] 		wb_addr_i5;
wire [7:0] 								wb_dat_i5;


reg [3:0] 								ier5;
reg [3:0] 								iir5;
reg [1:0] 								fcr5;  /// bits 7 and 6 of fcr5. Other5 bits are ignored
reg [4:0] 								mcr5;
reg [7:0] 								lcr5;
reg [7:0] 								msr5;
reg [15:0] 								dl5;  // 32-bit divisor5 latch5
reg [7:0] 								scratch5; // UART5 scratch5 register
reg 										start_dlc5; // activate5 dlc5 on writing to UART_DL15
reg 										lsr_mask_d5; // delay for lsr_mask5 condition
reg 										msi_reset5; // reset MSR5 4 lower5 bits indicator5
//reg 										threi_clear5; // THRE5 interrupt5 clear flag5
reg [15:0] 								dlc5;  // 32-bit divisor5 latch5 counter
reg 										int_o5;

reg [3:0] 								trigger_level5; // trigger level of the receiver5 FIFO
reg 										rx_reset5;
reg 										tx_reset5;

wire 										dlab5;			   // divisor5 latch5 access bit
wire 										cts_pad_i5, dsr_pad_i5, ri_pad_i5, dcd_pad_i5; // modem5 status bits
wire 										loopback5;		   // loopback5 bit (MCR5 bit 4)
wire 										cts5, dsr5, ri, dcd5;	   // effective5 signals5
wire                    cts_c5, dsr_c5, ri_c5, dcd_c5; // Complement5 effective5 signals5 (considering5 loopback5)
wire 										rts_pad_o5, dtr_pad_o5;		   // modem5 control5 outputs5

// LSR5 bits wires5 and regs
wire [7:0] 								lsr5;
wire 										lsr05, lsr15, lsr25, lsr35, lsr45, lsr55, lsr65, lsr75;
reg										lsr0r5, lsr1r5, lsr2r5, lsr3r5, lsr4r5, lsr5r5, lsr6r5, lsr7r5;
wire 										lsr_mask5; // lsr_mask5

//
// ASSINGS5
//

assign 									lsr5[7:0] = { lsr7r5, lsr6r5, lsr5r5, lsr4r5, lsr3r5, lsr2r5, lsr1r5, lsr0r5 };

assign 									{cts_pad_i5, dsr_pad_i5, ri_pad_i5, dcd_pad_i5} = modem_inputs5;
assign 									{cts5, dsr5, ri, dcd5} = ~{cts_pad_i5,dsr_pad_i5,ri_pad_i5,dcd_pad_i5};

assign                  {cts_c5, dsr_c5, ri_c5, dcd_c5} = loopback5 ? {mcr5[`UART_MC_RTS5],mcr5[`UART_MC_DTR5],mcr5[`UART_MC_OUT15],mcr5[`UART_MC_OUT25]}
                                                               : {cts_pad_i5,dsr_pad_i5,ri_pad_i5,dcd_pad_i5};

assign 									dlab5 = lcr5[`UART_LC_DL5];
assign 									loopback5 = mcr5[4];

// assign modem5 outputs5
assign 									rts_pad_o5 = mcr5[`UART_MC_RTS5];
assign 									dtr_pad_o5 = mcr5[`UART_MC_DTR5];

// Interrupt5 signals5
wire 										rls_int5;  // receiver5 line status interrupt5
wire 										rda_int5;  // receiver5 data available interrupt5
wire 										ti_int5;   // timeout indicator5 interrupt5
wire										thre_int5; // transmitter5 holding5 register empty5 interrupt5
wire 										ms_int5;   // modem5 status interrupt5

// FIFO signals5
reg 										tf_push5;
reg 										rf_pop5;
wire [`UART_FIFO_REC_WIDTH5-1:0] 	rf_data_out5;
wire 										rf_error_bit5; // an error (parity5 or framing5) is inside the fifo
wire [`UART_FIFO_COUNTER_W5-1:0] 	rf_count5;
wire [`UART_FIFO_COUNTER_W5-1:0] 	tf_count5;
wire [2:0] 								tstate5;
wire [3:0] 								rstate;
wire [9:0] 								counter_t5;

wire                      thre_set_en5; // THRE5 status is delayed5 one character5 time when a character5 is written5 to fifo.
reg  [7:0]                block_cnt5;   // While5 counter counts5, THRE5 status is blocked5 (delayed5 one character5 cycle)
reg  [7:0]                block_value5; // One5 character5 length minus5 stop bit

// Transmitter5 Instance
wire serial_out5;

uart_transmitter5 transmitter5(clk5, wb_rst_i5, lcr5, tf_push5, wb_dat_i5, enable, serial_out5, tstate5, tf_count5, tx_reset5, lsr_mask5);

  // Synchronizing5 and sampling5 serial5 RX5 input
  uart_sync_flops5    i_uart_sync_flops5
  (
    .rst_i5           (wb_rst_i5),
    .clk_i5           (clk5),
    .stage1_rst_i5    (1'b0),
    .stage1_clk_en_i5 (1'b1),
    .async_dat_i5     (srx_pad_i5),
    .sync_dat_o5      (srx_pad5)
  );
  defparam i_uart_sync_flops5.width      = 1;
  defparam i_uart_sync_flops5.init_value5 = 1'b1;

// handle loopback5
wire serial_in5 = loopback5 ? serial_out5 : srx_pad5;
assign stx_pad_o5 = loopback5 ? 1'b1 : serial_out5;

// Receiver5 Instance
uart_receiver5 receiver5(clk5, wb_rst_i5, lcr5, rf_pop5, serial_in5, enable, 
	counter_t5, rf_count5, rf_data_out5, rf_error_bit5, rf_overrun5, rx_reset5, lsr_mask5, rstate, rf_push_pulse5);


// Asynchronous5 reading here5 because the outputs5 are sampled5 in uart_wb5.v file 
always @(dl5 or dlab5 or ier5 or iir5 or scratch5
			or lcr5 or lsr5 or msr5 or rf_data_out5 or wb_addr_i5 or wb_re_i5)   // asynchrounous5 reading
begin
	case (wb_addr_i5)
		`UART_REG_RB5   : wb_dat_o5 = dlab5 ? dl5[`UART_DL15] : rf_data_out5[10:3];
		`UART_REG_IE5	: wb_dat_o5 = dlab5 ? dl5[`UART_DL25] : ier5;
		`UART_REG_II5	: wb_dat_o5 = {4'b1100,iir5};
		`UART_REG_LC5	: wb_dat_o5 = lcr5;
		`UART_REG_LS5	: wb_dat_o5 = lsr5;
		`UART_REG_MS5	: wb_dat_o5 = msr5;
		`UART_REG_SR5	: wb_dat_o5 = scratch5;
		default:  wb_dat_o5 = 8'b0; // ??
	endcase // case(wb_addr_i5)
end // always @ (dl5 or dlab5 or ier5 or iir5 or scratch5...


// rf_pop5 signal5 handling5
always @(posedge clk5 or posedge wb_rst_i5)
begin
	if (wb_rst_i5)
		rf_pop5 <= #1 0; 
	else
	if (rf_pop5)	// restore5 the signal5 to 0 after one clock5 cycle
		rf_pop5 <= #1 0;
	else
	if (wb_re_i5 && wb_addr_i5 == `UART_REG_RB5 && !dlab5)
		rf_pop5 <= #1 1; // advance5 read pointer5
end

wire 	lsr_mask_condition5;
wire 	iir_read5;
wire  msr_read5;
wire	fifo_read5;
wire	fifo_write5;

assign lsr_mask_condition5 = (wb_re_i5 && wb_addr_i5 == `UART_REG_LS5 && !dlab5);
assign iir_read5 = (wb_re_i5 && wb_addr_i5 == `UART_REG_II5 && !dlab5);
assign msr_read5 = (wb_re_i5 && wb_addr_i5 == `UART_REG_MS5 && !dlab5);
assign fifo_read5 = (wb_re_i5 && wb_addr_i5 == `UART_REG_RB5 && !dlab5);
assign fifo_write5 = (wb_we_i5 && wb_addr_i5 == `UART_REG_TR5 && !dlab5);

// lsr_mask_d5 delayed5 signal5 handling5
always @(posedge clk5 or posedge wb_rst_i5)
begin
	if (wb_rst_i5)
		lsr_mask_d5 <= #1 0;
	else // reset bits in the Line5 Status Register
		lsr_mask_d5 <= #1 lsr_mask_condition5;
end

// lsr_mask5 is rise5 detected
assign lsr_mask5 = lsr_mask_condition5 && ~lsr_mask_d5;

// msi_reset5 signal5 handling5
always @(posedge clk5 or posedge wb_rst_i5)
begin
	if (wb_rst_i5)
		msi_reset5 <= #1 1;
	else
	if (msi_reset5)
		msi_reset5 <= #1 0;
	else
	if (msr_read5)
		msi_reset5 <= #1 1; // reset bits in Modem5 Status Register
end


//
//   WRITES5 AND5 RESETS5   //
//
// Line5 Control5 Register
always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5)
		lcr5 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i5 && wb_addr_i5==`UART_REG_LC5)
		lcr5 <= #1 wb_dat_i5;

// Interrupt5 Enable5 Register or UART_DL25
always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5)
	begin
		ier5 <= #1 4'b0000; // no interrupts5 after reset
		dl5[`UART_DL25] <= #1 8'b0;
	end
	else
	if (wb_we_i5 && wb_addr_i5==`UART_REG_IE5)
		if (dlab5)
		begin
			dl5[`UART_DL25] <= #1 wb_dat_i5;
		end
		else
			ier5 <= #1 wb_dat_i5[3:0]; // ier5 uses only 4 lsb


// FIFO Control5 Register and rx_reset5, tx_reset5 signals5
always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) begin
		fcr5 <= #1 2'b11; 
		rx_reset5 <= #1 0;
		tx_reset5 <= #1 0;
	end else
	if (wb_we_i5 && wb_addr_i5==`UART_REG_FC5) begin
		fcr5 <= #1 wb_dat_i5[7:6];
		rx_reset5 <= #1 wb_dat_i5[1];
		tx_reset5 <= #1 wb_dat_i5[2];
	end else begin
		rx_reset5 <= #1 0;
		tx_reset5 <= #1 0;
	end

// Modem5 Control5 Register
always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5)
		mcr5 <= #1 5'b0; 
	else
	if (wb_we_i5 && wb_addr_i5==`UART_REG_MC5)
			mcr5 <= #1 wb_dat_i5[4:0];

// Scratch5 register
// Line5 Control5 Register
always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5)
		scratch5 <= #1 0; // 8n1 setting
	else
	if (wb_we_i5 && wb_addr_i5==`UART_REG_SR5)
		scratch5 <= #1 wb_dat_i5;

// TX_FIFO5 or UART_DL15
always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5)
	begin
		dl5[`UART_DL15]  <= #1 8'b0;
		tf_push5   <= #1 1'b0;
		start_dlc5 <= #1 1'b0;
	end
	else
	if (wb_we_i5 && wb_addr_i5==`UART_REG_TR5)
		if (dlab5)
		begin
			dl5[`UART_DL15] <= #1 wb_dat_i5;
			start_dlc5 <= #1 1'b1; // enable DL5 counter
			tf_push5 <= #1 1'b0;
		end
		else
		begin
			tf_push5   <= #1 1'b1;
			start_dlc5 <= #1 1'b0;
		end // else: !if(dlab5)
	else
	begin
		start_dlc5 <= #1 1'b0;
		tf_push5   <= #1 1'b0;
	end // else: !if(dlab5)

// Receiver5 FIFO trigger level selection logic (asynchronous5 mux5)
always @(fcr5)
	case (fcr5[`UART_FC_TL5])
		2'b00 : trigger_level5 = 1;
		2'b01 : trigger_level5 = 4;
		2'b10 : trigger_level5 = 8;
		2'b11 : trigger_level5 = 14;
	endcase // case(fcr5[`UART_FC_TL5])
	
//
//  STATUS5 REGISTERS5  //
//

// Modem5 Status Register
reg [3:0] delayed_modem_signals5;
always @(posedge clk5 or posedge wb_rst_i5)
begin
	if (wb_rst_i5)
	  begin
  		msr5 <= #1 0;
	  	delayed_modem_signals5[3:0] <= #1 0;
	  end
	else begin
		msr5[`UART_MS_DDCD5:`UART_MS_DCTS5] <= #1 msi_reset5 ? 4'b0 :
			msr5[`UART_MS_DDCD5:`UART_MS_DCTS5] | ({dcd5, ri, dsr5, cts5} ^ delayed_modem_signals5[3:0]);
		msr5[`UART_MS_CDCD5:`UART_MS_CCTS5] <= #1 {dcd_c5, ri_c5, dsr_c5, cts_c5};
		delayed_modem_signals5[3:0] <= #1 {dcd5, ri, dsr5, cts5};
	end
end


// Line5 Status Register

// activation5 conditions5
assign lsr05 = (rf_count5==0 && rf_push_pulse5);  // data in receiver5 fifo available set condition
assign lsr15 = rf_overrun5;     // Receiver5 overrun5 error
assign lsr25 = rf_data_out5[1]; // parity5 error bit
assign lsr35 = rf_data_out5[0]; // framing5 error bit
assign lsr45 = rf_data_out5[2]; // break error in the character5
assign lsr55 = (tf_count5==5'b0 && thre_set_en5);  // transmitter5 fifo is empty5
assign lsr65 = (tf_count5==5'b0 && thre_set_en5 && (tstate5 == /*`S_IDLE5 */ 0)); // transmitter5 empty5
assign lsr75 = rf_error_bit5 | rf_overrun5;

// lsr5 bit05 (receiver5 data available)
reg 	 lsr0_d5;

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr0_d5 <= #1 0;
	else lsr0_d5 <= #1 lsr05;

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr0r5 <= #1 0;
	else lsr0r5 <= #1 (rf_count5==1 && rf_pop5 && !rf_push_pulse5 || rx_reset5) ? 0 : // deassert5 condition
					  lsr0r5 || (lsr05 && ~lsr0_d5); // set on rise5 of lsr05 and keep5 asserted5 until deasserted5 

// lsr5 bit 1 (receiver5 overrun5)
reg lsr1_d5; // delayed5

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr1_d5 <= #1 0;
	else lsr1_d5 <= #1 lsr15;

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr1r5 <= #1 0;
	else	lsr1r5 <= #1	lsr_mask5 ? 0 : lsr1r5 || (lsr15 && ~lsr1_d5); // set on rise5

// lsr5 bit 2 (parity5 error)
reg lsr2_d5; // delayed5

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr2_d5 <= #1 0;
	else lsr2_d5 <= #1 lsr25;

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr2r5 <= #1 0;
	else lsr2r5 <= #1 lsr_mask5 ? 0 : lsr2r5 || (lsr25 && ~lsr2_d5); // set on rise5

// lsr5 bit 3 (framing5 error)
reg lsr3_d5; // delayed5

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr3_d5 <= #1 0;
	else lsr3_d5 <= #1 lsr35;

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr3r5 <= #1 0;
	else lsr3r5 <= #1 lsr_mask5 ? 0 : lsr3r5 || (lsr35 && ~lsr3_d5); // set on rise5

// lsr5 bit 4 (break indicator5)
reg lsr4_d5; // delayed5

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr4_d5 <= #1 0;
	else lsr4_d5 <= #1 lsr45;

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr4r5 <= #1 0;
	else lsr4r5 <= #1 lsr_mask5 ? 0 : lsr4r5 || (lsr45 && ~lsr4_d5);

// lsr5 bit 5 (transmitter5 fifo is empty5)
reg lsr5_d5;

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr5_d5 <= #1 1;
	else lsr5_d5 <= #1 lsr55;

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr5r5 <= #1 1;
	else lsr5r5 <= #1 (fifo_write5) ? 0 :  lsr5r5 || (lsr55 && ~lsr5_d5);

// lsr5 bit 6 (transmitter5 empty5 indicator5)
reg lsr6_d5;

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr6_d5 <= #1 1;
	else lsr6_d5 <= #1 lsr65;

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr6r5 <= #1 1;
	else lsr6r5 <= #1 (fifo_write5) ? 0 : lsr6r5 || (lsr65 && ~lsr6_d5);

// lsr5 bit 7 (error in fifo)
reg lsr7_d5;

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr7_d5 <= #1 0;
	else lsr7_d5 <= #1 lsr75;

always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) lsr7r5 <= #1 0;
	else lsr7r5 <= #1 lsr_mask5 ? 0 : lsr7r5 || (lsr75 && ~lsr7_d5);

// Frequency5 divider5
always @(posedge clk5 or posedge wb_rst_i5) 
begin
	if (wb_rst_i5)
		dlc5 <= #1 0;
	else
		if (start_dlc5 | ~ (|dlc5))
  			dlc5 <= #1 dl5 - 1;               // preset5 counter
		else
			dlc5 <= #1 dlc5 - 1;              // decrement counter
end

// Enable5 signal5 generation5 logic
always @(posedge clk5 or posedge wb_rst_i5)
begin
	if (wb_rst_i5)
		enable <= #1 1'b0;
	else
		if (|dl5 & ~(|dlc5))     // dl5>0 & dlc5==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying5 THRE5 status for one character5 cycle after a character5 is written5 to an empty5 fifo.
always @(lcr5)
  case (lcr5[3:0])
    4'b0000                             : block_value5 =  95; // 6 bits
    4'b0100                             : block_value5 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value5 = 111; // 7 bits
    4'b1100                             : block_value5 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value5 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value5 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value5 = 159; // 10 bits
    4'b1111                             : block_value5 = 175; // 11 bits
  endcase // case(lcr5[3:0])

// Counting5 time of one character5 minus5 stop bit
always @(posedge clk5 or posedge wb_rst_i5)
begin
  if (wb_rst_i5)
    block_cnt5 <= #1 8'd0;
  else
  if(lsr5r5 & fifo_write5)  // THRE5 bit set & write to fifo occured5
    block_cnt5 <= #1 block_value5;
  else
  if (enable & block_cnt5 != 8'b0)  // only work5 on enable times
    block_cnt5 <= #1 block_cnt5 - 1;  // decrement break counter
end // always of break condition detection5

// Generating5 THRE5 status enable signal5
assign thre_set_en5 = ~(|block_cnt5);


//
//	INTERRUPT5 LOGIC5
//

assign rls_int5  = ier5[`UART_IE_RLS5] && (lsr5[`UART_LS_OE5] || lsr5[`UART_LS_PE5] || lsr5[`UART_LS_FE5] || lsr5[`UART_LS_BI5]);
assign rda_int5  = ier5[`UART_IE_RDA5] && (rf_count5 >= {1'b0,trigger_level5});
assign thre_int5 = ier5[`UART_IE_THRE5] && lsr5[`UART_LS_TFE5];
assign ms_int5   = ier5[`UART_IE_MS5] && (| msr5[3:0]);
assign ti_int5   = ier5[`UART_IE_RDA5] && (counter_t5 == 10'b0) && (|rf_count5);

reg 	 rls_int_d5;
reg 	 thre_int_d5;
reg 	 ms_int_d5;
reg 	 ti_int_d5;
reg 	 rda_int_d5;

// delay lines5
always  @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) rls_int_d5 <= #1 0;
	else rls_int_d5 <= #1 rls_int5;

always  @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) rda_int_d5 <= #1 0;
	else rda_int_d5 <= #1 rda_int5;

always  @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) thre_int_d5 <= #1 0;
	else thre_int_d5 <= #1 thre_int5;

always  @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) ms_int_d5 <= #1 0;
	else ms_int_d5 <= #1 ms_int5;

always  @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) ti_int_d5 <= #1 0;
	else ti_int_d5 <= #1 ti_int5;

// rise5 detection5 signals5

wire 	 rls_int_rise5;
wire 	 thre_int_rise5;
wire 	 ms_int_rise5;
wire 	 ti_int_rise5;
wire 	 rda_int_rise5;

assign rda_int_rise5    = rda_int5 & ~rda_int_d5;
assign rls_int_rise5 	  = rls_int5 & ~rls_int_d5;
assign thre_int_rise5   = thre_int5 & ~thre_int_d5;
assign ms_int_rise5 	  = ms_int5 & ~ms_int_d5;
assign ti_int_rise5 	  = ti_int5 & ~ti_int_d5;

// interrupt5 pending flags5
reg 	rls_int_pnd5;
reg	rda_int_pnd5;
reg 	thre_int_pnd5;
reg 	ms_int_pnd5;
reg 	ti_int_pnd5;

// interrupt5 pending flags5 assignments5
always  @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) rls_int_pnd5 <= #1 0; 
	else 
		rls_int_pnd5 <= #1 lsr_mask5 ? 0 :  						// reset condition
							rls_int_rise5 ? 1 :						// latch5 condition
							rls_int_pnd5 && ier5[`UART_IE_RLS5];	// default operation5: remove if masked5

always  @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) rda_int_pnd5 <= #1 0; 
	else 
		rda_int_pnd5 <= #1 ((rf_count5 == {1'b0,trigger_level5}) && fifo_read5) ? 0 :  	// reset condition
							rda_int_rise5 ? 1 :						// latch5 condition
							rda_int_pnd5 && ier5[`UART_IE_RDA5];	// default operation5: remove if masked5

always  @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) thre_int_pnd5 <= #1 0; 
	else 
		thre_int_pnd5 <= #1 fifo_write5 || (iir_read5 & ~iir5[`UART_II_IP5] & iir5[`UART_II_II5] == `UART_II_THRE5)? 0 : 
							thre_int_rise5 ? 1 :
							thre_int_pnd5 && ier5[`UART_IE_THRE5];

always  @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) ms_int_pnd5 <= #1 0; 
	else 
		ms_int_pnd5 <= #1 msr_read5 ? 0 : 
							ms_int_rise5 ? 1 :
							ms_int_pnd5 && ier5[`UART_IE_MS5];

always  @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) ti_int_pnd5 <= #1 0; 
	else 
		ti_int_pnd5 <= #1 fifo_read5 ? 0 : 
							ti_int_rise5 ? 1 :
							ti_int_pnd5 && ier5[`UART_IE_RDA5];
// end of pending flags5

// INT_O5 logic
always @(posedge clk5 or posedge wb_rst_i5)
begin
	if (wb_rst_i5)	
		int_o5 <= #1 1'b0;
	else
		int_o5 <= #1 
					rls_int_pnd5		?	~lsr_mask5					:
					rda_int_pnd5		? 1								:
					ti_int_pnd5		? ~fifo_read5					:
					thre_int_pnd5	? !(fifo_write5 & iir_read5) :
					ms_int_pnd5		? ~msr_read5						:
					0;	// if no interrupt5 are pending
end


// Interrupt5 Identification5 register
always @(posedge clk5 or posedge wb_rst_i5)
begin
	if (wb_rst_i5)
		iir5 <= #1 1;
	else
	if (rls_int_pnd5)  // interrupt5 is pending
	begin
		iir5[`UART_II_II5] <= #1 `UART_II_RLS5;	// set identification5 register to correct5 value
		iir5[`UART_II_IP5] <= #1 1'b0;		// and clear the IIR5 bit 0 (interrupt5 pending)
	end else // the sequence of conditions5 determines5 priority of interrupt5 identification5
	if (rda_int5)
	begin
		iir5[`UART_II_II5] <= #1 `UART_II_RDA5;
		iir5[`UART_II_IP5] <= #1 1'b0;
	end
	else if (ti_int_pnd5)
	begin
		iir5[`UART_II_II5] <= #1 `UART_II_TI5;
		iir5[`UART_II_IP5] <= #1 1'b0;
	end
	else if (thre_int_pnd5)
	begin
		iir5[`UART_II_II5] <= #1 `UART_II_THRE5;
		iir5[`UART_II_IP5] <= #1 1'b0;
	end
	else if (ms_int_pnd5)
	begin
		iir5[`UART_II_II5] <= #1 `UART_II_MS5;
		iir5[`UART_II_IP5] <= #1 1'b0;
	end else	// no interrupt5 is pending
	begin
		iir5[`UART_II_II5] <= #1 0;
		iir5[`UART_II_IP5] <= #1 1'b1;
	end
end

endmodule
