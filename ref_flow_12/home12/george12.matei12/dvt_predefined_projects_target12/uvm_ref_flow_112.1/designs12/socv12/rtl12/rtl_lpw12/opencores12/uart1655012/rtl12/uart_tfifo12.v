//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_tfifo12.v                                                ////
////                                                              ////
////                                                              ////
////  This12 file is part of the "UART12 16550 compatible12" project12    ////
////  http12://www12.opencores12.org12/cores12/uart1655012/                   ////
////                                                              ////
////  Documentation12 related12 to this project12:                      ////
////  - http12://www12.opencores12.org12/cores12/uart1655012/                 ////
////                                                              ////
////  Projects12 compatibility12:                                     ////
////  - WISHBONE12                                                  ////
////  RS23212 Protocol12                                              ////
////  16550D uart12 (mostly12 supported)                              ////
////                                                              ////
////  Overview12 (main12 Features12):                                   ////
////  UART12 core12 transmitter12 FIFO                                  ////
////                                                              ////
////  To12 Do12:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author12(s):                                                  ////
////      - gorban12@opencores12.org12                                  ////
////      - Jacob12 Gorban12                                          ////
////      - Igor12 Mohor12 (igorm12@opencores12.org12)                      ////
////                                                              ////
////  Created12:        2001/05/12                                  ////
////  Last12 Updated12:   2002/07/22                                  ////
////                  (See log12 for the revision12 history12)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright12 (C) 2000, 2001 Authors12                             ////
////                                                              ////
//// This12 source12 file may be used and distributed12 without         ////
//// restriction12 provided that this copyright12 statement12 is not    ////
//// removed from the file and that any derivative12 work12 contains12  ////
//// the original copyright12 notice12 and the associated disclaimer12. ////
////                                                              ////
//// This12 source12 file is free software12; you can redistribute12 it   ////
//// and/or modify it under the terms12 of the GNU12 Lesser12 General12   ////
//// Public12 License12 as published12 by the Free12 Software12 Foundation12; ////
//// either12 version12 2.1 of the License12, or (at your12 option) any   ////
//// later12 version12.                                               ////
////                                                              ////
//// This12 source12 is distributed12 in the hope12 that it will be       ////
//// useful12, but WITHOUT12 ANY12 WARRANTY12; without even12 the implied12   ////
//// warranty12 of MERCHANTABILITY12 or FITNESS12 FOR12 A PARTICULAR12      ////
//// PURPOSE12.  See the GNU12 Lesser12 General12 Public12 License12 for more ////
//// details12.                                                     ////
////                                                              ////
//// You should have received12 a copy of the GNU12 Lesser12 General12    ////
//// Public12 License12 along12 with this source12; if not, download12 it   ////
//// from http12://www12.opencores12.org12/lgpl12.shtml12                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS12 Revision12 History12
//
// $Log: not supported by cvs2svn12 $
// Revision12 1.1  2002/07/22 23:02:23  gorban12
// Bug12 Fixes12:
//  * Possible12 loss of sync and bad12 reception12 of stop bit on slow12 baud12 rates12 fixed12.
//   Problem12 reported12 by Kenny12.Tung12.
//  * Bad (or lack12 of ) loopback12 handling12 fixed12. Reported12 by Cherry12 Withers12.
//
// Improvements12:
//  * Made12 FIFO's as general12 inferrable12 memory where possible12.
//  So12 on FPGA12 they should be inferred12 as RAM12 (Distributed12 RAM12 on Xilinx12).
//  This12 saves12 about12 1/3 of the Slice12 count and reduces12 P&R and synthesis12 times.
//
//  * Added12 optional12 baudrate12 output (baud_o12).
//  This12 is identical12 to BAUDOUT12* signal12 on 16550 chip12.
//  It outputs12 16xbit_clock_rate - the divided12 clock12.
//  It's disabled by default. Define12 UART_HAS_BAUDRATE_OUTPUT12 to use.
//
// Revision12 1.16  2001/12/20 13:25:46  mohor12
// rx12 push12 changed to be only one cycle wide12.
//
// Revision12 1.15  2001/12/18 09:01:07  mohor12
// Bug12 that was entered12 in the last update fixed12 (rx12 state machine12).
//
// Revision12 1.14  2001/12/17 14:46:48  mohor12
// overrun12 signal12 was moved to separate12 block because many12 sequential12 lsr12
// reads were12 preventing12 data from being written12 to rx12 fifo.
// underrun12 signal12 was not used and was removed from the project12.
//
// Revision12 1.13  2001/11/26 21:38:54  gorban12
// Lots12 of fixes12:
// Break12 condition wasn12't handled12 correctly at all.
// LSR12 bits could lose12 their12 values.
// LSR12 value after reset was wrong12.
// Timing12 of THRE12 interrupt12 signal12 corrected12.
// LSR12 bit 0 timing12 corrected12.
//
// Revision12 1.12  2001/11/08 14:54:23  mohor12
// Comments12 in Slovene12 language12 deleted12, few12 small fixes12 for better12 work12 of
// old12 tools12. IRQs12 need to be fix12.
//
// Revision12 1.11  2001/11/07 17:51:52  gorban12
// Heavily12 rewritten12 interrupt12 and LSR12 subsystems12.
// Many12 bugs12 hopefully12 squashed12.
//
// Revision12 1.10  2001/10/20 09:58:40  gorban12
// Small12 synopsis12 fixes12
//
// Revision12 1.9  2001/08/24 21:01:12  mohor12
// Things12 connected12 to parity12 changed.
// Clock12 devider12 changed.
//
// Revision12 1.8  2001/08/24 08:48:10  mohor12
// FIFO was not cleared12 after the data was read bug12 fixed12.
//
// Revision12 1.7  2001/08/23 16:05:05  mohor12
// Stop bit bug12 fixed12.
// Parity12 bug12 fixed12.
// WISHBONE12 read cycle bug12 fixed12,
// OE12 indicator12 (Overrun12 Error) bug12 fixed12.
// PE12 indicator12 (Parity12 Error) bug12 fixed12.
// Register read bug12 fixed12.
//
// Revision12 1.3  2001/05/31 20:08:01  gorban12
// FIFO changes12 and other corrections12.
//
// Revision12 1.3  2001/05/27 17:37:48  gorban12
// Fixed12 many12 bugs12. Updated12 spec12. Changed12 FIFO files structure12. See CHANGES12.txt12 file.
//
// Revision12 1.2  2001/05/17 18:34:18  gorban12
// First12 'stable' release. Should12 be sythesizable12 now. Also12 added new header.
//
// Revision12 1.0  2001-05-17 21:27:12+02  jacob12
// Initial12 revision12
//
//

// synopsys12 translate_off12
`include "timescale.v"
// synopsys12 translate_on12

`include "uart_defines12.v"

module uart_tfifo12 (clk12, 
	wb_rst_i12, data_in12, data_out12,
// Control12 signals12
	push12, // push12 strobe12, active high12
	pop12,   // pop12 strobe12, active high12
// status signals12
	overrun12,
	count,
	fifo_reset12,
	reset_status12
	);


// FIFO parameters12
parameter fifo_width12 = `UART_FIFO_WIDTH12;
parameter fifo_depth12 = `UART_FIFO_DEPTH12;
parameter fifo_pointer_w12 = `UART_FIFO_POINTER_W12;
parameter fifo_counter_w12 = `UART_FIFO_COUNTER_W12;

input				clk12;
input				wb_rst_i12;
input				push12;
input				pop12;
input	[fifo_width12-1:0]	data_in12;
input				fifo_reset12;
input       reset_status12;

output	[fifo_width12-1:0]	data_out12;
output				overrun12;
output	[fifo_counter_w12-1:0]	count;

wire	[fifo_width12-1:0]	data_out12;

// FIFO pointers12
reg	[fifo_pointer_w12-1:0]	top;
reg	[fifo_pointer_w12-1:0]	bottom12;

reg	[fifo_counter_w12-1:0]	count;
reg				overrun12;
wire [fifo_pointer_w12-1:0] top_plus_112 = top + 1'b1;

raminfr12 #(fifo_pointer_w12,fifo_width12,fifo_depth12) tfifo12  
        (.clk12(clk12), 
			.we12(push12), 
			.a(top), 
			.dpra12(bottom12), 
			.di12(data_in12), 
			.dpo12(data_out12)
		); 


always @(posedge clk12 or posedge wb_rst_i12) // synchronous12 FIFO
begin
	if (wb_rst_i12)
	begin
		top		<= #1 0;
		bottom12		<= #1 1'b0;
		count		<= #1 0;
	end
	else
	if (fifo_reset12) begin
		top		<= #1 0;
		bottom12		<= #1 1'b0;
		count		<= #1 0;
	end
  else
	begin
		case ({push12, pop12})
		2'b10 : if (count<fifo_depth12)  // overrun12 condition
			begin
				top       <= #1 top_plus_112;
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
				bottom12   <= #1 bottom12 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom12   <= #1 bottom12 + 1'b1;
				top       <= #1 top_plus_112;
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk12 or posedge wb_rst_i12) // synchronous12 FIFO
begin
  if (wb_rst_i12)
    overrun12   <= #1 1'b0;
  else
  if(fifo_reset12 | reset_status12) 
    overrun12   <= #1 1'b0;
  else
  if(push12 & (count==fifo_depth12))
    overrun12   <= #1 1'b1;
end   // always

endmodule
