//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo26.v (Modified26 from uart_fifo26.v)                    ////
////                                                              ////
////                                                              ////
////  This26 file is part of the "UART26 16550 compatible26" project26    ////
////  http26://www26.opencores26.org26/cores26/uart1655026/                   ////
////                                                              ////
////  Documentation26 related26 to this project26:                      ////
////  - http26://www26.opencores26.org26/cores26/uart1655026/                 ////
////                                                              ////
////  Projects26 compatibility26:                                     ////
////  - WISHBONE26                                                  ////
////  RS23226 Protocol26                                              ////
////  16550D uart26 (mostly26 supported)                              ////
////                                                              ////
////  Overview26 (main26 Features26):                                   ////
////  UART26 core26 receiver26 FIFO                                     ////
////                                                              ////
////  To26 Do26:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author26(s):                                                  ////
////      - gorban26@opencores26.org26                                  ////
////      - Jacob26 Gorban26                                          ////
////      - Igor26 Mohor26 (igorm26@opencores26.org26)                      ////
////                                                              ////
////  Created26:        2001/05/12                                  ////
////  Last26 Updated26:   2002/07/22                                  ////
////                  (See log26 for the revision26 history26)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2000, 2001 Authors26                             ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS26 Revision26 History26
//
// $Log: not supported by cvs2svn26 $
// Revision26 1.3  2003/06/11 16:37:47  gorban26
// This26 fixes26 errors26 in some26 cases26 when data is being read and put to the FIFO at the same time. Patch26 is submitted26 by Scott26 Furman26. Update is very26 recommended26.
//
// Revision26 1.2  2002/07/29 21:16:18  gorban26
// The uart_defines26.v file is included26 again26 in sources26.
//
// Revision26 1.1  2002/07/22 23:02:23  gorban26
// Bug26 Fixes26:
//  * Possible26 loss of sync and bad26 reception26 of stop bit on slow26 baud26 rates26 fixed26.
//   Problem26 reported26 by Kenny26.Tung26.
//  * Bad (or lack26 of ) loopback26 handling26 fixed26. Reported26 by Cherry26 Withers26.
//
// Improvements26:
//  * Made26 FIFO's as general26 inferrable26 memory where possible26.
//  So26 on FPGA26 they should be inferred26 as RAM26 (Distributed26 RAM26 on Xilinx26).
//  This26 saves26 about26 1/3 of the Slice26 count and reduces26 P&R and synthesis26 times.
//
//  * Added26 optional26 baudrate26 output (baud_o26).
//  This26 is identical26 to BAUDOUT26* signal26 on 16550 chip26.
//  It outputs26 16xbit_clock_rate - the divided26 clock26.
//  It's disabled by default. Define26 UART_HAS_BAUDRATE_OUTPUT26 to use.
//
// Revision26 1.16  2001/12/20 13:25:46  mohor26
// rx26 push26 changed to be only one cycle wide26.
//
// Revision26 1.15  2001/12/18 09:01:07  mohor26
// Bug26 that was entered26 in the last update fixed26 (rx26 state machine26).
//
// Revision26 1.14  2001/12/17 14:46:48  mohor26
// overrun26 signal26 was moved to separate26 block because many26 sequential26 lsr26
// reads were26 preventing26 data from being written26 to rx26 fifo.
// underrun26 signal26 was not used and was removed from the project26.
//
// Revision26 1.13  2001/11/26 21:38:54  gorban26
// Lots26 of fixes26:
// Break26 condition wasn26't handled26 correctly at all.
// LSR26 bits could lose26 their26 values.
// LSR26 value after reset was wrong26.
// Timing26 of THRE26 interrupt26 signal26 corrected26.
// LSR26 bit 0 timing26 corrected26.
//
// Revision26 1.12  2001/11/08 14:54:23  mohor26
// Comments26 in Slovene26 language26 deleted26, few26 small fixes26 for better26 work26 of
// old26 tools26. IRQs26 need to be fix26.
//
// Revision26 1.11  2001/11/07 17:51:52  gorban26
// Heavily26 rewritten26 interrupt26 and LSR26 subsystems26.
// Many26 bugs26 hopefully26 squashed26.
//
// Revision26 1.10  2001/10/20 09:58:40  gorban26
// Small26 synopsis26 fixes26
//
// Revision26 1.9  2001/08/24 21:01:12  mohor26
// Things26 connected26 to parity26 changed.
// Clock26 devider26 changed.
//
// Revision26 1.8  2001/08/24 08:48:10  mohor26
// FIFO was not cleared26 after the data was read bug26 fixed26.
//
// Revision26 1.7  2001/08/23 16:05:05  mohor26
// Stop bit bug26 fixed26.
// Parity26 bug26 fixed26.
// WISHBONE26 read cycle bug26 fixed26,
// OE26 indicator26 (Overrun26 Error) bug26 fixed26.
// PE26 indicator26 (Parity26 Error) bug26 fixed26.
// Register read bug26 fixed26.
//
// Revision26 1.3  2001/05/31 20:08:01  gorban26
// FIFO changes26 and other corrections26.
//
// Revision26 1.3  2001/05/27 17:37:48  gorban26
// Fixed26 many26 bugs26. Updated26 spec26. Changed26 FIFO files structure26. See CHANGES26.txt26 file.
//
// Revision26 1.2  2001/05/17 18:34:18  gorban26
// First26 'stable' release. Should26 be sythesizable26 now. Also26 added new header.
//
// Revision26 1.0  2001-05-17 21:27:12+02  jacob26
// Initial26 revision26
//
//

// synopsys26 translate_off26
`include "timescale.v"
// synopsys26 translate_on26

`include "uart_defines26.v"

module uart_rfifo26 (clk26, 
	wb_rst_i26, data_in26, data_out26,
// Control26 signals26
	push26, // push26 strobe26, active high26
	pop26,   // pop26 strobe26, active high26
// status signals26
	overrun26,
	count,
	error_bit26,
	fifo_reset26,
	reset_status26
	);


// FIFO parameters26
parameter fifo_width26 = `UART_FIFO_WIDTH26;
parameter fifo_depth26 = `UART_FIFO_DEPTH26;
parameter fifo_pointer_w26 = `UART_FIFO_POINTER_W26;
parameter fifo_counter_w26 = `UART_FIFO_COUNTER_W26;

input				clk26;
input				wb_rst_i26;
input				push26;
input				pop26;
input	[fifo_width26-1:0]	data_in26;
input				fifo_reset26;
input       reset_status26;

output	[fifo_width26-1:0]	data_out26;
output				overrun26;
output	[fifo_counter_w26-1:0]	count;
output				error_bit26;

wire	[fifo_width26-1:0]	data_out26;
wire [7:0] data8_out26;
// flags26 FIFO
reg	[2:0]	fifo[fifo_depth26-1:0];

// FIFO pointers26
reg	[fifo_pointer_w26-1:0]	top;
reg	[fifo_pointer_w26-1:0]	bottom26;

reg	[fifo_counter_w26-1:0]	count;
reg				overrun26;

wire [fifo_pointer_w26-1:0] top_plus_126 = top + 1'b1;

raminfr26 #(fifo_pointer_w26,8,fifo_depth26) rfifo26  
        (.clk26(clk26), 
			.we26(push26), 
			.a(top), 
			.dpra26(bottom26), 
			.di26(data_in26[fifo_width26-1:fifo_width26-8]), 
			.dpo26(data8_out26)
		); 

always @(posedge clk26 or posedge wb_rst_i26) // synchronous26 FIFO
begin
	if (wb_rst_i26)
	begin
		top		<= #1 0;
		bottom26		<= #1 1'b0;
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
	if (fifo_reset26) begin
		top		<= #1 0;
		bottom26		<= #1 1'b0;
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
		case ({push26, pop26})
		2'b10 : if (count<fifo_depth26)  // overrun26 condition
			begin
				top       <= #1 top_plus_126;
				fifo[top] <= #1 data_in26[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom26] <= #1 0;
				bottom26   <= #1 bottom26 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom26   <= #1 bottom26 + 1'b1;
				top       <= #1 top_plus_126;
				fifo[top] <= #1 data_in26[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk26 or posedge wb_rst_i26) // synchronous26 FIFO
begin
  if (wb_rst_i26)
    overrun26   <= #1 1'b0;
  else
  if(fifo_reset26 | reset_status26) 
    overrun26   <= #1 1'b0;
  else
  if(push26 & ~pop26 & (count==fifo_depth26))
    overrun26   <= #1 1'b1;
end   // always


// please26 note26 though26 that data_out26 is only valid one clock26 after pop26 signal26
assign data_out26 = {data8_out26,fifo[bottom26]};

// Additional26 logic for detection26 of error conditions26 (parity26 and framing26) inside the FIFO
// for the Line26 Status Register bit 7

wire	[2:0]	word026 = fifo[0];
wire	[2:0]	word126 = fifo[1];
wire	[2:0]	word226 = fifo[2];
wire	[2:0]	word326 = fifo[3];
wire	[2:0]	word426 = fifo[4];
wire	[2:0]	word526 = fifo[5];
wire	[2:0]	word626 = fifo[6];
wire	[2:0]	word726 = fifo[7];

wire	[2:0]	word826 = fifo[8];
wire	[2:0]	word926 = fifo[9];
wire	[2:0]	word1026 = fifo[10];
wire	[2:0]	word1126 = fifo[11];
wire	[2:0]	word1226 = fifo[12];
wire	[2:0]	word1326 = fifo[13];
wire	[2:0]	word1426 = fifo[14];
wire	[2:0]	word1526 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit26 = |(word026[2:0]  | word126[2:0]  | word226[2:0]  | word326[2:0]  |
            		      word426[2:0]  | word526[2:0]  | word626[2:0]  | word726[2:0]  |
            		      word826[2:0]  | word926[2:0]  | word1026[2:0] | word1126[2:0] |
            		      word1226[2:0] | word1326[2:0] | word1426[2:0] | word1526[2:0] );

endmodule
