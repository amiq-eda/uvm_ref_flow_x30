//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo6.v (Modified6 from uart_fifo6.v)                    ////
////                                                              ////
////                                                              ////
////  This6 file is part of the "UART6 16550 compatible6" project6    ////
////  http6://www6.opencores6.org6/cores6/uart165506/                   ////
////                                                              ////
////  Documentation6 related6 to this project6:                      ////
////  - http6://www6.opencores6.org6/cores6/uart165506/                 ////
////                                                              ////
////  Projects6 compatibility6:                                     ////
////  - WISHBONE6                                                  ////
////  RS2326 Protocol6                                              ////
////  16550D uart6 (mostly6 supported)                              ////
////                                                              ////
////  Overview6 (main6 Features6):                                   ////
////  UART6 core6 receiver6 FIFO                                     ////
////                                                              ////
////  To6 Do6:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author6(s):                                                  ////
////      - gorban6@opencores6.org6                                  ////
////      - Jacob6 Gorban6                                          ////
////      - Igor6 Mohor6 (igorm6@opencores6.org6)                      ////
////                                                              ////
////  Created6:        2001/05/12                                  ////
////  Last6 Updated6:   2002/07/22                                  ////
////                  (See log6 for the revision6 history6)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2000, 2001 Authors6                             ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS6 Revision6 History6
//
// $Log: not supported by cvs2svn6 $
// Revision6 1.3  2003/06/11 16:37:47  gorban6
// This6 fixes6 errors6 in some6 cases6 when data is being read and put to the FIFO at the same time. Patch6 is submitted6 by Scott6 Furman6. Update is very6 recommended6.
//
// Revision6 1.2  2002/07/29 21:16:18  gorban6
// The uart_defines6.v file is included6 again6 in sources6.
//
// Revision6 1.1  2002/07/22 23:02:23  gorban6
// Bug6 Fixes6:
//  * Possible6 loss of sync and bad6 reception6 of stop bit on slow6 baud6 rates6 fixed6.
//   Problem6 reported6 by Kenny6.Tung6.
//  * Bad (or lack6 of ) loopback6 handling6 fixed6. Reported6 by Cherry6 Withers6.
//
// Improvements6:
//  * Made6 FIFO's as general6 inferrable6 memory where possible6.
//  So6 on FPGA6 they should be inferred6 as RAM6 (Distributed6 RAM6 on Xilinx6).
//  This6 saves6 about6 1/3 of the Slice6 count and reduces6 P&R and synthesis6 times.
//
//  * Added6 optional6 baudrate6 output (baud_o6).
//  This6 is identical6 to BAUDOUT6* signal6 on 16550 chip6.
//  It outputs6 16xbit_clock_rate - the divided6 clock6.
//  It's disabled by default. Define6 UART_HAS_BAUDRATE_OUTPUT6 to use.
//
// Revision6 1.16  2001/12/20 13:25:46  mohor6
// rx6 push6 changed to be only one cycle wide6.
//
// Revision6 1.15  2001/12/18 09:01:07  mohor6
// Bug6 that was entered6 in the last update fixed6 (rx6 state machine6).
//
// Revision6 1.14  2001/12/17 14:46:48  mohor6
// overrun6 signal6 was moved to separate6 block because many6 sequential6 lsr6
// reads were6 preventing6 data from being written6 to rx6 fifo.
// underrun6 signal6 was not used and was removed from the project6.
//
// Revision6 1.13  2001/11/26 21:38:54  gorban6
// Lots6 of fixes6:
// Break6 condition wasn6't handled6 correctly at all.
// LSR6 bits could lose6 their6 values.
// LSR6 value after reset was wrong6.
// Timing6 of THRE6 interrupt6 signal6 corrected6.
// LSR6 bit 0 timing6 corrected6.
//
// Revision6 1.12  2001/11/08 14:54:23  mohor6
// Comments6 in Slovene6 language6 deleted6, few6 small fixes6 for better6 work6 of
// old6 tools6. IRQs6 need to be fix6.
//
// Revision6 1.11  2001/11/07 17:51:52  gorban6
// Heavily6 rewritten6 interrupt6 and LSR6 subsystems6.
// Many6 bugs6 hopefully6 squashed6.
//
// Revision6 1.10  2001/10/20 09:58:40  gorban6
// Small6 synopsis6 fixes6
//
// Revision6 1.9  2001/08/24 21:01:12  mohor6
// Things6 connected6 to parity6 changed.
// Clock6 devider6 changed.
//
// Revision6 1.8  2001/08/24 08:48:10  mohor6
// FIFO was not cleared6 after the data was read bug6 fixed6.
//
// Revision6 1.7  2001/08/23 16:05:05  mohor6
// Stop bit bug6 fixed6.
// Parity6 bug6 fixed6.
// WISHBONE6 read cycle bug6 fixed6,
// OE6 indicator6 (Overrun6 Error) bug6 fixed6.
// PE6 indicator6 (Parity6 Error) bug6 fixed6.
// Register read bug6 fixed6.
//
// Revision6 1.3  2001/05/31 20:08:01  gorban6
// FIFO changes6 and other corrections6.
//
// Revision6 1.3  2001/05/27 17:37:48  gorban6
// Fixed6 many6 bugs6. Updated6 spec6. Changed6 FIFO files structure6. See CHANGES6.txt6 file.
//
// Revision6 1.2  2001/05/17 18:34:18  gorban6
// First6 'stable' release. Should6 be sythesizable6 now. Also6 added new header.
//
// Revision6 1.0  2001-05-17 21:27:12+02  jacob6
// Initial6 revision6
//
//

// synopsys6 translate_off6
`include "timescale.v"
// synopsys6 translate_on6

`include "uart_defines6.v"

module uart_rfifo6 (clk6, 
	wb_rst_i6, data_in6, data_out6,
// Control6 signals6
	push6, // push6 strobe6, active high6
	pop6,   // pop6 strobe6, active high6
// status signals6
	overrun6,
	count,
	error_bit6,
	fifo_reset6,
	reset_status6
	);


// FIFO parameters6
parameter fifo_width6 = `UART_FIFO_WIDTH6;
parameter fifo_depth6 = `UART_FIFO_DEPTH6;
parameter fifo_pointer_w6 = `UART_FIFO_POINTER_W6;
parameter fifo_counter_w6 = `UART_FIFO_COUNTER_W6;

input				clk6;
input				wb_rst_i6;
input				push6;
input				pop6;
input	[fifo_width6-1:0]	data_in6;
input				fifo_reset6;
input       reset_status6;

output	[fifo_width6-1:0]	data_out6;
output				overrun6;
output	[fifo_counter_w6-1:0]	count;
output				error_bit6;

wire	[fifo_width6-1:0]	data_out6;
wire [7:0] data8_out6;
// flags6 FIFO
reg	[2:0]	fifo[fifo_depth6-1:0];

// FIFO pointers6
reg	[fifo_pointer_w6-1:0]	top;
reg	[fifo_pointer_w6-1:0]	bottom6;

reg	[fifo_counter_w6-1:0]	count;
reg				overrun6;

wire [fifo_pointer_w6-1:0] top_plus_16 = top + 1'b1;

raminfr6 #(fifo_pointer_w6,8,fifo_depth6) rfifo6  
        (.clk6(clk6), 
			.we6(push6), 
			.a(top), 
			.dpra6(bottom6), 
			.di6(data_in6[fifo_width6-1:fifo_width6-8]), 
			.dpo6(data8_out6)
		); 

always @(posedge clk6 or posedge wb_rst_i6) // synchronous6 FIFO
begin
	if (wb_rst_i6)
	begin
		top		<= #1 0;
		bottom6		<= #1 1'b0;
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
	if (fifo_reset6) begin
		top		<= #1 0;
		bottom6		<= #1 1'b0;
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
		case ({push6, pop6})
		2'b10 : if (count<fifo_depth6)  // overrun6 condition
			begin
				top       <= #1 top_plus_16;
				fifo[top] <= #1 data_in6[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom6] <= #1 0;
				bottom6   <= #1 bottom6 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom6   <= #1 bottom6 + 1'b1;
				top       <= #1 top_plus_16;
				fifo[top] <= #1 data_in6[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk6 or posedge wb_rst_i6) // synchronous6 FIFO
begin
  if (wb_rst_i6)
    overrun6   <= #1 1'b0;
  else
  if(fifo_reset6 | reset_status6) 
    overrun6   <= #1 1'b0;
  else
  if(push6 & ~pop6 & (count==fifo_depth6))
    overrun6   <= #1 1'b1;
end   // always


// please6 note6 though6 that data_out6 is only valid one clock6 after pop6 signal6
assign data_out6 = {data8_out6,fifo[bottom6]};

// Additional6 logic for detection6 of error conditions6 (parity6 and framing6) inside the FIFO
// for the Line6 Status Register bit 7

wire	[2:0]	word06 = fifo[0];
wire	[2:0]	word16 = fifo[1];
wire	[2:0]	word26 = fifo[2];
wire	[2:0]	word36 = fifo[3];
wire	[2:0]	word46 = fifo[4];
wire	[2:0]	word56 = fifo[5];
wire	[2:0]	word66 = fifo[6];
wire	[2:0]	word76 = fifo[7];

wire	[2:0]	word86 = fifo[8];
wire	[2:0]	word96 = fifo[9];
wire	[2:0]	word106 = fifo[10];
wire	[2:0]	word116 = fifo[11];
wire	[2:0]	word126 = fifo[12];
wire	[2:0]	word136 = fifo[13];
wire	[2:0]	word146 = fifo[14];
wire	[2:0]	word156 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit6 = |(word06[2:0]  | word16[2:0]  | word26[2:0]  | word36[2:0]  |
            		      word46[2:0]  | word56[2:0]  | word66[2:0]  | word76[2:0]  |
            		      word86[2:0]  | word96[2:0]  | word106[2:0] | word116[2:0] |
            		      word126[2:0] | word136[2:0] | word146[2:0] | word156[2:0] );

endmodule
