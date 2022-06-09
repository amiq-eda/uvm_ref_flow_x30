//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo30.v                                                ////
////                                                              ////
////                                                              ////
////  This30 file is part of the "UART30 16550 compatible30" project30    ////
////  http30://www30.opencores30.org30/cores30/uart1655030/                   ////
////                                                              ////
////  Documentation30 related30 to this project30:                      ////
////  - http30://www30.opencores30.org30/cores30/uart1655030/                 ////
////                                                              ////
////  Projects30 compatibility30:                                     ////
////  - WISHBONE30                                                  ////
////  RS23230 Protocol30                                              ////
////  16550D uart30 (mostly30 supported)                              ////
////                                                              ////
////  Overview30 (main30 Features30):                                   ////
////  UART30 core30 transmitter30 FIFO                                  ////
////                                                              ////
////  To30 Do30:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author30(s):                                                  ////
////      - gorban30@opencores30.org30                                  ////
////      - Jacob30 Gorban30                                          ////
////      - Igor30 Mohor30 (igorm30@opencores30.org30)                      ////
////                                                              ////
////  Created30:        2001/05/12                                  ////
////  Last30 Updated30:   2002/07/22                                  ////
////                  (See log30 for the revision30 history30)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2000, 2001 Authors30                             ////
////                                                              ////
//// This30 source30 file may be used and distributed30 without         ////
//// restriction30 provided that this copyright30 statement30 is not    ////
//// removed from the file and that any derivative30 work30 contains30  ////
//// the original copyright30 notice30 and the associated disclaimer30. ////
////                                                              ////
//// This30 source30 file is free software30; you can redistribute30 it   ////
//// and/or modify it under the terms30 of the GNU30 Lesser30 General30   ////
//// Public30 License30 as published30 by the Free30 Software30 Foundation30; ////
//// either30 version30 2.1 of the License30, or (at your30 option) any   ////
//// later30 version30.                                               ////
////                                                              ////
//// This30 source30 is distributed30 in the hope30 that it will be       ////
//// useful30, but WITHOUT30 ANY30 WARRANTY30; without even30 the implied30   ////
//// warranty30 of MERCHANTABILITY30 or FITNESS30 FOR30 A PARTICULAR30      ////
//// PURPOSE30.  See the GNU30 Lesser30 General30 Public30 License30 for more ////
//// details30.                                                     ////
////                                                              ////
//// You should have received30 a copy of the GNU30 Lesser30 General30    ////
//// Public30 License30 along30 with this source30; if not, download30 it   ////
//// from http30://www30.opencores30.org30/lgpl30.shtml30                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS30 Revision30 History30
//
// $Log: not supported by cvs2svn30 $
// Revision30 1.1  2002/07/22 23:02:23  gorban30
// Bug30 Fixes30:
//  * Possible30 loss of sync and bad30 reception30 of stop bit on slow30 baud30 rates30 fixed30.
//   Problem30 reported30 by Kenny30.Tung30.
//  * Bad (or lack30 of ) loopback30 handling30 fixed30. Reported30 by Cherry30 Withers30.
//
// Improvements30:
//  * Made30 FIFO's as general30 inferrable30 memory where possible30.
//  So30 on FPGA30 they should be inferred30 as RAM30 (Distributed30 RAM30 on Xilinx30).
//  This30 saves30 about30 1/3 of the Slice30 count and reduces30 P&R and synthesis30 times.
//
//  * Added30 optional30 baudrate30 output (baud_o30).
//  This30 is identical30 to BAUDOUT30* signal30 on 16550 chip30.
//  It outputs30 16xbit_clock_rate - the divided30 clock30.
//  It's disabled by default. Define30 UART_HAS_BAUDRATE_OUTPUT30 to use.
//
// Revision30 1.16  2001/12/20 13:25:46  mohor30
// rx30 push30 changed to be only one cycle wide30.
//
// Revision30 1.15  2001/12/18 09:01:07  mohor30
// Bug30 that was entered30 in the last update fixed30 (rx30 state machine30).
//
// Revision30 1.14  2001/12/17 14:46:48  mohor30
// overrun30 signal30 was moved to separate30 block because many30 sequential30 lsr30
// reads were30 preventing30 data from being written30 to rx30 fifo.
// underrun30 signal30 was not used and was removed from the project30.
//
// Revision30 1.13  2001/11/26 21:38:54  gorban30
// Lots30 of fixes30:
// Break30 condition wasn30't handled30 correctly at all.
// LSR30 bits could lose30 their30 values.
// LSR30 value after reset was wrong30.
// Timing30 of THRE30 interrupt30 signal30 corrected30.
// LSR30 bit 0 timing30 corrected30.
//
// Revision30 1.12  2001/11/08 14:54:23  mohor30
// Comments30 in Slovene30 language30 deleted30, few30 small fixes30 for better30 work30 of
// old30 tools30. IRQs30 need to be fix30.
//
// Revision30 1.11  2001/11/07 17:51:52  gorban30
// Heavily30 rewritten30 interrupt30 and LSR30 subsystems30.
// Many30 bugs30 hopefully30 squashed30.
//
// Revision30 1.10  2001/10/20 09:58:40  gorban30
// Small30 synopsis30 fixes30
//
// Revision30 1.9  2001/08/24 21:01:12  mohor30
// Things30 connected30 to parity30 changed.
// Clock30 devider30 changed.
//
// Revision30 1.8  2001/08/24 08:48:10  mohor30
// FIFO was not cleared30 after the data was read bug30 fixed30.
//
// Revision30 1.7  2001/08/23 16:05:05  mohor30
// Stop bit bug30 fixed30.
// Parity30 bug30 fixed30.
// WISHBONE30 read cycle bug30 fixed30,
// OE30 indicator30 (Overrun30 Error) bug30 fixed30.
// PE30 indicator30 (Parity30 Error) bug30 fixed30.
// Register read bug30 fixed30.
//
// Revision30 1.3  2001/05/31 20:08:01  gorban30
// FIFO changes30 and other corrections30.
//
// Revision30 1.3  2001/05/27 17:37:48  gorban30
// Fixed30 many30 bugs30. Updated30 spec30. Changed30 FIFO files structure30. See CHANGES30.txt30 file.
//
// Revision30 1.2  2001/05/17 18:34:18  gorban30
// First30 'stable' release. Should30 be sythesizable30 now. Also30 added new header.
//
// Revision30 1.0  2001-05-17 21:27:12+02  jacob30
// Initial30 revision30
//
//

// synopsys30 translate_off30
`include "timescale.v"
// synopsys30 translate_on30

`include "uart_defines30.v"

module uart_tfifo30 (clk30, 
	wb_rst_i30, data_in30, data_out30,
// Control30 signals30
	push30, // push30 strobe30, active high30
	pop30,   // pop30 strobe30, active high30
// status signals30
	overrun30,
	count,
	fifo_reset30,
	reset_status30
	);


// FIFO parameters30
parameter fifo_width30 = `UART_FIFO_WIDTH30;
parameter fifo_depth30 = `UART_FIFO_DEPTH30;
parameter fifo_pointer_w30 = `UART_FIFO_POINTER_W30;
parameter fifo_counter_w30 = `UART_FIFO_COUNTER_W30;

input				clk30;
input				wb_rst_i30;
input				push30;
input				pop30;
input	[fifo_width30-1:0]	data_in30;
input				fifo_reset30;
input       reset_status30;

output	[fifo_width30-1:0]	data_out30;
output				overrun30;
output	[fifo_counter_w30-1:0]	count;

wire	[fifo_width30-1:0]	data_out30;

// FIFO pointers30
reg	[fifo_pointer_w30-1:0]	top;
reg	[fifo_pointer_w30-1:0]	bottom30;

reg	[fifo_counter_w30-1:0]	count;
reg				overrun30;
wire [fifo_pointer_w30-1:0] top_plus_130 = top + 1'b1;

raminfr30 #(fifo_pointer_w30,fifo_width30,fifo_depth30) tfifo30  
        (.clk30(clk30), 
			.we30(push30), 
			.a(top), 
			.dpra30(bottom30), 
			.di30(data_in30), 
			.dpo30(data_out30)
		); 


always @(posedge clk30 or posedge wb_rst_i30) // synchronous30 FIFO
begin
	if (wb_rst_i30)
	begin
		top		<= #1 0;
		bottom30		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset30) begin
		top		<= #1 0;
		bottom30		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push30, pop30})
		2'b10 : if (count<fifo_depth30)  // overrun30 condition
			begin
				top       <= #1 top_plus_130;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom30   <= #1 bottom30 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom30   <= #1 bottom30 + 1'b1;
				top       <= #1 top_plus_130;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk30 or posedge wb_rst_i30) // synchronous30 FIFO
begin
  if (wb_rst_i30)
    overrun30   <= #1 1'b0;
  else
  if(fifo_reset30 | reset_status30) 
    overrun30   <= #1 1'b0;
  else
  if(push30 & (count==fifo_depth30))
    overrun30   <= #1 1'b1;
end   // always

endmodule
