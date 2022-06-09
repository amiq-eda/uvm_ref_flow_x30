//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver24.v                                             ////
////                                                              ////
////                                                              ////
////  This24 file is part of the "UART24 16550 compatible24" project24    ////
////  http24://www24.opencores24.org24/cores24/uart1655024/                   ////
////                                                              ////
////  Documentation24 related24 to this project24:                      ////
////  - http24://www24.opencores24.org24/cores24/uart1655024/                 ////
////                                                              ////
////  Projects24 compatibility24:                                     ////
////  - WISHBONE24                                                  ////
////  RS23224 Protocol24                                              ////
////  16550D uart24 (mostly24 supported)                              ////
////                                                              ////
////  Overview24 (main24 Features24):                                   ////
////  UART24 core24 receiver24 logic                                    ////
////                                                              ////
////  Known24 problems24 (limits24):                                    ////
////  None24 known24                                                  ////
////                                                              ////
////  To24 Do24:                                                      ////
////  Thourough24 testing24.                                          ////
////                                                              ////
////  Author24(s):                                                  ////
////      - gorban24@opencores24.org24                                  ////
////      - Jacob24 Gorban24                                          ////
////      - Igor24 Mohor24 (igorm24@opencores24.org24)                      ////
////                                                              ////
////  Created24:        2001/05/12                                  ////
////  Last24 Updated24:   2001/05/17                                  ////
////                  (See log24 for the revision24 history24)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright24 (C) 2000, 2001 Authors24                             ////
////                                                              ////
//// This24 source24 file may be used and distributed24 without         ////
//// restriction24 provided that this copyright24 statement24 is not    ////
//// removed from the file and that any derivative24 work24 contains24  ////
//// the original copyright24 notice24 and the associated disclaimer24. ////
////                                                              ////
//// This24 source24 file is free software24; you can redistribute24 it   ////
//// and/or modify it under the terms24 of the GNU24 Lesser24 General24   ////
//// Public24 License24 as published24 by the Free24 Software24 Foundation24; ////
//// either24 version24 2.1 of the License24, or (at your24 option) any   ////
//// later24 version24.                                               ////
////                                                              ////
//// This24 source24 is distributed24 in the hope24 that it will be       ////
//// useful24, but WITHOUT24 ANY24 WARRANTY24; without even24 the implied24   ////
//// warranty24 of MERCHANTABILITY24 or FITNESS24 FOR24 A PARTICULAR24      ////
//// PURPOSE24.  See the GNU24 Lesser24 General24 Public24 License24 for more ////
//// details24.                                                     ////
////                                                              ////
//// You should have received24 a copy of the GNU24 Lesser24 General24    ////
//// Public24 License24 along24 with this source24; if not, download24 it   ////
//// from http24://www24.opencores24.org24/lgpl24.shtml24                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS24 Revision24 History24
//
// $Log: not supported by cvs2svn24 $
// Revision24 1.29  2002/07/29 21:16:18  gorban24
// The uart_defines24.v file is included24 again24 in sources24.
//
// Revision24 1.28  2002/07/22 23:02:23  gorban24
// Bug24 Fixes24:
//  * Possible24 loss of sync and bad24 reception24 of stop bit on slow24 baud24 rates24 fixed24.
//   Problem24 reported24 by Kenny24.Tung24.
//  * Bad (or lack24 of ) loopback24 handling24 fixed24. Reported24 by Cherry24 Withers24.
//
// Improvements24:
//  * Made24 FIFO's as general24 inferrable24 memory where possible24.
//  So24 on FPGA24 they should be inferred24 as RAM24 (Distributed24 RAM24 on Xilinx24).
//  This24 saves24 about24 1/3 of the Slice24 count and reduces24 P&R and synthesis24 times.
//
//  * Added24 optional24 baudrate24 output (baud_o24).
//  This24 is identical24 to BAUDOUT24* signal24 on 16550 chip24.
//  It outputs24 16xbit_clock_rate - the divided24 clock24.
//  It's disabled by default. Define24 UART_HAS_BAUDRATE_OUTPUT24 to use.
//
// Revision24 1.27  2001/12/30 20:39:13  mohor24
// More than one character24 was stored24 in case of break. End24 of the break
// was not detected correctly.
//
// Revision24 1.26  2001/12/20 13:28:27  mohor24
// Missing24 declaration24 of rf_push_q24 fixed24.
//
// Revision24 1.25  2001/12/20 13:25:46  mohor24
// rx24 push24 changed to be only one cycle wide24.
//
// Revision24 1.24  2001/12/19 08:03:34  mohor24
// Warnings24 cleared24.
//
// Revision24 1.23  2001/12/19 07:33:54  mohor24
// Synplicity24 was having24 troubles24 with the comment24.
//
// Revision24 1.22  2001/12/17 14:46:48  mohor24
// overrun24 signal24 was moved to separate24 block because many24 sequential24 lsr24
// reads were24 preventing24 data from being written24 to rx24 fifo.
// underrun24 signal24 was not used and was removed from the project24.
//
// Revision24 1.21  2001/12/13 10:31:16  mohor24
// timeout irq24 must be set regardless24 of the rda24 irq24 (rda24 irq24 does not reset the
// timeout counter).
//
// Revision24 1.20  2001/12/10 19:52:05  gorban24
// Igor24 fixed24 break condition bugs24
//
// Revision24 1.19  2001/12/06 14:51:04  gorban24
// Bug24 in LSR24[0] is fixed24.
// All WISHBONE24 signals24 are now sampled24, so another24 wait-state is introduced24 on all transfers24.
//
// Revision24 1.18  2001/12/03 21:44:29  gorban24
// Updated24 specification24 documentation.
// Added24 full 32-bit data bus interface, now as default.
// Address is 5-bit wide24 in 32-bit data bus mode.
// Added24 wb_sel_i24 input to the core24. It's used in the 32-bit mode.
// Added24 debug24 interface with two24 32-bit read-only registers in 32-bit mode.
// Bits24 5 and 6 of LSR24 are now only cleared24 on TX24 FIFO write.
// My24 small test bench24 is modified to work24 with 32-bit mode.
//
// Revision24 1.17  2001/11/28 19:36:39  gorban24
// Fixed24: timeout and break didn24't pay24 attention24 to current data format24 when counting24 time
//
// Revision24 1.16  2001/11/27 22:17:09  gorban24
// Fixed24 bug24 that prevented24 synthesis24 in uart_receiver24.v
//
// Revision24 1.15  2001/11/26 21:38:54  gorban24
// Lots24 of fixes24:
// Break24 condition wasn24't handled24 correctly at all.
// LSR24 bits could lose24 their24 values.
// LSR24 value after reset was wrong24.
// Timing24 of THRE24 interrupt24 signal24 corrected24.
// LSR24 bit 0 timing24 corrected24.
//
// Revision24 1.14  2001/11/10 12:43:21  gorban24
// Logic24 Synthesis24 bugs24 fixed24. Some24 other minor24 changes24
//
// Revision24 1.13  2001/11/08 14:54:23  mohor24
// Comments24 in Slovene24 language24 deleted24, few24 small fixes24 for better24 work24 of
// old24 tools24. IRQs24 need to be fix24.
//
// Revision24 1.12  2001/11/07 17:51:52  gorban24
// Heavily24 rewritten24 interrupt24 and LSR24 subsystems24.
// Many24 bugs24 hopefully24 squashed24.
//
// Revision24 1.11  2001/10/31 15:19:22  gorban24
// Fixes24 to break and timeout conditions24
//
// Revision24 1.10  2001/10/20 09:58:40  gorban24
// Small24 synopsis24 fixes24
//
// Revision24 1.9  2001/08/24 21:01:12  mohor24
// Things24 connected24 to parity24 changed.
// Clock24 devider24 changed.
//
// Revision24 1.8  2001/08/23 16:05:05  mohor24
// Stop bit bug24 fixed24.
// Parity24 bug24 fixed24.
// WISHBONE24 read cycle bug24 fixed24,
// OE24 indicator24 (Overrun24 Error) bug24 fixed24.
// PE24 indicator24 (Parity24 Error) bug24 fixed24.
// Register read bug24 fixed24.
//
// Revision24 1.6  2001/06/23 11:21:48  gorban24
// DL24 made24 16-bit long24. Fixed24 transmission24/reception24 bugs24.
//
// Revision24 1.5  2001/06/02 14:28:14  gorban24
// Fixed24 receiver24 and transmitter24. Major24 bug24 fixed24.
//
// Revision24 1.4  2001/05/31 20:08:01  gorban24
// FIFO changes24 and other corrections24.
//
// Revision24 1.3  2001/05/27 17:37:49  gorban24
// Fixed24 many24 bugs24. Updated24 spec24. Changed24 FIFO files structure24. See CHANGES24.txt24 file.
//
// Revision24 1.2  2001/05/21 19:12:02  gorban24
// Corrected24 some24 Linter24 messages24.
//
// Revision24 1.1  2001/05/17 18:34:18  gorban24
// First24 'stable' release. Should24 be sythesizable24 now. Also24 added new header.
//
// Revision24 1.0  2001-05-17 21:27:11+02  jacob24
// Initial24 revision24
//
//

// synopsys24 translate_off24
`include "timescale.v"
// synopsys24 translate_on24

`include "uart_defines24.v"

module uart_receiver24 (clk24, wb_rst_i24, lcr24, rf_pop24, srx_pad_i24, enable, 
	counter_t24, rf_count24, rf_data_out24, rf_error_bit24, rf_overrun24, rx_reset24, lsr_mask24, rstate, rf_push_pulse24);

input				clk24;
input				wb_rst_i24;
input	[7:0]	lcr24;
input				rf_pop24;
input				srx_pad_i24;
input				enable;
input				rx_reset24;
input       lsr_mask24;

output	[9:0]			counter_t24;
output	[`UART_FIFO_COUNTER_W24-1:0]	rf_count24;
output	[`UART_FIFO_REC_WIDTH24-1:0]	rf_data_out24;
output				rf_overrun24;
output				rf_error_bit24;
output [3:0] 		rstate;
output 				rf_push_pulse24;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1624;
reg	[2:0]	rbit_counter24;
reg	[7:0]	rshift24;			// receiver24 shift24 register
reg		rparity24;		// received24 parity24
reg		rparity_error24;
reg		rframing_error24;		// framing24 error flag24
reg		rbit_in24;
reg		rparity_xor24;
reg	[7:0]	counter_b24;	// counts24 the 0 (low24) signals24
reg   rf_push_q24;

// RX24 FIFO signals24
reg	[`UART_FIFO_REC_WIDTH24-1:0]	rf_data_in24;
wire	[`UART_FIFO_REC_WIDTH24-1:0]	rf_data_out24;
wire      rf_push_pulse24;
reg				rf_push24;
wire				rf_pop24;
wire				rf_overrun24;
wire	[`UART_FIFO_COUNTER_W24-1:0]	rf_count24;
wire				rf_error_bit24; // an error (parity24 or framing24) is inside the fifo
wire 				break_error24 = (counter_b24 == 0);

// RX24 FIFO instance
uart_rfifo24 #(`UART_FIFO_REC_WIDTH24) fifo_rx24(
	.clk24(		clk24		), 
	.wb_rst_i24(	wb_rst_i24	),
	.data_in24(	rf_data_in24	),
	.data_out24(	rf_data_out24	),
	.push24(		rf_push_pulse24		),
	.pop24(		rf_pop24		),
	.overrun24(	rf_overrun24	),
	.count(		rf_count24	),
	.error_bit24(	rf_error_bit24	),
	.fifo_reset24(	rx_reset24	),
	.reset_status24(lsr_mask24)
);

wire 		rcounter16_eq_724 = (rcounter1624 == 4'd7);
wire		rcounter16_eq_024 = (rcounter1624 == 4'd0);
wire		rcounter16_eq_124 = (rcounter1624 == 4'd1);

wire [3:0] rcounter16_minus_124 = rcounter1624 - 1'b1;

parameter  sr_idle24 					= 4'd0;
parameter  sr_rec_start24 			= 4'd1;
parameter  sr_rec_bit24 				= 4'd2;
parameter  sr_rec_parity24			= 4'd3;
parameter  sr_rec_stop24 				= 4'd4;
parameter  sr_check_parity24 		= 4'd5;
parameter  sr_rec_prepare24 			= 4'd6;
parameter  sr_end_bit24				= 4'd7;
parameter  sr_ca_lc_parity24	      = 4'd8;
parameter  sr_wait124 					= 4'd9;
parameter  sr_push24 					= 4'd10;


always @(posedge clk24 or posedge wb_rst_i24)
begin
  if (wb_rst_i24)
  begin
     rstate 			<= #1 sr_idle24;
	  rbit_in24 				<= #1 1'b0;
	  rcounter1624 			<= #1 0;
	  rbit_counter24 		<= #1 0;
	  rparity_xor24 		<= #1 1'b0;
	  rframing_error24 	<= #1 1'b0;
	  rparity_error24 		<= #1 1'b0;
	  rparity24 				<= #1 1'b0;
	  rshift24 				<= #1 0;
	  rf_push24 				<= #1 1'b0;
	  rf_data_in24 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle24 : begin
			rf_push24 			  <= #1 1'b0;
			rf_data_in24 	  <= #1 0;
			rcounter1624 	  <= #1 4'b1110;
			if (srx_pad_i24==1'b0 & ~break_error24)   // detected a pulse24 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start24;
			end
		end
	sr_rec_start24 :	begin
  			rf_push24 			  <= #1 1'b0;
				if (rcounter16_eq_724)    // check the pulse24
					if (srx_pad_i24==1'b1)   // no start bit
						rstate <= #1 sr_idle24;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare24;
				rcounter1624 <= #1 rcounter16_minus_124;
			end
	sr_rec_prepare24:begin
				case (lcr24[/*`UART_LC_BITS24*/1:0])  // number24 of bits in a word24
				2'b00 : rbit_counter24 <= #1 3'b100;
				2'b01 : rbit_counter24 <= #1 3'b101;
				2'b10 : rbit_counter24 <= #1 3'b110;
				2'b11 : rbit_counter24 <= #1 3'b111;
				endcase
				if (rcounter16_eq_024)
				begin
					rstate		<= #1 sr_rec_bit24;
					rcounter1624	<= #1 4'b1110;
					rshift24		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare24;
				rcounter1624 <= #1 rcounter16_minus_124;
			end
	sr_rec_bit24 :	begin
				if (rcounter16_eq_024)
					rstate <= #1 sr_end_bit24;
				if (rcounter16_eq_724) // read the bit
					case (lcr24[/*`UART_LC_BITS24*/1:0])  // number24 of bits in a word24
					2'b00 : rshift24[4:0]  <= #1 {srx_pad_i24, rshift24[4:1]};
					2'b01 : rshift24[5:0]  <= #1 {srx_pad_i24, rshift24[5:1]};
					2'b10 : rshift24[6:0]  <= #1 {srx_pad_i24, rshift24[6:1]};
					2'b11 : rshift24[7:0]  <= #1 {srx_pad_i24, rshift24[7:1]};
					endcase
				rcounter1624 <= #1 rcounter16_minus_124;
			end
	sr_end_bit24 :   begin
				if (rbit_counter24==3'b0) // no more bits in word24
					if (lcr24[`UART_LC_PE24]) // choose24 state based on parity24
						rstate <= #1 sr_rec_parity24;
					else
					begin
						rstate <= #1 sr_rec_stop24;
						rparity_error24 <= #1 1'b0;  // no parity24 - no error :)
					end
				else		// else we24 have more bits to read
				begin
					rstate <= #1 sr_rec_bit24;
					rbit_counter24 <= #1 rbit_counter24 - 1'b1;
				end
				rcounter1624 <= #1 4'b1110;
			end
	sr_rec_parity24: begin
				if (rcounter16_eq_724)	// read the parity24
				begin
					rparity24 <= #1 srx_pad_i24;
					rstate <= #1 sr_ca_lc_parity24;
				end
				rcounter1624 <= #1 rcounter16_minus_124;
			end
	sr_ca_lc_parity24 : begin    // rcounter24 equals24 6
				rcounter1624  <= #1 rcounter16_minus_124;
				rparity_xor24 <= #1 ^{rshift24,rparity24}; // calculate24 parity24 on all incoming24 data
				rstate      <= #1 sr_check_parity24;
			  end
	sr_check_parity24: begin	  // rcounter24 equals24 5
				case ({lcr24[`UART_LC_EP24],lcr24[`UART_LC_SP24]})
					2'b00: rparity_error24 <= #1  rparity_xor24 == 0;  // no error if parity24 1
					2'b01: rparity_error24 <= #1 ~rparity24;      // parity24 should sticked24 to 1
					2'b10: rparity_error24 <= #1  rparity_xor24 == 1;   // error if parity24 is odd24
					2'b11: rparity_error24 <= #1  rparity24;	  // parity24 should be sticked24 to 0
				endcase
				rcounter1624 <= #1 rcounter16_minus_124;
				rstate <= #1 sr_wait124;
			  end
	sr_wait124 :	if (rcounter16_eq_024)
			begin
				rstate <= #1 sr_rec_stop24;
				rcounter1624 <= #1 4'b1110;
			end
			else
				rcounter1624 <= #1 rcounter16_minus_124;
	sr_rec_stop24 :	begin
				if (rcounter16_eq_724)	// read the parity24
				begin
					rframing_error24 <= #1 !srx_pad_i24; // no framing24 error if input is 1 (stop bit)
					rstate <= #1 sr_push24;
				end
				rcounter1624 <= #1 rcounter16_minus_124;
			end
	sr_push24 :	begin
///////////////////////////////////////
//				$display($time, ": received24: %b", rf_data_in24);
        if(srx_pad_i24 | break_error24)
          begin
            if(break_error24)
        		  rf_data_in24 	<= #1 {8'b0, 3'b100}; // break input (empty24 character24) to receiver24 FIFO
            else
        			rf_data_in24  <= #1 {rshift24, 1'b0, rparity_error24, rframing_error24};
      		  rf_push24 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle24;
          end
        else if(~rframing_error24)  // There's always a framing24 before break_error24 -> wait for break or srx_pad_i24
          begin
       			rf_data_in24  <= #1 {rshift24, 1'b0, rparity_error24, rframing_error24};
      		  rf_push24 		  <= #1 1'b1;
      			rcounter1624 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start24;
          end
                      
			end
	default : rstate <= #1 sr_idle24;
	endcase
  end  // if (enable)
end // always of receiver24

always @ (posedge clk24 or posedge wb_rst_i24)
begin
  if(wb_rst_i24)
    rf_push_q24 <= 0;
  else
    rf_push_q24 <= #1 rf_push24;
end

assign rf_push_pulse24 = rf_push24 & ~rf_push_q24;

  
//
// Break24 condition detection24.
// Works24 in conjuction24 with the receiver24 state machine24

reg 	[9:0]	toc_value24; // value to be set to timeout counter

always @(lcr24)
	case (lcr24[3:0])
		4'b0000										: toc_value24 = 447; // 7 bits
		4'b0100										: toc_value24 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value24 = 511; // 8 bits
		4'b1100										: toc_value24 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value24 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value24 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value24 = 703; // 11 bits
		4'b1111										: toc_value24 = 767; // 12 bits
	endcase // case(lcr24[3:0])

wire [7:0] 	brc_value24; // value to be set to break counter
assign 		brc_value24 = toc_value24[9:2]; // the same as timeout but 1 insead24 of 4 character24 times

always @(posedge clk24 or posedge wb_rst_i24)
begin
	if (wb_rst_i24)
		counter_b24 <= #1 8'd159;
	else
	if (srx_pad_i24)
		counter_b24 <= #1 brc_value24; // character24 time length - 1
	else
	if(enable & counter_b24 != 8'b0)            // only work24 on enable times  break not reached24.
		counter_b24 <= #1 counter_b24 - 1;  // decrement break counter
end // always of break condition detection24

///
/// Timeout24 condition detection24
reg	[9:0]	counter_t24;	// counts24 the timeout condition clocks24

always @(posedge clk24 or posedge wb_rst_i24)
begin
	if (wb_rst_i24)
		counter_t24 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse24 || rf_pop24 || rf_count24 == 0) // counter is reset when RX24 FIFO is empty24, accessed or above24 trigger level
			counter_t24 <= #1 toc_value24;
		else
		if (enable && counter_t24 != 10'b0)  // we24 don24't want24 to underflow24
			counter_t24 <= #1 counter_t24 - 1;		
end
	
endmodule
