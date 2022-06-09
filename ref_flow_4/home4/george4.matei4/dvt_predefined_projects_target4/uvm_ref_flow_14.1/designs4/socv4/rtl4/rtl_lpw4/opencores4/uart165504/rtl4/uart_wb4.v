//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb4.v                                                   ////
////                                                              ////
////                                                              ////
////  This4 file is part of the "UART4 16550 compatible4" project4    ////
////  http4://www4.opencores4.org4/cores4/uart165504/                   ////
////                                                              ////
////  Documentation4 related4 to this project4:                      ////
////  - http4://www4.opencores4.org4/cores4/uart165504/                 ////
////                                                              ////
////  Projects4 compatibility4:                                     ////
////  - WISHBONE4                                                  ////
////  RS2324 Protocol4                                              ////
////  16550D uart4 (mostly4 supported)                              ////
////                                                              ////
////  Overview4 (main4 Features4):                                   ////
////  UART4 core4 WISHBONE4 interface.                               ////
////                                                              ////
////  Known4 problems4 (limits4):                                    ////
////  Inserts4 one wait state on all transfers4.                    ////
////  Note4 affected4 signals4 and the way4 they are affected4.        ////
////                                                              ////
////  To4 Do4:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author4(s):                                                  ////
////      - gorban4@opencores4.org4                                  ////
////      - Jacob4 Gorban4                                          ////
////      - Igor4 Mohor4 (igorm4@opencores4.org4)                      ////
////                                                              ////
////  Created4:        2001/05/12                                  ////
////  Last4 Updated4:   2001/05/17                                  ////
////                  (See log4 for the revision4 history4)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2000, 2001 Authors4                             ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS4 Revision4 History4
//
// $Log: not supported by cvs2svn4 $
// Revision4 1.16  2002/07/29 21:16:18  gorban4
// The uart_defines4.v file is included4 again4 in sources4.
//
// Revision4 1.15  2002/07/22 23:02:23  gorban4
// Bug4 Fixes4:
//  * Possible4 loss of sync and bad4 reception4 of stop bit on slow4 baud4 rates4 fixed4.
//   Problem4 reported4 by Kenny4.Tung4.
//  * Bad (or lack4 of ) loopback4 handling4 fixed4. Reported4 by Cherry4 Withers4.
//
// Improvements4:
//  * Made4 FIFO's as general4 inferrable4 memory where possible4.
//  So4 on FPGA4 they should be inferred4 as RAM4 (Distributed4 RAM4 on Xilinx4).
//  This4 saves4 about4 1/3 of the Slice4 count and reduces4 P&R and synthesis4 times.
//
//  * Added4 optional4 baudrate4 output (baud_o4).
//  This4 is identical4 to BAUDOUT4* signal4 on 16550 chip4.
//  It outputs4 16xbit_clock_rate - the divided4 clock4.
//  It's disabled by default. Define4 UART_HAS_BAUDRATE_OUTPUT4 to use.
//
// Revision4 1.12  2001/12/19 08:03:34  mohor4
// Warnings4 cleared4.
//
// Revision4 1.11  2001/12/06 14:51:04  gorban4
// Bug4 in LSR4[0] is fixed4.
// All WISHBONE4 signals4 are now sampled4, so another4 wait-state is introduced4 on all transfers4.
//
// Revision4 1.10  2001/12/03 21:44:29  gorban4
// Updated4 specification4 documentation.
// Added4 full 32-bit data bus interface, now as default.
// Address is 5-bit wide4 in 32-bit data bus mode.
// Added4 wb_sel_i4 input to the core4. It's used in the 32-bit mode.
// Added4 debug4 interface with two4 32-bit read-only registers in 32-bit mode.
// Bits4 5 and 6 of LSR4 are now only cleared4 on TX4 FIFO write.
// My4 small test bench4 is modified to work4 with 32-bit mode.
//
// Revision4 1.9  2001/10/20 09:58:40  gorban4
// Small4 synopsis4 fixes4
//
// Revision4 1.8  2001/08/24 21:01:12  mohor4
// Things4 connected4 to parity4 changed.
// Clock4 devider4 changed.
//
// Revision4 1.7  2001/08/23 16:05:05  mohor4
// Stop bit bug4 fixed4.
// Parity4 bug4 fixed4.
// WISHBONE4 read cycle bug4 fixed4,
// OE4 indicator4 (Overrun4 Error) bug4 fixed4.
// PE4 indicator4 (Parity4 Error) bug4 fixed4.
// Register read bug4 fixed4.
//
// Revision4 1.4  2001/05/31 20:08:01  gorban4
// FIFO changes4 and other corrections4.
//
// Revision4 1.3  2001/05/21 19:12:01  gorban4
// Corrected4 some4 Linter4 messages4.
//
// Revision4 1.2  2001/05/17 18:34:18  gorban4
// First4 'stable' release. Should4 be sythesizable4 now. Also4 added new header.
//
// Revision4 1.0  2001-05-17 21:27:13+02  jacob4
// Initial4 revision4
//
//

// UART4 core4 WISHBONE4 interface 
//
// Author4: Jacob4 Gorban4   (jacob4.gorban4@flextronicssemi4.com4)
// Company4: Flextronics4 Semiconductor4
//

// synopsys4 translate_off4
`include "timescale.v"
// synopsys4 translate_on4
`include "uart_defines4.v"
 
module uart_wb4 (clk4, wb_rst_i4, 
	wb_we_i4, wb_stb_i4, wb_cyc_i4, wb_ack_o4, wb_adr_i4,
	wb_adr_int4, wb_dat_i4, wb_dat_o4, wb_dat8_i4, wb_dat8_o4, wb_dat32_o4, wb_sel_i4,
	we_o4, re_o4 // Write and read enable output for the core4
);

input 		  clk4;

// WISHBONE4 interface	
input 		  wb_rst_i4;
input 		  wb_we_i4;
input 		  wb_stb_i4;
input 		  wb_cyc_i4;
input [3:0]   wb_sel_i4;
input [`UART_ADDR_WIDTH4-1:0] 	wb_adr_i4; //WISHBONE4 address line

`ifdef DATA_BUS_WIDTH_84
input [7:0]  wb_dat_i4; //input WISHBONE4 bus 
output [7:0] wb_dat_o4;
reg [7:0] 	 wb_dat_o4;
wire [7:0] 	 wb_dat_i4;
reg [7:0] 	 wb_dat_is4;
`else // for 32 data bus mode
input [31:0]  wb_dat_i4; //input WISHBONE4 bus 
output [31:0] wb_dat_o4;
reg [31:0] 	  wb_dat_o4;
wire [31:0]   wb_dat_i4;
reg [31:0] 	  wb_dat_is4;
`endif // !`ifdef DATA_BUS_WIDTH_84

output [`UART_ADDR_WIDTH4-1:0]	wb_adr_int4; // internal signal4 for address bus
input [7:0]   wb_dat8_o4; // internal 8 bit output to be put into wb_dat_o4
output [7:0]  wb_dat8_i4;
input [31:0]  wb_dat32_o4; // 32 bit data output (for debug4 interface)
output 		  wb_ack_o4;
output 		  we_o4;
output 		  re_o4;

wire 			  we_o4;
reg 			  wb_ack_o4;
reg [7:0] 	  wb_dat8_i4;
wire [7:0] 	  wb_dat8_o4;
wire [`UART_ADDR_WIDTH4-1:0]	wb_adr_int4; // internal signal4 for address bus
reg [`UART_ADDR_WIDTH4-1:0]	wb_adr_is4;
reg 								wb_we_is4;
reg 								wb_cyc_is4;
reg 								wb_stb_is4;
reg [3:0] 						wb_sel_is4;
wire [3:0]   wb_sel_i4;
reg 			 wre4 ;// timing4 control4 signal4 for write or read enable

// wb_ack_o4 FSM4
reg [1:0] 	 wbstate4;
always  @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) begin
		wb_ack_o4 <= #1 1'b0;
		wbstate4 <= #1 0;
		wre4 <= #1 1'b1;
	end else
		case (wbstate4)
			0: begin
				if (wb_stb_is4 & wb_cyc_is4) begin
					wre4 <= #1 0;
					wbstate4 <= #1 1;
					wb_ack_o4 <= #1 1;
				end else begin
					wre4 <= #1 1;
					wb_ack_o4 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o4 <= #1 0;
				wbstate4 <= #1 2;
				wre4 <= #1 0;
			end
			2,3: begin
				wb_ack_o4 <= #1 0;
				wbstate4 <= #1 0;
				wre4 <= #1 0;
			end
		endcase

assign we_o4 =  wb_we_is4 & wb_stb_is4 & wb_cyc_is4 & wre4 ; //WE4 for registers	
assign re_o4 = ~wb_we_is4 & wb_stb_is4 & wb_cyc_is4 & wre4 ; //RE4 for registers	

// Sample4 input signals4
always  @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4) begin
		wb_adr_is4 <= #1 0;
		wb_we_is4 <= #1 0;
		wb_cyc_is4 <= #1 0;
		wb_stb_is4 <= #1 0;
		wb_dat_is4 <= #1 0;
		wb_sel_is4 <= #1 0;
	end else begin
		wb_adr_is4 <= #1 wb_adr_i4;
		wb_we_is4 <= #1 wb_we_i4;
		wb_cyc_is4 <= #1 wb_cyc_i4;
		wb_stb_is4 <= #1 wb_stb_i4;
		wb_dat_is4 <= #1 wb_dat_i4;
		wb_sel_is4 <= #1 wb_sel_i4;
	end

`ifdef DATA_BUS_WIDTH_84 // 8-bit data bus
always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4)
		wb_dat_o4 <= #1 0;
	else
		wb_dat_o4 <= #1 wb_dat8_o4;

always @(wb_dat_is4)
	wb_dat8_i4 = wb_dat_is4;

assign wb_adr_int4 = wb_adr_is4;

`else // 32-bit bus
// put output to the correct4 byte in 32 bits using select4 line
always @(posedge clk4 or posedge wb_rst_i4)
	if (wb_rst_i4)
		wb_dat_o4 <= #1 0;
	else if (re_o4)
		case (wb_sel_is4)
			4'b0001: wb_dat_o4 <= #1 {24'b0, wb_dat8_o4};
			4'b0010: wb_dat_o4 <= #1 {16'b0, wb_dat8_o4, 8'b0};
			4'b0100: wb_dat_o4 <= #1 {8'b0, wb_dat8_o4, 16'b0};
			4'b1000: wb_dat_o4 <= #1 {wb_dat8_o4, 24'b0};
			4'b1111: wb_dat_o4 <= #1 wb_dat32_o4; // debug4 interface output
 			default: wb_dat_o4 <= #1 0;
		endcase // case(wb_sel_i4)

reg [1:0] wb_adr_int_lsb4;

always @(wb_sel_is4 or wb_dat_is4)
begin
	case (wb_sel_is4)
		4'b0001 : wb_dat8_i4 = wb_dat_is4[7:0];
		4'b0010 : wb_dat8_i4 = wb_dat_is4[15:8];
		4'b0100 : wb_dat8_i4 = wb_dat_is4[23:16];
		4'b1000 : wb_dat8_i4 = wb_dat_is4[31:24];
		default : wb_dat8_i4 = wb_dat_is4[7:0];
	endcase // case(wb_sel_i4)

  `ifdef LITLE_ENDIAN4
	case (wb_sel_is4)
		4'b0001 : wb_adr_int_lsb4 = 2'h0;
		4'b0010 : wb_adr_int_lsb4 = 2'h1;
		4'b0100 : wb_adr_int_lsb4 = 2'h2;
		4'b1000 : wb_adr_int_lsb4 = 2'h3;
		default : wb_adr_int_lsb4 = 2'h0;
	endcase // case(wb_sel_i4)
  `else
	case (wb_sel_is4)
		4'b0001 : wb_adr_int_lsb4 = 2'h3;
		4'b0010 : wb_adr_int_lsb4 = 2'h2;
		4'b0100 : wb_adr_int_lsb4 = 2'h1;
		4'b1000 : wb_adr_int_lsb4 = 2'h0;
		default : wb_adr_int_lsb4 = 2'h0;
	endcase // case(wb_sel_i4)
  `endif
end

assign wb_adr_int4 = {wb_adr_is4[`UART_ADDR_WIDTH4-1:2], wb_adr_int_lsb4};

`endif // !`ifdef DATA_BUS_WIDTH_84

endmodule










