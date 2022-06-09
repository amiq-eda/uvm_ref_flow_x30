//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter4.v                                          ////
////                                                              ////
////                                                              ////
////  This4 file is part of the "UART4 16550 compatible4" project4    ////
////  http4://www4.opencores4.org4/cores4/uart165504/                   ////
////                                                              ////
////  Documentation4 related4 to this project4:                      ////
////  - http4://www4.opencores4.org4/cores4/uart165504/                 ////
////                                                              ////
////  Projects4 compatibility4:                                     ////
////  - WISHBONE4                                                  ////
////  RS2324 Protocol4                                              ////
////  16550D uart4 (mostly4 supported)                              ////
////                                                              ////
////  Overview4 (main4 Features4):                                   ////
////  UART4 core4 transmitter4 logic                                 ////
////                                                              ////
////  Known4 problems4 (limits4):                                    ////
////  None4 known4                                                  ////
////                                                              ////
////  To4 Do4:                                                      ////
////  Thourough4 testing4.                                          ////
////                                                              ////
////  Author4(s):                                                  ////
////      - gorban4@opencores4.org4                                  ////
////      - Jacob4 Gorban4                                          ////
////      - Igor4 Mohor4 (igorm4@opencores4.org4)                      ////
////                                                              ////
////  Created4:        2001/05/12                                  ////
////  Last4 Updated4:   2001/05/17                                  ////
////                  (See log4 for the revision4 history4)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2000, 2001 Authors4                             ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS4 Revision4 History4
//
// $Log: not supported by cvs2svn4 $
// Revision4 1.18  2002/07/22 23:02:23  gorban4
// Bug4 Fixes4:
//  * Possible4 loss of sync and bad4 reception4 of stop bit on slow4 baud4 rates4 fixed4.
//   Problem4 reported4 by Kenny4.Tung4.
//  * Bad (or lack4 of ) loopback4 handling4 fixed4. Reported4 by Cherry4 Withers4.
//
// Improvements4:
//  * Made4 FIFO's as general4 inferrable4 memory where possible4.
//  So4 on FPGA4 they should be inferred4 as RAM4 (Distributed4 RAM4 on Xilinx4).
//  This4 saves4 about4 1/3 of the Slice4 count and reduces4 P&R and synthesis4 times.
//
//  * Added4 optional4 baudrate4 output (baud_o4).
//  This4 is identical4 to BAUDOUT4* signal4 on 16550 chip4.
//  It outputs4 16xbit_clock_rate - the divided4 clock4.
//  It's disabled by default. Define4 UART_HAS_BAUDRATE_OUTPUT4 to use.
//
// Revision4 1.16  2002/01/08 11:29:40  mohor4
// tf_pop4 was too wide4. Now4 it is only 1 clk4 cycle width.
//
// Revision4 1.15  2001/12/17 14:46:48  mohor4
// overrun4 signal4 was moved to separate4 block because many4 sequential4 lsr4
// reads were4 preventing4 data from being written4 to rx4 fifo.
// underrun4 signal4 was not used and was removed from the project4.
//
// Revision4 1.14  2001/12/03 21:44:29  gorban4
// Updated4 specification4 documentation.
// Added4 full 32-bit data bus interface, now as default.
// Address is 5-bit wide4 in 32-bit data bus mode.
// Added4 wb_sel_i4 input to the core4. It's used in the 32-bit mode.
// Added4 debug4 interface with two4 32-bit read-only registers in 32-bit mode.
// Bits4 5 and 6 of LSR4 are now only cleared4 on TX4 FIFO write.
// My4 small test bench4 is modified to work4 with 32-bit mode.
//
// Revision4 1.13  2001/11/08 14:54:23  mohor4
// Comments4 in Slovene4 language4 deleted4, few4 small fixes4 for better4 work4 of
// old4 tools4. IRQs4 need to be fix4.
//
// Revision4 1.12  2001/11/07 17:51:52  gorban4
// Heavily4 rewritten4 interrupt4 and LSR4 subsystems4.
// Many4 bugs4 hopefully4 squashed4.
//
// Revision4 1.11  2001/10/29 17:00:46  gorban4
// fixed4 parity4 sending4 and tx_fifo4 resets4 over- and underrun4
//
// Revision4 1.10  2001/10/20 09:58:40  gorban4
// Small4 synopsis4 fixes4
//
// Revision4 1.9  2001/08/24 21:01:12  mohor4
// Things4 connected4 to parity4 changed.
// Clock4 devider4 changed.
//
// Revision4 1.8  2001/08/23 16:05:05  mohor4
// Stop bit bug4 fixed4.
// Parity4 bug4 fixed4.
// WISHBONE4 read cycle bug4 fixed4,
// OE4 indicator4 (Overrun4 Error) bug4 fixed4.
// PE4 indicator4 (Parity4 Error) bug4 fixed4.
// Register read bug4 fixed4.
//
// Revision4 1.6  2001/06/23 11:21:48  gorban4
// DL4 made4 16-bit long4. Fixed4 transmission4/reception4 bugs4.
//
// Revision4 1.5  2001/06/02 14:28:14  gorban4
// Fixed4 receiver4 and transmitter4. Major4 bug4 fixed4.
//
// Revision4 1.4  2001/05/31 20:08:01  gorban4
// FIFO changes4 and other corrections4.
//
// Revision4 1.3  2001/05/27 17:37:49  gorban4
// Fixed4 many4 bugs4. Updated4 spec4. Changed4 FIFO files structure4. See CHANGES4.txt4 file.
//
// Revision4 1.2  2001/05/21 19:12:02  gorban4
// Corrected4 some4 Linter4 messages4.
//
// Revision4 1.1  2001/05/17 18:34:18  gorban4
// First4 'stable' release. Should4 be sythesizable4 now. Also4 added new header.
//
// Revision4 1.0  2001-05-17 21:27:12+02  jacob4
// Initial4 revision4
//
//

// synopsys4 translate_off4
`include "timescale.v"
// synopsys4 translate_on4

`include "uart_defines4.v"

module uart_transmitter4 (clk4, wb_rst_i4, lcr4, tf_push4, wb_dat_i4, enable,	stx_pad_o4, tstate4, tf_count4, tx_reset4, lsr_mask4);

input 										clk4;
input 										wb_rst_i4;
input [7:0] 								lcr4;
input 										tf_push4;
input [7:0] 								wb_dat_i4;
input 										enable;
input 										tx_reset4;
input 										lsr_mask4; //reset of fifo
output 										stx_pad_o4;
output [2:0] 								tstate4;
output [`UART_FIFO_COUNTER_W4-1:0] 	tf_count4;

reg [2:0] 									tstate4;
reg [4:0] 									counter;
reg [2:0] 									bit_counter4;   // counts4 the bits to be sent4
reg [6:0] 									shift_out4;	// output shift4 register
reg 											stx_o_tmp4;
reg 											parity_xor4;  // parity4 of the word4
reg 											tf_pop4;
reg 											bit_out4;

// TX4 FIFO instance
//
// Transmitter4 FIFO signals4
wire [`UART_FIFO_WIDTH4-1:0] 			tf_data_in4;
wire [`UART_FIFO_WIDTH4-1:0] 			tf_data_out4;
wire 											tf_push4;
wire 											tf_overrun4;
wire [`UART_FIFO_COUNTER_W4-1:0] 		tf_count4;

assign 										tf_data_in4 = wb_dat_i4;

uart_tfifo4 fifo_tx4(	// error bit signal4 is not used in transmitter4 FIFO
	.clk4(		clk4		), 
	.wb_rst_i4(	wb_rst_i4	),
	.data_in4(	tf_data_in4	),
	.data_out4(	tf_data_out4	),
	.push4(		tf_push4		),
	.pop4(		tf_pop4		),
	.overrun4(	tf_overrun4	),
	.count(		tf_count4	),
	.fifo_reset4(	tx_reset4	),
	.reset_status4(lsr_mask4)
);

// TRANSMITTER4 FINAL4 STATE4 MACHINE4

parameter s_idle4        = 3'd0;
parameter s_send_start4  = 3'd1;
parameter s_send_byte4   = 3'd2;
parameter s_send_parity4 = 3'd3;
parameter s_send_stop4   = 3'd4;
parameter s_pop_byte4    = 3'd5;

always @(posedge clk4 or posedge wb_rst_i4)
begin
  if (wb_rst_i4)
  begin
	tstate4       <= #1 s_idle4;
	stx_o_tmp4       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out4   <= #1 7'b0;
	bit_out4     <= #1 1'b0;
	parity_xor4  <= #1 1'b0;
	tf_pop4      <= #1 1'b0;
	bit_counter4 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate4)
	s_idle4	 :	if (~|tf_count4) // if tf_count4==0
			begin
				tstate4 <= #1 s_idle4;
				stx_o_tmp4 <= #1 1'b1;
			end
			else
			begin
				tf_pop4 <= #1 1'b0;
				stx_o_tmp4  <= #1 1'b1;
				tstate4  <= #1 s_pop_byte4;
			end
	s_pop_byte4 :	begin
				tf_pop4 <= #1 1'b1;
				case (lcr4[/*`UART_LC_BITS4*/1:0])  // number4 of bits in a word4
				2'b00 : begin
					bit_counter4 <= #1 3'b100;
					parity_xor4  <= #1 ^tf_data_out4[4:0];
				     end
				2'b01 : begin
					bit_counter4 <= #1 3'b101;
					parity_xor4  <= #1 ^tf_data_out4[5:0];
				     end
				2'b10 : begin
					bit_counter4 <= #1 3'b110;
					parity_xor4  <= #1 ^tf_data_out4[6:0];
				     end
				2'b11 : begin
					bit_counter4 <= #1 3'b111;
					parity_xor4  <= #1 ^tf_data_out4[7:0];
				     end
				endcase
				{shift_out4[6:0], bit_out4} <= #1 tf_data_out4;
				tstate4 <= #1 s_send_start4;
			end
	s_send_start4 :	begin
				tf_pop4 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate4 <= #1 s_send_byte4;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp4 <= #1 1'b0;
			end
	s_send_byte4 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter4 > 3'b0)
					begin
						bit_counter4 <= #1 bit_counter4 - 1'b1;
						{shift_out4[5:0],bit_out4  } <= #1 {shift_out4[6:1], shift_out4[0]};
						tstate4 <= #1 s_send_byte4;
					end
					else   // end of byte
					if (~lcr4[`UART_LC_PE4])
					begin
						tstate4 <= #1 s_send_stop4;
					end
					else
					begin
						case ({lcr4[`UART_LC_EP4],lcr4[`UART_LC_SP4]})
						2'b00:	bit_out4 <= #1 ~parity_xor4;
						2'b01:	bit_out4 <= #1 1'b1;
						2'b10:	bit_out4 <= #1 parity_xor4;
						2'b11:	bit_out4 <= #1 1'b0;
						endcase
						tstate4 <= #1 s_send_parity4;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp4 <= #1 bit_out4; // set output pin4
			end
	s_send_parity4 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate4 <= #1 s_send_stop4;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp4 <= #1 bit_out4;
			end
	s_send_stop4 :  begin
				if (~|counter)
				  begin
						casex ({lcr4[`UART_LC_SB4],lcr4[`UART_LC_BITS4]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor4
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate4 <= #1 s_idle4;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp4 <= #1 1'b1;
			end

		default : // should never get here4
			tstate4 <= #1 s_idle4;
	endcase
  end // end if enable
  else
    tf_pop4 <= #1 1'b0;  // tf_pop4 must be 1 cycle width
end // transmitter4 logic

assign stx_pad_o4 = lcr4[`UART_LC_BC4] ? 1'b0 : stx_o_tmp4;    // Break4 condition
	
endmodule
