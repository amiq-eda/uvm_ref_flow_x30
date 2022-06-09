//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter14.v                                          ////
////                                                              ////
////                                                              ////
////  This14 file is part of the "UART14 16550 compatible14" project14    ////
////  http14://www14.opencores14.org14/cores14/uart1655014/                   ////
////                                                              ////
////  Documentation14 related14 to this project14:                      ////
////  - http14://www14.opencores14.org14/cores14/uart1655014/                 ////
////                                                              ////
////  Projects14 compatibility14:                                     ////
////  - WISHBONE14                                                  ////
////  RS23214 Protocol14                                              ////
////  16550D uart14 (mostly14 supported)                              ////
////                                                              ////
////  Overview14 (main14 Features14):                                   ////
////  UART14 core14 transmitter14 logic                                 ////
////                                                              ////
////  Known14 problems14 (limits14):                                    ////
////  None14 known14                                                  ////
////                                                              ////
////  To14 Do14:                                                      ////
////  Thourough14 testing14.                                          ////
////                                                              ////
////  Author14(s):                                                  ////
////      - gorban14@opencores14.org14                                  ////
////      - Jacob14 Gorban14                                          ////
////      - Igor14 Mohor14 (igorm14@opencores14.org14)                      ////
////                                                              ////
////  Created14:        2001/05/12                                  ////
////  Last14 Updated14:   2001/05/17                                  ////
////                  (See log14 for the revision14 history14)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2000, 2001 Authors14                             ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS14 Revision14 History14
//
// $Log: not supported by cvs2svn14 $
// Revision14 1.18  2002/07/22 23:02:23  gorban14
// Bug14 Fixes14:
//  * Possible14 loss of sync and bad14 reception14 of stop bit on slow14 baud14 rates14 fixed14.
//   Problem14 reported14 by Kenny14.Tung14.
//  * Bad (or lack14 of ) loopback14 handling14 fixed14. Reported14 by Cherry14 Withers14.
//
// Improvements14:
//  * Made14 FIFO's as general14 inferrable14 memory where possible14.
//  So14 on FPGA14 they should be inferred14 as RAM14 (Distributed14 RAM14 on Xilinx14).
//  This14 saves14 about14 1/3 of the Slice14 count and reduces14 P&R and synthesis14 times.
//
//  * Added14 optional14 baudrate14 output (baud_o14).
//  This14 is identical14 to BAUDOUT14* signal14 on 16550 chip14.
//  It outputs14 16xbit_clock_rate - the divided14 clock14.
//  It's disabled by default. Define14 UART_HAS_BAUDRATE_OUTPUT14 to use.
//
// Revision14 1.16  2002/01/08 11:29:40  mohor14
// tf_pop14 was too wide14. Now14 it is only 1 clk14 cycle width.
//
// Revision14 1.15  2001/12/17 14:46:48  mohor14
// overrun14 signal14 was moved to separate14 block because many14 sequential14 lsr14
// reads were14 preventing14 data from being written14 to rx14 fifo.
// underrun14 signal14 was not used and was removed from the project14.
//
// Revision14 1.14  2001/12/03 21:44:29  gorban14
// Updated14 specification14 documentation.
// Added14 full 32-bit data bus interface, now as default.
// Address is 5-bit wide14 in 32-bit data bus mode.
// Added14 wb_sel_i14 input to the core14. It's used in the 32-bit mode.
// Added14 debug14 interface with two14 32-bit read-only registers in 32-bit mode.
// Bits14 5 and 6 of LSR14 are now only cleared14 on TX14 FIFO write.
// My14 small test bench14 is modified to work14 with 32-bit mode.
//
// Revision14 1.13  2001/11/08 14:54:23  mohor14
// Comments14 in Slovene14 language14 deleted14, few14 small fixes14 for better14 work14 of
// old14 tools14. IRQs14 need to be fix14.
//
// Revision14 1.12  2001/11/07 17:51:52  gorban14
// Heavily14 rewritten14 interrupt14 and LSR14 subsystems14.
// Many14 bugs14 hopefully14 squashed14.
//
// Revision14 1.11  2001/10/29 17:00:46  gorban14
// fixed14 parity14 sending14 and tx_fifo14 resets14 over- and underrun14
//
// Revision14 1.10  2001/10/20 09:58:40  gorban14
// Small14 synopsis14 fixes14
//
// Revision14 1.9  2001/08/24 21:01:12  mohor14
// Things14 connected14 to parity14 changed.
// Clock14 devider14 changed.
//
// Revision14 1.8  2001/08/23 16:05:05  mohor14
// Stop bit bug14 fixed14.
// Parity14 bug14 fixed14.
// WISHBONE14 read cycle bug14 fixed14,
// OE14 indicator14 (Overrun14 Error) bug14 fixed14.
// PE14 indicator14 (Parity14 Error) bug14 fixed14.
// Register read bug14 fixed14.
//
// Revision14 1.6  2001/06/23 11:21:48  gorban14
// DL14 made14 16-bit long14. Fixed14 transmission14/reception14 bugs14.
//
// Revision14 1.5  2001/06/02 14:28:14  gorban14
// Fixed14 receiver14 and transmitter14. Major14 bug14 fixed14.
//
// Revision14 1.4  2001/05/31 20:08:01  gorban14
// FIFO changes14 and other corrections14.
//
// Revision14 1.3  2001/05/27 17:37:49  gorban14
// Fixed14 many14 bugs14. Updated14 spec14. Changed14 FIFO files structure14. See CHANGES14.txt14 file.
//
// Revision14 1.2  2001/05/21 19:12:02  gorban14
// Corrected14 some14 Linter14 messages14.
//
// Revision14 1.1  2001/05/17 18:34:18  gorban14
// First14 'stable' release. Should14 be sythesizable14 now. Also14 added new header.
//
// Revision14 1.0  2001-05-17 21:27:12+02  jacob14
// Initial14 revision14
//
//

// synopsys14 translate_off14
`include "timescale.v"
// synopsys14 translate_on14

`include "uart_defines14.v"

module uart_transmitter14 (clk14, wb_rst_i14, lcr14, tf_push14, wb_dat_i14, enable,	stx_pad_o14, tstate14, tf_count14, tx_reset14, lsr_mask14);

input 										clk14;
input 										wb_rst_i14;
input [7:0] 								lcr14;
input 										tf_push14;
input [7:0] 								wb_dat_i14;
input 										enable;
input 										tx_reset14;
input 										lsr_mask14; //reset of fifo
output 										stx_pad_o14;
output [2:0] 								tstate14;
output [`UART_FIFO_COUNTER_W14-1:0] 	tf_count14;

reg [2:0] 									tstate14;
reg [4:0] 									counter;
reg [2:0] 									bit_counter14;   // counts14 the bits to be sent14
reg [6:0] 									shift_out14;	// output shift14 register
reg 											stx_o_tmp14;
reg 											parity_xor14;  // parity14 of the word14
reg 											tf_pop14;
reg 											bit_out14;

// TX14 FIFO instance
//
// Transmitter14 FIFO signals14
wire [`UART_FIFO_WIDTH14-1:0] 			tf_data_in14;
wire [`UART_FIFO_WIDTH14-1:0] 			tf_data_out14;
wire 											tf_push14;
wire 											tf_overrun14;
wire [`UART_FIFO_COUNTER_W14-1:0] 		tf_count14;

assign 										tf_data_in14 = wb_dat_i14;

uart_tfifo14 fifo_tx14(	// error bit signal14 is not used in transmitter14 FIFO
	.clk14(		clk14		), 
	.wb_rst_i14(	wb_rst_i14	),
	.data_in14(	tf_data_in14	),
	.data_out14(	tf_data_out14	),
	.push14(		tf_push14		),
	.pop14(		tf_pop14		),
	.overrun14(	tf_overrun14	),
	.count(		tf_count14	),
	.fifo_reset14(	tx_reset14	),
	.reset_status14(lsr_mask14)
);

// TRANSMITTER14 FINAL14 STATE14 MACHINE14

parameter s_idle14        = 3'd0;
parameter s_send_start14  = 3'd1;
parameter s_send_byte14   = 3'd2;
parameter s_send_parity14 = 3'd3;
parameter s_send_stop14   = 3'd4;
parameter s_pop_byte14    = 3'd5;

always @(posedge clk14 or posedge wb_rst_i14)
begin
  if (wb_rst_i14)
  begin
	tstate14       <= #1 s_idle14;
	stx_o_tmp14       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out14   <= #1 7'b0;
	bit_out14     <= #1 1'b0;
	parity_xor14  <= #1 1'b0;
	tf_pop14      <= #1 1'b0;
	bit_counter14 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate14)
	s_idle14	 :	if (~|tf_count14) // if tf_count14==0
			begin
				tstate14 <= #1 s_idle14;
				stx_o_tmp14 <= #1 1'b1;
			end
			else
			begin
				tf_pop14 <= #1 1'b0;
				stx_o_tmp14  <= #1 1'b1;
				tstate14  <= #1 s_pop_byte14;
			end
	s_pop_byte14 :	begin
				tf_pop14 <= #1 1'b1;
				case (lcr14[/*`UART_LC_BITS14*/1:0])  // number14 of bits in a word14
				2'b00 : begin
					bit_counter14 <= #1 3'b100;
					parity_xor14  <= #1 ^tf_data_out14[4:0];
				     end
				2'b01 : begin
					bit_counter14 <= #1 3'b101;
					parity_xor14  <= #1 ^tf_data_out14[5:0];
				     end
				2'b10 : begin
					bit_counter14 <= #1 3'b110;
					parity_xor14  <= #1 ^tf_data_out14[6:0];
				     end
				2'b11 : begin
					bit_counter14 <= #1 3'b111;
					parity_xor14  <= #1 ^tf_data_out14[7:0];
				     end
				endcase
				{shift_out14[6:0], bit_out14} <= #1 tf_data_out14;
				tstate14 <= #1 s_send_start14;
			end
	s_send_start14 :	begin
				tf_pop14 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate14 <= #1 s_send_byte14;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp14 <= #1 1'b0;
			end
	s_send_byte14 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter14 > 3'b0)
					begin
						bit_counter14 <= #1 bit_counter14 - 1'b1;
						{shift_out14[5:0],bit_out14  } <= #1 {shift_out14[6:1], shift_out14[0]};
						tstate14 <= #1 s_send_byte14;
					end
					else   // end of byte
					if (~lcr14[`UART_LC_PE14])
					begin
						tstate14 <= #1 s_send_stop14;
					end
					else
					begin
						case ({lcr14[`UART_LC_EP14],lcr14[`UART_LC_SP14]})
						2'b00:	bit_out14 <= #1 ~parity_xor14;
						2'b01:	bit_out14 <= #1 1'b1;
						2'b10:	bit_out14 <= #1 parity_xor14;
						2'b11:	bit_out14 <= #1 1'b0;
						endcase
						tstate14 <= #1 s_send_parity14;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp14 <= #1 bit_out14; // set output pin14
			end
	s_send_parity14 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate14 <= #1 s_send_stop14;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp14 <= #1 bit_out14;
			end
	s_send_stop14 :  begin
				if (~|counter)
				  begin
						casex ({lcr14[`UART_LC_SB14],lcr14[`UART_LC_BITS14]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor14
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate14 <= #1 s_idle14;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp14 <= #1 1'b1;
			end

		default : // should never get here14
			tstate14 <= #1 s_idle14;
	endcase
  end // end if enable
  else
    tf_pop14 <= #1 1'b0;  // tf_pop14 must be 1 cycle width
end // transmitter14 logic

assign stx_pad_o14 = lcr14[`UART_LC_BC14] ? 1'b0 : stx_o_tmp14;    // Break14 condition
	
endmodule
