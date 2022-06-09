//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter26.v                                          ////
////                                                              ////
////                                                              ////
////  This26 file is part of the "UART26 16550 compatible26" project26    ////
////  http26://www26.opencores26.org26/cores26/uart1655026/                   ////
////                                                              ////
////  Documentation26 related26 to this project26:                      ////
////  - http26://www26.opencores26.org26/cores26/uart1655026/                 ////
////                                                              ////
////  Projects26 compatibility26:                                     ////
////  - WISHBONE26                                                  ////
////  RS23226 Protocol26                                              ////
////  16550D uart26 (mostly26 supported)                              ////
////                                                              ////
////  Overview26 (main26 Features26):                                   ////
////  UART26 core26 transmitter26 logic                                 ////
////                                                              ////
////  Known26 problems26 (limits26):                                    ////
////  None26 known26                                                  ////
////                                                              ////
////  To26 Do26:                                                      ////
////  Thourough26 testing26.                                          ////
////                                                              ////
////  Author26(s):                                                  ////
////      - gorban26@opencores26.org26                                  ////
////      - Jacob26 Gorban26                                          ////
////      - Igor26 Mohor26 (igorm26@opencores26.org26)                      ////
////                                                              ////
////  Created26:        2001/05/12                                  ////
////  Last26 Updated26:   2001/05/17                                  ////
////                  (See log26 for the revision26 history26)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2000, 2001 Authors26                             ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS26 Revision26 History26
//
// $Log: not supported by cvs2svn26 $
// Revision26 1.18  2002/07/22 23:02:23  gorban26
// Bug26 Fixes26:
//  * Possible26 loss of sync and bad26 reception26 of stop bit on slow26 baud26 rates26 fixed26.
//   Problem26 reported26 by Kenny26.Tung26.
//  * Bad (or lack26 of ) loopback26 handling26 fixed26. Reported26 by Cherry26 Withers26.
//
// Improvements26:
//  * Made26 FIFO's as general26 inferrable26 memory where possible26.
//  So26 on FPGA26 they should be inferred26 as RAM26 (Distributed26 RAM26 on Xilinx26).
//  This26 saves26 about26 1/3 of the Slice26 count and reduces26 P&R and synthesis26 times.
//
//  * Added26 optional26 baudrate26 output (baud_o26).
//  This26 is identical26 to BAUDOUT26* signal26 on 16550 chip26.
//  It outputs26 16xbit_clock_rate - the divided26 clock26.
//  It's disabled by default. Define26 UART_HAS_BAUDRATE_OUTPUT26 to use.
//
// Revision26 1.16  2002/01/08 11:29:40  mohor26
// tf_pop26 was too wide26. Now26 it is only 1 clk26 cycle width.
//
// Revision26 1.15  2001/12/17 14:46:48  mohor26
// overrun26 signal26 was moved to separate26 block because many26 sequential26 lsr26
// reads were26 preventing26 data from being written26 to rx26 fifo.
// underrun26 signal26 was not used and was removed from the project26.
//
// Revision26 1.14  2001/12/03 21:44:29  gorban26
// Updated26 specification26 documentation.
// Added26 full 32-bit data bus interface, now as default.
// Address is 5-bit wide26 in 32-bit data bus mode.
// Added26 wb_sel_i26 input to the core26. It's used in the 32-bit mode.
// Added26 debug26 interface with two26 32-bit read-only registers in 32-bit mode.
// Bits26 5 and 6 of LSR26 are now only cleared26 on TX26 FIFO write.
// My26 small test bench26 is modified to work26 with 32-bit mode.
//
// Revision26 1.13  2001/11/08 14:54:23  mohor26
// Comments26 in Slovene26 language26 deleted26, few26 small fixes26 for better26 work26 of
// old26 tools26. IRQs26 need to be fix26.
//
// Revision26 1.12  2001/11/07 17:51:52  gorban26
// Heavily26 rewritten26 interrupt26 and LSR26 subsystems26.
// Many26 bugs26 hopefully26 squashed26.
//
// Revision26 1.11  2001/10/29 17:00:46  gorban26
// fixed26 parity26 sending26 and tx_fifo26 resets26 over- and underrun26
//
// Revision26 1.10  2001/10/20 09:58:40  gorban26
// Small26 synopsis26 fixes26
//
// Revision26 1.9  2001/08/24 21:01:12  mohor26
// Things26 connected26 to parity26 changed.
// Clock26 devider26 changed.
//
// Revision26 1.8  2001/08/23 16:05:05  mohor26
// Stop bit bug26 fixed26.
// Parity26 bug26 fixed26.
// WISHBONE26 read cycle bug26 fixed26,
// OE26 indicator26 (Overrun26 Error) bug26 fixed26.
// PE26 indicator26 (Parity26 Error) bug26 fixed26.
// Register read bug26 fixed26.
//
// Revision26 1.6  2001/06/23 11:21:48  gorban26
// DL26 made26 16-bit long26. Fixed26 transmission26/reception26 bugs26.
//
// Revision26 1.5  2001/06/02 14:28:14  gorban26
// Fixed26 receiver26 and transmitter26. Major26 bug26 fixed26.
//
// Revision26 1.4  2001/05/31 20:08:01  gorban26
// FIFO changes26 and other corrections26.
//
// Revision26 1.3  2001/05/27 17:37:49  gorban26
// Fixed26 many26 bugs26. Updated26 spec26. Changed26 FIFO files structure26. See CHANGES26.txt26 file.
//
// Revision26 1.2  2001/05/21 19:12:02  gorban26
// Corrected26 some26 Linter26 messages26.
//
// Revision26 1.1  2001/05/17 18:34:18  gorban26
// First26 'stable' release. Should26 be sythesizable26 now. Also26 added new header.
//
// Revision26 1.0  2001-05-17 21:27:12+02  jacob26
// Initial26 revision26
//
//

// synopsys26 translate_off26
`include "timescale.v"
// synopsys26 translate_on26

`include "uart_defines26.v"

module uart_transmitter26 (clk26, wb_rst_i26, lcr26, tf_push26, wb_dat_i26, enable,	stx_pad_o26, tstate26, tf_count26, tx_reset26, lsr_mask26);

input 										clk26;
input 										wb_rst_i26;
input [7:0] 								lcr26;
input 										tf_push26;
input [7:0] 								wb_dat_i26;
input 										enable;
input 										tx_reset26;
input 										lsr_mask26; //reset of fifo
output 										stx_pad_o26;
output [2:0] 								tstate26;
output [`UART_FIFO_COUNTER_W26-1:0] 	tf_count26;

reg [2:0] 									tstate26;
reg [4:0] 									counter;
reg [2:0] 									bit_counter26;   // counts26 the bits to be sent26
reg [6:0] 									shift_out26;	// output shift26 register
reg 											stx_o_tmp26;
reg 											parity_xor26;  // parity26 of the word26
reg 											tf_pop26;
reg 											bit_out26;

// TX26 FIFO instance
//
// Transmitter26 FIFO signals26
wire [`UART_FIFO_WIDTH26-1:0] 			tf_data_in26;
wire [`UART_FIFO_WIDTH26-1:0] 			tf_data_out26;
wire 											tf_push26;
wire 											tf_overrun26;
wire [`UART_FIFO_COUNTER_W26-1:0] 		tf_count26;

assign 										tf_data_in26 = wb_dat_i26;

uart_tfifo26 fifo_tx26(	// error bit signal26 is not used in transmitter26 FIFO
	.clk26(		clk26		), 
	.wb_rst_i26(	wb_rst_i26	),
	.data_in26(	tf_data_in26	),
	.data_out26(	tf_data_out26	),
	.push26(		tf_push26		),
	.pop26(		tf_pop26		),
	.overrun26(	tf_overrun26	),
	.count(		tf_count26	),
	.fifo_reset26(	tx_reset26	),
	.reset_status26(lsr_mask26)
);

// TRANSMITTER26 FINAL26 STATE26 MACHINE26

parameter s_idle26        = 3'd0;
parameter s_send_start26  = 3'd1;
parameter s_send_byte26   = 3'd2;
parameter s_send_parity26 = 3'd3;
parameter s_send_stop26   = 3'd4;
parameter s_pop_byte26    = 3'd5;

always @(posedge clk26 or posedge wb_rst_i26)
begin
  if (wb_rst_i26)
  begin
	tstate26       <= #1 s_idle26;
	stx_o_tmp26       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out26   <= #1 7'b0;
	bit_out26     <= #1 1'b0;
	parity_xor26  <= #1 1'b0;
	tf_pop26      <= #1 1'b0;
	bit_counter26 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate26)
	s_idle26	 :	if (~|tf_count26) // if tf_count26==0
			begin
				tstate26 <= #1 s_idle26;
				stx_o_tmp26 <= #1 1'b1;
			end
			else
			begin
				tf_pop26 <= #1 1'b0;
				stx_o_tmp26  <= #1 1'b1;
				tstate26  <= #1 s_pop_byte26;
			end
	s_pop_byte26 :	begin
				tf_pop26 <= #1 1'b1;
				case (lcr26[/*`UART_LC_BITS26*/1:0])  // number26 of bits in a word26
				2'b00 : begin
					bit_counter26 <= #1 3'b100;
					parity_xor26  <= #1 ^tf_data_out26[4:0];
				     end
				2'b01 : begin
					bit_counter26 <= #1 3'b101;
					parity_xor26  <= #1 ^tf_data_out26[5:0];
				     end
				2'b10 : begin
					bit_counter26 <= #1 3'b110;
					parity_xor26  <= #1 ^tf_data_out26[6:0];
				     end
				2'b11 : begin
					bit_counter26 <= #1 3'b111;
					parity_xor26  <= #1 ^tf_data_out26[7:0];
				     end
				endcase
				{shift_out26[6:0], bit_out26} <= #1 tf_data_out26;
				tstate26 <= #1 s_send_start26;
			end
	s_send_start26 :	begin
				tf_pop26 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate26 <= #1 s_send_byte26;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp26 <= #1 1'b0;
			end
	s_send_byte26 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter26 > 3'b0)
					begin
						bit_counter26 <= #1 bit_counter26 - 1'b1;
						{shift_out26[5:0],bit_out26  } <= #1 {shift_out26[6:1], shift_out26[0]};
						tstate26 <= #1 s_send_byte26;
					end
					else   // end of byte
					if (~lcr26[`UART_LC_PE26])
					begin
						tstate26 <= #1 s_send_stop26;
					end
					else
					begin
						case ({lcr26[`UART_LC_EP26],lcr26[`UART_LC_SP26]})
						2'b00:	bit_out26 <= #1 ~parity_xor26;
						2'b01:	bit_out26 <= #1 1'b1;
						2'b10:	bit_out26 <= #1 parity_xor26;
						2'b11:	bit_out26 <= #1 1'b0;
						endcase
						tstate26 <= #1 s_send_parity26;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp26 <= #1 bit_out26; // set output pin26
			end
	s_send_parity26 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate26 <= #1 s_send_stop26;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp26 <= #1 bit_out26;
			end
	s_send_stop26 :  begin
				if (~|counter)
				  begin
						casex ({lcr26[`UART_LC_SB26],lcr26[`UART_LC_BITS26]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor26
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate26 <= #1 s_idle26;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp26 <= #1 1'b1;
			end

		default : // should never get here26
			tstate26 <= #1 s_idle26;
	endcase
  end // end if enable
  else
    tf_pop26 <= #1 1'b0;  // tf_pop26 must be 1 cycle width
end // transmitter26 logic

assign stx_pad_o26 = lcr26[`UART_LC_BC26] ? 1'b0 : stx_o_tmp26;    // Break26 condition
	
endmodule
