//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter15.v                                          ////
////                                                              ////
////                                                              ////
////  This15 file is part of the "UART15 16550 compatible15" project15    ////
////  http15://www15.opencores15.org15/cores15/uart1655015/                   ////
////                                                              ////
////  Documentation15 related15 to this project15:                      ////
////  - http15://www15.opencores15.org15/cores15/uart1655015/                 ////
////                                                              ////
////  Projects15 compatibility15:                                     ////
////  - WISHBONE15                                                  ////
////  RS23215 Protocol15                                              ////
////  16550D uart15 (mostly15 supported)                              ////
////                                                              ////
////  Overview15 (main15 Features15):                                   ////
////  UART15 core15 transmitter15 logic                                 ////
////                                                              ////
////  Known15 problems15 (limits15):                                    ////
////  None15 known15                                                  ////
////                                                              ////
////  To15 Do15:                                                      ////
////  Thourough15 testing15.                                          ////
////                                                              ////
////  Author15(s):                                                  ////
////      - gorban15@opencores15.org15                                  ////
////      - Jacob15 Gorban15                                          ////
////      - Igor15 Mohor15 (igorm15@opencores15.org15)                      ////
////                                                              ////
////  Created15:        2001/05/12                                  ////
////  Last15 Updated15:   2001/05/17                                  ////
////                  (See log15 for the revision15 history15)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2000, 2001 Authors15                             ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS15 Revision15 History15
//
// $Log: not supported by cvs2svn15 $
// Revision15 1.18  2002/07/22 23:02:23  gorban15
// Bug15 Fixes15:
//  * Possible15 loss of sync and bad15 reception15 of stop bit on slow15 baud15 rates15 fixed15.
//   Problem15 reported15 by Kenny15.Tung15.
//  * Bad (or lack15 of ) loopback15 handling15 fixed15. Reported15 by Cherry15 Withers15.
//
// Improvements15:
//  * Made15 FIFO's as general15 inferrable15 memory where possible15.
//  So15 on FPGA15 they should be inferred15 as RAM15 (Distributed15 RAM15 on Xilinx15).
//  This15 saves15 about15 1/3 of the Slice15 count and reduces15 P&R and synthesis15 times.
//
//  * Added15 optional15 baudrate15 output (baud_o15).
//  This15 is identical15 to BAUDOUT15* signal15 on 16550 chip15.
//  It outputs15 16xbit_clock_rate - the divided15 clock15.
//  It's disabled by default. Define15 UART_HAS_BAUDRATE_OUTPUT15 to use.
//
// Revision15 1.16  2002/01/08 11:29:40  mohor15
// tf_pop15 was too wide15. Now15 it is only 1 clk15 cycle width.
//
// Revision15 1.15  2001/12/17 14:46:48  mohor15
// overrun15 signal15 was moved to separate15 block because many15 sequential15 lsr15
// reads were15 preventing15 data from being written15 to rx15 fifo.
// underrun15 signal15 was not used and was removed from the project15.
//
// Revision15 1.14  2001/12/03 21:44:29  gorban15
// Updated15 specification15 documentation.
// Added15 full 32-bit data bus interface, now as default.
// Address is 5-bit wide15 in 32-bit data bus mode.
// Added15 wb_sel_i15 input to the core15. It's used in the 32-bit mode.
// Added15 debug15 interface with two15 32-bit read-only registers in 32-bit mode.
// Bits15 5 and 6 of LSR15 are now only cleared15 on TX15 FIFO write.
// My15 small test bench15 is modified to work15 with 32-bit mode.
//
// Revision15 1.13  2001/11/08 14:54:23  mohor15
// Comments15 in Slovene15 language15 deleted15, few15 small fixes15 for better15 work15 of
// old15 tools15. IRQs15 need to be fix15.
//
// Revision15 1.12  2001/11/07 17:51:52  gorban15
// Heavily15 rewritten15 interrupt15 and LSR15 subsystems15.
// Many15 bugs15 hopefully15 squashed15.
//
// Revision15 1.11  2001/10/29 17:00:46  gorban15
// fixed15 parity15 sending15 and tx_fifo15 resets15 over- and underrun15
//
// Revision15 1.10  2001/10/20 09:58:40  gorban15
// Small15 synopsis15 fixes15
//
// Revision15 1.9  2001/08/24 21:01:12  mohor15
// Things15 connected15 to parity15 changed.
// Clock15 devider15 changed.
//
// Revision15 1.8  2001/08/23 16:05:05  mohor15
// Stop bit bug15 fixed15.
// Parity15 bug15 fixed15.
// WISHBONE15 read cycle bug15 fixed15,
// OE15 indicator15 (Overrun15 Error) bug15 fixed15.
// PE15 indicator15 (Parity15 Error) bug15 fixed15.
// Register read bug15 fixed15.
//
// Revision15 1.6  2001/06/23 11:21:48  gorban15
// DL15 made15 16-bit long15. Fixed15 transmission15/reception15 bugs15.
//
// Revision15 1.5  2001/06/02 14:28:14  gorban15
// Fixed15 receiver15 and transmitter15. Major15 bug15 fixed15.
//
// Revision15 1.4  2001/05/31 20:08:01  gorban15
// FIFO changes15 and other corrections15.
//
// Revision15 1.3  2001/05/27 17:37:49  gorban15
// Fixed15 many15 bugs15. Updated15 spec15. Changed15 FIFO files structure15. See CHANGES15.txt15 file.
//
// Revision15 1.2  2001/05/21 19:12:02  gorban15
// Corrected15 some15 Linter15 messages15.
//
// Revision15 1.1  2001/05/17 18:34:18  gorban15
// First15 'stable' release. Should15 be sythesizable15 now. Also15 added new header.
//
// Revision15 1.0  2001-05-17 21:27:12+02  jacob15
// Initial15 revision15
//
//

// synopsys15 translate_off15
`include "timescale.v"
// synopsys15 translate_on15

`include "uart_defines15.v"

module uart_transmitter15 (clk15, wb_rst_i15, lcr15, tf_push15, wb_dat_i15, enable,	stx_pad_o15, tstate15, tf_count15, tx_reset15, lsr_mask15);

input 										clk15;
input 										wb_rst_i15;
input [7:0] 								lcr15;
input 										tf_push15;
input [7:0] 								wb_dat_i15;
input 										enable;
input 										tx_reset15;
input 										lsr_mask15; //reset of fifo
output 										stx_pad_o15;
output [2:0] 								tstate15;
output [`UART_FIFO_COUNTER_W15-1:0] 	tf_count15;

reg [2:0] 									tstate15;
reg [4:0] 									counter;
reg [2:0] 									bit_counter15;   // counts15 the bits to be sent15
reg [6:0] 									shift_out15;	// output shift15 register
reg 											stx_o_tmp15;
reg 											parity_xor15;  // parity15 of the word15
reg 											tf_pop15;
reg 											bit_out15;

// TX15 FIFO instance
//
// Transmitter15 FIFO signals15
wire [`UART_FIFO_WIDTH15-1:0] 			tf_data_in15;
wire [`UART_FIFO_WIDTH15-1:0] 			tf_data_out15;
wire 											tf_push15;
wire 											tf_overrun15;
wire [`UART_FIFO_COUNTER_W15-1:0] 		tf_count15;

assign 										tf_data_in15 = wb_dat_i15;

uart_tfifo15 fifo_tx15(	// error bit signal15 is not used in transmitter15 FIFO
	.clk15(		clk15		), 
	.wb_rst_i15(	wb_rst_i15	),
	.data_in15(	tf_data_in15	),
	.data_out15(	tf_data_out15	),
	.push15(		tf_push15		),
	.pop15(		tf_pop15		),
	.overrun15(	tf_overrun15	),
	.count(		tf_count15	),
	.fifo_reset15(	tx_reset15	),
	.reset_status15(lsr_mask15)
);

// TRANSMITTER15 FINAL15 STATE15 MACHINE15

parameter s_idle15        = 3'd0;
parameter s_send_start15  = 3'd1;
parameter s_send_byte15   = 3'd2;
parameter s_send_parity15 = 3'd3;
parameter s_send_stop15   = 3'd4;
parameter s_pop_byte15    = 3'd5;

always @(posedge clk15 or posedge wb_rst_i15)
begin
  if (wb_rst_i15)
  begin
	tstate15       <= #1 s_idle15;
	stx_o_tmp15       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out15   <= #1 7'b0;
	bit_out15     <= #1 1'b0;
	parity_xor15  <= #1 1'b0;
	tf_pop15      <= #1 1'b0;
	bit_counter15 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate15)
	s_idle15	 :	if (~|tf_count15) // if tf_count15==0
			begin
				tstate15 <= #1 s_idle15;
				stx_o_tmp15 <= #1 1'b1;
			end
			else
			begin
				tf_pop15 <= #1 1'b0;
				stx_o_tmp15  <= #1 1'b1;
				tstate15  <= #1 s_pop_byte15;
			end
	s_pop_byte15 :	begin
				tf_pop15 <= #1 1'b1;
				case (lcr15[/*`UART_LC_BITS15*/1:0])  // number15 of bits in a word15
				2'b00 : begin
					bit_counter15 <= #1 3'b100;
					parity_xor15  <= #1 ^tf_data_out15[4:0];
				     end
				2'b01 : begin
					bit_counter15 <= #1 3'b101;
					parity_xor15  <= #1 ^tf_data_out15[5:0];
				     end
				2'b10 : begin
					bit_counter15 <= #1 3'b110;
					parity_xor15  <= #1 ^tf_data_out15[6:0];
				     end
				2'b11 : begin
					bit_counter15 <= #1 3'b111;
					parity_xor15  <= #1 ^tf_data_out15[7:0];
				     end
				endcase
				{shift_out15[6:0], bit_out15} <= #1 tf_data_out15;
				tstate15 <= #1 s_send_start15;
			end
	s_send_start15 :	begin
				tf_pop15 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate15 <= #1 s_send_byte15;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp15 <= #1 1'b0;
			end
	s_send_byte15 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter15 > 3'b0)
					begin
						bit_counter15 <= #1 bit_counter15 - 1'b1;
						{shift_out15[5:0],bit_out15  } <= #1 {shift_out15[6:1], shift_out15[0]};
						tstate15 <= #1 s_send_byte15;
					end
					else   // end of byte
					if (~lcr15[`UART_LC_PE15])
					begin
						tstate15 <= #1 s_send_stop15;
					end
					else
					begin
						case ({lcr15[`UART_LC_EP15],lcr15[`UART_LC_SP15]})
						2'b00:	bit_out15 <= #1 ~parity_xor15;
						2'b01:	bit_out15 <= #1 1'b1;
						2'b10:	bit_out15 <= #1 parity_xor15;
						2'b11:	bit_out15 <= #1 1'b0;
						endcase
						tstate15 <= #1 s_send_parity15;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp15 <= #1 bit_out15; // set output pin15
			end
	s_send_parity15 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate15 <= #1 s_send_stop15;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp15 <= #1 bit_out15;
			end
	s_send_stop15 :  begin
				if (~|counter)
				  begin
						casex ({lcr15[`UART_LC_SB15],lcr15[`UART_LC_BITS15]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor15
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate15 <= #1 s_idle15;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp15 <= #1 1'b1;
			end

		default : // should never get here15
			tstate15 <= #1 s_idle15;
	endcase
  end // end if enable
  else
    tf_pop15 <= #1 1'b0;  // tf_pop15 must be 1 cycle width
end // transmitter15 logic

assign stx_pad_o15 = lcr15[`UART_LC_BC15] ? 1'b0 : stx_o_tmp15;    // Break15 condition
	
endmodule
