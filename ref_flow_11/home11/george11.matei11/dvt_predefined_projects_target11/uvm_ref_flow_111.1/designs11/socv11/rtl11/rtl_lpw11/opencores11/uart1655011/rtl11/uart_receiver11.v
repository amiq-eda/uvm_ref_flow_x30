//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver11.v                                             ////
////                                                              ////
////                                                              ////
////  This11 file is part of the "UART11 16550 compatible11" project11    ////
////  http11://www11.opencores11.org11/cores11/uart1655011/                   ////
////                                                              ////
////  Documentation11 related11 to this project11:                      ////
////  - http11://www11.opencores11.org11/cores11/uart1655011/                 ////
////                                                              ////
////  Projects11 compatibility11:                                     ////
////  - WISHBONE11                                                  ////
////  RS23211 Protocol11                                              ////
////  16550D uart11 (mostly11 supported)                              ////
////                                                              ////
////  Overview11 (main11 Features11):                                   ////
////  UART11 core11 receiver11 logic                                    ////
////                                                              ////
////  Known11 problems11 (limits11):                                    ////
////  None11 known11                                                  ////
////                                                              ////
////  To11 Do11:                                                      ////
////  Thourough11 testing11.                                          ////
////                                                              ////
////  Author11(s):                                                  ////
////      - gorban11@opencores11.org11                                  ////
////      - Jacob11 Gorban11                                          ////
////      - Igor11 Mohor11 (igorm11@opencores11.org11)                      ////
////                                                              ////
////  Created11:        2001/05/12                                  ////
////  Last11 Updated11:   2001/05/17                                  ////
////                  (See log11 for the revision11 history11)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2000, 2001 Authors11                             ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS11 Revision11 History11
//
// $Log: not supported by cvs2svn11 $
// Revision11 1.29  2002/07/29 21:16:18  gorban11
// The uart_defines11.v file is included11 again11 in sources11.
//
// Revision11 1.28  2002/07/22 23:02:23  gorban11
// Bug11 Fixes11:
//  * Possible11 loss of sync and bad11 reception11 of stop bit on slow11 baud11 rates11 fixed11.
//   Problem11 reported11 by Kenny11.Tung11.
//  * Bad (or lack11 of ) loopback11 handling11 fixed11. Reported11 by Cherry11 Withers11.
//
// Improvements11:
//  * Made11 FIFO's as general11 inferrable11 memory where possible11.
//  So11 on FPGA11 they should be inferred11 as RAM11 (Distributed11 RAM11 on Xilinx11).
//  This11 saves11 about11 1/3 of the Slice11 count and reduces11 P&R and synthesis11 times.
//
//  * Added11 optional11 baudrate11 output (baud_o11).
//  This11 is identical11 to BAUDOUT11* signal11 on 16550 chip11.
//  It outputs11 16xbit_clock_rate - the divided11 clock11.
//  It's disabled by default. Define11 UART_HAS_BAUDRATE_OUTPUT11 to use.
//
// Revision11 1.27  2001/12/30 20:39:13  mohor11
// More than one character11 was stored11 in case of break. End11 of the break
// was not detected correctly.
//
// Revision11 1.26  2001/12/20 13:28:27  mohor11
// Missing11 declaration11 of rf_push_q11 fixed11.
//
// Revision11 1.25  2001/12/20 13:25:46  mohor11
// rx11 push11 changed to be only one cycle wide11.
//
// Revision11 1.24  2001/12/19 08:03:34  mohor11
// Warnings11 cleared11.
//
// Revision11 1.23  2001/12/19 07:33:54  mohor11
// Synplicity11 was having11 troubles11 with the comment11.
//
// Revision11 1.22  2001/12/17 14:46:48  mohor11
// overrun11 signal11 was moved to separate11 block because many11 sequential11 lsr11
// reads were11 preventing11 data from being written11 to rx11 fifo.
// underrun11 signal11 was not used and was removed from the project11.
//
// Revision11 1.21  2001/12/13 10:31:16  mohor11
// timeout irq11 must be set regardless11 of the rda11 irq11 (rda11 irq11 does not reset the
// timeout counter).
//
// Revision11 1.20  2001/12/10 19:52:05  gorban11
// Igor11 fixed11 break condition bugs11
//
// Revision11 1.19  2001/12/06 14:51:04  gorban11
// Bug11 in LSR11[0] is fixed11.
// All WISHBONE11 signals11 are now sampled11, so another11 wait-state is introduced11 on all transfers11.
//
// Revision11 1.18  2001/12/03 21:44:29  gorban11
// Updated11 specification11 documentation.
// Added11 full 32-bit data bus interface, now as default.
// Address is 5-bit wide11 in 32-bit data bus mode.
// Added11 wb_sel_i11 input to the core11. It's used in the 32-bit mode.
// Added11 debug11 interface with two11 32-bit read-only registers in 32-bit mode.
// Bits11 5 and 6 of LSR11 are now only cleared11 on TX11 FIFO write.
// My11 small test bench11 is modified to work11 with 32-bit mode.
//
// Revision11 1.17  2001/11/28 19:36:39  gorban11
// Fixed11: timeout and break didn11't pay11 attention11 to current data format11 when counting11 time
//
// Revision11 1.16  2001/11/27 22:17:09  gorban11
// Fixed11 bug11 that prevented11 synthesis11 in uart_receiver11.v
//
// Revision11 1.15  2001/11/26 21:38:54  gorban11
// Lots11 of fixes11:
// Break11 condition wasn11't handled11 correctly at all.
// LSR11 bits could lose11 their11 values.
// LSR11 value after reset was wrong11.
// Timing11 of THRE11 interrupt11 signal11 corrected11.
// LSR11 bit 0 timing11 corrected11.
//
// Revision11 1.14  2001/11/10 12:43:21  gorban11
// Logic11 Synthesis11 bugs11 fixed11. Some11 other minor11 changes11
//
// Revision11 1.13  2001/11/08 14:54:23  mohor11
// Comments11 in Slovene11 language11 deleted11, few11 small fixes11 for better11 work11 of
// old11 tools11. IRQs11 need to be fix11.
//
// Revision11 1.12  2001/11/07 17:51:52  gorban11
// Heavily11 rewritten11 interrupt11 and LSR11 subsystems11.
// Many11 bugs11 hopefully11 squashed11.
//
// Revision11 1.11  2001/10/31 15:19:22  gorban11
// Fixes11 to break and timeout conditions11
//
// Revision11 1.10  2001/10/20 09:58:40  gorban11
// Small11 synopsis11 fixes11
//
// Revision11 1.9  2001/08/24 21:01:12  mohor11
// Things11 connected11 to parity11 changed.
// Clock11 devider11 changed.
//
// Revision11 1.8  2001/08/23 16:05:05  mohor11
// Stop bit bug11 fixed11.
// Parity11 bug11 fixed11.
// WISHBONE11 read cycle bug11 fixed11,
// OE11 indicator11 (Overrun11 Error) bug11 fixed11.
// PE11 indicator11 (Parity11 Error) bug11 fixed11.
// Register read bug11 fixed11.
//
// Revision11 1.6  2001/06/23 11:21:48  gorban11
// DL11 made11 16-bit long11. Fixed11 transmission11/reception11 bugs11.
//
// Revision11 1.5  2001/06/02 14:28:14  gorban11
// Fixed11 receiver11 and transmitter11. Major11 bug11 fixed11.
//
// Revision11 1.4  2001/05/31 20:08:01  gorban11
// FIFO changes11 and other corrections11.
//
// Revision11 1.3  2001/05/27 17:37:49  gorban11
// Fixed11 many11 bugs11. Updated11 spec11. Changed11 FIFO files structure11. See CHANGES11.txt11 file.
//
// Revision11 1.2  2001/05/21 19:12:02  gorban11
// Corrected11 some11 Linter11 messages11.
//
// Revision11 1.1  2001/05/17 18:34:18  gorban11
// First11 'stable' release. Should11 be sythesizable11 now. Also11 added new header.
//
// Revision11 1.0  2001-05-17 21:27:11+02  jacob11
// Initial11 revision11
//
//

// synopsys11 translate_off11
`include "timescale.v"
// synopsys11 translate_on11

`include "uart_defines11.v"

module uart_receiver11 (clk11, wb_rst_i11, lcr11, rf_pop11, srx_pad_i11, enable, 
	counter_t11, rf_count11, rf_data_out11, rf_error_bit11, rf_overrun11, rx_reset11, lsr_mask11, rstate, rf_push_pulse11);

input				clk11;
input				wb_rst_i11;
input	[7:0]	lcr11;
input				rf_pop11;
input				srx_pad_i11;
input				enable;
input				rx_reset11;
input       lsr_mask11;

output	[9:0]			counter_t11;
output	[`UART_FIFO_COUNTER_W11-1:0]	rf_count11;
output	[`UART_FIFO_REC_WIDTH11-1:0]	rf_data_out11;
output				rf_overrun11;
output				rf_error_bit11;
output [3:0] 		rstate;
output 				rf_push_pulse11;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1611;
reg	[2:0]	rbit_counter11;
reg	[7:0]	rshift11;			// receiver11 shift11 register
reg		rparity11;		// received11 parity11
reg		rparity_error11;
reg		rframing_error11;		// framing11 error flag11
reg		rbit_in11;
reg		rparity_xor11;
reg	[7:0]	counter_b11;	// counts11 the 0 (low11) signals11
reg   rf_push_q11;

// RX11 FIFO signals11
reg	[`UART_FIFO_REC_WIDTH11-1:0]	rf_data_in11;
wire	[`UART_FIFO_REC_WIDTH11-1:0]	rf_data_out11;
wire      rf_push_pulse11;
reg				rf_push11;
wire				rf_pop11;
wire				rf_overrun11;
wire	[`UART_FIFO_COUNTER_W11-1:0]	rf_count11;
wire				rf_error_bit11; // an error (parity11 or framing11) is inside the fifo
wire 				break_error11 = (counter_b11 == 0);

// RX11 FIFO instance
uart_rfifo11 #(`UART_FIFO_REC_WIDTH11) fifo_rx11(
	.clk11(		clk11		), 
	.wb_rst_i11(	wb_rst_i11	),
	.data_in11(	rf_data_in11	),
	.data_out11(	rf_data_out11	),
	.push11(		rf_push_pulse11		),
	.pop11(		rf_pop11		),
	.overrun11(	rf_overrun11	),
	.count(		rf_count11	),
	.error_bit11(	rf_error_bit11	),
	.fifo_reset11(	rx_reset11	),
	.reset_status11(lsr_mask11)
);

wire 		rcounter16_eq_711 = (rcounter1611 == 4'd7);
wire		rcounter16_eq_011 = (rcounter1611 == 4'd0);
wire		rcounter16_eq_111 = (rcounter1611 == 4'd1);

wire [3:0] rcounter16_minus_111 = rcounter1611 - 1'b1;

parameter  sr_idle11 					= 4'd0;
parameter  sr_rec_start11 			= 4'd1;
parameter  sr_rec_bit11 				= 4'd2;
parameter  sr_rec_parity11			= 4'd3;
parameter  sr_rec_stop11 				= 4'd4;
parameter  sr_check_parity11 		= 4'd5;
parameter  sr_rec_prepare11 			= 4'd6;
parameter  sr_end_bit11				= 4'd7;
parameter  sr_ca_lc_parity11	      = 4'd8;
parameter  sr_wait111 					= 4'd9;
parameter  sr_push11 					= 4'd10;


always @(posedge clk11 or posedge wb_rst_i11)
begin
  if (wb_rst_i11)
  begin
     rstate 			<= #1 sr_idle11;
	  rbit_in11 				<= #1 1'b0;
	  rcounter1611 			<= #1 0;
	  rbit_counter11 		<= #1 0;
	  rparity_xor11 		<= #1 1'b0;
	  rframing_error11 	<= #1 1'b0;
	  rparity_error11 		<= #1 1'b0;
	  rparity11 				<= #1 1'b0;
	  rshift11 				<= #1 0;
	  rf_push11 				<= #1 1'b0;
	  rf_data_in11 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle11 : begin
			rf_push11 			  <= #1 1'b0;
			rf_data_in11 	  <= #1 0;
			rcounter1611 	  <= #1 4'b1110;
			if (srx_pad_i11==1'b0 & ~break_error11)   // detected a pulse11 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start11;
			end
		end
	sr_rec_start11 :	begin
  			rf_push11 			  <= #1 1'b0;
				if (rcounter16_eq_711)    // check the pulse11
					if (srx_pad_i11==1'b1)   // no start bit
						rstate <= #1 sr_idle11;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare11;
				rcounter1611 <= #1 rcounter16_minus_111;
			end
	sr_rec_prepare11:begin
				case (lcr11[/*`UART_LC_BITS11*/1:0])  // number11 of bits in a word11
				2'b00 : rbit_counter11 <= #1 3'b100;
				2'b01 : rbit_counter11 <= #1 3'b101;
				2'b10 : rbit_counter11 <= #1 3'b110;
				2'b11 : rbit_counter11 <= #1 3'b111;
				endcase
				if (rcounter16_eq_011)
				begin
					rstate		<= #1 sr_rec_bit11;
					rcounter1611	<= #1 4'b1110;
					rshift11		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare11;
				rcounter1611 <= #1 rcounter16_minus_111;
			end
	sr_rec_bit11 :	begin
				if (rcounter16_eq_011)
					rstate <= #1 sr_end_bit11;
				if (rcounter16_eq_711) // read the bit
					case (lcr11[/*`UART_LC_BITS11*/1:0])  // number11 of bits in a word11
					2'b00 : rshift11[4:0]  <= #1 {srx_pad_i11, rshift11[4:1]};
					2'b01 : rshift11[5:0]  <= #1 {srx_pad_i11, rshift11[5:1]};
					2'b10 : rshift11[6:0]  <= #1 {srx_pad_i11, rshift11[6:1]};
					2'b11 : rshift11[7:0]  <= #1 {srx_pad_i11, rshift11[7:1]};
					endcase
				rcounter1611 <= #1 rcounter16_minus_111;
			end
	sr_end_bit11 :   begin
				if (rbit_counter11==3'b0) // no more bits in word11
					if (lcr11[`UART_LC_PE11]) // choose11 state based on parity11
						rstate <= #1 sr_rec_parity11;
					else
					begin
						rstate <= #1 sr_rec_stop11;
						rparity_error11 <= #1 1'b0;  // no parity11 - no error :)
					end
				else		// else we11 have more bits to read
				begin
					rstate <= #1 sr_rec_bit11;
					rbit_counter11 <= #1 rbit_counter11 - 1'b1;
				end
				rcounter1611 <= #1 4'b1110;
			end
	sr_rec_parity11: begin
				if (rcounter16_eq_711)	// read the parity11
				begin
					rparity11 <= #1 srx_pad_i11;
					rstate <= #1 sr_ca_lc_parity11;
				end
				rcounter1611 <= #1 rcounter16_minus_111;
			end
	sr_ca_lc_parity11 : begin    // rcounter11 equals11 6
				rcounter1611  <= #1 rcounter16_minus_111;
				rparity_xor11 <= #1 ^{rshift11,rparity11}; // calculate11 parity11 on all incoming11 data
				rstate      <= #1 sr_check_parity11;
			  end
	sr_check_parity11: begin	  // rcounter11 equals11 5
				case ({lcr11[`UART_LC_EP11],lcr11[`UART_LC_SP11]})
					2'b00: rparity_error11 <= #1  rparity_xor11 == 0;  // no error if parity11 1
					2'b01: rparity_error11 <= #1 ~rparity11;      // parity11 should sticked11 to 1
					2'b10: rparity_error11 <= #1  rparity_xor11 == 1;   // error if parity11 is odd11
					2'b11: rparity_error11 <= #1  rparity11;	  // parity11 should be sticked11 to 0
				endcase
				rcounter1611 <= #1 rcounter16_minus_111;
				rstate <= #1 sr_wait111;
			  end
	sr_wait111 :	if (rcounter16_eq_011)
			begin
				rstate <= #1 sr_rec_stop11;
				rcounter1611 <= #1 4'b1110;
			end
			else
				rcounter1611 <= #1 rcounter16_minus_111;
	sr_rec_stop11 :	begin
				if (rcounter16_eq_711)	// read the parity11
				begin
					rframing_error11 <= #1 !srx_pad_i11; // no framing11 error if input is 1 (stop bit)
					rstate <= #1 sr_push11;
				end
				rcounter1611 <= #1 rcounter16_minus_111;
			end
	sr_push11 :	begin
///////////////////////////////////////
//				$display($time, ": received11: %b", rf_data_in11);
        if(srx_pad_i11 | break_error11)
          begin
            if(break_error11)
        		  rf_data_in11 	<= #1 {8'b0, 3'b100}; // break input (empty11 character11) to receiver11 FIFO
            else
        			rf_data_in11  <= #1 {rshift11, 1'b0, rparity_error11, rframing_error11};
      		  rf_push11 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle11;
          end
        else if(~rframing_error11)  // There's always a framing11 before break_error11 -> wait for break or srx_pad_i11
          begin
       			rf_data_in11  <= #1 {rshift11, 1'b0, rparity_error11, rframing_error11};
      		  rf_push11 		  <= #1 1'b1;
      			rcounter1611 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start11;
          end
                      
			end
	default : rstate <= #1 sr_idle11;
	endcase
  end  // if (enable)
end // always of receiver11

always @ (posedge clk11 or posedge wb_rst_i11)
begin
  if(wb_rst_i11)
    rf_push_q11 <= 0;
  else
    rf_push_q11 <= #1 rf_push11;
end

assign rf_push_pulse11 = rf_push11 & ~rf_push_q11;

  
//
// Break11 condition detection11.
// Works11 in conjuction11 with the receiver11 state machine11

reg 	[9:0]	toc_value11; // value to be set to timeout counter

always @(lcr11)
	case (lcr11[3:0])
		4'b0000										: toc_value11 = 447; // 7 bits
		4'b0100										: toc_value11 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value11 = 511; // 8 bits
		4'b1100										: toc_value11 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value11 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value11 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value11 = 703; // 11 bits
		4'b1111										: toc_value11 = 767; // 12 bits
	endcase // case(lcr11[3:0])

wire [7:0] 	brc_value11; // value to be set to break counter
assign 		brc_value11 = toc_value11[9:2]; // the same as timeout but 1 insead11 of 4 character11 times

always @(posedge clk11 or posedge wb_rst_i11)
begin
	if (wb_rst_i11)
		counter_b11 <= #1 8'd159;
	else
	if (srx_pad_i11)
		counter_b11 <= #1 brc_value11; // character11 time length - 1
	else
	if(enable & counter_b11 != 8'b0)            // only work11 on enable times  break not reached11.
		counter_b11 <= #1 counter_b11 - 1;  // decrement break counter
end // always of break condition detection11

///
/// Timeout11 condition detection11
reg	[9:0]	counter_t11;	// counts11 the timeout condition clocks11

always @(posedge clk11 or posedge wb_rst_i11)
begin
	if (wb_rst_i11)
		counter_t11 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse11 || rf_pop11 || rf_count11 == 0) // counter is reset when RX11 FIFO is empty11, accessed or above11 trigger level
			counter_t11 <= #1 toc_value11;
		else
		if (enable && counter_t11 != 10'b0)  // we11 don11't want11 to underflow11
			counter_t11 <= #1 counter_t11 - 1;		
end
	
endmodule
