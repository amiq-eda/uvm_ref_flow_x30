//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver28.v                                             ////
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
////  UART28 core28 receiver28 logic                                    ////
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
// Revision28 1.29  2002/07/29 21:16:18  gorban28
// The uart_defines28.v file is included28 again28 in sources28.
//
// Revision28 1.28  2002/07/22 23:02:23  gorban28
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
// Revision28 1.27  2001/12/30 20:39:13  mohor28
// More than one character28 was stored28 in case of break. End28 of the break
// was not detected correctly.
//
// Revision28 1.26  2001/12/20 13:28:27  mohor28
// Missing28 declaration28 of rf_push_q28 fixed28.
//
// Revision28 1.25  2001/12/20 13:25:46  mohor28
// rx28 push28 changed to be only one cycle wide28.
//
// Revision28 1.24  2001/12/19 08:03:34  mohor28
// Warnings28 cleared28.
//
// Revision28 1.23  2001/12/19 07:33:54  mohor28
// Synplicity28 was having28 troubles28 with the comment28.
//
// Revision28 1.22  2001/12/17 14:46:48  mohor28
// overrun28 signal28 was moved to separate28 block because many28 sequential28 lsr28
// reads were28 preventing28 data from being written28 to rx28 fifo.
// underrun28 signal28 was not used and was removed from the project28.
//
// Revision28 1.21  2001/12/13 10:31:16  mohor28
// timeout irq28 must be set regardless28 of the rda28 irq28 (rda28 irq28 does not reset the
// timeout counter).
//
// Revision28 1.20  2001/12/10 19:52:05  gorban28
// Igor28 fixed28 break condition bugs28
//
// Revision28 1.19  2001/12/06 14:51:04  gorban28
// Bug28 in LSR28[0] is fixed28.
// All WISHBONE28 signals28 are now sampled28, so another28 wait-state is introduced28 on all transfers28.
//
// Revision28 1.18  2001/12/03 21:44:29  gorban28
// Updated28 specification28 documentation.
// Added28 full 32-bit data bus interface, now as default.
// Address is 5-bit wide28 in 32-bit data bus mode.
// Added28 wb_sel_i28 input to the core28. It's used in the 32-bit mode.
// Added28 debug28 interface with two28 32-bit read-only registers in 32-bit mode.
// Bits28 5 and 6 of LSR28 are now only cleared28 on TX28 FIFO write.
// My28 small test bench28 is modified to work28 with 32-bit mode.
//
// Revision28 1.17  2001/11/28 19:36:39  gorban28
// Fixed28: timeout and break didn28't pay28 attention28 to current data format28 when counting28 time
//
// Revision28 1.16  2001/11/27 22:17:09  gorban28
// Fixed28 bug28 that prevented28 synthesis28 in uart_receiver28.v
//
// Revision28 1.15  2001/11/26 21:38:54  gorban28
// Lots28 of fixes28:
// Break28 condition wasn28't handled28 correctly at all.
// LSR28 bits could lose28 their28 values.
// LSR28 value after reset was wrong28.
// Timing28 of THRE28 interrupt28 signal28 corrected28.
// LSR28 bit 0 timing28 corrected28.
//
// Revision28 1.14  2001/11/10 12:43:21  gorban28
// Logic28 Synthesis28 bugs28 fixed28. Some28 other minor28 changes28
//
// Revision28 1.13  2001/11/08 14:54:23  mohor28
// Comments28 in Slovene28 language28 deleted28, few28 small fixes28 for better28 work28 of
// old28 tools28. IRQs28 need to be fix28.
//
// Revision28 1.12  2001/11/07 17:51:52  gorban28
// Heavily28 rewritten28 interrupt28 and LSR28 subsystems28.
// Many28 bugs28 hopefully28 squashed28.
//
// Revision28 1.11  2001/10/31 15:19:22  gorban28
// Fixes28 to break and timeout conditions28
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
// Revision28 1.0  2001-05-17 21:27:11+02  jacob28
// Initial28 revision28
//
//

// synopsys28 translate_off28
`include "timescale.v"
// synopsys28 translate_on28

`include "uart_defines28.v"

module uart_receiver28 (clk28, wb_rst_i28, lcr28, rf_pop28, srx_pad_i28, enable, 
	counter_t28, rf_count28, rf_data_out28, rf_error_bit28, rf_overrun28, rx_reset28, lsr_mask28, rstate, rf_push_pulse28);

input				clk28;
input				wb_rst_i28;
input	[7:0]	lcr28;
input				rf_pop28;
input				srx_pad_i28;
input				enable;
input				rx_reset28;
input       lsr_mask28;

output	[9:0]			counter_t28;
output	[`UART_FIFO_COUNTER_W28-1:0]	rf_count28;
output	[`UART_FIFO_REC_WIDTH28-1:0]	rf_data_out28;
output				rf_overrun28;
output				rf_error_bit28;
output [3:0] 		rstate;
output 				rf_push_pulse28;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1628;
reg	[2:0]	rbit_counter28;
reg	[7:0]	rshift28;			// receiver28 shift28 register
reg		rparity28;		// received28 parity28
reg		rparity_error28;
reg		rframing_error28;		// framing28 error flag28
reg		rbit_in28;
reg		rparity_xor28;
reg	[7:0]	counter_b28;	// counts28 the 0 (low28) signals28
reg   rf_push_q28;

// RX28 FIFO signals28
reg	[`UART_FIFO_REC_WIDTH28-1:0]	rf_data_in28;
wire	[`UART_FIFO_REC_WIDTH28-1:0]	rf_data_out28;
wire      rf_push_pulse28;
reg				rf_push28;
wire				rf_pop28;
wire				rf_overrun28;
wire	[`UART_FIFO_COUNTER_W28-1:0]	rf_count28;
wire				rf_error_bit28; // an error (parity28 or framing28) is inside the fifo
wire 				break_error28 = (counter_b28 == 0);

// RX28 FIFO instance
uart_rfifo28 #(`UART_FIFO_REC_WIDTH28) fifo_rx28(
	.clk28(		clk28		), 
	.wb_rst_i28(	wb_rst_i28	),
	.data_in28(	rf_data_in28	),
	.data_out28(	rf_data_out28	),
	.push28(		rf_push_pulse28		),
	.pop28(		rf_pop28		),
	.overrun28(	rf_overrun28	),
	.count(		rf_count28	),
	.error_bit28(	rf_error_bit28	),
	.fifo_reset28(	rx_reset28	),
	.reset_status28(lsr_mask28)
);

wire 		rcounter16_eq_728 = (rcounter1628 == 4'd7);
wire		rcounter16_eq_028 = (rcounter1628 == 4'd0);
wire		rcounter16_eq_128 = (rcounter1628 == 4'd1);

wire [3:0] rcounter16_minus_128 = rcounter1628 - 1'b1;

parameter  sr_idle28 					= 4'd0;
parameter  sr_rec_start28 			= 4'd1;
parameter  sr_rec_bit28 				= 4'd2;
parameter  sr_rec_parity28			= 4'd3;
parameter  sr_rec_stop28 				= 4'd4;
parameter  sr_check_parity28 		= 4'd5;
parameter  sr_rec_prepare28 			= 4'd6;
parameter  sr_end_bit28				= 4'd7;
parameter  sr_ca_lc_parity28	      = 4'd8;
parameter  sr_wait128 					= 4'd9;
parameter  sr_push28 					= 4'd10;


always @(posedge clk28 or posedge wb_rst_i28)
begin
  if (wb_rst_i28)
  begin
     rstate 			<= #1 sr_idle28;
	  rbit_in28 				<= #1 1'b0;
	  rcounter1628 			<= #1 0;
	  rbit_counter28 		<= #1 0;
	  rparity_xor28 		<= #1 1'b0;
	  rframing_error28 	<= #1 1'b0;
	  rparity_error28 		<= #1 1'b0;
	  rparity28 				<= #1 1'b0;
	  rshift28 				<= #1 0;
	  rf_push28 				<= #1 1'b0;
	  rf_data_in28 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle28 : begin
			rf_push28 			  <= #1 1'b0;
			rf_data_in28 	  <= #1 0;
			rcounter1628 	  <= #1 4'b1110;
			if (srx_pad_i28==1'b0 & ~break_error28)   // detected a pulse28 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start28;
			end
		end
	sr_rec_start28 :	begin
  			rf_push28 			  <= #1 1'b0;
				if (rcounter16_eq_728)    // check the pulse28
					if (srx_pad_i28==1'b1)   // no start bit
						rstate <= #1 sr_idle28;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare28;
				rcounter1628 <= #1 rcounter16_minus_128;
			end
	sr_rec_prepare28:begin
				case (lcr28[/*`UART_LC_BITS28*/1:0])  // number28 of bits in a word28
				2'b00 : rbit_counter28 <= #1 3'b100;
				2'b01 : rbit_counter28 <= #1 3'b101;
				2'b10 : rbit_counter28 <= #1 3'b110;
				2'b11 : rbit_counter28 <= #1 3'b111;
				endcase
				if (rcounter16_eq_028)
				begin
					rstate		<= #1 sr_rec_bit28;
					rcounter1628	<= #1 4'b1110;
					rshift28		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare28;
				rcounter1628 <= #1 rcounter16_minus_128;
			end
	sr_rec_bit28 :	begin
				if (rcounter16_eq_028)
					rstate <= #1 sr_end_bit28;
				if (rcounter16_eq_728) // read the bit
					case (lcr28[/*`UART_LC_BITS28*/1:0])  // number28 of bits in a word28
					2'b00 : rshift28[4:0]  <= #1 {srx_pad_i28, rshift28[4:1]};
					2'b01 : rshift28[5:0]  <= #1 {srx_pad_i28, rshift28[5:1]};
					2'b10 : rshift28[6:0]  <= #1 {srx_pad_i28, rshift28[6:1]};
					2'b11 : rshift28[7:0]  <= #1 {srx_pad_i28, rshift28[7:1]};
					endcase
				rcounter1628 <= #1 rcounter16_minus_128;
			end
	sr_end_bit28 :   begin
				if (rbit_counter28==3'b0) // no more bits in word28
					if (lcr28[`UART_LC_PE28]) // choose28 state based on parity28
						rstate <= #1 sr_rec_parity28;
					else
					begin
						rstate <= #1 sr_rec_stop28;
						rparity_error28 <= #1 1'b0;  // no parity28 - no error :)
					end
				else		// else we28 have more bits to read
				begin
					rstate <= #1 sr_rec_bit28;
					rbit_counter28 <= #1 rbit_counter28 - 1'b1;
				end
				rcounter1628 <= #1 4'b1110;
			end
	sr_rec_parity28: begin
				if (rcounter16_eq_728)	// read the parity28
				begin
					rparity28 <= #1 srx_pad_i28;
					rstate <= #1 sr_ca_lc_parity28;
				end
				rcounter1628 <= #1 rcounter16_minus_128;
			end
	sr_ca_lc_parity28 : begin    // rcounter28 equals28 6
				rcounter1628  <= #1 rcounter16_minus_128;
				rparity_xor28 <= #1 ^{rshift28,rparity28}; // calculate28 parity28 on all incoming28 data
				rstate      <= #1 sr_check_parity28;
			  end
	sr_check_parity28: begin	  // rcounter28 equals28 5
				case ({lcr28[`UART_LC_EP28],lcr28[`UART_LC_SP28]})
					2'b00: rparity_error28 <= #1  rparity_xor28 == 0;  // no error if parity28 1
					2'b01: rparity_error28 <= #1 ~rparity28;      // parity28 should sticked28 to 1
					2'b10: rparity_error28 <= #1  rparity_xor28 == 1;   // error if parity28 is odd28
					2'b11: rparity_error28 <= #1  rparity28;	  // parity28 should be sticked28 to 0
				endcase
				rcounter1628 <= #1 rcounter16_minus_128;
				rstate <= #1 sr_wait128;
			  end
	sr_wait128 :	if (rcounter16_eq_028)
			begin
				rstate <= #1 sr_rec_stop28;
				rcounter1628 <= #1 4'b1110;
			end
			else
				rcounter1628 <= #1 rcounter16_minus_128;
	sr_rec_stop28 :	begin
				if (rcounter16_eq_728)	// read the parity28
				begin
					rframing_error28 <= #1 !srx_pad_i28; // no framing28 error if input is 1 (stop bit)
					rstate <= #1 sr_push28;
				end
				rcounter1628 <= #1 rcounter16_minus_128;
			end
	sr_push28 :	begin
///////////////////////////////////////
//				$display($time, ": received28: %b", rf_data_in28);
        if(srx_pad_i28 | break_error28)
          begin
            if(break_error28)
        		  rf_data_in28 	<= #1 {8'b0, 3'b100}; // break input (empty28 character28) to receiver28 FIFO
            else
        			rf_data_in28  <= #1 {rshift28, 1'b0, rparity_error28, rframing_error28};
      		  rf_push28 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle28;
          end
        else if(~rframing_error28)  // There's always a framing28 before break_error28 -> wait for break or srx_pad_i28
          begin
       			rf_data_in28  <= #1 {rshift28, 1'b0, rparity_error28, rframing_error28};
      		  rf_push28 		  <= #1 1'b1;
      			rcounter1628 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start28;
          end
                      
			end
	default : rstate <= #1 sr_idle28;
	endcase
  end  // if (enable)
end // always of receiver28

always @ (posedge clk28 or posedge wb_rst_i28)
begin
  if(wb_rst_i28)
    rf_push_q28 <= 0;
  else
    rf_push_q28 <= #1 rf_push28;
end

assign rf_push_pulse28 = rf_push28 & ~rf_push_q28;

  
//
// Break28 condition detection28.
// Works28 in conjuction28 with the receiver28 state machine28

reg 	[9:0]	toc_value28; // value to be set to timeout counter

always @(lcr28)
	case (lcr28[3:0])
		4'b0000										: toc_value28 = 447; // 7 bits
		4'b0100										: toc_value28 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value28 = 511; // 8 bits
		4'b1100										: toc_value28 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value28 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value28 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value28 = 703; // 11 bits
		4'b1111										: toc_value28 = 767; // 12 bits
	endcase // case(lcr28[3:0])

wire [7:0] 	brc_value28; // value to be set to break counter
assign 		brc_value28 = toc_value28[9:2]; // the same as timeout but 1 insead28 of 4 character28 times

always @(posedge clk28 or posedge wb_rst_i28)
begin
	if (wb_rst_i28)
		counter_b28 <= #1 8'd159;
	else
	if (srx_pad_i28)
		counter_b28 <= #1 brc_value28; // character28 time length - 1
	else
	if(enable & counter_b28 != 8'b0)            // only work28 on enable times  break not reached28.
		counter_b28 <= #1 counter_b28 - 1;  // decrement break counter
end // always of break condition detection28

///
/// Timeout28 condition detection28
reg	[9:0]	counter_t28;	// counts28 the timeout condition clocks28

always @(posedge clk28 or posedge wb_rst_i28)
begin
	if (wb_rst_i28)
		counter_t28 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse28 || rf_pop28 || rf_count28 == 0) // counter is reset when RX28 FIFO is empty28, accessed or above28 trigger level
			counter_t28 <= #1 toc_value28;
		else
		if (enable && counter_t28 != 10'b0)  // we28 don28't want28 to underflow28
			counter_t28 <= #1 counter_t28 - 1;		
end
	
endmodule
