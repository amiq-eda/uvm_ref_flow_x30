//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb16.v                                                   ////
////                                                              ////
////                                                              ////
////  This16 file is part of the "UART16 16550 compatible16" project16    ////
////  http16://www16.opencores16.org16/cores16/uart1655016/                   ////
////                                                              ////
////  Documentation16 related16 to this project16:                      ////
////  - http16://www16.opencores16.org16/cores16/uart1655016/                 ////
////                                                              ////
////  Projects16 compatibility16:                                     ////
////  - WISHBONE16                                                  ////
////  RS23216 Protocol16                                              ////
////  16550D uart16 (mostly16 supported)                              ////
////                                                              ////
////  Overview16 (main16 Features16):                                   ////
////  UART16 core16 WISHBONE16 interface.                               ////
////                                                              ////
////  Known16 problems16 (limits16):                                    ////
////  Inserts16 one wait state on all transfers16.                    ////
////  Note16 affected16 signals16 and the way16 they are affected16.        ////
////                                                              ////
////  To16 Do16:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author16(s):                                                  ////
////      - gorban16@opencores16.org16                                  ////
////      - Jacob16 Gorban16                                          ////
////      - Igor16 Mohor16 (igorm16@opencores16.org16)                      ////
////                                                              ////
////  Created16:        2001/05/12                                  ////
////  Last16 Updated16:   2001/05/17                                  ////
////                  (See log16 for the revision16 history16)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2000, 2001 Authors16                             ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS16 Revision16 History16
//
// $Log: not supported by cvs2svn16 $
// Revision16 1.16  2002/07/29 21:16:18  gorban16
// The uart_defines16.v file is included16 again16 in sources16.
//
// Revision16 1.15  2002/07/22 23:02:23  gorban16
// Bug16 Fixes16:
//  * Possible16 loss of sync and bad16 reception16 of stop bit on slow16 baud16 rates16 fixed16.
//   Problem16 reported16 by Kenny16.Tung16.
//  * Bad (or lack16 of ) loopback16 handling16 fixed16. Reported16 by Cherry16 Withers16.
//
// Improvements16:
//  * Made16 FIFO's as general16 inferrable16 memory where possible16.
//  So16 on FPGA16 they should be inferred16 as RAM16 (Distributed16 RAM16 on Xilinx16).
//  This16 saves16 about16 1/3 of the Slice16 count and reduces16 P&R and synthesis16 times.
//
//  * Added16 optional16 baudrate16 output (baud_o16).
//  This16 is identical16 to BAUDOUT16* signal16 on 16550 chip16.
//  It outputs16 16xbit_clock_rate - the divided16 clock16.
//  It's disabled by default. Define16 UART_HAS_BAUDRATE_OUTPUT16 to use.
//
// Revision16 1.12  2001/12/19 08:03:34  mohor16
// Warnings16 cleared16.
//
// Revision16 1.11  2001/12/06 14:51:04  gorban16
// Bug16 in LSR16[0] is fixed16.
// All WISHBONE16 signals16 are now sampled16, so another16 wait-state is introduced16 on all transfers16.
//
// Revision16 1.10  2001/12/03 21:44:29  gorban16
// Updated16 specification16 documentation.
// Added16 full 32-bit data bus interface, now as default.
// Address is 5-bit wide16 in 32-bit data bus mode.
// Added16 wb_sel_i16 input to the core16. It's used in the 32-bit mode.
// Added16 debug16 interface with two16 32-bit read-only registers in 32-bit mode.
// Bits16 5 and 6 of LSR16 are now only cleared16 on TX16 FIFO write.
// My16 small test bench16 is modified to work16 with 32-bit mode.
//
// Revision16 1.9  2001/10/20 09:58:40  gorban16
// Small16 synopsis16 fixes16
//
// Revision16 1.8  2001/08/24 21:01:12  mohor16
// Things16 connected16 to parity16 changed.
// Clock16 devider16 changed.
//
// Revision16 1.7  2001/08/23 16:05:05  mohor16
// Stop bit bug16 fixed16.
// Parity16 bug16 fixed16.
// WISHBONE16 read cycle bug16 fixed16,
// OE16 indicator16 (Overrun16 Error) bug16 fixed16.
// PE16 indicator16 (Parity16 Error) bug16 fixed16.
// Register read bug16 fixed16.
//
// Revision16 1.4  2001/05/31 20:08:01  gorban16
// FIFO changes16 and other corrections16.
//
// Revision16 1.3  2001/05/21 19:12:01  gorban16
// Corrected16 some16 Linter16 messages16.
//
// Revision16 1.2  2001/05/17 18:34:18  gorban16
// First16 'stable' release. Should16 be sythesizable16 now. Also16 added new header.
//
// Revision16 1.0  2001-05-17 21:27:13+02  jacob16
// Initial16 revision16
//
//

// UART16 core16 WISHBONE16 interface 
//
// Author16: Jacob16 Gorban16   (jacob16.gorban16@flextronicssemi16.com16)
// Company16: Flextronics16 Semiconductor16
//

// synopsys16 translate_off16
`include "timescale.v"
// synopsys16 translate_on16
`include "uart_defines16.v"
 
module uart_wb16 (clk16, wb_rst_i16, 
	wb_we_i16, wb_stb_i16, wb_cyc_i16, wb_ack_o16, wb_adr_i16,
	wb_adr_int16, wb_dat_i16, wb_dat_o16, wb_dat8_i16, wb_dat8_o16, wb_dat32_o16, wb_sel_i16,
	we_o16, re_o16 // Write and read enable output for the core16
);

input 		  clk16;

// WISHBONE16 interface	
input 		  wb_rst_i16;
input 		  wb_we_i16;
input 		  wb_stb_i16;
input 		  wb_cyc_i16;
input [3:0]   wb_sel_i16;
input [`UART_ADDR_WIDTH16-1:0] 	wb_adr_i16; //WISHBONE16 address line

`ifdef DATA_BUS_WIDTH_816
input [7:0]  wb_dat_i16; //input WISHBONE16 bus 
output [7:0] wb_dat_o16;
reg [7:0] 	 wb_dat_o16;
wire [7:0] 	 wb_dat_i16;
reg [7:0] 	 wb_dat_is16;
`else // for 32 data bus mode
input [31:0]  wb_dat_i16; //input WISHBONE16 bus 
output [31:0] wb_dat_o16;
reg [31:0] 	  wb_dat_o16;
wire [31:0]   wb_dat_i16;
reg [31:0] 	  wb_dat_is16;
`endif // !`ifdef DATA_BUS_WIDTH_816

output [`UART_ADDR_WIDTH16-1:0]	wb_adr_int16; // internal signal16 for address bus
input [7:0]   wb_dat8_o16; // internal 8 bit output to be put into wb_dat_o16
output [7:0]  wb_dat8_i16;
input [31:0]  wb_dat32_o16; // 32 bit data output (for debug16 interface)
output 		  wb_ack_o16;
output 		  we_o16;
output 		  re_o16;

wire 			  we_o16;
reg 			  wb_ack_o16;
reg [7:0] 	  wb_dat8_i16;
wire [7:0] 	  wb_dat8_o16;
wire [`UART_ADDR_WIDTH16-1:0]	wb_adr_int16; // internal signal16 for address bus
reg [`UART_ADDR_WIDTH16-1:0]	wb_adr_is16;
reg 								wb_we_is16;
reg 								wb_cyc_is16;
reg 								wb_stb_is16;
reg [3:0] 						wb_sel_is16;
wire [3:0]   wb_sel_i16;
reg 			 wre16 ;// timing16 control16 signal16 for write or read enable

// wb_ack_o16 FSM16
reg [1:0] 	 wbstate16;
always  @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) begin
		wb_ack_o16 <= #1 1'b0;
		wbstate16 <= #1 0;
		wre16 <= #1 1'b1;
	end else
		case (wbstate16)
			0: begin
				if (wb_stb_is16 & wb_cyc_is16) begin
					wre16 <= #1 0;
					wbstate16 <= #1 1;
					wb_ack_o16 <= #1 1;
				end else begin
					wre16 <= #1 1;
					wb_ack_o16 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o16 <= #1 0;
				wbstate16 <= #1 2;
				wre16 <= #1 0;
			end
			2,3: begin
				wb_ack_o16 <= #1 0;
				wbstate16 <= #1 0;
				wre16 <= #1 0;
			end
		endcase

assign we_o16 =  wb_we_is16 & wb_stb_is16 & wb_cyc_is16 & wre16 ; //WE16 for registers	
assign re_o16 = ~wb_we_is16 & wb_stb_is16 & wb_cyc_is16 & wre16 ; //RE16 for registers	

// Sample16 input signals16
always  @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16) begin
		wb_adr_is16 <= #1 0;
		wb_we_is16 <= #1 0;
		wb_cyc_is16 <= #1 0;
		wb_stb_is16 <= #1 0;
		wb_dat_is16 <= #1 0;
		wb_sel_is16 <= #1 0;
	end else begin
		wb_adr_is16 <= #1 wb_adr_i16;
		wb_we_is16 <= #1 wb_we_i16;
		wb_cyc_is16 <= #1 wb_cyc_i16;
		wb_stb_is16 <= #1 wb_stb_i16;
		wb_dat_is16 <= #1 wb_dat_i16;
		wb_sel_is16 <= #1 wb_sel_i16;
	end

`ifdef DATA_BUS_WIDTH_816 // 8-bit data bus
always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16)
		wb_dat_o16 <= #1 0;
	else
		wb_dat_o16 <= #1 wb_dat8_o16;

always @(wb_dat_is16)
	wb_dat8_i16 = wb_dat_is16;

assign wb_adr_int16 = wb_adr_is16;

`else // 32-bit bus
// put output to the correct16 byte in 32 bits using select16 line
always @(posedge clk16 or posedge wb_rst_i16)
	if (wb_rst_i16)
		wb_dat_o16 <= #1 0;
	else if (re_o16)
		case (wb_sel_is16)
			4'b0001: wb_dat_o16 <= #1 {24'b0, wb_dat8_o16};
			4'b0010: wb_dat_o16 <= #1 {16'b0, wb_dat8_o16, 8'b0};
			4'b0100: wb_dat_o16 <= #1 {8'b0, wb_dat8_o16, 16'b0};
			4'b1000: wb_dat_o16 <= #1 {wb_dat8_o16, 24'b0};
			4'b1111: wb_dat_o16 <= #1 wb_dat32_o16; // debug16 interface output
 			default: wb_dat_o16 <= #1 0;
		endcase // case(wb_sel_i16)

reg [1:0] wb_adr_int_lsb16;

always @(wb_sel_is16 or wb_dat_is16)
begin
	case (wb_sel_is16)
		4'b0001 : wb_dat8_i16 = wb_dat_is16[7:0];
		4'b0010 : wb_dat8_i16 = wb_dat_is16[15:8];
		4'b0100 : wb_dat8_i16 = wb_dat_is16[23:16];
		4'b1000 : wb_dat8_i16 = wb_dat_is16[31:24];
		default : wb_dat8_i16 = wb_dat_is16[7:0];
	endcase // case(wb_sel_i16)

  `ifdef LITLE_ENDIAN16
	case (wb_sel_is16)
		4'b0001 : wb_adr_int_lsb16 = 2'h0;
		4'b0010 : wb_adr_int_lsb16 = 2'h1;
		4'b0100 : wb_adr_int_lsb16 = 2'h2;
		4'b1000 : wb_adr_int_lsb16 = 2'h3;
		default : wb_adr_int_lsb16 = 2'h0;
	endcase // case(wb_sel_i16)
  `else
	case (wb_sel_is16)
		4'b0001 : wb_adr_int_lsb16 = 2'h3;
		4'b0010 : wb_adr_int_lsb16 = 2'h2;
		4'b0100 : wb_adr_int_lsb16 = 2'h1;
		4'b1000 : wb_adr_int_lsb16 = 2'h0;
		default : wb_adr_int_lsb16 = 2'h0;
	endcase // case(wb_sel_i16)
  `endif
end

assign wb_adr_int16 = {wb_adr_is16[`UART_ADDR_WIDTH16-1:2], wb_adr_int_lsb16};

`endif // !`ifdef DATA_BUS_WIDTH_816

endmodule










