//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter3.v                                          ////
////                                                              ////
////                                                              ////
////  This3 file is part of the "UART3 16550 compatible3" project3    ////
////  http3://www3.opencores3.org3/cores3/uart165503/                   ////
////                                                              ////
////  Documentation3 related3 to this project3:                      ////
////  - http3://www3.opencores3.org3/cores3/uart165503/                 ////
////                                                              ////
////  Projects3 compatibility3:                                     ////
////  - WISHBONE3                                                  ////
////  RS2323 Protocol3                                              ////
////  16550D uart3 (mostly3 supported)                              ////
////                                                              ////
////  Overview3 (main3 Features3):                                   ////
////  UART3 core3 transmitter3 logic                                 ////
////                                                              ////
////  Known3 problems3 (limits3):                                    ////
////  None3 known3                                                  ////
////                                                              ////
////  To3 Do3:                                                      ////
////  Thourough3 testing3.                                          ////
////                                                              ////
////  Author3(s):                                                  ////
////      - gorban3@opencores3.org3                                  ////
////      - Jacob3 Gorban3                                          ////
////      - Igor3 Mohor3 (igorm3@opencores3.org3)                      ////
////                                                              ////
////  Created3:        2001/05/12                                  ////
////  Last3 Updated3:   2001/05/17                                  ////
////                  (See log3 for the revision3 history3)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2000, 2001 Authors3                             ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS3 Revision3 History3
//
// $Log: not supported by cvs2svn3 $
// Revision3 1.18  2002/07/22 23:02:23  gorban3
// Bug3 Fixes3:
//  * Possible3 loss of sync and bad3 reception3 of stop bit on slow3 baud3 rates3 fixed3.
//   Problem3 reported3 by Kenny3.Tung3.
//  * Bad (or lack3 of ) loopback3 handling3 fixed3. Reported3 by Cherry3 Withers3.
//
// Improvements3:
//  * Made3 FIFO's as general3 inferrable3 memory where possible3.
//  So3 on FPGA3 they should be inferred3 as RAM3 (Distributed3 RAM3 on Xilinx3).
//  This3 saves3 about3 1/3 of the Slice3 count and reduces3 P&R and synthesis3 times.
//
//  * Added3 optional3 baudrate3 output (baud_o3).
//  This3 is identical3 to BAUDOUT3* signal3 on 16550 chip3.
//  It outputs3 16xbit_clock_rate - the divided3 clock3.
//  It's disabled by default. Define3 UART_HAS_BAUDRATE_OUTPUT3 to use.
//
// Revision3 1.16  2002/01/08 11:29:40  mohor3
// tf_pop3 was too wide3. Now3 it is only 1 clk3 cycle width.
//
// Revision3 1.15  2001/12/17 14:46:48  mohor3
// overrun3 signal3 was moved to separate3 block because many3 sequential3 lsr3
// reads were3 preventing3 data from being written3 to rx3 fifo.
// underrun3 signal3 was not used and was removed from the project3.
//
// Revision3 1.14  2001/12/03 21:44:29  gorban3
// Updated3 specification3 documentation.
// Added3 full 32-bit data bus interface, now as default.
// Address is 5-bit wide3 in 32-bit data bus mode.
// Added3 wb_sel_i3 input to the core3. It's used in the 32-bit mode.
// Added3 debug3 interface with two3 32-bit read-only registers in 32-bit mode.
// Bits3 5 and 6 of LSR3 are now only cleared3 on TX3 FIFO write.
// My3 small test bench3 is modified to work3 with 32-bit mode.
//
// Revision3 1.13  2001/11/08 14:54:23  mohor3
// Comments3 in Slovene3 language3 deleted3, few3 small fixes3 for better3 work3 of
// old3 tools3. IRQs3 need to be fix3.
//
// Revision3 1.12  2001/11/07 17:51:52  gorban3
// Heavily3 rewritten3 interrupt3 and LSR3 subsystems3.
// Many3 bugs3 hopefully3 squashed3.
//
// Revision3 1.11  2001/10/29 17:00:46  gorban3
// fixed3 parity3 sending3 and tx_fifo3 resets3 over- and underrun3
//
// Revision3 1.10  2001/10/20 09:58:40  gorban3
// Small3 synopsis3 fixes3
//
// Revision3 1.9  2001/08/24 21:01:12  mohor3
// Things3 connected3 to parity3 changed.
// Clock3 devider3 changed.
//
// Revision3 1.8  2001/08/23 16:05:05  mohor3
// Stop bit bug3 fixed3.
// Parity3 bug3 fixed3.
// WISHBONE3 read cycle bug3 fixed3,
// OE3 indicator3 (Overrun3 Error) bug3 fixed3.
// PE3 indicator3 (Parity3 Error) bug3 fixed3.
// Register read bug3 fixed3.
//
// Revision3 1.6  2001/06/23 11:21:48  gorban3
// DL3 made3 16-bit long3. Fixed3 transmission3/reception3 bugs3.
//
// Revision3 1.5  2001/06/02 14:28:14  gorban3
// Fixed3 receiver3 and transmitter3. Major3 bug3 fixed3.
//
// Revision3 1.4  2001/05/31 20:08:01  gorban3
// FIFO changes3 and other corrections3.
//
// Revision3 1.3  2001/05/27 17:37:49  gorban3
// Fixed3 many3 bugs3. Updated3 spec3. Changed3 FIFO files structure3. See CHANGES3.txt3 file.
//
// Revision3 1.2  2001/05/21 19:12:02  gorban3
// Corrected3 some3 Linter3 messages3.
//
// Revision3 1.1  2001/05/17 18:34:18  gorban3
// First3 'stable' release. Should3 be sythesizable3 now. Also3 added new header.
//
// Revision3 1.0  2001-05-17 21:27:12+02  jacob3
// Initial3 revision3
//
//

// synopsys3 translate_off3
`include "timescale.v"
// synopsys3 translate_on3

`include "uart_defines3.v"

module uart_transmitter3 (clk3, wb_rst_i3, lcr3, tf_push3, wb_dat_i3, enable,	stx_pad_o3, tstate3, tf_count3, tx_reset3, lsr_mask3);

input 										clk3;
input 										wb_rst_i3;
input [7:0] 								lcr3;
input 										tf_push3;
input [7:0] 								wb_dat_i3;
input 										enable;
input 										tx_reset3;
input 										lsr_mask3; //reset of fifo
output 										stx_pad_o3;
output [2:0] 								tstate3;
output [`UART_FIFO_COUNTER_W3-1:0] 	tf_count3;

reg [2:0] 									tstate3;
reg [4:0] 									counter;
reg [2:0] 									bit_counter3;   // counts3 the bits to be sent3
reg [6:0] 									shift_out3;	// output shift3 register
reg 											stx_o_tmp3;
reg 											parity_xor3;  // parity3 of the word3
reg 											tf_pop3;
reg 											bit_out3;

// TX3 FIFO instance
//
// Transmitter3 FIFO signals3
wire [`UART_FIFO_WIDTH3-1:0] 			tf_data_in3;
wire [`UART_FIFO_WIDTH3-1:0] 			tf_data_out3;
wire 											tf_push3;
wire 											tf_overrun3;
wire [`UART_FIFO_COUNTER_W3-1:0] 		tf_count3;

assign 										tf_data_in3 = wb_dat_i3;

uart_tfifo3 fifo_tx3(	// error bit signal3 is not used in transmitter3 FIFO
	.clk3(		clk3		), 
	.wb_rst_i3(	wb_rst_i3	),
	.data_in3(	tf_data_in3	),
	.data_out3(	tf_data_out3	),
	.push3(		tf_push3		),
	.pop3(		tf_pop3		),
	.overrun3(	tf_overrun3	),
	.count(		tf_count3	),
	.fifo_reset3(	tx_reset3	),
	.reset_status3(lsr_mask3)
);

// TRANSMITTER3 FINAL3 STATE3 MACHINE3

parameter s_idle3        = 3'd0;
parameter s_send_start3  = 3'd1;
parameter s_send_byte3   = 3'd2;
parameter s_send_parity3 = 3'd3;
parameter s_send_stop3   = 3'd4;
parameter s_pop_byte3    = 3'd5;

always @(posedge clk3 or posedge wb_rst_i3)
begin
  if (wb_rst_i3)
  begin
	tstate3       <= #1 s_idle3;
	stx_o_tmp3       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out3   <= #1 7'b0;
	bit_out3     <= #1 1'b0;
	parity_xor3  <= #1 1'b0;
	tf_pop3      <= #1 1'b0;
	bit_counter3 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate3)
	s_idle3	 :	if (~|tf_count3) // if tf_count3==0
			begin
				tstate3 <= #1 s_idle3;
				stx_o_tmp3 <= #1 1'b1;
			end
			else
			begin
				tf_pop3 <= #1 1'b0;
				stx_o_tmp3  <= #1 1'b1;
				tstate3  <= #1 s_pop_byte3;
			end
	s_pop_byte3 :	begin
				tf_pop3 <= #1 1'b1;
				case (lcr3[/*`UART_LC_BITS3*/1:0])  // number3 of bits in a word3
				2'b00 : begin
					bit_counter3 <= #1 3'b100;
					parity_xor3  <= #1 ^tf_data_out3[4:0];
				     end
				2'b01 : begin
					bit_counter3 <= #1 3'b101;
					parity_xor3  <= #1 ^tf_data_out3[5:0];
				     end
				2'b10 : begin
					bit_counter3 <= #1 3'b110;
					parity_xor3  <= #1 ^tf_data_out3[6:0];
				     end
				2'b11 : begin
					bit_counter3 <= #1 3'b111;
					parity_xor3  <= #1 ^tf_data_out3[7:0];
				     end
				endcase
				{shift_out3[6:0], bit_out3} <= #1 tf_data_out3;
				tstate3 <= #1 s_send_start3;
			end
	s_send_start3 :	begin
				tf_pop3 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate3 <= #1 s_send_byte3;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp3 <= #1 1'b0;
			end
	s_send_byte3 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter3 > 3'b0)
					begin
						bit_counter3 <= #1 bit_counter3 - 1'b1;
						{shift_out3[5:0],bit_out3  } <= #1 {shift_out3[6:1], shift_out3[0]};
						tstate3 <= #1 s_send_byte3;
					end
					else   // end of byte
					if (~lcr3[`UART_LC_PE3])
					begin
						tstate3 <= #1 s_send_stop3;
					end
					else
					begin
						case ({lcr3[`UART_LC_EP3],lcr3[`UART_LC_SP3]})
						2'b00:	bit_out3 <= #1 ~parity_xor3;
						2'b01:	bit_out3 <= #1 1'b1;
						2'b10:	bit_out3 <= #1 parity_xor3;
						2'b11:	bit_out3 <= #1 1'b0;
						endcase
						tstate3 <= #1 s_send_parity3;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp3 <= #1 bit_out3; // set output pin3
			end
	s_send_parity3 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate3 <= #1 s_send_stop3;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp3 <= #1 bit_out3;
			end
	s_send_stop3 :  begin
				if (~|counter)
				  begin
						casex ({lcr3[`UART_LC_SB3],lcr3[`UART_LC_BITS3]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor3
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate3 <= #1 s_idle3;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp3 <= #1 1'b1;
			end

		default : // should never get here3
			tstate3 <= #1 s_idle3;
	endcase
  end // end if enable
  else
    tf_pop3 <= #1 1'b0;  // tf_pop3 must be 1 cycle width
end // transmitter3 logic

assign stx_pad_o3 = lcr3[`UART_LC_BC3] ? 1'b0 : stx_o_tmp3;    // Break3 condition
	
endmodule
