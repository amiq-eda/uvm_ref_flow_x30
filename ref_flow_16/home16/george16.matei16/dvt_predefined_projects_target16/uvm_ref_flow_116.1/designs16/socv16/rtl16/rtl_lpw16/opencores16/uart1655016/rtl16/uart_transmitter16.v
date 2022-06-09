//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter16.v                                          ////
////                                                              ////
////                                                              ////
////  This16 file is part of the "UART16 16550 compatible16" project16    ////
////  http16://www16.opencores16.org16/cores16/uart1655016/                   ////
////                                                              ////
////  Documentation16 related16 to this project16:                      ////
////  - http16://www16.opencores16.org16/cores16/uart1655016/                 ////
////                                                              ////
////  Projects16 compatibility16:                                     ////
////  - WISHBONE16                                                  ////
////  RS23216 Protocol16                                              ////
////  16550D uart16 (mostly16 supported)                              ////
////                                                              ////
////  Overview16 (main16 Features16):                                   ////
////  UART16 core16 transmitter16 logic                                 ////
////                                                              ////
////  Known16 problems16 (limits16):                                    ////
////  None16 known16                                                  ////
////                                                              ////
////  To16 Do16:                                                      ////
////  Thourough16 testing16.                                          ////
////                                                              ////
////  Author16(s):                                                  ////
////      - gorban16@opencores16.org16                                  ////
////      - Jacob16 Gorban16                                          ////
////      - Igor16 Mohor16 (igorm16@opencores16.org16)                      ////
////                                                              ////
////  Created16:        2001/05/12                                  ////
////  Last16 Updated16:   2001/05/17                                  ////
////                  (See log16 for the revision16 history16)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2000, 2001 Authors16                             ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS16 Revision16 History16
//
// $Log: not supported by cvs2svn16 $
// Revision16 1.18  2002/07/22 23:02:23  gorban16
// Bug16 Fixes16:
//  * Possible16 loss of sync and bad16 reception16 of stop bit on slow16 baud16 rates16 fixed16.
//   Problem16 reported16 by Kenny16.Tung16.
//  * Bad (or lack16 of ) loopback16 handling16 fixed16. Reported16 by Cherry16 Withers16.
//
// Improvements16:
//  * Made16 FIFO's as general16 inferrable16 memory where possible16.
//  So16 on FPGA16 they should be inferred16 as RAM16 (Distributed16 RAM16 on Xilinx16).
//  This16 saves16 about16 1/3 of the Slice16 count and reduces16 P&R and synthesis16 times.
//
//  * Added16 optional16 baudrate16 output (baud_o16).
//  This16 is identical16 to BAUDOUT16* signal16 on 16550 chip16.
//  It outputs16 16xbit_clock_rate - the divided16 clock16.
//  It's disabled by default. Define16 UART_HAS_BAUDRATE_OUTPUT16 to use.
//
// Revision16 1.16  2002/01/08 11:29:40  mohor16
// tf_pop16 was too wide16. Now16 it is only 1 clk16 cycle width.
//
// Revision16 1.15  2001/12/17 14:46:48  mohor16
// overrun16 signal16 was moved to separate16 block because many16 sequential16 lsr16
// reads were16 preventing16 data from being written16 to rx16 fifo.
// underrun16 signal16 was not used and was removed from the project16.
//
// Revision16 1.14  2001/12/03 21:44:29  gorban16
// Updated16 specification16 documentation.
// Added16 full 32-bit data bus interface, now as default.
// Address is 5-bit wide16 in 32-bit data bus mode.
// Added16 wb_sel_i16 input to the core16. It's used in the 32-bit mode.
// Added16 debug16 interface with two16 32-bit read-only registers in 32-bit mode.
// Bits16 5 and 6 of LSR16 are now only cleared16 on TX16 FIFO write.
// My16 small test bench16 is modified to work16 with 32-bit mode.
//
// Revision16 1.13  2001/11/08 14:54:23  mohor16
// Comments16 in Slovene16 language16 deleted16, few16 small fixes16 for better16 work16 of
// old16 tools16. IRQs16 need to be fix16.
//
// Revision16 1.12  2001/11/07 17:51:52  gorban16
// Heavily16 rewritten16 interrupt16 and LSR16 subsystems16.
// Many16 bugs16 hopefully16 squashed16.
//
// Revision16 1.11  2001/10/29 17:00:46  gorban16
// fixed16 parity16 sending16 and tx_fifo16 resets16 over- and underrun16
//
// Revision16 1.10  2001/10/20 09:58:40  gorban16
// Small16 synopsis16 fixes16
//
// Revision16 1.9  2001/08/24 21:01:12  mohor16
// Things16 connected16 to parity16 changed.
// Clock16 devider16 changed.
//
// Revision16 1.8  2001/08/23 16:05:05  mohor16
// Stop bit bug16 fixed16.
// Parity16 bug16 fixed16.
// WISHBONE16 read cycle bug16 fixed16,
// OE16 indicator16 (Overrun16 Error) bug16 fixed16.
// PE16 indicator16 (Parity16 Error) bug16 fixed16.
// Register read bug16 fixed16.
//
// Revision16 1.6  2001/06/23 11:21:48  gorban16
// DL16 made16 16-bit long16. Fixed16 transmission16/reception16 bugs16.
//
// Revision16 1.5  2001/06/02 14:28:14  gorban16
// Fixed16 receiver16 and transmitter16. Major16 bug16 fixed16.
//
// Revision16 1.4  2001/05/31 20:08:01  gorban16
// FIFO changes16 and other corrections16.
//
// Revision16 1.3  2001/05/27 17:37:49  gorban16
// Fixed16 many16 bugs16. Updated16 spec16. Changed16 FIFO files structure16. See CHANGES16.txt16 file.
//
// Revision16 1.2  2001/05/21 19:12:02  gorban16
// Corrected16 some16 Linter16 messages16.
//
// Revision16 1.1  2001/05/17 18:34:18  gorban16
// First16 'stable' release. Should16 be sythesizable16 now. Also16 added new header.
//
// Revision16 1.0  2001-05-17 21:27:12+02  jacob16
// Initial16 revision16
//
//

// synopsys16 translate_off16
`include "timescale.v"
// synopsys16 translate_on16

`include "uart_defines16.v"

module uart_transmitter16 (clk16, wb_rst_i16, lcr16, tf_push16, wb_dat_i16, enable,	stx_pad_o16, tstate16, tf_count16, tx_reset16, lsr_mask16);

input 										clk16;
input 										wb_rst_i16;
input [7:0] 								lcr16;
input 										tf_push16;
input [7:0] 								wb_dat_i16;
input 										enable;
input 										tx_reset16;
input 										lsr_mask16; //reset of fifo
output 										stx_pad_o16;
output [2:0] 								tstate16;
output [`UART_FIFO_COUNTER_W16-1:0] 	tf_count16;

reg [2:0] 									tstate16;
reg [4:0] 									counter;
reg [2:0] 									bit_counter16;   // counts16 the bits to be sent16
reg [6:0] 									shift_out16;	// output shift16 register
reg 											stx_o_tmp16;
reg 											parity_xor16;  // parity16 of the word16
reg 											tf_pop16;
reg 											bit_out16;

// TX16 FIFO instance
//
// Transmitter16 FIFO signals16
wire [`UART_FIFO_WIDTH16-1:0] 			tf_data_in16;
wire [`UART_FIFO_WIDTH16-1:0] 			tf_data_out16;
wire 											tf_push16;
wire 											tf_overrun16;
wire [`UART_FIFO_COUNTER_W16-1:0] 		tf_count16;

assign 										tf_data_in16 = wb_dat_i16;

uart_tfifo16 fifo_tx16(	// error bit signal16 is not used in transmitter16 FIFO
	.clk16(		clk16		), 
	.wb_rst_i16(	wb_rst_i16	),
	.data_in16(	tf_data_in16	),
	.data_out16(	tf_data_out16	),
	.push16(		tf_push16		),
	.pop16(		tf_pop16		),
	.overrun16(	tf_overrun16	),
	.count(		tf_count16	),
	.fifo_reset16(	tx_reset16	),
	.reset_status16(lsr_mask16)
);

// TRANSMITTER16 FINAL16 STATE16 MACHINE16

parameter s_idle16        = 3'd0;
parameter s_send_start16  = 3'd1;
parameter s_send_byte16   = 3'd2;
parameter s_send_parity16 = 3'd3;
parameter s_send_stop16   = 3'd4;
parameter s_pop_byte16    = 3'd5;

always @(posedge clk16 or posedge wb_rst_i16)
begin
  if (wb_rst_i16)
  begin
	tstate16       <= #1 s_idle16;
	stx_o_tmp16       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out16   <= #1 7'b0;
	bit_out16     <= #1 1'b0;
	parity_xor16  <= #1 1'b0;
	tf_pop16      <= #1 1'b0;
	bit_counter16 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate16)
	s_idle16	 :	if (~|tf_count16) // if tf_count16==0
			begin
				tstate16 <= #1 s_idle16;
				stx_o_tmp16 <= #1 1'b1;
			end
			else
			begin
				tf_pop16 <= #1 1'b0;
				stx_o_tmp16  <= #1 1'b1;
				tstate16  <= #1 s_pop_byte16;
			end
	s_pop_byte16 :	begin
				tf_pop16 <= #1 1'b1;
				case (lcr16[/*`UART_LC_BITS16*/1:0])  // number16 of bits in a word16
				2'b00 : begin
					bit_counter16 <= #1 3'b100;
					parity_xor16  <= #1 ^tf_data_out16[4:0];
				     end
				2'b01 : begin
					bit_counter16 <= #1 3'b101;
					parity_xor16  <= #1 ^tf_data_out16[5:0];
				     end
				2'b10 : begin
					bit_counter16 <= #1 3'b110;
					parity_xor16  <= #1 ^tf_data_out16[6:0];
				     end
				2'b11 : begin
					bit_counter16 <= #1 3'b111;
					parity_xor16  <= #1 ^tf_data_out16[7:0];
				     end
				endcase
				{shift_out16[6:0], bit_out16} <= #1 tf_data_out16;
				tstate16 <= #1 s_send_start16;
			end
	s_send_start16 :	begin
				tf_pop16 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate16 <= #1 s_send_byte16;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp16 <= #1 1'b0;
			end
	s_send_byte16 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter16 > 3'b0)
					begin
						bit_counter16 <= #1 bit_counter16 - 1'b1;
						{shift_out16[5:0],bit_out16  } <= #1 {shift_out16[6:1], shift_out16[0]};
						tstate16 <= #1 s_send_byte16;
					end
					else   // end of byte
					if (~lcr16[`UART_LC_PE16])
					begin
						tstate16 <= #1 s_send_stop16;
					end
					else
					begin
						case ({lcr16[`UART_LC_EP16],lcr16[`UART_LC_SP16]})
						2'b00:	bit_out16 <= #1 ~parity_xor16;
						2'b01:	bit_out16 <= #1 1'b1;
						2'b10:	bit_out16 <= #1 parity_xor16;
						2'b11:	bit_out16 <= #1 1'b0;
						endcase
						tstate16 <= #1 s_send_parity16;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp16 <= #1 bit_out16; // set output pin16
			end
	s_send_parity16 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate16 <= #1 s_send_stop16;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp16 <= #1 bit_out16;
			end
	s_send_stop16 :  begin
				if (~|counter)
				  begin
						casex ({lcr16[`UART_LC_SB16],lcr16[`UART_LC_BITS16]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor16
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate16 <= #1 s_idle16;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp16 <= #1 1'b1;
			end

		default : // should never get here16
			tstate16 <= #1 s_idle16;
	endcase
  end // end if enable
  else
    tf_pop16 <= #1 1'b0;  // tf_pop16 must be 1 cycle width
end // transmitter16 logic

assign stx_pad_o16 = lcr16[`UART_LC_BC16] ? 1'b0 : stx_o_tmp16;    // Break16 condition
	
endmodule
