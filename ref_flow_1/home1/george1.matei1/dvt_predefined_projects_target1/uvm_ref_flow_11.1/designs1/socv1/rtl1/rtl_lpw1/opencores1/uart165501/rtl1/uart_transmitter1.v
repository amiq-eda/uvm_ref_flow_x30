//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter1.v                                          ////
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
////  UART1 core1 transmitter1 logic                                 ////
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
// Revision1 1.18  2002/07/22 23:02:23  gorban1
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
// Revision1 1.16  2002/01/08 11:29:40  mohor1
// tf_pop1 was too wide1. Now1 it is only 1 clk1 cycle width.
//
// Revision1 1.15  2001/12/17 14:46:48  mohor1
// overrun1 signal1 was moved to separate1 block because many1 sequential1 lsr1
// reads were1 preventing1 data from being written1 to rx1 fifo.
// underrun1 signal1 was not used and was removed from the project1.
//
// Revision1 1.14  2001/12/03 21:44:29  gorban1
// Updated1 specification1 documentation.
// Added1 full 32-bit data bus interface, now as default.
// Address is 5-bit wide1 in 32-bit data bus mode.
// Added1 wb_sel_i1 input to the core1. It's used in the 32-bit mode.
// Added1 debug1 interface with two1 32-bit read-only registers in 32-bit mode.
// Bits1 5 and 6 of LSR1 are now only cleared1 on TX1 FIFO write.
// My1 small test bench1 is modified to work1 with 32-bit mode.
//
// Revision1 1.13  2001/11/08 14:54:23  mohor1
// Comments1 in Slovene1 language1 deleted1, few1 small fixes1 for better1 work1 of
// old1 tools1. IRQs1 need to be fix1.
//
// Revision1 1.12  2001/11/07 17:51:52  gorban1
// Heavily1 rewritten1 interrupt1 and LSR1 subsystems1.
// Many1 bugs1 hopefully1 squashed1.
//
// Revision1 1.11  2001/10/29 17:00:46  gorban1
// fixed1 parity1 sending1 and tx_fifo1 resets1 over- and underrun1
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
// Revision1 1.0  2001-05-17 21:27:12+02  jacob1
// Initial1 revision1
//
//

// synopsys1 translate_off1
`include "timescale.v"
// synopsys1 translate_on1

`include "uart_defines1.v"

module uart_transmitter1 (clk1, wb_rst_i1, lcr1, tf_push1, wb_dat_i1, enable,	stx_pad_o1, tstate1, tf_count1, tx_reset1, lsr_mask1);

input 										clk1;
input 										wb_rst_i1;
input [7:0] 								lcr1;
input 										tf_push1;
input [7:0] 								wb_dat_i1;
input 										enable;
input 										tx_reset1;
input 										lsr_mask1; //reset of fifo
output 										stx_pad_o1;
output [2:0] 								tstate1;
output [`UART_FIFO_COUNTER_W1-1:0] 	tf_count1;

reg [2:0] 									tstate1;
reg [4:0] 									counter;
reg [2:0] 									bit_counter1;   // counts1 the bits to be sent1
reg [6:0] 									shift_out1;	// output shift1 register
reg 											stx_o_tmp1;
reg 											parity_xor1;  // parity1 of the word1
reg 											tf_pop1;
reg 											bit_out1;

// TX1 FIFO instance
//
// Transmitter1 FIFO signals1
wire [`UART_FIFO_WIDTH1-1:0] 			tf_data_in1;
wire [`UART_FIFO_WIDTH1-1:0] 			tf_data_out1;
wire 											tf_push1;
wire 											tf_overrun1;
wire [`UART_FIFO_COUNTER_W1-1:0] 		tf_count1;

assign 										tf_data_in1 = wb_dat_i1;

uart_tfifo1 fifo_tx1(	// error bit signal1 is not used in transmitter1 FIFO
	.clk1(		clk1		), 
	.wb_rst_i1(	wb_rst_i1	),
	.data_in1(	tf_data_in1	),
	.data_out1(	tf_data_out1	),
	.push1(		tf_push1		),
	.pop1(		tf_pop1		),
	.overrun1(	tf_overrun1	),
	.count(		tf_count1	),
	.fifo_reset1(	tx_reset1	),
	.reset_status1(lsr_mask1)
);

// TRANSMITTER1 FINAL1 STATE1 MACHINE1

parameter s_idle1        = 3'd0;
parameter s_send_start1  = 3'd1;
parameter s_send_byte1   = 3'd2;
parameter s_send_parity1 = 3'd3;
parameter s_send_stop1   = 3'd4;
parameter s_pop_byte1    = 3'd5;

always @(posedge clk1 or posedge wb_rst_i1)
begin
  if (wb_rst_i1)
  begin
	tstate1       <= #1 s_idle1;
	stx_o_tmp1       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out1   <= #1 7'b0;
	bit_out1     <= #1 1'b0;
	parity_xor1  <= #1 1'b0;
	tf_pop1      <= #1 1'b0;
	bit_counter1 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate1)
	s_idle1	 :	if (~|tf_count1) // if tf_count1==0
			begin
				tstate1 <= #1 s_idle1;
				stx_o_tmp1 <= #1 1'b1;
			end
			else
			begin
				tf_pop1 <= #1 1'b0;
				stx_o_tmp1  <= #1 1'b1;
				tstate1  <= #1 s_pop_byte1;
			end
	s_pop_byte1 :	begin
				tf_pop1 <= #1 1'b1;
				case (lcr1[/*`UART_LC_BITS1*/1:0])  // number1 of bits in a word1
				2'b00 : begin
					bit_counter1 <= #1 3'b100;
					parity_xor1  <= #1 ^tf_data_out1[4:0];
				     end
				2'b01 : begin
					bit_counter1 <= #1 3'b101;
					parity_xor1  <= #1 ^tf_data_out1[5:0];
				     end
				2'b10 : begin
					bit_counter1 <= #1 3'b110;
					parity_xor1  <= #1 ^tf_data_out1[6:0];
				     end
				2'b11 : begin
					bit_counter1 <= #1 3'b111;
					parity_xor1  <= #1 ^tf_data_out1[7:0];
				     end
				endcase
				{shift_out1[6:0], bit_out1} <= #1 tf_data_out1;
				tstate1 <= #1 s_send_start1;
			end
	s_send_start1 :	begin
				tf_pop1 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate1 <= #1 s_send_byte1;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp1 <= #1 1'b0;
			end
	s_send_byte1 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter1 > 3'b0)
					begin
						bit_counter1 <= #1 bit_counter1 - 1'b1;
						{shift_out1[5:0],bit_out1  } <= #1 {shift_out1[6:1], shift_out1[0]};
						tstate1 <= #1 s_send_byte1;
					end
					else   // end of byte
					if (~lcr1[`UART_LC_PE1])
					begin
						tstate1 <= #1 s_send_stop1;
					end
					else
					begin
						case ({lcr1[`UART_LC_EP1],lcr1[`UART_LC_SP1]})
						2'b00:	bit_out1 <= #1 ~parity_xor1;
						2'b01:	bit_out1 <= #1 1'b1;
						2'b10:	bit_out1 <= #1 parity_xor1;
						2'b11:	bit_out1 <= #1 1'b0;
						endcase
						tstate1 <= #1 s_send_parity1;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp1 <= #1 bit_out1; // set output pin1
			end
	s_send_parity1 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate1 <= #1 s_send_stop1;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp1 <= #1 bit_out1;
			end
	s_send_stop1 :  begin
				if (~|counter)
				  begin
						casex ({lcr1[`UART_LC_SB1],lcr1[`UART_LC_BITS1]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor1
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate1 <= #1 s_idle1;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp1 <= #1 1'b1;
			end

		default : // should never get here1
			tstate1 <= #1 s_idle1;
	endcase
  end // end if enable
  else
    tf_pop1 <= #1 1'b0;  // tf_pop1 must be 1 cycle width
end // transmitter1 logic

assign stx_pad_o1 = lcr1[`UART_LC_BC1] ? 1'b0 : stx_o_tmp1;    // Break1 condition
	
endmodule
