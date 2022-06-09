//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver23.v                                             ////
////                                                              ////
////                                                              ////
////  This23 file is part of the "UART23 16550 compatible23" project23    ////
////  http23://www23.opencores23.org23/cores23/uart1655023/                   ////
////                                                              ////
////  Documentation23 related23 to this project23:                      ////
////  - http23://www23.opencores23.org23/cores23/uart1655023/                 ////
////                                                              ////
////  Projects23 compatibility23:                                     ////
////  - WISHBONE23                                                  ////
////  RS23223 Protocol23                                              ////
////  16550D uart23 (mostly23 supported)                              ////
////                                                              ////
////  Overview23 (main23 Features23):                                   ////
////  UART23 core23 receiver23 logic                                    ////
////                                                              ////
////  Known23 problems23 (limits23):                                    ////
////  None23 known23                                                  ////
////                                                              ////
////  To23 Do23:                                                      ////
////  Thourough23 testing23.                                          ////
////                                                              ////
////  Author23(s):                                                  ////
////      - gorban23@opencores23.org23                                  ////
////      - Jacob23 Gorban23                                          ////
////      - Igor23 Mohor23 (igorm23@opencores23.org23)                      ////
////                                                              ////
////  Created23:        2001/05/12                                  ////
////  Last23 Updated23:   2001/05/17                                  ////
////                  (See log23 for the revision23 history23)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2000, 2001 Authors23                             ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS23 Revision23 History23
//
// $Log: not supported by cvs2svn23 $
// Revision23 1.29  2002/07/29 21:16:18  gorban23
// The uart_defines23.v file is included23 again23 in sources23.
//
// Revision23 1.28  2002/07/22 23:02:23  gorban23
// Bug23 Fixes23:
//  * Possible23 loss of sync and bad23 reception23 of stop bit on slow23 baud23 rates23 fixed23.
//   Problem23 reported23 by Kenny23.Tung23.
//  * Bad (or lack23 of ) loopback23 handling23 fixed23. Reported23 by Cherry23 Withers23.
//
// Improvements23:
//  * Made23 FIFO's as general23 inferrable23 memory where possible23.
//  So23 on FPGA23 they should be inferred23 as RAM23 (Distributed23 RAM23 on Xilinx23).
//  This23 saves23 about23 1/3 of the Slice23 count and reduces23 P&R and synthesis23 times.
//
//  * Added23 optional23 baudrate23 output (baud_o23).
//  This23 is identical23 to BAUDOUT23* signal23 on 16550 chip23.
//  It outputs23 16xbit_clock_rate - the divided23 clock23.
//  It's disabled by default. Define23 UART_HAS_BAUDRATE_OUTPUT23 to use.
//
// Revision23 1.27  2001/12/30 20:39:13  mohor23
// More than one character23 was stored23 in case of break. End23 of the break
// was not detected correctly.
//
// Revision23 1.26  2001/12/20 13:28:27  mohor23
// Missing23 declaration23 of rf_push_q23 fixed23.
//
// Revision23 1.25  2001/12/20 13:25:46  mohor23
// rx23 push23 changed to be only one cycle wide23.
//
// Revision23 1.24  2001/12/19 08:03:34  mohor23
// Warnings23 cleared23.
//
// Revision23 1.23  2001/12/19 07:33:54  mohor23
// Synplicity23 was having23 troubles23 with the comment23.
//
// Revision23 1.22  2001/12/17 14:46:48  mohor23
// overrun23 signal23 was moved to separate23 block because many23 sequential23 lsr23
// reads were23 preventing23 data from being written23 to rx23 fifo.
// underrun23 signal23 was not used and was removed from the project23.
//
// Revision23 1.21  2001/12/13 10:31:16  mohor23
// timeout irq23 must be set regardless23 of the rda23 irq23 (rda23 irq23 does not reset the
// timeout counter).
//
// Revision23 1.20  2001/12/10 19:52:05  gorban23
// Igor23 fixed23 break condition bugs23
//
// Revision23 1.19  2001/12/06 14:51:04  gorban23
// Bug23 in LSR23[0] is fixed23.
// All WISHBONE23 signals23 are now sampled23, so another23 wait-state is introduced23 on all transfers23.
//
// Revision23 1.18  2001/12/03 21:44:29  gorban23
// Updated23 specification23 documentation.
// Added23 full 32-bit data bus interface, now as default.
// Address is 5-bit wide23 in 32-bit data bus mode.
// Added23 wb_sel_i23 input to the core23. It's used in the 32-bit mode.
// Added23 debug23 interface with two23 32-bit read-only registers in 32-bit mode.
// Bits23 5 and 6 of LSR23 are now only cleared23 on TX23 FIFO write.
// My23 small test bench23 is modified to work23 with 32-bit mode.
//
// Revision23 1.17  2001/11/28 19:36:39  gorban23
// Fixed23: timeout and break didn23't pay23 attention23 to current data format23 when counting23 time
//
// Revision23 1.16  2001/11/27 22:17:09  gorban23
// Fixed23 bug23 that prevented23 synthesis23 in uart_receiver23.v
//
// Revision23 1.15  2001/11/26 21:38:54  gorban23
// Lots23 of fixes23:
// Break23 condition wasn23't handled23 correctly at all.
// LSR23 bits could lose23 their23 values.
// LSR23 value after reset was wrong23.
// Timing23 of THRE23 interrupt23 signal23 corrected23.
// LSR23 bit 0 timing23 corrected23.
//
// Revision23 1.14  2001/11/10 12:43:21  gorban23
// Logic23 Synthesis23 bugs23 fixed23. Some23 other minor23 changes23
//
// Revision23 1.13  2001/11/08 14:54:23  mohor23
// Comments23 in Slovene23 language23 deleted23, few23 small fixes23 for better23 work23 of
// old23 tools23. IRQs23 need to be fix23.
//
// Revision23 1.12  2001/11/07 17:51:52  gorban23
// Heavily23 rewritten23 interrupt23 and LSR23 subsystems23.
// Many23 bugs23 hopefully23 squashed23.
//
// Revision23 1.11  2001/10/31 15:19:22  gorban23
// Fixes23 to break and timeout conditions23
//
// Revision23 1.10  2001/10/20 09:58:40  gorban23
// Small23 synopsis23 fixes23
//
// Revision23 1.9  2001/08/24 21:01:12  mohor23
// Things23 connected23 to parity23 changed.
// Clock23 devider23 changed.
//
// Revision23 1.8  2001/08/23 16:05:05  mohor23
// Stop bit bug23 fixed23.
// Parity23 bug23 fixed23.
// WISHBONE23 read cycle bug23 fixed23,
// OE23 indicator23 (Overrun23 Error) bug23 fixed23.
// PE23 indicator23 (Parity23 Error) bug23 fixed23.
// Register read bug23 fixed23.
//
// Revision23 1.6  2001/06/23 11:21:48  gorban23
// DL23 made23 16-bit long23. Fixed23 transmission23/reception23 bugs23.
//
// Revision23 1.5  2001/06/02 14:28:14  gorban23
// Fixed23 receiver23 and transmitter23. Major23 bug23 fixed23.
//
// Revision23 1.4  2001/05/31 20:08:01  gorban23
// FIFO changes23 and other corrections23.
//
// Revision23 1.3  2001/05/27 17:37:49  gorban23
// Fixed23 many23 bugs23. Updated23 spec23. Changed23 FIFO files structure23. See CHANGES23.txt23 file.
//
// Revision23 1.2  2001/05/21 19:12:02  gorban23
// Corrected23 some23 Linter23 messages23.
//
// Revision23 1.1  2001/05/17 18:34:18  gorban23
// First23 'stable' release. Should23 be sythesizable23 now. Also23 added new header.
//
// Revision23 1.0  2001-05-17 21:27:11+02  jacob23
// Initial23 revision23
//
//

// synopsys23 translate_off23
`include "timescale.v"
// synopsys23 translate_on23

`include "uart_defines23.v"

module uart_receiver23 (clk23, wb_rst_i23, lcr23, rf_pop23, srx_pad_i23, enable, 
	counter_t23, rf_count23, rf_data_out23, rf_error_bit23, rf_overrun23, rx_reset23, lsr_mask23, rstate, rf_push_pulse23);

input				clk23;
input				wb_rst_i23;
input	[7:0]	lcr23;
input				rf_pop23;
input				srx_pad_i23;
input				enable;
input				rx_reset23;
input       lsr_mask23;

output	[9:0]			counter_t23;
output	[`UART_FIFO_COUNTER_W23-1:0]	rf_count23;
output	[`UART_FIFO_REC_WIDTH23-1:0]	rf_data_out23;
output				rf_overrun23;
output				rf_error_bit23;
output [3:0] 		rstate;
output 				rf_push_pulse23;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1623;
reg	[2:0]	rbit_counter23;
reg	[7:0]	rshift23;			// receiver23 shift23 register
reg		rparity23;		// received23 parity23
reg		rparity_error23;
reg		rframing_error23;		// framing23 error flag23
reg		rbit_in23;
reg		rparity_xor23;
reg	[7:0]	counter_b23;	// counts23 the 0 (low23) signals23
reg   rf_push_q23;

// RX23 FIFO signals23
reg	[`UART_FIFO_REC_WIDTH23-1:0]	rf_data_in23;
wire	[`UART_FIFO_REC_WIDTH23-1:0]	rf_data_out23;
wire      rf_push_pulse23;
reg				rf_push23;
wire				rf_pop23;
wire				rf_overrun23;
wire	[`UART_FIFO_COUNTER_W23-1:0]	rf_count23;
wire				rf_error_bit23; // an error (parity23 or framing23) is inside the fifo
wire 				break_error23 = (counter_b23 == 0);

// RX23 FIFO instance
uart_rfifo23 #(`UART_FIFO_REC_WIDTH23) fifo_rx23(
	.clk23(		clk23		), 
	.wb_rst_i23(	wb_rst_i23	),
	.data_in23(	rf_data_in23	),
	.data_out23(	rf_data_out23	),
	.push23(		rf_push_pulse23		),
	.pop23(		rf_pop23		),
	.overrun23(	rf_overrun23	),
	.count(		rf_count23	),
	.error_bit23(	rf_error_bit23	),
	.fifo_reset23(	rx_reset23	),
	.reset_status23(lsr_mask23)
);

wire 		rcounter16_eq_723 = (rcounter1623 == 4'd7);
wire		rcounter16_eq_023 = (rcounter1623 == 4'd0);
wire		rcounter16_eq_123 = (rcounter1623 == 4'd1);

wire [3:0] rcounter16_minus_123 = rcounter1623 - 1'b1;

parameter  sr_idle23 					= 4'd0;
parameter  sr_rec_start23 			= 4'd1;
parameter  sr_rec_bit23 				= 4'd2;
parameter  sr_rec_parity23			= 4'd3;
parameter  sr_rec_stop23 				= 4'd4;
parameter  sr_check_parity23 		= 4'd5;
parameter  sr_rec_prepare23 			= 4'd6;
parameter  sr_end_bit23				= 4'd7;
parameter  sr_ca_lc_parity23	      = 4'd8;
parameter  sr_wait123 					= 4'd9;
parameter  sr_push23 					= 4'd10;


always @(posedge clk23 or posedge wb_rst_i23)
begin
  if (wb_rst_i23)
  begin
     rstate 			<= #1 sr_idle23;
	  rbit_in23 				<= #1 1'b0;
	  rcounter1623 			<= #1 0;
	  rbit_counter23 		<= #1 0;
	  rparity_xor23 		<= #1 1'b0;
	  rframing_error23 	<= #1 1'b0;
	  rparity_error23 		<= #1 1'b0;
	  rparity23 				<= #1 1'b0;
	  rshift23 				<= #1 0;
	  rf_push23 				<= #1 1'b0;
	  rf_data_in23 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle23 : begin
			rf_push23 			  <= #1 1'b0;
			rf_data_in23 	  <= #1 0;
			rcounter1623 	  <= #1 4'b1110;
			if (srx_pad_i23==1'b0 & ~break_error23)   // detected a pulse23 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start23;
			end
		end
	sr_rec_start23 :	begin
  			rf_push23 			  <= #1 1'b0;
				if (rcounter16_eq_723)    // check the pulse23
					if (srx_pad_i23==1'b1)   // no start bit
						rstate <= #1 sr_idle23;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare23;
				rcounter1623 <= #1 rcounter16_minus_123;
			end
	sr_rec_prepare23:begin
				case (lcr23[/*`UART_LC_BITS23*/1:0])  // number23 of bits in a word23
				2'b00 : rbit_counter23 <= #1 3'b100;
				2'b01 : rbit_counter23 <= #1 3'b101;
				2'b10 : rbit_counter23 <= #1 3'b110;
				2'b11 : rbit_counter23 <= #1 3'b111;
				endcase
				if (rcounter16_eq_023)
				begin
					rstate		<= #1 sr_rec_bit23;
					rcounter1623	<= #1 4'b1110;
					rshift23		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare23;
				rcounter1623 <= #1 rcounter16_minus_123;
			end
	sr_rec_bit23 :	begin
				if (rcounter16_eq_023)
					rstate <= #1 sr_end_bit23;
				if (rcounter16_eq_723) // read the bit
					case (lcr23[/*`UART_LC_BITS23*/1:0])  // number23 of bits in a word23
					2'b00 : rshift23[4:0]  <= #1 {srx_pad_i23, rshift23[4:1]};
					2'b01 : rshift23[5:0]  <= #1 {srx_pad_i23, rshift23[5:1]};
					2'b10 : rshift23[6:0]  <= #1 {srx_pad_i23, rshift23[6:1]};
					2'b11 : rshift23[7:0]  <= #1 {srx_pad_i23, rshift23[7:1]};
					endcase
				rcounter1623 <= #1 rcounter16_minus_123;
			end
	sr_end_bit23 :   begin
				if (rbit_counter23==3'b0) // no more bits in word23
					if (lcr23[`UART_LC_PE23]) // choose23 state based on parity23
						rstate <= #1 sr_rec_parity23;
					else
					begin
						rstate <= #1 sr_rec_stop23;
						rparity_error23 <= #1 1'b0;  // no parity23 - no error :)
					end
				else		// else we23 have more bits to read
				begin
					rstate <= #1 sr_rec_bit23;
					rbit_counter23 <= #1 rbit_counter23 - 1'b1;
				end
				rcounter1623 <= #1 4'b1110;
			end
	sr_rec_parity23: begin
				if (rcounter16_eq_723)	// read the parity23
				begin
					rparity23 <= #1 srx_pad_i23;
					rstate <= #1 sr_ca_lc_parity23;
				end
				rcounter1623 <= #1 rcounter16_minus_123;
			end
	sr_ca_lc_parity23 : begin    // rcounter23 equals23 6
				rcounter1623  <= #1 rcounter16_minus_123;
				rparity_xor23 <= #1 ^{rshift23,rparity23}; // calculate23 parity23 on all incoming23 data
				rstate      <= #1 sr_check_parity23;
			  end
	sr_check_parity23: begin	  // rcounter23 equals23 5
				case ({lcr23[`UART_LC_EP23],lcr23[`UART_LC_SP23]})
					2'b00: rparity_error23 <= #1  rparity_xor23 == 0;  // no error if parity23 1
					2'b01: rparity_error23 <= #1 ~rparity23;      // parity23 should sticked23 to 1
					2'b10: rparity_error23 <= #1  rparity_xor23 == 1;   // error if parity23 is odd23
					2'b11: rparity_error23 <= #1  rparity23;	  // parity23 should be sticked23 to 0
				endcase
				rcounter1623 <= #1 rcounter16_minus_123;
				rstate <= #1 sr_wait123;
			  end
	sr_wait123 :	if (rcounter16_eq_023)
			begin
				rstate <= #1 sr_rec_stop23;
				rcounter1623 <= #1 4'b1110;
			end
			else
				rcounter1623 <= #1 rcounter16_minus_123;
	sr_rec_stop23 :	begin
				if (rcounter16_eq_723)	// read the parity23
				begin
					rframing_error23 <= #1 !srx_pad_i23; // no framing23 error if input is 1 (stop bit)
					rstate <= #1 sr_push23;
				end
				rcounter1623 <= #1 rcounter16_minus_123;
			end
	sr_push23 :	begin
///////////////////////////////////////
//				$display($time, ": received23: %b", rf_data_in23);
        if(srx_pad_i23 | break_error23)
          begin
            if(break_error23)
        		  rf_data_in23 	<= #1 {8'b0, 3'b100}; // break input (empty23 character23) to receiver23 FIFO
            else
        			rf_data_in23  <= #1 {rshift23, 1'b0, rparity_error23, rframing_error23};
      		  rf_push23 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle23;
          end
        else if(~rframing_error23)  // There's always a framing23 before break_error23 -> wait for break or srx_pad_i23
          begin
       			rf_data_in23  <= #1 {rshift23, 1'b0, rparity_error23, rframing_error23};
      		  rf_push23 		  <= #1 1'b1;
      			rcounter1623 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start23;
          end
                      
			end
	default : rstate <= #1 sr_idle23;
	endcase
  end  // if (enable)
end // always of receiver23

always @ (posedge clk23 or posedge wb_rst_i23)
begin
  if(wb_rst_i23)
    rf_push_q23 <= 0;
  else
    rf_push_q23 <= #1 rf_push23;
end

assign rf_push_pulse23 = rf_push23 & ~rf_push_q23;

  
//
// Break23 condition detection23.
// Works23 in conjuction23 with the receiver23 state machine23

reg 	[9:0]	toc_value23; // value to be set to timeout counter

always @(lcr23)
	case (lcr23[3:0])
		4'b0000										: toc_value23 = 447; // 7 bits
		4'b0100										: toc_value23 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value23 = 511; // 8 bits
		4'b1100										: toc_value23 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value23 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value23 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value23 = 703; // 11 bits
		4'b1111										: toc_value23 = 767; // 12 bits
	endcase // case(lcr23[3:0])

wire [7:0] 	brc_value23; // value to be set to break counter
assign 		brc_value23 = toc_value23[9:2]; // the same as timeout but 1 insead23 of 4 character23 times

always @(posedge clk23 or posedge wb_rst_i23)
begin
	if (wb_rst_i23)
		counter_b23 <= #1 8'd159;
	else
	if (srx_pad_i23)
		counter_b23 <= #1 brc_value23; // character23 time length - 1
	else
	if(enable & counter_b23 != 8'b0)            // only work23 on enable times  break not reached23.
		counter_b23 <= #1 counter_b23 - 1;  // decrement break counter
end // always of break condition detection23

///
/// Timeout23 condition detection23
reg	[9:0]	counter_t23;	// counts23 the timeout condition clocks23

always @(posedge clk23 or posedge wb_rst_i23)
begin
	if (wb_rst_i23)
		counter_t23 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse23 || rf_pop23 || rf_count23 == 0) // counter is reset when RX23 FIFO is empty23, accessed or above23 trigger level
			counter_t23 <= #1 toc_value23;
		else
		if (enable && counter_t23 != 10'b0)  // we23 don23't want23 to underflow23
			counter_t23 <= #1 counter_t23 - 1;		
end
	
endmodule
