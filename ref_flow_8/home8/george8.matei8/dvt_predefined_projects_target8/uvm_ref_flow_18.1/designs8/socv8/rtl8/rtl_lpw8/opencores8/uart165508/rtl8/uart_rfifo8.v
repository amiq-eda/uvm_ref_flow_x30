//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo8.v (Modified8 from uart_fifo8.v)                    ////
////                                                              ////
////                                                              ////
////  This8 file is part of the "UART8 16550 compatible8" project8    ////
////  http8://www8.opencores8.org8/cores8/uart165508/                   ////
////                                                              ////
////  Documentation8 related8 to this project8:                      ////
////  - http8://www8.opencores8.org8/cores8/uart165508/                 ////
////                                                              ////
////  Projects8 compatibility8:                                     ////
////  - WISHBONE8                                                  ////
////  RS2328 Protocol8                                              ////
////  16550D uart8 (mostly8 supported)                              ////
////                                                              ////
////  Overview8 (main8 Features8):                                   ////
////  UART8 core8 receiver8 FIFO                                     ////
////                                                              ////
////  To8 Do8:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author8(s):                                                  ////
////      - gorban8@opencores8.org8                                  ////
////      - Jacob8 Gorban8                                          ////
////      - Igor8 Mohor8 (igorm8@opencores8.org8)                      ////
////                                                              ////
////  Created8:        2001/05/12                                  ////
////  Last8 Updated8:   2002/07/22                                  ////
////                  (See log8 for the revision8 history8)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2000, 2001 Authors8                             ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS8 Revision8 History8
//
// $Log: not supported by cvs2svn8 $
// Revision8 1.3  2003/06/11 16:37:47  gorban8
// This8 fixes8 errors8 in some8 cases8 when data is being read and put to the FIFO at the same time. Patch8 is submitted8 by Scott8 Furman8. Update is very8 recommended8.
//
// Revision8 1.2  2002/07/29 21:16:18  gorban8
// The uart_defines8.v file is included8 again8 in sources8.
//
// Revision8 1.1  2002/07/22 23:02:23  gorban8
// Bug8 Fixes8:
//  * Possible8 loss of sync and bad8 reception8 of stop bit on slow8 baud8 rates8 fixed8.
//   Problem8 reported8 by Kenny8.Tung8.
//  * Bad (or lack8 of ) loopback8 handling8 fixed8. Reported8 by Cherry8 Withers8.
//
// Improvements8:
//  * Made8 FIFO's as general8 inferrable8 memory where possible8.
//  So8 on FPGA8 they should be inferred8 as RAM8 (Distributed8 RAM8 on Xilinx8).
//  This8 saves8 about8 1/3 of the Slice8 count and reduces8 P&R and synthesis8 times.
//
//  * Added8 optional8 baudrate8 output (baud_o8).
//  This8 is identical8 to BAUDOUT8* signal8 on 16550 chip8.
//  It outputs8 16xbit_clock_rate - the divided8 clock8.
//  It's disabled by default. Define8 UART_HAS_BAUDRATE_OUTPUT8 to use.
//
// Revision8 1.16  2001/12/20 13:25:46  mohor8
// rx8 push8 changed to be only one cycle wide8.
//
// Revision8 1.15  2001/12/18 09:01:07  mohor8
// Bug8 that was entered8 in the last update fixed8 (rx8 state machine8).
//
// Revision8 1.14  2001/12/17 14:46:48  mohor8
// overrun8 signal8 was moved to separate8 block because many8 sequential8 lsr8
// reads were8 preventing8 data from being written8 to rx8 fifo.
// underrun8 signal8 was not used and was removed from the project8.
//
// Revision8 1.13  2001/11/26 21:38:54  gorban8
// Lots8 of fixes8:
// Break8 condition wasn8't handled8 correctly at all.
// LSR8 bits could lose8 their8 values.
// LSR8 value after reset was wrong8.
// Timing8 of THRE8 interrupt8 signal8 corrected8.
// LSR8 bit 0 timing8 corrected8.
//
// Revision8 1.12  2001/11/08 14:54:23  mohor8
// Comments8 in Slovene8 language8 deleted8, few8 small fixes8 for better8 work8 of
// old8 tools8. IRQs8 need to be fix8.
//
// Revision8 1.11  2001/11/07 17:51:52  gorban8
// Heavily8 rewritten8 interrupt8 and LSR8 subsystems8.
// Many8 bugs8 hopefully8 squashed8.
//
// Revision8 1.10  2001/10/20 09:58:40  gorban8
// Small8 synopsis8 fixes8
//
// Revision8 1.9  2001/08/24 21:01:12  mohor8
// Things8 connected8 to parity8 changed.
// Clock8 devider8 changed.
//
// Revision8 1.8  2001/08/24 08:48:10  mohor8
// FIFO was not cleared8 after the data was read bug8 fixed8.
//
// Revision8 1.7  2001/08/23 16:05:05  mohor8
// Stop bit bug8 fixed8.
// Parity8 bug8 fixed8.
// WISHBONE8 read cycle bug8 fixed8,
// OE8 indicator8 (Overrun8 Error) bug8 fixed8.
// PE8 indicator8 (Parity8 Error) bug8 fixed8.
// Register read bug8 fixed8.
//
// Revision8 1.3  2001/05/31 20:08:01  gorban8
// FIFO changes8 and other corrections8.
//
// Revision8 1.3  2001/05/27 17:37:48  gorban8
// Fixed8 many8 bugs8. Updated8 spec8. Changed8 FIFO files structure8. See CHANGES8.txt8 file.
//
// Revision8 1.2  2001/05/17 18:34:18  gorban8
// First8 'stable' release. Should8 be sythesizable8 now. Also8 added new header.
//
// Revision8 1.0  2001-05-17 21:27:12+02  jacob8
// Initial8 revision8
//
//

// synopsys8 translate_off8
`include "timescale.v"
// synopsys8 translate_on8

`include "uart_defines8.v"

module uart_rfifo8 (clk8, 
	wb_rst_i8, data_in8, data_out8,
// Control8 signals8
	push8, // push8 strobe8, active high8
	pop8,   // pop8 strobe8, active high8
// status signals8
	overrun8,
	count,
	error_bit8,
	fifo_reset8,
	reset_status8
	);


// FIFO parameters8
parameter fifo_width8 = `UART_FIFO_WIDTH8;
parameter fifo_depth8 = `UART_FIFO_DEPTH8;
parameter fifo_pointer_w8 = `UART_FIFO_POINTER_W8;
parameter fifo_counter_w8 = `UART_FIFO_COUNTER_W8;

input				clk8;
input				wb_rst_i8;
input				push8;
input				pop8;
input	[fifo_width8-1:0]	data_in8;
input				fifo_reset8;
input       reset_status8;

output	[fifo_width8-1:0]	data_out8;
output				overrun8;
output	[fifo_counter_w8-1:0]	count;
output				error_bit8;

wire	[fifo_width8-1:0]	data_out8;
wire [7:0] data8_out8;
// flags8 FIFO
reg	[2:0]	fifo[fifo_depth8-1:0];

// FIFO pointers8
reg	[fifo_pointer_w8-1:0]	top;
reg	[fifo_pointer_w8-1:0]	bottom8;

reg	[fifo_counter_w8-1:0]	count;
reg				overrun8;

wire [fifo_pointer_w8-1:0] top_plus_18 = top + 1'b1;

raminfr8 #(fifo_pointer_w8,8,fifo_depth8) rfifo8  
        (.clk8(clk8), 
			.we8(push8), 
			.a(top), 
			.dpra8(bottom8), 
			.di8(data_in8[fifo_width8-1:fifo_width8-8]), 
			.dpo8(data8_out8)
		); 

always @(posedge clk8 or posedge wb_rst_i8) // synchronous8 FIFO
begin
	if (wb_rst_i8)
	begin
		top		<= #1 0;
		bottom8		<= #1 1'b0;
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
	if (fifo_reset8) begin
		top		<= #1 0;
		bottom8		<= #1 1'b0;
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
		case ({push8, pop8})
		2'b10 : if (count<fifo_depth8)  // overrun8 condition
			begin
				top       <= #1 top_plus_18;
				fifo[top] <= #1 data_in8[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom8] <= #1 0;
				bottom8   <= #1 bottom8 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom8   <= #1 bottom8 + 1'b1;
				top       <= #1 top_plus_18;
				fifo[top] <= #1 data_in8[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk8 or posedge wb_rst_i8) // synchronous8 FIFO
begin
  if (wb_rst_i8)
    overrun8   <= #1 1'b0;
  else
  if(fifo_reset8 | reset_status8) 
    overrun8   <= #1 1'b0;
  else
  if(push8 & ~pop8 & (count==fifo_depth8))
    overrun8   <= #1 1'b1;
end   // always


// please8 note8 though8 that data_out8 is only valid one clock8 after pop8 signal8
assign data_out8 = {data8_out8,fifo[bottom8]};

// Additional8 logic for detection8 of error conditions8 (parity8 and framing8) inside the FIFO
// for the Line8 Status Register bit 7

wire	[2:0]	word08 = fifo[0];
wire	[2:0]	word18 = fifo[1];
wire	[2:0]	word28 = fifo[2];
wire	[2:0]	word38 = fifo[3];
wire	[2:0]	word48 = fifo[4];
wire	[2:0]	word58 = fifo[5];
wire	[2:0]	word68 = fifo[6];
wire	[2:0]	word78 = fifo[7];

wire	[2:0]	word88 = fifo[8];
wire	[2:0]	word98 = fifo[9];
wire	[2:0]	word108 = fifo[10];
wire	[2:0]	word118 = fifo[11];
wire	[2:0]	word128 = fifo[12];
wire	[2:0]	word138 = fifo[13];
wire	[2:0]	word148 = fifo[14];
wire	[2:0]	word158 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit8 = |(word08[2:0]  | word18[2:0]  | word28[2:0]  | word38[2:0]  |
            		      word48[2:0]  | word58[2:0]  | word68[2:0]  | word78[2:0]  |
            		      word88[2:0]  | word98[2:0]  | word108[2:0] | word118[2:0] |
            		      word128[2:0] | word138[2:0] | word148[2:0] | word158[2:0] );

endmodule
