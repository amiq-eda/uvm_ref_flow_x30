//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo2.v                                                ////
////                                                              ////
////                                                              ////
////  This2 file is part of the "UART2 16550 compatible2" project2    ////
////  http2://www2.opencores2.org2/cores2/uart165502/                   ////
////                                                              ////
////  Documentation2 related2 to this project2:                      ////
////  - http2://www2.opencores2.org2/cores2/uart165502/                 ////
////                                                              ////
////  Projects2 compatibility2:                                     ////
////  - WISHBONE2                                                  ////
////  RS2322 Protocol2                                              ////
////  16550D uart2 (mostly2 supported)                              ////
////                                                              ////
////  Overview2 (main2 Features2):                                   ////
////  UART2 core2 transmitter2 FIFO                                  ////
////                                                              ////
////  To2 Do2:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author2(s):                                                  ////
////      - gorban2@opencores2.org2                                  ////
////      - Jacob2 Gorban2                                          ////
////      - Igor2 Mohor2 (igorm2@opencores2.org2)                      ////
////                                                              ////
////  Created2:        2001/05/12                                  ////
////  Last2 Updated2:   2002/07/22                                  ////
////                  (See log2 for the revision2 history2)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2000, 2001 Authors2                             ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS2 Revision2 History2
//
// $Log: not supported by cvs2svn2 $
// Revision2 1.1  2002/07/22 23:02:23  gorban2
// Bug2 Fixes2:
//  * Possible2 loss of sync and bad2 reception2 of stop bit on slow2 baud2 rates2 fixed2.
//   Problem2 reported2 by Kenny2.Tung2.
//  * Bad (or lack2 of ) loopback2 handling2 fixed2. Reported2 by Cherry2 Withers2.
//
// Improvements2:
//  * Made2 FIFO's as general2 inferrable2 memory where possible2.
//  So2 on FPGA2 they should be inferred2 as RAM2 (Distributed2 RAM2 on Xilinx2).
//  This2 saves2 about2 1/3 of the Slice2 count and reduces2 P&R and synthesis2 times.
//
//  * Added2 optional2 baudrate2 output (baud_o2).
//  This2 is identical2 to BAUDOUT2* signal2 on 16550 chip2.
//  It outputs2 16xbit_clock_rate - the divided2 clock2.
//  It's disabled by default. Define2 UART_HAS_BAUDRATE_OUTPUT2 to use.
//
// Revision2 1.16  2001/12/20 13:25:46  mohor2
// rx2 push2 changed to be only one cycle wide2.
//
// Revision2 1.15  2001/12/18 09:01:07  mohor2
// Bug2 that was entered2 in the last update fixed2 (rx2 state machine2).
//
// Revision2 1.14  2001/12/17 14:46:48  mohor2
// overrun2 signal2 was moved to separate2 block because many2 sequential2 lsr2
// reads were2 preventing2 data from being written2 to rx2 fifo.
// underrun2 signal2 was not used and was removed from the project2.
//
// Revision2 1.13  2001/11/26 21:38:54  gorban2
// Lots2 of fixes2:
// Break2 condition wasn2't handled2 correctly at all.
// LSR2 bits could lose2 their2 values.
// LSR2 value after reset was wrong2.
// Timing2 of THRE2 interrupt2 signal2 corrected2.
// LSR2 bit 0 timing2 corrected2.
//
// Revision2 1.12  2001/11/08 14:54:23  mohor2
// Comments2 in Slovene2 language2 deleted2, few2 small fixes2 for better2 work2 of
// old2 tools2. IRQs2 need to be fix2.
//
// Revision2 1.11  2001/11/07 17:51:52  gorban2
// Heavily2 rewritten2 interrupt2 and LSR2 subsystems2.
// Many2 bugs2 hopefully2 squashed2.
//
// Revision2 1.10  2001/10/20 09:58:40  gorban2
// Small2 synopsis2 fixes2
//
// Revision2 1.9  2001/08/24 21:01:12  mohor2
// Things2 connected2 to parity2 changed.
// Clock2 devider2 changed.
//
// Revision2 1.8  2001/08/24 08:48:10  mohor2
// FIFO was not cleared2 after the data was read bug2 fixed2.
//
// Revision2 1.7  2001/08/23 16:05:05  mohor2
// Stop bit bug2 fixed2.
// Parity2 bug2 fixed2.
// WISHBONE2 read cycle bug2 fixed2,
// OE2 indicator2 (Overrun2 Error) bug2 fixed2.
// PE2 indicator2 (Parity2 Error) bug2 fixed2.
// Register read bug2 fixed2.
//
// Revision2 1.3  2001/05/31 20:08:01  gorban2
// FIFO changes2 and other corrections2.
//
// Revision2 1.3  2001/05/27 17:37:48  gorban2
// Fixed2 many2 bugs2. Updated2 spec2. Changed2 FIFO files structure2. See CHANGES2.txt2 file.
//
// Revision2 1.2  2001/05/17 18:34:18  gorban2
// First2 'stable' release. Should2 be sythesizable2 now. Also2 added new header.
//
// Revision2 1.0  2001-05-17 21:27:12+02  jacob2
// Initial2 revision2
//
//

// synopsys2 translate_off2
`include "timescale.v"
// synopsys2 translate_on2

`include "uart_defines2.v"

module uart_tfifo2 (clk2, 
	wb_rst_i2, data_in2, data_out2,
// Control2 signals2
	push2, // push2 strobe2, active high2
	pop2,   // pop2 strobe2, active high2
// status signals2
	overrun2,
	count,
	fifo_reset2,
	reset_status2
	);


// FIFO parameters2
parameter fifo_width2 = `UART_FIFO_WIDTH2;
parameter fifo_depth2 = `UART_FIFO_DEPTH2;
parameter fifo_pointer_w2 = `UART_FIFO_POINTER_W2;
parameter fifo_counter_w2 = `UART_FIFO_COUNTER_W2;

input				clk2;
input				wb_rst_i2;
input				push2;
input				pop2;
input	[fifo_width2-1:0]	data_in2;
input				fifo_reset2;
input       reset_status2;

output	[fifo_width2-1:0]	data_out2;
output				overrun2;
output	[fifo_counter_w2-1:0]	count;

wire	[fifo_width2-1:0]	data_out2;

// FIFO pointers2
reg	[fifo_pointer_w2-1:0]	top;
reg	[fifo_pointer_w2-1:0]	bottom2;

reg	[fifo_counter_w2-1:0]	count;
reg				overrun2;
wire [fifo_pointer_w2-1:0] top_plus_12 = top + 1'b1;

raminfr2 #(fifo_pointer_w2,fifo_width2,fifo_depth2) tfifo2  
        (.clk2(clk2), 
			.we2(push2), 
			.a(top), 
			.dpra2(bottom2), 
			.di2(data_in2), 
			.dpo2(data_out2)
		); 


always @(posedge clk2 or posedge wb_rst_i2) // synchronous2 FIFO
begin
	if (wb_rst_i2)
	begin
		top		<= #1 0;
		bottom2		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset2) begin
		top		<= #1 0;
		bottom2		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push2, pop2})
		2'b10 : if (count<fifo_depth2)  // overrun2 condition
			begin
				top       <= #1 top_plus_12;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom2   <= #1 bottom2 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom2   <= #1 bottom2 + 1'b1;
				top       <= #1 top_plus_12;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk2 or posedge wb_rst_i2) // synchronous2 FIFO
begin
  if (wb_rst_i2)
    overrun2   <= #1 1'b0;
  else
  if(fifo_reset2 | reset_status2) 
    overrun2   <= #1 1'b0;
  else
  if(push2 & (count==fifo_depth2))
    overrun2   <= #1 1'b1;
end   // always

endmodule
