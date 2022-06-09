//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo18.v (Modified18 from uart_fifo18.v)                    ////
////                                                              ////
////                                                              ////
////  This18 file is part of the "UART18 16550 compatible18" project18    ////
////  http18://www18.opencores18.org18/cores18/uart1655018/                   ////
////                                                              ////
////  Documentation18 related18 to this project18:                      ////
////  - http18://www18.opencores18.org18/cores18/uart1655018/                 ////
////                                                              ////
////  Projects18 compatibility18:                                     ////
////  - WISHBONE18                                                  ////
////  RS23218 Protocol18                                              ////
////  16550D uart18 (mostly18 supported)                              ////
////                                                              ////
////  Overview18 (main18 Features18):                                   ////
////  UART18 core18 receiver18 FIFO                                     ////
////                                                              ////
////  To18 Do18:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author18(s):                                                  ////
////      - gorban18@opencores18.org18                                  ////
////      - Jacob18 Gorban18                                          ////
////      - Igor18 Mohor18 (igorm18@opencores18.org18)                      ////
////                                                              ////
////  Created18:        2001/05/12                                  ////
////  Last18 Updated18:   2002/07/22                                  ////
////                  (See log18 for the revision18 history18)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2000, 2001 Authors18                             ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS18 Revision18 History18
//
// $Log: not supported by cvs2svn18 $
// Revision18 1.3  2003/06/11 16:37:47  gorban18
// This18 fixes18 errors18 in some18 cases18 when data is being read and put to the FIFO at the same time. Patch18 is submitted18 by Scott18 Furman18. Update is very18 recommended18.
//
// Revision18 1.2  2002/07/29 21:16:18  gorban18
// The uart_defines18.v file is included18 again18 in sources18.
//
// Revision18 1.1  2002/07/22 23:02:23  gorban18
// Bug18 Fixes18:
//  * Possible18 loss of sync and bad18 reception18 of stop bit on slow18 baud18 rates18 fixed18.
//   Problem18 reported18 by Kenny18.Tung18.
//  * Bad (or lack18 of ) loopback18 handling18 fixed18. Reported18 by Cherry18 Withers18.
//
// Improvements18:
//  * Made18 FIFO's as general18 inferrable18 memory where possible18.
//  So18 on FPGA18 they should be inferred18 as RAM18 (Distributed18 RAM18 on Xilinx18).
//  This18 saves18 about18 1/3 of the Slice18 count and reduces18 P&R and synthesis18 times.
//
//  * Added18 optional18 baudrate18 output (baud_o18).
//  This18 is identical18 to BAUDOUT18* signal18 on 16550 chip18.
//  It outputs18 16xbit_clock_rate - the divided18 clock18.
//  It's disabled by default. Define18 UART_HAS_BAUDRATE_OUTPUT18 to use.
//
// Revision18 1.16  2001/12/20 13:25:46  mohor18
// rx18 push18 changed to be only one cycle wide18.
//
// Revision18 1.15  2001/12/18 09:01:07  mohor18
// Bug18 that was entered18 in the last update fixed18 (rx18 state machine18).
//
// Revision18 1.14  2001/12/17 14:46:48  mohor18
// overrun18 signal18 was moved to separate18 block because many18 sequential18 lsr18
// reads were18 preventing18 data from being written18 to rx18 fifo.
// underrun18 signal18 was not used and was removed from the project18.
//
// Revision18 1.13  2001/11/26 21:38:54  gorban18
// Lots18 of fixes18:
// Break18 condition wasn18't handled18 correctly at all.
// LSR18 bits could lose18 their18 values.
// LSR18 value after reset was wrong18.
// Timing18 of THRE18 interrupt18 signal18 corrected18.
// LSR18 bit 0 timing18 corrected18.
//
// Revision18 1.12  2001/11/08 14:54:23  mohor18
// Comments18 in Slovene18 language18 deleted18, few18 small fixes18 for better18 work18 of
// old18 tools18. IRQs18 need to be fix18.
//
// Revision18 1.11  2001/11/07 17:51:52  gorban18
// Heavily18 rewritten18 interrupt18 and LSR18 subsystems18.
// Many18 bugs18 hopefully18 squashed18.
//
// Revision18 1.10  2001/10/20 09:58:40  gorban18
// Small18 synopsis18 fixes18
//
// Revision18 1.9  2001/08/24 21:01:12  mohor18
// Things18 connected18 to parity18 changed.
// Clock18 devider18 changed.
//
// Revision18 1.8  2001/08/24 08:48:10  mohor18
// FIFO was not cleared18 after the data was read bug18 fixed18.
//
// Revision18 1.7  2001/08/23 16:05:05  mohor18
// Stop bit bug18 fixed18.
// Parity18 bug18 fixed18.
// WISHBONE18 read cycle bug18 fixed18,
// OE18 indicator18 (Overrun18 Error) bug18 fixed18.
// PE18 indicator18 (Parity18 Error) bug18 fixed18.
// Register read bug18 fixed18.
//
// Revision18 1.3  2001/05/31 20:08:01  gorban18
// FIFO changes18 and other corrections18.
//
// Revision18 1.3  2001/05/27 17:37:48  gorban18
// Fixed18 many18 bugs18. Updated18 spec18. Changed18 FIFO files structure18. See CHANGES18.txt18 file.
//
// Revision18 1.2  2001/05/17 18:34:18  gorban18
// First18 'stable' release. Should18 be sythesizable18 now. Also18 added new header.
//
// Revision18 1.0  2001-05-17 21:27:12+02  jacob18
// Initial18 revision18
//
//

// synopsys18 translate_off18
`include "timescale.v"
// synopsys18 translate_on18

`include "uart_defines18.v"

module uart_rfifo18 (clk18, 
	wb_rst_i18, data_in18, data_out18,
// Control18 signals18
	push18, // push18 strobe18, active high18
	pop18,   // pop18 strobe18, active high18
// status signals18
	overrun18,
	count,
	error_bit18,
	fifo_reset18,
	reset_status18
	);


// FIFO parameters18
parameter fifo_width18 = `UART_FIFO_WIDTH18;
parameter fifo_depth18 = `UART_FIFO_DEPTH18;
parameter fifo_pointer_w18 = `UART_FIFO_POINTER_W18;
parameter fifo_counter_w18 = `UART_FIFO_COUNTER_W18;

input				clk18;
input				wb_rst_i18;
input				push18;
input				pop18;
input	[fifo_width18-1:0]	data_in18;
input				fifo_reset18;
input       reset_status18;

output	[fifo_width18-1:0]	data_out18;
output				overrun18;
output	[fifo_counter_w18-1:0]	count;
output				error_bit18;

wire	[fifo_width18-1:0]	data_out18;
wire [7:0] data8_out18;
// flags18 FIFO
reg	[2:0]	fifo[fifo_depth18-1:0];

// FIFO pointers18
reg	[fifo_pointer_w18-1:0]	top;
reg	[fifo_pointer_w18-1:0]	bottom18;

reg	[fifo_counter_w18-1:0]	count;
reg				overrun18;

wire [fifo_pointer_w18-1:0] top_plus_118 = top + 1'b1;

raminfr18 #(fifo_pointer_w18,8,fifo_depth18) rfifo18  
        (.clk18(clk18), 
			.we18(push18), 
			.a(top), 
			.dpra18(bottom18), 
			.di18(data_in18[fifo_width18-1:fifo_width18-8]), 
			.dpo18(data8_out18)
		); 

always @(posedge clk18 or posedge wb_rst_i18) // synchronous18 FIFO
begin
	if (wb_rst_i18)
	begin
		top		<= #1 0;
		bottom18		<= #1 1'b0;
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
	if (fifo_reset18) begin
		top		<= #1 0;
		bottom18		<= #1 1'b0;
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
		case ({push18, pop18})
		2'b10 : if (count<fifo_depth18)  // overrun18 condition
			begin
				top       <= #1 top_plus_118;
				fifo[top] <= #1 data_in18[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom18] <= #1 0;
				bottom18   <= #1 bottom18 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom18   <= #1 bottom18 + 1'b1;
				top       <= #1 top_plus_118;
				fifo[top] <= #1 data_in18[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk18 or posedge wb_rst_i18) // synchronous18 FIFO
begin
  if (wb_rst_i18)
    overrun18   <= #1 1'b0;
  else
  if(fifo_reset18 | reset_status18) 
    overrun18   <= #1 1'b0;
  else
  if(push18 & ~pop18 & (count==fifo_depth18))
    overrun18   <= #1 1'b1;
end   // always


// please18 note18 though18 that data_out18 is only valid one clock18 after pop18 signal18
assign data_out18 = {data8_out18,fifo[bottom18]};

// Additional18 logic for detection18 of error conditions18 (parity18 and framing18) inside the FIFO
// for the Line18 Status Register bit 7

wire	[2:0]	word018 = fifo[0];
wire	[2:0]	word118 = fifo[1];
wire	[2:0]	word218 = fifo[2];
wire	[2:0]	word318 = fifo[3];
wire	[2:0]	word418 = fifo[4];
wire	[2:0]	word518 = fifo[5];
wire	[2:0]	word618 = fifo[6];
wire	[2:0]	word718 = fifo[7];

wire	[2:0]	word818 = fifo[8];
wire	[2:0]	word918 = fifo[9];
wire	[2:0]	word1018 = fifo[10];
wire	[2:0]	word1118 = fifo[11];
wire	[2:0]	word1218 = fifo[12];
wire	[2:0]	word1318 = fifo[13];
wire	[2:0]	word1418 = fifo[14];
wire	[2:0]	word1518 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit18 = |(word018[2:0]  | word118[2:0]  | word218[2:0]  | word318[2:0]  |
            		      word418[2:0]  | word518[2:0]  | word618[2:0]  | word718[2:0]  |
            		      word818[2:0]  | word918[2:0]  | word1018[2:0] | word1118[2:0] |
            		      word1218[2:0] | word1318[2:0] | word1418[2:0] | word1518[2:0] );

endmodule
