//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver30.v                                             ////
////                                                              ////
////                                                              ////
////  This30 file is part of the "UART30 16550 compatible30" project30    ////
////  http30://www30.opencores30.org30/cores30/uart1655030/                   ////
////                                                              ////
////  Documentation30 related30 to this project30:                      ////
////  - http30://www30.opencores30.org30/cores30/uart1655030/                 ////
////                                                              ////
////  Projects30 compatibility30:                                     ////
////  - WISHBONE30                                                  ////
////  RS23230 Protocol30                                              ////
////  16550D uart30 (mostly30 supported)                              ////
////                                                              ////
////  Overview30 (main30 Features30):                                   ////
////  UART30 core30 receiver30 logic                                    ////
////                                                              ////
////  Known30 problems30 (limits30):                                    ////
////  None30 known30                                                  ////
////                                                              ////
////  To30 Do30:                                                      ////
////  Thourough30 testing30.                                          ////
////                                                              ////
////  Author30(s):                                                  ////
////      - gorban30@opencores30.org30                                  ////
////      - Jacob30 Gorban30                                          ////
////      - Igor30 Mohor30 (igorm30@opencores30.org30)                      ////
////                                                              ////
////  Created30:        2001/05/12                                  ////
////  Last30 Updated30:   2001/05/17                                  ////
////                  (See log30 for the revision30 history30)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2000, 2001 Authors30                             ////
////                                                              ////
//// This30 source30 file may be used and distributed30 without         ////
//// restriction30 provided that this copyright30 statement30 is not    ////
//// removed from the file and that any derivative30 work30 contains30  ////
//// the original copyright30 notice30 and the associated disclaimer30. ////
////                                                              ////
//// This30 source30 file is free software30; you can redistribute30 it   ////
//// and/or modify it under the terms30 of the GNU30 Lesser30 General30   ////
//// Public30 License30 as published30 by the Free30 Software30 Foundation30; ////
//// either30 version30 2.1 of the License30, or (at your30 option) any   ////
//// later30 version30.                                               ////
////                                                              ////
//// This30 source30 is distributed30 in the hope30 that it will be       ////
//// useful30, but WITHOUT30 ANY30 WARRANTY30; without even30 the implied30   ////
//// warranty30 of MERCHANTABILITY30 or FITNESS30 FOR30 A PARTICULAR30      ////
//// PURPOSE30.  See the GNU30 Lesser30 General30 Public30 License30 for more ////
//// details30.                                                     ////
////                                                              ////
//// You should have received30 a copy of the GNU30 Lesser30 General30    ////
//// Public30 License30 along30 with this source30; if not, download30 it   ////
//// from http30://www30.opencores30.org30/lgpl30.shtml30                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS30 Revision30 History30
//
// $Log: not supported by cvs2svn30 $
// Revision30 1.29  2002/07/29 21:16:18  gorban30
// The uart_defines30.v file is included30 again30 in sources30.
//
// Revision30 1.28  2002/07/22 23:02:23  gorban30
// Bug30 Fixes30:
//  * Possible30 loss of sync and bad30 reception30 of stop bit on slow30 baud30 rates30 fixed30.
//   Problem30 reported30 by Kenny30.Tung30.
//  * Bad (or lack30 of ) loopback30 handling30 fixed30. Reported30 by Cherry30 Withers30.
//
// Improvements30:
//  * Made30 FIFO's as general30 inferrable30 memory where possible30.
//  So30 on FPGA30 they should be inferred30 as RAM30 (Distributed30 RAM30 on Xilinx30).
//  This30 saves30 about30 1/3 of the Slice30 count and reduces30 P&R and synthesis30 times.
//
//  * Added30 optional30 baudrate30 output (baud_o30).
//  This30 is identical30 to BAUDOUT30* signal30 on 16550 chip30.
//  It outputs30 16xbit_clock_rate - the divided30 clock30.
//  It's disabled by default. Define30 UART_HAS_BAUDRATE_OUTPUT30 to use.
//
// Revision30 1.27  2001/12/30 20:39:13  mohor30
// More than one character30 was stored30 in case of break. End30 of the break
// was not detected correctly.
//
// Revision30 1.26  2001/12/20 13:28:27  mohor30
// Missing30 declaration30 of rf_push_q30 fixed30.
//
// Revision30 1.25  2001/12/20 13:25:46  mohor30
// rx30 push30 changed to be only one cycle wide30.
//
// Revision30 1.24  2001/12/19 08:03:34  mohor30
// Warnings30 cleared30.
//
// Revision30 1.23  2001/12/19 07:33:54  mohor30
// Synplicity30 was having30 troubles30 with the comment30.
//
// Revision30 1.22  2001/12/17 14:46:48  mohor30
// overrun30 signal30 was moved to separate30 block because many30 sequential30 lsr30
// reads were30 preventing30 data from being written30 to rx30 fifo.
// underrun30 signal30 was not used and was removed from the project30.
//
// Revision30 1.21  2001/12/13 10:31:16  mohor30
// timeout irq30 must be set regardless30 of the rda30 irq30 (rda30 irq30 does not reset the
// timeout counter).
//
// Revision30 1.20  2001/12/10 19:52:05  gorban30
// Igor30 fixed30 break condition bugs30
//
// Revision30 1.19  2001/12/06 14:51:04  gorban30
// Bug30 in LSR30[0] is fixed30.
// All WISHBONE30 signals30 are now sampled30, so another30 wait-state is introduced30 on all transfers30.
//
// Revision30 1.18  2001/12/03 21:44:29  gorban30
// Updated30 specification30 documentation.
// Added30 full 32-bit data bus interface, now as default.
// Address is 5-bit wide30 in 32-bit data bus mode.
// Added30 wb_sel_i30 input to the core30. It's used in the 32-bit mode.
// Added30 debug30 interface with two30 32-bit read-only registers in 32-bit mode.
// Bits30 5 and 6 of LSR30 are now only cleared30 on TX30 FIFO write.
// My30 small test bench30 is modified to work30 with 32-bit mode.
//
// Revision30 1.17  2001/11/28 19:36:39  gorban30
// Fixed30: timeout and break didn30't pay30 attention30 to current data format30 when counting30 time
//
// Revision30 1.16  2001/11/27 22:17:09  gorban30
// Fixed30 bug30 that prevented30 synthesis30 in uart_receiver30.v
//
// Revision30 1.15  2001/11/26 21:38:54  gorban30
// Lots30 of fixes30:
// Break30 condition wasn30't handled30 correctly at all.
// LSR30 bits could lose30 their30 values.
// LSR30 value after reset was wrong30.
// Timing30 of THRE30 interrupt30 signal30 corrected30.
// LSR30 bit 0 timing30 corrected30.
//
// Revision30 1.14  2001/11/10 12:43:21  gorban30
// Logic30 Synthesis30 bugs30 fixed30. Some30 other minor30 changes30
//
// Revision30 1.13  2001/11/08 14:54:23  mohor30
// Comments30 in Slovene30 language30 deleted30, few30 small fixes30 for better30 work30 of
// old30 tools30. IRQs30 need to be fix30.
//
// Revision30 1.12  2001/11/07 17:51:52  gorban30
// Heavily30 rewritten30 interrupt30 and LSR30 subsystems30.
// Many30 bugs30 hopefully30 squashed30.
//
// Revision30 1.11  2001/10/31 15:19:22  gorban30
// Fixes30 to break and timeout conditions30
//
// Revision30 1.10  2001/10/20 09:58:40  gorban30
// Small30 synopsis30 fixes30
//
// Revision30 1.9  2001/08/24 21:01:12  mohor30
// Things30 connected30 to parity30 changed.
// Clock30 devider30 changed.
//
// Revision30 1.8  2001/08/23 16:05:05  mohor30
// Stop bit bug30 fixed30.
// Parity30 bug30 fixed30.
// WISHBONE30 read cycle bug30 fixed30,
// OE30 indicator30 (Overrun30 Error) bug30 fixed30.
// PE30 indicator30 (Parity30 Error) bug30 fixed30.
// Register read bug30 fixed30.
//
// Revision30 1.6  2001/06/23 11:21:48  gorban30
// DL30 made30 16-bit long30. Fixed30 transmission30/reception30 bugs30.
//
// Revision30 1.5  2001/06/02 14:28:14  gorban30
// Fixed30 receiver30 and transmitter30. Major30 bug30 fixed30.
//
// Revision30 1.4  2001/05/31 20:08:01  gorban30
// FIFO changes30 and other corrections30.
//
// Revision30 1.3  2001/05/27 17:37:49  gorban30
// Fixed30 many30 bugs30. Updated30 spec30. Changed30 FIFO files structure30. See CHANGES30.txt30 file.
//
// Revision30 1.2  2001/05/21 19:12:02  gorban30
// Corrected30 some30 Linter30 messages30.
//
// Revision30 1.1  2001/05/17 18:34:18  gorban30
// First30 'stable' release. Should30 be sythesizable30 now. Also30 added new header.
//
// Revision30 1.0  2001-05-17 21:27:11+02  jacob30
// Initial30 revision30
//
//

// synopsys30 translate_off30
`include "timescale.v"
// synopsys30 translate_on30

`include "uart_defines30.v"

module uart_receiver30 (clk30, wb_rst_i30, lcr30, rf_pop30, srx_pad_i30, enable, 
	counter_t30, rf_count30, rf_data_out30, rf_error_bit30, rf_overrun30, rx_reset30, lsr_mask30, rstate, rf_push_pulse30);

input				clk30;
input				wb_rst_i30;
input	[7:0]	lcr30;
input				rf_pop30;
input				srx_pad_i30;
input				enable;
input				rx_reset30;
input       lsr_mask30;

output	[9:0]			counter_t30;
output	[`UART_FIFO_COUNTER_W30-1:0]	rf_count30;
output	[`UART_FIFO_REC_WIDTH30-1:0]	rf_data_out30;
output				rf_overrun30;
output				rf_error_bit30;
output [3:0] 		rstate;
output 				rf_push_pulse30;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1630;
reg	[2:0]	rbit_counter30;
reg	[7:0]	rshift30;			// receiver30 shift30 register
reg		rparity30;		// received30 parity30
reg		rparity_error30;
reg		rframing_error30;		// framing30 error flag30
reg		rbit_in30;
reg		rparity_xor30;
reg	[7:0]	counter_b30;	// counts30 the 0 (low30) signals30
reg   rf_push_q30;

// RX30 FIFO signals30
reg	[`UART_FIFO_REC_WIDTH30-1:0]	rf_data_in30;
wire	[`UART_FIFO_REC_WIDTH30-1:0]	rf_data_out30;
wire      rf_push_pulse30;
reg				rf_push30;
wire				rf_pop30;
wire				rf_overrun30;
wire	[`UART_FIFO_COUNTER_W30-1:0]	rf_count30;
wire				rf_error_bit30; // an error (parity30 or framing30) is inside the fifo
wire 				break_error30 = (counter_b30 == 0);

// RX30 FIFO instance
uart_rfifo30 #(`UART_FIFO_REC_WIDTH30) fifo_rx30(
	.clk30(		clk30		), 
	.wb_rst_i30(	wb_rst_i30	),
	.data_in30(	rf_data_in30	),
	.data_out30(	rf_data_out30	),
	.push30(		rf_push_pulse30		),
	.pop30(		rf_pop30		),
	.overrun30(	rf_overrun30	),
	.count(		rf_count30	),
	.error_bit30(	rf_error_bit30	),
	.fifo_reset30(	rx_reset30	),
	.reset_status30(lsr_mask30)
);

wire 		rcounter16_eq_730 = (rcounter1630 == 4'd7);
wire		rcounter16_eq_030 = (rcounter1630 == 4'd0);
wire		rcounter16_eq_130 = (rcounter1630 == 4'd1);

wire [3:0] rcounter16_minus_130 = rcounter1630 - 1'b1;

parameter  sr_idle30 					= 4'd0;
parameter  sr_rec_start30 			= 4'd1;
parameter  sr_rec_bit30 				= 4'd2;
parameter  sr_rec_parity30			= 4'd3;
parameter  sr_rec_stop30 				= 4'd4;
parameter  sr_check_parity30 		= 4'd5;
parameter  sr_rec_prepare30 			= 4'd6;
parameter  sr_end_bit30				= 4'd7;
parameter  sr_ca_lc_parity30	      = 4'd8;
parameter  sr_wait130 					= 4'd9;
parameter  sr_push30 					= 4'd10;


always @(posedge clk30 or posedge wb_rst_i30)
begin
  if (wb_rst_i30)
  begin
     rstate 			<= #1 sr_idle30;
	  rbit_in30 				<= #1 1'b0;
	  rcounter1630 			<= #1 0;
	  rbit_counter30 		<= #1 0;
	  rparity_xor30 		<= #1 1'b0;
	  rframing_error30 	<= #1 1'b0;
	  rparity_error30 		<= #1 1'b0;
	  rparity30 				<= #1 1'b0;
	  rshift30 				<= #1 0;
	  rf_push30 				<= #1 1'b0;
	  rf_data_in30 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle30 : begin
			rf_push30 			  <= #1 1'b0;
			rf_data_in30 	  <= #1 0;
			rcounter1630 	  <= #1 4'b1110;
			if (srx_pad_i30==1'b0 & ~break_error30)   // detected a pulse30 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start30;
			end
		end
	sr_rec_start30 :	begin
  			rf_push30 			  <= #1 1'b0;
				if (rcounter16_eq_730)    // check the pulse30
					if (srx_pad_i30==1'b1)   // no start bit
						rstate <= #1 sr_idle30;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare30;
				rcounter1630 <= #1 rcounter16_minus_130;
			end
	sr_rec_prepare30:begin
				case (lcr30[/*`UART_LC_BITS30*/1:0])  // number30 of bits in a word30
				2'b00 : rbit_counter30 <= #1 3'b100;
				2'b01 : rbit_counter30 <= #1 3'b101;
				2'b10 : rbit_counter30 <= #1 3'b110;
				2'b11 : rbit_counter30 <= #1 3'b111;
				endcase
				if (rcounter16_eq_030)
				begin
					rstate		<= #1 sr_rec_bit30;
					rcounter1630	<= #1 4'b1110;
					rshift30		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare30;
				rcounter1630 <= #1 rcounter16_minus_130;
			end
	sr_rec_bit30 :	begin
				if (rcounter16_eq_030)
					rstate <= #1 sr_end_bit30;
				if (rcounter16_eq_730) // read the bit
					case (lcr30[/*`UART_LC_BITS30*/1:0])  // number30 of bits in a word30
					2'b00 : rshift30[4:0]  <= #1 {srx_pad_i30, rshift30[4:1]};
					2'b01 : rshift30[5:0]  <= #1 {srx_pad_i30, rshift30[5:1]};
					2'b10 : rshift30[6:0]  <= #1 {srx_pad_i30, rshift30[6:1]};
					2'b11 : rshift30[7:0]  <= #1 {srx_pad_i30, rshift30[7:1]};
					endcase
				rcounter1630 <= #1 rcounter16_minus_130;
			end
	sr_end_bit30 :   begin
				if (rbit_counter30==3'b0) // no more bits in word30
					if (lcr30[`UART_LC_PE30]) // choose30 state based on parity30
						rstate <= #1 sr_rec_parity30;
					else
					begin
						rstate <= #1 sr_rec_stop30;
						rparity_error30 <= #1 1'b0;  // no parity30 - no error :)
					end
				else		// else we30 have more bits to read
				begin
					rstate <= #1 sr_rec_bit30;
					rbit_counter30 <= #1 rbit_counter30 - 1'b1;
				end
				rcounter1630 <= #1 4'b1110;
			end
	sr_rec_parity30: begin
				if (rcounter16_eq_730)	// read the parity30
				begin
					rparity30 <= #1 srx_pad_i30;
					rstate <= #1 sr_ca_lc_parity30;
				end
				rcounter1630 <= #1 rcounter16_minus_130;
			end
	sr_ca_lc_parity30 : begin    // rcounter30 equals30 6
				rcounter1630  <= #1 rcounter16_minus_130;
				rparity_xor30 <= #1 ^{rshift30,rparity30}; // calculate30 parity30 on all incoming30 data
				rstate      <= #1 sr_check_parity30;
			  end
	sr_check_parity30: begin	  // rcounter30 equals30 5
				case ({lcr30[`UART_LC_EP30],lcr30[`UART_LC_SP30]})
					2'b00: rparity_error30 <= #1  rparity_xor30 == 0;  // no error if parity30 1
					2'b01: rparity_error30 <= #1 ~rparity30;      // parity30 should sticked30 to 1
					2'b10: rparity_error30 <= #1  rparity_xor30 == 1;   // error if parity30 is odd30
					2'b11: rparity_error30 <= #1  rparity30;	  // parity30 should be sticked30 to 0
				endcase
				rcounter1630 <= #1 rcounter16_minus_130;
				rstate <= #1 sr_wait130;
			  end
	sr_wait130 :	if (rcounter16_eq_030)
			begin
				rstate <= #1 sr_rec_stop30;
				rcounter1630 <= #1 4'b1110;
			end
			else
				rcounter1630 <= #1 rcounter16_minus_130;
	sr_rec_stop30 :	begin
				if (rcounter16_eq_730)	// read the parity30
				begin
					rframing_error30 <= #1 !srx_pad_i30; // no framing30 error if input is 1 (stop bit)
					rstate <= #1 sr_push30;
				end
				rcounter1630 <= #1 rcounter16_minus_130;
			end
	sr_push30 :	begin
///////////////////////////////////////
//				$display($time, ": received30: %b", rf_data_in30);
        if(srx_pad_i30 | break_error30)
          begin
            if(break_error30)
        		  rf_data_in30 	<= #1 {8'b0, 3'b100}; // break input (empty30 character30) to receiver30 FIFO
            else
        			rf_data_in30  <= #1 {rshift30, 1'b0, rparity_error30, rframing_error30};
      		  rf_push30 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle30;
          end
        else if(~rframing_error30)  // There's always a framing30 before break_error30 -> wait for break or srx_pad_i30
          begin
       			rf_data_in30  <= #1 {rshift30, 1'b0, rparity_error30, rframing_error30};
      		  rf_push30 		  <= #1 1'b1;
      			rcounter1630 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start30;
          end
                      
			end
	default : rstate <= #1 sr_idle30;
	endcase
  end  // if (enable)
end // always of receiver30

always @ (posedge clk30 or posedge wb_rst_i30)
begin
  if(wb_rst_i30)
    rf_push_q30 <= 0;
  else
    rf_push_q30 <= #1 rf_push30;
end

assign rf_push_pulse30 = rf_push30 & ~rf_push_q30;

  
//
// Break30 condition detection30.
// Works30 in conjuction30 with the receiver30 state machine30

reg 	[9:0]	toc_value30; // value to be set to timeout counter

always @(lcr30)
	case (lcr30[3:0])
		4'b0000										: toc_value30 = 447; // 7 bits
		4'b0100										: toc_value30 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value30 = 511; // 8 bits
		4'b1100										: toc_value30 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value30 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value30 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value30 = 703; // 11 bits
		4'b1111										: toc_value30 = 767; // 12 bits
	endcase // case(lcr30[3:0])

wire [7:0] 	brc_value30; // value to be set to break counter
assign 		brc_value30 = toc_value30[9:2]; // the same as timeout but 1 insead30 of 4 character30 times

always @(posedge clk30 or posedge wb_rst_i30)
begin
	if (wb_rst_i30)
		counter_b30 <= #1 8'd159;
	else
	if (srx_pad_i30)
		counter_b30 <= #1 brc_value30; // character30 time length - 1
	else
	if(enable & counter_b30 != 8'b0)            // only work30 on enable times  break not reached30.
		counter_b30 <= #1 counter_b30 - 1;  // decrement break counter
end // always of break condition detection30

///
/// Timeout30 condition detection30
reg	[9:0]	counter_t30;	// counts30 the timeout condition clocks30

always @(posedge clk30 or posedge wb_rst_i30)
begin
	if (wb_rst_i30)
		counter_t30 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse30 || rf_pop30 || rf_count30 == 0) // counter is reset when RX30 FIFO is empty30, accessed or above30 trigger level
			counter_t30 <= #1 toc_value30;
		else
		if (enable && counter_t30 != 10'b0)  // we30 don30't want30 to underflow30
			counter_t30 <= #1 counter_t30 - 1;		
end
	
endmodule
