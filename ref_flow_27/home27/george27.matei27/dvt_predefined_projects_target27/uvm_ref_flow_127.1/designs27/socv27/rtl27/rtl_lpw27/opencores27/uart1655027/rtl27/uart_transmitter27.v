//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter27.v                                          ////
////                                                              ////
////                                                              ////
////  This27 file is part of the "UART27 16550 compatible27" project27    ////
////  http27://www27.opencores27.org27/cores27/uart1655027/                   ////
////                                                              ////
////  Documentation27 related27 to this project27:                      ////
////  - http27://www27.opencores27.org27/cores27/uart1655027/                 ////
////                                                              ////
////  Projects27 compatibility27:                                     ////
////  - WISHBONE27                                                  ////
////  RS23227 Protocol27                                              ////
////  16550D uart27 (mostly27 supported)                              ////
////                                                              ////
////  Overview27 (main27 Features27):                                   ////
////  UART27 core27 transmitter27 logic                                 ////
////                                                              ////
////  Known27 problems27 (limits27):                                    ////
////  None27 known27                                                  ////
////                                                              ////
////  To27 Do27:                                                      ////
////  Thourough27 testing27.                                          ////
////                                                              ////
////  Author27(s):                                                  ////
////      - gorban27@opencores27.org27                                  ////
////      - Jacob27 Gorban27                                          ////
////      - Igor27 Mohor27 (igorm27@opencores27.org27)                      ////
////                                                              ////
////  Created27:        2001/05/12                                  ////
////  Last27 Updated27:   2001/05/17                                  ////
////                  (See log27 for the revision27 history27)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2000, 2001 Authors27                             ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS27 Revision27 History27
//
// $Log: not supported by cvs2svn27 $
// Revision27 1.18  2002/07/22 23:02:23  gorban27
// Bug27 Fixes27:
//  * Possible27 loss of sync and bad27 reception27 of stop bit on slow27 baud27 rates27 fixed27.
//   Problem27 reported27 by Kenny27.Tung27.
//  * Bad (or lack27 of ) loopback27 handling27 fixed27. Reported27 by Cherry27 Withers27.
//
// Improvements27:
//  * Made27 FIFO's as general27 inferrable27 memory where possible27.
//  So27 on FPGA27 they should be inferred27 as RAM27 (Distributed27 RAM27 on Xilinx27).
//  This27 saves27 about27 1/3 of the Slice27 count and reduces27 P&R and synthesis27 times.
//
//  * Added27 optional27 baudrate27 output (baud_o27).
//  This27 is identical27 to BAUDOUT27* signal27 on 16550 chip27.
//  It outputs27 16xbit_clock_rate - the divided27 clock27.
//  It's disabled by default. Define27 UART_HAS_BAUDRATE_OUTPUT27 to use.
//
// Revision27 1.16  2002/01/08 11:29:40  mohor27
// tf_pop27 was too wide27. Now27 it is only 1 clk27 cycle width.
//
// Revision27 1.15  2001/12/17 14:46:48  mohor27
// overrun27 signal27 was moved to separate27 block because many27 sequential27 lsr27
// reads were27 preventing27 data from being written27 to rx27 fifo.
// underrun27 signal27 was not used and was removed from the project27.
//
// Revision27 1.14  2001/12/03 21:44:29  gorban27
// Updated27 specification27 documentation.
// Added27 full 32-bit data bus interface, now as default.
// Address is 5-bit wide27 in 32-bit data bus mode.
// Added27 wb_sel_i27 input to the core27. It's used in the 32-bit mode.
// Added27 debug27 interface with two27 32-bit read-only registers in 32-bit mode.
// Bits27 5 and 6 of LSR27 are now only cleared27 on TX27 FIFO write.
// My27 small test bench27 is modified to work27 with 32-bit mode.
//
// Revision27 1.13  2001/11/08 14:54:23  mohor27
// Comments27 in Slovene27 language27 deleted27, few27 small fixes27 for better27 work27 of
// old27 tools27. IRQs27 need to be fix27.
//
// Revision27 1.12  2001/11/07 17:51:52  gorban27
// Heavily27 rewritten27 interrupt27 and LSR27 subsystems27.
// Many27 bugs27 hopefully27 squashed27.
//
// Revision27 1.11  2001/10/29 17:00:46  gorban27
// fixed27 parity27 sending27 and tx_fifo27 resets27 over- and underrun27
//
// Revision27 1.10  2001/10/20 09:58:40  gorban27
// Small27 synopsis27 fixes27
//
// Revision27 1.9  2001/08/24 21:01:12  mohor27
// Things27 connected27 to parity27 changed.
// Clock27 devider27 changed.
//
// Revision27 1.8  2001/08/23 16:05:05  mohor27
// Stop bit bug27 fixed27.
// Parity27 bug27 fixed27.
// WISHBONE27 read cycle bug27 fixed27,
// OE27 indicator27 (Overrun27 Error) bug27 fixed27.
// PE27 indicator27 (Parity27 Error) bug27 fixed27.
// Register read bug27 fixed27.
//
// Revision27 1.6  2001/06/23 11:21:48  gorban27
// DL27 made27 16-bit long27. Fixed27 transmission27/reception27 bugs27.
//
// Revision27 1.5  2001/06/02 14:28:14  gorban27
// Fixed27 receiver27 and transmitter27. Major27 bug27 fixed27.
//
// Revision27 1.4  2001/05/31 20:08:01  gorban27
// FIFO changes27 and other corrections27.
//
// Revision27 1.3  2001/05/27 17:37:49  gorban27
// Fixed27 many27 bugs27. Updated27 spec27. Changed27 FIFO files structure27. See CHANGES27.txt27 file.
//
// Revision27 1.2  2001/05/21 19:12:02  gorban27
// Corrected27 some27 Linter27 messages27.
//
// Revision27 1.1  2001/05/17 18:34:18  gorban27
// First27 'stable' release. Should27 be sythesizable27 now. Also27 added new header.
//
// Revision27 1.0  2001-05-17 21:27:12+02  jacob27
// Initial27 revision27
//
//

// synopsys27 translate_off27
`include "timescale.v"
// synopsys27 translate_on27

`include "uart_defines27.v"

module uart_transmitter27 (clk27, wb_rst_i27, lcr27, tf_push27, wb_dat_i27, enable,	stx_pad_o27, tstate27, tf_count27, tx_reset27, lsr_mask27);

input 										clk27;
input 										wb_rst_i27;
input [7:0] 								lcr27;
input 										tf_push27;
input [7:0] 								wb_dat_i27;
input 										enable;
input 										tx_reset27;
input 										lsr_mask27; //reset of fifo
output 										stx_pad_o27;
output [2:0] 								tstate27;
output [`UART_FIFO_COUNTER_W27-1:0] 	tf_count27;

reg [2:0] 									tstate27;
reg [4:0] 									counter;
reg [2:0] 									bit_counter27;   // counts27 the bits to be sent27
reg [6:0] 									shift_out27;	// output shift27 register
reg 											stx_o_tmp27;
reg 											parity_xor27;  // parity27 of the word27
reg 											tf_pop27;
reg 											bit_out27;

// TX27 FIFO instance
//
// Transmitter27 FIFO signals27
wire [`UART_FIFO_WIDTH27-1:0] 			tf_data_in27;
wire [`UART_FIFO_WIDTH27-1:0] 			tf_data_out27;
wire 											tf_push27;
wire 											tf_overrun27;
wire [`UART_FIFO_COUNTER_W27-1:0] 		tf_count27;

assign 										tf_data_in27 = wb_dat_i27;

uart_tfifo27 fifo_tx27(	// error bit signal27 is not used in transmitter27 FIFO
	.clk27(		clk27		), 
	.wb_rst_i27(	wb_rst_i27	),
	.data_in27(	tf_data_in27	),
	.data_out27(	tf_data_out27	),
	.push27(		tf_push27		),
	.pop27(		tf_pop27		),
	.overrun27(	tf_overrun27	),
	.count(		tf_count27	),
	.fifo_reset27(	tx_reset27	),
	.reset_status27(lsr_mask27)
);

// TRANSMITTER27 FINAL27 STATE27 MACHINE27

parameter s_idle27        = 3'd0;
parameter s_send_start27  = 3'd1;
parameter s_send_byte27   = 3'd2;
parameter s_send_parity27 = 3'd3;
parameter s_send_stop27   = 3'd4;
parameter s_pop_byte27    = 3'd5;

always @(posedge clk27 or posedge wb_rst_i27)
begin
  if (wb_rst_i27)
  begin
	tstate27       <= #1 s_idle27;
	stx_o_tmp27       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out27   <= #1 7'b0;
	bit_out27     <= #1 1'b0;
	parity_xor27  <= #1 1'b0;
	tf_pop27      <= #1 1'b0;
	bit_counter27 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate27)
	s_idle27	 :	if (~|tf_count27) // if tf_count27==0
			begin
				tstate27 <= #1 s_idle27;
				stx_o_tmp27 <= #1 1'b1;
			end
			else
			begin
				tf_pop27 <= #1 1'b0;
				stx_o_tmp27  <= #1 1'b1;
				tstate27  <= #1 s_pop_byte27;
			end
	s_pop_byte27 :	begin
				tf_pop27 <= #1 1'b1;
				case (lcr27[/*`UART_LC_BITS27*/1:0])  // number27 of bits in a word27
				2'b00 : begin
					bit_counter27 <= #1 3'b100;
					parity_xor27  <= #1 ^tf_data_out27[4:0];
				     end
				2'b01 : begin
					bit_counter27 <= #1 3'b101;
					parity_xor27  <= #1 ^tf_data_out27[5:0];
				     end
				2'b10 : begin
					bit_counter27 <= #1 3'b110;
					parity_xor27  <= #1 ^tf_data_out27[6:0];
				     end
				2'b11 : begin
					bit_counter27 <= #1 3'b111;
					parity_xor27  <= #1 ^tf_data_out27[7:0];
				     end
				endcase
				{shift_out27[6:0], bit_out27} <= #1 tf_data_out27;
				tstate27 <= #1 s_send_start27;
			end
	s_send_start27 :	begin
				tf_pop27 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate27 <= #1 s_send_byte27;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp27 <= #1 1'b0;
			end
	s_send_byte27 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter27 > 3'b0)
					begin
						bit_counter27 <= #1 bit_counter27 - 1'b1;
						{shift_out27[5:0],bit_out27  } <= #1 {shift_out27[6:1], shift_out27[0]};
						tstate27 <= #1 s_send_byte27;
					end
					else   // end of byte
					if (~lcr27[`UART_LC_PE27])
					begin
						tstate27 <= #1 s_send_stop27;
					end
					else
					begin
						case ({lcr27[`UART_LC_EP27],lcr27[`UART_LC_SP27]})
						2'b00:	bit_out27 <= #1 ~parity_xor27;
						2'b01:	bit_out27 <= #1 1'b1;
						2'b10:	bit_out27 <= #1 parity_xor27;
						2'b11:	bit_out27 <= #1 1'b0;
						endcase
						tstate27 <= #1 s_send_parity27;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp27 <= #1 bit_out27; // set output pin27
			end
	s_send_parity27 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate27 <= #1 s_send_stop27;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp27 <= #1 bit_out27;
			end
	s_send_stop27 :  begin
				if (~|counter)
				  begin
						casex ({lcr27[`UART_LC_SB27],lcr27[`UART_LC_BITS27]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor27
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate27 <= #1 s_idle27;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp27 <= #1 1'b1;
			end

		default : // should never get here27
			tstate27 <= #1 s_idle27;
	endcase
  end // end if enable
  else
    tf_pop27 <= #1 1'b0;  // tf_pop27 must be 1 cycle width
end // transmitter27 logic

assign stx_pad_o27 = lcr27[`UART_LC_BC27] ? 1'b0 : stx_o_tmp27;    // Break27 condition
	
endmodule
