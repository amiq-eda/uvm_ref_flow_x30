//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb8.v                                                   ////
////                                                              ////
////                                                              ////
////  This8 file is part of the "UART8 16550 compatible8" project8    ////
////  http8://www8.opencores8.org8/cores8/uart165508/                   ////
////                                                              ////
////  Documentation8 related8 to this project8:                      ////
////  - http8://www8.opencores8.org8/cores8/uart165508/                 ////
////                                                              ////
////  Projects8 compatibility8:                                     ////
////  - WISHBONE8                                                  ////
////  RS2328 Protocol8                                              ////
////  16550D uart8 (mostly8 supported)                              ////
////                                                              ////
////  Overview8 (main8 Features8):                                   ////
////  UART8 core8 WISHBONE8 interface.                               ////
////                                                              ////
////  Known8 problems8 (limits8):                                    ////
////  Inserts8 one wait state on all transfers8.                    ////
////  Note8 affected8 signals8 and the way8 they are affected8.        ////
////                                                              ////
////  To8 Do8:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author8(s):                                                  ////
////      - gorban8@opencores8.org8                                  ////
////      - Jacob8 Gorban8                                          ////
////      - Igor8 Mohor8 (igorm8@opencores8.org8)                      ////
////                                                              ////
////  Created8:        2001/05/12                                  ////
////  Last8 Updated8:   2001/05/17                                  ////
////                  (See log8 for the revision8 history8)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2000, 2001 Authors8                             ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS8 Revision8 History8
//
// $Log: not supported by cvs2svn8 $
// Revision8 1.16  2002/07/29 21:16:18  gorban8
// The uart_defines8.v file is included8 again8 in sources8.
//
// Revision8 1.15  2002/07/22 23:02:23  gorban8
// Bug8 Fixes8:
//  * Possible8 loss of sync and bad8 reception8 of stop bit on slow8 baud8 rates8 fixed8.
//   Problem8 reported8 by Kenny8.Tung8.
//  * Bad (or lack8 of ) loopback8 handling8 fixed8. Reported8 by Cherry8 Withers8.
//
// Improvements8:
//  * Made8 FIFO's as general8 inferrable8 memory where possible8.
//  So8 on FPGA8 they should be inferred8 as RAM8 (Distributed8 RAM8 on Xilinx8).
//  This8 saves8 about8 1/3 of the Slice8 count and reduces8 P&R and synthesis8 times.
//
//  * Added8 optional8 baudrate8 output (baud_o8).
//  This8 is identical8 to BAUDOUT8* signal8 on 16550 chip8.
//  It outputs8 16xbit_clock_rate - the divided8 clock8.
//  It's disabled by default. Define8 UART_HAS_BAUDRATE_OUTPUT8 to use.
//
// Revision8 1.12  2001/12/19 08:03:34  mohor8
// Warnings8 cleared8.
//
// Revision8 1.11  2001/12/06 14:51:04  gorban8
// Bug8 in LSR8[0] is fixed8.
// All WISHBONE8 signals8 are now sampled8, so another8 wait-state is introduced8 on all transfers8.
//
// Revision8 1.10  2001/12/03 21:44:29  gorban8
// Updated8 specification8 documentation.
// Added8 full 32-bit data bus interface, now as default.
// Address is 5-bit wide8 in 32-bit data bus mode.
// Added8 wb_sel_i8 input to the core8. It's used in the 32-bit mode.
// Added8 debug8 interface with two8 32-bit read-only registers in 32-bit mode.
// Bits8 5 and 6 of LSR8 are now only cleared8 on TX8 FIFO write.
// My8 small test bench8 is modified to work8 with 32-bit mode.
//
// Revision8 1.9  2001/10/20 09:58:40  gorban8
// Small8 synopsis8 fixes8
//
// Revision8 1.8  2001/08/24 21:01:12  mohor8
// Things8 connected8 to parity8 changed.
// Clock8 devider8 changed.
//
// Revision8 1.7  2001/08/23 16:05:05  mohor8
// Stop bit bug8 fixed8.
// Parity8 bug8 fixed8.
// WISHBONE8 read cycle bug8 fixed8,
// OE8 indicator8 (Overrun8 Error) bug8 fixed8.
// PE8 indicator8 (Parity8 Error) bug8 fixed8.
// Register read bug8 fixed8.
//
// Revision8 1.4  2001/05/31 20:08:01  gorban8
// FIFO changes8 and other corrections8.
//
// Revision8 1.3  2001/05/21 19:12:01  gorban8
// Corrected8 some8 Linter8 messages8.
//
// Revision8 1.2  2001/05/17 18:34:18  gorban8
// First8 'stable' release. Should8 be sythesizable8 now. Also8 added new header.
//
// Revision8 1.0  2001-05-17 21:27:13+02  jacob8
// Initial8 revision8
//
//

// UART8 core8 WISHBONE8 interface 
//
// Author8: Jacob8 Gorban8   (jacob8.gorban8@flextronicssemi8.com8)
// Company8: Flextronics8 Semiconductor8
//

// synopsys8 translate_off8
`include "timescale.v"
// synopsys8 translate_on8
`include "uart_defines8.v"
 
module uart_wb8 (clk8, wb_rst_i8, 
	wb_we_i8, wb_stb_i8, wb_cyc_i8, wb_ack_o8, wb_adr_i8,
	wb_adr_int8, wb_dat_i8, wb_dat_o8, wb_dat8_i8, wb_dat8_o8, wb_dat32_o8, wb_sel_i8,
	we_o8, re_o8 // Write and read enable output for the core8
);

input 		  clk8;

// WISHBONE8 interface	
input 		  wb_rst_i8;
input 		  wb_we_i8;
input 		  wb_stb_i8;
input 		  wb_cyc_i8;
input [3:0]   wb_sel_i8;
input [`UART_ADDR_WIDTH8-1:0] 	wb_adr_i8; //WISHBONE8 address line

`ifdef DATA_BUS_WIDTH_88
input [7:0]  wb_dat_i8; //input WISHBONE8 bus 
output [7:0] wb_dat_o8;
reg [7:0] 	 wb_dat_o8;
wire [7:0] 	 wb_dat_i8;
reg [7:0] 	 wb_dat_is8;
`else // for 32 data bus mode
input [31:0]  wb_dat_i8; //input WISHBONE8 bus 
output [31:0] wb_dat_o8;
reg [31:0] 	  wb_dat_o8;
wire [31:0]   wb_dat_i8;
reg [31:0] 	  wb_dat_is8;
`endif // !`ifdef DATA_BUS_WIDTH_88

output [`UART_ADDR_WIDTH8-1:0]	wb_adr_int8; // internal signal8 for address bus
input [7:0]   wb_dat8_o8; // internal 8 bit output to be put into wb_dat_o8
output [7:0]  wb_dat8_i8;
input [31:0]  wb_dat32_o8; // 32 bit data output (for debug8 interface)
output 		  wb_ack_o8;
output 		  we_o8;
output 		  re_o8;

wire 			  we_o8;
reg 			  wb_ack_o8;
reg [7:0] 	  wb_dat8_i8;
wire [7:0] 	  wb_dat8_o8;
wire [`UART_ADDR_WIDTH8-1:0]	wb_adr_int8; // internal signal8 for address bus
reg [`UART_ADDR_WIDTH8-1:0]	wb_adr_is8;
reg 								wb_we_is8;
reg 								wb_cyc_is8;
reg 								wb_stb_is8;
reg [3:0] 						wb_sel_is8;
wire [3:0]   wb_sel_i8;
reg 			 wre8 ;// timing8 control8 signal8 for write or read enable

// wb_ack_o8 FSM8
reg [1:0] 	 wbstate8;
always  @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) begin
		wb_ack_o8 <= #1 1'b0;
		wbstate8 <= #1 0;
		wre8 <= #1 1'b1;
	end else
		case (wbstate8)
			0: begin
				if (wb_stb_is8 & wb_cyc_is8) begin
					wre8 <= #1 0;
					wbstate8 <= #1 1;
					wb_ack_o8 <= #1 1;
				end else begin
					wre8 <= #1 1;
					wb_ack_o8 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o8 <= #1 0;
				wbstate8 <= #1 2;
				wre8 <= #1 0;
			end
			2,3: begin
				wb_ack_o8 <= #1 0;
				wbstate8 <= #1 0;
				wre8 <= #1 0;
			end
		endcase

assign we_o8 =  wb_we_is8 & wb_stb_is8 & wb_cyc_is8 & wre8 ; //WE8 for registers	
assign re_o8 = ~wb_we_is8 & wb_stb_is8 & wb_cyc_is8 & wre8 ; //RE8 for registers	

// Sample8 input signals8
always  @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8) begin
		wb_adr_is8 <= #1 0;
		wb_we_is8 <= #1 0;
		wb_cyc_is8 <= #1 0;
		wb_stb_is8 <= #1 0;
		wb_dat_is8 <= #1 0;
		wb_sel_is8 <= #1 0;
	end else begin
		wb_adr_is8 <= #1 wb_adr_i8;
		wb_we_is8 <= #1 wb_we_i8;
		wb_cyc_is8 <= #1 wb_cyc_i8;
		wb_stb_is8 <= #1 wb_stb_i8;
		wb_dat_is8 <= #1 wb_dat_i8;
		wb_sel_is8 <= #1 wb_sel_i8;
	end

`ifdef DATA_BUS_WIDTH_88 // 8-bit data bus
always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8)
		wb_dat_o8 <= #1 0;
	else
		wb_dat_o8 <= #1 wb_dat8_o8;

always @(wb_dat_is8)
	wb_dat8_i8 = wb_dat_is8;

assign wb_adr_int8 = wb_adr_is8;

`else // 32-bit bus
// put output to the correct8 byte in 32 bits using select8 line
always @(posedge clk8 or posedge wb_rst_i8)
	if (wb_rst_i8)
		wb_dat_o8 <= #1 0;
	else if (re_o8)
		case (wb_sel_is8)
			4'b0001: wb_dat_o8 <= #1 {24'b0, wb_dat8_o8};
			4'b0010: wb_dat_o8 <= #1 {16'b0, wb_dat8_o8, 8'b0};
			4'b0100: wb_dat_o8 <= #1 {8'b0, wb_dat8_o8, 16'b0};
			4'b1000: wb_dat_o8 <= #1 {wb_dat8_o8, 24'b0};
			4'b1111: wb_dat_o8 <= #1 wb_dat32_o8; // debug8 interface output
 			default: wb_dat_o8 <= #1 0;
		endcase // case(wb_sel_i8)

reg [1:0] wb_adr_int_lsb8;

always @(wb_sel_is8 or wb_dat_is8)
begin
	case (wb_sel_is8)
		4'b0001 : wb_dat8_i8 = wb_dat_is8[7:0];
		4'b0010 : wb_dat8_i8 = wb_dat_is8[15:8];
		4'b0100 : wb_dat8_i8 = wb_dat_is8[23:16];
		4'b1000 : wb_dat8_i8 = wb_dat_is8[31:24];
		default : wb_dat8_i8 = wb_dat_is8[7:0];
	endcase // case(wb_sel_i8)

  `ifdef LITLE_ENDIAN8
	case (wb_sel_is8)
		4'b0001 : wb_adr_int_lsb8 = 2'h0;
		4'b0010 : wb_adr_int_lsb8 = 2'h1;
		4'b0100 : wb_adr_int_lsb8 = 2'h2;
		4'b1000 : wb_adr_int_lsb8 = 2'h3;
		default : wb_adr_int_lsb8 = 2'h0;
	endcase // case(wb_sel_i8)
  `else
	case (wb_sel_is8)
		4'b0001 : wb_adr_int_lsb8 = 2'h3;
		4'b0010 : wb_adr_int_lsb8 = 2'h2;
		4'b0100 : wb_adr_int_lsb8 = 2'h1;
		4'b1000 : wb_adr_int_lsb8 = 2'h0;
		default : wb_adr_int_lsb8 = 2'h0;
	endcase // case(wb_sel_i8)
  `endif
end

assign wb_adr_int8 = {wb_adr_is8[`UART_ADDR_WIDTH8-1:2], wb_adr_int_lsb8};

`endif // !`ifdef DATA_BUS_WIDTH_88

endmodule










