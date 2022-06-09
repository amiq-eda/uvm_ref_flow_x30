//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver15.v                                             ////
////                                                              ////
////                                                              ////
////  This15 file is part of the "UART15 16550 compatible15" project15    ////
////  http15://www15.opencores15.org15/cores15/uart1655015/                   ////
////                                                              ////
////  Documentation15 related15 to this project15:                      ////
////  - http15://www15.opencores15.org15/cores15/uart1655015/                 ////
////                                                              ////
////  Projects15 compatibility15:                                     ////
////  - WISHBONE15                                                  ////
////  RS23215 Protocol15                                              ////
////  16550D uart15 (mostly15 supported)                              ////
////                                                              ////
////  Overview15 (main15 Features15):                                   ////
////  UART15 core15 receiver15 logic                                    ////
////                                                              ////
////  Known15 problems15 (limits15):                                    ////
////  None15 known15                                                  ////
////                                                              ////
////  To15 Do15:                                                      ////
////  Thourough15 testing15.                                          ////
////                                                              ////
////  Author15(s):                                                  ////
////      - gorban15@opencores15.org15                                  ////
////      - Jacob15 Gorban15                                          ////
////      - Igor15 Mohor15 (igorm15@opencores15.org15)                      ////
////                                                              ////
////  Created15:        2001/05/12                                  ////
////  Last15 Updated15:   2001/05/17                                  ////
////                  (See log15 for the revision15 history15)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2000, 2001 Authors15                             ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS15 Revision15 History15
//
// $Log: not supported by cvs2svn15 $
// Revision15 1.29  2002/07/29 21:16:18  gorban15
// The uart_defines15.v file is included15 again15 in sources15.
//
// Revision15 1.28  2002/07/22 23:02:23  gorban15
// Bug15 Fixes15:
//  * Possible15 loss of sync and bad15 reception15 of stop bit on slow15 baud15 rates15 fixed15.
//   Problem15 reported15 by Kenny15.Tung15.
//  * Bad (or lack15 of ) loopback15 handling15 fixed15. Reported15 by Cherry15 Withers15.
//
// Improvements15:
//  * Made15 FIFO's as general15 inferrable15 memory where possible15.
//  So15 on FPGA15 they should be inferred15 as RAM15 (Distributed15 RAM15 on Xilinx15).
//  This15 saves15 about15 1/3 of the Slice15 count and reduces15 P&R and synthesis15 times.
//
//  * Added15 optional15 baudrate15 output (baud_o15).
//  This15 is identical15 to BAUDOUT15* signal15 on 16550 chip15.
//  It outputs15 16xbit_clock_rate - the divided15 clock15.
//  It's disabled by default. Define15 UART_HAS_BAUDRATE_OUTPUT15 to use.
//
// Revision15 1.27  2001/12/30 20:39:13  mohor15
// More than one character15 was stored15 in case of break. End15 of the break
// was not detected correctly.
//
// Revision15 1.26  2001/12/20 13:28:27  mohor15
// Missing15 declaration15 of rf_push_q15 fixed15.
//
// Revision15 1.25  2001/12/20 13:25:46  mohor15
// rx15 push15 changed to be only one cycle wide15.
//
// Revision15 1.24  2001/12/19 08:03:34  mohor15
// Warnings15 cleared15.
//
// Revision15 1.23  2001/12/19 07:33:54  mohor15
// Synplicity15 was having15 troubles15 with the comment15.
//
// Revision15 1.22  2001/12/17 14:46:48  mohor15
// overrun15 signal15 was moved to separate15 block because many15 sequential15 lsr15
// reads were15 preventing15 data from being written15 to rx15 fifo.
// underrun15 signal15 was not used and was removed from the project15.
//
// Revision15 1.21  2001/12/13 10:31:16  mohor15
// timeout irq15 must be set regardless15 of the rda15 irq15 (rda15 irq15 does not reset the
// timeout counter).
//
// Revision15 1.20  2001/12/10 19:52:05  gorban15
// Igor15 fixed15 break condition bugs15
//
// Revision15 1.19  2001/12/06 14:51:04  gorban15
// Bug15 in LSR15[0] is fixed15.
// All WISHBONE15 signals15 are now sampled15, so another15 wait-state is introduced15 on all transfers15.
//
// Revision15 1.18  2001/12/03 21:44:29  gorban15
// Updated15 specification15 documentation.
// Added15 full 32-bit data bus interface, now as default.
// Address is 5-bit wide15 in 32-bit data bus mode.
// Added15 wb_sel_i15 input to the core15. It's used in the 32-bit mode.
// Added15 debug15 interface with two15 32-bit read-only registers in 32-bit mode.
// Bits15 5 and 6 of LSR15 are now only cleared15 on TX15 FIFO write.
// My15 small test bench15 is modified to work15 with 32-bit mode.
//
// Revision15 1.17  2001/11/28 19:36:39  gorban15
// Fixed15: timeout and break didn15't pay15 attention15 to current data format15 when counting15 time
//
// Revision15 1.16  2001/11/27 22:17:09  gorban15
// Fixed15 bug15 that prevented15 synthesis15 in uart_receiver15.v
//
// Revision15 1.15  2001/11/26 21:38:54  gorban15
// Lots15 of fixes15:
// Break15 condition wasn15't handled15 correctly at all.
// LSR15 bits could lose15 their15 values.
// LSR15 value after reset was wrong15.
// Timing15 of THRE15 interrupt15 signal15 corrected15.
// LSR15 bit 0 timing15 corrected15.
//
// Revision15 1.14  2001/11/10 12:43:21  gorban15
// Logic15 Synthesis15 bugs15 fixed15. Some15 other minor15 changes15
//
// Revision15 1.13  2001/11/08 14:54:23  mohor15
// Comments15 in Slovene15 language15 deleted15, few15 small fixes15 for better15 work15 of
// old15 tools15. IRQs15 need to be fix15.
//
// Revision15 1.12  2001/11/07 17:51:52  gorban15
// Heavily15 rewritten15 interrupt15 and LSR15 subsystems15.
// Many15 bugs15 hopefully15 squashed15.
//
// Revision15 1.11  2001/10/31 15:19:22  gorban15
// Fixes15 to break and timeout conditions15
//
// Revision15 1.10  2001/10/20 09:58:40  gorban15
// Small15 synopsis15 fixes15
//
// Revision15 1.9  2001/08/24 21:01:12  mohor15
// Things15 connected15 to parity15 changed.
// Clock15 devider15 changed.
//
// Revision15 1.8  2001/08/23 16:05:05  mohor15
// Stop bit bug15 fixed15.
// Parity15 bug15 fixed15.
// WISHBONE15 read cycle bug15 fixed15,
// OE15 indicator15 (Overrun15 Error) bug15 fixed15.
// PE15 indicator15 (Parity15 Error) bug15 fixed15.
// Register read bug15 fixed15.
//
// Revision15 1.6  2001/06/23 11:21:48  gorban15
// DL15 made15 16-bit long15. Fixed15 transmission15/reception15 bugs15.
//
// Revision15 1.5  2001/06/02 14:28:14  gorban15
// Fixed15 receiver15 and transmitter15. Major15 bug15 fixed15.
//
// Revision15 1.4  2001/05/31 20:08:01  gorban15
// FIFO changes15 and other corrections15.
//
// Revision15 1.3  2001/05/27 17:37:49  gorban15
// Fixed15 many15 bugs15. Updated15 spec15. Changed15 FIFO files structure15. See CHANGES15.txt15 file.
//
// Revision15 1.2  2001/05/21 19:12:02  gorban15
// Corrected15 some15 Linter15 messages15.
//
// Revision15 1.1  2001/05/17 18:34:18  gorban15
// First15 'stable' release. Should15 be sythesizable15 now. Also15 added new header.
//
// Revision15 1.0  2001-05-17 21:27:11+02  jacob15
// Initial15 revision15
//
//

// synopsys15 translate_off15
`include "timescale.v"
// synopsys15 translate_on15

`include "uart_defines15.v"

module uart_receiver15 (clk15, wb_rst_i15, lcr15, rf_pop15, srx_pad_i15, enable, 
	counter_t15, rf_count15, rf_data_out15, rf_error_bit15, rf_overrun15, rx_reset15, lsr_mask15, rstate, rf_push_pulse15);

input				clk15;
input				wb_rst_i15;
input	[7:0]	lcr15;
input				rf_pop15;
input				srx_pad_i15;
input				enable;
input				rx_reset15;
input       lsr_mask15;

output	[9:0]			counter_t15;
output	[`UART_FIFO_COUNTER_W15-1:0]	rf_count15;
output	[`UART_FIFO_REC_WIDTH15-1:0]	rf_data_out15;
output				rf_overrun15;
output				rf_error_bit15;
output [3:0] 		rstate;
output 				rf_push_pulse15;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1615;
reg	[2:0]	rbit_counter15;
reg	[7:0]	rshift15;			// receiver15 shift15 register
reg		rparity15;		// received15 parity15
reg		rparity_error15;
reg		rframing_error15;		// framing15 error flag15
reg		rbit_in15;
reg		rparity_xor15;
reg	[7:0]	counter_b15;	// counts15 the 0 (low15) signals15
reg   rf_push_q15;

// RX15 FIFO signals15
reg	[`UART_FIFO_REC_WIDTH15-1:0]	rf_data_in15;
wire	[`UART_FIFO_REC_WIDTH15-1:0]	rf_data_out15;
wire      rf_push_pulse15;
reg				rf_push15;
wire				rf_pop15;
wire				rf_overrun15;
wire	[`UART_FIFO_COUNTER_W15-1:0]	rf_count15;
wire				rf_error_bit15; // an error (parity15 or framing15) is inside the fifo
wire 				break_error15 = (counter_b15 == 0);

// RX15 FIFO instance
uart_rfifo15 #(`UART_FIFO_REC_WIDTH15) fifo_rx15(
	.clk15(		clk15		), 
	.wb_rst_i15(	wb_rst_i15	),
	.data_in15(	rf_data_in15	),
	.data_out15(	rf_data_out15	),
	.push15(		rf_push_pulse15		),
	.pop15(		rf_pop15		),
	.overrun15(	rf_overrun15	),
	.count(		rf_count15	),
	.error_bit15(	rf_error_bit15	),
	.fifo_reset15(	rx_reset15	),
	.reset_status15(lsr_mask15)
);

wire 		rcounter16_eq_715 = (rcounter1615 == 4'd7);
wire		rcounter16_eq_015 = (rcounter1615 == 4'd0);
wire		rcounter16_eq_115 = (rcounter1615 == 4'd1);

wire [3:0] rcounter16_minus_115 = rcounter1615 - 1'b1;

parameter  sr_idle15 					= 4'd0;
parameter  sr_rec_start15 			= 4'd1;
parameter  sr_rec_bit15 				= 4'd2;
parameter  sr_rec_parity15			= 4'd3;
parameter  sr_rec_stop15 				= 4'd4;
parameter  sr_check_parity15 		= 4'd5;
parameter  sr_rec_prepare15 			= 4'd6;
parameter  sr_end_bit15				= 4'd7;
parameter  sr_ca_lc_parity15	      = 4'd8;
parameter  sr_wait115 					= 4'd9;
parameter  sr_push15 					= 4'd10;


always @(posedge clk15 or posedge wb_rst_i15)
begin
  if (wb_rst_i15)
  begin
     rstate 			<= #1 sr_idle15;
	  rbit_in15 				<= #1 1'b0;
	  rcounter1615 			<= #1 0;
	  rbit_counter15 		<= #1 0;
	  rparity_xor15 		<= #1 1'b0;
	  rframing_error15 	<= #1 1'b0;
	  rparity_error15 		<= #1 1'b0;
	  rparity15 				<= #1 1'b0;
	  rshift15 				<= #1 0;
	  rf_push15 				<= #1 1'b0;
	  rf_data_in15 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle15 : begin
			rf_push15 			  <= #1 1'b0;
			rf_data_in15 	  <= #1 0;
			rcounter1615 	  <= #1 4'b1110;
			if (srx_pad_i15==1'b0 & ~break_error15)   // detected a pulse15 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start15;
			end
		end
	sr_rec_start15 :	begin
  			rf_push15 			  <= #1 1'b0;
				if (rcounter16_eq_715)    // check the pulse15
					if (srx_pad_i15==1'b1)   // no start bit
						rstate <= #1 sr_idle15;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare15;
				rcounter1615 <= #1 rcounter16_minus_115;
			end
	sr_rec_prepare15:begin
				case (lcr15[/*`UART_LC_BITS15*/1:0])  // number15 of bits in a word15
				2'b00 : rbit_counter15 <= #1 3'b100;
				2'b01 : rbit_counter15 <= #1 3'b101;
				2'b10 : rbit_counter15 <= #1 3'b110;
				2'b11 : rbit_counter15 <= #1 3'b111;
				endcase
				if (rcounter16_eq_015)
				begin
					rstate		<= #1 sr_rec_bit15;
					rcounter1615	<= #1 4'b1110;
					rshift15		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare15;
				rcounter1615 <= #1 rcounter16_minus_115;
			end
	sr_rec_bit15 :	begin
				if (rcounter16_eq_015)
					rstate <= #1 sr_end_bit15;
				if (rcounter16_eq_715) // read the bit
					case (lcr15[/*`UART_LC_BITS15*/1:0])  // number15 of bits in a word15
					2'b00 : rshift15[4:0]  <= #1 {srx_pad_i15, rshift15[4:1]};
					2'b01 : rshift15[5:0]  <= #1 {srx_pad_i15, rshift15[5:1]};
					2'b10 : rshift15[6:0]  <= #1 {srx_pad_i15, rshift15[6:1]};
					2'b11 : rshift15[7:0]  <= #1 {srx_pad_i15, rshift15[7:1]};
					endcase
				rcounter1615 <= #1 rcounter16_minus_115;
			end
	sr_end_bit15 :   begin
				if (rbit_counter15==3'b0) // no more bits in word15
					if (lcr15[`UART_LC_PE15]) // choose15 state based on parity15
						rstate <= #1 sr_rec_parity15;
					else
					begin
						rstate <= #1 sr_rec_stop15;
						rparity_error15 <= #1 1'b0;  // no parity15 - no error :)
					end
				else		// else we15 have more bits to read
				begin
					rstate <= #1 sr_rec_bit15;
					rbit_counter15 <= #1 rbit_counter15 - 1'b1;
				end
				rcounter1615 <= #1 4'b1110;
			end
	sr_rec_parity15: begin
				if (rcounter16_eq_715)	// read the parity15
				begin
					rparity15 <= #1 srx_pad_i15;
					rstate <= #1 sr_ca_lc_parity15;
				end
				rcounter1615 <= #1 rcounter16_minus_115;
			end
	sr_ca_lc_parity15 : begin    // rcounter15 equals15 6
				rcounter1615  <= #1 rcounter16_minus_115;
				rparity_xor15 <= #1 ^{rshift15,rparity15}; // calculate15 parity15 on all incoming15 data
				rstate      <= #1 sr_check_parity15;
			  end
	sr_check_parity15: begin	  // rcounter15 equals15 5
				case ({lcr15[`UART_LC_EP15],lcr15[`UART_LC_SP15]})
					2'b00: rparity_error15 <= #1  rparity_xor15 == 0;  // no error if parity15 1
					2'b01: rparity_error15 <= #1 ~rparity15;      // parity15 should sticked15 to 1
					2'b10: rparity_error15 <= #1  rparity_xor15 == 1;   // error if parity15 is odd15
					2'b11: rparity_error15 <= #1  rparity15;	  // parity15 should be sticked15 to 0
				endcase
				rcounter1615 <= #1 rcounter16_minus_115;
				rstate <= #1 sr_wait115;
			  end
	sr_wait115 :	if (rcounter16_eq_015)
			begin
				rstate <= #1 sr_rec_stop15;
				rcounter1615 <= #1 4'b1110;
			end
			else
				rcounter1615 <= #1 rcounter16_minus_115;
	sr_rec_stop15 :	begin
				if (rcounter16_eq_715)	// read the parity15
				begin
					rframing_error15 <= #1 !srx_pad_i15; // no framing15 error if input is 1 (stop bit)
					rstate <= #1 sr_push15;
				end
				rcounter1615 <= #1 rcounter16_minus_115;
			end
	sr_push15 :	begin
///////////////////////////////////////
//				$display($time, ": received15: %b", rf_data_in15);
        if(srx_pad_i15 | break_error15)
          begin
            if(break_error15)
        		  rf_data_in15 	<= #1 {8'b0, 3'b100}; // break input (empty15 character15) to receiver15 FIFO
            else
        			rf_data_in15  <= #1 {rshift15, 1'b0, rparity_error15, rframing_error15};
      		  rf_push15 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle15;
          end
        else if(~rframing_error15)  // There's always a framing15 before break_error15 -> wait for break or srx_pad_i15
          begin
       			rf_data_in15  <= #1 {rshift15, 1'b0, rparity_error15, rframing_error15};
      		  rf_push15 		  <= #1 1'b1;
      			rcounter1615 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start15;
          end
                      
			end
	default : rstate <= #1 sr_idle15;
	endcase
  end  // if (enable)
end // always of receiver15

always @ (posedge clk15 or posedge wb_rst_i15)
begin
  if(wb_rst_i15)
    rf_push_q15 <= 0;
  else
    rf_push_q15 <= #1 rf_push15;
end

assign rf_push_pulse15 = rf_push15 & ~rf_push_q15;

  
//
// Break15 condition detection15.
// Works15 in conjuction15 with the receiver15 state machine15

reg 	[9:0]	toc_value15; // value to be set to timeout counter

always @(lcr15)
	case (lcr15[3:0])
		4'b0000										: toc_value15 = 447; // 7 bits
		4'b0100										: toc_value15 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value15 = 511; // 8 bits
		4'b1100										: toc_value15 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value15 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value15 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value15 = 703; // 11 bits
		4'b1111										: toc_value15 = 767; // 12 bits
	endcase // case(lcr15[3:0])

wire [7:0] 	brc_value15; // value to be set to break counter
assign 		brc_value15 = toc_value15[9:2]; // the same as timeout but 1 insead15 of 4 character15 times

always @(posedge clk15 or posedge wb_rst_i15)
begin
	if (wb_rst_i15)
		counter_b15 <= #1 8'd159;
	else
	if (srx_pad_i15)
		counter_b15 <= #1 brc_value15; // character15 time length - 1
	else
	if(enable & counter_b15 != 8'b0)            // only work15 on enable times  break not reached15.
		counter_b15 <= #1 counter_b15 - 1;  // decrement break counter
end // always of break condition detection15

///
/// Timeout15 condition detection15
reg	[9:0]	counter_t15;	// counts15 the timeout condition clocks15

always @(posedge clk15 or posedge wb_rst_i15)
begin
	if (wb_rst_i15)
		counter_t15 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse15 || rf_pop15 || rf_count15 == 0) // counter is reset when RX15 FIFO is empty15, accessed or above15 trigger level
			counter_t15 <= #1 toc_value15;
		else
		if (enable && counter_t15 != 10'b0)  // we15 don15't want15 to underflow15
			counter_t15 <= #1 counter_t15 - 1;		
end
	
endmodule
