//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo29.v (Modified29 from uart_fifo29.v)                    ////
////                                                              ////
////                                                              ////
////  This29 file is part of the "UART29 16550 compatible29" project29    ////
////  http29://www29.opencores29.org29/cores29/uart1655029/                   ////
////                                                              ////
////  Documentation29 related29 to this project29:                      ////
////  - http29://www29.opencores29.org29/cores29/uart1655029/                 ////
////                                                              ////
////  Projects29 compatibility29:                                     ////
////  - WISHBONE29                                                  ////
////  RS23229 Protocol29                                              ////
////  16550D uart29 (mostly29 supported)                              ////
////                                                              ////
////  Overview29 (main29 Features29):                                   ////
////  UART29 core29 receiver29 FIFO                                     ////
////                                                              ////
////  To29 Do29:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author29(s):                                                  ////
////      - gorban29@opencores29.org29                                  ////
////      - Jacob29 Gorban29                                          ////
////      - Igor29 Mohor29 (igorm29@opencores29.org29)                      ////
////                                                              ////
////  Created29:        2001/05/12                                  ////
////  Last29 Updated29:   2002/07/22                                  ////
////                  (See log29 for the revision29 history29)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2000, 2001 Authors29                             ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS29 Revision29 History29
//
// $Log: not supported by cvs2svn29 $
// Revision29 1.3  2003/06/11 16:37:47  gorban29
// This29 fixes29 errors29 in some29 cases29 when data is being read and put to the FIFO at the same time. Patch29 is submitted29 by Scott29 Furman29. Update is very29 recommended29.
//
// Revision29 1.2  2002/07/29 21:16:18  gorban29
// The uart_defines29.v file is included29 again29 in sources29.
//
// Revision29 1.1  2002/07/22 23:02:23  gorban29
// Bug29 Fixes29:
//  * Possible29 loss of sync and bad29 reception29 of stop bit on slow29 baud29 rates29 fixed29.
//   Problem29 reported29 by Kenny29.Tung29.
//  * Bad (or lack29 of ) loopback29 handling29 fixed29. Reported29 by Cherry29 Withers29.
//
// Improvements29:
//  * Made29 FIFO's as general29 inferrable29 memory where possible29.
//  So29 on FPGA29 they should be inferred29 as RAM29 (Distributed29 RAM29 on Xilinx29).
//  This29 saves29 about29 1/3 of the Slice29 count and reduces29 P&R and synthesis29 times.
//
//  * Added29 optional29 baudrate29 output (baud_o29).
//  This29 is identical29 to BAUDOUT29* signal29 on 16550 chip29.
//  It outputs29 16xbit_clock_rate - the divided29 clock29.
//  It's disabled by default. Define29 UART_HAS_BAUDRATE_OUTPUT29 to use.
//
// Revision29 1.16  2001/12/20 13:25:46  mohor29
// rx29 push29 changed to be only one cycle wide29.
//
// Revision29 1.15  2001/12/18 09:01:07  mohor29
// Bug29 that was entered29 in the last update fixed29 (rx29 state machine29).
//
// Revision29 1.14  2001/12/17 14:46:48  mohor29
// overrun29 signal29 was moved to separate29 block because many29 sequential29 lsr29
// reads were29 preventing29 data from being written29 to rx29 fifo.
// underrun29 signal29 was not used and was removed from the project29.
//
// Revision29 1.13  2001/11/26 21:38:54  gorban29
// Lots29 of fixes29:
// Break29 condition wasn29't handled29 correctly at all.
// LSR29 bits could lose29 their29 values.
// LSR29 value after reset was wrong29.
// Timing29 of THRE29 interrupt29 signal29 corrected29.
// LSR29 bit 0 timing29 corrected29.
//
// Revision29 1.12  2001/11/08 14:54:23  mohor29
// Comments29 in Slovene29 language29 deleted29, few29 small fixes29 for better29 work29 of
// old29 tools29. IRQs29 need to be fix29.
//
// Revision29 1.11  2001/11/07 17:51:52  gorban29
// Heavily29 rewritten29 interrupt29 and LSR29 subsystems29.
// Many29 bugs29 hopefully29 squashed29.
//
// Revision29 1.10  2001/10/20 09:58:40  gorban29
// Small29 synopsis29 fixes29
//
// Revision29 1.9  2001/08/24 21:01:12  mohor29
// Things29 connected29 to parity29 changed.
// Clock29 devider29 changed.
//
// Revision29 1.8  2001/08/24 08:48:10  mohor29
// FIFO was not cleared29 after the data was read bug29 fixed29.
//
// Revision29 1.7  2001/08/23 16:05:05  mohor29
// Stop bit bug29 fixed29.
// Parity29 bug29 fixed29.
// WISHBONE29 read cycle bug29 fixed29,
// OE29 indicator29 (Overrun29 Error) bug29 fixed29.
// PE29 indicator29 (Parity29 Error) bug29 fixed29.
// Register read bug29 fixed29.
//
// Revision29 1.3  2001/05/31 20:08:01  gorban29
// FIFO changes29 and other corrections29.
//
// Revision29 1.3  2001/05/27 17:37:48  gorban29
// Fixed29 many29 bugs29. Updated29 spec29. Changed29 FIFO files structure29. See CHANGES29.txt29 file.
//
// Revision29 1.2  2001/05/17 18:34:18  gorban29
// First29 'stable' release. Should29 be sythesizable29 now. Also29 added new header.
//
// Revision29 1.0  2001-05-17 21:27:12+02  jacob29
// Initial29 revision29
//
//

// synopsys29 translate_off29
`include "timescale.v"
// synopsys29 translate_on29

`include "uart_defines29.v"

module uart_rfifo29 (clk29, 
	wb_rst_i29, data_in29, data_out29,
// Control29 signals29
	push29, // push29 strobe29, active high29
	pop29,   // pop29 strobe29, active high29
// status signals29
	overrun29,
	count,
	error_bit29,
	fifo_reset29,
	reset_status29
	);


// FIFO parameters29
parameter fifo_width29 = `UART_FIFO_WIDTH29;
parameter fifo_depth29 = `UART_FIFO_DEPTH29;
parameter fifo_pointer_w29 = `UART_FIFO_POINTER_W29;
parameter fifo_counter_w29 = `UART_FIFO_COUNTER_W29;

input				clk29;
input				wb_rst_i29;
input				push29;
input				pop29;
input	[fifo_width29-1:0]	data_in29;
input				fifo_reset29;
input       reset_status29;

output	[fifo_width29-1:0]	data_out29;
output				overrun29;
output	[fifo_counter_w29-1:0]	count;
output				error_bit29;

wire	[fifo_width29-1:0]	data_out29;
wire [7:0] data8_out29;
// flags29 FIFO
reg	[2:0]	fifo[fifo_depth29-1:0];

// FIFO pointers29
reg	[fifo_pointer_w29-1:0]	top;
reg	[fifo_pointer_w29-1:0]	bottom29;

reg	[fifo_counter_w29-1:0]	count;
reg				overrun29;

wire [fifo_pointer_w29-1:0] top_plus_129 = top + 1'b1;

raminfr29 #(fifo_pointer_w29,8,fifo_depth29) rfifo29  
        (.clk29(clk29), 
			.we29(push29), 
			.a(top), 
			.dpra29(bottom29), 
			.di29(data_in29[fifo_width29-1:fifo_width29-8]), 
			.dpo29(data8_out29)
		); 

always @(posedge clk29 or posedge wb_rst_i29) // synchronous29 FIFO
begin
	if (wb_rst_i29)
	begin
		top		<= #1 0;
		bottom29		<= #1 1'b0;
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
	if (fifo_reset29) begin
		top		<= #1 0;
		bottom29		<= #1 1'b0;
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
		case ({push29, pop29})
		2'b10 : if (count<fifo_depth29)  // overrun29 condition
			begin
				top       <= #1 top_plus_129;
				fifo[top] <= #1 data_in29[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom29] <= #1 0;
				bottom29   <= #1 bottom29 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom29   <= #1 bottom29 + 1'b1;
				top       <= #1 top_plus_129;
				fifo[top] <= #1 data_in29[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk29 or posedge wb_rst_i29) // synchronous29 FIFO
begin
  if (wb_rst_i29)
    overrun29   <= #1 1'b0;
  else
  if(fifo_reset29 | reset_status29) 
    overrun29   <= #1 1'b0;
  else
  if(push29 & ~pop29 & (count==fifo_depth29))
    overrun29   <= #1 1'b1;
end   // always


// please29 note29 though29 that data_out29 is only valid one clock29 after pop29 signal29
assign data_out29 = {data8_out29,fifo[bottom29]};

// Additional29 logic for detection29 of error conditions29 (parity29 and framing29) inside the FIFO
// for the Line29 Status Register bit 7

wire	[2:0]	word029 = fifo[0];
wire	[2:0]	word129 = fifo[1];
wire	[2:0]	word229 = fifo[2];
wire	[2:0]	word329 = fifo[3];
wire	[2:0]	word429 = fifo[4];
wire	[2:0]	word529 = fifo[5];
wire	[2:0]	word629 = fifo[6];
wire	[2:0]	word729 = fifo[7];

wire	[2:0]	word829 = fifo[8];
wire	[2:0]	word929 = fifo[9];
wire	[2:0]	word1029 = fifo[10];
wire	[2:0]	word1129 = fifo[11];
wire	[2:0]	word1229 = fifo[12];
wire	[2:0]	word1329 = fifo[13];
wire	[2:0]	word1429 = fifo[14];
wire	[2:0]	word1529 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit29 = |(word029[2:0]  | word129[2:0]  | word229[2:0]  | word329[2:0]  |
            		      word429[2:0]  | word529[2:0]  | word629[2:0]  | word729[2:0]  |
            		      word829[2:0]  | word929[2:0]  | word1029[2:0] | word1129[2:0] |
            		      word1229[2:0] | word1329[2:0] | word1429[2:0] | word1529[2:0] );

endmodule
