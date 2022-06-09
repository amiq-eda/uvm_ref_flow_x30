//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo13.v                                                ////
////                                                              ////
////                                                              ////
////  This13 file is part of the "UART13 16550 compatible13" project13    ////
////  http13://www13.opencores13.org13/cores13/uart1655013/                   ////
////                                                              ////
////  Documentation13 related13 to this project13:                      ////
////  - http13://www13.opencores13.org13/cores13/uart1655013/                 ////
////                                                              ////
////  Projects13 compatibility13:                                     ////
////  - WISHBONE13                                                  ////
////  RS23213 Protocol13                                              ////
////  16550D uart13 (mostly13 supported)                              ////
////                                                              ////
////  Overview13 (main13 Features13):                                   ////
////  UART13 core13 transmitter13 FIFO                                  ////
////                                                              ////
////  To13 Do13:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author13(s):                                                  ////
////      - gorban13@opencores13.org13                                  ////
////      - Jacob13 Gorban13                                          ////
////      - Igor13 Mohor13 (igorm13@opencores13.org13)                      ////
////                                                              ////
////  Created13:        2001/05/12                                  ////
////  Last13 Updated13:   2002/07/22                                  ////
////                  (See log13 for the revision13 history13)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2000, 2001 Authors13                             ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS13 Revision13 History13
//
// $Log: not supported by cvs2svn13 $
// Revision13 1.1  2002/07/22 23:02:23  gorban13
// Bug13 Fixes13:
//  * Possible13 loss of sync and bad13 reception13 of stop bit on slow13 baud13 rates13 fixed13.
//   Problem13 reported13 by Kenny13.Tung13.
//  * Bad (or lack13 of ) loopback13 handling13 fixed13. Reported13 by Cherry13 Withers13.
//
// Improvements13:
//  * Made13 FIFO's as general13 inferrable13 memory where possible13.
//  So13 on FPGA13 they should be inferred13 as RAM13 (Distributed13 RAM13 on Xilinx13).
//  This13 saves13 about13 1/3 of the Slice13 count and reduces13 P&R and synthesis13 times.
//
//  * Added13 optional13 baudrate13 output (baud_o13).
//  This13 is identical13 to BAUDOUT13* signal13 on 16550 chip13.
//  It outputs13 16xbit_clock_rate - the divided13 clock13.
//  It's disabled by default. Define13 UART_HAS_BAUDRATE_OUTPUT13 to use.
//
// Revision13 1.16  2001/12/20 13:25:46  mohor13
// rx13 push13 changed to be only one cycle wide13.
//
// Revision13 1.15  2001/12/18 09:01:07  mohor13
// Bug13 that was entered13 in the last update fixed13 (rx13 state machine13).
//
// Revision13 1.14  2001/12/17 14:46:48  mohor13
// overrun13 signal13 was moved to separate13 block because many13 sequential13 lsr13
// reads were13 preventing13 data from being written13 to rx13 fifo.
// underrun13 signal13 was not used and was removed from the project13.
//
// Revision13 1.13  2001/11/26 21:38:54  gorban13
// Lots13 of fixes13:
// Break13 condition wasn13't handled13 correctly at all.
// LSR13 bits could lose13 their13 values.
// LSR13 value after reset was wrong13.
// Timing13 of THRE13 interrupt13 signal13 corrected13.
// LSR13 bit 0 timing13 corrected13.
//
// Revision13 1.12  2001/11/08 14:54:23  mohor13
// Comments13 in Slovene13 language13 deleted13, few13 small fixes13 for better13 work13 of
// old13 tools13. IRQs13 need to be fix13.
//
// Revision13 1.11  2001/11/07 17:51:52  gorban13
// Heavily13 rewritten13 interrupt13 and LSR13 subsystems13.
// Many13 bugs13 hopefully13 squashed13.
//
// Revision13 1.10  2001/10/20 09:58:40  gorban13
// Small13 synopsis13 fixes13
//
// Revision13 1.9  2001/08/24 21:01:12  mohor13
// Things13 connected13 to parity13 changed.
// Clock13 devider13 changed.
//
// Revision13 1.8  2001/08/24 08:48:10  mohor13
// FIFO was not cleared13 after the data was read bug13 fixed13.
//
// Revision13 1.7  2001/08/23 16:05:05  mohor13
// Stop bit bug13 fixed13.
// Parity13 bug13 fixed13.
// WISHBONE13 read cycle bug13 fixed13,
// OE13 indicator13 (Overrun13 Error) bug13 fixed13.
// PE13 indicator13 (Parity13 Error) bug13 fixed13.
// Register read bug13 fixed13.
//
// Revision13 1.3  2001/05/31 20:08:01  gorban13
// FIFO changes13 and other corrections13.
//
// Revision13 1.3  2001/05/27 17:37:48  gorban13
// Fixed13 many13 bugs13. Updated13 spec13. Changed13 FIFO files structure13. See CHANGES13.txt13 file.
//
// Revision13 1.2  2001/05/17 18:34:18  gorban13
// First13 'stable' release. Should13 be sythesizable13 now. Also13 added new header.
//
// Revision13 1.0  2001-05-17 21:27:12+02  jacob13
// Initial13 revision13
//
//

// synopsys13 translate_off13
`include "timescale.v"
// synopsys13 translate_on13

`include "uart_defines13.v"

module uart_tfifo13 (clk13, 
	wb_rst_i13, data_in13, data_out13,
// Control13 signals13
	push13, // push13 strobe13, active high13
	pop13,   // pop13 strobe13, active high13
// status signals13
	overrun13,
	count,
	fifo_reset13,
	reset_status13
	);


// FIFO parameters13
parameter fifo_width13 = `UART_FIFO_WIDTH13;
parameter fifo_depth13 = `UART_FIFO_DEPTH13;
parameter fifo_pointer_w13 = `UART_FIFO_POINTER_W13;
parameter fifo_counter_w13 = `UART_FIFO_COUNTER_W13;

input				clk13;
input				wb_rst_i13;
input				push13;
input				pop13;
input	[fifo_width13-1:0]	data_in13;
input				fifo_reset13;
input       reset_status13;

output	[fifo_width13-1:0]	data_out13;
output				overrun13;
output	[fifo_counter_w13-1:0]	count;

wire	[fifo_width13-1:0]	data_out13;

// FIFO pointers13
reg	[fifo_pointer_w13-1:0]	top;
reg	[fifo_pointer_w13-1:0]	bottom13;

reg	[fifo_counter_w13-1:0]	count;
reg				overrun13;
wire [fifo_pointer_w13-1:0] top_plus_113 = top + 1'b1;

raminfr13 #(fifo_pointer_w13,fifo_width13,fifo_depth13) tfifo13  
        (.clk13(clk13), 
			.we13(push13), 
			.a(top), 
			.dpra13(bottom13), 
			.di13(data_in13), 
			.dpo13(data_out13)
		); 


always @(posedge clk13 or posedge wb_rst_i13) // synchronous13 FIFO
begin
	if (wb_rst_i13)
	begin
		top		<= #1 0;
		bottom13		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset13) begin
		top		<= #1 0;
		bottom13		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push13, pop13})
		2'b10 : if (count<fifo_depth13)  // overrun13 condition
			begin
				top       <= #1 top_plus_113;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom13   <= #1 bottom13 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom13   <= #1 bottom13 + 1'b1;
				top       <= #1 top_plus_113;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk13 or posedge wb_rst_i13) // synchronous13 FIFO
begin
  if (wb_rst_i13)
    overrun13   <= #1 1'b0;
  else
  if(fifo_reset13 | reset_status13) 
    overrun13   <= #1 1'b0;
  else
  if(push13 & (count==fifo_depth13))
    overrun13   <= #1 1'b1;
end   // always

endmodule
