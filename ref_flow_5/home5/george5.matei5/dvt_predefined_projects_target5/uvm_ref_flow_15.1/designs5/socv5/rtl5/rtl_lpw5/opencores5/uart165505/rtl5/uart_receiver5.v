//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver5.v                                             ////
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
////  UART5 core5 receiver5 logic                                    ////
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
// Revision5 1.29  2002/07/29 21:16:18  gorban5
// The uart_defines5.v file is included5 again5 in sources5.
//
// Revision5 1.28  2002/07/22 23:02:23  gorban5
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
// Revision5 1.27  2001/12/30 20:39:13  mohor5
// More than one character5 was stored5 in case of break. End5 of the break
// was not detected correctly.
//
// Revision5 1.26  2001/12/20 13:28:27  mohor5
// Missing5 declaration5 of rf_push_q5 fixed5.
//
// Revision5 1.25  2001/12/20 13:25:46  mohor5
// rx5 push5 changed to be only one cycle wide5.
//
// Revision5 1.24  2001/12/19 08:03:34  mohor5
// Warnings5 cleared5.
//
// Revision5 1.23  2001/12/19 07:33:54  mohor5
// Synplicity5 was having5 troubles5 with the comment5.
//
// Revision5 1.22  2001/12/17 14:46:48  mohor5
// overrun5 signal5 was moved to separate5 block because many5 sequential5 lsr5
// reads were5 preventing5 data from being written5 to rx5 fifo.
// underrun5 signal5 was not used and was removed from the project5.
//
// Revision5 1.21  2001/12/13 10:31:16  mohor5
// timeout irq5 must be set regardless5 of the rda5 irq5 (rda5 irq5 does not reset the
// timeout counter).
//
// Revision5 1.20  2001/12/10 19:52:05  gorban5
// Igor5 fixed5 break condition bugs5
//
// Revision5 1.19  2001/12/06 14:51:04  gorban5
// Bug5 in LSR5[0] is fixed5.
// All WISHBONE5 signals5 are now sampled5, so another5 wait-state is introduced5 on all transfers5.
//
// Revision5 1.18  2001/12/03 21:44:29  gorban5
// Updated5 specification5 documentation.
// Added5 full 32-bit data bus interface, now as default.
// Address is 5-bit wide5 in 32-bit data bus mode.
// Added5 wb_sel_i5 input to the core5. It's used in the 32-bit mode.
// Added5 debug5 interface with two5 32-bit read-only registers in 32-bit mode.
// Bits5 5 and 6 of LSR5 are now only cleared5 on TX5 FIFO write.
// My5 small test bench5 is modified to work5 with 32-bit mode.
//
// Revision5 1.17  2001/11/28 19:36:39  gorban5
// Fixed5: timeout and break didn5't pay5 attention5 to current data format5 when counting5 time
//
// Revision5 1.16  2001/11/27 22:17:09  gorban5
// Fixed5 bug5 that prevented5 synthesis5 in uart_receiver5.v
//
// Revision5 1.15  2001/11/26 21:38:54  gorban5
// Lots5 of fixes5:
// Break5 condition wasn5't handled5 correctly at all.
// LSR5 bits could lose5 their5 values.
// LSR5 value after reset was wrong5.
// Timing5 of THRE5 interrupt5 signal5 corrected5.
// LSR5 bit 0 timing5 corrected5.
//
// Revision5 1.14  2001/11/10 12:43:21  gorban5
// Logic5 Synthesis5 bugs5 fixed5. Some5 other minor5 changes5
//
// Revision5 1.13  2001/11/08 14:54:23  mohor5
// Comments5 in Slovene5 language5 deleted5, few5 small fixes5 for better5 work5 of
// old5 tools5. IRQs5 need to be fix5.
//
// Revision5 1.12  2001/11/07 17:51:52  gorban5
// Heavily5 rewritten5 interrupt5 and LSR5 subsystems5.
// Many5 bugs5 hopefully5 squashed5.
//
// Revision5 1.11  2001/10/31 15:19:22  gorban5
// Fixes5 to break and timeout conditions5
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
// Revision5 1.0  2001-05-17 21:27:11+02  jacob5
// Initial5 revision5
//
//

// synopsys5 translate_off5
`include "timescale.v"
// synopsys5 translate_on5

`include "uart_defines5.v"

module uart_receiver5 (clk5, wb_rst_i5, lcr5, rf_pop5, srx_pad_i5, enable, 
	counter_t5, rf_count5, rf_data_out5, rf_error_bit5, rf_overrun5, rx_reset5, lsr_mask5, rstate, rf_push_pulse5);

input				clk5;
input				wb_rst_i5;
input	[7:0]	lcr5;
input				rf_pop5;
input				srx_pad_i5;
input				enable;
input				rx_reset5;
input       lsr_mask5;

output	[9:0]			counter_t5;
output	[`UART_FIFO_COUNTER_W5-1:0]	rf_count5;
output	[`UART_FIFO_REC_WIDTH5-1:0]	rf_data_out5;
output				rf_overrun5;
output				rf_error_bit5;
output [3:0] 		rstate;
output 				rf_push_pulse5;

reg	[3:0]	rstate;
reg	[3:0]	rcounter165;
reg	[2:0]	rbit_counter5;
reg	[7:0]	rshift5;			// receiver5 shift5 register
reg		rparity5;		// received5 parity5
reg		rparity_error5;
reg		rframing_error5;		// framing5 error flag5
reg		rbit_in5;
reg		rparity_xor5;
reg	[7:0]	counter_b5;	// counts5 the 0 (low5) signals5
reg   rf_push_q5;

// RX5 FIFO signals5
reg	[`UART_FIFO_REC_WIDTH5-1:0]	rf_data_in5;
wire	[`UART_FIFO_REC_WIDTH5-1:0]	rf_data_out5;
wire      rf_push_pulse5;
reg				rf_push5;
wire				rf_pop5;
wire				rf_overrun5;
wire	[`UART_FIFO_COUNTER_W5-1:0]	rf_count5;
wire				rf_error_bit5; // an error (parity5 or framing5) is inside the fifo
wire 				break_error5 = (counter_b5 == 0);

// RX5 FIFO instance
uart_rfifo5 #(`UART_FIFO_REC_WIDTH5) fifo_rx5(
	.clk5(		clk5		), 
	.wb_rst_i5(	wb_rst_i5	),
	.data_in5(	rf_data_in5	),
	.data_out5(	rf_data_out5	),
	.push5(		rf_push_pulse5		),
	.pop5(		rf_pop5		),
	.overrun5(	rf_overrun5	),
	.count(		rf_count5	),
	.error_bit5(	rf_error_bit5	),
	.fifo_reset5(	rx_reset5	),
	.reset_status5(lsr_mask5)
);

wire 		rcounter16_eq_75 = (rcounter165 == 4'd7);
wire		rcounter16_eq_05 = (rcounter165 == 4'd0);
wire		rcounter16_eq_15 = (rcounter165 == 4'd1);

wire [3:0] rcounter16_minus_15 = rcounter165 - 1'b1;

parameter  sr_idle5 					= 4'd0;
parameter  sr_rec_start5 			= 4'd1;
parameter  sr_rec_bit5 				= 4'd2;
parameter  sr_rec_parity5			= 4'd3;
parameter  sr_rec_stop5 				= 4'd4;
parameter  sr_check_parity5 		= 4'd5;
parameter  sr_rec_prepare5 			= 4'd6;
parameter  sr_end_bit5				= 4'd7;
parameter  sr_ca_lc_parity5	      = 4'd8;
parameter  sr_wait15 					= 4'd9;
parameter  sr_push5 					= 4'd10;


always @(posedge clk5 or posedge wb_rst_i5)
begin
  if (wb_rst_i5)
  begin
     rstate 			<= #1 sr_idle5;
	  rbit_in5 				<= #1 1'b0;
	  rcounter165 			<= #1 0;
	  rbit_counter5 		<= #1 0;
	  rparity_xor5 		<= #1 1'b0;
	  rframing_error5 	<= #1 1'b0;
	  rparity_error5 		<= #1 1'b0;
	  rparity5 				<= #1 1'b0;
	  rshift5 				<= #1 0;
	  rf_push5 				<= #1 1'b0;
	  rf_data_in5 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle5 : begin
			rf_push5 			  <= #1 1'b0;
			rf_data_in5 	  <= #1 0;
			rcounter165 	  <= #1 4'b1110;
			if (srx_pad_i5==1'b0 & ~break_error5)   // detected a pulse5 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start5;
			end
		end
	sr_rec_start5 :	begin
  			rf_push5 			  <= #1 1'b0;
				if (rcounter16_eq_75)    // check the pulse5
					if (srx_pad_i5==1'b1)   // no start bit
						rstate <= #1 sr_idle5;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare5;
				rcounter165 <= #1 rcounter16_minus_15;
			end
	sr_rec_prepare5:begin
				case (lcr5[/*`UART_LC_BITS5*/1:0])  // number5 of bits in a word5
				2'b00 : rbit_counter5 <= #1 3'b100;
				2'b01 : rbit_counter5 <= #1 3'b101;
				2'b10 : rbit_counter5 <= #1 3'b110;
				2'b11 : rbit_counter5 <= #1 3'b111;
				endcase
				if (rcounter16_eq_05)
				begin
					rstate		<= #1 sr_rec_bit5;
					rcounter165	<= #1 4'b1110;
					rshift5		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare5;
				rcounter165 <= #1 rcounter16_minus_15;
			end
	sr_rec_bit5 :	begin
				if (rcounter16_eq_05)
					rstate <= #1 sr_end_bit5;
				if (rcounter16_eq_75) // read the bit
					case (lcr5[/*`UART_LC_BITS5*/1:0])  // number5 of bits in a word5
					2'b00 : rshift5[4:0]  <= #1 {srx_pad_i5, rshift5[4:1]};
					2'b01 : rshift5[5:0]  <= #1 {srx_pad_i5, rshift5[5:1]};
					2'b10 : rshift5[6:0]  <= #1 {srx_pad_i5, rshift5[6:1]};
					2'b11 : rshift5[7:0]  <= #1 {srx_pad_i5, rshift5[7:1]};
					endcase
				rcounter165 <= #1 rcounter16_minus_15;
			end
	sr_end_bit5 :   begin
				if (rbit_counter5==3'b0) // no more bits in word5
					if (lcr5[`UART_LC_PE5]) // choose5 state based on parity5
						rstate <= #1 sr_rec_parity5;
					else
					begin
						rstate <= #1 sr_rec_stop5;
						rparity_error5 <= #1 1'b0;  // no parity5 - no error :)
					end
				else		// else we5 have more bits to read
				begin
					rstate <= #1 sr_rec_bit5;
					rbit_counter5 <= #1 rbit_counter5 - 1'b1;
				end
				rcounter165 <= #1 4'b1110;
			end
	sr_rec_parity5: begin
				if (rcounter16_eq_75)	// read the parity5
				begin
					rparity5 <= #1 srx_pad_i5;
					rstate <= #1 sr_ca_lc_parity5;
				end
				rcounter165 <= #1 rcounter16_minus_15;
			end
	sr_ca_lc_parity5 : begin    // rcounter5 equals5 6
				rcounter165  <= #1 rcounter16_minus_15;
				rparity_xor5 <= #1 ^{rshift5,rparity5}; // calculate5 parity5 on all incoming5 data
				rstate      <= #1 sr_check_parity5;
			  end
	sr_check_parity5: begin	  // rcounter5 equals5 5
				case ({lcr5[`UART_LC_EP5],lcr5[`UART_LC_SP5]})
					2'b00: rparity_error5 <= #1  rparity_xor5 == 0;  // no error if parity5 1
					2'b01: rparity_error5 <= #1 ~rparity5;      // parity5 should sticked5 to 1
					2'b10: rparity_error5 <= #1  rparity_xor5 == 1;   // error if parity5 is odd5
					2'b11: rparity_error5 <= #1  rparity5;	  // parity5 should be sticked5 to 0
				endcase
				rcounter165 <= #1 rcounter16_minus_15;
				rstate <= #1 sr_wait15;
			  end
	sr_wait15 :	if (rcounter16_eq_05)
			begin
				rstate <= #1 sr_rec_stop5;
				rcounter165 <= #1 4'b1110;
			end
			else
				rcounter165 <= #1 rcounter16_minus_15;
	sr_rec_stop5 :	begin
				if (rcounter16_eq_75)	// read the parity5
				begin
					rframing_error5 <= #1 !srx_pad_i5; // no framing5 error if input is 1 (stop bit)
					rstate <= #1 sr_push5;
				end
				rcounter165 <= #1 rcounter16_minus_15;
			end
	sr_push5 :	begin
///////////////////////////////////////
//				$display($time, ": received5: %b", rf_data_in5);
        if(srx_pad_i5 | break_error5)
          begin
            if(break_error5)
        		  rf_data_in5 	<= #1 {8'b0, 3'b100}; // break input (empty5 character5) to receiver5 FIFO
            else
        			rf_data_in5  <= #1 {rshift5, 1'b0, rparity_error5, rframing_error5};
      		  rf_push5 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle5;
          end
        else if(~rframing_error5)  // There's always a framing5 before break_error5 -> wait for break or srx_pad_i5
          begin
       			rf_data_in5  <= #1 {rshift5, 1'b0, rparity_error5, rframing_error5};
      		  rf_push5 		  <= #1 1'b1;
      			rcounter165 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start5;
          end
                      
			end
	default : rstate <= #1 sr_idle5;
	endcase
  end  // if (enable)
end // always of receiver5

always @ (posedge clk5 or posedge wb_rst_i5)
begin
  if(wb_rst_i5)
    rf_push_q5 <= 0;
  else
    rf_push_q5 <= #1 rf_push5;
end

assign rf_push_pulse5 = rf_push5 & ~rf_push_q5;

  
//
// Break5 condition detection5.
// Works5 in conjuction5 with the receiver5 state machine5

reg 	[9:0]	toc_value5; // value to be set to timeout counter

always @(lcr5)
	case (lcr5[3:0])
		4'b0000										: toc_value5 = 447; // 7 bits
		4'b0100										: toc_value5 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value5 = 511; // 8 bits
		4'b1100										: toc_value5 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value5 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value5 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value5 = 703; // 11 bits
		4'b1111										: toc_value5 = 767; // 12 bits
	endcase // case(lcr5[3:0])

wire [7:0] 	brc_value5; // value to be set to break counter
assign 		brc_value5 = toc_value5[9:2]; // the same as timeout but 1 insead5 of 4 character5 times

always @(posedge clk5 or posedge wb_rst_i5)
begin
	if (wb_rst_i5)
		counter_b5 <= #1 8'd159;
	else
	if (srx_pad_i5)
		counter_b5 <= #1 brc_value5; // character5 time length - 1
	else
	if(enable & counter_b5 != 8'b0)            // only work5 on enable times  break not reached5.
		counter_b5 <= #1 counter_b5 - 1;  // decrement break counter
end // always of break condition detection5

///
/// Timeout5 condition detection5
reg	[9:0]	counter_t5;	// counts5 the timeout condition clocks5

always @(posedge clk5 or posedge wb_rst_i5)
begin
	if (wb_rst_i5)
		counter_t5 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse5 || rf_pop5 || rf_count5 == 0) // counter is reset when RX5 FIFO is empty5, accessed or above5 trigger level
			counter_t5 <= #1 toc_value5;
		else
		if (enable && counter_t5 != 10'b0)  // we5 don5't want5 to underflow5
			counter_t5 <= #1 counter_t5 - 1;		
end
	
endmodule
