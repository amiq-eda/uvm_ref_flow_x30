//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo1.v                                                ////
////                                                              ////
////                                                              ////
////  This1 file is part of the "UART1 16550 compatible1" project1    ////
////  http1://www1.opencores1.org1/cores1/uart165501/                   ////
////                                                              ////
////  Documentation1 related1 to this project1:                      ////
////  - http1://www1.opencores1.org1/cores1/uart165501/                 ////
////                                                              ////
////  Projects1 compatibility1:                                     ////
////  - WISHBONE1                                                  ////
////  RS2321 Protocol1                                              ////
////  16550D uart1 (mostly1 supported)                              ////
////                                                              ////
////  Overview1 (main1 Features1):                                   ////
////  UART1 core1 transmitter1 FIFO                                  ////
////                                                              ////
////  To1 Do1:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author1(s):                                                  ////
////      - gorban1@opencores1.org1                                  ////
////      - Jacob1 Gorban1                                          ////
////      - Igor1 Mohor1 (igorm1@opencores1.org1)                      ////
////                                                              ////
////  Created1:        2001/05/12                                  ////
////  Last1 Updated1:   2002/07/22                                  ////
////                  (See log1 for the revision1 history1)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright1 (C) 2000, 2001 Authors1                             ////
////                                                              ////
//// This1 source1 file may be used and distributed1 without         ////
//// restriction1 provided that this copyright1 statement1 is not    ////
//// removed from the file and that any derivative1 work1 contains1  ////
//// the original copyright1 notice1 and the associated disclaimer1. ////
////                                                              ////
//// This1 source1 file is free software1; you can redistribute1 it   ////
//// and/or modify it under the terms1 of the GNU1 Lesser1 General1   ////
//// Public1 License1 as published1 by the Free1 Software1 Foundation1; ////
//// either1 version1 2.1 of the License1, or (at your1 option) any   ////
//// later1 version1.                                               ////
////                                                              ////
//// This1 source1 is distributed1 in the hope1 that it will be       ////
//// useful1, but WITHOUT1 ANY1 WARRANTY1; without even1 the implied1   ////
//// warranty1 of MERCHANTABILITY1 or FITNESS1 FOR1 A PARTICULAR1      ////
//// PURPOSE1.  See the GNU1 Lesser1 General1 Public1 License1 for more ////
//// details1.                                                     ////
////                                                              ////
//// You should have received1 a copy of the GNU1 Lesser1 General1    ////
//// Public1 License1 along1 with this source1; if not, download1 it   ////
//// from http1://www1.opencores1.org1/lgpl1.shtml1                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS1 Revision1 History1
//
// $Log: not supported by cvs2svn1 $
// Revision1 1.1  2002/07/22 23:02:23  gorban1
// Bug1 Fixes1:
//  * Possible1 loss of sync and bad1 reception1 of stop bit on slow1 baud1 rates1 fixed1.
//   Problem1 reported1 by Kenny1.Tung1.
//  * Bad (or lack1 of ) loopback1 handling1 fixed1. Reported1 by Cherry1 Withers1.
//
// Improvements1:
//  * Made1 FIFO's as general1 inferrable1 memory where possible1.
//  So1 on FPGA1 they should be inferred1 as RAM1 (Distributed1 RAM1 on Xilinx1).
//  This1 saves1 about1 1/3 of the Slice1 count and reduces1 P&R and synthesis1 times.
//
//  * Added1 optional1 baudrate1 output (baud_o1).
//  This1 is identical1 to BAUDOUT1* signal1 on 16550 chip1.
//  It outputs1 16xbit_clock_rate - the divided1 clock1.
//  It's disabled by default. Define1 UART_HAS_BAUDRATE_OUTPUT1 to use.
//
// Revision1 1.16  2001/12/20 13:25:46  mohor1
// rx1 push1 changed to be only one cycle wide1.
//
// Revision1 1.15  2001/12/18 09:01:07  mohor1
// Bug1 that was entered1 in the last update fixed1 (rx1 state machine1).
//
// Revision1 1.14  2001/12/17 14:46:48  mohor1
// overrun1 signal1 was moved to separate1 block because many1 sequential1 lsr1
// reads were1 preventing1 data from being written1 to rx1 fifo.
// underrun1 signal1 was not used and was removed from the project1.
//
// Revision1 1.13  2001/11/26 21:38:54  gorban1
// Lots1 of fixes1:
// Break1 condition wasn1't handled1 correctly at all.
// LSR1 bits could lose1 their1 values.
// LSR1 value after reset was wrong1.
// Timing1 of THRE1 interrupt1 signal1 corrected1.
// LSR1 bit 0 timing1 corrected1.
//
// Revision1 1.12  2001/11/08 14:54:23  mohor1
// Comments1 in Slovene1 language1 deleted1, few1 small fixes1 for better1 work1 of
// old1 tools1. IRQs1 need to be fix1.
//
// Revision1 1.11  2001/11/07 17:51:52  gorban1
// Heavily1 rewritten1 interrupt1 and LSR1 subsystems1.
// Many1 bugs1 hopefully1 squashed1.
//
// Revision1 1.10  2001/10/20 09:58:40  gorban1
// Small1 synopsis1 fixes1
//
// Revision1 1.9  2001/08/24 21:01:12  mohor1
// Things1 connected1 to parity1 changed.
// Clock1 devider1 changed.
//
// Revision1 1.8  2001/08/24 08:48:10  mohor1
// FIFO was not cleared1 after the data was read bug1 fixed1.
//
// Revision1 1.7  2001/08/23 16:05:05  mohor1
// Stop bit bug1 fixed1.
// Parity1 bug1 fixed1.
// WISHBONE1 read cycle bug1 fixed1,
// OE1 indicator1 (Overrun1 Error) bug1 fixed1.
// PE1 indicator1 (Parity1 Error) bug1 fixed1.
// Register read bug1 fixed1.
//
// Revision1 1.3  2001/05/31 20:08:01  gorban1
// FIFO changes1 and other corrections1.
//
// Revision1 1.3  2001/05/27 17:37:48  gorban1
// Fixed1 many1 bugs1. Updated1 spec1. Changed1 FIFO files structure1. See CHANGES1.txt1 file.
//
// Revision1 1.2  2001/05/17 18:34:18  gorban1
// First1 'stable' release. Should1 be sythesizable1 now. Also1 added new header.
//
// Revision1 1.0  2001-05-17 21:27:12+02  jacob1
// Initial1 revision1
//
//

// synopsys1 translate_off1
`include "timescale.v"
// synopsys1 translate_on1

`include "uart_defines1.v"

module uart_tfifo1 (clk1, 
	wb_rst_i1, data_in1, data_out1,
// Control1 signals1
	push1, // push1 strobe1, active high1
	pop1,   // pop1 strobe1, active high1
// status signals1
	overrun1,
	count,
	fifo_reset1,
	reset_status1
	);


// FIFO parameters1
parameter fifo_width1 = `UART_FIFO_WIDTH1;
parameter fifo_depth1 = `UART_FIFO_DEPTH1;
parameter fifo_pointer_w1 = `UART_FIFO_POINTER_W1;
parameter fifo_counter_w1 = `UART_FIFO_COUNTER_W1;

input				clk1;
input				wb_rst_i1;
input				push1;
input				pop1;
input	[fifo_width1-1:0]	data_in1;
input				fifo_reset1;
input       reset_status1;

output	[fifo_width1-1:0]	data_out1;
output				overrun1;
output	[fifo_counter_w1-1:0]	count;

wire	[fifo_width1-1:0]	data_out1;

// FIFO pointers1
reg	[fifo_pointer_w1-1:0]	top;
reg	[fifo_pointer_w1-1:0]	bottom1;

reg	[fifo_counter_w1-1:0]	count;
reg				overrun1;
wire [fifo_pointer_w1-1:0] top_plus_11 = top + 1'b1;

raminfr1 #(fifo_pointer_w1,fifo_width1,fifo_depth1) tfifo1  
        (.clk1(clk1), 
			.we1(push1), 
			.a(top), 
			.dpra1(bottom1), 
			.di1(data_in1), 
			.dpo1(data_out1)
		); 


always @(posedge clk1 or posedge wb_rst_i1) // synchronous1 FIFO
begin
	if (wb_rst_i1)
	begin
		top		<= #1 0;
		bottom1		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset1) begin
		top		<= #1 0;
		bottom1		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push1, pop1})
		2'b10 : if (count<fifo_depth1)  // overrun1 condition
			begin
				top       <= #1 top_plus_11;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom1   <= #1 bottom1 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom1   <= #1 bottom1 + 1'b1;
				top       <= #1 top_plus_11;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk1 or posedge wb_rst_i1) // synchronous1 FIFO
begin
  if (wb_rst_i1)
    overrun1   <= #1 1'b0;
  else
  if(fifo_reset1 | reset_status1) 
    overrun1   <= #1 1'b0;
  else
  if(push1 & (count==fifo_depth1))
    overrun1   <= #1 1'b1;
end   // always

endmodule
