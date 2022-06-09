//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter13.v                                          ////
////                                                              ////
////                                                              ////
////  This13 file is part of the "UART13 16550 compatible13" project13    ////
////  http13://www13.opencores13.org13/cores13/uart1655013/                   ////
////                                                              ////
////  Documentation13 related13 to this project13:                      ////
////  - http13://www13.opencores13.org13/cores13/uart1655013/                 ////
////                                                              ////
////  Projects13 compatibility13:                                     ////
////  - WISHBONE13                                                  ////
////  RS23213 Protocol13                                              ////
////  16550D uart13 (mostly13 supported)                              ////
////                                                              ////
////  Overview13 (main13 Features13):                                   ////
////  UART13 core13 transmitter13 logic                                 ////
////                                                              ////
////  Known13 problems13 (limits13):                                    ////
////  None13 known13                                                  ////
////                                                              ////
////  To13 Do13:                                                      ////
////  Thourough13 testing13.                                          ////
////                                                              ////
////  Author13(s):                                                  ////
////      - gorban13@opencores13.org13                                  ////
////      - Jacob13 Gorban13                                          ////
////      - Igor13 Mohor13 (igorm13@opencores13.org13)                      ////
////                                                              ////
////  Created13:        2001/05/12                                  ////
////  Last13 Updated13:   2001/05/17                                  ////
////                  (See log13 for the revision13 history13)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2000, 2001 Authors13                             ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS13 Revision13 History13
//
// $Log: not supported by cvs2svn13 $
// Revision13 1.18  2002/07/22 23:02:23  gorban13
// Bug13 Fixes13:
//  * Possible13 loss of sync and bad13 reception13 of stop bit on slow13 baud13 rates13 fixed13.
//   Problem13 reported13 by Kenny13.Tung13.
//  * Bad (or lack13 of ) loopback13 handling13 fixed13. Reported13 by Cherry13 Withers13.
//
// Improvements13:
//  * Made13 FIFO's as general13 inferrable13 memory where possible13.
//  So13 on FPGA13 they should be inferred13 as RAM13 (Distributed13 RAM13 on Xilinx13).
//  This13 saves13 about13 1/3 of the Slice13 count and reduces13 P&R and synthesis13 times.
//
//  * Added13 optional13 baudrate13 output (baud_o13).
//  This13 is identical13 to BAUDOUT13* signal13 on 16550 chip13.
//  It outputs13 16xbit_clock_rate - the divided13 clock13.
//  It's disabled by default. Define13 UART_HAS_BAUDRATE_OUTPUT13 to use.
//
// Revision13 1.16  2002/01/08 11:29:40  mohor13
// tf_pop13 was too wide13. Now13 it is only 1 clk13 cycle width.
//
// Revision13 1.15  2001/12/17 14:46:48  mohor13
// overrun13 signal13 was moved to separate13 block because many13 sequential13 lsr13
// reads were13 preventing13 data from being written13 to rx13 fifo.
// underrun13 signal13 was not used and was removed from the project13.
//
// Revision13 1.14  2001/12/03 21:44:29  gorban13
// Updated13 specification13 documentation.
// Added13 full 32-bit data bus interface, now as default.
// Address is 5-bit wide13 in 32-bit data bus mode.
// Added13 wb_sel_i13 input to the core13. It's used in the 32-bit mode.
// Added13 debug13 interface with two13 32-bit read-only registers in 32-bit mode.
// Bits13 5 and 6 of LSR13 are now only cleared13 on TX13 FIFO write.
// My13 small test bench13 is modified to work13 with 32-bit mode.
//
// Revision13 1.13  2001/11/08 14:54:23  mohor13
// Comments13 in Slovene13 language13 deleted13, few13 small fixes13 for better13 work13 of
// old13 tools13. IRQs13 need to be fix13.
//
// Revision13 1.12  2001/11/07 17:51:52  gorban13
// Heavily13 rewritten13 interrupt13 and LSR13 subsystems13.
// Many13 bugs13 hopefully13 squashed13.
//
// Revision13 1.11  2001/10/29 17:00:46  gorban13
// fixed13 parity13 sending13 and tx_fifo13 resets13 over- and underrun13
//
// Revision13 1.10  2001/10/20 09:58:40  gorban13
// Small13 synopsis13 fixes13
//
// Revision13 1.9  2001/08/24 21:01:12  mohor13
// Things13 connected13 to parity13 changed.
// Clock13 devider13 changed.
//
// Revision13 1.8  2001/08/23 16:05:05  mohor13
// Stop bit bug13 fixed13.
// Parity13 bug13 fixed13.
// WISHBONE13 read cycle bug13 fixed13,
// OE13 indicator13 (Overrun13 Error) bug13 fixed13.
// PE13 indicator13 (Parity13 Error) bug13 fixed13.
// Register read bug13 fixed13.
//
// Revision13 1.6  2001/06/23 11:21:48  gorban13
// DL13 made13 16-bit long13. Fixed13 transmission13/reception13 bugs13.
//
// Revision13 1.5  2001/06/02 14:28:14  gorban13
// Fixed13 receiver13 and transmitter13. Major13 bug13 fixed13.
//
// Revision13 1.4  2001/05/31 20:08:01  gorban13
// FIFO changes13 and other corrections13.
//
// Revision13 1.3  2001/05/27 17:37:49  gorban13
// Fixed13 many13 bugs13. Updated13 spec13. Changed13 FIFO files structure13. See CHANGES13.txt13 file.
//
// Revision13 1.2  2001/05/21 19:12:02  gorban13
// Corrected13 some13 Linter13 messages13.
//
// Revision13 1.1  2001/05/17 18:34:18  gorban13
// First13 'stable' release. Should13 be sythesizable13 now. Also13 added new header.
//
// Revision13 1.0  2001-05-17 21:27:12+02  jacob13
// Initial13 revision13
//
//

// synopsys13 translate_off13
`include "timescale.v"
// synopsys13 translate_on13

`include "uart_defines13.v"

module uart_transmitter13 (clk13, wb_rst_i13, lcr13, tf_push13, wb_dat_i13, enable,	stx_pad_o13, tstate13, tf_count13, tx_reset13, lsr_mask13);

input 										clk13;
input 										wb_rst_i13;
input [7:0] 								lcr13;
input 										tf_push13;
input [7:0] 								wb_dat_i13;
input 										enable;
input 										tx_reset13;
input 										lsr_mask13; //reset of fifo
output 										stx_pad_o13;
output [2:0] 								tstate13;
output [`UART_FIFO_COUNTER_W13-1:0] 	tf_count13;

reg [2:0] 									tstate13;
reg [4:0] 									counter;
reg [2:0] 									bit_counter13;   // counts13 the bits to be sent13
reg [6:0] 									shift_out13;	// output shift13 register
reg 											stx_o_tmp13;
reg 											parity_xor13;  // parity13 of the word13
reg 											tf_pop13;
reg 											bit_out13;

// TX13 FIFO instance
//
// Transmitter13 FIFO signals13
wire [`UART_FIFO_WIDTH13-1:0] 			tf_data_in13;
wire [`UART_FIFO_WIDTH13-1:0] 			tf_data_out13;
wire 											tf_push13;
wire 											tf_overrun13;
wire [`UART_FIFO_COUNTER_W13-1:0] 		tf_count13;

assign 										tf_data_in13 = wb_dat_i13;

uart_tfifo13 fifo_tx13(	// error bit signal13 is not used in transmitter13 FIFO
	.clk13(		clk13		), 
	.wb_rst_i13(	wb_rst_i13	),
	.data_in13(	tf_data_in13	),
	.data_out13(	tf_data_out13	),
	.push13(		tf_push13		),
	.pop13(		tf_pop13		),
	.overrun13(	tf_overrun13	),
	.count(		tf_count13	),
	.fifo_reset13(	tx_reset13	),
	.reset_status13(lsr_mask13)
);

// TRANSMITTER13 FINAL13 STATE13 MACHINE13

parameter s_idle13        = 3'd0;
parameter s_send_start13  = 3'd1;
parameter s_send_byte13   = 3'd2;
parameter s_send_parity13 = 3'd3;
parameter s_send_stop13   = 3'd4;
parameter s_pop_byte13    = 3'd5;

always @(posedge clk13 or posedge wb_rst_i13)
begin
  if (wb_rst_i13)
  begin
	tstate13       <= #1 s_idle13;
	stx_o_tmp13       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out13   <= #1 7'b0;
	bit_out13     <= #1 1'b0;
	parity_xor13  <= #1 1'b0;
	tf_pop13      <= #1 1'b0;
	bit_counter13 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate13)
	s_idle13	 :	if (~|tf_count13) // if tf_count13==0
			begin
				tstate13 <= #1 s_idle13;
				stx_o_tmp13 <= #1 1'b1;
			end
			else
			begin
				tf_pop13 <= #1 1'b0;
				stx_o_tmp13  <= #1 1'b1;
				tstate13  <= #1 s_pop_byte13;
			end
	s_pop_byte13 :	begin
				tf_pop13 <= #1 1'b1;
				case (lcr13[/*`UART_LC_BITS13*/1:0])  // number13 of bits in a word13
				2'b00 : begin
					bit_counter13 <= #1 3'b100;
					parity_xor13  <= #1 ^tf_data_out13[4:0];
				     end
				2'b01 : begin
					bit_counter13 <= #1 3'b101;
					parity_xor13  <= #1 ^tf_data_out13[5:0];
				     end
				2'b10 : begin
					bit_counter13 <= #1 3'b110;
					parity_xor13  <= #1 ^tf_data_out13[6:0];
				     end
				2'b11 : begin
					bit_counter13 <= #1 3'b111;
					parity_xor13  <= #1 ^tf_data_out13[7:0];
				     end
				endcase
				{shift_out13[6:0], bit_out13} <= #1 tf_data_out13;
				tstate13 <= #1 s_send_start13;
			end
	s_send_start13 :	begin
				tf_pop13 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate13 <= #1 s_send_byte13;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp13 <= #1 1'b0;
			end
	s_send_byte13 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter13 > 3'b0)
					begin
						bit_counter13 <= #1 bit_counter13 - 1'b1;
						{shift_out13[5:0],bit_out13  } <= #1 {shift_out13[6:1], shift_out13[0]};
						tstate13 <= #1 s_send_byte13;
					end
					else   // end of byte
					if (~lcr13[`UART_LC_PE13])
					begin
						tstate13 <= #1 s_send_stop13;
					end
					else
					begin
						case ({lcr13[`UART_LC_EP13],lcr13[`UART_LC_SP13]})
						2'b00:	bit_out13 <= #1 ~parity_xor13;
						2'b01:	bit_out13 <= #1 1'b1;
						2'b10:	bit_out13 <= #1 parity_xor13;
						2'b11:	bit_out13 <= #1 1'b0;
						endcase
						tstate13 <= #1 s_send_parity13;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp13 <= #1 bit_out13; // set output pin13
			end
	s_send_parity13 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate13 <= #1 s_send_stop13;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp13 <= #1 bit_out13;
			end
	s_send_stop13 :  begin
				if (~|counter)
				  begin
						casex ({lcr13[`UART_LC_SB13],lcr13[`UART_LC_BITS13]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor13
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate13 <= #1 s_idle13;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp13 <= #1 1'b1;
			end

		default : // should never get here13
			tstate13 <= #1 s_idle13;
	endcase
  end // end if enable
  else
    tf_pop13 <= #1 1'b0;  // tf_pop13 must be 1 cycle width
end // transmitter13 logic

assign stx_pad_o13 = lcr13[`UART_LC_BC13] ? 1'b0 : stx_o_tmp13;    // Break13 condition
	
endmodule
