//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver1.v                                             ////
////                                                              ////
////                                                              ////
////  This1 file is part of the "UART1 16550 compatible1" project1    ////
////  http1://www1.opencores1.org1/cores1/uart165501/                   ////
////                                                              ////
////  Documentation1 related1 to this project1:                      ////
////  - http1://www1.opencores1.org1/cores1/uart165501/                 ////
////                                                              ////
////  Projects1 compatibility1:                                     ////
////  - WISHBONE1                                                  ////
////  RS2321 Protocol1                                              ////
////  16550D uart1 (mostly1 supported)                              ////
////                                                              ////
////  Overview1 (main1 Features1):                                   ////
////  UART1 core1 receiver1 logic                                    ////
////                                                              ////
////  Known1 problems1 (limits1):                                    ////
////  None1 known1                                                  ////
////                                                              ////
////  To1 Do1:                                                      ////
////  Thourough1 testing1.                                          ////
////                                                              ////
////  Author1(s):                                                  ////
////      - gorban1@opencores1.org1                                  ////
////      - Jacob1 Gorban1                                          ////
////      - Igor1 Mohor1 (igorm1@opencores1.org1)                      ////
////                                                              ////
////  Created1:        2001/05/12                                  ////
////  Last1 Updated1:   2001/05/17                                  ////
////                  (See log1 for the revision1 history1)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright1 (C) 2000, 2001 Authors1                             ////
////                                                              ////
//// This1 source1 file may be used and distributed1 without         ////
//// restriction1 provided that this copyright1 statement1 is not    ////
//// removed from the file and that any derivative1 work1 contains1  ////
//// the original copyright1 notice1 and the associated disclaimer1. ////
////                                                              ////
//// This1 source1 file is free software1; you can redistribute1 it   ////
//// and/or modify it under the terms1 of the GNU1 Lesser1 General1   ////
//// Public1 License1 as published1 by the Free1 Software1 Foundation1; ////
//// either1 version1 2.1 of the License1, or (at your1 option) any   ////
//// later1 version1.                                               ////
////                                                              ////
//// This1 source1 is distributed1 in the hope1 that it will be       ////
//// useful1, but WITHOUT1 ANY1 WARRANTY1; without even1 the implied1   ////
//// warranty1 of MERCHANTABILITY1 or FITNESS1 FOR1 A PARTICULAR1      ////
//// PURPOSE1.  See the GNU1 Lesser1 General1 Public1 License1 for more ////
//// details1.                                                     ////
////                                                              ////
//// You should have received1 a copy of the GNU1 Lesser1 General1    ////
//// Public1 License1 along1 with this source1; if not, download1 it   ////
//// from http1://www1.opencores1.org1/lgpl1.shtml1                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS1 Revision1 History1
//
// $Log: not supported by cvs2svn1 $
// Revision1 1.29  2002/07/29 21:16:18  gorban1
// The uart_defines1.v file is included1 again1 in sources1.
//
// Revision1 1.28  2002/07/22 23:02:23  gorban1
// Bug1 Fixes1:
//  * Possible1 loss of sync and bad1 reception1 of stop bit on slow1 baud1 rates1 fixed1.
//   Problem1 reported1 by Kenny1.Tung1.
//  * Bad (or lack1 of ) loopback1 handling1 fixed1. Reported1 by Cherry1 Withers1.
//
// Improvements1:
//  * Made1 FIFO's as general1 inferrable1 memory where possible1.
//  So1 on FPGA1 they should be inferred1 as RAM1 (Distributed1 RAM1 on Xilinx1).
//  This1 saves1 about1 1/3 of the Slice1 count and reduces1 P&R and synthesis1 times.
//
//  * Added1 optional1 baudrate1 output (baud_o1).
//  This1 is identical1 to BAUDOUT1* signal1 on 16550 chip1.
//  It outputs1 16xbit_clock_rate - the divided1 clock1.
//  It's disabled by default. Define1 UART_HAS_BAUDRATE_OUTPUT1 to use.
//
// Revision1 1.27  2001/12/30 20:39:13  mohor1
// More than one character1 was stored1 in case of break. End1 of the break
// was not detected correctly.
//
// Revision1 1.26  2001/12/20 13:28:27  mohor1
// Missing1 declaration1 of rf_push_q1 fixed1.
//
// Revision1 1.25  2001/12/20 13:25:46  mohor1
// rx1 push1 changed to be only one cycle wide1.
//
// Revision1 1.24  2001/12/19 08:03:34  mohor1
// Warnings1 cleared1.
//
// Revision1 1.23  2001/12/19 07:33:54  mohor1
// Synplicity1 was having1 troubles1 with the comment1.
//
// Revision1 1.22  2001/12/17 14:46:48  mohor1
// overrun1 signal1 was moved to separate1 block because many1 sequential1 lsr1
// reads were1 preventing1 data from being written1 to rx1 fifo.
// underrun1 signal1 was not used and was removed from the project1.
//
// Revision1 1.21  2001/12/13 10:31:16  mohor1
// timeout irq1 must be set regardless1 of the rda1 irq1 (rda1 irq1 does not reset the
// timeout counter).
//
// Revision1 1.20  2001/12/10 19:52:05  gorban1
// Igor1 fixed1 break condition bugs1
//
// Revision1 1.19  2001/12/06 14:51:04  gorban1
// Bug1 in LSR1[0] is fixed1.
// All WISHBONE1 signals1 are now sampled1, so another1 wait-state is introduced1 on all transfers1.
//
// Revision1 1.18  2001/12/03 21:44:29  gorban1
// Updated1 specification1 documentation.
// Added1 full 32-bit data bus interface, now as default.
// Address is 5-bit wide1 in 32-bit data bus mode.
// Added1 wb_sel_i1 input to the core1. It's used in the 32-bit mode.
// Added1 debug1 interface with two1 32-bit read-only registers in 32-bit mode.
// Bits1 5 and 6 of LSR1 are now only cleared1 on TX1 FIFO write.
// My1 small test bench1 is modified to work1 with 32-bit mode.
//
// Revision1 1.17  2001/11/28 19:36:39  gorban1
// Fixed1: timeout and break didn1't pay1 attention1 to current data format1 when counting1 time
//
// Revision1 1.16  2001/11/27 22:17:09  gorban1
// Fixed1 bug1 that prevented1 synthesis1 in uart_receiver1.v
//
// Revision1 1.15  2001/11/26 21:38:54  gorban1
// Lots1 of fixes1:
// Break1 condition wasn1't handled1 correctly at all.
// LSR1 bits could lose1 their1 values.
// LSR1 value after reset was wrong1.
// Timing1 of THRE1 interrupt1 signal1 corrected1.
// LSR1 bit 0 timing1 corrected1.
//
// Revision1 1.14  2001/11/10 12:43:21  gorban1
// Logic1 Synthesis1 bugs1 fixed1. Some1 other minor1 changes1
//
// Revision1 1.13  2001/11/08 14:54:23  mohor1
// Comments1 in Slovene1 language1 deleted1, few1 small fixes1 for better1 work1 of
// old1 tools1. IRQs1 need to be fix1.
//
// Revision1 1.12  2001/11/07 17:51:52  gorban1
// Heavily1 rewritten1 interrupt1 and LSR1 subsystems1.
// Many1 bugs1 hopefully1 squashed1.
//
// Revision1 1.11  2001/10/31 15:19:22  gorban1
// Fixes1 to break and timeout conditions1
//
// Revision1 1.10  2001/10/20 09:58:40  gorban1
// Small1 synopsis1 fixes1
//
// Revision1 1.9  2001/08/24 21:01:12  mohor1
// Things1 connected1 to parity1 changed.
// Clock1 devider1 changed.
//
// Revision1 1.8  2001/08/23 16:05:05  mohor1
// Stop bit bug1 fixed1.
// Parity1 bug1 fixed1.
// WISHBONE1 read cycle bug1 fixed1,
// OE1 indicator1 (Overrun1 Error) bug1 fixed1.
// PE1 indicator1 (Parity1 Error) bug1 fixed1.
// Register read bug1 fixed1.
//
// Revision1 1.6  2001/06/23 11:21:48  gorban1
// DL1 made1 16-bit long1. Fixed1 transmission1/reception1 bugs1.
//
// Revision1 1.5  2001/06/02 14:28:14  gorban1
// Fixed1 receiver1 and transmitter1. Major1 bug1 fixed1.
//
// Revision1 1.4  2001/05/31 20:08:01  gorban1
// FIFO changes1 and other corrections1.
//
// Revision1 1.3  2001/05/27 17:37:49  gorban1
// Fixed1 many1 bugs1. Updated1 spec1. Changed1 FIFO files structure1. See CHANGES1.txt1 file.
//
// Revision1 1.2  2001/05/21 19:12:02  gorban1
// Corrected1 some1 Linter1 messages1.
//
// Revision1 1.1  2001/05/17 18:34:18  gorban1
// First1 'stable' release. Should1 be sythesizable1 now. Also1 added new header.
//
// Revision1 1.0  2001-05-17 21:27:11+02  jacob1
// Initial1 revision1
//
//

// synopsys1 translate_off1
`include "timescale.v"
// synopsys1 translate_on1

`include "uart_defines1.v"

module uart_receiver1 (clk1, wb_rst_i1, lcr1, rf_pop1, srx_pad_i1, enable, 
	counter_t1, rf_count1, rf_data_out1, rf_error_bit1, rf_overrun1, rx_reset1, lsr_mask1, rstate, rf_push_pulse1);

input				clk1;
input				wb_rst_i1;
input	[7:0]	lcr1;
input				rf_pop1;
input				srx_pad_i1;
input				enable;
input				rx_reset1;
input       lsr_mask1;

output	[9:0]			counter_t1;
output	[`UART_FIFO_COUNTER_W1-1:0]	rf_count1;
output	[`UART_FIFO_REC_WIDTH1-1:0]	rf_data_out1;
output				rf_overrun1;
output				rf_error_bit1;
output [3:0] 		rstate;
output 				rf_push_pulse1;

reg	[3:0]	rstate;
reg	[3:0]	rcounter161;
reg	[2:0]	rbit_counter1;
reg	[7:0]	rshift1;			// receiver1 shift1 register
reg		rparity1;		// received1 parity1
reg		rparity_error1;
reg		rframing_error1;		// framing1 error flag1
reg		rbit_in1;
reg		rparity_xor1;
reg	[7:0]	counter_b1;	// counts1 the 0 (low1) signals1
reg   rf_push_q1;

// RX1 FIFO signals1
reg	[`UART_FIFO_REC_WIDTH1-1:0]	rf_data_in1;
wire	[`UART_FIFO_REC_WIDTH1-1:0]	rf_data_out1;
wire      rf_push_pulse1;
reg				rf_push1;
wire				rf_pop1;
wire				rf_overrun1;
wire	[`UART_FIFO_COUNTER_W1-1:0]	rf_count1;
wire				rf_error_bit1; // an error (parity1 or framing1) is inside the fifo
wire 				break_error1 = (counter_b1 == 0);

// RX1 FIFO instance
uart_rfifo1 #(`UART_FIFO_REC_WIDTH1) fifo_rx1(
	.clk1(		clk1		), 
	.wb_rst_i1(	wb_rst_i1	),
	.data_in1(	rf_data_in1	),
	.data_out1(	rf_data_out1	),
	.push1(		rf_push_pulse1		),
	.pop1(		rf_pop1		),
	.overrun1(	rf_overrun1	),
	.count(		rf_count1	),
	.error_bit1(	rf_error_bit1	),
	.fifo_reset1(	rx_reset1	),
	.reset_status1(lsr_mask1)
);

wire 		rcounter16_eq_71 = (rcounter161 == 4'd7);
wire		rcounter16_eq_01 = (rcounter161 == 4'd0);
wire		rcounter16_eq_11 = (rcounter161 == 4'd1);

wire [3:0] rcounter16_minus_11 = rcounter161 - 1'b1;

parameter  sr_idle1 					= 4'd0;
parameter  sr_rec_start1 			= 4'd1;
parameter  sr_rec_bit1 				= 4'd2;
parameter  sr_rec_parity1			= 4'd3;
parameter  sr_rec_stop1 				= 4'd4;
parameter  sr_check_parity1 		= 4'd5;
parameter  sr_rec_prepare1 			= 4'd6;
parameter  sr_end_bit1				= 4'd7;
parameter  sr_ca_lc_parity1	      = 4'd8;
parameter  sr_wait11 					= 4'd9;
parameter  sr_push1 					= 4'd10;


always @(posedge clk1 or posedge wb_rst_i1)
begin
  if (wb_rst_i1)
  begin
     rstate 			<= #1 sr_idle1;
	  rbit_in1 				<= #1 1'b0;
	  rcounter161 			<= #1 0;
	  rbit_counter1 		<= #1 0;
	  rparity_xor1 		<= #1 1'b0;
	  rframing_error1 	<= #1 1'b0;
	  rparity_error1 		<= #1 1'b0;
	  rparity1 				<= #1 1'b0;
	  rshift1 				<= #1 0;
	  rf_push1 				<= #1 1'b0;
	  rf_data_in1 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle1 : begin
			rf_push1 			  <= #1 1'b0;
			rf_data_in1 	  <= #1 0;
			rcounter161 	  <= #1 4'b1110;
			if (srx_pad_i1==1'b0 & ~break_error1)   // detected a pulse1 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start1;
			end
		end
	sr_rec_start1 :	begin
  			rf_push1 			  <= #1 1'b0;
				if (rcounter16_eq_71)    // check the pulse1
					if (srx_pad_i1==1'b1)   // no start bit
						rstate <= #1 sr_idle1;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare1;
				rcounter161 <= #1 rcounter16_minus_11;
			end
	sr_rec_prepare1:begin
				case (lcr1[/*`UART_LC_BITS1*/1:0])  // number1 of bits in a word1
				2'b00 : rbit_counter1 <= #1 3'b100;
				2'b01 : rbit_counter1 <= #1 3'b101;
				2'b10 : rbit_counter1 <= #1 3'b110;
				2'b11 : rbit_counter1 <= #1 3'b111;
				endcase
				if (rcounter16_eq_01)
				begin
					rstate		<= #1 sr_rec_bit1;
					rcounter161	<= #1 4'b1110;
					rshift1		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare1;
				rcounter161 <= #1 rcounter16_minus_11;
			end
	sr_rec_bit1 :	begin
				if (rcounter16_eq_01)
					rstate <= #1 sr_end_bit1;
				if (rcounter16_eq_71) // read the bit
					case (lcr1[/*`UART_LC_BITS1*/1:0])  // number1 of bits in a word1
					2'b00 : rshift1[4:0]  <= #1 {srx_pad_i1, rshift1[4:1]};
					2'b01 : rshift1[5:0]  <= #1 {srx_pad_i1, rshift1[5:1]};
					2'b10 : rshift1[6:0]  <= #1 {srx_pad_i1, rshift1[6:1]};
					2'b11 : rshift1[7:0]  <= #1 {srx_pad_i1, rshift1[7:1]};
					endcase
				rcounter161 <= #1 rcounter16_minus_11;
			end
	sr_end_bit1 :   begin
				if (rbit_counter1==3'b0) // no more bits in word1
					if (lcr1[`UART_LC_PE1]) // choose1 state based on parity1
						rstate <= #1 sr_rec_parity1;
					else
					begin
						rstate <= #1 sr_rec_stop1;
						rparity_error1 <= #1 1'b0;  // no parity1 - no error :)
					end
				else		// else we1 have more bits to read
				begin
					rstate <= #1 sr_rec_bit1;
					rbit_counter1 <= #1 rbit_counter1 - 1'b1;
				end
				rcounter161 <= #1 4'b1110;
			end
	sr_rec_parity1: begin
				if (rcounter16_eq_71)	// read the parity1
				begin
					rparity1 <= #1 srx_pad_i1;
					rstate <= #1 sr_ca_lc_parity1;
				end
				rcounter161 <= #1 rcounter16_minus_11;
			end
	sr_ca_lc_parity1 : begin    // rcounter1 equals1 6
				rcounter161  <= #1 rcounter16_minus_11;
				rparity_xor1 <= #1 ^{rshift1,rparity1}; // calculate1 parity1 on all incoming1 data
				rstate      <= #1 sr_check_parity1;
			  end
	sr_check_parity1: begin	  // rcounter1 equals1 5
				case ({lcr1[`UART_LC_EP1],lcr1[`UART_LC_SP1]})
					2'b00: rparity_error1 <= #1  rparity_xor1 == 0;  // no error if parity1 1
					2'b01: rparity_error1 <= #1 ~rparity1;      // parity1 should sticked1 to 1
					2'b10: rparity_error1 <= #1  rparity_xor1 == 1;   // error if parity1 is odd1
					2'b11: rparity_error1 <= #1  rparity1;	  // parity1 should be sticked1 to 0
				endcase
				rcounter161 <= #1 rcounter16_minus_11;
				rstate <= #1 sr_wait11;
			  end
	sr_wait11 :	if (rcounter16_eq_01)
			begin
				rstate <= #1 sr_rec_stop1;
				rcounter161 <= #1 4'b1110;
			end
			else
				rcounter161 <= #1 rcounter16_minus_11;
	sr_rec_stop1 :	begin
				if (rcounter16_eq_71)	// read the parity1
				begin
					rframing_error1 <= #1 !srx_pad_i1; // no framing1 error if input is 1 (stop bit)
					rstate <= #1 sr_push1;
				end
				rcounter161 <= #1 rcounter16_minus_11;
			end
	sr_push1 :	begin
///////////////////////////////////////
//				$display($time, ": received1: %b", rf_data_in1);
        if(srx_pad_i1 | break_error1)
          begin
            if(break_error1)
        		  rf_data_in1 	<= #1 {8'b0, 3'b100}; // break input (empty1 character1) to receiver1 FIFO
            else
        			rf_data_in1  <= #1 {rshift1, 1'b0, rparity_error1, rframing_error1};
      		  rf_push1 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle1;
          end
        else if(~rframing_error1)  // There's always a framing1 before break_error1 -> wait for break or srx_pad_i1
          begin
       			rf_data_in1  <= #1 {rshift1, 1'b0, rparity_error1, rframing_error1};
      		  rf_push1 		  <= #1 1'b1;
      			rcounter161 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start1;
          end
                      
			end
	default : rstate <= #1 sr_idle1;
	endcase
  end  // if (enable)
end // always of receiver1

always @ (posedge clk1 or posedge wb_rst_i1)
begin
  if(wb_rst_i1)
    rf_push_q1 <= 0;
  else
    rf_push_q1 <= #1 rf_push1;
end

assign rf_push_pulse1 = rf_push1 & ~rf_push_q1;

  
//
// Break1 condition detection1.
// Works1 in conjuction1 with the receiver1 state machine1

reg 	[9:0]	toc_value1; // value to be set to timeout counter

always @(lcr1)
	case (lcr1[3:0])
		4'b0000										: toc_value1 = 447; // 7 bits
		4'b0100										: toc_value1 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value1 = 511; // 8 bits
		4'b1100										: toc_value1 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value1 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value1 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value1 = 703; // 11 bits
		4'b1111										: toc_value1 = 767; // 12 bits
	endcase // case(lcr1[3:0])

wire [7:0] 	brc_value1; // value to be set to break counter
assign 		brc_value1 = toc_value1[9:2]; // the same as timeout but 1 insead1 of 4 character1 times

always @(posedge clk1 or posedge wb_rst_i1)
begin
	if (wb_rst_i1)
		counter_b1 <= #1 8'd159;
	else
	if (srx_pad_i1)
		counter_b1 <= #1 brc_value1; // character1 time length - 1
	else
	if(enable & counter_b1 != 8'b0)            // only work1 on enable times  break not reached1.
		counter_b1 <= #1 counter_b1 - 1;  // decrement break counter
end // always of break condition detection1

///
/// Timeout1 condition detection1
reg	[9:0]	counter_t1;	// counts1 the timeout condition clocks1

always @(posedge clk1 or posedge wb_rst_i1)
begin
	if (wb_rst_i1)
		counter_t1 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse1 || rf_pop1 || rf_count1 == 0) // counter is reset when RX1 FIFO is empty1, accessed or above1 trigger level
			counter_t1 <= #1 toc_value1;
		else
		if (enable && counter_t1 != 10'b0)  // we1 don1't want1 to underflow1
			counter_t1 <= #1 counter_t1 - 1;		
end
	
endmodule
