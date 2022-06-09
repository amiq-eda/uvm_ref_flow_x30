//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter18.v                                          ////
////                                                              ////
////                                                              ////
////  This18 file is part of the "UART18 16550 compatible18" project18    ////
////  http18://www18.opencores18.org18/cores18/uart1655018/                   ////
////                                                              ////
////  Documentation18 related18 to this project18:                      ////
////  - http18://www18.opencores18.org18/cores18/uart1655018/                 ////
////                                                              ////
////  Projects18 compatibility18:                                     ////
////  - WISHBONE18                                                  ////
////  RS23218 Protocol18                                              ////
////  16550D uart18 (mostly18 supported)                              ////
////                                                              ////
////  Overview18 (main18 Features18):                                   ////
////  UART18 core18 transmitter18 logic                                 ////
////                                                              ////
////  Known18 problems18 (limits18):                                    ////
////  None18 known18                                                  ////
////                                                              ////
////  To18 Do18:                                                      ////
////  Thourough18 testing18.                                          ////
////                                                              ////
////  Author18(s):                                                  ////
////      - gorban18@opencores18.org18                                  ////
////      - Jacob18 Gorban18                                          ////
////      - Igor18 Mohor18 (igorm18@opencores18.org18)                      ////
////                                                              ////
////  Created18:        2001/05/12                                  ////
////  Last18 Updated18:   2001/05/17                                  ////
////                  (See log18 for the revision18 history18)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2000, 2001 Authors18                             ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS18 Revision18 History18
//
// $Log: not supported by cvs2svn18 $
// Revision18 1.18  2002/07/22 23:02:23  gorban18
// Bug18 Fixes18:
//  * Possible18 loss of sync and bad18 reception18 of stop bit on slow18 baud18 rates18 fixed18.
//   Problem18 reported18 by Kenny18.Tung18.
//  * Bad (or lack18 of ) loopback18 handling18 fixed18. Reported18 by Cherry18 Withers18.
//
// Improvements18:
//  * Made18 FIFO's as general18 inferrable18 memory where possible18.
//  So18 on FPGA18 they should be inferred18 as RAM18 (Distributed18 RAM18 on Xilinx18).
//  This18 saves18 about18 1/3 of the Slice18 count and reduces18 P&R and synthesis18 times.
//
//  * Added18 optional18 baudrate18 output (baud_o18).
//  This18 is identical18 to BAUDOUT18* signal18 on 16550 chip18.
//  It outputs18 16xbit_clock_rate - the divided18 clock18.
//  It's disabled by default. Define18 UART_HAS_BAUDRATE_OUTPUT18 to use.
//
// Revision18 1.16  2002/01/08 11:29:40  mohor18
// tf_pop18 was too wide18. Now18 it is only 1 clk18 cycle width.
//
// Revision18 1.15  2001/12/17 14:46:48  mohor18
// overrun18 signal18 was moved to separate18 block because many18 sequential18 lsr18
// reads were18 preventing18 data from being written18 to rx18 fifo.
// underrun18 signal18 was not used and was removed from the project18.
//
// Revision18 1.14  2001/12/03 21:44:29  gorban18
// Updated18 specification18 documentation.
// Added18 full 32-bit data bus interface, now as default.
// Address is 5-bit wide18 in 32-bit data bus mode.
// Added18 wb_sel_i18 input to the core18. It's used in the 32-bit mode.
// Added18 debug18 interface with two18 32-bit read-only registers in 32-bit mode.
// Bits18 5 and 6 of LSR18 are now only cleared18 on TX18 FIFO write.
// My18 small test bench18 is modified to work18 with 32-bit mode.
//
// Revision18 1.13  2001/11/08 14:54:23  mohor18
// Comments18 in Slovene18 language18 deleted18, few18 small fixes18 for better18 work18 of
// old18 tools18. IRQs18 need to be fix18.
//
// Revision18 1.12  2001/11/07 17:51:52  gorban18
// Heavily18 rewritten18 interrupt18 and LSR18 subsystems18.
// Many18 bugs18 hopefully18 squashed18.
//
// Revision18 1.11  2001/10/29 17:00:46  gorban18
// fixed18 parity18 sending18 and tx_fifo18 resets18 over- and underrun18
//
// Revision18 1.10  2001/10/20 09:58:40  gorban18
// Small18 synopsis18 fixes18
//
// Revision18 1.9  2001/08/24 21:01:12  mohor18
// Things18 connected18 to parity18 changed.
// Clock18 devider18 changed.
//
// Revision18 1.8  2001/08/23 16:05:05  mohor18
// Stop bit bug18 fixed18.
// Parity18 bug18 fixed18.
// WISHBONE18 read cycle bug18 fixed18,
// OE18 indicator18 (Overrun18 Error) bug18 fixed18.
// PE18 indicator18 (Parity18 Error) bug18 fixed18.
// Register read bug18 fixed18.
//
// Revision18 1.6  2001/06/23 11:21:48  gorban18
// DL18 made18 16-bit long18. Fixed18 transmission18/reception18 bugs18.
//
// Revision18 1.5  2001/06/02 14:28:14  gorban18
// Fixed18 receiver18 and transmitter18. Major18 bug18 fixed18.
//
// Revision18 1.4  2001/05/31 20:08:01  gorban18
// FIFO changes18 and other corrections18.
//
// Revision18 1.3  2001/05/27 17:37:49  gorban18
// Fixed18 many18 bugs18. Updated18 spec18. Changed18 FIFO files structure18. See CHANGES18.txt18 file.
//
// Revision18 1.2  2001/05/21 19:12:02  gorban18
// Corrected18 some18 Linter18 messages18.
//
// Revision18 1.1  2001/05/17 18:34:18  gorban18
// First18 'stable' release. Should18 be sythesizable18 now. Also18 added new header.
//
// Revision18 1.0  2001-05-17 21:27:12+02  jacob18
// Initial18 revision18
//
//

// synopsys18 translate_off18
`include "timescale.v"
// synopsys18 translate_on18

`include "uart_defines18.v"

module uart_transmitter18 (clk18, wb_rst_i18, lcr18, tf_push18, wb_dat_i18, enable,	stx_pad_o18, tstate18, tf_count18, tx_reset18, lsr_mask18);

input 										clk18;
input 										wb_rst_i18;
input [7:0] 								lcr18;
input 										tf_push18;
input [7:0] 								wb_dat_i18;
input 										enable;
input 										tx_reset18;
input 										lsr_mask18; //reset of fifo
output 										stx_pad_o18;
output [2:0] 								tstate18;
output [`UART_FIFO_COUNTER_W18-1:0] 	tf_count18;

reg [2:0] 									tstate18;
reg [4:0] 									counter;
reg [2:0] 									bit_counter18;   // counts18 the bits to be sent18
reg [6:0] 									shift_out18;	// output shift18 register
reg 											stx_o_tmp18;
reg 											parity_xor18;  // parity18 of the word18
reg 											tf_pop18;
reg 											bit_out18;

// TX18 FIFO instance
//
// Transmitter18 FIFO signals18
wire [`UART_FIFO_WIDTH18-1:0] 			tf_data_in18;
wire [`UART_FIFO_WIDTH18-1:0] 			tf_data_out18;
wire 											tf_push18;
wire 											tf_overrun18;
wire [`UART_FIFO_COUNTER_W18-1:0] 		tf_count18;

assign 										tf_data_in18 = wb_dat_i18;

uart_tfifo18 fifo_tx18(	// error bit signal18 is not used in transmitter18 FIFO
	.clk18(		clk18		), 
	.wb_rst_i18(	wb_rst_i18	),
	.data_in18(	tf_data_in18	),
	.data_out18(	tf_data_out18	),
	.push18(		tf_push18		),
	.pop18(		tf_pop18		),
	.overrun18(	tf_overrun18	),
	.count(		tf_count18	),
	.fifo_reset18(	tx_reset18	),
	.reset_status18(lsr_mask18)
);

// TRANSMITTER18 FINAL18 STATE18 MACHINE18

parameter s_idle18        = 3'd0;
parameter s_send_start18  = 3'd1;
parameter s_send_byte18   = 3'd2;
parameter s_send_parity18 = 3'd3;
parameter s_send_stop18   = 3'd4;
parameter s_pop_byte18    = 3'd5;

always @(posedge clk18 or posedge wb_rst_i18)
begin
  if (wb_rst_i18)
  begin
	tstate18       <= #1 s_idle18;
	stx_o_tmp18       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out18   <= #1 7'b0;
	bit_out18     <= #1 1'b0;
	parity_xor18  <= #1 1'b0;
	tf_pop18      <= #1 1'b0;
	bit_counter18 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate18)
	s_idle18	 :	if (~|tf_count18) // if tf_count18==0
			begin
				tstate18 <= #1 s_idle18;
				stx_o_tmp18 <= #1 1'b1;
			end
			else
			begin
				tf_pop18 <= #1 1'b0;
				stx_o_tmp18  <= #1 1'b1;
				tstate18  <= #1 s_pop_byte18;
			end
	s_pop_byte18 :	begin
				tf_pop18 <= #1 1'b1;
				case (lcr18[/*`UART_LC_BITS18*/1:0])  // number18 of bits in a word18
				2'b00 : begin
					bit_counter18 <= #1 3'b100;
					parity_xor18  <= #1 ^tf_data_out18[4:0];
				     end
				2'b01 : begin
					bit_counter18 <= #1 3'b101;
					parity_xor18  <= #1 ^tf_data_out18[5:0];
				     end
				2'b10 : begin
					bit_counter18 <= #1 3'b110;
					parity_xor18  <= #1 ^tf_data_out18[6:0];
				     end
				2'b11 : begin
					bit_counter18 <= #1 3'b111;
					parity_xor18  <= #1 ^tf_data_out18[7:0];
				     end
				endcase
				{shift_out18[6:0], bit_out18} <= #1 tf_data_out18;
				tstate18 <= #1 s_send_start18;
			end
	s_send_start18 :	begin
				tf_pop18 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate18 <= #1 s_send_byte18;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp18 <= #1 1'b0;
			end
	s_send_byte18 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter18 > 3'b0)
					begin
						bit_counter18 <= #1 bit_counter18 - 1'b1;
						{shift_out18[5:0],bit_out18  } <= #1 {shift_out18[6:1], shift_out18[0]};
						tstate18 <= #1 s_send_byte18;
					end
					else   // end of byte
					if (~lcr18[`UART_LC_PE18])
					begin
						tstate18 <= #1 s_send_stop18;
					end
					else
					begin
						case ({lcr18[`UART_LC_EP18],lcr18[`UART_LC_SP18]})
						2'b00:	bit_out18 <= #1 ~parity_xor18;
						2'b01:	bit_out18 <= #1 1'b1;
						2'b10:	bit_out18 <= #1 parity_xor18;
						2'b11:	bit_out18 <= #1 1'b0;
						endcase
						tstate18 <= #1 s_send_parity18;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp18 <= #1 bit_out18; // set output pin18
			end
	s_send_parity18 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate18 <= #1 s_send_stop18;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp18 <= #1 bit_out18;
			end
	s_send_stop18 :  begin
				if (~|counter)
				  begin
						casex ({lcr18[`UART_LC_SB18],lcr18[`UART_LC_BITS18]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor18
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate18 <= #1 s_idle18;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp18 <= #1 1'b1;
			end

		default : // should never get here18
			tstate18 <= #1 s_idle18;
	endcase
  end // end if enable
  else
    tf_pop18 <= #1 1'b0;  // tf_pop18 must be 1 cycle width
end // transmitter18 logic

assign stx_pad_o18 = lcr18[`UART_LC_BC18] ? 1'b0 : stx_o_tmp18;    // Break18 condition
	
endmodule
