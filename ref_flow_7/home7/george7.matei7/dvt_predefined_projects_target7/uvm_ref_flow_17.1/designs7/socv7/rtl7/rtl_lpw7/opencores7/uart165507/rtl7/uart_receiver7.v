//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver7.v                                             ////
////                                                              ////
////                                                              ////
////  This7 file is part of the "UART7 16550 compatible7" project7    ////
////  http7://www7.opencores7.org7/cores7/uart165507/                   ////
////                                                              ////
////  Documentation7 related7 to this project7:                      ////
////  - http7://www7.opencores7.org7/cores7/uart165507/                 ////
////                                                              ////
////  Projects7 compatibility7:                                     ////
////  - WISHBONE7                                                  ////
////  RS2327 Protocol7                                              ////
////  16550D uart7 (mostly7 supported)                              ////
////                                                              ////
////  Overview7 (main7 Features7):                                   ////
////  UART7 core7 receiver7 logic                                    ////
////                                                              ////
////  Known7 problems7 (limits7):                                    ////
////  None7 known7                                                  ////
////                                                              ////
////  To7 Do7:                                                      ////
////  Thourough7 testing7.                                          ////
////                                                              ////
////  Author7(s):                                                  ////
////      - gorban7@opencores7.org7                                  ////
////      - Jacob7 Gorban7                                          ////
////      - Igor7 Mohor7 (igorm7@opencores7.org7)                      ////
////                                                              ////
////  Created7:        2001/05/12                                  ////
////  Last7 Updated7:   2001/05/17                                  ////
////                  (See log7 for the revision7 history7)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2000, 2001 Authors7                             ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS7 Revision7 History7
//
// $Log: not supported by cvs2svn7 $
// Revision7 1.29  2002/07/29 21:16:18  gorban7
// The uart_defines7.v file is included7 again7 in sources7.
//
// Revision7 1.28  2002/07/22 23:02:23  gorban7
// Bug7 Fixes7:
//  * Possible7 loss of sync and bad7 reception7 of stop bit on slow7 baud7 rates7 fixed7.
//   Problem7 reported7 by Kenny7.Tung7.
//  * Bad (or lack7 of ) loopback7 handling7 fixed7. Reported7 by Cherry7 Withers7.
//
// Improvements7:
//  * Made7 FIFO's as general7 inferrable7 memory where possible7.
//  So7 on FPGA7 they should be inferred7 as RAM7 (Distributed7 RAM7 on Xilinx7).
//  This7 saves7 about7 1/3 of the Slice7 count and reduces7 P&R and synthesis7 times.
//
//  * Added7 optional7 baudrate7 output (baud_o7).
//  This7 is identical7 to BAUDOUT7* signal7 on 16550 chip7.
//  It outputs7 16xbit_clock_rate - the divided7 clock7.
//  It's disabled by default. Define7 UART_HAS_BAUDRATE_OUTPUT7 to use.
//
// Revision7 1.27  2001/12/30 20:39:13  mohor7
// More than one character7 was stored7 in case of break. End7 of the break
// was not detected correctly.
//
// Revision7 1.26  2001/12/20 13:28:27  mohor7
// Missing7 declaration7 of rf_push_q7 fixed7.
//
// Revision7 1.25  2001/12/20 13:25:46  mohor7
// rx7 push7 changed to be only one cycle wide7.
//
// Revision7 1.24  2001/12/19 08:03:34  mohor7
// Warnings7 cleared7.
//
// Revision7 1.23  2001/12/19 07:33:54  mohor7
// Synplicity7 was having7 troubles7 with the comment7.
//
// Revision7 1.22  2001/12/17 14:46:48  mohor7
// overrun7 signal7 was moved to separate7 block because many7 sequential7 lsr7
// reads were7 preventing7 data from being written7 to rx7 fifo.
// underrun7 signal7 was not used and was removed from the project7.
//
// Revision7 1.21  2001/12/13 10:31:16  mohor7
// timeout irq7 must be set regardless7 of the rda7 irq7 (rda7 irq7 does not reset the
// timeout counter).
//
// Revision7 1.20  2001/12/10 19:52:05  gorban7
// Igor7 fixed7 break condition bugs7
//
// Revision7 1.19  2001/12/06 14:51:04  gorban7
// Bug7 in LSR7[0] is fixed7.
// All WISHBONE7 signals7 are now sampled7, so another7 wait-state is introduced7 on all transfers7.
//
// Revision7 1.18  2001/12/03 21:44:29  gorban7
// Updated7 specification7 documentation.
// Added7 full 32-bit data bus interface, now as default.
// Address is 5-bit wide7 in 32-bit data bus mode.
// Added7 wb_sel_i7 input to the core7. It's used in the 32-bit mode.
// Added7 debug7 interface with two7 32-bit read-only registers in 32-bit mode.
// Bits7 5 and 6 of LSR7 are now only cleared7 on TX7 FIFO write.
// My7 small test bench7 is modified to work7 with 32-bit mode.
//
// Revision7 1.17  2001/11/28 19:36:39  gorban7
// Fixed7: timeout and break didn7't pay7 attention7 to current data format7 when counting7 time
//
// Revision7 1.16  2001/11/27 22:17:09  gorban7
// Fixed7 bug7 that prevented7 synthesis7 in uart_receiver7.v
//
// Revision7 1.15  2001/11/26 21:38:54  gorban7
// Lots7 of fixes7:
// Break7 condition wasn7't handled7 correctly at all.
// LSR7 bits could lose7 their7 values.
// LSR7 value after reset was wrong7.
// Timing7 of THRE7 interrupt7 signal7 corrected7.
// LSR7 bit 0 timing7 corrected7.
//
// Revision7 1.14  2001/11/10 12:43:21  gorban7
// Logic7 Synthesis7 bugs7 fixed7. Some7 other minor7 changes7
//
// Revision7 1.13  2001/11/08 14:54:23  mohor7
// Comments7 in Slovene7 language7 deleted7, few7 small fixes7 for better7 work7 of
// old7 tools7. IRQs7 need to be fix7.
//
// Revision7 1.12  2001/11/07 17:51:52  gorban7
// Heavily7 rewritten7 interrupt7 and LSR7 subsystems7.
// Many7 bugs7 hopefully7 squashed7.
//
// Revision7 1.11  2001/10/31 15:19:22  gorban7
// Fixes7 to break and timeout conditions7
//
// Revision7 1.10  2001/10/20 09:58:40  gorban7
// Small7 synopsis7 fixes7
//
// Revision7 1.9  2001/08/24 21:01:12  mohor7
// Things7 connected7 to parity7 changed.
// Clock7 devider7 changed.
//
// Revision7 1.8  2001/08/23 16:05:05  mohor7
// Stop bit bug7 fixed7.
// Parity7 bug7 fixed7.
// WISHBONE7 read cycle bug7 fixed7,
// OE7 indicator7 (Overrun7 Error) bug7 fixed7.
// PE7 indicator7 (Parity7 Error) bug7 fixed7.
// Register read bug7 fixed7.
//
// Revision7 1.6  2001/06/23 11:21:48  gorban7
// DL7 made7 16-bit long7. Fixed7 transmission7/reception7 bugs7.
//
// Revision7 1.5  2001/06/02 14:28:14  gorban7
// Fixed7 receiver7 and transmitter7. Major7 bug7 fixed7.
//
// Revision7 1.4  2001/05/31 20:08:01  gorban7
// FIFO changes7 and other corrections7.
//
// Revision7 1.3  2001/05/27 17:37:49  gorban7
// Fixed7 many7 bugs7. Updated7 spec7. Changed7 FIFO files structure7. See CHANGES7.txt7 file.
//
// Revision7 1.2  2001/05/21 19:12:02  gorban7
// Corrected7 some7 Linter7 messages7.
//
// Revision7 1.1  2001/05/17 18:34:18  gorban7
// First7 'stable' release. Should7 be sythesizable7 now. Also7 added new header.
//
// Revision7 1.0  2001-05-17 21:27:11+02  jacob7
// Initial7 revision7
//
//

// synopsys7 translate_off7
`include "timescale.v"
// synopsys7 translate_on7

`include "uart_defines7.v"

module uart_receiver7 (clk7, wb_rst_i7, lcr7, rf_pop7, srx_pad_i7, enable, 
	counter_t7, rf_count7, rf_data_out7, rf_error_bit7, rf_overrun7, rx_reset7, lsr_mask7, rstate, rf_push_pulse7);

input				clk7;
input				wb_rst_i7;
input	[7:0]	lcr7;
input				rf_pop7;
input				srx_pad_i7;
input				enable;
input				rx_reset7;
input       lsr_mask7;

output	[9:0]			counter_t7;
output	[`UART_FIFO_COUNTER_W7-1:0]	rf_count7;
output	[`UART_FIFO_REC_WIDTH7-1:0]	rf_data_out7;
output				rf_overrun7;
output				rf_error_bit7;
output [3:0] 		rstate;
output 				rf_push_pulse7;

reg	[3:0]	rstate;
reg	[3:0]	rcounter167;
reg	[2:0]	rbit_counter7;
reg	[7:0]	rshift7;			// receiver7 shift7 register
reg		rparity7;		// received7 parity7
reg		rparity_error7;
reg		rframing_error7;		// framing7 error flag7
reg		rbit_in7;
reg		rparity_xor7;
reg	[7:0]	counter_b7;	// counts7 the 0 (low7) signals7
reg   rf_push_q7;

// RX7 FIFO signals7
reg	[`UART_FIFO_REC_WIDTH7-1:0]	rf_data_in7;
wire	[`UART_FIFO_REC_WIDTH7-1:0]	rf_data_out7;
wire      rf_push_pulse7;
reg				rf_push7;
wire				rf_pop7;
wire				rf_overrun7;
wire	[`UART_FIFO_COUNTER_W7-1:0]	rf_count7;
wire				rf_error_bit7; // an error (parity7 or framing7) is inside the fifo
wire 				break_error7 = (counter_b7 == 0);

// RX7 FIFO instance
uart_rfifo7 #(`UART_FIFO_REC_WIDTH7) fifo_rx7(
	.clk7(		clk7		), 
	.wb_rst_i7(	wb_rst_i7	),
	.data_in7(	rf_data_in7	),
	.data_out7(	rf_data_out7	),
	.push7(		rf_push_pulse7		),
	.pop7(		rf_pop7		),
	.overrun7(	rf_overrun7	),
	.count(		rf_count7	),
	.error_bit7(	rf_error_bit7	),
	.fifo_reset7(	rx_reset7	),
	.reset_status7(lsr_mask7)
);

wire 		rcounter16_eq_77 = (rcounter167 == 4'd7);
wire		rcounter16_eq_07 = (rcounter167 == 4'd0);
wire		rcounter16_eq_17 = (rcounter167 == 4'd1);

wire [3:0] rcounter16_minus_17 = rcounter167 - 1'b1;

parameter  sr_idle7 					= 4'd0;
parameter  sr_rec_start7 			= 4'd1;
parameter  sr_rec_bit7 				= 4'd2;
parameter  sr_rec_parity7			= 4'd3;
parameter  sr_rec_stop7 				= 4'd4;
parameter  sr_check_parity7 		= 4'd5;
parameter  sr_rec_prepare7 			= 4'd6;
parameter  sr_end_bit7				= 4'd7;
parameter  sr_ca_lc_parity7	      = 4'd8;
parameter  sr_wait17 					= 4'd9;
parameter  sr_push7 					= 4'd10;


always @(posedge clk7 or posedge wb_rst_i7)
begin
  if (wb_rst_i7)
  begin
     rstate 			<= #1 sr_idle7;
	  rbit_in7 				<= #1 1'b0;
	  rcounter167 			<= #1 0;
	  rbit_counter7 		<= #1 0;
	  rparity_xor7 		<= #1 1'b0;
	  rframing_error7 	<= #1 1'b0;
	  rparity_error7 		<= #1 1'b0;
	  rparity7 				<= #1 1'b0;
	  rshift7 				<= #1 0;
	  rf_push7 				<= #1 1'b0;
	  rf_data_in7 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle7 : begin
			rf_push7 			  <= #1 1'b0;
			rf_data_in7 	  <= #1 0;
			rcounter167 	  <= #1 4'b1110;
			if (srx_pad_i7==1'b0 & ~break_error7)   // detected a pulse7 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start7;
			end
		end
	sr_rec_start7 :	begin
  			rf_push7 			  <= #1 1'b0;
				if (rcounter16_eq_77)    // check the pulse7
					if (srx_pad_i7==1'b1)   // no start bit
						rstate <= #1 sr_idle7;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare7;
				rcounter167 <= #1 rcounter16_minus_17;
			end
	sr_rec_prepare7:begin
				case (lcr7[/*`UART_LC_BITS7*/1:0])  // number7 of bits in a word7
				2'b00 : rbit_counter7 <= #1 3'b100;
				2'b01 : rbit_counter7 <= #1 3'b101;
				2'b10 : rbit_counter7 <= #1 3'b110;
				2'b11 : rbit_counter7 <= #1 3'b111;
				endcase
				if (rcounter16_eq_07)
				begin
					rstate		<= #1 sr_rec_bit7;
					rcounter167	<= #1 4'b1110;
					rshift7		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare7;
				rcounter167 <= #1 rcounter16_minus_17;
			end
	sr_rec_bit7 :	begin
				if (rcounter16_eq_07)
					rstate <= #1 sr_end_bit7;
				if (rcounter16_eq_77) // read the bit
					case (lcr7[/*`UART_LC_BITS7*/1:0])  // number7 of bits in a word7
					2'b00 : rshift7[4:0]  <= #1 {srx_pad_i7, rshift7[4:1]};
					2'b01 : rshift7[5:0]  <= #1 {srx_pad_i7, rshift7[5:1]};
					2'b10 : rshift7[6:0]  <= #1 {srx_pad_i7, rshift7[6:1]};
					2'b11 : rshift7[7:0]  <= #1 {srx_pad_i7, rshift7[7:1]};
					endcase
				rcounter167 <= #1 rcounter16_minus_17;
			end
	sr_end_bit7 :   begin
				if (rbit_counter7==3'b0) // no more bits in word7
					if (lcr7[`UART_LC_PE7]) // choose7 state based on parity7
						rstate <= #1 sr_rec_parity7;
					else
					begin
						rstate <= #1 sr_rec_stop7;
						rparity_error7 <= #1 1'b0;  // no parity7 - no error :)
					end
				else		// else we7 have more bits to read
				begin
					rstate <= #1 sr_rec_bit7;
					rbit_counter7 <= #1 rbit_counter7 - 1'b1;
				end
				rcounter167 <= #1 4'b1110;
			end
	sr_rec_parity7: begin
				if (rcounter16_eq_77)	// read the parity7
				begin
					rparity7 <= #1 srx_pad_i7;
					rstate <= #1 sr_ca_lc_parity7;
				end
				rcounter167 <= #1 rcounter16_minus_17;
			end
	sr_ca_lc_parity7 : begin    // rcounter7 equals7 6
				rcounter167  <= #1 rcounter16_minus_17;
				rparity_xor7 <= #1 ^{rshift7,rparity7}; // calculate7 parity7 on all incoming7 data
				rstate      <= #1 sr_check_parity7;
			  end
	sr_check_parity7: begin	  // rcounter7 equals7 5
				case ({lcr7[`UART_LC_EP7],lcr7[`UART_LC_SP7]})
					2'b00: rparity_error7 <= #1  rparity_xor7 == 0;  // no error if parity7 1
					2'b01: rparity_error7 <= #1 ~rparity7;      // parity7 should sticked7 to 1
					2'b10: rparity_error7 <= #1  rparity_xor7 == 1;   // error if parity7 is odd7
					2'b11: rparity_error7 <= #1  rparity7;	  // parity7 should be sticked7 to 0
				endcase
				rcounter167 <= #1 rcounter16_minus_17;
				rstate <= #1 sr_wait17;
			  end
	sr_wait17 :	if (rcounter16_eq_07)
			begin
				rstate <= #1 sr_rec_stop7;
				rcounter167 <= #1 4'b1110;
			end
			else
				rcounter167 <= #1 rcounter16_minus_17;
	sr_rec_stop7 :	begin
				if (rcounter16_eq_77)	// read the parity7
				begin
					rframing_error7 <= #1 !srx_pad_i7; // no framing7 error if input is 1 (stop bit)
					rstate <= #1 sr_push7;
				end
				rcounter167 <= #1 rcounter16_minus_17;
			end
	sr_push7 :	begin
///////////////////////////////////////
//				$display($time, ": received7: %b", rf_data_in7);
        if(srx_pad_i7 | break_error7)
          begin
            if(break_error7)
        		  rf_data_in7 	<= #1 {8'b0, 3'b100}; // break input (empty7 character7) to receiver7 FIFO
            else
        			rf_data_in7  <= #1 {rshift7, 1'b0, rparity_error7, rframing_error7};
      		  rf_push7 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle7;
          end
        else if(~rframing_error7)  // There's always a framing7 before break_error7 -> wait for break or srx_pad_i7
          begin
       			rf_data_in7  <= #1 {rshift7, 1'b0, rparity_error7, rframing_error7};
      		  rf_push7 		  <= #1 1'b1;
      			rcounter167 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start7;
          end
                      
			end
	default : rstate <= #1 sr_idle7;
	endcase
  end  // if (enable)
end // always of receiver7

always @ (posedge clk7 or posedge wb_rst_i7)
begin
  if(wb_rst_i7)
    rf_push_q7 <= 0;
  else
    rf_push_q7 <= #1 rf_push7;
end

assign rf_push_pulse7 = rf_push7 & ~rf_push_q7;

  
//
// Break7 condition detection7.
// Works7 in conjuction7 with the receiver7 state machine7

reg 	[9:0]	toc_value7; // value to be set to timeout counter

always @(lcr7)
	case (lcr7[3:0])
		4'b0000										: toc_value7 = 447; // 7 bits
		4'b0100										: toc_value7 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value7 = 511; // 8 bits
		4'b1100										: toc_value7 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value7 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value7 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value7 = 703; // 11 bits
		4'b1111										: toc_value7 = 767; // 12 bits
	endcase // case(lcr7[3:0])

wire [7:0] 	brc_value7; // value to be set to break counter
assign 		brc_value7 = toc_value7[9:2]; // the same as timeout but 1 insead7 of 4 character7 times

always @(posedge clk7 or posedge wb_rst_i7)
begin
	if (wb_rst_i7)
		counter_b7 <= #1 8'd159;
	else
	if (srx_pad_i7)
		counter_b7 <= #1 brc_value7; // character7 time length - 1
	else
	if(enable & counter_b7 != 8'b0)            // only work7 on enable times  break not reached7.
		counter_b7 <= #1 counter_b7 - 1;  // decrement break counter
end // always of break condition detection7

///
/// Timeout7 condition detection7
reg	[9:0]	counter_t7;	// counts7 the timeout condition clocks7

always @(posedge clk7 or posedge wb_rst_i7)
begin
	if (wb_rst_i7)
		counter_t7 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse7 || rf_pop7 || rf_count7 == 0) // counter is reset when RX7 FIFO is empty7, accessed or above7 trigger level
			counter_t7 <= #1 toc_value7;
		else
		if (enable && counter_t7 != 10'b0)  // we7 don7't want7 to underflow7
			counter_t7 <= #1 counter_t7 - 1;		
end
	
endmodule
