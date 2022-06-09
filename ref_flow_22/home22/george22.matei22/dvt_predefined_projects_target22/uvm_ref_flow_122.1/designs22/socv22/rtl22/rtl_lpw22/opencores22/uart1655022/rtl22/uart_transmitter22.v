//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter22.v                                          ////
////                                                              ////
////                                                              ////
////  This22 file is part of the "UART22 16550 compatible22" project22    ////
////  http22://www22.opencores22.org22/cores22/uart1655022/                   ////
////                                                              ////
////  Documentation22 related22 to this project22:                      ////
////  - http22://www22.opencores22.org22/cores22/uart1655022/                 ////
////                                                              ////
////  Projects22 compatibility22:                                     ////
////  - WISHBONE22                                                  ////
////  RS23222 Protocol22                                              ////
////  16550D uart22 (mostly22 supported)                              ////
////                                                              ////
////  Overview22 (main22 Features22):                                   ////
////  UART22 core22 transmitter22 logic                                 ////
////                                                              ////
////  Known22 problems22 (limits22):                                    ////
////  None22 known22                                                  ////
////                                                              ////
////  To22 Do22:                                                      ////
////  Thourough22 testing22.                                          ////
////                                                              ////
////  Author22(s):                                                  ////
////      - gorban22@opencores22.org22                                  ////
////      - Jacob22 Gorban22                                          ////
////      - Igor22 Mohor22 (igorm22@opencores22.org22)                      ////
////                                                              ////
////  Created22:        2001/05/12                                  ////
////  Last22 Updated22:   2001/05/17                                  ////
////                  (See log22 for the revision22 history22)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2000, 2001 Authors22                             ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS22 Revision22 History22
//
// $Log: not supported by cvs2svn22 $
// Revision22 1.18  2002/07/22 23:02:23  gorban22
// Bug22 Fixes22:
//  * Possible22 loss of sync and bad22 reception22 of stop bit on slow22 baud22 rates22 fixed22.
//   Problem22 reported22 by Kenny22.Tung22.
//  * Bad (or lack22 of ) loopback22 handling22 fixed22. Reported22 by Cherry22 Withers22.
//
// Improvements22:
//  * Made22 FIFO's as general22 inferrable22 memory where possible22.
//  So22 on FPGA22 they should be inferred22 as RAM22 (Distributed22 RAM22 on Xilinx22).
//  This22 saves22 about22 1/3 of the Slice22 count and reduces22 P&R and synthesis22 times.
//
//  * Added22 optional22 baudrate22 output (baud_o22).
//  This22 is identical22 to BAUDOUT22* signal22 on 16550 chip22.
//  It outputs22 16xbit_clock_rate - the divided22 clock22.
//  It's disabled by default. Define22 UART_HAS_BAUDRATE_OUTPUT22 to use.
//
// Revision22 1.16  2002/01/08 11:29:40  mohor22
// tf_pop22 was too wide22. Now22 it is only 1 clk22 cycle width.
//
// Revision22 1.15  2001/12/17 14:46:48  mohor22
// overrun22 signal22 was moved to separate22 block because many22 sequential22 lsr22
// reads were22 preventing22 data from being written22 to rx22 fifo.
// underrun22 signal22 was not used and was removed from the project22.
//
// Revision22 1.14  2001/12/03 21:44:29  gorban22
// Updated22 specification22 documentation.
// Added22 full 32-bit data bus interface, now as default.
// Address is 5-bit wide22 in 32-bit data bus mode.
// Added22 wb_sel_i22 input to the core22. It's used in the 32-bit mode.
// Added22 debug22 interface with two22 32-bit read-only registers in 32-bit mode.
// Bits22 5 and 6 of LSR22 are now only cleared22 on TX22 FIFO write.
// My22 small test bench22 is modified to work22 with 32-bit mode.
//
// Revision22 1.13  2001/11/08 14:54:23  mohor22
// Comments22 in Slovene22 language22 deleted22, few22 small fixes22 for better22 work22 of
// old22 tools22. IRQs22 need to be fix22.
//
// Revision22 1.12  2001/11/07 17:51:52  gorban22
// Heavily22 rewritten22 interrupt22 and LSR22 subsystems22.
// Many22 bugs22 hopefully22 squashed22.
//
// Revision22 1.11  2001/10/29 17:00:46  gorban22
// fixed22 parity22 sending22 and tx_fifo22 resets22 over- and underrun22
//
// Revision22 1.10  2001/10/20 09:58:40  gorban22
// Small22 synopsis22 fixes22
//
// Revision22 1.9  2001/08/24 21:01:12  mohor22
// Things22 connected22 to parity22 changed.
// Clock22 devider22 changed.
//
// Revision22 1.8  2001/08/23 16:05:05  mohor22
// Stop bit bug22 fixed22.
// Parity22 bug22 fixed22.
// WISHBONE22 read cycle bug22 fixed22,
// OE22 indicator22 (Overrun22 Error) bug22 fixed22.
// PE22 indicator22 (Parity22 Error) bug22 fixed22.
// Register read bug22 fixed22.
//
// Revision22 1.6  2001/06/23 11:21:48  gorban22
// DL22 made22 16-bit long22. Fixed22 transmission22/reception22 bugs22.
//
// Revision22 1.5  2001/06/02 14:28:14  gorban22
// Fixed22 receiver22 and transmitter22. Major22 bug22 fixed22.
//
// Revision22 1.4  2001/05/31 20:08:01  gorban22
// FIFO changes22 and other corrections22.
//
// Revision22 1.3  2001/05/27 17:37:49  gorban22
// Fixed22 many22 bugs22. Updated22 spec22. Changed22 FIFO files structure22. See CHANGES22.txt22 file.
//
// Revision22 1.2  2001/05/21 19:12:02  gorban22
// Corrected22 some22 Linter22 messages22.
//
// Revision22 1.1  2001/05/17 18:34:18  gorban22
// First22 'stable' release. Should22 be sythesizable22 now. Also22 added new header.
//
// Revision22 1.0  2001-05-17 21:27:12+02  jacob22
// Initial22 revision22
//
//

// synopsys22 translate_off22
`include "timescale.v"
// synopsys22 translate_on22

`include "uart_defines22.v"

module uart_transmitter22 (clk22, wb_rst_i22, lcr22, tf_push22, wb_dat_i22, enable,	stx_pad_o22, tstate22, tf_count22, tx_reset22, lsr_mask22);

input 										clk22;
input 										wb_rst_i22;
input [7:0] 								lcr22;
input 										tf_push22;
input [7:0] 								wb_dat_i22;
input 										enable;
input 										tx_reset22;
input 										lsr_mask22; //reset of fifo
output 										stx_pad_o22;
output [2:0] 								tstate22;
output [`UART_FIFO_COUNTER_W22-1:0] 	tf_count22;

reg [2:0] 									tstate22;
reg [4:0] 									counter;
reg [2:0] 									bit_counter22;   // counts22 the bits to be sent22
reg [6:0] 									shift_out22;	// output shift22 register
reg 											stx_o_tmp22;
reg 											parity_xor22;  // parity22 of the word22
reg 											tf_pop22;
reg 											bit_out22;

// TX22 FIFO instance
//
// Transmitter22 FIFO signals22
wire [`UART_FIFO_WIDTH22-1:0] 			tf_data_in22;
wire [`UART_FIFO_WIDTH22-1:0] 			tf_data_out22;
wire 											tf_push22;
wire 											tf_overrun22;
wire [`UART_FIFO_COUNTER_W22-1:0] 		tf_count22;

assign 										tf_data_in22 = wb_dat_i22;

uart_tfifo22 fifo_tx22(	// error bit signal22 is not used in transmitter22 FIFO
	.clk22(		clk22		), 
	.wb_rst_i22(	wb_rst_i22	),
	.data_in22(	tf_data_in22	),
	.data_out22(	tf_data_out22	),
	.push22(		tf_push22		),
	.pop22(		tf_pop22		),
	.overrun22(	tf_overrun22	),
	.count(		tf_count22	),
	.fifo_reset22(	tx_reset22	),
	.reset_status22(lsr_mask22)
);

// TRANSMITTER22 FINAL22 STATE22 MACHINE22

parameter s_idle22        = 3'd0;
parameter s_send_start22  = 3'd1;
parameter s_send_byte22   = 3'd2;
parameter s_send_parity22 = 3'd3;
parameter s_send_stop22   = 3'd4;
parameter s_pop_byte22    = 3'd5;

always @(posedge clk22 or posedge wb_rst_i22)
begin
  if (wb_rst_i22)
  begin
	tstate22       <= #1 s_idle22;
	stx_o_tmp22       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out22   <= #1 7'b0;
	bit_out22     <= #1 1'b0;
	parity_xor22  <= #1 1'b0;
	tf_pop22      <= #1 1'b0;
	bit_counter22 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate22)
	s_idle22	 :	if (~|tf_count22) // if tf_count22==0
			begin
				tstate22 <= #1 s_idle22;
				stx_o_tmp22 <= #1 1'b1;
			end
			else
			begin
				tf_pop22 <= #1 1'b0;
				stx_o_tmp22  <= #1 1'b1;
				tstate22  <= #1 s_pop_byte22;
			end
	s_pop_byte22 :	begin
				tf_pop22 <= #1 1'b1;
				case (lcr22[/*`UART_LC_BITS22*/1:0])  // number22 of bits in a word22
				2'b00 : begin
					bit_counter22 <= #1 3'b100;
					parity_xor22  <= #1 ^tf_data_out22[4:0];
				     end
				2'b01 : begin
					bit_counter22 <= #1 3'b101;
					parity_xor22  <= #1 ^tf_data_out22[5:0];
				     end
				2'b10 : begin
					bit_counter22 <= #1 3'b110;
					parity_xor22  <= #1 ^tf_data_out22[6:0];
				     end
				2'b11 : begin
					bit_counter22 <= #1 3'b111;
					parity_xor22  <= #1 ^tf_data_out22[7:0];
				     end
				endcase
				{shift_out22[6:0], bit_out22} <= #1 tf_data_out22;
				tstate22 <= #1 s_send_start22;
			end
	s_send_start22 :	begin
				tf_pop22 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate22 <= #1 s_send_byte22;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp22 <= #1 1'b0;
			end
	s_send_byte22 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter22 > 3'b0)
					begin
						bit_counter22 <= #1 bit_counter22 - 1'b1;
						{shift_out22[5:0],bit_out22  } <= #1 {shift_out22[6:1], shift_out22[0]};
						tstate22 <= #1 s_send_byte22;
					end
					else   // end of byte
					if (~lcr22[`UART_LC_PE22])
					begin
						tstate22 <= #1 s_send_stop22;
					end
					else
					begin
						case ({lcr22[`UART_LC_EP22],lcr22[`UART_LC_SP22]})
						2'b00:	bit_out22 <= #1 ~parity_xor22;
						2'b01:	bit_out22 <= #1 1'b1;
						2'b10:	bit_out22 <= #1 parity_xor22;
						2'b11:	bit_out22 <= #1 1'b0;
						endcase
						tstate22 <= #1 s_send_parity22;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp22 <= #1 bit_out22; // set output pin22
			end
	s_send_parity22 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate22 <= #1 s_send_stop22;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp22 <= #1 bit_out22;
			end
	s_send_stop22 :  begin
				if (~|counter)
				  begin
						casex ({lcr22[`UART_LC_SB22],lcr22[`UART_LC_BITS22]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor22
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate22 <= #1 s_idle22;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp22 <= #1 1'b1;
			end

		default : // should never get here22
			tstate22 <= #1 s_idle22;
	endcase
  end // end if enable
  else
    tf_pop22 <= #1 1'b0;  // tf_pop22 must be 1 cycle width
end // transmitter22 logic

assign stx_pad_o22 = lcr22[`UART_LC_BC22] ? 1'b0 : stx_o_tmp22;    // Break22 condition
	
endmodule
