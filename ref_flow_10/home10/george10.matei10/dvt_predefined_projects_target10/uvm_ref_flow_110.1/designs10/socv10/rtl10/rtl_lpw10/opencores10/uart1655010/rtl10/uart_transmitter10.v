//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter10.v                                          ////
////                                                              ////
////                                                              ////
////  This10 file is part of the "UART10 16550 compatible10" project10    ////
////  http10://www10.opencores10.org10/cores10/uart1655010/                   ////
////                                                              ////
////  Documentation10 related10 to this project10:                      ////
////  - http10://www10.opencores10.org10/cores10/uart1655010/                 ////
////                                                              ////
////  Projects10 compatibility10:                                     ////
////  - WISHBONE10                                                  ////
////  RS23210 Protocol10                                              ////
////  16550D uart10 (mostly10 supported)                              ////
////                                                              ////
////  Overview10 (main10 Features10):                                   ////
////  UART10 core10 transmitter10 logic                                 ////
////                                                              ////
////  Known10 problems10 (limits10):                                    ////
////  None10 known10                                                  ////
////                                                              ////
////  To10 Do10:                                                      ////
////  Thourough10 testing10.                                          ////
////                                                              ////
////  Author10(s):                                                  ////
////      - gorban10@opencores10.org10                                  ////
////      - Jacob10 Gorban10                                          ////
////      - Igor10 Mohor10 (igorm10@opencores10.org10)                      ////
////                                                              ////
////  Created10:        2001/05/12                                  ////
////  Last10 Updated10:   2001/05/17                                  ////
////                  (See log10 for the revision10 history10)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright10 (C) 2000, 2001 Authors10                             ////
////                                                              ////
//// This10 source10 file may be used and distributed10 without         ////
//// restriction10 provided that this copyright10 statement10 is not    ////
//// removed from the file and that any derivative10 work10 contains10  ////
//// the original copyright10 notice10 and the associated disclaimer10. ////
////                                                              ////
//// This10 source10 file is free software10; you can redistribute10 it   ////
//// and/or modify it under the terms10 of the GNU10 Lesser10 General10   ////
//// Public10 License10 as published10 by the Free10 Software10 Foundation10; ////
//// either10 version10 2.1 of the License10, or (at your10 option) any   ////
//// later10 version10.                                               ////
////                                                              ////
//// This10 source10 is distributed10 in the hope10 that it will be       ////
//// useful10, but WITHOUT10 ANY10 WARRANTY10; without even10 the implied10   ////
//// warranty10 of MERCHANTABILITY10 or FITNESS10 FOR10 A PARTICULAR10      ////
//// PURPOSE10.  See the GNU10 Lesser10 General10 Public10 License10 for more ////
//// details10.                                                     ////
////                                                              ////
//// You should have received10 a copy of the GNU10 Lesser10 General10    ////
//// Public10 License10 along10 with this source10; if not, download10 it   ////
//// from http10://www10.opencores10.org10/lgpl10.shtml10                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS10 Revision10 History10
//
// $Log: not supported by cvs2svn10 $
// Revision10 1.18  2002/07/22 23:02:23  gorban10
// Bug10 Fixes10:
//  * Possible10 loss of sync and bad10 reception10 of stop bit on slow10 baud10 rates10 fixed10.
//   Problem10 reported10 by Kenny10.Tung10.
//  * Bad (or lack10 of ) loopback10 handling10 fixed10. Reported10 by Cherry10 Withers10.
//
// Improvements10:
//  * Made10 FIFO's as general10 inferrable10 memory where possible10.
//  So10 on FPGA10 they should be inferred10 as RAM10 (Distributed10 RAM10 on Xilinx10).
//  This10 saves10 about10 1/3 of the Slice10 count and reduces10 P&R and synthesis10 times.
//
//  * Added10 optional10 baudrate10 output (baud_o10).
//  This10 is identical10 to BAUDOUT10* signal10 on 16550 chip10.
//  It outputs10 16xbit_clock_rate - the divided10 clock10.
//  It's disabled by default. Define10 UART_HAS_BAUDRATE_OUTPUT10 to use.
//
// Revision10 1.16  2002/01/08 11:29:40  mohor10
// tf_pop10 was too wide10. Now10 it is only 1 clk10 cycle width.
//
// Revision10 1.15  2001/12/17 14:46:48  mohor10
// overrun10 signal10 was moved to separate10 block because many10 sequential10 lsr10
// reads were10 preventing10 data from being written10 to rx10 fifo.
// underrun10 signal10 was not used and was removed from the project10.
//
// Revision10 1.14  2001/12/03 21:44:29  gorban10
// Updated10 specification10 documentation.
// Added10 full 32-bit data bus interface, now as default.
// Address is 5-bit wide10 in 32-bit data bus mode.
// Added10 wb_sel_i10 input to the core10. It's used in the 32-bit mode.
// Added10 debug10 interface with two10 32-bit read-only registers in 32-bit mode.
// Bits10 5 and 6 of LSR10 are now only cleared10 on TX10 FIFO write.
// My10 small test bench10 is modified to work10 with 32-bit mode.
//
// Revision10 1.13  2001/11/08 14:54:23  mohor10
// Comments10 in Slovene10 language10 deleted10, few10 small fixes10 for better10 work10 of
// old10 tools10. IRQs10 need to be fix10.
//
// Revision10 1.12  2001/11/07 17:51:52  gorban10
// Heavily10 rewritten10 interrupt10 and LSR10 subsystems10.
// Many10 bugs10 hopefully10 squashed10.
//
// Revision10 1.11  2001/10/29 17:00:46  gorban10
// fixed10 parity10 sending10 and tx_fifo10 resets10 over- and underrun10
//
// Revision10 1.10  2001/10/20 09:58:40  gorban10
// Small10 synopsis10 fixes10
//
// Revision10 1.9  2001/08/24 21:01:12  mohor10
// Things10 connected10 to parity10 changed.
// Clock10 devider10 changed.
//
// Revision10 1.8  2001/08/23 16:05:05  mohor10
// Stop bit bug10 fixed10.
// Parity10 bug10 fixed10.
// WISHBONE10 read cycle bug10 fixed10,
// OE10 indicator10 (Overrun10 Error) bug10 fixed10.
// PE10 indicator10 (Parity10 Error) bug10 fixed10.
// Register read bug10 fixed10.
//
// Revision10 1.6  2001/06/23 11:21:48  gorban10
// DL10 made10 16-bit long10. Fixed10 transmission10/reception10 bugs10.
//
// Revision10 1.5  2001/06/02 14:28:14  gorban10
// Fixed10 receiver10 and transmitter10. Major10 bug10 fixed10.
//
// Revision10 1.4  2001/05/31 20:08:01  gorban10
// FIFO changes10 and other corrections10.
//
// Revision10 1.3  2001/05/27 17:37:49  gorban10
// Fixed10 many10 bugs10. Updated10 spec10. Changed10 FIFO files structure10. See CHANGES10.txt10 file.
//
// Revision10 1.2  2001/05/21 19:12:02  gorban10
// Corrected10 some10 Linter10 messages10.
//
// Revision10 1.1  2001/05/17 18:34:18  gorban10
// First10 'stable' release. Should10 be sythesizable10 now. Also10 added new header.
//
// Revision10 1.0  2001-05-17 21:27:12+02  jacob10
// Initial10 revision10
//
//

// synopsys10 translate_off10
`include "timescale.v"
// synopsys10 translate_on10

`include "uart_defines10.v"

module uart_transmitter10 (clk10, wb_rst_i10, lcr10, tf_push10, wb_dat_i10, enable,	stx_pad_o10, tstate10, tf_count10, tx_reset10, lsr_mask10);

input 										clk10;
input 										wb_rst_i10;
input [7:0] 								lcr10;
input 										tf_push10;
input [7:0] 								wb_dat_i10;
input 										enable;
input 										tx_reset10;
input 										lsr_mask10; //reset of fifo
output 										stx_pad_o10;
output [2:0] 								tstate10;
output [`UART_FIFO_COUNTER_W10-1:0] 	tf_count10;

reg [2:0] 									tstate10;
reg [4:0] 									counter;
reg [2:0] 									bit_counter10;   // counts10 the bits to be sent10
reg [6:0] 									shift_out10;	// output shift10 register
reg 											stx_o_tmp10;
reg 											parity_xor10;  // parity10 of the word10
reg 											tf_pop10;
reg 											bit_out10;

// TX10 FIFO instance
//
// Transmitter10 FIFO signals10
wire [`UART_FIFO_WIDTH10-1:0] 			tf_data_in10;
wire [`UART_FIFO_WIDTH10-1:0] 			tf_data_out10;
wire 											tf_push10;
wire 											tf_overrun10;
wire [`UART_FIFO_COUNTER_W10-1:0] 		tf_count10;

assign 										tf_data_in10 = wb_dat_i10;

uart_tfifo10 fifo_tx10(	// error bit signal10 is not used in transmitter10 FIFO
	.clk10(		clk10		), 
	.wb_rst_i10(	wb_rst_i10	),
	.data_in10(	tf_data_in10	),
	.data_out10(	tf_data_out10	),
	.push10(		tf_push10		),
	.pop10(		tf_pop10		),
	.overrun10(	tf_overrun10	),
	.count(		tf_count10	),
	.fifo_reset10(	tx_reset10	),
	.reset_status10(lsr_mask10)
);

// TRANSMITTER10 FINAL10 STATE10 MACHINE10

parameter s_idle10        = 3'd0;
parameter s_send_start10  = 3'd1;
parameter s_send_byte10   = 3'd2;
parameter s_send_parity10 = 3'd3;
parameter s_send_stop10   = 3'd4;
parameter s_pop_byte10    = 3'd5;

always @(posedge clk10 or posedge wb_rst_i10)
begin
  if (wb_rst_i10)
  begin
	tstate10       <= #1 s_idle10;
	stx_o_tmp10       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out10   <= #1 7'b0;
	bit_out10     <= #1 1'b0;
	parity_xor10  <= #1 1'b0;
	tf_pop10      <= #1 1'b0;
	bit_counter10 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate10)
	s_idle10	 :	if (~|tf_count10) // if tf_count10==0
			begin
				tstate10 <= #1 s_idle10;
				stx_o_tmp10 <= #1 1'b1;
			end
			else
			begin
				tf_pop10 <= #1 1'b0;
				stx_o_tmp10  <= #1 1'b1;
				tstate10  <= #1 s_pop_byte10;
			end
	s_pop_byte10 :	begin
				tf_pop10 <= #1 1'b1;
				case (lcr10[/*`UART_LC_BITS10*/1:0])  // number10 of bits in a word10
				2'b00 : begin
					bit_counter10 <= #1 3'b100;
					parity_xor10  <= #1 ^tf_data_out10[4:0];
				     end
				2'b01 : begin
					bit_counter10 <= #1 3'b101;
					parity_xor10  <= #1 ^tf_data_out10[5:0];
				     end
				2'b10 : begin
					bit_counter10 <= #1 3'b110;
					parity_xor10  <= #1 ^tf_data_out10[6:0];
				     end
				2'b11 : begin
					bit_counter10 <= #1 3'b111;
					parity_xor10  <= #1 ^tf_data_out10[7:0];
				     end
				endcase
				{shift_out10[6:0], bit_out10} <= #1 tf_data_out10;
				tstate10 <= #1 s_send_start10;
			end
	s_send_start10 :	begin
				tf_pop10 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate10 <= #1 s_send_byte10;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp10 <= #1 1'b0;
			end
	s_send_byte10 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter10 > 3'b0)
					begin
						bit_counter10 <= #1 bit_counter10 - 1'b1;
						{shift_out10[5:0],bit_out10  } <= #1 {shift_out10[6:1], shift_out10[0]};
						tstate10 <= #1 s_send_byte10;
					end
					else   // end of byte
					if (~lcr10[`UART_LC_PE10])
					begin
						tstate10 <= #1 s_send_stop10;
					end
					else
					begin
						case ({lcr10[`UART_LC_EP10],lcr10[`UART_LC_SP10]})
						2'b00:	bit_out10 <= #1 ~parity_xor10;
						2'b01:	bit_out10 <= #1 1'b1;
						2'b10:	bit_out10 <= #1 parity_xor10;
						2'b11:	bit_out10 <= #1 1'b0;
						endcase
						tstate10 <= #1 s_send_parity10;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp10 <= #1 bit_out10; // set output pin10
			end
	s_send_parity10 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate10 <= #1 s_send_stop10;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp10 <= #1 bit_out10;
			end
	s_send_stop10 :  begin
				if (~|counter)
				  begin
						casex ({lcr10[`UART_LC_SB10],lcr10[`UART_LC_BITS10]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor10
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate10 <= #1 s_idle10;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp10 <= #1 1'b1;
			end

		default : // should never get here10
			tstate10 <= #1 s_idle10;
	endcase
  end // end if enable
  else
    tf_pop10 <= #1 1'b0;  // tf_pop10 must be 1 cycle width
end // transmitter10 logic

assign stx_pad_o10 = lcr10[`UART_LC_BC10] ? 1'b0 : stx_o_tmp10;    // Break10 condition
	
endmodule
