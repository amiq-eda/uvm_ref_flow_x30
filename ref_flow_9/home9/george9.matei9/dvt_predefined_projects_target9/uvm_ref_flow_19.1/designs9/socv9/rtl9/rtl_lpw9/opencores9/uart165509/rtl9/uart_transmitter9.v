//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter9.v                                          ////
////                                                              ////
////                                                              ////
////  This9 file is part of the "UART9 16550 compatible9" project9    ////
////  http9://www9.opencores9.org9/cores9/uart165509/                   ////
////                                                              ////
////  Documentation9 related9 to this project9:                      ////
////  - http9://www9.opencores9.org9/cores9/uart165509/                 ////
////                                                              ////
////  Projects9 compatibility9:                                     ////
////  - WISHBONE9                                                  ////
////  RS2329 Protocol9                                              ////
////  16550D uart9 (mostly9 supported)                              ////
////                                                              ////
////  Overview9 (main9 Features9):                                   ////
////  UART9 core9 transmitter9 logic                                 ////
////                                                              ////
////  Known9 problems9 (limits9):                                    ////
////  None9 known9                                                  ////
////                                                              ////
////  To9 Do9:                                                      ////
////  Thourough9 testing9.                                          ////
////                                                              ////
////  Author9(s):                                                  ////
////      - gorban9@opencores9.org9                                  ////
////      - Jacob9 Gorban9                                          ////
////      - Igor9 Mohor9 (igorm9@opencores9.org9)                      ////
////                                                              ////
////  Created9:        2001/05/12                                  ////
////  Last9 Updated9:   2001/05/17                                  ////
////                  (See log9 for the revision9 history9)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2000, 2001 Authors9                             ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS9 Revision9 History9
//
// $Log: not supported by cvs2svn9 $
// Revision9 1.18  2002/07/22 23:02:23  gorban9
// Bug9 Fixes9:
//  * Possible9 loss of sync and bad9 reception9 of stop bit on slow9 baud9 rates9 fixed9.
//   Problem9 reported9 by Kenny9.Tung9.
//  * Bad (or lack9 of ) loopback9 handling9 fixed9. Reported9 by Cherry9 Withers9.
//
// Improvements9:
//  * Made9 FIFO's as general9 inferrable9 memory where possible9.
//  So9 on FPGA9 they should be inferred9 as RAM9 (Distributed9 RAM9 on Xilinx9).
//  This9 saves9 about9 1/3 of the Slice9 count and reduces9 P&R and synthesis9 times.
//
//  * Added9 optional9 baudrate9 output (baud_o9).
//  This9 is identical9 to BAUDOUT9* signal9 on 16550 chip9.
//  It outputs9 16xbit_clock_rate - the divided9 clock9.
//  It's disabled by default. Define9 UART_HAS_BAUDRATE_OUTPUT9 to use.
//
// Revision9 1.16  2002/01/08 11:29:40  mohor9
// tf_pop9 was too wide9. Now9 it is only 1 clk9 cycle width.
//
// Revision9 1.15  2001/12/17 14:46:48  mohor9
// overrun9 signal9 was moved to separate9 block because many9 sequential9 lsr9
// reads were9 preventing9 data from being written9 to rx9 fifo.
// underrun9 signal9 was not used and was removed from the project9.
//
// Revision9 1.14  2001/12/03 21:44:29  gorban9
// Updated9 specification9 documentation.
// Added9 full 32-bit data bus interface, now as default.
// Address is 5-bit wide9 in 32-bit data bus mode.
// Added9 wb_sel_i9 input to the core9. It's used in the 32-bit mode.
// Added9 debug9 interface with two9 32-bit read-only registers in 32-bit mode.
// Bits9 5 and 6 of LSR9 are now only cleared9 on TX9 FIFO write.
// My9 small test bench9 is modified to work9 with 32-bit mode.
//
// Revision9 1.13  2001/11/08 14:54:23  mohor9
// Comments9 in Slovene9 language9 deleted9, few9 small fixes9 for better9 work9 of
// old9 tools9. IRQs9 need to be fix9.
//
// Revision9 1.12  2001/11/07 17:51:52  gorban9
// Heavily9 rewritten9 interrupt9 and LSR9 subsystems9.
// Many9 bugs9 hopefully9 squashed9.
//
// Revision9 1.11  2001/10/29 17:00:46  gorban9
// fixed9 parity9 sending9 and tx_fifo9 resets9 over- and underrun9
//
// Revision9 1.10  2001/10/20 09:58:40  gorban9
// Small9 synopsis9 fixes9
//
// Revision9 1.9  2001/08/24 21:01:12  mohor9
// Things9 connected9 to parity9 changed.
// Clock9 devider9 changed.
//
// Revision9 1.8  2001/08/23 16:05:05  mohor9
// Stop bit bug9 fixed9.
// Parity9 bug9 fixed9.
// WISHBONE9 read cycle bug9 fixed9,
// OE9 indicator9 (Overrun9 Error) bug9 fixed9.
// PE9 indicator9 (Parity9 Error) bug9 fixed9.
// Register read bug9 fixed9.
//
// Revision9 1.6  2001/06/23 11:21:48  gorban9
// DL9 made9 16-bit long9. Fixed9 transmission9/reception9 bugs9.
//
// Revision9 1.5  2001/06/02 14:28:14  gorban9
// Fixed9 receiver9 and transmitter9. Major9 bug9 fixed9.
//
// Revision9 1.4  2001/05/31 20:08:01  gorban9
// FIFO changes9 and other corrections9.
//
// Revision9 1.3  2001/05/27 17:37:49  gorban9
// Fixed9 many9 bugs9. Updated9 spec9. Changed9 FIFO files structure9. See CHANGES9.txt9 file.
//
// Revision9 1.2  2001/05/21 19:12:02  gorban9
// Corrected9 some9 Linter9 messages9.
//
// Revision9 1.1  2001/05/17 18:34:18  gorban9
// First9 'stable' release. Should9 be sythesizable9 now. Also9 added new header.
//
// Revision9 1.0  2001-05-17 21:27:12+02  jacob9
// Initial9 revision9
//
//

// synopsys9 translate_off9
`include "timescale.v"
// synopsys9 translate_on9

`include "uart_defines9.v"

module uart_transmitter9 (clk9, wb_rst_i9, lcr9, tf_push9, wb_dat_i9, enable,	stx_pad_o9, tstate9, tf_count9, tx_reset9, lsr_mask9);

input 										clk9;
input 										wb_rst_i9;
input [7:0] 								lcr9;
input 										tf_push9;
input [7:0] 								wb_dat_i9;
input 										enable;
input 										tx_reset9;
input 										lsr_mask9; //reset of fifo
output 										stx_pad_o9;
output [2:0] 								tstate9;
output [`UART_FIFO_COUNTER_W9-1:0] 	tf_count9;

reg [2:0] 									tstate9;
reg [4:0] 									counter;
reg [2:0] 									bit_counter9;   // counts9 the bits to be sent9
reg [6:0] 									shift_out9;	// output shift9 register
reg 											stx_o_tmp9;
reg 											parity_xor9;  // parity9 of the word9
reg 											tf_pop9;
reg 											bit_out9;

// TX9 FIFO instance
//
// Transmitter9 FIFO signals9
wire [`UART_FIFO_WIDTH9-1:0] 			tf_data_in9;
wire [`UART_FIFO_WIDTH9-1:0] 			tf_data_out9;
wire 											tf_push9;
wire 											tf_overrun9;
wire [`UART_FIFO_COUNTER_W9-1:0] 		tf_count9;

assign 										tf_data_in9 = wb_dat_i9;

uart_tfifo9 fifo_tx9(	// error bit signal9 is not used in transmitter9 FIFO
	.clk9(		clk9		), 
	.wb_rst_i9(	wb_rst_i9	),
	.data_in9(	tf_data_in9	),
	.data_out9(	tf_data_out9	),
	.push9(		tf_push9		),
	.pop9(		tf_pop9		),
	.overrun9(	tf_overrun9	),
	.count(		tf_count9	),
	.fifo_reset9(	tx_reset9	),
	.reset_status9(lsr_mask9)
);

// TRANSMITTER9 FINAL9 STATE9 MACHINE9

parameter s_idle9        = 3'd0;
parameter s_send_start9  = 3'd1;
parameter s_send_byte9   = 3'd2;
parameter s_send_parity9 = 3'd3;
parameter s_send_stop9   = 3'd4;
parameter s_pop_byte9    = 3'd5;

always @(posedge clk9 or posedge wb_rst_i9)
begin
  if (wb_rst_i9)
  begin
	tstate9       <= #1 s_idle9;
	stx_o_tmp9       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out9   <= #1 7'b0;
	bit_out9     <= #1 1'b0;
	parity_xor9  <= #1 1'b0;
	tf_pop9      <= #1 1'b0;
	bit_counter9 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate9)
	s_idle9	 :	if (~|tf_count9) // if tf_count9==0
			begin
				tstate9 <= #1 s_idle9;
				stx_o_tmp9 <= #1 1'b1;
			end
			else
			begin
				tf_pop9 <= #1 1'b0;
				stx_o_tmp9  <= #1 1'b1;
				tstate9  <= #1 s_pop_byte9;
			end
	s_pop_byte9 :	begin
				tf_pop9 <= #1 1'b1;
				case (lcr9[/*`UART_LC_BITS9*/1:0])  // number9 of bits in a word9
				2'b00 : begin
					bit_counter9 <= #1 3'b100;
					parity_xor9  <= #1 ^tf_data_out9[4:0];
				     end
				2'b01 : begin
					bit_counter9 <= #1 3'b101;
					parity_xor9  <= #1 ^tf_data_out9[5:0];
				     end
				2'b10 : begin
					bit_counter9 <= #1 3'b110;
					parity_xor9  <= #1 ^tf_data_out9[6:0];
				     end
				2'b11 : begin
					bit_counter9 <= #1 3'b111;
					parity_xor9  <= #1 ^tf_data_out9[7:0];
				     end
				endcase
				{shift_out9[6:0], bit_out9} <= #1 tf_data_out9;
				tstate9 <= #1 s_send_start9;
			end
	s_send_start9 :	begin
				tf_pop9 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate9 <= #1 s_send_byte9;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp9 <= #1 1'b0;
			end
	s_send_byte9 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter9 > 3'b0)
					begin
						bit_counter9 <= #1 bit_counter9 - 1'b1;
						{shift_out9[5:0],bit_out9  } <= #1 {shift_out9[6:1], shift_out9[0]};
						tstate9 <= #1 s_send_byte9;
					end
					else   // end of byte
					if (~lcr9[`UART_LC_PE9])
					begin
						tstate9 <= #1 s_send_stop9;
					end
					else
					begin
						case ({lcr9[`UART_LC_EP9],lcr9[`UART_LC_SP9]})
						2'b00:	bit_out9 <= #1 ~parity_xor9;
						2'b01:	bit_out9 <= #1 1'b1;
						2'b10:	bit_out9 <= #1 parity_xor9;
						2'b11:	bit_out9 <= #1 1'b0;
						endcase
						tstate9 <= #1 s_send_parity9;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp9 <= #1 bit_out9; // set output pin9
			end
	s_send_parity9 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate9 <= #1 s_send_stop9;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp9 <= #1 bit_out9;
			end
	s_send_stop9 :  begin
				if (~|counter)
				  begin
						casex ({lcr9[`UART_LC_SB9],lcr9[`UART_LC_BITS9]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor9
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate9 <= #1 s_idle9;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp9 <= #1 1'b1;
			end

		default : // should never get here9
			tstate9 <= #1 s_idle9;
	endcase
  end // end if enable
  else
    tf_pop9 <= #1 1'b0;  // tf_pop9 must be 1 cycle width
end // transmitter9 logic

assign stx_pad_o9 = lcr9[`UART_LC_BC9] ? 1'b0 : stx_o_tmp9;    // Break9 condition
	
endmodule
