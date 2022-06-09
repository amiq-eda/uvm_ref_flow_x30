//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_transmitter5.v                                          ////
////                                                              ////
////                                                              ////
////  This5 file is part of the "UART5 16550 compatible5" project5    ////
////  http5://www5.opencores5.org5/cores5/uart165505/                   ////
////                                                              ////
////  Documentation5 related5 to this project5:                      ////
////  - http5://www5.opencores5.org5/cores5/uart165505/                 ////
////                                                              ////
////  Projects5 compatibility5:                                     ////
////  - WISHBONE5                                                  ////
////  RS2325 Protocol5                                              ////
////  16550D uart5 (mostly5 supported)                              ////
////                                                              ////
////  Overview5 (main5 Features5):                                   ////
////  UART5 core5 transmitter5 logic                                 ////
////                                                              ////
////  Known5 problems5 (limits5):                                    ////
////  None5 known5                                                  ////
////                                                              ////
////  To5 Do5:                                                      ////
////  Thourough5 testing5.                                          ////
////                                                              ////
////  Author5(s):                                                  ////
////      - gorban5@opencores5.org5                                  ////
////      - Jacob5 Gorban5                                          ////
////      - Igor5 Mohor5 (igorm5@opencores5.org5)                      ////
////                                                              ////
////  Created5:        2001/05/12                                  ////
////  Last5 Updated5:   2001/05/17                                  ////
////                  (See log5 for the revision5 history5)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2000, 2001 Authors5                             ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS5 Revision5 History5
//
// $Log: not supported by cvs2svn5 $
// Revision5 1.18  2002/07/22 23:02:23  gorban5
// Bug5 Fixes5:
//  * Possible5 loss of sync and bad5 reception5 of stop bit on slow5 baud5 rates5 fixed5.
//   Problem5 reported5 by Kenny5.Tung5.
//  * Bad (or lack5 of ) loopback5 handling5 fixed5. Reported5 by Cherry5 Withers5.
//
// Improvements5:
//  * Made5 FIFO's as general5 inferrable5 memory where possible5.
//  So5 on FPGA5 they should be inferred5 as RAM5 (Distributed5 RAM5 on Xilinx5).
//  This5 saves5 about5 1/3 of the Slice5 count and reduces5 P&R and synthesis5 times.
//
//  * Added5 optional5 baudrate5 output (baud_o5).
//  This5 is identical5 to BAUDOUT5* signal5 on 16550 chip5.
//  It outputs5 16xbit_clock_rate - the divided5 clock5.
//  It's disabled by default. Define5 UART_HAS_BAUDRATE_OUTPUT5 to use.
//
// Revision5 1.16  2002/01/08 11:29:40  mohor5
// tf_pop5 was too wide5. Now5 it is only 1 clk5 cycle width.
//
// Revision5 1.15  2001/12/17 14:46:48  mohor5
// overrun5 signal5 was moved to separate5 block because many5 sequential5 lsr5
// reads were5 preventing5 data from being written5 to rx5 fifo.
// underrun5 signal5 was not used and was removed from the project5.
//
// Revision5 1.14  2001/12/03 21:44:29  gorban5
// Updated5 specification5 documentation.
// Added5 full 32-bit data bus interface, now as default.
// Address is 5-bit wide5 in 32-bit data bus mode.
// Added5 wb_sel_i5 input to the core5. It's used in the 32-bit mode.
// Added5 debug5 interface with two5 32-bit read-only registers in 32-bit mode.
// Bits5 5 and 6 of LSR5 are now only cleared5 on TX5 FIFO write.
// My5 small test bench5 is modified to work5 with 32-bit mode.
//
// Revision5 1.13  2001/11/08 14:54:23  mohor5
// Comments5 in Slovene5 language5 deleted5, few5 small fixes5 for better5 work5 of
// old5 tools5. IRQs5 need to be fix5.
//
// Revision5 1.12  2001/11/07 17:51:52  gorban5
// Heavily5 rewritten5 interrupt5 and LSR5 subsystems5.
// Many5 bugs5 hopefully5 squashed5.
//
// Revision5 1.11  2001/10/29 17:00:46  gorban5
// fixed5 parity5 sending5 and tx_fifo5 resets5 over- and underrun5
//
// Revision5 1.10  2001/10/20 09:58:40  gorban5
// Small5 synopsis5 fixes5
//
// Revision5 1.9  2001/08/24 21:01:12  mohor5
// Things5 connected5 to parity5 changed.
// Clock5 devider5 changed.
//
// Revision5 1.8  2001/08/23 16:05:05  mohor5
// Stop bit bug5 fixed5.
// Parity5 bug5 fixed5.
// WISHBONE5 read cycle bug5 fixed5,
// OE5 indicator5 (Overrun5 Error) bug5 fixed5.
// PE5 indicator5 (Parity5 Error) bug5 fixed5.
// Register read bug5 fixed5.
//
// Revision5 1.6  2001/06/23 11:21:48  gorban5
// DL5 made5 16-bit long5. Fixed5 transmission5/reception5 bugs5.
//
// Revision5 1.5  2001/06/02 14:28:14  gorban5
// Fixed5 receiver5 and transmitter5. Major5 bug5 fixed5.
//
// Revision5 1.4  2001/05/31 20:08:01  gorban5
// FIFO changes5 and other corrections5.
//
// Revision5 1.3  2001/05/27 17:37:49  gorban5
// Fixed5 many5 bugs5. Updated5 spec5. Changed5 FIFO files structure5. See CHANGES5.txt5 file.
//
// Revision5 1.2  2001/05/21 19:12:02  gorban5
// Corrected5 some5 Linter5 messages5.
//
// Revision5 1.1  2001/05/17 18:34:18  gorban5
// First5 'stable' release. Should5 be sythesizable5 now. Also5 added new header.
//
// Revision5 1.0  2001-05-17 21:27:12+02  jacob5
// Initial5 revision5
//
//

// synopsys5 translate_off5
`include "timescale.v"
// synopsys5 translate_on5

`include "uart_defines5.v"

module uart_transmitter5 (clk5, wb_rst_i5, lcr5, tf_push5, wb_dat_i5, enable,	stx_pad_o5, tstate5, tf_count5, tx_reset5, lsr_mask5);

input 										clk5;
input 										wb_rst_i5;
input [7:0] 								lcr5;
input 										tf_push5;
input [7:0] 								wb_dat_i5;
input 										enable;
input 										tx_reset5;
input 										lsr_mask5; //reset of fifo
output 										stx_pad_o5;
output [2:0] 								tstate5;
output [`UART_FIFO_COUNTER_W5-1:0] 	tf_count5;

reg [2:0] 									tstate5;
reg [4:0] 									counter;
reg [2:0] 									bit_counter5;   // counts5 the bits to be sent5
reg [6:0] 									shift_out5;	// output shift5 register
reg 											stx_o_tmp5;
reg 											parity_xor5;  // parity5 of the word5
reg 											tf_pop5;
reg 											bit_out5;

// TX5 FIFO instance
//
// Transmitter5 FIFO signals5
wire [`UART_FIFO_WIDTH5-1:0] 			tf_data_in5;
wire [`UART_FIFO_WIDTH5-1:0] 			tf_data_out5;
wire 											tf_push5;
wire 											tf_overrun5;
wire [`UART_FIFO_COUNTER_W5-1:0] 		tf_count5;

assign 										tf_data_in5 = wb_dat_i5;

uart_tfifo5 fifo_tx5(	// error bit signal5 is not used in transmitter5 FIFO
	.clk5(		clk5		), 
	.wb_rst_i5(	wb_rst_i5	),
	.data_in5(	tf_data_in5	),
	.data_out5(	tf_data_out5	),
	.push5(		tf_push5		),
	.pop5(		tf_pop5		),
	.overrun5(	tf_overrun5	),
	.count(		tf_count5	),
	.fifo_reset5(	tx_reset5	),
	.reset_status5(lsr_mask5)
);

// TRANSMITTER5 FINAL5 STATE5 MACHINE5

parameter s_idle5        = 3'd0;
parameter s_send_start5  = 3'd1;
parameter s_send_byte5   = 3'd2;
parameter s_send_parity5 = 3'd3;
parameter s_send_stop5   = 3'd4;
parameter s_pop_byte5    = 3'd5;

always @(posedge clk5 or posedge wb_rst_i5)
begin
  if (wb_rst_i5)
  begin
	tstate5       <= #1 s_idle5;
	stx_o_tmp5       <= #1 1'b1;
	counter   <= #1 5'b0;
	shift_out5   <= #1 7'b0;
	bit_out5     <= #1 1'b0;
	parity_xor5  <= #1 1'b0;
	tf_pop5      <= #1 1'b0;
	bit_counter5 <= #1 3'b0;
  end
  else
  if (enable)
  begin
	case (tstate5)
	s_idle5	 :	if (~|tf_count5) // if tf_count5==0
			begin
				tstate5 <= #1 s_idle5;
				stx_o_tmp5 <= #1 1'b1;
			end
			else
			begin
				tf_pop5 <= #1 1'b0;
				stx_o_tmp5  <= #1 1'b1;
				tstate5  <= #1 s_pop_byte5;
			end
	s_pop_byte5 :	begin
				tf_pop5 <= #1 1'b1;
				case (lcr5[/*`UART_LC_BITS5*/1:0])  // number5 of bits in a word5
				2'b00 : begin
					bit_counter5 <= #1 3'b100;
					parity_xor5  <= #1 ^tf_data_out5[4:0];
				     end
				2'b01 : begin
					bit_counter5 <= #1 3'b101;
					parity_xor5  <= #1 ^tf_data_out5[5:0];
				     end
				2'b10 : begin
					bit_counter5 <= #1 3'b110;
					parity_xor5  <= #1 ^tf_data_out5[6:0];
				     end
				2'b11 : begin
					bit_counter5 <= #1 3'b111;
					parity_xor5  <= #1 ^tf_data_out5[7:0];
				     end
				endcase
				{shift_out5[6:0], bit_out5} <= #1 tf_data_out5;
				tstate5 <= #1 s_send_start5;
			end
	s_send_start5 :	begin
				tf_pop5 <= #1 1'b0;
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate5 <= #1 s_send_byte5;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp5 <= #1 1'b0;
			end
	s_send_byte5 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					if (bit_counter5 > 3'b0)
					begin
						bit_counter5 <= #1 bit_counter5 - 1'b1;
						{shift_out5[5:0],bit_out5  } <= #1 {shift_out5[6:1], shift_out5[0]};
						tstate5 <= #1 s_send_byte5;
					end
					else   // end of byte
					if (~lcr5[`UART_LC_PE5])
					begin
						tstate5 <= #1 s_send_stop5;
					end
					else
					begin
						case ({lcr5[`UART_LC_EP5],lcr5[`UART_LC_SP5]})
						2'b00:	bit_out5 <= #1 ~parity_xor5;
						2'b01:	bit_out5 <= #1 1'b1;
						2'b10:	bit_out5 <= #1 parity_xor5;
						2'b11:	bit_out5 <= #1 1'b0;
						endcase
						tstate5 <= #1 s_send_parity5;
					end
					counter <= #1 0;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp5 <= #1 bit_out5; // set output pin5
			end
	s_send_parity5 :	begin
				if (~|counter)
					counter <= #1 5'b01111;
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 4'b0;
					tstate5 <= #1 s_send_stop5;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp5 <= #1 bit_out5;
			end
	s_send_stop5 :  begin
				if (~|counter)
				  begin
						casex ({lcr5[`UART_LC_SB5],lcr5[`UART_LC_BITS5]})
  						3'b0xx:	  counter <= #1 5'b01101;     // 1 stop bit ok igor5
  						3'b100:	  counter <= #1 5'b10101;     // 1.5 stop bit
  						default:	  counter <= #1 5'b11101;     // 2 stop bits
						endcase
					end
				else
				if (counter == 5'b00001)
				begin
					counter <= #1 0;
					tstate5 <= #1 s_idle5;
				end
				else
					counter <= #1 counter - 1'b1;
				stx_o_tmp5 <= #1 1'b1;
			end

		default : // should never get here5
			tstate5 <= #1 s_idle5;
	endcase
  end // end if enable
  else
    tf_pop5 <= #1 1'b0;  // tf_pop5 must be 1 cycle width
end // transmitter5 logic

assign stx_pad_o5 = lcr5[`UART_LC_BC5] ? 1'b0 : stx_o_tmp5;    // Break5 condition
	
endmodule
