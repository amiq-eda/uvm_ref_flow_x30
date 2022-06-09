//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo9.v                                                ////
////                                                              ////
////                                                              ////
////  This9 file is part of the "UART9 16550 compatible9" project9    ////
////  http9://www9.opencores9.org9/cores9/uart165509/                   ////
////                                                              ////
////  Documentation9 related9 to this project9:                      ////
////  - http9://www9.opencores9.org9/cores9/uart165509/                 ////
////                                                              ////
////  Projects9 compatibility9:                                     ////
////  - WISHBONE9                                                  ////
////  RS2329 Protocol9                                              ////
////  16550D uart9 (mostly9 supported)                              ////
////                                                              ////
////  Overview9 (main9 Features9):                                   ////
////  UART9 core9 transmitter9 FIFO                                  ////
////                                                              ////
////  To9 Do9:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author9(s):                                                  ////
////      - gorban9@opencores9.org9                                  ////
////      - Jacob9 Gorban9                                          ////
////      - Igor9 Mohor9 (igorm9@opencores9.org9)                      ////
////                                                              ////
////  Created9:        2001/05/12                                  ////
////  Last9 Updated9:   2002/07/22                                  ////
////                  (See log9 for the revision9 history9)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2000, 2001 Authors9                             ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS9 Revision9 History9
//
// $Log: not supported by cvs2svn9 $
// Revision9 1.1  2002/07/22 23:02:23  gorban9
// Bug9 Fixes9:
//  * Possible9 loss of sync and bad9 reception9 of stop bit on slow9 baud9 rates9 fixed9.
//   Problem9 reported9 by Kenny9.Tung9.
//  * Bad (or lack9 of ) loopback9 handling9 fixed9. Reported9 by Cherry9 Withers9.
//
// Improvements9:
//  * Made9 FIFO's as general9 inferrable9 memory where possible9.
//  So9 on FPGA9 they should be inferred9 as RAM9 (Distributed9 RAM9 on Xilinx9).
//  This9 saves9 about9 1/3 of the Slice9 count and reduces9 P&R and synthesis9 times.
//
//  * Added9 optional9 baudrate9 output (baud_o9).
//  This9 is identical9 to BAUDOUT9* signal9 on 16550 chip9.
//  It outputs9 16xbit_clock_rate - the divided9 clock9.
//  It's disabled by default. Define9 UART_HAS_BAUDRATE_OUTPUT9 to use.
//
// Revision9 1.16  2001/12/20 13:25:46  mohor9
// rx9 push9 changed to be only one cycle wide9.
//
// Revision9 1.15  2001/12/18 09:01:07  mohor9
// Bug9 that was entered9 in the last update fixed9 (rx9 state machine9).
//
// Revision9 1.14  2001/12/17 14:46:48  mohor9
// overrun9 signal9 was moved to separate9 block because many9 sequential9 lsr9
// reads were9 preventing9 data from being written9 to rx9 fifo.
// underrun9 signal9 was not used and was removed from the project9.
//
// Revision9 1.13  2001/11/26 21:38:54  gorban9
// Lots9 of fixes9:
// Break9 condition wasn9't handled9 correctly at all.
// LSR9 bits could lose9 their9 values.
// LSR9 value after reset was wrong9.
// Timing9 of THRE9 interrupt9 signal9 corrected9.
// LSR9 bit 0 timing9 corrected9.
//
// Revision9 1.12  2001/11/08 14:54:23  mohor9
// Comments9 in Slovene9 language9 deleted9, few9 small fixes9 for better9 work9 of
// old9 tools9. IRQs9 need to be fix9.
//
// Revision9 1.11  2001/11/07 17:51:52  gorban9
// Heavily9 rewritten9 interrupt9 and LSR9 subsystems9.
// Many9 bugs9 hopefully9 squashed9.
//
// Revision9 1.10  2001/10/20 09:58:40  gorban9
// Small9 synopsis9 fixes9
//
// Revision9 1.9  2001/08/24 21:01:12  mohor9
// Things9 connected9 to parity9 changed.
// Clock9 devider9 changed.
//
// Revision9 1.8  2001/08/24 08:48:10  mohor9
// FIFO was not cleared9 after the data was read bug9 fixed9.
//
// Revision9 1.7  2001/08/23 16:05:05  mohor9
// Stop bit bug9 fixed9.
// Parity9 bug9 fixed9.
// WISHBONE9 read cycle bug9 fixed9,
// OE9 indicator9 (Overrun9 Error) bug9 fixed9.
// PE9 indicator9 (Parity9 Error) bug9 fixed9.
// Register read bug9 fixed9.
//
// Revision9 1.3  2001/05/31 20:08:01  gorban9
// FIFO changes9 and other corrections9.
//
// Revision9 1.3  2001/05/27 17:37:48  gorban9
// Fixed9 many9 bugs9. Updated9 spec9. Changed9 FIFO files structure9. See CHANGES9.txt9 file.
//
// Revision9 1.2  2001/05/17 18:34:18  gorban9
// First9 'stable' release. Should9 be sythesizable9 now. Also9 added new header.
//
// Revision9 1.0  2001-05-17 21:27:12+02  jacob9
// Initial9 revision9
//
//

// synopsys9 translate_off9
`include "timescale.v"
// synopsys9 translate_on9

`include "uart_defines9.v"

module uart_tfifo9 (clk9, 
	wb_rst_i9, data_in9, data_out9,
// Control9 signals9
	push9, // push9 strobe9, active high9
	pop9,   // pop9 strobe9, active high9
// status signals9
	overrun9,
	count,
	fifo_reset9,
	reset_status9
	);


// FIFO parameters9
parameter fifo_width9 = `UART_FIFO_WIDTH9;
parameter fifo_depth9 = `UART_FIFO_DEPTH9;
parameter fifo_pointer_w9 = `UART_FIFO_POINTER_W9;
parameter fifo_counter_w9 = `UART_FIFO_COUNTER_W9;

input				clk9;
input				wb_rst_i9;
input				push9;
input				pop9;
input	[fifo_width9-1:0]	data_in9;
input				fifo_reset9;
input       reset_status9;

output	[fifo_width9-1:0]	data_out9;
output				overrun9;
output	[fifo_counter_w9-1:0]	count;

wire	[fifo_width9-1:0]	data_out9;

// FIFO pointers9
reg	[fifo_pointer_w9-1:0]	top;
reg	[fifo_pointer_w9-1:0]	bottom9;

reg	[fifo_counter_w9-1:0]	count;
reg				overrun9;
wire [fifo_pointer_w9-1:0] top_plus_19 = top + 1'b1;

raminfr9 #(fifo_pointer_w9,fifo_width9,fifo_depth9) tfifo9  
        (.clk9(clk9), 
			.we9(push9), 
			.a(top), 
			.dpra9(bottom9), 
			.di9(data_in9), 
			.dpo9(data_out9)
		); 


always @(posedge clk9 or posedge wb_rst_i9) // synchronous9 FIFO
begin
	if (wb_rst_i9)
	begin
		top		<= #1 0;
		bottom9		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset9) begin
		top		<= #1 0;
		bottom9		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push9, pop9})
		2'b10 : if (count<fifo_depth9)  // overrun9 condition
			begin
				top       <= #1 top_plus_19;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom9   <= #1 bottom9 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom9   <= #1 bottom9 + 1'b1;
				top       <= #1 top_plus_19;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk9 or posedge wb_rst_i9) // synchronous9 FIFO
begin
  if (wb_rst_i9)
    overrun9   <= #1 1'b0;
  else
  if(fifo_reset9 | reset_status9) 
    overrun9   <= #1 1'b0;
  else
  if(push9 & (count==fifo_depth9))
    overrun9   <= #1 1'b1;
end   // always

endmodule
