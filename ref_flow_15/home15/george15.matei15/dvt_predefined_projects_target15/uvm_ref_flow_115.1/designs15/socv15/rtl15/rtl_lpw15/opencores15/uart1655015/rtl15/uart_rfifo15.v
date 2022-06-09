//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo15.v (Modified15 from uart_fifo15.v)                    ////
////                                                              ////
////                                                              ////
////  This15 file is part of the "UART15 16550 compatible15" project15    ////
////  http15://www15.opencores15.org15/cores15/uart1655015/                   ////
////                                                              ////
////  Documentation15 related15 to this project15:                      ////
////  - http15://www15.opencores15.org15/cores15/uart1655015/                 ////
////                                                              ////
////  Projects15 compatibility15:                                     ////
////  - WISHBONE15                                                  ////
////  RS23215 Protocol15                                              ////
////  16550D uart15 (mostly15 supported)                              ////
////                                                              ////
////  Overview15 (main15 Features15):                                   ////
////  UART15 core15 receiver15 FIFO                                     ////
////                                                              ////
////  To15 Do15:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author15(s):                                                  ////
////      - gorban15@opencores15.org15                                  ////
////      - Jacob15 Gorban15                                          ////
////      - Igor15 Mohor15 (igorm15@opencores15.org15)                      ////
////                                                              ////
////  Created15:        2001/05/12                                  ////
////  Last15 Updated15:   2002/07/22                                  ////
////                  (See log15 for the revision15 history15)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2000, 2001 Authors15                             ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS15 Revision15 History15
//
// $Log: not supported by cvs2svn15 $
// Revision15 1.3  2003/06/11 16:37:47  gorban15
// This15 fixes15 errors15 in some15 cases15 when data is being read and put to the FIFO at the same time. Patch15 is submitted15 by Scott15 Furman15. Update is very15 recommended15.
//
// Revision15 1.2  2002/07/29 21:16:18  gorban15
// The uart_defines15.v file is included15 again15 in sources15.
//
// Revision15 1.1  2002/07/22 23:02:23  gorban15
// Bug15 Fixes15:
//  * Possible15 loss of sync and bad15 reception15 of stop bit on slow15 baud15 rates15 fixed15.
//   Problem15 reported15 by Kenny15.Tung15.
//  * Bad (or lack15 of ) loopback15 handling15 fixed15. Reported15 by Cherry15 Withers15.
//
// Improvements15:
//  * Made15 FIFO's as general15 inferrable15 memory where possible15.
//  So15 on FPGA15 they should be inferred15 as RAM15 (Distributed15 RAM15 on Xilinx15).
//  This15 saves15 about15 1/3 of the Slice15 count and reduces15 P&R and synthesis15 times.
//
//  * Added15 optional15 baudrate15 output (baud_o15).
//  This15 is identical15 to BAUDOUT15* signal15 on 16550 chip15.
//  It outputs15 16xbit_clock_rate - the divided15 clock15.
//  It's disabled by default. Define15 UART_HAS_BAUDRATE_OUTPUT15 to use.
//
// Revision15 1.16  2001/12/20 13:25:46  mohor15
// rx15 push15 changed to be only one cycle wide15.
//
// Revision15 1.15  2001/12/18 09:01:07  mohor15
// Bug15 that was entered15 in the last update fixed15 (rx15 state machine15).
//
// Revision15 1.14  2001/12/17 14:46:48  mohor15
// overrun15 signal15 was moved to separate15 block because many15 sequential15 lsr15
// reads were15 preventing15 data from being written15 to rx15 fifo.
// underrun15 signal15 was not used and was removed from the project15.
//
// Revision15 1.13  2001/11/26 21:38:54  gorban15
// Lots15 of fixes15:
// Break15 condition wasn15't handled15 correctly at all.
// LSR15 bits could lose15 their15 values.
// LSR15 value after reset was wrong15.
// Timing15 of THRE15 interrupt15 signal15 corrected15.
// LSR15 bit 0 timing15 corrected15.
//
// Revision15 1.12  2001/11/08 14:54:23  mohor15
// Comments15 in Slovene15 language15 deleted15, few15 small fixes15 for better15 work15 of
// old15 tools15. IRQs15 need to be fix15.
//
// Revision15 1.11  2001/11/07 17:51:52  gorban15
// Heavily15 rewritten15 interrupt15 and LSR15 subsystems15.
// Many15 bugs15 hopefully15 squashed15.
//
// Revision15 1.10  2001/10/20 09:58:40  gorban15
// Small15 synopsis15 fixes15
//
// Revision15 1.9  2001/08/24 21:01:12  mohor15
// Things15 connected15 to parity15 changed.
// Clock15 devider15 changed.
//
// Revision15 1.8  2001/08/24 08:48:10  mohor15
// FIFO was not cleared15 after the data was read bug15 fixed15.
//
// Revision15 1.7  2001/08/23 16:05:05  mohor15
// Stop bit bug15 fixed15.
// Parity15 bug15 fixed15.
// WISHBONE15 read cycle bug15 fixed15,
// OE15 indicator15 (Overrun15 Error) bug15 fixed15.
// PE15 indicator15 (Parity15 Error) bug15 fixed15.
// Register read bug15 fixed15.
//
// Revision15 1.3  2001/05/31 20:08:01  gorban15
// FIFO changes15 and other corrections15.
//
// Revision15 1.3  2001/05/27 17:37:48  gorban15
// Fixed15 many15 bugs15. Updated15 spec15. Changed15 FIFO files structure15. See CHANGES15.txt15 file.
//
// Revision15 1.2  2001/05/17 18:34:18  gorban15
// First15 'stable' release. Should15 be sythesizable15 now. Also15 added new header.
//
// Revision15 1.0  2001-05-17 21:27:12+02  jacob15
// Initial15 revision15
//
//

// synopsys15 translate_off15
`include "timescale.v"
// synopsys15 translate_on15

`include "uart_defines15.v"

module uart_rfifo15 (clk15, 
	wb_rst_i15, data_in15, data_out15,
// Control15 signals15
	push15, // push15 strobe15, active high15
	pop15,   // pop15 strobe15, active high15
// status signals15
	overrun15,
	count,
	error_bit15,
	fifo_reset15,
	reset_status15
	);


// FIFO parameters15
parameter fifo_width15 = `UART_FIFO_WIDTH15;
parameter fifo_depth15 = `UART_FIFO_DEPTH15;
parameter fifo_pointer_w15 = `UART_FIFO_POINTER_W15;
parameter fifo_counter_w15 = `UART_FIFO_COUNTER_W15;

input				clk15;
input				wb_rst_i15;
input				push15;
input				pop15;
input	[fifo_width15-1:0]	data_in15;
input				fifo_reset15;
input       reset_status15;

output	[fifo_width15-1:0]	data_out15;
output				overrun15;
output	[fifo_counter_w15-1:0]	count;
output				error_bit15;

wire	[fifo_width15-1:0]	data_out15;
wire [7:0] data8_out15;
// flags15 FIFO
reg	[2:0]	fifo[fifo_depth15-1:0];

// FIFO pointers15
reg	[fifo_pointer_w15-1:0]	top;
reg	[fifo_pointer_w15-1:0]	bottom15;

reg	[fifo_counter_w15-1:0]	count;
reg				overrun15;

wire [fifo_pointer_w15-1:0] top_plus_115 = top + 1'b1;

raminfr15 #(fifo_pointer_w15,8,fifo_depth15) rfifo15  
        (.clk15(clk15), 
			.we15(push15), 
			.a(top), 
			.dpra15(bottom15), 
			.di15(data_in15[fifo_width15-1:fifo_width15-8]), 
			.dpo15(data8_out15)
		); 

always @(posedge clk15 or posedge wb_rst_i15) // synchronous15 FIFO
begin
	if (wb_rst_i15)
	begin
		top		<= #1 0;
		bottom15		<= #1 1'b0;
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
	if (fifo_reset15) begin
		top		<= #1 0;
		bottom15		<= #1 1'b0;
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
		case ({push15, pop15})
		2'b10 : if (count<fifo_depth15)  // overrun15 condition
			begin
				top       <= #1 top_plus_115;
				fifo[top] <= #1 data_in15[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom15] <= #1 0;
				bottom15   <= #1 bottom15 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom15   <= #1 bottom15 + 1'b1;
				top       <= #1 top_plus_115;
				fifo[top] <= #1 data_in15[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk15 or posedge wb_rst_i15) // synchronous15 FIFO
begin
  if (wb_rst_i15)
    overrun15   <= #1 1'b0;
  else
  if(fifo_reset15 | reset_status15) 
    overrun15   <= #1 1'b0;
  else
  if(push15 & ~pop15 & (count==fifo_depth15))
    overrun15   <= #1 1'b1;
end   // always


// please15 note15 though15 that data_out15 is only valid one clock15 after pop15 signal15
assign data_out15 = {data8_out15,fifo[bottom15]};

// Additional15 logic for detection15 of error conditions15 (parity15 and framing15) inside the FIFO
// for the Line15 Status Register bit 7

wire	[2:0]	word015 = fifo[0];
wire	[2:0]	word115 = fifo[1];
wire	[2:0]	word215 = fifo[2];
wire	[2:0]	word315 = fifo[3];
wire	[2:0]	word415 = fifo[4];
wire	[2:0]	word515 = fifo[5];
wire	[2:0]	word615 = fifo[6];
wire	[2:0]	word715 = fifo[7];

wire	[2:0]	word815 = fifo[8];
wire	[2:0]	word915 = fifo[9];
wire	[2:0]	word1015 = fifo[10];
wire	[2:0]	word1115 = fifo[11];
wire	[2:0]	word1215 = fifo[12];
wire	[2:0]	word1315 = fifo[13];
wire	[2:0]	word1415 = fifo[14];
wire	[2:0]	word1515 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit15 = |(word015[2:0]  | word115[2:0]  | word215[2:0]  | word315[2:0]  |
            		      word415[2:0]  | word515[2:0]  | word615[2:0]  | word715[2:0]  |
            		      word815[2:0]  | word915[2:0]  | word1015[2:0] | word1115[2:0] |
            		      word1215[2:0] | word1315[2:0] | word1415[2:0] | word1515[2:0] );

endmodule
