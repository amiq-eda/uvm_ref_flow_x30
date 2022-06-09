//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver8.v                                             ////
////                                                              ////
////                                                              ////
////  This8 file is part of the "UART8 16550 compatible8" project8    ////
////  http8://www8.opencores8.org8/cores8/uart165508/                   ////
////                                                              ////
////  Documentation8 related8 to this project8:                      ////
////  - http8://www8.opencores8.org8/cores8/uart165508/                 ////
////                                                              ////
////  Projects8 compatibility8:                                     ////
////  - WISHBONE8                                                  ////
////  RS2328 Protocol8                                              ////
////  16550D uart8 (mostly8 supported)                              ////
////                                                              ////
////  Overview8 (main8 Features8):                                   ////
////  UART8 core8 receiver8 logic                                    ////
////                                                              ////
////  Known8 problems8 (limits8):                                    ////
////  None8 known8                                                  ////
////                                                              ////
////  To8 Do8:                                                      ////
////  Thourough8 testing8.                                          ////
////                                                              ////
////  Author8(s):                                                  ////
////      - gorban8@opencores8.org8                                  ////
////      - Jacob8 Gorban8                                          ////
////      - Igor8 Mohor8 (igorm8@opencores8.org8)                      ////
////                                                              ////
////  Created8:        2001/05/12                                  ////
////  Last8 Updated8:   2001/05/17                                  ////
////                  (See log8 for the revision8 history8)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2000, 2001 Authors8                             ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS8 Revision8 History8
//
// $Log: not supported by cvs2svn8 $
// Revision8 1.29  2002/07/29 21:16:18  gorban8
// The uart_defines8.v file is included8 again8 in sources8.
//
// Revision8 1.28  2002/07/22 23:02:23  gorban8
// Bug8 Fixes8:
//  * Possible8 loss of sync and bad8 reception8 of stop bit on slow8 baud8 rates8 fixed8.
//   Problem8 reported8 by Kenny8.Tung8.
//  * Bad (or lack8 of ) loopback8 handling8 fixed8. Reported8 by Cherry8 Withers8.
//
// Improvements8:
//  * Made8 FIFO's as general8 inferrable8 memory where possible8.
//  So8 on FPGA8 they should be inferred8 as RAM8 (Distributed8 RAM8 on Xilinx8).
//  This8 saves8 about8 1/3 of the Slice8 count and reduces8 P&R and synthesis8 times.
//
//  * Added8 optional8 baudrate8 output (baud_o8).
//  This8 is identical8 to BAUDOUT8* signal8 on 16550 chip8.
//  It outputs8 16xbit_clock_rate - the divided8 clock8.
//  It's disabled by default. Define8 UART_HAS_BAUDRATE_OUTPUT8 to use.
//
// Revision8 1.27  2001/12/30 20:39:13  mohor8
// More than one character8 was stored8 in case of break. End8 of the break
// was not detected correctly.
//
// Revision8 1.26  2001/12/20 13:28:27  mohor8
// Missing8 declaration8 of rf_push_q8 fixed8.
//
// Revision8 1.25  2001/12/20 13:25:46  mohor8
// rx8 push8 changed to be only one cycle wide8.
//
// Revision8 1.24  2001/12/19 08:03:34  mohor8
// Warnings8 cleared8.
//
// Revision8 1.23  2001/12/19 07:33:54  mohor8
// Synplicity8 was having8 troubles8 with the comment8.
//
// Revision8 1.22  2001/12/17 14:46:48  mohor8
// overrun8 signal8 was moved to separate8 block because many8 sequential8 lsr8
// reads were8 preventing8 data from being written8 to rx8 fifo.
// underrun8 signal8 was not used and was removed from the project8.
//
// Revision8 1.21  2001/12/13 10:31:16  mohor8
// timeout irq8 must be set regardless8 of the rda8 irq8 (rda8 irq8 does not reset the
// timeout counter).
//
// Revision8 1.20  2001/12/10 19:52:05  gorban8
// Igor8 fixed8 break condition bugs8
//
// Revision8 1.19  2001/12/06 14:51:04  gorban8
// Bug8 in LSR8[0] is fixed8.
// All WISHBONE8 signals8 are now sampled8, so another8 wait-state is introduced8 on all transfers8.
//
// Revision8 1.18  2001/12/03 21:44:29  gorban8
// Updated8 specification8 documentation.
// Added8 full 32-bit data bus interface, now as default.
// Address is 5-bit wide8 in 32-bit data bus mode.
// Added8 wb_sel_i8 input to the core8. It's used in the 32-bit mode.
// Added8 debug8 interface with two8 32-bit read-only registers in 32-bit mode.
// Bits8 5 and 6 of LSR8 are now only cleared8 on TX8 FIFO write.
// My8 small test bench8 is modified to work8 with 32-bit mode.
//
// Revision8 1.17  2001/11/28 19:36:39  gorban8
// Fixed8: timeout and break didn8't pay8 attention8 to current data format8 when counting8 time
//
// Revision8 1.16  2001/11/27 22:17:09  gorban8
// Fixed8 bug8 that prevented8 synthesis8 in uart_receiver8.v
//
// Revision8 1.15  2001/11/26 21:38:54  gorban8
// Lots8 of fixes8:
// Break8 condition wasn8't handled8 correctly at all.
// LSR8 bits could lose8 their8 values.
// LSR8 value after reset was wrong8.
// Timing8 of THRE8 interrupt8 signal8 corrected8.
// LSR8 bit 0 timing8 corrected8.
//
// Revision8 1.14  2001/11/10 12:43:21  gorban8
// Logic8 Synthesis8 bugs8 fixed8. Some8 other minor8 changes8
//
// Revision8 1.13  2001/11/08 14:54:23  mohor8
// Comments8 in Slovene8 language8 deleted8, few8 small fixes8 for better8 work8 of
// old8 tools8. IRQs8 need to be fix8.
//
// Revision8 1.12  2001/11/07 17:51:52  gorban8
// Heavily8 rewritten8 interrupt8 and LSR8 subsystems8.
// Many8 bugs8 hopefully8 squashed8.
//
// Revision8 1.11  2001/10/31 15:19:22  gorban8
// Fixes8 to break and timeout conditions8
//
// Revision8 1.10  2001/10/20 09:58:40  gorban8
// Small8 synopsis8 fixes8
//
// Revision8 1.9  2001/08/24 21:01:12  mohor8
// Things8 connected8 to parity8 changed.
// Clock8 devider8 changed.
//
// Revision8 1.8  2001/08/23 16:05:05  mohor8
// Stop bit bug8 fixed8.
// Parity8 bug8 fixed8.
// WISHBONE8 read cycle bug8 fixed8,
// OE8 indicator8 (Overrun8 Error) bug8 fixed8.
// PE8 indicator8 (Parity8 Error) bug8 fixed8.
// Register read bug8 fixed8.
//
// Revision8 1.6  2001/06/23 11:21:48  gorban8
// DL8 made8 16-bit long8. Fixed8 transmission8/reception8 bugs8.
//
// Revision8 1.5  2001/06/02 14:28:14  gorban8
// Fixed8 receiver8 and transmitter8. Major8 bug8 fixed8.
//
// Revision8 1.4  2001/05/31 20:08:01  gorban8
// FIFO changes8 and other corrections8.
//
// Revision8 1.3  2001/05/27 17:37:49  gorban8
// Fixed8 many8 bugs8. Updated8 spec8. Changed8 FIFO files structure8. See CHANGES8.txt8 file.
//
// Revision8 1.2  2001/05/21 19:12:02  gorban8
// Corrected8 some8 Linter8 messages8.
//
// Revision8 1.1  2001/05/17 18:34:18  gorban8
// First8 'stable' release. Should8 be sythesizable8 now. Also8 added new header.
//
// Revision8 1.0  2001-05-17 21:27:11+02  jacob8
// Initial8 revision8
//
//

// synopsys8 translate_off8
`include "timescale.v"
// synopsys8 translate_on8

`include "uart_defines8.v"

module uart_receiver8 (clk8, wb_rst_i8, lcr8, rf_pop8, srx_pad_i8, enable, 
	counter_t8, rf_count8, rf_data_out8, rf_error_bit8, rf_overrun8, rx_reset8, lsr_mask8, rstate, rf_push_pulse8);

input				clk8;
input				wb_rst_i8;
input	[7:0]	lcr8;
input				rf_pop8;
input				srx_pad_i8;
input				enable;
input				rx_reset8;
input       lsr_mask8;

output	[9:0]			counter_t8;
output	[`UART_FIFO_COUNTER_W8-1:0]	rf_count8;
output	[`UART_FIFO_REC_WIDTH8-1:0]	rf_data_out8;
output				rf_overrun8;
output				rf_error_bit8;
output [3:0] 		rstate;
output 				rf_push_pulse8;

reg	[3:0]	rstate;
reg	[3:0]	rcounter168;
reg	[2:0]	rbit_counter8;
reg	[7:0]	rshift8;			// receiver8 shift8 register
reg		rparity8;		// received8 parity8
reg		rparity_error8;
reg		rframing_error8;		// framing8 error flag8
reg		rbit_in8;
reg		rparity_xor8;
reg	[7:0]	counter_b8;	// counts8 the 0 (low8) signals8
reg   rf_push_q8;

// RX8 FIFO signals8
reg	[`UART_FIFO_REC_WIDTH8-1:0]	rf_data_in8;
wire	[`UART_FIFO_REC_WIDTH8-1:0]	rf_data_out8;
wire      rf_push_pulse8;
reg				rf_push8;
wire				rf_pop8;
wire				rf_overrun8;
wire	[`UART_FIFO_COUNTER_W8-1:0]	rf_count8;
wire				rf_error_bit8; // an error (parity8 or framing8) is inside the fifo
wire 				break_error8 = (counter_b8 == 0);

// RX8 FIFO instance
uart_rfifo8 #(`UART_FIFO_REC_WIDTH8) fifo_rx8(
	.clk8(		clk8		), 
	.wb_rst_i8(	wb_rst_i8	),
	.data_in8(	rf_data_in8	),
	.data_out8(	rf_data_out8	),
	.push8(		rf_push_pulse8		),
	.pop8(		rf_pop8		),
	.overrun8(	rf_overrun8	),
	.count(		rf_count8	),
	.error_bit8(	rf_error_bit8	),
	.fifo_reset8(	rx_reset8	),
	.reset_status8(lsr_mask8)
);

wire 		rcounter16_eq_78 = (rcounter168 == 4'd7);
wire		rcounter16_eq_08 = (rcounter168 == 4'd0);
wire		rcounter16_eq_18 = (rcounter168 == 4'd1);

wire [3:0] rcounter16_minus_18 = rcounter168 - 1'b1;

parameter  sr_idle8 					= 4'd0;
parameter  sr_rec_start8 			= 4'd1;
parameter  sr_rec_bit8 				= 4'd2;
parameter  sr_rec_parity8			= 4'd3;
parameter  sr_rec_stop8 				= 4'd4;
parameter  sr_check_parity8 		= 4'd5;
parameter  sr_rec_prepare8 			= 4'd6;
parameter  sr_end_bit8				= 4'd7;
parameter  sr_ca_lc_parity8	      = 4'd8;
parameter  sr_wait18 					= 4'd9;
parameter  sr_push8 					= 4'd10;


always @(posedge clk8 or posedge wb_rst_i8)
begin
  if (wb_rst_i8)
  begin
     rstate 			<= #1 sr_idle8;
	  rbit_in8 				<= #1 1'b0;
	  rcounter168 			<= #1 0;
	  rbit_counter8 		<= #1 0;
	  rparity_xor8 		<= #1 1'b0;
	  rframing_error8 	<= #1 1'b0;
	  rparity_error8 		<= #1 1'b0;
	  rparity8 				<= #1 1'b0;
	  rshift8 				<= #1 0;
	  rf_push8 				<= #1 1'b0;
	  rf_data_in8 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle8 : begin
			rf_push8 			  <= #1 1'b0;
			rf_data_in8 	  <= #1 0;
			rcounter168 	  <= #1 4'b1110;
			if (srx_pad_i8==1'b0 & ~break_error8)   // detected a pulse8 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start8;
			end
		end
	sr_rec_start8 :	begin
  			rf_push8 			  <= #1 1'b0;
				if (rcounter16_eq_78)    // check the pulse8
					if (srx_pad_i8==1'b1)   // no start bit
						rstate <= #1 sr_idle8;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare8;
				rcounter168 <= #1 rcounter16_minus_18;
			end
	sr_rec_prepare8:begin
				case (lcr8[/*`UART_LC_BITS8*/1:0])  // number8 of bits in a word8
				2'b00 : rbit_counter8 <= #1 3'b100;
				2'b01 : rbit_counter8 <= #1 3'b101;
				2'b10 : rbit_counter8 <= #1 3'b110;
				2'b11 : rbit_counter8 <= #1 3'b111;
				endcase
				if (rcounter16_eq_08)
				begin
					rstate		<= #1 sr_rec_bit8;
					rcounter168	<= #1 4'b1110;
					rshift8		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare8;
				rcounter168 <= #1 rcounter16_minus_18;
			end
	sr_rec_bit8 :	begin
				if (rcounter16_eq_08)
					rstate <= #1 sr_end_bit8;
				if (rcounter16_eq_78) // read the bit
					case (lcr8[/*`UART_LC_BITS8*/1:0])  // number8 of bits in a word8
					2'b00 : rshift8[4:0]  <= #1 {srx_pad_i8, rshift8[4:1]};
					2'b01 : rshift8[5:0]  <= #1 {srx_pad_i8, rshift8[5:1]};
					2'b10 : rshift8[6:0]  <= #1 {srx_pad_i8, rshift8[6:1]};
					2'b11 : rshift8[7:0]  <= #1 {srx_pad_i8, rshift8[7:1]};
					endcase
				rcounter168 <= #1 rcounter16_minus_18;
			end
	sr_end_bit8 :   begin
				if (rbit_counter8==3'b0) // no more bits in word8
					if (lcr8[`UART_LC_PE8]) // choose8 state based on parity8
						rstate <= #1 sr_rec_parity8;
					else
					begin
						rstate <= #1 sr_rec_stop8;
						rparity_error8 <= #1 1'b0;  // no parity8 - no error :)
					end
				else		// else we8 have more bits to read
				begin
					rstate <= #1 sr_rec_bit8;
					rbit_counter8 <= #1 rbit_counter8 - 1'b1;
				end
				rcounter168 <= #1 4'b1110;
			end
	sr_rec_parity8: begin
				if (rcounter16_eq_78)	// read the parity8
				begin
					rparity8 <= #1 srx_pad_i8;
					rstate <= #1 sr_ca_lc_parity8;
				end
				rcounter168 <= #1 rcounter16_minus_18;
			end
	sr_ca_lc_parity8 : begin    // rcounter8 equals8 6
				rcounter168  <= #1 rcounter16_minus_18;
				rparity_xor8 <= #1 ^{rshift8,rparity8}; // calculate8 parity8 on all incoming8 data
				rstate      <= #1 sr_check_parity8;
			  end
	sr_check_parity8: begin	  // rcounter8 equals8 5
				case ({lcr8[`UART_LC_EP8],lcr8[`UART_LC_SP8]})
					2'b00: rparity_error8 <= #1  rparity_xor8 == 0;  // no error if parity8 1
					2'b01: rparity_error8 <= #1 ~rparity8;      // parity8 should sticked8 to 1
					2'b10: rparity_error8 <= #1  rparity_xor8 == 1;   // error if parity8 is odd8
					2'b11: rparity_error8 <= #1  rparity8;	  // parity8 should be sticked8 to 0
				endcase
				rcounter168 <= #1 rcounter16_minus_18;
				rstate <= #1 sr_wait18;
			  end
	sr_wait18 :	if (rcounter16_eq_08)
			begin
				rstate <= #1 sr_rec_stop8;
				rcounter168 <= #1 4'b1110;
			end
			else
				rcounter168 <= #1 rcounter16_minus_18;
	sr_rec_stop8 :	begin
				if (rcounter16_eq_78)	// read the parity8
				begin
					rframing_error8 <= #1 !srx_pad_i8; // no framing8 error if input is 1 (stop bit)
					rstate <= #1 sr_push8;
				end
				rcounter168 <= #1 rcounter16_minus_18;
			end
	sr_push8 :	begin
///////////////////////////////////////
//				$display($time, ": received8: %b", rf_data_in8);
        if(srx_pad_i8 | break_error8)
          begin
            if(break_error8)
        		  rf_data_in8 	<= #1 {8'b0, 3'b100}; // break input (empty8 character8) to receiver8 FIFO
            else
        			rf_data_in8  <= #1 {rshift8, 1'b0, rparity_error8, rframing_error8};
      		  rf_push8 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle8;
          end
        else if(~rframing_error8)  // There's always a framing8 before break_error8 -> wait for break or srx_pad_i8
          begin
       			rf_data_in8  <= #1 {rshift8, 1'b0, rparity_error8, rframing_error8};
      		  rf_push8 		  <= #1 1'b1;
      			rcounter168 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start8;
          end
                      
			end
	default : rstate <= #1 sr_idle8;
	endcase
  end  // if (enable)
end // always of receiver8

always @ (posedge clk8 or posedge wb_rst_i8)
begin
  if(wb_rst_i8)
    rf_push_q8 <= 0;
  else
    rf_push_q8 <= #1 rf_push8;
end

assign rf_push_pulse8 = rf_push8 & ~rf_push_q8;

  
//
// Break8 condition detection8.
// Works8 in conjuction8 with the receiver8 state machine8

reg 	[9:0]	toc_value8; // value to be set to timeout counter

always @(lcr8)
	case (lcr8[3:0])
		4'b0000										: toc_value8 = 447; // 7 bits
		4'b0100										: toc_value8 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value8 = 511; // 8 bits
		4'b1100										: toc_value8 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value8 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value8 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value8 = 703; // 11 bits
		4'b1111										: toc_value8 = 767; // 12 bits
	endcase // case(lcr8[3:0])

wire [7:0] 	brc_value8; // value to be set to break counter
assign 		brc_value8 = toc_value8[9:2]; // the same as timeout but 1 insead8 of 4 character8 times

always @(posedge clk8 or posedge wb_rst_i8)
begin
	if (wb_rst_i8)
		counter_b8 <= #1 8'd159;
	else
	if (srx_pad_i8)
		counter_b8 <= #1 brc_value8; // character8 time length - 1
	else
	if(enable & counter_b8 != 8'b0)            // only work8 on enable times  break not reached8.
		counter_b8 <= #1 counter_b8 - 1;  // decrement break counter
end // always of break condition detection8

///
/// Timeout8 condition detection8
reg	[9:0]	counter_t8;	// counts8 the timeout condition clocks8

always @(posedge clk8 or posedge wb_rst_i8)
begin
	if (wb_rst_i8)
		counter_t8 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse8 || rf_pop8 || rf_count8 == 0) // counter is reset when RX8 FIFO is empty8, accessed or above8 trigger level
			counter_t8 <= #1 toc_value8;
		else
		if (enable && counter_t8 != 10'b0)  // we8 don8't want8 to underflow8
			counter_t8 <= #1 counter_t8 - 1;		
end
	
endmodule
