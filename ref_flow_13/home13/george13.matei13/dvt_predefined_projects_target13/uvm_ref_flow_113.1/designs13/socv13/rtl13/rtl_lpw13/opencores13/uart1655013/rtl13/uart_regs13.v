//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_regs13.v                                                 ////
////                                                              ////
////                                                              ////
////  This13 file is part of the "UART13 16550 compatible13" project13    ////
////  http13://www13.opencores13.org13/cores13/uart1655013/                   ////
////                                                              ////
////  Documentation13 related13 to this project13:                      ////
////  - http13://www13.opencores13.org13/cores13/uart1655013/                 ////
////                                                              ////
////  Projects13 compatibility13:                                     ////
////  - WISHBONE13                                                  ////
////  RS23213 Protocol13                                              ////
////  16550D uart13 (mostly13 supported)                              ////
////                                                              ////
////  Overview13 (main13 Features13):                                   ////
////  Registers13 of the uart13 16550 core13                            ////
////                                                              ////
////  Known13 problems13 (limits13):                                    ////
////  Inserts13 1 wait state in all WISHBONE13 transfers13              ////
////                                                              ////
////  To13 Do13:                                                      ////
////  Nothing or verification13.                                    ////
////                                                              ////
////  Author13(s):                                                  ////
////      - gorban13@opencores13.org13                                  ////
////      - Jacob13 Gorban13                                          ////
////      - Igor13 Mohor13 (igorm13@opencores13.org13)                      ////
////                                                              ////
////  Created13:        2001/05/12                                  ////
////  Last13 Updated13:   (See log13 for the revision13 history13           ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2000, 2001 Authors13                             ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS13 Revision13 History13
//
// $Log: not supported by cvs2svn13 $
// Revision13 1.41  2004/05/21 11:44:41  tadejm13
// Added13 synchronizer13 flops13 for RX13 input.
//
// Revision13 1.40  2003/06/11 16:37:47  gorban13
// This13 fixes13 errors13 in some13 cases13 when data is being read and put to the FIFO at the same time. Patch13 is submitted13 by Scott13 Furman13. Update is very13 recommended13.
//
// Revision13 1.39  2002/07/29 21:16:18  gorban13
// The uart_defines13.v file is included13 again13 in sources13.
//
// Revision13 1.38  2002/07/22 23:02:23  gorban13
// Bug13 Fixes13:
//  * Possible13 loss of sync and bad13 reception13 of stop bit on slow13 baud13 rates13 fixed13.
//   Problem13 reported13 by Kenny13.Tung13.
//  * Bad (or lack13 of ) loopback13 handling13 fixed13. Reported13 by Cherry13 Withers13.
//
// Improvements13:
//  * Made13 FIFO's as general13 inferrable13 memory where possible13.
//  So13 on FPGA13 they should be inferred13 as RAM13 (Distributed13 RAM13 on Xilinx13).
//  This13 saves13 about13 1/3 of the Slice13 count and reduces13 P&R and synthesis13 times.
//
//  * Added13 optional13 baudrate13 output (baud_o13).
//  This13 is identical13 to BAUDOUT13* signal13 on 16550 chip13.
//  It outputs13 16xbit_clock_rate - the divided13 clock13.
//  It's disabled by default. Define13 UART_HAS_BAUDRATE_OUTPUT13 to use.
//
// Revision13 1.37  2001/12/27 13:24:09  mohor13
// lsr13[7] was not showing13 overrun13 errors13.
//
// Revision13 1.36  2001/12/20 13:25:46  mohor13
// rx13 push13 changed to be only one cycle wide13.
//
// Revision13 1.35  2001/12/19 08:03:34  mohor13
// Warnings13 cleared13.
//
// Revision13 1.34  2001/12/19 07:33:54  mohor13
// Synplicity13 was having13 troubles13 with the comment13.
//
// Revision13 1.33  2001/12/17 10:14:43  mohor13
// Things13 related13 to msr13 register changed. After13 THRE13 IRQ13 occurs13, and one
// character13 is written13 to the transmit13 fifo, the detection13 of the THRE13 bit in the
// LSR13 is delayed13 for one character13 time.
//
// Revision13 1.32  2001/12/14 13:19:24  mohor13
// MSR13 register fixed13.
//
// Revision13 1.31  2001/12/14 10:06:58  mohor13
// After13 reset modem13 status register MSR13 should be reset.
//
// Revision13 1.30  2001/12/13 10:09:13  mohor13
// thre13 irq13 should be cleared13 only when being source13 of interrupt13.
//
// Revision13 1.29  2001/12/12 09:05:46  mohor13
// LSR13 status bit 0 was not cleared13 correctly in case of reseting13 the FCR13 (rx13 fifo).
//
// Revision13 1.28  2001/12/10 19:52:41  gorban13
// Scratch13 register added
//
// Revision13 1.27  2001/12/06 14:51:04  gorban13
// Bug13 in LSR13[0] is fixed13.
// All WISHBONE13 signals13 are now sampled13, so another13 wait-state is introduced13 on all transfers13.
//
// Revision13 1.26  2001/12/03 21:44:29  gorban13
// Updated13 specification13 documentation.
// Added13 full 32-bit data bus interface, now as default.
// Address is 5-bit wide13 in 32-bit data bus mode.
// Added13 wb_sel_i13 input to the core13. It's used in the 32-bit mode.
// Added13 debug13 interface with two13 32-bit read-only registers in 32-bit mode.
// Bits13 5 and 6 of LSR13 are now only cleared13 on TX13 FIFO write.
// My13 small test bench13 is modified to work13 with 32-bit mode.
//
// Revision13 1.25  2001/11/28 19:36:39  gorban13
// Fixed13: timeout and break didn13't pay13 attention13 to current data format13 when counting13 time
//
// Revision13 1.24  2001/11/26 21:38:54  gorban13
// Lots13 of fixes13:
// Break13 condition wasn13't handled13 correctly at all.
// LSR13 bits could lose13 their13 values.
// LSR13 value after reset was wrong13.
// Timing13 of THRE13 interrupt13 signal13 corrected13.
// LSR13 bit 0 timing13 corrected13.
//
// Revision13 1.23  2001/11/12 21:57:29  gorban13
// fixed13 more typo13 bugs13
//
// Revision13 1.22  2001/11/12 15:02:28  mohor13
// lsr1r13 error fixed13.
//
// Revision13 1.21  2001/11/12 14:57:27  mohor13
// ti_int_pnd13 error fixed13.
//
// Revision13 1.20  2001/11/12 14:50:27  mohor13
// ti_int_d13 error fixed13.
//
// Revision13 1.19  2001/11/10 12:43:21  gorban13
// Logic13 Synthesis13 bugs13 fixed13. Some13 other minor13 changes13
//
// Revision13 1.18  2001/11/08 14:54:23  mohor13
// Comments13 in Slovene13 language13 deleted13, few13 small fixes13 for better13 work13 of
// old13 tools13. IRQs13 need to be fix13.
//
// Revision13 1.17  2001/11/07 17:51:52  gorban13
// Heavily13 rewritten13 interrupt13 and LSR13 subsystems13.
// Many13 bugs13 hopefully13 squashed13.
//
// Revision13 1.16  2001/11/02 09:55:16  mohor13
// no message
//
// Revision13 1.15  2001/10/31 15:19:22  gorban13
// Fixes13 to break and timeout conditions13
//
// Revision13 1.14  2001/10/29 17:00:46  gorban13
// fixed13 parity13 sending13 and tx_fifo13 resets13 over- and underrun13
//
// Revision13 1.13  2001/10/20 09:58:40  gorban13
// Small13 synopsis13 fixes13
//
// Revision13 1.12  2001/10/19 16:21:40  gorban13
// Changes13 data_out13 to be synchronous13 again13 as it should have been.
//
// Revision13 1.11  2001/10/18 20:35:45  gorban13
// small fix13
//
// Revision13 1.10  2001/08/24 21:01:12  mohor13
// Things13 connected13 to parity13 changed.
// Clock13 devider13 changed.
//
// Revision13 1.9  2001/08/23 16:05:05  mohor13
// Stop bit bug13 fixed13.
// Parity13 bug13 fixed13.
// WISHBONE13 read cycle bug13 fixed13,
// OE13 indicator13 (Overrun13 Error) bug13 fixed13.
// PE13 indicator13 (Parity13 Error) bug13 fixed13.
// Register read bug13 fixed13.
//
// Revision13 1.10  2001/06/23 11:21:48  gorban13
// DL13 made13 16-bit long13. Fixed13 transmission13/reception13 bugs13.
//
// Revision13 1.9  2001/05/31 20:08:01  gorban13
// FIFO changes13 and other corrections13.
//
// Revision13 1.8  2001/05/29 20:05:04  gorban13
// Fixed13 some13 bugs13 and synthesis13 problems13.
//
// Revision13 1.7  2001/05/27 17:37:49  gorban13
// Fixed13 many13 bugs13. Updated13 spec13. Changed13 FIFO files structure13. See CHANGES13.txt13 file.
//
// Revision13 1.6  2001/05/21 19:12:02  gorban13
// Corrected13 some13 Linter13 messages13.
//
// Revision13 1.5  2001/05/17 18:34:18  gorban13
// First13 'stable' release. Should13 be sythesizable13 now. Also13 added new header.
//
// Revision13 1.0  2001-05-17 21:27:11+02  jacob13
// Initial13 revision13
//
//

// synopsys13 translate_off13
`include "timescale.v"
// synopsys13 translate_on13

`include "uart_defines13.v"

`define UART_DL113 7:0
`define UART_DL213 15:8

module uart_regs13 (clk13,
	wb_rst_i13, wb_addr_i13, wb_dat_i13, wb_dat_o13, wb_we_i13, wb_re_i13, 

// additional13 signals13
	modem_inputs13,
	stx_pad_o13, srx_pad_i13,

`ifdef DATA_BUS_WIDTH_813
`else
// debug13 interface signals13	enabled
ier13, iir13, fcr13, mcr13, lcr13, msr13, lsr13, rf_count13, tf_count13, tstate13, rstate,
`endif				
	rts_pad_o13, dtr_pad_o13, int_o13
`ifdef UART_HAS_BAUDRATE_OUTPUT13
	, baud_o13
`endif

	);

input 									clk13;
input 									wb_rst_i13;
input [`UART_ADDR_WIDTH13-1:0] 		wb_addr_i13;
input [7:0] 							wb_dat_i13;
output [7:0] 							wb_dat_o13;
input 									wb_we_i13;
input 									wb_re_i13;

output 									stx_pad_o13;
input 									srx_pad_i13;

input [3:0] 							modem_inputs13;
output 									rts_pad_o13;
output 									dtr_pad_o13;
output 									int_o13;
`ifdef UART_HAS_BAUDRATE_OUTPUT13
output	baud_o13;
`endif

`ifdef DATA_BUS_WIDTH_813
`else
// if 32-bit databus13 and debug13 interface are enabled
output [3:0]							ier13;
output [3:0]							iir13;
output [1:0]							fcr13;  /// bits 7 and 6 of fcr13. Other13 bits are ignored
output [4:0]							mcr13;
output [7:0]							lcr13;
output [7:0]							msr13;
output [7:0] 							lsr13;
output [`UART_FIFO_COUNTER_W13-1:0] 	rf_count13;
output [`UART_FIFO_COUNTER_W13-1:0] 	tf_count13;
output [2:0] 							tstate13;
output [3:0] 							rstate;

`endif

wire [3:0] 								modem_inputs13;
reg 										enable;
`ifdef UART_HAS_BAUDRATE_OUTPUT13
assign baud_o13 = enable; // baud_o13 is actually13 the enable signal13
`endif


wire 										stx_pad_o13;		// received13 from transmitter13 module
wire 										srx_pad_i13;
wire 										srx_pad13;

reg [7:0] 								wb_dat_o13;

wire [`UART_ADDR_WIDTH13-1:0] 		wb_addr_i13;
wire [7:0] 								wb_dat_i13;


reg [3:0] 								ier13;
reg [3:0] 								iir13;
reg [1:0] 								fcr13;  /// bits 7 and 6 of fcr13. Other13 bits are ignored
reg [4:0] 								mcr13;
reg [7:0] 								lcr13;
reg [7:0] 								msr13;
reg [15:0] 								dl13;  // 32-bit divisor13 latch13
reg [7:0] 								scratch13; // UART13 scratch13 register
reg 										start_dlc13; // activate13 dlc13 on writing to UART_DL113
reg 										lsr_mask_d13; // delay for lsr_mask13 condition
reg 										msi_reset13; // reset MSR13 4 lower13 bits indicator13
//reg 										threi_clear13; // THRE13 interrupt13 clear flag13
reg [15:0] 								dlc13;  // 32-bit divisor13 latch13 counter
reg 										int_o13;

reg [3:0] 								trigger_level13; // trigger level of the receiver13 FIFO
reg 										rx_reset13;
reg 										tx_reset13;

wire 										dlab13;			   // divisor13 latch13 access bit
wire 										cts_pad_i13, dsr_pad_i13, ri_pad_i13, dcd_pad_i13; // modem13 status bits
wire 										loopback13;		   // loopback13 bit (MCR13 bit 4)
wire 										cts13, dsr13, ri, dcd13;	   // effective13 signals13
wire                    cts_c13, dsr_c13, ri_c13, dcd_c13; // Complement13 effective13 signals13 (considering13 loopback13)
wire 										rts_pad_o13, dtr_pad_o13;		   // modem13 control13 outputs13

// LSR13 bits wires13 and regs
wire [7:0] 								lsr13;
wire 										lsr013, lsr113, lsr213, lsr313, lsr413, lsr513, lsr613, lsr713;
reg										lsr0r13, lsr1r13, lsr2r13, lsr3r13, lsr4r13, lsr5r13, lsr6r13, lsr7r13;
wire 										lsr_mask13; // lsr_mask13

//
// ASSINGS13
//

assign 									lsr13[7:0] = { lsr7r13, lsr6r13, lsr5r13, lsr4r13, lsr3r13, lsr2r13, lsr1r13, lsr0r13 };

assign 									{cts_pad_i13, dsr_pad_i13, ri_pad_i13, dcd_pad_i13} = modem_inputs13;
assign 									{cts13, dsr13, ri, dcd13} = ~{cts_pad_i13,dsr_pad_i13,ri_pad_i13,dcd_pad_i13};

assign                  {cts_c13, dsr_c13, ri_c13, dcd_c13} = loopback13 ? {mcr13[`UART_MC_RTS13],mcr13[`UART_MC_DTR13],mcr13[`UART_MC_OUT113],mcr13[`UART_MC_OUT213]}
                                                               : {cts_pad_i13,dsr_pad_i13,ri_pad_i13,dcd_pad_i13};

assign 									dlab13 = lcr13[`UART_LC_DL13];
assign 									loopback13 = mcr13[4];

// assign modem13 outputs13
assign 									rts_pad_o13 = mcr13[`UART_MC_RTS13];
assign 									dtr_pad_o13 = mcr13[`UART_MC_DTR13];

// Interrupt13 signals13
wire 										rls_int13;  // receiver13 line status interrupt13
wire 										rda_int13;  // receiver13 data available interrupt13
wire 										ti_int13;   // timeout indicator13 interrupt13
wire										thre_int13; // transmitter13 holding13 register empty13 interrupt13
wire 										ms_int13;   // modem13 status interrupt13

// FIFO signals13
reg 										tf_push13;
reg 										rf_pop13;
wire [`UART_FIFO_REC_WIDTH13-1:0] 	rf_data_out13;
wire 										rf_error_bit13; // an error (parity13 or framing13) is inside the fifo
wire [`UART_FIFO_COUNTER_W13-1:0] 	rf_count13;
wire [`UART_FIFO_COUNTER_W13-1:0] 	tf_count13;
wire [2:0] 								tstate13;
wire [3:0] 								rstate;
wire [9:0] 								counter_t13;

wire                      thre_set_en13; // THRE13 status is delayed13 one character13 time when a character13 is written13 to fifo.
reg  [7:0]                block_cnt13;   // While13 counter counts13, THRE13 status is blocked13 (delayed13 one character13 cycle)
reg  [7:0]                block_value13; // One13 character13 length minus13 stop bit

// Transmitter13 Instance
wire serial_out13;

uart_transmitter13 transmitter13(clk13, wb_rst_i13, lcr13, tf_push13, wb_dat_i13, enable, serial_out13, tstate13, tf_count13, tx_reset13, lsr_mask13);

  // Synchronizing13 and sampling13 serial13 RX13 input
  uart_sync_flops13    i_uart_sync_flops13
  (
    .rst_i13           (wb_rst_i13),
    .clk_i13           (clk13),
    .stage1_rst_i13    (1'b0),
    .stage1_clk_en_i13 (1'b1),
    .async_dat_i13     (srx_pad_i13),
    .sync_dat_o13      (srx_pad13)
  );
  defparam i_uart_sync_flops13.width      = 1;
  defparam i_uart_sync_flops13.init_value13 = 1'b1;

// handle loopback13
wire serial_in13 = loopback13 ? serial_out13 : srx_pad13;
assign stx_pad_o13 = loopback13 ? 1'b1 : serial_out13;

// Receiver13 Instance
uart_receiver13 receiver13(clk13, wb_rst_i13, lcr13, rf_pop13, serial_in13, enable, 
	counter_t13, rf_count13, rf_data_out13, rf_error_bit13, rf_overrun13, rx_reset13, lsr_mask13, rstate, rf_push_pulse13);


// Asynchronous13 reading here13 because the outputs13 are sampled13 in uart_wb13.v file 
always @(dl13 or dlab13 or ier13 or iir13 or scratch13
			or lcr13 or lsr13 or msr13 or rf_data_out13 or wb_addr_i13 or wb_re_i13)   // asynchrounous13 reading
begin
	case (wb_addr_i13)
		`UART_REG_RB13   : wb_dat_o13 = dlab13 ? dl13[`UART_DL113] : rf_data_out13[10:3];
		`UART_REG_IE13	: wb_dat_o13 = dlab13 ? dl13[`UART_DL213] : ier13;
		`UART_REG_II13	: wb_dat_o13 = {4'b1100,iir13};
		`UART_REG_LC13	: wb_dat_o13 = lcr13;
		`UART_REG_LS13	: wb_dat_o13 = lsr13;
		`UART_REG_MS13	: wb_dat_o13 = msr13;
		`UART_REG_SR13	: wb_dat_o13 = scratch13;
		default:  wb_dat_o13 = 8'b0; // ??
	endcase // case(wb_addr_i13)
end // always @ (dl13 or dlab13 or ier13 or iir13 or scratch13...


// rf_pop13 signal13 handling13
always @(posedge clk13 or posedge wb_rst_i13)
begin
	if (wb_rst_i13)
		rf_pop13 <= #1 0; 
	else
	if (rf_pop13)	// restore13 the signal13 to 0 after one clock13 cycle
		rf_pop13 <= #1 0;
	else
	if (wb_re_i13 && wb_addr_i13 == `UART_REG_RB13 && !dlab13)
		rf_pop13 <= #1 1; // advance13 read pointer13
end

wire 	lsr_mask_condition13;
wire 	iir_read13;
wire  msr_read13;
wire	fifo_read13;
wire	fifo_write13;

assign lsr_mask_condition13 = (wb_re_i13 && wb_addr_i13 == `UART_REG_LS13 && !dlab13);
assign iir_read13 = (wb_re_i13 && wb_addr_i13 == `UART_REG_II13 && !dlab13);
assign msr_read13 = (wb_re_i13 && wb_addr_i13 == `UART_REG_MS13 && !dlab13);
assign fifo_read13 = (wb_re_i13 && wb_addr_i13 == `UART_REG_RB13 && !dlab13);
assign fifo_write13 = (wb_we_i13 && wb_addr_i13 == `UART_REG_TR13 && !dlab13);

// lsr_mask_d13 delayed13 signal13 handling13
always @(posedge clk13 or posedge wb_rst_i13)
begin
	if (wb_rst_i13)
		lsr_mask_d13 <= #1 0;
	else // reset bits in the Line13 Status Register
		lsr_mask_d13 <= #1 lsr_mask_condition13;
end

// lsr_mask13 is rise13 detected
assign lsr_mask13 = lsr_mask_condition13 && ~lsr_mask_d13;

// msi_reset13 signal13 handling13
always @(posedge clk13 or posedge wb_rst_i13)
begin
	if (wb_rst_i13)
		msi_reset13 <= #1 1;
	else
	if (msi_reset13)
		msi_reset13 <= #1 0;
	else
	if (msr_read13)
		msi_reset13 <= #1 1; // reset bits in Modem13 Status Register
end


//
//   WRITES13 AND13 RESETS13   //
//
// Line13 Control13 Register
always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13)
		lcr13 <= #1 8'b00000011; // 8n1 setting
	else
	if (wb_we_i13 && wb_addr_i13==`UART_REG_LC13)
		lcr13 <= #1 wb_dat_i13;

// Interrupt13 Enable13 Register or UART_DL213
always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13)
	begin
		ier13 <= #1 4'b0000; // no interrupts13 after reset
		dl13[`UART_DL213] <= #1 8'b0;
	end
	else
	if (wb_we_i13 && wb_addr_i13==`UART_REG_IE13)
		if (dlab13)
		begin
			dl13[`UART_DL213] <= #1 wb_dat_i13;
		end
		else
			ier13 <= #1 wb_dat_i13[3:0]; // ier13 uses only 4 lsb


// FIFO Control13 Register and rx_reset13, tx_reset13 signals13
always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) begin
		fcr13 <= #1 2'b11; 
		rx_reset13 <= #1 0;
		tx_reset13 <= #1 0;
	end else
	if (wb_we_i13 && wb_addr_i13==`UART_REG_FC13) begin
		fcr13 <= #1 wb_dat_i13[7:6];
		rx_reset13 <= #1 wb_dat_i13[1];
		tx_reset13 <= #1 wb_dat_i13[2];
	end else begin
		rx_reset13 <= #1 0;
		tx_reset13 <= #1 0;
	end

// Modem13 Control13 Register
always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13)
		mcr13 <= #1 5'b0; 
	else
	if (wb_we_i13 && wb_addr_i13==`UART_REG_MC13)
			mcr13 <= #1 wb_dat_i13[4:0];

// Scratch13 register
// Line13 Control13 Register
always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13)
		scratch13 <= #1 0; // 8n1 setting
	else
	if (wb_we_i13 && wb_addr_i13==`UART_REG_SR13)
		scratch13 <= #1 wb_dat_i13;

// TX_FIFO13 or UART_DL113
always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13)
	begin
		dl13[`UART_DL113]  <= #1 8'b0;
		tf_push13   <= #1 1'b0;
		start_dlc13 <= #1 1'b0;
	end
	else
	if (wb_we_i13 && wb_addr_i13==`UART_REG_TR13)
		if (dlab13)
		begin
			dl13[`UART_DL113] <= #1 wb_dat_i13;
			start_dlc13 <= #1 1'b1; // enable DL13 counter
			tf_push13 <= #1 1'b0;
		end
		else
		begin
			tf_push13   <= #1 1'b1;
			start_dlc13 <= #1 1'b0;
		end // else: !if(dlab13)
	else
	begin
		start_dlc13 <= #1 1'b0;
		tf_push13   <= #1 1'b0;
	end // else: !if(dlab13)

// Receiver13 FIFO trigger level selection logic (asynchronous13 mux13)
always @(fcr13)
	case (fcr13[`UART_FC_TL13])
		2'b00 : trigger_level13 = 1;
		2'b01 : trigger_level13 = 4;
		2'b10 : trigger_level13 = 8;
		2'b11 : trigger_level13 = 14;
	endcase // case(fcr13[`UART_FC_TL13])
	
//
//  STATUS13 REGISTERS13  //
//

// Modem13 Status Register
reg [3:0] delayed_modem_signals13;
always @(posedge clk13 or posedge wb_rst_i13)
begin
	if (wb_rst_i13)
	  begin
  		msr13 <= #1 0;
	  	delayed_modem_signals13[3:0] <= #1 0;
	  end
	else begin
		msr13[`UART_MS_DDCD13:`UART_MS_DCTS13] <= #1 msi_reset13 ? 4'b0 :
			msr13[`UART_MS_DDCD13:`UART_MS_DCTS13] | ({dcd13, ri, dsr13, cts13} ^ delayed_modem_signals13[3:0]);
		msr13[`UART_MS_CDCD13:`UART_MS_CCTS13] <= #1 {dcd_c13, ri_c13, dsr_c13, cts_c13};
		delayed_modem_signals13[3:0] <= #1 {dcd13, ri, dsr13, cts13};
	end
end


// Line13 Status Register

// activation13 conditions13
assign lsr013 = (rf_count13==0 && rf_push_pulse13);  // data in receiver13 fifo available set condition
assign lsr113 = rf_overrun13;     // Receiver13 overrun13 error
assign lsr213 = rf_data_out13[1]; // parity13 error bit
assign lsr313 = rf_data_out13[0]; // framing13 error bit
assign lsr413 = rf_data_out13[2]; // break error in the character13
assign lsr513 = (tf_count13==5'b0 && thre_set_en13);  // transmitter13 fifo is empty13
assign lsr613 = (tf_count13==5'b0 && thre_set_en13 && (tstate13 == /*`S_IDLE13 */ 0)); // transmitter13 empty13
assign lsr713 = rf_error_bit13 | rf_overrun13;

// lsr13 bit013 (receiver13 data available)
reg 	 lsr0_d13;

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr0_d13 <= #1 0;
	else lsr0_d13 <= #1 lsr013;

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr0r13 <= #1 0;
	else lsr0r13 <= #1 (rf_count13==1 && rf_pop13 && !rf_push_pulse13 || rx_reset13) ? 0 : // deassert13 condition
					  lsr0r13 || (lsr013 && ~lsr0_d13); // set on rise13 of lsr013 and keep13 asserted13 until deasserted13 

// lsr13 bit 1 (receiver13 overrun13)
reg lsr1_d13; // delayed13

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr1_d13 <= #1 0;
	else lsr1_d13 <= #1 lsr113;

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr1r13 <= #1 0;
	else	lsr1r13 <= #1	lsr_mask13 ? 0 : lsr1r13 || (lsr113 && ~lsr1_d13); // set on rise13

// lsr13 bit 2 (parity13 error)
reg lsr2_d13; // delayed13

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr2_d13 <= #1 0;
	else lsr2_d13 <= #1 lsr213;

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr2r13 <= #1 0;
	else lsr2r13 <= #1 lsr_mask13 ? 0 : lsr2r13 || (lsr213 && ~lsr2_d13); // set on rise13

// lsr13 bit 3 (framing13 error)
reg lsr3_d13; // delayed13

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr3_d13 <= #1 0;
	else lsr3_d13 <= #1 lsr313;

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr3r13 <= #1 0;
	else lsr3r13 <= #1 lsr_mask13 ? 0 : lsr3r13 || (lsr313 && ~lsr3_d13); // set on rise13

// lsr13 bit 4 (break indicator13)
reg lsr4_d13; // delayed13

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr4_d13 <= #1 0;
	else lsr4_d13 <= #1 lsr413;

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr4r13 <= #1 0;
	else lsr4r13 <= #1 lsr_mask13 ? 0 : lsr4r13 || (lsr413 && ~lsr4_d13);

// lsr13 bit 5 (transmitter13 fifo is empty13)
reg lsr5_d13;

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr5_d13 <= #1 1;
	else lsr5_d13 <= #1 lsr513;

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr5r13 <= #1 1;
	else lsr5r13 <= #1 (fifo_write13) ? 0 :  lsr5r13 || (lsr513 && ~lsr5_d13);

// lsr13 bit 6 (transmitter13 empty13 indicator13)
reg lsr6_d13;

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr6_d13 <= #1 1;
	else lsr6_d13 <= #1 lsr613;

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr6r13 <= #1 1;
	else lsr6r13 <= #1 (fifo_write13) ? 0 : lsr6r13 || (lsr613 && ~lsr6_d13);

// lsr13 bit 7 (error in fifo)
reg lsr7_d13;

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr7_d13 <= #1 0;
	else lsr7_d13 <= #1 lsr713;

always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) lsr7r13 <= #1 0;
	else lsr7r13 <= #1 lsr_mask13 ? 0 : lsr7r13 || (lsr713 && ~lsr7_d13);

// Frequency13 divider13
always @(posedge clk13 or posedge wb_rst_i13) 
begin
	if (wb_rst_i13)
		dlc13 <= #1 0;
	else
		if (start_dlc13 | ~ (|dlc13))
  			dlc13 <= #1 dl13 - 1;               // preset13 counter
		else
			dlc13 <= #1 dlc13 - 1;              // decrement counter
end

// Enable13 signal13 generation13 logic
always @(posedge clk13 or posedge wb_rst_i13)
begin
	if (wb_rst_i13)
		enable <= #1 1'b0;
	else
		if (|dl13 & ~(|dlc13))     // dl13>0 & dlc13==0
			enable <= #1 1'b1;
		else
			enable <= #1 1'b0;
end

// Delaying13 THRE13 status for one character13 cycle after a character13 is written13 to an empty13 fifo.
always @(lcr13)
  case (lcr13[3:0])
    4'b0000                             : block_value13 =  95; // 6 bits
    4'b0100                             : block_value13 = 103; // 6.5 bits
    4'b0001, 4'b1000                    : block_value13 = 111; // 7 bits
    4'b1100                             : block_value13 = 119; // 7.5 bits
    4'b0010, 4'b0101, 4'b1001           : block_value13 = 127; // 8 bits
    4'b0011, 4'b0110, 4'b1010, 4'b1101  : block_value13 = 143; // 9 bits
    4'b0111, 4'b1011, 4'b1110           : block_value13 = 159; // 10 bits
    4'b1111                             : block_value13 = 175; // 11 bits
  endcase // case(lcr13[3:0])

// Counting13 time of one character13 minus13 stop bit
always @(posedge clk13 or posedge wb_rst_i13)
begin
  if (wb_rst_i13)
    block_cnt13 <= #1 8'd0;
  else
  if(lsr5r13 & fifo_write13)  // THRE13 bit set & write to fifo occured13
    block_cnt13 <= #1 block_value13;
  else
  if (enable & block_cnt13 != 8'b0)  // only work13 on enable times
    block_cnt13 <= #1 block_cnt13 - 1;  // decrement break counter
end // always of break condition detection13

// Generating13 THRE13 status enable signal13
assign thre_set_en13 = ~(|block_cnt13);


//
//	INTERRUPT13 LOGIC13
//

assign rls_int13  = ier13[`UART_IE_RLS13] && (lsr13[`UART_LS_OE13] || lsr13[`UART_LS_PE13] || lsr13[`UART_LS_FE13] || lsr13[`UART_LS_BI13]);
assign rda_int13  = ier13[`UART_IE_RDA13] && (rf_count13 >= {1'b0,trigger_level13});
assign thre_int13 = ier13[`UART_IE_THRE13] && lsr13[`UART_LS_TFE13];
assign ms_int13   = ier13[`UART_IE_MS13] && (| msr13[3:0]);
assign ti_int13   = ier13[`UART_IE_RDA13] && (counter_t13 == 10'b0) && (|rf_count13);

reg 	 rls_int_d13;
reg 	 thre_int_d13;
reg 	 ms_int_d13;
reg 	 ti_int_d13;
reg 	 rda_int_d13;

// delay lines13
always  @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) rls_int_d13 <= #1 0;
	else rls_int_d13 <= #1 rls_int13;

always  @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) rda_int_d13 <= #1 0;
	else rda_int_d13 <= #1 rda_int13;

always  @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) thre_int_d13 <= #1 0;
	else thre_int_d13 <= #1 thre_int13;

always  @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) ms_int_d13 <= #1 0;
	else ms_int_d13 <= #1 ms_int13;

always  @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) ti_int_d13 <= #1 0;
	else ti_int_d13 <= #1 ti_int13;

// rise13 detection13 signals13

wire 	 rls_int_rise13;
wire 	 thre_int_rise13;
wire 	 ms_int_rise13;
wire 	 ti_int_rise13;
wire 	 rda_int_rise13;

assign rda_int_rise13    = rda_int13 & ~rda_int_d13;
assign rls_int_rise13 	  = rls_int13 & ~rls_int_d13;
assign thre_int_rise13   = thre_int13 & ~thre_int_d13;
assign ms_int_rise13 	  = ms_int13 & ~ms_int_d13;
assign ti_int_rise13 	  = ti_int13 & ~ti_int_d13;

// interrupt13 pending flags13
reg 	rls_int_pnd13;
reg	rda_int_pnd13;
reg 	thre_int_pnd13;
reg 	ms_int_pnd13;
reg 	ti_int_pnd13;

// interrupt13 pending flags13 assignments13
always  @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) rls_int_pnd13 <= #1 0; 
	else 
		rls_int_pnd13 <= #1 lsr_mask13 ? 0 :  						// reset condition
							rls_int_rise13 ? 1 :						// latch13 condition
							rls_int_pnd13 && ier13[`UART_IE_RLS13];	// default operation13: remove if masked13

always  @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) rda_int_pnd13 <= #1 0; 
	else 
		rda_int_pnd13 <= #1 ((rf_count13 == {1'b0,trigger_level13}) && fifo_read13) ? 0 :  	// reset condition
							rda_int_rise13 ? 1 :						// latch13 condition
							rda_int_pnd13 && ier13[`UART_IE_RDA13];	// default operation13: remove if masked13

always  @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) thre_int_pnd13 <= #1 0; 
	else 
		thre_int_pnd13 <= #1 fifo_write13 || (iir_read13 & ~iir13[`UART_II_IP13] & iir13[`UART_II_II13] == `UART_II_THRE13)? 0 : 
							thre_int_rise13 ? 1 :
							thre_int_pnd13 && ier13[`UART_IE_THRE13];

always  @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) ms_int_pnd13 <= #1 0; 
	else 
		ms_int_pnd13 <= #1 msr_read13 ? 0 : 
							ms_int_rise13 ? 1 :
							ms_int_pnd13 && ier13[`UART_IE_MS13];

always  @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) ti_int_pnd13 <= #1 0; 
	else 
		ti_int_pnd13 <= #1 fifo_read13 ? 0 : 
							ti_int_rise13 ? 1 :
							ti_int_pnd13 && ier13[`UART_IE_RDA13];
// end of pending flags13

// INT_O13 logic
always @(posedge clk13 or posedge wb_rst_i13)
begin
	if (wb_rst_i13)	
		int_o13 <= #1 1'b0;
	else
		int_o13 <= #1 
					rls_int_pnd13		?	~lsr_mask13					:
					rda_int_pnd13		? 1								:
					ti_int_pnd13		? ~fifo_read13					:
					thre_int_pnd13	? !(fifo_write13 & iir_read13) :
					ms_int_pnd13		? ~msr_read13						:
					0;	// if no interrupt13 are pending
end


// Interrupt13 Identification13 register
always @(posedge clk13 or posedge wb_rst_i13)
begin
	if (wb_rst_i13)
		iir13 <= #1 1;
	else
	if (rls_int_pnd13)  // interrupt13 is pending
	begin
		iir13[`UART_II_II13] <= #1 `UART_II_RLS13;	// set identification13 register to correct13 value
		iir13[`UART_II_IP13] <= #1 1'b0;		// and clear the IIR13 bit 0 (interrupt13 pending)
	end else // the sequence of conditions13 determines13 priority of interrupt13 identification13
	if (rda_int13)
	begin
		iir13[`UART_II_II13] <= #1 `UART_II_RDA13;
		iir13[`UART_II_IP13] <= #1 1'b0;
	end
	else if (ti_int_pnd13)
	begin
		iir13[`UART_II_II13] <= #1 `UART_II_TI13;
		iir13[`UART_II_IP13] <= #1 1'b0;
	end
	else if (thre_int_pnd13)
	begin
		iir13[`UART_II_II13] <= #1 `UART_II_THRE13;
		iir13[`UART_II_IP13] <= #1 1'b0;
	end
	else if (ms_int_pnd13)
	begin
		iir13[`UART_II_II13] <= #1 `UART_II_MS13;
		iir13[`UART_II_IP13] <= #1 1'b0;
	end else	// no interrupt13 is pending
	begin
		iir13[`UART_II_II13] <= #1 0;
		iir13[`UART_II_IP13] <= #1 1'b1;
	end
end

endmodule
