//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter20.v                                          ////
////                                                              ////
////                                                              ////
////  This20 file is part of the "UART20 16550 compatible20" project20    ////
////  http20://www20.opencores20.org20/cores20/uart1655020/                   ////
////                                                              ////
////  Documentation20 related20 to this project20:                      ////
////  - http20://www20.opencores20.org20/cores20/uart1655020/                 ////
////                                                              ////
////  Projects20 compatibility20:                                     ////
////  - WISHBONE20                                                  ////
////  RS23220 Protocol20                                              ////
////  16550D uart20 (mostly20 supported)                              ////
////                                                              ////
////  Overview20 (main20 Features20):                                   ////
////  UART20 core20 transmitter20 logic                                 ////
////                                                              ////
////  Known20 problems20 (limits20):                                    ////
////  None20 known20                                                  ////
////                                                              ////
////  To20 Do20:                                                      ////
////  Thourough20 testing20.                                          ////
////                                                              ////
////  Author20(s):                                                  ////
////      - gorban20@opencores20.org20                                  ////
////      - Jacob20 Gorban20                                          ////
////      - Igor20 Mohor20 (igorm20@opencores20.org20)                      ////
////                                                              ////
////  Created20:        2001/05/12                                  ////
////  Last20 Updated20:   2001/05/17                                  ////
////                  (See log20 for the revision20 history20)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2000, 2001 Authors20                             ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS20 Revision20 History20
//
// $Log: not supported by cvs2svn20 $
// Revision20 1.18  2002/07/22 23:02:23  gorban20
// Bug20 Fixes20:
//  * Possible20 loss of sync and bad20 reception20 of stop bit on slow20 baud20 rates20 fixed20.
//   Problem20 reported20 by Kenny20.Tung20.
//  * Bad (or lack20 of ) loopback20 handling20 fixed20. Reported20 by Cherry20 Withers20.
//
// Improvements20:
//  * Made20 FIFO's as general20 inferrable20 memory where possible20.
//  So20 on FPGA20 they should be inferred20 as RAM20 (Distributed20 RAM20 on Xilinx20).
//  This20 saves20 about20 1/3 of the Slice20 count and reduces20 P&R and synthesis20 times.
//
//  * Added20 optional20 baudrate20 output (baud_o20).
//  This20 is identical20 to BAUDOUT20* signal20 on 16550 chip20.
//  It outputs20 16xbit_clock_rate - the divided20 clock20.
//  It's disabled by default. Define20 UART_HAS_BAUDRATE_OUTPUT20 to use.
//
// Revision20 1.16  2002/01/08 11:29:40  mohor20
// tf_pop20 was too wide20. Now20 it is only 1 clk20 cycle width.
//
// Revision20 1.15  2001/12/17 14:46:48  mohor20
// overrun20 signal20 was moved to separate20 block because many20 sequential20 lsr20
// reads were20 preventing20 data from being written20 to rx20 fifo.
// underrun20 signal20 was not used and was removed from the project20.
//
// Revision20 1.14  2001/12/03 21:44:29  gorban20
// Updated20 specification20 documentation.
// Added20 full 32-bit data bus interface, now as default.
// Address is 5-bit wide20 in 32-bit data bus mode.
// Added20 wb_sel_i20 input to the core20. It's used in the 32-bit mode.
// Added20 debug20 interface with two20 32-bit read-only registers in 32-bit mode.
// Bits20 5 and 6 of LSR20 are now only cleared20 on TX20 FIFO write.
// My20 small test bench20 is modified to work20 with 32-bit mode.
//
// Revision20 1.13  2001/11/08 14:54:23  mohor20
// Comments20 in Slovene20 language20 deleted20, few20 small fixes20 for better20 work20 of
// old20 tools20. IRQs20 need to be fix20.
//
// Revision20 1.12  2001/11/07 17:51:52  gorban20
// Heavily20 rewritten20 interrupt20 and LSR20 subsystems20.
// Many20 bugs20 hopefully20 squashed20.
//
// Revision20 1.11  2001/10/29 17:00:46  gorban20
// fixed20 parity20 sending20 and tx_fifo20 resets20 over- and underrun20
//
// Revision20 1.10  2001/10/20 09:58:40  gorban20
// Small20 synopsis20 fixes20
//
// Revision20 1.9  2001/08/24 21:01:12  mohor20
// Things20 connected20 to parity20 changed.
// Clock20 devider20 changed.
//
// Revision20 1.8  2001/08/23 16:05:05  mohor20
// Stop bit bug20 fixed20.
// Parity20 bug20 fixed20.
// WISHBONE20 read cycle bug20 fixed20,
// OE20 indicator20 (Overrun20 Error) bug20 fixed20.
// PE20 indicator20 (Parity20 Error) bug20 fixed20.
// Register read bug20 fixed20.
//
// Revision20 1.6  2001/06/23 11:21:48  gorban20
// DL20 made20 16-bit long20. Fixed20 transmission20/reception20 bugs20.
//
// Revision20 1.5  2001/06/02 14:28:14  gorban20
// Fixed20 receiver20 and transmitter20. Major20 bug20 fixed20.
//
// Revision20 1.4  2001/05/31 20:08:01  gorban20
// FIFO changes20 and other corrections20.
//
// Revision20 1.3  2001/05/27 17:37:49  gorban20
// Fixed20 many20 bugs20. Updated20 spec20. Changed20 FIFO files structure20. See CHANGES20.txt20 file.
//
// Revision20 1.2  2001/05/21 19:12:02  gorban20
// Corrected20 some20 Linter20 messages20.
//
// Revision20 1.1  2001/05/17 18:34:18  gorban20
// First20 'stable' release. Should20 be sythesizable20 now. Also20 added new header.
//
// Revision20 1.0  2001-05-17 21:27:12+02  jacob20
// Initial20 revision20
//
//

// synopsys20 translate_off20
`include "timescale.v"
// synopsys20 translate_on20

`include "uart_defines20.v"

module uart_transmitter20 (clk20, wb_rst_i20, lcr20, tf_push20, wb_dat_i20, enable,	stx_pad_o20, tstate20, tf_count20, tx_reset20, lsr_mask20);

input 										clk20;
input 										wb_rst_i20;
input [7:0] 								lcr20;
input 										tf_push20;
input [7:0] 								wb_dat_i20;
input 										enable;
input 										tx_reset20;
input 										lsr_mask20; //reset of fifo
output 										stx_pad_o20;
output [2:0] 								tstate20;
output [`UART_FIFO_COUNTER_W20-1:0] 	tf_count20;

reg [2:0] 									tstate20;
reg [4:0] 									counter;
reg [2:0] 									bit_counter20;   // counts20 the bits to be sent20
reg [6:0] 									shift_out20;	// output shift20 register
reg 											stx_o_tmp20;
reg 											parity_xor20;  // parity20 of the word20
reg 											tf_pop20;
reg 											bit_out20;

// TX20 FIFO instance
//
// Transmitter20 FIFO signals20
wire [`UART_FIFO_WIDTH20-1:0] 			tf_data_in20;
wire [`UART_FIFO_WIDTH20-1:0] 			tf_data_out20;
wire 											tf_push20;
wire 											tf_overrun20;
wire [`UART_FIFO_COUNTER_W20-1:0] 		tf_count20;

assign 										tf_data_in20 = wb_dat_i20;

uart_tfifo20 fifo_tx20(	// error bit signal20 is not used in transmitter20 FIFO
	.clk20(		clk20		), 
	.wb_rst_i20(	wb_rst_i20	),
	.data_in20(	tf_data_in20	),
	.data_out20(	tf_data_out20	),
	.push20(		tf_push20		),
	.pop20(		tf_pop20		),
	.overrun20(	tf_overrun20	),
	.count(		tf_count20	),
	.fifo_reset20(	tx_reset20	),
	.reset_status20(lsr_mask20)
);

// TRANSMITTER20 FINAL20 STATE20 MACHINE20

parameter s_idle20        = 3'd0;
parameter s_send_start20  = 3'd1;
parameter s_send_byte20   = 3'd2;
parameter s_send_parity20 = 3'd3;
parameter s_send_stop20   = 3'd4;
parameter s_pop_byte20    = 3'd5;

always @(posedge clk20 or posedge wb_rst_i20)
begin
  if (wb_rst_i20)
  begin
	tstate20       <= #1 s_idle20;
	stx_o_tmp20       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out20   <= #1 7'b0;
	bit_out20     <= #1 1'b0;
	parity_xor20  <= #1 1'b0;
	tf_pop20      <= #1 1'b0;
	bit_counter20 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate20)
	s_idle20	 :	if (~|tf_count20) // if tf_count20==0
			begin
				tstate20 <= #1 s_idle20;
				stx_o_tmp20 <= #1 1'b1;
			end
			else
			begin
				tf_pop20 <= #1 1'b0;
				stx_o_tmp20  <= #1 1'b1;
				tstate20  <= #1 s_pop_byte20;
			end
	s_pop_byte20 :	begin
				tf_pop20 <= #1 1'b1;
				case (lcr20[/*`UART_LC_BITS20*/1:0])  // number20 of bits in a word20
				2'b00 : begin
					bit_counter20 <= #1 3'b100;
					parity_xor20  <= #1 ^tf_data_out20[4:0];
				     end
				2'b01 : begin
					bit_counter20 <= #1 3'b101;
					parity_xor20  <= #1 ^tf_data_out20[5:0];
				     end
				2'b10 : begin
					bit_counter20 <= #1 3'b110;
					parity_xor20  <= #1 ^tf_data_out20[6:0];
				     end
				2'b11 : begin
					bit_counter20 <= #1 3'b111;
					parity_xor20  <= #1 ^tf_data_out20[7:0];
				     end
				endcase
				{shift_out20[6:0], bit_out20} <= #1 tf_data_out20;
				tstate20 <= #1 s_send_start20;
			end
	s_send_start20 :	begin
				tf_pop20 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate20 <= #1 s_send_byte20;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp20 <= #1 1'b0;
			end
	s_send_byte20 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter20 > 3'b0)
					begin
						bit_counter20 <= #1 bit_counter20 - 1'b1;
						{shift_out20[5:0],bit_out20  } <= #1 {shift_out20[6:1], shift_out20[0]};
						tstate20 <= #1 s_send_byte20;
					end
					else   // end of byte
					if (~lcr20[`UART_LC_PE20])
					begin
						tstate20 <= #1 s_send_stop20;
					end
					else
					begin
						case ({lcr20[`UART_LC_EP20],lcr20[`UART_LC_SP20]})
						2'b00:	bit_out20 <= #1 ~parity_xor20;
						2'b01:	bit_out20 <= #1 1'b1;
						2'b10:	bit_out20 <= #1 parity_xor20;
						2'b11:	bit_out20 <= #1 1'b0;
						endcase
						tstate20 <= #1 s_send_parity20;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp20 <= #1 bit_out20; // set output pin20
			end
	s_send_parity20 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate20 <= #1 s_send_stop20;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp20 <= #1 bit_out20;
			end
	s_send_stop20 :  begin
				if (~|counter)
				  begin
						casex ({lcr20[`UART_LC_SB20],lcr20[`UART_LC_BITS20]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor20
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate20 <= #1 s_idle20;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp20 <= #1 1'b1;
			end

		default : // should never get here20
			tstate20 <= #1 s_idle20;
	endcase
  end // end if enable
  else
    tf_pop20 <= #1 1'b0;  // tf_pop20 must be 1 cycle width
end // transmitter20 logic

assign stx_pad_o20 = lcr20[`UART_LC_BC20] ? 1'b0 : stx_o_tmp20;    // Break20 condition
	
endmodule
