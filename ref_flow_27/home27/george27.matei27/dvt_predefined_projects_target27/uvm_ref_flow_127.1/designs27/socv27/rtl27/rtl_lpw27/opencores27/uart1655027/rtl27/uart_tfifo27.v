//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo27.v                                                ////
////                                                              ////
////                                                              ////
////  This27 file is part of the "UART27 16550 compatible27" project27    ////
////  http27://www27.opencores27.org27/cores27/uart1655027/                   ////
////                                                              ////
////  Documentation27 related27 to this project27:                      ////
////  - http27://www27.opencores27.org27/cores27/uart1655027/                 ////
////                                                              ////
////  Projects27 compatibility27:                                     ////
////  - WISHBONE27                                                  ////
////  RS23227 Protocol27                                              ////
////  16550D uart27 (mostly27 supported)                              ////
////                                                              ////
////  Overview27 (main27 Features27):                                   ////
////  UART27 core27 transmitter27 FIFO                                  ////
////                                                              ////
////  To27 Do27:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author27(s):                                                  ////
////      - gorban27@opencores27.org27                                  ////
////      - Jacob27 Gorban27                                          ////
////      - Igor27 Mohor27 (igorm27@opencores27.org27)                      ////
////                                                              ////
////  Created27:        2001/05/12                                  ////
////  Last27 Updated27:   2002/07/22                                  ////
////                  (See log27 for the revision27 history27)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2000, 2001 Authors27                             ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS27 Revision27 History27
//
// $Log: not supported by cvs2svn27 $
// Revision27 1.1  2002/07/22 23:02:23  gorban27
// Bug27 Fixes27:
//  * Possible27 loss of sync and bad27 reception27 of stop bit on slow27 baud27 rates27 fixed27.
//   Problem27 reported27 by Kenny27.Tung27.
//  * Bad (or lack27 of ) loopback27 handling27 fixed27. Reported27 by Cherry27 Withers27.
//
// Improvements27:
//  * Made27 FIFO's as general27 inferrable27 memory where possible27.
//  So27 on FPGA27 they should be inferred27 as RAM27 (Distributed27 RAM27 on Xilinx27).
//  This27 saves27 about27 1/3 of the Slice27 count and reduces27 P&R and synthesis27 times.
//
//  * Added27 optional27 baudrate27 output (baud_o27).
//  This27 is identical27 to BAUDOUT27* signal27 on 16550 chip27.
//  It outputs27 16xbit_clock_rate - the divided27 clock27.
//  It's disabled by default. Define27 UART_HAS_BAUDRATE_OUTPUT27 to use.
//
// Revision27 1.16  2001/12/20 13:25:46  mohor27
// rx27 push27 changed to be only one cycle wide27.
//
// Revision27 1.15  2001/12/18 09:01:07  mohor27
// Bug27 that was entered27 in the last update fixed27 (rx27 state machine27).
//
// Revision27 1.14  2001/12/17 14:46:48  mohor27
// overrun27 signal27 was moved to separate27 block because many27 sequential27 lsr27
// reads were27 preventing27 data from being written27 to rx27 fifo.
// underrun27 signal27 was not used and was removed from the project27.
//
// Revision27 1.13  2001/11/26 21:38:54  gorban27
// Lots27 of fixes27:
// Break27 condition wasn27't handled27 correctly at all.
// LSR27 bits could lose27 their27 values.
// LSR27 value after reset was wrong27.
// Timing27 of THRE27 interrupt27 signal27 corrected27.
// LSR27 bit 0 timing27 corrected27.
//
// Revision27 1.12  2001/11/08 14:54:23  mohor27
// Comments27 in Slovene27 language27 deleted27, few27 small fixes27 for better27 work27 of
// old27 tools27. IRQs27 need to be fix27.
//
// Revision27 1.11  2001/11/07 17:51:52  gorban27
// Heavily27 rewritten27 interrupt27 and LSR27 subsystems27.
// Many27 bugs27 hopefully27 squashed27.
//
// Revision27 1.10  2001/10/20 09:58:40  gorban27
// Small27 synopsis27 fixes27
//
// Revision27 1.9  2001/08/24 21:01:12  mohor27
// Things27 connected27 to parity27 changed.
// Clock27 devider27 changed.
//
// Revision27 1.8  2001/08/24 08:48:10  mohor27
// FIFO was not cleared27 after the data was read bug27 fixed27.
//
// Revision27 1.7  2001/08/23 16:05:05  mohor27
// Stop bit bug27 fixed27.
// Parity27 bug27 fixed27.
// WISHBONE27 read cycle bug27 fixed27,
// OE27 indicator27 (Overrun27 Error) bug27 fixed27.
// PE27 indicator27 (Parity27 Error) bug27 fixed27.
// Register read bug27 fixed27.
//
// Revision27 1.3  2001/05/31 20:08:01  gorban27
// FIFO changes27 and other corrections27.
//
// Revision27 1.3  2001/05/27 17:37:48  gorban27
// Fixed27 many27 bugs27. Updated27 spec27. Changed27 FIFO files structure27. See CHANGES27.txt27 file.
//
// Revision27 1.2  2001/05/17 18:34:18  gorban27
// First27 'stable' release. Should27 be sythesizable27 now. Also27 added new header.
//
// Revision27 1.0  2001-05-17 21:27:12+02  jacob27
// Initial27 revision27
//
//

// synopsys27 translate_off27
`include "timescale.v"
// synopsys27 translate_on27

`include "uart_defines27.v"

module uart_tfifo27 (clk27, 
	wb_rst_i27, data_in27, data_out27,
// Control27 signals27
	push27, // push27 strobe27, active high27
	pop27,   // pop27 strobe27, active high27
// status signals27
	overrun27,
	count,
	fifo_reset27,
	reset_status27
	);


// FIFO parameters27
parameter fifo_width27 = `UART_FIFO_WIDTH27;
parameter fifo_depth27 = `UART_FIFO_DEPTH27;
parameter fifo_pointer_w27 = `UART_FIFO_POINTER_W27;
parameter fifo_counter_w27 = `UART_FIFO_COUNTER_W27;

input				clk27;
input				wb_rst_i27;
input				push27;
input				pop27;
input	[fifo_width27-1:0]	data_in27;
input				fifo_reset27;
input       reset_status27;

output	[fifo_width27-1:0]	data_out27;
output				overrun27;
output	[fifo_counter_w27-1:0]	count;

wire	[fifo_width27-1:0]	data_out27;

// FIFO pointers27
reg	[fifo_pointer_w27-1:0]	top;
reg	[fifo_pointer_w27-1:0]	bottom27;

reg	[fifo_counter_w27-1:0]	count;
reg				overrun27;
wire [fifo_pointer_w27-1:0] top_plus_127 = top + 1'b1;

raminfr27 #(fifo_pointer_w27,fifo_width27,fifo_depth27) tfifo27  
        (.clk27(clk27), 
			.we27(push27), 
			.a(top), 
			.dpra27(bottom27), 
			.di27(data_in27), 
			.dpo27(data_out27)
		); 


always @(posedge clk27 or posedge wb_rst_i27) // synchronous27 FIFO
begin
	if (wb_rst_i27)
	begin
		top		<= #1 0;
		bottom27		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset27) begin
		top		<= #1 0;
		bottom27		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push27, pop27})
		2'b10 : if (count<fifo_depth27)  // overrun27 condition
			begin
				top       <= #1 top_plus_127;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom27   <= #1 bottom27 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom27   <= #1 bottom27 + 1'b1;
				top       <= #1 top_plus_127;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk27 or posedge wb_rst_i27) // synchronous27 FIFO
begin
  if (wb_rst_i27)
    overrun27   <= #1 1'b0;
  else
  if(fifo_reset27 | reset_status27) 
    overrun27   <= #1 1'b0;
  else
  if(push27 & (count==fifo_depth27))
    overrun27   <= #1 1'b1;
end   // always

endmodule
