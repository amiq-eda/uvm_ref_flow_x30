//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter17.v                                          ////
////                                                              ////
////                                                              ////
////  This17 file is part of the "UART17 16550 compatible17" project17    ////
////  http17://www17.opencores17.org17/cores17/uart1655017/                   ////
////                                                              ////
////  Documentation17 related17 to this project17:                      ////
////  - http17://www17.opencores17.org17/cores17/uart1655017/                 ////
////                                                              ////
////  Projects17 compatibility17:                                     ////
////  - WISHBONE17                                                  ////
////  RS23217 Protocol17                                              ////
////  16550D uart17 (mostly17 supported)                              ////
////                                                              ////
////  Overview17 (main17 Features17):                                   ////
////  UART17 core17 transmitter17 logic                                 ////
////                                                              ////
////  Known17 problems17 (limits17):                                    ////
////  None17 known17                                                  ////
////                                                              ////
////  To17 Do17:                                                      ////
////  Thourough17 testing17.                                          ////
////                                                              ////
////  Author17(s):                                                  ////
////      - gorban17@opencores17.org17                                  ////
////      - Jacob17 Gorban17                                          ////
////      - Igor17 Mohor17 (igorm17@opencores17.org17)                      ////
////                                                              ////
////  Created17:        2001/05/12                                  ////
////  Last17 Updated17:   2001/05/17                                  ////
////                  (See log17 for the revision17 history17)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2000, 2001 Authors17                             ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS17 Revision17 History17
//
// $Log: not supported by cvs2svn17 $
// Revision17 1.18  2002/07/22 23:02:23  gorban17
// Bug17 Fixes17:
//  * Possible17 loss of sync and bad17 reception17 of stop bit on slow17 baud17 rates17 fixed17.
//   Problem17 reported17 by Kenny17.Tung17.
//  * Bad (or lack17 of ) loopback17 handling17 fixed17. Reported17 by Cherry17 Withers17.
//
// Improvements17:
//  * Made17 FIFO's as general17 inferrable17 memory where possible17.
//  So17 on FPGA17 they should be inferred17 as RAM17 (Distributed17 RAM17 on Xilinx17).
//  This17 saves17 about17 1/3 of the Slice17 count and reduces17 P&R and synthesis17 times.
//
//  * Added17 optional17 baudrate17 output (baud_o17).
//  This17 is identical17 to BAUDOUT17* signal17 on 16550 chip17.
//  It outputs17 16xbit_clock_rate - the divided17 clock17.
//  It's disabled by default. Define17 UART_HAS_BAUDRATE_OUTPUT17 to use.
//
// Revision17 1.16  2002/01/08 11:29:40  mohor17
// tf_pop17 was too wide17. Now17 it is only 1 clk17 cycle width.
//
// Revision17 1.15  2001/12/17 14:46:48  mohor17
// overrun17 signal17 was moved to separate17 block because many17 sequential17 lsr17
// reads were17 preventing17 data from being written17 to rx17 fifo.
// underrun17 signal17 was not used and was removed from the project17.
//
// Revision17 1.14  2001/12/03 21:44:29  gorban17
// Updated17 specification17 documentation.
// Added17 full 32-bit data bus interface, now as default.
// Address is 5-bit wide17 in 32-bit data bus mode.
// Added17 wb_sel_i17 input to the core17. It's used in the 32-bit mode.
// Added17 debug17 interface with two17 32-bit read-only registers in 32-bit mode.
// Bits17 5 and 6 of LSR17 are now only cleared17 on TX17 FIFO write.
// My17 small test bench17 is modified to work17 with 32-bit mode.
//
// Revision17 1.13  2001/11/08 14:54:23  mohor17
// Comments17 in Slovene17 language17 deleted17, few17 small fixes17 for better17 work17 of
// old17 tools17. IRQs17 need to be fix17.
//
// Revision17 1.12  2001/11/07 17:51:52  gorban17
// Heavily17 rewritten17 interrupt17 and LSR17 subsystems17.
// Many17 bugs17 hopefully17 squashed17.
//
// Revision17 1.11  2001/10/29 17:00:46  gorban17
// fixed17 parity17 sending17 and tx_fifo17 resets17 over- and underrun17
//
// Revision17 1.10  2001/10/20 09:58:40  gorban17
// Small17 synopsis17 fixes17
//
// Revision17 1.9  2001/08/24 21:01:12  mohor17
// Things17 connected17 to parity17 changed.
// Clock17 devider17 changed.
//
// Revision17 1.8  2001/08/23 16:05:05  mohor17
// Stop bit bug17 fixed17.
// Parity17 bug17 fixed17.
// WISHBONE17 read cycle bug17 fixed17,
// OE17 indicator17 (Overrun17 Error) bug17 fixed17.
// PE17 indicator17 (Parity17 Error) bug17 fixed17.
// Register read bug17 fixed17.
//
// Revision17 1.6  2001/06/23 11:21:48  gorban17
// DL17 made17 16-bit long17. Fixed17 transmission17/reception17 bugs17.
//
// Revision17 1.5  2001/06/02 14:28:14  gorban17
// Fixed17 receiver17 and transmitter17. Major17 bug17 fixed17.
//
// Revision17 1.4  2001/05/31 20:08:01  gorban17
// FIFO changes17 and other corrections17.
//
// Revision17 1.3  2001/05/27 17:37:49  gorban17
// Fixed17 many17 bugs17. Updated17 spec17. Changed17 FIFO files structure17. See CHANGES17.txt17 file.
//
// Revision17 1.2  2001/05/21 19:12:02  gorban17
// Corrected17 some17 Linter17 messages17.
//
// Revision17 1.1  2001/05/17 18:34:18  gorban17
// First17 'stable' release. Should17 be sythesizable17 now. Also17 added new header.
//
// Revision17 1.0  2001-05-17 21:27:12+02  jacob17
// Initial17 revision17
//
//

// synopsys17 translate_off17
`include "timescale.v"
// synopsys17 translate_on17

`include "uart_defines17.v"

module uart_transmitter17 (clk17, wb_rst_i17, lcr17, tf_push17, wb_dat_i17, enable,	stx_pad_o17, tstate17, tf_count17, tx_reset17, lsr_mask17);

input 										clk17;
input 										wb_rst_i17;
input [7:0] 								lcr17;
input 										tf_push17;
input [7:0] 								wb_dat_i17;
input 										enable;
input 										tx_reset17;
input 										lsr_mask17; //reset of fifo
output 										stx_pad_o17;
output [2:0] 								tstate17;
output [`UART_FIFO_COUNTER_W17-1:0] 	tf_count17;

reg [2:0] 									tstate17;
reg [4:0] 									counter;
reg [2:0] 									bit_counter17;   // counts17 the bits to be sent17
reg [6:0] 									shift_out17;	// output shift17 register
reg 											stx_o_tmp17;
reg 											parity_xor17;  // parity17 of the word17
reg 											tf_pop17;
reg 											bit_out17;

// TX17 FIFO instance
//
// Transmitter17 FIFO signals17
wire [`UART_FIFO_WIDTH17-1:0] 			tf_data_in17;
wire [`UART_FIFO_WIDTH17-1:0] 			tf_data_out17;
wire 											tf_push17;
wire 											tf_overrun17;
wire [`UART_FIFO_COUNTER_W17-1:0] 		tf_count17;

assign 										tf_data_in17 = wb_dat_i17;

uart_tfifo17 fifo_tx17(	// error bit signal17 is not used in transmitter17 FIFO
	.clk17(		clk17		), 
	.wb_rst_i17(	wb_rst_i17	),
	.data_in17(	tf_data_in17	),
	.data_out17(	tf_data_out17	),
	.push17(		tf_push17		),
	.pop17(		tf_pop17		),
	.overrun17(	tf_overrun17	),
	.count(		tf_count17	),
	.fifo_reset17(	tx_reset17	),
	.reset_status17(lsr_mask17)
);

// TRANSMITTER17 FINAL17 STATE17 MACHINE17

parameter s_idle17        = 3'd0;
parameter s_send_start17  = 3'd1;
parameter s_send_byte17   = 3'd2;
parameter s_send_parity17 = 3'd3;
parameter s_send_stop17   = 3'd4;
parameter s_pop_byte17    = 3'd5;

always @(posedge clk17 or posedge wb_rst_i17)
begin
  if (wb_rst_i17)
  begin
	tstate17       <= #1 s_idle17;
	stx_o_tmp17       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out17   <= #1 7'b0;
	bit_out17     <= #1 1'b0;
	parity_xor17  <= #1 1'b0;
	tf_pop17      <= #1 1'b0;
	bit_counter17 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate17)
	s_idle17	 :	if (~|tf_count17) // if tf_count17==0
			begin
				tstate17 <= #1 s_idle17;
				stx_o_tmp17 <= #1 1'b1;
			end
			else
			begin
				tf_pop17 <= #1 1'b0;
				stx_o_tmp17  <= #1 1'b1;
				tstate17  <= #1 s_pop_byte17;
			end
	s_pop_byte17 :	begin
				tf_pop17 <= #1 1'b1;
				case (lcr17[/*`UART_LC_BITS17*/1:0])  // number17 of bits in a word17
				2'b00 : begin
					bit_counter17 <= #1 3'b100;
					parity_xor17  <= #1 ^tf_data_out17[4:0];
				     end
				2'b01 : begin
					bit_counter17 <= #1 3'b101;
					parity_xor17  <= #1 ^tf_data_out17[5:0];
				     end
				2'b10 : begin
					bit_counter17 <= #1 3'b110;
					parity_xor17  <= #1 ^tf_data_out17[6:0];
				     end
				2'b11 : begin
					bit_counter17 <= #1 3'b111;
					parity_xor17  <= #1 ^tf_data_out17[7:0];
				     end
				endcase
				{shift_out17[6:0], bit_out17} <= #1 tf_data_out17;
				tstate17 <= #1 s_send_start17;
			end
	s_send_start17 :	begin
				tf_pop17 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate17 <= #1 s_send_byte17;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp17 <= #1 1'b0;
			end
	s_send_byte17 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter17 > 3'b0)
					begin
						bit_counter17 <= #1 bit_counter17 - 1'b1;
						{shift_out17[5:0],bit_out17  } <= #1 {shift_out17[6:1], shift_out17[0]};
						tstate17 <= #1 s_send_byte17;
					end
					else   // end of byte
					if (~lcr17[`UART_LC_PE17])
					begin
						tstate17 <= #1 s_send_stop17;
					end
					else
					begin
						case ({lcr17[`UART_LC_EP17],lcr17[`UART_LC_SP17]})
						2'b00:	bit_out17 <= #1 ~parity_xor17;
						2'b01:	bit_out17 <= #1 1'b1;
						2'b10:	bit_out17 <= #1 parity_xor17;
						2'b11:	bit_out17 <= #1 1'b0;
						endcase
						tstate17 <= #1 s_send_parity17;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp17 <= #1 bit_out17; // set output pin17
			end
	s_send_parity17 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate17 <= #1 s_send_stop17;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp17 <= #1 bit_out17;
			end
	s_send_stop17 :  begin
				if (~|counter)
				  begin
						casex ({lcr17[`UART_LC_SB17],lcr17[`UART_LC_BITS17]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor17
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate17 <= #1 s_idle17;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp17 <= #1 1'b1;
			end

		default : // should never get here17
			tstate17 <= #1 s_idle17;
	endcase
  end // end if enable
  else
    tf_pop17 <= #1 1'b0;  // tf_pop17 must be 1 cycle width
end // transmitter17 logic

assign stx_pad_o17 = lcr17[`UART_LC_BC17] ? 1'b0 : stx_o_tmp17;    // Break17 condition
	
endmodule
