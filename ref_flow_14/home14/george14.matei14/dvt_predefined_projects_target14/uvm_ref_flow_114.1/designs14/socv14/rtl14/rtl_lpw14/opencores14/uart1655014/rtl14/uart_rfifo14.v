//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo14.v (Modified14 from uart_fifo14.v)                    ////
////                                                              ////
////                                                              ////
////  This14 file is part of the "UART14 16550 compatible14" project14    ////
////  http14://www14.opencores14.org14/cores14/uart1655014/                   ////
////                                                              ////
////  Documentation14 related14 to this project14:                      ////
////  - http14://www14.opencores14.org14/cores14/uart1655014/                 ////
////                                                              ////
////  Projects14 compatibility14:                                     ////
////  - WISHBONE14                                                  ////
////  RS23214 Protocol14                                              ////
////  16550D uart14 (mostly14 supported)                              ////
////                                                              ////
////  Overview14 (main14 Features14):                                   ////
////  UART14 core14 receiver14 FIFO                                     ////
////                                                              ////
////  To14 Do14:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author14(s):                                                  ////
////      - gorban14@opencores14.org14                                  ////
////      - Jacob14 Gorban14                                          ////
////      - Igor14 Mohor14 (igorm14@opencores14.org14)                      ////
////                                                              ////
////  Created14:        2001/05/12                                  ////
////  Last14 Updated14:   2002/07/22                                  ////
////                  (See log14 for the revision14 history14)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2000, 2001 Authors14                             ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS14 Revision14 History14
//
// $Log: not supported by cvs2svn14 $
// Revision14 1.3  2003/06/11 16:37:47  gorban14
// This14 fixes14 errors14 in some14 cases14 when data is being read and put to the FIFO at the same time. Patch14 is submitted14 by Scott14 Furman14. Update is very14 recommended14.
//
// Revision14 1.2  2002/07/29 21:16:18  gorban14
// The uart_defines14.v file is included14 again14 in sources14.
//
// Revision14 1.1  2002/07/22 23:02:23  gorban14
// Bug14 Fixes14:
//  * Possible14 loss of sync and bad14 reception14 of stop bit on slow14 baud14 rates14 fixed14.
//   Problem14 reported14 by Kenny14.Tung14.
//  * Bad (or lack14 of ) loopback14 handling14 fixed14. Reported14 by Cherry14 Withers14.
//
// Improvements14:
//  * Made14 FIFO's as general14 inferrable14 memory where possible14.
//  So14 on FPGA14 they should be inferred14 as RAM14 (Distributed14 RAM14 on Xilinx14).
//  This14 saves14 about14 1/3 of the Slice14 count and reduces14 P&R and synthesis14 times.
//
//  * Added14 optional14 baudrate14 output (baud_o14).
//  This14 is identical14 to BAUDOUT14* signal14 on 16550 chip14.
//  It outputs14 16xbit_clock_rate - the divided14 clock14.
//  It's disabled by default. Define14 UART_HAS_BAUDRATE_OUTPUT14 to use.
//
// Revision14 1.16  2001/12/20 13:25:46  mohor14
// rx14 push14 changed to be only one cycle wide14.
//
// Revision14 1.15  2001/12/18 09:01:07  mohor14
// Bug14 that was entered14 in the last update fixed14 (rx14 state machine14).
//
// Revision14 1.14  2001/12/17 14:46:48  mohor14
// overrun14 signal14 was moved to separate14 block because many14 sequential14 lsr14
// reads were14 preventing14 data from being written14 to rx14 fifo.
// underrun14 signal14 was not used and was removed from the project14.
//
// Revision14 1.13  2001/11/26 21:38:54  gorban14
// Lots14 of fixes14:
// Break14 condition wasn14't handled14 correctly at all.
// LSR14 bits could lose14 their14 values.
// LSR14 value after reset was wrong14.
// Timing14 of THRE14 interrupt14 signal14 corrected14.
// LSR14 bit 0 timing14 corrected14.
//
// Revision14 1.12  2001/11/08 14:54:23  mohor14
// Comments14 in Slovene14 language14 deleted14, few14 small fixes14 for better14 work14 of
// old14 tools14. IRQs14 need to be fix14.
//
// Revision14 1.11  2001/11/07 17:51:52  gorban14
// Heavily14 rewritten14 interrupt14 and LSR14 subsystems14.
// Many14 bugs14 hopefully14 squashed14.
//
// Revision14 1.10  2001/10/20 09:58:40  gorban14
// Small14 synopsis14 fixes14
//
// Revision14 1.9  2001/08/24 21:01:12  mohor14
// Things14 connected14 to parity14 changed.
// Clock14 devider14 changed.
//
// Revision14 1.8  2001/08/24 08:48:10  mohor14
// FIFO was not cleared14 after the data was read bug14 fixed14.
//
// Revision14 1.7  2001/08/23 16:05:05  mohor14
// Stop bit bug14 fixed14.
// Parity14 bug14 fixed14.
// WISHBONE14 read cycle bug14 fixed14,
// OE14 indicator14 (Overrun14 Error) bug14 fixed14.
// PE14 indicator14 (Parity14 Error) bug14 fixed14.
// Register read bug14 fixed14.
//
// Revision14 1.3  2001/05/31 20:08:01  gorban14
// FIFO changes14 and other corrections14.
//
// Revision14 1.3  2001/05/27 17:37:48  gorban14
// Fixed14 many14 bugs14. Updated14 spec14. Changed14 FIFO files structure14. See CHANGES14.txt14 file.
//
// Revision14 1.2  2001/05/17 18:34:18  gorban14
// First14 'stable' release. Should14 be sythesizable14 now. Also14 added new header.
//
// Revision14 1.0  2001-05-17 21:27:12+02  jacob14
// Initial14 revision14
//
//

// synopsys14 translate_off14
`include "timescale.v"
// synopsys14 translate_on14

`include "uart_defines14.v"

module uart_rfifo14 (clk14, 
	wb_rst_i14, data_in14, data_out14,
// Control14 signals14
	push14, // push14 strobe14, active high14
	pop14,   // pop14 strobe14, active high14
// status signals14
	overrun14,
	count,
	error_bit14,
	fifo_reset14,
	reset_status14
	);


// FIFO parameters14
parameter fifo_width14 = `UART_FIFO_WIDTH14;
parameter fifo_depth14 = `UART_FIFO_DEPTH14;
parameter fifo_pointer_w14 = `UART_FIFO_POINTER_W14;
parameter fifo_counter_w14 = `UART_FIFO_COUNTER_W14;

input				clk14;
input				wb_rst_i14;
input				push14;
input				pop14;
input	[fifo_width14-1:0]	data_in14;
input				fifo_reset14;
input       reset_status14;

output	[fifo_width14-1:0]	data_out14;
output				overrun14;
output	[fifo_counter_w14-1:0]	count;
output				error_bit14;

wire	[fifo_width14-1:0]	data_out14;
wire [7:0] data8_out14;
// flags14 FIFO
reg	[2:0]	fifo[fifo_depth14-1:0];

// FIFO pointers14
reg	[fifo_pointer_w14-1:0]	top;
reg	[fifo_pointer_w14-1:0]	bottom14;

reg	[fifo_counter_w14-1:0]	count;
reg				overrun14;

wire [fifo_pointer_w14-1:0] top_plus_114 = top + 1'b1;

raminfr14 #(fifo_pointer_w14,8,fifo_depth14) rfifo14  
        (.clk14(clk14), 
			.we14(push14), 
			.a(top), 
			.dpra14(bottom14), 
			.di14(data_in14[fifo_width14-1:fifo_width14-8]), 
			.dpo14(data8_out14)
		); 

always @(posedge clk14 or posedge wb_rst_i14) // synchronous14 FIFO
begin
	if (wb_rst_i14)
	begin
		top		<= #1 0;
		bottom14		<= #1 1'b0;
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
	if (fifo_reset14) begin
		top		<= #1 0;
		bottom14		<= #1 1'b0;
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
		case ({push14, pop14})
		2'b10 : if (count<fifo_depth14)  // overrun14 condition
			begin
				top       <= #1 top_plus_114;
				fifo[top] <= #1 data_in14[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom14] <= #1 0;
				bottom14   <= #1 bottom14 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom14   <= #1 bottom14 + 1'b1;
				top       <= #1 top_plus_114;
				fifo[top] <= #1 data_in14[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk14 or posedge wb_rst_i14) // synchronous14 FIFO
begin
  if (wb_rst_i14)
    overrun14   <= #1 1'b0;
  else
  if(fifo_reset14 | reset_status14) 
    overrun14   <= #1 1'b0;
  else
  if(push14 & ~pop14 & (count==fifo_depth14))
    overrun14   <= #1 1'b1;
end   // always


// please14 note14 though14 that data_out14 is only valid one clock14 after pop14 signal14
assign data_out14 = {data8_out14,fifo[bottom14]};

// Additional14 logic for detection14 of error conditions14 (parity14 and framing14) inside the FIFO
// for the Line14 Status Register bit 7

wire	[2:0]	word014 = fifo[0];
wire	[2:0]	word114 = fifo[1];
wire	[2:0]	word214 = fifo[2];
wire	[2:0]	word314 = fifo[3];
wire	[2:0]	word414 = fifo[4];
wire	[2:0]	word514 = fifo[5];
wire	[2:0]	word614 = fifo[6];
wire	[2:0]	word714 = fifo[7];

wire	[2:0]	word814 = fifo[8];
wire	[2:0]	word914 = fifo[9];
wire	[2:0]	word1014 = fifo[10];
wire	[2:0]	word1114 = fifo[11];
wire	[2:0]	word1214 = fifo[12];
wire	[2:0]	word1314 = fifo[13];
wire	[2:0]	word1414 = fifo[14];
wire	[2:0]	word1514 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit14 = |(word014[2:0]  | word114[2:0]  | word214[2:0]  | word314[2:0]  |
            		      word414[2:0]  | word514[2:0]  | word614[2:0]  | word714[2:0]  |
            		      word814[2:0]  | word914[2:0]  | word1014[2:0] | word1114[2:0] |
            		      word1214[2:0] | word1314[2:0] | word1414[2:0] | word1514[2:0] );

endmodule
