//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb24.v                                                   ////
////                                                              ////
////                                                              ////
////  This24 file is part of the "UART24 16550 compatible24" project24    ////
////  http24://www24.opencores24.org24/cores24/uart1655024/                   ////
////                                                              ////
////  Documentation24 related24 to this project24:                      ////
////  - http24://www24.opencores24.org24/cores24/uart1655024/                 ////
////                                                              ////
////  Projects24 compatibility24:                                     ////
////  - WISHBONE24                                                  ////
////  RS23224 Protocol24                                              ////
////  16550D uart24 (mostly24 supported)                              ////
////                                                              ////
////  Overview24 (main24 Features24):                                   ////
////  UART24 core24 WISHBONE24 interface.                               ////
////                                                              ////
////  Known24 problems24 (limits24):                                    ////
////  Inserts24 one wait state on all transfers24.                    ////
////  Note24 affected24 signals24 and the way24 they are affected24.        ////
////                                                              ////
////  To24 Do24:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author24(s):                                                  ////
////      - gorban24@opencores24.org24                                  ////
////      - Jacob24 Gorban24                                          ////
////      - Igor24 Mohor24 (igorm24@opencores24.org24)                      ////
////                                                              ////
////  Created24:        2001/05/12                                  ////
////  Last24 Updated24:   2001/05/17                                  ////
////                  (See log24 for the revision24 history24)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright24 (C) 2000, 2001 Authors24                             ////
////                                                              ////
//// This24 source24 file may be used and distributed24 without         ////
//// restriction24 provided that this copyright24 statement24 is not    ////
//// removed from the file and that any derivative24 work24 contains24  ////
//// the original copyright24 notice24 and the associated disclaimer24. ////
////                                                              ////
//// This24 source24 file is free software24; you can redistribute24 it   ////
//// and/or modify it under the terms24 of the GNU24 Lesser24 General24   ////
//// Public24 License24 as published24 by the Free24 Software24 Foundation24; ////
//// either24 version24 2.1 of the License24, or (at your24 option) any   ////
//// later24 version24.                                               ////
////                                                              ////
//// This24 source24 is distributed24 in the hope24 that it will be       ////
//// useful24, but WITHOUT24 ANY24 WARRANTY24; without even24 the implied24   ////
//// warranty24 of MERCHANTABILITY24 or FITNESS24 FOR24 A PARTICULAR24      ////
//// PURPOSE24.  See the GNU24 Lesser24 General24 Public24 License24 for more ////
//// details24.                                                     ////
////                                                              ////
//// You should have received24 a copy of the GNU24 Lesser24 General24    ////
//// Public24 License24 along24 with this source24; if not, download24 it   ////
//// from http24://www24.opencores24.org24/lgpl24.shtml24                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS24 Revision24 History24
//
// $Log: not supported by cvs2svn24 $
// Revision24 1.16  2002/07/29 21:16:18  gorban24
// The uart_defines24.v file is included24 again24 in sources24.
//
// Revision24 1.15  2002/07/22 23:02:23  gorban24
// Bug24 Fixes24:
//  * Possible24 loss of sync and bad24 reception24 of stop bit on slow24 baud24 rates24 fixed24.
//   Problem24 reported24 by Kenny24.Tung24.
//  * Bad (or lack24 of ) loopback24 handling24 fixed24. Reported24 by Cherry24 Withers24.
//
// Improvements24:
//  * Made24 FIFO's as general24 inferrable24 memory where possible24.
//  So24 on FPGA24 they should be inferred24 as RAM24 (Distributed24 RAM24 on Xilinx24).
//  This24 saves24 about24 1/3 of the Slice24 count and reduces24 P&R and synthesis24 times.
//
//  * Added24 optional24 baudrate24 output (baud_o24).
//  This24 is identical24 to BAUDOUT24* signal24 on 16550 chip24.
//  It outputs24 16xbit_clock_rate - the divided24 clock24.
//  It's disabled by default. Define24 UART_HAS_BAUDRATE_OUTPUT24 to use.
//
// Revision24 1.12  2001/12/19 08:03:34  mohor24
// Warnings24 cleared24.
//
// Revision24 1.11  2001/12/06 14:51:04  gorban24
// Bug24 in LSR24[0] is fixed24.
// All WISHBONE24 signals24 are now sampled24, so another24 wait-state is introduced24 on all transfers24.
//
// Revision24 1.10  2001/12/03 21:44:29  gorban24
// Updated24 specification24 documentation.
// Added24 full 32-bit data bus interface, now as default.
// Address is 5-bit wide24 in 32-bit data bus mode.
// Added24 wb_sel_i24 input to the core24. It's used in the 32-bit mode.
// Added24 debug24 interface with two24 32-bit read-only registers in 32-bit mode.
// Bits24 5 and 6 of LSR24 are now only cleared24 on TX24 FIFO write.
// My24 small test bench24 is modified to work24 with 32-bit mode.
//
// Revision24 1.9  2001/10/20 09:58:40  gorban24
// Small24 synopsis24 fixes24
//
// Revision24 1.8  2001/08/24 21:01:12  mohor24
// Things24 connected24 to parity24 changed.
// Clock24 devider24 changed.
//
// Revision24 1.7  2001/08/23 16:05:05  mohor24
// Stop bit bug24 fixed24.
// Parity24 bug24 fixed24.
// WISHBONE24 read cycle bug24 fixed24,
// OE24 indicator24 (Overrun24 Error) bug24 fixed24.
// PE24 indicator24 (Parity24 Error) bug24 fixed24.
// Register read bug24 fixed24.
//
// Revision24 1.4  2001/05/31 20:08:01  gorban24
// FIFO changes24 and other corrections24.
//
// Revision24 1.3  2001/05/21 19:12:01  gorban24
// Corrected24 some24 Linter24 messages24.
//
// Revision24 1.2  2001/05/17 18:34:18  gorban24
// First24 'stable' release. Should24 be sythesizable24 now. Also24 added new header.
//
// Revision24 1.0  2001-05-17 21:27:13+02  jacob24
// Initial24 revision24
//
//

// UART24 core24 WISHBONE24 interface 
//
// Author24: Jacob24 Gorban24   (jacob24.gorban24@flextronicssemi24.com24)
// Company24: Flextronics24 Semiconductor24
//

// synopsys24 translate_off24
`include "timescale.v"
// synopsys24 translate_on24
`include "uart_defines24.v"
 
module uart_wb24 (clk24, wb_rst_i24, 
	wb_we_i24, wb_stb_i24, wb_cyc_i24, wb_ack_o24, wb_adr_i24,
	wb_adr_int24, wb_dat_i24, wb_dat_o24, wb_dat8_i24, wb_dat8_o24, wb_dat32_o24, wb_sel_i24,
	we_o24, re_o24 // Write and read enable output for the core24
);

input 		  clk24;

// WISHBONE24 interface	
input 		  wb_rst_i24;
input 		  wb_we_i24;
input 		  wb_stb_i24;
input 		  wb_cyc_i24;
input [3:0]   wb_sel_i24;
input [`UART_ADDR_WIDTH24-1:0] 	wb_adr_i24; //WISHBONE24 address line

`ifdef DATA_BUS_WIDTH_824
input [7:0]  wb_dat_i24; //input WISHBONE24 bus 
output [7:0] wb_dat_o24;
reg [7:0] 	 wb_dat_o24;
wire [7:0] 	 wb_dat_i24;
reg [7:0] 	 wb_dat_is24;
`else // for 32 data bus mode
input [31:0]  wb_dat_i24; //input WISHBONE24 bus 
output [31:0] wb_dat_o24;
reg [31:0] 	  wb_dat_o24;
wire [31:0]   wb_dat_i24;
reg [31:0] 	  wb_dat_is24;
`endif // !`ifdef DATA_BUS_WIDTH_824

output [`UART_ADDR_WIDTH24-1:0]	wb_adr_int24; // internal signal24 for address bus
input [7:0]   wb_dat8_o24; // internal 8 bit output to be put into wb_dat_o24
output [7:0]  wb_dat8_i24;
input [31:0]  wb_dat32_o24; // 32 bit data output (for debug24 interface)
output 		  wb_ack_o24;
output 		  we_o24;
output 		  re_o24;

wire 			  we_o24;
reg 			  wb_ack_o24;
reg [7:0] 	  wb_dat8_i24;
wire [7:0] 	  wb_dat8_o24;
wire [`UART_ADDR_WIDTH24-1:0]	wb_adr_int24; // internal signal24 for address bus
reg [`UART_ADDR_WIDTH24-1:0]	wb_adr_is24;
reg 								wb_we_is24;
reg 								wb_cyc_is24;
reg 								wb_stb_is24;
reg [3:0] 						wb_sel_is24;
wire [3:0]   wb_sel_i24;
reg 			 wre24 ;// timing24 control24 signal24 for write or read enable

// wb_ack_o24 FSM24
reg [1:0] 	 wbstate24;
always  @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) begin
		wb_ack_o24 <= #1 1'b0;
		wbstate24 <= #1 0;
		wre24 <= #1 1'b1;
	end else
		case (wbstate24)
			0: begin
				if (wb_stb_is24 & wb_cyc_is24) begin
					wre24 <= #1 0;
					wbstate24 <= #1 1;
					wb_ack_o24 <= #1 1;
				end else begin
					wre24 <= #1 1;
					wb_ack_o24 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o24 <= #1 0;
				wbstate24 <= #1 2;
				wre24 <= #1 0;
			end
			2,3: begin
				wb_ack_o24 <= #1 0;
				wbstate24 <= #1 0;
				wre24 <= #1 0;
			end
		endcase

assign we_o24 =  wb_we_is24 & wb_stb_is24 & wb_cyc_is24 & wre24 ; //WE24 for registers	
assign re_o24 = ~wb_we_is24 & wb_stb_is24 & wb_cyc_is24 & wre24 ; //RE24 for registers	

// Sample24 input signals24
always  @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24) begin
		wb_adr_is24 <= #1 0;
		wb_we_is24 <= #1 0;
		wb_cyc_is24 <= #1 0;
		wb_stb_is24 <= #1 0;
		wb_dat_is24 <= #1 0;
		wb_sel_is24 <= #1 0;
	end else begin
		wb_adr_is24 <= #1 wb_adr_i24;
		wb_we_is24 <= #1 wb_we_i24;
		wb_cyc_is24 <= #1 wb_cyc_i24;
		wb_stb_is24 <= #1 wb_stb_i24;
		wb_dat_is24 <= #1 wb_dat_i24;
		wb_sel_is24 <= #1 wb_sel_i24;
	end

`ifdef DATA_BUS_WIDTH_824 // 8-bit data bus
always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24)
		wb_dat_o24 <= #1 0;
	else
		wb_dat_o24 <= #1 wb_dat8_o24;

always @(wb_dat_is24)
	wb_dat8_i24 = wb_dat_is24;

assign wb_adr_int24 = wb_adr_is24;

`else // 32-bit bus
// put output to the correct24 byte in 32 bits using select24 line
always @(posedge clk24 or posedge wb_rst_i24)
	if (wb_rst_i24)
		wb_dat_o24 <= #1 0;
	else if (re_o24)
		case (wb_sel_is24)
			4'b0001: wb_dat_o24 <= #1 {24'b0, wb_dat8_o24};
			4'b0010: wb_dat_o24 <= #1 {16'b0, wb_dat8_o24, 8'b0};
			4'b0100: wb_dat_o24 <= #1 {8'b0, wb_dat8_o24, 16'b0};
			4'b1000: wb_dat_o24 <= #1 {wb_dat8_o24, 24'b0};
			4'b1111: wb_dat_o24 <= #1 wb_dat32_o24; // debug24 interface output
 			default: wb_dat_o24 <= #1 0;
		endcase // case(wb_sel_i24)

reg [1:0] wb_adr_int_lsb24;

always @(wb_sel_is24 or wb_dat_is24)
begin
	case (wb_sel_is24)
		4'b0001 : wb_dat8_i24 = wb_dat_is24[7:0];
		4'b0010 : wb_dat8_i24 = wb_dat_is24[15:8];
		4'b0100 : wb_dat8_i24 = wb_dat_is24[23:16];
		4'b1000 : wb_dat8_i24 = wb_dat_is24[31:24];
		default : wb_dat8_i24 = wb_dat_is24[7:0];
	endcase // case(wb_sel_i24)

  `ifdef LITLE_ENDIAN24
	case (wb_sel_is24)
		4'b0001 : wb_adr_int_lsb24 = 2'h0;
		4'b0010 : wb_adr_int_lsb24 = 2'h1;
		4'b0100 : wb_adr_int_lsb24 = 2'h2;
		4'b1000 : wb_adr_int_lsb24 = 2'h3;
		default : wb_adr_int_lsb24 = 2'h0;
	endcase // case(wb_sel_i24)
  `else
	case (wb_sel_is24)
		4'b0001 : wb_adr_int_lsb24 = 2'h3;
		4'b0010 : wb_adr_int_lsb24 = 2'h2;
		4'b0100 : wb_adr_int_lsb24 = 2'h1;
		4'b1000 : wb_adr_int_lsb24 = 2'h0;
		default : wb_adr_int_lsb24 = 2'h0;
	endcase // case(wb_sel_i24)
  `endif
end

assign wb_adr_int24 = {wb_adr_is24[`UART_ADDR_WIDTH24-1:2], wb_adr_int_lsb24};

`endif // !`ifdef DATA_BUS_WIDTH_824

endmodule










