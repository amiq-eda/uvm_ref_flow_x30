//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter23.v                                          ////
////                                                              ////
////                                                              ////
////  This23 file is part of the "UART23 16550 compatible23" project23    ////
////  http23://www23.opencores23.org23/cores23/uart1655023/                   ////
////                                                              ////
////  Documentation23 related23 to this project23:                      ////
////  - http23://www23.opencores23.org23/cores23/uart1655023/                 ////
////                                                              ////
////  Projects23 compatibility23:                                     ////
////  - WISHBONE23                                                  ////
////  RS23223 Protocol23                                              ////
////  16550D uart23 (mostly23 supported)                              ////
////                                                              ////
////  Overview23 (main23 Features23):                                   ////
////  UART23 core23 transmitter23 logic                                 ////
////                                                              ////
////  Known23 problems23 (limits23):                                    ////
////  None23 known23                                                  ////
////                                                              ////
////  To23 Do23:                                                      ////
////  Thourough23 testing23.                                          ////
////                                                              ////
////  Author23(s):                                                  ////
////      - gorban23@opencores23.org23                                  ////
////      - Jacob23 Gorban23                                          ////
////      - Igor23 Mohor23 (igorm23@opencores23.org23)                      ////
////                                                              ////
////  Created23:        2001/05/12                                  ////
////  Last23 Updated23:   2001/05/17                                  ////
////                  (See log23 for the revision23 history23)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2000, 2001 Authors23                             ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS23 Revision23 History23
//
// $Log: not supported by cvs2svn23 $
// Revision23 1.18  2002/07/22 23:02:23  gorban23
// Bug23 Fixes23:
//  * Possible23 loss of sync and bad23 reception23 of stop bit on slow23 baud23 rates23 fixed23.
//   Problem23 reported23 by Kenny23.Tung23.
//  * Bad (or lack23 of ) loopback23 handling23 fixed23. Reported23 by Cherry23 Withers23.
//
// Improvements23:
//  * Made23 FIFO's as general23 inferrable23 memory where possible23.
//  So23 on FPGA23 they should be inferred23 as RAM23 (Distributed23 RAM23 on Xilinx23).
//  This23 saves23 about23 1/3 of the Slice23 count and reduces23 P&R and synthesis23 times.
//
//  * Added23 optional23 baudrate23 output (baud_o23).
//  This23 is identical23 to BAUDOUT23* signal23 on 16550 chip23.
//  It outputs23 16xbit_clock_rate - the divided23 clock23.
//  It's disabled by default. Define23 UART_HAS_BAUDRATE_OUTPUT23 to use.
//
// Revision23 1.16  2002/01/08 11:29:40  mohor23
// tf_pop23 was too wide23. Now23 it is only 1 clk23 cycle width.
//
// Revision23 1.15  2001/12/17 14:46:48  mohor23
// overrun23 signal23 was moved to separate23 block because many23 sequential23 lsr23
// reads were23 preventing23 data from being written23 to rx23 fifo.
// underrun23 signal23 was not used and was removed from the project23.
//
// Revision23 1.14  2001/12/03 21:44:29  gorban23
// Updated23 specification23 documentation.
// Added23 full 32-bit data bus interface, now as default.
// Address is 5-bit wide23 in 32-bit data bus mode.
// Added23 wb_sel_i23 input to the core23. It's used in the 32-bit mode.
// Added23 debug23 interface with two23 32-bit read-only registers in 32-bit mode.
// Bits23 5 and 6 of LSR23 are now only cleared23 on TX23 FIFO write.
// My23 small test bench23 is modified to work23 with 32-bit mode.
//
// Revision23 1.13  2001/11/08 14:54:23  mohor23
// Comments23 in Slovene23 language23 deleted23, few23 small fixes23 for better23 work23 of
// old23 tools23. IRQs23 need to be fix23.
//
// Revision23 1.12  2001/11/07 17:51:52  gorban23
// Heavily23 rewritten23 interrupt23 and LSR23 subsystems23.
// Many23 bugs23 hopefully23 squashed23.
//
// Revision23 1.11  2001/10/29 17:00:46  gorban23
// fixed23 parity23 sending23 and tx_fifo23 resets23 over- and underrun23
//
// Revision23 1.10  2001/10/20 09:58:40  gorban23
// Small23 synopsis23 fixes23
//
// Revision23 1.9  2001/08/24 21:01:12  mohor23
// Things23 connected23 to parity23 changed.
// Clock23 devider23 changed.
//
// Revision23 1.8  2001/08/23 16:05:05  mohor23
// Stop bit bug23 fixed23.
// Parity23 bug23 fixed23.
// WISHBONE23 read cycle bug23 fixed23,
// OE23 indicator23 (Overrun23 Error) bug23 fixed23.
// PE23 indicator23 (Parity23 Error) bug23 fixed23.
// Register read bug23 fixed23.
//
// Revision23 1.6  2001/06/23 11:21:48  gorban23
// DL23 made23 16-bit long23. Fixed23 transmission23/reception23 bugs23.
//
// Revision23 1.5  2001/06/02 14:28:14  gorban23
// Fixed23 receiver23 and transmitter23. Major23 bug23 fixed23.
//
// Revision23 1.4  2001/05/31 20:08:01  gorban23
// FIFO changes23 and other corrections23.
//
// Revision23 1.3  2001/05/27 17:37:49  gorban23
// Fixed23 many23 bugs23. Updated23 spec23. Changed23 FIFO files structure23. See CHANGES23.txt23 file.
//
// Revision23 1.2  2001/05/21 19:12:02  gorban23
// Corrected23 some23 Linter23 messages23.
//
// Revision23 1.1  2001/05/17 18:34:18  gorban23
// First23 'stable' release. Should23 be sythesizable23 now. Also23 added new header.
//
// Revision23 1.0  2001-05-17 21:27:12+02  jacob23
// Initial23 revision23
//
//

// synopsys23 translate_off23
`include "timescale.v"
// synopsys23 translate_on23

`include "uart_defines23.v"

module uart_transmitter23 (clk23, wb_rst_i23, lcr23, tf_push23, wb_dat_i23, enable,	stx_pad_o23, tstate23, tf_count23, tx_reset23, lsr_mask23);

input 										clk23;
input 										wb_rst_i23;
input [7:0] 								lcr23;
input 										tf_push23;
input [7:0] 								wb_dat_i23;
input 										enable;
input 										tx_reset23;
input 										lsr_mask23; //reset of fifo
output 										stx_pad_o23;
output [2:0] 								tstate23;
output [`UART_FIFO_COUNTER_W23-1:0] 	tf_count23;

reg [2:0] 									tstate23;
reg [4:0] 									counter;
reg [2:0] 									bit_counter23;   // counts23 the bits to be sent23
reg [6:0] 									shift_out23;	// output shift23 register
reg 											stx_o_tmp23;
reg 											parity_xor23;  // parity23 of the word23
reg 											tf_pop23;
reg 											bit_out23;

// TX23 FIFO instance
//
// Transmitter23 FIFO signals23
wire [`UART_FIFO_WIDTH23-1:0] 			tf_data_in23;
wire [`UART_FIFO_WIDTH23-1:0] 			tf_data_out23;
wire 											tf_push23;
wire 											tf_overrun23;
wire [`UART_FIFO_COUNTER_W23-1:0] 		tf_count23;

assign 										tf_data_in23 = wb_dat_i23;

uart_tfifo23 fifo_tx23(	// error bit signal23 is not used in transmitter23 FIFO
	.clk23(		clk23		), 
	.wb_rst_i23(	wb_rst_i23	),
	.data_in23(	tf_data_in23	),
	.data_out23(	tf_data_out23	),
	.push23(		tf_push23		),
	.pop23(		tf_pop23		),
	.overrun23(	tf_overrun23	),
	.count(		tf_count23	),
	.fifo_reset23(	tx_reset23	),
	.reset_status23(lsr_mask23)
);

// TRANSMITTER23 FINAL23 STATE23 MACHINE23

parameter s_idle23        = 3'd0;
parameter s_send_start23  = 3'd1;
parameter s_send_byte23   = 3'd2;
parameter s_send_parity23 = 3'd3;
parameter s_send_stop23   = 3'd4;
parameter s_pop_byte23    = 3'd5;

always @(posedge clk23 or posedge wb_rst_i23)
begin
  if (wb_rst_i23)
  begin
	tstate23       <= #1 s_idle23;
	stx_o_tmp23       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out23   <= #1 7'b0;
	bit_out23     <= #1 1'b0;
	parity_xor23  <= #1 1'b0;
	tf_pop23      <= #1 1'b0;
	bit_counter23 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate23)
	s_idle23	 :	if (~|tf_count23) // if tf_count23==0
			begin
				tstate23 <= #1 s_idle23;
				stx_o_tmp23 <= #1 1'b1;
			end
			else
			begin
				tf_pop23 <= #1 1'b0;
				stx_o_tmp23  <= #1 1'b1;
				tstate23  <= #1 s_pop_byte23;
			end
	s_pop_byte23 :	begin
				tf_pop23 <= #1 1'b1;
				case (lcr23[/*`UART_LC_BITS23*/1:0])  // number23 of bits in a word23
				2'b00 : begin
					bit_counter23 <= #1 3'b100;
					parity_xor23  <= #1 ^tf_data_out23[4:0];
				     end
				2'b01 : begin
					bit_counter23 <= #1 3'b101;
					parity_xor23  <= #1 ^tf_data_out23[5:0];
				     end
				2'b10 : begin
					bit_counter23 <= #1 3'b110;
					parity_xor23  <= #1 ^tf_data_out23[6:0];
				     end
				2'b11 : begin
					bit_counter23 <= #1 3'b111;
					parity_xor23  <= #1 ^tf_data_out23[7:0];
				     end
				endcase
				{shift_out23[6:0], bit_out23} <= #1 tf_data_out23;
				tstate23 <= #1 s_send_start23;
			end
	s_send_start23 :	begin
				tf_pop23 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate23 <= #1 s_send_byte23;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp23 <= #1 1'b0;
			end
	s_send_byte23 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter23 > 3'b0)
					begin
						bit_counter23 <= #1 bit_counter23 - 1'b1;
						{shift_out23[5:0],bit_out23  } <= #1 {shift_out23[6:1], shift_out23[0]};
						tstate23 <= #1 s_send_byte23;
					end
					else   // end of byte
					if (~lcr23[`UART_LC_PE23])
					begin
						tstate23 <= #1 s_send_stop23;
					end
					else
					begin
						case ({lcr23[`UART_LC_EP23],lcr23[`UART_LC_SP23]})
						2'b00:	bit_out23 <= #1 ~parity_xor23;
						2'b01:	bit_out23 <= #1 1'b1;
						2'b10:	bit_out23 <= #1 parity_xor23;
						2'b11:	bit_out23 <= #1 1'b0;
						endcase
						tstate23 <= #1 s_send_parity23;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp23 <= #1 bit_out23; // set output pin23
			end
	s_send_parity23 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate23 <= #1 s_send_stop23;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp23 <= #1 bit_out23;
			end
	s_send_stop23 :  begin
				if (~|counter)
				  begin
						casex ({lcr23[`UART_LC_SB23],lcr23[`UART_LC_BITS23]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor23
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate23 <= #1 s_idle23;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp23 <= #1 1'b1;
			end

		default : // should never get here23
			tstate23 <= #1 s_idle23;
	endcase
  end // end if enable
  else
    tf_pop23 <= #1 1'b0;  // tf_pop23 must be 1 cycle width
end // transmitter23 logic

assign stx_pad_o23 = lcr23[`UART_LC_BC23] ? 1'b0 : stx_o_tmp23;    // Break23 condition
	
endmodule
