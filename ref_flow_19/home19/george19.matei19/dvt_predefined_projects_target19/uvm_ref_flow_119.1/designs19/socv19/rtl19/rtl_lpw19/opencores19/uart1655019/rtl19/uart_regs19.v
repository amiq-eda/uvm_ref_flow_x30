//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs19.v                                                 ////
////                                                              ////
////                                                              ////
////  This19 file is part of the "UART19 16550 compatible19" project19    ////
////  http19://www19.opencores19.org19/cores19/uart1655019/                   ////
////                                                              ////
////  Documentation19 related19 to this project19:                      ////
////  - http19://www19.opencores19.org19/cores19/uart1655019/                 ////
////                                                              ////
////  Projects19 compatibility19:                                     ////
////  - WISHBONE19                                                  ////
////  RS23219 Protocol19                                              ////
////  16550D uart19 (mostly19 supported)                              ////
////                                                              ////
////  Overview19 (main19 Features19):                                   ////
////  Registers19 of the uart19 16550 core19                            ////
////                                                              ////
////  Known19 problems19 (limits19):                                    ////
////  Inserts19 1 wait state in all WISHBONE19 transfers19              ////
////                                                              ////
////  To19 Do19:                                                      ////
////  Nothing or verification19.                                    ////
////                                                              ////
////  Author19(s):                                                  ////
////      - gorban19@opencores19.org19                                  ////
////      - Jacob19 Gorban19                                          ////
////      - Igor19 Mohor19 (igorm19@opencores19.org19)                      ////
////                                                              ////
////  Created19:        2001/05/12                                  ////
////  Last19 Updated19:   (See log19 for the revision19 history19           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2000, 2001 Authors19                             ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS19 Revision19 History19
//
// $Log: not supported by cvs2svn19 $
// Revision19 1.41  2004/05/21 11:44:41  tadejm19
// Added19 synchronizer19 flops19 for RX19 input.
//
// Revision19 1.40  2003/06/11 16:37:47  gorban19
// This19 fixes19 errors19 in some19 cases19 when data is being read and put to the FIFO at the same time. Patch19 is submitted19 by Scott19 Furman19. Update is very19 recommended19.
//
// Revision19 1.39  2002/07/29 21:16:18  gorban19
// The uart_defines19.v file is included19 again19 in sources19.
//
// Revision19 1.38  2002/07/22 23:02:23  gorban19
// Bug19 Fixes19:
//  * Possible19 loss of sync and bad19 reception19 of stop bit on slow19 baud19 rates19 fixed19.
//   Problem19 reported19 by Kenny19.Tung19.
//  * Bad (or lack19 of ) loopback19 handling19 fixed19. Reported19 by Cherry19 Withers19.
//
// Improvements19:
//  * Made19 FIFO's as general19 inferrable19 memory where possible19.
//  So19 on FPGA19 they should be inferred19 as RAM19 (Distributed19 RAM19 on Xilinx19).
//  This19 saves19 about19 1/3 of the Slice19 count and reduces19 P&R and synthesis19 times.
//
//  * Added19 optional19 baudrate19 output (baud_o19).
//  This19 is identical19 to BAUDOUT19* signal19 on 16550 chip19.
//  It outputs19 16xbit_clock_rate - the divided19 clock19.
//  It's disabled by default. Define19 UART_HAS_BAUDRATE_OUTPUT19 to use.
//
// Revision19 1.37  2001/12/27 13:24:09  mohor19
// lsr19[7] was not showing19 overrun19 errors19.
//
// Revision19 1.36  2001/12/20 13:25:46  mohor19
// rx19 push19 changed to be only one cycle wide19.
//
// Revision19 1.35  2001/12/19 08:03:34  mohor19
// Warnings19 cleared19.
//
// Revision19 1.34  2001/12/19 07:33:54  mohor19
// Synplicity19 was having19 troubles19 with the comment19.
//
// Revision19 1.33  2001/12/17 10:14:43  mohor19
// Things19 related19 to msr19 register changed. After19 THRE19 IRQ19 occurs19, and one
// character19 is written19 to the transmit19 fifo, the detection19 of the THRE19 bit in the
// LSR19 is delayed19 for one character19 time.
//
// Revision19 1.32  2001/12/14 13:19:24  mohor19
// MSR19 register fixed19.
//
// Revision19 1.31  2001/12/14 10:06:58  mohor19
// After19 reset modem19 status register MSR19 should be reset.
//
// Revision19 1.30  2001/12/13 10:09:13  mohor19
// thre19 irq19 should be cleared19 only when being source19 of interrupt19.
//
// Revision19 1.29  2001/12/12 09:05:46  mohor19
// LSR19 status bit 0 was not cleared19 correctly in case of reseting19 the FCR19 (rx19 fifo).
//
// Revision19 1.28  2001/12/10 19:52:41  gorban19
// Scratch19 register added
//
// Revision19 1.27  2001/12/06 14:51:04  gorban19
// Bug19 in LSR19[0] is fixed19.
// All WISHBONE19 signals19 are now sampled19, so another19 wait-state is introduced19 on all transfers19.
//
// Revision19 1.26  2001/12/03 21:44:29  gorban19
// Updated19 specification19 documentation.
// Added19 full 32-bit data bus interface, now as default.
// Address is 5-bit wide19 in 32-bit data bus mode.
// Added19 wb_sel_i19 input to the core19. It's used in the 32-bit mode.
// Added19 debug19 interface with two19 32-bit read-only registers in 32-bit mode.
// Bits19 5 and 6 of LSR19 are now only cleared19 on TX19 FIFO write.
// My19 small test bench19 is modified to work19 with 32-bit mode.
//
// Revision19 1.25  2001/11/28 19:36:39  gorban19
// Fixed19: timeout and break didn19't pay19 attention19 to current data format19 when counting19 time
//
// Revision19 1.24  2001/11/26 21:38:54  gorban19
// Lots19 of fixes19:
// Break19 condition wasn19't handled19 correctly at all.
// LSR19 bits could lose19 their19 values.
// LSR19 value after reset was wrong19.
// Timing19 of THRE19 interrupt19 signal19 corrected19.
// LSR19 bit 0 timing19 corrected19.
//
// Revision19 1.23  2001/11/12 21:57:29  gorban19
// fixed19 more typo19 bugs19
//
// Revision19 1.22  2001/11/12 15:02:28  mohor19
// lsr1r19 error fixed19.
//
// Revision19 1.21  2001/11/12 14:57:27  mohor19
// ti_int_pnd19 error fixed19.
//
// Revision19 1.20  2001/11/12 14:50:27  mohor19
// ti_int_d19 error fixed19.
//
// Revision19 1.19  2001/11/10 12:43:21  gorban19
// Logic19 Synthesis19 bugs19 fixed19. Some19 other minor19 changes19
//
// Revision19 1.18  2001/11/08 14:54:23  mohor19
// Comments19 in Slovene19 language19 deleted19, few19 small fixes19 for better19 work19 of
// old19 tools19. IRQs19 need to be fix19.
//
// Revision19 1.17  2001/11/07 17:51:52  gorban19
// Heavily19 rewritten19 interrupt19 and LSR19 subsystems19.
// Many19 bugs19 hopefully19 squashed19.
//
// Revision19 1.16  2001/11/02 09:55:16  mohor19
// no message
//
// Revision19 1.15  2001/10/31 15:19:22  gorban19
// Fixes19 to break and timeout conditions19
//
// Revision19 1.14  2001/10/29 17:00:46  gorban19
// fixed19 parity19 sending19 and tx_fifo19 resets19 over- and underrun19
//
// Revision19 1.13  2001/10/20 09:58:40  gorban19
// Small19 synopsis19 fixes19
//
// Revision19 1.12  2001/10/19 16:21:40  gorban19
// Changes19 data_out19 to be synchronous19 again19 as it should have been.
//
// Revision19 1.11  2001/10/18 20:35:45  gorban19
// small fix19
//
// Revision19 1.10  2001/08/24 21:01:12  mohor19
// Things19 connected19 to parity19 changed.
// Clock19 devider19 changed.
//
// Revision19 1.9  2001/08/23 16:05:05  mohor19
// Stop bit bug19 fixed19.
// Parity19 bug19 fixed19.
// WISHBONE19 read cycle bug19 fixed19,
// OE19 indicator19 (Overrun19 Error) bug19 fixed19.
// PE19 indicator19 (Parity19 Error) bug19 fixed19.
// Register read bug19 fixed19.
//
// Revision19 1.10  2001/06/23 11:21:48  gorban19
// DL19 made19 16-bit long19. Fixed19 transmission19/reception19 bugs19.
//
// Revision19 1.9  2001/05/31 20:08:01  gorban19
// FIFO changes19 and other corrections19.
//
// Revision19 1.8  2001/05/29 20:05:04  gorban19
// Fixed19 some19 bugs19 and synthesis19 problems19.
//
// Revision19 1.7  2001/05/27 17:37:49  gorban19
// Fixed19 many19 bugs19. Updated19 spec19. Changed19 FIFO files structure19. See CHANGES19.txt19 file.
//
// Revision19 1.6  2001/05/21 19:12:02  gorban19
// Corrected19 some19 Linter19 messages19.
//
// Revision19 1.5  2001/05/17 18:34:18  gorban19
// First19 'stable' release. Should19 be sythesizable19 now. Also19 added new header.
//
// Revision19 1.0  2001-05-17 21:27:11+02  jacob19
// Initial19 revision19
//
//

// synopsys19 translate_off19
`include "timescale.v"
// synopsys19 translate_on19

`include "uart_defines19.v"

`define UART_DL119 7:0
`define UART_DL219 15:8

module uart_regs19 (clk19,
	wb_rst_i19, wb_addr_i19, wb_dat_i19, wb_dat_o19, wb_we_i19, wb_re_i19, 

// additional19 signals19
	modem_inputs19,
	stx_pad_o19, srx_pad_i19,

`ifdef DATA_BUS_WIDTH_819
`else
// debug19 interface signals19	enabled
ier19, iir19, fcr19, mcr19, lcr19, msr19, lsr19, rf_count19, tf_count19, tstate19, rstate,
`endif				
	rts_pad_o19, dtr_pad_o19, int_o19
`ifdef UART_HAS_BAUDRATE_OUTPUT19
	, baud_o19
`endif

	);

input 									clk19;
input 									wb_rst_i19;
input [`UART_ADDR_WIDTH19-1:0] 		wb_addr_i19;
input [7:0] 							wb_dat_i19;
output [7:0] 							wb_dat_o19;
input 									wb_we_i19;
input 									wb_re_i19;

output 									stx_pad_o19;
input 									srx_pad_i19;

input [3:0] 							modem_inputs19;
output 									rts_pad_o19;
output 									dtr_pad_o19;
output 									int_o19;
`ifdef UART_HAS_BAUDRATE_OUTPUT19
output	baud_o19;
`endif

`ifdef DATA_BUS_WIDTH_819
`else
// if 32-bit databus19 and debug19 interface are enabled
output [3:0]							ier19;
output [3:0]							iir19;
output [1:0]							fcr19;  /// bits 7 and 6 of fcr19. Other19 bits are ignored
output [4:0]							mcr19;
output [7:0]							lcr19;
output [7:0]							msr19;
output [7:0] 							lsr19;
output [`UART_FIFO_COUNTER_W19-1:0] 	rf_count19;
output [`UART_FIFO_COUNTER_W19-1:0] 	tf_count19;
output [2:0] 							tstate19;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs19;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT19
assign baud_o19 = enable; // baud_o19 is actually19 the enable signal19
`endif


wire 										stx_pad_o19;		// received19 from transmitter19 module
wire 										srx_pad_i19;
wire 										srx_pad19;

reg [7:0] 								wb_dat_o19;

wire [`UART_ADDR_WIDTH19-1:0] 		wb_addr_i19;
wire [7:0] 								wb_dat_i19;


reg [3:0] 								ier19;
reg [3:0] 								iir19;
reg [1:0] 								fcr19;  /// bits 7 and 6 of fcr19. Other19 bits are ignored
reg [4:0] 								mcr19;
reg [7:0] 								lcr19;
reg [7:0] 								msr19;
reg [15:0] 								dl19;  // 32-bit divisor19 latch19
reg [7:0] 								scratch19; // UART19 scratch19 register
reg 										start_dlc19; // activate19 dlc19 on writing to UART_DL119
reg 										lsr_mask_d19; // delay for lsr_mask19 condition
reg 										msi_reset19; // reset MSR19 4 lower19 bits indicator19
//reg 										threi_clear19; // THRE19 interrupt19 clear flag19
reg [15:0] 								dlc19;  // 32-bit divisor19 latch19 counter
reg 										int_o19;

reg [3:0] 								trigger_level19; // trigger level of the receiver19 FIFO
reg 										rx_reset19;
reg 										tx_reset19;

wire 										dlab19;			   // divisor19 latch19 access bit
wire 										cts_pad_i19, dsr_pad_i19, ri_pad_i19, dcd_pad_i19; // modem19 status bits
wire 										loopback19;		   // loopback19 bit (MCR19 bit 4)
wire 										cts19, dsr19, ri, dcd19;	   // effective19 signals19
wire                    cts_c19, dsr_c19, ri_c19, dcd_c19; // Complement19 effective19 signals19 (considering19 loopback19)
wire 										rts_pad_o19, dtr_pad_o19;		   // modem19 control19 outputs19

// LSR19 bits wires19 and regs
wire [7:0] 								lsr19;
wire 										lsr019, lsr119, lsr219, lsr319, lsr419, lsr519, lsr619, lsr719;
reg										lsr0r19, lsr1r19, lsr2r19, lsr3r19, lsr4r19, lsr5r19, lsr6r19, lsr7r19;
wire 										lsr_mask19; // lsr_mask19

//
// ASSINGS19
//

assign 									lsr19[7:0] = { lsr7r19, lsr6r19, lsr5r19, lsr4r19, lsr3r19, lsr2r19, lsr1r19, lsr0r19 };

assign 									{cts_pad_i19, dsr_pad_i19, ri_pad_i19, dcd_pad_i19} = modem_inputs19;
assign 									{cts19, dsr19, ri, dcd19} = ~{cts_pad_i19,dsr_pad_i19,ri_pad_i19,dcd_pad_i19};

assign                  {cts_c19, dsr_c19, ri_c19, dcd_c19} = loopback19 ? {mcr19[`UART_MC_RTS19],mcr19[`UART_MC_DTR19],mcr19[`UART_MC_OUT119],mcr19[`UART_MC_OUT219]}
                                                               : {cts_pad_i19,dsr_pad_i19,ri_pad_i19,dcd_pad_i19};

assign 									dlab19 = lcr19[`UART_LC_DL19];
assign 									loopback19 = mcr19[4];

// assign modem19 outputs19
assign 									rts_pad_o19 = mcr19[`UART_MC_RTS19];
assign 									dtr_pad_o19 = mcr19[`UART_MC_DTR19];

// Interrupt19 signals19
wire 										rls_int19;  // receiver19 line status interrupt19
wire 										rda_int19;  // receiver19 data available interrupt19
wire 										ti_int19;   // timeout indicator19 interrupt19
wire										thre_int19; // transmitter19 holding19 register empty19 interrupt19
wire 										ms_int19;   // modem19 status interrupt19

// FIFO signals19
reg 										tf_push19;
reg 										rf_pop19;
wire [`UART_FIFO_REC_WIDTH19-1:0] 	rf_data_out19;
wire 										rf_error_bit19; // an error (parity19 or framing19) is inside the fifo
wire [`UART_FIFO_COUNTER_W19-1:0] 	rf_count19;
wire [`UART_FIFO_COUNTER_W19-1:0] 	tf_count19;
wire [2:0] 								tstate19;
wire [3:0] 								rstate;
wire [9:0] 								counter_t19;

wire                      thre_set_en19; // THRE19 status is delayed19 one character19 time when a character19 is written19 to fifo.
reg  [7:0]                block_cnt19;   // While19 counter counts19, THRE19 status is blocked19 (delayed19 one character19 cycle)
reg  [7:0]                block_value19; // One19 character19 length minus19 stop bit

// Transmitter19 Instance
wire serial_out19;

uart_transmitter19 transmitter19(clk19, wb_rst_i19, lcr19, tf_push19, wb_dat_i19, enable, serial_out19, tstate19, tf_count19, tx_reset19, lsr_mask19);

  // Synchronizing19 and sampling19 serial19 RX19 input
  uart_sync_flops19    i_uart_sync_flops19
  (
    .rst_i19           (wb_rst_i19),
    .clk_i19           (clk19),
    .stage1_rst_i19    (1'b0),
    .stage1_clk_en_i19 (1'b1),
    .async_dat_i19     (srx_pad_i19),
    .sync_dat_o19      (srx_pad19)
  );
  defparam i_uart_sync_flops19.width      = 1;
  defparam i_uart_sync_flops19.init_value19 = 1'b1;

// handle loopback19
wire serial_in19 = loopback19 ? serial_out19 : srx_pad19;
assign stx_pad_o19 = loopback19 ? 1'b1 : serial_out19;

// Receiver19 Instance
uart_receiver19 receiver19(clk19, wb_rst_i19, lcr19, rf_pop19, serial_in19, enable, 
	counter_t19, rf_count19, rf_data_out19, rf_error_bit19, rf_overrun19, rx_reset19, lsr_mask19, rstate, rf_push_pulse19);


// Asynchronous19 reading here19 because the outputs19 are sampled19 in uart_wb19.v file 
always @(dl19 or dlab19 or ier19 or iir19 or scratch19
			or lcr19 or lsr19 or msr19 or rf_data_out19 or wb_addr_i19 or wb_re_i19)   // asynchrounous19 reading
begin
	case (wb_addr_i19)
		`UART_REG_RB19   : wb_dat_o19 = dlab19 ? dl19[`UART_DL119] : rf_data_out19[10:3];
		`UART_REG_IE19	: wb_dat_o19 = dlab19 ? dl19[`UART_DL219] : ier19;
		`UART_REG_II19	: wb_dat_o19 = {4'b1100,iir19};
		`UART_REG_LC19	: wb_dat_o19 = lcr19;
		`UART_REG_LS19	: wb_dat_o19 = lsr19;
		`UART_REG_MS19	: wb_dat_o19 = msr19;
		`UART_REG_SR19	: wb_dat_o19 = scratch19;
		default:  wb_dat_o19 = 8'b0; // ??
	endcase // case(wb_addr_i19)
end // always @ (dl19 or dlab19 or ier19 or iir19 or scratch19...


// rf_pop19 signal19 handling19
always @(posedge clk19 or posedge wb_rst_i19)
begin
	if (wb_rst_i19)
		rf_pop19 <= #1 0; 
	else
	if (rf_pop19)	// restore19 the signal19 to 0 after one clock19 cycle
		rf_pop19 <= #1 0;
	else
	if (wb_re_i19 && wb_addr_i19 == `UART_REG_RB19 && !dlab19)
		rf_pop19 <= #1 1; // advance19 read pointer19
end

wire 	lsr_mask_condition19;
wire 	iir_read19;
wire  msr_read19;
wire	fifo_read19;
wire	fifo_write19;

assign lsr_mask_condition19 = (wb_re_i19 && wb_addr_i19 == `UART_REG_LS19 && !dlab19);
assign iir_read19 = (wb_re_i19 && wb_addr_i19 == `UART_REG_II19 && !dlab19);
assign msr_read19 = (wb_re_i19 && wb_addr_i19 == `UART_REG_MS19 && !dlab19);
assign fifo_read19 = (wb_re_i19 && wb_addr_i19 == `UART_REG_RB19 && !dlab19);
assign fifo_write19 = (wb_we_i19 && wb_addr_i19 == `UART_REG_TR19 && !dlab19);

// lsr_mask_d19 delayed19 signal19 handling19
always @(posedge clk19 or posedge wb_rst_i19)
begin
	if (wb_rst_i19)
		lsr_mask_d19 <= #1 0;
	else // reset bits in the Line19 Status Register
		lsr_mask_d19 <= #1 lsr_mask_condition19;
end

// lsr_mask19 is rise19 detected
assign lsr_mask19 = lsr_mask_condition19 && ~lsr_mask_d19;

// msi_reset19 signal19 handling19
always @(posedge clk19 or posedge wb_rst_i19)
begin
	if (wb_rst_i19)
		msi_reset19 <= #1 1;
	else
	if (msi_reset19)
		msi_reset19 <= #1 0;
	else
	if (msr_read19)
		msi_reset19 <= #1 1; // reset bits in Modem19 Status Register
end


//
//   WRITES19 AND19 RESETS19   //
//
// Line19 Control19 Register
always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19)
		lcr19 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i19 && wb_addr_i19==`UART_REG_LC19)
		lcr19 <= #1 wb_dat_i19;

// Interrupt19 Enable19 Register or UART_DL219
always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19)
	begin
		ier19 <= #1 4'b0000; // no interrupts19 after reset
		dl19[`UART_DL219] <= #1 8'b0;
	end
	else
	if (wb_we_i19 && wb_addr_i19==`UART_REG_IE19)
		if (dlab19)
		begin
			dl19[`UART_DL219] <= #1 wb_dat_i19;
		end
		else
			ier19 <= #1 wb_dat_i19[3:0]; // ier19 uses only 4 lsb


// FIFO Control19 Register and rx_reset19, tx_reset19 signals19
always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) begin
		fcr19 <= #1 2'b11; 
		rx_reset19 <= #1 0;
		tx_reset19 <= #1 0;
	end else
	if (wb_we_i19 && wb_addr_i19==`UART_REG_FC19) begin
		fcr19 <= #1 wb_dat_i19[7:6];
		rx_reset19 <= #1 wb_dat_i19[1];
		tx_reset19 <= #1 wb_dat_i19[2];
	end else begin
		rx_reset19 <= #1 0;
		tx_reset19 <= #1 0;
	end

// Modem19 Control19 Register
always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19)
		mcr19 <= #1 5'b0; 
	else
	if (wb_we_i19 && wb_addr_i19==`UART_REG_MC19)
			mcr19 <= #1 wb_dat_i19[4:0];

// Scratch19 register
// Line19 Control19 Register
always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19)
		scratch19 <= #1 0; // 8n1 setting
	else
	if (wb_we_i19 && wb_addr_i19==`UART_REG_SR19)
		scratch19 <= #1 wb_dat_i19;

// TX_FIFO19 or UART_DL119
always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19)
	begin
		dl19[`UART_DL119]  <= #1 8'b0;
		tf_push19   <= #1 1'b0;
		start_dlc19 <= #1 1'b0;
	end
	else
	if (wb_we_i19 && wb_addr_i19==`UART_REG_TR19)
		if (dlab19)
		begin
			dl19[`UART_DL119] <= #1 wb_dat_i19;
			start_dlc19 <= #1 1'b1; // enable DL19 counter
			tf_push19 <= #1 1'b0;
		end
		else
		begin
			tf_push19   <= #1 1'b1;
			start_dlc19 <= #1 1'b0;
		end // else: !if(dlab19)
	else
	begin
		start_dlc19 <= #1 1'b0;
		tf_push19   <= #1 1'b0;
	end // else: !if(dlab19)

// Receiver19 FIFO trigger level selection logic (asynchronous19 mux19)
always @(fcr19)
	case (fcr19[`UART_FC_TL19])
		2'b00 : trigger_level19 = 1;
		2'b01 : trigger_level19 = 4;
		2'b10 : trigger_level19 = 8;
		2'b11 : trigger_level19 = 14;
	endcase // case(fcr19[`UART_FC_TL19])
	
//
//  STATUS19 REGISTERS19  //
//

// Modem19 Status Register
reg [3:0] delayed_modem_signals19;
always @(posedge clk19 or posedge wb_rst_i19)
begin
	if (wb_rst_i19)
	  begin
  		msr19 <= #1 0;
	  	delayed_modem_signals19[3:0] <= #1 0;
	  end
	else begin
		msr19[`UART_MS_DDCD19:`UART_MS_DCTS19] <= #1 msi_reset19 ? 4'b0 :
			msr19[`UART_MS_DDCD19:`UART_MS_DCTS19] | ({dcd19, ri, dsr19, cts19} ^ delayed_modem_signals19[3:0]);
		msr19[`UART_MS_CDCD19:`UART_MS_CCTS19] <= #1 {dcd_c19, ri_c19, dsr_c19, cts_c19};
		delayed_modem_signals19[3:0] <= #1 {dcd19, ri, dsr19, cts19};
	end
end


// Line19 Status Register

// activation19 conditions19
assign lsr019 = (rf_count19==0 && rf_push_pulse19);  // data in receiver19 fifo available set condition
assign lsr119 = rf_overrun19;     // Receiver19 overrun19 error
assign lsr219 = rf_data_out19[1]; // parity19 error bit
assign lsr319 = rf_data_out19[0]; // framing19 error bit
assign lsr419 = rf_data_out19[2]; // break error in the character19
assign lsr519 = (tf_count19==5'b0 && thre_set_en19);  // transmitter19 fifo is empty19
assign lsr619 = (tf_count19==5'b0 && thre_set_en19 && (tstate19 == /*`S_IDLE19 */ 0)); // transmitter19 empty19
assign lsr719 = rf_error_bit19 | rf_overrun19;

// lsr19 bit019 (receiver19 data available)
reg 	 lsr0_d19;

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr0_d19 <= #1 0;
	else lsr0_d19 <= #1 lsr019;

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr0r19 <= #1 0;
	else lsr0r19 <= #1 (rf_count19==1 && rf_pop19 && !rf_push_pulse19 || rx_reset19) ? 0 : // deassert19 condition
					  lsr0r19 || (lsr019 && ~lsr0_d19); // set on rise19 of lsr019 and keep19 asserted19 until deasserted19 

// lsr19 bit 1 (receiver19 overrun19)
reg lsr1_d19; // delayed19

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr1_d19 <= #1 0;
	else lsr1_d19 <= #1 lsr119;

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr1r19 <= #1 0;
	else	lsr1r19 <= #1	lsr_mask19 ? 0 : lsr1r19 || (lsr119 && ~lsr1_d19); // set on rise19

// lsr19 bit 2 (parity19 error)
reg lsr2_d19; // delayed19

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr2_d19 <= #1 0;
	else lsr2_d19 <= #1 lsr219;

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr2r19 <= #1 0;
	else lsr2r19 <= #1 lsr_mask19 ? 0 : lsr2r19 || (lsr219 && ~lsr2_d19); // set on rise19

// lsr19 bit 3 (framing19 error)
reg lsr3_d19; // delayed19

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr3_d19 <= #1 0;
	else lsr3_d19 <= #1 lsr319;

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr3r19 <= #1 0;
	else lsr3r19 <= #1 lsr_mask19 ? 0 : lsr3r19 || (lsr319 && ~lsr3_d19); // set on rise19

// lsr19 bit 4 (break indicator19)
reg lsr4_d19; // delayed19

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr4_d19 <= #1 0;
	else lsr4_d19 <= #1 lsr419;

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr4r19 <= #1 0;
	else lsr4r19 <= #1 lsr_mask19 ? 0 : lsr4r19 || (lsr419 && ~lsr4_d19);

// lsr19 bit 5 (transmitter19 fifo is empty19)
reg lsr5_d19;

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr5_d19 <= #1 1;
	else lsr5_d19 <= #1 lsr519;

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr5r19 <= #1 1;
	else lsr5r19 <= #1 (fifo_write19) ? 0 :  lsr5r19 || (lsr519 && ~lsr5_d19);

// lsr19 bit 6 (transmitter19 empty19 indicator19)
reg lsr6_d19;

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr6_d19 <= #1 1;
	else lsr6_d19 <= #1 lsr619;

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr6r19 <= #1 1;
	else lsr6r19 <= #1 (fifo_write19) ? 0 : lsr6r19 || (lsr619 && ~lsr6_d19);

// lsr19 bit 7 (error in fifo)
reg lsr7_d19;

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr7_d19 <= #1 0;
	else lsr7_d19 <= #1 lsr719;

always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) lsr7r19 <= #1 0;
	else lsr7r19 <= #1 lsr_mask19 ? 0 : lsr7r19 || (lsr719 && ~lsr7_d19);

// Frequency19 divider19
always @(posedge clk19 or posedge wb_rst_i19) 
begin
	if (wb_rst_i19)
		dlc19 <= #1 0;
	else
		if (start_dlc19 | ~ (|dlc19))
  			dlc19 <= #1 dl19 - 1;               // preset19 counter
		else
			dlc19 <= #1 dlc19 - 1;              // decrement counter
end

// Enable19 signal19 generation19 logic
always @(posedge clk19 or posedge wb_rst_i19)
begin
	if (wb_rst_i19)
		enable <= #1 1'b0;
	else
		if (|dl19 & ~(|dlc19))     // dl19>0 & dlc19==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying19 THRE19 status for one character19 cycle after a character19 is written19 to an empty19 fifo.
always @(lcr19)
  case (lcr19[3:0])
    4'b0000                             : block_value19 =  95; // 6 bits
    4'b0100                             : block_value19 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value19 = 111; // 7 bits
    4'b1100                             : block_value19 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value19 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value19 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value19 = 159; // 10 bits
    4'b1111                             : block_value19 = 175; // 11 bits
  endcase // case(lcr19[3:0])

// Counting19 time of one character19 minus19 stop bit
always @(posedge clk19 or posedge wb_rst_i19)
begin
  if (wb_rst_i19)
    block_cnt19 <= #1 8'd0;
  else
  if(lsr5r19 & fifo_write19)  // THRE19 bit set & write to fifo occured19
    block_cnt19 <= #1 block_value19;
  else
  if (enable & block_cnt19 != 8'b0)  // only work19 on enable times
    block_cnt19 <= #1 block_cnt19 - 1;  // decrement break counter
end // always of break condition detection19

// Generating19 THRE19 status enable signal19
assign thre_set_en19 = ~(|block_cnt19);


//
//	INTERRUPT19 LOGIC19
//

assign rls_int19  = ier19[`UART_IE_RLS19] && (lsr19[`UART_LS_OE19] || lsr19[`UART_LS_PE19] || lsr19[`UART_LS_FE19] || lsr19[`UART_LS_BI19]);
assign rda_int19  = ier19[`UART_IE_RDA19] && (rf_count19 >= {1'b0,trigger_level19});
assign thre_int19 = ier19[`UART_IE_THRE19] && lsr19[`UART_LS_TFE19];
assign ms_int19   = ier19[`UART_IE_MS19] && (| msr19[3:0]);
assign ti_int19   = ier19[`UART_IE_RDA19] && (counter_t19 == 10'b0) && (|rf_count19);

reg 	 rls_int_d19;
reg 	 thre_int_d19;
reg 	 ms_int_d19;
reg 	 ti_int_d19;
reg 	 rda_int_d19;

// delay lines19
always  @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) rls_int_d19 <= #1 0;
	else rls_int_d19 <= #1 rls_int19;

always  @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) rda_int_d19 <= #1 0;
	else rda_int_d19 <= #1 rda_int19;

always  @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) thre_int_d19 <= #1 0;
	else thre_int_d19 <= #1 thre_int19;

always  @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) ms_int_d19 <= #1 0;
	else ms_int_d19 <= #1 ms_int19;

always  @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) ti_int_d19 <= #1 0;
	else ti_int_d19 <= #1 ti_int19;

// rise19 detection19 signals19

wire 	 rls_int_rise19;
wire 	 thre_int_rise19;
wire 	 ms_int_rise19;
wire 	 ti_int_rise19;
wire 	 rda_int_rise19;

assign rda_int_rise19    = rda_int19 & ~rda_int_d19;
assign rls_int_rise19 	  = rls_int19 & ~rls_int_d19;
assign thre_int_rise19   = thre_int19 & ~thre_int_d19;
assign ms_int_rise19 	  = ms_int19 & ~ms_int_d19;
assign ti_int_rise19 	  = ti_int19 & ~ti_int_d19;

// interrupt19 pending flags19
reg 	rls_int_pnd19;
reg	rda_int_pnd19;
reg 	thre_int_pnd19;
reg 	ms_int_pnd19;
reg 	ti_int_pnd19;

// interrupt19 pending flags19 assignments19
always  @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) rls_int_pnd19 <= #1 0; 
	else 
		rls_int_pnd19 <= #1 lsr_mask19 ? 0 :  						// reset condition
							rls_int_rise19 ? 1 :						// latch19 condition
							rls_int_pnd19 && ier19[`UART_IE_RLS19];	// default operation19: remove if masked19

always  @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) rda_int_pnd19 <= #1 0; 
	else 
		rda_int_pnd19 <= #1 ((rf_count19 == {1'b0,trigger_level19}) && fifo_read19) ? 0 :  	// reset condition
							rda_int_rise19 ? 1 :						// latch19 condition
							rda_int_pnd19 && ier19[`UART_IE_RDA19];	// default operation19: remove if masked19

always  @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) thre_int_pnd19 <= #1 0; 
	else 
		thre_int_pnd19 <= #1 fifo_write19 || (iir_read19 & ~iir19[`UART_II_IP19] & iir19[`UART_II_II19] == `UART_II_THRE19)? 0 : 
							thre_int_rise19 ? 1 :
							thre_int_pnd19 && ier19[`UART_IE_THRE19];

always  @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) ms_int_pnd19 <= #1 0; 
	else 
		ms_int_pnd19 <= #1 msr_read19 ? 0 : 
							ms_int_rise19 ? 1 :
							ms_int_pnd19 && ier19[`UART_IE_MS19];

always  @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) ti_int_pnd19 <= #1 0; 
	else 
		ti_int_pnd19 <= #1 fifo_read19 ? 0 : 
							ti_int_rise19 ? 1 :
							ti_int_pnd19 && ier19[`UART_IE_RDA19];
// end of pending flags19

// INT_O19 logic
always @(posedge clk19 or posedge wb_rst_i19)
begin
	if (wb_rst_i19)	
		int_o19 <= #1 1'b0;
	else
		int_o19 <= #1 
					rls_int_pnd19		?	~lsr_mask19					:
					rda_int_pnd19		? 1								:
					ti_int_pnd19		? ~fifo_read19					:
					thre_int_pnd19	? !(fifo_write19 & iir_read19) :
					ms_int_pnd19		? ~msr_read19						:
					0;	// if no interrupt19 are pending
end


// Interrupt19 Identification19 register
always @(posedge clk19 or posedge wb_rst_i19)
begin
	if (wb_rst_i19)
		iir19 <= #1 1;
	else
	if (rls_int_pnd19)  // interrupt19 is pending
	begin
		iir19[`UART_II_II19] <= #1 `UART_II_RLS19;	// set identification19 register to correct19 value
		iir19[`UART_II_IP19] <= #1 1'b0;		// and clear the IIR19 bit 0 (interrupt19 pending)
	end else // the sequence of conditions19 determines19 priority of interrupt19 identification19
	if (rda_int19)
	begin
		iir19[`UART_II_II19] <= #1 `UART_II_RDA19;
		iir19[`UART_II_IP19] <= #1 1'b0;
	end
	else if (ti_int_pnd19)
	begin
		iir19[`UART_II_II19] <= #1 `UART_II_TI19;
		iir19[`UART_II_IP19] <= #1 1'b0;
	end
	else if (thre_int_pnd19)
	begin
		iir19[`UART_II_II19] <= #1 `UART_II_THRE19;
		iir19[`UART_II_IP19] <= #1 1'b0;
	end
	else if (ms_int_pnd19)
	begin
		iir19[`UART_II_II19] <= #1 `UART_II_MS19;
		iir19[`UART_II_IP19] <= #1 1'b0;
	end else	// no interrupt19 is pending
	begin
		iir19[`UART_II_II19] <= #1 0;
		iir19[`UART_II_IP19] <= #1 1'b1;
	end
end

endmodule
