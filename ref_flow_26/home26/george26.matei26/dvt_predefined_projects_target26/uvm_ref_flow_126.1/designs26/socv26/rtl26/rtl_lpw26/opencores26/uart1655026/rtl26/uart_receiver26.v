//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver26.v                                             ////
////                                                              ////
////                                                              ////
////  This26 file is part of the "UART26 16550 compatible26" project26    ////
////  http26://www26.opencores26.org26/cores26/uart1655026/                   ////
////                                                              ////
////  Documentation26 related26 to this project26:                      ////
////  - http26://www26.opencores26.org26/cores26/uart1655026/                 ////
////                                                              ////
////  Projects26 compatibility26:                                     ////
////  - WISHBONE26                                                  ////
////  RS23226 Protocol26                                              ////
////  16550D uart26 (mostly26 supported)                              ////
////                                                              ////
////  Overview26 (main26 Features26):                                   ////
////  UART26 core26 receiver26 logic                                    ////
////                                                              ////
////  Known26 problems26 (limits26):                                    ////
////  None26 known26                                                  ////
////                                                              ////
////  To26 Do26:                                                      ////
////  Thourough26 testing26.                                          ////
////                                                              ////
////  Author26(s):                                                  ////
////      - gorban26@opencores26.org26                                  ////
////      - Jacob26 Gorban26                                          ////
////      - Igor26 Mohor26 (igorm26@opencores26.org26)                      ////
////                                                              ////
////  Created26:        2001/05/12                                  ////
////  Last26 Updated26:   2001/05/17                                  ////
////                  (See log26 for the revision26 history26)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2000, 2001 Authors26                             ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS26 Revision26 History26
//
// $Log: not supported by cvs2svn26 $
// Revision26 1.29  2002/07/29 21:16:18  gorban26
// The uart_defines26.v file is included26 again26 in sources26.
//
// Revision26 1.28  2002/07/22 23:02:23  gorban26
// Bug26 Fixes26:
//  * Possible26 loss of sync and bad26 reception26 of stop bit on slow26 baud26 rates26 fixed26.
//   Problem26 reported26 by Kenny26.Tung26.
//  * Bad (or lack26 of ) loopback26 handling26 fixed26. Reported26 by Cherry26 Withers26.
//
// Improvements26:
//  * Made26 FIFO's as general26 inferrable26 memory where possible26.
//  So26 on FPGA26 they should be inferred26 as RAM26 (Distributed26 RAM26 on Xilinx26).
//  This26 saves26 about26 1/3 of the Slice26 count and reduces26 P&R and synthesis26 times.
//
//  * Added26 optional26 baudrate26 output (baud_o26).
//  This26 is identical26 to BAUDOUT26* signal26 on 16550 chip26.
//  It outputs26 16xbit_clock_rate - the divided26 clock26.
//  It's disabled by default. Define26 UART_HAS_BAUDRATE_OUTPUT26 to use.
//
// Revision26 1.27  2001/12/30 20:39:13  mohor26
// More than one character26 was stored26 in case of break. End26 of the break
// was not detected correctly.
//
// Revision26 1.26  2001/12/20 13:28:27  mohor26
// Missing26 declaration26 of rf_push_q26 fixed26.
//
// Revision26 1.25  2001/12/20 13:25:46  mohor26
// rx26 push26 changed to be only one cycle wide26.
//
// Revision26 1.24  2001/12/19 08:03:34  mohor26
// Warnings26 cleared26.
//
// Revision26 1.23  2001/12/19 07:33:54  mohor26
// Synplicity26 was having26 troubles26 with the comment26.
//
// Revision26 1.22  2001/12/17 14:46:48  mohor26
// overrun26 signal26 was moved to separate26 block because many26 sequential26 lsr26
// reads were26 preventing26 data from being written26 to rx26 fifo.
// underrun26 signal26 was not used and was removed from the project26.
//
// Revision26 1.21  2001/12/13 10:31:16  mohor26
// timeout irq26 must be set regardless26 of the rda26 irq26 (rda26 irq26 does not reset the
// timeout counter).
//
// Revision26 1.20  2001/12/10 19:52:05  gorban26
// Igor26 fixed26 break condition bugs26
//
// Revision26 1.19  2001/12/06 14:51:04  gorban26
// Bug26 in LSR26[0] is fixed26.
// All WISHBONE26 signals26 are now sampled26, so another26 wait-state is introduced26 on all transfers26.
//
// Revision26 1.18  2001/12/03 21:44:29  gorban26
// Updated26 specification26 documentation.
// Added26 full 32-bit data bus interface, now as default.
// Address is 5-bit wide26 in 32-bit data bus mode.
// Added26 wb_sel_i26 input to the core26. It's used in the 32-bit mode.
// Added26 debug26 interface with two26 32-bit read-only registers in 32-bit mode.
// Bits26 5 and 6 of LSR26 are now only cleared26 on TX26 FIFO write.
// My26 small test bench26 is modified to work26 with 32-bit mode.
//
// Revision26 1.17  2001/11/28 19:36:39  gorban26
// Fixed26: timeout and break didn26't pay26 attention26 to current data format26 when counting26 time
//
// Revision26 1.16  2001/11/27 22:17:09  gorban26
// Fixed26 bug26 that prevented26 synthesis26 in uart_receiver26.v
//
// Revision26 1.15  2001/11/26 21:38:54  gorban26
// Lots26 of fixes26:
// Break26 condition wasn26't handled26 correctly at all.
// LSR26 bits could lose26 their26 values.
// LSR26 value after reset was wrong26.
// Timing26 of THRE26 interrupt26 signal26 corrected26.
// LSR26 bit 0 timing26 corrected26.
//
// Revision26 1.14  2001/11/10 12:43:21  gorban26
// Logic26 Synthesis26 bugs26 fixed26. Some26 other minor26 changes26
//
// Revision26 1.13  2001/11/08 14:54:23  mohor26
// Comments26 in Slovene26 language26 deleted26, few26 small fixes26 for better26 work26 of
// old26 tools26. IRQs26 need to be fix26.
//
// Revision26 1.12  2001/11/07 17:51:52  gorban26
// Heavily26 rewritten26 interrupt26 and LSR26 subsystems26.
// Many26 bugs26 hopefully26 squashed26.
//
// Revision26 1.11  2001/10/31 15:19:22  gorban26
// Fixes26 to break and timeout conditions26
//
// Revision26 1.10  2001/10/20 09:58:40  gorban26
// Small26 synopsis26 fixes26
//
// Revision26 1.9  2001/08/24 21:01:12  mohor26
// Things26 connected26 to parity26 changed.
// Clock26 devider26 changed.
//
// Revision26 1.8  2001/08/23 16:05:05  mohor26
// Stop bit bug26 fixed26.
// Parity26 bug26 fixed26.
// WISHBONE26 read cycle bug26 fixed26,
// OE26 indicator26 (Overrun26 Error) bug26 fixed26.
// PE26 indicator26 (Parity26 Error) bug26 fixed26.
// Register read bug26 fixed26.
//
// Revision26 1.6  2001/06/23 11:21:48  gorban26
// DL26 made26 16-bit long26. Fixed26 transmission26/reception26 bugs26.
//
// Revision26 1.5  2001/06/02 14:28:14  gorban26
// Fixed26 receiver26 and transmitter26. Major26 bug26 fixed26.
//
// Revision26 1.4  2001/05/31 20:08:01  gorban26
// FIFO changes26 and other corrections26.
//
// Revision26 1.3  2001/05/27 17:37:49  gorban26
// Fixed26 many26 bugs26. Updated26 spec26. Changed26 FIFO files structure26. See CHANGES26.txt26 file.
//
// Revision26 1.2  2001/05/21 19:12:02  gorban26
// Corrected26 some26 Linter26 messages26.
//
// Revision26 1.1  2001/05/17 18:34:18  gorban26
// First26 'stable' release. Should26 be sythesizable26 now. Also26 added new header.
//
// Revision26 1.0  2001-05-17 21:27:11+02  jacob26
// Initial26 revision26
//
//

// synopsys26 translate_off26
`include "timescale.v"
// synopsys26 translate_on26

`include "uart_defines26.v"

module uart_receiver26 (clk26, wb_rst_i26, lcr26, rf_pop26, srx_pad_i26, enable, 
	counter_t26, rf_count26, rf_data_out26, rf_error_bit26, rf_overrun26, rx_reset26, lsr_mask26, rstate, rf_push_pulse26);

input				clk26;
input				wb_rst_i26;
input	[7:0]	lcr26;
input				rf_pop26;
input				srx_pad_i26;
input				enable;
input				rx_reset26;
input       lsr_mask26;

output	[9:0]			counter_t26;
output	[`UART_FIFO_COUNTER_W26-1:0]	rf_count26;
output	[`UART_FIFO_REC_WIDTH26-1:0]	rf_data_out26;
output				rf_overrun26;
output				rf_error_bit26;
output [3:0] 		rstate;
output 				rf_push_pulse26;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1626;
reg	[2:0]	rbit_counter26;
reg	[7:0]	rshift26;			// receiver26 shift26 register
reg		rparity26;		// received26 parity26
reg		rparity_error26;
reg		rframing_error26;		// framing26 error flag26
reg		rbit_in26;
reg		rparity_xor26;
reg	[7:0]	counter_b26;	// counts26 the 0 (low26) signals26
reg   rf_push_q26;

// RX26 FIFO signals26
reg	[`UART_FIFO_REC_WIDTH26-1:0]	rf_data_in26;
wire	[`UART_FIFO_REC_WIDTH26-1:0]	rf_data_out26;
wire      rf_push_pulse26;
reg				rf_push26;
wire				rf_pop26;
wire				rf_overrun26;
wire	[`UART_FIFO_COUNTER_W26-1:0]	rf_count26;
wire				rf_error_bit26; // an error (parity26 or framing26) is inside the fifo
wire 				break_error26 = (counter_b26 == 0);

// RX26 FIFO instance
uart_rfifo26 #(`UART_FIFO_REC_WIDTH26) fifo_rx26(
	.clk26(		clk26		), 
	.wb_rst_i26(	wb_rst_i26	),
	.data_in26(	rf_data_in26	),
	.data_out26(	rf_data_out26	),
	.push26(		rf_push_pulse26		),
	.pop26(		rf_pop26		),
	.overrun26(	rf_overrun26	),
	.count(		rf_count26	),
	.error_bit26(	rf_error_bit26	),
	.fifo_reset26(	rx_reset26	),
	.reset_status26(lsr_mask26)
);

wire 		rcounter16_eq_726 = (rcounter1626 == 4'd7);
wire		rcounter16_eq_026 = (rcounter1626 == 4'd0);
wire		rcounter16_eq_126 = (rcounter1626 == 4'd1);

wire [3:0] rcounter16_minus_126 = rcounter1626 - 1'b1;

parameter  sr_idle26 					= 4'd0;
parameter  sr_rec_start26 			= 4'd1;
parameter  sr_rec_bit26 				= 4'd2;
parameter  sr_rec_parity26			= 4'd3;
parameter  sr_rec_stop26 				= 4'd4;
parameter  sr_check_parity26 		= 4'd5;
parameter  sr_rec_prepare26 			= 4'd6;
parameter  sr_end_bit26				= 4'd7;
parameter  sr_ca_lc_parity26	      = 4'd8;
parameter  sr_wait126 					= 4'd9;
parameter  sr_push26 					= 4'd10;


always @(posedge clk26 or posedge wb_rst_i26)
begin
  if (wb_rst_i26)
  begin
     rstate 			<= #1 sr_idle26;
	  rbit_in26 				<= #1 1'b0;
	  rcounter1626 			<= #1 0;
	  rbit_counter26 		<= #1 0;
	  rparity_xor26 		<= #1 1'b0;
	  rframing_error26 	<= #1 1'b0;
	  rparity_error26 		<= #1 1'b0;
	  rparity26 				<= #1 1'b0;
	  rshift26 				<= #1 0;
	  rf_push26 				<= #1 1'b0;
	  rf_data_in26 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle26 : begin
			rf_push26 			  <= #1 1'b0;
			rf_data_in26 	  <= #1 0;
			rcounter1626 	  <= #1 4'b1110;
			if (srx_pad_i26==1'b0 & ~break_error26)   // detected a pulse26 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start26;
			end
		end
	sr_rec_start26 :	begin
  			rf_push26 			  <= #1 1'b0;
				if (rcounter16_eq_726)    // check the pulse26
					if (srx_pad_i26==1'b1)   // no start bit
						rstate <= #1 sr_idle26;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare26;
				rcounter1626 <= #1 rcounter16_minus_126;
			end
	sr_rec_prepare26:begin
				case (lcr26[/*`UART_LC_BITS26*/1:0])  // number26 of bits in a word26
				2'b00 : rbit_counter26 <= #1 3'b100;
				2'b01 : rbit_counter26 <= #1 3'b101;
				2'b10 : rbit_counter26 <= #1 3'b110;
				2'b11 : rbit_counter26 <= #1 3'b111;
				endcase
				if (rcounter16_eq_026)
				begin
					rstate		<= #1 sr_rec_bit26;
					rcounter1626	<= #1 4'b1110;
					rshift26		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare26;
				rcounter1626 <= #1 rcounter16_minus_126;
			end
	sr_rec_bit26 :	begin
				if (rcounter16_eq_026)
					rstate <= #1 sr_end_bit26;
				if (rcounter16_eq_726) // read the bit
					case (lcr26[/*`UART_LC_BITS26*/1:0])  // number26 of bits in a word26
					2'b00 : rshift26[4:0]  <= #1 {srx_pad_i26, rshift26[4:1]};
					2'b01 : rshift26[5:0]  <= #1 {srx_pad_i26, rshift26[5:1]};
					2'b10 : rshift26[6:0]  <= #1 {srx_pad_i26, rshift26[6:1]};
					2'b11 : rshift26[7:0]  <= #1 {srx_pad_i26, rshift26[7:1]};
					endcase
				rcounter1626 <= #1 rcounter16_minus_126;
			end
	sr_end_bit26 :   begin
				if (rbit_counter26==3'b0) // no more bits in word26
					if (lcr26[`UART_LC_PE26]) // choose26 state based on parity26
						rstate <= #1 sr_rec_parity26;
					else
					begin
						rstate <= #1 sr_rec_stop26;
						rparity_error26 <= #1 1'b0;  // no parity26 - no error :)
					end
				else		// else we26 have more bits to read
				begin
					rstate <= #1 sr_rec_bit26;
					rbit_counter26 <= #1 rbit_counter26 - 1'b1;
				end
				rcounter1626 <= #1 4'b1110;
			end
	sr_rec_parity26: begin
				if (rcounter16_eq_726)	// read the parity26
				begin
					rparity26 <= #1 srx_pad_i26;
					rstate <= #1 sr_ca_lc_parity26;
				end
				rcounter1626 <= #1 rcounter16_minus_126;
			end
	sr_ca_lc_parity26 : begin    // rcounter26 equals26 6
				rcounter1626  <= #1 rcounter16_minus_126;
				rparity_xor26 <= #1 ^{rshift26,rparity26}; // calculate26 parity26 on all incoming26 data
				rstate      <= #1 sr_check_parity26;
			  end
	sr_check_parity26: begin	  // rcounter26 equals26 5
				case ({lcr26[`UART_LC_EP26],lcr26[`UART_LC_SP26]})
					2'b00: rparity_error26 <= #1  rparity_xor26 == 0;  // no error if parity26 1
					2'b01: rparity_error26 <= #1 ~rparity26;      // parity26 should sticked26 to 1
					2'b10: rparity_error26 <= #1  rparity_xor26 == 1;   // error if parity26 is odd26
					2'b11: rparity_error26 <= #1  rparity26;	  // parity26 should be sticked26 to 0
				endcase
				rcounter1626 <= #1 rcounter16_minus_126;
				rstate <= #1 sr_wait126;
			  end
	sr_wait126 :	if (rcounter16_eq_026)
			begin
				rstate <= #1 sr_rec_stop26;
				rcounter1626 <= #1 4'b1110;
			end
			else
				rcounter1626 <= #1 rcounter16_minus_126;
	sr_rec_stop26 :	begin
				if (rcounter16_eq_726)	// read the parity26
				begin
					rframing_error26 <= #1 !srx_pad_i26; // no framing26 error if input is 1 (stop bit)
					rstate <= #1 sr_push26;
				end
				rcounter1626 <= #1 rcounter16_minus_126;
			end
	sr_push26 :	begin
///////////////////////////////////////
//				$display($time, ": received26: %b", rf_data_in26);
        if(srx_pad_i26 | break_error26)
          begin
            if(break_error26)
        		  rf_data_in26 	<= #1 {8'b0, 3'b100}; // break input (empty26 character26) to receiver26 FIFO
            else
        			rf_data_in26  <= #1 {rshift26, 1'b0, rparity_error26, rframing_error26};
      		  rf_push26 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle26;
          end
        else if(~rframing_error26)  // There's always a framing26 before break_error26 -> wait for break or srx_pad_i26
          begin
       			rf_data_in26  <= #1 {rshift26, 1'b0, rparity_error26, rframing_error26};
      		  rf_push26 		  <= #1 1'b1;
      			rcounter1626 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start26;
          end
                      
			end
	default : rstate <= #1 sr_idle26;
	endcase
  end  // if (enable)
end // always of receiver26

always @ (posedge clk26 or posedge wb_rst_i26)
begin
  if(wb_rst_i26)
    rf_push_q26 <= 0;
  else
    rf_push_q26 <= #1 rf_push26;
end

assign rf_push_pulse26 = rf_push26 & ~rf_push_q26;

  
//
// Break26 condition detection26.
// Works26 in conjuction26 with the receiver26 state machine26

reg 	[9:0]	toc_value26; // value to be set to timeout counter

always @(lcr26)
	case (lcr26[3:0])
		4'b0000										: toc_value26 = 447; // 7 bits
		4'b0100										: toc_value26 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value26 = 511; // 8 bits
		4'b1100										: toc_value26 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value26 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value26 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value26 = 703; // 11 bits
		4'b1111										: toc_value26 = 767; // 12 bits
	endcase // case(lcr26[3:0])

wire [7:0] 	brc_value26; // value to be set to break counter
assign 		brc_value26 = toc_value26[9:2]; // the same as timeout but 1 insead26 of 4 character26 times

always @(posedge clk26 or posedge wb_rst_i26)
begin
	if (wb_rst_i26)
		counter_b26 <= #1 8'd159;
	else
	if (srx_pad_i26)
		counter_b26 <= #1 brc_value26; // character26 time length - 1
	else
	if(enable & counter_b26 != 8'b0)            // only work26 on enable times  break not reached26.
		counter_b26 <= #1 counter_b26 - 1;  // decrement break counter
end // always of break condition detection26

///
/// Timeout26 condition detection26
reg	[9:0]	counter_t26;	// counts26 the timeout condition clocks26

always @(posedge clk26 or posedge wb_rst_i26)
begin
	if (wb_rst_i26)
		counter_t26 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse26 || rf_pop26 || rf_count26 == 0) // counter is reset when RX26 FIFO is empty26, accessed or above26 trigger level
			counter_t26 <= #1 toc_value26;
		else
		if (enable && counter_t26 != 10'b0)  // we26 don26't want26 to underflow26
			counter_t26 <= #1 counter_t26 - 1;		
end
	
endmodule
