//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo21.v                                                ////
////                                                              ////
////                                                              ////
////  This21 file is part of the "UART21 16550 compatible21" project21    ////
////  http21://www21.opencores21.org21/cores21/uart1655021/                   ////
////                                                              ////
////  Documentation21 related21 to this project21:                      ////
////  - http21://www21.opencores21.org21/cores21/uart1655021/                 ////
////                                                              ////
////  Projects21 compatibility21:                                     ////
////  - WISHBONE21                                                  ////
////  RS23221 Protocol21                                              ////
////  16550D uart21 (mostly21 supported)                              ////
////                                                              ////
////  Overview21 (main21 Features21):                                   ////
////  UART21 core21 transmitter21 FIFO                                  ////
////                                                              ////
////  To21 Do21:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author21(s):                                                  ////
////      - gorban21@opencores21.org21                                  ////
////      - Jacob21 Gorban21                                          ////
////      - Igor21 Mohor21 (igorm21@opencores21.org21)                      ////
////                                                              ////
////  Created21:        2001/05/12                                  ////
////  Last21 Updated21:   2002/07/22                                  ////
////                  (See log21 for the revision21 history21)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2000, 2001 Authors21                             ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS21 Revision21 History21
//
// $Log: not supported by cvs2svn21 $
// Revision21 1.1  2002/07/22 23:02:23  gorban21
// Bug21 Fixes21:
//  * Possible21 loss of sync and bad21 reception21 of stop bit on slow21 baud21 rates21 fixed21.
//   Problem21 reported21 by Kenny21.Tung21.
//  * Bad (or lack21 of ) loopback21 handling21 fixed21. Reported21 by Cherry21 Withers21.
//
// Improvements21:
//  * Made21 FIFO's as general21 inferrable21 memory where possible21.
//  So21 on FPGA21 they should be inferred21 as RAM21 (Distributed21 RAM21 on Xilinx21).
//  This21 saves21 about21 1/3 of the Slice21 count and reduces21 P&R and synthesis21 times.
//
//  * Added21 optional21 baudrate21 output (baud_o21).
//  This21 is identical21 to BAUDOUT21* signal21 on 16550 chip21.
//  It outputs21 16xbit_clock_rate - the divided21 clock21.
//  It's disabled by default. Define21 UART_HAS_BAUDRATE_OUTPUT21 to use.
//
// Revision21 1.16  2001/12/20 13:25:46  mohor21
// rx21 push21 changed to be only one cycle wide21.
//
// Revision21 1.15  2001/12/18 09:01:07  mohor21
// Bug21 that was entered21 in the last update fixed21 (rx21 state machine21).
//
// Revision21 1.14  2001/12/17 14:46:48  mohor21
// overrun21 signal21 was moved to separate21 block because many21 sequential21 lsr21
// reads were21 preventing21 data from being written21 to rx21 fifo.
// underrun21 signal21 was not used and was removed from the project21.
//
// Revision21 1.13  2001/11/26 21:38:54  gorban21
// Lots21 of fixes21:
// Break21 condition wasn21't handled21 correctly at all.
// LSR21 bits could lose21 their21 values.
// LSR21 value after reset was wrong21.
// Timing21 of THRE21 interrupt21 signal21 corrected21.
// LSR21 bit 0 timing21 corrected21.
//
// Revision21 1.12  2001/11/08 14:54:23  mohor21
// Comments21 in Slovene21 language21 deleted21, few21 small fixes21 for better21 work21 of
// old21 tools21. IRQs21 need to be fix21.
//
// Revision21 1.11  2001/11/07 17:51:52  gorban21
// Heavily21 rewritten21 interrupt21 and LSR21 subsystems21.
// Many21 bugs21 hopefully21 squashed21.
//
// Revision21 1.10  2001/10/20 09:58:40  gorban21
// Small21 synopsis21 fixes21
//
// Revision21 1.9  2001/08/24 21:01:12  mohor21
// Things21 connected21 to parity21 changed.
// Clock21 devider21 changed.
//
// Revision21 1.8  2001/08/24 08:48:10  mohor21
// FIFO was not cleared21 after the data was read bug21 fixed21.
//
// Revision21 1.7  2001/08/23 16:05:05  mohor21
// Stop bit bug21 fixed21.
// Parity21 bug21 fixed21.
// WISHBONE21 read cycle bug21 fixed21,
// OE21 indicator21 (Overrun21 Error) bug21 fixed21.
// PE21 indicator21 (Parity21 Error) bug21 fixed21.
// Register read bug21 fixed21.
//
// Revision21 1.3  2001/05/31 20:08:01  gorban21
// FIFO changes21 and other corrections21.
//
// Revision21 1.3  2001/05/27 17:37:48  gorban21
// Fixed21 many21 bugs21. Updated21 spec21. Changed21 FIFO files structure21. See CHANGES21.txt21 file.
//
// Revision21 1.2  2001/05/17 18:34:18  gorban21
// First21 'stable' release. Should21 be sythesizable21 now. Also21 added new header.
//
// Revision21 1.0  2001-05-17 21:27:12+02  jacob21
// Initial21 revision21
//
//

// synopsys21 translate_off21
`include "timescale.v"
// synopsys21 translate_on21

`include "uart_defines21.v"

module uart_tfifo21 (clk21, 
	wb_rst_i21, data_in21, data_out21,
// Control21 signals21
	push21, // push21 strobe21, active high21
	pop21,   // pop21 strobe21, active high21
// status signals21
	overrun21,
	count,
	fifo_reset21,
	reset_status21
	);


// FIFO parameters21
parameter fifo_width21 = `UART_FIFO_WIDTH21;
parameter fifo_depth21 = `UART_FIFO_DEPTH21;
parameter fifo_pointer_w21 = `UART_FIFO_POINTER_W21;
parameter fifo_counter_w21 = `UART_FIFO_COUNTER_W21;

input				clk21;
input				wb_rst_i21;
input				push21;
input				pop21;
input	[fifo_width21-1:0]	data_in21;
input				fifo_reset21;
input       reset_status21;

output	[fifo_width21-1:0]	data_out21;
output				overrun21;
output	[fifo_counter_w21-1:0]	count;

wire	[fifo_width21-1:0]	data_out21;

// FIFO pointers21
reg	[fifo_pointer_w21-1:0]	top;
reg	[fifo_pointer_w21-1:0]	bottom21;

reg	[fifo_counter_w21-1:0]	count;
reg				overrun21;
wire [fifo_pointer_w21-1:0] top_plus_121 = top + 1'b1;

raminfr21 #(fifo_pointer_w21,fifo_width21,fifo_depth21) tfifo21  
        (.clk21(clk21), 
			.we21(push21), 
			.a(top), 
			.dpra21(bottom21), 
			.di21(data_in21), 
			.dpo21(data_out21)
		); 


always @(posedge clk21 or posedge wb_rst_i21) // synchronous21 FIFO
begin
	if (wb_rst_i21)
	begin
		top		<= #1 0;
		bottom21		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset21) begin
		top		<= #1 0;
		bottom21		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push21, pop21})
		2'b10 : if (count<fifo_depth21)  // overrun21 condition
			begin
				top       <= #1 top_plus_121;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom21   <= #1 bottom21 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom21   <= #1 bottom21 + 1'b1;
				top       <= #1 top_plus_121;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk21 or posedge wb_rst_i21) // synchronous21 FIFO
begin
  if (wb_rst_i21)
    overrun21   <= #1 1'b0;
  else
  if(fifo_reset21 | reset_status21) 
    overrun21   <= #1 1'b0;
  else
  if(push21 & (count==fifo_depth21))
    overrun21   <= #1 1'b1;
end   // always

endmodule
