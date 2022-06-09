//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo3.v                                                ////
////                                                              ////
////                                                              ////
////  This3 file is part of the "UART3 16550 compatible3" project3    ////
////  http3://www3.opencores3.org3/cores3/uart165503/                   ////
////                                                              ////
////  Documentation3 related3 to this project3:                      ////
////  - http3://www3.opencores3.org3/cores3/uart165503/                 ////
////                                                              ////
////  Projects3 compatibility3:                                     ////
////  - WISHBONE3                                                  ////
////  RS2323 Protocol3                                              ////
////  16550D uart3 (mostly3 supported)                              ////
////                                                              ////
////  Overview3 (main3 Features3):                                   ////
////  UART3 core3 transmitter3 FIFO                                  ////
////                                                              ////
////  To3 Do3:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author3(s):                                                  ////
////      - gorban3@opencores3.org3                                  ////
////      - Jacob3 Gorban3                                          ////
////      - Igor3 Mohor3 (igorm3@opencores3.org3)                      ////
////                                                              ////
////  Created3:        2001/05/12                                  ////
////  Last3 Updated3:   2002/07/22                                  ////
////                  (See log3 for the revision3 history3)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2000, 2001 Authors3                             ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS3 Revision3 History3
//
// $Log: not supported by cvs2svn3 $
// Revision3 1.1  2002/07/22 23:02:23  gorban3
// Bug3 Fixes3:
//  * Possible3 loss of sync and bad3 reception3 of stop bit on slow3 baud3 rates3 fixed3.
//   Problem3 reported3 by Kenny3.Tung3.
//  * Bad (or lack3 of ) loopback3 handling3 fixed3. Reported3 by Cherry3 Withers3.
//
// Improvements3:
//  * Made3 FIFO's as general3 inferrable3 memory where possible3.
//  So3 on FPGA3 they should be inferred3 as RAM3 (Distributed3 RAM3 on Xilinx3).
//  This3 saves3 about3 1/3 of the Slice3 count and reduces3 P&R and synthesis3 times.
//
//  * Added3 optional3 baudrate3 output (baud_o3).
//  This3 is identical3 to BAUDOUT3* signal3 on 16550 chip3.
//  It outputs3 16xbit_clock_rate - the divided3 clock3.
//  It's disabled by default. Define3 UART_HAS_BAUDRATE_OUTPUT3 to use.
//
// Revision3 1.16  2001/12/20 13:25:46  mohor3
// rx3 push3 changed to be only one cycle wide3.
//
// Revision3 1.15  2001/12/18 09:01:07  mohor3
// Bug3 that was entered3 in the last update fixed3 (rx3 state machine3).
//
// Revision3 1.14  2001/12/17 14:46:48  mohor3
// overrun3 signal3 was moved to separate3 block because many3 sequential3 lsr3
// reads were3 preventing3 data from being written3 to rx3 fifo.
// underrun3 signal3 was not used and was removed from the project3.
//
// Revision3 1.13  2001/11/26 21:38:54  gorban3
// Lots3 of fixes3:
// Break3 condition wasn3't handled3 correctly at all.
// LSR3 bits could lose3 their3 values.
// LSR3 value after reset was wrong3.
// Timing3 of THRE3 interrupt3 signal3 corrected3.
// LSR3 bit 0 timing3 corrected3.
//
// Revision3 1.12  2001/11/08 14:54:23  mohor3
// Comments3 in Slovene3 language3 deleted3, few3 small fixes3 for better3 work3 of
// old3 tools3. IRQs3 need to be fix3.
//
// Revision3 1.11  2001/11/07 17:51:52  gorban3
// Heavily3 rewritten3 interrupt3 and LSR3 subsystems3.
// Many3 bugs3 hopefully3 squashed3.
//
// Revision3 1.10  2001/10/20 09:58:40  gorban3
// Small3 synopsis3 fixes3
//
// Revision3 1.9  2001/08/24 21:01:12  mohor3
// Things3 connected3 to parity3 changed.
// Clock3 devider3 changed.
//
// Revision3 1.8  2001/08/24 08:48:10  mohor3
// FIFO was not cleared3 after the data was read bug3 fixed3.
//
// Revision3 1.7  2001/08/23 16:05:05  mohor3
// Stop bit bug3 fixed3.
// Parity3 bug3 fixed3.
// WISHBONE3 read cycle bug3 fixed3,
// OE3 indicator3 (Overrun3 Error) bug3 fixed3.
// PE3 indicator3 (Parity3 Error) bug3 fixed3.
// Register read bug3 fixed3.
//
// Revision3 1.3  2001/05/31 20:08:01  gorban3
// FIFO changes3 and other corrections3.
//
// Revision3 1.3  2001/05/27 17:37:48  gorban3
// Fixed3 many3 bugs3. Updated3 spec3. Changed3 FIFO files structure3. See CHANGES3.txt3 file.
//
// Revision3 1.2  2001/05/17 18:34:18  gorban3
// First3 'stable' release. Should3 be sythesizable3 now. Also3 added new header.
//
// Revision3 1.0  2001-05-17 21:27:12+02  jacob3
// Initial3 revision3
//
//

// synopsys3 translate_off3
`include "timescale.v"
// synopsys3 translate_on3

`include "uart_defines3.v"

module uart_tfifo3 (clk3, 
	wb_rst_i3, data_in3, data_out3,
// Control3 signals3
	push3, // push3 strobe3, active high3
	pop3,   // pop3 strobe3, active high3
// status signals3
	overrun3,
	count,
	fifo_reset3,
	reset_status3
	);


// FIFO parameters3
parameter fifo_width3 = `UART_FIFO_WIDTH3;
parameter fifo_depth3 = `UART_FIFO_DEPTH3;
parameter fifo_pointer_w3 = `UART_FIFO_POINTER_W3;
parameter fifo_counter_w3 = `UART_FIFO_COUNTER_W3;

input				clk3;
input				wb_rst_i3;
input				push3;
input				pop3;
input	[fifo_width3-1:0]	data_in3;
input				fifo_reset3;
input       reset_status3;

output	[fifo_width3-1:0]	data_out3;
output				overrun3;
output	[fifo_counter_w3-1:0]	count;

wire	[fifo_width3-1:0]	data_out3;

// FIFO pointers3
reg	[fifo_pointer_w3-1:0]	top;
reg	[fifo_pointer_w3-1:0]	bottom3;

reg	[fifo_counter_w3-1:0]	count;
reg				overrun3;
wire [fifo_pointer_w3-1:0] top_plus_13 = top + 1'b1;

raminfr3 #(fifo_pointer_w3,fifo_width3,fifo_depth3) tfifo3  
        (.clk3(clk3), 
			.we3(push3), 
			.a(top), 
			.dpra3(bottom3), 
			.di3(data_in3), 
			.dpo3(data_out3)
		); 


always @(posedge clk3 or posedge wb_rst_i3) // synchronous3 FIFO
begin
	if (wb_rst_i3)
	begin
		top		<= #1 0;
		bottom3		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset3) begin
		top		<= #1 0;
		bottom3		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push3, pop3})
		2'b10 : if (count<fifo_depth3)  // overrun3 condition
			begin
				top       <= #1 top_plus_13;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom3   <= #1 bottom3 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom3   <= #1 bottom3 + 1'b1;
				top       <= #1 top_plus_13;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk3 or posedge wb_rst_i3) // synchronous3 FIFO
begin
  if (wb_rst_i3)
    overrun3   <= #1 1'b0;
  else
  if(fifo_reset3 | reset_status3) 
    overrun3   <= #1 1'b0;
  else
  if(push3 & (count==fifo_depth3))
    overrun3   <= #1 1'b1;
end   // always

endmodule
