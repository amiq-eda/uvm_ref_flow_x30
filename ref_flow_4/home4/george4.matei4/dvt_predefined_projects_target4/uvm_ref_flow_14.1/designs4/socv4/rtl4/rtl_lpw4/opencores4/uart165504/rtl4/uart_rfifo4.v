//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo4.v (Modified4 from uart_fifo4.v)                    ////
////                                                              ////
////                                                              ////
////  This4 file is part of the "UART4 16550 compatible4" project4    ////
////  http4://www4.opencores4.org4/cores4/uart165504/                   ////
////                                                              ////
////  Documentation4 related4 to this project4:                      ////
////  - http4://www4.opencores4.org4/cores4/uart165504/                 ////
////                                                              ////
////  Projects4 compatibility4:                                     ////
////  - WISHBONE4                                                  ////
////  RS2324 Protocol4                                              ////
////  16550D uart4 (mostly4 supported)                              ////
////                                                              ////
////  Overview4 (main4 Features4):                                   ////
////  UART4 core4 receiver4 FIFO                                     ////
////                                                              ////
////  To4 Do4:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author4(s):                                                  ////
////      - gorban4@opencores4.org4                                  ////
////      - Jacob4 Gorban4                                          ////
////      - Igor4 Mohor4 (igorm4@opencores4.org4)                      ////
////                                                              ////
////  Created4:        2001/05/12                                  ////
////  Last4 Updated4:   2002/07/22                                  ////
////                  (See log4 for the revision4 history4)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2000, 2001 Authors4                             ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS4 Revision4 History4
//
// $Log: not supported by cvs2svn4 $
// Revision4 1.3  2003/06/11 16:37:47  gorban4
// This4 fixes4 errors4 in some4 cases4 when data is being read and put to the FIFO at the same time. Patch4 is submitted4 by Scott4 Furman4. Update is very4 recommended4.
//
// Revision4 1.2  2002/07/29 21:16:18  gorban4
// The uart_defines4.v file is included4 again4 in sources4.
//
// Revision4 1.1  2002/07/22 23:02:23  gorban4
// Bug4 Fixes4:
//  * Possible4 loss of sync and bad4 reception4 of stop bit on slow4 baud4 rates4 fixed4.
//   Problem4 reported4 by Kenny4.Tung4.
//  * Bad (or lack4 of ) loopback4 handling4 fixed4. Reported4 by Cherry4 Withers4.
//
// Improvements4:
//  * Made4 FIFO's as general4 inferrable4 memory where possible4.
//  So4 on FPGA4 they should be inferred4 as RAM4 (Distributed4 RAM4 on Xilinx4).
//  This4 saves4 about4 1/3 of the Slice4 count and reduces4 P&R and synthesis4 times.
//
//  * Added4 optional4 baudrate4 output (baud_o4).
//  This4 is identical4 to BAUDOUT4* signal4 on 16550 chip4.
//  It outputs4 16xbit_clock_rate - the divided4 clock4.
//  It's disabled by default. Define4 UART_HAS_BAUDRATE_OUTPUT4 to use.
//
// Revision4 1.16  2001/12/20 13:25:46  mohor4
// rx4 push4 changed to be only one cycle wide4.
//
// Revision4 1.15  2001/12/18 09:01:07  mohor4
// Bug4 that was entered4 in the last update fixed4 (rx4 state machine4).
//
// Revision4 1.14  2001/12/17 14:46:48  mohor4
// overrun4 signal4 was moved to separate4 block because many4 sequential4 lsr4
// reads were4 preventing4 data from being written4 to rx4 fifo.
// underrun4 signal4 was not used and was removed from the project4.
//
// Revision4 1.13  2001/11/26 21:38:54  gorban4
// Lots4 of fixes4:
// Break4 condition wasn4't handled4 correctly at all.
// LSR4 bits could lose4 their4 values.
// LSR4 value after reset was wrong4.
// Timing4 of THRE4 interrupt4 signal4 corrected4.
// LSR4 bit 0 timing4 corrected4.
//
// Revision4 1.12  2001/11/08 14:54:23  mohor4
// Comments4 in Slovene4 language4 deleted4, few4 small fixes4 for better4 work4 of
// old4 tools4. IRQs4 need to be fix4.
//
// Revision4 1.11  2001/11/07 17:51:52  gorban4
// Heavily4 rewritten4 interrupt4 and LSR4 subsystems4.
// Many4 bugs4 hopefully4 squashed4.
//
// Revision4 1.10  2001/10/20 09:58:40  gorban4
// Small4 synopsis4 fixes4
//
// Revision4 1.9  2001/08/24 21:01:12  mohor4
// Things4 connected4 to parity4 changed.
// Clock4 devider4 changed.
//
// Revision4 1.8  2001/08/24 08:48:10  mohor4
// FIFO was not cleared4 after the data was read bug4 fixed4.
//
// Revision4 1.7  2001/08/23 16:05:05  mohor4
// Stop bit bug4 fixed4.
// Parity4 bug4 fixed4.
// WISHBONE4 read cycle bug4 fixed4,
// OE4 indicator4 (Overrun4 Error) bug4 fixed4.
// PE4 indicator4 (Parity4 Error) bug4 fixed4.
// Register read bug4 fixed4.
//
// Revision4 1.3  2001/05/31 20:08:01  gorban4
// FIFO changes4 and other corrections4.
//
// Revision4 1.3  2001/05/27 17:37:48  gorban4
// Fixed4 many4 bugs4. Updated4 spec4. Changed4 FIFO files structure4. See CHANGES4.txt4 file.
//
// Revision4 1.2  2001/05/17 18:34:18  gorban4
// First4 'stable' release. Should4 be sythesizable4 now. Also4 added new header.
//
// Revision4 1.0  2001-05-17 21:27:12+02  jacob4
// Initial4 revision4
//
//

// synopsys4 translate_off4
`include "timescale.v"
// synopsys4 translate_on4

`include "uart_defines4.v"

module uart_rfifo4 (clk4, 
	wb_rst_i4, data_in4, data_out4,
// Control4 signals4
	push4, // push4 strobe4, active high4
	pop4,   // pop4 strobe4, active high4
// status signals4
	overrun4,
	count,
	error_bit4,
	fifo_reset4,
	reset_status4
	);


// FIFO parameters4
parameter fifo_width4 = `UART_FIFO_WIDTH4;
parameter fifo_depth4 = `UART_FIFO_DEPTH4;
parameter fifo_pointer_w4 = `UART_FIFO_POINTER_W4;
parameter fifo_counter_w4 = `UART_FIFO_COUNTER_W4;

input				clk4;
input				wb_rst_i4;
input				push4;
input				pop4;
input	[fifo_width4-1:0]	data_in4;
input				fifo_reset4;
input       reset_status4;

output	[fifo_width4-1:0]	data_out4;
output				overrun4;
output	[fifo_counter_w4-1:0]	count;
output				error_bit4;

wire	[fifo_width4-1:0]	data_out4;
wire [7:0] data8_out4;
// flags4 FIFO
reg	[2:0]	fifo[fifo_depth4-1:0];

// FIFO pointers4
reg	[fifo_pointer_w4-1:0]	top;
reg	[fifo_pointer_w4-1:0]	bottom4;

reg	[fifo_counter_w4-1:0]	count;
reg				overrun4;

wire [fifo_pointer_w4-1:0] top_plus_14 = top + 1'b1;

raminfr4 #(fifo_pointer_w4,8,fifo_depth4) rfifo4  
        (.clk4(clk4), 
			.we4(push4), 
			.a(top), 
			.dpra4(bottom4), 
			.di4(data_in4[fifo_width4-1:fifo_width4-8]), 
			.dpo4(data8_out4)
		); 

always @(posedge clk4 or posedge wb_rst_i4) // synchronous4 FIFO
begin
	if (wb_rst_i4)
	begin
		top		<= #1 0;
		bottom4		<= #1 1'b0;
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
	if (fifo_reset4) begin
		top		<= #1 0;
		bottom4		<= #1 1'b0;
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
		case ({push4, pop4})
		2'b10 : if (count<fifo_depth4)  // overrun4 condition
			begin
				top       <= #1 top_plus_14;
				fifo[top] <= #1 data_in4[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom4] <= #1 0;
				bottom4   <= #1 bottom4 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom4   <= #1 bottom4 + 1'b1;
				top       <= #1 top_plus_14;
				fifo[top] <= #1 data_in4[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk4 or posedge wb_rst_i4) // synchronous4 FIFO
begin
  if (wb_rst_i4)
    overrun4   <= #1 1'b0;
  else
  if(fifo_reset4 | reset_status4) 
    overrun4   <= #1 1'b0;
  else
  if(push4 & ~pop4 & (count==fifo_depth4))
    overrun4   <= #1 1'b1;
end   // always


// please4 note4 though4 that data_out4 is only valid one clock4 after pop4 signal4
assign data_out4 = {data8_out4,fifo[bottom4]};

// Additional4 logic for detection4 of error conditions4 (parity4 and framing4) inside the FIFO
// for the Line4 Status Register bit 7

wire	[2:0]	word04 = fifo[0];
wire	[2:0]	word14 = fifo[1];
wire	[2:0]	word24 = fifo[2];
wire	[2:0]	word34 = fifo[3];
wire	[2:0]	word44 = fifo[4];
wire	[2:0]	word54 = fifo[5];
wire	[2:0]	word64 = fifo[6];
wire	[2:0]	word74 = fifo[7];

wire	[2:0]	word84 = fifo[8];
wire	[2:0]	word94 = fifo[9];
wire	[2:0]	word104 = fifo[10];
wire	[2:0]	word114 = fifo[11];
wire	[2:0]	word124 = fifo[12];
wire	[2:0]	word134 = fifo[13];
wire	[2:0]	word144 = fifo[14];
wire	[2:0]	word154 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit4 = |(word04[2:0]  | word14[2:0]  | word24[2:0]  | word34[2:0]  |
            		      word44[2:0]  | word54[2:0]  | word64[2:0]  | word74[2:0]  |
            		      word84[2:0]  | word94[2:0]  | word104[2:0] | word114[2:0] |
            		      word124[2:0] | word134[2:0] | word144[2:0] | word154[2:0] );

endmodule
