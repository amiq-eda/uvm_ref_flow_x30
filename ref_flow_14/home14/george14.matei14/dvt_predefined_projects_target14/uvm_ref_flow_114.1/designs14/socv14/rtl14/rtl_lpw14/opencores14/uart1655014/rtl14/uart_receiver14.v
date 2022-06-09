//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver14.v                                             ////
////                                                              ////
////                                                              ////
////  This14 file is part of the "UART14 16550 compatible14" project14    ////
////  http14://www14.opencores14.org14/cores14/uart1655014/                   ////
////                                                              ////
////  Documentation14 related14 to this project14:                      ////
////  - http14://www14.opencores14.org14/cores14/uart1655014/                 ////
////                                                              ////
////  Projects14 compatibility14:                                     ////
////  - WISHBONE14                                                  ////
////  RS23214 Protocol14                                              ////
////  16550D uart14 (mostly14 supported)                              ////
////                                                              ////
////  Overview14 (main14 Features14):                                   ////
////  UART14 core14 receiver14 logic                                    ////
////                                                              ////
////  Known14 problems14 (limits14):                                    ////
////  None14 known14                                                  ////
////                                                              ////
////  To14 Do14:                                                      ////
////  Thourough14 testing14.                                          ////
////                                                              ////
////  Author14(s):                                                  ////
////      - gorban14@opencores14.org14                                  ////
////      - Jacob14 Gorban14                                          ////
////      - Igor14 Mohor14 (igorm14@opencores14.org14)                      ////
////                                                              ////
////  Created14:        2001/05/12                                  ////
////  Last14 Updated14:   2001/05/17                                  ////
////                  (See log14 for the revision14 history14)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2000, 2001 Authors14                             ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS14 Revision14 History14
//
// $Log: not supported by cvs2svn14 $
// Revision14 1.29  2002/07/29 21:16:18  gorban14
// The uart_defines14.v file is included14 again14 in sources14.
//
// Revision14 1.28  2002/07/22 23:02:23  gorban14
// Bug14 Fixes14:
//  * Possible14 loss of sync and bad14 reception14 of stop bit on slow14 baud14 rates14 fixed14.
//   Problem14 reported14 by Kenny14.Tung14.
//  * Bad (or lack14 of ) loopback14 handling14 fixed14. Reported14 by Cherry14 Withers14.
//
// Improvements14:
//  * Made14 FIFO's as general14 inferrable14 memory where possible14.
//  So14 on FPGA14 they should be inferred14 as RAM14 (Distributed14 RAM14 on Xilinx14).
//  This14 saves14 about14 1/3 of the Slice14 count and reduces14 P&R and synthesis14 times.
//
//  * Added14 optional14 baudrate14 output (baud_o14).
//  This14 is identical14 to BAUDOUT14* signal14 on 16550 chip14.
//  It outputs14 16xbit_clock_rate - the divided14 clock14.
//  It's disabled by default. Define14 UART_HAS_BAUDRATE_OUTPUT14 to use.
//
// Revision14 1.27  2001/12/30 20:39:13  mohor14
// More than one character14 was stored14 in case of break. End14 of the break
// was not detected correctly.
//
// Revision14 1.26  2001/12/20 13:28:27  mohor14
// Missing14 declaration14 of rf_push_q14 fixed14.
//
// Revision14 1.25  2001/12/20 13:25:46  mohor14
// rx14 push14 changed to be only one cycle wide14.
//
// Revision14 1.24  2001/12/19 08:03:34  mohor14
// Warnings14 cleared14.
//
// Revision14 1.23  2001/12/19 07:33:54  mohor14
// Synplicity14 was having14 troubles14 with the comment14.
//
// Revision14 1.22  2001/12/17 14:46:48  mohor14
// overrun14 signal14 was moved to separate14 block because many14 sequential14 lsr14
// reads were14 preventing14 data from being written14 to rx14 fifo.
// underrun14 signal14 was not used and was removed from the project14.
//
// Revision14 1.21  2001/12/13 10:31:16  mohor14
// timeout irq14 must be set regardless14 of the rda14 irq14 (rda14 irq14 does not reset the
// timeout counter).
//
// Revision14 1.20  2001/12/10 19:52:05  gorban14
// Igor14 fixed14 break condition bugs14
//
// Revision14 1.19  2001/12/06 14:51:04  gorban14
// Bug14 in LSR14[0] is fixed14.
// All WISHBONE14 signals14 are now sampled14, so another14 wait-state is introduced14 on all transfers14.
//
// Revision14 1.18  2001/12/03 21:44:29  gorban14
// Updated14 specification14 documentation.
// Added14 full 32-bit data bus interface, now as default.
// Address is 5-bit wide14 in 32-bit data bus mode.
// Added14 wb_sel_i14 input to the core14. It's used in the 32-bit mode.
// Added14 debug14 interface with two14 32-bit read-only registers in 32-bit mode.
// Bits14 5 and 6 of LSR14 are now only cleared14 on TX14 FIFO write.
// My14 small test bench14 is modified to work14 with 32-bit mode.
//
// Revision14 1.17  2001/11/28 19:36:39  gorban14
// Fixed14: timeout and break didn14't pay14 attention14 to current data format14 when counting14 time
//
// Revision14 1.16  2001/11/27 22:17:09  gorban14
// Fixed14 bug14 that prevented14 synthesis14 in uart_receiver14.v
//
// Revision14 1.15  2001/11/26 21:38:54  gorban14
// Lots14 of fixes14:
// Break14 condition wasn14't handled14 correctly at all.
// LSR14 bits could lose14 their14 values.
// LSR14 value after reset was wrong14.
// Timing14 of THRE14 interrupt14 signal14 corrected14.
// LSR14 bit 0 timing14 corrected14.
//
// Revision14 1.14  2001/11/10 12:43:21  gorban14
// Logic14 Synthesis14 bugs14 fixed14. Some14 other minor14 changes14
//
// Revision14 1.13  2001/11/08 14:54:23  mohor14
// Comments14 in Slovene14 language14 deleted14, few14 small fixes14 for better14 work14 of
// old14 tools14. IRQs14 need to be fix14.
//
// Revision14 1.12  2001/11/07 17:51:52  gorban14
// Heavily14 rewritten14 interrupt14 and LSR14 subsystems14.
// Many14 bugs14 hopefully14 squashed14.
//
// Revision14 1.11  2001/10/31 15:19:22  gorban14
// Fixes14 to break and timeout conditions14
//
// Revision14 1.10  2001/10/20 09:58:40  gorban14
// Small14 synopsis14 fixes14
//
// Revision14 1.9  2001/08/24 21:01:12  mohor14
// Things14 connected14 to parity14 changed.
// Clock14 devider14 changed.
//
// Revision14 1.8  2001/08/23 16:05:05  mohor14
// Stop bit bug14 fixed14.
// Parity14 bug14 fixed14.
// WISHBONE14 read cycle bug14 fixed14,
// OE14 indicator14 (Overrun14 Error) bug14 fixed14.
// PE14 indicator14 (Parity14 Error) bug14 fixed14.
// Register read bug14 fixed14.
//
// Revision14 1.6  2001/06/23 11:21:48  gorban14
// DL14 made14 16-bit long14. Fixed14 transmission14/reception14 bugs14.
//
// Revision14 1.5  2001/06/02 14:28:14  gorban14
// Fixed14 receiver14 and transmitter14. Major14 bug14 fixed14.
//
// Revision14 1.4  2001/05/31 20:08:01  gorban14
// FIFO changes14 and other corrections14.
//
// Revision14 1.3  2001/05/27 17:37:49  gorban14
// Fixed14 many14 bugs14. Updated14 spec14. Changed14 FIFO files structure14. See CHANGES14.txt14 file.
//
// Revision14 1.2  2001/05/21 19:12:02  gorban14
// Corrected14 some14 Linter14 messages14.
//
// Revision14 1.1  2001/05/17 18:34:18  gorban14
// First14 'stable' release. Should14 be sythesizable14 now. Also14 added new header.
//
// Revision14 1.0  2001-05-17 21:27:11+02  jacob14
// Initial14 revision14
//
//

// synopsys14 translate_off14
`include "timescale.v"
// synopsys14 translate_on14

`include "uart_defines14.v"

module uart_receiver14 (clk14, wb_rst_i14, lcr14, rf_pop14, srx_pad_i14, enable, 
	counter_t14, rf_count14, rf_data_out14, rf_error_bit14, rf_overrun14, rx_reset14, lsr_mask14, rstate, rf_push_pulse14);

input				clk14;
input				wb_rst_i14;
input	[7:0]	lcr14;
input				rf_pop14;
input				srx_pad_i14;
input				enable;
input				rx_reset14;
input       lsr_mask14;

output	[9:0]			counter_t14;
output	[`UART_FIFO_COUNTER_W14-1:0]	rf_count14;
output	[`UART_FIFO_REC_WIDTH14-1:0]	rf_data_out14;
output				rf_overrun14;
output				rf_error_bit14;
output [3:0] 		rstate;
output 				rf_push_pulse14;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1614;
reg	[2:0]	rbit_counter14;
reg	[7:0]	rshift14;			// receiver14 shift14 register
reg		rparity14;		// received14 parity14
reg		rparity_error14;
reg		rframing_error14;		// framing14 error flag14
reg		rbit_in14;
reg		rparity_xor14;
reg	[7:0]	counter_b14;	// counts14 the 0 (low14) signals14
reg   rf_push_q14;

// RX14 FIFO signals14
reg	[`UART_FIFO_REC_WIDTH14-1:0]	rf_data_in14;
wire	[`UART_FIFO_REC_WIDTH14-1:0]	rf_data_out14;
wire      rf_push_pulse14;
reg				rf_push14;
wire				rf_pop14;
wire				rf_overrun14;
wire	[`UART_FIFO_COUNTER_W14-1:0]	rf_count14;
wire				rf_error_bit14; // an error (parity14 or framing14) is inside the fifo
wire 				break_error14 = (counter_b14 == 0);

// RX14 FIFO instance
uart_rfifo14 #(`UART_FIFO_REC_WIDTH14) fifo_rx14(
	.clk14(		clk14		), 
	.wb_rst_i14(	wb_rst_i14	),
	.data_in14(	rf_data_in14	),
	.data_out14(	rf_data_out14	),
	.push14(		rf_push_pulse14		),
	.pop14(		rf_pop14		),
	.overrun14(	rf_overrun14	),
	.count(		rf_count14	),
	.error_bit14(	rf_error_bit14	),
	.fifo_reset14(	rx_reset14	),
	.reset_status14(lsr_mask14)
);

wire 		rcounter16_eq_714 = (rcounter1614 == 4'd7);
wire		rcounter16_eq_014 = (rcounter1614 == 4'd0);
wire		rcounter16_eq_114 = (rcounter1614 == 4'd1);

wire [3:0] rcounter16_minus_114 = rcounter1614 - 1'b1;

parameter  sr_idle14 					= 4'd0;
parameter  sr_rec_start14 			= 4'd1;
parameter  sr_rec_bit14 				= 4'd2;
parameter  sr_rec_parity14			= 4'd3;
parameter  sr_rec_stop14 				= 4'd4;
parameter  sr_check_parity14 		= 4'd5;
parameter  sr_rec_prepare14 			= 4'd6;
parameter  sr_end_bit14				= 4'd7;
parameter  sr_ca_lc_parity14	      = 4'd8;
parameter  sr_wait114 					= 4'd9;
parameter  sr_push14 					= 4'd10;


always @(posedge clk14 or posedge wb_rst_i14)
begin
  if (wb_rst_i14)
  begin
     rstate 			<= #1 sr_idle14;
	  rbit_in14 				<= #1 1'b0;
	  rcounter1614 			<= #1 0;
	  rbit_counter14 		<= #1 0;
	  rparity_xor14 		<= #1 1'b0;
	  rframing_error14 	<= #1 1'b0;
	  rparity_error14 		<= #1 1'b0;
	  rparity14 				<= #1 1'b0;
	  rshift14 				<= #1 0;
	  rf_push14 				<= #1 1'b0;
	  rf_data_in14 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle14 : begin
			rf_push14 			  <= #1 1'b0;
			rf_data_in14 	  <= #1 0;
			rcounter1614 	  <= #1 4'b1110;
			if (srx_pad_i14==1'b0 & ~break_error14)   // detected a pulse14 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start14;
			end
		end
	sr_rec_start14 :	begin
  			rf_push14 			  <= #1 1'b0;
				if (rcounter16_eq_714)    // check the pulse14
					if (srx_pad_i14==1'b1)   // no start bit
						rstate <= #1 sr_idle14;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare14;
				rcounter1614 <= #1 rcounter16_minus_114;
			end
	sr_rec_prepare14:begin
				case (lcr14[/*`UART_LC_BITS14*/1:0])  // number14 of bits in a word14
				2'b00 : rbit_counter14 <= #1 3'b100;
				2'b01 : rbit_counter14 <= #1 3'b101;
				2'b10 : rbit_counter14 <= #1 3'b110;
				2'b11 : rbit_counter14 <= #1 3'b111;
				endcase
				if (rcounter16_eq_014)
				begin
					rstate		<= #1 sr_rec_bit14;
					rcounter1614	<= #1 4'b1110;
					rshift14		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare14;
				rcounter1614 <= #1 rcounter16_minus_114;
			end
	sr_rec_bit14 :	begin
				if (rcounter16_eq_014)
					rstate <= #1 sr_end_bit14;
				if (rcounter16_eq_714) // read the bit
					case (lcr14[/*`UART_LC_BITS14*/1:0])  // number14 of bits in a word14
					2'b00 : rshift14[4:0]  <= #1 {srx_pad_i14, rshift14[4:1]};
					2'b01 : rshift14[5:0]  <= #1 {srx_pad_i14, rshift14[5:1]};
					2'b10 : rshift14[6:0]  <= #1 {srx_pad_i14, rshift14[6:1]};
					2'b11 : rshift14[7:0]  <= #1 {srx_pad_i14, rshift14[7:1]};
					endcase
				rcounter1614 <= #1 rcounter16_minus_114;
			end
	sr_end_bit14 :   begin
				if (rbit_counter14==3'b0) // no more bits in word14
					if (lcr14[`UART_LC_PE14]) // choose14 state based on parity14
						rstate <= #1 sr_rec_parity14;
					else
					begin
						rstate <= #1 sr_rec_stop14;
						rparity_error14 <= #1 1'b0;  // no parity14 - no error :)
					end
				else		// else we14 have more bits to read
				begin
					rstate <= #1 sr_rec_bit14;
					rbit_counter14 <= #1 rbit_counter14 - 1'b1;
				end
				rcounter1614 <= #1 4'b1110;
			end
	sr_rec_parity14: begin
				if (rcounter16_eq_714)	// read the parity14
				begin
					rparity14 <= #1 srx_pad_i14;
					rstate <= #1 sr_ca_lc_parity14;
				end
				rcounter1614 <= #1 rcounter16_minus_114;
			end
	sr_ca_lc_parity14 : begin    // rcounter14 equals14 6
				rcounter1614  <= #1 rcounter16_minus_114;
				rparity_xor14 <= #1 ^{rshift14,rparity14}; // calculate14 parity14 on all incoming14 data
				rstate      <= #1 sr_check_parity14;
			  end
	sr_check_parity14: begin	  // rcounter14 equals14 5
				case ({lcr14[`UART_LC_EP14],lcr14[`UART_LC_SP14]})
					2'b00: rparity_error14 <= #1  rparity_xor14 == 0;  // no error if parity14 1
					2'b01: rparity_error14 <= #1 ~rparity14;      // parity14 should sticked14 to 1
					2'b10: rparity_error14 <= #1  rparity_xor14 == 1;   // error if parity14 is odd14
					2'b11: rparity_error14 <= #1  rparity14;	  // parity14 should be sticked14 to 0
				endcase
				rcounter1614 <= #1 rcounter16_minus_114;
				rstate <= #1 sr_wait114;
			  end
	sr_wait114 :	if (rcounter16_eq_014)
			begin
				rstate <= #1 sr_rec_stop14;
				rcounter1614 <= #1 4'b1110;
			end
			else
				rcounter1614 <= #1 rcounter16_minus_114;
	sr_rec_stop14 :	begin
				if (rcounter16_eq_714)	// read the parity14
				begin
					rframing_error14 <= #1 !srx_pad_i14; // no framing14 error if input is 1 (stop bit)
					rstate <= #1 sr_push14;
				end
				rcounter1614 <= #1 rcounter16_minus_114;
			end
	sr_push14 :	begin
///////////////////////////////////////
//				$display($time, ": received14: %b", rf_data_in14);
        if(srx_pad_i14 | break_error14)
          begin
            if(break_error14)
        		  rf_data_in14 	<= #1 {8'b0, 3'b100}; // break input (empty14 character14) to receiver14 FIFO
            else
        			rf_data_in14  <= #1 {rshift14, 1'b0, rparity_error14, rframing_error14};
      		  rf_push14 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle14;
          end
        else if(~rframing_error14)  // There's always a framing14 before break_error14 -> wait for break or srx_pad_i14
          begin
       			rf_data_in14  <= #1 {rshift14, 1'b0, rparity_error14, rframing_error14};
      		  rf_push14 		  <= #1 1'b1;
      			rcounter1614 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start14;
          end
                      
			end
	default : rstate <= #1 sr_idle14;
	endcase
  end  // if (enable)
end // always of receiver14

always @ (posedge clk14 or posedge wb_rst_i14)
begin
  if(wb_rst_i14)
    rf_push_q14 <= 0;
  else
    rf_push_q14 <= #1 rf_push14;
end

assign rf_push_pulse14 = rf_push14 & ~rf_push_q14;

  
//
// Break14 condition detection14.
// Works14 in conjuction14 with the receiver14 state machine14

reg 	[9:0]	toc_value14; // value to be set to timeout counter

always @(lcr14)
	case (lcr14[3:0])
		4'b0000										: toc_value14 = 447; // 7 bits
		4'b0100										: toc_value14 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value14 = 511; // 8 bits
		4'b1100										: toc_value14 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value14 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value14 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value14 = 703; // 11 bits
		4'b1111										: toc_value14 = 767; // 12 bits
	endcase // case(lcr14[3:0])

wire [7:0] 	brc_value14; // value to be set to break counter
assign 		brc_value14 = toc_value14[9:2]; // the same as timeout but 1 insead14 of 4 character14 times

always @(posedge clk14 or posedge wb_rst_i14)
begin
	if (wb_rst_i14)
		counter_b14 <= #1 8'd159;
	else
	if (srx_pad_i14)
		counter_b14 <= #1 brc_value14; // character14 time length - 1
	else
	if(enable & counter_b14 != 8'b0)            // only work14 on enable times  break not reached14.
		counter_b14 <= #1 counter_b14 - 1;  // decrement break counter
end // always of break condition detection14

///
/// Timeout14 condition detection14
reg	[9:0]	counter_t14;	// counts14 the timeout condition clocks14

always @(posedge clk14 or posedge wb_rst_i14)
begin
	if (wb_rst_i14)
		counter_t14 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse14 || rf_pop14 || rf_count14 == 0) // counter is reset when RX14 FIFO is empty14, accessed or above14 trigger level
			counter_t14 <= #1 toc_value14;
		else
		if (enable && counter_t14 != 10'b0)  // we14 don14't want14 to underflow14
			counter_t14 <= #1 counter_t14 - 1;		
end
	
endmodule
