//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver29.v                                             ////
////                                                              ////
////                                                              ////
////  This29 file is part of the "UART29 16550 compatible29" project29    ////
////  http29://www29.opencores29.org29/cores29/uart1655029/                   ////
////                                                              ////
////  Documentation29 related29 to this project29:                      ////
////  - http29://www29.opencores29.org29/cores29/uart1655029/                 ////
////                                                              ////
////  Projects29 compatibility29:                                     ////
////  - WISHBONE29                                                  ////
////  RS23229 Protocol29                                              ////
////  16550D uart29 (mostly29 supported)                              ////
////                                                              ////
////  Overview29 (main29 Features29):                                   ////
////  UART29 core29 receiver29 logic                                    ////
////                                                              ////
////  Known29 problems29 (limits29):                                    ////
////  None29 known29                                                  ////
////                                                              ////
////  To29 Do29:                                                      ////
////  Thourough29 testing29.                                          ////
////                                                              ////
////  Author29(s):                                                  ////
////      - gorban29@opencores29.org29                                  ////
////      - Jacob29 Gorban29                                          ////
////      - Igor29 Mohor29 (igorm29@opencores29.org29)                      ////
////                                                              ////
////  Created29:        2001/05/12                                  ////
////  Last29 Updated29:   2001/05/17                                  ////
////                  (See log29 for the revision29 history29)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2000, 2001 Authors29                             ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS29 Revision29 History29
//
// $Log: not supported by cvs2svn29 $
// Revision29 1.29  2002/07/29 21:16:18  gorban29
// The uart_defines29.v file is included29 again29 in sources29.
//
// Revision29 1.28  2002/07/22 23:02:23  gorban29
// Bug29 Fixes29:
//  * Possible29 loss of sync and bad29 reception29 of stop bit on slow29 baud29 rates29 fixed29.
//   Problem29 reported29 by Kenny29.Tung29.
//  * Bad (or lack29 of ) loopback29 handling29 fixed29. Reported29 by Cherry29 Withers29.
//
// Improvements29:
//  * Made29 FIFO's as general29 inferrable29 memory where possible29.
//  So29 on FPGA29 they should be inferred29 as RAM29 (Distributed29 RAM29 on Xilinx29).
//  This29 saves29 about29 1/3 of the Slice29 count and reduces29 P&R and synthesis29 times.
//
//  * Added29 optional29 baudrate29 output (baud_o29).
//  This29 is identical29 to BAUDOUT29* signal29 on 16550 chip29.
//  It outputs29 16xbit_clock_rate - the divided29 clock29.
//  It's disabled by default. Define29 UART_HAS_BAUDRATE_OUTPUT29 to use.
//
// Revision29 1.27  2001/12/30 20:39:13  mohor29
// More than one character29 was stored29 in case of break. End29 of the break
// was not detected correctly.
//
// Revision29 1.26  2001/12/20 13:28:27  mohor29
// Missing29 declaration29 of rf_push_q29 fixed29.
//
// Revision29 1.25  2001/12/20 13:25:46  mohor29
// rx29 push29 changed to be only one cycle wide29.
//
// Revision29 1.24  2001/12/19 08:03:34  mohor29
// Warnings29 cleared29.
//
// Revision29 1.23  2001/12/19 07:33:54  mohor29
// Synplicity29 was having29 troubles29 with the comment29.
//
// Revision29 1.22  2001/12/17 14:46:48  mohor29
// overrun29 signal29 was moved to separate29 block because many29 sequential29 lsr29
// reads were29 preventing29 data from being written29 to rx29 fifo.
// underrun29 signal29 was not used and was removed from the project29.
//
// Revision29 1.21  2001/12/13 10:31:16  mohor29
// timeout irq29 must be set regardless29 of the rda29 irq29 (rda29 irq29 does not reset the
// timeout counter).
//
// Revision29 1.20  2001/12/10 19:52:05  gorban29
// Igor29 fixed29 break condition bugs29
//
// Revision29 1.19  2001/12/06 14:51:04  gorban29
// Bug29 in LSR29[0] is fixed29.
// All WISHBONE29 signals29 are now sampled29, so another29 wait-state is introduced29 on all transfers29.
//
// Revision29 1.18  2001/12/03 21:44:29  gorban29
// Updated29 specification29 documentation.
// Added29 full 32-bit data bus interface, now as default.
// Address is 5-bit wide29 in 32-bit data bus mode.
// Added29 wb_sel_i29 input to the core29. It's used in the 32-bit mode.
// Added29 debug29 interface with two29 32-bit read-only registers in 32-bit mode.
// Bits29 5 and 6 of LSR29 are now only cleared29 on TX29 FIFO write.
// My29 small test bench29 is modified to work29 with 32-bit mode.
//
// Revision29 1.17  2001/11/28 19:36:39  gorban29
// Fixed29: timeout and break didn29't pay29 attention29 to current data format29 when counting29 time
//
// Revision29 1.16  2001/11/27 22:17:09  gorban29
// Fixed29 bug29 that prevented29 synthesis29 in uart_receiver29.v
//
// Revision29 1.15  2001/11/26 21:38:54  gorban29
// Lots29 of fixes29:
// Break29 condition wasn29't handled29 correctly at all.
// LSR29 bits could lose29 their29 values.
// LSR29 value after reset was wrong29.
// Timing29 of THRE29 interrupt29 signal29 corrected29.
// LSR29 bit 0 timing29 corrected29.
//
// Revision29 1.14  2001/11/10 12:43:21  gorban29
// Logic29 Synthesis29 bugs29 fixed29. Some29 other minor29 changes29
//
// Revision29 1.13  2001/11/08 14:54:23  mohor29
// Comments29 in Slovene29 language29 deleted29, few29 small fixes29 for better29 work29 of
// old29 tools29. IRQs29 need to be fix29.
//
// Revision29 1.12  2001/11/07 17:51:52  gorban29
// Heavily29 rewritten29 interrupt29 and LSR29 subsystems29.
// Many29 bugs29 hopefully29 squashed29.
//
// Revision29 1.11  2001/10/31 15:19:22  gorban29
// Fixes29 to break and timeout conditions29
//
// Revision29 1.10  2001/10/20 09:58:40  gorban29
// Small29 synopsis29 fixes29
//
// Revision29 1.9  2001/08/24 21:01:12  mohor29
// Things29 connected29 to parity29 changed.
// Clock29 devider29 changed.
//
// Revision29 1.8  2001/08/23 16:05:05  mohor29
// Stop bit bug29 fixed29.
// Parity29 bug29 fixed29.
// WISHBONE29 read cycle bug29 fixed29,
// OE29 indicator29 (Overrun29 Error) bug29 fixed29.
// PE29 indicator29 (Parity29 Error) bug29 fixed29.
// Register read bug29 fixed29.
//
// Revision29 1.6  2001/06/23 11:21:48  gorban29
// DL29 made29 16-bit long29. Fixed29 transmission29/reception29 bugs29.
//
// Revision29 1.5  2001/06/02 14:28:14  gorban29
// Fixed29 receiver29 and transmitter29. Major29 bug29 fixed29.
//
// Revision29 1.4  2001/05/31 20:08:01  gorban29
// FIFO changes29 and other corrections29.
//
// Revision29 1.3  2001/05/27 17:37:49  gorban29
// Fixed29 many29 bugs29. Updated29 spec29. Changed29 FIFO files structure29. See CHANGES29.txt29 file.
//
// Revision29 1.2  2001/05/21 19:12:02  gorban29
// Corrected29 some29 Linter29 messages29.
//
// Revision29 1.1  2001/05/17 18:34:18  gorban29
// First29 'stable' release. Should29 be sythesizable29 now. Also29 added new header.
//
// Revision29 1.0  2001-05-17 21:27:11+02  jacob29
// Initial29 revision29
//
//

// synopsys29 translate_off29
`include "timescale.v"
// synopsys29 translate_on29

`include "uart_defines29.v"

module uart_receiver29 (clk29, wb_rst_i29, lcr29, rf_pop29, srx_pad_i29, enable, 
	counter_t29, rf_count29, rf_data_out29, rf_error_bit29, rf_overrun29, rx_reset29, lsr_mask29, rstate, rf_push_pulse29);

input				clk29;
input				wb_rst_i29;
input	[7:0]	lcr29;
input				rf_pop29;
input				srx_pad_i29;
input				enable;
input				rx_reset29;
input       lsr_mask29;

output	[9:0]			counter_t29;
output	[`UART_FIFO_COUNTER_W29-1:0]	rf_count29;
output	[`UART_FIFO_REC_WIDTH29-1:0]	rf_data_out29;
output				rf_overrun29;
output				rf_error_bit29;
output [3:0] 		rstate;
output 				rf_push_pulse29;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1629;
reg	[2:0]	rbit_counter29;
reg	[7:0]	rshift29;			// receiver29 shift29 register
reg		rparity29;		// received29 parity29
reg		rparity_error29;
reg		rframing_error29;		// framing29 error flag29
reg		rbit_in29;
reg		rparity_xor29;
reg	[7:0]	counter_b29;	// counts29 the 0 (low29) signals29
reg   rf_push_q29;

// RX29 FIFO signals29
reg	[`UART_FIFO_REC_WIDTH29-1:0]	rf_data_in29;
wire	[`UART_FIFO_REC_WIDTH29-1:0]	rf_data_out29;
wire      rf_push_pulse29;
reg				rf_push29;
wire				rf_pop29;
wire				rf_overrun29;
wire	[`UART_FIFO_COUNTER_W29-1:0]	rf_count29;
wire				rf_error_bit29; // an error (parity29 or framing29) is inside the fifo
wire 				break_error29 = (counter_b29 == 0);

// RX29 FIFO instance
uart_rfifo29 #(`UART_FIFO_REC_WIDTH29) fifo_rx29(
	.clk29(		clk29		), 
	.wb_rst_i29(	wb_rst_i29	),
	.data_in29(	rf_data_in29	),
	.data_out29(	rf_data_out29	),
	.push29(		rf_push_pulse29		),
	.pop29(		rf_pop29		),
	.overrun29(	rf_overrun29	),
	.count(		rf_count29	),
	.error_bit29(	rf_error_bit29	),
	.fifo_reset29(	rx_reset29	),
	.reset_status29(lsr_mask29)
);

wire 		rcounter16_eq_729 = (rcounter1629 == 4'd7);
wire		rcounter16_eq_029 = (rcounter1629 == 4'd0);
wire		rcounter16_eq_129 = (rcounter1629 == 4'd1);

wire [3:0] rcounter16_minus_129 = rcounter1629 - 1'b1;

parameter  sr_idle29 					= 4'd0;
parameter  sr_rec_start29 			= 4'd1;
parameter  sr_rec_bit29 				= 4'd2;
parameter  sr_rec_parity29			= 4'd3;
parameter  sr_rec_stop29 				= 4'd4;
parameter  sr_check_parity29 		= 4'd5;
parameter  sr_rec_prepare29 			= 4'd6;
parameter  sr_end_bit29				= 4'd7;
parameter  sr_ca_lc_parity29	      = 4'd8;
parameter  sr_wait129 					= 4'd9;
parameter  sr_push29 					= 4'd10;


always @(posedge clk29 or posedge wb_rst_i29)
begin
  if (wb_rst_i29)
  begin
     rstate 			<= #1 sr_idle29;
	  rbit_in29 				<= #1 1'b0;
	  rcounter1629 			<= #1 0;
	  rbit_counter29 		<= #1 0;
	  rparity_xor29 		<= #1 1'b0;
	  rframing_error29 	<= #1 1'b0;
	  rparity_error29 		<= #1 1'b0;
	  rparity29 				<= #1 1'b0;
	  rshift29 				<= #1 0;
	  rf_push29 				<= #1 1'b0;
	  rf_data_in29 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle29 : begin
			rf_push29 			  <= #1 1'b0;
			rf_data_in29 	  <= #1 0;
			rcounter1629 	  <= #1 4'b1110;
			if (srx_pad_i29==1'b0 & ~break_error29)   // detected a pulse29 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start29;
			end
		end
	sr_rec_start29 :	begin
  			rf_push29 			  <= #1 1'b0;
				if (rcounter16_eq_729)    // check the pulse29
					if (srx_pad_i29==1'b1)   // no start bit
						rstate <= #1 sr_idle29;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare29;
				rcounter1629 <= #1 rcounter16_minus_129;
			end
	sr_rec_prepare29:begin
				case (lcr29[/*`UART_LC_BITS29*/1:0])  // number29 of bits in a word29
				2'b00 : rbit_counter29 <= #1 3'b100;
				2'b01 : rbit_counter29 <= #1 3'b101;
				2'b10 : rbit_counter29 <= #1 3'b110;
				2'b11 : rbit_counter29 <= #1 3'b111;
				endcase
				if (rcounter16_eq_029)
				begin
					rstate		<= #1 sr_rec_bit29;
					rcounter1629	<= #1 4'b1110;
					rshift29		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare29;
				rcounter1629 <= #1 rcounter16_minus_129;
			end
	sr_rec_bit29 :	begin
				if (rcounter16_eq_029)
					rstate <= #1 sr_end_bit29;
				if (rcounter16_eq_729) // read the bit
					case (lcr29[/*`UART_LC_BITS29*/1:0])  // number29 of bits in a word29
					2'b00 : rshift29[4:0]  <= #1 {srx_pad_i29, rshift29[4:1]};
					2'b01 : rshift29[5:0]  <= #1 {srx_pad_i29, rshift29[5:1]};
					2'b10 : rshift29[6:0]  <= #1 {srx_pad_i29, rshift29[6:1]};
					2'b11 : rshift29[7:0]  <= #1 {srx_pad_i29, rshift29[7:1]};
					endcase
				rcounter1629 <= #1 rcounter16_minus_129;
			end
	sr_end_bit29 :   begin
				if (rbit_counter29==3'b0) // no more bits in word29
					if (lcr29[`UART_LC_PE29]) // choose29 state based on parity29
						rstate <= #1 sr_rec_parity29;
					else
					begin
						rstate <= #1 sr_rec_stop29;
						rparity_error29 <= #1 1'b0;  // no parity29 - no error :)
					end
				else		// else we29 have more bits to read
				begin
					rstate <= #1 sr_rec_bit29;
					rbit_counter29 <= #1 rbit_counter29 - 1'b1;
				end
				rcounter1629 <= #1 4'b1110;
			end
	sr_rec_parity29: begin
				if (rcounter16_eq_729)	// read the parity29
				begin
					rparity29 <= #1 srx_pad_i29;
					rstate <= #1 sr_ca_lc_parity29;
				end
				rcounter1629 <= #1 rcounter16_minus_129;
			end
	sr_ca_lc_parity29 : begin    // rcounter29 equals29 6
				rcounter1629  <= #1 rcounter16_minus_129;
				rparity_xor29 <= #1 ^{rshift29,rparity29}; // calculate29 parity29 on all incoming29 data
				rstate      <= #1 sr_check_parity29;
			  end
	sr_check_parity29: begin	  // rcounter29 equals29 5
				case ({lcr29[`UART_LC_EP29],lcr29[`UART_LC_SP29]})
					2'b00: rparity_error29 <= #1  rparity_xor29 == 0;  // no error if parity29 1
					2'b01: rparity_error29 <= #1 ~rparity29;      // parity29 should sticked29 to 1
					2'b10: rparity_error29 <= #1  rparity_xor29 == 1;   // error if parity29 is odd29
					2'b11: rparity_error29 <= #1  rparity29;	  // parity29 should be sticked29 to 0
				endcase
				rcounter1629 <= #1 rcounter16_minus_129;
				rstate <= #1 sr_wait129;
			  end
	sr_wait129 :	if (rcounter16_eq_029)
			begin
				rstate <= #1 sr_rec_stop29;
				rcounter1629 <= #1 4'b1110;
			end
			else
				rcounter1629 <= #1 rcounter16_minus_129;
	sr_rec_stop29 :	begin
				if (rcounter16_eq_729)	// read the parity29
				begin
					rframing_error29 <= #1 !srx_pad_i29; // no framing29 error if input is 1 (stop bit)
					rstate <= #1 sr_push29;
				end
				rcounter1629 <= #1 rcounter16_minus_129;
			end
	sr_push29 :	begin
///////////////////////////////////////
//				$display($time, ": received29: %b", rf_data_in29);
        if(srx_pad_i29 | break_error29)
          begin
            if(break_error29)
        		  rf_data_in29 	<= #1 {8'b0, 3'b100}; // break input (empty29 character29) to receiver29 FIFO
            else
        			rf_data_in29  <= #1 {rshift29, 1'b0, rparity_error29, rframing_error29};
      		  rf_push29 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle29;
          end
        else if(~rframing_error29)  // There's always a framing29 before break_error29 -> wait for break or srx_pad_i29
          begin
       			rf_data_in29  <= #1 {rshift29, 1'b0, rparity_error29, rframing_error29};
      		  rf_push29 		  <= #1 1'b1;
      			rcounter1629 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start29;
          end
                      
			end
	default : rstate <= #1 sr_idle29;
	endcase
  end  // if (enable)
end // always of receiver29

always @ (posedge clk29 or posedge wb_rst_i29)
begin
  if(wb_rst_i29)
    rf_push_q29 <= 0;
  else
    rf_push_q29 <= #1 rf_push29;
end

assign rf_push_pulse29 = rf_push29 & ~rf_push_q29;

  
//
// Break29 condition detection29.
// Works29 in conjuction29 with the receiver29 state machine29

reg 	[9:0]	toc_value29; // value to be set to timeout counter

always @(lcr29)
	case (lcr29[3:0])
		4'b0000										: toc_value29 = 447; // 7 bits
		4'b0100										: toc_value29 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value29 = 511; // 8 bits
		4'b1100										: toc_value29 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value29 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value29 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value29 = 703; // 11 bits
		4'b1111										: toc_value29 = 767; // 12 bits
	endcase // case(lcr29[3:0])

wire [7:0] 	brc_value29; // value to be set to break counter
assign 		brc_value29 = toc_value29[9:2]; // the same as timeout but 1 insead29 of 4 character29 times

always @(posedge clk29 or posedge wb_rst_i29)
begin
	if (wb_rst_i29)
		counter_b29 <= #1 8'd159;
	else
	if (srx_pad_i29)
		counter_b29 <= #1 brc_value29; // character29 time length - 1
	else
	if(enable & counter_b29 != 8'b0)            // only work29 on enable times  break not reached29.
		counter_b29 <= #1 counter_b29 - 1;  // decrement break counter
end // always of break condition detection29

///
/// Timeout29 condition detection29
reg	[9:0]	counter_t29;	// counts29 the timeout condition clocks29

always @(posedge clk29 or posedge wb_rst_i29)
begin
	if (wb_rst_i29)
		counter_t29 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse29 || rf_pop29 || rf_count29 == 0) // counter is reset when RX29 FIFO is empty29, accessed or above29 trigger level
			counter_t29 <= #1 toc_value29;
		else
		if (enable && counter_t29 != 10'b0)  // we29 don29't want29 to underflow29
			counter_t29 <= #1 counter_t29 - 1;		
end
	
endmodule
