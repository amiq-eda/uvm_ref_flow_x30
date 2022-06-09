//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter7.v                                          ////
////                                                              ////
////                                                              ////
////  This7 file is part of the "UART7 16550 compatible7" project7    ////
////  http7://www7.opencores7.org7/cores7/uart165507/                   ////
////                                                              ////
////  Documentation7 related7 to this project7:                      ////
////  - http7://www7.opencores7.org7/cores7/uart165507/                 ////
////                                                              ////
////  Projects7 compatibility7:                                     ////
////  - WISHBONE7                                                  ////
////  RS2327 Protocol7                                              ////
////  16550D uart7 (mostly7 supported)                              ////
////                                                              ////
////  Overview7 (main7 Features7):                                   ////
////  UART7 core7 transmitter7 logic                                 ////
////                                                              ////
////  Known7 problems7 (limits7):                                    ////
////  None7 known7                                                  ////
////                                                              ////
////  To7 Do7:                                                      ////
////  Thourough7 testing7.                                          ////
////                                                              ////
////  Author7(s):                                                  ////
////      - gorban7@opencores7.org7                                  ////
////      - Jacob7 Gorban7                                          ////
////      - Igor7 Mohor7 (igorm7@opencores7.org7)                      ////
////                                                              ////
////  Created7:        2001/05/12                                  ////
////  Last7 Updated7:   2001/05/17                                  ////
////                  (See log7 for the revision7 history7)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2000, 2001 Authors7                             ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS7 Revision7 History7
//
// $Log: not supported by cvs2svn7 $
// Revision7 1.18  2002/07/22 23:02:23  gorban7
// Bug7 Fixes7:
//  * Possible7 loss of sync and bad7 reception7 of stop bit on slow7 baud7 rates7 fixed7.
//   Problem7 reported7 by Kenny7.Tung7.
//  * Bad (or lack7 of ) loopback7 handling7 fixed7. Reported7 by Cherry7 Withers7.
//
// Improvements7:
//  * Made7 FIFO's as general7 inferrable7 memory where possible7.
//  So7 on FPGA7 they should be inferred7 as RAM7 (Distributed7 RAM7 on Xilinx7).
//  This7 saves7 about7 1/3 of the Slice7 count and reduces7 P&R and synthesis7 times.
//
//  * Added7 optional7 baudrate7 output (baud_o7).
//  This7 is identical7 to BAUDOUT7* signal7 on 16550 chip7.
//  It outputs7 16xbit_clock_rate - the divided7 clock7.
//  It's disabled by default. Define7 UART_HAS_BAUDRATE_OUTPUT7 to use.
//
// Revision7 1.16  2002/01/08 11:29:40  mohor7
// tf_pop7 was too wide7. Now7 it is only 1 clk7 cycle width.
//
// Revision7 1.15  2001/12/17 14:46:48  mohor7
// overrun7 signal7 was moved to separate7 block because many7 sequential7 lsr7
// reads were7 preventing7 data from being written7 to rx7 fifo.
// underrun7 signal7 was not used and was removed from the project7.
//
// Revision7 1.14  2001/12/03 21:44:29  gorban7
// Updated7 specification7 documentation.
// Added7 full 32-bit data bus interface, now as default.
// Address is 5-bit wide7 in 32-bit data bus mode.
// Added7 wb_sel_i7 input to the core7. It's used in the 32-bit mode.
// Added7 debug7 interface with two7 32-bit read-only registers in 32-bit mode.
// Bits7 5 and 6 of LSR7 are now only cleared7 on TX7 FIFO write.
// My7 small test bench7 is modified to work7 with 32-bit mode.
//
// Revision7 1.13  2001/11/08 14:54:23  mohor7
// Comments7 in Slovene7 language7 deleted7, few7 small fixes7 for better7 work7 of
// old7 tools7. IRQs7 need to be fix7.
//
// Revision7 1.12  2001/11/07 17:51:52  gorban7
// Heavily7 rewritten7 interrupt7 and LSR7 subsystems7.
// Many7 bugs7 hopefully7 squashed7.
//
// Revision7 1.11  2001/10/29 17:00:46  gorban7
// fixed7 parity7 sending7 and tx_fifo7 resets7 over- and underrun7
//
// Revision7 1.10  2001/10/20 09:58:40  gorban7
// Small7 synopsis7 fixes7
//
// Revision7 1.9  2001/08/24 21:01:12  mohor7
// Things7 connected7 to parity7 changed.
// Clock7 devider7 changed.
//
// Revision7 1.8  2001/08/23 16:05:05  mohor7
// Stop bit bug7 fixed7.
// Parity7 bug7 fixed7.
// WISHBONE7 read cycle bug7 fixed7,
// OE7 indicator7 (Overrun7 Error) bug7 fixed7.
// PE7 indicator7 (Parity7 Error) bug7 fixed7.
// Register read bug7 fixed7.
//
// Revision7 1.6  2001/06/23 11:21:48  gorban7
// DL7 made7 16-bit long7. Fixed7 transmission7/reception7 bugs7.
//
// Revision7 1.5  2001/06/02 14:28:14  gorban7
// Fixed7 receiver7 and transmitter7. Major7 bug7 fixed7.
//
// Revision7 1.4  2001/05/31 20:08:01  gorban7
// FIFO changes7 and other corrections7.
//
// Revision7 1.3  2001/05/27 17:37:49  gorban7
// Fixed7 many7 bugs7. Updated7 spec7. Changed7 FIFO files structure7. See CHANGES7.txt7 file.
//
// Revision7 1.2  2001/05/21 19:12:02  gorban7
// Corrected7 some7 Linter7 messages7.
//
// Revision7 1.1  2001/05/17 18:34:18  gorban7
// First7 'stable' release. Should7 be sythesizable7 now. Also7 added new header.
//
// Revision7 1.0  2001-05-17 21:27:12+02  jacob7
// Initial7 revision7
//
//

// synopsys7 translate_off7
`include "timescale.v"
// synopsys7 translate_on7

`include "uart_defines7.v"

module uart_transmitter7 (clk7, wb_rst_i7, lcr7, tf_push7, wb_dat_i7, enable,	stx_pad_o7, tstate7, tf_count7, tx_reset7, lsr_mask7);

input 										clk7;
input 										wb_rst_i7;
input [7:0] 								lcr7;
input 										tf_push7;
input [7:0] 								wb_dat_i7;
input 										enable;
input 										tx_reset7;
input 										lsr_mask7; //reset of fifo
output 										stx_pad_o7;
output [2:0] 								tstate7;
output [`UART_FIFO_COUNTER_W7-1:0] 	tf_count7;

reg [2:0] 									tstate7;
reg [4:0] 									counter;
reg [2:0] 									bit_counter7;   // counts7 the bits to be sent7
reg [6:0] 									shift_out7;	// output shift7 register
reg 											stx_o_tmp7;
reg 											parity_xor7;  // parity7 of the word7
reg 											tf_pop7;
reg 											bit_out7;

// TX7 FIFO instance
//
// Transmitter7 FIFO signals7
wire [`UART_FIFO_WIDTH7-1:0] 			tf_data_in7;
wire [`UART_FIFO_WIDTH7-1:0] 			tf_data_out7;
wire 											tf_push7;
wire 											tf_overrun7;
wire [`UART_FIFO_COUNTER_W7-1:0] 		tf_count7;

assign 										tf_data_in7 = wb_dat_i7;

uart_tfifo7 fifo_tx7(	// error bit signal7 is not used in transmitter7 FIFO
	.clk7(		clk7		), 
	.wb_rst_i7(	wb_rst_i7	),
	.data_in7(	tf_data_in7	),
	.data_out7(	tf_data_out7	),
	.push7(		tf_push7		),
	.pop7(		tf_pop7		),
	.overrun7(	tf_overrun7	),
	.count(		tf_count7	),
	.fifo_reset7(	tx_reset7	),
	.reset_status7(lsr_mask7)
);

// TRANSMITTER7 FINAL7 STATE7 MACHINE7

parameter s_idle7        = 3'd0;
parameter s_send_start7  = 3'd1;
parameter s_send_byte7   = 3'd2;
parameter s_send_parity7 = 3'd3;
parameter s_send_stop7   = 3'd4;
parameter s_pop_byte7    = 3'd5;

always @(posedge clk7 or posedge wb_rst_i7)
begin
  if (wb_rst_i7)
  begin
	tstate7       <= #1 s_idle7;
	stx_o_tmp7       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out7   <= #1 7'b0;
	bit_out7     <= #1 1'b0;
	parity_xor7  <= #1 1'b0;
	tf_pop7      <= #1 1'b0;
	bit_counter7 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate7)
	s_idle7	 :	if (~|tf_count7) // if tf_count7==0
			begin
				tstate7 <= #1 s_idle7;
				stx_o_tmp7 <= #1 1'b1;
			end
			else
			begin
				tf_pop7 <= #1 1'b0;
				stx_o_tmp7  <= #1 1'b1;
				tstate7  <= #1 s_pop_byte7;
			end
	s_pop_byte7 :	begin
				tf_pop7 <= #1 1'b1;
				case (lcr7[/*`UART_LC_BITS7*/1:0])  // number7 of bits in a word7
				2'b00 : begin
					bit_counter7 <= #1 3'b100;
					parity_xor7  <= #1 ^tf_data_out7[4:0];
				     end
				2'b01 : begin
					bit_counter7 <= #1 3'b101;
					parity_xor7  <= #1 ^tf_data_out7[5:0];
				     end
				2'b10 : begin
					bit_counter7 <= #1 3'b110;
					parity_xor7  <= #1 ^tf_data_out7[6:0];
				     end
				2'b11 : begin
					bit_counter7 <= #1 3'b111;
					parity_xor7  <= #1 ^tf_data_out7[7:0];
				     end
				endcase
				{shift_out7[6:0], bit_out7} <= #1 tf_data_out7;
				tstate7 <= #1 s_send_start7;
			end
	s_send_start7 :	begin
				tf_pop7 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate7 <= #1 s_send_byte7;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp7 <= #1 1'b0;
			end
	s_send_byte7 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter7 > 3'b0)
					begin
						bit_counter7 <= #1 bit_counter7 - 1'b1;
						{shift_out7[5:0],bit_out7  } <= #1 {shift_out7[6:1], shift_out7[0]};
						tstate7 <= #1 s_send_byte7;
					end
					else   // end of byte
					if (~lcr7[`UART_LC_PE7])
					begin
						tstate7 <= #1 s_send_stop7;
					end
					else
					begin
						case ({lcr7[`UART_LC_EP7],lcr7[`UART_LC_SP7]})
						2'b00:	bit_out7 <= #1 ~parity_xor7;
						2'b01:	bit_out7 <= #1 1'b1;
						2'b10:	bit_out7 <= #1 parity_xor7;
						2'b11:	bit_out7 <= #1 1'b0;
						endcase
						tstate7 <= #1 s_send_parity7;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp7 <= #1 bit_out7; // set output pin7
			end
	s_send_parity7 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate7 <= #1 s_send_stop7;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp7 <= #1 bit_out7;
			end
	s_send_stop7 :  begin
				if (~|counter)
				  begin
						casex ({lcr7[`UART_LC_SB7],lcr7[`UART_LC_BITS7]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor7
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate7 <= #1 s_idle7;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp7 <= #1 1'b1;
			end

		default : // should never get here7
			tstate7 <= #1 s_idle7;
	endcase
  end // end if enable
  else
    tf_pop7 <= #1 1'b0;  // tf_pop7 must be 1 cycle width
end // transmitter7 logic

assign stx_pad_o7 = lcr7[`UART_LC_BC7] ? 1'b0 : stx_o_tmp7;    // Break7 condition
	
endmodule
