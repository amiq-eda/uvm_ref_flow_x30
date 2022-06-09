//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver21.v                                             ////
////                                                              ////
////                                                              ////
////  This21 file is part of the "UART21 16550 compatible21" project21    ////
////  http21://www21.opencores21.org21/cores21/uart1655021/                   ////
////                                                              ////
////  Documentation21 related21 to this project21:                      ////
////  - http21://www21.opencores21.org21/cores21/uart1655021/                 ////
////                                                              ////
////  Projects21 compatibility21:                                     ////
////  - WISHBONE21                                                  ////
////  RS23221 Protocol21                                              ////
////  16550D uart21 (mostly21 supported)                              ////
////                                                              ////
////  Overview21 (main21 Features21):                                   ////
////  UART21 core21 receiver21 logic                                    ////
////                                                              ////
////  Known21 problems21 (limits21):                                    ////
////  None21 known21                                                  ////
////                                                              ////
////  To21 Do21:                                                      ////
////  Thourough21 testing21.                                          ////
////                                                              ////
////  Author21(s):                                                  ////
////      - gorban21@opencores21.org21                                  ////
////      - Jacob21 Gorban21                                          ////
////      - Igor21 Mohor21 (igorm21@opencores21.org21)                      ////
////                                                              ////
////  Created21:        2001/05/12                                  ////
////  Last21 Updated21:   2001/05/17                                  ////
////                  (See log21 for the revision21 history21)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2000, 2001 Authors21                             ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS21 Revision21 History21
//
// $Log: not supported by cvs2svn21 $
// Revision21 1.29  2002/07/29 21:16:18  gorban21
// The uart_defines21.v file is included21 again21 in sources21.
//
// Revision21 1.28  2002/07/22 23:02:23  gorban21
// Bug21 Fixes21:
//  * Possible21 loss of sync and bad21 reception21 of stop bit on slow21 baud21 rates21 fixed21.
//   Problem21 reported21 by Kenny21.Tung21.
//  * Bad (or lack21 of ) loopback21 handling21 fixed21. Reported21 by Cherry21 Withers21.
//
// Improvements21:
//  * Made21 FIFO's as general21 inferrable21 memory where possible21.
//  So21 on FPGA21 they should be inferred21 as RAM21 (Distributed21 RAM21 on Xilinx21).
//  This21 saves21 about21 1/3 of the Slice21 count and reduces21 P&R and synthesis21 times.
//
//  * Added21 optional21 baudrate21 output (baud_o21).
//  This21 is identical21 to BAUDOUT21* signal21 on 16550 chip21.
//  It outputs21 16xbit_clock_rate - the divided21 clock21.
//  It's disabled by default. Define21 UART_HAS_BAUDRATE_OUTPUT21 to use.
//
// Revision21 1.27  2001/12/30 20:39:13  mohor21
// More than one character21 was stored21 in case of break. End21 of the break
// was not detected correctly.
//
// Revision21 1.26  2001/12/20 13:28:27  mohor21
// Missing21 declaration21 of rf_push_q21 fixed21.
//
// Revision21 1.25  2001/12/20 13:25:46  mohor21
// rx21 push21 changed to be only one cycle wide21.
//
// Revision21 1.24  2001/12/19 08:03:34  mohor21
// Warnings21 cleared21.
//
// Revision21 1.23  2001/12/19 07:33:54  mohor21
// Synplicity21 was having21 troubles21 with the comment21.
//
// Revision21 1.22  2001/12/17 14:46:48  mohor21
// overrun21 signal21 was moved to separate21 block because many21 sequential21 lsr21
// reads were21 preventing21 data from being written21 to rx21 fifo.
// underrun21 signal21 was not used and was removed from the project21.
//
// Revision21 1.21  2001/12/13 10:31:16  mohor21
// timeout irq21 must be set regardless21 of the rda21 irq21 (rda21 irq21 does not reset the
// timeout counter).
//
// Revision21 1.20  2001/12/10 19:52:05  gorban21
// Igor21 fixed21 break condition bugs21
//
// Revision21 1.19  2001/12/06 14:51:04  gorban21
// Bug21 in LSR21[0] is fixed21.
// All WISHBONE21 signals21 are now sampled21, so another21 wait-state is introduced21 on all transfers21.
//
// Revision21 1.18  2001/12/03 21:44:29  gorban21
// Updated21 specification21 documentation.
// Added21 full 32-bit data bus interface, now as default.
// Address is 5-bit wide21 in 32-bit data bus mode.
// Added21 wb_sel_i21 input to the core21. It's used in the 32-bit mode.
// Added21 debug21 interface with two21 32-bit read-only registers in 32-bit mode.
// Bits21 5 and 6 of LSR21 are now only cleared21 on TX21 FIFO write.
// My21 small test bench21 is modified to work21 with 32-bit mode.
//
// Revision21 1.17  2001/11/28 19:36:39  gorban21
// Fixed21: timeout and break didn21't pay21 attention21 to current data format21 when counting21 time
//
// Revision21 1.16  2001/11/27 22:17:09  gorban21
// Fixed21 bug21 that prevented21 synthesis21 in uart_receiver21.v
//
// Revision21 1.15  2001/11/26 21:38:54  gorban21
// Lots21 of fixes21:
// Break21 condition wasn21't handled21 correctly at all.
// LSR21 bits could lose21 their21 values.
// LSR21 value after reset was wrong21.
// Timing21 of THRE21 interrupt21 signal21 corrected21.
// LSR21 bit 0 timing21 corrected21.
//
// Revision21 1.14  2001/11/10 12:43:21  gorban21
// Logic21 Synthesis21 bugs21 fixed21. Some21 other minor21 changes21
//
// Revision21 1.13  2001/11/08 14:54:23  mohor21
// Comments21 in Slovene21 language21 deleted21, few21 small fixes21 for better21 work21 of
// old21 tools21. IRQs21 need to be fix21.
//
// Revision21 1.12  2001/11/07 17:51:52  gorban21
// Heavily21 rewritten21 interrupt21 and LSR21 subsystems21.
// Many21 bugs21 hopefully21 squashed21.
//
// Revision21 1.11  2001/10/31 15:19:22  gorban21
// Fixes21 to break and timeout conditions21
//
// Revision21 1.10  2001/10/20 09:58:40  gorban21
// Small21 synopsis21 fixes21
//
// Revision21 1.9  2001/08/24 21:01:12  mohor21
// Things21 connected21 to parity21 changed.
// Clock21 devider21 changed.
//
// Revision21 1.8  2001/08/23 16:05:05  mohor21
// Stop bit bug21 fixed21.
// Parity21 bug21 fixed21.
// WISHBONE21 read cycle bug21 fixed21,
// OE21 indicator21 (Overrun21 Error) bug21 fixed21.
// PE21 indicator21 (Parity21 Error) bug21 fixed21.
// Register read bug21 fixed21.
//
// Revision21 1.6  2001/06/23 11:21:48  gorban21
// DL21 made21 16-bit long21. Fixed21 transmission21/reception21 bugs21.
//
// Revision21 1.5  2001/06/02 14:28:14  gorban21
// Fixed21 receiver21 and transmitter21. Major21 bug21 fixed21.
//
// Revision21 1.4  2001/05/31 20:08:01  gorban21
// FIFO changes21 and other corrections21.
//
// Revision21 1.3  2001/05/27 17:37:49  gorban21
// Fixed21 many21 bugs21. Updated21 spec21. Changed21 FIFO files structure21. See CHANGES21.txt21 file.
//
// Revision21 1.2  2001/05/21 19:12:02  gorban21
// Corrected21 some21 Linter21 messages21.
//
// Revision21 1.1  2001/05/17 18:34:18  gorban21
// First21 'stable' release. Should21 be sythesizable21 now. Also21 added new header.
//
// Revision21 1.0  2001-05-17 21:27:11+02  jacob21
// Initial21 revision21
//
//

// synopsys21 translate_off21
`include "timescale.v"
// synopsys21 translate_on21

`include "uart_defines21.v"

module uart_receiver21 (clk21, wb_rst_i21, lcr21, rf_pop21, srx_pad_i21, enable, 
	counter_t21, rf_count21, rf_data_out21, rf_error_bit21, rf_overrun21, rx_reset21, lsr_mask21, rstate, rf_push_pulse21);

input				clk21;
input				wb_rst_i21;
input	[7:0]	lcr21;
input				rf_pop21;
input				srx_pad_i21;
input				enable;
input				rx_reset21;
input       lsr_mask21;

output	[9:0]			counter_t21;
output	[`UART_FIFO_COUNTER_W21-1:0]	rf_count21;
output	[`UART_FIFO_REC_WIDTH21-1:0]	rf_data_out21;
output				rf_overrun21;
output				rf_error_bit21;
output [3:0] 		rstate;
output 				rf_push_pulse21;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1621;
reg	[2:0]	rbit_counter21;
reg	[7:0]	rshift21;			// receiver21 shift21 register
reg		rparity21;		// received21 parity21
reg		rparity_error21;
reg		rframing_error21;		// framing21 error flag21
reg		rbit_in21;
reg		rparity_xor21;
reg	[7:0]	counter_b21;	// counts21 the 0 (low21) signals21
reg   rf_push_q21;

// RX21 FIFO signals21
reg	[`UART_FIFO_REC_WIDTH21-1:0]	rf_data_in21;
wire	[`UART_FIFO_REC_WIDTH21-1:0]	rf_data_out21;
wire      rf_push_pulse21;
reg				rf_push21;
wire				rf_pop21;
wire				rf_overrun21;
wire	[`UART_FIFO_COUNTER_W21-1:0]	rf_count21;
wire				rf_error_bit21; // an error (parity21 or framing21) is inside the fifo
wire 				break_error21 = (counter_b21 == 0);

// RX21 FIFO instance
uart_rfifo21 #(`UART_FIFO_REC_WIDTH21) fifo_rx21(
	.clk21(		clk21		), 
	.wb_rst_i21(	wb_rst_i21	),
	.data_in21(	rf_data_in21	),
	.data_out21(	rf_data_out21	),
	.push21(		rf_push_pulse21		),
	.pop21(		rf_pop21		),
	.overrun21(	rf_overrun21	),
	.count(		rf_count21	),
	.error_bit21(	rf_error_bit21	),
	.fifo_reset21(	rx_reset21	),
	.reset_status21(lsr_mask21)
);

wire 		rcounter16_eq_721 = (rcounter1621 == 4'd7);
wire		rcounter16_eq_021 = (rcounter1621 == 4'd0);
wire		rcounter16_eq_121 = (rcounter1621 == 4'd1);

wire [3:0] rcounter16_minus_121 = rcounter1621 - 1'b1;

parameter  sr_idle21 					= 4'd0;
parameter  sr_rec_start21 			= 4'd1;
parameter  sr_rec_bit21 				= 4'd2;
parameter  sr_rec_parity21			= 4'd3;
parameter  sr_rec_stop21 				= 4'd4;
parameter  sr_check_parity21 		= 4'd5;
parameter  sr_rec_prepare21 			= 4'd6;
parameter  sr_end_bit21				= 4'd7;
parameter  sr_ca_lc_parity21	      = 4'd8;
parameter  sr_wait121 					= 4'd9;
parameter  sr_push21 					= 4'd10;


always @(posedge clk21 or posedge wb_rst_i21)
begin
  if (wb_rst_i21)
  begin
     rstate 			<= #1 sr_idle21;
	  rbit_in21 				<= #1 1'b0;
	  rcounter1621 			<= #1 0;
	  rbit_counter21 		<= #1 0;
	  rparity_xor21 		<= #1 1'b0;
	  rframing_error21 	<= #1 1'b0;
	  rparity_error21 		<= #1 1'b0;
	  rparity21 				<= #1 1'b0;
	  rshift21 				<= #1 0;
	  rf_push21 				<= #1 1'b0;
	  rf_data_in21 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle21 : begin
			rf_push21 			  <= #1 1'b0;
			rf_data_in21 	  <= #1 0;
			rcounter1621 	  <= #1 4'b1110;
			if (srx_pad_i21==1'b0 & ~break_error21)   // detected a pulse21 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start21;
			end
		end
	sr_rec_start21 :	begin
  			rf_push21 			  <= #1 1'b0;
				if (rcounter16_eq_721)    // check the pulse21
					if (srx_pad_i21==1'b1)   // no start bit
						rstate <= #1 sr_idle21;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare21;
				rcounter1621 <= #1 rcounter16_minus_121;
			end
	sr_rec_prepare21:begin
				case (lcr21[/*`UART_LC_BITS21*/1:0])  // number21 of bits in a word21
				2'b00 : rbit_counter21 <= #1 3'b100;
				2'b01 : rbit_counter21 <= #1 3'b101;
				2'b10 : rbit_counter21 <= #1 3'b110;
				2'b11 : rbit_counter21 <= #1 3'b111;
				endcase
				if (rcounter16_eq_021)
				begin
					rstate		<= #1 sr_rec_bit21;
					rcounter1621	<= #1 4'b1110;
					rshift21		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare21;
				rcounter1621 <= #1 rcounter16_minus_121;
			end
	sr_rec_bit21 :	begin
				if (rcounter16_eq_021)
					rstate <= #1 sr_end_bit21;
				if (rcounter16_eq_721) // read the bit
					case (lcr21[/*`UART_LC_BITS21*/1:0])  // number21 of bits in a word21
					2'b00 : rshift21[4:0]  <= #1 {srx_pad_i21, rshift21[4:1]};
					2'b01 : rshift21[5:0]  <= #1 {srx_pad_i21, rshift21[5:1]};
					2'b10 : rshift21[6:0]  <= #1 {srx_pad_i21, rshift21[6:1]};
					2'b11 : rshift21[7:0]  <= #1 {srx_pad_i21, rshift21[7:1]};
					endcase
				rcounter1621 <= #1 rcounter16_minus_121;
			end
	sr_end_bit21 :   begin
				if (rbit_counter21==3'b0) // no more bits in word21
					if (lcr21[`UART_LC_PE21]) // choose21 state based on parity21
						rstate <= #1 sr_rec_parity21;
					else
					begin
						rstate <= #1 sr_rec_stop21;
						rparity_error21 <= #1 1'b0;  // no parity21 - no error :)
					end
				else		// else we21 have more bits to read
				begin
					rstate <= #1 sr_rec_bit21;
					rbit_counter21 <= #1 rbit_counter21 - 1'b1;
				end
				rcounter1621 <= #1 4'b1110;
			end
	sr_rec_parity21: begin
				if (rcounter16_eq_721)	// read the parity21
				begin
					rparity21 <= #1 srx_pad_i21;
					rstate <= #1 sr_ca_lc_parity21;
				end
				rcounter1621 <= #1 rcounter16_minus_121;
			end
	sr_ca_lc_parity21 : begin    // rcounter21 equals21 6
				rcounter1621  <= #1 rcounter16_minus_121;
				rparity_xor21 <= #1 ^{rshift21,rparity21}; // calculate21 parity21 on all incoming21 data
				rstate      <= #1 sr_check_parity21;
			  end
	sr_check_parity21: begin	  // rcounter21 equals21 5
				case ({lcr21[`UART_LC_EP21],lcr21[`UART_LC_SP21]})
					2'b00: rparity_error21 <= #1  rparity_xor21 == 0;  // no error if parity21 1
					2'b01: rparity_error21 <= #1 ~rparity21;      // parity21 should sticked21 to 1
					2'b10: rparity_error21 <= #1  rparity_xor21 == 1;   // error if parity21 is odd21
					2'b11: rparity_error21 <= #1  rparity21;	  // parity21 should be sticked21 to 0
				endcase
				rcounter1621 <= #1 rcounter16_minus_121;
				rstate <= #1 sr_wait121;
			  end
	sr_wait121 :	if (rcounter16_eq_021)
			begin
				rstate <= #1 sr_rec_stop21;
				rcounter1621 <= #1 4'b1110;
			end
			else
				rcounter1621 <= #1 rcounter16_minus_121;
	sr_rec_stop21 :	begin
				if (rcounter16_eq_721)	// read the parity21
				begin
					rframing_error21 <= #1 !srx_pad_i21; // no framing21 error if input is 1 (stop bit)
					rstate <= #1 sr_push21;
				end
				rcounter1621 <= #1 rcounter16_minus_121;
			end
	sr_push21 :	begin
///////////////////////////////////////
//				$display($time, ": received21: %b", rf_data_in21);
        if(srx_pad_i21 | break_error21)
          begin
            if(break_error21)
        		  rf_data_in21 	<= #1 {8'b0, 3'b100}; // break input (empty21 character21) to receiver21 FIFO
            else
        			rf_data_in21  <= #1 {rshift21, 1'b0, rparity_error21, rframing_error21};
      		  rf_push21 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle21;
          end
        else if(~rframing_error21)  // There's always a framing21 before break_error21 -> wait for break or srx_pad_i21
          begin
       			rf_data_in21  <= #1 {rshift21, 1'b0, rparity_error21, rframing_error21};
      		  rf_push21 		  <= #1 1'b1;
      			rcounter1621 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start21;
          end
                      
			end
	default : rstate <= #1 sr_idle21;
	endcase
  end  // if (enable)
end // always of receiver21

always @ (posedge clk21 or posedge wb_rst_i21)
begin
  if(wb_rst_i21)
    rf_push_q21 <= 0;
  else
    rf_push_q21 <= #1 rf_push21;
end

assign rf_push_pulse21 = rf_push21 & ~rf_push_q21;

  
//
// Break21 condition detection21.
// Works21 in conjuction21 with the receiver21 state machine21

reg 	[9:0]	toc_value21; // value to be set to timeout counter

always @(lcr21)
	case (lcr21[3:0])
		4'b0000										: toc_value21 = 447; // 7 bits
		4'b0100										: toc_value21 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value21 = 511; // 8 bits
		4'b1100										: toc_value21 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value21 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value21 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value21 = 703; // 11 bits
		4'b1111										: toc_value21 = 767; // 12 bits
	endcase // case(lcr21[3:0])

wire [7:0] 	brc_value21; // value to be set to break counter
assign 		brc_value21 = toc_value21[9:2]; // the same as timeout but 1 insead21 of 4 character21 times

always @(posedge clk21 or posedge wb_rst_i21)
begin
	if (wb_rst_i21)
		counter_b21 <= #1 8'd159;
	else
	if (srx_pad_i21)
		counter_b21 <= #1 brc_value21; // character21 time length - 1
	else
	if(enable & counter_b21 != 8'b0)            // only work21 on enable times  break not reached21.
		counter_b21 <= #1 counter_b21 - 1;  // decrement break counter
end // always of break condition detection21

///
/// Timeout21 condition detection21
reg	[9:0]	counter_t21;	// counts21 the timeout condition clocks21

always @(posedge clk21 or posedge wb_rst_i21)
begin
	if (wb_rst_i21)
		counter_t21 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse21 || rf_pop21 || rf_count21 == 0) // counter is reset when RX21 FIFO is empty21, accessed or above21 trigger level
			counter_t21 <= #1 toc_value21;
		else
		if (enable && counter_t21 != 10'b0)  // we21 don21't want21 to underflow21
			counter_t21 <= #1 counter_t21 - 1;		
end
	
endmodule
