//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo10.v                                                ////
////                                                              ////
////                                                              ////
////  This10 file is part of the "UART10 16550 compatible10" project10    ////
////  http10://www10.opencores10.org10/cores10/uart1655010/                   ////
////                                                              ////
////  Documentation10 related10 to this project10:                      ////
////  - http10://www10.opencores10.org10/cores10/uart1655010/                 ////
////                                                              ////
////  Projects10 compatibility10:                                     ////
////  - WISHBONE10                                                  ////
////  RS23210 Protocol10                                              ////
////  16550D uart10 (mostly10 supported)                              ////
////                                                              ////
////  Overview10 (main10 Features10):                                   ////
////  UART10 core10 transmitter10 FIFO                                  ////
////                                                              ////
////  To10 Do10:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author10(s):                                                  ////
////      - gorban10@opencores10.org10                                  ////
////      - Jacob10 Gorban10                                          ////
////      - Igor10 Mohor10 (igorm10@opencores10.org10)                      ////
////                                                              ////
////  Created10:        2001/05/12                                  ////
////  Last10 Updated10:   2002/07/22                                  ////
////                  (See log10 for the revision10 history10)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright10 (C) 2000, 2001 Authors10                             ////
////                                                              ////
//// This10 source10 file may be used and distributed10 without         ////
//// restriction10 provided that this copyright10 statement10 is not    ////
//// removed from the file and that any derivative10 work10 contains10  ////
//// the original copyright10 notice10 and the associated disclaimer10. ////
////                                                              ////
//// This10 source10 file is free software10; you can redistribute10 it   ////
//// and/or modify it under the terms10 of the GNU10 Lesser10 General10   ////
//// Public10 License10 as published10 by the Free10 Software10 Foundation10; ////
//// either10 version10 2.1 of the License10, or (at your10 option) any   ////
//// later10 version10.                                               ////
////                                                              ////
//// This10 source10 is distributed10 in the hope10 that it will be       ////
//// useful10, but WITHOUT10 ANY10 WARRANTY10; without even10 the implied10   ////
//// warranty10 of MERCHANTABILITY10 or FITNESS10 FOR10 A PARTICULAR10      ////
//// PURPOSE10.  See the GNU10 Lesser10 General10 Public10 License10 for more ////
//// details10.                                                     ////
////                                                              ////
//// You should have received10 a copy of the GNU10 Lesser10 General10    ////
//// Public10 License10 along10 with this source10; if not, download10 it   ////
//// from http10://www10.opencores10.org10/lgpl10.shtml10                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS10 Revision10 History10
//
// $Log: not supported by cvs2svn10 $
// Revision10 1.1  2002/07/22 23:02:23  gorban10
// Bug10 Fixes10:
//  * Possible10 loss of sync and bad10 reception10 of stop bit on slow10 baud10 rates10 fixed10.
//   Problem10 reported10 by Kenny10.Tung10.
//  * Bad (or lack10 of ) loopback10 handling10 fixed10. Reported10 by Cherry10 Withers10.
//
// Improvements10:
//  * Made10 FIFO's as general10 inferrable10 memory where possible10.
//  So10 on FPGA10 they should be inferred10 as RAM10 (Distributed10 RAM10 on Xilinx10).
//  This10 saves10 about10 1/3 of the Slice10 count and reduces10 P&R and synthesis10 times.
//
//  * Added10 optional10 baudrate10 output (baud_o10).
//  This10 is identical10 to BAUDOUT10* signal10 on 16550 chip10.
//  It outputs10 16xbit_clock_rate - the divided10 clock10.
//  It's disabled by default. Define10 UART_HAS_BAUDRATE_OUTPUT10 to use.
//
// Revision10 1.16  2001/12/20 13:25:46  mohor10
// rx10 push10 changed to be only one cycle wide10.
//
// Revision10 1.15  2001/12/18 09:01:07  mohor10
// Bug10 that was entered10 in the last update fixed10 (rx10 state machine10).
//
// Revision10 1.14  2001/12/17 14:46:48  mohor10
// overrun10 signal10 was moved to separate10 block because many10 sequential10 lsr10
// reads were10 preventing10 data from being written10 to rx10 fifo.
// underrun10 signal10 was not used and was removed from the project10.
//
// Revision10 1.13  2001/11/26 21:38:54  gorban10
// Lots10 of fixes10:
// Break10 condition wasn10't handled10 correctly at all.
// LSR10 bits could lose10 their10 values.
// LSR10 value after reset was wrong10.
// Timing10 of THRE10 interrupt10 signal10 corrected10.
// LSR10 bit 0 timing10 corrected10.
//
// Revision10 1.12  2001/11/08 14:54:23  mohor10
// Comments10 in Slovene10 language10 deleted10, few10 small fixes10 for better10 work10 of
// old10 tools10. IRQs10 need to be fix10.
//
// Revision10 1.11  2001/11/07 17:51:52  gorban10
// Heavily10 rewritten10 interrupt10 and LSR10 subsystems10.
// Many10 bugs10 hopefully10 squashed10.
//
// Revision10 1.10  2001/10/20 09:58:40  gorban10
// Small10 synopsis10 fixes10
//
// Revision10 1.9  2001/08/24 21:01:12  mohor10
// Things10 connected10 to parity10 changed.
// Clock10 devider10 changed.
//
// Revision10 1.8  2001/08/24 08:48:10  mohor10
// FIFO was not cleared10 after the data was read bug10 fixed10.
//
// Revision10 1.7  2001/08/23 16:05:05  mohor10
// Stop bit bug10 fixed10.
// Parity10 bug10 fixed10.
// WISHBONE10 read cycle bug10 fixed10,
// OE10 indicator10 (Overrun10 Error) bug10 fixed10.
// PE10 indicator10 (Parity10 Error) bug10 fixed10.
// Register read bug10 fixed10.
//
// Revision10 1.3  2001/05/31 20:08:01  gorban10
// FIFO changes10 and other corrections10.
//
// Revision10 1.3  2001/05/27 17:37:48  gorban10
// Fixed10 many10 bugs10. Updated10 spec10. Changed10 FIFO files structure10. See CHANGES10.txt10 file.
//
// Revision10 1.2  2001/05/17 18:34:18  gorban10
// First10 'stable' release. Should10 be sythesizable10 now. Also10 added new header.
//
// Revision10 1.0  2001-05-17 21:27:12+02  jacob10
// Initial10 revision10
//
//

// synopsys10 translate_off10
`include "timescale.v"
// synopsys10 translate_on10

`include "uart_defines10.v"

module uart_tfifo10 (clk10, 
	wb_rst_i10, data_in10, data_out10,
// Control10 signals10
	push10, // push10 strobe10, active high10
	pop10,   // pop10 strobe10, active high10
// status signals10
	overrun10,
	count,
	fifo_reset10,
	reset_status10
	);


// FIFO parameters10
parameter fifo_width10 = `UART_FIFO_WIDTH10;
parameter fifo_depth10 = `UART_FIFO_DEPTH10;
parameter fifo_pointer_w10 = `UART_FIFO_POINTER_W10;
parameter fifo_counter_w10 = `UART_FIFO_COUNTER_W10;

input				clk10;
input				wb_rst_i10;
input				push10;
input				pop10;
input	[fifo_width10-1:0]	data_in10;
input				fifo_reset10;
input       reset_status10;

output	[fifo_width10-1:0]	data_out10;
output				overrun10;
output	[fifo_counter_w10-1:0]	count;

wire	[fifo_width10-1:0]	data_out10;

// FIFO pointers10
reg	[fifo_pointer_w10-1:0]	top;
reg	[fifo_pointer_w10-1:0]	bottom10;

reg	[fifo_counter_w10-1:0]	count;
reg				overrun10;
wire [fifo_pointer_w10-1:0] top_plus_110 = top + 1'b1;

raminfr10 #(fifo_pointer_w10,fifo_width10,fifo_depth10) tfifo10  
        (.clk10(clk10), 
			.we10(push10), 
			.a(top), 
			.dpra10(bottom10), 
			.di10(data_in10), 
			.dpo10(data_out10)
		); 


always @(posedge clk10 or posedge wb_rst_i10) // synchronous10 FIFO
begin
	if (wb_rst_i10)
	begin
		top		<= #1 0;
		bottom10		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset10) begin
		top		<= #1 0;
		bottom10		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push10, pop10})
		2'b10 : if (count<fifo_depth10)  // overrun10 condition
			begin
				top       <= #1 top_plus_110;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom10   <= #1 bottom10 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom10   <= #1 bottom10 + 1'b1;
				top       <= #1 top_plus_110;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk10 or posedge wb_rst_i10) // synchronous10 FIFO
begin
  if (wb_rst_i10)
    overrun10   <= #1 1'b0;
  else
  if(fifo_reset10 | reset_status10) 
    overrun10   <= #1 1'b0;
  else
  if(push10 & (count==fifo_depth10))
    overrun10   <= #1 1'b1;
end   // always

endmodule
