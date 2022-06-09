//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter30.v                                          ////
////                                                              ////
////                                                              ////
////  This30 file is part of the "UART30 16550 compatible30" project30    ////
////  http30://www30.opencores30.org30/cores30/uart1655030/                   ////
////                                                              ////
////  Documentation30 related30 to this project30:                      ////
////  - http30://www30.opencores30.org30/cores30/uart1655030/                 ////
////                                                              ////
////  Projects30 compatibility30:                                     ////
////  - WISHBONE30                                                  ////
////  RS23230 Protocol30                                              ////
////  16550D uart30 (mostly30 supported)                              ////
////                                                              ////
////  Overview30 (main30 Features30):                                   ////
////  UART30 core30 transmitter30 logic                                 ////
////                                                              ////
////  Known30 problems30 (limits30):                                    ////
////  None30 known30                                                  ////
////                                                              ////
////  To30 Do30:                                                      ////
////  Thourough30 testing30.                                          ////
////                                                              ////
////  Author30(s):                                                  ////
////      - gorban30@opencores30.org30                                  ////
////      - Jacob30 Gorban30                                          ////
////      - Igor30 Mohor30 (igorm30@opencores30.org30)                      ////
////                                                              ////
////  Created30:        2001/05/12                                  ////
////  Last30 Updated30:   2001/05/17                                  ////
////                  (See log30 for the revision30 history30)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2000, 2001 Authors30                             ////
////                                                              ////
//// This30 source30 file may be used and distributed30 without         ////
//// restriction30 provided that this copyright30 statement30 is not    ////
//// removed from the file and that any derivative30 work30 contains30  ////
//// the original copyright30 notice30 and the associated disclaimer30. ////
////                                                              ////
//// This30 source30 file is free software30; you can redistribute30 it   ////
//// and/or modify it under the terms30 of the GNU30 Lesser30 General30   ////
//// Public30 License30 as published30 by the Free30 Software30 Foundation30; ////
//// either30 version30 2.1 of the License30, or (at your30 option) any   ////
//// later30 version30.                                               ////
////                                                              ////
//// This30 source30 is distributed30 in the hope30 that it will be       ////
//// useful30, but WITHOUT30 ANY30 WARRANTY30; without even30 the implied30   ////
//// warranty30 of MERCHANTABILITY30 or FITNESS30 FOR30 A PARTICULAR30      ////
//// PURPOSE30.  See the GNU30 Lesser30 General30 Public30 License30 for more ////
//// details30.                                                     ////
////                                                              ////
//// You should have received30 a copy of the GNU30 Lesser30 General30    ////
//// Public30 License30 along30 with this source30; if not, download30 it   ////
//// from http30://www30.opencores30.org30/lgpl30.shtml30                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS30 Revision30 History30
//
// $Log: not supported by cvs2svn30 $
// Revision30 1.18  2002/07/22 23:02:23  gorban30
// Bug30 Fixes30:
//  * Possible30 loss of sync and bad30 reception30 of stop bit on slow30 baud30 rates30 fixed30.
//   Problem30 reported30 by Kenny30.Tung30.
//  * Bad (or lack30 of ) loopback30 handling30 fixed30. Reported30 by Cherry30 Withers30.
//
// Improvements30:
//  * Made30 FIFO's as general30 inferrable30 memory where possible30.
//  So30 on FPGA30 they should be inferred30 as RAM30 (Distributed30 RAM30 on Xilinx30).
//  This30 saves30 about30 1/3 of the Slice30 count and reduces30 P&R and synthesis30 times.
//
//  * Added30 optional30 baudrate30 output (baud_o30).
//  This30 is identical30 to BAUDOUT30* signal30 on 16550 chip30.
//  It outputs30 16xbit_clock_rate - the divided30 clock30.
//  It's disabled by default. Define30 UART_HAS_BAUDRATE_OUTPUT30 to use.
//
// Revision30 1.16  2002/01/08 11:29:40  mohor30
// tf_pop30 was too wide30. Now30 it is only 1 clk30 cycle width.
//
// Revision30 1.15  2001/12/17 14:46:48  mohor30
// overrun30 signal30 was moved to separate30 block because many30 sequential30 lsr30
// reads were30 preventing30 data from being written30 to rx30 fifo.
// underrun30 signal30 was not used and was removed from the project30.
//
// Revision30 1.14  2001/12/03 21:44:29  gorban30
// Updated30 specification30 documentation.
// Added30 full 32-bit data bus interface, now as default.
// Address is 5-bit wide30 in 32-bit data bus mode.
// Added30 wb_sel_i30 input to the core30. It's used in the 32-bit mode.
// Added30 debug30 interface with two30 32-bit read-only registers in 32-bit mode.
// Bits30 5 and 6 of LSR30 are now only cleared30 on TX30 FIFO write.
// My30 small test bench30 is modified to work30 with 32-bit mode.
//
// Revision30 1.13  2001/11/08 14:54:23  mohor30
// Comments30 in Slovene30 language30 deleted30, few30 small fixes30 for better30 work30 of
// old30 tools30. IRQs30 need to be fix30.
//
// Revision30 1.12  2001/11/07 17:51:52  gorban30
// Heavily30 rewritten30 interrupt30 and LSR30 subsystems30.
// Many30 bugs30 hopefully30 squashed30.
//
// Revision30 1.11  2001/10/29 17:00:46  gorban30
// fixed30 parity30 sending30 and tx_fifo30 resets30 over- and underrun30
//
// Revision30 1.10  2001/10/20 09:58:40  gorban30
// Small30 synopsis30 fixes30
//
// Revision30 1.9  2001/08/24 21:01:12  mohor30
// Things30 connected30 to parity30 changed.
// Clock30 devider30 changed.
//
// Revision30 1.8  2001/08/23 16:05:05  mohor30
// Stop bit bug30 fixed30.
// Parity30 bug30 fixed30.
// WISHBONE30 read cycle bug30 fixed30,
// OE30 indicator30 (Overrun30 Error) bug30 fixed30.
// PE30 indicator30 (Parity30 Error) bug30 fixed30.
// Register read bug30 fixed30.
//
// Revision30 1.6  2001/06/23 11:21:48  gorban30
// DL30 made30 16-bit long30. Fixed30 transmission30/reception30 bugs30.
//
// Revision30 1.5  2001/06/02 14:28:14  gorban30
// Fixed30 receiver30 and transmitter30. Major30 bug30 fixed30.
//
// Revision30 1.4  2001/05/31 20:08:01  gorban30
// FIFO changes30 and other corrections30.
//
// Revision30 1.3  2001/05/27 17:37:49  gorban30
// Fixed30 many30 bugs30. Updated30 spec30. Changed30 FIFO files structure30. See CHANGES30.txt30 file.
//
// Revision30 1.2  2001/05/21 19:12:02  gorban30
// Corrected30 some30 Linter30 messages30.
//
// Revision30 1.1  2001/05/17 18:34:18  gorban30
// First30 'stable' release. Should30 be sythesizable30 now. Also30 added new header.
//
// Revision30 1.0  2001-05-17 21:27:12+02  jacob30
// Initial30 revision30
//
//

// synopsys30 translate_off30
`include "timescale.v"
// synopsys30 translate_on30

`include "uart_defines30.v"

module uart_transmitter30 (clk30, wb_rst_i30, lcr30, tf_push30, wb_dat_i30, enable,	stx_pad_o30, tstate30, tf_count30, tx_reset30, lsr_mask30);

input 										clk30;
input 										wb_rst_i30;
input [7:0] 								lcr30;
input 										tf_push30;
input [7:0] 								wb_dat_i30;
input 										enable;
input 										tx_reset30;
input 										lsr_mask30; //reset of fifo
output 										stx_pad_o30;
output [2:0] 								tstate30;
output [`UART_FIFO_COUNTER_W30-1:0] 	tf_count30;

reg [2:0] 									tstate30;
reg [4:0] 									counter;
reg [2:0] 									bit_counter30;   // counts30 the bits to be sent30
reg [6:0] 									shift_out30;	// output shift30 register
reg 											stx_o_tmp30;
reg 											parity_xor30;  // parity30 of the word30
reg 											tf_pop30;
reg 											bit_out30;

// TX30 FIFO instance
//
// Transmitter30 FIFO signals30
wire [`UART_FIFO_WIDTH30-1:0] 			tf_data_in30;
wire [`UART_FIFO_WIDTH30-1:0] 			tf_data_out30;
wire 											tf_push30;
wire 											tf_overrun30;
wire [`UART_FIFO_COUNTER_W30-1:0] 		tf_count30;

assign 										tf_data_in30 = wb_dat_i30;

uart_tfifo30 fifo_tx30(	// error bit signal30 is not used in transmitter30 FIFO
	.clk30(		clk30		), 
	.wb_rst_i30(	wb_rst_i30	),
	.data_in30(	tf_data_in30	),
	.data_out30(	tf_data_out30	),
	.push30(		tf_push30		),
	.pop30(		tf_pop30		),
	.overrun30(	tf_overrun30	),
	.count(		tf_count30	),
	.fifo_reset30(	tx_reset30	),
	.reset_status30(lsr_mask30)
);

// TRANSMITTER30 FINAL30 STATE30 MACHINE30

parameter s_idle30        = 3'd0;
parameter s_send_start30  = 3'd1;
parameter s_send_byte30   = 3'd2;
parameter s_send_parity30 = 3'd3;
parameter s_send_stop30   = 3'd4;
parameter s_pop_byte30    = 3'd5;

always @(posedge clk30 or posedge wb_rst_i30)
begin
  if (wb_rst_i30)
  begin
	tstate30       <= #1 s_idle30;
	stx_o_tmp30       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out30   <= #1 7'b0;
	bit_out30     <= #1 1'b0;
	parity_xor30  <= #1 1'b0;
	tf_pop30      <= #1 1'b0;
	bit_counter30 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate30)
	s_idle30	 :	if (~|tf_count30) // if tf_count30==0
			begin
				tstate30 <= #1 s_idle30;
				stx_o_tmp30 <= #1 1'b1;
			end
			else
			begin
				tf_pop30 <= #1 1'b0;
				stx_o_tmp30  <= #1 1'b1;
				tstate30  <= #1 s_pop_byte30;
			end
	s_pop_byte30 :	begin
				tf_pop30 <= #1 1'b1;
				case (lcr30[/*`UART_LC_BITS30*/1:0])  // number30 of bits in a word30
				2'b00 : begin
					bit_counter30 <= #1 3'b100;
					parity_xor30  <= #1 ^tf_data_out30[4:0];
				     end
				2'b01 : begin
					bit_counter30 <= #1 3'b101;
					parity_xor30  <= #1 ^tf_data_out30[5:0];
				     end
				2'b10 : begin
					bit_counter30 <= #1 3'b110;
					parity_xor30  <= #1 ^tf_data_out30[6:0];
				     end
				2'b11 : begin
					bit_counter30 <= #1 3'b111;
					parity_xor30  <= #1 ^tf_data_out30[7:0];
				     end
				endcase
				{shift_out30[6:0], bit_out30} <= #1 tf_data_out30;
				tstate30 <= #1 s_send_start30;
			end
	s_send_start30 :	begin
				tf_pop30 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate30 <= #1 s_send_byte30;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp30 <= #1 1'b0;
			end
	s_send_byte30 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter30 > 3'b0)
					begin
						bit_counter30 <= #1 bit_counter30 - 1'b1;
						{shift_out30[5:0],bit_out30  } <= #1 {shift_out30[6:1], shift_out30[0]};
						tstate30 <= #1 s_send_byte30;
					end
					else   // end of byte
					if (~lcr30[`UART_LC_PE30])
					begin
						tstate30 <= #1 s_send_stop30;
					end
					else
					begin
						case ({lcr30[`UART_LC_EP30],lcr30[`UART_LC_SP30]})
						2'b00:	bit_out30 <= #1 ~parity_xor30;
						2'b01:	bit_out30 <= #1 1'b1;
						2'b10:	bit_out30 <= #1 parity_xor30;
						2'b11:	bit_out30 <= #1 1'b0;
						endcase
						tstate30 <= #1 s_send_parity30;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp30 <= #1 bit_out30; // set output pin30
			end
	s_send_parity30 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate30 <= #1 s_send_stop30;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp30 <= #1 bit_out30;
			end
	s_send_stop30 :  begin
				if (~|counter)
				  begin
						casex ({lcr30[`UART_LC_SB30],lcr30[`UART_LC_BITS30]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor30
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate30 <= #1 s_idle30;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp30 <= #1 1'b1;
			end

		default : // should never get here30
			tstate30 <= #1 s_idle30;
	endcase
  end // end if enable
  else
    tf_pop30 <= #1 1'b0;  // tf_pop30 must be 1 cycle width
end // transmitter30 logic

assign stx_pad_o30 = lcr30[`UART_LC_BC30] ? 1'b0 : stx_o_tmp30;    // Break30 condition
	
endmodule
