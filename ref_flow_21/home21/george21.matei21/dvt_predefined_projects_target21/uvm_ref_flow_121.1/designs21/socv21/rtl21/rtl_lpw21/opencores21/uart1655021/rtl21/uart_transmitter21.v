//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter21.v                                          ////
////                                                              ////
////                                                              ////
////  This21 file is part of the "UART21 16550 compatible21" project21    ////
////  http21://www21.opencores21.org21/cores21/uart1655021/                   ////
////                                                              ////
////  Documentation21 related21 to this project21:                      ////
////  - http21://www21.opencores21.org21/cores21/uart1655021/                 ////
////                                                              ////
////  Projects21 compatibility21:                                     ////
////  - WISHBONE21                                                  ////
////  RS23221 Protocol21                                              ////
////  16550D uart21 (mostly21 supported)                              ////
////                                                              ////
////  Overview21 (main21 Features21):                                   ////
////  UART21 core21 transmitter21 logic                                 ////
////                                                              ////
////  Known21 problems21 (limits21):                                    ////
////  None21 known21                                                  ////
////                                                              ////
////  To21 Do21:                                                      ////
////  Thourough21 testing21.                                          ////
////                                                              ////
////  Author21(s):                                                  ////
////      - gorban21@opencores21.org21                                  ////
////      - Jacob21 Gorban21                                          ////
////      - Igor21 Mohor21 (igorm21@opencores21.org21)                      ////
////                                                              ////
////  Created21:        2001/05/12                                  ////
////  Last21 Updated21:   2001/05/17                                  ////
////                  (See log21 for the revision21 history21)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2000, 2001 Authors21                             ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS21 Revision21 History21
//
// $Log: not supported by cvs2svn21 $
// Revision21 1.18  2002/07/22 23:02:23  gorban21
// Bug21 Fixes21:
//  * Possible21 loss of sync and bad21 reception21 of stop bit on slow21 baud21 rates21 fixed21.
//   Problem21 reported21 by Kenny21.Tung21.
//  * Bad (or lack21 of ) loopback21 handling21 fixed21. Reported21 by Cherry21 Withers21.
//
// Improvements21:
//  * Made21 FIFO's as general21 inferrable21 memory where possible21.
//  So21 on FPGA21 they should be inferred21 as RAM21 (Distributed21 RAM21 on Xilinx21).
//  This21 saves21 about21 1/3 of the Slice21 count and reduces21 P&R and synthesis21 times.
//
//  * Added21 optional21 baudrate21 output (baud_o21).
//  This21 is identical21 to BAUDOUT21* signal21 on 16550 chip21.
//  It outputs21 16xbit_clock_rate - the divided21 clock21.
//  It's disabled by default. Define21 UART_HAS_BAUDRATE_OUTPUT21 to use.
//
// Revision21 1.16  2002/01/08 11:29:40  mohor21
// tf_pop21 was too wide21. Now21 it is only 1 clk21 cycle width.
//
// Revision21 1.15  2001/12/17 14:46:48  mohor21
// overrun21 signal21 was moved to separate21 block because many21 sequential21 lsr21
// reads were21 preventing21 data from being written21 to rx21 fifo.
// underrun21 signal21 was not used and was removed from the project21.
//
// Revision21 1.14  2001/12/03 21:44:29  gorban21
// Updated21 specification21 documentation.
// Added21 full 32-bit data bus interface, now as default.
// Address is 5-bit wide21 in 32-bit data bus mode.
// Added21 wb_sel_i21 input to the core21. It's used in the 32-bit mode.
// Added21 debug21 interface with two21 32-bit read-only registers in 32-bit mode.
// Bits21 5 and 6 of LSR21 are now only cleared21 on TX21 FIFO write.
// My21 small test bench21 is modified to work21 with 32-bit mode.
//
// Revision21 1.13  2001/11/08 14:54:23  mohor21
// Comments21 in Slovene21 language21 deleted21, few21 small fixes21 for better21 work21 of
// old21 tools21. IRQs21 need to be fix21.
//
// Revision21 1.12  2001/11/07 17:51:52  gorban21
// Heavily21 rewritten21 interrupt21 and LSR21 subsystems21.
// Many21 bugs21 hopefully21 squashed21.
//
// Revision21 1.11  2001/10/29 17:00:46  gorban21
// fixed21 parity21 sending21 and tx_fifo21 resets21 over- and underrun21
//
// Revision21 1.10  2001/10/20 09:58:40  gorban21
// Small21 synopsis21 fixes21
//
// Revision21 1.9  2001/08/24 21:01:12  mohor21
// Things21 connected21 to parity21 changed.
// Clock21 devider21 changed.
//
// Revision21 1.8  2001/08/23 16:05:05  mohor21
// Stop bit bug21 fixed21.
// Parity21 bug21 fixed21.
// WISHBONE21 read cycle bug21 fixed21,
// OE21 indicator21 (Overrun21 Error) bug21 fixed21.
// PE21 indicator21 (Parity21 Error) bug21 fixed21.
// Register read bug21 fixed21.
//
// Revision21 1.6  2001/06/23 11:21:48  gorban21
// DL21 made21 16-bit long21. Fixed21 transmission21/reception21 bugs21.
//
// Revision21 1.5  2001/06/02 14:28:14  gorban21
// Fixed21 receiver21 and transmitter21. Major21 bug21 fixed21.
//
// Revision21 1.4  2001/05/31 20:08:01  gorban21
// FIFO changes21 and other corrections21.
//
// Revision21 1.3  2001/05/27 17:37:49  gorban21
// Fixed21 many21 bugs21. Updated21 spec21. Changed21 FIFO files structure21. See CHANGES21.txt21 file.
//
// Revision21 1.2  2001/05/21 19:12:02  gorban21
// Corrected21 some21 Linter21 messages21.
//
// Revision21 1.1  2001/05/17 18:34:18  gorban21
// First21 'stable' release. Should21 be sythesizable21 now. Also21 added new header.
//
// Revision21 1.0  2001-05-17 21:27:12+02  jacob21
// Initial21 revision21
//
//

// synopsys21 translate_off21
`include "timescale.v"
// synopsys21 translate_on21

`include "uart_defines21.v"

module uart_transmitter21 (clk21, wb_rst_i21, lcr21, tf_push21, wb_dat_i21, enable,	stx_pad_o21, tstate21, tf_count21, tx_reset21, lsr_mask21);

input 										clk21;
input 										wb_rst_i21;
input [7:0] 								lcr21;
input 										tf_push21;
input [7:0] 								wb_dat_i21;
input 										enable;
input 										tx_reset21;
input 										lsr_mask21; //reset of fifo
output 										stx_pad_o21;
output [2:0] 								tstate21;
output [`UART_FIFO_COUNTER_W21-1:0] 	tf_count21;

reg [2:0] 									tstate21;
reg [4:0] 									counter;
reg [2:0] 									bit_counter21;   // counts21 the bits to be sent21
reg [6:0] 									shift_out21;	// output shift21 register
reg 											stx_o_tmp21;
reg 											parity_xor21;  // parity21 of the word21
reg 											tf_pop21;
reg 											bit_out21;

// TX21 FIFO instance
//
// Transmitter21 FIFO signals21
wire [`UART_FIFO_WIDTH21-1:0] 			tf_data_in21;
wire [`UART_FIFO_WIDTH21-1:0] 			tf_data_out21;
wire 											tf_push21;
wire 											tf_overrun21;
wire [`UART_FIFO_COUNTER_W21-1:0] 		tf_count21;

assign 										tf_data_in21 = wb_dat_i21;

uart_tfifo21 fifo_tx21(	// error bit signal21 is not used in transmitter21 FIFO
	.clk21(		clk21		), 
	.wb_rst_i21(	wb_rst_i21	),
	.data_in21(	tf_data_in21	),
	.data_out21(	tf_data_out21	),
	.push21(		tf_push21		),
	.pop21(		tf_pop21		),
	.overrun21(	tf_overrun21	),
	.count(		tf_count21	),
	.fifo_reset21(	tx_reset21	),
	.reset_status21(lsr_mask21)
);

// TRANSMITTER21 FINAL21 STATE21 MACHINE21

parameter s_idle21        = 3'd0;
parameter s_send_start21  = 3'd1;
parameter s_send_byte21   = 3'd2;
parameter s_send_parity21 = 3'd3;
parameter s_send_stop21   = 3'd4;
parameter s_pop_byte21    = 3'd5;

always @(posedge clk21 or posedge wb_rst_i21)
begin
  if (wb_rst_i21)
  begin
	tstate21       <= #1 s_idle21;
	stx_o_tmp21       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out21   <= #1 7'b0;
	bit_out21     <= #1 1'b0;
	parity_xor21  <= #1 1'b0;
	tf_pop21      <= #1 1'b0;
	bit_counter21 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate21)
	s_idle21	 :	if (~|tf_count21) // if tf_count21==0
			begin
				tstate21 <= #1 s_idle21;
				stx_o_tmp21 <= #1 1'b1;
			end
			else
			begin
				tf_pop21 <= #1 1'b0;
				stx_o_tmp21  <= #1 1'b1;
				tstate21  <= #1 s_pop_byte21;
			end
	s_pop_byte21 :	begin
				tf_pop21 <= #1 1'b1;
				case (lcr21[/*`UART_LC_BITS21*/1:0])  // number21 of bits in a word21
				2'b00 : begin
					bit_counter21 <= #1 3'b100;
					parity_xor21  <= #1 ^tf_data_out21[4:0];
				     end
				2'b01 : begin
					bit_counter21 <= #1 3'b101;
					parity_xor21  <= #1 ^tf_data_out21[5:0];
				     end
				2'b10 : begin
					bit_counter21 <= #1 3'b110;
					parity_xor21  <= #1 ^tf_data_out21[6:0];
				     end
				2'b11 : begin
					bit_counter21 <= #1 3'b111;
					parity_xor21  <= #1 ^tf_data_out21[7:0];
				     end
				endcase
				{shift_out21[6:0], bit_out21} <= #1 tf_data_out21;
				tstate21 <= #1 s_send_start21;
			end
	s_send_start21 :	begin
				tf_pop21 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate21 <= #1 s_send_byte21;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp21 <= #1 1'b0;
			end
	s_send_byte21 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter21 > 3'b0)
					begin
						bit_counter21 <= #1 bit_counter21 - 1'b1;
						{shift_out21[5:0],bit_out21  } <= #1 {shift_out21[6:1], shift_out21[0]};
						tstate21 <= #1 s_send_byte21;
					end
					else   // end of byte
					if (~lcr21[`UART_LC_PE21])
					begin
						tstate21 <= #1 s_send_stop21;
					end
					else
					begin
						case ({lcr21[`UART_LC_EP21],lcr21[`UART_LC_SP21]})
						2'b00:	bit_out21 <= #1 ~parity_xor21;
						2'b01:	bit_out21 <= #1 1'b1;
						2'b10:	bit_out21 <= #1 parity_xor21;
						2'b11:	bit_out21 <= #1 1'b0;
						endcase
						tstate21 <= #1 s_send_parity21;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp21 <= #1 bit_out21; // set output pin21
			end
	s_send_parity21 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate21 <= #1 s_send_stop21;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp21 <= #1 bit_out21;
			end
	s_send_stop21 :  begin
				if (~|counter)
				  begin
						casex ({lcr21[`UART_LC_SB21],lcr21[`UART_LC_BITS21]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor21
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate21 <= #1 s_idle21;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp21 <= #1 1'b1;
			end

		default : // should never get here21
			tstate21 <= #1 s_idle21;
	endcase
  end // end if enable
  else
    tf_pop21 <= #1 1'b0;  // tf_pop21 must be 1 cycle width
end // transmitter21 logic

assign stx_pad_o21 = lcr21[`UART_LC_BC21] ? 1'b0 : stx_o_tmp21;    // Break21 condition
	
endmodule
