//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo28.v (Modified28 from uart_fifo28.v)                    ////
////                                                              ////
////                                                              ////
////  This28 file is part of the "UART28 16550 compatible28" project28    ////
////  http28://www28.opencores28.org28/cores28/uart1655028/                   ////
////                                                              ////
////  Documentation28 related28 to this project28:                      ////
////  - http28://www28.opencores28.org28/cores28/uart1655028/                 ////
////                                                              ////
////  Projects28 compatibility28:                                     ////
////  - WISHBONE28                                                  ////
////  RS23228 Protocol28                                              ////
////  16550D uart28 (mostly28 supported)                              ////
////                                                              ////
////  Overview28 (main28 Features28):                                   ////
////  UART28 core28 receiver28 FIFO                                     ////
////                                                              ////
////  To28 Do28:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author28(s):                                                  ////
////      - gorban28@opencores28.org28                                  ////
////      - Jacob28 Gorban28                                          ////
////      - Igor28 Mohor28 (igorm28@opencores28.org28)                      ////
////                                                              ////
////  Created28:        2001/05/12                                  ////
////  Last28 Updated28:   2002/07/22                                  ////
////                  (See log28 for the revision28 history28)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2000, 2001 Authors28                             ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS28 Revision28 History28
//
// $Log: not supported by cvs2svn28 $
// Revision28 1.3  2003/06/11 16:37:47  gorban28
// This28 fixes28 errors28 in some28 cases28 when data is being read and put to the FIFO at the same time. Patch28 is submitted28 by Scott28 Furman28. Update is very28 recommended28.
//
// Revision28 1.2  2002/07/29 21:16:18  gorban28
// The uart_defines28.v file is included28 again28 in sources28.
//
// Revision28 1.1  2002/07/22 23:02:23  gorban28
// Bug28 Fixes28:
//  * Possible28 loss of sync and bad28 reception28 of stop bit on slow28 baud28 rates28 fixed28.
//   Problem28 reported28 by Kenny28.Tung28.
//  * Bad (or lack28 of ) loopback28 handling28 fixed28. Reported28 by Cherry28 Withers28.
//
// Improvements28:
//  * Made28 FIFO's as general28 inferrable28 memory where possible28.
//  So28 on FPGA28 they should be inferred28 as RAM28 (Distributed28 RAM28 on Xilinx28).
//  This28 saves28 about28 1/3 of the Slice28 count and reduces28 P&R and synthesis28 times.
//
//  * Added28 optional28 baudrate28 output (baud_o28).
//  This28 is identical28 to BAUDOUT28* signal28 on 16550 chip28.
//  It outputs28 16xbit_clock_rate - the divided28 clock28.
//  It's disabled by default. Define28 UART_HAS_BAUDRATE_OUTPUT28 to use.
//
// Revision28 1.16  2001/12/20 13:25:46  mohor28
// rx28 push28 changed to be only one cycle wide28.
//
// Revision28 1.15  2001/12/18 09:01:07  mohor28
// Bug28 that was entered28 in the last update fixed28 (rx28 state machine28).
//
// Revision28 1.14  2001/12/17 14:46:48  mohor28
// overrun28 signal28 was moved to separate28 block because many28 sequential28 lsr28
// reads were28 preventing28 data from being written28 to rx28 fifo.
// underrun28 signal28 was not used and was removed from the project28.
//
// Revision28 1.13  2001/11/26 21:38:54  gorban28
// Lots28 of fixes28:
// Break28 condition wasn28't handled28 correctly at all.
// LSR28 bits could lose28 their28 values.
// LSR28 value after reset was wrong28.
// Timing28 of THRE28 interrupt28 signal28 corrected28.
// LSR28 bit 0 timing28 corrected28.
//
// Revision28 1.12  2001/11/08 14:54:23  mohor28
// Comments28 in Slovene28 language28 deleted28, few28 small fixes28 for better28 work28 of
// old28 tools28. IRQs28 need to be fix28.
//
// Revision28 1.11  2001/11/07 17:51:52  gorban28
// Heavily28 rewritten28 interrupt28 and LSR28 subsystems28.
// Many28 bugs28 hopefully28 squashed28.
//
// Revision28 1.10  2001/10/20 09:58:40  gorban28
// Small28 synopsis28 fixes28
//
// Revision28 1.9  2001/08/24 21:01:12  mohor28
// Things28 connected28 to parity28 changed.
// Clock28 devider28 changed.
//
// Revision28 1.8  2001/08/24 08:48:10  mohor28
// FIFO was not cleared28 after the data was read bug28 fixed28.
//
// Revision28 1.7  2001/08/23 16:05:05  mohor28
// Stop bit bug28 fixed28.
// Parity28 bug28 fixed28.
// WISHBONE28 read cycle bug28 fixed28,
// OE28 indicator28 (Overrun28 Error) bug28 fixed28.
// PE28 indicator28 (Parity28 Error) bug28 fixed28.
// Register read bug28 fixed28.
//
// Revision28 1.3  2001/05/31 20:08:01  gorban28
// FIFO changes28 and other corrections28.
//
// Revision28 1.3  2001/05/27 17:37:48  gorban28
// Fixed28 many28 bugs28. Updated28 spec28. Changed28 FIFO files structure28. See CHANGES28.txt28 file.
//
// Revision28 1.2  2001/05/17 18:34:18  gorban28
// First28 'stable' release. Should28 be sythesizable28 now. Also28 added new header.
//
// Revision28 1.0  2001-05-17 21:27:12+02  jacob28
// Initial28 revision28
//
//

// synopsys28 translate_off28
`include "timescale.v"
// synopsys28 translate_on28

`include "uart_defines28.v"

module uart_rfifo28 (clk28, 
	wb_rst_i28, data_in28, data_out28,
// Control28 signals28
	push28, // push28 strobe28, active high28
	pop28,   // pop28 strobe28, active high28
// status signals28
	overrun28,
	count,
	error_bit28,
	fifo_reset28,
	reset_status28
	);


// FIFO parameters28
parameter fifo_width28 = `UART_FIFO_WIDTH28;
parameter fifo_depth28 = `UART_FIFO_DEPTH28;
parameter fifo_pointer_w28 = `UART_FIFO_POINTER_W28;
parameter fifo_counter_w28 = `UART_FIFO_COUNTER_W28;

input				clk28;
input				wb_rst_i28;
input				push28;
input				pop28;
input	[fifo_width28-1:0]	data_in28;
input				fifo_reset28;
input       reset_status28;

output	[fifo_width28-1:0]	data_out28;
output				overrun28;
output	[fifo_counter_w28-1:0]	count;
output				error_bit28;

wire	[fifo_width28-1:0]	data_out28;
wire [7:0] data8_out28;
// flags28 FIFO
reg	[2:0]	fifo[fifo_depth28-1:0];

// FIFO pointers28
reg	[fifo_pointer_w28-1:0]	top;
reg	[fifo_pointer_w28-1:0]	bottom28;

reg	[fifo_counter_w28-1:0]	count;
reg				overrun28;

wire [fifo_pointer_w28-1:0] top_plus_128 = top + 1'b1;

raminfr28 #(fifo_pointer_w28,8,fifo_depth28) rfifo28  
        (.clk28(clk28), 
			.we28(push28), 
			.a(top), 
			.dpra28(bottom28), 
			.di28(data_in28[fifo_width28-1:fifo_width28-8]), 
			.dpo28(data8_out28)
		); 

always @(posedge clk28 or posedge wb_rst_i28) // synchronous28 FIFO
begin
	if (wb_rst_i28)
	begin
		top		<= #1 0;
		bottom28		<= #1 1'b0;
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
	if (fifo_reset28) begin
		top		<= #1 0;
		bottom28		<= #1 1'b0;
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
		case ({push28, pop28})
		2'b10 : if (count<fifo_depth28)  // overrun28 condition
			begin
				top       <= #1 top_plus_128;
				fifo[top] <= #1 data_in28[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom28] <= #1 0;
				bottom28   <= #1 bottom28 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom28   <= #1 bottom28 + 1'b1;
				top       <= #1 top_plus_128;
				fifo[top] <= #1 data_in28[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk28 or posedge wb_rst_i28) // synchronous28 FIFO
begin
  if (wb_rst_i28)
    overrun28   <= #1 1'b0;
  else
  if(fifo_reset28 | reset_status28) 
    overrun28   <= #1 1'b0;
  else
  if(push28 & ~pop28 & (count==fifo_depth28))
    overrun28   <= #1 1'b1;
end   // always


// please28 note28 though28 that data_out28 is only valid one clock28 after pop28 signal28
assign data_out28 = {data8_out28,fifo[bottom28]};

// Additional28 logic for detection28 of error conditions28 (parity28 and framing28) inside the FIFO
// for the Line28 Status Register bit 7

wire	[2:0]	word028 = fifo[0];
wire	[2:0]	word128 = fifo[1];
wire	[2:0]	word228 = fifo[2];
wire	[2:0]	word328 = fifo[3];
wire	[2:0]	word428 = fifo[4];
wire	[2:0]	word528 = fifo[5];
wire	[2:0]	word628 = fifo[6];
wire	[2:0]	word728 = fifo[7];

wire	[2:0]	word828 = fifo[8];
wire	[2:0]	word928 = fifo[9];
wire	[2:0]	word1028 = fifo[10];
wire	[2:0]	word1128 = fifo[11];
wire	[2:0]	word1228 = fifo[12];
wire	[2:0]	word1328 = fifo[13];
wire	[2:0]	word1428 = fifo[14];
wire	[2:0]	word1528 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit28 = |(word028[2:0]  | word128[2:0]  | word228[2:0]  | word328[2:0]  |
            		      word428[2:0]  | word528[2:0]  | word628[2:0]  | word728[2:0]  |
            		      word828[2:0]  | word928[2:0]  | word1028[2:0] | word1128[2:0] |
            		      word1228[2:0] | word1328[2:0] | word1428[2:0] | word1528[2:0] );

endmodule
