//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver10.v                                             ////
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
////  UART10 core10 receiver10 logic                                    ////
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
// Revision10 1.29  2002/07/29 21:16:18  gorban10
// The uart_defines10.v file is included10 again10 in sources10.
//
// Revision10 1.28  2002/07/22 23:02:23  gorban10
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
// Revision10 1.27  2001/12/30 20:39:13  mohor10
// More than one character10 was stored10 in case of break. End10 of the break
// was not detected correctly.
//
// Revision10 1.26  2001/12/20 13:28:27  mohor10
// Missing10 declaration10 of rf_push_q10 fixed10.
//
// Revision10 1.25  2001/12/20 13:25:46  mohor10
// rx10 push10 changed to be only one cycle wide10.
//
// Revision10 1.24  2001/12/19 08:03:34  mohor10
// Warnings10 cleared10.
//
// Revision10 1.23  2001/12/19 07:33:54  mohor10
// Synplicity10 was having10 troubles10 with the comment10.
//
// Revision10 1.22  2001/12/17 14:46:48  mohor10
// overrun10 signal10 was moved to separate10 block because many10 sequential10 lsr10
// reads were10 preventing10 data from being written10 to rx10 fifo.
// underrun10 signal10 was not used and was removed from the project10.
//
// Revision10 1.21  2001/12/13 10:31:16  mohor10
// timeout irq10 must be set regardless10 of the rda10 irq10 (rda10 irq10 does not reset the
// timeout counter).
//
// Revision10 1.20  2001/12/10 19:52:05  gorban10
// Igor10 fixed10 break condition bugs10
//
// Revision10 1.19  2001/12/06 14:51:04  gorban10
// Bug10 in LSR10[0] is fixed10.
// All WISHBONE10 signals10 are now sampled10, so another10 wait-state is introduced10 on all transfers10.
//
// Revision10 1.18  2001/12/03 21:44:29  gorban10
// Updated10 specification10 documentation.
// Added10 full 32-bit data bus interface, now as default.
// Address is 5-bit wide10 in 32-bit data bus mode.
// Added10 wb_sel_i10 input to the core10. It's used in the 32-bit mode.
// Added10 debug10 interface with two10 32-bit read-only registers in 32-bit mode.
// Bits10 5 and 6 of LSR10 are now only cleared10 on TX10 FIFO write.
// My10 small test bench10 is modified to work10 with 32-bit mode.
//
// Revision10 1.17  2001/11/28 19:36:39  gorban10
// Fixed10: timeout and break didn10't pay10 attention10 to current data format10 when counting10 time
//
// Revision10 1.16  2001/11/27 22:17:09  gorban10
// Fixed10 bug10 that prevented10 synthesis10 in uart_receiver10.v
//
// Revision10 1.15  2001/11/26 21:38:54  gorban10
// Lots10 of fixes10:
// Break10 condition wasn10't handled10 correctly at all.
// LSR10 bits could lose10 their10 values.
// LSR10 value after reset was wrong10.
// Timing10 of THRE10 interrupt10 signal10 corrected10.
// LSR10 bit 0 timing10 corrected10.
//
// Revision10 1.14  2001/11/10 12:43:21  gorban10
// Logic10 Synthesis10 bugs10 fixed10. Some10 other minor10 changes10
//
// Revision10 1.13  2001/11/08 14:54:23  mohor10
// Comments10 in Slovene10 language10 deleted10, few10 small fixes10 for better10 work10 of
// old10 tools10. IRQs10 need to be fix10.
//
// Revision10 1.12  2001/11/07 17:51:52  gorban10
// Heavily10 rewritten10 interrupt10 and LSR10 subsystems10.
// Many10 bugs10 hopefully10 squashed10.
//
// Revision10 1.11  2001/10/31 15:19:22  gorban10
// Fixes10 to break and timeout conditions10
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
// Revision10 1.0  2001-05-17 21:27:11+02  jacob10
// Initial10 revision10
//
//

// synopsys10 translate_off10
`include "timescale.v"
// synopsys10 translate_on10

`include "uart_defines10.v"

module uart_receiver10 (clk10, wb_rst_i10, lcr10, rf_pop10, srx_pad_i10, enable, 
	counter_t10, rf_count10, rf_data_out10, rf_error_bit10, rf_overrun10, rx_reset10, lsr_mask10, rstate, rf_push_pulse10);

input				clk10;
input				wb_rst_i10;
input	[7:0]	lcr10;
input				rf_pop10;
input				srx_pad_i10;
input				enable;
input				rx_reset10;
input       lsr_mask10;

output	[9:0]			counter_t10;
output	[`UART_FIFO_COUNTER_W10-1:0]	rf_count10;
output	[`UART_FIFO_REC_WIDTH10-1:0]	rf_data_out10;
output				rf_overrun10;
output				rf_error_bit10;
output [3:0] 		rstate;
output 				rf_push_pulse10;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1610;
reg	[2:0]	rbit_counter10;
reg	[7:0]	rshift10;			// receiver10 shift10 register
reg		rparity10;		// received10 parity10
reg		rparity_error10;
reg		rframing_error10;		// framing10 error flag10
reg		rbit_in10;
reg		rparity_xor10;
reg	[7:0]	counter_b10;	// counts10 the 0 (low10) signals10
reg   rf_push_q10;

// RX10 FIFO signals10
reg	[`UART_FIFO_REC_WIDTH10-1:0]	rf_data_in10;
wire	[`UART_FIFO_REC_WIDTH10-1:0]	rf_data_out10;
wire      rf_push_pulse10;
reg				rf_push10;
wire				rf_pop10;
wire				rf_overrun10;
wire	[`UART_FIFO_COUNTER_W10-1:0]	rf_count10;
wire				rf_error_bit10; // an error (parity10 or framing10) is inside the fifo
wire 				break_error10 = (counter_b10 == 0);

// RX10 FIFO instance
uart_rfifo10 #(`UART_FIFO_REC_WIDTH10) fifo_rx10(
	.clk10(		clk10		), 
	.wb_rst_i10(	wb_rst_i10	),
	.data_in10(	rf_data_in10	),
	.data_out10(	rf_data_out10	),
	.push10(		rf_push_pulse10		),
	.pop10(		rf_pop10		),
	.overrun10(	rf_overrun10	),
	.count(		rf_count10	),
	.error_bit10(	rf_error_bit10	),
	.fifo_reset10(	rx_reset10	),
	.reset_status10(lsr_mask10)
);

wire 		rcounter16_eq_710 = (rcounter1610 == 4'd7);
wire		rcounter16_eq_010 = (rcounter1610 == 4'd0);
wire		rcounter16_eq_110 = (rcounter1610 == 4'd1);

wire [3:0] rcounter16_minus_110 = rcounter1610 - 1'b1;

parameter  sr_idle10 					= 4'd0;
parameter  sr_rec_start10 			= 4'd1;
parameter  sr_rec_bit10 				= 4'd2;
parameter  sr_rec_parity10			= 4'd3;
parameter  sr_rec_stop10 				= 4'd4;
parameter  sr_check_parity10 		= 4'd5;
parameter  sr_rec_prepare10 			= 4'd6;
parameter  sr_end_bit10				= 4'd7;
parameter  sr_ca_lc_parity10	      = 4'd8;
parameter  sr_wait110 					= 4'd9;
parameter  sr_push10 					= 4'd10;


always @(posedge clk10 or posedge wb_rst_i10)
begin
  if (wb_rst_i10)
  begin
     rstate 			<= #1 sr_idle10;
	  rbit_in10 				<= #1 1'b0;
	  rcounter1610 			<= #1 0;
	  rbit_counter10 		<= #1 0;
	  rparity_xor10 		<= #1 1'b0;
	  rframing_error10 	<= #1 1'b0;
	  rparity_error10 		<= #1 1'b0;
	  rparity10 				<= #1 1'b0;
	  rshift10 				<= #1 0;
	  rf_push10 				<= #1 1'b0;
	  rf_data_in10 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle10 : begin
			rf_push10 			  <= #1 1'b0;
			rf_data_in10 	  <= #1 0;
			rcounter1610 	  <= #1 4'b1110;
			if (srx_pad_i10==1'b0 & ~break_error10)   // detected a pulse10 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start10;
			end
		end
	sr_rec_start10 :	begin
  			rf_push10 			  <= #1 1'b0;
				if (rcounter16_eq_710)    // check the pulse10
					if (srx_pad_i10==1'b1)   // no start bit
						rstate <= #1 sr_idle10;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare10;
				rcounter1610 <= #1 rcounter16_minus_110;
			end
	sr_rec_prepare10:begin
				case (lcr10[/*`UART_LC_BITS10*/1:0])  // number10 of bits in a word10
				2'b00 : rbit_counter10 <= #1 3'b100;
				2'b01 : rbit_counter10 <= #1 3'b101;
				2'b10 : rbit_counter10 <= #1 3'b110;
				2'b11 : rbit_counter10 <= #1 3'b111;
				endcase
				if (rcounter16_eq_010)
				begin
					rstate		<= #1 sr_rec_bit10;
					rcounter1610	<= #1 4'b1110;
					rshift10		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare10;
				rcounter1610 <= #1 rcounter16_minus_110;
			end
	sr_rec_bit10 :	begin
				if (rcounter16_eq_010)
					rstate <= #1 sr_end_bit10;
				if (rcounter16_eq_710) // read the bit
					case (lcr10[/*`UART_LC_BITS10*/1:0])  // number10 of bits in a word10
					2'b00 : rshift10[4:0]  <= #1 {srx_pad_i10, rshift10[4:1]};
					2'b01 : rshift10[5:0]  <= #1 {srx_pad_i10, rshift10[5:1]};
					2'b10 : rshift10[6:0]  <= #1 {srx_pad_i10, rshift10[6:1]};
					2'b11 : rshift10[7:0]  <= #1 {srx_pad_i10, rshift10[7:1]};
					endcase
				rcounter1610 <= #1 rcounter16_minus_110;
			end
	sr_end_bit10 :   begin
				if (rbit_counter10==3'b0) // no more bits in word10
					if (lcr10[`UART_LC_PE10]) // choose10 state based on parity10
						rstate <= #1 sr_rec_parity10;
					else
					begin
						rstate <= #1 sr_rec_stop10;
						rparity_error10 <= #1 1'b0;  // no parity10 - no error :)
					end
				else		// else we10 have more bits to read
				begin
					rstate <= #1 sr_rec_bit10;
					rbit_counter10 <= #1 rbit_counter10 - 1'b1;
				end
				rcounter1610 <= #1 4'b1110;
			end
	sr_rec_parity10: begin
				if (rcounter16_eq_710)	// read the parity10
				begin
					rparity10 <= #1 srx_pad_i10;
					rstate <= #1 sr_ca_lc_parity10;
				end
				rcounter1610 <= #1 rcounter16_minus_110;
			end
	sr_ca_lc_parity10 : begin    // rcounter10 equals10 6
				rcounter1610  <= #1 rcounter16_minus_110;
				rparity_xor10 <= #1 ^{rshift10,rparity10}; // calculate10 parity10 on all incoming10 data
				rstate      <= #1 sr_check_parity10;
			  end
	sr_check_parity10: begin	  // rcounter10 equals10 5
				case ({lcr10[`UART_LC_EP10],lcr10[`UART_LC_SP10]})
					2'b00: rparity_error10 <= #1  rparity_xor10 == 0;  // no error if parity10 1
					2'b01: rparity_error10 <= #1 ~rparity10;      // parity10 should sticked10 to 1
					2'b10: rparity_error10 <= #1  rparity_xor10 == 1;   // error if parity10 is odd10
					2'b11: rparity_error10 <= #1  rparity10;	  // parity10 should be sticked10 to 0
				endcase
				rcounter1610 <= #1 rcounter16_minus_110;
				rstate <= #1 sr_wait110;
			  end
	sr_wait110 :	if (rcounter16_eq_010)
			begin
				rstate <= #1 sr_rec_stop10;
				rcounter1610 <= #1 4'b1110;
			end
			else
				rcounter1610 <= #1 rcounter16_minus_110;
	sr_rec_stop10 :	begin
				if (rcounter16_eq_710)	// read the parity10
				begin
					rframing_error10 <= #1 !srx_pad_i10; // no framing10 error if input is 1 (stop bit)
					rstate <= #1 sr_push10;
				end
				rcounter1610 <= #1 rcounter16_minus_110;
			end
	sr_push10 :	begin
///////////////////////////////////////
//				$display($time, ": received10: %b", rf_data_in10);
        if(srx_pad_i10 | break_error10)
          begin
            if(break_error10)
        		  rf_data_in10 	<= #1 {8'b0, 3'b100}; // break input (empty10 character10) to receiver10 FIFO
            else
        			rf_data_in10  <= #1 {rshift10, 1'b0, rparity_error10, rframing_error10};
      		  rf_push10 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle10;
          end
        else if(~rframing_error10)  // There's always a framing10 before break_error10 -> wait for break or srx_pad_i10
          begin
       			rf_data_in10  <= #1 {rshift10, 1'b0, rparity_error10, rframing_error10};
      		  rf_push10 		  <= #1 1'b1;
      			rcounter1610 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start10;
          end
                      
			end
	default : rstate <= #1 sr_idle10;
	endcase
  end  // if (enable)
end // always of receiver10

always @ (posedge clk10 or posedge wb_rst_i10)
begin
  if(wb_rst_i10)
    rf_push_q10 <= 0;
  else
    rf_push_q10 <= #1 rf_push10;
end

assign rf_push_pulse10 = rf_push10 & ~rf_push_q10;

  
//
// Break10 condition detection10.
// Works10 in conjuction10 with the receiver10 state machine10

reg 	[9:0]	toc_value10; // value to be set to timeout counter

always @(lcr10)
	case (lcr10[3:0])
		4'b0000										: toc_value10 = 447; // 7 bits
		4'b0100										: toc_value10 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value10 = 511; // 8 bits
		4'b1100										: toc_value10 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value10 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value10 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value10 = 703; // 11 bits
		4'b1111										: toc_value10 = 767; // 12 bits
	endcase // case(lcr10[3:0])

wire [7:0] 	brc_value10; // value to be set to break counter
assign 		brc_value10 = toc_value10[9:2]; // the same as timeout but 1 insead10 of 4 character10 times

always @(posedge clk10 or posedge wb_rst_i10)
begin
	if (wb_rst_i10)
		counter_b10 <= #1 8'd159;
	else
	if (srx_pad_i10)
		counter_b10 <= #1 brc_value10; // character10 time length - 1
	else
	if(enable & counter_b10 != 8'b0)            // only work10 on enable times  break not reached10.
		counter_b10 <= #1 counter_b10 - 1;  // decrement break counter
end // always of break condition detection10

///
/// Timeout10 condition detection10
reg	[9:0]	counter_t10;	// counts10 the timeout condition clocks10

always @(posedge clk10 or posedge wb_rst_i10)
begin
	if (wb_rst_i10)
		counter_t10 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse10 || rf_pop10 || rf_count10 == 0) // counter is reset when RX10 FIFO is empty10, accessed or above10 trigger level
			counter_t10 <= #1 toc_value10;
		else
		if (enable && counter_t10 != 10'b0)  // we10 don10't want10 to underflow10
			counter_t10 <= #1 counter_t10 - 1;		
end
	
endmodule
