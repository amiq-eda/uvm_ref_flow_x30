//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo5.v (Modified5 from uart_fifo5.v)                    ////
////                                                              ////
////                                                              ////
////  This5 file is part of the "UART5 16550 compatible5" project5    ////
////  http5://www5.opencores5.org5/cores5/uart165505/                   ////
////                                                              ////
////  Documentation5 related5 to this project5:                      ////
////  - http5://www5.opencores5.org5/cores5/uart165505/                 ////
////                                                              ////
////  Projects5 compatibility5:                                     ////
////  - WISHBONE5                                                  ////
////  RS2325 Protocol5                                              ////
////  16550D uart5 (mostly5 supported)                              ////
////                                                              ////
////  Overview5 (main5 Features5):                                   ////
////  UART5 core5 receiver5 FIFO                                     ////
////                                                              ////
////  To5 Do5:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author5(s):                                                  ////
////      - gorban5@opencores5.org5                                  ////
////      - Jacob5 Gorban5                                          ////
////      - Igor5 Mohor5 (igorm5@opencores5.org5)                      ////
////                                                              ////
////  Created5:        2001/05/12                                  ////
////  Last5 Updated5:   2002/07/22                                  ////
////                  (See log5 for the revision5 history5)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2000, 2001 Authors5                             ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS5 Revision5 History5
//
// $Log: not supported by cvs2svn5 $
// Revision5 1.3  2003/06/11 16:37:47  gorban5
// This5 fixes5 errors5 in some5 cases5 when data is being read and put to the FIFO at the same time. Patch5 is submitted5 by Scott5 Furman5. Update is very5 recommended5.
//
// Revision5 1.2  2002/07/29 21:16:18  gorban5
// The uart_defines5.v file is included5 again5 in sources5.
//
// Revision5 1.1  2002/07/22 23:02:23  gorban5
// Bug5 Fixes5:
//  * Possible5 loss of sync and bad5 reception5 of stop bit on slow5 baud5 rates5 fixed5.
//   Problem5 reported5 by Kenny5.Tung5.
//  * Bad (or lack5 of ) loopback5 handling5 fixed5. Reported5 by Cherry5 Withers5.
//
// Improvements5:
//  * Made5 FIFO's as general5 inferrable5 memory where possible5.
//  So5 on FPGA5 they should be inferred5 as RAM5 (Distributed5 RAM5 on Xilinx5).
//  This5 saves5 about5 1/3 of the Slice5 count and reduces5 P&R and synthesis5 times.
//
//  * Added5 optional5 baudrate5 output (baud_o5).
//  This5 is identical5 to BAUDOUT5* signal5 on 16550 chip5.
//  It outputs5 16xbit_clock_rate - the divided5 clock5.
//  It's disabled by default. Define5 UART_HAS_BAUDRATE_OUTPUT5 to use.
//
// Revision5 1.16  2001/12/20 13:25:46  mohor5
// rx5 push5 changed to be only one cycle wide5.
//
// Revision5 1.15  2001/12/18 09:01:07  mohor5
// Bug5 that was entered5 in the last update fixed5 (rx5 state machine5).
//
// Revision5 1.14  2001/12/17 14:46:48  mohor5
// overrun5 signal5 was moved to separate5 block because many5 sequential5 lsr5
// reads were5 preventing5 data from being written5 to rx5 fifo.
// underrun5 signal5 was not used and was removed from the project5.
//
// Revision5 1.13  2001/11/26 21:38:54  gorban5
// Lots5 of fixes5:
// Break5 condition wasn5't handled5 correctly at all.
// LSR5 bits could lose5 their5 values.
// LSR5 value after reset was wrong5.
// Timing5 of THRE5 interrupt5 signal5 corrected5.
// LSR5 bit 0 timing5 corrected5.
//
// Revision5 1.12  2001/11/08 14:54:23  mohor5
// Comments5 in Slovene5 language5 deleted5, few5 small fixes5 for better5 work5 of
// old5 tools5. IRQs5 need to be fix5.
//
// Revision5 1.11  2001/11/07 17:51:52  gorban5
// Heavily5 rewritten5 interrupt5 and LSR5 subsystems5.
// Many5 bugs5 hopefully5 squashed5.
//
// Revision5 1.10  2001/10/20 09:58:40  gorban5
// Small5 synopsis5 fixes5
//
// Revision5 1.9  2001/08/24 21:01:12  mohor5
// Things5 connected5 to parity5 changed.
// Clock5 devider5 changed.
//
// Revision5 1.8  2001/08/24 08:48:10  mohor5
// FIFO was not cleared5 after the data was read bug5 fixed5.
//
// Revision5 1.7  2001/08/23 16:05:05  mohor5
// Stop bit bug5 fixed5.
// Parity5 bug5 fixed5.
// WISHBONE5 read cycle bug5 fixed5,
// OE5 indicator5 (Overrun5 Error) bug5 fixed5.
// PE5 indicator5 (Parity5 Error) bug5 fixed5.
// Register read bug5 fixed5.
//
// Revision5 1.3  2001/05/31 20:08:01  gorban5
// FIFO changes5 and other corrections5.
//
// Revision5 1.3  2001/05/27 17:37:48  gorban5
// Fixed5 many5 bugs5. Updated5 spec5. Changed5 FIFO files structure5. See CHANGES5.txt5 file.
//
// Revision5 1.2  2001/05/17 18:34:18  gorban5
// First5 'stable' release. Should5 be sythesizable5 now. Also5 added new header.
//
// Revision5 1.0  2001-05-17 21:27:12+02  jacob5
// Initial5 revision5
//
//

// synopsys5 translate_off5
`include "timescale.v"
// synopsys5 translate_on5

`include "uart_defines5.v"

module uart_rfifo5 (clk5, 
	wb_rst_i5, data_in5, data_out5,
// Control5 signals5
	push5, // push5 strobe5, active high5
	pop5,   // pop5 strobe5, active high5
// status signals5
	overrun5,
	count,
	error_bit5,
	fifo_reset5,
	reset_status5
	);


// FIFO parameters5
parameter fifo_width5 = `UART_FIFO_WIDTH5;
parameter fifo_depth5 = `UART_FIFO_DEPTH5;
parameter fifo_pointer_w5 = `UART_FIFO_POINTER_W5;
parameter fifo_counter_w5 = `UART_FIFO_COUNTER_W5;

input				clk5;
input				wb_rst_i5;
input				push5;
input				pop5;
input	[fifo_width5-1:0]	data_in5;
input				fifo_reset5;
input       reset_status5;

output	[fifo_width5-1:0]	data_out5;
output				overrun5;
output	[fifo_counter_w5-1:0]	count;
output				error_bit5;

wire	[fifo_width5-1:0]	data_out5;
wire [7:0] data8_out5;
// flags5 FIFO
reg	[2:0]	fifo[fifo_depth5-1:0];

// FIFO pointers5
reg	[fifo_pointer_w5-1:0]	top;
reg	[fifo_pointer_w5-1:0]	bottom5;

reg	[fifo_counter_w5-1:0]	count;
reg				overrun5;

wire [fifo_pointer_w5-1:0] top_plus_15 = top + 1'b1;

raminfr5 #(fifo_pointer_w5,8,fifo_depth5) rfifo5  
        (.clk5(clk5), 
			.we5(push5), 
			.a(top), 
			.dpra5(bottom5), 
			.di5(data_in5[fifo_width5-1:fifo_width5-8]), 
			.dpo5(data8_out5)
		); 

always @(posedge clk5 or posedge wb_rst_i5) // synchronous5 FIFO
begin
	if (wb_rst_i5)
	begin
		top		<= #1 0;
		bottom5		<= #1 1'b0;
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
	if (fifo_reset5) begin
		top		<= #1 0;
		bottom5		<= #1 1'b0;
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
		case ({push5, pop5})
		2'b10 : if (count<fifo_depth5)  // overrun5 condition
			begin
				top       <= #1 top_plus_15;
				fifo[top] <= #1 data_in5[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom5] <= #1 0;
				bottom5   <= #1 bottom5 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom5   <= #1 bottom5 + 1'b1;
				top       <= #1 top_plus_15;
				fifo[top] <= #1 data_in5[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk5 or posedge wb_rst_i5) // synchronous5 FIFO
begin
  if (wb_rst_i5)
    overrun5   <= #1 1'b0;
  else
  if(fifo_reset5 | reset_status5) 
    overrun5   <= #1 1'b0;
  else
  if(push5 & ~pop5 & (count==fifo_depth5))
    overrun5   <= #1 1'b1;
end   // always


// please5 note5 though5 that data_out5 is only valid one clock5 after pop5 signal5
assign data_out5 = {data8_out5,fifo[bottom5]};

// Additional5 logic for detection5 of error conditions5 (parity5 and framing5) inside the FIFO
// for the Line5 Status Register bit 7

wire	[2:0]	word05 = fifo[0];
wire	[2:0]	word15 = fifo[1];
wire	[2:0]	word25 = fifo[2];
wire	[2:0]	word35 = fifo[3];
wire	[2:0]	word45 = fifo[4];
wire	[2:0]	word55 = fifo[5];
wire	[2:0]	word65 = fifo[6];
wire	[2:0]	word75 = fifo[7];

wire	[2:0]	word85 = fifo[8];
wire	[2:0]	word95 = fifo[9];
wire	[2:0]	word105 = fifo[10];
wire	[2:0]	word115 = fifo[11];
wire	[2:0]	word125 = fifo[12];
wire	[2:0]	word135 = fifo[13];
wire	[2:0]	word145 = fifo[14];
wire	[2:0]	word155 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit5 = |(word05[2:0]  | word15[2:0]  | word25[2:0]  | word35[2:0]  |
            		      word45[2:0]  | word55[2:0]  | word65[2:0]  | word75[2:0]  |
            		      word85[2:0]  | word95[2:0]  | word105[2:0] | word115[2:0] |
            		      word125[2:0] | word135[2:0] | word145[2:0] | word155[2:0] );

endmodule
