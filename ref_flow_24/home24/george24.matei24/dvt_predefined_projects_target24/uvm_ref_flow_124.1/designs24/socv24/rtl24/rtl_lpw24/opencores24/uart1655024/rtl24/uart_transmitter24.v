//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter24.v                                          ////
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
////  UART24 core24 transmitter24 logic                                 ////
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
// Revision24 1.18  2002/07/22 23:02:23  gorban24
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
// Revision24 1.16  2002/01/08 11:29:40  mohor24
// tf_pop24 was too wide24. Now24 it is only 1 clk24 cycle width.
//
// Revision24 1.15  2001/12/17 14:46:48  mohor24
// overrun24 signal24 was moved to separate24 block because many24 sequential24 lsr24
// reads were24 preventing24 data from being written24 to rx24 fifo.
// underrun24 signal24 was not used and was removed from the project24.
//
// Revision24 1.14  2001/12/03 21:44:29  gorban24
// Updated24 specification24 documentation.
// Added24 full 32-bit data bus interface, now as default.
// Address is 5-bit wide24 in 32-bit data bus mode.
// Added24 wb_sel_i24 input to the core24. It's used in the 32-bit mode.
// Added24 debug24 interface with two24 32-bit read-only registers in 32-bit mode.
// Bits24 5 and 6 of LSR24 are now only cleared24 on TX24 FIFO write.
// My24 small test bench24 is modified to work24 with 32-bit mode.
//
// Revision24 1.13  2001/11/08 14:54:23  mohor24
// Comments24 in Slovene24 language24 deleted24, few24 small fixes24 for better24 work24 of
// old24 tools24. IRQs24 need to be fix24.
//
// Revision24 1.12  2001/11/07 17:51:52  gorban24
// Heavily24 rewritten24 interrupt24 and LSR24 subsystems24.
// Many24 bugs24 hopefully24 squashed24.
//
// Revision24 1.11  2001/10/29 17:00:46  gorban24
// fixed24 parity24 sending24 and tx_fifo24 resets24 over- and underrun24
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
// Revision24 1.0  2001-05-17 21:27:12+02  jacob24
// Initial24 revision24
//
//

// synopsys24 translate_off24
`include "timescale.v"
// synopsys24 translate_on24

`include "uart_defines24.v"

module uart_transmitter24 (clk24, wb_rst_i24, lcr24, tf_push24, wb_dat_i24, enable,	stx_pad_o24, tstate24, tf_count24, tx_reset24, lsr_mask24);

input 										clk24;
input 										wb_rst_i24;
input [7:0] 								lcr24;
input 										tf_push24;
input [7:0] 								wb_dat_i24;
input 										enable;
input 										tx_reset24;
input 										lsr_mask24; //reset of fifo
output 										stx_pad_o24;
output [2:0] 								tstate24;
output [`UART_FIFO_COUNTER_W24-1:0] 	tf_count24;

reg [2:0] 									tstate24;
reg [4:0] 									counter;
reg [2:0] 									bit_counter24;   // counts24 the bits to be sent24
reg [6:0] 									shift_out24;	// output shift24 register
reg 											stx_o_tmp24;
reg 											parity_xor24;  // parity24 of the word24
reg 											tf_pop24;
reg 											bit_out24;

// TX24 FIFO instance
//
// Transmitter24 FIFO signals24
wire [`UART_FIFO_WIDTH24-1:0] 			tf_data_in24;
wire [`UART_FIFO_WIDTH24-1:0] 			tf_data_out24;
wire 											tf_push24;
wire 											tf_overrun24;
wire [`UART_FIFO_COUNTER_W24-1:0] 		tf_count24;

assign 										tf_data_in24 = wb_dat_i24;

uart_tfifo24 fifo_tx24(	// error bit signal24 is not used in transmitter24 FIFO
	.clk24(		clk24		), 
	.wb_rst_i24(	wb_rst_i24	),
	.data_in24(	tf_data_in24	),
	.data_out24(	tf_data_out24	),
	.push24(		tf_push24		),
	.pop24(		tf_pop24		),
	.overrun24(	tf_overrun24	),
	.count(		tf_count24	),
	.fifo_reset24(	tx_reset24	),
	.reset_status24(lsr_mask24)
);

// TRANSMITTER24 FINAL24 STATE24 MACHINE24

parameter s_idle24        = 3'd0;
parameter s_send_start24  = 3'd1;
parameter s_send_byte24   = 3'd2;
parameter s_send_parity24 = 3'd3;
parameter s_send_stop24   = 3'd4;
parameter s_pop_byte24    = 3'd5;

always @(posedge clk24 or posedge wb_rst_i24)
begin
  if (wb_rst_i24)
  begin
	tstate24       <= #1 s_idle24;
	stx_o_tmp24       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out24   <= #1 7'b0;
	bit_out24     <= #1 1'b0;
	parity_xor24  <= #1 1'b0;
	tf_pop24      <= #1 1'b0;
	bit_counter24 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate24)
	s_idle24	 :	if (~|tf_count24) // if tf_count24==0
			begin
				tstate24 <= #1 s_idle24;
				stx_o_tmp24 <= #1 1'b1;
			end
			else
			begin
				tf_pop24 <= #1 1'b0;
				stx_o_tmp24  <= #1 1'b1;
				tstate24  <= #1 s_pop_byte24;
			end
	s_pop_byte24 :	begin
				tf_pop24 <= #1 1'b1;
				case (lcr24[/*`UART_LC_BITS24*/1:0])  // number24 of bits in a word24
				2'b00 : begin
					bit_counter24 <= #1 3'b100;
					parity_xor24  <= #1 ^tf_data_out24[4:0];
				     end
				2'b01 : begin
					bit_counter24 <= #1 3'b101;
					parity_xor24  <= #1 ^tf_data_out24[5:0];
				     end
				2'b10 : begin
					bit_counter24 <= #1 3'b110;
					parity_xor24  <= #1 ^tf_data_out24[6:0];
				     end
				2'b11 : begin
					bit_counter24 <= #1 3'b111;
					parity_xor24  <= #1 ^tf_data_out24[7:0];
				     end
				endcase
				{shift_out24[6:0], bit_out24} <= #1 tf_data_out24;
				tstate24 <= #1 s_send_start24;
			end
	s_send_start24 :	begin
				tf_pop24 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate24 <= #1 s_send_byte24;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp24 <= #1 1'b0;
			end
	s_send_byte24 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter24 > 3'b0)
					begin
						bit_counter24 <= #1 bit_counter24 - 1'b1;
						{shift_out24[5:0],bit_out24  } <= #1 {shift_out24[6:1], shift_out24[0]};
						tstate24 <= #1 s_send_byte24;
					end
					else   // end of byte
					if (~lcr24[`UART_LC_PE24])
					begin
						tstate24 <= #1 s_send_stop24;
					end
					else
					begin
						case ({lcr24[`UART_LC_EP24],lcr24[`UART_LC_SP24]})
						2'b00:	bit_out24 <= #1 ~parity_xor24;
						2'b01:	bit_out24 <= #1 1'b1;
						2'b10:	bit_out24 <= #1 parity_xor24;
						2'b11:	bit_out24 <= #1 1'b0;
						endcase
						tstate24 <= #1 s_send_parity24;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp24 <= #1 bit_out24; // set output pin24
			end
	s_send_parity24 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate24 <= #1 s_send_stop24;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp24 <= #1 bit_out24;
			end
	s_send_stop24 :  begin
				if (~|counter)
				  begin
						casex ({lcr24[`UART_LC_SB24],lcr24[`UART_LC_BITS24]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor24
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate24 <= #1 s_idle24;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp24 <= #1 1'b1;
			end

		default : // should never get here24
			tstate24 <= #1 s_idle24;
	endcase
  end // end if enable
  else
    tf_pop24 <= #1 1'b0;  // tf_pop24 must be 1 cycle width
end // transmitter24 logic

assign stx_pad_o24 = lcr24[`UART_LC_BC24] ? 1'b0 : stx_o_tmp24;    // Break24 condition
	
endmodule
