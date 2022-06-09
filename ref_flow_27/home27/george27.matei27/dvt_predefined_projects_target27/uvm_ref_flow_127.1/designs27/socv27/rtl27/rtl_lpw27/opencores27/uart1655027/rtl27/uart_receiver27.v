//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver27.v                                             ////
////                                                              ////
////                                                              ////
////  This27 file is part of the "UART27 16550 compatible27" project27    ////
////  http27://www27.opencores27.org27/cores27/uart1655027/                   ////
////                                                              ////
////  Documentation27 related27 to this project27:                      ////
////  - http27://www27.opencores27.org27/cores27/uart1655027/                 ////
////                                                              ////
////  Projects27 compatibility27:                                     ////
////  - WISHBONE27                                                  ////
////  RS23227 Protocol27                                              ////
////  16550D uart27 (mostly27 supported)                              ////
////                                                              ////
////  Overview27 (main27 Features27):                                   ////
////  UART27 core27 receiver27 logic                                    ////
////                                                              ////
////  Known27 problems27 (limits27):                                    ////
////  None27 known27                                                  ////
////                                                              ////
////  To27 Do27:                                                      ////
////  Thourough27 testing27.                                          ////
////                                                              ////
////  Author27(s):                                                  ////
////      - gorban27@opencores27.org27                                  ////
////      - Jacob27 Gorban27                                          ////
////      - Igor27 Mohor27 (igorm27@opencores27.org27)                      ////
////                                                              ////
////  Created27:        2001/05/12                                  ////
////  Last27 Updated27:   2001/05/17                                  ////
////                  (See log27 for the revision27 history27)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2000, 2001 Authors27                             ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS27 Revision27 History27
//
// $Log: not supported by cvs2svn27 $
// Revision27 1.29  2002/07/29 21:16:18  gorban27
// The uart_defines27.v file is included27 again27 in sources27.
//
// Revision27 1.28  2002/07/22 23:02:23  gorban27
// Bug27 Fixes27:
//  * Possible27 loss of sync and bad27 reception27 of stop bit on slow27 baud27 rates27 fixed27.
//   Problem27 reported27 by Kenny27.Tung27.
//  * Bad (or lack27 of ) loopback27 handling27 fixed27. Reported27 by Cherry27 Withers27.
//
// Improvements27:
//  * Made27 FIFO's as general27 inferrable27 memory where possible27.
//  So27 on FPGA27 they should be inferred27 as RAM27 (Distributed27 RAM27 on Xilinx27).
//  This27 saves27 about27 1/3 of the Slice27 count and reduces27 P&R and synthesis27 times.
//
//  * Added27 optional27 baudrate27 output (baud_o27).
//  This27 is identical27 to BAUDOUT27* signal27 on 16550 chip27.
//  It outputs27 16xbit_clock_rate - the divided27 clock27.
//  It's disabled by default. Define27 UART_HAS_BAUDRATE_OUTPUT27 to use.
//
// Revision27 1.27  2001/12/30 20:39:13  mohor27
// More than one character27 was stored27 in case of break. End27 of the break
// was not detected correctly.
//
// Revision27 1.26  2001/12/20 13:28:27  mohor27
// Missing27 declaration27 of rf_push_q27 fixed27.
//
// Revision27 1.25  2001/12/20 13:25:46  mohor27
// rx27 push27 changed to be only one cycle wide27.
//
// Revision27 1.24  2001/12/19 08:03:34  mohor27
// Warnings27 cleared27.
//
// Revision27 1.23  2001/12/19 07:33:54  mohor27
// Synplicity27 was having27 troubles27 with the comment27.
//
// Revision27 1.22  2001/12/17 14:46:48  mohor27
// overrun27 signal27 was moved to separate27 block because many27 sequential27 lsr27
// reads were27 preventing27 data from being written27 to rx27 fifo.
// underrun27 signal27 was not used and was removed from the project27.
//
// Revision27 1.21  2001/12/13 10:31:16  mohor27
// timeout irq27 must be set regardless27 of the rda27 irq27 (rda27 irq27 does not reset the
// timeout counter).
//
// Revision27 1.20  2001/12/10 19:52:05  gorban27
// Igor27 fixed27 break condition bugs27
//
// Revision27 1.19  2001/12/06 14:51:04  gorban27
// Bug27 in LSR27[0] is fixed27.
// All WISHBONE27 signals27 are now sampled27, so another27 wait-state is introduced27 on all transfers27.
//
// Revision27 1.18  2001/12/03 21:44:29  gorban27
// Updated27 specification27 documentation.
// Added27 full 32-bit data bus interface, now as default.
// Address is 5-bit wide27 in 32-bit data bus mode.
// Added27 wb_sel_i27 input to the core27. It's used in the 32-bit mode.
// Added27 debug27 interface with two27 32-bit read-only registers in 32-bit mode.
// Bits27 5 and 6 of LSR27 are now only cleared27 on TX27 FIFO write.
// My27 small test bench27 is modified to work27 with 32-bit mode.
//
// Revision27 1.17  2001/11/28 19:36:39  gorban27
// Fixed27: timeout and break didn27't pay27 attention27 to current data format27 when counting27 time
//
// Revision27 1.16  2001/11/27 22:17:09  gorban27
// Fixed27 bug27 that prevented27 synthesis27 in uart_receiver27.v
//
// Revision27 1.15  2001/11/26 21:38:54  gorban27
// Lots27 of fixes27:
// Break27 condition wasn27't handled27 correctly at all.
// LSR27 bits could lose27 their27 values.
// LSR27 value after reset was wrong27.
// Timing27 of THRE27 interrupt27 signal27 corrected27.
// LSR27 bit 0 timing27 corrected27.
//
// Revision27 1.14  2001/11/10 12:43:21  gorban27
// Logic27 Synthesis27 bugs27 fixed27. Some27 other minor27 changes27
//
// Revision27 1.13  2001/11/08 14:54:23  mohor27
// Comments27 in Slovene27 language27 deleted27, few27 small fixes27 for better27 work27 of
// old27 tools27. IRQs27 need to be fix27.
//
// Revision27 1.12  2001/11/07 17:51:52  gorban27
// Heavily27 rewritten27 interrupt27 and LSR27 subsystems27.
// Many27 bugs27 hopefully27 squashed27.
//
// Revision27 1.11  2001/10/31 15:19:22  gorban27
// Fixes27 to break and timeout conditions27
//
// Revision27 1.10  2001/10/20 09:58:40  gorban27
// Small27 synopsis27 fixes27
//
// Revision27 1.9  2001/08/24 21:01:12  mohor27
// Things27 connected27 to parity27 changed.
// Clock27 devider27 changed.
//
// Revision27 1.8  2001/08/23 16:05:05  mohor27
// Stop bit bug27 fixed27.
// Parity27 bug27 fixed27.
// WISHBONE27 read cycle bug27 fixed27,
// OE27 indicator27 (Overrun27 Error) bug27 fixed27.
// PE27 indicator27 (Parity27 Error) bug27 fixed27.
// Register read bug27 fixed27.
//
// Revision27 1.6  2001/06/23 11:21:48  gorban27
// DL27 made27 16-bit long27. Fixed27 transmission27/reception27 bugs27.
//
// Revision27 1.5  2001/06/02 14:28:14  gorban27
// Fixed27 receiver27 and transmitter27. Major27 bug27 fixed27.
//
// Revision27 1.4  2001/05/31 20:08:01  gorban27
// FIFO changes27 and other corrections27.
//
// Revision27 1.3  2001/05/27 17:37:49  gorban27
// Fixed27 many27 bugs27. Updated27 spec27. Changed27 FIFO files structure27. See CHANGES27.txt27 file.
//
// Revision27 1.2  2001/05/21 19:12:02  gorban27
// Corrected27 some27 Linter27 messages27.
//
// Revision27 1.1  2001/05/17 18:34:18  gorban27
// First27 'stable' release. Should27 be sythesizable27 now. Also27 added new header.
//
// Revision27 1.0  2001-05-17 21:27:11+02  jacob27
// Initial27 revision27
//
//

// synopsys27 translate_off27
`include "timescale.v"
// synopsys27 translate_on27

`include "uart_defines27.v"

module uart_receiver27 (clk27, wb_rst_i27, lcr27, rf_pop27, srx_pad_i27, enable, 
	counter_t27, rf_count27, rf_data_out27, rf_error_bit27, rf_overrun27, rx_reset27, lsr_mask27, rstate, rf_push_pulse27);

input				clk27;
input				wb_rst_i27;
input	[7:0]	lcr27;
input				rf_pop27;
input				srx_pad_i27;
input				enable;
input				rx_reset27;
input       lsr_mask27;

output	[9:0]			counter_t27;
output	[`UART_FIFO_COUNTER_W27-1:0]	rf_count27;
output	[`UART_FIFO_REC_WIDTH27-1:0]	rf_data_out27;
output				rf_overrun27;
output				rf_error_bit27;
output [3:0] 		rstate;
output 				rf_push_pulse27;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1627;
reg	[2:0]	rbit_counter27;
reg	[7:0]	rshift27;			// receiver27 shift27 register
reg		rparity27;		// received27 parity27
reg		rparity_error27;
reg		rframing_error27;		// framing27 error flag27
reg		rbit_in27;
reg		rparity_xor27;
reg	[7:0]	counter_b27;	// counts27 the 0 (low27) signals27
reg   rf_push_q27;

// RX27 FIFO signals27
reg	[`UART_FIFO_REC_WIDTH27-1:0]	rf_data_in27;
wire	[`UART_FIFO_REC_WIDTH27-1:0]	rf_data_out27;
wire      rf_push_pulse27;
reg				rf_push27;
wire				rf_pop27;
wire				rf_overrun27;
wire	[`UART_FIFO_COUNTER_W27-1:0]	rf_count27;
wire				rf_error_bit27; // an error (parity27 or framing27) is inside the fifo
wire 				break_error27 = (counter_b27 == 0);

// RX27 FIFO instance
uart_rfifo27 #(`UART_FIFO_REC_WIDTH27) fifo_rx27(
	.clk27(		clk27		), 
	.wb_rst_i27(	wb_rst_i27	),
	.data_in27(	rf_data_in27	),
	.data_out27(	rf_data_out27	),
	.push27(		rf_push_pulse27		),
	.pop27(		rf_pop27		),
	.overrun27(	rf_overrun27	),
	.count(		rf_count27	),
	.error_bit27(	rf_error_bit27	),
	.fifo_reset27(	rx_reset27	),
	.reset_status27(lsr_mask27)
);

wire 		rcounter16_eq_727 = (rcounter1627 == 4'd7);
wire		rcounter16_eq_027 = (rcounter1627 == 4'd0);
wire		rcounter16_eq_127 = (rcounter1627 == 4'd1);

wire [3:0] rcounter16_minus_127 = rcounter1627 - 1'b1;

parameter  sr_idle27 					= 4'd0;
parameter  sr_rec_start27 			= 4'd1;
parameter  sr_rec_bit27 				= 4'd2;
parameter  sr_rec_parity27			= 4'd3;
parameter  sr_rec_stop27 				= 4'd4;
parameter  sr_check_parity27 		= 4'd5;
parameter  sr_rec_prepare27 			= 4'd6;
parameter  sr_end_bit27				= 4'd7;
parameter  sr_ca_lc_parity27	      = 4'd8;
parameter  sr_wait127 					= 4'd9;
parameter  sr_push27 					= 4'd10;


always @(posedge clk27 or posedge wb_rst_i27)
begin
  if (wb_rst_i27)
  begin
     rstate 			<= #1 sr_idle27;
	  rbit_in27 				<= #1 1'b0;
	  rcounter1627 			<= #1 0;
	  rbit_counter27 		<= #1 0;
	  rparity_xor27 		<= #1 1'b0;
	  rframing_error27 	<= #1 1'b0;
	  rparity_error27 		<= #1 1'b0;
	  rparity27 				<= #1 1'b0;
	  rshift27 				<= #1 0;
	  rf_push27 				<= #1 1'b0;
	  rf_data_in27 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle27 : begin
			rf_push27 			  <= #1 1'b0;
			rf_data_in27 	  <= #1 0;
			rcounter1627 	  <= #1 4'b1110;
			if (srx_pad_i27==1'b0 & ~break_error27)   // detected a pulse27 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start27;
			end
		end
	sr_rec_start27 :	begin
  			rf_push27 			  <= #1 1'b0;
				if (rcounter16_eq_727)    // check the pulse27
					if (srx_pad_i27==1'b1)   // no start bit
						rstate <= #1 sr_idle27;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare27;
				rcounter1627 <= #1 rcounter16_minus_127;
			end
	sr_rec_prepare27:begin
				case (lcr27[/*`UART_LC_BITS27*/1:0])  // number27 of bits in a word27
				2'b00 : rbit_counter27 <= #1 3'b100;
				2'b01 : rbit_counter27 <= #1 3'b101;
				2'b10 : rbit_counter27 <= #1 3'b110;
				2'b11 : rbit_counter27 <= #1 3'b111;
				endcase
				if (rcounter16_eq_027)
				begin
					rstate		<= #1 sr_rec_bit27;
					rcounter1627	<= #1 4'b1110;
					rshift27		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare27;
				rcounter1627 <= #1 rcounter16_minus_127;
			end
	sr_rec_bit27 :	begin
				if (rcounter16_eq_027)
					rstate <= #1 sr_end_bit27;
				if (rcounter16_eq_727) // read the bit
					case (lcr27[/*`UART_LC_BITS27*/1:0])  // number27 of bits in a word27
					2'b00 : rshift27[4:0]  <= #1 {srx_pad_i27, rshift27[4:1]};
					2'b01 : rshift27[5:0]  <= #1 {srx_pad_i27, rshift27[5:1]};
					2'b10 : rshift27[6:0]  <= #1 {srx_pad_i27, rshift27[6:1]};
					2'b11 : rshift27[7:0]  <= #1 {srx_pad_i27, rshift27[7:1]};
					endcase
				rcounter1627 <= #1 rcounter16_minus_127;
			end
	sr_end_bit27 :   begin
				if (rbit_counter27==3'b0) // no more bits in word27
					if (lcr27[`UART_LC_PE27]) // choose27 state based on parity27
						rstate <= #1 sr_rec_parity27;
					else
					begin
						rstate <= #1 sr_rec_stop27;
						rparity_error27 <= #1 1'b0;  // no parity27 - no error :)
					end
				else		// else we27 have more bits to read
				begin
					rstate <= #1 sr_rec_bit27;
					rbit_counter27 <= #1 rbit_counter27 - 1'b1;
				end
				rcounter1627 <= #1 4'b1110;
			end
	sr_rec_parity27: begin
				if (rcounter16_eq_727)	// read the parity27
				begin
					rparity27 <= #1 srx_pad_i27;
					rstate <= #1 sr_ca_lc_parity27;
				end
				rcounter1627 <= #1 rcounter16_minus_127;
			end
	sr_ca_lc_parity27 : begin    // rcounter27 equals27 6
				rcounter1627  <= #1 rcounter16_minus_127;
				rparity_xor27 <= #1 ^{rshift27,rparity27}; // calculate27 parity27 on all incoming27 data
				rstate      <= #1 sr_check_parity27;
			  end
	sr_check_parity27: begin	  // rcounter27 equals27 5
				case ({lcr27[`UART_LC_EP27],lcr27[`UART_LC_SP27]})
					2'b00: rparity_error27 <= #1  rparity_xor27 == 0;  // no error if parity27 1
					2'b01: rparity_error27 <= #1 ~rparity27;      // parity27 should sticked27 to 1
					2'b10: rparity_error27 <= #1  rparity_xor27 == 1;   // error if parity27 is odd27
					2'b11: rparity_error27 <= #1  rparity27;	  // parity27 should be sticked27 to 0
				endcase
				rcounter1627 <= #1 rcounter16_minus_127;
				rstate <= #1 sr_wait127;
			  end
	sr_wait127 :	if (rcounter16_eq_027)
			begin
				rstate <= #1 sr_rec_stop27;
				rcounter1627 <= #1 4'b1110;
			end
			else
				rcounter1627 <= #1 rcounter16_minus_127;
	sr_rec_stop27 :	begin
				if (rcounter16_eq_727)	// read the parity27
				begin
					rframing_error27 <= #1 !srx_pad_i27; // no framing27 error if input is 1 (stop bit)
					rstate <= #1 sr_push27;
				end
				rcounter1627 <= #1 rcounter16_minus_127;
			end
	sr_push27 :	begin
///////////////////////////////////////
//				$display($time, ": received27: %b", rf_data_in27);
        if(srx_pad_i27 | break_error27)
          begin
            if(break_error27)
        		  rf_data_in27 	<= #1 {8'b0, 3'b100}; // break input (empty27 character27) to receiver27 FIFO
            else
        			rf_data_in27  <= #1 {rshift27, 1'b0, rparity_error27, rframing_error27};
      		  rf_push27 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle27;
          end
        else if(~rframing_error27)  // There's always a framing27 before break_error27 -> wait for break or srx_pad_i27
          begin
       			rf_data_in27  <= #1 {rshift27, 1'b0, rparity_error27, rframing_error27};
      		  rf_push27 		  <= #1 1'b1;
      			rcounter1627 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start27;
          end
                      
			end
	default : rstate <= #1 sr_idle27;
	endcase
  end  // if (enable)
end // always of receiver27

always @ (posedge clk27 or posedge wb_rst_i27)
begin
  if(wb_rst_i27)
    rf_push_q27 <= 0;
  else
    rf_push_q27 <= #1 rf_push27;
end

assign rf_push_pulse27 = rf_push27 & ~rf_push_q27;

  
//
// Break27 condition detection27.
// Works27 in conjuction27 with the receiver27 state machine27

reg 	[9:0]	toc_value27; // value to be set to timeout counter

always @(lcr27)
	case (lcr27[3:0])
		4'b0000										: toc_value27 = 447; // 7 bits
		4'b0100										: toc_value27 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value27 = 511; // 8 bits
		4'b1100										: toc_value27 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value27 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value27 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value27 = 703; // 11 bits
		4'b1111										: toc_value27 = 767; // 12 bits
	endcase // case(lcr27[3:0])

wire [7:0] 	brc_value27; // value to be set to break counter
assign 		brc_value27 = toc_value27[9:2]; // the same as timeout but 1 insead27 of 4 character27 times

always @(posedge clk27 or posedge wb_rst_i27)
begin
	if (wb_rst_i27)
		counter_b27 <= #1 8'd159;
	else
	if (srx_pad_i27)
		counter_b27 <= #1 brc_value27; // character27 time length - 1
	else
	if(enable & counter_b27 != 8'b0)            // only work27 on enable times  break not reached27.
		counter_b27 <= #1 counter_b27 - 1;  // decrement break counter
end // always of break condition detection27

///
/// Timeout27 condition detection27
reg	[9:0]	counter_t27;	// counts27 the timeout condition clocks27

always @(posedge clk27 or posedge wb_rst_i27)
begin
	if (wb_rst_i27)
		counter_t27 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse27 || rf_pop27 || rf_count27 == 0) // counter is reset when RX27 FIFO is empty27, accessed or above27 trigger level
			counter_t27 <= #1 toc_value27;
		else
		if (enable && counter_t27 != 10'b0)  // we27 don27't want27 to underflow27
			counter_t27 <= #1 counter_t27 - 1;		
end
	
endmodule
