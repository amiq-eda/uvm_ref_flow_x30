//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo9.v (Modified9 from uart_fifo9.v)                    ////
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
////  UART9 core9 receiver9 FIFO                                     ////
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
// Revision9 1.3  2003/06/11 16:37:47  gorban9
// This9 fixes9 errors9 in some9 cases9 when data is being read and put to the FIFO at the same time. Patch9 is submitted9 by Scott9 Furman9. Update is very9 recommended9.
//
// Revision9 1.2  2002/07/29 21:16:18  gorban9
// The uart_defines9.v file is included9 again9 in sources9.
//
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

module uart_rfifo9 (clk9, 
	wb_rst_i9, data_in9, data_out9,
// Control9 signals9
	push9, // push9 strobe9, active high9
	pop9,   // pop9 strobe9, active high9
// status signals9
	overrun9,
	count,
	error_bit9,
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
output				error_bit9;

wire	[fifo_width9-1:0]	data_out9;
wire [7:0] data8_out9;
// flags9 FIFO
reg	[2:0]	fifo[fifo_depth9-1:0];

// FIFO pointers9
reg	[fifo_pointer_w9-1:0]	top;
reg	[fifo_pointer_w9-1:0]	bottom9;

reg	[fifo_counter_w9-1:0]	count;
reg				overrun9;

wire [fifo_pointer_w9-1:0] top_plus_19 = top + 1'b1;

raminfr9 #(fifo_pointer_w9,8,fifo_depth9) rfifo9  
        (.clk9(clk9), 
			.we9(push9), 
			.a(top), 
			.dpra9(bottom9), 
			.di9(data_in9[fifo_width9-1:fifo_width9-8]), 
			.dpo9(data8_out9)
		); 

always @(posedge clk9 or posedge wb_rst_i9) // synchronous9 FIFO
begin
	if (wb_rst_i9)
	begin
		top		<= #1 0;
		bottom9		<= #1 1'b0;
		count		<= #1 0;
		fifo[0] <= #1 0;
		fifo[1] <= #1 0;
		fifo[2] <= #1 0;
		fifo[3] <= #1 0;
		fifo[4] <= #1 0;
		fifo[5] <= #1 0;
		fifo[6] <= #1 0;
		fifo[7] <= #1 0;
		fifo[8] <= #1 0;
		fifo[9] <= #1 0;
		fifo[10] <= #1 0;
		fifo[11] <= #1 0;
		fifo[12] <= #1 0;
		fifo[13] <= #1 0;
		fifo[14] <= #1 0;
		fifo[15] <= #1 0;
	end
	else
	if (fifo_reset9) begin
		top		<= #1 0;
		bottom9		<= #1 1'b0;
		count		<= #1 0;
		fifo[0] <= #1 0;
		fifo[1] <= #1 0;
		fifo[2] <= #1 0;
		fifo[3] <= #1 0;
		fifo[4] <= #1 0;
		fifo[5] <= #1 0;
		fifo[6] <= #1 0;
		fifo[7] <= #1 0;
		fifo[8] <= #1 0;
		fifo[9] <= #1 0;
		fifo[10] <= #1 0;
		fifo[11] <= #1 0;
		fifo[12] <= #1 0;
		fifo[13] <= #1 0;
		fifo[14] <= #1 0;
		fifo[15] <= #1 0;
	end
  else
	begin
		case ({push9, pop9})
		2'b10 : if (count<fifo_depth9)  // overrun9 condition
			begin
				top       <= #1 top_plus_19;
				fifo[top] <= #1 data_in9[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom9] <= #1 0;
				bottom9   <= #1 bottom9 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom9   <= #1 bottom9 + 1'b1;
				top       <= #1 top_plus_19;
				fifo[top] <= #1 data_in9[2:0];
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
  if(push9 & ~pop9 & (count==fifo_depth9))
    overrun9   <= #1 1'b1;
end   // always


// please9 note9 though9 that data_out9 is only valid one clock9 after pop9 signal9
assign data_out9 = {data8_out9,fifo[bottom9]};

// Additional9 logic for detection9 of error conditions9 (parity9 and framing9) inside the FIFO
// for the Line9 Status Register bit 7

wire	[2:0]	word09 = fifo[0];
wire	[2:0]	word19 = fifo[1];
wire	[2:0]	word29 = fifo[2];
wire	[2:0]	word39 = fifo[3];
wire	[2:0]	word49 = fifo[4];
wire	[2:0]	word59 = fifo[5];
wire	[2:0]	word69 = fifo[6];
wire	[2:0]	word79 = fifo[7];

wire	[2:0]	word89 = fifo[8];
wire	[2:0]	word99 = fifo[9];
wire	[2:0]	word109 = fifo[10];
wire	[2:0]	word119 = fifo[11];
wire	[2:0]	word129 = fifo[12];
wire	[2:0]	word139 = fifo[13];
wire	[2:0]	word149 = fifo[14];
wire	[2:0]	word159 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit9 = |(word09[2:0]  | word19[2:0]  | word29[2:0]  | word39[2:0]  |
            		      word49[2:0]  | word59[2:0]  | word69[2:0]  | word79[2:0]  |
            		      word89[2:0]  | word99[2:0]  | word109[2:0] | word119[2:0] |
            		      word129[2:0] | word139[2:0] | word149[2:0] | word159[2:0] );

endmodule
