//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_receiver19.v                                             ////
////                                                              ////
////                                                              ////
////  This19 file is part of the "UART19 16550 compatible19" project19    ////
////  http19://www19.opencores19.org19/cores19/uart1655019/                   ////
////                                                              ////
////  Documentation19 related19 to this project19:                      ////
////  - http19://www19.opencores19.org19/cores19/uart1655019/                 ////
////                                                              ////
////  Projects19 compatibility19:                                     ////
////  - WISHBONE19                                                  ////
////  RS23219 Protocol19                                              ////
////  16550D uart19 (mostly19 supported)                              ////
////                                                              ////
////  Overview19 (main19 Features19):                                   ////
////  UART19 core19 receiver19 logic                                    ////
////                                                              ////
////  Known19 problems19 (limits19):                                    ////
////  None19 known19                                                  ////
////                                                              ////
////  To19 Do19:                                                      ////
////  Thourough19 testing19.                                          ////
////                                                              ////
////  Author19(s):                                                  ////
////      - gorban19@opencores19.org19                                  ////
////      - Jacob19 Gorban19                                          ////
////      - Igor19 Mohor19 (igorm19@opencores19.org19)                      ////
////                                                              ////
////  Created19:        2001/05/12                                  ////
////  Last19 Updated19:   2001/05/17                                  ////
////                  (See log19 for the revision19 history19)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2000, 2001 Authors19                             ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS19 Revision19 History19
//
// $Log: not supported by cvs2svn19 $
// Revision19 1.29  2002/07/29 21:16:18  gorban19
// The uart_defines19.v file is included19 again19 in sources19.
//
// Revision19 1.28  2002/07/22 23:02:23  gorban19
// Bug19 Fixes19:
//  * Possible19 loss of sync and bad19 reception19 of stop bit on slow19 baud19 rates19 fixed19.
//   Problem19 reported19 by Kenny19.Tung19.
//  * Bad (or lack19 of ) loopback19 handling19 fixed19. Reported19 by Cherry19 Withers19.
//
// Improvements19:
//  * Made19 FIFO's as general19 inferrable19 memory where possible19.
//  So19 on FPGA19 they should be inferred19 as RAM19 (Distributed19 RAM19 on Xilinx19).
//  This19 saves19 about19 1/3 of the Slice19 count and reduces19 P&R and synthesis19 times.
//
//  * Added19 optional19 baudrate19 output (baud_o19).
//  This19 is identical19 to BAUDOUT19* signal19 on 16550 chip19.
//  It outputs19 16xbit_clock_rate - the divided19 clock19.
//  It's disabled by default. Define19 UART_HAS_BAUDRATE_OUTPUT19 to use.
//
// Revision19 1.27  2001/12/30 20:39:13  mohor19
// More than one character19 was stored19 in case of break. End19 of the break
// was not detected correctly.
//
// Revision19 1.26  2001/12/20 13:28:27  mohor19
// Missing19 declaration19 of rf_push_q19 fixed19.
//
// Revision19 1.25  2001/12/20 13:25:46  mohor19
// rx19 push19 changed to be only one cycle wide19.
//
// Revision19 1.24  2001/12/19 08:03:34  mohor19
// Warnings19 cleared19.
//
// Revision19 1.23  2001/12/19 07:33:54  mohor19
// Synplicity19 was having19 troubles19 with the comment19.
//
// Revision19 1.22  2001/12/17 14:46:48  mohor19
// overrun19 signal19 was moved to separate19 block because many19 sequential19 lsr19
// reads were19 preventing19 data from being written19 to rx19 fifo.
// underrun19 signal19 was not used and was removed from the project19.
//
// Revision19 1.21  2001/12/13 10:31:16  mohor19
// timeout irq19 must be set regardless19 of the rda19 irq19 (rda19 irq19 does not reset the
// timeout counter).
//
// Revision19 1.20  2001/12/10 19:52:05  gorban19
// Igor19 fixed19 break condition bugs19
//
// Revision19 1.19  2001/12/06 14:51:04  gorban19
// Bug19 in LSR19[0] is fixed19.
// All WISHBONE19 signals19 are now sampled19, so another19 wait-state is introduced19 on all transfers19.
//
// Revision19 1.18  2001/12/03 21:44:29  gorban19
// Updated19 specification19 documentation.
// Added19 full 32-bit data bus interface, now as default.
// Address is 5-bit wide19 in 32-bit data bus mode.
// Added19 wb_sel_i19 input to the core19. It's used in the 32-bit mode.
// Added19 debug19 interface with two19 32-bit read-only registers in 32-bit mode.
// Bits19 5 and 6 of LSR19 are now only cleared19 on TX19 FIFO write.
// My19 small test bench19 is modified to work19 with 32-bit mode.
//
// Revision19 1.17  2001/11/28 19:36:39  gorban19
// Fixed19: timeout and break didn19't pay19 attention19 to current data format19 when counting19 time
//
// Revision19 1.16  2001/11/27 22:17:09  gorban19
// Fixed19 bug19 that prevented19 synthesis19 in uart_receiver19.v
//
// Revision19 1.15  2001/11/26 21:38:54  gorban19
// Lots19 of fixes19:
// Break19 condition wasn19't handled19 correctly at all.
// LSR19 bits could lose19 their19 values.
// LSR19 value after reset was wrong19.
// Timing19 of THRE19 interrupt19 signal19 corrected19.
// LSR19 bit 0 timing19 corrected19.
//
// Revision19 1.14  2001/11/10 12:43:21  gorban19
// Logic19 Synthesis19 bugs19 fixed19. Some19 other minor19 changes19
//
// Revision19 1.13  2001/11/08 14:54:23  mohor19
// Comments19 in Slovene19 language19 deleted19, few19 small fixes19 for better19 work19 of
// old19 tools19. IRQs19 need to be fix19.
//
// Revision19 1.12  2001/11/07 17:51:52  gorban19
// Heavily19 rewritten19 interrupt19 and LSR19 subsystems19.
// Many19 bugs19 hopefully19 squashed19.
//
// Revision19 1.11  2001/10/31 15:19:22  gorban19
// Fixes19 to break and timeout conditions19
//
// Revision19 1.10  2001/10/20 09:58:40  gorban19
// Small19 synopsis19 fixes19
//
// Revision19 1.9  2001/08/24 21:01:12  mohor19
// Things19 connected19 to parity19 changed.
// Clock19 devider19 changed.
//
// Revision19 1.8  2001/08/23 16:05:05  mohor19
// Stop bit bug19 fixed19.
// Parity19 bug19 fixed19.
// WISHBONE19 read cycle bug19 fixed19,
// OE19 indicator19 (Overrun19 Error) bug19 fixed19.
// PE19 indicator19 (Parity19 Error) bug19 fixed19.
// Register read bug19 fixed19.
//
// Revision19 1.6  2001/06/23 11:21:48  gorban19
// DL19 made19 16-bit long19. Fixed19 transmission19/reception19 bugs19.
//
// Revision19 1.5  2001/06/02 14:28:14  gorban19
// Fixed19 receiver19 and transmitter19. Major19 bug19 fixed19.
//
// Revision19 1.4  2001/05/31 20:08:01  gorban19
// FIFO changes19 and other corrections19.
//
// Revision19 1.3  2001/05/27 17:37:49  gorban19
// Fixed19 many19 bugs19. Updated19 spec19. Changed19 FIFO files structure19. See CHANGES19.txt19 file.
//
// Revision19 1.2  2001/05/21 19:12:02  gorban19
// Corrected19 some19 Linter19 messages19.
//
// Revision19 1.1  2001/05/17 18:34:18  gorban19
// First19 'stable' release. Should19 be sythesizable19 now. Also19 added new header.
//
// Revision19 1.0  2001-05-17 21:27:11+02  jacob19
// Initial19 revision19
//
//

// synopsys19 translate_off19
`include "timescale.v"
// synopsys19 translate_on19

`include "uart_defines19.v"

module uart_receiver19 (clk19, wb_rst_i19, lcr19, rf_pop19, srx_pad_i19, enable, 
	counter_t19, rf_count19, rf_data_out19, rf_error_bit19, rf_overrun19, rx_reset19, lsr_mask19, rstate, rf_push_pulse19);

input				clk19;
input				wb_rst_i19;
input	[7:0]	lcr19;
input				rf_pop19;
input				srx_pad_i19;
input				enable;
input				rx_reset19;
input       lsr_mask19;

output	[9:0]			counter_t19;
output	[`UART_FIFO_COUNTER_W19-1:0]	rf_count19;
output	[`UART_FIFO_REC_WIDTH19-1:0]	rf_data_out19;
output				rf_overrun19;
output				rf_error_bit19;
output [3:0] 		rstate;
output 				rf_push_pulse19;

reg	[3:0]	rstate;
reg	[3:0]	rcounter1619;
reg	[2:0]	rbit_counter19;
reg	[7:0]	rshift19;			// receiver19 shift19 register
reg		rparity19;		// received19 parity19
reg		rparity_error19;
reg		rframing_error19;		// framing19 error flag19
reg		rbit_in19;
reg		rparity_xor19;
reg	[7:0]	counter_b19;	// counts19 the 0 (low19) signals19
reg   rf_push_q19;

// RX19 FIFO signals19
reg	[`UART_FIFO_REC_WIDTH19-1:0]	rf_data_in19;
wire	[`UART_FIFO_REC_WIDTH19-1:0]	rf_data_out19;
wire      rf_push_pulse19;
reg				rf_push19;
wire				rf_pop19;
wire				rf_overrun19;
wire	[`UART_FIFO_COUNTER_W19-1:0]	rf_count19;
wire				rf_error_bit19; // an error (parity19 or framing19) is inside the fifo
wire 				break_error19 = (counter_b19 == 0);

// RX19 FIFO instance
uart_rfifo19 #(`UART_FIFO_REC_WIDTH19) fifo_rx19(
	.clk19(		clk19		), 
	.wb_rst_i19(	wb_rst_i19	),
	.data_in19(	rf_data_in19	),
	.data_out19(	rf_data_out19	),
	.push19(		rf_push_pulse19		),
	.pop19(		rf_pop19		),
	.overrun19(	rf_overrun19	),
	.count(		rf_count19	),
	.error_bit19(	rf_error_bit19	),
	.fifo_reset19(	rx_reset19	),
	.reset_status19(lsr_mask19)
);

wire 		rcounter16_eq_719 = (rcounter1619 == 4'd7);
wire		rcounter16_eq_019 = (rcounter1619 == 4'd0);
wire		rcounter16_eq_119 = (rcounter1619 == 4'd1);

wire [3:0] rcounter16_minus_119 = rcounter1619 - 1'b1;

parameter  sr_idle19 					= 4'd0;
parameter  sr_rec_start19 			= 4'd1;
parameter  sr_rec_bit19 				= 4'd2;
parameter  sr_rec_parity19			= 4'd3;
parameter  sr_rec_stop19 				= 4'd4;
parameter  sr_check_parity19 		= 4'd5;
parameter  sr_rec_prepare19 			= 4'd6;
parameter  sr_end_bit19				= 4'd7;
parameter  sr_ca_lc_parity19	      = 4'd8;
parameter  sr_wait119 					= 4'd9;
parameter  sr_push19 					= 4'd10;


always @(posedge clk19 or posedge wb_rst_i19)
begin
  if (wb_rst_i19)
  begin
     rstate 			<= #1 sr_idle19;
	  rbit_in19 				<= #1 1'b0;
	  rcounter1619 			<= #1 0;
	  rbit_counter19 		<= #1 0;
	  rparity_xor19 		<= #1 1'b0;
	  rframing_error19 	<= #1 1'b0;
	  rparity_error19 		<= #1 1'b0;
	  rparity19 				<= #1 1'b0;
	  rshift19 				<= #1 0;
	  rf_push19 				<= #1 1'b0;
	  rf_data_in19 			<= #1 0;
  end
  else
  if (enable)
  begin
	case (rstate)
	sr_idle19 : begin
			rf_push19 			  <= #1 1'b0;
			rf_data_in19 	  <= #1 0;
			rcounter1619 	  <= #1 4'b1110;
			if (srx_pad_i19==1'b0 & ~break_error19)   // detected a pulse19 (start bit?)
			begin
				rstate 		  <= #1 sr_rec_start19;
			end
		end
	sr_rec_start19 :	begin
  			rf_push19 			  <= #1 1'b0;
				if (rcounter16_eq_719)    // check the pulse19
					if (srx_pad_i19==1'b1)   // no start bit
						rstate <= #1 sr_idle19;
					else            // start bit detected
						rstate <= #1 sr_rec_prepare19;
				rcounter1619 <= #1 rcounter16_minus_119;
			end
	sr_rec_prepare19:begin
				case (lcr19[/*`UART_LC_BITS19*/1:0])  // number19 of bits in a word19
				2'b00 : rbit_counter19 <= #1 3'b100;
				2'b01 : rbit_counter19 <= #1 3'b101;
				2'b10 : rbit_counter19 <= #1 3'b110;
				2'b11 : rbit_counter19 <= #1 3'b111;
				endcase
				if (rcounter16_eq_019)
				begin
					rstate		<= #1 sr_rec_bit19;
					rcounter1619	<= #1 4'b1110;
					rshift19		<= #1 0;
				end
				else
					rstate <= #1 sr_rec_prepare19;
				rcounter1619 <= #1 rcounter16_minus_119;
			end
	sr_rec_bit19 :	begin
				if (rcounter16_eq_019)
					rstate <= #1 sr_end_bit19;
				if (rcounter16_eq_719) // read the bit
					case (lcr19[/*`UART_LC_BITS19*/1:0])  // number19 of bits in a word19
					2'b00 : rshift19[4:0]  <= #1 {srx_pad_i19, rshift19[4:1]};
					2'b01 : rshift19[5:0]  <= #1 {srx_pad_i19, rshift19[5:1]};
					2'b10 : rshift19[6:0]  <= #1 {srx_pad_i19, rshift19[6:1]};
					2'b11 : rshift19[7:0]  <= #1 {srx_pad_i19, rshift19[7:1]};
					endcase
				rcounter1619 <= #1 rcounter16_minus_119;
			end
	sr_end_bit19 :   begin
				if (rbit_counter19==3'b0) // no more bits in word19
					if (lcr19[`UART_LC_PE19]) // choose19 state based on parity19
						rstate <= #1 sr_rec_parity19;
					else
					begin
						rstate <= #1 sr_rec_stop19;
						rparity_error19 <= #1 1'b0;  // no parity19 - no error :)
					end
				else		// else we19 have more bits to read
				begin
					rstate <= #1 sr_rec_bit19;
					rbit_counter19 <= #1 rbit_counter19 - 1'b1;
				end
				rcounter1619 <= #1 4'b1110;
			end
	sr_rec_parity19: begin
				if (rcounter16_eq_719)	// read the parity19
				begin
					rparity19 <= #1 srx_pad_i19;
					rstate <= #1 sr_ca_lc_parity19;
				end
				rcounter1619 <= #1 rcounter16_minus_119;
			end
	sr_ca_lc_parity19 : begin    // rcounter19 equals19 6
				rcounter1619  <= #1 rcounter16_minus_119;
				rparity_xor19 <= #1 ^{rshift19,rparity19}; // calculate19 parity19 on all incoming19 data
				rstate      <= #1 sr_check_parity19;
			  end
	sr_check_parity19: begin	  // rcounter19 equals19 5
				case ({lcr19[`UART_LC_EP19],lcr19[`UART_LC_SP19]})
					2'b00: rparity_error19 <= #1  rparity_xor19 == 0;  // no error if parity19 1
					2'b01: rparity_error19 <= #1 ~rparity19;      // parity19 should sticked19 to 1
					2'b10: rparity_error19 <= #1  rparity_xor19 == 1;   // error if parity19 is odd19
					2'b11: rparity_error19 <= #1  rparity19;	  // parity19 should be sticked19 to 0
				endcase
				rcounter1619 <= #1 rcounter16_minus_119;
				rstate <= #1 sr_wait119;
			  end
	sr_wait119 :	if (rcounter16_eq_019)
			begin
				rstate <= #1 sr_rec_stop19;
				rcounter1619 <= #1 4'b1110;
			end
			else
				rcounter1619 <= #1 rcounter16_minus_119;
	sr_rec_stop19 :	begin
				if (rcounter16_eq_719)	// read the parity19
				begin
					rframing_error19 <= #1 !srx_pad_i19; // no framing19 error if input is 1 (stop bit)
					rstate <= #1 sr_push19;
				end
				rcounter1619 <= #1 rcounter16_minus_119;
			end
	sr_push19 :	begin
///////////////////////////////////////
//				$display($time, ": received19: %b", rf_data_in19);
        if(srx_pad_i19 | break_error19)
          begin
            if(break_error19)
        		  rf_data_in19 	<= #1 {8'b0, 3'b100}; // break input (empty19 character19) to receiver19 FIFO
            else
        			rf_data_in19  <= #1 {rshift19, 1'b0, rparity_error19, rframing_error19};
      		  rf_push19 		  <= #1 1'b1;
    				rstate        <= #1 sr_idle19;
          end
        else if(~rframing_error19)  // There's always a framing19 before break_error19 -> wait for break or srx_pad_i19
          begin
       			rf_data_in19  <= #1 {rshift19, 1'b0, rparity_error19, rframing_error19};
      		  rf_push19 		  <= #1 1'b1;
      			rcounter1619 	  <= #1 4'b1110;
    				rstate 		  <= #1 sr_rec_start19;
          end
                      
			end
	default : rstate <= #1 sr_idle19;
	endcase
  end  // if (enable)
end // always of receiver19

always @ (posedge clk19 or posedge wb_rst_i19)
begin
  if(wb_rst_i19)
    rf_push_q19 <= 0;
  else
    rf_push_q19 <= #1 rf_push19;
end

assign rf_push_pulse19 = rf_push19 & ~rf_push_q19;

  
//
// Break19 condition detection19.
// Works19 in conjuction19 with the receiver19 state machine19

reg 	[9:0]	toc_value19; // value to be set to timeout counter

always @(lcr19)
	case (lcr19[3:0])
		4'b0000										: toc_value19 = 447; // 7 bits
		4'b0100										: toc_value19 = 479; // 7.5 bits
		4'b0001,	4'b1000							: toc_value19 = 511; // 8 bits
		4'b1100										: toc_value19 = 543; // 8.5 bits
		4'b0010, 4'b0101, 4'b1001				: toc_value19 = 575; // 9 bits
		4'b0011, 4'b0110, 4'b1010, 4'b1101	: toc_value19 = 639; // 10 bits
		4'b0111, 4'b1011, 4'b1110				: toc_value19 = 703; // 11 bits
		4'b1111										: toc_value19 = 767; // 12 bits
	endcase // case(lcr19[3:0])

wire [7:0] 	brc_value19; // value to be set to break counter
assign 		brc_value19 = toc_value19[9:2]; // the same as timeout but 1 insead19 of 4 character19 times

always @(posedge clk19 or posedge wb_rst_i19)
begin
	if (wb_rst_i19)
		counter_b19 <= #1 8'd159;
	else
	if (srx_pad_i19)
		counter_b19 <= #1 brc_value19; // character19 time length - 1
	else
	if(enable & counter_b19 != 8'b0)            // only work19 on enable times  break not reached19.
		counter_b19 <= #1 counter_b19 - 1;  // decrement break counter
end // always of break condition detection19

///
/// Timeout19 condition detection19
reg	[9:0]	counter_t19;	// counts19 the timeout condition clocks19

always @(posedge clk19 or posedge wb_rst_i19)
begin
	if (wb_rst_i19)
		counter_t19 <= #1 10'd639; // 10 bits for the default 8N1
	else
		if(rf_push_pulse19 || rf_pop19 || rf_count19 == 0) // counter is reset when RX19 FIFO is empty19, accessed or above19 trigger level
			counter_t19 <= #1 toc_value19;
		else
		if (enable && counter_t19 != 10'b0)  // we19 don19't want19 to underflow19
			counter_t19 <= #1 counter_t19 - 1;		
end
	
endmodule
