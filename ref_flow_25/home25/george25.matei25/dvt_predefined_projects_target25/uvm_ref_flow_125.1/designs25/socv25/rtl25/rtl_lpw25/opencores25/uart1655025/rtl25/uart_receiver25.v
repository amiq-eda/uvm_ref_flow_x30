//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver25.v                                             ////
////                                                              ////
////                                                              ////
////  This25 file is part of the "UART25 16550 compatible25" project25    ////
////  http25://www25.opencores25.org25/cores25/uart1655025/                   ////
////                                                              ////
////  Documentation25 related25 to this project25:                      ////
////  - http25://www25.opencores25.org25/cores25/uart1655025/                 ////
////                                                              ////
////  Projects25 compatibility25:                                     ////
////  - WISHBONE25                                                  ////
////  RS23225 Protocol25                                              ////
////  16550D uart25 (mostly25 supported)                              ////
////                                                              ////
////  Overview25 (main25 Features25):                                   ////
////  UART25 core25 receiver25 logic                                    ////
////                                                              ////
////  Known25 problems25 (limits25):                                    ////
////  None25 known25                                                  ////
////                                                              ////
////  To25 Do25:                                                      ////
////  Thourough25 testing25.                                          ////
////                                                              ////
////  Author25(s):                                                  ////
////      - gorban25@opencores25.org25                                  ////
////      - Jacob25 Gorban25                                          ////
////      - Igor25 Mohor25 (igorm25@opencores25.org25)                      ////
////                                                              ////
////  Created25:        2001/05/12                                  ////
////  Last25 Updated25:   2001/05/17                                  ////
////                  (See log25 for the revision25 history25)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2000, 2001 Authors25                             ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS25 Revision25 History25
//
// $Log: not supported by cvs2svn25 $
// Revision25 1.29  2002/07/29 21:16:18  gorban25
// The uart_defines25.v file is included25 again25 in sources25.
//
// Revision25 1.28  2002/07/22 23:02:23  gorban25
// Bug25 Fixes25:
//  * Possible25 loss of sync and bad25 reception25 of stop bit on slow25 baud25 rates25 fixed25.
//   Problem25 reported25 by Kenny25.Tung25.
//  * Bad (or lack25 of ) loopback25 handling25 fixed25. Reported25 by Cherry25 Withers25.
//
// Improvements25:
//  * Made25 FIFO's as general25 inferrable25 memory where possible25.
//  So25 on FPGA25 they should be inferred25 as RAM25 (Distributed25 RAM25 on Xilinx25).
//  This25 saves25 about25 1/3 of the Slice25 count and reduces25 P&R and synthesis25 times.
//
//  * Added25 optional25 baudrate25 output (baud_o25).
//  This25 is identical25 to BAUDOUT25* signal25 on 16550 chip25.
//  It outputs25 16xbit_clock_rate - the divided25 clock25.
//  It's disabled by default. Define25 UART_HAS_BAUDRATE_OUTPUT25 to use.
//
// Revision25 1.27  2001/12/30 20:39:13  mohor25
// More than one character25 was stored25 in case of break. End25 of the break
// was not detected correctly.
//
// Revision25 1.26  2001/12/20 13:28:27  mohor25
// Missing25 declaration25 of rf_push_q25 fixed25.
//
// Revision25 1.25  2001/12/20 13:25:46  mohor25
// rx25 push25 changed to be only one cycle wide25.
//
// Revision25 1.24  2001/12/19 08:03:34  mohor25
// Warnings25 cleared25.
//
// Revision25 1.23  2001/12/19 07:33:54  mohor25
// Synplicity25 was having25 troubles25 with the comment25.
//
// Revision25 1.22  2001/12/17 14:46:48  mohor25
// overrun25 signal25 was moved to separate25 block because many25 sequential25 lsr25
// reads were25 preventing25 data from being written25 to rx25 fifo.
// underrun25 signal25 was not used and was removed from the project25.
//
// Revision25 1.21  2001/12/13 10:31:16  mohor25
// timeout irq25 must be set regardless25 of the rda25 irq25 (rda25 irq25 does not reset the
// timeout counter).
//
// Revision25 1.20  2001/12/10 19:52:05  gorban25
// Igor25 fixed25 break condition bugs25
//
// Revision25 1.19  2001/12/06 14:51:04  gorban25
// Bug25 in LSR25[0] is fixed25.
// All WISHBONE25 signals25 are now sampled25, so another25 wait-state is introduced25 on all transfers25.
//
// Revision25 1.18  2001/12/03 21:44:29  gorban25
// Updated25 specification25 documentation.
// Added25 full 32-bit data bus interface, now as default.
// Address is 5-bit wide25 in 32-bit data bus mode.
// Added25 wb_sel_i25 input to the core25. It's used in the 32-bit mode.
// Added25 debug25 interface with two25 32-bit read-only registers in 32-bit mode.
// Bits25 5 and 6 of LSR25 are now only cleared25 on TX25 FIFO write.
// My25 small test bench25 is modified to work25 with 32-bit mode.
//
// Revision25 1.17  2001/11/28 19:36:39  gorban25
// Fixed25: timeout and break didn25't pay25 attention25 to current data format25 when counting25 time
//
// Revision25 1.16  2001/11/27 22:17:09  gorban25
// Fixed25 bug25 that prevented25 synthesis25 in uart_receiver25.v
//
// Revision25 1.15  2001/11/26 21:38:54  gorban25
// Lots25 of fixes25:
// Break25 condition wasn25't handled25 correctly at all.
// LSR25 bits could lose25 their25 values.
// LSR25 value after reset was wrong25.
// Timing25 of THRE25 interrupt25 signal25 corrected25.
// LSR25 bit 0 timing25 corrected25.
//
// Revision25 1.14  2001/11/10 12:43:21  gorban25
// Logic25 Synthesis25 bugs25 fixed25. Some25 other minor25 changes25
//
// Revision25 1.13  2001/11/08 14:54:23  mohor25
// Comments25 in Slovene25 language25 deleted25, few25 small fixes25 for better25 work25 of
// old25 tools25. IRQs25 need to be fix25.
//
// Revision25 1.12  2001/11/07 17:51:52  gorban25
// Heavily25 rewritten25 interrupt25 and LSR25 subsystems25.
// Many25 bugs25 hopefully25 squashed25.
//
// Revision25 1.11  2001/10/31 15:19:22  gorban25
// Fixes25 to break and timeout conditions25
//
// Revision25 1.10  2001/10/20 09:58:40  gorban25
// Small25 synopsis25 fixes25
//
// Revision25 1.9  2001/08/24 21:01:12  mohor25
// Things25 connected25 to parity25 changed.
// Clock25 devider25 changed.
//
// Revision25 1.8  2001/08/23 16:05:05  mohor25
// Stop bit bug25 fixed25.
// Parity25 bug25 fixed25.
// WISHBONE25 read cycle bug25 fixed25,
// OE25 indicator25 (Overrun25 Error) bug25 fixed25.
// PE25 indicator25 (Parity25 Error) bug25 fixed25.
// Register read bug25 fixed25.
//
// Revision25 1.6  2001/06/23 11:21:48  gorban25
// DL25 made25 16-bit long25. Fixed25 transmission25/reception25 bugs25.
//
// Revision25 1.5  2001/06/02 14:28:14  gorban25
// Fixed25 receiver25 and transmitter25. Major25 bug25 fixed25.
//
// Revision25 1.4  2001/05/31 20:08:01  gorban25
// FIFO changes25 and other corrections25.
//
// Revision25 1.3  2001/05/27 17:37:49  gorban25
// Fixed25 many25 bugs25. Updated25 spec25. Changed25 FIFO files structure25. See CHANGES25.txt25 file.
//
// Revision25 1.2  2001/05/21 19:12:02  gorban25
// Corrected25 some25 Linter25 messages25.
//
// Revision25 1.1  2001/05/17 18:34:18  gorban25
// First25 'stable' release. Should25 be sythesizable25 now. Also25 added new header.
//
// Revision25 1.0  2001-05-17 21:27:11+02  jacob25
// Initial25 revision25
//
//

// synopsys25 translate_off25
`include "timescale.v"
// synopsys25 translate_on25

`include "uart_defines25.v"

module uart_receiver25 (clk25, wb_rst_i25, lcr25, rf_pop25, srx_pad_i25, enable, 
	counter_t25, rf_count25, rf_data_out25, rf_error_bit25, rf_overrun25, rx_reset25, lsr_mask25, rstate, rf_push_pulse25);

input				clk25;
input				wb_rst_i25;
input	[7:0]	lcr25;
input				rf_pop25;
input				srx_pad_i25;
input				enable;
input				rx_reset25;
input       lsr_mask25;

output	[9:0]			counter_t25;
output	[`UART_FIFO_COUNTER_W25-1:0]	rf_count25;
output	[`UART_FIFO_REC_WIDTH25-1:0]	rf_data_out25;
output				rf_overrun25;
output				rf_error_bit25;
output [3:0] 		rstate;
output 				rf_push_pulse25;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1625;
reg	[2:0]	rbit_counter25;
reg	[7:0]	rshift25;			// receiver25 shift25 register
reg		rparity25;		// received25 parity25
reg		rparity_error25;
reg		rframing_error25;		// framing25 error flag25
reg		rbit_in25;
reg		rparity_xor25;
reg	[7:0]	counter_b25;	// counts25 the 0 (low25) signals25
reg   rf_push_q25;

// RX25 FIFO signals25
reg	[`UART_FIFO_REC_WIDTH25-1:0]	rf_data_in25;
wire	[`UART_FIFO_REC_WIDTH25-1:0]	rf_data_out25;
wire      rf_push_pulse25;
reg				rf_push25;
wire				rf_pop25;
wire				rf_overrun25;
wire	[`UART_FIFO_COUNTER_W25-1:0]	rf_count25;
wire				rf_error_bit25; // an error (parity25 or framing25) is inside the fifo
wire 				break_error25 = (counter_b25 == 0);

// RX25 FIFO instance
uart_rfifo25 #(`UART_FIFO_REC_WIDTH25) fifo_rx25(
	.clk25(		clk25		), 
	.wb_rst_i25(	wb_rst_i25	),
	.data_in25(	rf_data_in25	),
	.data_out25(	rf_data_out25	),
	.push25(		rf_push_pulse25		),
	.pop25(		rf_pop25		),
	.overrun25(	rf_overrun25	),
	.count(		rf_count25	),
	.error_bit25(	rf_error_bit25	),
	.fifo_reset25(	rx_reset25	),
	.reset_status25(lsr_mask25)
);

wire 		rcounter16_eq_725 = (rcounter1625 == 4'd7);
wire		rcounter16_eq_025 = (rcounter1625 == 4'd0);
wire		rcounter16_eq_125 = (rcounter1625 == 4'd1);

wire [3:0] rcounter16_minus_125 = rcounter1625 - 1'b1;

parameter  sr_idle25 					= 4'd0;
parameter  sr_rec_start25 			= 4'd1;
parameter  sr_rec_bit25 				= 4'd2;
parameter  sr_rec_parity25			= 4'd3;
parameter  sr_rec_stop25 				= 4'd4;
parameter  sr_check_parity25 		= 4'd5;
parameter  sr_rec_prepare25 			= 4'd6;
parameter  sr_end_bit25				= 4'd7;
parameter  sr_ca_lc_parity25	      = 4'd8;
parameter  sr_wait125 					= 4'd9;
parameter  sr_push25 					= 4'd10;


always @(posedge clk25 or posedge wb_rst_i25)
begin
  if (wb_rst_i25)
  begin
     rstate 			<= #1 sr_idle25;
	  rbit_in25 				<= #1 1'b0;
	  rcounter1625 			<= #1 0;
	  rbit_counter25 		<= #1 0;
	  rparity_xor25 		<= #1 1'b0;
	  rframing_error25 	<= #1 1'b0;
	  rparity_error25 		<= #1 1'b0;
	  rparity25 				<= #1 1'b0;
	  rshift25 				<= #1 0;
	  rf_push25 				<= #1 1'b0;
	  rf_data_in25 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle25 : begin
			rf_push25 			  <= #1 1'b0;
			rf_data_in25 	  <= #1 0;
			rcounter1625 	  <= #1 4'b1110;
			if (srx_pad_i25==1'b0 & ~break_error25)   // detected a pulse25 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start25;
			end
		end
	sr_rec_start25 :	begin
  			rf_push25 			  <= #1 1'b0;
				if (rcounter16_eq_725)    // check the pulse25
					if (srx_pad_i25==1'b1)   // no start bit
						rstate <= #1 sr_idle25;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare25;
				rcounter1625 <= #1 rcounter16_minus_125;
			end
	sr_rec_prepare25:begin
				case (lcr25[/*`UART_LC_BITS25*/1:0])  // number25 of bits in a word25
				2'b00 : rbit_counter25 <= #1 3'b100;
				2'b01 : rbit_counter25 <= #1 3'b101;
				2'b10 : rbit_counter25 <= #1 3'b110;
				2'b11 : rbit_counter25 <= #1 3'b111;
				endcase
				if (rcounter16_eq_025)
				begin
					rstate		<= #1 sr_rec_bit25;
					rcounter1625	<= #1 4'b1110;
					rshift25		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare25;
				rcounter1625 <= #1 rcounter16_minus_125;
			end
	sr_rec_bit25 :	begin
				if (rcounter16_eq_025)
					rstate <= #1 sr_end_bit25;
				if (rcounter16_eq_725) // read the bit
					case (lcr25[/*`UART_LC_BITS25*/1:0])  // number25 of bits in a word25
					2'b00 : rshift25[4:0]  <= #1 {srx_pad_i25, rshift25[4:1]};
					2'b01 : rshift25[5:0]  <= #1 {srx_pad_i25, rshift25[5:1]};
					2'b10 : rshift25[6:0]  <= #1 {srx_pad_i25, rshift25[6:1]};
					2'b11 : rshift25[7:0]  <= #1 {srx_pad_i25, rshift25[7:1]};
					endcase
				rcounter1625 <= #1 rcounter16_minus_125;
			end
	sr_end_bit25 :   begin
				if (rbit_counter25==3'b0) // no more bits in word25
					if (lcr25[`UART_LC_PE25]) // choose25 state based on parity25
						rstate <= #1 sr_rec_parity25;
					else
					begin
						rstate <= #1 sr_rec_stop25;
						rparity_error25 <= #1 1'b0;  // no parity25 - no error :)
					end
				else		// else we25 have more bits to read
				begin
					rstate <= #1 sr_rec_bit25;
					rbit_counter25 <= #1 rbit_counter25 - 1'b1;
				end
				rcounter1625 <= #1 4'b1110;
			end
	sr_rec_parity25: begin
				if (rcounter16_eq_725)	// read the parity25
				begin
					rparity25 <= #1 srx_pad_i25;
					rstate <= #1 sr_ca_lc_parity25;
				end
				rcounter1625 <= #1 rcounter16_minus_125;
			end
	sr_ca_lc_parity25 : begin    // rcounter25 equals25 6
				rcounter1625  <= #1 rcounter16_minus_125;
				rparity_xor25 <= #1 ^{rshift25,rparity25}; // calculate25 parity25 on all incoming25 data
				rstate      <= #1 sr_check_parity25;
			  end
	sr_check_parity25: begin	  // rcounter25 equals25 5
				case ({lcr25[`UART_LC_EP25],lcr25[`UART_LC_SP25]})
					2'b00: rparity_error25 <= #1  rparity_xor25 == 0;  // no error if parity25 1
					2'b01: rparity_error25 <= #1 ~rparity25;      // parity25 should sticked25 to 1
					2'b10: rparity_error25 <= #1  rparity_xor25 == 1;   // error if parity25 is odd25
					2'b11: rparity_error25 <= #1  rparity25;	  // parity25 should be sticked25 to 0
				endcase
				rcounter1625 <= #1 rcounter16_minus_125;
				rstate <= #1 sr_wait125;
			  end
	sr_wait125 :	if (rcounter16_eq_025)
			begin
				rstate <= #1 sr_rec_stop25;
				rcounter1625 <= #1 4'b1110;
			end
			else
				rcounter1625 <= #1 rcounter16_minus_125;
	sr_rec_stop25 :	begin
				if (rcounter16_eq_725)	// read the parity25
				begin
					rframing_error25 <= #1 !srx_pad_i25; // no framing25 error if input is 1 (stop bit)
					rstate <= #1 sr_push25;
				end
				rcounter1625 <= #1 rcounter16_minus_125;
			end
	sr_push25 :	begin
///////////////////////////////////////
//				$display($time, ": received25: %b", rf_data_in25);
        if(srx_pad_i25 | break_error25)
          begin
            if(break_error25)
        		  rf_data_in25 	<= #1 {8'b0, 3'b100}; // break input (empty25 character25) to receiver25 FIFO
            else
        			rf_data_in25  <= #1 {rshift25, 1'b0, rparity_error25, rframing_error25};
      		  rf_push25 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle25;
          end
        else if(~rframing_error25)  // There's always a framing25 before break_error25 -> wait for break or srx_pad_i25
          begin
       			rf_data_in25  <= #1 {rshift25, 1'b0, rparity_error25, rframing_error25};
      		  rf_push25 		  <= #1 1'b1;
      			rcounter1625 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start25;
          end
                      
			end
	default : rstate <= #1 sr_idle25;
	endcase
  end  // if (enable)
end // always of receiver25

always @ (posedge clk25 or posedge wb_rst_i25)
begin
  if(wb_rst_i25)
    rf_push_q25 <= 0;
  else
    rf_push_q25 <= #1 rf_push25;
end

assign rf_push_pulse25 = rf_push25 & ~rf_push_q25;

  
//
// Break25 condition detection25.
// Works25 in conjuction25 with the receiver25 state machine25

reg 	[9:0]	toc_value25; // value to be set to timeout counter

always @(lcr25)
	case (lcr25[3:0])
		4'b0000										: toc_value25 = 447; // 7 bits
		4'b0100										: toc_value25 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value25 = 511; // 8 bits
		4'b1100										: toc_value25 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value25 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value25 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value25 = 703; // 11 bits
		4'b1111										: toc_value25 = 767; // 12 bits
	endcase // case(lcr25[3:0])

wire [7:0] 	brc_value25; // value to be set to break counter
assign 		brc_value25 = toc_value25[9:2]; // the same as timeout but 1 insead25 of 4 character25 times

always @(posedge clk25 or posedge wb_rst_i25)
begin
	if (wb_rst_i25)
		counter_b25 <= #1 8'd159;
	else
	if (srx_pad_i25)
		counter_b25 <= #1 brc_value25; // character25 time length - 1
	else
	if(enable & counter_b25 != 8'b0)            // only work25 on enable times  break not reached25.
		counter_b25 <= #1 counter_b25 - 1;  // decrement break counter
end // always of break condition detection25

///
/// Timeout25 condition detection25
reg	[9:0]	counter_t25;	// counts25 the timeout condition clocks25

always @(posedge clk25 or posedge wb_rst_i25)
begin
	if (wb_rst_i25)
		counter_t25 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse25 || rf_pop25 || rf_count25 == 0) // counter is reset when RX25 FIFO is empty25, accessed or above25 trigger level
			counter_t25 <= #1 toc_value25;
		else
		if (enable && counter_t25 != 10'b0)  // we25 don25't want25 to underflow25
			counter_t25 <= #1 counter_t25 - 1;		
end
	
endmodule
