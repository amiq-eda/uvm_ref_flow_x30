//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver13.v                                             ////
////                                                              ////
////                                                              ////
////  This13 file is part of the "UART13 16550 compatible13" project13    ////
////  http13://www13.opencores13.org13/cores13/uart1655013/                   ////
////                                                              ////
////  Documentation13 related13 to this project13:                      ////
////  - http13://www13.opencores13.org13/cores13/uart1655013/                 ////
////                                                              ////
////  Projects13 compatibility13:                                     ////
////  - WISHBONE13                                                  ////
////  RS23213 Protocol13                                              ////
////  16550D uart13 (mostly13 supported)                              ////
////                                                              ////
////  Overview13 (main13 Features13):                                   ////
////  UART13 core13 receiver13 logic                                    ////
////                                                              ////
////  Known13 problems13 (limits13):                                    ////
////  None13 known13                                                  ////
////                                                              ////
////  To13 Do13:                                                      ////
////  Thourough13 testing13.                                          ////
////                                                              ////
////  Author13(s):                                                  ////
////      - gorban13@opencores13.org13                                  ////
////      - Jacob13 Gorban13                                          ////
////      - Igor13 Mohor13 (igorm13@opencores13.org13)                      ////
////                                                              ////
////  Created13:        2001/05/12                                  ////
////  Last13 Updated13:   2001/05/17                                  ////
////                  (See log13 for the revision13 history13)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2000, 2001 Authors13                             ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS13 Revision13 History13
//
// $Log: not supported by cvs2svn13 $
// Revision13 1.29  2002/07/29 21:16:18  gorban13
// The uart_defines13.v file is included13 again13 in sources13.
//
// Revision13 1.28  2002/07/22 23:02:23  gorban13
// Bug13 Fixes13:
//  * Possible13 loss of sync and bad13 reception13 of stop bit on slow13 baud13 rates13 fixed13.
//   Problem13 reported13 by Kenny13.Tung13.
//  * Bad (or lack13 of ) loopback13 handling13 fixed13. Reported13 by Cherry13 Withers13.
//
// Improvements13:
//  * Made13 FIFO's as general13 inferrable13 memory where possible13.
//  So13 on FPGA13 they should be inferred13 as RAM13 (Distributed13 RAM13 on Xilinx13).
//  This13 saves13 about13 1/3 of the Slice13 count and reduces13 P&R and synthesis13 times.
//
//  * Added13 optional13 baudrate13 output (baud_o13).
//  This13 is identical13 to BAUDOUT13* signal13 on 16550 chip13.
//  It outputs13 16xbit_clock_rate - the divided13 clock13.
//  It's disabled by default. Define13 UART_HAS_BAUDRATE_OUTPUT13 to use.
//
// Revision13 1.27  2001/12/30 20:39:13  mohor13
// More than one character13 was stored13 in case of break. End13 of the break
// was not detected correctly.
//
// Revision13 1.26  2001/12/20 13:28:27  mohor13
// Missing13 declaration13 of rf_push_q13 fixed13.
//
// Revision13 1.25  2001/12/20 13:25:46  mohor13
// rx13 push13 changed to be only one cycle wide13.
//
// Revision13 1.24  2001/12/19 08:03:34  mohor13
// Warnings13 cleared13.
//
// Revision13 1.23  2001/12/19 07:33:54  mohor13
// Synplicity13 was having13 troubles13 with the comment13.
//
// Revision13 1.22  2001/12/17 14:46:48  mohor13
// overrun13 signal13 was moved to separate13 block because many13 sequential13 lsr13
// reads were13 preventing13 data from being written13 to rx13 fifo.
// underrun13 signal13 was not used and was removed from the project13.
//
// Revision13 1.21  2001/12/13 10:31:16  mohor13
// timeout irq13 must be set regardless13 of the rda13 irq13 (rda13 irq13 does not reset the
// timeout counter).
//
// Revision13 1.20  2001/12/10 19:52:05  gorban13
// Igor13 fixed13 break condition bugs13
//
// Revision13 1.19  2001/12/06 14:51:04  gorban13
// Bug13 in LSR13[0] is fixed13.
// All WISHBONE13 signals13 are now sampled13, so another13 wait-state is introduced13 on all transfers13.
//
// Revision13 1.18  2001/12/03 21:44:29  gorban13
// Updated13 specification13 documentation.
// Added13 full 32-bit data bus interface, now as default.
// Address is 5-bit wide13 in 32-bit data bus mode.
// Added13 wb_sel_i13 input to the core13. It's used in the 32-bit mode.
// Added13 debug13 interface with two13 32-bit read-only registers in 32-bit mode.
// Bits13 5 and 6 of LSR13 are now only cleared13 on TX13 FIFO write.
// My13 small test bench13 is modified to work13 with 32-bit mode.
//
// Revision13 1.17  2001/11/28 19:36:39  gorban13
// Fixed13: timeout and break didn13't pay13 attention13 to current data format13 when counting13 time
//
// Revision13 1.16  2001/11/27 22:17:09  gorban13
// Fixed13 bug13 that prevented13 synthesis13 in uart_receiver13.v
//
// Revision13 1.15  2001/11/26 21:38:54  gorban13
// Lots13 of fixes13:
// Break13 condition wasn13't handled13 correctly at all.
// LSR13 bits could lose13 their13 values.
// LSR13 value after reset was wrong13.
// Timing13 of THRE13 interrupt13 signal13 corrected13.
// LSR13 bit 0 timing13 corrected13.
//
// Revision13 1.14  2001/11/10 12:43:21  gorban13
// Logic13 Synthesis13 bugs13 fixed13. Some13 other minor13 changes13
//
// Revision13 1.13  2001/11/08 14:54:23  mohor13
// Comments13 in Slovene13 language13 deleted13, few13 small fixes13 for better13 work13 of
// old13 tools13. IRQs13 need to be fix13.
//
// Revision13 1.12  2001/11/07 17:51:52  gorban13
// Heavily13 rewritten13 interrupt13 and LSR13 subsystems13.
// Many13 bugs13 hopefully13 squashed13.
//
// Revision13 1.11  2001/10/31 15:19:22  gorban13
// Fixes13 to break and timeout conditions13
//
// Revision13 1.10  2001/10/20 09:58:40  gorban13
// Small13 synopsis13 fixes13
//
// Revision13 1.9  2001/08/24 21:01:12  mohor13
// Things13 connected13 to parity13 changed.
// Clock13 devider13 changed.
//
// Revision13 1.8  2001/08/23 16:05:05  mohor13
// Stop bit bug13 fixed13.
// Parity13 bug13 fixed13.
// WISHBONE13 read cycle bug13 fixed13,
// OE13 indicator13 (Overrun13 Error) bug13 fixed13.
// PE13 indicator13 (Parity13 Error) bug13 fixed13.
// Register read bug13 fixed13.
//
// Revision13 1.6  2001/06/23 11:21:48  gorban13
// DL13 made13 16-bit long13. Fixed13 transmission13/reception13 bugs13.
//
// Revision13 1.5  2001/06/02 14:28:14  gorban13
// Fixed13 receiver13 and transmitter13. Major13 bug13 fixed13.
//
// Revision13 1.4  2001/05/31 20:08:01  gorban13
// FIFO changes13 and other corrections13.
//
// Revision13 1.3  2001/05/27 17:37:49  gorban13
// Fixed13 many13 bugs13. Updated13 spec13. Changed13 FIFO files structure13. See CHANGES13.txt13 file.
//
// Revision13 1.2  2001/05/21 19:12:02  gorban13
// Corrected13 some13 Linter13 messages13.
//
// Revision13 1.1  2001/05/17 18:34:18  gorban13
// First13 'stable' release. Should13 be sythesizable13 now. Also13 added new header.
//
// Revision13 1.0  2001-05-17 21:27:11+02  jacob13
// Initial13 revision13
//
//

// synopsys13 translate_off13
`include "timescale.v"
// synopsys13 translate_on13

`include "uart_defines13.v"

module uart_receiver13 (clk13, wb_rst_i13, lcr13, rf_pop13, srx_pad_i13, enable, 
	counter_t13, rf_count13, rf_data_out13, rf_error_bit13, rf_overrun13, rx_reset13, lsr_mask13, rstate, rf_push_pulse13);

input				clk13;
input				wb_rst_i13;
input	[7:0]	lcr13;
input				rf_pop13;
input				srx_pad_i13;
input				enable;
input				rx_reset13;
input       lsr_mask13;

output	[9:0]			counter_t13;
output	[`UART_FIFO_COUNTER_W13-1:0]	rf_count13;
output	[`UART_FIFO_REC_WIDTH13-1:0]	rf_data_out13;
output				rf_overrun13;
output				rf_error_bit13;
output [3:0] 		rstate;
output 				rf_push_pulse13;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1613;
reg	[2:0]	rbit_counter13;
reg	[7:0]	rshift13;			// receiver13 shift13 register
reg		rparity13;		// received13 parity13
reg		rparity_error13;
reg		rframing_error13;		// framing13 error flag13
reg		rbit_in13;
reg		rparity_xor13;
reg	[7:0]	counter_b13;	// counts13 the 0 (low13) signals13
reg   rf_push_q13;

// RX13 FIFO signals13
reg	[`UART_FIFO_REC_WIDTH13-1:0]	rf_data_in13;
wire	[`UART_FIFO_REC_WIDTH13-1:0]	rf_data_out13;
wire      rf_push_pulse13;
reg				rf_push13;
wire				rf_pop13;
wire				rf_overrun13;
wire	[`UART_FIFO_COUNTER_W13-1:0]	rf_count13;
wire				rf_error_bit13; // an error (parity13 or framing13) is inside the fifo
wire 				break_error13 = (counter_b13 == 0);

// RX13 FIFO instance
uart_rfifo13 #(`UART_FIFO_REC_WIDTH13) fifo_rx13(
	.clk13(		clk13		), 
	.wb_rst_i13(	wb_rst_i13	),
	.data_in13(	rf_data_in13	),
	.data_out13(	rf_data_out13	),
	.push13(		rf_push_pulse13		),
	.pop13(		rf_pop13		),
	.overrun13(	rf_overrun13	),
	.count(		rf_count13	),
	.error_bit13(	rf_error_bit13	),
	.fifo_reset13(	rx_reset13	),
	.reset_status13(lsr_mask13)
);

wire 		rcounter16_eq_713 = (rcounter1613 == 4'd7);
wire		rcounter16_eq_013 = (rcounter1613 == 4'd0);
wire		rcounter16_eq_113 = (rcounter1613 == 4'd1);

wire [3:0] rcounter16_minus_113 = rcounter1613 - 1'b1;

parameter  sr_idle13 					= 4'd0;
parameter  sr_rec_start13 			= 4'd1;
parameter  sr_rec_bit13 				= 4'd2;
parameter  sr_rec_parity13			= 4'd3;
parameter  sr_rec_stop13 				= 4'd4;
parameter  sr_check_parity13 		= 4'd5;
parameter  sr_rec_prepare13 			= 4'd6;
parameter  sr_end_bit13				= 4'd7;
parameter  sr_ca_lc_parity13	      = 4'd8;
parameter  sr_wait113 					= 4'd9;
parameter  sr_push13 					= 4'd10;


always @(posedge clk13 or posedge wb_rst_i13)
begin
  if (wb_rst_i13)
  begin
     rstate 			<= #1 sr_idle13;
	  rbit_in13 				<= #1 1'b0;
	  rcounter1613 			<= #1 0;
	  rbit_counter13 		<= #1 0;
	  rparity_xor13 		<= #1 1'b0;
	  rframing_error13 	<= #1 1'b0;
	  rparity_error13 		<= #1 1'b0;
	  rparity13 				<= #1 1'b0;
	  rshift13 				<= #1 0;
	  rf_push13 				<= #1 1'b0;
	  rf_data_in13 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle13 : begin
			rf_push13 			  <= #1 1'b0;
			rf_data_in13 	  <= #1 0;
			rcounter1613 	  <= #1 4'b1110;
			if (srx_pad_i13==1'b0 & ~break_error13)   // detected a pulse13 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start13;
			end
		end
	sr_rec_start13 :	begin
  			rf_push13 			  <= #1 1'b0;
				if (rcounter16_eq_713)    // check the pulse13
					if (srx_pad_i13==1'b1)   // no start bit
						rstate <= #1 sr_idle13;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare13;
				rcounter1613 <= #1 rcounter16_minus_113;
			end
	sr_rec_prepare13:begin
				case (lcr13[/*`UART_LC_BITS13*/1:0])  // number13 of bits in a word13
				2'b00 : rbit_counter13 <= #1 3'b100;
				2'b01 : rbit_counter13 <= #1 3'b101;
				2'b10 : rbit_counter13 <= #1 3'b110;
				2'b11 : rbit_counter13 <= #1 3'b111;
				endcase
				if (rcounter16_eq_013)
				begin
					rstate		<= #1 sr_rec_bit13;
					rcounter1613	<= #1 4'b1110;
					rshift13		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare13;
				rcounter1613 <= #1 rcounter16_minus_113;
			end
	sr_rec_bit13 :	begin
				if (rcounter16_eq_013)
					rstate <= #1 sr_end_bit13;
				if (rcounter16_eq_713) // read the bit
					case (lcr13[/*`UART_LC_BITS13*/1:0])  // number13 of bits in a word13
					2'b00 : rshift13[4:0]  <= #1 {srx_pad_i13, rshift13[4:1]};
					2'b01 : rshift13[5:0]  <= #1 {srx_pad_i13, rshift13[5:1]};
					2'b10 : rshift13[6:0]  <= #1 {srx_pad_i13, rshift13[6:1]};
					2'b11 : rshift13[7:0]  <= #1 {srx_pad_i13, rshift13[7:1]};
					endcase
				rcounter1613 <= #1 rcounter16_minus_113;
			end
	sr_end_bit13 :   begin
				if (rbit_counter13==3'b0) // no more bits in word13
					if (lcr13[`UART_LC_PE13]) // choose13 state based on parity13
						rstate <= #1 sr_rec_parity13;
					else
					begin
						rstate <= #1 sr_rec_stop13;
						rparity_error13 <= #1 1'b0;  // no parity13 - no error :)
					end
				else		// else we13 have more bits to read
				begin
					rstate <= #1 sr_rec_bit13;
					rbit_counter13 <= #1 rbit_counter13 - 1'b1;
				end
				rcounter1613 <= #1 4'b1110;
			end
	sr_rec_parity13: begin
				if (rcounter16_eq_713)	// read the parity13
				begin
					rparity13 <= #1 srx_pad_i13;
					rstate <= #1 sr_ca_lc_parity13;
				end
				rcounter1613 <= #1 rcounter16_minus_113;
			end
	sr_ca_lc_parity13 : begin    // rcounter13 equals13 6
				rcounter1613  <= #1 rcounter16_minus_113;
				rparity_xor13 <= #1 ^{rshift13,rparity13}; // calculate13 parity13 on all incoming13 data
				rstate      <= #1 sr_check_parity13;
			  end
	sr_check_parity13: begin	  // rcounter13 equals13 5
				case ({lcr13[`UART_LC_EP13],lcr13[`UART_LC_SP13]})
					2'b00: rparity_error13 <= #1  rparity_xor13 == 0;  // no error if parity13 1
					2'b01: rparity_error13 <= #1 ~rparity13;      // parity13 should sticked13 to 1
					2'b10: rparity_error13 <= #1  rparity_xor13 == 1;   // error if parity13 is odd13
					2'b11: rparity_error13 <= #1  rparity13;	  // parity13 should be sticked13 to 0
				endcase
				rcounter1613 <= #1 rcounter16_minus_113;
				rstate <= #1 sr_wait113;
			  end
	sr_wait113 :	if (rcounter16_eq_013)
			begin
				rstate <= #1 sr_rec_stop13;
				rcounter1613 <= #1 4'b1110;
			end
			else
				rcounter1613 <= #1 rcounter16_minus_113;
	sr_rec_stop13 :	begin
				if (rcounter16_eq_713)	// read the parity13
				begin
					rframing_error13 <= #1 !srx_pad_i13; // no framing13 error if input is 1 (stop bit)
					rstate <= #1 sr_push13;
				end
				rcounter1613 <= #1 rcounter16_minus_113;
			end
	sr_push13 :	begin
///////////////////////////////////////
//				$display($time, ": received13: %b", rf_data_in13);
        if(srx_pad_i13 | break_error13)
          begin
            if(break_error13)
        		  rf_data_in13 	<= #1 {8'b0, 3'b100}; // break input (empty13 character13) to receiver13 FIFO
            else
        			rf_data_in13  <= #1 {rshift13, 1'b0, rparity_error13, rframing_error13};
      		  rf_push13 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle13;
          end
        else if(~rframing_error13)  // There's always a framing13 before break_error13 -> wait for break or srx_pad_i13
          begin
       			rf_data_in13  <= #1 {rshift13, 1'b0, rparity_error13, rframing_error13};
      		  rf_push13 		  <= #1 1'b1;
      			rcounter1613 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start13;
          end
                      
			end
	default : rstate <= #1 sr_idle13;
	endcase
  end  // if (enable)
end // always of receiver13

always @ (posedge clk13 or posedge wb_rst_i13)
begin
  if(wb_rst_i13)
    rf_push_q13 <= 0;
  else
    rf_push_q13 <= #1 rf_push13;
end

assign rf_push_pulse13 = rf_push13 & ~rf_push_q13;

  
//
// Break13 condition detection13.
// Works13 in conjuction13 with the receiver13 state machine13

reg 	[9:0]	toc_value13; // value to be set to timeout counter

always @(lcr13)
	case (lcr13[3:0])
		4'b0000										: toc_value13 = 447; // 7 bits
		4'b0100										: toc_value13 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value13 = 511; // 8 bits
		4'b1100										: toc_value13 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value13 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value13 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value13 = 703; // 11 bits
		4'b1111										: toc_value13 = 767; // 12 bits
	endcase // case(lcr13[3:0])

wire [7:0] 	brc_value13; // value to be set to break counter
assign 		brc_value13 = toc_value13[9:2]; // the same as timeout but 1 insead13 of 4 character13 times

always @(posedge clk13 or posedge wb_rst_i13)
begin
	if (wb_rst_i13)
		counter_b13 <= #1 8'd159;
	else
	if (srx_pad_i13)
		counter_b13 <= #1 brc_value13; // character13 time length - 1
	else
	if(enable & counter_b13 != 8'b0)            // only work13 on enable times  break not reached13.
		counter_b13 <= #1 counter_b13 - 1;  // decrement break counter
end // always of break condition detection13

///
/// Timeout13 condition detection13
reg	[9:0]	counter_t13;	// counts13 the timeout condition clocks13

always @(posedge clk13 or posedge wb_rst_i13)
begin
	if (wb_rst_i13)
		counter_t13 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse13 || rf_pop13 || rf_count13 == 0) // counter is reset when RX13 FIFO is empty13, accessed or above13 trigger level
			counter_t13 <= #1 toc_value13;
		else
		if (enable && counter_t13 != 10'b0)  // we13 don13't want13 to underflow13
			counter_t13 <= #1 counter_t13 - 1;		
end
	
endmodule
