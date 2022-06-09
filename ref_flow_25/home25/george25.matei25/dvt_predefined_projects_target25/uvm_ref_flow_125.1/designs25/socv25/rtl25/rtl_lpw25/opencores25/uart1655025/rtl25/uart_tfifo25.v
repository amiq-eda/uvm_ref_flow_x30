//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo25.v                                                ////
////                                                              ////
////                                                              ////
////  This25 file is part of the "UART25 16550 compatible25" project25    ////
////  http25://www25.opencores25.org25/cores25/uart1655025/                   ////
////                                                              ////
////  Documentation25 related25 to this project25:                      ////
////  - http25://www25.opencores25.org25/cores25/uart1655025/                 ////
////                                                              ////
////  Projects25 compatibility25:                                     ////
////  - WISHBONE25                                                  ////
////  RS23225 Protocol25                                              ////
////  16550D uart25 (mostly25 supported)                              ////
////                                                              ////
////  Overview25 (main25 Features25):                                   ////
////  UART25 core25 transmitter25 FIFO                                  ////
////                                                              ////
////  To25 Do25:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author25(s):                                                  ////
////      - gorban25@opencores25.org25                                  ////
////      - Jacob25 Gorban25                                          ////
////      - Igor25 Mohor25 (igorm25@opencores25.org25)                      ////
////                                                              ////
////  Created25:        2001/05/12                                  ////
////  Last25 Updated25:   2002/07/22                                  ////
////                  (See log25 for the revision25 history25)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2000, 2001 Authors25                             ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS25 Revision25 History25
//
// $Log: not supported by cvs2svn25 $
// Revision25 1.1  2002/07/22 23:02:23  gorban25
// Bug25 Fixes25:
//  * Possible25 loss of sync and bad25 reception25 of stop bit on slow25 baud25 rates25 fixed25.
//   Problem25 reported25 by Kenny25.Tung25.
//  * Bad (or lack25 of ) loopback25 handling25 fixed25. Reported25 by Cherry25 Withers25.
//
// Improvements25:
//  * Made25 FIFO's as general25 inferrable25 memory where possible25.
//  So25 on FPGA25 they should be inferred25 as RAM25 (Distributed25 RAM25 on Xilinx25).
//  This25 saves25 about25 1/3 of the Slice25 count and reduces25 P&R and synthesis25 times.
//
//  * Added25 optional25 baudrate25 output (baud_o25).
//  This25 is identical25 to BAUDOUT25* signal25 on 16550 chip25.
//  It outputs25 16xbit_clock_rate - the divided25 clock25.
//  It's disabled by default. Define25 UART_HAS_BAUDRATE_OUTPUT25 to use.
//
// Revision25 1.16  2001/12/20 13:25:46  mohor25
// rx25 push25 changed to be only one cycle wide25.
//
// Revision25 1.15  2001/12/18 09:01:07  mohor25
// Bug25 that was entered25 in the last update fixed25 (rx25 state machine25).
//
// Revision25 1.14  2001/12/17 14:46:48  mohor25
// overrun25 signal25 was moved to separate25 block because many25 sequential25 lsr25
// reads were25 preventing25 data from being written25 to rx25 fifo.
// underrun25 signal25 was not used and was removed from the project25.
//
// Revision25 1.13  2001/11/26 21:38:54  gorban25
// Lots25 of fixes25:
// Break25 condition wasn25't handled25 correctly at all.
// LSR25 bits could lose25 their25 values.
// LSR25 value after reset was wrong25.
// Timing25 of THRE25 interrupt25 signal25 corrected25.
// LSR25 bit 0 timing25 corrected25.
//
// Revision25 1.12  2001/11/08 14:54:23  mohor25
// Comments25 in Slovene25 language25 deleted25, few25 small fixes25 for better25 work25 of
// old25 tools25. IRQs25 need to be fix25.
//
// Revision25 1.11  2001/11/07 17:51:52  gorban25
// Heavily25 rewritten25 interrupt25 and LSR25 subsystems25.
// Many25 bugs25 hopefully25 squashed25.
//
// Revision25 1.10  2001/10/20 09:58:40  gorban25
// Small25 synopsis25 fixes25
//
// Revision25 1.9  2001/08/24 21:01:12  mohor25
// Things25 connected25 to parity25 changed.
// Clock25 devider25 changed.
//
// Revision25 1.8  2001/08/24 08:48:10  mohor25
// FIFO was not cleared25 after the data was read bug25 fixed25.
//
// Revision25 1.7  2001/08/23 16:05:05  mohor25
// Stop bit bug25 fixed25.
// Parity25 bug25 fixed25.
// WISHBONE25 read cycle bug25 fixed25,
// OE25 indicator25 (Overrun25 Error) bug25 fixed25.
// PE25 indicator25 (Parity25 Error) bug25 fixed25.
// Register read bug25 fixed25.
//
// Revision25 1.3  2001/05/31 20:08:01  gorban25
// FIFO changes25 and other corrections25.
//
// Revision25 1.3  2001/05/27 17:37:48  gorban25
// Fixed25 many25 bugs25. Updated25 spec25. Changed25 FIFO files structure25. See CHANGES25.txt25 file.
//
// Revision25 1.2  2001/05/17 18:34:18  gorban25
// First25 'stable' release. Should25 be sythesizable25 now. Also25 added new header.
//
// Revision25 1.0  2001-05-17 21:27:12+02  jacob25
// Initial25 revision25
//
//

// synopsys25 translate_off25
`include "timescale.v"
// synopsys25 translate_on25

`include "uart_defines25.v"

module uart_tfifo25 (clk25, 
	wb_rst_i25, data_in25, data_out25,
// Control25 signals25
	push25, // push25 strobe25, active high25
	pop25,   // pop25 strobe25, active high25
// status signals25
	overrun25,
	count,
	fifo_reset25,
	reset_status25
	);


// FIFO parameters25
parameter fifo_width25 = `UART_FIFO_WIDTH25;
parameter fifo_depth25 = `UART_FIFO_DEPTH25;
parameter fifo_pointer_w25 = `UART_FIFO_POINTER_W25;
parameter fifo_counter_w25 = `UART_FIFO_COUNTER_W25;

input				clk25;
input				wb_rst_i25;
input				push25;
input				pop25;
input	[fifo_width25-1:0]	data_in25;
input				fifo_reset25;
input       reset_status25;

output	[fifo_width25-1:0]	data_out25;
output				overrun25;
output	[fifo_counter_w25-1:0]	count;

wire	[fifo_width25-1:0]	data_out25;

// FIFO pointers25
reg	[fifo_pointer_w25-1:0]	top;
reg	[fifo_pointer_w25-1:0]	bottom25;

reg	[fifo_counter_w25-1:0]	count;
reg				overrun25;
wire [fifo_pointer_w25-1:0] top_plus_125 = top + 1'b1;

raminfr25 #(fifo_pointer_w25,fifo_width25,fifo_depth25) tfifo25  
        (.clk25(clk25), 
			.we25(push25), 
			.a(top), 
			.dpra25(bottom25), 
			.di25(data_in25), 
			.dpo25(data_out25)
		); 


always @(posedge clk25 or posedge wb_rst_i25) // synchronous25 FIFO
begin
	if (wb_rst_i25)
	begin
		top		<= #1 0;
		bottom25		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset25) begin
		top		<= #1 0;
		bottom25		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push25, pop25})
		2'b10 : if (count<fifo_depth25)  // overrun25 condition
			begin
				top       <= #1 top_plus_125;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom25   <= #1 bottom25 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom25   <= #1 bottom25 + 1'b1;
				top       <= #1 top_plus_125;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk25 or posedge wb_rst_i25) // synchronous25 FIFO
begin
  if (wb_rst_i25)
    overrun25   <= #1 1'b0;
  else
  if(fifo_reset25 | reset_status25) 
    overrun25   <= #1 1'b0;
  else
  if(push25 & (count==fifo_depth25))
    overrun25   <= #1 1'b1;
end   // always

endmodule
