//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter19.v                                          ////
////                                                              ////
////                                                              ////
////  This19 file is part of the "UART19 16550 compatible19" project19    ////
////  http19://www19.opencores19.org19/cores19/uart1655019/                   ////
////                                                              ////
////  Documentation19 related19 to this project19:                      ////
////  - http19://www19.opencores19.org19/cores19/uart1655019/                 ////
////                                                              ////
////  Projects19 compatibility19:                                     ////
////  - WISHBONE19                                                  ////
////  RS23219 Protocol19                                              ////
////  16550D uart19 (mostly19 supported)                              ////
////                                                              ////
////  Overview19 (main19 Features19):                                   ////
////  UART19 core19 transmitter19 logic                                 ////
////                                                              ////
////  Known19 problems19 (limits19):                                    ////
////  None19 known19                                                  ////
////                                                              ////
////  To19 Do19:                                                      ////
////  Thourough19 testing19.                                          ////
////                                                              ////
////  Author19(s):                                                  ////
////      - gorban19@opencores19.org19                                  ////
////      - Jacob19 Gorban19                                          ////
////      - Igor19 Mohor19 (igorm19@opencores19.org19)                      ////
////                                                              ////
////  Created19:        2001/05/12                                  ////
////  Last19 Updated19:   2001/05/17                                  ////
////                  (See log19 for the revision19 history19)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2000, 2001 Authors19                             ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS19 Revision19 History19
//
// $Log: not supported by cvs2svn19 $
// Revision19 1.18  2002/07/22 23:02:23  gorban19
// Bug19 Fixes19:
//  * Possible19 loss of sync and bad19 reception19 of stop bit on slow19 baud19 rates19 fixed19.
//   Problem19 reported19 by Kenny19.Tung19.
//  * Bad (or lack19 of ) loopback19 handling19 fixed19. Reported19 by Cherry19 Withers19.
//
// Improvements19:
//  * Made19 FIFO's as general19 inferrable19 memory where possible19.
//  So19 on FPGA19 they should be inferred19 as RAM19 (Distributed19 RAM19 on Xilinx19).
//  This19 saves19 about19 1/3 of the Slice19 count and reduces19 P&R and synthesis19 times.
//
//  * Added19 optional19 baudrate19 output (baud_o19).
//  This19 is identical19 to BAUDOUT19* signal19 on 16550 chip19.
//  It outputs19 16xbit_clock_rate - the divided19 clock19.
//  It's disabled by default. Define19 UART_HAS_BAUDRATE_OUTPUT19 to use.
//
// Revision19 1.16  2002/01/08 11:29:40  mohor19
// tf_pop19 was too wide19. Now19 it is only 1 clk19 cycle width.
//
// Revision19 1.15  2001/12/17 14:46:48  mohor19
// overrun19 signal19 was moved to separate19 block because many19 sequential19 lsr19
// reads were19 preventing19 data from being written19 to rx19 fifo.
// underrun19 signal19 was not used and was removed from the project19.
//
// Revision19 1.14  2001/12/03 21:44:29  gorban19
// Updated19 specification19 documentation.
// Added19 full 32-bit data bus interface, now as default.
// Address is 5-bit wide19 in 32-bit data bus mode.
// Added19 wb_sel_i19 input to the core19. It's used in the 32-bit mode.
// Added19 debug19 interface with two19 32-bit read-only registers in 32-bit mode.
// Bits19 5 and 6 of LSR19 are now only cleared19 on TX19 FIFO write.
// My19 small test bench19 is modified to work19 with 32-bit mode.
//
// Revision19 1.13  2001/11/08 14:54:23  mohor19
// Comments19 in Slovene19 language19 deleted19, few19 small fixes19 for better19 work19 of
// old19 tools19. IRQs19 need to be fix19.
//
// Revision19 1.12  2001/11/07 17:51:52  gorban19
// Heavily19 rewritten19 interrupt19 and LSR19 subsystems19.
// Many19 bugs19 hopefully19 squashed19.
//
// Revision19 1.11  2001/10/29 17:00:46  gorban19
// fixed19 parity19 sending19 and tx_fifo19 resets19 over- and underrun19
//
// Revision19 1.10  2001/10/20 09:58:40  gorban19
// Small19 synopsis19 fixes19
//
// Revision19 1.9  2001/08/24 21:01:12  mohor19
// Things19 connected19 to parity19 changed.
// Clock19 devider19 changed.
//
// Revision19 1.8  2001/08/23 16:05:05  mohor19
// Stop bit bug19 fixed19.
// Parity19 bug19 fixed19.
// WISHBONE19 read cycle bug19 fixed19,
// OE19 indicator19 (Overrun19 Error) bug19 fixed19.
// PE19 indicator19 (Parity19 Error) bug19 fixed19.
// Register read bug19 fixed19.
//
// Revision19 1.6  2001/06/23 11:21:48  gorban19
// DL19 made19 16-bit long19. Fixed19 transmission19/reception19 bugs19.
//
// Revision19 1.5  2001/06/02 14:28:14  gorban19
// Fixed19 receiver19 and transmitter19. Major19 bug19 fixed19.
//
// Revision19 1.4  2001/05/31 20:08:01  gorban19
// FIFO changes19 and other corrections19.
//
// Revision19 1.3  2001/05/27 17:37:49  gorban19
// Fixed19 many19 bugs19. Updated19 spec19. Changed19 FIFO files structure19. See CHANGES19.txt19 file.
//
// Revision19 1.2  2001/05/21 19:12:02  gorban19
// Corrected19 some19 Linter19 messages19.
//
// Revision19 1.1  2001/05/17 18:34:18  gorban19
// First19 'stable' release. Should19 be sythesizable19 now. Also19 added new header.
//
// Revision19 1.0  2001-05-17 21:27:12+02  jacob19
// Initial19 revision19
//
//

// synopsys19 translate_off19
`include "timescale.v"
// synopsys19 translate_on19

`include "uart_defines19.v"

module uart_transmitter19 (clk19, wb_rst_i19, lcr19, tf_push19, wb_dat_i19, enable,	stx_pad_o19, tstate19, tf_count19, tx_reset19, lsr_mask19);

input 										clk19;
input 										wb_rst_i19;
input [7:0] 								lcr19;
input 										tf_push19;
input [7:0] 								wb_dat_i19;
input 										enable;
input 										tx_reset19;
input 										lsr_mask19; //reset of fifo
output 										stx_pad_o19;
output [2:0] 								tstate19;
output [`UART_FIFO_COUNTER_W19-1:0] 	tf_count19;

reg [2:0] 									tstate19;
reg [4:0] 									counter;
reg [2:0] 									bit_counter19;   // counts19 the bits to be sent19
reg [6:0] 									shift_out19;	// output shift19 register
reg 											stx_o_tmp19;
reg 											parity_xor19;  // parity19 of the word19
reg 											tf_pop19;
reg 											bit_out19;

// TX19 FIFO instance
//
// Transmitter19 FIFO signals19
wire [`UART_FIFO_WIDTH19-1:0] 			tf_data_in19;
wire [`UART_FIFO_WIDTH19-1:0] 			tf_data_out19;
wire 											tf_push19;
wire 											tf_overrun19;
wire [`UART_FIFO_COUNTER_W19-1:0] 		tf_count19;

assign 										tf_data_in19 = wb_dat_i19;

uart_tfifo19 fifo_tx19(	// error bit signal19 is not used in transmitter19 FIFO
	.clk19(		clk19		), 
	.wb_rst_i19(	wb_rst_i19	),
	.data_in19(	tf_data_in19	),
	.data_out19(	tf_data_out19	),
	.push19(		tf_push19		),
	.pop19(		tf_pop19		),
	.overrun19(	tf_overrun19	),
	.count(		tf_count19	),
	.fifo_reset19(	tx_reset19	),
	.reset_status19(lsr_mask19)
);

// TRANSMITTER19 FINAL19 STATE19 MACHINE19

parameter s_idle19        = 3'd0;
parameter s_send_start19  = 3'd1;
parameter s_send_byte19   = 3'd2;
parameter s_send_parity19 = 3'd3;
parameter s_send_stop19   = 3'd4;
parameter s_pop_byte19    = 3'd5;

always @(posedge clk19 or posedge wb_rst_i19)
begin
  if (wb_rst_i19)
  begin
	tstate19       <= #1 s_idle19;
	stx_o_tmp19       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out19   <= #1 7'b0;
	bit_out19     <= #1 1'b0;
	parity_xor19  <= #1 1'b0;
	tf_pop19      <= #1 1'b0;
	bit_counter19 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate19)
	s_idle19	 :	if (~|tf_count19) // if tf_count19==0
			begin
				tstate19 <= #1 s_idle19;
				stx_o_tmp19 <= #1 1'b1;
			end
			else
			begin
				tf_pop19 <= #1 1'b0;
				stx_o_tmp19  <= #1 1'b1;
				tstate19  <= #1 s_pop_byte19;
			end
	s_pop_byte19 :	begin
				tf_pop19 <= #1 1'b1;
				case (lcr19[/*`UART_LC_BITS19*/1:0])  // number19 of bits in a word19
				2'b00 : begin
					bit_counter19 <= #1 3'b100;
					parity_xor19  <= #1 ^tf_data_out19[4:0];
				     end
				2'b01 : begin
					bit_counter19 <= #1 3'b101;
					parity_xor19  <= #1 ^tf_data_out19[5:0];
				     end
				2'b10 : begin
					bit_counter19 <= #1 3'b110;
					parity_xor19  <= #1 ^tf_data_out19[6:0];
				     end
				2'b11 : begin
					bit_counter19 <= #1 3'b111;
					parity_xor19  <= #1 ^tf_data_out19[7:0];
				     end
				endcase
				{shift_out19[6:0], bit_out19} <= #1 tf_data_out19;
				tstate19 <= #1 s_send_start19;
			end
	s_send_start19 :	begin
				tf_pop19 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate19 <= #1 s_send_byte19;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp19 <= #1 1'b0;
			end
	s_send_byte19 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter19 > 3'b0)
					begin
						bit_counter19 <= #1 bit_counter19 - 1'b1;
						{shift_out19[5:0],bit_out19  } <= #1 {shift_out19[6:1], shift_out19[0]};
						tstate19 <= #1 s_send_byte19;
					end
					else   // end of byte
					if (~lcr19[`UART_LC_PE19])
					begin
						tstate19 <= #1 s_send_stop19;
					end
					else
					begin
						case ({lcr19[`UART_LC_EP19],lcr19[`UART_LC_SP19]})
						2'b00:	bit_out19 <= #1 ~parity_xor19;
						2'b01:	bit_out19 <= #1 1'b1;
						2'b10:	bit_out19 <= #1 parity_xor19;
						2'b11:	bit_out19 <= #1 1'b0;
						endcase
						tstate19 <= #1 s_send_parity19;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp19 <= #1 bit_out19; // set output pin19
			end
	s_send_parity19 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate19 <= #1 s_send_stop19;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp19 <= #1 bit_out19;
			end
	s_send_stop19 :  begin
				if (~|counter)
				  begin
						casex ({lcr19[`UART_LC_SB19],lcr19[`UART_LC_BITS19]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor19
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate19 <= #1 s_idle19;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp19 <= #1 1'b1;
			end

		default : // should never get here19
			tstate19 <= #1 s_idle19;
	endcase
  end // end if enable
  else
    tf_pop19 <= #1 1'b0;  // tf_pop19 must be 1 cycle width
end // transmitter19 logic

assign stx_pad_o19 = lcr19[`UART_LC_BC19] ? 1'b0 : stx_o_tmp19;    // Break19 condition
	
endmodule
