//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver4.v                                             ////
////                                                              ////
////                                                              ////
////  This4 file is part of the "UART4 16550 compatible4" project4    ////
////  http4://www4.opencores4.org4/cores4/uart165504/                   ////
////                                                              ////
////  Documentation4 related4 to this project4:                      ////
////  - http4://www4.opencores4.org4/cores4/uart165504/                 ////
////                                                              ////
////  Projects4 compatibility4:                                     ////
////  - WISHBONE4                                                  ////
////  RS2324 Protocol4                                              ////
////  16550D uart4 (mostly4 supported)                              ////
////                                                              ////
////  Overview4 (main4 Features4):                                   ////
////  UART4 core4 receiver4 logic                                    ////
////                                                              ////
////  Known4 problems4 (limits4):                                    ////
////  None4 known4                                                  ////
////                                                              ////
////  To4 Do4:                                                      ////
////  Thourough4 testing4.                                          ////
////                                                              ////
////  Author4(s):                                                  ////
////      - gorban4@opencores4.org4                                  ////
////      - Jacob4 Gorban4                                          ////
////      - Igor4 Mohor4 (igorm4@opencores4.org4)                      ////
////                                                              ////
////  Created4:        2001/05/12                                  ////
////  Last4 Updated4:   2001/05/17                                  ////
////                  (See log4 for the revision4 history4)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2000, 2001 Authors4                             ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS4 Revision4 History4
//
// $Log: not supported by cvs2svn4 $
// Revision4 1.29  2002/07/29 21:16:18  gorban4
// The uart_defines4.v file is included4 again4 in sources4.
//
// Revision4 1.28  2002/07/22 23:02:23  gorban4
// Bug4 Fixes4:
//  * Possible4 loss of sync and bad4 reception4 of stop bit on slow4 baud4 rates4 fixed4.
//   Problem4 reported4 by Kenny4.Tung4.
//  * Bad (or lack4 of ) loopback4 handling4 fixed4. Reported4 by Cherry4 Withers4.
//
// Improvements4:
//  * Made4 FIFO's as general4 inferrable4 memory where possible4.
//  So4 on FPGA4 they should be inferred4 as RAM4 (Distributed4 RAM4 on Xilinx4).
//  This4 saves4 about4 1/3 of the Slice4 count and reduces4 P&R and synthesis4 times.
//
//  * Added4 optional4 baudrate4 output (baud_o4).
//  This4 is identical4 to BAUDOUT4* signal4 on 16550 chip4.
//  It outputs4 16xbit_clock_rate - the divided4 clock4.
//  It's disabled by default. Define4 UART_HAS_BAUDRATE_OUTPUT4 to use.
//
// Revision4 1.27  2001/12/30 20:39:13  mohor4
// More than one character4 was stored4 in case of break. End4 of the break
// was not detected correctly.
//
// Revision4 1.26  2001/12/20 13:28:27  mohor4
// Missing4 declaration4 of rf_push_q4 fixed4.
//
// Revision4 1.25  2001/12/20 13:25:46  mohor4
// rx4 push4 changed to be only one cycle wide4.
//
// Revision4 1.24  2001/12/19 08:03:34  mohor4
// Warnings4 cleared4.
//
// Revision4 1.23  2001/12/19 07:33:54  mohor4
// Synplicity4 was having4 troubles4 with the comment4.
//
// Revision4 1.22  2001/12/17 14:46:48  mohor4
// overrun4 signal4 was moved to separate4 block because many4 sequential4 lsr4
// reads were4 preventing4 data from being written4 to rx4 fifo.
// underrun4 signal4 was not used and was removed from the project4.
//
// Revision4 1.21  2001/12/13 10:31:16  mohor4
// timeout irq4 must be set regardless4 of the rda4 irq4 (rda4 irq4 does not reset the
// timeout counter).
//
// Revision4 1.20  2001/12/10 19:52:05  gorban4
// Igor4 fixed4 break condition bugs4
//
// Revision4 1.19  2001/12/06 14:51:04  gorban4
// Bug4 in LSR4[0] is fixed4.
// All WISHBONE4 signals4 are now sampled4, so another4 wait-state is introduced4 on all transfers4.
//
// Revision4 1.18  2001/12/03 21:44:29  gorban4
// Updated4 specification4 documentation.
// Added4 full 32-bit data bus interface, now as default.
// Address is 5-bit wide4 in 32-bit data bus mode.
// Added4 wb_sel_i4 input to the core4. It's used in the 32-bit mode.
// Added4 debug4 interface with two4 32-bit read-only registers in 32-bit mode.
// Bits4 5 and 6 of LSR4 are now only cleared4 on TX4 FIFO write.
// My4 small test bench4 is modified to work4 with 32-bit mode.
//
// Revision4 1.17  2001/11/28 19:36:39  gorban4
// Fixed4: timeout and break didn4't pay4 attention4 to current data format4 when counting4 time
//
// Revision4 1.16  2001/11/27 22:17:09  gorban4
// Fixed4 bug4 that prevented4 synthesis4 in uart_receiver4.v
//
// Revision4 1.15  2001/11/26 21:38:54  gorban4
// Lots4 of fixes4:
// Break4 condition wasn4't handled4 correctly at all.
// LSR4 bits could lose4 their4 values.
// LSR4 value after reset was wrong4.
// Timing4 of THRE4 interrupt4 signal4 corrected4.
// LSR4 bit 0 timing4 corrected4.
//
// Revision4 1.14  2001/11/10 12:43:21  gorban4
// Logic4 Synthesis4 bugs4 fixed4. Some4 other minor4 changes4
//
// Revision4 1.13  2001/11/08 14:54:23  mohor4
// Comments4 in Slovene4 language4 deleted4, few4 small fixes4 for better4 work4 of
// old4 tools4. IRQs4 need to be fix4.
//
// Revision4 1.12  2001/11/07 17:51:52  gorban4
// Heavily4 rewritten4 interrupt4 and LSR4 subsystems4.
// Many4 bugs4 hopefully4 squashed4.
//
// Revision4 1.11  2001/10/31 15:19:22  gorban4
// Fixes4 to break and timeout conditions4
//
// Revision4 1.10  2001/10/20 09:58:40  gorban4
// Small4 synopsis4 fixes4
//
// Revision4 1.9  2001/08/24 21:01:12  mohor4
// Things4 connected4 to parity4 changed.
// Clock4 devider4 changed.
//
// Revision4 1.8  2001/08/23 16:05:05  mohor4
// Stop bit bug4 fixed4.
// Parity4 bug4 fixed4.
// WISHBONE4 read cycle bug4 fixed4,
// OE4 indicator4 (Overrun4 Error) bug4 fixed4.
// PE4 indicator4 (Parity4 Error) bug4 fixed4.
// Register read bug4 fixed4.
//
// Revision4 1.6  2001/06/23 11:21:48  gorban4
// DL4 made4 16-bit long4. Fixed4 transmission4/reception4 bugs4.
//
// Revision4 1.5  2001/06/02 14:28:14  gorban4
// Fixed4 receiver4 and transmitter4. Major4 bug4 fixed4.
//
// Revision4 1.4  2001/05/31 20:08:01  gorban4
// FIFO changes4 and other corrections4.
//
// Revision4 1.3  2001/05/27 17:37:49  gorban4
// Fixed4 many4 bugs4. Updated4 spec4. Changed4 FIFO files structure4. See CHANGES4.txt4 file.
//
// Revision4 1.2  2001/05/21 19:12:02  gorban4
// Corrected4 some4 Linter4 messages4.
//
// Revision4 1.1  2001/05/17 18:34:18  gorban4
// First4 'stable' release. Should4 be sythesizable4 now. Also4 added new header.
//
// Revision4 1.0  2001-05-17 21:27:11+02  jacob4
// Initial4 revision4
//
//

// synopsys4 translate_off4
`include "timescale.v"
// synopsys4 translate_on4

`include "uart_defines4.v"

module uart_receiver4 (clk4, wb_rst_i4, lcr4, rf_pop4, srx_pad_i4, enable, 
	counter_t4, rf_count4, rf_data_out4, rf_error_bit4, rf_overrun4, rx_reset4, lsr_mask4, rstate, rf_push_pulse4);

input				clk4;
input				wb_rst_i4;
input	[7:0]	lcr4;
input				rf_pop4;
input				srx_pad_i4;
input				enable;
input				rx_reset4;
input       lsr_mask4;

output	[9:0]			counter_t4;
output	[`UART_FIFO_COUNTER_W4-1:0]	rf_count4;
output	[`UART_FIFO_REC_WIDTH4-1:0]	rf_data_out4;
output				rf_overrun4;
output				rf_error_bit4;
output [3:0] 		rstate;
output 				rf_push_pulse4;

reg	[3:0]	rstate;
reg	[3:0]	rcounter164;
reg	[2:0]	rbit_counter4;
reg	[7:0]	rshift4;			// receiver4 shift4 register
reg		rparity4;		// received4 parity4
reg		rparity_error4;
reg		rframing_error4;		// framing4 error flag4
reg		rbit_in4;
reg		rparity_xor4;
reg	[7:0]	counter_b4;	// counts4 the 0 (low4) signals4
reg   rf_push_q4;

// RX4 FIFO signals4
reg	[`UART_FIFO_REC_WIDTH4-1:0]	rf_data_in4;
wire	[`UART_FIFO_REC_WIDTH4-1:0]	rf_data_out4;
wire      rf_push_pulse4;
reg				rf_push4;
wire				rf_pop4;
wire				rf_overrun4;
wire	[`UART_FIFO_COUNTER_W4-1:0]	rf_count4;
wire				rf_error_bit4; // an error (parity4 or framing4) is inside the fifo
wire 				break_error4 = (counter_b4 == 0);

// RX4 FIFO instance
uart_rfifo4 #(`UART_FIFO_REC_WIDTH4) fifo_rx4(
	.clk4(		clk4		), 
	.wb_rst_i4(	wb_rst_i4	),
	.data_in4(	rf_data_in4	),
	.data_out4(	rf_data_out4	),
	.push4(		rf_push_pulse4		),
	.pop4(		rf_pop4		),
	.overrun4(	rf_overrun4	),
	.count(		rf_count4	),
	.error_bit4(	rf_error_bit4	),
	.fifo_reset4(	rx_reset4	),
	.reset_status4(lsr_mask4)
);

wire 		rcounter16_eq_74 = (rcounter164 == 4'd7);
wire		rcounter16_eq_04 = (rcounter164 == 4'd0);
wire		rcounter16_eq_14 = (rcounter164 == 4'd1);

wire [3:0] rcounter16_minus_14 = rcounter164 - 1'b1;

parameter  sr_idle4 					= 4'd0;
parameter  sr_rec_start4 			= 4'd1;
parameter  sr_rec_bit4 				= 4'd2;
parameter  sr_rec_parity4			= 4'd3;
parameter  sr_rec_stop4 				= 4'd4;
parameter  sr_check_parity4 		= 4'd5;
parameter  sr_rec_prepare4 			= 4'd6;
parameter  sr_end_bit4				= 4'd7;
parameter  sr_ca_lc_parity4	      = 4'd8;
parameter  sr_wait14 					= 4'd9;
parameter  sr_push4 					= 4'd10;


always @(posedge clk4 or posedge wb_rst_i4)
begin
  if (wb_rst_i4)
  begin
     rstate 			<= #1 sr_idle4;
	  rbit_in4 				<= #1 1'b0;
	  rcounter164 			<= #1 0;
	  rbit_counter4 		<= #1 0;
	  rparity_xor4 		<= #1 1'b0;
	  rframing_error4 	<= #1 1'b0;
	  rparity_error4 		<= #1 1'b0;
	  rparity4 				<= #1 1'b0;
	  rshift4 				<= #1 0;
	  rf_push4 				<= #1 1'b0;
	  rf_data_in4 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle4 : begin
			rf_push4 			  <= #1 1'b0;
			rf_data_in4 	  <= #1 0;
			rcounter164 	  <= #1 4'b1110;
			if (srx_pad_i4==1'b0 & ~break_error4)   // detected a pulse4 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start4;
			end
		end
	sr_rec_start4 :	begin
  			rf_push4 			  <= #1 1'b0;
				if (rcounter16_eq_74)    // check the pulse4
					if (srx_pad_i4==1'b1)   // no start bit
						rstate <= #1 sr_idle4;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare4;
				rcounter164 <= #1 rcounter16_minus_14;
			end
	sr_rec_prepare4:begin
				case (lcr4[/*`UART_LC_BITS4*/1:0])  // number4 of bits in a word4
				2'b00 : rbit_counter4 <= #1 3'b100;
				2'b01 : rbit_counter4 <= #1 3'b101;
				2'b10 : rbit_counter4 <= #1 3'b110;
				2'b11 : rbit_counter4 <= #1 3'b111;
				endcase
				if (rcounter16_eq_04)
				begin
					rstate		<= #1 sr_rec_bit4;
					rcounter164	<= #1 4'b1110;
					rshift4		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare4;
				rcounter164 <= #1 rcounter16_minus_14;
			end
	sr_rec_bit4 :	begin
				if (rcounter16_eq_04)
					rstate <= #1 sr_end_bit4;
				if (rcounter16_eq_74) // read the bit
					case (lcr4[/*`UART_LC_BITS4*/1:0])  // number4 of bits in a word4
					2'b00 : rshift4[4:0]  <= #1 {srx_pad_i4, rshift4[4:1]};
					2'b01 : rshift4[5:0]  <= #1 {srx_pad_i4, rshift4[5:1]};
					2'b10 : rshift4[6:0]  <= #1 {srx_pad_i4, rshift4[6:1]};
					2'b11 : rshift4[7:0]  <= #1 {srx_pad_i4, rshift4[7:1]};
					endcase
				rcounter164 <= #1 rcounter16_minus_14;
			end
	sr_end_bit4 :   begin
				if (rbit_counter4==3'b0) // no more bits in word4
					if (lcr4[`UART_LC_PE4]) // choose4 state based on parity4
						rstate <= #1 sr_rec_parity4;
					else
					begin
						rstate <= #1 sr_rec_stop4;
						rparity_error4 <= #1 1'b0;  // no parity4 - no error :)
					end
				else		// else we4 have more bits to read
				begin
					rstate <= #1 sr_rec_bit4;
					rbit_counter4 <= #1 rbit_counter4 - 1'b1;
				end
				rcounter164 <= #1 4'b1110;
			end
	sr_rec_parity4: begin
				if (rcounter16_eq_74)	// read the parity4
				begin
					rparity4 <= #1 srx_pad_i4;
					rstate <= #1 sr_ca_lc_parity4;
				end
				rcounter164 <= #1 rcounter16_minus_14;
			end
	sr_ca_lc_parity4 : begin    // rcounter4 equals4 6
				rcounter164  <= #1 rcounter16_minus_14;
				rparity_xor4 <= #1 ^{rshift4,rparity4}; // calculate4 parity4 on all incoming4 data
				rstate      <= #1 sr_check_parity4;
			  end
	sr_check_parity4: begin	  // rcounter4 equals4 5
				case ({lcr4[`UART_LC_EP4],lcr4[`UART_LC_SP4]})
					2'b00: rparity_error4 <= #1  rparity_xor4 == 0;  // no error if parity4 1
					2'b01: rparity_error4 <= #1 ~rparity4;      // parity4 should sticked4 to 1
					2'b10: rparity_error4 <= #1  rparity_xor4 == 1;   // error if parity4 is odd4
					2'b11: rparity_error4 <= #1  rparity4;	  // parity4 should be sticked4 to 0
				endcase
				rcounter164 <= #1 rcounter16_minus_14;
				rstate <= #1 sr_wait14;
			  end
	sr_wait14 :	if (rcounter16_eq_04)
			begin
				rstate <= #1 sr_rec_stop4;
				rcounter164 <= #1 4'b1110;
			end
			else
				rcounter164 <= #1 rcounter16_minus_14;
	sr_rec_stop4 :	begin
				if (rcounter16_eq_74)	// read the parity4
				begin
					rframing_error4 <= #1 !srx_pad_i4; // no framing4 error if input is 1 (stop bit)
					rstate <= #1 sr_push4;
				end
				rcounter164 <= #1 rcounter16_minus_14;
			end
	sr_push4 :	begin
///////////////////////////////////////
//				$display($time, ": received4: %b", rf_data_in4);
        if(srx_pad_i4 | break_error4)
          begin
            if(break_error4)
        		  rf_data_in4 	<= #1 {8'b0, 3'b100}; // break input (empty4 character4) to receiver4 FIFO
            else
        			rf_data_in4  <= #1 {rshift4, 1'b0, rparity_error4, rframing_error4};
      		  rf_push4 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle4;
          end
        else if(~rframing_error4)  // There's always a framing4 before break_error4 -> wait for break or srx_pad_i4
          begin
       			rf_data_in4  <= #1 {rshift4, 1'b0, rparity_error4, rframing_error4};
      		  rf_push4 		  <= #1 1'b1;
      			rcounter164 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start4;
          end
                      
			end
	default : rstate <= #1 sr_idle4;
	endcase
  end  // if (enable)
end // always of receiver4

always @ (posedge clk4 or posedge wb_rst_i4)
begin
  if(wb_rst_i4)
    rf_push_q4 <= 0;
  else
    rf_push_q4 <= #1 rf_push4;
end

assign rf_push_pulse4 = rf_push4 & ~rf_push_q4;

  
//
// Break4 condition detection4.
// Works4 in conjuction4 with the receiver4 state machine4

reg 	[9:0]	toc_value4; // value to be set to timeout counter

always @(lcr4)
	case (lcr4[3:0])
		4'b0000										: toc_value4 = 447; // 7 bits
		4'b0100										: toc_value4 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value4 = 511; // 8 bits
		4'b1100										: toc_value4 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value4 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value4 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value4 = 703; // 11 bits
		4'b1111										: toc_value4 = 767; // 12 bits
	endcase // case(lcr4[3:0])

wire [7:0] 	brc_value4; // value to be set to break counter
assign 		brc_value4 = toc_value4[9:2]; // the same as timeout but 1 insead4 of 4 character4 times

always @(posedge clk4 or posedge wb_rst_i4)
begin
	if (wb_rst_i4)
		counter_b4 <= #1 8'd159;
	else
	if (srx_pad_i4)
		counter_b4 <= #1 brc_value4; // character4 time length - 1
	else
	if(enable & counter_b4 != 8'b0)            // only work4 on enable times  break not reached4.
		counter_b4 <= #1 counter_b4 - 1;  // decrement break counter
end // always of break condition detection4

///
/// Timeout4 condition detection4
reg	[9:0]	counter_t4;	// counts4 the timeout condition clocks4

always @(posedge clk4 or posedge wb_rst_i4)
begin
	if (wb_rst_i4)
		counter_t4 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse4 || rf_pop4 || rf_count4 == 0) // counter is reset when RX4 FIFO is empty4, accessed or above4 trigger level
			counter_t4 <= #1 toc_value4;
		else
		if (enable && counter_t4 != 10'b0)  // we4 don4't want4 to underflow4
			counter_t4 <= #1 counter_t4 - 1;		
end
	
endmodule
