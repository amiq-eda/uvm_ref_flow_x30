//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver17.v                                             ////
////                                                              ////
////                                                              ////
////  This17 file is part of the "UART17 16550 compatible17" project17    ////
////  http17://www17.opencores17.org17/cores17/uart1655017/                   ////
////                                                              ////
////  Documentation17 related17 to this project17:                      ////
////  - http17://www17.opencores17.org17/cores17/uart1655017/                 ////
////                                                              ////
////  Projects17 compatibility17:                                     ////
////  - WISHBONE17                                                  ////
////  RS23217 Protocol17                                              ////
////  16550D uart17 (mostly17 supported)                              ////
////                                                              ////
////  Overview17 (main17 Features17):                                   ////
////  UART17 core17 receiver17 logic                                    ////
////                                                              ////
////  Known17 problems17 (limits17):                                    ////
////  None17 known17                                                  ////
////                                                              ////
////  To17 Do17:                                                      ////
////  Thourough17 testing17.                                          ////
////                                                              ////
////  Author17(s):                                                  ////
////      - gorban17@opencores17.org17                                  ////
////      - Jacob17 Gorban17                                          ////
////      - Igor17 Mohor17 (igorm17@opencores17.org17)                      ////
////                                                              ////
////  Created17:        2001/05/12                                  ////
////  Last17 Updated17:   2001/05/17                                  ////
////                  (See log17 for the revision17 history17)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2000, 2001 Authors17                             ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS17 Revision17 History17
//
// $Log: not supported by cvs2svn17 $
// Revision17 1.29  2002/07/29 21:16:18  gorban17
// The uart_defines17.v file is included17 again17 in sources17.
//
// Revision17 1.28  2002/07/22 23:02:23  gorban17
// Bug17 Fixes17:
//  * Possible17 loss of sync and bad17 reception17 of stop bit on slow17 baud17 rates17 fixed17.
//   Problem17 reported17 by Kenny17.Tung17.
//  * Bad (or lack17 of ) loopback17 handling17 fixed17. Reported17 by Cherry17 Withers17.
//
// Improvements17:
//  * Made17 FIFO's as general17 inferrable17 memory where possible17.
//  So17 on FPGA17 they should be inferred17 as RAM17 (Distributed17 RAM17 on Xilinx17).
//  This17 saves17 about17 1/3 of the Slice17 count and reduces17 P&R and synthesis17 times.
//
//  * Added17 optional17 baudrate17 output (baud_o17).
//  This17 is identical17 to BAUDOUT17* signal17 on 16550 chip17.
//  It outputs17 16xbit_clock_rate - the divided17 clock17.
//  It's disabled by default. Define17 UART_HAS_BAUDRATE_OUTPUT17 to use.
//
// Revision17 1.27  2001/12/30 20:39:13  mohor17
// More than one character17 was stored17 in case of break. End17 of the break
// was not detected correctly.
//
// Revision17 1.26  2001/12/20 13:28:27  mohor17
// Missing17 declaration17 of rf_push_q17 fixed17.
//
// Revision17 1.25  2001/12/20 13:25:46  mohor17
// rx17 push17 changed to be only one cycle wide17.
//
// Revision17 1.24  2001/12/19 08:03:34  mohor17
// Warnings17 cleared17.
//
// Revision17 1.23  2001/12/19 07:33:54  mohor17
// Synplicity17 was having17 troubles17 with the comment17.
//
// Revision17 1.22  2001/12/17 14:46:48  mohor17
// overrun17 signal17 was moved to separate17 block because many17 sequential17 lsr17
// reads were17 preventing17 data from being written17 to rx17 fifo.
// underrun17 signal17 was not used and was removed from the project17.
//
// Revision17 1.21  2001/12/13 10:31:16  mohor17
// timeout irq17 must be set regardless17 of the rda17 irq17 (rda17 irq17 does not reset the
// timeout counter).
//
// Revision17 1.20  2001/12/10 19:52:05  gorban17
// Igor17 fixed17 break condition bugs17
//
// Revision17 1.19  2001/12/06 14:51:04  gorban17
// Bug17 in LSR17[0] is fixed17.
// All WISHBONE17 signals17 are now sampled17, so another17 wait-state is introduced17 on all transfers17.
//
// Revision17 1.18  2001/12/03 21:44:29  gorban17
// Updated17 specification17 documentation.
// Added17 full 32-bit data bus interface, now as default.
// Address is 5-bit wide17 in 32-bit data bus mode.
// Added17 wb_sel_i17 input to the core17. It's used in the 32-bit mode.
// Added17 debug17 interface with two17 32-bit read-only registers in 32-bit mode.
// Bits17 5 and 6 of LSR17 are now only cleared17 on TX17 FIFO write.
// My17 small test bench17 is modified to work17 with 32-bit mode.
//
// Revision17 1.17  2001/11/28 19:36:39  gorban17
// Fixed17: timeout and break didn17't pay17 attention17 to current data format17 when counting17 time
//
// Revision17 1.16  2001/11/27 22:17:09  gorban17
// Fixed17 bug17 that prevented17 synthesis17 in uart_receiver17.v
//
// Revision17 1.15  2001/11/26 21:38:54  gorban17
// Lots17 of fixes17:
// Break17 condition wasn17't handled17 correctly at all.
// LSR17 bits could lose17 their17 values.
// LSR17 value after reset was wrong17.
// Timing17 of THRE17 interrupt17 signal17 corrected17.
// LSR17 bit 0 timing17 corrected17.
//
// Revision17 1.14  2001/11/10 12:43:21  gorban17
// Logic17 Synthesis17 bugs17 fixed17. Some17 other minor17 changes17
//
// Revision17 1.13  2001/11/08 14:54:23  mohor17
// Comments17 in Slovene17 language17 deleted17, few17 small fixes17 for better17 work17 of
// old17 tools17. IRQs17 need to be fix17.
//
// Revision17 1.12  2001/11/07 17:51:52  gorban17
// Heavily17 rewritten17 interrupt17 and LSR17 subsystems17.
// Many17 bugs17 hopefully17 squashed17.
//
// Revision17 1.11  2001/10/31 15:19:22  gorban17
// Fixes17 to break and timeout conditions17
//
// Revision17 1.10  2001/10/20 09:58:40  gorban17
// Small17 synopsis17 fixes17
//
// Revision17 1.9  2001/08/24 21:01:12  mohor17
// Things17 connected17 to parity17 changed.
// Clock17 devider17 changed.
//
// Revision17 1.8  2001/08/23 16:05:05  mohor17
// Stop bit bug17 fixed17.
// Parity17 bug17 fixed17.
// WISHBONE17 read cycle bug17 fixed17,
// OE17 indicator17 (Overrun17 Error) bug17 fixed17.
// PE17 indicator17 (Parity17 Error) bug17 fixed17.
// Register read bug17 fixed17.
//
// Revision17 1.6  2001/06/23 11:21:48  gorban17
// DL17 made17 16-bit long17. Fixed17 transmission17/reception17 bugs17.
//
// Revision17 1.5  2001/06/02 14:28:14  gorban17
// Fixed17 receiver17 and transmitter17. Major17 bug17 fixed17.
//
// Revision17 1.4  2001/05/31 20:08:01  gorban17
// FIFO changes17 and other corrections17.
//
// Revision17 1.3  2001/05/27 17:37:49  gorban17
// Fixed17 many17 bugs17. Updated17 spec17. Changed17 FIFO files structure17. See CHANGES17.txt17 file.
//
// Revision17 1.2  2001/05/21 19:12:02  gorban17
// Corrected17 some17 Linter17 messages17.
//
// Revision17 1.1  2001/05/17 18:34:18  gorban17
// First17 'stable' release. Should17 be sythesizable17 now. Also17 added new header.
//
// Revision17 1.0  2001-05-17 21:27:11+02  jacob17
// Initial17 revision17
//
//

// synopsys17 translate_off17
`include "timescale.v"
// synopsys17 translate_on17

`include "uart_defines17.v"

module uart_receiver17 (clk17, wb_rst_i17, lcr17, rf_pop17, srx_pad_i17, enable, 
	counter_t17, rf_count17, rf_data_out17, rf_error_bit17, rf_overrun17, rx_reset17, lsr_mask17, rstate, rf_push_pulse17);

input				clk17;
input				wb_rst_i17;
input	[7:0]	lcr17;
input				rf_pop17;
input				srx_pad_i17;
input				enable;
input				rx_reset17;
input       lsr_mask17;

output	[9:0]			counter_t17;
output	[`UART_FIFO_COUNTER_W17-1:0]	rf_count17;
output	[`UART_FIFO_REC_WIDTH17-1:0]	rf_data_out17;
output				rf_overrun17;
output				rf_error_bit17;
output [3:0] 		rstate;
output 				rf_push_pulse17;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1617;
reg	[2:0]	rbit_counter17;
reg	[7:0]	rshift17;			// receiver17 shift17 register
reg		rparity17;		// received17 parity17
reg		rparity_error17;
reg		rframing_error17;		// framing17 error flag17
reg		rbit_in17;
reg		rparity_xor17;
reg	[7:0]	counter_b17;	// counts17 the 0 (low17) signals17
reg   rf_push_q17;

// RX17 FIFO signals17
reg	[`UART_FIFO_REC_WIDTH17-1:0]	rf_data_in17;
wire	[`UART_FIFO_REC_WIDTH17-1:0]	rf_data_out17;
wire      rf_push_pulse17;
reg				rf_push17;
wire				rf_pop17;
wire				rf_overrun17;
wire	[`UART_FIFO_COUNTER_W17-1:0]	rf_count17;
wire				rf_error_bit17; // an error (parity17 or framing17) is inside the fifo
wire 				break_error17 = (counter_b17 == 0);

// RX17 FIFO instance
uart_rfifo17 #(`UART_FIFO_REC_WIDTH17) fifo_rx17(
	.clk17(		clk17		), 
	.wb_rst_i17(	wb_rst_i17	),
	.data_in17(	rf_data_in17	),
	.data_out17(	rf_data_out17	),
	.push17(		rf_push_pulse17		),
	.pop17(		rf_pop17		),
	.overrun17(	rf_overrun17	),
	.count(		rf_count17	),
	.error_bit17(	rf_error_bit17	),
	.fifo_reset17(	rx_reset17	),
	.reset_status17(lsr_mask17)
);

wire 		rcounter16_eq_717 = (rcounter1617 == 4'd7);
wire		rcounter16_eq_017 = (rcounter1617 == 4'd0);
wire		rcounter16_eq_117 = (rcounter1617 == 4'd1);

wire [3:0] rcounter16_minus_117 = rcounter1617 - 1'b1;

parameter  sr_idle17 					= 4'd0;
parameter  sr_rec_start17 			= 4'd1;
parameter  sr_rec_bit17 				= 4'd2;
parameter  sr_rec_parity17			= 4'd3;
parameter  sr_rec_stop17 				= 4'd4;
parameter  sr_check_parity17 		= 4'd5;
parameter  sr_rec_prepare17 			= 4'd6;
parameter  sr_end_bit17				= 4'd7;
parameter  sr_ca_lc_parity17	      = 4'd8;
parameter  sr_wait117 					= 4'd9;
parameter  sr_push17 					= 4'd10;


always @(posedge clk17 or posedge wb_rst_i17)
begin
  if (wb_rst_i17)
  begin
     rstate 			<= #1 sr_idle17;
	  rbit_in17 				<= #1 1'b0;
	  rcounter1617 			<= #1 0;
	  rbit_counter17 		<= #1 0;
	  rparity_xor17 		<= #1 1'b0;
	  rframing_error17 	<= #1 1'b0;
	  rparity_error17 		<= #1 1'b0;
	  rparity17 				<= #1 1'b0;
	  rshift17 				<= #1 0;
	  rf_push17 				<= #1 1'b0;
	  rf_data_in17 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle17 : begin
			rf_push17 			  <= #1 1'b0;
			rf_data_in17 	  <= #1 0;
			rcounter1617 	  <= #1 4'b1110;
			if (srx_pad_i17==1'b0 & ~break_error17)   // detected a pulse17 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start17;
			end
		end
	sr_rec_start17 :	begin
  			rf_push17 			  <= #1 1'b0;
				if (rcounter16_eq_717)    // check the pulse17
					if (srx_pad_i17==1'b1)   // no start bit
						rstate <= #1 sr_idle17;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare17;
				rcounter1617 <= #1 rcounter16_minus_117;
			end
	sr_rec_prepare17:begin
				case (lcr17[/*`UART_LC_BITS17*/1:0])  // number17 of bits in a word17
				2'b00 : rbit_counter17 <= #1 3'b100;
				2'b01 : rbit_counter17 <= #1 3'b101;
				2'b10 : rbit_counter17 <= #1 3'b110;
				2'b11 : rbit_counter17 <= #1 3'b111;
				endcase
				if (rcounter16_eq_017)
				begin
					rstate		<= #1 sr_rec_bit17;
					rcounter1617	<= #1 4'b1110;
					rshift17		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare17;
				rcounter1617 <= #1 rcounter16_minus_117;
			end
	sr_rec_bit17 :	begin
				if (rcounter16_eq_017)
					rstate <= #1 sr_end_bit17;
				if (rcounter16_eq_717) // read the bit
					case (lcr17[/*`UART_LC_BITS17*/1:0])  // number17 of bits in a word17
					2'b00 : rshift17[4:0]  <= #1 {srx_pad_i17, rshift17[4:1]};
					2'b01 : rshift17[5:0]  <= #1 {srx_pad_i17, rshift17[5:1]};
					2'b10 : rshift17[6:0]  <= #1 {srx_pad_i17, rshift17[6:1]};
					2'b11 : rshift17[7:0]  <= #1 {srx_pad_i17, rshift17[7:1]};
					endcase
				rcounter1617 <= #1 rcounter16_minus_117;
			end
	sr_end_bit17 :   begin
				if (rbit_counter17==3'b0) // no more bits in word17
					if (lcr17[`UART_LC_PE17]) // choose17 state based on parity17
						rstate <= #1 sr_rec_parity17;
					else
					begin
						rstate <= #1 sr_rec_stop17;
						rparity_error17 <= #1 1'b0;  // no parity17 - no error :)
					end
				else		// else we17 have more bits to read
				begin
					rstate <= #1 sr_rec_bit17;
					rbit_counter17 <= #1 rbit_counter17 - 1'b1;
				end
				rcounter1617 <= #1 4'b1110;
			end
	sr_rec_parity17: begin
				if (rcounter16_eq_717)	// read the parity17
				begin
					rparity17 <= #1 srx_pad_i17;
					rstate <= #1 sr_ca_lc_parity17;
				end
				rcounter1617 <= #1 rcounter16_minus_117;
			end
	sr_ca_lc_parity17 : begin    // rcounter17 equals17 6
				rcounter1617  <= #1 rcounter16_minus_117;
				rparity_xor17 <= #1 ^{rshift17,rparity17}; // calculate17 parity17 on all incoming17 data
				rstate      <= #1 sr_check_parity17;
			  end
	sr_check_parity17: begin	  // rcounter17 equals17 5
				case ({lcr17[`UART_LC_EP17],lcr17[`UART_LC_SP17]})
					2'b00: rparity_error17 <= #1  rparity_xor17 == 0;  // no error if parity17 1
					2'b01: rparity_error17 <= #1 ~rparity17;      // parity17 should sticked17 to 1
					2'b10: rparity_error17 <= #1  rparity_xor17 == 1;   // error if parity17 is odd17
					2'b11: rparity_error17 <= #1  rparity17;	  // parity17 should be sticked17 to 0
				endcase
				rcounter1617 <= #1 rcounter16_minus_117;
				rstate <= #1 sr_wait117;
			  end
	sr_wait117 :	if (rcounter16_eq_017)
			begin
				rstate <= #1 sr_rec_stop17;
				rcounter1617 <= #1 4'b1110;
			end
			else
				rcounter1617 <= #1 rcounter16_minus_117;
	sr_rec_stop17 :	begin
				if (rcounter16_eq_717)	// read the parity17
				begin
					rframing_error17 <= #1 !srx_pad_i17; // no framing17 error if input is 1 (stop bit)
					rstate <= #1 sr_push17;
				end
				rcounter1617 <= #1 rcounter16_minus_117;
			end
	sr_push17 :	begin
///////////////////////////////////////
//				$display($time, ": received17: %b", rf_data_in17);
        if(srx_pad_i17 | break_error17)
          begin
            if(break_error17)
        		  rf_data_in17 	<= #1 {8'b0, 3'b100}; // break input (empty17 character17) to receiver17 FIFO
            else
        			rf_data_in17  <= #1 {rshift17, 1'b0, rparity_error17, rframing_error17};
      		  rf_push17 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle17;
          end
        else if(~rframing_error17)  // There's always a framing17 before break_error17 -> wait for break or srx_pad_i17
          begin
       			rf_data_in17  <= #1 {rshift17, 1'b0, rparity_error17, rframing_error17};
      		  rf_push17 		  <= #1 1'b1;
      			rcounter1617 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start17;
          end
                      
			end
	default : rstate <= #1 sr_idle17;
	endcase
  end  // if (enable)
end // always of receiver17

always @ (posedge clk17 or posedge wb_rst_i17)
begin
  if(wb_rst_i17)
    rf_push_q17 <= 0;
  else
    rf_push_q17 <= #1 rf_push17;
end

assign rf_push_pulse17 = rf_push17 & ~rf_push_q17;

  
//
// Break17 condition detection17.
// Works17 in conjuction17 with the receiver17 state machine17

reg 	[9:0]	toc_value17; // value to be set to timeout counter

always @(lcr17)
	case (lcr17[3:0])
		4'b0000										: toc_value17 = 447; // 7 bits
		4'b0100										: toc_value17 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value17 = 511; // 8 bits
		4'b1100										: toc_value17 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value17 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value17 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value17 = 703; // 11 bits
		4'b1111										: toc_value17 = 767; // 12 bits
	endcase // case(lcr17[3:0])

wire [7:0] 	brc_value17; // value to be set to break counter
assign 		brc_value17 = toc_value17[9:2]; // the same as timeout but 1 insead17 of 4 character17 times

always @(posedge clk17 or posedge wb_rst_i17)
begin
	if (wb_rst_i17)
		counter_b17 <= #1 8'd159;
	else
	if (srx_pad_i17)
		counter_b17 <= #1 brc_value17; // character17 time length - 1
	else
	if(enable & counter_b17 != 8'b0)            // only work17 on enable times  break not reached17.
		counter_b17 <= #1 counter_b17 - 1;  // decrement break counter
end // always of break condition detection17

///
/// Timeout17 condition detection17
reg	[9:0]	counter_t17;	// counts17 the timeout condition clocks17

always @(posedge clk17 or posedge wb_rst_i17)
begin
	if (wb_rst_i17)
		counter_t17 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse17 || rf_pop17 || rf_count17 == 0) // counter is reset when RX17 FIFO is empty17, accessed or above17 trigger level
			counter_t17 <= #1 toc_value17;
		else
		if (enable && counter_t17 != 10'b0)  // we17 don17't want17 to underflow17
			counter_t17 <= #1 counter_t17 - 1;		
end
	
endmodule
