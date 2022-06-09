//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter2.v                                          ////
////                                                              ////
////                                                              ////
////  This2 file is part of the "UART2 16550 compatible2" project2    ////
////  http2://www2.opencores2.org2/cores2/uart165502/                   ////
////                                                              ////
////  Documentation2 related2 to this project2:                      ////
////  - http2://www2.opencores2.org2/cores2/uart165502/                 ////
////                                                              ////
////  Projects2 compatibility2:                                     ////
////  - WISHBONE2                                                  ////
////  RS2322 Protocol2                                              ////
////  16550D uart2 (mostly2 supported)                              ////
////                                                              ////
////  Overview2 (main2 Features2):                                   ////
////  UART2 core2 transmitter2 logic                                 ////
////                                                              ////
////  Known2 problems2 (limits2):                                    ////
////  None2 known2                                                  ////
////                                                              ////
////  To2 Do2:                                                      ////
////  Thourough2 testing2.                                          ////
////                                                              ////
////  Author2(s):                                                  ////
////      - gorban2@opencores2.org2                                  ////
////      - Jacob2 Gorban2                                          ////
////      - Igor2 Mohor2 (igorm2@opencores2.org2)                      ////
////                                                              ////
////  Created2:        2001/05/12                                  ////
////  Last2 Updated2:   2001/05/17                                  ////
////                  (See log2 for the revision2 history2)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2000, 2001 Authors2                             ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS2 Revision2 History2
//
// $Log: not supported by cvs2svn2 $
// Revision2 1.18  2002/07/22 23:02:23  gorban2
// Bug2 Fixes2:
//  * Possible2 loss of sync and bad2 reception2 of stop bit on slow2 baud2 rates2 fixed2.
//   Problem2 reported2 by Kenny2.Tung2.
//  * Bad (or lack2 of ) loopback2 handling2 fixed2. Reported2 by Cherry2 Withers2.
//
// Improvements2:
//  * Made2 FIFO's as general2 inferrable2 memory where possible2.
//  So2 on FPGA2 they should be inferred2 as RAM2 (Distributed2 RAM2 on Xilinx2).
//  This2 saves2 about2 1/3 of the Slice2 count and reduces2 P&R and synthesis2 times.
//
//  * Added2 optional2 baudrate2 output (baud_o2).
//  This2 is identical2 to BAUDOUT2* signal2 on 16550 chip2.
//  It outputs2 16xbit_clock_rate - the divided2 clock2.
//  It's disabled by default. Define2 UART_HAS_BAUDRATE_OUTPUT2 to use.
//
// Revision2 1.16  2002/01/08 11:29:40  mohor2
// tf_pop2 was too wide2. Now2 it is only 1 clk2 cycle width.
//
// Revision2 1.15  2001/12/17 14:46:48  mohor2
// overrun2 signal2 was moved to separate2 block because many2 sequential2 lsr2
// reads were2 preventing2 data from being written2 to rx2 fifo.
// underrun2 signal2 was not used and was removed from the project2.
//
// Revision2 1.14  2001/12/03 21:44:29  gorban2
// Updated2 specification2 documentation.
// Added2 full 32-bit data bus interface, now as default.
// Address is 5-bit wide2 in 32-bit data bus mode.
// Added2 wb_sel_i2 input to the core2. It's used in the 32-bit mode.
// Added2 debug2 interface with two2 32-bit read-only registers in 32-bit mode.
// Bits2 5 and 6 of LSR2 are now only cleared2 on TX2 FIFO write.
// My2 small test bench2 is modified to work2 with 32-bit mode.
//
// Revision2 1.13  2001/11/08 14:54:23  mohor2
// Comments2 in Slovene2 language2 deleted2, few2 small fixes2 for better2 work2 of
// old2 tools2. IRQs2 need to be fix2.
//
// Revision2 1.12  2001/11/07 17:51:52  gorban2
// Heavily2 rewritten2 interrupt2 and LSR2 subsystems2.
// Many2 bugs2 hopefully2 squashed2.
//
// Revision2 1.11  2001/10/29 17:00:46  gorban2
// fixed2 parity2 sending2 and tx_fifo2 resets2 over- and underrun2
//
// Revision2 1.10  2001/10/20 09:58:40  gorban2
// Small2 synopsis2 fixes2
//
// Revision2 1.9  2001/08/24 21:01:12  mohor2
// Things2 connected2 to parity2 changed.
// Clock2 devider2 changed.
//
// Revision2 1.8  2001/08/23 16:05:05  mohor2
// Stop bit bug2 fixed2.
// Parity2 bug2 fixed2.
// WISHBONE2 read cycle bug2 fixed2,
// OE2 indicator2 (Overrun2 Error) bug2 fixed2.
// PE2 indicator2 (Parity2 Error) bug2 fixed2.
// Register read bug2 fixed2.
//
// Revision2 1.6  2001/06/23 11:21:48  gorban2
// DL2 made2 16-bit long2. Fixed2 transmission2/reception2 bugs2.
//
// Revision2 1.5  2001/06/02 14:28:14  gorban2
// Fixed2 receiver2 and transmitter2. Major2 bug2 fixed2.
//
// Revision2 1.4  2001/05/31 20:08:01  gorban2
// FIFO changes2 and other corrections2.
//
// Revision2 1.3  2001/05/27 17:37:49  gorban2
// Fixed2 many2 bugs2. Updated2 spec2. Changed2 FIFO files structure2. See CHANGES2.txt2 file.
//
// Revision2 1.2  2001/05/21 19:12:02  gorban2
// Corrected2 some2 Linter2 messages2.
//
// Revision2 1.1  2001/05/17 18:34:18  gorban2
// First2 'stable' release. Should2 be sythesizable2 now. Also2 added new header.
//
// Revision2 1.0  2001-05-17 21:27:12+02  jacob2
// Initial2 revision2
//
//

// synopsys2 translate_off2
`include "timescale.v"
// synopsys2 translate_on2

`include "uart_defines2.v"

module uart_transmitter2 (clk2, wb_rst_i2, lcr2, tf_push2, wb_dat_i2, enable,	stx_pad_o2, tstate2, tf_count2, tx_reset2, lsr_mask2);

input 										clk2;
input 										wb_rst_i2;
input [7:0] 								lcr2;
input 										tf_push2;
input [7:0] 								wb_dat_i2;
input 										enable;
input 										tx_reset2;
input 										lsr_mask2; //reset of fifo
output 										stx_pad_o2;
output [2:0] 								tstate2;
output [`UART_FIFO_COUNTER_W2-1:0] 	tf_count2;

reg [2:0] 									tstate2;
reg [4:0] 									counter;
reg [2:0] 									bit_counter2;   // counts2 the bits to be sent2
reg [6:0] 									shift_out2;	// output shift2 register
reg 											stx_o_tmp2;
reg 											parity_xor2;  // parity2 of the word2
reg 											tf_pop2;
reg 											bit_out2;

// TX2 FIFO instance
//
// Transmitter2 FIFO signals2
wire [`UART_FIFO_WIDTH2-1:0] 			tf_data_in2;
wire [`UART_FIFO_WIDTH2-1:0] 			tf_data_out2;
wire 											tf_push2;
wire 											tf_overrun2;
wire [`UART_FIFO_COUNTER_W2-1:0] 		tf_count2;

assign 										tf_data_in2 = wb_dat_i2;

uart_tfifo2 fifo_tx2(	// error bit signal2 is not used in transmitter2 FIFO
	.clk2(		clk2		), 
	.wb_rst_i2(	wb_rst_i2	),
	.data_in2(	tf_data_in2	),
	.data_out2(	tf_data_out2	),
	.push2(		tf_push2		),
	.pop2(		tf_pop2		),
	.overrun2(	tf_overrun2	),
	.count(		tf_count2	),
	.fifo_reset2(	tx_reset2	),
	.reset_status2(lsr_mask2)
);

// TRANSMITTER2 FINAL2 STATE2 MACHINE2

parameter s_idle2        = 3'd0;
parameter s_send_start2  = 3'd1;
parameter s_send_byte2   = 3'd2;
parameter s_send_parity2 = 3'd3;
parameter s_send_stop2   = 3'd4;
parameter s_pop_byte2    = 3'd5;

always @(posedge clk2 or posedge wb_rst_i2)
begin
  if (wb_rst_i2)
  begin
	tstate2       <= #1 s_idle2;
	stx_o_tmp2       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out2   <= #1 7'b0;
	bit_out2     <= #1 1'b0;
	parity_xor2  <= #1 1'b0;
	tf_pop2      <= #1 1'b0;
	bit_counter2 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate2)
	s_idle2	 :	if (~|tf_count2) // if tf_count2==0
			begin
				tstate2 <= #1 s_idle2;
				stx_o_tmp2 <= #1 1'b1;
			end
			else
			begin
				tf_pop2 <= #1 1'b0;
				stx_o_tmp2  <= #1 1'b1;
				tstate2  <= #1 s_pop_byte2;
			end
	s_pop_byte2 :	begin
				tf_pop2 <= #1 1'b1;
				case (lcr2[/*`UART_LC_BITS2*/1:0])  // number2 of bits in a word2
				2'b00 : begin
					bit_counter2 <= #1 3'b100;
					parity_xor2  <= #1 ^tf_data_out2[4:0];
				     end
				2'b01 : begin
					bit_counter2 <= #1 3'b101;
					parity_xor2  <= #1 ^tf_data_out2[5:0];
				     end
				2'b10 : begin
					bit_counter2 <= #1 3'b110;
					parity_xor2  <= #1 ^tf_data_out2[6:0];
				     end
				2'b11 : begin
					bit_counter2 <= #1 3'b111;
					parity_xor2  <= #1 ^tf_data_out2[7:0];
				     end
				endcase
				{shift_out2[6:0], bit_out2} <= #1 tf_data_out2;
				tstate2 <= #1 s_send_start2;
			end
	s_send_start2 :	begin
				tf_pop2 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate2 <= #1 s_send_byte2;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp2 <= #1 1'b0;
			end
	s_send_byte2 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter2 > 3'b0)
					begin
						bit_counter2 <= #1 bit_counter2 - 1'b1;
						{shift_out2[5:0],bit_out2  } <= #1 {shift_out2[6:1], shift_out2[0]};
						tstate2 <= #1 s_send_byte2;
					end
					else   // end of byte
					if (~lcr2[`UART_LC_PE2])
					begin
						tstate2 <= #1 s_send_stop2;
					end
					else
					begin
						case ({lcr2[`UART_LC_EP2],lcr2[`UART_LC_SP2]})
						2'b00:	bit_out2 <= #1 ~parity_xor2;
						2'b01:	bit_out2 <= #1 1'b1;
						2'b10:	bit_out2 <= #1 parity_xor2;
						2'b11:	bit_out2 <= #1 1'b0;
						endcase
						tstate2 <= #1 s_send_parity2;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp2 <= #1 bit_out2; // set output pin2
			end
	s_send_parity2 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate2 <= #1 s_send_stop2;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp2 <= #1 bit_out2;
			end
	s_send_stop2 :  begin
				if (~|counter)
				  begin
						casex ({lcr2[`UART_LC_SB2],lcr2[`UART_LC_BITS2]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor2
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate2 <= #1 s_idle2;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp2 <= #1 1'b1;
			end

		default : // should never get here2
			tstate2 <= #1 s_idle2;
	endcase
  end // end if enable
  else
    tf_pop2 <= #1 1'b0;  // tf_pop2 must be 1 cycle width
end // transmitter2 logic

assign stx_pad_o2 = lcr2[`UART_LC_BC2] ? 1'b0 : stx_o_tmp2;    // Break2 condition
	
endmodule
