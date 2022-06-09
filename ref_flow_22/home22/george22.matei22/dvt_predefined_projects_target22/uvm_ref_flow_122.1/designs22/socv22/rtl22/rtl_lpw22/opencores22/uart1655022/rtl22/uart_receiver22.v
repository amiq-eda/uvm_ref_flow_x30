//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver22.v                                             ////
////                                                              ////
////                                                              ////
////  This22 file is part of the "UART22 16550 compatible22" project22    ////
////  http22://www22.opencores22.org22/cores22/uart1655022/                   ////
////                                                              ////
////  Documentation22 related22 to this project22:                      ////
////  - http22://www22.opencores22.org22/cores22/uart1655022/                 ////
////                                                              ////
////  Projects22 compatibility22:                                     ////
////  - WISHBONE22                                                  ////
////  RS23222 Protocol22                                              ////
////  16550D uart22 (mostly22 supported)                              ////
////                                                              ////
////  Overview22 (main22 Features22):                                   ////
////  UART22 core22 receiver22 logic                                    ////
////                                                              ////
////  Known22 problems22 (limits22):                                    ////
////  None22 known22                                                  ////
////                                                              ////
////  To22 Do22:                                                      ////
////  Thourough22 testing22.                                          ////
////                                                              ////
////  Author22(s):                                                  ////
////      - gorban22@opencores22.org22                                  ////
////      - Jacob22 Gorban22                                          ////
////      - Igor22 Mohor22 (igorm22@opencores22.org22)                      ////
////                                                              ////
////  Created22:        2001/05/12                                  ////
////  Last22 Updated22:   2001/05/17                                  ////
////                  (See log22 for the revision22 history22)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2000, 2001 Authors22                             ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS22 Revision22 History22
//
// $Log: not supported by cvs2svn22 $
// Revision22 1.29  2002/07/29 21:16:18  gorban22
// The uart_defines22.v file is included22 again22 in sources22.
//
// Revision22 1.28  2002/07/22 23:02:23  gorban22
// Bug22 Fixes22:
//  * Possible22 loss of sync and bad22 reception22 of stop bit on slow22 baud22 rates22 fixed22.
//   Problem22 reported22 by Kenny22.Tung22.
//  * Bad (or lack22 of ) loopback22 handling22 fixed22. Reported22 by Cherry22 Withers22.
//
// Improvements22:
//  * Made22 FIFO's as general22 inferrable22 memory where possible22.
//  So22 on FPGA22 they should be inferred22 as RAM22 (Distributed22 RAM22 on Xilinx22).
//  This22 saves22 about22 1/3 of the Slice22 count and reduces22 P&R and synthesis22 times.
//
//  * Added22 optional22 baudrate22 output (baud_o22).
//  This22 is identical22 to BAUDOUT22* signal22 on 16550 chip22.
//  It outputs22 16xbit_clock_rate - the divided22 clock22.
//  It's disabled by default. Define22 UART_HAS_BAUDRATE_OUTPUT22 to use.
//
// Revision22 1.27  2001/12/30 20:39:13  mohor22
// More than one character22 was stored22 in case of break. End22 of the break
// was not detected correctly.
//
// Revision22 1.26  2001/12/20 13:28:27  mohor22
// Missing22 declaration22 of rf_push_q22 fixed22.
//
// Revision22 1.25  2001/12/20 13:25:46  mohor22
// rx22 push22 changed to be only one cycle wide22.
//
// Revision22 1.24  2001/12/19 08:03:34  mohor22
// Warnings22 cleared22.
//
// Revision22 1.23  2001/12/19 07:33:54  mohor22
// Synplicity22 was having22 troubles22 with the comment22.
//
// Revision22 1.22  2001/12/17 14:46:48  mohor22
// overrun22 signal22 was moved to separate22 block because many22 sequential22 lsr22
// reads were22 preventing22 data from being written22 to rx22 fifo.
// underrun22 signal22 was not used and was removed from the project22.
//
// Revision22 1.21  2001/12/13 10:31:16  mohor22
// timeout irq22 must be set regardless22 of the rda22 irq22 (rda22 irq22 does not reset the
// timeout counter).
//
// Revision22 1.20  2001/12/10 19:52:05  gorban22
// Igor22 fixed22 break condition bugs22
//
// Revision22 1.19  2001/12/06 14:51:04  gorban22
// Bug22 in LSR22[0] is fixed22.
// All WISHBONE22 signals22 are now sampled22, so another22 wait-state is introduced22 on all transfers22.
//
// Revision22 1.18  2001/12/03 21:44:29  gorban22
// Updated22 specification22 documentation.
// Added22 full 32-bit data bus interface, now as default.
// Address is 5-bit wide22 in 32-bit data bus mode.
// Added22 wb_sel_i22 input to the core22. It's used in the 32-bit mode.
// Added22 debug22 interface with two22 32-bit read-only registers in 32-bit mode.
// Bits22 5 and 6 of LSR22 are now only cleared22 on TX22 FIFO write.
// My22 small test bench22 is modified to work22 with 32-bit mode.
//
// Revision22 1.17  2001/11/28 19:36:39  gorban22
// Fixed22: timeout and break didn22't pay22 attention22 to current data format22 when counting22 time
//
// Revision22 1.16  2001/11/27 22:17:09  gorban22
// Fixed22 bug22 that prevented22 synthesis22 in uart_receiver22.v
//
// Revision22 1.15  2001/11/26 21:38:54  gorban22
// Lots22 of fixes22:
// Break22 condition wasn22't handled22 correctly at all.
// LSR22 bits could lose22 their22 values.
// LSR22 value after reset was wrong22.
// Timing22 of THRE22 interrupt22 signal22 corrected22.
// LSR22 bit 0 timing22 corrected22.
//
// Revision22 1.14  2001/11/10 12:43:21  gorban22
// Logic22 Synthesis22 bugs22 fixed22. Some22 other minor22 changes22
//
// Revision22 1.13  2001/11/08 14:54:23  mohor22
// Comments22 in Slovene22 language22 deleted22, few22 small fixes22 for better22 work22 of
// old22 tools22. IRQs22 need to be fix22.
//
// Revision22 1.12  2001/11/07 17:51:52  gorban22
// Heavily22 rewritten22 interrupt22 and LSR22 subsystems22.
// Many22 bugs22 hopefully22 squashed22.
//
// Revision22 1.11  2001/10/31 15:19:22  gorban22
// Fixes22 to break and timeout conditions22
//
// Revision22 1.10  2001/10/20 09:58:40  gorban22
// Small22 synopsis22 fixes22
//
// Revision22 1.9  2001/08/24 21:01:12  mohor22
// Things22 connected22 to parity22 changed.
// Clock22 devider22 changed.
//
// Revision22 1.8  2001/08/23 16:05:05  mohor22
// Stop bit bug22 fixed22.
// Parity22 bug22 fixed22.
// WISHBONE22 read cycle bug22 fixed22,
// OE22 indicator22 (Overrun22 Error) bug22 fixed22.
// PE22 indicator22 (Parity22 Error) bug22 fixed22.
// Register read bug22 fixed22.
//
// Revision22 1.6  2001/06/23 11:21:48  gorban22
// DL22 made22 16-bit long22. Fixed22 transmission22/reception22 bugs22.
//
// Revision22 1.5  2001/06/02 14:28:14  gorban22
// Fixed22 receiver22 and transmitter22. Major22 bug22 fixed22.
//
// Revision22 1.4  2001/05/31 20:08:01  gorban22
// FIFO changes22 and other corrections22.
//
// Revision22 1.3  2001/05/27 17:37:49  gorban22
// Fixed22 many22 bugs22. Updated22 spec22. Changed22 FIFO files structure22. See CHANGES22.txt22 file.
//
// Revision22 1.2  2001/05/21 19:12:02  gorban22
// Corrected22 some22 Linter22 messages22.
//
// Revision22 1.1  2001/05/17 18:34:18  gorban22
// First22 'stable' release. Should22 be sythesizable22 now. Also22 added new header.
//
// Revision22 1.0  2001-05-17 21:27:11+02  jacob22
// Initial22 revision22
//
//

// synopsys22 translate_off22
`include "timescale.v"
// synopsys22 translate_on22

`include "uart_defines22.v"

module uart_receiver22 (clk22, wb_rst_i22, lcr22, rf_pop22, srx_pad_i22, enable, 
	counter_t22, rf_count22, rf_data_out22, rf_error_bit22, rf_overrun22, rx_reset22, lsr_mask22, rstate, rf_push_pulse22);

input				clk22;
input				wb_rst_i22;
input	[7:0]	lcr22;
input				rf_pop22;
input				srx_pad_i22;
input				enable;
input				rx_reset22;
input       lsr_mask22;

output	[9:0]			counter_t22;
output	[`UART_FIFO_COUNTER_W22-1:0]	rf_count22;
output	[`UART_FIFO_REC_WIDTH22-1:0]	rf_data_out22;
output				rf_overrun22;
output				rf_error_bit22;
output [3:0] 		rstate;
output 				rf_push_pulse22;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1622;
reg	[2:0]	rbit_counter22;
reg	[7:0]	rshift22;			// receiver22 shift22 register
reg		rparity22;		// received22 parity22
reg		rparity_error22;
reg		rframing_error22;		// framing22 error flag22
reg		rbit_in22;
reg		rparity_xor22;
reg	[7:0]	counter_b22;	// counts22 the 0 (low22) signals22
reg   rf_push_q22;

// RX22 FIFO signals22
reg	[`UART_FIFO_REC_WIDTH22-1:0]	rf_data_in22;
wire	[`UART_FIFO_REC_WIDTH22-1:0]	rf_data_out22;
wire      rf_push_pulse22;
reg				rf_push22;
wire				rf_pop22;
wire				rf_overrun22;
wire	[`UART_FIFO_COUNTER_W22-1:0]	rf_count22;
wire				rf_error_bit22; // an error (parity22 or framing22) is inside the fifo
wire 				break_error22 = (counter_b22 == 0);

// RX22 FIFO instance
uart_rfifo22 #(`UART_FIFO_REC_WIDTH22) fifo_rx22(
	.clk22(		clk22		), 
	.wb_rst_i22(	wb_rst_i22	),
	.data_in22(	rf_data_in22	),
	.data_out22(	rf_data_out22	),
	.push22(		rf_push_pulse22		),
	.pop22(		rf_pop22		),
	.overrun22(	rf_overrun22	),
	.count(		rf_count22	),
	.error_bit22(	rf_error_bit22	),
	.fifo_reset22(	rx_reset22	),
	.reset_status22(lsr_mask22)
);

wire 		rcounter16_eq_722 = (rcounter1622 == 4'd7);
wire		rcounter16_eq_022 = (rcounter1622 == 4'd0);
wire		rcounter16_eq_122 = (rcounter1622 == 4'd1);

wire [3:0] rcounter16_minus_122 = rcounter1622 - 1'b1;

parameter  sr_idle22 					= 4'd0;
parameter  sr_rec_start22 			= 4'd1;
parameter  sr_rec_bit22 				= 4'd2;
parameter  sr_rec_parity22			= 4'd3;
parameter  sr_rec_stop22 				= 4'd4;
parameter  sr_check_parity22 		= 4'd5;
parameter  sr_rec_prepare22 			= 4'd6;
parameter  sr_end_bit22				= 4'd7;
parameter  sr_ca_lc_parity22	      = 4'd8;
parameter  sr_wait122 					= 4'd9;
parameter  sr_push22 					= 4'd10;


always @(posedge clk22 or posedge wb_rst_i22)
begin
  if (wb_rst_i22)
  begin
     rstate 			<= #1 sr_idle22;
	  rbit_in22 				<= #1 1'b0;
	  rcounter1622 			<= #1 0;
	  rbit_counter22 		<= #1 0;
	  rparity_xor22 		<= #1 1'b0;
	  rframing_error22 	<= #1 1'b0;
	  rparity_error22 		<= #1 1'b0;
	  rparity22 				<= #1 1'b0;
	  rshift22 				<= #1 0;
	  rf_push22 				<= #1 1'b0;
	  rf_data_in22 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle22 : begin
			rf_push22 			  <= #1 1'b0;
			rf_data_in22 	  <= #1 0;
			rcounter1622 	  <= #1 4'b1110;
			if (srx_pad_i22==1'b0 & ~break_error22)   // detected a pulse22 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start22;
			end
		end
	sr_rec_start22 :	begin
  			rf_push22 			  <= #1 1'b0;
				if (rcounter16_eq_722)    // check the pulse22
					if (srx_pad_i22==1'b1)   // no start bit
						rstate <= #1 sr_idle22;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare22;
				rcounter1622 <= #1 rcounter16_minus_122;
			end
	sr_rec_prepare22:begin
				case (lcr22[/*`UART_LC_BITS22*/1:0])  // number22 of bits in a word22
				2'b00 : rbit_counter22 <= #1 3'b100;
				2'b01 : rbit_counter22 <= #1 3'b101;
				2'b10 : rbit_counter22 <= #1 3'b110;
				2'b11 : rbit_counter22 <= #1 3'b111;
				endcase
				if (rcounter16_eq_022)
				begin
					rstate		<= #1 sr_rec_bit22;
					rcounter1622	<= #1 4'b1110;
					rshift22		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare22;
				rcounter1622 <= #1 rcounter16_minus_122;
			end
	sr_rec_bit22 :	begin
				if (rcounter16_eq_022)
					rstate <= #1 sr_end_bit22;
				if (rcounter16_eq_722) // read the bit
					case (lcr22[/*`UART_LC_BITS22*/1:0])  // number22 of bits in a word22
					2'b00 : rshift22[4:0]  <= #1 {srx_pad_i22, rshift22[4:1]};
					2'b01 : rshift22[5:0]  <= #1 {srx_pad_i22, rshift22[5:1]};
					2'b10 : rshift22[6:0]  <= #1 {srx_pad_i22, rshift22[6:1]};
					2'b11 : rshift22[7:0]  <= #1 {srx_pad_i22, rshift22[7:1]};
					endcase
				rcounter1622 <= #1 rcounter16_minus_122;
			end
	sr_end_bit22 :   begin
				if (rbit_counter22==3'b0) // no more bits in word22
					if (lcr22[`UART_LC_PE22]) // choose22 state based on parity22
						rstate <= #1 sr_rec_parity22;
					else
					begin
						rstate <= #1 sr_rec_stop22;
						rparity_error22 <= #1 1'b0;  // no parity22 - no error :)
					end
				else		// else we22 have more bits to read
				begin
					rstate <= #1 sr_rec_bit22;
					rbit_counter22 <= #1 rbit_counter22 - 1'b1;
				end
				rcounter1622 <= #1 4'b1110;
			end
	sr_rec_parity22: begin
				if (rcounter16_eq_722)	// read the parity22
				begin
					rparity22 <= #1 srx_pad_i22;
					rstate <= #1 sr_ca_lc_parity22;
				end
				rcounter1622 <= #1 rcounter16_minus_122;
			end
	sr_ca_lc_parity22 : begin    // rcounter22 equals22 6
				rcounter1622  <= #1 rcounter16_minus_122;
				rparity_xor22 <= #1 ^{rshift22,rparity22}; // calculate22 parity22 on all incoming22 data
				rstate      <= #1 sr_check_parity22;
			  end
	sr_check_parity22: begin	  // rcounter22 equals22 5
				case ({lcr22[`UART_LC_EP22],lcr22[`UART_LC_SP22]})
					2'b00: rparity_error22 <= #1  rparity_xor22 == 0;  // no error if parity22 1
					2'b01: rparity_error22 <= #1 ~rparity22;      // parity22 should sticked22 to 1
					2'b10: rparity_error22 <= #1  rparity_xor22 == 1;   // error if parity22 is odd22
					2'b11: rparity_error22 <= #1  rparity22;	  // parity22 should be sticked22 to 0
				endcase
				rcounter1622 <= #1 rcounter16_minus_122;
				rstate <= #1 sr_wait122;
			  end
	sr_wait122 :	if (rcounter16_eq_022)
			begin
				rstate <= #1 sr_rec_stop22;
				rcounter1622 <= #1 4'b1110;
			end
			else
				rcounter1622 <= #1 rcounter16_minus_122;
	sr_rec_stop22 :	begin
				if (rcounter16_eq_722)	// read the parity22
				begin
					rframing_error22 <= #1 !srx_pad_i22; // no framing22 error if input is 1 (stop bit)
					rstate <= #1 sr_push22;
				end
				rcounter1622 <= #1 rcounter16_minus_122;
			end
	sr_push22 :	begin
///////////////////////////////////////
//				$display($time, ": received22: %b", rf_data_in22);
        if(srx_pad_i22 | break_error22)
          begin
            if(break_error22)
        		  rf_data_in22 	<= #1 {8'b0, 3'b100}; // break input (empty22 character22) to receiver22 FIFO
            else
        			rf_data_in22  <= #1 {rshift22, 1'b0, rparity_error22, rframing_error22};
      		  rf_push22 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle22;
          end
        else if(~rframing_error22)  // There's always a framing22 before break_error22 -> wait for break or srx_pad_i22
          begin
       			rf_data_in22  <= #1 {rshift22, 1'b0, rparity_error22, rframing_error22};
      		  rf_push22 		  <= #1 1'b1;
      			rcounter1622 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start22;
          end
                      
			end
	default : rstate <= #1 sr_idle22;
	endcase
  end  // if (enable)
end // always of receiver22

always @ (posedge clk22 or posedge wb_rst_i22)
begin
  if(wb_rst_i22)
    rf_push_q22 <= 0;
  else
    rf_push_q22 <= #1 rf_push22;
end

assign rf_push_pulse22 = rf_push22 & ~rf_push_q22;

  
//
// Break22 condition detection22.
// Works22 in conjuction22 with the receiver22 state machine22

reg 	[9:0]	toc_value22; // value to be set to timeout counter

always @(lcr22)
	case (lcr22[3:0])
		4'b0000										: toc_value22 = 447; // 7 bits
		4'b0100										: toc_value22 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value22 = 511; // 8 bits
		4'b1100										: toc_value22 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value22 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value22 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value22 = 703; // 11 bits
		4'b1111										: toc_value22 = 767; // 12 bits
	endcase // case(lcr22[3:0])

wire [7:0] 	brc_value22; // value to be set to break counter
assign 		brc_value22 = toc_value22[9:2]; // the same as timeout but 1 insead22 of 4 character22 times

always @(posedge clk22 or posedge wb_rst_i22)
begin
	if (wb_rst_i22)
		counter_b22 <= #1 8'd159;
	else
	if (srx_pad_i22)
		counter_b22 <= #1 brc_value22; // character22 time length - 1
	else
	if(enable & counter_b22 != 8'b0)            // only work22 on enable times  break not reached22.
		counter_b22 <= #1 counter_b22 - 1;  // decrement break counter
end // always of break condition detection22

///
/// Timeout22 condition detection22
reg	[9:0]	counter_t22;	// counts22 the timeout condition clocks22

always @(posedge clk22 or posedge wb_rst_i22)
begin
	if (wb_rst_i22)
		counter_t22 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse22 || rf_pop22 || rf_count22 == 0) // counter is reset when RX22 FIFO is empty22, accessed or above22 trigger level
			counter_t22 <= #1 toc_value22;
		else
		if (enable && counter_t22 != 10'b0)  // we22 don22't want22 to underflow22
			counter_t22 <= #1 counter_t22 - 1;		
end
	
endmodule
