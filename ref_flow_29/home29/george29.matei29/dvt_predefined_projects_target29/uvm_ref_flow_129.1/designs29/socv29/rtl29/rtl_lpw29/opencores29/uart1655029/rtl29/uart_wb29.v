//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb29.v                                                   ////
////                                                              ////
////                                                              ////
////  This29 file is part of the "UART29 16550 compatible29" project29    ////
////  http29://www29.opencores29.org29/cores29/uart1655029/                   ////
////                                                              ////
////  Documentation29 related29 to this project29:                      ////
////  - http29://www29.opencores29.org29/cores29/uart1655029/                 ////
////                                                              ////
////  Projects29 compatibility29:                                     ////
////  - WISHBONE29                                                  ////
////  RS23229 Protocol29                                              ////
////  16550D uart29 (mostly29 supported)                              ////
////                                                              ////
////  Overview29 (main29 Features29):                                   ////
////  UART29 core29 WISHBONE29 interface.                               ////
////                                                              ////
////  Known29 problems29 (limits29):                                    ////
////  Inserts29 one wait state on all transfers29.                    ////
////  Note29 affected29 signals29 and the way29 they are affected29.        ////
////                                                              ////
////  To29 Do29:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author29(s):                                                  ////
////      - gorban29@opencores29.org29                                  ////
////      - Jacob29 Gorban29                                          ////
////      - Igor29 Mohor29 (igorm29@opencores29.org29)                      ////
////                                                              ////
////  Created29:        2001/05/12                                  ////
////  Last29 Updated29:   2001/05/17                                  ////
////                  (See log29 for the revision29 history29)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2000, 2001 Authors29                             ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS29 Revision29 History29
//
// $Log: not supported by cvs2svn29 $
// Revision29 1.16  2002/07/29 21:16:18  gorban29
// The uart_defines29.v file is included29 again29 in sources29.
//
// Revision29 1.15  2002/07/22 23:02:23  gorban29
// Bug29 Fixes29:
//  * Possible29 loss of sync and bad29 reception29 of stop bit on slow29 baud29 rates29 fixed29.
//   Problem29 reported29 by Kenny29.Tung29.
//  * Bad (or lack29 of ) loopback29 handling29 fixed29. Reported29 by Cherry29 Withers29.
//
// Improvements29:
//  * Made29 FIFO's as general29 inferrable29 memory where possible29.
//  So29 on FPGA29 they should be inferred29 as RAM29 (Distributed29 RAM29 on Xilinx29).
//  This29 saves29 about29 1/3 of the Slice29 count and reduces29 P&R and synthesis29 times.
//
//  * Added29 optional29 baudrate29 output (baud_o29).
//  This29 is identical29 to BAUDOUT29* signal29 on 16550 chip29.
//  It outputs29 16xbit_clock_rate - the divided29 clock29.
//  It's disabled by default. Define29 UART_HAS_BAUDRATE_OUTPUT29 to use.
//
// Revision29 1.12  2001/12/19 08:03:34  mohor29
// Warnings29 cleared29.
//
// Revision29 1.11  2001/12/06 14:51:04  gorban29
// Bug29 in LSR29[0] is fixed29.
// All WISHBONE29 signals29 are now sampled29, so another29 wait-state is introduced29 on all transfers29.
//
// Revision29 1.10  2001/12/03 21:44:29  gorban29
// Updated29 specification29 documentation.
// Added29 full 32-bit data bus interface, now as default.
// Address is 5-bit wide29 in 32-bit data bus mode.
// Added29 wb_sel_i29 input to the core29. It's used in the 32-bit mode.
// Added29 debug29 interface with two29 32-bit read-only registers in 32-bit mode.
// Bits29 5 and 6 of LSR29 are now only cleared29 on TX29 FIFO write.
// My29 small test bench29 is modified to work29 with 32-bit mode.
//
// Revision29 1.9  2001/10/20 09:58:40  gorban29
// Small29 synopsis29 fixes29
//
// Revision29 1.8  2001/08/24 21:01:12  mohor29
// Things29 connected29 to parity29 changed.
// Clock29 devider29 changed.
//
// Revision29 1.7  2001/08/23 16:05:05  mohor29
// Stop bit bug29 fixed29.
// Parity29 bug29 fixed29.
// WISHBONE29 read cycle bug29 fixed29,
// OE29 indicator29 (Overrun29 Error) bug29 fixed29.
// PE29 indicator29 (Parity29 Error) bug29 fixed29.
// Register read bug29 fixed29.
//
// Revision29 1.4  2001/05/31 20:08:01  gorban29
// FIFO changes29 and other corrections29.
//
// Revision29 1.3  2001/05/21 19:12:01  gorban29
// Corrected29 some29 Linter29 messages29.
//
// Revision29 1.2  2001/05/17 18:34:18  gorban29
// First29 'stable' release. Should29 be sythesizable29 now. Also29 added new header.
//
// Revision29 1.0  2001-05-17 21:27:13+02  jacob29
// Initial29 revision29
//
//

// UART29 core29 WISHBONE29 interface 
//
// Author29: Jacob29 Gorban29   (jacob29.gorban29@flextronicssemi29.com29)
// Company29: Flextronics29 Semiconductor29
//

// synopsys29 translate_off29
`include "timescale.v"
// synopsys29 translate_on29
`include "uart_defines29.v"
 
module uart_wb29 (clk29, wb_rst_i29, 
	wb_we_i29, wb_stb_i29, wb_cyc_i29, wb_ack_o29, wb_adr_i29,
	wb_adr_int29, wb_dat_i29, wb_dat_o29, wb_dat8_i29, wb_dat8_o29, wb_dat32_o29, wb_sel_i29,
	we_o29, re_o29 // Write and read enable output for the core29
);

input 		  clk29;

// WISHBONE29 interface	
input 		  wb_rst_i29;
input 		  wb_we_i29;
input 		  wb_stb_i29;
input 		  wb_cyc_i29;
input [3:0]   wb_sel_i29;
input [`UART_ADDR_WIDTH29-1:0] 	wb_adr_i29; //WISHBONE29 address line

`ifdef DATA_BUS_WIDTH_829
input [7:0]  wb_dat_i29; //input WISHBONE29 bus 
output [7:0] wb_dat_o29;
reg [7:0] 	 wb_dat_o29;
wire [7:0] 	 wb_dat_i29;
reg [7:0] 	 wb_dat_is29;
`else // for 32 data bus mode
input [31:0]  wb_dat_i29; //input WISHBONE29 bus 
output [31:0] wb_dat_o29;
reg [31:0] 	  wb_dat_o29;
wire [31:0]   wb_dat_i29;
reg [31:0] 	  wb_dat_is29;
`endif // !`ifdef DATA_BUS_WIDTH_829

output [`UART_ADDR_WIDTH29-1:0]	wb_adr_int29; // internal signal29 for address bus
input [7:0]   wb_dat8_o29; // internal 8 bit output to be put into wb_dat_o29
output [7:0]  wb_dat8_i29;
input [31:0]  wb_dat32_o29; // 32 bit data output (for debug29 interface)
output 		  wb_ack_o29;
output 		  we_o29;
output 		  re_o29;

wire 			  we_o29;
reg 			  wb_ack_o29;
reg [7:0] 	  wb_dat8_i29;
wire [7:0] 	  wb_dat8_o29;
wire [`UART_ADDR_WIDTH29-1:0]	wb_adr_int29; // internal signal29 for address bus
reg [`UART_ADDR_WIDTH29-1:0]	wb_adr_is29;
reg 								wb_we_is29;
reg 								wb_cyc_is29;
reg 								wb_stb_is29;
reg [3:0] 						wb_sel_is29;
wire [3:0]   wb_sel_i29;
reg 			 wre29 ;// timing29 control29 signal29 for write or read enable

// wb_ack_o29 FSM29
reg [1:0] 	 wbstate29;
always  @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) begin
		wb_ack_o29 <= #1 1'b0;
		wbstate29 <= #1 0;
		wre29 <= #1 1'b1;
	end else
		case (wbstate29)
			0: begin
				if (wb_stb_is29 & wb_cyc_is29) begin
					wre29 <= #1 0;
					wbstate29 <= #1 1;
					wb_ack_o29 <= #1 1;
				end else begin
					wre29 <= #1 1;
					wb_ack_o29 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o29 <= #1 0;
				wbstate29 <= #1 2;
				wre29 <= #1 0;
			end
			2,3: begin
				wb_ack_o29 <= #1 0;
				wbstate29 <= #1 0;
				wre29 <= #1 0;
			end
		endcase

assign we_o29 =  wb_we_is29 & wb_stb_is29 & wb_cyc_is29 & wre29 ; //WE29 for registers	
assign re_o29 = ~wb_we_is29 & wb_stb_is29 & wb_cyc_is29 & wre29 ; //RE29 for registers	

// Sample29 input signals29
always  @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29) begin
		wb_adr_is29 <= #1 0;
		wb_we_is29 <= #1 0;
		wb_cyc_is29 <= #1 0;
		wb_stb_is29 <= #1 0;
		wb_dat_is29 <= #1 0;
		wb_sel_is29 <= #1 0;
	end else begin
		wb_adr_is29 <= #1 wb_adr_i29;
		wb_we_is29 <= #1 wb_we_i29;
		wb_cyc_is29 <= #1 wb_cyc_i29;
		wb_stb_is29 <= #1 wb_stb_i29;
		wb_dat_is29 <= #1 wb_dat_i29;
		wb_sel_is29 <= #1 wb_sel_i29;
	end

`ifdef DATA_BUS_WIDTH_829 // 8-bit data bus
always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29)
		wb_dat_o29 <= #1 0;
	else
		wb_dat_o29 <= #1 wb_dat8_o29;

always @(wb_dat_is29)
	wb_dat8_i29 = wb_dat_is29;

assign wb_adr_int29 = wb_adr_is29;

`else // 32-bit bus
// put output to the correct29 byte in 32 bits using select29 line
always @(posedge clk29 or posedge wb_rst_i29)
	if (wb_rst_i29)
		wb_dat_o29 <= #1 0;
	else if (re_o29)
		case (wb_sel_is29)
			4'b0001: wb_dat_o29 <= #1 {24'b0, wb_dat8_o29};
			4'b0010: wb_dat_o29 <= #1 {16'b0, wb_dat8_o29, 8'b0};
			4'b0100: wb_dat_o29 <= #1 {8'b0, wb_dat8_o29, 16'b0};
			4'b1000: wb_dat_o29 <= #1 {wb_dat8_o29, 24'b0};
			4'b1111: wb_dat_o29 <= #1 wb_dat32_o29; // debug29 interface output
 			default: wb_dat_o29 <= #1 0;
		endcase // case(wb_sel_i29)

reg [1:0] wb_adr_int_lsb29;

always @(wb_sel_is29 or wb_dat_is29)
begin
	case (wb_sel_is29)
		4'b0001 : wb_dat8_i29 = wb_dat_is29[7:0];
		4'b0010 : wb_dat8_i29 = wb_dat_is29[15:8];
		4'b0100 : wb_dat8_i29 = wb_dat_is29[23:16];
		4'b1000 : wb_dat8_i29 = wb_dat_is29[31:24];
		default : wb_dat8_i29 = wb_dat_is29[7:0];
	endcase // case(wb_sel_i29)

  `ifdef LITLE_ENDIAN29
	case (wb_sel_is29)
		4'b0001 : wb_adr_int_lsb29 = 2'h0;
		4'b0010 : wb_adr_int_lsb29 = 2'h1;
		4'b0100 : wb_adr_int_lsb29 = 2'h2;
		4'b1000 : wb_adr_int_lsb29 = 2'h3;
		default : wb_adr_int_lsb29 = 2'h0;
	endcase // case(wb_sel_i29)
  `else
	case (wb_sel_is29)
		4'b0001 : wb_adr_int_lsb29 = 2'h3;
		4'b0010 : wb_adr_int_lsb29 = 2'h2;
		4'b0100 : wb_adr_int_lsb29 = 2'h1;
		4'b1000 : wb_adr_int_lsb29 = 2'h0;
		default : wb_adr_int_lsb29 = 2'h0;
	endcase // case(wb_sel_i29)
  `endif
end

assign wb_adr_int29 = {wb_adr_is29[`UART_ADDR_WIDTH29-1:2], wb_adr_int_lsb29};

`endif // !`ifdef DATA_BUS_WIDTH_829

endmodule










