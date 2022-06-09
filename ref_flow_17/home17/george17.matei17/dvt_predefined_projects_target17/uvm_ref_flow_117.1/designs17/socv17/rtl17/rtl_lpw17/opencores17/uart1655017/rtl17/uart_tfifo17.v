//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo17.v                                                ////
////                                                              ////
////                                                              ////
////  This17 file is part of the "UART17 16550 compatible17" project17    ////
////  http17://www17.opencores17.org17/cores17/uart1655017/                   ////
////                                                              ////
////  Documentation17 related17 to this project17:                      ////
////  - http17://www17.opencores17.org17/cores17/uart1655017/                 ////
////                                                              ////
////  Projects17 compatibility17:                                     ////
////  - WISHBONE17                                                  ////
////  RS23217 Protocol17                                              ////
////  16550D uart17 (mostly17 supported)                              ////
////                                                              ////
////  Overview17 (main17 Features17):                                   ////
////  UART17 core17 transmitter17 FIFO                                  ////
////                                                              ////
////  To17 Do17:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author17(s):                                                  ////
////      - gorban17@opencores17.org17                                  ////
////      - Jacob17 Gorban17                                          ////
////      - Igor17 Mohor17 (igorm17@opencores17.org17)                      ////
////                                                              ////
////  Created17:        2001/05/12                                  ////
////  Last17 Updated17:   2002/07/22                                  ////
////                  (See log17 for the revision17 history17)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2000, 2001 Authors17                             ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS17 Revision17 History17
//
// $Log: not supported by cvs2svn17 $
// Revision17 1.1  2002/07/22 23:02:23  gorban17
// Bug17 Fixes17:
//  * Possible17 loss of sync and bad17 reception17 of stop bit on slow17 baud17 rates17 fixed17.
//   Problem17 reported17 by Kenny17.Tung17.
//  * Bad (or lack17 of ) loopback17 handling17 fixed17. Reported17 by Cherry17 Withers17.
//
// Improvements17:
//  * Made17 FIFO's as general17 inferrable17 memory where possible17.
//  So17 on FPGA17 they should be inferred17 as RAM17 (Distributed17 RAM17 on Xilinx17).
//  This17 saves17 about17 1/3 of the Slice17 count and reduces17 P&R and synthesis17 times.
//
//  * Added17 optional17 baudrate17 output (baud_o17).
//  This17 is identical17 to BAUDOUT17* signal17 on 16550 chip17.
//  It outputs17 16xbit_clock_rate - the divided17 clock17.
//  It's disabled by default. Define17 UART_HAS_BAUDRATE_OUTPUT17 to use.
//
// Revision17 1.16  2001/12/20 13:25:46  mohor17
// rx17 push17 changed to be only one cycle wide17.
//
// Revision17 1.15  2001/12/18 09:01:07  mohor17
// Bug17 that was entered17 in the last update fixed17 (rx17 state machine17).
//
// Revision17 1.14  2001/12/17 14:46:48  mohor17
// overrun17 signal17 was moved to separate17 block because many17 sequential17 lsr17
// reads were17 preventing17 data from being written17 to rx17 fifo.
// underrun17 signal17 was not used and was removed from the project17.
//
// Revision17 1.13  2001/11/26 21:38:54  gorban17
// Lots17 of fixes17:
// Break17 condition wasn17't handled17 correctly at all.
// LSR17 bits could lose17 their17 values.
// LSR17 value after reset was wrong17.
// Timing17 of THRE17 interrupt17 signal17 corrected17.
// LSR17 bit 0 timing17 corrected17.
//
// Revision17 1.12  2001/11/08 14:54:23  mohor17
// Comments17 in Slovene17 language17 deleted17, few17 small fixes17 for better17 work17 of
// old17 tools17. IRQs17 need to be fix17.
//
// Revision17 1.11  2001/11/07 17:51:52  gorban17
// Heavily17 rewritten17 interrupt17 and LSR17 subsystems17.
// Many17 bugs17 hopefully17 squashed17.
//
// Revision17 1.10  2001/10/20 09:58:40  gorban17
// Small17 synopsis17 fixes17
//
// Revision17 1.9  2001/08/24 21:01:12  mohor17
// Things17 connected17 to parity17 changed.
// Clock17 devider17 changed.
//
// Revision17 1.8  2001/08/24 08:48:10  mohor17
// FIFO was not cleared17 after the data was read bug17 fixed17.
//
// Revision17 1.7  2001/08/23 16:05:05  mohor17
// Stop bit bug17 fixed17.
// Parity17 bug17 fixed17.
// WISHBONE17 read cycle bug17 fixed17,
// OE17 indicator17 (Overrun17 Error) bug17 fixed17.
// PE17 indicator17 (Parity17 Error) bug17 fixed17.
// Register read bug17 fixed17.
//
// Revision17 1.3  2001/05/31 20:08:01  gorban17
// FIFO changes17 and other corrections17.
//
// Revision17 1.3  2001/05/27 17:37:48  gorban17
// Fixed17 many17 bugs17. Updated17 spec17. Changed17 FIFO files structure17. See CHANGES17.txt17 file.
//
// Revision17 1.2  2001/05/17 18:34:18  gorban17
// First17 'stable' release. Should17 be sythesizable17 now. Also17 added new header.
//
// Revision17 1.0  2001-05-17 21:27:12+02  jacob17
// Initial17 revision17
//
//

// synopsys17 translate_off17
`include "timescale.v"
// synopsys17 translate_on17

`include "uart_defines17.v"

module uart_tfifo17 (clk17, 
	wb_rst_i17, data_in17, data_out17,
// Control17 signals17
	push17, // push17 strobe17, active high17
	pop17,   // pop17 strobe17, active high17
// status signals17
	overrun17,
	count,
	fifo_reset17,
	reset_status17
	);


// FIFO parameters17
parameter fifo_width17 = `UART_FIFO_WIDTH17;
parameter fifo_depth17 = `UART_FIFO_DEPTH17;
parameter fifo_pointer_w17 = `UART_FIFO_POINTER_W17;
parameter fifo_counter_w17 = `UART_FIFO_COUNTER_W17;

input				clk17;
input				wb_rst_i17;
input				push17;
input				pop17;
input	[fifo_width17-1:0]	data_in17;
input				fifo_reset17;
input       reset_status17;

output	[fifo_width17-1:0]	data_out17;
output				overrun17;
output	[fifo_counter_w17-1:0]	count;

wire	[fifo_width17-1:0]	data_out17;

// FIFO pointers17
reg	[fifo_pointer_w17-1:0]	top;
reg	[fifo_pointer_w17-1:0]	bottom17;

reg	[fifo_counter_w17-1:0]	count;
reg				overrun17;
wire [fifo_pointer_w17-1:0] top_plus_117 = top + 1'b1;

raminfr17 #(fifo_pointer_w17,fifo_width17,fifo_depth17) tfifo17  
        (.clk17(clk17), 
			.we17(push17), 
			.a(top), 
			.dpra17(bottom17), 
			.di17(data_in17), 
			.dpo17(data_out17)
		); 


always @(posedge clk17 or posedge wb_rst_i17) // synchronous17 FIFO
begin
	if (wb_rst_i17)
	begin
		top		<= #1 0;
		bottom17		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset17) begin
		top		<= #1 0;
		bottom17		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push17, pop17})
		2'b10 : if (count<fifo_depth17)  // overrun17 condition
			begin
				top       <= #1 top_plus_117;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom17   <= #1 bottom17 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom17   <= #1 bottom17 + 1'b1;
				top       <= #1 top_plus_117;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk17 or posedge wb_rst_i17) // synchronous17 FIFO
begin
  if (wb_rst_i17)
    overrun17   <= #1 1'b0;
  else
  if(fifo_reset17 | reset_status17) 
    overrun17   <= #1 1'b0;
  else
  if(push17 & (count==fifo_depth17))
    overrun17   <= #1 1'b1;
end   // always

endmodule
