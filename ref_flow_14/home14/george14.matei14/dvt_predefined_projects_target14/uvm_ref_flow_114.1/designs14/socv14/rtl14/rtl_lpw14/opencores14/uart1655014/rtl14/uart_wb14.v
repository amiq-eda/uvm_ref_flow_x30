//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb14.v                                                   ////
////                                                              ////
////                                                              ////
////  This14 file is part of the "UART14 16550 compatible14" project14    ////
////  http14://www14.opencores14.org14/cores14/uart1655014/                   ////
////                                                              ////
////  Documentation14 related14 to this project14:                      ////
////  - http14://www14.opencores14.org14/cores14/uart1655014/                 ////
////                                                              ////
////  Projects14 compatibility14:                                     ////
////  - WISHBONE14                                                  ////
////  RS23214 Protocol14                                              ////
////  16550D uart14 (mostly14 supported)                              ////
////                                                              ////
////  Overview14 (main14 Features14):                                   ////
////  UART14 core14 WISHBONE14 interface.                               ////
////                                                              ////
////  Known14 problems14 (limits14):                                    ////
////  Inserts14 one wait state on all transfers14.                    ////
////  Note14 affected14 signals14 and the way14 they are affected14.        ////
////                                                              ////
////  To14 Do14:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author14(s):                                                  ////
////      - gorban14@opencores14.org14                                  ////
////      - Jacob14 Gorban14                                          ////
////      - Igor14 Mohor14 (igorm14@opencores14.org14)                      ////
////                                                              ////
////  Created14:        2001/05/12                                  ////
////  Last14 Updated14:   2001/05/17                                  ////
////                  (See log14 for the revision14 history14)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2000, 2001 Authors14                             ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS14 Revision14 History14
//
// $Log: not supported by cvs2svn14 $
// Revision14 1.16  2002/07/29 21:16:18  gorban14
// The uart_defines14.v file is included14 again14 in sources14.
//
// Revision14 1.15  2002/07/22 23:02:23  gorban14
// Bug14 Fixes14:
//  * Possible14 loss of sync and bad14 reception14 of stop bit on slow14 baud14 rates14 fixed14.
//   Problem14 reported14 by Kenny14.Tung14.
//  * Bad (or lack14 of ) loopback14 handling14 fixed14. Reported14 by Cherry14 Withers14.
//
// Improvements14:
//  * Made14 FIFO's as general14 inferrable14 memory where possible14.
//  So14 on FPGA14 they should be inferred14 as RAM14 (Distributed14 RAM14 on Xilinx14).
//  This14 saves14 about14 1/3 of the Slice14 count and reduces14 P&R and synthesis14 times.
//
//  * Added14 optional14 baudrate14 output (baud_o14).
//  This14 is identical14 to BAUDOUT14* signal14 on 16550 chip14.
//  It outputs14 16xbit_clock_rate - the divided14 clock14.
//  It's disabled by default. Define14 UART_HAS_BAUDRATE_OUTPUT14 to use.
//
// Revision14 1.12  2001/12/19 08:03:34  mohor14
// Warnings14 cleared14.
//
// Revision14 1.11  2001/12/06 14:51:04  gorban14
// Bug14 in LSR14[0] is fixed14.
// All WISHBONE14 signals14 are now sampled14, so another14 wait-state is introduced14 on all transfers14.
//
// Revision14 1.10  2001/12/03 21:44:29  gorban14
// Updated14 specification14 documentation.
// Added14 full 32-bit data bus interface, now as default.
// Address is 5-bit wide14 in 32-bit data bus mode.
// Added14 wb_sel_i14 input to the core14. It's used in the 32-bit mode.
// Added14 debug14 interface with two14 32-bit read-only registers in 32-bit mode.
// Bits14 5 and 6 of LSR14 are now only cleared14 on TX14 FIFO write.
// My14 small test bench14 is modified to work14 with 32-bit mode.
//
// Revision14 1.9  2001/10/20 09:58:40  gorban14
// Small14 synopsis14 fixes14
//
// Revision14 1.8  2001/08/24 21:01:12  mohor14
// Things14 connected14 to parity14 changed.
// Clock14 devider14 changed.
//
// Revision14 1.7  2001/08/23 16:05:05  mohor14
// Stop bit bug14 fixed14.
// Parity14 bug14 fixed14.
// WISHBONE14 read cycle bug14 fixed14,
// OE14 indicator14 (Overrun14 Error) bug14 fixed14.
// PE14 indicator14 (Parity14 Error) bug14 fixed14.
// Register read bug14 fixed14.
//
// Revision14 1.4  2001/05/31 20:08:01  gorban14
// FIFO changes14 and other corrections14.
//
// Revision14 1.3  2001/05/21 19:12:01  gorban14
// Corrected14 some14 Linter14 messages14.
//
// Revision14 1.2  2001/05/17 18:34:18  gorban14
// First14 'stable' release. Should14 be sythesizable14 now. Also14 added new header.
//
// Revision14 1.0  2001-05-17 21:27:13+02  jacob14
// Initial14 revision14
//
//

// UART14 core14 WISHBONE14 interface 
//
// Author14: Jacob14 Gorban14   (jacob14.gorban14@flextronicssemi14.com14)
// Company14: Flextronics14 Semiconductor14
//

// synopsys14 translate_off14
`include "timescale.v"
// synopsys14 translate_on14
`include "uart_defines14.v"
 
module uart_wb14 (clk14, wb_rst_i14, 
	wb_we_i14, wb_stb_i14, wb_cyc_i14, wb_ack_o14, wb_adr_i14,
	wb_adr_int14, wb_dat_i14, wb_dat_o14, wb_dat8_i14, wb_dat8_o14, wb_dat32_o14, wb_sel_i14,
	we_o14, re_o14 // Write and read enable output for the core14
);

input 		  clk14;

// WISHBONE14 interface	
input 		  wb_rst_i14;
input 		  wb_we_i14;
input 		  wb_stb_i14;
input 		  wb_cyc_i14;
input [3:0]   wb_sel_i14;
input [`UART_ADDR_WIDTH14-1:0] 	wb_adr_i14; //WISHBONE14 address line

`ifdef DATA_BUS_WIDTH_814
input [7:0]  wb_dat_i14; //input WISHBONE14 bus 
output [7:0] wb_dat_o14;
reg [7:0] 	 wb_dat_o14;
wire [7:0] 	 wb_dat_i14;
reg [7:0] 	 wb_dat_is14;
`else // for 32 data bus mode
input [31:0]  wb_dat_i14; //input WISHBONE14 bus 
output [31:0] wb_dat_o14;
reg [31:0] 	  wb_dat_o14;
wire [31:0]   wb_dat_i14;
reg [31:0] 	  wb_dat_is14;
`endif // !`ifdef DATA_BUS_WIDTH_814

output [`UART_ADDR_WIDTH14-1:0]	wb_adr_int14; // internal signal14 for address bus
input [7:0]   wb_dat8_o14; // internal 8 bit output to be put into wb_dat_o14
output [7:0]  wb_dat8_i14;
input [31:0]  wb_dat32_o14; // 32 bit data output (for debug14 interface)
output 		  wb_ack_o14;
output 		  we_o14;
output 		  re_o14;

wire 			  we_o14;
reg 			  wb_ack_o14;
reg [7:0] 	  wb_dat8_i14;
wire [7:0] 	  wb_dat8_o14;
wire [`UART_ADDR_WIDTH14-1:0]	wb_adr_int14; // internal signal14 for address bus
reg [`UART_ADDR_WIDTH14-1:0]	wb_adr_is14;
reg 								wb_we_is14;
reg 								wb_cyc_is14;
reg 								wb_stb_is14;
reg [3:0] 						wb_sel_is14;
wire [3:0]   wb_sel_i14;
reg 			 wre14 ;// timing14 control14 signal14 for write or read enable

// wb_ack_o14 FSM14
reg [1:0] 	 wbstate14;
always  @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) begin
		wb_ack_o14 <= #1 1'b0;
		wbstate14 <= #1 0;
		wre14 <= #1 1'b1;
	end else
		case (wbstate14)
			0: begin
				if (wb_stb_is14 & wb_cyc_is14) begin
					wre14 <= #1 0;
					wbstate14 <= #1 1;
					wb_ack_o14 <= #1 1;
				end else begin
					wre14 <= #1 1;
					wb_ack_o14 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o14 <= #1 0;
				wbstate14 <= #1 2;
				wre14 <= #1 0;
			end
			2,3: begin
				wb_ack_o14 <= #1 0;
				wbstate14 <= #1 0;
				wre14 <= #1 0;
			end
		endcase

assign we_o14 =  wb_we_is14 & wb_stb_is14 & wb_cyc_is14 & wre14 ; //WE14 for registers	
assign re_o14 = ~wb_we_is14 & wb_stb_is14 & wb_cyc_is14 & wre14 ; //RE14 for registers	

// Sample14 input signals14
always  @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14) begin
		wb_adr_is14 <= #1 0;
		wb_we_is14 <= #1 0;
		wb_cyc_is14 <= #1 0;
		wb_stb_is14 <= #1 0;
		wb_dat_is14 <= #1 0;
		wb_sel_is14 <= #1 0;
	end else begin
		wb_adr_is14 <= #1 wb_adr_i14;
		wb_we_is14 <= #1 wb_we_i14;
		wb_cyc_is14 <= #1 wb_cyc_i14;
		wb_stb_is14 <= #1 wb_stb_i14;
		wb_dat_is14 <= #1 wb_dat_i14;
		wb_sel_is14 <= #1 wb_sel_i14;
	end

`ifdef DATA_BUS_WIDTH_814 // 8-bit data bus
always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14)
		wb_dat_o14 <= #1 0;
	else
		wb_dat_o14 <= #1 wb_dat8_o14;

always @(wb_dat_is14)
	wb_dat8_i14 = wb_dat_is14;

assign wb_adr_int14 = wb_adr_is14;

`else // 32-bit bus
// put output to the correct14 byte in 32 bits using select14 line
always @(posedge clk14 or posedge wb_rst_i14)
	if (wb_rst_i14)
		wb_dat_o14 <= #1 0;
	else if (re_o14)
		case (wb_sel_is14)
			4'b0001: wb_dat_o14 <= #1 {24'b0, wb_dat8_o14};
			4'b0010: wb_dat_o14 <= #1 {16'b0, wb_dat8_o14, 8'b0};
			4'b0100: wb_dat_o14 <= #1 {8'b0, wb_dat8_o14, 16'b0};
			4'b1000: wb_dat_o14 <= #1 {wb_dat8_o14, 24'b0};
			4'b1111: wb_dat_o14 <= #1 wb_dat32_o14; // debug14 interface output
 			default: wb_dat_o14 <= #1 0;
		endcase // case(wb_sel_i14)

reg [1:0] wb_adr_int_lsb14;

always @(wb_sel_is14 or wb_dat_is14)
begin
	case (wb_sel_is14)
		4'b0001 : wb_dat8_i14 = wb_dat_is14[7:0];
		4'b0010 : wb_dat8_i14 = wb_dat_is14[15:8];
		4'b0100 : wb_dat8_i14 = wb_dat_is14[23:16];
		4'b1000 : wb_dat8_i14 = wb_dat_is14[31:24];
		default : wb_dat8_i14 = wb_dat_is14[7:0];
	endcase // case(wb_sel_i14)

  `ifdef LITLE_ENDIAN14
	case (wb_sel_is14)
		4'b0001 : wb_adr_int_lsb14 = 2'h0;
		4'b0010 : wb_adr_int_lsb14 = 2'h1;
		4'b0100 : wb_adr_int_lsb14 = 2'h2;
		4'b1000 : wb_adr_int_lsb14 = 2'h3;
		default : wb_adr_int_lsb14 = 2'h0;
	endcase // case(wb_sel_i14)
  `else
	case (wb_sel_is14)
		4'b0001 : wb_adr_int_lsb14 = 2'h3;
		4'b0010 : wb_adr_int_lsb14 = 2'h2;
		4'b0100 : wb_adr_int_lsb14 = 2'h1;
		4'b1000 : wb_adr_int_lsb14 = 2'h0;
		default : wb_adr_int_lsb14 = 2'h0;
	endcase // case(wb_sel_i14)
  `endif
end

assign wb_adr_int14 = {wb_adr_is14[`UART_ADDR_WIDTH14-1:2], wb_adr_int_lsb14};

`endif // !`ifdef DATA_BUS_WIDTH_814

endmodule










