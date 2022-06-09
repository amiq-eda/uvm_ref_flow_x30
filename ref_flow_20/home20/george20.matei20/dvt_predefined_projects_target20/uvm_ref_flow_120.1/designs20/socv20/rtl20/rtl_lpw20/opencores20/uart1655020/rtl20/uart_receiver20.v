//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver20.v                                             ////
////                                                              ////
////                                                              ////
////  This20 file is part of the "UART20 16550 compatible20" project20    ////
////  http20://www20.opencores20.org20/cores20/uart1655020/                   ////
////                                                              ////
////  Documentation20 related20 to this project20:                      ////
////  - http20://www20.opencores20.org20/cores20/uart1655020/                 ////
////                                                              ////
////  Projects20 compatibility20:                                     ////
////  - WISHBONE20                                                  ////
////  RS23220 Protocol20                                              ////
////  16550D uart20 (mostly20 supported)                              ////
////                                                              ////
////  Overview20 (main20 Features20):                                   ////
////  UART20 core20 receiver20 logic                                    ////
////                                                              ////
////  Known20 problems20 (limits20):                                    ////
////  None20 known20                                                  ////
////                                                              ////
////  To20 Do20:                                                      ////
////  Thourough20 testing20.                                          ////
////                                                              ////
////  Author20(s):                                                  ////
////      - gorban20@opencores20.org20                                  ////
////      - Jacob20 Gorban20                                          ////
////      - Igor20 Mohor20 (igorm20@opencores20.org20)                      ////
////                                                              ////
////  Created20:        2001/05/12                                  ////
////  Last20 Updated20:   2001/05/17                                  ////
////                  (See log20 for the revision20 history20)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2000, 2001 Authors20                             ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS20 Revision20 History20
//
// $Log: not supported by cvs2svn20 $
// Revision20 1.29  2002/07/29 21:16:18  gorban20
// The uart_defines20.v file is included20 again20 in sources20.
//
// Revision20 1.28  2002/07/22 23:02:23  gorban20
// Bug20 Fixes20:
//  * Possible20 loss of sync and bad20 reception20 of stop bit on slow20 baud20 rates20 fixed20.
//   Problem20 reported20 by Kenny20.Tung20.
//  * Bad (or lack20 of ) loopback20 handling20 fixed20. Reported20 by Cherry20 Withers20.
//
// Improvements20:
//  * Made20 FIFO's as general20 inferrable20 memory where possible20.
//  So20 on FPGA20 they should be inferred20 as RAM20 (Distributed20 RAM20 on Xilinx20).
//  This20 saves20 about20 1/3 of the Slice20 count and reduces20 P&R and synthesis20 times.
//
//  * Added20 optional20 baudrate20 output (baud_o20).
//  This20 is identical20 to BAUDOUT20* signal20 on 16550 chip20.
//  It outputs20 16xbit_clock_rate - the divided20 clock20.
//  It's disabled by default. Define20 UART_HAS_BAUDRATE_OUTPUT20 to use.
//
// Revision20 1.27  2001/12/30 20:39:13  mohor20
// More than one character20 was stored20 in case of break. End20 of the break
// was not detected correctly.
//
// Revision20 1.26  2001/12/20 13:28:27  mohor20
// Missing20 declaration20 of rf_push_q20 fixed20.
//
// Revision20 1.25  2001/12/20 13:25:46  mohor20
// rx20 push20 changed to be only one cycle wide20.
//
// Revision20 1.24  2001/12/19 08:03:34  mohor20
// Warnings20 cleared20.
//
// Revision20 1.23  2001/12/19 07:33:54  mohor20
// Synplicity20 was having20 troubles20 with the comment20.
//
// Revision20 1.22  2001/12/17 14:46:48  mohor20
// overrun20 signal20 was moved to separate20 block because many20 sequential20 lsr20
// reads were20 preventing20 data from being written20 to rx20 fifo.
// underrun20 signal20 was not used and was removed from the project20.
//
// Revision20 1.21  2001/12/13 10:31:16  mohor20
// timeout irq20 must be set regardless20 of the rda20 irq20 (rda20 irq20 does not reset the
// timeout counter).
//
// Revision20 1.20  2001/12/10 19:52:05  gorban20
// Igor20 fixed20 break condition bugs20
//
// Revision20 1.19  2001/12/06 14:51:04  gorban20
// Bug20 in LSR20[0] is fixed20.
// All WISHBONE20 signals20 are now sampled20, so another20 wait-state is introduced20 on all transfers20.
//
// Revision20 1.18  2001/12/03 21:44:29  gorban20
// Updated20 specification20 documentation.
// Added20 full 32-bit data bus interface, now as default.
// Address is 5-bit wide20 in 32-bit data bus mode.
// Added20 wb_sel_i20 input to the core20. It's used in the 32-bit mode.
// Added20 debug20 interface with two20 32-bit read-only registers in 32-bit mode.
// Bits20 5 and 6 of LSR20 are now only cleared20 on TX20 FIFO write.
// My20 small test bench20 is modified to work20 with 32-bit mode.
//
// Revision20 1.17  2001/11/28 19:36:39  gorban20
// Fixed20: timeout and break didn20't pay20 attention20 to current data format20 when counting20 time
//
// Revision20 1.16  2001/11/27 22:17:09  gorban20
// Fixed20 bug20 that prevented20 synthesis20 in uart_receiver20.v
//
// Revision20 1.15  2001/11/26 21:38:54  gorban20
// Lots20 of fixes20:
// Break20 condition wasn20't handled20 correctly at all.
// LSR20 bits could lose20 their20 values.
// LSR20 value after reset was wrong20.
// Timing20 of THRE20 interrupt20 signal20 corrected20.
// LSR20 bit 0 timing20 corrected20.
//
// Revision20 1.14  2001/11/10 12:43:21  gorban20
// Logic20 Synthesis20 bugs20 fixed20. Some20 other minor20 changes20
//
// Revision20 1.13  2001/11/08 14:54:23  mohor20
// Comments20 in Slovene20 language20 deleted20, few20 small fixes20 for better20 work20 of
// old20 tools20. IRQs20 need to be fix20.
//
// Revision20 1.12  2001/11/07 17:51:52  gorban20
// Heavily20 rewritten20 interrupt20 and LSR20 subsystems20.
// Many20 bugs20 hopefully20 squashed20.
//
// Revision20 1.11  2001/10/31 15:19:22  gorban20
// Fixes20 to break and timeout conditions20
//
// Revision20 1.10  2001/10/20 09:58:40  gorban20
// Small20 synopsis20 fixes20
//
// Revision20 1.9  2001/08/24 21:01:12  mohor20
// Things20 connected20 to parity20 changed.
// Clock20 devider20 changed.
//
// Revision20 1.8  2001/08/23 16:05:05  mohor20
// Stop bit bug20 fixed20.
// Parity20 bug20 fixed20.
// WISHBONE20 read cycle bug20 fixed20,
// OE20 indicator20 (Overrun20 Error) bug20 fixed20.
// PE20 indicator20 (Parity20 Error) bug20 fixed20.
// Register read bug20 fixed20.
//
// Revision20 1.6  2001/06/23 11:21:48  gorban20
// DL20 made20 16-bit long20. Fixed20 transmission20/reception20 bugs20.
//
// Revision20 1.5  2001/06/02 14:28:14  gorban20
// Fixed20 receiver20 and transmitter20. Major20 bug20 fixed20.
//
// Revision20 1.4  2001/05/31 20:08:01  gorban20
// FIFO changes20 and other corrections20.
//
// Revision20 1.3  2001/05/27 17:37:49  gorban20
// Fixed20 many20 bugs20. Updated20 spec20. Changed20 FIFO files structure20. See CHANGES20.txt20 file.
//
// Revision20 1.2  2001/05/21 19:12:02  gorban20
// Corrected20 some20 Linter20 messages20.
//
// Revision20 1.1  2001/05/17 18:34:18  gorban20
// First20 'stable' release. Should20 be sythesizable20 now. Also20 added new header.
//
// Revision20 1.0  2001-05-17 21:27:11+02  jacob20
// Initial20 revision20
//
//

// synopsys20 translate_off20
`include "timescale.v"
// synopsys20 translate_on20

`include "uart_defines20.v"

module uart_receiver20 (clk20, wb_rst_i20, lcr20, rf_pop20, srx_pad_i20, enable, 
	counter_t20, rf_count20, rf_data_out20, rf_error_bit20, rf_overrun20, rx_reset20, lsr_mask20, rstate, rf_push_pulse20);

input				clk20;
input				wb_rst_i20;
input	[7:0]	lcr20;
input				rf_pop20;
input				srx_pad_i20;
input				enable;
input				rx_reset20;
input       lsr_mask20;

output	[9:0]			counter_t20;
output	[`UART_FIFO_COUNTER_W20-1:0]	rf_count20;
output	[`UART_FIFO_REC_WIDTH20-1:0]	rf_data_out20;
output				rf_overrun20;
output				rf_error_bit20;
output [3:0] 		rstate;
output 				rf_push_pulse20;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1620;
reg	[2:0]	rbit_counter20;
reg	[7:0]	rshift20;			// receiver20 shift20 register
reg		rparity20;		// received20 parity20
reg		rparity_error20;
reg		rframing_error20;		// framing20 error flag20
reg		rbit_in20;
reg		rparity_xor20;
reg	[7:0]	counter_b20;	// counts20 the 0 (low20) signals20
reg   rf_push_q20;

// RX20 FIFO signals20
reg	[`UART_FIFO_REC_WIDTH20-1:0]	rf_data_in20;
wire	[`UART_FIFO_REC_WIDTH20-1:0]	rf_data_out20;
wire      rf_push_pulse20;
reg				rf_push20;
wire				rf_pop20;
wire				rf_overrun20;
wire	[`UART_FIFO_COUNTER_W20-1:0]	rf_count20;
wire				rf_error_bit20; // an error (parity20 or framing20) is inside the fifo
wire 				break_error20 = (counter_b20 == 0);

// RX20 FIFO instance
uart_rfifo20 #(`UART_FIFO_REC_WIDTH20) fifo_rx20(
	.clk20(		clk20		), 
	.wb_rst_i20(	wb_rst_i20	),
	.data_in20(	rf_data_in20	),
	.data_out20(	rf_data_out20	),
	.push20(		rf_push_pulse20		),
	.pop20(		rf_pop20		),
	.overrun20(	rf_overrun20	),
	.count(		rf_count20	),
	.error_bit20(	rf_error_bit20	),
	.fifo_reset20(	rx_reset20	),
	.reset_status20(lsr_mask20)
);

wire 		rcounter16_eq_720 = (rcounter1620 == 4'd7);
wire		rcounter16_eq_020 = (rcounter1620 == 4'd0);
wire		rcounter16_eq_120 = (rcounter1620 == 4'd1);

wire [3:0] rcounter16_minus_120 = rcounter1620 - 1'b1;

parameter  sr_idle20 					= 4'd0;
parameter  sr_rec_start20 			= 4'd1;
parameter  sr_rec_bit20 				= 4'd2;
parameter  sr_rec_parity20			= 4'd3;
parameter  sr_rec_stop20 				= 4'd4;
parameter  sr_check_parity20 		= 4'd5;
parameter  sr_rec_prepare20 			= 4'd6;
parameter  sr_end_bit20				= 4'd7;
parameter  sr_ca_lc_parity20	      = 4'd8;
parameter  sr_wait120 					= 4'd9;
parameter  sr_push20 					= 4'd10;


always @(posedge clk20 or posedge wb_rst_i20)
begin
  if (wb_rst_i20)
  begin
     rstate 			<= #1 sr_idle20;
	  rbit_in20 				<= #1 1'b0;
	  rcounter1620 			<= #1 0;
	  rbit_counter20 		<= #1 0;
	  rparity_xor20 		<= #1 1'b0;
	  rframing_error20 	<= #1 1'b0;
	  rparity_error20 		<= #1 1'b0;
	  rparity20 				<= #1 1'b0;
	  rshift20 				<= #1 0;
	  rf_push20 				<= #1 1'b0;
	  rf_data_in20 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle20 : begin
			rf_push20 			  <= #1 1'b0;
			rf_data_in20 	  <= #1 0;
			rcounter1620 	  <= #1 4'b1110;
			if (srx_pad_i20==1'b0 & ~break_error20)   // detected a pulse20 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start20;
			end
		end
	sr_rec_start20 :	begin
  			rf_push20 			  <= #1 1'b0;
				if (rcounter16_eq_720)    // check the pulse20
					if (srx_pad_i20==1'b1)   // no start bit
						rstate <= #1 sr_idle20;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare20;
				rcounter1620 <= #1 rcounter16_minus_120;
			end
	sr_rec_prepare20:begin
				case (lcr20[/*`UART_LC_BITS20*/1:0])  // number20 of bits in a word20
				2'b00 : rbit_counter20 <= #1 3'b100;
				2'b01 : rbit_counter20 <= #1 3'b101;
				2'b10 : rbit_counter20 <= #1 3'b110;
				2'b11 : rbit_counter20 <= #1 3'b111;
				endcase
				if (rcounter16_eq_020)
				begin
					rstate		<= #1 sr_rec_bit20;
					rcounter1620	<= #1 4'b1110;
					rshift20		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare20;
				rcounter1620 <= #1 rcounter16_minus_120;
			end
	sr_rec_bit20 :	begin
				if (rcounter16_eq_020)
					rstate <= #1 sr_end_bit20;
				if (rcounter16_eq_720) // read the bit
					case (lcr20[/*`UART_LC_BITS20*/1:0])  // number20 of bits in a word20
					2'b00 : rshift20[4:0]  <= #1 {srx_pad_i20, rshift20[4:1]};
					2'b01 : rshift20[5:0]  <= #1 {srx_pad_i20, rshift20[5:1]};
					2'b10 : rshift20[6:0]  <= #1 {srx_pad_i20, rshift20[6:1]};
					2'b11 : rshift20[7:0]  <= #1 {srx_pad_i20, rshift20[7:1]};
					endcase
				rcounter1620 <= #1 rcounter16_minus_120;
			end
	sr_end_bit20 :   begin
				if (rbit_counter20==3'b0) // no more bits in word20
					if (lcr20[`UART_LC_PE20]) // choose20 state based on parity20
						rstate <= #1 sr_rec_parity20;
					else
					begin
						rstate <= #1 sr_rec_stop20;
						rparity_error20 <= #1 1'b0;  // no parity20 - no error :)
					end
				else		// else we20 have more bits to read
				begin
					rstate <= #1 sr_rec_bit20;
					rbit_counter20 <= #1 rbit_counter20 - 1'b1;
				end
				rcounter1620 <= #1 4'b1110;
			end
	sr_rec_parity20: begin
				if (rcounter16_eq_720)	// read the parity20
				begin
					rparity20 <= #1 srx_pad_i20;
					rstate <= #1 sr_ca_lc_parity20;
				end
				rcounter1620 <= #1 rcounter16_minus_120;
			end
	sr_ca_lc_parity20 : begin    // rcounter20 equals20 6
				rcounter1620  <= #1 rcounter16_minus_120;
				rparity_xor20 <= #1 ^{rshift20,rparity20}; // calculate20 parity20 on all incoming20 data
				rstate      <= #1 sr_check_parity20;
			  end
	sr_check_parity20: begin	  // rcounter20 equals20 5
				case ({lcr20[`UART_LC_EP20],lcr20[`UART_LC_SP20]})
					2'b00: rparity_error20 <= #1  rparity_xor20 == 0;  // no error if parity20 1
					2'b01: rparity_error20 <= #1 ~rparity20;      // parity20 should sticked20 to 1
					2'b10: rparity_error20 <= #1  rparity_xor20 == 1;   // error if parity20 is odd20
					2'b11: rparity_error20 <= #1  rparity20;	  // parity20 should be sticked20 to 0
				endcase
				rcounter1620 <= #1 rcounter16_minus_120;
				rstate <= #1 sr_wait120;
			  end
	sr_wait120 :	if (rcounter16_eq_020)
			begin
				rstate <= #1 sr_rec_stop20;
				rcounter1620 <= #1 4'b1110;
			end
			else
				rcounter1620 <= #1 rcounter16_minus_120;
	sr_rec_stop20 :	begin
				if (rcounter16_eq_720)	// read the parity20
				begin
					rframing_error20 <= #1 !srx_pad_i20; // no framing20 error if input is 1 (stop bit)
					rstate <= #1 sr_push20;
				end
				rcounter1620 <= #1 rcounter16_minus_120;
			end
	sr_push20 :	begin
///////////////////////////////////////
//				$display($time, ": received20: %b", rf_data_in20);
        if(srx_pad_i20 | break_error20)
          begin
            if(break_error20)
        		  rf_data_in20 	<= #1 {8'b0, 3'b100}; // break input (empty20 character20) to receiver20 FIFO
            else
        			rf_data_in20  <= #1 {rshift20, 1'b0, rparity_error20, rframing_error20};
      		  rf_push20 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle20;
          end
        else if(~rframing_error20)  // There's always a framing20 before break_error20 -> wait for break or srx_pad_i20
          begin
       			rf_data_in20  <= #1 {rshift20, 1'b0, rparity_error20, rframing_error20};
      		  rf_push20 		  <= #1 1'b1;
      			rcounter1620 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start20;
          end
                      
			end
	default : rstate <= #1 sr_idle20;
	endcase
  end  // if (enable)
end // always of receiver20

always @ (posedge clk20 or posedge wb_rst_i20)
begin
  if(wb_rst_i20)
    rf_push_q20 <= 0;
  else
    rf_push_q20 <= #1 rf_push20;
end

assign rf_push_pulse20 = rf_push20 & ~rf_push_q20;

  
//
// Break20 condition detection20.
// Works20 in conjuction20 with the receiver20 state machine20

reg 	[9:0]	toc_value20; // value to be set to timeout counter

always @(lcr20)
	case (lcr20[3:0])
		4'b0000										: toc_value20 = 447; // 7 bits
		4'b0100										: toc_value20 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value20 = 511; // 8 bits
		4'b1100										: toc_value20 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value20 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value20 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value20 = 703; // 11 bits
		4'b1111										: toc_value20 = 767; // 12 bits
	endcase // case(lcr20[3:0])

wire [7:0] 	brc_value20; // value to be set to break counter
assign 		brc_value20 = toc_value20[9:2]; // the same as timeout but 1 insead20 of 4 character20 times

always @(posedge clk20 or posedge wb_rst_i20)
begin
	if (wb_rst_i20)
		counter_b20 <= #1 8'd159;
	else
	if (srx_pad_i20)
		counter_b20 <= #1 brc_value20; // character20 time length - 1
	else
	if(enable & counter_b20 != 8'b0)            // only work20 on enable times  break not reached20.
		counter_b20 <= #1 counter_b20 - 1;  // decrement break counter
end // always of break condition detection20

///
/// Timeout20 condition detection20
reg	[9:0]	counter_t20;	// counts20 the timeout condition clocks20

always @(posedge clk20 or posedge wb_rst_i20)
begin
	if (wb_rst_i20)
		counter_t20 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse20 || rf_pop20 || rf_count20 == 0) // counter is reset when RX20 FIFO is empty20, accessed or above20 trigger level
			counter_t20 <= #1 toc_value20;
		else
		if (enable && counter_t20 != 10'b0)  // we20 don20't want20 to underflow20
			counter_t20 <= #1 counter_t20 - 1;		
end
	
endmodule
