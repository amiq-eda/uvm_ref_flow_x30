//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver9.v                                             ////
////                                                              ////
////                                                              ////
////  This9 file is part of the "UART9 16550 compatible9" project9    ////
////  http9://www9.opencores9.org9/cores9/uart165509/                   ////
////                                                              ////
////  Documentation9 related9 to this project9:                      ////
////  - http9://www9.opencores9.org9/cores9/uart165509/                 ////
////                                                              ////
////  Projects9 compatibility9:                                     ////
////  - WISHBONE9                                                  ////
////  RS2329 Protocol9                                              ////
////  16550D uart9 (mostly9 supported)                              ////
////                                                              ////
////  Overview9 (main9 Features9):                                   ////
////  UART9 core9 receiver9 logic                                    ////
////                                                              ////
////  Known9 problems9 (limits9):                                    ////
////  None9 known9                                                  ////
////                                                              ////
////  To9 Do9:                                                      ////
////  Thourough9 testing9.                                          ////
////                                                              ////
////  Author9(s):                                                  ////
////      - gorban9@opencores9.org9                                  ////
////      - Jacob9 Gorban9                                          ////
////      - Igor9 Mohor9 (igorm9@opencores9.org9)                      ////
////                                                              ////
////  Created9:        2001/05/12                                  ////
////  Last9 Updated9:   2001/05/17                                  ////
////                  (See log9 for the revision9 history9)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2000, 2001 Authors9                             ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS9 Revision9 History9
//
// $Log: not supported by cvs2svn9 $
// Revision9 1.29  2002/07/29 21:16:18  gorban9
// The uart_defines9.v file is included9 again9 in sources9.
//
// Revision9 1.28  2002/07/22 23:02:23  gorban9
// Bug9 Fixes9:
//  * Possible9 loss of sync and bad9 reception9 of stop bit on slow9 baud9 rates9 fixed9.
//   Problem9 reported9 by Kenny9.Tung9.
//  * Bad (or lack9 of ) loopback9 handling9 fixed9. Reported9 by Cherry9 Withers9.
//
// Improvements9:
//  * Made9 FIFO's as general9 inferrable9 memory where possible9.
//  So9 on FPGA9 they should be inferred9 as RAM9 (Distributed9 RAM9 on Xilinx9).
//  This9 saves9 about9 1/3 of the Slice9 count and reduces9 P&R and synthesis9 times.
//
//  * Added9 optional9 baudrate9 output (baud_o9).
//  This9 is identical9 to BAUDOUT9* signal9 on 16550 chip9.
//  It outputs9 16xbit_clock_rate - the divided9 clock9.
//  It's disabled by default. Define9 UART_HAS_BAUDRATE_OUTPUT9 to use.
//
// Revision9 1.27  2001/12/30 20:39:13  mohor9
// More than one character9 was stored9 in case of break. End9 of the break
// was not detected correctly.
//
// Revision9 1.26  2001/12/20 13:28:27  mohor9
// Missing9 declaration9 of rf_push_q9 fixed9.
//
// Revision9 1.25  2001/12/20 13:25:46  mohor9
// rx9 push9 changed to be only one cycle wide9.
//
// Revision9 1.24  2001/12/19 08:03:34  mohor9
// Warnings9 cleared9.
//
// Revision9 1.23  2001/12/19 07:33:54  mohor9
// Synplicity9 was having9 troubles9 with the comment9.
//
// Revision9 1.22  2001/12/17 14:46:48  mohor9
// overrun9 signal9 was moved to separate9 block because many9 sequential9 lsr9
// reads were9 preventing9 data from being written9 to rx9 fifo.
// underrun9 signal9 was not used and was removed from the project9.
//
// Revision9 1.21  2001/12/13 10:31:16  mohor9
// timeout irq9 must be set regardless9 of the rda9 irq9 (rda9 irq9 does not reset the
// timeout counter).
//
// Revision9 1.20  2001/12/10 19:52:05  gorban9
// Igor9 fixed9 break condition bugs9
//
// Revision9 1.19  2001/12/06 14:51:04  gorban9
// Bug9 in LSR9[0] is fixed9.
// All WISHBONE9 signals9 are now sampled9, so another9 wait-state is introduced9 on all transfers9.
//
// Revision9 1.18  2001/12/03 21:44:29  gorban9
// Updated9 specification9 documentation.
// Added9 full 32-bit data bus interface, now as default.
// Address is 5-bit wide9 in 32-bit data bus mode.
// Added9 wb_sel_i9 input to the core9. It's used in the 32-bit mode.
// Added9 debug9 interface with two9 32-bit read-only registers in 32-bit mode.
// Bits9 5 and 6 of LSR9 are now only cleared9 on TX9 FIFO write.
// My9 small test bench9 is modified to work9 with 32-bit mode.
//
// Revision9 1.17  2001/11/28 19:36:39  gorban9
// Fixed9: timeout and break didn9't pay9 attention9 to current data format9 when counting9 time
//
// Revision9 1.16  2001/11/27 22:17:09  gorban9
// Fixed9 bug9 that prevented9 synthesis9 in uart_receiver9.v
//
// Revision9 1.15  2001/11/26 21:38:54  gorban9
// Lots9 of fixes9:
// Break9 condition wasn9't handled9 correctly at all.
// LSR9 bits could lose9 their9 values.
// LSR9 value after reset was wrong9.
// Timing9 of THRE9 interrupt9 signal9 corrected9.
// LSR9 bit 0 timing9 corrected9.
//
// Revision9 1.14  2001/11/10 12:43:21  gorban9
// Logic9 Synthesis9 bugs9 fixed9. Some9 other minor9 changes9
//
// Revision9 1.13  2001/11/08 14:54:23  mohor9
// Comments9 in Slovene9 language9 deleted9, few9 small fixes9 for better9 work9 of
// old9 tools9. IRQs9 need to be fix9.
//
// Revision9 1.12  2001/11/07 17:51:52  gorban9
// Heavily9 rewritten9 interrupt9 and LSR9 subsystems9.
// Many9 bugs9 hopefully9 squashed9.
//
// Revision9 1.11  2001/10/31 15:19:22  gorban9
// Fixes9 to break and timeout conditions9
//
// Revision9 1.10  2001/10/20 09:58:40  gorban9
// Small9 synopsis9 fixes9
//
// Revision9 1.9  2001/08/24 21:01:12  mohor9
// Things9 connected9 to parity9 changed.
// Clock9 devider9 changed.
//
// Revision9 1.8  2001/08/23 16:05:05  mohor9
// Stop bit bug9 fixed9.
// Parity9 bug9 fixed9.
// WISHBONE9 read cycle bug9 fixed9,
// OE9 indicator9 (Overrun9 Error) bug9 fixed9.
// PE9 indicator9 (Parity9 Error) bug9 fixed9.
// Register read bug9 fixed9.
//
// Revision9 1.6  2001/06/23 11:21:48  gorban9
// DL9 made9 16-bit long9. Fixed9 transmission9/reception9 bugs9.
//
// Revision9 1.5  2001/06/02 14:28:14  gorban9
// Fixed9 receiver9 and transmitter9. Major9 bug9 fixed9.
//
// Revision9 1.4  2001/05/31 20:08:01  gorban9
// FIFO changes9 and other corrections9.
//
// Revision9 1.3  2001/05/27 17:37:49  gorban9
// Fixed9 many9 bugs9. Updated9 spec9. Changed9 FIFO files structure9. See CHANGES9.txt9 file.
//
// Revision9 1.2  2001/05/21 19:12:02  gorban9
// Corrected9 some9 Linter9 messages9.
//
// Revision9 1.1  2001/05/17 18:34:18  gorban9
// First9 'stable' release. Should9 be sythesizable9 now. Also9 added new header.
//
// Revision9 1.0  2001-05-17 21:27:11+02  jacob9
// Initial9 revision9
//
//

// synopsys9 translate_off9
`include "timescale.v"
// synopsys9 translate_on9

`include "uart_defines9.v"

module uart_receiver9 (clk9, wb_rst_i9, lcr9, rf_pop9, srx_pad_i9, enable, 
	counter_t9, rf_count9, rf_data_out9, rf_error_bit9, rf_overrun9, rx_reset9, lsr_mask9, rstate, rf_push_pulse9);

input				clk9;
input				wb_rst_i9;
input	[7:0]	lcr9;
input				rf_pop9;
input				srx_pad_i9;
input				enable;
input				rx_reset9;
input       lsr_mask9;

output	[9:0]			counter_t9;
output	[`UART_FIFO_COUNTER_W9-1:0]	rf_count9;
output	[`UART_FIFO_REC_WIDTH9-1:0]	rf_data_out9;
output				rf_overrun9;
output				rf_error_bit9;
output [3:0] 		rstate;
output 				rf_push_pulse9;

reg	[3:0]	rstate;
reg	[3:0]	rcounter169;
reg	[2:0]	rbit_counter9;
reg	[7:0]	rshift9;			// receiver9 shift9 register
reg		rparity9;		// received9 parity9
reg		rparity_error9;
reg		rframing_error9;		// framing9 error flag9
reg		rbit_in9;
reg		rparity_xor9;
reg	[7:0]	counter_b9;	// counts9 the 0 (low9) signals9
reg   rf_push_q9;

// RX9 FIFO signals9
reg	[`UART_FIFO_REC_WIDTH9-1:0]	rf_data_in9;
wire	[`UART_FIFO_REC_WIDTH9-1:0]	rf_data_out9;
wire      rf_push_pulse9;
reg				rf_push9;
wire				rf_pop9;
wire				rf_overrun9;
wire	[`UART_FIFO_COUNTER_W9-1:0]	rf_count9;
wire				rf_error_bit9; // an error (parity9 or framing9) is inside the fifo
wire 				break_error9 = (counter_b9 == 0);

// RX9 FIFO instance
uart_rfifo9 #(`UART_FIFO_REC_WIDTH9) fifo_rx9(
	.clk9(		clk9		), 
	.wb_rst_i9(	wb_rst_i9	),
	.data_in9(	rf_data_in9	),
	.data_out9(	rf_data_out9	),
	.push9(		rf_push_pulse9		),
	.pop9(		rf_pop9		),
	.overrun9(	rf_overrun9	),
	.count(		rf_count9	),
	.error_bit9(	rf_error_bit9	),
	.fifo_reset9(	rx_reset9	),
	.reset_status9(lsr_mask9)
);

wire 		rcounter16_eq_79 = (rcounter169 == 4'd7);
wire		rcounter16_eq_09 = (rcounter169 == 4'd0);
wire		rcounter16_eq_19 = (rcounter169 == 4'd1);

wire [3:0] rcounter16_minus_19 = rcounter169 - 1'b1;

parameter  sr_idle9 					= 4'd0;
parameter  sr_rec_start9 			= 4'd1;
parameter  sr_rec_bit9 				= 4'd2;
parameter  sr_rec_parity9			= 4'd3;
parameter  sr_rec_stop9 				= 4'd4;
parameter  sr_check_parity9 		= 4'd5;
parameter  sr_rec_prepare9 			= 4'd6;
parameter  sr_end_bit9				= 4'd7;
parameter  sr_ca_lc_parity9	      = 4'd8;
parameter  sr_wait19 					= 4'd9;
parameter  sr_push9 					= 4'd10;


always @(posedge clk9 or posedge wb_rst_i9)
begin
  if (wb_rst_i9)
  begin
     rstate 			<= #1 sr_idle9;
	  rbit_in9 				<= #1 1'b0;
	  rcounter169 			<= #1 0;
	  rbit_counter9 		<= #1 0;
	  rparity_xor9 		<= #1 1'b0;
	  rframing_error9 	<= #1 1'b0;
	  rparity_error9 		<= #1 1'b0;
	  rparity9 				<= #1 1'b0;
	  rshift9 				<= #1 0;
	  rf_push9 				<= #1 1'b0;
	  rf_data_in9 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle9 : begin
			rf_push9 			  <= #1 1'b0;
			rf_data_in9 	  <= #1 0;
			rcounter169 	  <= #1 4'b1110;
			if (srx_pad_i9==1'b0 & ~break_error9)   // detected a pulse9 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start9;
			end
		end
	sr_rec_start9 :	begin
  			rf_push9 			  <= #1 1'b0;
				if (rcounter16_eq_79)    // check the pulse9
					if (srx_pad_i9==1'b1)   // no start bit
						rstate <= #1 sr_idle9;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare9;
				rcounter169 <= #1 rcounter16_minus_19;
			end
	sr_rec_prepare9:begin
				case (lcr9[/*`UART_LC_BITS9*/1:0])  // number9 of bits in a word9
				2'b00 : rbit_counter9 <= #1 3'b100;
				2'b01 : rbit_counter9 <= #1 3'b101;
				2'b10 : rbit_counter9 <= #1 3'b110;
				2'b11 : rbit_counter9 <= #1 3'b111;
				endcase
				if (rcounter16_eq_09)
				begin
					rstate		<= #1 sr_rec_bit9;
					rcounter169	<= #1 4'b1110;
					rshift9		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare9;
				rcounter169 <= #1 rcounter16_minus_19;
			end
	sr_rec_bit9 :	begin
				if (rcounter16_eq_09)
					rstate <= #1 sr_end_bit9;
				if (rcounter16_eq_79) // read the bit
					case (lcr9[/*`UART_LC_BITS9*/1:0])  // number9 of bits in a word9
					2'b00 : rshift9[4:0]  <= #1 {srx_pad_i9, rshift9[4:1]};
					2'b01 : rshift9[5:0]  <= #1 {srx_pad_i9, rshift9[5:1]};
					2'b10 : rshift9[6:0]  <= #1 {srx_pad_i9, rshift9[6:1]};
					2'b11 : rshift9[7:0]  <= #1 {srx_pad_i9, rshift9[7:1]};
					endcase
				rcounter169 <= #1 rcounter16_minus_19;
			end
	sr_end_bit9 :   begin
				if (rbit_counter9==3'b0) // no more bits in word9
					if (lcr9[`UART_LC_PE9]) // choose9 state based on parity9
						rstate <= #1 sr_rec_parity9;
					else
					begin
						rstate <= #1 sr_rec_stop9;
						rparity_error9 <= #1 1'b0;  // no parity9 - no error :)
					end
				else		// else we9 have more bits to read
				begin
					rstate <= #1 sr_rec_bit9;
					rbit_counter9 <= #1 rbit_counter9 - 1'b1;
				end
				rcounter169 <= #1 4'b1110;
			end
	sr_rec_parity9: begin
				if (rcounter16_eq_79)	// read the parity9
				begin
					rparity9 <= #1 srx_pad_i9;
					rstate <= #1 sr_ca_lc_parity9;
				end
				rcounter169 <= #1 rcounter16_minus_19;
			end
	sr_ca_lc_parity9 : begin    // rcounter9 equals9 6
				rcounter169  <= #1 rcounter16_minus_19;
				rparity_xor9 <= #1 ^{rshift9,rparity9}; // calculate9 parity9 on all incoming9 data
				rstate      <= #1 sr_check_parity9;
			  end
	sr_check_parity9: begin	  // rcounter9 equals9 5
				case ({lcr9[`UART_LC_EP9],lcr9[`UART_LC_SP9]})
					2'b00: rparity_error9 <= #1  rparity_xor9 == 0;  // no error if parity9 1
					2'b01: rparity_error9 <= #1 ~rparity9;      // parity9 should sticked9 to 1
					2'b10: rparity_error9 <= #1  rparity_xor9 == 1;   // error if parity9 is odd9
					2'b11: rparity_error9 <= #1  rparity9;	  // parity9 should be sticked9 to 0
				endcase
				rcounter169 <= #1 rcounter16_minus_19;
				rstate <= #1 sr_wait19;
			  end
	sr_wait19 :	if (rcounter16_eq_09)
			begin
				rstate <= #1 sr_rec_stop9;
				rcounter169 <= #1 4'b1110;
			end
			else
				rcounter169 <= #1 rcounter16_minus_19;
	sr_rec_stop9 :	begin
				if (rcounter16_eq_79)	// read the parity9
				begin
					rframing_error9 <= #1 !srx_pad_i9; // no framing9 error if input is 1 (stop bit)
					rstate <= #1 sr_push9;
				end
				rcounter169 <= #1 rcounter16_minus_19;
			end
	sr_push9 :	begin
///////////////////////////////////////
//				$display($time, ": received9: %b", rf_data_in9);
        if(srx_pad_i9 | break_error9)
          begin
            if(break_error9)
        		  rf_data_in9 	<= #1 {8'b0, 3'b100}; // break input (empty9 character9) to receiver9 FIFO
            else
        			rf_data_in9  <= #1 {rshift9, 1'b0, rparity_error9, rframing_error9};
      		  rf_push9 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle9;
          end
        else if(~rframing_error9)  // There's always a framing9 before break_error9 -> wait for break or srx_pad_i9
          begin
       			rf_data_in9  <= #1 {rshift9, 1'b0, rparity_error9, rframing_error9};
      		  rf_push9 		  <= #1 1'b1;
      			rcounter169 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start9;
          end
                      
			end
	default : rstate <= #1 sr_idle9;
	endcase
  end  // if (enable)
end // always of receiver9

always @ (posedge clk9 or posedge wb_rst_i9)
begin
  if(wb_rst_i9)
    rf_push_q9 <= 0;
  else
    rf_push_q9 <= #1 rf_push9;
end

assign rf_push_pulse9 = rf_push9 & ~rf_push_q9;

  
//
// Break9 condition detection9.
// Works9 in conjuction9 with the receiver9 state machine9

reg 	[9:0]	toc_value9; // value to be set to timeout counter

always @(lcr9)
	case (lcr9[3:0])
		4'b0000										: toc_value9 = 447; // 7 bits
		4'b0100										: toc_value9 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value9 = 511; // 8 bits
		4'b1100										: toc_value9 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value9 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value9 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value9 = 703; // 11 bits
		4'b1111										: toc_value9 = 767; // 12 bits
	endcase // case(lcr9[3:0])

wire [7:0] 	brc_value9; // value to be set to break counter
assign 		brc_value9 = toc_value9[9:2]; // the same as timeout but 1 insead9 of 4 character9 times

always @(posedge clk9 or posedge wb_rst_i9)
begin
	if (wb_rst_i9)
		counter_b9 <= #1 8'd159;
	else
	if (srx_pad_i9)
		counter_b9 <= #1 brc_value9; // character9 time length - 1
	else
	if(enable & counter_b9 != 8'b0)            // only work9 on enable times  break not reached9.
		counter_b9 <= #1 counter_b9 - 1;  // decrement break counter
end // always of break condition detection9

///
/// Timeout9 condition detection9
reg	[9:0]	counter_t9;	// counts9 the timeout condition clocks9

always @(posedge clk9 or posedge wb_rst_i9)
begin
	if (wb_rst_i9)
		counter_t9 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse9 || rf_pop9 || rf_count9 == 0) // counter is reset when RX9 FIFO is empty9, accessed or above9 trigger level
			counter_t9 <= #1 toc_value9;
		else
		if (enable && counter_t9 != 10'b0)  // we9 don9't want9 to underflow9
			counter_t9 <= #1 counter_t9 - 1;		
end
	
endmodule
