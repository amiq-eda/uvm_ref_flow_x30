//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter11.v                                          ////
////                                                              ////
////                                                              ////
////  This11 file is part of the "UART11 16550 compatible11" project11    ////
////  http11://www11.opencores11.org11/cores11/uart1655011/                   ////
////                                                              ////
////  Documentation11 related11 to this project11:                      ////
////  - http11://www11.opencores11.org11/cores11/uart1655011/                 ////
////                                                              ////
////  Projects11 compatibility11:                                     ////
////  - WISHBONE11                                                  ////
////  RS23211 Protocol11                                              ////
////  16550D uart11 (mostly11 supported)                              ////
////                                                              ////
////  Overview11 (main11 Features11):                                   ////
////  UART11 core11 transmitter11 logic                                 ////
////                                                              ////
////  Known11 problems11 (limits11):                                    ////
////  None11 known11                                                  ////
////                                                              ////
////  To11 Do11:                                                      ////
////  Thourough11 testing11.                                          ////
////                                                              ////
////  Author11(s):                                                  ////
////      - gorban11@opencores11.org11                                  ////
////      - Jacob11 Gorban11                                          ////
////      - Igor11 Mohor11 (igorm11@opencores11.org11)                      ////
////                                                              ////
////  Created11:        2001/05/12                                  ////
////  Last11 Updated11:   2001/05/17                                  ////
////                  (See log11 for the revision11 history11)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2000, 2001 Authors11                             ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS11 Revision11 History11
//
// $Log: not supported by cvs2svn11 $
// Revision11 1.18  2002/07/22 23:02:23  gorban11
// Bug11 Fixes11:
//  * Possible11 loss of sync and bad11 reception11 of stop bit on slow11 baud11 rates11 fixed11.
//   Problem11 reported11 by Kenny11.Tung11.
//  * Bad (or lack11 of ) loopback11 handling11 fixed11. Reported11 by Cherry11 Withers11.
//
// Improvements11:
//  * Made11 FIFO's as general11 inferrable11 memory where possible11.
//  So11 on FPGA11 they should be inferred11 as RAM11 (Distributed11 RAM11 on Xilinx11).
//  This11 saves11 about11 1/3 of the Slice11 count and reduces11 P&R and synthesis11 times.
//
//  * Added11 optional11 baudrate11 output (baud_o11).
//  This11 is identical11 to BAUDOUT11* signal11 on 16550 chip11.
//  It outputs11 16xbit_clock_rate - the divided11 clock11.
//  It's disabled by default. Define11 UART_HAS_BAUDRATE_OUTPUT11 to use.
//
// Revision11 1.16  2002/01/08 11:29:40  mohor11
// tf_pop11 was too wide11. Now11 it is only 1 clk11 cycle width.
//
// Revision11 1.15  2001/12/17 14:46:48  mohor11
// overrun11 signal11 was moved to separate11 block because many11 sequential11 lsr11
// reads were11 preventing11 data from being written11 to rx11 fifo.
// underrun11 signal11 was not used and was removed from the project11.
//
// Revision11 1.14  2001/12/03 21:44:29  gorban11
// Updated11 specification11 documentation.
// Added11 full 32-bit data bus interface, now as default.
// Address is 5-bit wide11 in 32-bit data bus mode.
// Added11 wb_sel_i11 input to the core11. It's used in the 32-bit mode.
// Added11 debug11 interface with two11 32-bit read-only registers in 32-bit mode.
// Bits11 5 and 6 of LSR11 are now only cleared11 on TX11 FIFO write.
// My11 small test bench11 is modified to work11 with 32-bit mode.
//
// Revision11 1.13  2001/11/08 14:54:23  mohor11
// Comments11 in Slovene11 language11 deleted11, few11 small fixes11 for better11 work11 of
// old11 tools11. IRQs11 need to be fix11.
//
// Revision11 1.12  2001/11/07 17:51:52  gorban11
// Heavily11 rewritten11 interrupt11 and LSR11 subsystems11.
// Many11 bugs11 hopefully11 squashed11.
//
// Revision11 1.11  2001/10/29 17:00:46  gorban11
// fixed11 parity11 sending11 and tx_fifo11 resets11 over- and underrun11
//
// Revision11 1.10  2001/10/20 09:58:40  gorban11
// Small11 synopsis11 fixes11
//
// Revision11 1.9  2001/08/24 21:01:12  mohor11
// Things11 connected11 to parity11 changed.
// Clock11 devider11 changed.
//
// Revision11 1.8  2001/08/23 16:05:05  mohor11
// Stop bit bug11 fixed11.
// Parity11 bug11 fixed11.
// WISHBONE11 read cycle bug11 fixed11,
// OE11 indicator11 (Overrun11 Error) bug11 fixed11.
// PE11 indicator11 (Parity11 Error) bug11 fixed11.
// Register read bug11 fixed11.
//
// Revision11 1.6  2001/06/23 11:21:48  gorban11
// DL11 made11 16-bit long11. Fixed11 transmission11/reception11 bugs11.
//
// Revision11 1.5  2001/06/02 14:28:14  gorban11
// Fixed11 receiver11 and transmitter11. Major11 bug11 fixed11.
//
// Revision11 1.4  2001/05/31 20:08:01  gorban11
// FIFO changes11 and other corrections11.
//
// Revision11 1.3  2001/05/27 17:37:49  gorban11
// Fixed11 many11 bugs11. Updated11 spec11. Changed11 FIFO files structure11. See CHANGES11.txt11 file.
//
// Revision11 1.2  2001/05/21 19:12:02  gorban11
// Corrected11 some11 Linter11 messages11.
//
// Revision11 1.1  2001/05/17 18:34:18  gorban11
// First11 'stable' release. Should11 be sythesizable11 now. Also11 added new header.
//
// Revision11 1.0  2001-05-17 21:27:12+02  jacob11
// Initial11 revision11
//
//

// synopsys11 translate_off11
`include "timescale.v"
// synopsys11 translate_on11

`include "uart_defines11.v"

module uart_transmitter11 (clk11, wb_rst_i11, lcr11, tf_push11, wb_dat_i11, enable,	stx_pad_o11, tstate11, tf_count11, tx_reset11, lsr_mask11);

input 										clk11;
input 										wb_rst_i11;
input [7:0] 								lcr11;
input 										tf_push11;
input [7:0] 								wb_dat_i11;
input 										enable;
input 										tx_reset11;
input 										lsr_mask11; //reset of fifo
output 										stx_pad_o11;
output [2:0] 								tstate11;
output [`UART_FIFO_COUNTER_W11-1:0] 	tf_count11;

reg [2:0] 									tstate11;
reg [4:0] 									counter;
reg [2:0] 									bit_counter11;   // counts11 the bits to be sent11
reg [6:0] 									shift_out11;	// output shift11 register
reg 											stx_o_tmp11;
reg 											parity_xor11;  // parity11 of the word11
reg 											tf_pop11;
reg 											bit_out11;

// TX11 FIFO instance
//
// Transmitter11 FIFO signals11
wire [`UART_FIFO_WIDTH11-1:0] 			tf_data_in11;
wire [`UART_FIFO_WIDTH11-1:0] 			tf_data_out11;
wire 											tf_push11;
wire 											tf_overrun11;
wire [`UART_FIFO_COUNTER_W11-1:0] 		tf_count11;

assign 										tf_data_in11 = wb_dat_i11;

uart_tfifo11 fifo_tx11(	// error bit signal11 is not used in transmitter11 FIFO
	.clk11(		clk11		), 
	.wb_rst_i11(	wb_rst_i11	),
	.data_in11(	tf_data_in11	),
	.data_out11(	tf_data_out11	),
	.push11(		tf_push11		),
	.pop11(		tf_pop11		),
	.overrun11(	tf_overrun11	),
	.count(		tf_count11	),
	.fifo_reset11(	tx_reset11	),
	.reset_status11(lsr_mask11)
);

// TRANSMITTER11 FINAL11 STATE11 MACHINE11

parameter s_idle11        = 3'd0;
parameter s_send_start11  = 3'd1;
parameter s_send_byte11   = 3'd2;
parameter s_send_parity11 = 3'd3;
parameter s_send_stop11   = 3'd4;
parameter s_pop_byte11    = 3'd5;

always @(posedge clk11 or posedge wb_rst_i11)
begin
  if (wb_rst_i11)
  begin
	tstate11       <= #1 s_idle11;
	stx_o_tmp11       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out11   <= #1 7'b0;
	bit_out11     <= #1 1'b0;
	parity_xor11  <= #1 1'b0;
	tf_pop11      <= #1 1'b0;
	bit_counter11 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate11)
	s_idle11	 :	if (~|tf_count11) // if tf_count11==0
			begin
				tstate11 <= #1 s_idle11;
				stx_o_tmp11 <= #1 1'b1;
			end
			else
			begin
				tf_pop11 <= #1 1'b0;
				stx_o_tmp11  <= #1 1'b1;
				tstate11  <= #1 s_pop_byte11;
			end
	s_pop_byte11 :	begin
				tf_pop11 <= #1 1'b1;
				case (lcr11[/*`UART_LC_BITS11*/1:0])  // number11 of bits in a word11
				2'b00 : begin
					bit_counter11 <= #1 3'b100;
					parity_xor11  <= #1 ^tf_data_out11[4:0];
				     end
				2'b01 : begin
					bit_counter11 <= #1 3'b101;
					parity_xor11  <= #1 ^tf_data_out11[5:0];
				     end
				2'b10 : begin
					bit_counter11 <= #1 3'b110;
					parity_xor11  <= #1 ^tf_data_out11[6:0];
				     end
				2'b11 : begin
					bit_counter11 <= #1 3'b111;
					parity_xor11  <= #1 ^tf_data_out11[7:0];
				     end
				endcase
				{shift_out11[6:0], bit_out11} <= #1 tf_data_out11;
				tstate11 <= #1 s_send_start11;
			end
	s_send_start11 :	begin
				tf_pop11 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate11 <= #1 s_send_byte11;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp11 <= #1 1'b0;
			end
	s_send_byte11 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter11 > 3'b0)
					begin
						bit_counter11 <= #1 bit_counter11 - 1'b1;
						{shift_out11[5:0],bit_out11  } <= #1 {shift_out11[6:1], shift_out11[0]};
						tstate11 <= #1 s_send_byte11;
					end
					else   // end of byte
					if (~lcr11[`UART_LC_PE11])
					begin
						tstate11 <= #1 s_send_stop11;
					end
					else
					begin
						case ({lcr11[`UART_LC_EP11],lcr11[`UART_LC_SP11]})
						2'b00:	bit_out11 <= #1 ~parity_xor11;
						2'b01:	bit_out11 <= #1 1'b1;
						2'b10:	bit_out11 <= #1 parity_xor11;
						2'b11:	bit_out11 <= #1 1'b0;
						endcase
						tstate11 <= #1 s_send_parity11;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp11 <= #1 bit_out11; // set output pin11
			end
	s_send_parity11 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate11 <= #1 s_send_stop11;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp11 <= #1 bit_out11;
			end
	s_send_stop11 :  begin
				if (~|counter)
				  begin
						casex ({lcr11[`UART_LC_SB11],lcr11[`UART_LC_BITS11]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor11
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate11 <= #1 s_idle11;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp11 <= #1 1'b1;
			end

		default : // should never get here11
			tstate11 <= #1 s_idle11;
	endcase
  end // end if enable
  else
    tf_pop11 <= #1 1'b0;  // tf_pop11 must be 1 cycle width
end // transmitter11 logic

assign stx_pad_o11 = lcr11[`UART_LC_BC11] ? 1'b0 : stx_o_tmp11;    // Break11 condition
	
endmodule
