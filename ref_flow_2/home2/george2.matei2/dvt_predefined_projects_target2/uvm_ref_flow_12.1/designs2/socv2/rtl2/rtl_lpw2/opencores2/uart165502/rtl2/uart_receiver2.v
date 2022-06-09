//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver2.v                                             ////
////                                                              ////
////                                                              ////
////  This2 file is part of the "UART2 16550 compatible2" project2    ////
////  http2://www2.opencores2.org2/cores2/uart165502/                   ////
////                                                              ////
////  Documentation2 related2 to this project2:                      ////
////  - http2://www2.opencores2.org2/cores2/uart165502/                 ////
////                                                              ////
////  Projects2 compatibility2:                                     ////
////  - WISHBONE2                                                  ////
////  RS2322 Protocol2                                              ////
////  16550D uart2 (mostly2 supported)                              ////
////                                                              ////
////  Overview2 (main2 Features2):                                   ////
////  UART2 core2 receiver2 logic                                    ////
////                                                              ////
////  Known2 problems2 (limits2):                                    ////
////  None2 known2                                                  ////
////                                                              ////
////  To2 Do2:                                                      ////
////  Thourough2 testing2.                                          ////
////                                                              ////
////  Author2(s):                                                  ////
////      - gorban2@opencores2.org2                                  ////
////      - Jacob2 Gorban2                                          ////
////      - Igor2 Mohor2 (igorm2@opencores2.org2)                      ////
////                                                              ////
////  Created2:        2001/05/12                                  ////
////  Last2 Updated2:   2001/05/17                                  ////
////                  (See log2 for the revision2 history2)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2000, 2001 Authors2                             ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS2 Revision2 History2
//
// $Log: not supported by cvs2svn2 $
// Revision2 1.29  2002/07/29 21:16:18  gorban2
// The uart_defines2.v file is included2 again2 in sources2.
//
// Revision2 1.28  2002/07/22 23:02:23  gorban2
// Bug2 Fixes2:
//  * Possible2 loss of sync and bad2 reception2 of stop bit on slow2 baud2 rates2 fixed2.
//   Problem2 reported2 by Kenny2.Tung2.
//  * Bad (or lack2 of ) loopback2 handling2 fixed2. Reported2 by Cherry2 Withers2.
//
// Improvements2:
//  * Made2 FIFO's as general2 inferrable2 memory where possible2.
//  So2 on FPGA2 they should be inferred2 as RAM2 (Distributed2 RAM2 on Xilinx2).
//  This2 saves2 about2 1/3 of the Slice2 count and reduces2 P&R and synthesis2 times.
//
//  * Added2 optional2 baudrate2 output (baud_o2).
//  This2 is identical2 to BAUDOUT2* signal2 on 16550 chip2.
//  It outputs2 16xbit_clock_rate - the divided2 clock2.
//  It's disabled by default. Define2 UART_HAS_BAUDRATE_OUTPUT2 to use.
//
// Revision2 1.27  2001/12/30 20:39:13  mohor2
// More than one character2 was stored2 in case of break. End2 of the break
// was not detected correctly.
//
// Revision2 1.26  2001/12/20 13:28:27  mohor2
// Missing2 declaration2 of rf_push_q2 fixed2.
//
// Revision2 1.25  2001/12/20 13:25:46  mohor2
// rx2 push2 changed to be only one cycle wide2.
//
// Revision2 1.24  2001/12/19 08:03:34  mohor2
// Warnings2 cleared2.
//
// Revision2 1.23  2001/12/19 07:33:54  mohor2
// Synplicity2 was having2 troubles2 with the comment2.
//
// Revision2 1.22  2001/12/17 14:46:48  mohor2
// overrun2 signal2 was moved to separate2 block because many2 sequential2 lsr2
// reads were2 preventing2 data from being written2 to rx2 fifo.
// underrun2 signal2 was not used and was removed from the project2.
//
// Revision2 1.21  2001/12/13 10:31:16  mohor2
// timeout irq2 must be set regardless2 of the rda2 irq2 (rda2 irq2 does not reset the
// timeout counter).
//
// Revision2 1.20  2001/12/10 19:52:05  gorban2
// Igor2 fixed2 break condition bugs2
//
// Revision2 1.19  2001/12/06 14:51:04  gorban2
// Bug2 in LSR2[0] is fixed2.
// All WISHBONE2 signals2 are now sampled2, so another2 wait-state is introduced2 on all transfers2.
//
// Revision2 1.18  2001/12/03 21:44:29  gorban2
// Updated2 specification2 documentation.
// Added2 full 32-bit data bus interface, now as default.
// Address is 5-bit wide2 in 32-bit data bus mode.
// Added2 wb_sel_i2 input to the core2. It's used in the 32-bit mode.
// Added2 debug2 interface with two2 32-bit read-only registers in 32-bit mode.
// Bits2 5 and 6 of LSR2 are now only cleared2 on TX2 FIFO write.
// My2 small test bench2 is modified to work2 with 32-bit mode.
//
// Revision2 1.17  2001/11/28 19:36:39  gorban2
// Fixed2: timeout and break didn2't pay2 attention2 to current data format2 when counting2 time
//
// Revision2 1.16  2001/11/27 22:17:09  gorban2
// Fixed2 bug2 that prevented2 synthesis2 in uart_receiver2.v
//
// Revision2 1.15  2001/11/26 21:38:54  gorban2
// Lots2 of fixes2:
// Break2 condition wasn2't handled2 correctly at all.
// LSR2 bits could lose2 their2 values.
// LSR2 value after reset was wrong2.
// Timing2 of THRE2 interrupt2 signal2 corrected2.
// LSR2 bit 0 timing2 corrected2.
//
// Revision2 1.14  2001/11/10 12:43:21  gorban2
// Logic2 Synthesis2 bugs2 fixed2. Some2 other minor2 changes2
//
// Revision2 1.13  2001/11/08 14:54:23  mohor2
// Comments2 in Slovene2 language2 deleted2, few2 small fixes2 for better2 work2 of
// old2 tools2. IRQs2 need to be fix2.
//
// Revision2 1.12  2001/11/07 17:51:52  gorban2
// Heavily2 rewritten2 interrupt2 and LSR2 subsystems2.
// Many2 bugs2 hopefully2 squashed2.
//
// Revision2 1.11  2001/10/31 15:19:22  gorban2
// Fixes2 to break and timeout conditions2
//
// Revision2 1.10  2001/10/20 09:58:40  gorban2
// Small2 synopsis2 fixes2
//
// Revision2 1.9  2001/08/24 21:01:12  mohor2
// Things2 connected2 to parity2 changed.
// Clock2 devider2 changed.
//
// Revision2 1.8  2001/08/23 16:05:05  mohor2
// Stop bit bug2 fixed2.
// Parity2 bug2 fixed2.
// WISHBONE2 read cycle bug2 fixed2,
// OE2 indicator2 (Overrun2 Error) bug2 fixed2.
// PE2 indicator2 (Parity2 Error) bug2 fixed2.
// Register read bug2 fixed2.
//
// Revision2 1.6  2001/06/23 11:21:48  gorban2
// DL2 made2 16-bit long2. Fixed2 transmission2/reception2 bugs2.
//
// Revision2 1.5  2001/06/02 14:28:14  gorban2
// Fixed2 receiver2 and transmitter2. Major2 bug2 fixed2.
//
// Revision2 1.4  2001/05/31 20:08:01  gorban2
// FIFO changes2 and other corrections2.
//
// Revision2 1.3  2001/05/27 17:37:49  gorban2
// Fixed2 many2 bugs2. Updated2 spec2. Changed2 FIFO files structure2. See CHANGES2.txt2 file.
//
// Revision2 1.2  2001/05/21 19:12:02  gorban2
// Corrected2 some2 Linter2 messages2.
//
// Revision2 1.1  2001/05/17 18:34:18  gorban2
// First2 'stable' release. Should2 be sythesizable2 now. Also2 added new header.
//
// Revision2 1.0  2001-05-17 21:27:11+02  jacob2
// Initial2 revision2
//
//

// synopsys2 translate_off2
`include "timescale.v"
// synopsys2 translate_on2

`include "uart_defines2.v"

module uart_receiver2 (clk2, wb_rst_i2, lcr2, rf_pop2, srx_pad_i2, enable, 
	counter_t2, rf_count2, rf_data_out2, rf_error_bit2, rf_overrun2, rx_reset2, lsr_mask2, rstate, rf_push_pulse2);

input				clk2;
input				wb_rst_i2;
input	[7:0]	lcr2;
input				rf_pop2;
input				srx_pad_i2;
input				enable;
input				rx_reset2;
input       lsr_mask2;

output	[9:0]			counter_t2;
output	[`UART_FIFO_COUNTER_W2-1:0]	rf_count2;
output	[`UART_FIFO_REC_WIDTH2-1:0]	rf_data_out2;
output				rf_overrun2;
output				rf_error_bit2;
output [3:0] 		rstate;
output 				rf_push_pulse2;

reg	[3:0]	rstate;
reg	[3:0]	rcounter162;
reg	[2:0]	rbit_counter2;
reg	[7:0]	rshift2;			// receiver2 shift2 register
reg		rparity2;		// received2 parity2
reg		rparity_error2;
reg		rframing_error2;		// framing2 error flag2
reg		rbit_in2;
reg		rparity_xor2;
reg	[7:0]	counter_b2;	// counts2 the 0 (low2) signals2
reg   rf_push_q2;

// RX2 FIFO signals2
reg	[`UART_FIFO_REC_WIDTH2-1:0]	rf_data_in2;
wire	[`UART_FIFO_REC_WIDTH2-1:0]	rf_data_out2;
wire      rf_push_pulse2;
reg				rf_push2;
wire				rf_pop2;
wire				rf_overrun2;
wire	[`UART_FIFO_COUNTER_W2-1:0]	rf_count2;
wire				rf_error_bit2; // an error (parity2 or framing2) is inside the fifo
wire 				break_error2 = (counter_b2 == 0);

// RX2 FIFO instance
uart_rfifo2 #(`UART_FIFO_REC_WIDTH2) fifo_rx2(
	.clk2(		clk2		), 
	.wb_rst_i2(	wb_rst_i2	),
	.data_in2(	rf_data_in2	),
	.data_out2(	rf_data_out2	),
	.push2(		rf_push_pulse2		),
	.pop2(		rf_pop2		),
	.overrun2(	rf_overrun2	),
	.count(		rf_count2	),
	.error_bit2(	rf_error_bit2	),
	.fifo_reset2(	rx_reset2	),
	.reset_status2(lsr_mask2)
);

wire 		rcounter16_eq_72 = (rcounter162 == 4'd7);
wire		rcounter16_eq_02 = (rcounter162 == 4'd0);
wire		rcounter16_eq_12 = (rcounter162 == 4'd1);

wire [3:0] rcounter16_minus_12 = rcounter162 - 1'b1;

parameter  sr_idle2 					= 4'd0;
parameter  sr_rec_start2 			= 4'd1;
parameter  sr_rec_bit2 				= 4'd2;
parameter  sr_rec_parity2			= 4'd3;
parameter  sr_rec_stop2 				= 4'd4;
parameter  sr_check_parity2 		= 4'd5;
parameter  sr_rec_prepare2 			= 4'd6;
parameter  sr_end_bit2				= 4'd7;
parameter  sr_ca_lc_parity2	      = 4'd8;
parameter  sr_wait12 					= 4'd9;
parameter  sr_push2 					= 4'd10;


always @(posedge clk2 or posedge wb_rst_i2)
begin
  if (wb_rst_i2)
  begin
     rstate 			<= #1 sr_idle2;
	  rbit_in2 				<= #1 1'b0;
	  rcounter162 			<= #1 0;
	  rbit_counter2 		<= #1 0;
	  rparity_xor2 		<= #1 1'b0;
	  rframing_error2 	<= #1 1'b0;
	  rparity_error2 		<= #1 1'b0;
	  rparity2 				<= #1 1'b0;
	  rshift2 				<= #1 0;
	  rf_push2 				<= #1 1'b0;
	  rf_data_in2 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle2 : begin
			rf_push2 			  <= #1 1'b0;
			rf_data_in2 	  <= #1 0;
			rcounter162 	  <= #1 4'b1110;
			if (srx_pad_i2==1'b0 & ~break_error2)   // detected a pulse2 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start2;
			end
		end
	sr_rec_start2 :	begin
  			rf_push2 			  <= #1 1'b0;
				if (rcounter16_eq_72)    // check the pulse2
					if (srx_pad_i2==1'b1)   // no start bit
						rstate <= #1 sr_idle2;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare2;
				rcounter162 <= #1 rcounter16_minus_12;
			end
	sr_rec_prepare2:begin
				case (lcr2[/*`UART_LC_BITS2*/1:0])  // number2 of bits in a word2
				2'b00 : rbit_counter2 <= #1 3'b100;
				2'b01 : rbit_counter2 <= #1 3'b101;
				2'b10 : rbit_counter2 <= #1 3'b110;
				2'b11 : rbit_counter2 <= #1 3'b111;
				endcase
				if (rcounter16_eq_02)
				begin
					rstate		<= #1 sr_rec_bit2;
					rcounter162	<= #1 4'b1110;
					rshift2		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare2;
				rcounter162 <= #1 rcounter16_minus_12;
			end
	sr_rec_bit2 :	begin
				if (rcounter16_eq_02)
					rstate <= #1 sr_end_bit2;
				if (rcounter16_eq_72) // read the bit
					case (lcr2[/*`UART_LC_BITS2*/1:0])  // number2 of bits in a word2
					2'b00 : rshift2[4:0]  <= #1 {srx_pad_i2, rshift2[4:1]};
					2'b01 : rshift2[5:0]  <= #1 {srx_pad_i2, rshift2[5:1]};
					2'b10 : rshift2[6:0]  <= #1 {srx_pad_i2, rshift2[6:1]};
					2'b11 : rshift2[7:0]  <= #1 {srx_pad_i2, rshift2[7:1]};
					endcase
				rcounter162 <= #1 rcounter16_minus_12;
			end
	sr_end_bit2 :   begin
				if (rbit_counter2==3'b0) // no more bits in word2
					if (lcr2[`UART_LC_PE2]) // choose2 state based on parity2
						rstate <= #1 sr_rec_parity2;
					else
					begin
						rstate <= #1 sr_rec_stop2;
						rparity_error2 <= #1 1'b0;  // no parity2 - no error :)
					end
				else		// else we2 have more bits to read
				begin
					rstate <= #1 sr_rec_bit2;
					rbit_counter2 <= #1 rbit_counter2 - 1'b1;
				end
				rcounter162 <= #1 4'b1110;
			end
	sr_rec_parity2: begin
				if (rcounter16_eq_72)	// read the parity2
				begin
					rparity2 <= #1 srx_pad_i2;
					rstate <= #1 sr_ca_lc_parity2;
				end
				rcounter162 <= #1 rcounter16_minus_12;
			end
	sr_ca_lc_parity2 : begin    // rcounter2 equals2 6
				rcounter162  <= #1 rcounter16_minus_12;
				rparity_xor2 <= #1 ^{rshift2,rparity2}; // calculate2 parity2 on all incoming2 data
				rstate      <= #1 sr_check_parity2;
			  end
	sr_check_parity2: begin	  // rcounter2 equals2 5
				case ({lcr2[`UART_LC_EP2],lcr2[`UART_LC_SP2]})
					2'b00: rparity_error2 <= #1  rparity_xor2 == 0;  // no error if parity2 1
					2'b01: rparity_error2 <= #1 ~rparity2;      // parity2 should sticked2 to 1
					2'b10: rparity_error2 <= #1  rparity_xor2 == 1;   // error if parity2 is odd2
					2'b11: rparity_error2 <= #1  rparity2;	  // parity2 should be sticked2 to 0
				endcase
				rcounter162 <= #1 rcounter16_minus_12;
				rstate <= #1 sr_wait12;
			  end
	sr_wait12 :	if (rcounter16_eq_02)
			begin
				rstate <= #1 sr_rec_stop2;
				rcounter162 <= #1 4'b1110;
			end
			else
				rcounter162 <= #1 rcounter16_minus_12;
	sr_rec_stop2 :	begin
				if (rcounter16_eq_72)	// read the parity2
				begin
					rframing_error2 <= #1 !srx_pad_i2; // no framing2 error if input is 1 (stop bit)
					rstate <= #1 sr_push2;
				end
				rcounter162 <= #1 rcounter16_minus_12;
			end
	sr_push2 :	begin
///////////////////////////////////////
//				$display($time, ": received2: %b", rf_data_in2);
        if(srx_pad_i2 | break_error2)
          begin
            if(break_error2)
        		  rf_data_in2 	<= #1 {8'b0, 3'b100}; // break input (empty2 character2) to receiver2 FIFO
            else
        			rf_data_in2  <= #1 {rshift2, 1'b0, rparity_error2, rframing_error2};
      		  rf_push2 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle2;
          end
        else if(~rframing_error2)  // There's always a framing2 before break_error2 -> wait for break or srx_pad_i2
          begin
       			rf_data_in2  <= #1 {rshift2, 1'b0, rparity_error2, rframing_error2};
      		  rf_push2 		  <= #1 1'b1;
      			rcounter162 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start2;
          end
                      
			end
	default : rstate <= #1 sr_idle2;
	endcase
  end  // if (enable)
end // always of receiver2

always @ (posedge clk2 or posedge wb_rst_i2)
begin
  if(wb_rst_i2)
    rf_push_q2 <= 0;
  else
    rf_push_q2 <= #1 rf_push2;
end

assign rf_push_pulse2 = rf_push2 & ~rf_push_q2;

  
//
// Break2 condition detection2.
// Works2 in conjuction2 with the receiver2 state machine2

reg 	[9:0]	toc_value2; // value to be set to timeout counter

always @(lcr2)
	case (lcr2[3:0])
		4'b0000										: toc_value2 = 447; // 7 bits
		4'b0100										: toc_value2 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value2 = 511; // 8 bits
		4'b1100										: toc_value2 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value2 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value2 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value2 = 703; // 11 bits
		4'b1111										: toc_value2 = 767; // 12 bits
	endcase // case(lcr2[3:0])

wire [7:0] 	brc_value2; // value to be set to break counter
assign 		brc_value2 = toc_value2[9:2]; // the same as timeout but 1 insead2 of 4 character2 times

always @(posedge clk2 or posedge wb_rst_i2)
begin
	if (wb_rst_i2)
		counter_b2 <= #1 8'd159;
	else
	if (srx_pad_i2)
		counter_b2 <= #1 brc_value2; // character2 time length - 1
	else
	if(enable & counter_b2 != 8'b0)            // only work2 on enable times  break not reached2.
		counter_b2 <= #1 counter_b2 - 1;  // decrement break counter
end // always of break condition detection2

///
/// Timeout2 condition detection2
reg	[9:0]	counter_t2;	// counts2 the timeout condition clocks2

always @(posedge clk2 or posedge wb_rst_i2)
begin
	if (wb_rst_i2)
		counter_t2 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse2 || rf_pop2 || rf_count2 == 0) // counter is reset when RX2 FIFO is empty2, accessed or above2 trigger level
			counter_t2 <= #1 toc_value2;
		else
		if (enable && counter_t2 != 10'b0)  // we2 don2't want2 to underflow2
			counter_t2 <= #1 counter_t2 - 1;		
end
	
endmodule
