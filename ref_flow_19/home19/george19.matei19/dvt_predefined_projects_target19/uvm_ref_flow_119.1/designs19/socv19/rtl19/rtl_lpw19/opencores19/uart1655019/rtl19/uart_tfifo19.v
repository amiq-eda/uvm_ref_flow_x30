//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo19.v                                                ////
////                                                              ////
////                                                              ////
////  This19 file is part of the "UART19 16550 compatible19" project19    ////
////  http19://www19.opencores19.org19/cores19/uart1655019/                   ////
////                                                              ////
////  Documentation19 related19 to this project19:                      ////
////  - http19://www19.opencores19.org19/cores19/uart1655019/                 ////
////                                                              ////
////  Projects19 compatibility19:                                     ////
////  - WISHBONE19                                                  ////
////  RS23219 Protocol19                                              ////
////  16550D uart19 (mostly19 supported)                              ////
////                                                              ////
////  Overview19 (main19 Features19):                                   ////
////  UART19 core19 transmitter19 FIFO                                  ////
////                                                              ////
////  To19 Do19:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author19(s):                                                  ////
////      - gorban19@opencores19.org19                                  ////
////      - Jacob19 Gorban19                                          ////
////      - Igor19 Mohor19 (igorm19@opencores19.org19)                      ////
////                                                              ////
////  Created19:        2001/05/12                                  ////
////  Last19 Updated19:   2002/07/22                                  ////
////                  (See log19 for the revision19 history19)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2000, 2001 Authors19                             ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS19 Revision19 History19
//
// $Log: not supported by cvs2svn19 $
// Revision19 1.1  2002/07/22 23:02:23  gorban19
// Bug19 Fixes19:
//  * Possible19 loss of sync and bad19 reception19 of stop bit on slow19 baud19 rates19 fixed19.
//   Problem19 reported19 by Kenny19.Tung19.
//  * Bad (or lack19 of ) loopback19 handling19 fixed19. Reported19 by Cherry19 Withers19.
//
// Improvements19:
//  * Made19 FIFO's as general19 inferrable19 memory where possible19.
//  So19 on FPGA19 they should be inferred19 as RAM19 (Distributed19 RAM19 on Xilinx19).
//  This19 saves19 about19 1/3 of the Slice19 count and reduces19 P&R and synthesis19 times.
//
//  * Added19 optional19 baudrate19 output (baud_o19).
//  This19 is identical19 to BAUDOUT19* signal19 on 16550 chip19.
//  It outputs19 16xbit_clock_rate - the divided19 clock19.
//  It's disabled by default. Define19 UART_HAS_BAUDRATE_OUTPUT19 to use.
//
// Revision19 1.16  2001/12/20 13:25:46  mohor19
// rx19 push19 changed to be only one cycle wide19.
//
// Revision19 1.15  2001/12/18 09:01:07  mohor19
// Bug19 that was entered19 in the last update fixed19 (rx19 state machine19).
//
// Revision19 1.14  2001/12/17 14:46:48  mohor19
// overrun19 signal19 was moved to separate19 block because many19 sequential19 lsr19
// reads were19 preventing19 data from being written19 to rx19 fifo.
// underrun19 signal19 was not used and was removed from the project19.
//
// Revision19 1.13  2001/11/26 21:38:54  gorban19
// Lots19 of fixes19:
// Break19 condition wasn19't handled19 correctly at all.
// LSR19 bits could lose19 their19 values.
// LSR19 value after reset was wrong19.
// Timing19 of THRE19 interrupt19 signal19 corrected19.
// LSR19 bit 0 timing19 corrected19.
//
// Revision19 1.12  2001/11/08 14:54:23  mohor19
// Comments19 in Slovene19 language19 deleted19, few19 small fixes19 for better19 work19 of
// old19 tools19. IRQs19 need to be fix19.
//
// Revision19 1.11  2001/11/07 17:51:52  gorban19
// Heavily19 rewritten19 interrupt19 and LSR19 subsystems19.
// Many19 bugs19 hopefully19 squashed19.
//
// Revision19 1.10  2001/10/20 09:58:40  gorban19
// Small19 synopsis19 fixes19
//
// Revision19 1.9  2001/08/24 21:01:12  mohor19
// Things19 connected19 to parity19 changed.
// Clock19 devider19 changed.
//
// Revision19 1.8  2001/08/24 08:48:10  mohor19
// FIFO was not cleared19 after the data was read bug19 fixed19.
//
// Revision19 1.7  2001/08/23 16:05:05  mohor19
// Stop bit bug19 fixed19.
// Parity19 bug19 fixed19.
// WISHBONE19 read cycle bug19 fixed19,
// OE19 indicator19 (Overrun19 Error) bug19 fixed19.
// PE19 indicator19 (Parity19 Error) bug19 fixed19.
// Register read bug19 fixed19.
//
// Revision19 1.3  2001/05/31 20:08:01  gorban19
// FIFO changes19 and other corrections19.
//
// Revision19 1.3  2001/05/27 17:37:48  gorban19
// Fixed19 many19 bugs19. Updated19 spec19. Changed19 FIFO files structure19. See CHANGES19.txt19 file.
//
// Revision19 1.2  2001/05/17 18:34:18  gorban19
// First19 'stable' release. Should19 be sythesizable19 now. Also19 added new header.
//
// Revision19 1.0  2001-05-17 21:27:12+02  jacob19
// Initial19 revision19
//
//

// synopsys19 translate_off19
`include "timescale.v"
// synopsys19 translate_on19

`include "uart_defines19.v"

module uart_tfifo19 (clk19, 
	wb_rst_i19, data_in19, data_out19,
// Control19 signals19
	push19, // push19 strobe19, active high19
	pop19,   // pop19 strobe19, active high19
// status signals19
	overrun19,
	count,
	fifo_reset19,
	reset_status19
	);


// FIFO parameters19
parameter fifo_width19 = `UART_FIFO_WIDTH19;
parameter fifo_depth19 = `UART_FIFO_DEPTH19;
parameter fifo_pointer_w19 = `UART_FIFO_POINTER_W19;
parameter fifo_counter_w19 = `UART_FIFO_COUNTER_W19;

input				clk19;
input				wb_rst_i19;
input				push19;
input				pop19;
input	[fifo_width19-1:0]	data_in19;
input				fifo_reset19;
input       reset_status19;

output	[fifo_width19-1:0]	data_out19;
output				overrun19;
output	[fifo_counter_w19-1:0]	count;

wire	[fifo_width19-1:0]	data_out19;

// FIFO pointers19
reg	[fifo_pointer_w19-1:0]	top;
reg	[fifo_pointer_w19-1:0]	bottom19;

reg	[fifo_counter_w19-1:0]	count;
reg				overrun19;
wire [fifo_pointer_w19-1:0] top_plus_119 = top + 1'b1;

raminfr19 #(fifo_pointer_w19,fifo_width19,fifo_depth19) tfifo19  
        (.clk19(clk19), 
			.we19(push19), 
			.a(top), 
			.dpra19(bottom19), 
			.di19(data_in19), 
			.dpo19(data_out19)
		); 


always @(posedge clk19 or posedge wb_rst_i19) // synchronous19 FIFO
begin
	if (wb_rst_i19)
	begin
		top		<= #1 0;
		bottom19		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset19) begin
		top		<= #1 0;
		bottom19		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push19, pop19})
		2'b10 : if (count<fifo_depth19)  // overrun19 condition
			begin
				top       <= #1 top_plus_119;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom19   <= #1 bottom19 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom19   <= #1 bottom19 + 1'b1;
				top       <= #1 top_plus_119;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk19 or posedge wb_rst_i19) // synchronous19 FIFO
begin
  if (wb_rst_i19)
    overrun19   <= #1 1'b0;
  else
  if(fifo_reset19 | reset_status19) 
    overrun19   <= #1 1'b0;
  else
  if(push19 & (count==fifo_depth19))
    overrun19   <= #1 1'b1;
end   // always

endmodule
