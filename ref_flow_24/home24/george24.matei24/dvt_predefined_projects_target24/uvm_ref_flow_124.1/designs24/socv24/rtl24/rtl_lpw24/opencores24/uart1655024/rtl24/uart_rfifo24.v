//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo24.v (Modified24 from uart_fifo24.v)                    ////
////                                                              ////
////                                                              ////
////  This24 file is part of the "UART24 16550 compatible24" project24    ////
////  http24://www24.opencores24.org24/cores24/uart1655024/                   ////
////                                                              ////
////  Documentation24 related24 to this project24:                      ////
////  - http24://www24.opencores24.org24/cores24/uart1655024/                 ////
////                                                              ////
////  Projects24 compatibility24:                                     ////
////  - WISHBONE24                                                  ////
////  RS23224 Protocol24                                              ////
////  16550D uart24 (mostly24 supported)                              ////
////                                                              ////
////  Overview24 (main24 Features24):                                   ////
////  UART24 core24 receiver24 FIFO                                     ////
////                                                              ////
////  To24 Do24:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author24(s):                                                  ////
////      - gorban24@opencores24.org24                                  ////
////      - Jacob24 Gorban24                                          ////
////      - Igor24 Mohor24 (igorm24@opencores24.org24)                      ////
////                                                              ////
////  Created24:        2001/05/12                                  ////
////  Last24 Updated24:   2002/07/22                                  ////
////                  (See log24 for the revision24 history24)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright24 (C) 2000, 2001 Authors24                             ////
////                                                              ////
//// This24 source24 file may be used and distributed24 without         ////
//// restriction24 provided that this copyright24 statement24 is not    ////
//// removed from the file and that any derivative24 work24 contains24  ////
//// the original copyright24 notice24 and the associated disclaimer24. ////
////                                                              ////
//// This24 source24 file is free software24; you can redistribute24 it   ////
//// and/or modify it under the terms24 of the GNU24 Lesser24 General24   ////
//// Public24 License24 as published24 by the Free24 Software24 Foundation24; ////
//// either24 version24 2.1 of the License24, or (at your24 option) any   ////
//// later24 version24.                                               ////
////                                                              ////
//// This24 source24 is distributed24 in the hope24 that it will be       ////
//// useful24, but WITHOUT24 ANY24 WARRANTY24; without even24 the implied24   ////
//// warranty24 of MERCHANTABILITY24 or FITNESS24 FOR24 A PARTICULAR24      ////
//// PURPOSE24.  See the GNU24 Lesser24 General24 Public24 License24 for more ////
//// details24.                                                     ////
////                                                              ////
//// You should have received24 a copy of the GNU24 Lesser24 General24    ////
//// Public24 License24 along24 with this source24; if not, download24 it   ////
//// from http24://www24.opencores24.org24/lgpl24.shtml24                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS24 Revision24 History24
//
// $Log: not supported by cvs2svn24 $
// Revision24 1.3  2003/06/11 16:37:47  gorban24
// This24 fixes24 errors24 in some24 cases24 when data is being read and put to the FIFO at the same time. Patch24 is submitted24 by Scott24 Furman24. Update is very24 recommended24.
//
// Revision24 1.2  2002/07/29 21:16:18  gorban24
// The uart_defines24.v file is included24 again24 in sources24.
//
// Revision24 1.1  2002/07/22 23:02:23  gorban24
// Bug24 Fixes24:
//  * Possible24 loss of sync and bad24 reception24 of stop bit on slow24 baud24 rates24 fixed24.
//   Problem24 reported24 by Kenny24.Tung24.
//  * Bad (or lack24 of ) loopback24 handling24 fixed24. Reported24 by Cherry24 Withers24.
//
// Improvements24:
//  * Made24 FIFO's as general24 inferrable24 memory where possible24.
//  So24 on FPGA24 they should be inferred24 as RAM24 (Distributed24 RAM24 on Xilinx24).
//  This24 saves24 about24 1/3 of the Slice24 count and reduces24 P&R and synthesis24 times.
//
//  * Added24 optional24 baudrate24 output (baud_o24).
//  This24 is identical24 to BAUDOUT24* signal24 on 16550 chip24.
//  It outputs24 16xbit_clock_rate - the divided24 clock24.
//  It's disabled by default. Define24 UART_HAS_BAUDRATE_OUTPUT24 to use.
//
// Revision24 1.16  2001/12/20 13:25:46  mohor24
// rx24 push24 changed to be only one cycle wide24.
//
// Revision24 1.15  2001/12/18 09:01:07  mohor24
// Bug24 that was entered24 in the last update fixed24 (rx24 state machine24).
//
// Revision24 1.14  2001/12/17 14:46:48  mohor24
// overrun24 signal24 was moved to separate24 block because many24 sequential24 lsr24
// reads were24 preventing24 data from being written24 to rx24 fifo.
// underrun24 signal24 was not used and was removed from the project24.
//
// Revision24 1.13  2001/11/26 21:38:54  gorban24
// Lots24 of fixes24:
// Break24 condition wasn24't handled24 correctly at all.
// LSR24 bits could lose24 their24 values.
// LSR24 value after reset was wrong24.
// Timing24 of THRE24 interrupt24 signal24 corrected24.
// LSR24 bit 0 timing24 corrected24.
//
// Revision24 1.12  2001/11/08 14:54:23  mohor24
// Comments24 in Slovene24 language24 deleted24, few24 small fixes24 for better24 work24 of
// old24 tools24. IRQs24 need to be fix24.
//
// Revision24 1.11  2001/11/07 17:51:52  gorban24
// Heavily24 rewritten24 interrupt24 and LSR24 subsystems24.
// Many24 bugs24 hopefully24 squashed24.
//
// Revision24 1.10  2001/10/20 09:58:40  gorban24
// Small24 synopsis24 fixes24
//
// Revision24 1.9  2001/08/24 21:01:12  mohor24
// Things24 connected24 to parity24 changed.
// Clock24 devider24 changed.
//
// Revision24 1.8  2001/08/24 08:48:10  mohor24
// FIFO was not cleared24 after the data was read bug24 fixed24.
//
// Revision24 1.7  2001/08/23 16:05:05  mohor24
// Stop bit bug24 fixed24.
// Parity24 bug24 fixed24.
// WISHBONE24 read cycle bug24 fixed24,
// OE24 indicator24 (Overrun24 Error) bug24 fixed24.
// PE24 indicator24 (Parity24 Error) bug24 fixed24.
// Register read bug24 fixed24.
//
// Revision24 1.3  2001/05/31 20:08:01  gorban24
// FIFO changes24 and other corrections24.
//
// Revision24 1.3  2001/05/27 17:37:48  gorban24
// Fixed24 many24 bugs24. Updated24 spec24. Changed24 FIFO files structure24. See CHANGES24.txt24 file.
//
// Revision24 1.2  2001/05/17 18:34:18  gorban24
// First24 'stable' release. Should24 be sythesizable24 now. Also24 added new header.
//
// Revision24 1.0  2001-05-17 21:27:12+02  jacob24
// Initial24 revision24
//
//

// synopsys24 translate_off24
`include "timescale.v"
// synopsys24 translate_on24

`include "uart_defines24.v"

module uart_rfifo24 (clk24, 
	wb_rst_i24, data_in24, data_out24,
// Control24 signals24
	push24, // push24 strobe24, active high24
	pop24,   // pop24 strobe24, active high24
// status signals24
	overrun24,
	count,
	error_bit24,
	fifo_reset24,
	reset_status24
	);


// FIFO parameters24
parameter fifo_width24 = `UART_FIFO_WIDTH24;
parameter fifo_depth24 = `UART_FIFO_DEPTH24;
parameter fifo_pointer_w24 = `UART_FIFO_POINTER_W24;
parameter fifo_counter_w24 = `UART_FIFO_COUNTER_W24;

input				clk24;
input				wb_rst_i24;
input				push24;
input				pop24;
input	[fifo_width24-1:0]	data_in24;
input				fifo_reset24;
input       reset_status24;

output	[fifo_width24-1:0]	data_out24;
output				overrun24;
output	[fifo_counter_w24-1:0]	count;
output				error_bit24;

wire	[fifo_width24-1:0]	data_out24;
wire [7:0] data8_out24;
// flags24 FIFO
reg	[2:0]	fifo[fifo_depth24-1:0];

// FIFO pointers24
reg	[fifo_pointer_w24-1:0]	top;
reg	[fifo_pointer_w24-1:0]	bottom24;

reg	[fifo_counter_w24-1:0]	count;
reg				overrun24;

wire [fifo_pointer_w24-1:0] top_plus_124 = top + 1'b1;

raminfr24 #(fifo_pointer_w24,8,fifo_depth24) rfifo24  
        (.clk24(clk24), 
			.we24(push24), 
			.a(top), 
			.dpra24(bottom24), 
			.di24(data_in24[fifo_width24-1:fifo_width24-8]), 
			.dpo24(data8_out24)
		); 

always @(posedge clk24 or posedge wb_rst_i24) // synchronous24 FIFO
begin
	if (wb_rst_i24)
	begin
		top		<= #1 0;
		bottom24		<= #1 1'b0;
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
	if (fifo_reset24) begin
		top		<= #1 0;
		bottom24		<= #1 1'b0;
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
		case ({push24, pop24})
		2'b10 : if (count<fifo_depth24)  // overrun24 condition
			begin
				top       <= #1 top_plus_124;
				fifo[top] <= #1 data_in24[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom24] <= #1 0;
				bottom24   <= #1 bottom24 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom24   <= #1 bottom24 + 1'b1;
				top       <= #1 top_plus_124;
				fifo[top] <= #1 data_in24[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk24 or posedge wb_rst_i24) // synchronous24 FIFO
begin
  if (wb_rst_i24)
    overrun24   <= #1 1'b0;
  else
  if(fifo_reset24 | reset_status24) 
    overrun24   <= #1 1'b0;
  else
  if(push24 & ~pop24 & (count==fifo_depth24))
    overrun24   <= #1 1'b1;
end   // always


// please24 note24 though24 that data_out24 is only valid one clock24 after pop24 signal24
assign data_out24 = {data8_out24,fifo[bottom24]};

// Additional24 logic for detection24 of error conditions24 (parity24 and framing24) inside the FIFO
// for the Line24 Status Register bit 7

wire	[2:0]	word024 = fifo[0];
wire	[2:0]	word124 = fifo[1];
wire	[2:0]	word224 = fifo[2];
wire	[2:0]	word324 = fifo[3];
wire	[2:0]	word424 = fifo[4];
wire	[2:0]	word524 = fifo[5];
wire	[2:0]	word624 = fifo[6];
wire	[2:0]	word724 = fifo[7];

wire	[2:0]	word824 = fifo[8];
wire	[2:0]	word924 = fifo[9];
wire	[2:0]	word1024 = fifo[10];
wire	[2:0]	word1124 = fifo[11];
wire	[2:0]	word1224 = fifo[12];
wire	[2:0]	word1324 = fifo[13];
wire	[2:0]	word1424 = fifo[14];
wire	[2:0]	word1524 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit24 = |(word024[2:0]  | word124[2:0]  | word224[2:0]  | word324[2:0]  |
            		      word424[2:0]  | word524[2:0]  | word624[2:0]  | word724[2:0]  |
            		      word824[2:0]  | word924[2:0]  | word1024[2:0] | word1124[2:0] |
            		      word1224[2:0] | word1324[2:0] | word1424[2:0] | word1524[2:0] );

endmodule
