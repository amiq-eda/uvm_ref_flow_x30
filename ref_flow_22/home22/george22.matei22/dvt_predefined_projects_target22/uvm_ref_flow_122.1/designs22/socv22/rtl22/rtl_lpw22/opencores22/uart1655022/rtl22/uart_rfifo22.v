//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo22.v (Modified22 from uart_fifo22.v)                    ////
////                                                              ////
////                                                              ////
////  This22 file is part of the "UART22 16550 compatible22" project22    ////
////  http22://www22.opencores22.org22/cores22/uart1655022/                   ////
////                                                              ////
////  Documentation22 related22 to this project22:                      ////
////  - http22://www22.opencores22.org22/cores22/uart1655022/                 ////
////                                                              ////
////  Projects22 compatibility22:                                     ////
////  - WISHBONE22                                                  ////
////  RS23222 Protocol22                                              ////
////  16550D uart22 (mostly22 supported)                              ////
////                                                              ////
////  Overview22 (main22 Features22):                                   ////
////  UART22 core22 receiver22 FIFO                                     ////
////                                                              ////
////  To22 Do22:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author22(s):                                                  ////
////      - gorban22@opencores22.org22                                  ////
////      - Jacob22 Gorban22                                          ////
////      - Igor22 Mohor22 (igorm22@opencores22.org22)                      ////
////                                                              ////
////  Created22:        2001/05/12                                  ////
////  Last22 Updated22:   2002/07/22                                  ////
////                  (See log22 for the revision22 history22)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2000, 2001 Authors22                             ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS22 Revision22 History22
//
// $Log: not supported by cvs2svn22 $
// Revision22 1.3  2003/06/11 16:37:47  gorban22
// This22 fixes22 errors22 in some22 cases22 when data is being read and put to the FIFO at the same time. Patch22 is submitted22 by Scott22 Furman22. Update is very22 recommended22.
//
// Revision22 1.2  2002/07/29 21:16:18  gorban22
// The uart_defines22.v file is included22 again22 in sources22.
//
// Revision22 1.1  2002/07/22 23:02:23  gorban22
// Bug22 Fixes22:
//  * Possible22 loss of sync and bad22 reception22 of stop bit on slow22 baud22 rates22 fixed22.
//   Problem22 reported22 by Kenny22.Tung22.
//  * Bad (or lack22 of ) loopback22 handling22 fixed22. Reported22 by Cherry22 Withers22.
//
// Improvements22:
//  * Made22 FIFO's as general22 inferrable22 memory where possible22.
//  So22 on FPGA22 they should be inferred22 as RAM22 (Distributed22 RAM22 on Xilinx22).
//  This22 saves22 about22 1/3 of the Slice22 count and reduces22 P&R and synthesis22 times.
//
//  * Added22 optional22 baudrate22 output (baud_o22).
//  This22 is identical22 to BAUDOUT22* signal22 on 16550 chip22.
//  It outputs22 16xbit_clock_rate - the divided22 clock22.
//  It's disabled by default. Define22 UART_HAS_BAUDRATE_OUTPUT22 to use.
//
// Revision22 1.16  2001/12/20 13:25:46  mohor22
// rx22 push22 changed to be only one cycle wide22.
//
// Revision22 1.15  2001/12/18 09:01:07  mohor22
// Bug22 that was entered22 in the last update fixed22 (rx22 state machine22).
//
// Revision22 1.14  2001/12/17 14:46:48  mohor22
// overrun22 signal22 was moved to separate22 block because many22 sequential22 lsr22
// reads were22 preventing22 data from being written22 to rx22 fifo.
// underrun22 signal22 was not used and was removed from the project22.
//
// Revision22 1.13  2001/11/26 21:38:54  gorban22
// Lots22 of fixes22:
// Break22 condition wasn22't handled22 correctly at all.
// LSR22 bits could lose22 their22 values.
// LSR22 value after reset was wrong22.
// Timing22 of THRE22 interrupt22 signal22 corrected22.
// LSR22 bit 0 timing22 corrected22.
//
// Revision22 1.12  2001/11/08 14:54:23  mohor22
// Comments22 in Slovene22 language22 deleted22, few22 small fixes22 for better22 work22 of
// old22 tools22. IRQs22 need to be fix22.
//
// Revision22 1.11  2001/11/07 17:51:52  gorban22
// Heavily22 rewritten22 interrupt22 and LSR22 subsystems22.
// Many22 bugs22 hopefully22 squashed22.
//
// Revision22 1.10  2001/10/20 09:58:40  gorban22
// Small22 synopsis22 fixes22
//
// Revision22 1.9  2001/08/24 21:01:12  mohor22
// Things22 connected22 to parity22 changed.
// Clock22 devider22 changed.
//
// Revision22 1.8  2001/08/24 08:48:10  mohor22
// FIFO was not cleared22 after the data was read bug22 fixed22.
//
// Revision22 1.7  2001/08/23 16:05:05  mohor22
// Stop bit bug22 fixed22.
// Parity22 bug22 fixed22.
// WISHBONE22 read cycle bug22 fixed22,
// OE22 indicator22 (Overrun22 Error) bug22 fixed22.
// PE22 indicator22 (Parity22 Error) bug22 fixed22.
// Register read bug22 fixed22.
//
// Revision22 1.3  2001/05/31 20:08:01  gorban22
// FIFO changes22 and other corrections22.
//
// Revision22 1.3  2001/05/27 17:37:48  gorban22
// Fixed22 many22 bugs22. Updated22 spec22. Changed22 FIFO files structure22. See CHANGES22.txt22 file.
//
// Revision22 1.2  2001/05/17 18:34:18  gorban22
// First22 'stable' release. Should22 be sythesizable22 now. Also22 added new header.
//
// Revision22 1.0  2001-05-17 21:27:12+02  jacob22
// Initial22 revision22
//
//

// synopsys22 translate_off22
`include "timescale.v"
// synopsys22 translate_on22

`include "uart_defines22.v"

module uart_rfifo22 (clk22, 
	wb_rst_i22, data_in22, data_out22,
// Control22 signals22
	push22, // push22 strobe22, active high22
	pop22,   // pop22 strobe22, active high22
// status signals22
	overrun22,
	count,
	error_bit22,
	fifo_reset22,
	reset_status22
	);


// FIFO parameters22
parameter fifo_width22 = `UART_FIFO_WIDTH22;
parameter fifo_depth22 = `UART_FIFO_DEPTH22;
parameter fifo_pointer_w22 = `UART_FIFO_POINTER_W22;
parameter fifo_counter_w22 = `UART_FIFO_COUNTER_W22;

input				clk22;
input				wb_rst_i22;
input				push22;
input				pop22;
input	[fifo_width22-1:0]	data_in22;
input				fifo_reset22;
input       reset_status22;

output	[fifo_width22-1:0]	data_out22;
output				overrun22;
output	[fifo_counter_w22-1:0]	count;
output				error_bit22;

wire	[fifo_width22-1:0]	data_out22;
wire [7:0] data8_out22;
// flags22 FIFO
reg	[2:0]	fifo[fifo_depth22-1:0];

// FIFO pointers22
reg	[fifo_pointer_w22-1:0]	top;
reg	[fifo_pointer_w22-1:0]	bottom22;

reg	[fifo_counter_w22-1:0]	count;
reg				overrun22;

wire [fifo_pointer_w22-1:0] top_plus_122 = top + 1'b1;

raminfr22 #(fifo_pointer_w22,8,fifo_depth22) rfifo22  
        (.clk22(clk22), 
			.we22(push22), 
			.a(top), 
			.dpra22(bottom22), 
			.di22(data_in22[fifo_width22-1:fifo_width22-8]), 
			.dpo22(data8_out22)
		); 

always @(posedge clk22 or posedge wb_rst_i22) // synchronous22 FIFO
begin
	if (wb_rst_i22)
	begin
		top		<= #1 0;
		bottom22		<= #1 1'b0;
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
	if (fifo_reset22) begin
		top		<= #1 0;
		bottom22		<= #1 1'b0;
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
		case ({push22, pop22})
		2'b10 : if (count<fifo_depth22)  // overrun22 condition
			begin
				top       <= #1 top_plus_122;
				fifo[top] <= #1 data_in22[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom22] <= #1 0;
				bottom22   <= #1 bottom22 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom22   <= #1 bottom22 + 1'b1;
				top       <= #1 top_plus_122;
				fifo[top] <= #1 data_in22[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk22 or posedge wb_rst_i22) // synchronous22 FIFO
begin
  if (wb_rst_i22)
    overrun22   <= #1 1'b0;
  else
  if(fifo_reset22 | reset_status22) 
    overrun22   <= #1 1'b0;
  else
  if(push22 & ~pop22 & (count==fifo_depth22))
    overrun22   <= #1 1'b1;
end   // always


// please22 note22 though22 that data_out22 is only valid one clock22 after pop22 signal22
assign data_out22 = {data8_out22,fifo[bottom22]};

// Additional22 logic for detection22 of error conditions22 (parity22 and framing22) inside the FIFO
// for the Line22 Status Register bit 7

wire	[2:0]	word022 = fifo[0];
wire	[2:0]	word122 = fifo[1];
wire	[2:0]	word222 = fifo[2];
wire	[2:0]	word322 = fifo[3];
wire	[2:0]	word422 = fifo[4];
wire	[2:0]	word522 = fifo[5];
wire	[2:0]	word622 = fifo[6];
wire	[2:0]	word722 = fifo[7];

wire	[2:0]	word822 = fifo[8];
wire	[2:0]	word922 = fifo[9];
wire	[2:0]	word1022 = fifo[10];
wire	[2:0]	word1122 = fifo[11];
wire	[2:0]	word1222 = fifo[12];
wire	[2:0]	word1322 = fifo[13];
wire	[2:0]	word1422 = fifo[14];
wire	[2:0]	word1522 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit22 = |(word022[2:0]  | word122[2:0]  | word222[2:0]  | word322[2:0]  |
            		      word422[2:0]  | word522[2:0]  | word622[2:0]  | word722[2:0]  |
            		      word822[2:0]  | word922[2:0]  | word1022[2:0] | word1122[2:0] |
            		      word1222[2:0] | word1322[2:0] | word1422[2:0] | word1522[2:0] );

endmodule
