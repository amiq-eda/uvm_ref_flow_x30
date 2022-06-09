//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver3.v                                             ////
////                                                              ////
////                                                              ////
////  This3 file is part of the "UART3 16550 compatible3" project3    ////
////  http3://www3.opencores3.org3/cores3/uart165503/                   ////
////                                                              ////
////  Documentation3 related3 to this project3:                      ////
////  - http3://www3.opencores3.org3/cores3/uart165503/                 ////
////                                                              ////
////  Projects3 compatibility3:                                     ////
////  - WISHBONE3                                                  ////
////  RS2323 Protocol3                                              ////
////  16550D uart3 (mostly3 supported)                              ////
////                                                              ////
////  Overview3 (main3 Features3):                                   ////
////  UART3 core3 receiver3 logic                                    ////
////                                                              ////
////  Known3 problems3 (limits3):                                    ////
////  None3 known3                                                  ////
////                                                              ////
////  To3 Do3:                                                      ////
////  Thourough3 testing3.                                          ////
////                                                              ////
////  Author3(s):                                                  ////
////      - gorban3@opencores3.org3                                  ////
////      - Jacob3 Gorban3                                          ////
////      - Igor3 Mohor3 (igorm3@opencores3.org3)                      ////
////                                                              ////
////  Created3:        2001/05/12                                  ////
////  Last3 Updated3:   2001/05/17                                  ////
////                  (See log3 for the revision3 history3)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2000, 2001 Authors3                             ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS3 Revision3 History3
//
// $Log: not supported by cvs2svn3 $
// Revision3 1.29  2002/07/29 21:16:18  gorban3
// The uart_defines3.v file is included3 again3 in sources3.
//
// Revision3 1.28  2002/07/22 23:02:23  gorban3
// Bug3 Fixes3:
//  * Possible3 loss of sync and bad3 reception3 of stop bit on slow3 baud3 rates3 fixed3.
//   Problem3 reported3 by Kenny3.Tung3.
//  * Bad (or lack3 of ) loopback3 handling3 fixed3. Reported3 by Cherry3 Withers3.
//
// Improvements3:
//  * Made3 FIFO's as general3 inferrable3 memory where possible3.
//  So3 on FPGA3 they should be inferred3 as RAM3 (Distributed3 RAM3 on Xilinx3).
//  This3 saves3 about3 1/3 of the Slice3 count and reduces3 P&R and synthesis3 times.
//
//  * Added3 optional3 baudrate3 output (baud_o3).
//  This3 is identical3 to BAUDOUT3* signal3 on 16550 chip3.
//  It outputs3 16xbit_clock_rate - the divided3 clock3.
//  It's disabled by default. Define3 UART_HAS_BAUDRATE_OUTPUT3 to use.
//
// Revision3 1.27  2001/12/30 20:39:13  mohor3
// More than one character3 was stored3 in case of break. End3 of the break
// was not detected correctly.
//
// Revision3 1.26  2001/12/20 13:28:27  mohor3
// Missing3 declaration3 of rf_push_q3 fixed3.
//
// Revision3 1.25  2001/12/20 13:25:46  mohor3
// rx3 push3 changed to be only one cycle wide3.
//
// Revision3 1.24  2001/12/19 08:03:34  mohor3
// Warnings3 cleared3.
//
// Revision3 1.23  2001/12/19 07:33:54  mohor3
// Synplicity3 was having3 troubles3 with the comment3.
//
// Revision3 1.22  2001/12/17 14:46:48  mohor3
// overrun3 signal3 was moved to separate3 block because many3 sequential3 lsr3
// reads were3 preventing3 data from being written3 to rx3 fifo.
// underrun3 signal3 was not used and was removed from the project3.
//
// Revision3 1.21  2001/12/13 10:31:16  mohor3
// timeout irq3 must be set regardless3 of the rda3 irq3 (rda3 irq3 does not reset the
// timeout counter).
//
// Revision3 1.20  2001/12/10 19:52:05  gorban3
// Igor3 fixed3 break condition bugs3
//
// Revision3 1.19  2001/12/06 14:51:04  gorban3
// Bug3 in LSR3[0] is fixed3.
// All WISHBONE3 signals3 are now sampled3, so another3 wait-state is introduced3 on all transfers3.
//
// Revision3 1.18  2001/12/03 21:44:29  gorban3
// Updated3 specification3 documentation.
// Added3 full 32-bit data bus interface, now as default.
// Address is 5-bit wide3 in 32-bit data bus mode.
// Added3 wb_sel_i3 input to the core3. It's used in the 32-bit mode.
// Added3 debug3 interface with two3 32-bit read-only registers in 32-bit mode.
// Bits3 5 and 6 of LSR3 are now only cleared3 on TX3 FIFO write.
// My3 small test bench3 is modified to work3 with 32-bit mode.
//
// Revision3 1.17  2001/11/28 19:36:39  gorban3
// Fixed3: timeout and break didn3't pay3 attention3 to current data format3 when counting3 time
//
// Revision3 1.16  2001/11/27 22:17:09  gorban3
// Fixed3 bug3 that prevented3 synthesis3 in uart_receiver3.v
//
// Revision3 1.15  2001/11/26 21:38:54  gorban3
// Lots3 of fixes3:
// Break3 condition wasn3't handled3 correctly at all.
// LSR3 bits could lose3 their3 values.
// LSR3 value after reset was wrong3.
// Timing3 of THRE3 interrupt3 signal3 corrected3.
// LSR3 bit 0 timing3 corrected3.
//
// Revision3 1.14  2001/11/10 12:43:21  gorban3
// Logic3 Synthesis3 bugs3 fixed3. Some3 other minor3 changes3
//
// Revision3 1.13  2001/11/08 14:54:23  mohor3
// Comments3 in Slovene3 language3 deleted3, few3 small fixes3 for better3 work3 of
// old3 tools3. IRQs3 need to be fix3.
//
// Revision3 1.12  2001/11/07 17:51:52  gorban3
// Heavily3 rewritten3 interrupt3 and LSR3 subsystems3.
// Many3 bugs3 hopefully3 squashed3.
//
// Revision3 1.11  2001/10/31 15:19:22  gorban3
// Fixes3 to break and timeout conditions3
//
// Revision3 1.10  2001/10/20 09:58:40  gorban3
// Small3 synopsis3 fixes3
//
// Revision3 1.9  2001/08/24 21:01:12  mohor3
// Things3 connected3 to parity3 changed.
// Clock3 devider3 changed.
//
// Revision3 1.8  2001/08/23 16:05:05  mohor3
// Stop bit bug3 fixed3.
// Parity3 bug3 fixed3.
// WISHBONE3 read cycle bug3 fixed3,
// OE3 indicator3 (Overrun3 Error) bug3 fixed3.
// PE3 indicator3 (Parity3 Error) bug3 fixed3.
// Register read bug3 fixed3.
//
// Revision3 1.6  2001/06/23 11:21:48  gorban3
// DL3 made3 16-bit long3. Fixed3 transmission3/reception3 bugs3.
//
// Revision3 1.5  2001/06/02 14:28:14  gorban3
// Fixed3 receiver3 and transmitter3. Major3 bug3 fixed3.
//
// Revision3 1.4  2001/05/31 20:08:01  gorban3
// FIFO changes3 and other corrections3.
//
// Revision3 1.3  2001/05/27 17:37:49  gorban3
// Fixed3 many3 bugs3. Updated3 spec3. Changed3 FIFO files structure3. See CHANGES3.txt3 file.
//
// Revision3 1.2  2001/05/21 19:12:02  gorban3
// Corrected3 some3 Linter3 messages3.
//
// Revision3 1.1  2001/05/17 18:34:18  gorban3
// First3 'stable' release. Should3 be sythesizable3 now. Also3 added new header.
//
// Revision3 1.0  2001-05-17 21:27:11+02  jacob3
// Initial3 revision3
//
//

// synopsys3 translate_off3
`include "timescale.v"
// synopsys3 translate_on3

`include "uart_defines3.v"

module uart_receiver3 (clk3, wb_rst_i3, lcr3, rf_pop3, srx_pad_i3, enable, 
	counter_t3, rf_count3, rf_data_out3, rf_error_bit3, rf_overrun3, rx_reset3, lsr_mask3, rstate, rf_push_pulse3);

input				clk3;
input				wb_rst_i3;
input	[7:0]	lcr3;
input				rf_pop3;
input				srx_pad_i3;
input				enable;
input				rx_reset3;
input       lsr_mask3;

output	[9:0]			counter_t3;
output	[`UART_FIFO_COUNTER_W3-1:0]	rf_count3;
output	[`UART_FIFO_REC_WIDTH3-1:0]	rf_data_out3;
output				rf_overrun3;
output				rf_error_bit3;
output [3:0] 		rstate;
output 				rf_push_pulse3;

reg	[3:0]	rstate;
reg	[3:0]	rcounter163;
reg	[2:0]	rbit_counter3;
reg	[7:0]	rshift3;			// receiver3 shift3 register
reg		rparity3;		// received3 parity3
reg		rparity_error3;
reg		rframing_error3;		// framing3 error flag3
reg		rbit_in3;
reg		rparity_xor3;
reg	[7:0]	counter_b3;	// counts3 the 0 (low3) signals3
reg   rf_push_q3;

// RX3 FIFO signals3
reg	[`UART_FIFO_REC_WIDTH3-1:0]	rf_data_in3;
wire	[`UART_FIFO_REC_WIDTH3-1:0]	rf_data_out3;
wire      rf_push_pulse3;
reg				rf_push3;
wire				rf_pop3;
wire				rf_overrun3;
wire	[`UART_FIFO_COUNTER_W3-1:0]	rf_count3;
wire				rf_error_bit3; // an error (parity3 or framing3) is inside the fifo
wire 				break_error3 = (counter_b3 == 0);

// RX3 FIFO instance
uart_rfifo3 #(`UART_FIFO_REC_WIDTH3) fifo_rx3(
	.clk3(		clk3		), 
	.wb_rst_i3(	wb_rst_i3	),
	.data_in3(	rf_data_in3	),
	.data_out3(	rf_data_out3	),
	.push3(		rf_push_pulse3		),
	.pop3(		rf_pop3		),
	.overrun3(	rf_overrun3	),
	.count(		rf_count3	),
	.error_bit3(	rf_error_bit3	),
	.fifo_reset3(	rx_reset3	),
	.reset_status3(lsr_mask3)
);

wire 		rcounter16_eq_73 = (rcounter163 == 4'd7);
wire		rcounter16_eq_03 = (rcounter163 == 4'd0);
wire		rcounter16_eq_13 = (rcounter163 == 4'd1);

wire [3:0] rcounter16_minus_13 = rcounter163 - 1'b1;

parameter  sr_idle3 					= 4'd0;
parameter  sr_rec_start3 			= 4'd1;
parameter  sr_rec_bit3 				= 4'd2;
parameter  sr_rec_parity3			= 4'd3;
parameter  sr_rec_stop3 				= 4'd4;
parameter  sr_check_parity3 		= 4'd5;
parameter  sr_rec_prepare3 			= 4'd6;
parameter  sr_end_bit3				= 4'd7;
parameter  sr_ca_lc_parity3	      = 4'd8;
parameter  sr_wait13 					= 4'd9;
parameter  sr_push3 					= 4'd10;


always @(posedge clk3 or posedge wb_rst_i3)
begin
  if (wb_rst_i3)
  begin
     rstate 			<= #1 sr_idle3;
	  rbit_in3 				<= #1 1'b0;
	  rcounter163 			<= #1 0;
	  rbit_counter3 		<= #1 0;
	  rparity_xor3 		<= #1 1'b0;
	  rframing_error3 	<= #1 1'b0;
	  rparity_error3 		<= #1 1'b0;
	  rparity3 				<= #1 1'b0;
	  rshift3 				<= #1 0;
	  rf_push3 				<= #1 1'b0;
	  rf_data_in3 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle3 : begin
			rf_push3 			  <= #1 1'b0;
			rf_data_in3 	  <= #1 0;
			rcounter163 	  <= #1 4'b1110;
			if (srx_pad_i3==1'b0 & ~break_error3)   // detected a pulse3 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start3;
			end
		end
	sr_rec_start3 :	begin
  			rf_push3 			  <= #1 1'b0;
				if (rcounter16_eq_73)    // check the pulse3
					if (srx_pad_i3==1'b1)   // no start bit
						rstate <= #1 sr_idle3;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare3;
				rcounter163 <= #1 rcounter16_minus_13;
			end
	sr_rec_prepare3:begin
				case (lcr3[/*`UART_LC_BITS3*/1:0])  // number3 of bits in a word3
				2'b00 : rbit_counter3 <= #1 3'b100;
				2'b01 : rbit_counter3 <= #1 3'b101;
				2'b10 : rbit_counter3 <= #1 3'b110;
				2'b11 : rbit_counter3 <= #1 3'b111;
				endcase
				if (rcounter16_eq_03)
				begin
					rstate		<= #1 sr_rec_bit3;
					rcounter163	<= #1 4'b1110;
					rshift3		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare3;
				rcounter163 <= #1 rcounter16_minus_13;
			end
	sr_rec_bit3 :	begin
				if (rcounter16_eq_03)
					rstate <= #1 sr_end_bit3;
				if (rcounter16_eq_73) // read the bit
					case (lcr3[/*`UART_LC_BITS3*/1:0])  // number3 of bits in a word3
					2'b00 : rshift3[4:0]  <= #1 {srx_pad_i3, rshift3[4:1]};
					2'b01 : rshift3[5:0]  <= #1 {srx_pad_i3, rshift3[5:1]};
					2'b10 : rshift3[6:0]  <= #1 {srx_pad_i3, rshift3[6:1]};
					2'b11 : rshift3[7:0]  <= #1 {srx_pad_i3, rshift3[7:1]};
					endcase
				rcounter163 <= #1 rcounter16_minus_13;
			end
	sr_end_bit3 :   begin
				if (rbit_counter3==3'b0) // no more bits in word3
					if (lcr3[`UART_LC_PE3]) // choose3 state based on parity3
						rstate <= #1 sr_rec_parity3;
					else
					begin
						rstate <= #1 sr_rec_stop3;
						rparity_error3 <= #1 1'b0;  // no parity3 - no error :)
					end
				else		// else we3 have more bits to read
				begin
					rstate <= #1 sr_rec_bit3;
					rbit_counter3 <= #1 rbit_counter3 - 1'b1;
				end
				rcounter163 <= #1 4'b1110;
			end
	sr_rec_parity3: begin
				if (rcounter16_eq_73)	// read the parity3
				begin
					rparity3 <= #1 srx_pad_i3;
					rstate <= #1 sr_ca_lc_parity3;
				end
				rcounter163 <= #1 rcounter16_minus_13;
			end
	sr_ca_lc_parity3 : begin    // rcounter3 equals3 6
				rcounter163  <= #1 rcounter16_minus_13;
				rparity_xor3 <= #1 ^{rshift3,rparity3}; // calculate3 parity3 on all incoming3 data
				rstate      <= #1 sr_check_parity3;
			  end
	sr_check_parity3: begin	  // rcounter3 equals3 5
				case ({lcr3[`UART_LC_EP3],lcr3[`UART_LC_SP3]})
					2'b00: rparity_error3 <= #1  rparity_xor3 == 0;  // no error if parity3 1
					2'b01: rparity_error3 <= #1 ~rparity3;      // parity3 should sticked3 to 1
					2'b10: rparity_error3 <= #1  rparity_xor3 == 1;   // error if parity3 is odd3
					2'b11: rparity_error3 <= #1  rparity3;	  // parity3 should be sticked3 to 0
				endcase
				rcounter163 <= #1 rcounter16_minus_13;
				rstate <= #1 sr_wait13;
			  end
	sr_wait13 :	if (rcounter16_eq_03)
			begin
				rstate <= #1 sr_rec_stop3;
				rcounter163 <= #1 4'b1110;
			end
			else
				rcounter163 <= #1 rcounter16_minus_13;
	sr_rec_stop3 :	begin
				if (rcounter16_eq_73)	// read the parity3
				begin
					rframing_error3 <= #1 !srx_pad_i3; // no framing3 error if input is 1 (stop bit)
					rstate <= #1 sr_push3;
				end
				rcounter163 <= #1 rcounter16_minus_13;
			end
	sr_push3 :	begin
///////////////////////////////////////
//				$display($time, ": received3: %b", rf_data_in3);
        if(srx_pad_i3 | break_error3)
          begin
            if(break_error3)
        		  rf_data_in3 	<= #1 {8'b0, 3'b100}; // break input (empty3 character3) to receiver3 FIFO
            else
        			rf_data_in3  <= #1 {rshift3, 1'b0, rparity_error3, rframing_error3};
      		  rf_push3 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle3;
          end
        else if(~rframing_error3)  // There's always a framing3 before break_error3 -> wait for break or srx_pad_i3
          begin
       			rf_data_in3  <= #1 {rshift3, 1'b0, rparity_error3, rframing_error3};
      		  rf_push3 		  <= #1 1'b1;
      			rcounter163 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start3;
          end
                      
			end
	default : rstate <= #1 sr_idle3;
	endcase
  end  // if (enable)
end // always of receiver3

always @ (posedge clk3 or posedge wb_rst_i3)
begin
  if(wb_rst_i3)
    rf_push_q3 <= 0;
  else
    rf_push_q3 <= #1 rf_push3;
end

assign rf_push_pulse3 = rf_push3 & ~rf_push_q3;

  
//
// Break3 condition detection3.
// Works3 in conjuction3 with the receiver3 state machine3

reg 	[9:0]	toc_value3; // value to be set to timeout counter

always @(lcr3)
	case (lcr3[3:0])
		4'b0000										: toc_value3 = 447; // 7 bits
		4'b0100										: toc_value3 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value3 = 511; // 8 bits
		4'b1100										: toc_value3 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value3 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value3 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value3 = 703; // 11 bits
		4'b1111										: toc_value3 = 767; // 12 bits
	endcase // case(lcr3[3:0])

wire [7:0] 	brc_value3; // value to be set to break counter
assign 		brc_value3 = toc_value3[9:2]; // the same as timeout but 1 insead3 of 4 character3 times

always @(posedge clk3 or posedge wb_rst_i3)
begin
	if (wb_rst_i3)
		counter_b3 <= #1 8'd159;
	else
	if (srx_pad_i3)
		counter_b3 <= #1 brc_value3; // character3 time length - 1
	else
	if(enable & counter_b3 != 8'b0)            // only work3 on enable times  break not reached3.
		counter_b3 <= #1 counter_b3 - 1;  // decrement break counter
end // always of break condition detection3

///
/// Timeout3 condition detection3
reg	[9:0]	counter_t3;	// counts3 the timeout condition clocks3

always @(posedge clk3 or posedge wb_rst_i3)
begin
	if (wb_rst_i3)
		counter_t3 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse3 || rf_pop3 || rf_count3 == 0) // counter is reset when RX3 FIFO is empty3, accessed or above3 trigger level
			counter_t3 <= #1 toc_value3;
		else
		if (enable && counter_t3 != 10'b0)  // we3 don3't want3 to underflow3
			counter_t3 <= #1 counter_t3 - 1;		
end
	
endmodule
