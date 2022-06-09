//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter29.v                                          ////
////                                                              ////
////                                                              ////
////  This29 file is part of the "UART29 16550 compatible29" project29    ////
////  http29://www29.opencores29.org29/cores29/uart1655029/                   ////
////                                                              ////
////  Documentation29 related29 to this project29:                      ////
////  - http29://www29.opencores29.org29/cores29/uart1655029/                 ////
////                                                              ////
////  Projects29 compatibility29:                                     ////
////  - WISHBONE29                                                  ////
////  RS23229 Protocol29                                              ////
////  16550D uart29 (mostly29 supported)                              ////
////                                                              ////
////  Overview29 (main29 Features29):                                   ////
////  UART29 core29 transmitter29 logic                                 ////
////                                                              ////
////  Known29 problems29 (limits29):                                    ////
////  None29 known29                                                  ////
////                                                              ////
////  To29 Do29:                                                      ////
////  Thourough29 testing29.                                          ////
////                                                              ////
////  Author29(s):                                                  ////
////      - gorban29@opencores29.org29                                  ////
////      - Jacob29 Gorban29                                          ////
////      - Igor29 Mohor29 (igorm29@opencores29.org29)                      ////
////                                                              ////
////  Created29:        2001/05/12                                  ////
////  Last29 Updated29:   2001/05/17                                  ////
////                  (See log29 for the revision29 history29)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2000, 2001 Authors29                             ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS29 Revision29 History29
//
// $Log: not supported by cvs2svn29 $
// Revision29 1.18  2002/07/22 23:02:23  gorban29
// Bug29 Fixes29:
//  * Possible29 loss of sync and bad29 reception29 of stop bit on slow29 baud29 rates29 fixed29.
//   Problem29 reported29 by Kenny29.Tung29.
//  * Bad (or lack29 of ) loopback29 handling29 fixed29. Reported29 by Cherry29 Withers29.
//
// Improvements29:
//  * Made29 FIFO's as general29 inferrable29 memory where possible29.
//  So29 on FPGA29 they should be inferred29 as RAM29 (Distributed29 RAM29 on Xilinx29).
//  This29 saves29 about29 1/3 of the Slice29 count and reduces29 P&R and synthesis29 times.
//
//  * Added29 optional29 baudrate29 output (baud_o29).
//  This29 is identical29 to BAUDOUT29* signal29 on 16550 chip29.
//  It outputs29 16xbit_clock_rate - the divided29 clock29.
//  It's disabled by default. Define29 UART_HAS_BAUDRATE_OUTPUT29 to use.
//
// Revision29 1.16  2002/01/08 11:29:40  mohor29
// tf_pop29 was too wide29. Now29 it is only 1 clk29 cycle width.
//
// Revision29 1.15  2001/12/17 14:46:48  mohor29
// overrun29 signal29 was moved to separate29 block because many29 sequential29 lsr29
// reads were29 preventing29 data from being written29 to rx29 fifo.
// underrun29 signal29 was not used and was removed from the project29.
//
// Revision29 1.14  2001/12/03 21:44:29  gorban29
// Updated29 specification29 documentation.
// Added29 full 32-bit data bus interface, now as default.
// Address is 5-bit wide29 in 32-bit data bus mode.
// Added29 wb_sel_i29 input to the core29. It's used in the 32-bit mode.
// Added29 debug29 interface with two29 32-bit read-only registers in 32-bit mode.
// Bits29 5 and 6 of LSR29 are now only cleared29 on TX29 FIFO write.
// My29 small test bench29 is modified to work29 with 32-bit mode.
//
// Revision29 1.13  2001/11/08 14:54:23  mohor29
// Comments29 in Slovene29 language29 deleted29, few29 small fixes29 for better29 work29 of
// old29 tools29. IRQs29 need to be fix29.
//
// Revision29 1.12  2001/11/07 17:51:52  gorban29
// Heavily29 rewritten29 interrupt29 and LSR29 subsystems29.
// Many29 bugs29 hopefully29 squashed29.
//
// Revision29 1.11  2001/10/29 17:00:46  gorban29
// fixed29 parity29 sending29 and tx_fifo29 resets29 over- and underrun29
//
// Revision29 1.10  2001/10/20 09:58:40  gorban29
// Small29 synopsis29 fixes29
//
// Revision29 1.9  2001/08/24 21:01:12  mohor29
// Things29 connected29 to parity29 changed.
// Clock29 devider29 changed.
//
// Revision29 1.8  2001/08/23 16:05:05  mohor29
// Stop bit bug29 fixed29.
// Parity29 bug29 fixed29.
// WISHBONE29 read cycle bug29 fixed29,
// OE29 indicator29 (Overrun29 Error) bug29 fixed29.
// PE29 indicator29 (Parity29 Error) bug29 fixed29.
// Register read bug29 fixed29.
//
// Revision29 1.6  2001/06/23 11:21:48  gorban29
// DL29 made29 16-bit long29. Fixed29 transmission29/reception29 bugs29.
//
// Revision29 1.5  2001/06/02 14:28:14  gorban29
// Fixed29 receiver29 and transmitter29. Major29 bug29 fixed29.
//
// Revision29 1.4  2001/05/31 20:08:01  gorban29
// FIFO changes29 and other corrections29.
//
// Revision29 1.3  2001/05/27 17:37:49  gorban29
// Fixed29 many29 bugs29. Updated29 spec29. Changed29 FIFO files structure29. See CHANGES29.txt29 file.
//
// Revision29 1.2  2001/05/21 19:12:02  gorban29
// Corrected29 some29 Linter29 messages29.
//
// Revision29 1.1  2001/05/17 18:34:18  gorban29
// First29 'stable' release. Should29 be sythesizable29 now. Also29 added new header.
//
// Revision29 1.0  2001-05-17 21:27:12+02  jacob29
// Initial29 revision29
//
//

// synopsys29 translate_off29
`include "timescale.v"
// synopsys29 translate_on29

`include "uart_defines29.v"

module uart_transmitter29 (clk29, wb_rst_i29, lcr29, tf_push29, wb_dat_i29, enable,	stx_pad_o29, tstate29, tf_count29, tx_reset29, lsr_mask29);

input 										clk29;
input 										wb_rst_i29;
input [7:0] 								lcr29;
input 										tf_push29;
input [7:0] 								wb_dat_i29;
input 										enable;
input 										tx_reset29;
input 										lsr_mask29; //reset of fifo
output 										stx_pad_o29;
output [2:0] 								tstate29;
output [`UART_FIFO_COUNTER_W29-1:0] 	tf_count29;

reg [2:0] 									tstate29;
reg [4:0] 									counter;
reg [2:0] 									bit_counter29;   // counts29 the bits to be sent29
reg [6:0] 									shift_out29;	// output shift29 register
reg 											stx_o_tmp29;
reg 											parity_xor29;  // parity29 of the word29
reg 											tf_pop29;
reg 											bit_out29;

// TX29 FIFO instance
//
// Transmitter29 FIFO signals29
wire [`UART_FIFO_WIDTH29-1:0] 			tf_data_in29;
wire [`UART_FIFO_WIDTH29-1:0] 			tf_data_out29;
wire 											tf_push29;
wire 											tf_overrun29;
wire [`UART_FIFO_COUNTER_W29-1:0] 		tf_count29;

assign 										tf_data_in29 = wb_dat_i29;

uart_tfifo29 fifo_tx29(	// error bit signal29 is not used in transmitter29 FIFO
	.clk29(		clk29		), 
	.wb_rst_i29(	wb_rst_i29	),
	.data_in29(	tf_data_in29	),
	.data_out29(	tf_data_out29	),
	.push29(		tf_push29		),
	.pop29(		tf_pop29		),
	.overrun29(	tf_overrun29	),
	.count(		tf_count29	),
	.fifo_reset29(	tx_reset29	),
	.reset_status29(lsr_mask29)
);

// TRANSMITTER29 FINAL29 STATE29 MACHINE29

parameter s_idle29        = 3'd0;
parameter s_send_start29  = 3'd1;
parameter s_send_byte29   = 3'd2;
parameter s_send_parity29 = 3'd3;
parameter s_send_stop29   = 3'd4;
parameter s_pop_byte29    = 3'd5;

always @(posedge clk29 or posedge wb_rst_i29)
begin
  if (wb_rst_i29)
  begin
	tstate29       <= #1 s_idle29;
	stx_o_tmp29       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out29   <= #1 7'b0;
	bit_out29     <= #1 1'b0;
	parity_xor29  <= #1 1'b0;
	tf_pop29      <= #1 1'b0;
	bit_counter29 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate29)
	s_idle29	 :	if (~|tf_count29) // if tf_count29==0
			begin
				tstate29 <= #1 s_idle29;
				stx_o_tmp29 <= #1 1'b1;
			end
			else
			begin
				tf_pop29 <= #1 1'b0;
				stx_o_tmp29  <= #1 1'b1;
				tstate29  <= #1 s_pop_byte29;
			end
	s_pop_byte29 :	begin
				tf_pop29 <= #1 1'b1;
				case (lcr29[/*`UART_LC_BITS29*/1:0])  // number29 of bits in a word29
				2'b00 : begin
					bit_counter29 <= #1 3'b100;
					parity_xor29  <= #1 ^tf_data_out29[4:0];
				     end
				2'b01 : begin
					bit_counter29 <= #1 3'b101;
					parity_xor29  <= #1 ^tf_data_out29[5:0];
				     end
				2'b10 : begin
					bit_counter29 <= #1 3'b110;
					parity_xor29  <= #1 ^tf_data_out29[6:0];
				     end
				2'b11 : begin
					bit_counter29 <= #1 3'b111;
					parity_xor29  <= #1 ^tf_data_out29[7:0];
				     end
				endcase
				{shift_out29[6:0], bit_out29} <= #1 tf_data_out29;
				tstate29 <= #1 s_send_start29;
			end
	s_send_start29 :	begin
				tf_pop29 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate29 <= #1 s_send_byte29;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp29 <= #1 1'b0;
			end
	s_send_byte29 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter29 > 3'b0)
					begin
						bit_counter29 <= #1 bit_counter29 - 1'b1;
						{shift_out29[5:0],bit_out29  } <= #1 {shift_out29[6:1], shift_out29[0]};
						tstate29 <= #1 s_send_byte29;
					end
					else   // end of byte
					if (~lcr29[`UART_LC_PE29])
					begin
						tstate29 <= #1 s_send_stop29;
					end
					else
					begin
						case ({lcr29[`UART_LC_EP29],lcr29[`UART_LC_SP29]})
						2'b00:	bit_out29 <= #1 ~parity_xor29;
						2'b01:	bit_out29 <= #1 1'b1;
						2'b10:	bit_out29 <= #1 parity_xor29;
						2'b11:	bit_out29 <= #1 1'b0;
						endcase
						tstate29 <= #1 s_send_parity29;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp29 <= #1 bit_out29; // set output pin29
			end
	s_send_parity29 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate29 <= #1 s_send_stop29;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp29 <= #1 bit_out29;
			end
	s_send_stop29 :  begin
				if (~|counter)
				  begin
						casex ({lcr29[`UART_LC_SB29],lcr29[`UART_LC_BITS29]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor29
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate29 <= #1 s_idle29;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp29 <= #1 1'b1;
			end

		default : // should never get here29
			tstate29 <= #1 s_idle29;
	endcase
  end // end if enable
  else
    tf_pop29 <= #1 1'b0;  // tf_pop29 must be 1 cycle width
end // transmitter29 logic

assign stx_pad_o29 = lcr29[`UART_LC_BC29] ? 1'b0 : stx_o_tmp29;    // Break29 condition
	
endmodule
