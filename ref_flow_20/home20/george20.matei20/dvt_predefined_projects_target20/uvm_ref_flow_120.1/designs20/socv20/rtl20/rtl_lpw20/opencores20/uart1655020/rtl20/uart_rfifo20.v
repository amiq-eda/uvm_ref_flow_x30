//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo20.v (Modified20 from uart_fifo20.v)                    ////
////                                                              ////
////                                                              ////
////  This20 file is part of the "UART20 16550 compatible20" project20    ////
////  http20://www20.opencores20.org20/cores20/uart1655020/                   ////
////                                                              ////
////  Documentation20 related20 to this project20:                      ////
////  - http20://www20.opencores20.org20/cores20/uart1655020/                 ////
////                                                              ////
////  Projects20 compatibility20:                                     ////
////  - WISHBONE20                                                  ////
////  RS23220 Protocol20                                              ////
////  16550D uart20 (mostly20 supported)                              ////
////                                                              ////
////  Overview20 (main20 Features20):                                   ////
////  UART20 core20 receiver20 FIFO                                     ////
////                                                              ////
////  To20 Do20:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author20(s):                                                  ////
////      - gorban20@opencores20.org20                                  ////
////      - Jacob20 Gorban20                                          ////
////      - Igor20 Mohor20 (igorm20@opencores20.org20)                      ////
////                                                              ////
////  Created20:        2001/05/12                                  ////
////  Last20 Updated20:   2002/07/22                                  ////
////                  (See log20 for the revision20 history20)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2000, 2001 Authors20                             ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS20 Revision20 History20
//
// $Log: not supported by cvs2svn20 $
// Revision20 1.3  2003/06/11 16:37:47  gorban20
// This20 fixes20 errors20 in some20 cases20 when data is being read and put to the FIFO at the same time. Patch20 is submitted20 by Scott20 Furman20. Update is very20 recommended20.
//
// Revision20 1.2  2002/07/29 21:16:18  gorban20
// The uart_defines20.v file is included20 again20 in sources20.
//
// Revision20 1.1  2002/07/22 23:02:23  gorban20
// Bug20 Fixes20:
//  * Possible20 loss of sync and bad20 reception20 of stop bit on slow20 baud20 rates20 fixed20.
//   Problem20 reported20 by Kenny20.Tung20.
//  * Bad (or lack20 of ) loopback20 handling20 fixed20. Reported20 by Cherry20 Withers20.
//
// Improvements20:
//  * Made20 FIFO's as general20 inferrable20 memory where possible20.
//  So20 on FPGA20 they should be inferred20 as RAM20 (Distributed20 RAM20 on Xilinx20).
//  This20 saves20 about20 1/3 of the Slice20 count and reduces20 P&R and synthesis20 times.
//
//  * Added20 optional20 baudrate20 output (baud_o20).
//  This20 is identical20 to BAUDOUT20* signal20 on 16550 chip20.
//  It outputs20 16xbit_clock_rate - the divided20 clock20.
//  It's disabled by default. Define20 UART_HAS_BAUDRATE_OUTPUT20 to use.
//
// Revision20 1.16  2001/12/20 13:25:46  mohor20
// rx20 push20 changed to be only one cycle wide20.
//
// Revision20 1.15  2001/12/18 09:01:07  mohor20
// Bug20 that was entered20 in the last update fixed20 (rx20 state machine20).
//
// Revision20 1.14  2001/12/17 14:46:48  mohor20
// overrun20 signal20 was moved to separate20 block because many20 sequential20 lsr20
// reads were20 preventing20 data from being written20 to rx20 fifo.
// underrun20 signal20 was not used and was removed from the project20.
//
// Revision20 1.13  2001/11/26 21:38:54  gorban20
// Lots20 of fixes20:
// Break20 condition wasn20't handled20 correctly at all.
// LSR20 bits could lose20 their20 values.
// LSR20 value after reset was wrong20.
// Timing20 of THRE20 interrupt20 signal20 corrected20.
// LSR20 bit 0 timing20 corrected20.
//
// Revision20 1.12  2001/11/08 14:54:23  mohor20
// Comments20 in Slovene20 language20 deleted20, few20 small fixes20 for better20 work20 of
// old20 tools20. IRQs20 need to be fix20.
//
// Revision20 1.11  2001/11/07 17:51:52  gorban20
// Heavily20 rewritten20 interrupt20 and LSR20 subsystems20.
// Many20 bugs20 hopefully20 squashed20.
//
// Revision20 1.10  2001/10/20 09:58:40  gorban20
// Small20 synopsis20 fixes20
//
// Revision20 1.9  2001/08/24 21:01:12  mohor20
// Things20 connected20 to parity20 changed.
// Clock20 devider20 changed.
//
// Revision20 1.8  2001/08/24 08:48:10  mohor20
// FIFO was not cleared20 after the data was read bug20 fixed20.
//
// Revision20 1.7  2001/08/23 16:05:05  mohor20
// Stop bit bug20 fixed20.
// Parity20 bug20 fixed20.
// WISHBONE20 read cycle bug20 fixed20,
// OE20 indicator20 (Overrun20 Error) bug20 fixed20.
// PE20 indicator20 (Parity20 Error) bug20 fixed20.
// Register read bug20 fixed20.
//
// Revision20 1.3  2001/05/31 20:08:01  gorban20
// FIFO changes20 and other corrections20.
//
// Revision20 1.3  2001/05/27 17:37:48  gorban20
// Fixed20 many20 bugs20. Updated20 spec20. Changed20 FIFO files structure20. See CHANGES20.txt20 file.
//
// Revision20 1.2  2001/05/17 18:34:18  gorban20
// First20 'stable' release. Should20 be sythesizable20 now. Also20 added new header.
//
// Revision20 1.0  2001-05-17 21:27:12+02  jacob20
// Initial20 revision20
//
//

// synopsys20 translate_off20
`include "timescale.v"
// synopsys20 translate_on20

`include "uart_defines20.v"

module uart_rfifo20 (clk20, 
	wb_rst_i20, data_in20, data_out20,
// Control20 signals20
	push20, // push20 strobe20, active high20
	pop20,   // pop20 strobe20, active high20
// status signals20
	overrun20,
	count,
	error_bit20,
	fifo_reset20,
	reset_status20
	);


// FIFO parameters20
parameter fifo_width20 = `UART_FIFO_WIDTH20;
parameter fifo_depth20 = `UART_FIFO_DEPTH20;
parameter fifo_pointer_w20 = `UART_FIFO_POINTER_W20;
parameter fifo_counter_w20 = `UART_FIFO_COUNTER_W20;

input				clk20;
input				wb_rst_i20;
input				push20;
input				pop20;
input	[fifo_width20-1:0]	data_in20;
input				fifo_reset20;
input       reset_status20;

output	[fifo_width20-1:0]	data_out20;
output				overrun20;
output	[fifo_counter_w20-1:0]	count;
output				error_bit20;

wire	[fifo_width20-1:0]	data_out20;
wire [7:0] data8_out20;
// flags20 FIFO
reg	[2:0]	fifo[fifo_depth20-1:0];

// FIFO pointers20
reg	[fifo_pointer_w20-1:0]	top;
reg	[fifo_pointer_w20-1:0]	bottom20;

reg	[fifo_counter_w20-1:0]	count;
reg				overrun20;

wire [fifo_pointer_w20-1:0] top_plus_120 = top + 1'b1;

raminfr20 #(fifo_pointer_w20,8,fifo_depth20) rfifo20  
        (.clk20(clk20), 
			.we20(push20), 
			.a(top), 
			.dpra20(bottom20), 
			.di20(data_in20[fifo_width20-1:fifo_width20-8]), 
			.dpo20(data8_out20)
		); 

always @(posedge clk20 or posedge wb_rst_i20) // synchronous20 FIFO
begin
	if (wb_rst_i20)
	begin
		top		<= #1 0;
		bottom20		<= #1 1'b0;
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
	if (fifo_reset20) begin
		top		<= #1 0;
		bottom20		<= #1 1'b0;
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
		case ({push20, pop20})
		2'b10 : if (count<fifo_depth20)  // overrun20 condition
			begin
				top       <= #1 top_plus_120;
				fifo[top] <= #1 data_in20[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom20] <= #1 0;
				bottom20   <= #1 bottom20 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom20   <= #1 bottom20 + 1'b1;
				top       <= #1 top_plus_120;
				fifo[top] <= #1 data_in20[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk20 or posedge wb_rst_i20) // synchronous20 FIFO
begin
  if (wb_rst_i20)
    overrun20   <= #1 1'b0;
  else
  if(fifo_reset20 | reset_status20) 
    overrun20   <= #1 1'b0;
  else
  if(push20 & ~pop20 & (count==fifo_depth20))
    overrun20   <= #1 1'b1;
end   // always


// please20 note20 though20 that data_out20 is only valid one clock20 after pop20 signal20
assign data_out20 = {data8_out20,fifo[bottom20]};

// Additional20 logic for detection20 of error conditions20 (parity20 and framing20) inside the FIFO
// for the Line20 Status Register bit 7

wire	[2:0]	word020 = fifo[0];
wire	[2:0]	word120 = fifo[1];
wire	[2:0]	word220 = fifo[2];
wire	[2:0]	word320 = fifo[3];
wire	[2:0]	word420 = fifo[4];
wire	[2:0]	word520 = fifo[5];
wire	[2:0]	word620 = fifo[6];
wire	[2:0]	word720 = fifo[7];

wire	[2:0]	word820 = fifo[8];
wire	[2:0]	word920 = fifo[9];
wire	[2:0]	word1020 = fifo[10];
wire	[2:0]	word1120 = fifo[11];
wire	[2:0]	word1220 = fifo[12];
wire	[2:0]	word1320 = fifo[13];
wire	[2:0]	word1420 = fifo[14];
wire	[2:0]	word1520 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit20 = |(word020[2:0]  | word120[2:0]  | word220[2:0]  | word320[2:0]  |
            		      word420[2:0]  | word520[2:0]  | word620[2:0]  | word720[2:0]  |
            		      word820[2:0]  | word920[2:0]  | word1020[2:0] | word1120[2:0] |
            		      word1220[2:0] | word1320[2:0] | word1420[2:0] | word1520[2:0] );

endmodule
