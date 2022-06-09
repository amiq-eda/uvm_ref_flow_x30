//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter12.v                                          ////
////                                                              ////
////                                                              ////
////  This12 file is part of the "UART12 16550 compatible12" project12    ////
////  http12://www12.opencores12.org12/cores12/uart1655012/                   ////
////                                                              ////
////  Documentation12 related12 to this project12:                      ////
////  - http12://www12.opencores12.org12/cores12/uart1655012/                 ////
////                                                              ////
////  Projects12 compatibility12:                                     ////
////  - WISHBONE12                                                  ////
////  RS23212 Protocol12                                              ////
////  16550D uart12 (mostly12 supported)                              ////
////                                                              ////
////  Overview12 (main12 Features12):                                   ////
////  UART12 core12 transmitter12 logic                                 ////
////                                                              ////
////  Known12 problems12 (limits12):                                    ////
////  None12 known12                                                  ////
////                                                              ////
////  To12 Do12:                                                      ////
////  Thourough12 testing12.                                          ////
////                                                              ////
////  Author12(s):                                                  ////
////      - gorban12@opencores12.org12                                  ////
////      - Jacob12 Gorban12                                          ////
////      - Igor12 Mohor12 (igorm12@opencores12.org12)                      ////
////                                                              ////
////  Created12:        2001/05/12                                  ////
////  Last12 Updated12:   2001/05/17                                  ////
////                  (See log12 for the revision12 history12)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright12 (C) 2000, 2001 Authors12                             ////
////                                                              ////
//// This12 source12 file may be used and distributed12 without         ////
//// restriction12 provided that this copyright12 statement12 is not    ////
//// removed from the file and that any derivative12 work12 contains12  ////
//// the original copyright12 notice12 and the associated disclaimer12. ////
////                                                              ////
//// This12 source12 file is free software12; you can redistribute12 it   ////
//// and/or modify it under the terms12 of the GNU12 Lesser12 General12   ////
//// Public12 License12 as published12 by the Free12 Software12 Foundation12; ////
//// either12 version12 2.1 of the License12, or (at your12 option) any   ////
//// later12 version12.                                               ////
////                                                              ////
//// This12 source12 is distributed12 in the hope12 that it will be       ////
//// useful12, but WITHOUT12 ANY12 WARRANTY12; without even12 the implied12   ////
//// warranty12 of MERCHANTABILITY12 or FITNESS12 FOR12 A PARTICULAR12      ////
//// PURPOSE12.  See the GNU12 Lesser12 General12 Public12 License12 for more ////
//// details12.                                                     ////
////                                                              ////
//// You should have received12 a copy of the GNU12 Lesser12 General12    ////
//// Public12 License12 along12 with this source12; if not, download12 it   ////
//// from http12://www12.opencores12.org12/lgpl12.shtml12                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS12 Revision12 History12
//
// $Log: not supported by cvs2svn12 $
// Revision12 1.18  2002/07/22 23:02:23  gorban12
// Bug12 Fixes12:
//  * Possible12 loss of sync and bad12 reception12 of stop bit on slow12 baud12 rates12 fixed12.
//   Problem12 reported12 by Kenny12.Tung12.
//  * Bad (or lack12 of ) loopback12 handling12 fixed12. Reported12 by Cherry12 Withers12.
//
// Improvements12:
//  * Made12 FIFO's as general12 inferrable12 memory where possible12.
//  So12 on FPGA12 they should be inferred12 as RAM12 (Distributed12 RAM12 on Xilinx12).
//  This12 saves12 about12 1/3 of the Slice12 count and reduces12 P&R and synthesis12 times.
//
//  * Added12 optional12 baudrate12 output (baud_o12).
//  This12 is identical12 to BAUDOUT12* signal12 on 16550 chip12.
//  It outputs12 16xbit_clock_rate - the divided12 clock12.
//  It's disabled by default. Define12 UART_HAS_BAUDRATE_OUTPUT12 to use.
//
// Revision12 1.16  2002/01/08 11:29:40  mohor12
// tf_pop12 was too wide12. Now12 it is only 1 clk12 cycle width.
//
// Revision12 1.15  2001/12/17 14:46:48  mohor12
// overrun12 signal12 was moved to separate12 block because many12 sequential12 lsr12
// reads were12 preventing12 data from being written12 to rx12 fifo.
// underrun12 signal12 was not used and was removed from the project12.
//
// Revision12 1.14  2001/12/03 21:44:29  gorban12
// Updated12 specification12 documentation.
// Added12 full 32-bit data bus interface, now as default.
// Address is 5-bit wide12 in 32-bit data bus mode.
// Added12 wb_sel_i12 input to the core12. It's used in the 32-bit mode.
// Added12 debug12 interface with two12 32-bit read-only registers in 32-bit mode.
// Bits12 5 and 6 of LSR12 are now only cleared12 on TX12 FIFO write.
// My12 small test bench12 is modified to work12 with 32-bit mode.
//
// Revision12 1.13  2001/11/08 14:54:23  mohor12
// Comments12 in Slovene12 language12 deleted12, few12 small fixes12 for better12 work12 of
// old12 tools12. IRQs12 need to be fix12.
//
// Revision12 1.12  2001/11/07 17:51:52  gorban12
// Heavily12 rewritten12 interrupt12 and LSR12 subsystems12.
// Many12 bugs12 hopefully12 squashed12.
//
// Revision12 1.11  2001/10/29 17:00:46  gorban12
// fixed12 parity12 sending12 and tx_fifo12 resets12 over- and underrun12
//
// Revision12 1.10  2001/10/20 09:58:40  gorban12
// Small12 synopsis12 fixes12
//
// Revision12 1.9  2001/08/24 21:01:12  mohor12
// Things12 connected12 to parity12 changed.
// Clock12 devider12 changed.
//
// Revision12 1.8  2001/08/23 16:05:05  mohor12
// Stop bit bug12 fixed12.
// Parity12 bug12 fixed12.
// WISHBONE12 read cycle bug12 fixed12,
// OE12 indicator12 (Overrun12 Error) bug12 fixed12.
// PE12 indicator12 (Parity12 Error) bug12 fixed12.
// Register read bug12 fixed12.
//
// Revision12 1.6  2001/06/23 11:21:48  gorban12
// DL12 made12 16-bit long12. Fixed12 transmission12/reception12 bugs12.
//
// Revision12 1.5  2001/06/02 14:28:14  gorban12
// Fixed12 receiver12 and transmitter12. Major12 bug12 fixed12.
//
// Revision12 1.4  2001/05/31 20:08:01  gorban12
// FIFO changes12 and other corrections12.
//
// Revision12 1.3  2001/05/27 17:37:49  gorban12
// Fixed12 many12 bugs12. Updated12 spec12. Changed12 FIFO files structure12. See CHANGES12.txt12 file.
//
// Revision12 1.2  2001/05/21 19:12:02  gorban12
// Corrected12 some12 Linter12 messages12.
//
// Revision12 1.1  2001/05/17 18:34:18  gorban12
// First12 'stable' release. Should12 be sythesizable12 now. Also12 added new header.
//
// Revision12 1.0  2001-05-17 21:27:12+02  jacob12
// Initial12 revision12
//
//

// synopsys12 translate_off12
`include "timescale.v"
// synopsys12 translate_on12

`include "uart_defines12.v"

module uart_transmitter12 (clk12, wb_rst_i12, lcr12, tf_push12, wb_dat_i12, enable,	stx_pad_o12, tstate12, tf_count12, tx_reset12, lsr_mask12);

input 										clk12;
input 										wb_rst_i12;
input [7:0] 								lcr12;
input 										tf_push12;
input [7:0] 								wb_dat_i12;
input 										enable;
input 										tx_reset12;
input 										lsr_mask12; //reset of fifo
output 										stx_pad_o12;
output [2:0] 								tstate12;
output [`UART_FIFO_COUNTER_W12-1:0] 	tf_count12;

reg [2:0] 									tstate12;
reg [4:0] 									counter;
reg [2:0] 									bit_counter12;   // counts12 the bits to be sent12
reg [6:0] 									shift_out12;	// output shift12 register
reg 											stx_o_tmp12;
reg 											parity_xor12;  // parity12 of the word12
reg 											tf_pop12;
reg 											bit_out12;

// TX12 FIFO instance
//
// Transmitter12 FIFO signals12
wire [`UART_FIFO_WIDTH12-1:0] 			tf_data_in12;
wire [`UART_FIFO_WIDTH12-1:0] 			tf_data_out12;
wire 											tf_push12;
wire 											tf_overrun12;
wire [`UART_FIFO_COUNTER_W12-1:0] 		tf_count12;

assign 										tf_data_in12 = wb_dat_i12;

uart_tfifo12 fifo_tx12(	// error bit signal12 is not used in transmitter12 FIFO
	.clk12(		clk12		), 
	.wb_rst_i12(	wb_rst_i12	),
	.data_in12(	tf_data_in12	),
	.data_out12(	tf_data_out12	),
	.push12(		tf_push12		),
	.pop12(		tf_pop12		),
	.overrun12(	tf_overrun12	),
	.count(		tf_count12	),
	.fifo_reset12(	tx_reset12	),
	.reset_status12(lsr_mask12)
);

// TRANSMITTER12 FINAL12 STATE12 MACHINE12

parameter s_idle12        = 3'd0;
parameter s_send_start12  = 3'd1;
parameter s_send_byte12   = 3'd2;
parameter s_send_parity12 = 3'd3;
parameter s_send_stop12   = 3'd4;
parameter s_pop_byte12    = 3'd5;

always @(posedge clk12 or posedge wb_rst_i12)
begin
  if (wb_rst_i12)
  begin
	tstate12       <= #1 s_idle12;
	stx_o_tmp12       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out12   <= #1 7'b0;
	bit_out12     <= #1 1'b0;
	parity_xor12  <= #1 1'b0;
	tf_pop12      <= #1 1'b0;
	bit_counter12 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate12)
	s_idle12	 :	if (~|tf_count12) // if tf_count12==0
			begin
				tstate12 <= #1 s_idle12;
				stx_o_tmp12 <= #1 1'b1;
			end
			else
			begin
				tf_pop12 <= #1 1'b0;
				stx_o_tmp12  <= #1 1'b1;
				tstate12  <= #1 s_pop_byte12;
			end
	s_pop_byte12 :	begin
				tf_pop12 <= #1 1'b1;
				case (lcr12[/*`UART_LC_BITS12*/1:0])  // number12 of bits in a word12
				2'b00 : begin
					bit_counter12 <= #1 3'b100;
					parity_xor12  <= #1 ^tf_data_out12[4:0];
				     end
				2'b01 : begin
					bit_counter12 <= #1 3'b101;
					parity_xor12  <= #1 ^tf_data_out12[5:0];
				     end
				2'b10 : begin
					bit_counter12 <= #1 3'b110;
					parity_xor12  <= #1 ^tf_data_out12[6:0];
				     end
				2'b11 : begin
					bit_counter12 <= #1 3'b111;
					parity_xor12  <= #1 ^tf_data_out12[7:0];
				     end
				endcase
				{shift_out12[6:0], bit_out12} <= #1 tf_data_out12;
				tstate12 <= #1 s_send_start12;
			end
	s_send_start12 :	begin
				tf_pop12 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate12 <= #1 s_send_byte12;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp12 <= #1 1'b0;
			end
	s_send_byte12 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter12 > 3'b0)
					begin
						bit_counter12 <= #1 bit_counter12 - 1'b1;
						{shift_out12[5:0],bit_out12  } <= #1 {shift_out12[6:1], shift_out12[0]};
						tstate12 <= #1 s_send_byte12;
					end
					else   // end of byte
					if (~lcr12[`UART_LC_PE12])
					begin
						tstate12 <= #1 s_send_stop12;
					end
					else
					begin
						case ({lcr12[`UART_LC_EP12],lcr12[`UART_LC_SP12]})
						2'b00:	bit_out12 <= #1 ~parity_xor12;
						2'b01:	bit_out12 <= #1 1'b1;
						2'b10:	bit_out12 <= #1 parity_xor12;
						2'b11:	bit_out12 <= #1 1'b0;
						endcase
						tstate12 <= #1 s_send_parity12;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp12 <= #1 bit_out12; // set output pin12
			end
	s_send_parity12 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate12 <= #1 s_send_stop12;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp12 <= #1 bit_out12;
			end
	s_send_stop12 :  begin
				if (~|counter)
				  begin
						casex ({lcr12[`UART_LC_SB12],lcr12[`UART_LC_BITS12]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor12
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate12 <= #1 s_idle12;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp12 <= #1 1'b1;
			end

		default : // should never get here12
			tstate12 <= #1 s_idle12;
	endcase
  end // end if enable
  else
    tf_pop12 <= #1 1'b0;  // tf_pop12 must be 1 cycle width
end // transmitter12 logic

assign stx_pad_o12 = lcr12[`UART_LC_BC12] ? 1'b0 : stx_o_tmp12;    // Break12 condition
	
endmodule
