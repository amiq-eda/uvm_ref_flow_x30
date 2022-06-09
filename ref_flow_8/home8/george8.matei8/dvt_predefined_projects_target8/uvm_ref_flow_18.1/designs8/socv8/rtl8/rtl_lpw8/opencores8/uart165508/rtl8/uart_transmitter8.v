//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter8.v                                          ////
////                                                              ////
////                                                              ////
////  This8 file is part of the "UART8 16550 compatible8" project8    ////
////  http8://www8.opencores8.org8/cores8/uart165508/                   ////
////                                                              ////
////  Documentation8 related8 to this project8:                      ////
////  - http8://www8.opencores8.org8/cores8/uart165508/                 ////
////                                                              ////
////  Projects8 compatibility8:                                     ////
////  - WISHBONE8                                                  ////
////  RS2328 Protocol8                                              ////
////  16550D uart8 (mostly8 supported)                              ////
////                                                              ////
////  Overview8 (main8 Features8):                                   ////
////  UART8 core8 transmitter8 logic                                 ////
////                                                              ////
////  Known8 problems8 (limits8):                                    ////
////  None8 known8                                                  ////
////                                                              ////
////  To8 Do8:                                                      ////
////  Thourough8 testing8.                                          ////
////                                                              ////
////  Author8(s):                                                  ////
////      - gorban8@opencores8.org8                                  ////
////      - Jacob8 Gorban8                                          ////
////      - Igor8 Mohor8 (igorm8@opencores8.org8)                      ////
////                                                              ////
////  Created8:        2001/05/12                                  ////
////  Last8 Updated8:   2001/05/17                                  ////
////                  (See log8 for the revision8 history8)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2000, 2001 Authors8                             ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS8 Revision8 History8
//
// $Log: not supported by cvs2svn8 $
// Revision8 1.18  2002/07/22 23:02:23  gorban8
// Bug8 Fixes8:
//  * Possible8 loss of sync and bad8 reception8 of stop bit on slow8 baud8 rates8 fixed8.
//   Problem8 reported8 by Kenny8.Tung8.
//  * Bad (or lack8 of ) loopback8 handling8 fixed8. Reported8 by Cherry8 Withers8.
//
// Improvements8:
//  * Made8 FIFO's as general8 inferrable8 memory where possible8.
//  So8 on FPGA8 they should be inferred8 as RAM8 (Distributed8 RAM8 on Xilinx8).
//  This8 saves8 about8 1/3 of the Slice8 count and reduces8 P&R and synthesis8 times.
//
//  * Added8 optional8 baudrate8 output (baud_o8).
//  This8 is identical8 to BAUDOUT8* signal8 on 16550 chip8.
//  It outputs8 16xbit_clock_rate - the divided8 clock8.
//  It's disabled by default. Define8 UART_HAS_BAUDRATE_OUTPUT8 to use.
//
// Revision8 1.16  2002/01/08 11:29:40  mohor8
// tf_pop8 was too wide8. Now8 it is only 1 clk8 cycle width.
//
// Revision8 1.15  2001/12/17 14:46:48  mohor8
// overrun8 signal8 was moved to separate8 block because many8 sequential8 lsr8
// reads were8 preventing8 data from being written8 to rx8 fifo.
// underrun8 signal8 was not used and was removed from the project8.
//
// Revision8 1.14  2001/12/03 21:44:29  gorban8
// Updated8 specification8 documentation.
// Added8 full 32-bit data bus interface, now as default.
// Address is 5-bit wide8 in 32-bit data bus mode.
// Added8 wb_sel_i8 input to the core8. It's used in the 32-bit mode.
// Added8 debug8 interface with two8 32-bit read-only registers in 32-bit mode.
// Bits8 5 and 6 of LSR8 are now only cleared8 on TX8 FIFO write.
// My8 small test bench8 is modified to work8 with 32-bit mode.
//
// Revision8 1.13  2001/11/08 14:54:23  mohor8
// Comments8 in Slovene8 language8 deleted8, few8 small fixes8 for better8 work8 of
// old8 tools8. IRQs8 need to be fix8.
//
// Revision8 1.12  2001/11/07 17:51:52  gorban8
// Heavily8 rewritten8 interrupt8 and LSR8 subsystems8.
// Many8 bugs8 hopefully8 squashed8.
//
// Revision8 1.11  2001/10/29 17:00:46  gorban8
// fixed8 parity8 sending8 and tx_fifo8 resets8 over- and underrun8
//
// Revision8 1.10  2001/10/20 09:58:40  gorban8
// Small8 synopsis8 fixes8
//
// Revision8 1.9  2001/08/24 21:01:12  mohor8
// Things8 connected8 to parity8 changed.
// Clock8 devider8 changed.
//
// Revision8 1.8  2001/08/23 16:05:05  mohor8
// Stop bit bug8 fixed8.
// Parity8 bug8 fixed8.
// WISHBONE8 read cycle bug8 fixed8,
// OE8 indicator8 (Overrun8 Error) bug8 fixed8.
// PE8 indicator8 (Parity8 Error) bug8 fixed8.
// Register read bug8 fixed8.
//
// Revision8 1.6  2001/06/23 11:21:48  gorban8
// DL8 made8 16-bit long8. Fixed8 transmission8/reception8 bugs8.
//
// Revision8 1.5  2001/06/02 14:28:14  gorban8
// Fixed8 receiver8 and transmitter8. Major8 bug8 fixed8.
//
// Revision8 1.4  2001/05/31 20:08:01  gorban8
// FIFO changes8 and other corrections8.
//
// Revision8 1.3  2001/05/27 17:37:49  gorban8
// Fixed8 many8 bugs8. Updated8 spec8. Changed8 FIFO files structure8. See CHANGES8.txt8 file.
//
// Revision8 1.2  2001/05/21 19:12:02  gorban8
// Corrected8 some8 Linter8 messages8.
//
// Revision8 1.1  2001/05/17 18:34:18  gorban8
// First8 'stable' release. Should8 be sythesizable8 now. Also8 added new header.
//
// Revision8 1.0  2001-05-17 21:27:12+02  jacob8
// Initial8 revision8
//
//

// synopsys8 translate_off8
`include "timescale.v"
// synopsys8 translate_on8

`include "uart_defines8.v"

module uart_transmitter8 (clk8, wb_rst_i8, lcr8, tf_push8, wb_dat_i8, enable,	stx_pad_o8, tstate8, tf_count8, tx_reset8, lsr_mask8);

input 										clk8;
input 										wb_rst_i8;
input [7:0] 								lcr8;
input 										tf_push8;
input [7:0] 								wb_dat_i8;
input 										enable;
input 										tx_reset8;
input 										lsr_mask8; //reset of fifo
output 										stx_pad_o8;
output [2:0] 								tstate8;
output [`UART_FIFO_COUNTER_W8-1:0] 	tf_count8;

reg [2:0] 									tstate8;
reg [4:0] 									counter;
reg [2:0] 									bit_counter8;   // counts8 the bits to be sent8
reg [6:0] 									shift_out8;	// output shift8 register
reg 											stx_o_tmp8;
reg 											parity_xor8;  // parity8 of the word8
reg 											tf_pop8;
reg 											bit_out8;

// TX8 FIFO instance
//
// Transmitter8 FIFO signals8
wire [`UART_FIFO_WIDTH8-1:0] 			tf_data_in8;
wire [`UART_FIFO_WIDTH8-1:0] 			tf_data_out8;
wire 											tf_push8;
wire 											tf_overrun8;
wire [`UART_FIFO_COUNTER_W8-1:0] 		tf_count8;

assign 										tf_data_in8 = wb_dat_i8;

uart_tfifo8 fifo_tx8(	// error bit signal8 is not used in transmitter8 FIFO
	.clk8(		clk8		), 
	.wb_rst_i8(	wb_rst_i8	),
	.data_in8(	tf_data_in8	),
	.data_out8(	tf_data_out8	),
	.push8(		tf_push8		),
	.pop8(		tf_pop8		),
	.overrun8(	tf_overrun8	),
	.count(		tf_count8	),
	.fifo_reset8(	tx_reset8	),
	.reset_status8(lsr_mask8)
);

// TRANSMITTER8 FINAL8 STATE8 MACHINE8

parameter s_idle8        = 3'd0;
parameter s_send_start8  = 3'd1;
parameter s_send_byte8   = 3'd2;
parameter s_send_parity8 = 3'd3;
parameter s_send_stop8   = 3'd4;
parameter s_pop_byte8    = 3'd5;

always @(posedge clk8 or posedge wb_rst_i8)
begin
  if (wb_rst_i8)
  begin
	tstate8       <= #1 s_idle8;
	stx_o_tmp8       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out8   <= #1 7'b0;
	bit_out8     <= #1 1'b0;
	parity_xor8  <= #1 1'b0;
	tf_pop8      <= #1 1'b0;
	bit_counter8 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate8)
	s_idle8	 :	if (~|tf_count8) // if tf_count8==0
			begin
				tstate8 <= #1 s_idle8;
				stx_o_tmp8 <= #1 1'b1;
			end
			else
			begin
				tf_pop8 <= #1 1'b0;
				stx_o_tmp8  <= #1 1'b1;
				tstate8  <= #1 s_pop_byte8;
			end
	s_pop_byte8 :	begin
				tf_pop8 <= #1 1'b1;
				case (lcr8[/*`UART_LC_BITS8*/1:0])  // number8 of bits in a word8
				2'b00 : begin
					bit_counter8 <= #1 3'b100;
					parity_xor8  <= #1 ^tf_data_out8[4:0];
				     end
				2'b01 : begin
					bit_counter8 <= #1 3'b101;
					parity_xor8  <= #1 ^tf_data_out8[5:0];
				     end
				2'b10 : begin
					bit_counter8 <= #1 3'b110;
					parity_xor8  <= #1 ^tf_data_out8[6:0];
				     end
				2'b11 : begin
					bit_counter8 <= #1 3'b111;
					parity_xor8  <= #1 ^tf_data_out8[7:0];
				     end
				endcase
				{shift_out8[6:0], bit_out8} <= #1 tf_data_out8;
				tstate8 <= #1 s_send_start8;
			end
	s_send_start8 :	begin
				tf_pop8 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate8 <= #1 s_send_byte8;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp8 <= #1 1'b0;
			end
	s_send_byte8 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter8 > 3'b0)
					begin
						bit_counter8 <= #1 bit_counter8 - 1'b1;
						{shift_out8[5:0],bit_out8  } <= #1 {shift_out8[6:1], shift_out8[0]};
						tstate8 <= #1 s_send_byte8;
					end
					else   // end of byte
					if (~lcr8[`UART_LC_PE8])
					begin
						tstate8 <= #1 s_send_stop8;
					end
					else
					begin
						case ({lcr8[`UART_LC_EP8],lcr8[`UART_LC_SP8]})
						2'b00:	bit_out8 <= #1 ~parity_xor8;
						2'b01:	bit_out8 <= #1 1'b1;
						2'b10:	bit_out8 <= #1 parity_xor8;
						2'b11:	bit_out8 <= #1 1'b0;
						endcase
						tstate8 <= #1 s_send_parity8;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp8 <= #1 bit_out8; // set output pin8
			end
	s_send_parity8 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate8 <= #1 s_send_stop8;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp8 <= #1 bit_out8;
			end
	s_send_stop8 :  begin
				if (~|counter)
				  begin
						casex ({lcr8[`UART_LC_SB8],lcr8[`UART_LC_BITS8]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor8
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate8 <= #1 s_idle8;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp8 <= #1 1'b1;
			end

		default : // should never get here8
			tstate8 <= #1 s_idle8;
	endcase
  end // end if enable
  else
    tf_pop8 <= #1 1'b0;  // tf_pop8 must be 1 cycle width
end // transmitter8 logic

assign stx_pad_o8 = lcr8[`UART_LC_BC8] ? 1'b0 : stx_o_tmp8;    // Break8 condition
	
endmodule
