//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb1.v                                                   ////
////                                                              ////
////                                                              ////
////  This1 file is part of the "UART1 16550 compatible1" project1    ////
////  http1://www1.opencores1.org1/cores1/uart165501/                   ////
////                                                              ////
////  Documentation1 related1 to this project1:                      ////
////  - http1://www1.opencores1.org1/cores1/uart165501/                 ////
////                                                              ////
////  Projects1 compatibility1:                                     ////
////  - WISHBONE1                                                  ////
////  RS2321 Protocol1                                              ////
////  16550D uart1 (mostly1 supported)                              ////
////                                                              ////
////  Overview1 (main1 Features1):                                   ////
////  UART1 core1 WISHBONE1 interface.                               ////
////                                                              ////
////  Known1 problems1 (limits1):                                    ////
////  Inserts1 one wait state on all transfers1.                    ////
////  Note1 affected1 signals1 and the way1 they are affected1.        ////
////                                                              ////
////  To1 Do1:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author1(s):                                                  ////
////      - gorban1@opencores1.org1                                  ////
////      - Jacob1 Gorban1                                          ////
////      - Igor1 Mohor1 (igorm1@opencores1.org1)                      ////
////                                                              ////
////  Created1:        2001/05/12                                  ////
////  Last1 Updated1:   2001/05/17                                  ////
////                  (See log1 for the revision1 history1)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright1 (C) 2000, 2001 Authors1                             ////
////                                                              ////
//// This1 source1 file may be used and distributed1 without         ////
//// restriction1 provided that this copyright1 statement1 is not    ////
//// removed from the file and that any derivative1 work1 contains1  ////
//// the original copyright1 notice1 and the associated disclaimer1. ////
////                                                              ////
//// This1 source1 file is free software1; you can redistribute1 it   ////
//// and/or modify it under the terms1 of the GNU1 Lesser1 General1   ////
//// Public1 License1 as published1 by the Free1 Software1 Foundation1; ////
//// either1 version1 2.1 of the License1, or (at your1 option) any   ////
//// later1 version1.                                               ////
////                                                              ////
//// This1 source1 is distributed1 in the hope1 that it will be       ////
//// useful1, but WITHOUT1 ANY1 WARRANTY1; without even1 the implied1   ////
//// warranty1 of MERCHANTABILITY1 or FITNESS1 FOR1 A PARTICULAR1      ////
//// PURPOSE1.  See the GNU1 Lesser1 General1 Public1 License1 for more ////
//// details1.                                                     ////
////                                                              ////
//// You should have received1 a copy of the GNU1 Lesser1 General1    ////
//// Public1 License1 along1 with this source1; if not, download1 it   ////
//// from http1://www1.opencores1.org1/lgpl1.shtml1                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS1 Revision1 History1
//
// $Log: not supported by cvs2svn1 $
// Revision1 1.16  2002/07/29 21:16:18  gorban1
// The uart_defines1.v file is included1 again1 in sources1.
//
// Revision1 1.15  2002/07/22 23:02:23  gorban1
// Bug1 Fixes1:
//  * Possible1 loss of sync and bad1 reception1 of stop bit on slow1 baud1 rates1 fixed1.
//   Problem1 reported1 by Kenny1.Tung1.
//  * Bad (or lack1 of ) loopback1 handling1 fixed1. Reported1 by Cherry1 Withers1.
//
// Improvements1:
//  * Made1 FIFO's as general1 inferrable1 memory where possible1.
//  So1 on FPGA1 they should be inferred1 as RAM1 (Distributed1 RAM1 on Xilinx1).
//  This1 saves1 about1 1/3 of the Slice1 count and reduces1 P&R and synthesis1 times.
//
//  * Added1 optional1 baudrate1 output (baud_o1).
//  This1 is identical1 to BAUDOUT1* signal1 on 16550 chip1.
//  It outputs1 16xbit_clock_rate - the divided1 clock1.
//  It's disabled by default. Define1 UART_HAS_BAUDRATE_OUTPUT1 to use.
//
// Revision1 1.12  2001/12/19 08:03:34  mohor1
// Warnings1 cleared1.
//
// Revision1 1.11  2001/12/06 14:51:04  gorban1
// Bug1 in LSR1[0] is fixed1.
// All WISHBONE1 signals1 are now sampled1, so another1 wait-state is introduced1 on all transfers1.
//
// Revision1 1.10  2001/12/03 21:44:29  gorban1
// Updated1 specification1 documentation.
// Added1 full 32-bit data bus interface, now as default.
// Address is 5-bit wide1 in 32-bit data bus mode.
// Added1 wb_sel_i1 input to the core1. It's used in the 32-bit mode.
// Added1 debug1 interface with two1 32-bit read-only registers in 32-bit mode.
// Bits1 5 and 6 of LSR1 are now only cleared1 on TX1 FIFO write.
// My1 small test bench1 is modified to work1 with 32-bit mode.
//
// Revision1 1.9  2001/10/20 09:58:40  gorban1
// Small1 synopsis1 fixes1
//
// Revision1 1.8  2001/08/24 21:01:12  mohor1
// Things1 connected1 to parity1 changed.
// Clock1 devider1 changed.
//
// Revision1 1.7  2001/08/23 16:05:05  mohor1
// Stop bit bug1 fixed1.
// Parity1 bug1 fixed1.
// WISHBONE1 read cycle bug1 fixed1,
// OE1 indicator1 (Overrun1 Error) bug1 fixed1.
// PE1 indicator1 (Parity1 Error) bug1 fixed1.
// Register read bug1 fixed1.
//
// Revision1 1.4  2001/05/31 20:08:01  gorban1
// FIFO changes1 and other corrections1.
//
// Revision1 1.3  2001/05/21 19:12:01  gorban1
// Corrected1 some1 Linter1 messages1.
//
// Revision1 1.2  2001/05/17 18:34:18  gorban1
// First1 'stable' release. Should1 be sythesizable1 now. Also1 added new header.
//
// Revision1 1.0  2001-05-17 21:27:13+02  jacob1
// Initial1 revision1
//
//

// UART1 core1 WISHBONE1 interface 
//
// Author1: Jacob1 Gorban1   (jacob1.gorban1@flextronicssemi1.com1)
// Company1: Flextronics1 Semiconductor1
//

// synopsys1 translate_off1
`include "timescale.v"
// synopsys1 translate_on1
`include "uart_defines1.v"
 
module uart_wb1 (clk1, wb_rst_i1, 
	wb_we_i1, wb_stb_i1, wb_cyc_i1, wb_ack_o1, wb_adr_i1,
	wb_adr_int1, wb_dat_i1, wb_dat_o1, wb_dat8_i1, wb_dat8_o1, wb_dat32_o1, wb_sel_i1,
	we_o1, re_o1 // Write and read enable output for the core1
);

input 		  clk1;

// WISHBONE1 interface	
input 		  wb_rst_i1;
input 		  wb_we_i1;
input 		  wb_stb_i1;
input 		  wb_cyc_i1;
input [3:0]   wb_sel_i1;
input [`UART_ADDR_WIDTH1-1:0] 	wb_adr_i1; //WISHBONE1 address line

`ifdef DATA_BUS_WIDTH_81
input [7:0]  wb_dat_i1; //input WISHBONE1 bus 
output [7:0] wb_dat_o1;
reg [7:0] 	 wb_dat_o1;
wire [7:0] 	 wb_dat_i1;
reg [7:0] 	 wb_dat_is1;
`else // for 32 data bus mode
input [31:0]  wb_dat_i1; //input WISHBONE1 bus 
output [31:0] wb_dat_o1;
reg [31:0] 	  wb_dat_o1;
wire [31:0]   wb_dat_i1;
reg [31:0] 	  wb_dat_is1;
`endif // !`ifdef DATA_BUS_WIDTH_81

output [`UART_ADDR_WIDTH1-1:0]	wb_adr_int1; // internal signal1 for address bus
input [7:0]   wb_dat8_o1; // internal 8 bit output to be put into wb_dat_o1
output [7:0]  wb_dat8_i1;
input [31:0]  wb_dat32_o1; // 32 bit data output (for debug1 interface)
output 		  wb_ack_o1;
output 		  we_o1;
output 		  re_o1;

wire 			  we_o1;
reg 			  wb_ack_o1;
reg [7:0] 	  wb_dat8_i1;
wire [7:0] 	  wb_dat8_o1;
wire [`UART_ADDR_WIDTH1-1:0]	wb_adr_int1; // internal signal1 for address bus
reg [`UART_ADDR_WIDTH1-1:0]	wb_adr_is1;
reg 								wb_we_is1;
reg 								wb_cyc_is1;
reg 								wb_stb_is1;
reg [3:0] 						wb_sel_is1;
wire [3:0]   wb_sel_i1;
reg 			 wre1 ;// timing1 control1 signal1 for write or read enable

// wb_ack_o1 FSM1
reg [1:0] 	 wbstate1;
always  @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) begin
		wb_ack_o1 <= #1 1'b0;
		wbstate1 <= #1 0;
		wre1 <= #1 1'b1;
	end else
		case (wbstate1)
			0: begin
				if (wb_stb_is1 & wb_cyc_is1) begin
					wre1 <= #1 0;
					wbstate1 <= #1 1;
					wb_ack_o1 <= #1 1;
				end else begin
					wre1 <= #1 1;
					wb_ack_o1 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o1 <= #1 0;
				wbstate1 <= #1 2;
				wre1 <= #1 0;
			end
			2,3: begin
				wb_ack_o1 <= #1 0;
				wbstate1 <= #1 0;
				wre1 <= #1 0;
			end
		endcase

assign we_o1 =  wb_we_is1 & wb_stb_is1 & wb_cyc_is1 & wre1 ; //WE1 for registers	
assign re_o1 = ~wb_we_is1 & wb_stb_is1 & wb_cyc_is1 & wre1 ; //RE1 for registers	

// Sample1 input signals1
always  @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1) begin
		wb_adr_is1 <= #1 0;
		wb_we_is1 <= #1 0;
		wb_cyc_is1 <= #1 0;
		wb_stb_is1 <= #1 0;
		wb_dat_is1 <= #1 0;
		wb_sel_is1 <= #1 0;
	end else begin
		wb_adr_is1 <= #1 wb_adr_i1;
		wb_we_is1 <= #1 wb_we_i1;
		wb_cyc_is1 <= #1 wb_cyc_i1;
		wb_stb_is1 <= #1 wb_stb_i1;
		wb_dat_is1 <= #1 wb_dat_i1;
		wb_sel_is1 <= #1 wb_sel_i1;
	end

`ifdef DATA_BUS_WIDTH_81 // 8-bit data bus
always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1)
		wb_dat_o1 <= #1 0;
	else
		wb_dat_o1 <= #1 wb_dat8_o1;

always @(wb_dat_is1)
	wb_dat8_i1 = wb_dat_is1;

assign wb_adr_int1 = wb_adr_is1;

`else // 32-bit bus
// put output to the correct1 byte in 32 bits using select1 line
always @(posedge clk1 or posedge wb_rst_i1)
	if (wb_rst_i1)
		wb_dat_o1 <= #1 0;
	else if (re_o1)
		case (wb_sel_is1)
			4'b0001: wb_dat_o1 <= #1 {24'b0, wb_dat8_o1};
			4'b0010: wb_dat_o1 <= #1 {16'b0, wb_dat8_o1, 8'b0};
			4'b0100: wb_dat_o1 <= #1 {8'b0, wb_dat8_o1, 16'b0};
			4'b1000: wb_dat_o1 <= #1 {wb_dat8_o1, 24'b0};
			4'b1111: wb_dat_o1 <= #1 wb_dat32_o1; // debug1 interface output
 			default: wb_dat_o1 <= #1 0;
		endcase // case(wb_sel_i1)

reg [1:0] wb_adr_int_lsb1;

always @(wb_sel_is1 or wb_dat_is1)
begin
	case (wb_sel_is1)
		4'b0001 : wb_dat8_i1 = wb_dat_is1[7:0];
		4'b0010 : wb_dat8_i1 = wb_dat_is1[15:8];
		4'b0100 : wb_dat8_i1 = wb_dat_is1[23:16];
		4'b1000 : wb_dat8_i1 = wb_dat_is1[31:24];
		default : wb_dat8_i1 = wb_dat_is1[7:0];
	endcase // case(wb_sel_i1)

  `ifdef LITLE_ENDIAN1
	case (wb_sel_is1)
		4'b0001 : wb_adr_int_lsb1 = 2'h0;
		4'b0010 : wb_adr_int_lsb1 = 2'h1;
		4'b0100 : wb_adr_int_lsb1 = 2'h2;
		4'b1000 : wb_adr_int_lsb1 = 2'h3;
		default : wb_adr_int_lsb1 = 2'h0;
	endcase // case(wb_sel_i1)
  `else
	case (wb_sel_is1)
		4'b0001 : wb_adr_int_lsb1 = 2'h3;
		4'b0010 : wb_adr_int_lsb1 = 2'h2;
		4'b0100 : wb_adr_int_lsb1 = 2'h1;
		4'b1000 : wb_adr_int_lsb1 = 2'h0;
		default : wb_adr_int_lsb1 = 2'h0;
	endcase // case(wb_sel_i1)
  `endif
end

assign wb_adr_int1 = {wb_adr_is1[`UART_ADDR_WIDTH1-1:2], wb_adr_int_lsb1};

`endif // !`ifdef DATA_BUS_WIDTH_81

endmodule










