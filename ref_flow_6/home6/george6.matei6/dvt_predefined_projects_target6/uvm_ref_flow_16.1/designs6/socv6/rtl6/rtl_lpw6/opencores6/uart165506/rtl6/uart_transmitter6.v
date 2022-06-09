//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter6.v                                          ////
////                                                              ////
////                                                              ////
////  This6 file is part of the "UART6 16550 compatible6" project6    ////
////  http6://www6.opencores6.org6/cores6/uart165506/                   ////
////                                                              ////
////  Documentation6 related6 to this project6:                      ////
////  - http6://www6.opencores6.org6/cores6/uart165506/                 ////
////                                                              ////
////  Projects6 compatibility6:                                     ////
////  - WISHBONE6                                                  ////
////  RS2326 Protocol6                                              ////
////  16550D uart6 (mostly6 supported)                              ////
////                                                              ////
////  Overview6 (main6 Features6):                                   ////
////  UART6 core6 transmitter6 logic                                 ////
////                                                              ////
////  Known6 problems6 (limits6):                                    ////
////  None6 known6                                                  ////
////                                                              ////
////  To6 Do6:                                                      ////
////  Thourough6 testing6.                                          ////
////                                                              ////
////  Author6(s):                                                  ////
////      - gorban6@opencores6.org6                                  ////
////      - Jacob6 Gorban6                                          ////
////      - Igor6 Mohor6 (igorm6@opencores6.org6)                      ////
////                                                              ////
////  Created6:        2001/05/12                                  ////
////  Last6 Updated6:   2001/05/17                                  ////
////                  (See log6 for the revision6 history6)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2000, 2001 Authors6                             ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS6 Revision6 History6
//
// $Log: not supported by cvs2svn6 $
// Revision6 1.18  2002/07/22 23:02:23  gorban6
// Bug6 Fixes6:
//  * Possible6 loss of sync and bad6 reception6 of stop bit on slow6 baud6 rates6 fixed6.
//   Problem6 reported6 by Kenny6.Tung6.
//  * Bad (or lack6 of ) loopback6 handling6 fixed6. Reported6 by Cherry6 Withers6.
//
// Improvements6:
//  * Made6 FIFO's as general6 inferrable6 memory where possible6.
//  So6 on FPGA6 they should be inferred6 as RAM6 (Distributed6 RAM6 on Xilinx6).
//  This6 saves6 about6 1/3 of the Slice6 count and reduces6 P&R and synthesis6 times.
//
//  * Added6 optional6 baudrate6 output (baud_o6).
//  This6 is identical6 to BAUDOUT6* signal6 on 16550 chip6.
//  It outputs6 16xbit_clock_rate - the divided6 clock6.
//  It's disabled by default. Define6 UART_HAS_BAUDRATE_OUTPUT6 to use.
//
// Revision6 1.16  2002/01/08 11:29:40  mohor6
// tf_pop6 was too wide6. Now6 it is only 1 clk6 cycle width.
//
// Revision6 1.15  2001/12/17 14:46:48  mohor6
// overrun6 signal6 was moved to separate6 block because many6 sequential6 lsr6
// reads were6 preventing6 data from being written6 to rx6 fifo.
// underrun6 signal6 was not used and was removed from the project6.
//
// Revision6 1.14  2001/12/03 21:44:29  gorban6
// Updated6 specification6 documentation.
// Added6 full 32-bit data bus interface, now as default.
// Address is 5-bit wide6 in 32-bit data bus mode.
// Added6 wb_sel_i6 input to the core6. It's used in the 32-bit mode.
// Added6 debug6 interface with two6 32-bit read-only registers in 32-bit mode.
// Bits6 5 and 6 of LSR6 are now only cleared6 on TX6 FIFO write.
// My6 small test bench6 is modified to work6 with 32-bit mode.
//
// Revision6 1.13  2001/11/08 14:54:23  mohor6
// Comments6 in Slovene6 language6 deleted6, few6 small fixes6 for better6 work6 of
// old6 tools6. IRQs6 need to be fix6.
//
// Revision6 1.12  2001/11/07 17:51:52  gorban6
// Heavily6 rewritten6 interrupt6 and LSR6 subsystems6.
// Many6 bugs6 hopefully6 squashed6.
//
// Revision6 1.11  2001/10/29 17:00:46  gorban6
// fixed6 parity6 sending6 and tx_fifo6 resets6 over- and underrun6
//
// Revision6 1.10  2001/10/20 09:58:40  gorban6
// Small6 synopsis6 fixes6
//
// Revision6 1.9  2001/08/24 21:01:12  mohor6
// Things6 connected6 to parity6 changed.
// Clock6 devider6 changed.
//
// Revision6 1.8  2001/08/23 16:05:05  mohor6
// Stop bit bug6 fixed6.
// Parity6 bug6 fixed6.
// WISHBONE6 read cycle bug6 fixed6,
// OE6 indicator6 (Overrun6 Error) bug6 fixed6.
// PE6 indicator6 (Parity6 Error) bug6 fixed6.
// Register read bug6 fixed6.
//
// Revision6 1.6  2001/06/23 11:21:48  gorban6
// DL6 made6 16-bit long6. Fixed6 transmission6/reception6 bugs6.
//
// Revision6 1.5  2001/06/02 14:28:14  gorban6
// Fixed6 receiver6 and transmitter6. Major6 bug6 fixed6.
//
// Revision6 1.4  2001/05/31 20:08:01  gorban6
// FIFO changes6 and other corrections6.
//
// Revision6 1.3  2001/05/27 17:37:49  gorban6
// Fixed6 many6 bugs6. Updated6 spec6. Changed6 FIFO files structure6. See CHANGES6.txt6 file.
//
// Revision6 1.2  2001/05/21 19:12:02  gorban6
// Corrected6 some6 Linter6 messages6.
//
// Revision6 1.1  2001/05/17 18:34:18  gorban6
// First6 'stable' release. Should6 be sythesizable6 now. Also6 added new header.
//
// Revision6 1.0  2001-05-17 21:27:12+02  jacob6
// Initial6 revision6
//
//

// synopsys6 translate_off6
`include "timescale.v"
// synopsys6 translate_on6

`include "uart_defines6.v"

module uart_transmitter6 (clk6, wb_rst_i6, lcr6, tf_push6, wb_dat_i6, enable,	stx_pad_o6, tstate6, tf_count6, tx_reset6, lsr_mask6);

input 										clk6;
input 										wb_rst_i6;
input [7:0] 								lcr6;
input 										tf_push6;
input [7:0] 								wb_dat_i6;
input 										enable;
input 										tx_reset6;
input 										lsr_mask6; //reset of fifo
output 										stx_pad_o6;
output [2:0] 								tstate6;
output [`UART_FIFO_COUNTER_W6-1:0] 	tf_count6;

reg [2:0] 									tstate6;
reg [4:0] 									counter;
reg [2:0] 									bit_counter6;   // counts6 the bits to be sent6
reg [6:0] 									shift_out6;	// output shift6 register
reg 											stx_o_tmp6;
reg 											parity_xor6;  // parity6 of the word6
reg 											tf_pop6;
reg 											bit_out6;

// TX6 FIFO instance
//
// Transmitter6 FIFO signals6
wire [`UART_FIFO_WIDTH6-1:0] 			tf_data_in6;
wire [`UART_FIFO_WIDTH6-1:0] 			tf_data_out6;
wire 											tf_push6;
wire 											tf_overrun6;
wire [`UART_FIFO_COUNTER_W6-1:0] 		tf_count6;

assign 										tf_data_in6 = wb_dat_i6;

uart_tfifo6 fifo_tx6(	// error bit signal6 is not used in transmitter6 FIFO
	.clk6(		clk6		), 
	.wb_rst_i6(	wb_rst_i6	),
	.data_in6(	tf_data_in6	),
	.data_out6(	tf_data_out6	),
	.push6(		tf_push6		),
	.pop6(		tf_pop6		),
	.overrun6(	tf_overrun6	),
	.count(		tf_count6	),
	.fifo_reset6(	tx_reset6	),
	.reset_status6(lsr_mask6)
);

// TRANSMITTER6 FINAL6 STATE6 MACHINE6

parameter s_idle6        = 3'd0;
parameter s_send_start6  = 3'd1;
parameter s_send_byte6   = 3'd2;
parameter s_send_parity6 = 3'd3;
parameter s_send_stop6   = 3'd4;
parameter s_pop_byte6    = 3'd5;

always @(posedge clk6 or posedge wb_rst_i6)
begin
  if (wb_rst_i6)
  begin
	tstate6       <= #1 s_idle6;
	stx_o_tmp6       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out6   <= #1 7'b0;
	bit_out6     <= #1 1'b0;
	parity_xor6  <= #1 1'b0;
	tf_pop6      <= #1 1'b0;
	bit_counter6 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate6)
	s_idle6	 :	if (~|tf_count6) // if tf_count6==0
			begin
				tstate6 <= #1 s_idle6;
				stx_o_tmp6 <= #1 1'b1;
			end
			else
			begin
				tf_pop6 <= #1 1'b0;
				stx_o_tmp6  <= #1 1'b1;
				tstate6  <= #1 s_pop_byte6;
			end
	s_pop_byte6 :	begin
				tf_pop6 <= #1 1'b1;
				case (lcr6[/*`UART_LC_BITS6*/1:0])  // number6 of bits in a word6
				2'b00 : begin
					bit_counter6 <= #1 3'b100;
					parity_xor6  <= #1 ^tf_data_out6[4:0];
				     end
				2'b01 : begin
					bit_counter6 <= #1 3'b101;
					parity_xor6  <= #1 ^tf_data_out6[5:0];
				     end
				2'b10 : begin
					bit_counter6 <= #1 3'b110;
					parity_xor6  <= #1 ^tf_data_out6[6:0];
				     end
				2'b11 : begin
					bit_counter6 <= #1 3'b111;
					parity_xor6  <= #1 ^tf_data_out6[7:0];
				     end
				endcase
				{shift_out6[6:0], bit_out6} <= #1 tf_data_out6;
				tstate6 <= #1 s_send_start6;
			end
	s_send_start6 :	begin
				tf_pop6 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate6 <= #1 s_send_byte6;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp6 <= #1 1'b0;
			end
	s_send_byte6 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter6 > 3'b0)
					begin
						bit_counter6 <= #1 bit_counter6 - 1'b1;
						{shift_out6[5:0],bit_out6  } <= #1 {shift_out6[6:1], shift_out6[0]};
						tstate6 <= #1 s_send_byte6;
					end
					else   // end of byte
					if (~lcr6[`UART_LC_PE6])
					begin
						tstate6 <= #1 s_send_stop6;
					end
					else
					begin
						case ({lcr6[`UART_LC_EP6],lcr6[`UART_LC_SP6]})
						2'b00:	bit_out6 <= #1 ~parity_xor6;
						2'b01:	bit_out6 <= #1 1'b1;
						2'b10:	bit_out6 <= #1 parity_xor6;
						2'b11:	bit_out6 <= #1 1'b0;
						endcase
						tstate6 <= #1 s_send_parity6;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp6 <= #1 bit_out6; // set output pin6
			end
	s_send_parity6 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate6 <= #1 s_send_stop6;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp6 <= #1 bit_out6;
			end
	s_send_stop6 :  begin
				if (~|counter)
				  begin
						casex ({lcr6[`UART_LC_SB6],lcr6[`UART_LC_BITS6]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor6
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate6 <= #1 s_idle6;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp6 <= #1 1'b1;
			end

		default : // should never get here6
			tstate6 <= #1 s_idle6;
	endcase
  end // end if enable
  else
    tf_pop6 <= #1 1'b0;  // tf_pop6 must be 1 cycle width
end // transmitter6 logic

assign stx_pad_o6 = lcr6[`UART_LC_BC6] ? 1'b0 : stx_o_tmp6;    // Break6 condition
	
endmodule
