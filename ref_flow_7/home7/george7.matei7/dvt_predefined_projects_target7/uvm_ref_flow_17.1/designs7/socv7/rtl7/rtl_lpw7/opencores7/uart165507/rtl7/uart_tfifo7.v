//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo7.v                                                ////
////                                                              ////
////                                                              ////
////  This7 file is part of the "UART7 16550 compatible7" project7    ////
////  http7://www7.opencores7.org7/cores7/uart165507/                   ////
////                                                              ////
////  Documentation7 related7 to this project7:                      ////
////  - http7://www7.opencores7.org7/cores7/uart165507/                 ////
////                                                              ////
////  Projects7 compatibility7:                                     ////
////  - WISHBONE7                                                  ////
////  RS2327 Protocol7                                              ////
////  16550D uart7 (mostly7 supported)                              ////
////                                                              ////
////  Overview7 (main7 Features7):                                   ////
////  UART7 core7 transmitter7 FIFO                                  ////
////                                                              ////
////  To7 Do7:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author7(s):                                                  ////
////      - gorban7@opencores7.org7                                  ////
////      - Jacob7 Gorban7                                          ////
////      - Igor7 Mohor7 (igorm7@opencores7.org7)                      ////
////                                                              ////
////  Created7:        2001/05/12                                  ////
////  Last7 Updated7:   2002/07/22                                  ////
////                  (See log7 for the revision7 history7)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2000, 2001 Authors7                             ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS7 Revision7 History7
//
// $Log: not supported by cvs2svn7 $
// Revision7 1.1  2002/07/22 23:02:23  gorban7
// Bug7 Fixes7:
//  * Possible7 loss of sync and bad7 reception7 of stop bit on slow7 baud7 rates7 fixed7.
//   Problem7 reported7 by Kenny7.Tung7.
//  * Bad (or lack7 of ) loopback7 handling7 fixed7. Reported7 by Cherry7 Withers7.
//
// Improvements7:
//  * Made7 FIFO's as general7 inferrable7 memory where possible7.
//  So7 on FPGA7 they should be inferred7 as RAM7 (Distributed7 RAM7 on Xilinx7).
//  This7 saves7 about7 1/3 of the Slice7 count and reduces7 P&R and synthesis7 times.
//
//  * Added7 optional7 baudrate7 output (baud_o7).
//  This7 is identical7 to BAUDOUT7* signal7 on 16550 chip7.
//  It outputs7 16xbit_clock_rate - the divided7 clock7.
//  It's disabled by default. Define7 UART_HAS_BAUDRATE_OUTPUT7 to use.
//
// Revision7 1.16  2001/12/20 13:25:46  mohor7
// rx7 push7 changed to be only one cycle wide7.
//
// Revision7 1.15  2001/12/18 09:01:07  mohor7
// Bug7 that was entered7 in the last update fixed7 (rx7 state machine7).
//
// Revision7 1.14  2001/12/17 14:46:48  mohor7
// overrun7 signal7 was moved to separate7 block because many7 sequential7 lsr7
// reads were7 preventing7 data from being written7 to rx7 fifo.
// underrun7 signal7 was not used and was removed from the project7.
//
// Revision7 1.13  2001/11/26 21:38:54  gorban7
// Lots7 of fixes7:
// Break7 condition wasn7't handled7 correctly at all.
// LSR7 bits could lose7 their7 values.
// LSR7 value after reset was wrong7.
// Timing7 of THRE7 interrupt7 signal7 corrected7.
// LSR7 bit 0 timing7 corrected7.
//
// Revision7 1.12  2001/11/08 14:54:23  mohor7
// Comments7 in Slovene7 language7 deleted7, few7 small fixes7 for better7 work7 of
// old7 tools7. IRQs7 need to be fix7.
//
// Revision7 1.11  2001/11/07 17:51:52  gorban7
// Heavily7 rewritten7 interrupt7 and LSR7 subsystems7.
// Many7 bugs7 hopefully7 squashed7.
//
// Revision7 1.10  2001/10/20 09:58:40  gorban7
// Small7 synopsis7 fixes7
//
// Revision7 1.9  2001/08/24 21:01:12  mohor7
// Things7 connected7 to parity7 changed.
// Clock7 devider7 changed.
//
// Revision7 1.8  2001/08/24 08:48:10  mohor7
// FIFO was not cleared7 after the data was read bug7 fixed7.
//
// Revision7 1.7  2001/08/23 16:05:05  mohor7
// Stop bit bug7 fixed7.
// Parity7 bug7 fixed7.
// WISHBONE7 read cycle bug7 fixed7,
// OE7 indicator7 (Overrun7 Error) bug7 fixed7.
// PE7 indicator7 (Parity7 Error) bug7 fixed7.
// Register read bug7 fixed7.
//
// Revision7 1.3  2001/05/31 20:08:01  gorban7
// FIFO changes7 and other corrections7.
//
// Revision7 1.3  2001/05/27 17:37:48  gorban7
// Fixed7 many7 bugs7. Updated7 spec7. Changed7 FIFO files structure7. See CHANGES7.txt7 file.
//
// Revision7 1.2  2001/05/17 18:34:18  gorban7
// First7 'stable' release. Should7 be sythesizable7 now. Also7 added new header.
//
// Revision7 1.0  2001-05-17 21:27:12+02  jacob7
// Initial7 revision7
//
//

// synopsys7 translate_off7
`include "timescale.v"
// synopsys7 translate_on7

`include "uart_defines7.v"

module uart_tfifo7 (clk7, 
	wb_rst_i7, data_in7, data_out7,
// Control7 signals7
	push7, // push7 strobe7, active high7
	pop7,   // pop7 strobe7, active high7
// status signals7
	overrun7,
	count,
	fifo_reset7,
	reset_status7
	);


// FIFO parameters7
parameter fifo_width7 = `UART_FIFO_WIDTH7;
parameter fifo_depth7 = `UART_FIFO_DEPTH7;
parameter fifo_pointer_w7 = `UART_FIFO_POINTER_W7;
parameter fifo_counter_w7 = `UART_FIFO_COUNTER_W7;

input				clk7;
input				wb_rst_i7;
input				push7;
input				pop7;
input	[fifo_width7-1:0]	data_in7;
input				fifo_reset7;
input       reset_status7;

output	[fifo_width7-1:0]	data_out7;
output				overrun7;
output	[fifo_counter_w7-1:0]	count;

wire	[fifo_width7-1:0]	data_out7;

// FIFO pointers7
reg	[fifo_pointer_w7-1:0]	top;
reg	[fifo_pointer_w7-1:0]	bottom7;

reg	[fifo_counter_w7-1:0]	count;
reg				overrun7;
wire [fifo_pointer_w7-1:0] top_plus_17 = top + 1'b1;

raminfr7 #(fifo_pointer_w7,fifo_width7,fifo_depth7) tfifo7  
        (.clk7(clk7), 
			.we7(push7), 
			.a(top), 
			.dpra7(bottom7), 
			.di7(data_in7), 
			.dpo7(data_out7)
		); 


always @(posedge clk7 or posedge wb_rst_i7) // synchronous7 FIFO
begin
	if (wb_rst_i7)
	begin
		top		<= #1 0;
		bottom7		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset7) begin
		top		<= #1 0;
		bottom7		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push7, pop7})
		2'b10 : if (count<fifo_depth7)  // overrun7 condition
			begin
				top       <= #1 top_plus_17;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom7   <= #1 bottom7 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom7   <= #1 bottom7 + 1'b1;
				top       <= #1 top_plus_17;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk7 or posedge wb_rst_i7) // synchronous7 FIFO
begin
  if (wb_rst_i7)
    overrun7   <= #1 1'b0;
  else
  if(fifo_reset7 | reset_status7) 
    overrun7   <= #1 1'b0;
  else
  if(push7 & (count==fifo_depth7))
    overrun7   <= #1 1'b1;
end   // always

endmodule
