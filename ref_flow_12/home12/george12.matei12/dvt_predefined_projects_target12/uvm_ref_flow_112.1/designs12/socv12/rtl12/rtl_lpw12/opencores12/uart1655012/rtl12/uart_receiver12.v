//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver12.v                                             ////
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
////  UART12 core12 receiver12 logic                                    ////
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
// Revision12 1.29  2002/07/29 21:16:18  gorban12
// The uart_defines12.v file is included12 again12 in sources12.
//
// Revision12 1.28  2002/07/22 23:02:23  gorban12
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
// Revision12 1.27  2001/12/30 20:39:13  mohor12
// More than one character12 was stored12 in case of break. End12 of the break
// was not detected correctly.
//
// Revision12 1.26  2001/12/20 13:28:27  mohor12
// Missing12 declaration12 of rf_push_q12 fixed12.
//
// Revision12 1.25  2001/12/20 13:25:46  mohor12
// rx12 push12 changed to be only one cycle wide12.
//
// Revision12 1.24  2001/12/19 08:03:34  mohor12
// Warnings12 cleared12.
//
// Revision12 1.23  2001/12/19 07:33:54  mohor12
// Synplicity12 was having12 troubles12 with the comment12.
//
// Revision12 1.22  2001/12/17 14:46:48  mohor12
// overrun12 signal12 was moved to separate12 block because many12 sequential12 lsr12
// reads were12 preventing12 data from being written12 to rx12 fifo.
// underrun12 signal12 was not used and was removed from the project12.
//
// Revision12 1.21  2001/12/13 10:31:16  mohor12
// timeout irq12 must be set regardless12 of the rda12 irq12 (rda12 irq12 does not reset the
// timeout counter).
//
// Revision12 1.20  2001/12/10 19:52:05  gorban12
// Igor12 fixed12 break condition bugs12
//
// Revision12 1.19  2001/12/06 14:51:04  gorban12
// Bug12 in LSR12[0] is fixed12.
// All WISHBONE12 signals12 are now sampled12, so another12 wait-state is introduced12 on all transfers12.
//
// Revision12 1.18  2001/12/03 21:44:29  gorban12
// Updated12 specification12 documentation.
// Added12 full 32-bit data bus interface, now as default.
// Address is 5-bit wide12 in 32-bit data bus mode.
// Added12 wb_sel_i12 input to the core12. It's used in the 32-bit mode.
// Added12 debug12 interface with two12 32-bit read-only registers in 32-bit mode.
// Bits12 5 and 6 of LSR12 are now only cleared12 on TX12 FIFO write.
// My12 small test bench12 is modified to work12 with 32-bit mode.
//
// Revision12 1.17  2001/11/28 19:36:39  gorban12
// Fixed12: timeout and break didn12't pay12 attention12 to current data format12 when counting12 time
//
// Revision12 1.16  2001/11/27 22:17:09  gorban12
// Fixed12 bug12 that prevented12 synthesis12 in uart_receiver12.v
//
// Revision12 1.15  2001/11/26 21:38:54  gorban12
// Lots12 of fixes12:
// Break12 condition wasn12't handled12 correctly at all.
// LSR12 bits could lose12 their12 values.
// LSR12 value after reset was wrong12.
// Timing12 of THRE12 interrupt12 signal12 corrected12.
// LSR12 bit 0 timing12 corrected12.
//
// Revision12 1.14  2001/11/10 12:43:21  gorban12
// Logic12 Synthesis12 bugs12 fixed12. Some12 other minor12 changes12
//
// Revision12 1.13  2001/11/08 14:54:23  mohor12
// Comments12 in Slovene12 language12 deleted12, few12 small fixes12 for better12 work12 of
// old12 tools12. IRQs12 need to be fix12.
//
// Revision12 1.12  2001/11/07 17:51:52  gorban12
// Heavily12 rewritten12 interrupt12 and LSR12 subsystems12.
// Many12 bugs12 hopefully12 squashed12.
//
// Revision12 1.11  2001/10/31 15:19:22  gorban12
// Fixes12 to break and timeout conditions12
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
// Revision12 1.0  2001-05-17 21:27:11+02  jacob12
// Initial12 revision12
//
//

// synopsys12 translate_off12
`include "timescale.v"
// synopsys12 translate_on12

`include "uart_defines12.v"

module uart_receiver12 (clk12, wb_rst_i12, lcr12, rf_pop12, srx_pad_i12, enable, 
	counter_t12, rf_count12, rf_data_out12, rf_error_bit12, rf_overrun12, rx_reset12, lsr_mask12, rstate, rf_push_pulse12);

input				clk12;
input				wb_rst_i12;
input	[7:0]	lcr12;
input				rf_pop12;
input				srx_pad_i12;
input				enable;
input				rx_reset12;
input       lsr_mask12;

output	[9:0]			counter_t12;
output	[`UART_FIFO_COUNTER_W12-1:0]	rf_count12;
output	[`UART_FIFO_REC_WIDTH12-1:0]	rf_data_out12;
output				rf_overrun12;
output				rf_error_bit12;
output [3:0] 		rstate;
output 				rf_push_pulse12;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1612;
reg	[2:0]	rbit_counter12;
reg	[7:0]	rshift12;			// receiver12 shift12 register
reg		rparity12;		// received12 parity12
reg		rparity_error12;
reg		rframing_error12;		// framing12 error flag12
reg		rbit_in12;
reg		rparity_xor12;
reg	[7:0]	counter_b12;	// counts12 the 0 (low12) signals12
reg   rf_push_q12;

// RX12 FIFO signals12
reg	[`UART_FIFO_REC_WIDTH12-1:0]	rf_data_in12;
wire	[`UART_FIFO_REC_WIDTH12-1:0]	rf_data_out12;
wire      rf_push_pulse12;
reg				rf_push12;
wire				rf_pop12;
wire				rf_overrun12;
wire	[`UART_FIFO_COUNTER_W12-1:0]	rf_count12;
wire				rf_error_bit12; // an error (parity12 or framing12) is inside the fifo
wire 				break_error12 = (counter_b12 == 0);

// RX12 FIFO instance
uart_rfifo12 #(`UART_FIFO_REC_WIDTH12) fifo_rx12(
	.clk12(		clk12		), 
	.wb_rst_i12(	wb_rst_i12	),
	.data_in12(	rf_data_in12	),
	.data_out12(	rf_data_out12	),
	.push12(		rf_push_pulse12		),
	.pop12(		rf_pop12		),
	.overrun12(	rf_overrun12	),
	.count(		rf_count12	),
	.error_bit12(	rf_error_bit12	),
	.fifo_reset12(	rx_reset12	),
	.reset_status12(lsr_mask12)
);

wire 		rcounter16_eq_712 = (rcounter1612 == 4'd7);
wire		rcounter16_eq_012 = (rcounter1612 == 4'd0);
wire		rcounter16_eq_112 = (rcounter1612 == 4'd1);

wire [3:0] rcounter16_minus_112 = rcounter1612 - 1'b1;

parameter  sr_idle12 					= 4'd0;
parameter  sr_rec_start12 			= 4'd1;
parameter  sr_rec_bit12 				= 4'd2;
parameter  sr_rec_parity12			= 4'd3;
parameter  sr_rec_stop12 				= 4'd4;
parameter  sr_check_parity12 		= 4'd5;
parameter  sr_rec_prepare12 			= 4'd6;
parameter  sr_end_bit12				= 4'd7;
parameter  sr_ca_lc_parity12	      = 4'd8;
parameter  sr_wait112 					= 4'd9;
parameter  sr_push12 					= 4'd10;


always @(posedge clk12 or posedge wb_rst_i12)
begin
  if (wb_rst_i12)
  begin
     rstate 			<= #1 sr_idle12;
	  rbit_in12 				<= #1 1'b0;
	  rcounter1612 			<= #1 0;
	  rbit_counter12 		<= #1 0;
	  rparity_xor12 		<= #1 1'b0;
	  rframing_error12 	<= #1 1'b0;
	  rparity_error12 		<= #1 1'b0;
	  rparity12 				<= #1 1'b0;
	  rshift12 				<= #1 0;
	  rf_push12 				<= #1 1'b0;
	  rf_data_in12 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle12 : begin
			rf_push12 			  <= #1 1'b0;
			rf_data_in12 	  <= #1 0;
			rcounter1612 	  <= #1 4'b1110;
			if (srx_pad_i12==1'b0 & ~break_error12)   // detected a pulse12 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start12;
			end
		end
	sr_rec_start12 :	begin
  			rf_push12 			  <= #1 1'b0;
				if (rcounter16_eq_712)    // check the pulse12
					if (srx_pad_i12==1'b1)   // no start bit
						rstate <= #1 sr_idle12;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare12;
				rcounter1612 <= #1 rcounter16_minus_112;
			end
	sr_rec_prepare12:begin
				case (lcr12[/*`UART_LC_BITS12*/1:0])  // number12 of bits in a word12
				2'b00 : rbit_counter12 <= #1 3'b100;
				2'b01 : rbit_counter12 <= #1 3'b101;
				2'b10 : rbit_counter12 <= #1 3'b110;
				2'b11 : rbit_counter12 <= #1 3'b111;
				endcase
				if (rcounter16_eq_012)
				begin
					rstate		<= #1 sr_rec_bit12;
					rcounter1612	<= #1 4'b1110;
					rshift12		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare12;
				rcounter1612 <= #1 rcounter16_minus_112;
			end
	sr_rec_bit12 :	begin
				if (rcounter16_eq_012)
					rstate <= #1 sr_end_bit12;
				if (rcounter16_eq_712) // read the bit
					case (lcr12[/*`UART_LC_BITS12*/1:0])  // number12 of bits in a word12
					2'b00 : rshift12[4:0]  <= #1 {srx_pad_i12, rshift12[4:1]};
					2'b01 : rshift12[5:0]  <= #1 {srx_pad_i12, rshift12[5:1]};
					2'b10 : rshift12[6:0]  <= #1 {srx_pad_i12, rshift12[6:1]};
					2'b11 : rshift12[7:0]  <= #1 {srx_pad_i12, rshift12[7:1]};
					endcase
				rcounter1612 <= #1 rcounter16_minus_112;
			end
	sr_end_bit12 :   begin
				if (rbit_counter12==3'b0) // no more bits in word12
					if (lcr12[`UART_LC_PE12]) // choose12 state based on parity12
						rstate <= #1 sr_rec_parity12;
					else
					begin
						rstate <= #1 sr_rec_stop12;
						rparity_error12 <= #1 1'b0;  // no parity12 - no error :)
					end
				else		// else we12 have more bits to read
				begin
					rstate <= #1 sr_rec_bit12;
					rbit_counter12 <= #1 rbit_counter12 - 1'b1;
				end
				rcounter1612 <= #1 4'b1110;
			end
	sr_rec_parity12: begin
				if (rcounter16_eq_712)	// read the parity12
				begin
					rparity12 <= #1 srx_pad_i12;
					rstate <= #1 sr_ca_lc_parity12;
				end
				rcounter1612 <= #1 rcounter16_minus_112;
			end
	sr_ca_lc_parity12 : begin    // rcounter12 equals12 6
				rcounter1612  <= #1 rcounter16_minus_112;
				rparity_xor12 <= #1 ^{rshift12,rparity12}; // calculate12 parity12 on all incoming12 data
				rstate      <= #1 sr_check_parity12;
			  end
	sr_check_parity12: begin	  // rcounter12 equals12 5
				case ({lcr12[`UART_LC_EP12],lcr12[`UART_LC_SP12]})
					2'b00: rparity_error12 <= #1  rparity_xor12 == 0;  // no error if parity12 1
					2'b01: rparity_error12 <= #1 ~rparity12;      // parity12 should sticked12 to 1
					2'b10: rparity_error12 <= #1  rparity_xor12 == 1;   // error if parity12 is odd12
					2'b11: rparity_error12 <= #1  rparity12;	  // parity12 should be sticked12 to 0
				endcase
				rcounter1612 <= #1 rcounter16_minus_112;
				rstate <= #1 sr_wait112;
			  end
	sr_wait112 :	if (rcounter16_eq_012)
			begin
				rstate <= #1 sr_rec_stop12;
				rcounter1612 <= #1 4'b1110;
			end
			else
				rcounter1612 <= #1 rcounter16_minus_112;
	sr_rec_stop12 :	begin
				if (rcounter16_eq_712)	// read the parity12
				begin
					rframing_error12 <= #1 !srx_pad_i12; // no framing12 error if input is 1 (stop bit)
					rstate <= #1 sr_push12;
				end
				rcounter1612 <= #1 rcounter16_minus_112;
			end
	sr_push12 :	begin
///////////////////////////////////////
//				$display($time, ": received12: %b", rf_data_in12);
        if(srx_pad_i12 | break_error12)
          begin
            if(break_error12)
        		  rf_data_in12 	<= #1 {8'b0, 3'b100}; // break input (empty12 character12) to receiver12 FIFO
            else
        			rf_data_in12  <= #1 {rshift12, 1'b0, rparity_error12, rframing_error12};
      		  rf_push12 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle12;
          end
        else if(~rframing_error12)  // There's always a framing12 before break_error12 -> wait for break or srx_pad_i12
          begin
       			rf_data_in12  <= #1 {rshift12, 1'b0, rparity_error12, rframing_error12};
      		  rf_push12 		  <= #1 1'b1;
      			rcounter1612 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start12;
          end
                      
			end
	default : rstate <= #1 sr_idle12;
	endcase
  end  // if (enable)
end // always of receiver12

always @ (posedge clk12 or posedge wb_rst_i12)
begin
  if(wb_rst_i12)
    rf_push_q12 <= 0;
  else
    rf_push_q12 <= #1 rf_push12;
end

assign rf_push_pulse12 = rf_push12 & ~rf_push_q12;

  
//
// Break12 condition detection12.
// Works12 in conjuction12 with the receiver12 state machine12

reg 	[9:0]	toc_value12; // value to be set to timeout counter

always @(lcr12)
	case (lcr12[3:0])
		4'b0000										: toc_value12 = 447; // 7 bits
		4'b0100										: toc_value12 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value12 = 511; // 8 bits
		4'b1100										: toc_value12 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value12 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value12 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value12 = 703; // 11 bits
		4'b1111										: toc_value12 = 767; // 12 bits
	endcase // case(lcr12[3:0])

wire [7:0] 	brc_value12; // value to be set to break counter
assign 		brc_value12 = toc_value12[9:2]; // the same as timeout but 1 insead12 of 4 character12 times

always @(posedge clk12 or posedge wb_rst_i12)
begin
	if (wb_rst_i12)
		counter_b12 <= #1 8'd159;
	else
	if (srx_pad_i12)
		counter_b12 <= #1 brc_value12; // character12 time length - 1
	else
	if(enable & counter_b12 != 8'b0)            // only work12 on enable times  break not reached12.
		counter_b12 <= #1 counter_b12 - 1;  // decrement break counter
end // always of break condition detection12

///
/// Timeout12 condition detection12
reg	[9:0]	counter_t12;	// counts12 the timeout condition clocks12

always @(posedge clk12 or posedge wb_rst_i12)
begin
	if (wb_rst_i12)
		counter_t12 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse12 || rf_pop12 || rf_count12 == 0) // counter is reset when RX12 FIFO is empty12, accessed or above12 trigger level
			counter_t12 <= #1 toc_value12;
		else
		if (enable && counter_t12 != 10'b0)  // we12 don12't want12 to underflow12
			counter_t12 <= #1 counter_t12 - 1;		
end
	
endmodule
