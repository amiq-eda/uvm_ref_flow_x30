//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver6.v                                             ////
////                                                              ////
////                                                              ////
////  This6 file is part of the "UART6 16550 compatible6" project6    ////
////  http6://www6.opencores6.org6/cores6/uart165506/                   ////
////                                                              ////
////  Documentation6 related6 to this project6:                      ////
////  - http6://www6.opencores6.org6/cores6/uart165506/                 ////
////                                                              ////
////  Projects6 compatibility6:                                     ////
////  - WISHBONE6                                                  ////
////  RS2326 Protocol6                                              ////
////  16550D uart6 (mostly6 supported)                              ////
////                                                              ////
////  Overview6 (main6 Features6):                                   ////
////  UART6 core6 receiver6 logic                                    ////
////                                                              ////
////  Known6 problems6 (limits6):                                    ////
////  None6 known6                                                  ////
////                                                              ////
////  To6 Do6:                                                      ////
////  Thourough6 testing6.                                          ////
////                                                              ////
////  Author6(s):                                                  ////
////      - gorban6@opencores6.org6                                  ////
////      - Jacob6 Gorban6                                          ////
////      - Igor6 Mohor6 (igorm6@opencores6.org6)                      ////
////                                                              ////
////  Created6:        2001/05/12                                  ////
////  Last6 Updated6:   2001/05/17                                  ////
////                  (See log6 for the revision6 history6)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2000, 2001 Authors6                             ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS6 Revision6 History6
//
// $Log: not supported by cvs2svn6 $
// Revision6 1.29  2002/07/29 21:16:18  gorban6
// The uart_defines6.v file is included6 again6 in sources6.
//
// Revision6 1.28  2002/07/22 23:02:23  gorban6
// Bug6 Fixes6:
//  * Possible6 loss of sync and bad6 reception6 of stop bit on slow6 baud6 rates6 fixed6.
//   Problem6 reported6 by Kenny6.Tung6.
//  * Bad (or lack6 of ) loopback6 handling6 fixed6. Reported6 by Cherry6 Withers6.
//
// Improvements6:
//  * Made6 FIFO's as general6 inferrable6 memory where possible6.
//  So6 on FPGA6 they should be inferred6 as RAM6 (Distributed6 RAM6 on Xilinx6).
//  This6 saves6 about6 1/3 of the Slice6 count and reduces6 P&R and synthesis6 times.
//
//  * Added6 optional6 baudrate6 output (baud_o6).
//  This6 is identical6 to BAUDOUT6* signal6 on 16550 chip6.
//  It outputs6 16xbit_clock_rate - the divided6 clock6.
//  It's disabled by default. Define6 UART_HAS_BAUDRATE_OUTPUT6 to use.
//
// Revision6 1.27  2001/12/30 20:39:13  mohor6
// More than one character6 was stored6 in case of break. End6 of the break
// was not detected correctly.
//
// Revision6 1.26  2001/12/20 13:28:27  mohor6
// Missing6 declaration6 of rf_push_q6 fixed6.
//
// Revision6 1.25  2001/12/20 13:25:46  mohor6
// rx6 push6 changed to be only one cycle wide6.
//
// Revision6 1.24  2001/12/19 08:03:34  mohor6
// Warnings6 cleared6.
//
// Revision6 1.23  2001/12/19 07:33:54  mohor6
// Synplicity6 was having6 troubles6 with the comment6.
//
// Revision6 1.22  2001/12/17 14:46:48  mohor6
// overrun6 signal6 was moved to separate6 block because many6 sequential6 lsr6
// reads were6 preventing6 data from being written6 to rx6 fifo.
// underrun6 signal6 was not used and was removed from the project6.
//
// Revision6 1.21  2001/12/13 10:31:16  mohor6
// timeout irq6 must be set regardless6 of the rda6 irq6 (rda6 irq6 does not reset the
// timeout counter).
//
// Revision6 1.20  2001/12/10 19:52:05  gorban6
// Igor6 fixed6 break condition bugs6
//
// Revision6 1.19  2001/12/06 14:51:04  gorban6
// Bug6 in LSR6[0] is fixed6.
// All WISHBONE6 signals6 are now sampled6, so another6 wait-state is introduced6 on all transfers6.
//
// Revision6 1.18  2001/12/03 21:44:29  gorban6
// Updated6 specification6 documentation.
// Added6 full 32-bit data bus interface, now as default.
// Address is 5-bit wide6 in 32-bit data bus mode.
// Added6 wb_sel_i6 input to the core6. It's used in the 32-bit mode.
// Added6 debug6 interface with two6 32-bit read-only registers in 32-bit mode.
// Bits6 5 and 6 of LSR6 are now only cleared6 on TX6 FIFO write.
// My6 small test bench6 is modified to work6 with 32-bit mode.
//
// Revision6 1.17  2001/11/28 19:36:39  gorban6
// Fixed6: timeout and break didn6't pay6 attention6 to current data format6 when counting6 time
//
// Revision6 1.16  2001/11/27 22:17:09  gorban6
// Fixed6 bug6 that prevented6 synthesis6 in uart_receiver6.v
//
// Revision6 1.15  2001/11/26 21:38:54  gorban6
// Lots6 of fixes6:
// Break6 condition wasn6't handled6 correctly at all.
// LSR6 bits could lose6 their6 values.
// LSR6 value after reset was wrong6.
// Timing6 of THRE6 interrupt6 signal6 corrected6.
// LSR6 bit 0 timing6 corrected6.
//
// Revision6 1.14  2001/11/10 12:43:21  gorban6
// Logic6 Synthesis6 bugs6 fixed6. Some6 other minor6 changes6
//
// Revision6 1.13  2001/11/08 14:54:23  mohor6
// Comments6 in Slovene6 language6 deleted6, few6 small fixes6 for better6 work6 of
// old6 tools6. IRQs6 need to be fix6.
//
// Revision6 1.12  2001/11/07 17:51:52  gorban6
// Heavily6 rewritten6 interrupt6 and LSR6 subsystems6.
// Many6 bugs6 hopefully6 squashed6.
//
// Revision6 1.11  2001/10/31 15:19:22  gorban6
// Fixes6 to break and timeout conditions6
//
// Revision6 1.10  2001/10/20 09:58:40  gorban6
// Small6 synopsis6 fixes6
//
// Revision6 1.9  2001/08/24 21:01:12  mohor6
// Things6 connected6 to parity6 changed.
// Clock6 devider6 changed.
//
// Revision6 1.8  2001/08/23 16:05:05  mohor6
// Stop bit bug6 fixed6.
// Parity6 bug6 fixed6.
// WISHBONE6 read cycle bug6 fixed6,
// OE6 indicator6 (Overrun6 Error) bug6 fixed6.
// PE6 indicator6 (Parity6 Error) bug6 fixed6.
// Register read bug6 fixed6.
//
// Revision6 1.6  2001/06/23 11:21:48  gorban6
// DL6 made6 16-bit long6. Fixed6 transmission6/reception6 bugs6.
//
// Revision6 1.5  2001/06/02 14:28:14  gorban6
// Fixed6 receiver6 and transmitter6. Major6 bug6 fixed6.
//
// Revision6 1.4  2001/05/31 20:08:01  gorban6
// FIFO changes6 and other corrections6.
//
// Revision6 1.3  2001/05/27 17:37:49  gorban6
// Fixed6 many6 bugs6. Updated6 spec6. Changed6 FIFO files structure6. See CHANGES6.txt6 file.
//
// Revision6 1.2  2001/05/21 19:12:02  gorban6
// Corrected6 some6 Linter6 messages6.
//
// Revision6 1.1  2001/05/17 18:34:18  gorban6
// First6 'stable' release. Should6 be sythesizable6 now. Also6 added new header.
//
// Revision6 1.0  2001-05-17 21:27:11+02  jacob6
// Initial6 revision6
//
//

// synopsys6 translate_off6
`include "timescale.v"
// synopsys6 translate_on6

`include "uart_defines6.v"

module uart_receiver6 (clk6, wb_rst_i6, lcr6, rf_pop6, srx_pad_i6, enable, 
	counter_t6, rf_count6, rf_data_out6, rf_error_bit6, rf_overrun6, rx_reset6, lsr_mask6, rstate, rf_push_pulse6);

input				clk6;
input				wb_rst_i6;
input	[7:0]	lcr6;
input				rf_pop6;
input				srx_pad_i6;
input				enable;
input				rx_reset6;
input       lsr_mask6;

output	[9:0]			counter_t6;
output	[`UART_FIFO_COUNTER_W6-1:0]	rf_count6;
output	[`UART_FIFO_REC_WIDTH6-1:0]	rf_data_out6;
output				rf_overrun6;
output				rf_error_bit6;
output [3:0] 		rstate;
output 				rf_push_pulse6;

reg	[3:0]	rstate;
reg	[3:0]	rcounter166;
reg	[2:0]	rbit_counter6;
reg	[7:0]	rshift6;			// receiver6 shift6 register
reg		rparity6;		// received6 parity6
reg		rparity_error6;
reg		rframing_error6;		// framing6 error flag6
reg		rbit_in6;
reg		rparity_xor6;
reg	[7:0]	counter_b6;	// counts6 the 0 (low6) signals6
reg   rf_push_q6;

// RX6 FIFO signals6
reg	[`UART_FIFO_REC_WIDTH6-1:0]	rf_data_in6;
wire	[`UART_FIFO_REC_WIDTH6-1:0]	rf_data_out6;
wire      rf_push_pulse6;
reg				rf_push6;
wire				rf_pop6;
wire				rf_overrun6;
wire	[`UART_FIFO_COUNTER_W6-1:0]	rf_count6;
wire				rf_error_bit6; // an error (parity6 or framing6) is inside the fifo
wire 				break_error6 = (counter_b6 == 0);

// RX6 FIFO instance
uart_rfifo6 #(`UART_FIFO_REC_WIDTH6) fifo_rx6(
	.clk6(		clk6		), 
	.wb_rst_i6(	wb_rst_i6	),
	.data_in6(	rf_data_in6	),
	.data_out6(	rf_data_out6	),
	.push6(		rf_push_pulse6		),
	.pop6(		rf_pop6		),
	.overrun6(	rf_overrun6	),
	.count(		rf_count6	),
	.error_bit6(	rf_error_bit6	),
	.fifo_reset6(	rx_reset6	),
	.reset_status6(lsr_mask6)
);

wire 		rcounter16_eq_76 = (rcounter166 == 4'd7);
wire		rcounter16_eq_06 = (rcounter166 == 4'd0);
wire		rcounter16_eq_16 = (rcounter166 == 4'd1);

wire [3:0] rcounter16_minus_16 = rcounter166 - 1'b1;

parameter  sr_idle6 					= 4'd0;
parameter  sr_rec_start6 			= 4'd1;
parameter  sr_rec_bit6 				= 4'd2;
parameter  sr_rec_parity6			= 4'd3;
parameter  sr_rec_stop6 				= 4'd4;
parameter  sr_check_parity6 		= 4'd5;
parameter  sr_rec_prepare6 			= 4'd6;
parameter  sr_end_bit6				= 4'd7;
parameter  sr_ca_lc_parity6	      = 4'd8;
parameter  sr_wait16 					= 4'd9;
parameter  sr_push6 					= 4'd10;


always @(posedge clk6 or posedge wb_rst_i6)
begin
  if (wb_rst_i6)
  begin
     rstate 			<= #1 sr_idle6;
	  rbit_in6 				<= #1 1'b0;
	  rcounter166 			<= #1 0;
	  rbit_counter6 		<= #1 0;
	  rparity_xor6 		<= #1 1'b0;
	  rframing_error6 	<= #1 1'b0;
	  rparity_error6 		<= #1 1'b0;
	  rparity6 				<= #1 1'b0;
	  rshift6 				<= #1 0;
	  rf_push6 				<= #1 1'b0;
	  rf_data_in6 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle6 : begin
			rf_push6 			  <= #1 1'b0;
			rf_data_in6 	  <= #1 0;
			rcounter166 	  <= #1 4'b1110;
			if (srx_pad_i6==1'b0 & ~break_error6)   // detected a pulse6 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start6;
			end
		end
	sr_rec_start6 :	begin
  			rf_push6 			  <= #1 1'b0;
				if (rcounter16_eq_76)    // check the pulse6
					if (srx_pad_i6==1'b1)   // no start bit
						rstate <= #1 sr_idle6;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare6;
				rcounter166 <= #1 rcounter16_minus_16;
			end
	sr_rec_prepare6:begin
				case (lcr6[/*`UART_LC_BITS6*/1:0])  // number6 of bits in a word6
				2'b00 : rbit_counter6 <= #1 3'b100;
				2'b01 : rbit_counter6 <= #1 3'b101;
				2'b10 : rbit_counter6 <= #1 3'b110;
				2'b11 : rbit_counter6 <= #1 3'b111;
				endcase
				if (rcounter16_eq_06)
				begin
					rstate		<= #1 sr_rec_bit6;
					rcounter166	<= #1 4'b1110;
					rshift6		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare6;
				rcounter166 <= #1 rcounter16_minus_16;
			end
	sr_rec_bit6 :	begin
				if (rcounter16_eq_06)
					rstate <= #1 sr_end_bit6;
				if (rcounter16_eq_76) // read the bit
					case (lcr6[/*`UART_LC_BITS6*/1:0])  // number6 of bits in a word6
					2'b00 : rshift6[4:0]  <= #1 {srx_pad_i6, rshift6[4:1]};
					2'b01 : rshift6[5:0]  <= #1 {srx_pad_i6, rshift6[5:1]};
					2'b10 : rshift6[6:0]  <= #1 {srx_pad_i6, rshift6[6:1]};
					2'b11 : rshift6[7:0]  <= #1 {srx_pad_i6, rshift6[7:1]};
					endcase
				rcounter166 <= #1 rcounter16_minus_16;
			end
	sr_end_bit6 :   begin
				if (rbit_counter6==3'b0) // no more bits in word6
					if (lcr6[`UART_LC_PE6]) // choose6 state based on parity6
						rstate <= #1 sr_rec_parity6;
					else
					begin
						rstate <= #1 sr_rec_stop6;
						rparity_error6 <= #1 1'b0;  // no parity6 - no error :)
					end
				else		// else we6 have more bits to read
				begin
					rstate <= #1 sr_rec_bit6;
					rbit_counter6 <= #1 rbit_counter6 - 1'b1;
				end
				rcounter166 <= #1 4'b1110;
			end
	sr_rec_parity6: begin
				if (rcounter16_eq_76)	// read the parity6
				begin
					rparity6 <= #1 srx_pad_i6;
					rstate <= #1 sr_ca_lc_parity6;
				end
				rcounter166 <= #1 rcounter16_minus_16;
			end
	sr_ca_lc_parity6 : begin    // rcounter6 equals6 6
				rcounter166  <= #1 rcounter16_minus_16;
				rparity_xor6 <= #1 ^{rshift6,rparity6}; // calculate6 parity6 on all incoming6 data
				rstate      <= #1 sr_check_parity6;
			  end
	sr_check_parity6: begin	  // rcounter6 equals6 5
				case ({lcr6[`UART_LC_EP6],lcr6[`UART_LC_SP6]})
					2'b00: rparity_error6 <= #1  rparity_xor6 == 0;  // no error if parity6 1
					2'b01: rparity_error6 <= #1 ~rparity6;      // parity6 should sticked6 to 1
					2'b10: rparity_error6 <= #1  rparity_xor6 == 1;   // error if parity6 is odd6
					2'b11: rparity_error6 <= #1  rparity6;	  // parity6 should be sticked6 to 0
				endcase
				rcounter166 <= #1 rcounter16_minus_16;
				rstate <= #1 sr_wait16;
			  end
	sr_wait16 :	if (rcounter16_eq_06)
			begin
				rstate <= #1 sr_rec_stop6;
				rcounter166 <= #1 4'b1110;
			end
			else
				rcounter166 <= #1 rcounter16_minus_16;
	sr_rec_stop6 :	begin
				if (rcounter16_eq_76)	// read the parity6
				begin
					rframing_error6 <= #1 !srx_pad_i6; // no framing6 error if input is 1 (stop bit)
					rstate <= #1 sr_push6;
				end
				rcounter166 <= #1 rcounter16_minus_16;
			end
	sr_push6 :	begin
///////////////////////////////////////
//				$display($time, ": received6: %b", rf_data_in6);
        if(srx_pad_i6 | break_error6)
          begin
            if(break_error6)
        		  rf_data_in6 	<= #1 {8'b0, 3'b100}; // break input (empty6 character6) to receiver6 FIFO
            else
        			rf_data_in6  <= #1 {rshift6, 1'b0, rparity_error6, rframing_error6};
      		  rf_push6 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle6;
          end
        else if(~rframing_error6)  // There's always a framing6 before break_error6 -> wait for break or srx_pad_i6
          begin
       			rf_data_in6  <= #1 {rshift6, 1'b0, rparity_error6, rframing_error6};
      		  rf_push6 		  <= #1 1'b1;
      			rcounter166 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start6;
          end
                      
			end
	default : rstate <= #1 sr_idle6;
	endcase
  end  // if (enable)
end // always of receiver6

always @ (posedge clk6 or posedge wb_rst_i6)
begin
  if(wb_rst_i6)
    rf_push_q6 <= 0;
  else
    rf_push_q6 <= #1 rf_push6;
end

assign rf_push_pulse6 = rf_push6 & ~rf_push_q6;

  
//
// Break6 condition detection6.
// Works6 in conjuction6 with the receiver6 state machine6

reg 	[9:0]	toc_value6; // value to be set to timeout counter

always @(lcr6)
	case (lcr6[3:0])
		4'b0000										: toc_value6 = 447; // 7 bits
		4'b0100										: toc_value6 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value6 = 511; // 8 bits
		4'b1100										: toc_value6 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value6 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value6 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value6 = 703; // 11 bits
		4'b1111										: toc_value6 = 767; // 12 bits
	endcase // case(lcr6[3:0])

wire [7:0] 	brc_value6; // value to be set to break counter
assign 		brc_value6 = toc_value6[9:2]; // the same as timeout but 1 insead6 of 4 character6 times

always @(posedge clk6 or posedge wb_rst_i6)
begin
	if (wb_rst_i6)
		counter_b6 <= #1 8'd159;
	else
	if (srx_pad_i6)
		counter_b6 <= #1 brc_value6; // character6 time length - 1
	else
	if(enable & counter_b6 != 8'b0)            // only work6 on enable times  break not reached6.
		counter_b6 <= #1 counter_b6 - 1;  // decrement break counter
end // always of break condition detection6

///
/// Timeout6 condition detection6
reg	[9:0]	counter_t6;	// counts6 the timeout condition clocks6

always @(posedge clk6 or posedge wb_rst_i6)
begin
	if (wb_rst_i6)
		counter_t6 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse6 || rf_pop6 || rf_count6 == 0) // counter is reset when RX6 FIFO is empty6, accessed or above6 trigger level
			counter_t6 <= #1 toc_value6;
		else
		if (enable && counter_t6 != 10'b0)  // we6 don6't want6 to underflow6
			counter_t6 <= #1 counter_t6 - 1;		
end
	
endmodule
