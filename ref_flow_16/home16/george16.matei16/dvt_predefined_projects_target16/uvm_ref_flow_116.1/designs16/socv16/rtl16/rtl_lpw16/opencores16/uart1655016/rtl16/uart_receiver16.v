//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver16.v                                             ////
////                                                              ////
////                                                              ////
////  This16 file is part of the "UART16 16550 compatible16" project16    ////
////  http16://www16.opencores16.org16/cores16/uart1655016/                   ////
////                                                              ////
////  Documentation16 related16 to this project16:                      ////
////  - http16://www16.opencores16.org16/cores16/uart1655016/                 ////
////                                                              ////
////  Projects16 compatibility16:                                     ////
////  - WISHBONE16                                                  ////
////  RS23216 Protocol16                                              ////
////  16550D uart16 (mostly16 supported)                              ////
////                                                              ////
////  Overview16 (main16 Features16):                                   ////
////  UART16 core16 receiver16 logic                                    ////
////                                                              ////
////  Known16 problems16 (limits16):                                    ////
////  None16 known16                                                  ////
////                                                              ////
////  To16 Do16:                                                      ////
////  Thourough16 testing16.                                          ////
////                                                              ////
////  Author16(s):                                                  ////
////      - gorban16@opencores16.org16                                  ////
////      - Jacob16 Gorban16                                          ////
////      - Igor16 Mohor16 (igorm16@opencores16.org16)                      ////
////                                                              ////
////  Created16:        2001/05/12                                  ////
////  Last16 Updated16:   2001/05/17                                  ////
////                  (See log16 for the revision16 history16)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2000, 2001 Authors16                             ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS16 Revision16 History16
//
// $Log: not supported by cvs2svn16 $
// Revision16 1.29  2002/07/29 21:16:18  gorban16
// The uart_defines16.v file is included16 again16 in sources16.
//
// Revision16 1.28  2002/07/22 23:02:23  gorban16
// Bug16 Fixes16:
//  * Possible16 loss of sync and bad16 reception16 of stop bit on slow16 baud16 rates16 fixed16.
//   Problem16 reported16 by Kenny16.Tung16.
//  * Bad (or lack16 of ) loopback16 handling16 fixed16. Reported16 by Cherry16 Withers16.
//
// Improvements16:
//  * Made16 FIFO's as general16 inferrable16 memory where possible16.
//  So16 on FPGA16 they should be inferred16 as RAM16 (Distributed16 RAM16 on Xilinx16).
//  This16 saves16 about16 1/3 of the Slice16 count and reduces16 P&R and synthesis16 times.
//
//  * Added16 optional16 baudrate16 output (baud_o16).
//  This16 is identical16 to BAUDOUT16* signal16 on 16550 chip16.
//  It outputs16 16xbit_clock_rate - the divided16 clock16.
//  It's disabled by default. Define16 UART_HAS_BAUDRATE_OUTPUT16 to use.
//
// Revision16 1.27  2001/12/30 20:39:13  mohor16
// More than one character16 was stored16 in case of break. End16 of the break
// was not detected correctly.
//
// Revision16 1.26  2001/12/20 13:28:27  mohor16
// Missing16 declaration16 of rf_push_q16 fixed16.
//
// Revision16 1.25  2001/12/20 13:25:46  mohor16
// rx16 push16 changed to be only one cycle wide16.
//
// Revision16 1.24  2001/12/19 08:03:34  mohor16
// Warnings16 cleared16.
//
// Revision16 1.23  2001/12/19 07:33:54  mohor16
// Synplicity16 was having16 troubles16 with the comment16.
//
// Revision16 1.22  2001/12/17 14:46:48  mohor16
// overrun16 signal16 was moved to separate16 block because many16 sequential16 lsr16
// reads were16 preventing16 data from being written16 to rx16 fifo.
// underrun16 signal16 was not used and was removed from the project16.
//
// Revision16 1.21  2001/12/13 10:31:16  mohor16
// timeout irq16 must be set regardless16 of the rda16 irq16 (rda16 irq16 does not reset the
// timeout counter).
//
// Revision16 1.20  2001/12/10 19:52:05  gorban16
// Igor16 fixed16 break condition bugs16
//
// Revision16 1.19  2001/12/06 14:51:04  gorban16
// Bug16 in LSR16[0] is fixed16.
// All WISHBONE16 signals16 are now sampled16, so another16 wait-state is introduced16 on all transfers16.
//
// Revision16 1.18  2001/12/03 21:44:29  gorban16
// Updated16 specification16 documentation.
// Added16 full 32-bit data bus interface, now as default.
// Address is 5-bit wide16 in 32-bit data bus mode.
// Added16 wb_sel_i16 input to the core16. It's used in the 32-bit mode.
// Added16 debug16 interface with two16 32-bit read-only registers in 32-bit mode.
// Bits16 5 and 6 of LSR16 are now only cleared16 on TX16 FIFO write.
// My16 small test bench16 is modified to work16 with 32-bit mode.
//
// Revision16 1.17  2001/11/28 19:36:39  gorban16
// Fixed16: timeout and break didn16't pay16 attention16 to current data format16 when counting16 time
//
// Revision16 1.16  2001/11/27 22:17:09  gorban16
// Fixed16 bug16 that prevented16 synthesis16 in uart_receiver16.v
//
// Revision16 1.15  2001/11/26 21:38:54  gorban16
// Lots16 of fixes16:
// Break16 condition wasn16't handled16 correctly at all.
// LSR16 bits could lose16 their16 values.
// LSR16 value after reset was wrong16.
// Timing16 of THRE16 interrupt16 signal16 corrected16.
// LSR16 bit 0 timing16 corrected16.
//
// Revision16 1.14  2001/11/10 12:43:21  gorban16
// Logic16 Synthesis16 bugs16 fixed16. Some16 other minor16 changes16
//
// Revision16 1.13  2001/11/08 14:54:23  mohor16
// Comments16 in Slovene16 language16 deleted16, few16 small fixes16 for better16 work16 of
// old16 tools16. IRQs16 need to be fix16.
//
// Revision16 1.12  2001/11/07 17:51:52  gorban16
// Heavily16 rewritten16 interrupt16 and LSR16 subsystems16.
// Many16 bugs16 hopefully16 squashed16.
//
// Revision16 1.11  2001/10/31 15:19:22  gorban16
// Fixes16 to break and timeout conditions16
//
// Revision16 1.10  2001/10/20 09:58:40  gorban16
// Small16 synopsis16 fixes16
//
// Revision16 1.9  2001/08/24 21:01:12  mohor16
// Things16 connected16 to parity16 changed.
// Clock16 devider16 changed.
//
// Revision16 1.8  2001/08/23 16:05:05  mohor16
// Stop bit bug16 fixed16.
// Parity16 bug16 fixed16.
// WISHBONE16 read cycle bug16 fixed16,
// OE16 indicator16 (Overrun16 Error) bug16 fixed16.
// PE16 indicator16 (Parity16 Error) bug16 fixed16.
// Register read bug16 fixed16.
//
// Revision16 1.6  2001/06/23 11:21:48  gorban16
// DL16 made16 16-bit long16. Fixed16 transmission16/reception16 bugs16.
//
// Revision16 1.5  2001/06/02 14:28:14  gorban16
// Fixed16 receiver16 and transmitter16. Major16 bug16 fixed16.
//
// Revision16 1.4  2001/05/31 20:08:01  gorban16
// FIFO changes16 and other corrections16.
//
// Revision16 1.3  2001/05/27 17:37:49  gorban16
// Fixed16 many16 bugs16. Updated16 spec16. Changed16 FIFO files structure16. See CHANGES16.txt16 file.
//
// Revision16 1.2  2001/05/21 19:12:02  gorban16
// Corrected16 some16 Linter16 messages16.
//
// Revision16 1.1  2001/05/17 18:34:18  gorban16
// First16 'stable' release. Should16 be sythesizable16 now. Also16 added new header.
//
// Revision16 1.0  2001-05-17 21:27:11+02  jacob16
// Initial16 revision16
//
//

// synopsys16 translate_off16
`include "timescale.v"
// synopsys16 translate_on16

`include "uart_defines16.v"

module uart_receiver16 (clk16, wb_rst_i16, lcr16, rf_pop16, srx_pad_i16, enable, 
	counter_t16, rf_count16, rf_data_out16, rf_error_bit16, rf_overrun16, rx_reset16, lsr_mask16, rstate, rf_push_pulse16);

input				clk16;
input				wb_rst_i16;
input	[7:0]	lcr16;
input				rf_pop16;
input				srx_pad_i16;
input				enable;
input				rx_reset16;
input       lsr_mask16;

output	[9:0]			counter_t16;
output	[`UART_FIFO_COUNTER_W16-1:0]	rf_count16;
output	[`UART_FIFO_REC_WIDTH16-1:0]	rf_data_out16;
output				rf_overrun16;
output				rf_error_bit16;
output [3:0] 		rstate;
output 				rf_push_pulse16;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1616;
reg	[2:0]	rbit_counter16;
reg	[7:0]	rshift16;			// receiver16 shift16 register
reg		rparity16;		// received16 parity16
reg		rparity_error16;
reg		rframing_error16;		// framing16 error flag16
reg		rbit_in16;
reg		rparity_xor16;
reg	[7:0]	counter_b16;	// counts16 the 0 (low16) signals16
reg   rf_push_q16;

// RX16 FIFO signals16
reg	[`UART_FIFO_REC_WIDTH16-1:0]	rf_data_in16;
wire	[`UART_FIFO_REC_WIDTH16-1:0]	rf_data_out16;
wire      rf_push_pulse16;
reg				rf_push16;
wire				rf_pop16;
wire				rf_overrun16;
wire	[`UART_FIFO_COUNTER_W16-1:0]	rf_count16;
wire				rf_error_bit16; // an error (parity16 or framing16) is inside the fifo
wire 				break_error16 = (counter_b16 == 0);

// RX16 FIFO instance
uart_rfifo16 #(`UART_FIFO_REC_WIDTH16) fifo_rx16(
	.clk16(		clk16		), 
	.wb_rst_i16(	wb_rst_i16	),
	.data_in16(	rf_data_in16	),
	.data_out16(	rf_data_out16	),
	.push16(		rf_push_pulse16		),
	.pop16(		rf_pop16		),
	.overrun16(	rf_overrun16	),
	.count(		rf_count16	),
	.error_bit16(	rf_error_bit16	),
	.fifo_reset16(	rx_reset16	),
	.reset_status16(lsr_mask16)
);

wire 		rcounter16_eq_716 = (rcounter1616 == 4'd7);
wire		rcounter16_eq_016 = (rcounter1616 == 4'd0);
wire		rcounter16_eq_116 = (rcounter1616 == 4'd1);

wire [3:0] rcounter16_minus_116 = rcounter1616 - 1'b1;

parameter  sr_idle16 					= 4'd0;
parameter  sr_rec_start16 			= 4'd1;
parameter  sr_rec_bit16 				= 4'd2;
parameter  sr_rec_parity16			= 4'd3;
parameter  sr_rec_stop16 				= 4'd4;
parameter  sr_check_parity16 		= 4'd5;
parameter  sr_rec_prepare16 			= 4'd6;
parameter  sr_end_bit16				= 4'd7;
parameter  sr_ca_lc_parity16	      = 4'd8;
parameter  sr_wait116 					= 4'd9;
parameter  sr_push16 					= 4'd10;


always @(posedge clk16 or posedge wb_rst_i16)
begin
  if (wb_rst_i16)
  begin
     rstate 			<= #1 sr_idle16;
	  rbit_in16 				<= #1 1'b0;
	  rcounter1616 			<= #1 0;
	  rbit_counter16 		<= #1 0;
	  rparity_xor16 		<= #1 1'b0;
	  rframing_error16 	<= #1 1'b0;
	  rparity_error16 		<= #1 1'b0;
	  rparity16 				<= #1 1'b0;
	  rshift16 				<= #1 0;
	  rf_push16 				<= #1 1'b0;
	  rf_data_in16 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle16 : begin
			rf_push16 			  <= #1 1'b0;
			rf_data_in16 	  <= #1 0;
			rcounter1616 	  <= #1 4'b1110;
			if (srx_pad_i16==1'b0 & ~break_error16)   // detected a pulse16 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start16;
			end
		end
	sr_rec_start16 :	begin
  			rf_push16 			  <= #1 1'b0;
				if (rcounter16_eq_716)    // check the pulse16
					if (srx_pad_i16==1'b1)   // no start bit
						rstate <= #1 sr_idle16;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare16;
				rcounter1616 <= #1 rcounter16_minus_116;
			end
	sr_rec_prepare16:begin
				case (lcr16[/*`UART_LC_BITS16*/1:0])  // number16 of bits in a word16
				2'b00 : rbit_counter16 <= #1 3'b100;
				2'b01 : rbit_counter16 <= #1 3'b101;
				2'b10 : rbit_counter16 <= #1 3'b110;
				2'b11 : rbit_counter16 <= #1 3'b111;
				endcase
				if (rcounter16_eq_016)
				begin
					rstate		<= #1 sr_rec_bit16;
					rcounter1616	<= #1 4'b1110;
					rshift16		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare16;
				rcounter1616 <= #1 rcounter16_minus_116;
			end
	sr_rec_bit16 :	begin
				if (rcounter16_eq_016)
					rstate <= #1 sr_end_bit16;
				if (rcounter16_eq_716) // read the bit
					case (lcr16[/*`UART_LC_BITS16*/1:0])  // number16 of bits in a word16
					2'b00 : rshift16[4:0]  <= #1 {srx_pad_i16, rshift16[4:1]};
					2'b01 : rshift16[5:0]  <= #1 {srx_pad_i16, rshift16[5:1]};
					2'b10 : rshift16[6:0]  <= #1 {srx_pad_i16, rshift16[6:1]};
					2'b11 : rshift16[7:0]  <= #1 {srx_pad_i16, rshift16[7:1]};
					endcase
				rcounter1616 <= #1 rcounter16_minus_116;
			end
	sr_end_bit16 :   begin
				if (rbit_counter16==3'b0) // no more bits in word16
					if (lcr16[`UART_LC_PE16]) // choose16 state based on parity16
						rstate <= #1 sr_rec_parity16;
					else
					begin
						rstate <= #1 sr_rec_stop16;
						rparity_error16 <= #1 1'b0;  // no parity16 - no error :)
					end
				else		// else we16 have more bits to read
				begin
					rstate <= #1 sr_rec_bit16;
					rbit_counter16 <= #1 rbit_counter16 - 1'b1;
				end
				rcounter1616 <= #1 4'b1110;
			end
	sr_rec_parity16: begin
				if (rcounter16_eq_716)	// read the parity16
				begin
					rparity16 <= #1 srx_pad_i16;
					rstate <= #1 sr_ca_lc_parity16;
				end
				rcounter1616 <= #1 rcounter16_minus_116;
			end
	sr_ca_lc_parity16 : begin    // rcounter16 equals16 6
				rcounter1616  <= #1 rcounter16_minus_116;
				rparity_xor16 <= #1 ^{rshift16,rparity16}; // calculate16 parity16 on all incoming16 data
				rstate      <= #1 sr_check_parity16;
			  end
	sr_check_parity16: begin	  // rcounter16 equals16 5
				case ({lcr16[`UART_LC_EP16],lcr16[`UART_LC_SP16]})
					2'b00: rparity_error16 <= #1  rparity_xor16 == 0;  // no error if parity16 1
					2'b01: rparity_error16 <= #1 ~rparity16;      // parity16 should sticked16 to 1
					2'b10: rparity_error16 <= #1  rparity_xor16 == 1;   // error if parity16 is odd16
					2'b11: rparity_error16 <= #1  rparity16;	  // parity16 should be sticked16 to 0
				endcase
				rcounter1616 <= #1 rcounter16_minus_116;
				rstate <= #1 sr_wait116;
			  end
	sr_wait116 :	if (rcounter16_eq_016)
			begin
				rstate <= #1 sr_rec_stop16;
				rcounter1616 <= #1 4'b1110;
			end
			else
				rcounter1616 <= #1 rcounter16_minus_116;
	sr_rec_stop16 :	begin
				if (rcounter16_eq_716)	// read the parity16
				begin
					rframing_error16 <= #1 !srx_pad_i16; // no framing16 error if input is 1 (stop bit)
					rstate <= #1 sr_push16;
				end
				rcounter1616 <= #1 rcounter16_minus_116;
			end
	sr_push16 :	begin
///////////////////////////////////////
//				$display($time, ": received16: %b", rf_data_in16);
        if(srx_pad_i16 | break_error16)
          begin
            if(break_error16)
        		  rf_data_in16 	<= #1 {8'b0, 3'b100}; // break input (empty16 character16) to receiver16 FIFO
            else
        			rf_data_in16  <= #1 {rshift16, 1'b0, rparity_error16, rframing_error16};
      		  rf_push16 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle16;
          end
        else if(~rframing_error16)  // There's always a framing16 before break_error16 -> wait for break or srx_pad_i16
          begin
       			rf_data_in16  <= #1 {rshift16, 1'b0, rparity_error16, rframing_error16};
      		  rf_push16 		  <= #1 1'b1;
      			rcounter1616 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start16;
          end
                      
			end
	default : rstate <= #1 sr_idle16;
	endcase
  end  // if (enable)
end // always of receiver16

always @ (posedge clk16 or posedge wb_rst_i16)
begin
  if(wb_rst_i16)
    rf_push_q16 <= 0;
  else
    rf_push_q16 <= #1 rf_push16;
end

assign rf_push_pulse16 = rf_push16 & ~rf_push_q16;

  
//
// Break16 condition detection16.
// Works16 in conjuction16 with the receiver16 state machine16

reg 	[9:0]	toc_value16; // value to be set to timeout counter

always @(lcr16)
	case (lcr16[3:0])
		4'b0000										: toc_value16 = 447; // 7 bits
		4'b0100										: toc_value16 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value16 = 511; // 8 bits
		4'b1100										: toc_value16 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value16 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value16 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value16 = 703; // 11 bits
		4'b1111										: toc_value16 = 767; // 12 bits
	endcase // case(lcr16[3:0])

wire [7:0] 	brc_value16; // value to be set to break counter
assign 		brc_value16 = toc_value16[9:2]; // the same as timeout but 1 insead16 of 4 character16 times

always @(posedge clk16 or posedge wb_rst_i16)
begin
	if (wb_rst_i16)
		counter_b16 <= #1 8'd159;
	else
	if (srx_pad_i16)
		counter_b16 <= #1 brc_value16; // character16 time length - 1
	else
	if(enable & counter_b16 != 8'b0)            // only work16 on enable times  break not reached16.
		counter_b16 <= #1 counter_b16 - 1;  // decrement break counter
end // always of break condition detection16

///
/// Timeout16 condition detection16
reg	[9:0]	counter_t16;	// counts16 the timeout condition clocks16

always @(posedge clk16 or posedge wb_rst_i16)
begin
	if (wb_rst_i16)
		counter_t16 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse16 || rf_pop16 || rf_count16 == 0) // counter is reset when RX16 FIFO is empty16, accessed or above16 trigger level
			counter_t16 <= #1 toc_value16;
		else
		if (enable && counter_t16 != 10'b0)  // we16 don16't want16 to underflow16
			counter_t16 <= #1 counter_t16 - 1;		
end
	
endmodule
