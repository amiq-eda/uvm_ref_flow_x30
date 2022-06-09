//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter25.v                                          ////
////                                                              ////
////                                                              ////
////  This25 file is part of the "UART25 16550 compatible25" project25    ////
////  http25://www25.opencores25.org25/cores25/uart1655025/                   ////
////                                                              ////
////  Documentation25 related25 to this project25:                      ////
////  - http25://www25.opencores25.org25/cores25/uart1655025/                 ////
////                                                              ////
////  Projects25 compatibility25:                                     ////
////  - WISHBONE25                                                  ////
////  RS23225 Protocol25                                              ////
////  16550D uart25 (mostly25 supported)                              ////
////                                                              ////
////  Overview25 (main25 Features25):                                   ////
////  UART25 core25 transmitter25 logic                                 ////
////                                                              ////
////  Known25 problems25 (limits25):                                    ////
////  None25 known25                                                  ////
////                                                              ////
////  To25 Do25:                                                      ////
////  Thourough25 testing25.                                          ////
////                                                              ////
////  Author25(s):                                                  ////
////      - gorban25@opencores25.org25                                  ////
////      - Jacob25 Gorban25                                          ////
////      - Igor25 Mohor25 (igorm25@opencores25.org25)                      ////
////                                                              ////
////  Created25:        2001/05/12                                  ////
////  Last25 Updated25:   2001/05/17                                  ////
////                  (See log25 for the revision25 history25)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2000, 2001 Authors25                             ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS25 Revision25 History25
//
// $Log: not supported by cvs2svn25 $
// Revision25 1.18  2002/07/22 23:02:23  gorban25
// Bug25 Fixes25:
//  * Possible25 loss of sync and bad25 reception25 of stop bit on slow25 baud25 rates25 fixed25.
//   Problem25 reported25 by Kenny25.Tung25.
//  * Bad (or lack25 of ) loopback25 handling25 fixed25. Reported25 by Cherry25 Withers25.
//
// Improvements25:
//  * Made25 FIFO's as general25 inferrable25 memory where possible25.
//  So25 on FPGA25 they should be inferred25 as RAM25 (Distributed25 RAM25 on Xilinx25).
//  This25 saves25 about25 1/3 of the Slice25 count and reduces25 P&R and synthesis25 times.
//
//  * Added25 optional25 baudrate25 output (baud_o25).
//  This25 is identical25 to BAUDOUT25* signal25 on 16550 chip25.
//  It outputs25 16xbit_clock_rate - the divided25 clock25.
//  It's disabled by default. Define25 UART_HAS_BAUDRATE_OUTPUT25 to use.
//
// Revision25 1.16  2002/01/08 11:29:40  mohor25
// tf_pop25 was too wide25. Now25 it is only 1 clk25 cycle width.
//
// Revision25 1.15  2001/12/17 14:46:48  mohor25
// overrun25 signal25 was moved to separate25 block because many25 sequential25 lsr25
// reads were25 preventing25 data from being written25 to rx25 fifo.
// underrun25 signal25 was not used and was removed from the project25.
//
// Revision25 1.14  2001/12/03 21:44:29  gorban25
// Updated25 specification25 documentation.
// Added25 full 32-bit data bus interface, now as default.
// Address is 5-bit wide25 in 32-bit data bus mode.
// Added25 wb_sel_i25 input to the core25. It's used in the 32-bit mode.
// Added25 debug25 interface with two25 32-bit read-only registers in 32-bit mode.
// Bits25 5 and 6 of LSR25 are now only cleared25 on TX25 FIFO write.
// My25 small test bench25 is modified to work25 with 32-bit mode.
//
// Revision25 1.13  2001/11/08 14:54:23  mohor25
// Comments25 in Slovene25 language25 deleted25, few25 small fixes25 for better25 work25 of
// old25 tools25. IRQs25 need to be fix25.
//
// Revision25 1.12  2001/11/07 17:51:52  gorban25
// Heavily25 rewritten25 interrupt25 and LSR25 subsystems25.
// Many25 bugs25 hopefully25 squashed25.
//
// Revision25 1.11  2001/10/29 17:00:46  gorban25
// fixed25 parity25 sending25 and tx_fifo25 resets25 over- and underrun25
//
// Revision25 1.10  2001/10/20 09:58:40  gorban25
// Small25 synopsis25 fixes25
//
// Revision25 1.9  2001/08/24 21:01:12  mohor25
// Things25 connected25 to parity25 changed.
// Clock25 devider25 changed.
//
// Revision25 1.8  2001/08/23 16:05:05  mohor25
// Stop bit bug25 fixed25.
// Parity25 bug25 fixed25.
// WISHBONE25 read cycle bug25 fixed25,
// OE25 indicator25 (Overrun25 Error) bug25 fixed25.
// PE25 indicator25 (Parity25 Error) bug25 fixed25.
// Register read bug25 fixed25.
//
// Revision25 1.6  2001/06/23 11:21:48  gorban25
// DL25 made25 16-bit long25. Fixed25 transmission25/reception25 bugs25.
//
// Revision25 1.5  2001/06/02 14:28:14  gorban25
// Fixed25 receiver25 and transmitter25. Major25 bug25 fixed25.
//
// Revision25 1.4  2001/05/31 20:08:01  gorban25
// FIFO changes25 and other corrections25.
//
// Revision25 1.3  2001/05/27 17:37:49  gorban25
// Fixed25 many25 bugs25. Updated25 spec25. Changed25 FIFO files structure25. See CHANGES25.txt25 file.
//
// Revision25 1.2  2001/05/21 19:12:02  gorban25
// Corrected25 some25 Linter25 messages25.
//
// Revision25 1.1  2001/05/17 18:34:18  gorban25
// First25 'stable' release. Should25 be sythesizable25 now. Also25 added new header.
//
// Revision25 1.0  2001-05-17 21:27:12+02  jacob25
// Initial25 revision25
//
//

// synopsys25 translate_off25
`include "timescale.v"
// synopsys25 translate_on25

`include "uart_defines25.v"

module uart_transmitter25 (clk25, wb_rst_i25, lcr25, tf_push25, wb_dat_i25, enable,	stx_pad_o25, tstate25, tf_count25, tx_reset25, lsr_mask25);

input 										clk25;
input 										wb_rst_i25;
input [7:0] 								lcr25;
input 										tf_push25;
input [7:0] 								wb_dat_i25;
input 										enable;
input 										tx_reset25;
input 										lsr_mask25; //reset of fifo
output 										stx_pad_o25;
output [2:0] 								tstate25;
output [`UART_FIFO_COUNTER_W25-1:0] 	tf_count25;

reg [2:0] 									tstate25;
reg [4:0] 									counter;
reg [2:0] 									bit_counter25;   // counts25 the bits to be sent25
reg [6:0] 									shift_out25;	// output shift25 register
reg 											stx_o_tmp25;
reg 											parity_xor25;  // parity25 of the word25
reg 											tf_pop25;
reg 											bit_out25;

// TX25 FIFO instance
//
// Transmitter25 FIFO signals25
wire [`UART_FIFO_WIDTH25-1:0] 			tf_data_in25;
wire [`UART_FIFO_WIDTH25-1:0] 			tf_data_out25;
wire 											tf_push25;
wire 											tf_overrun25;
wire [`UART_FIFO_COUNTER_W25-1:0] 		tf_count25;

assign 										tf_data_in25 = wb_dat_i25;

uart_tfifo25 fifo_tx25(	// error bit signal25 is not used in transmitter25 FIFO
	.clk25(		clk25		), 
	.wb_rst_i25(	wb_rst_i25	),
	.data_in25(	tf_data_in25	),
	.data_out25(	tf_data_out25	),
	.push25(		tf_push25		),
	.pop25(		tf_pop25		),
	.overrun25(	tf_overrun25	),
	.count(		tf_count25	),
	.fifo_reset25(	tx_reset25	),
	.reset_status25(lsr_mask25)
);

// TRANSMITTER25 FINAL25 STATE25 MACHINE25

parameter s_idle25        = 3'd0;
parameter s_send_start25  = 3'd1;
parameter s_send_byte25   = 3'd2;
parameter s_send_parity25 = 3'd3;
parameter s_send_stop25   = 3'd4;
parameter s_pop_byte25    = 3'd5;

always @(posedge clk25 or posedge wb_rst_i25)
begin
  if (wb_rst_i25)
  begin
	tstate25       <= #1 s_idle25;
	stx_o_tmp25       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out25   <= #1 7'b0;
	bit_out25     <= #1 1'b0;
	parity_xor25  <= #1 1'b0;
	tf_pop25      <= #1 1'b0;
	bit_counter25 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate25)
	s_idle25	 :	if (~|tf_count25) // if tf_count25==0
			begin
				tstate25 <= #1 s_idle25;
				stx_o_tmp25 <= #1 1'b1;
			end
			else
			begin
				tf_pop25 <= #1 1'b0;
				stx_o_tmp25  <= #1 1'b1;
				tstate25  <= #1 s_pop_byte25;
			end
	s_pop_byte25 :	begin
				tf_pop25 <= #1 1'b1;
				case (lcr25[/*`UART_LC_BITS25*/1:0])  // number25 of bits in a word25
				2'b00 : begin
					bit_counter25 <= #1 3'b100;
					parity_xor25  <= #1 ^tf_data_out25[4:0];
				     end
				2'b01 : begin
					bit_counter25 <= #1 3'b101;
					parity_xor25  <= #1 ^tf_data_out25[5:0];
				     end
				2'b10 : begin
					bit_counter25 <= #1 3'b110;
					parity_xor25  <= #1 ^tf_data_out25[6:0];
				     end
				2'b11 : begin
					bit_counter25 <= #1 3'b111;
					parity_xor25  <= #1 ^tf_data_out25[7:0];
				     end
				endcase
				{shift_out25[6:0], bit_out25} <= #1 tf_data_out25;
				tstate25 <= #1 s_send_start25;
			end
	s_send_start25 :	begin
				tf_pop25 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate25 <= #1 s_send_byte25;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp25 <= #1 1'b0;
			end
	s_send_byte25 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter25 > 3'b0)
					begin
						bit_counter25 <= #1 bit_counter25 - 1'b1;
						{shift_out25[5:0],bit_out25  } <= #1 {shift_out25[6:1], shift_out25[0]};
						tstate25 <= #1 s_send_byte25;
					end
					else   // end of byte
					if (~lcr25[`UART_LC_PE25])
					begin
						tstate25 <= #1 s_send_stop25;
					end
					else
					begin
						case ({lcr25[`UART_LC_EP25],lcr25[`UART_LC_SP25]})
						2'b00:	bit_out25 <= #1 ~parity_xor25;
						2'b01:	bit_out25 <= #1 1'b1;
						2'b10:	bit_out25 <= #1 parity_xor25;
						2'b11:	bit_out25 <= #1 1'b0;
						endcase
						tstate25 <= #1 s_send_parity25;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp25 <= #1 bit_out25; // set output pin25
			end
	s_send_parity25 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate25 <= #1 s_send_stop25;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp25 <= #1 bit_out25;
			end
	s_send_stop25 :  begin
				if (~|counter)
				  begin
						casex ({lcr25[`UART_LC_SB25],lcr25[`UART_LC_BITS25]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor25
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate25 <= #1 s_idle25;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp25 <= #1 1'b1;
			end

		default : // should never get here25
			tstate25 <= #1 s_idle25;
	endcase
  end // end if enable
  else
    tf_pop25 <= #1 1'b0;  // tf_pop25 must be 1 cycle width
end // transmitter25 logic

assign stx_pad_o25 = lcr25[`UART_LC_BC25] ? 1'b0 : stx_o_tmp25;    // Break25 condition
	
endmodule
