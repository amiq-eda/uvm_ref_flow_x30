//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter28.v                                          ////
////                                                              ////
////                                                              ////
////  This28 file is part of the "UART28 16550 compatible28" project28    ////
////  http28://www28.opencores28.org28/cores28/uart1655028/                   ////
////                                                              ////
////  Documentation28 related28 to this project28:                      ////
////  - http28://www28.opencores28.org28/cores28/uart1655028/                 ////
////                                                              ////
////  Projects28 compatibility28:                                     ////
////  - WISHBONE28                                                  ////
////  RS23228 Protocol28                                              ////
////  16550D uart28 (mostly28 supported)                              ////
////                                                              ////
////  Overview28 (main28 Features28):                                   ////
////  UART28 core28 transmitter28 logic                                 ////
////                                                              ////
////  Known28 problems28 (limits28):                                    ////
////  None28 known28                                                  ////
////                                                              ////
////  To28 Do28:                                                      ////
////  Thourough28 testing28.                                          ////
////                                                              ////
////  Author28(s):                                                  ////
////      - gorban28@opencores28.org28                                  ////
////      - Jacob28 Gorban28                                          ////
////      - Igor28 Mohor28 (igorm28@opencores28.org28)                      ////
////                                                              ////
////  Created28:        2001/05/12                                  ////
////  Last28 Updated28:   2001/05/17                                  ////
////                  (See log28 for the revision28 history28)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2000, 2001 Authors28                             ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS28 Revision28 History28
//
// $Log: not supported by cvs2svn28 $
// Revision28 1.18  2002/07/22 23:02:23  gorban28
// Bug28 Fixes28:
//  * Possible28 loss of sync and bad28 reception28 of stop bit on slow28 baud28 rates28 fixed28.
//   Problem28 reported28 by Kenny28.Tung28.
//  * Bad (or lack28 of ) loopback28 handling28 fixed28. Reported28 by Cherry28 Withers28.
//
// Improvements28:
//  * Made28 FIFO's as general28 inferrable28 memory where possible28.
//  So28 on FPGA28 they should be inferred28 as RAM28 (Distributed28 RAM28 on Xilinx28).
//  This28 saves28 about28 1/3 of the Slice28 count and reduces28 P&R and synthesis28 times.
//
//  * Added28 optional28 baudrate28 output (baud_o28).
//  This28 is identical28 to BAUDOUT28* signal28 on 16550 chip28.
//  It outputs28 16xbit_clock_rate - the divided28 clock28.
//  It's disabled by default. Define28 UART_HAS_BAUDRATE_OUTPUT28 to use.
//
// Revision28 1.16  2002/01/08 11:29:40  mohor28
// tf_pop28 was too wide28. Now28 it is only 1 clk28 cycle width.
//
// Revision28 1.15  2001/12/17 14:46:48  mohor28
// overrun28 signal28 was moved to separate28 block because many28 sequential28 lsr28
// reads were28 preventing28 data from being written28 to rx28 fifo.
// underrun28 signal28 was not used and was removed from the project28.
//
// Revision28 1.14  2001/12/03 21:44:29  gorban28
// Updated28 specification28 documentation.
// Added28 full 32-bit data bus interface, now as default.
// Address is 5-bit wide28 in 32-bit data bus mode.
// Added28 wb_sel_i28 input to the core28. It's used in the 32-bit mode.
// Added28 debug28 interface with two28 32-bit read-only registers in 32-bit mode.
// Bits28 5 and 6 of LSR28 are now only cleared28 on TX28 FIFO write.
// My28 small test bench28 is modified to work28 with 32-bit mode.
//
// Revision28 1.13  2001/11/08 14:54:23  mohor28
// Comments28 in Slovene28 language28 deleted28, few28 small fixes28 for better28 work28 of
// old28 tools28. IRQs28 need to be fix28.
//
// Revision28 1.12  2001/11/07 17:51:52  gorban28
// Heavily28 rewritten28 interrupt28 and LSR28 subsystems28.
// Many28 bugs28 hopefully28 squashed28.
//
// Revision28 1.11  2001/10/29 17:00:46  gorban28
// fixed28 parity28 sending28 and tx_fifo28 resets28 over- and underrun28
//
// Revision28 1.10  2001/10/20 09:58:40  gorban28
// Small28 synopsis28 fixes28
//
// Revision28 1.9  2001/08/24 21:01:12  mohor28
// Things28 connected28 to parity28 changed.
// Clock28 devider28 changed.
//
// Revision28 1.8  2001/08/23 16:05:05  mohor28
// Stop bit bug28 fixed28.
// Parity28 bug28 fixed28.
// WISHBONE28 read cycle bug28 fixed28,
// OE28 indicator28 (Overrun28 Error) bug28 fixed28.
// PE28 indicator28 (Parity28 Error) bug28 fixed28.
// Register read bug28 fixed28.
//
// Revision28 1.6  2001/06/23 11:21:48  gorban28
// DL28 made28 16-bit long28. Fixed28 transmission28/reception28 bugs28.
//
// Revision28 1.5  2001/06/02 14:28:14  gorban28
// Fixed28 receiver28 and transmitter28. Major28 bug28 fixed28.
//
// Revision28 1.4  2001/05/31 20:08:01  gorban28
// FIFO changes28 and other corrections28.
//
// Revision28 1.3  2001/05/27 17:37:49  gorban28
// Fixed28 many28 bugs28. Updated28 spec28. Changed28 FIFO files structure28. See CHANGES28.txt28 file.
//
// Revision28 1.2  2001/05/21 19:12:02  gorban28
// Corrected28 some28 Linter28 messages28.
//
// Revision28 1.1  2001/05/17 18:34:18  gorban28
// First28 'stable' release. Should28 be sythesizable28 now. Also28 added new header.
//
// Revision28 1.0  2001-05-17 21:27:12+02  jacob28
// Initial28 revision28
//
//

// synopsys28 translate_off28
`include "timescale.v"
// synopsys28 translate_on28

`include "uart_defines28.v"

module uart_transmitter28 (clk28, wb_rst_i28, lcr28, tf_push28, wb_dat_i28, enable,	stx_pad_o28, tstate28, tf_count28, tx_reset28, lsr_mask28);

input 										clk28;
input 										wb_rst_i28;
input [7:0] 								lcr28;
input 										tf_push28;
input [7:0] 								wb_dat_i28;
input 										enable;
input 										tx_reset28;
input 										lsr_mask28; //reset of fifo
output 										stx_pad_o28;
output [2:0] 								tstate28;
output [`UART_FIFO_COUNTER_W28-1:0] 	tf_count28;

reg [2:0] 									tstate28;
reg [4:0] 									counter;
reg [2:0] 									bit_counter28;   // counts28 the bits to be sent28
reg [6:0] 									shift_out28;	// output shift28 register
reg 											stx_o_tmp28;
reg 											parity_xor28;  // parity28 of the word28
reg 											tf_pop28;
reg 											bit_out28;

// TX28 FIFO instance
//
// Transmitter28 FIFO signals28
wire [`UART_FIFO_WIDTH28-1:0] 			tf_data_in28;
wire [`UART_FIFO_WIDTH28-1:0] 			tf_data_out28;
wire 											tf_push28;
wire 											tf_overrun28;
wire [`UART_FIFO_COUNTER_W28-1:0] 		tf_count28;

assign 										tf_data_in28 = wb_dat_i28;

uart_tfifo28 fifo_tx28(	// error bit signal28 is not used in transmitter28 FIFO
	.clk28(		clk28		), 
	.wb_rst_i28(	wb_rst_i28	),
	.data_in28(	tf_data_in28	),
	.data_out28(	tf_data_out28	),
	.push28(		tf_push28		),
	.pop28(		tf_pop28		),
	.overrun28(	tf_overrun28	),
	.count(		tf_count28	),
	.fifo_reset28(	tx_reset28	),
	.reset_status28(lsr_mask28)
);

// TRANSMITTER28 FINAL28 STATE28 MACHINE28

parameter s_idle28        = 3'd0;
parameter s_send_start28  = 3'd1;
parameter s_send_byte28   = 3'd2;
parameter s_send_parity28 = 3'd3;
parameter s_send_stop28   = 3'd4;
parameter s_pop_byte28    = 3'd5;

always @(posedge clk28 or posedge wb_rst_i28)
begin
  if (wb_rst_i28)
  begin
	tstate28       <= #1 s_idle28;
	stx_o_tmp28       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out28   <= #1 7'b0;
	bit_out28     <= #1 1'b0;
	parity_xor28  <= #1 1'b0;
	tf_pop28      <= #1 1'b0;
	bit_counter28 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate28)
	s_idle28	 :	if (~|tf_count28) // if tf_count28==0
			begin
				tstate28 <= #1 s_idle28;
				stx_o_tmp28 <= #1 1'b1;
			end
			else
			begin
				tf_pop28 <= #1 1'b0;
				stx_o_tmp28  <= #1 1'b1;
				tstate28  <= #1 s_pop_byte28;
			end
	s_pop_byte28 :	begin
				tf_pop28 <= #1 1'b1;
				case (lcr28[/*`UART_LC_BITS28*/1:0])  // number28 of bits in a word28
				2'b00 : begin
					bit_counter28 <= #1 3'b100;
					parity_xor28  <= #1 ^tf_data_out28[4:0];
				     end
				2'b01 : begin
					bit_counter28 <= #1 3'b101;
					parity_xor28  <= #1 ^tf_data_out28[5:0];
				     end
				2'b10 : begin
					bit_counter28 <= #1 3'b110;
					parity_xor28  <= #1 ^tf_data_out28[6:0];
				     end
				2'b11 : begin
					bit_counter28 <= #1 3'b111;
					parity_xor28  <= #1 ^tf_data_out28[7:0];
				     end
				endcase
				{shift_out28[6:0], bit_out28} <= #1 tf_data_out28;
				tstate28 <= #1 s_send_start28;
			end
	s_send_start28 :	begin
				tf_pop28 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate28 <= #1 s_send_byte28;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp28 <= #1 1'b0;
			end
	s_send_byte28 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter28 > 3'b0)
					begin
						bit_counter28 <= #1 bit_counter28 - 1'b1;
						{shift_out28[5:0],bit_out28  } <= #1 {shift_out28[6:1], shift_out28[0]};
						tstate28 <= #1 s_send_byte28;
					end
					else   // end of byte
					if (~lcr28[`UART_LC_PE28])
					begin
						tstate28 <= #1 s_send_stop28;
					end
					else
					begin
						case ({lcr28[`UART_LC_EP28],lcr28[`UART_LC_SP28]})
						2'b00:	bit_out28 <= #1 ~parity_xor28;
						2'b01:	bit_out28 <= #1 1'b1;
						2'b10:	bit_out28 <= #1 parity_xor28;
						2'b11:	bit_out28 <= #1 1'b0;
						endcase
						tstate28 <= #1 s_send_parity28;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp28 <= #1 bit_out28; // set output pin28
			end
	s_send_parity28 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate28 <= #1 s_send_stop28;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp28 <= #1 bit_out28;
			end
	s_send_stop28 :  begin
				if (~|counter)
				  begin
						casex ({lcr28[`UART_LC_SB28],lcr28[`UART_LC_BITS28]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor28
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate28 <= #1 s_idle28;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp28 <= #1 1'b1;
			end

		default : // should never get here28
			tstate28 <= #1 s_idle28;
	endcase
  end // end if enable
  else
    tf_pop28 <= #1 1'b0;  // tf_pop28 must be 1 cycle width
end // transmitter28 logic

assign stx_pad_o28 = lcr28[`UART_LC_BC28] ? 1'b0 : stx_o_tmp28;    // Break28 condition
	
endmodule
