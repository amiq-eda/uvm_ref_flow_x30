//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo11.v (Modified11 from uart_fifo11.v)                    ////
////                                                              ////
////                                                              ////
////  This11 file is part of the "UART11 16550 compatible11" project11    ////
////  http11://www11.opencores11.org11/cores11/uart1655011/                   ////
////                                                              ////
////  Documentation11 related11 to this project11:                      ////
////  - http11://www11.opencores11.org11/cores11/uart1655011/                 ////
////                                                              ////
////  Projects11 compatibility11:                                     ////
////  - WISHBONE11                                                  ////
////  RS23211 Protocol11                                              ////
////  16550D uart11 (mostly11 supported)                              ////
////                                                              ////
////  Overview11 (main11 Features11):                                   ////
////  UART11 core11 receiver11 FIFO                                     ////
////                                                              ////
////  To11 Do11:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author11(s):                                                  ////
////      - gorban11@opencores11.org11                                  ////
////      - Jacob11 Gorban11                                          ////
////      - Igor11 Mohor11 (igorm11@opencores11.org11)                      ////
////                                                              ////
////  Created11:        2001/05/12                                  ////
////  Last11 Updated11:   2002/07/22                                  ////
////                  (See log11 for the revision11 history11)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2000, 2001 Authors11                             ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS11 Revision11 History11
//
// $Log: not supported by cvs2svn11 $
// Revision11 1.3  2003/06/11 16:37:47  gorban11
// This11 fixes11 errors11 in some11 cases11 when data is being read and put to the FIFO at the same time. Patch11 is submitted11 by Scott11 Furman11. Update is very11 recommended11.
//
// Revision11 1.2  2002/07/29 21:16:18  gorban11
// The uart_defines11.v file is included11 again11 in sources11.
//
// Revision11 1.1  2002/07/22 23:02:23  gorban11
// Bug11 Fixes11:
//  * Possible11 loss of sync and bad11 reception11 of stop bit on slow11 baud11 rates11 fixed11.
//   Problem11 reported11 by Kenny11.Tung11.
//  * Bad (or lack11 of ) loopback11 handling11 fixed11. Reported11 by Cherry11 Withers11.
//
// Improvements11:
//  * Made11 FIFO's as general11 inferrable11 memory where possible11.
//  So11 on FPGA11 they should be inferred11 as RAM11 (Distributed11 RAM11 on Xilinx11).
//  This11 saves11 about11 1/3 of the Slice11 count and reduces11 P&R and synthesis11 times.
//
//  * Added11 optional11 baudrate11 output (baud_o11).
//  This11 is identical11 to BAUDOUT11* signal11 on 16550 chip11.
//  It outputs11 16xbit_clock_rate - the divided11 clock11.
//  It's disabled by default. Define11 UART_HAS_BAUDRATE_OUTPUT11 to use.
//
// Revision11 1.16  2001/12/20 13:25:46  mohor11
// rx11 push11 changed to be only one cycle wide11.
//
// Revision11 1.15  2001/12/18 09:01:07  mohor11
// Bug11 that was entered11 in the last update fixed11 (rx11 state machine11).
//
// Revision11 1.14  2001/12/17 14:46:48  mohor11
// overrun11 signal11 was moved to separate11 block because many11 sequential11 lsr11
// reads were11 preventing11 data from being written11 to rx11 fifo.
// underrun11 signal11 was not used and was removed from the project11.
//
// Revision11 1.13  2001/11/26 21:38:54  gorban11
// Lots11 of fixes11:
// Break11 condition wasn11't handled11 correctly at all.
// LSR11 bits could lose11 their11 values.
// LSR11 value after reset was wrong11.
// Timing11 of THRE11 interrupt11 signal11 corrected11.
// LSR11 bit 0 timing11 corrected11.
//
// Revision11 1.12  2001/11/08 14:54:23  mohor11
// Comments11 in Slovene11 language11 deleted11, few11 small fixes11 for better11 work11 of
// old11 tools11. IRQs11 need to be fix11.
//
// Revision11 1.11  2001/11/07 17:51:52  gorban11
// Heavily11 rewritten11 interrupt11 and LSR11 subsystems11.
// Many11 bugs11 hopefully11 squashed11.
//
// Revision11 1.10  2001/10/20 09:58:40  gorban11
// Small11 synopsis11 fixes11
//
// Revision11 1.9  2001/08/24 21:01:12  mohor11
// Things11 connected11 to parity11 changed.
// Clock11 devider11 changed.
//
// Revision11 1.8  2001/08/24 08:48:10  mohor11
// FIFO was not cleared11 after the data was read bug11 fixed11.
//
// Revision11 1.7  2001/08/23 16:05:05  mohor11
// Stop bit bug11 fixed11.
// Parity11 bug11 fixed11.
// WISHBONE11 read cycle bug11 fixed11,
// OE11 indicator11 (Overrun11 Error) bug11 fixed11.
// PE11 indicator11 (Parity11 Error) bug11 fixed11.
// Register read bug11 fixed11.
//
// Revision11 1.3  2001/05/31 20:08:01  gorban11
// FIFO changes11 and other corrections11.
//
// Revision11 1.3  2001/05/27 17:37:48  gorban11
// Fixed11 many11 bugs11. Updated11 spec11. Changed11 FIFO files structure11. See CHANGES11.txt11 file.
//
// Revision11 1.2  2001/05/17 18:34:18  gorban11
// First11 'stable' release. Should11 be sythesizable11 now. Also11 added new header.
//
// Revision11 1.0  2001-05-17 21:27:12+02  jacob11
// Initial11 revision11
//
//

// synopsys11 translate_off11
`include "timescale.v"
// synopsys11 translate_on11

`include "uart_defines11.v"

module uart_rfifo11 (clk11, 
	wb_rst_i11, data_in11, data_out11,
// Control11 signals11
	push11, // push11 strobe11, active high11
	pop11,   // pop11 strobe11, active high11
// status signals11
	overrun11,
	count,
	error_bit11,
	fifo_reset11,
	reset_status11
	);


// FIFO parameters11
parameter fifo_width11 = `UART_FIFO_WIDTH11;
parameter fifo_depth11 = `UART_FIFO_DEPTH11;
parameter fifo_pointer_w11 = `UART_FIFO_POINTER_W11;
parameter fifo_counter_w11 = `UART_FIFO_COUNTER_W11;

input				clk11;
input				wb_rst_i11;
input				push11;
input				pop11;
input	[fifo_width11-1:0]	data_in11;
input				fifo_reset11;
input       reset_status11;

output	[fifo_width11-1:0]	data_out11;
output				overrun11;
output	[fifo_counter_w11-1:0]	count;
output				error_bit11;

wire	[fifo_width11-1:0]	data_out11;
wire [7:0] data8_out11;
// flags11 FIFO
reg	[2:0]	fifo[fifo_depth11-1:0];

// FIFO pointers11
reg	[fifo_pointer_w11-1:0]	top;
reg	[fifo_pointer_w11-1:0]	bottom11;

reg	[fifo_counter_w11-1:0]	count;
reg				overrun11;

wire [fifo_pointer_w11-1:0] top_plus_111 = top + 1'b1;

raminfr11 #(fifo_pointer_w11,8,fifo_depth11) rfifo11  
        (.clk11(clk11), 
			.we11(push11), 
			.a(top), 
			.dpra11(bottom11), 
			.di11(data_in11[fifo_width11-1:fifo_width11-8]), 
			.dpo11(data8_out11)
		); 

always @(posedge clk11 or posedge wb_rst_i11) // synchronous11 FIFO
begin
	if (wb_rst_i11)
	begin
		top		<= #1 0;
		bottom11		<= #1 1'b0;
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
	if (fifo_reset11) begin
		top		<= #1 0;
		bottom11		<= #1 1'b0;
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
		case ({push11, pop11})
		2'b10 : if (count<fifo_depth11)  // overrun11 condition
			begin
				top       <= #1 top_plus_111;
				fifo[top] <= #1 data_in11[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom11] <= #1 0;
				bottom11   <= #1 bottom11 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom11   <= #1 bottom11 + 1'b1;
				top       <= #1 top_plus_111;
				fifo[top] <= #1 data_in11[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk11 or posedge wb_rst_i11) // synchronous11 FIFO
begin
  if (wb_rst_i11)
    overrun11   <= #1 1'b0;
  else
  if(fifo_reset11 | reset_status11) 
    overrun11   <= #1 1'b0;
  else
  if(push11 & ~pop11 & (count==fifo_depth11))
    overrun11   <= #1 1'b1;
end   // always


// please11 note11 though11 that data_out11 is only valid one clock11 after pop11 signal11
assign data_out11 = {data8_out11,fifo[bottom11]};

// Additional11 logic for detection11 of error conditions11 (parity11 and framing11) inside the FIFO
// for the Line11 Status Register bit 7

wire	[2:0]	word011 = fifo[0];
wire	[2:0]	word111 = fifo[1];
wire	[2:0]	word211 = fifo[2];
wire	[2:0]	word311 = fifo[3];
wire	[2:0]	word411 = fifo[4];
wire	[2:0]	word511 = fifo[5];
wire	[2:0]	word611 = fifo[6];
wire	[2:0]	word711 = fifo[7];

wire	[2:0]	word811 = fifo[8];
wire	[2:0]	word911 = fifo[9];
wire	[2:0]	word1011 = fifo[10];
wire	[2:0]	word1111 = fifo[11];
wire	[2:0]	word1211 = fifo[12];
wire	[2:0]	word1311 = fifo[13];
wire	[2:0]	word1411 = fifo[14];
wire	[2:0]	word1511 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit11 = |(word011[2:0]  | word111[2:0]  | word211[2:0]  | word311[2:0]  |
            		      word411[2:0]  | word511[2:0]  | word611[2:0]  | word711[2:0]  |
            		      word811[2:0]  | word911[2:0]  | word1011[2:0] | word1111[2:0] |
            		      word1211[2:0] | word1311[2:0] | word1411[2:0] | word1511[2:0] );

endmodule
