//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_rfifo23.v (Modified23 from uart_fifo23.v)                    ////
////                                                              ////
////                                                              ////
////  This23 file is part of the "UART23 16550 compatible23" project23    ////
////  http23://www23.opencores23.org23/cores23/uart1655023/                   ////
////                                                              ////
////  Documentation23 related23 to this project23:                      ////
////  - http23://www23.opencores23.org23/cores23/uart1655023/                 ////
////                                                              ////
////  Projects23 compatibility23:                                     ////
////  - WISHBONE23                                                  ////
////  RS23223 Protocol23                                              ////
////  16550D uart23 (mostly23 supported)                              ////
////                                                              ////
////  Overview23 (main23 Features23):                                   ////
////  UART23 core23 receiver23 FIFO                                     ////
////                                                              ////
////  To23 Do23:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author23(s):                                                  ////
////      - gorban23@opencores23.org23                                  ////
////      - Jacob23 Gorban23                                          ////
////      - Igor23 Mohor23 (igorm23@opencores23.org23)                      ////
////                                                              ////
////  Created23:        2001/05/12                                  ////
////  Last23 Updated23:   2002/07/22                                  ////
////                  (See log23 for the revision23 history23)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2000, 2001 Authors23                             ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS23 Revision23 History23
//
// $Log: not supported by cvs2svn23 $
// Revision23 1.3  2003/06/11 16:37:47  gorban23
// This23 fixes23 errors23 in some23 cases23 when data is being read and put to the FIFO at the same time. Patch23 is submitted23 by Scott23 Furman23. Update is very23 recommended23.
//
// Revision23 1.2  2002/07/29 21:16:18  gorban23
// The uart_defines23.v file is included23 again23 in sources23.
//
// Revision23 1.1  2002/07/22 23:02:23  gorban23
// Bug23 Fixes23:
//  * Possible23 loss of sync and bad23 reception23 of stop bit on slow23 baud23 rates23 fixed23.
//   Problem23 reported23 by Kenny23.Tung23.
//  * Bad (or lack23 of ) loopback23 handling23 fixed23. Reported23 by Cherry23 Withers23.
//
// Improvements23:
//  * Made23 FIFO's as general23 inferrable23 memory where possible23.
//  So23 on FPGA23 they should be inferred23 as RAM23 (Distributed23 RAM23 on Xilinx23).
//  This23 saves23 about23 1/3 of the Slice23 count and reduces23 P&R and synthesis23 times.
//
//  * Added23 optional23 baudrate23 output (baud_o23).
//  This23 is identical23 to BAUDOUT23* signal23 on 16550 chip23.
//  It outputs23 16xbit_clock_rate - the divided23 clock23.
//  It's disabled by default. Define23 UART_HAS_BAUDRATE_OUTPUT23 to use.
//
// Revision23 1.16  2001/12/20 13:25:46  mohor23
// rx23 push23 changed to be only one cycle wide23.
//
// Revision23 1.15  2001/12/18 09:01:07  mohor23
// Bug23 that was entered23 in the last update fixed23 (rx23 state machine23).
//
// Revision23 1.14  2001/12/17 14:46:48  mohor23
// overrun23 signal23 was moved to separate23 block because many23 sequential23 lsr23
// reads were23 preventing23 data from being written23 to rx23 fifo.
// underrun23 signal23 was not used and was removed from the project23.
//
// Revision23 1.13  2001/11/26 21:38:54  gorban23
// Lots23 of fixes23:
// Break23 condition wasn23't handled23 correctly at all.
// LSR23 bits could lose23 their23 values.
// LSR23 value after reset was wrong23.
// Timing23 of THRE23 interrupt23 signal23 corrected23.
// LSR23 bit 0 timing23 corrected23.
//
// Revision23 1.12  2001/11/08 14:54:23  mohor23
// Comments23 in Slovene23 language23 deleted23, few23 small fixes23 for better23 work23 of
// old23 tools23. IRQs23 need to be fix23.
//
// Revision23 1.11  2001/11/07 17:51:52  gorban23
// Heavily23 rewritten23 interrupt23 and LSR23 subsystems23.
// Many23 bugs23 hopefully23 squashed23.
//
// Revision23 1.10  2001/10/20 09:58:40  gorban23
// Small23 synopsis23 fixes23
//
// Revision23 1.9  2001/08/24 21:01:12  mohor23
// Things23 connected23 to parity23 changed.
// Clock23 devider23 changed.
//
// Revision23 1.8  2001/08/24 08:48:10  mohor23
// FIFO was not cleared23 after the data was read bug23 fixed23.
//
// Revision23 1.7  2001/08/23 16:05:05  mohor23
// Stop bit bug23 fixed23.
// Parity23 bug23 fixed23.
// WISHBONE23 read cycle bug23 fixed23,
// OE23 indicator23 (Overrun23 Error) bug23 fixed23.
// PE23 indicator23 (Parity23 Error) bug23 fixed23.
// Register read bug23 fixed23.
//
// Revision23 1.3  2001/05/31 20:08:01  gorban23
// FIFO changes23 and other corrections23.
//
// Revision23 1.3  2001/05/27 17:37:48  gorban23
// Fixed23 many23 bugs23. Updated23 spec23. Changed23 FIFO files structure23. See CHANGES23.txt23 file.
//
// Revision23 1.2  2001/05/17 18:34:18  gorban23
// First23 'stable' release. Should23 be sythesizable23 now. Also23 added new header.
//
// Revision23 1.0  2001-05-17 21:27:12+02  jacob23
// Initial23 revision23
//
//

// synopsys23 translate_off23
`include "timescale.v"
// synopsys23 translate_on23

`include "uart_defines23.v"

module uart_rfifo23 (clk23, 
	wb_rst_i23, data_in23, data_out23,
// Control23 signals23
	push23, // push23 strobe23, active high23
	pop23,   // pop23 strobe23, active high23
// status signals23
	overrun23,
	count,
	error_bit23,
	fifo_reset23,
	reset_status23
	);


// FIFO parameters23
parameter fifo_width23 = `UART_FIFO_WIDTH23;
parameter fifo_depth23 = `UART_FIFO_DEPTH23;
parameter fifo_pointer_w23 = `UART_FIFO_POINTER_W23;
parameter fifo_counter_w23 = `UART_FIFO_COUNTER_W23;

input				clk23;
input				wb_rst_i23;
input				push23;
input				pop23;
input	[fifo_width23-1:0]	data_in23;
input				fifo_reset23;
input       reset_status23;

output	[fifo_width23-1:0]	data_out23;
output				overrun23;
output	[fifo_counter_w23-1:0]	count;
output				error_bit23;

wire	[fifo_width23-1:0]	data_out23;
wire [7:0] data8_out23;
// flags23 FIFO
reg	[2:0]	fifo[fifo_depth23-1:0];

// FIFO pointers23
reg	[fifo_pointer_w23-1:0]	top;
reg	[fifo_pointer_w23-1:0]	bottom23;

reg	[fifo_counter_w23-1:0]	count;
reg				overrun23;

wire [fifo_pointer_w23-1:0] top_plus_123 = top + 1'b1;

raminfr23 #(fifo_pointer_w23,8,fifo_depth23) rfifo23  
        (.clk23(clk23), 
			.we23(push23), 
			.a(top), 
			.dpra23(bottom23), 
			.di23(data_in23[fifo_width23-1:fifo_width23-8]), 
			.dpo23(data8_out23)
		); 

always @(posedge clk23 or posedge wb_rst_i23) // synchronous23 FIFO
begin
	if (wb_rst_i23)
	begin
		top		<= #1 0;
		bottom23		<= #1 1'b0;
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
	if (fifo_reset23) begin
		top		<= #1 0;
		bottom23		<= #1 1'b0;
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
		case ({push23, pop23})
		2'b10 : if (count<fifo_depth23)  // overrun23 condition
			begin
				top       <= #1 top_plus_123;
				fifo[top] <= #1 data_in23[2:0];
				count     <= #1 count + 1'b1;
			end
		2'b01 : if(count>0)
			begin
        fifo[bottom23] <= #1 0;
				bottom23   <= #1 bottom23 + 1'b1;
				count	 <= #1 count - 1'b1;
			end
		2'b11 : begin
				bottom23   <= #1 bottom23 + 1'b1;
				top       <= #1 top_plus_123;
				fifo[top] <= #1 data_in23[2:0];
		        end
    default: ;
		endcase
	end
end   // always

always @(posedge clk23 or posedge wb_rst_i23) // synchronous23 FIFO
begin
  if (wb_rst_i23)
    overrun23   <= #1 1'b0;
  else
  if(fifo_reset23 | reset_status23) 
    overrun23   <= #1 1'b0;
  else
  if(push23 & ~pop23 & (count==fifo_depth23))
    overrun23   <= #1 1'b1;
end   // always


// please23 note23 though23 that data_out23 is only valid one clock23 after pop23 signal23
assign data_out23 = {data8_out23,fifo[bottom23]};

// Additional23 logic for detection23 of error conditions23 (parity23 and framing23) inside the FIFO
// for the Line23 Status Register bit 7

wire	[2:0]	word023 = fifo[0];
wire	[2:0]	word123 = fifo[1];
wire	[2:0]	word223 = fifo[2];
wire	[2:0]	word323 = fifo[3];
wire	[2:0]	word423 = fifo[4];
wire	[2:0]	word523 = fifo[5];
wire	[2:0]	word623 = fifo[6];
wire	[2:0]	word723 = fifo[7];

wire	[2:0]	word823 = fifo[8];
wire	[2:0]	word923 = fifo[9];
wire	[2:0]	word1023 = fifo[10];
wire	[2:0]	word1123 = fifo[11];
wire	[2:0]	word1223 = fifo[12];
wire	[2:0]	word1323 = fifo[13];
wire	[2:0]	word1423 = fifo[14];
wire	[2:0]	word1523 = fifo[15];

// a 1 is returned if any of the error bits in the fifo is 1
assign	error_bit23 = |(word023[2:0]  | word123[2:0]  | word223[2:0]  | word323[2:0]  |
            		      word423[2:0]  | word523[2:0]  | word623[2:0]  | word723[2:0]  |
            		      word823[2:0]  | word923[2:0]  | word1023[2:0] | word1123[2:0] |
            		      word1223[2:0] | word1323[2:0] | word1423[2:0] | word1523[2:0] );

endmodule
