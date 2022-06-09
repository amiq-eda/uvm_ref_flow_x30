//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb15.v                                                   ////
////                                                              ////
////                                                              ////
////  This15 file is part of the "UART15 16550 compatible15" project15    ////
////  http15://www15.opencores15.org15/cores15/uart1655015/                   ////
////                                                              ////
////  Documentation15 related15 to this project15:                      ////
////  - http15://www15.opencores15.org15/cores15/uart1655015/                 ////
////                                                              ////
////  Projects15 compatibility15:                                     ////
////  - WISHBONE15                                                  ////
////  RS23215 Protocol15                                              ////
////  16550D uart15 (mostly15 supported)                              ////
////                                                              ////
////  Overview15 (main15 Features15):                                   ////
////  UART15 core15 WISHBONE15 interface.                               ////
////                                                              ////
////  Known15 problems15 (limits15):                                    ////
////  Inserts15 one wait state on all transfers15.                    ////
////  Note15 affected15 signals15 and the way15 they are affected15.        ////
////                                                              ////
////  To15 Do15:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author15(s):                                                  ////
////      - gorban15@opencores15.org15                                  ////
////      - Jacob15 Gorban15                                          ////
////      - Igor15 Mohor15 (igorm15@opencores15.org15)                      ////
////                                                              ////
////  Created15:        2001/05/12                                  ////
////  Last15 Updated15:   2001/05/17                                  ////
////                  (See log15 for the revision15 history15)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2000, 2001 Authors15                             ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS15 Revision15 History15
//
// $Log: not supported by cvs2svn15 $
// Revision15 1.16  2002/07/29 21:16:18  gorban15
// The uart_defines15.v file is included15 again15 in sources15.
//
// Revision15 1.15  2002/07/22 23:02:23  gorban15
// Bug15 Fixes15:
//  * Possible15 loss of sync and bad15 reception15 of stop bit on slow15 baud15 rates15 fixed15.
//   Problem15 reported15 by Kenny15.Tung15.
//  * Bad (or lack15 of ) loopback15 handling15 fixed15. Reported15 by Cherry15 Withers15.
//
// Improvements15:
//  * Made15 FIFO's as general15 inferrable15 memory where possible15.
//  So15 on FPGA15 they should be inferred15 as RAM15 (Distributed15 RAM15 on Xilinx15).
//  This15 saves15 about15 1/3 of the Slice15 count and reduces15 P&R and synthesis15 times.
//
//  * Added15 optional15 baudrate15 output (baud_o15).
//  This15 is identical15 to BAUDOUT15* signal15 on 16550 chip15.
//  It outputs15 16xbit_clock_rate - the divided15 clock15.
//  It's disabled by default. Define15 UART_HAS_BAUDRATE_OUTPUT15 to use.
//
// Revision15 1.12  2001/12/19 08:03:34  mohor15
// Warnings15 cleared15.
//
// Revision15 1.11  2001/12/06 14:51:04  gorban15
// Bug15 in LSR15[0] is fixed15.
// All WISHBONE15 signals15 are now sampled15, so another15 wait-state is introduced15 on all transfers15.
//
// Revision15 1.10  2001/12/03 21:44:29  gorban15
// Updated15 specification15 documentation.
// Added15 full 32-bit data bus interface, now as default.
// Address is 5-bit wide15 in 32-bit data bus mode.
// Added15 wb_sel_i15 input to the core15. It's used in the 32-bit mode.
// Added15 debug15 interface with two15 32-bit read-only registers in 32-bit mode.
// Bits15 5 and 6 of LSR15 are now only cleared15 on TX15 FIFO write.
// My15 small test bench15 is modified to work15 with 32-bit mode.
//
// Revision15 1.9  2001/10/20 09:58:40  gorban15
// Small15 synopsis15 fixes15
//
// Revision15 1.8  2001/08/24 21:01:12  mohor15
// Things15 connected15 to parity15 changed.
// Clock15 devider15 changed.
//
// Revision15 1.7  2001/08/23 16:05:05  mohor15
// Stop bit bug15 fixed15.
// Parity15 bug15 fixed15.
// WISHBONE15 read cycle bug15 fixed15,
// OE15 indicator15 (Overrun15 Error) bug15 fixed15.
// PE15 indicator15 (Parity15 Error) bug15 fixed15.
// Register read bug15 fixed15.
//
// Revision15 1.4  2001/05/31 20:08:01  gorban15
// FIFO changes15 and other corrections15.
//
// Revision15 1.3  2001/05/21 19:12:01  gorban15
// Corrected15 some15 Linter15 messages15.
//
// Revision15 1.2  2001/05/17 18:34:18  gorban15
// First15 'stable' release. Should15 be sythesizable15 now. Also15 added new header.
//
// Revision15 1.0  2001-05-17 21:27:13+02  jacob15
// Initial15 revision15
//
//

// UART15 core15 WISHBONE15 interface 
//
// Author15: Jacob15 Gorban15   (jacob15.gorban15@flextronicssemi15.com15)
// Company15: Flextronics15 Semiconductor15
//

// synopsys15 translate_off15
`include "timescale.v"
// synopsys15 translate_on15
`include "uart_defines15.v"
 
module uart_wb15 (clk15, wb_rst_i15, 
	wb_we_i15, wb_stb_i15, wb_cyc_i15, wb_ack_o15, wb_adr_i15,
	wb_adr_int15, wb_dat_i15, wb_dat_o15, wb_dat8_i15, wb_dat8_o15, wb_dat32_o15, wb_sel_i15,
	we_o15, re_o15 // Write and read enable output for the core15
);

input 		  clk15;

// WISHBONE15 interface	
input 		  wb_rst_i15;
input 		  wb_we_i15;
input 		  wb_stb_i15;
input 		  wb_cyc_i15;
input [3:0]   wb_sel_i15;
input [`UART_ADDR_WIDTH15-1:0] 	wb_adr_i15; //WISHBONE15 address line

`ifdef DATA_BUS_WIDTH_815
input [7:0]  wb_dat_i15; //input WISHBONE15 bus 
output [7:0] wb_dat_o15;
reg [7:0] 	 wb_dat_o15;
wire [7:0] 	 wb_dat_i15;
reg [7:0] 	 wb_dat_is15;
`else // for 32 data bus mode
input [31:0]  wb_dat_i15; //input WISHBONE15 bus 
output [31:0] wb_dat_o15;
reg [31:0] 	  wb_dat_o15;
wire [31:0]   wb_dat_i15;
reg [31:0] 	  wb_dat_is15;
`endif // !`ifdef DATA_BUS_WIDTH_815

output [`UART_ADDR_WIDTH15-1:0]	wb_adr_int15; // internal signal15 for address bus
input [7:0]   wb_dat8_o15; // internal 8 bit output to be put into wb_dat_o15
output [7:0]  wb_dat8_i15;
input [31:0]  wb_dat32_o15; // 32 bit data output (for debug15 interface)
output 		  wb_ack_o15;
output 		  we_o15;
output 		  re_o15;

wire 			  we_o15;
reg 			  wb_ack_o15;
reg [7:0] 	  wb_dat8_i15;
wire [7:0] 	  wb_dat8_o15;
wire [`UART_ADDR_WIDTH15-1:0]	wb_adr_int15; // internal signal15 for address bus
reg [`UART_ADDR_WIDTH15-1:0]	wb_adr_is15;
reg 								wb_we_is15;
reg 								wb_cyc_is15;
reg 								wb_stb_is15;
reg [3:0] 						wb_sel_is15;
wire [3:0]   wb_sel_i15;
reg 			 wre15 ;// timing15 control15 signal15 for write or read enable

// wb_ack_o15 FSM15
reg [1:0] 	 wbstate15;
always  @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) begin
		wb_ack_o15 <= #1 1'b0;
		wbstate15 <= #1 0;
		wre15 <= #1 1'b1;
	end else
		case (wbstate15)
			0: begin
				if (wb_stb_is15 & wb_cyc_is15) begin
					wre15 <= #1 0;
					wbstate15 <= #1 1;
					wb_ack_o15 <= #1 1;
				end else begin
					wre15 <= #1 1;
					wb_ack_o15 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o15 <= #1 0;
				wbstate15 <= #1 2;
				wre15 <= #1 0;
			end
			2,3: begin
				wb_ack_o15 <= #1 0;
				wbstate15 <= #1 0;
				wre15 <= #1 0;
			end
		endcase

assign we_o15 =  wb_we_is15 & wb_stb_is15 & wb_cyc_is15 & wre15 ; //WE15 for registers	
assign re_o15 = ~wb_we_is15 & wb_stb_is15 & wb_cyc_is15 & wre15 ; //RE15 for registers	

// Sample15 input signals15
always  @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15) begin
		wb_adr_is15 <= #1 0;
		wb_we_is15 <= #1 0;
		wb_cyc_is15 <= #1 0;
		wb_stb_is15 <= #1 0;
		wb_dat_is15 <= #1 0;
		wb_sel_is15 <= #1 0;
	end else begin
		wb_adr_is15 <= #1 wb_adr_i15;
		wb_we_is15 <= #1 wb_we_i15;
		wb_cyc_is15 <= #1 wb_cyc_i15;
		wb_stb_is15 <= #1 wb_stb_i15;
		wb_dat_is15 <= #1 wb_dat_i15;
		wb_sel_is15 <= #1 wb_sel_i15;
	end

`ifdef DATA_BUS_WIDTH_815 // 8-bit data bus
always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15)
		wb_dat_o15 <= #1 0;
	else
		wb_dat_o15 <= #1 wb_dat8_o15;

always @(wb_dat_is15)
	wb_dat8_i15 = wb_dat_is15;

assign wb_adr_int15 = wb_adr_is15;

`else // 32-bit bus
// put output to the correct15 byte in 32 bits using select15 line
always @(posedge clk15 or posedge wb_rst_i15)
	if (wb_rst_i15)
		wb_dat_o15 <= #1 0;
	else if (re_o15)
		case (wb_sel_is15)
			4'b0001: wb_dat_o15 <= #1 {24'b0, wb_dat8_o15};
			4'b0010: wb_dat_o15 <= #1 {16'b0, wb_dat8_o15, 8'b0};
			4'b0100: wb_dat_o15 <= #1 {8'b0, wb_dat8_o15, 16'b0};
			4'b1000: wb_dat_o15 <= #1 {wb_dat8_o15, 24'b0};
			4'b1111: wb_dat_o15 <= #1 wb_dat32_o15; // debug15 interface output
 			default: wb_dat_o15 <= #1 0;
		endcase // case(wb_sel_i15)

reg [1:0] wb_adr_int_lsb15;

always @(wb_sel_is15 or wb_dat_is15)
begin
	case (wb_sel_is15)
		4'b0001 : wb_dat8_i15 = wb_dat_is15[7:0];
		4'b0010 : wb_dat8_i15 = wb_dat_is15[15:8];
		4'b0100 : wb_dat8_i15 = wb_dat_is15[23:16];
		4'b1000 : wb_dat8_i15 = wb_dat_is15[31:24];
		default : wb_dat8_i15 = wb_dat_is15[7:0];
	endcase // case(wb_sel_i15)

  `ifdef LITLE_ENDIAN15
	case (wb_sel_is15)
		4'b0001 : wb_adr_int_lsb15 = 2'h0;
		4'b0010 : wb_adr_int_lsb15 = 2'h1;
		4'b0100 : wb_adr_int_lsb15 = 2'h2;
		4'b1000 : wb_adr_int_lsb15 = 2'h3;
		default : wb_adr_int_lsb15 = 2'h0;
	endcase // case(wb_sel_i15)
  `else
	case (wb_sel_is15)
		4'b0001 : wb_adr_int_lsb15 = 2'h3;
		4'b0010 : wb_adr_int_lsb15 = 2'h2;
		4'b0100 : wb_adr_int_lsb15 = 2'h1;
		4'b1000 : wb_adr_int_lsb15 = 2'h0;
		default : wb_adr_int_lsb15 = 2'h0;
	endcase // case(wb_sel_i15)
  `endif
end

assign wb_adr_int15 = {wb_adr_is15[`UART_ADDR_WIDTH15-1:2], wb_adr_int_lsb15};

`endif // !`ifdef DATA_BUS_WIDTH_815

endmodule










