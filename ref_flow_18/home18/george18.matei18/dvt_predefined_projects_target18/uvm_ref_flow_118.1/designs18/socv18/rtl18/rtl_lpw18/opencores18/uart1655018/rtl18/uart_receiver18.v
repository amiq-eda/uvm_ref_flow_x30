//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver18.v                                             ////
////                                                              ////
////                                                              ////
////  This18 file is part of the "UART18 16550 compatible18" project18    ////
////  http18://www18.opencores18.org18/cores18/uart1655018/                   ////
////                                                              ////
////  Documentation18 related18 to this project18:                      ////
////  - http18://www18.opencores18.org18/cores18/uart1655018/                 ////
////                                                              ////
////  Projects18 compatibility18:                                     ////
////  - WISHBONE18                                                  ////
////  RS23218 Protocol18                                              ////
////  16550D uart18 (mostly18 supported)                              ////
////                                                              ////
////  Overview18 (main18 Features18):                                   ////
////  UART18 core18 receiver18 logic                                    ////
////                                                              ////
////  Known18 problems18 (limits18):                                    ////
////  None18 known18                                                  ////
////                                                              ////
////  To18 Do18:                                                      ////
////  Thourough18 testing18.                                          ////
////                                                              ////
////  Author18(s):                                                  ////
////      - gorban18@opencores18.org18                                  ////
////      - Jacob18 Gorban18                                          ////
////      - Igor18 Mohor18 (igorm18@opencores18.org18)                      ////
////                                                              ////
////  Created18:        2001/05/12                                  ////
////  Last18 Updated18:   2001/05/17                                  ////
////                  (See log18 for the revision18 history18)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2000, 2001 Authors18                             ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS18 Revision18 History18
//
// $Log: not supported by cvs2svn18 $
// Revision18 1.29  2002/07/29 21:16:18  gorban18
// The uart_defines18.v file is included18 again18 in sources18.
//
// Revision18 1.28  2002/07/22 23:02:23  gorban18
// Bug18 Fixes18:
//  * Possible18 loss of sync and bad18 reception18 of stop bit on slow18 baud18 rates18 fixed18.
//   Problem18 reported18 by Kenny18.Tung18.
//  * Bad (or lack18 of ) loopback18 handling18 fixed18. Reported18 by Cherry18 Withers18.
//
// Improvements18:
//  * Made18 FIFO's as general18 inferrable18 memory where possible18.
//  So18 on FPGA18 they should be inferred18 as RAM18 (Distributed18 RAM18 on Xilinx18).
//  This18 saves18 about18 1/3 of the Slice18 count and reduces18 P&R and synthesis18 times.
//
//  * Added18 optional18 baudrate18 output (baud_o18).
//  This18 is identical18 to BAUDOUT18* signal18 on 16550 chip18.
//  It outputs18 16xbit_clock_rate - the divided18 clock18.
//  It's disabled by default. Define18 UART_HAS_BAUDRATE_OUTPUT18 to use.
//
// Revision18 1.27  2001/12/30 20:39:13  mohor18
// More than one character18 was stored18 in case of break. End18 of the break
// was not detected correctly.
//
// Revision18 1.26  2001/12/20 13:28:27  mohor18
// Missing18 declaration18 of rf_push_q18 fixed18.
//
// Revision18 1.25  2001/12/20 13:25:46  mohor18
// rx18 push18 changed to be only one cycle wide18.
//
// Revision18 1.24  2001/12/19 08:03:34  mohor18
// Warnings18 cleared18.
//
// Revision18 1.23  2001/12/19 07:33:54  mohor18
// Synplicity18 was having18 troubles18 with the comment18.
//
// Revision18 1.22  2001/12/17 14:46:48  mohor18
// overrun18 signal18 was moved to separate18 block because many18 sequential18 lsr18
// reads were18 preventing18 data from being written18 to rx18 fifo.
// underrun18 signal18 was not used and was removed from the project18.
//
// Revision18 1.21  2001/12/13 10:31:16  mohor18
// timeout irq18 must be set regardless18 of the rda18 irq18 (rda18 irq18 does not reset the
// timeout counter).
//
// Revision18 1.20  2001/12/10 19:52:05  gorban18
// Igor18 fixed18 break condition bugs18
//
// Revision18 1.19  2001/12/06 14:51:04  gorban18
// Bug18 in LSR18[0] is fixed18.
// All WISHBONE18 signals18 are now sampled18, so another18 wait-state is introduced18 on all transfers18.
//
// Revision18 1.18  2001/12/03 21:44:29  gorban18
// Updated18 specification18 documentation.
// Added18 full 32-bit data bus interface, now as default.
// Address is 5-bit wide18 in 32-bit data bus mode.
// Added18 wb_sel_i18 input to the core18. It's used in the 32-bit mode.
// Added18 debug18 interface with two18 32-bit read-only registers in 32-bit mode.
// Bits18 5 and 6 of LSR18 are now only cleared18 on TX18 FIFO write.
// My18 small test bench18 is modified to work18 with 32-bit mode.
//
// Revision18 1.17  2001/11/28 19:36:39  gorban18
// Fixed18: timeout and break didn18't pay18 attention18 to current data format18 when counting18 time
//
// Revision18 1.16  2001/11/27 22:17:09  gorban18
// Fixed18 bug18 that prevented18 synthesis18 in uart_receiver18.v
//
// Revision18 1.15  2001/11/26 21:38:54  gorban18
// Lots18 of fixes18:
// Break18 condition wasn18't handled18 correctly at all.
// LSR18 bits could lose18 their18 values.
// LSR18 value after reset was wrong18.
// Timing18 of THRE18 interrupt18 signal18 corrected18.
// LSR18 bit 0 timing18 corrected18.
//
// Revision18 1.14  2001/11/10 12:43:21  gorban18
// Logic18 Synthesis18 bugs18 fixed18. Some18 other minor18 changes18
//
// Revision18 1.13  2001/11/08 14:54:23  mohor18
// Comments18 in Slovene18 language18 deleted18, few18 small fixes18 for better18 work18 of
// old18 tools18. IRQs18 need to be fix18.
//
// Revision18 1.12  2001/11/07 17:51:52  gorban18
// Heavily18 rewritten18 interrupt18 and LSR18 subsystems18.
// Many18 bugs18 hopefully18 squashed18.
//
// Revision18 1.11  2001/10/31 15:19:22  gorban18
// Fixes18 to break and timeout conditions18
//
// Revision18 1.10  2001/10/20 09:58:40  gorban18
// Small18 synopsis18 fixes18
//
// Revision18 1.9  2001/08/24 21:01:12  mohor18
// Things18 connected18 to parity18 changed.
// Clock18 devider18 changed.
//
// Revision18 1.8  2001/08/23 16:05:05  mohor18
// Stop bit bug18 fixed18.
// Parity18 bug18 fixed18.
// WISHBONE18 read cycle bug18 fixed18,
// OE18 indicator18 (Overrun18 Error) bug18 fixed18.
// PE18 indicator18 (Parity18 Error) bug18 fixed18.
// Register read bug18 fixed18.
//
// Revision18 1.6  2001/06/23 11:21:48  gorban18
// DL18 made18 16-bit long18. Fixed18 transmission18/reception18 bugs18.
//
// Revision18 1.5  2001/06/02 14:28:14  gorban18
// Fixed18 receiver18 and transmitter18. Major18 bug18 fixed18.
//
// Revision18 1.4  2001/05/31 20:08:01  gorban18
// FIFO changes18 and other corrections18.
//
// Revision18 1.3  2001/05/27 17:37:49  gorban18
// Fixed18 many18 bugs18. Updated18 spec18. Changed18 FIFO files structure18. See CHANGES18.txt18 file.
//
// Revision18 1.2  2001/05/21 19:12:02  gorban18
// Corrected18 some18 Linter18 messages18.
//
// Revision18 1.1  2001/05/17 18:34:18  gorban18
// First18 'stable' release. Should18 be sythesizable18 now. Also18 added new header.
//
// Revision18 1.0  2001-05-17 21:27:11+02  jacob18
// Initial18 revision18
//
//

// synopsys18 translate_off18
`include "timescale.v"
// synopsys18 translate_on18

`include "uart_defines18.v"

module uart_receiver18 (clk18, wb_rst_i18, lcr18, rf_pop18, srx_pad_i18, enable, 
	counter_t18, rf_count18, rf_data_out18, rf_error_bit18, rf_overrun18, rx_reset18, lsr_mask18, rstate, rf_push_pulse18);

input				clk18;
input				wb_rst_i18;
input	[7:0]	lcr18;
input				rf_pop18;
input				srx_pad_i18;
input				enable;
input				rx_reset18;
input       lsr_mask18;

output	[9:0]			counter_t18;
output	[`UART_FIFO_COUNTER_W18-1:0]	rf_count18;
output	[`UART_FIFO_REC_WIDTH18-1:0]	rf_data_out18;
output				rf_overrun18;
output				rf_error_bit18;
output [3:0] 		rstate;
output 				rf_push_pulse18;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1618;
reg	[2:0]	rbit_counter18;
reg	[7:0]	rshift18;			// receiver18 shift18 register
reg		rparity18;		// received18 parity18
reg		rparity_error18;
reg		rframing_error18;		// framing18 error flag18
reg		rbit_in18;
reg		rparity_xor18;
reg	[7:0]	counter_b18;	// counts18 the 0 (low18) signals18
reg   rf_push_q18;

// RX18 FIFO signals18
reg	[`UART_FIFO_REC_WIDTH18-1:0]	rf_data_in18;
wire	[`UART_FIFO_REC_WIDTH18-1:0]	rf_data_out18;
wire      rf_push_pulse18;
reg				rf_push18;
wire				rf_pop18;
wire				rf_overrun18;
wire	[`UART_FIFO_COUNTER_W18-1:0]	rf_count18;
wire				rf_error_bit18; // an error (parity18 or framing18) is inside the fifo
wire 				break_error18 = (counter_b18 == 0);

// RX18 FIFO instance
uart_rfifo18 #(`UART_FIFO_REC_WIDTH18) fifo_rx18(
	.clk18(		clk18		), 
	.wb_rst_i18(	wb_rst_i18	),
	.data_in18(	rf_data_in18	),
	.data_out18(	rf_data_out18	),
	.push18(		rf_push_pulse18		),
	.pop18(		rf_pop18		),
	.overrun18(	rf_overrun18	),
	.count(		rf_count18	),
	.error_bit18(	rf_error_bit18	),
	.fifo_reset18(	rx_reset18	),
	.reset_status18(lsr_mask18)
);

wire 		rcounter16_eq_718 = (rcounter1618 == 4'd7);
wire		rcounter16_eq_018 = (rcounter1618 == 4'd0);
wire		rcounter16_eq_118 = (rcounter1618 == 4'd1);

wire [3:0] rcounter16_minus_118 = rcounter1618 - 1'b1;

parameter  sr_idle18 					= 4'd0;
parameter  sr_rec_start18 			= 4'd1;
parameter  sr_rec_bit18 				= 4'd2;
parameter  sr_rec_parity18			= 4'd3;
parameter  sr_rec_stop18 				= 4'd4;
parameter  sr_check_parity18 		= 4'd5;
parameter  sr_rec_prepare18 			= 4'd6;
parameter  sr_end_bit18				= 4'd7;
parameter  sr_ca_lc_parity18	      = 4'd8;
parameter  sr_wait118 					= 4'd9;
parameter  sr_push18 					= 4'd10;


always @(posedge clk18 or posedge wb_rst_i18)
begin
  if (wb_rst_i18)
  begin
     rstate 			<= #1 sr_idle18;
	  rbit_in18 				<= #1 1'b0;
	  rcounter1618 			<= #1 0;
	  rbit_counter18 		<= #1 0;
	  rparity_xor18 		<= #1 1'b0;
	  rframing_error18 	<= #1 1'b0;
	  rparity_error18 		<= #1 1'b0;
	  rparity18 				<= #1 1'b0;
	  rshift18 				<= #1 0;
	  rf_push18 				<= #1 1'b0;
	  rf_data_in18 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle18 : begin
			rf_push18 			  <= #1 1'b0;
			rf_data_in18 	  <= #1 0;
			rcounter1618 	  <= #1 4'b1110;
			if (srx_pad_i18==1'b0 & ~break_error18)   // detected a pulse18 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start18;
			end
		end
	sr_rec_start18 :	begin
  			rf_push18 			  <= #1 1'b0;
				if (rcounter16_eq_718)    // check the pulse18
					if (srx_pad_i18==1'b1)   // no start bit
						rstate <= #1 sr_idle18;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare18;
				rcounter1618 <= #1 rcounter16_minus_118;
			end
	sr_rec_prepare18:begin
				case (lcr18[/*`UART_LC_BITS18*/1:0])  // number18 of bits in a word18
				2'b00 : rbit_counter18 <= #1 3'b100;
				2'b01 : rbit_counter18 <= #1 3'b101;
				2'b10 : rbit_counter18 <= #1 3'b110;
				2'b11 : rbit_counter18 <= #1 3'b111;
				endcase
				if (rcounter16_eq_018)
				begin
					rstate		<= #1 sr_rec_bit18;
					rcounter1618	<= #1 4'b1110;
					rshift18		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare18;
				rcounter1618 <= #1 rcounter16_minus_118;
			end
	sr_rec_bit18 :	begin
				if (rcounter16_eq_018)
					rstate <= #1 sr_end_bit18;
				if (rcounter16_eq_718) // read the bit
					case (lcr18[/*`UART_LC_BITS18*/1:0])  // number18 of bits in a word18
					2'b00 : rshift18[4:0]  <= #1 {srx_pad_i18, rshift18[4:1]};
					2'b01 : rshift18[5:0]  <= #1 {srx_pad_i18, rshift18[5:1]};
					2'b10 : rshift18[6:0]  <= #1 {srx_pad_i18, rshift18[6:1]};
					2'b11 : rshift18[7:0]  <= #1 {srx_pad_i18, rshift18[7:1]};
					endcase
				rcounter1618 <= #1 rcounter16_minus_118;
			end
	sr_end_bit18 :   begin
				if (rbit_counter18==3'b0) // no more bits in word18
					if (lcr18[`UART_LC_PE18]) // choose18 state based on parity18
						rstate <= #1 sr_rec_parity18;
					else
					begin
						rstate <= #1 sr_rec_stop18;
						rparity_error18 <= #1 1'b0;  // no parity18 - no error :)
					end
				else		// else we18 have more bits to read
				begin
					rstate <= #1 sr_rec_bit18;
					rbit_counter18 <= #1 rbit_counter18 - 1'b1;
				end
				rcounter1618 <= #1 4'b1110;
			end
	sr_rec_parity18: begin
				if (rcounter16_eq_718)	// read the parity18
				begin
					rparity18 <= #1 srx_pad_i18;
					rstate <= #1 sr_ca_lc_parity18;
				end
				rcounter1618 <= #1 rcounter16_minus_118;
			end
	sr_ca_lc_parity18 : begin    // rcounter18 equals18 6
				rcounter1618  <= #1 rcounter16_minus_118;
				rparity_xor18 <= #1 ^{rshift18,rparity18}; // calculate18 parity18 on all incoming18 data
				rstate      <= #1 sr_check_parity18;
			  end
	sr_check_parity18: begin	  // rcounter18 equals18 5
				case ({lcr18[`UART_LC_EP18],lcr18[`UART_LC_SP18]})
					2'b00: rparity_error18 <= #1  rparity_xor18 == 0;  // no error if parity18 1
					2'b01: rparity_error18 <= #1 ~rparity18;      // parity18 should sticked18 to 1
					2'b10: rparity_error18 <= #1  rparity_xor18 == 1;   // error if parity18 is odd18
					2'b11: rparity_error18 <= #1  rparity18;	  // parity18 should be sticked18 to 0
				endcase
				rcounter1618 <= #1 rcounter16_minus_118;
				rstate <= #1 sr_wait118;
			  end
	sr_wait118 :	if (rcounter16_eq_018)
			begin
				rstate <= #1 sr_rec_stop18;
				rcounter1618 <= #1 4'b1110;
			end
			else
				rcounter1618 <= #1 rcounter16_minus_118;
	sr_rec_stop18 :	begin
				if (rcounter16_eq_718)	// read the parity18
				begin
					rframing_error18 <= #1 !srx_pad_i18; // no framing18 error if input is 1 (stop bit)
					rstate <= #1 sr_push18;
				end
				rcounter1618 <= #1 rcounter16_minus_118;
			end
	sr_push18 :	begin
///////////////////////////////////////
//				$display($time, ": received18: %b", rf_data_in18);
        if(srx_pad_i18 | break_error18)
          begin
            if(break_error18)
        		  rf_data_in18 	<= #1 {8'b0, 3'b100}; // break input (empty18 character18) to receiver18 FIFO
            else
        			rf_data_in18  <= #1 {rshift18, 1'b0, rparity_error18, rframing_error18};
      		  rf_push18 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle18;
          end
        else if(~rframing_error18)  // There's always a framing18 before break_error18 -> wait for break or srx_pad_i18
          begin
       			rf_data_in18  <= #1 {rshift18, 1'b0, rparity_error18, rframing_error18};
      		  rf_push18 		  <= #1 1'b1;
      			rcounter1618 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start18;
          end
                      
			end
	default : rstate <= #1 sr_idle18;
	endcase
  end  // if (enable)
end // always of receiver18

always @ (posedge clk18 or posedge wb_rst_i18)
begin
  if(wb_rst_i18)
    rf_push_q18 <= 0;
  else
    rf_push_q18 <= #1 rf_push18;
end

assign rf_push_pulse18 = rf_push18 & ~rf_push_q18;

  
//
// Break18 condition detection18.
// Works18 in conjuction18 with the receiver18 state machine18

reg 	[9:0]	toc_value18; // value to be set to timeout counter

always @(lcr18)
	case (lcr18[3:0])
		4'b0000										: toc_value18 = 447; // 7 bits
		4'b0100										: toc_value18 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value18 = 511; // 8 bits
		4'b1100										: toc_value18 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value18 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value18 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value18 = 703; // 11 bits
		4'b1111										: toc_value18 = 767; // 12 bits
	endcase // case(lcr18[3:0])

wire [7:0] 	brc_value18; // value to be set to break counter
assign 		brc_value18 = toc_value18[9:2]; // the same as timeout but 1 insead18 of 4 character18 times

always @(posedge clk18 or posedge wb_rst_i18)
begin
	if (wb_rst_i18)
		counter_b18 <= #1 8'd159;
	else
	if (srx_pad_i18)
		counter_b18 <= #1 brc_value18; // character18 time length - 1
	else
	if(enable & counter_b18 != 8'b0)            // only work18 on enable times  break not reached18.
		counter_b18 <= #1 counter_b18 - 1;  // decrement break counter
end // always of break condition detection18

///
/// Timeout18 condition detection18
reg	[9:0]	counter_t18;	// counts18 the timeout condition clocks18

always @(posedge clk18 or posedge wb_rst_i18)
begin
	if (wb_rst_i18)
		counter_t18 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse18 || rf_pop18 || rf_count18 == 0) // counter is reset when RX18 FIFO is empty18, accessed or above18 trigger level
			counter_t18 <= #1 toc_value18;
		else
		if (enable && counter_t18 != 10'b0)  // we18 don18't want18 to underflow18
			counter_t18 <= #1 counter_t18 - 1;		
end
	
endmodule
