//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo16.v (Modified16 from uart_fifo16.v)                    ////
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
////  UART16 core16 receiver16 FIFO                                     ////
////                                                              ////
////  To16 Do16:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author16(s):                                                  ////
////      - gorban16@opencores16.org16                                  ////
////      - Jacob16 Gorban16                                          ////
////      - Igor16 Mohor16 (igorm16@opencores16.org16)                      ////
////                                                              ////
////  Created16:        2001/05/12                                  ////
////  Last16 Updated16:   2002/07/22                                  ////
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
// Revision16 1.3  2003/06/11 16:37:47  gorban16
// This16 fixes16 errors16 in some16 cases16 when data is being read and put to the FIFO at the same time. Patch16 is submitted16 by Scott16 Furman16. Update is very16 recommended16.
//
// Revision16 1.2  2002/07/29 21:16:18  gorban16
// The uart_defines16.v file is included16 again16 in sources16.
//
// Revision16 1.1  2002/07/22 23:02:23  gorban16
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
// Revision16 1.16  2001/12/20 13:25:46  mohor16
// rx16 push16 changed to be only one cycle wide16.
//
// Revision16 1.15  2001/12/18 09:01:07  mohor16
// Bug16 that was entered16 in the last update fixed16 (rx16 state machine16).
//
// Revision16 1.14  2001/12/17 14:46:48  mohor16
// overrun16 signal16 was moved to separate16 block because many16 sequential16 lsr16
// reads were16 preventing16 data from being written16 to rx16 fifo.
// underrun16 signal16 was not used and was removed from the project16.
//
// Revision16 1.13  2001/11/26 21:38:54  gorban16
// Lots16 of fixes16:
// Break16 condition wasn16't handled16 correctly at all.
// LSR16 bits could lose16 their16 values.
// LSR16 value after reset was wrong16.
// Timing16 of THRE16 interrupt16 signal16 corrected16.
// LSR16 bit 0 timing16 corrected16.
//
// Revision16 1.12  2001/11/08 14:54:23  mohor16
// Comments16 in Slovene16 language16 deleted16, few16 small fixes16 for better16 work16 of
// old16 tools16. IRQs16 need to be fix16.
//
// Revision16 1.11  2001/11/07 17:51:52  gorban16
// Heavily16 rewritten16 interrupt16 and LSR16 subsystems16.
// Many16 bugs16 hopefully16 squashed16.
//
// Revision16 1.10  2001/10/20 09:58:40  gorban16
// Small16 synopsis16 fixes16
//
// Revision16 1.9  2001/08/24 21:01:12  mohor16
// Things16 connected16 to parity16 changed.
// Clock16 devider16 changed.
//
// Revision16 1.8  2001/08/24 08:48:10  mohor16
// FIFO was not cleared16 after the data was read bug16 fixed16.
//
// Revision16 1.7  2001/08/23 16:05:05  mohor16
// Stop bit bug16 fixed16.
// Parity16 bug16 fixed16.
// WISHBONE16 read cycle bug16 fixed16,
// OE16 indicator16 (Overrun16 Error) bug16 fixed16.
// PE16 indicator16 (Parity16 Error) bug16 fixed16.
// Register read bug16 fixed16.
//
// Revision16 1.3  2001/05/31 20:08:01  gorban16
// FIFO changes16 and other corrections16.
//
// Revision16 1.3  2001/05/27 17:37:48  gorban16
// Fixed16 many16 bugs16. Updated16 spec16. Changed16 FIFO files structure16. See CHANGES16.txt16 file.
//
// Revision16 1.2  2001/05/17 18:34:18  gorban16
// First16 'stable' release. Should16 be sythesizable16 now. Also16 added new header.
//
// Revision16 1.0  2001-05-17 21:27:12+02  jacob16
// Initial16 revision16
//
//

// synopsys16 translate_off16
`include "timescale.v"
// synopsys16 translate_on16

`include "uart_defines16.v"

module uart_rfifo16 (clk16, 
	wb_rst_i16, data_in16, data_out16,
// Control16 signals16
	push16, // push16 strobe16, active high16
	pop16,   // pop16 strobe16, active high16
// status signals16
	overrun16,
	count,
	error_bit16,
	fifo_reset16,
	reset_status16
	);


// FIFO parameters16
parameter fifo_width16 = `UART_FIFO_WIDTH16;
parameter fifo_depth16 = `UART_FIFO_DEPTH16;
parameter fifo_pointer_w16 = `UART_FIFO_POINTER_W16;
parameter fifo_counter_w16 = `UART_FIFO_COUNTER_W16;

input				clk16;
input				wb_rst_i16;
input				push16;
input				pop16;
input	[fifo_width16-1:0]	data_in16;
input				fifo_reset16;
input       reset_status16;

output	[fifo_width16-1:0]	data_out16;
output				overrun16;
output	[fifo_counter_w16-1:0]	count;
output				error_bit16;

wire	[fifo_width16-1:0]	data_out16;
wire [7:0] data8_out16;
// flags16 FIFO
reg	[2:0]	fifo[fifo_depth16-1:0];

// FIFO pointers16
reg	[fifo_pointer_w16-1:0]	top;
reg	[fifo_pointer_w16-1:0]	bottom16;

reg	[fifo_counter_w16-1:0]	count;
reg				overrun16;

wire [fifo_pointer_w16-1:0] top_plus_116 = top + 1'b1;

raminfr16 #(fifo_pointer_w16,8,fifo_depth16) rfifo16  
        (.clk16(clk16), 
			.we16(push16), 
			.a(top), 
			.dpra16(bottom16), 
			.di16(data_in16[fifo_width16-1:fifo_width16-8]), 
			.dpo16(data8_out16)
		); 

always @(posedge clk16 or posedge wb_rst_i16) // synchronous16 FIFO
begin
	if (wb_rst_i16)
	begin
		top		<= #1 0;
		bottom16		<= #1 1'b0;
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
	if (fifo_reset16) begin
		top		<= #1 0;
		bottom16		<= #1 1'b0;
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
		case ({push16, pop16})
		2'b10 : if (count<fifo_depth16)  // overrun16 condition
			begin
				top       <= #1 top_plus_116;
				fifo[top] <= #1 data_in16[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom16] <= #1 0;
				bottom16   <= #1 bottom16 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom16   <= #1 bottom16 + 1'b1;
				top       <= #1 top_plus_116;
				fifo[top] <= #1 data_in16[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk16 or posedge wb_rst_i16) // synchronous16 FIFO
begin
  if (wb_rst_i16)
    overrun16   <= #1 1'b0;
  else
  if(fifo_reset16 | reset_status16) 
    overrun16   <= #1 1'b0;
  else
  if(push16 & ~pop16 & (count==fifo_depth16))
    overrun16   <= #1 1'b1;
end   // always


// please16 note16 though16 that data_out16 is only valid one clock16 after pop16 signal16
assign data_out16 = {data8_out16,fifo[bottom16]};

// Additional16 logic for detection16 of error conditions16 (parity16 and framing16) inside the FIFO
// for the Line16 Status Register bit 7

wire	[2:0]	word016 = fifo[0];
wire	[2:0]	word116 = fifo[1];
wire	[2:0]	word216 = fifo[2];
wire	[2:0]	word316 = fifo[3];
wire	[2:0]	word416 = fifo[4];
wire	[2:0]	word516 = fifo[5];
wire	[2:0]	word616 = fifo[6];
wire	[2:0]	word716 = fifo[7];

wire	[2:0]	word816 = fifo[8];
wire	[2:0]	word916 = fifo[9];
wire	[2:0]	word1016 = fifo[10];
wire	[2:0]	word1116 = fifo[11];
wire	[2:0]	word1216 = fifo[12];
wire	[2:0]	word1316 = fifo[13];
wire	[2:0]	word1416 = fifo[14];
wire	[2:0]	word1516 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit16 = |(word016[2:0]  | word116[2:0]  | word216[2:0]  | word316[2:0]  |
            		      word416[2:0]  | word516[2:0]  | word616[2:0]  | word716[2:0]  |
            		      word816[2:0]  | word916[2:0]  | word1016[2:0] | word1116[2:0] |
            		      word1216[2:0] | word1316[2:0] | word1416[2:0] | word1516[2:0] );

endmodule
