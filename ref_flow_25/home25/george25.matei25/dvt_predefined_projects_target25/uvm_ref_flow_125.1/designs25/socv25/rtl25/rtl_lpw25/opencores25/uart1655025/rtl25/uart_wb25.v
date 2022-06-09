//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb25.v                                                   ////
////                                                              ////
////                                                              ////
////  This25 file is part of the "UART25 16550 compatible25" project25    ////
////  http25://www25.opencores25.org25/cores25/uart1655025/                   ////
////                                                              ////
////  Documentation25 related25 to this project25:                      ////
////  - http25://www25.opencores25.org25/cores25/uart1655025/                 ////
////                                                              ////
////  Projects25 compatibility25:                                     ////
////  - WISHBONE25                                                  ////
////  RS23225 Protocol25                                              ////
////  16550D uart25 (mostly25 supported)                              ////
////                                                              ////
////  Overview25 (main25 Features25):                                   ////
////  UART25 core25 WISHBONE25 interface.                               ////
////                                                              ////
////  Known25 problems25 (limits25):                                    ////
////  Inserts25 one wait state on all transfers25.                    ////
////  Note25 affected25 signals25 and the way25 they are affected25.        ////
////                                                              ////
////  To25 Do25:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author25(s):                                                  ////
////      - gorban25@opencores25.org25                                  ////
////      - Jacob25 Gorban25                                          ////
////      - Igor25 Mohor25 (igorm25@opencores25.org25)                      ////
////                                                              ////
////  Created25:        2001/05/12                                  ////
////  Last25 Updated25:   2001/05/17                                  ////
////                  (See log25 for the revision25 history25)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2000, 2001 Authors25                             ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS25 Revision25 History25
//
// $Log: not supported by cvs2svn25 $
// Revision25 1.16  2002/07/29 21:16:18  gorban25
// The uart_defines25.v file is included25 again25 in sources25.
//
// Revision25 1.15  2002/07/22 23:02:23  gorban25
// Bug25 Fixes25:
//  * Possible25 loss of sync and bad25 reception25 of stop bit on slow25 baud25 rates25 fixed25.
//   Problem25 reported25 by Kenny25.Tung25.
//  * Bad (or lack25 of ) loopback25 handling25 fixed25. Reported25 by Cherry25 Withers25.
//
// Improvements25:
//  * Made25 FIFO's as general25 inferrable25 memory where possible25.
//  So25 on FPGA25 they should be inferred25 as RAM25 (Distributed25 RAM25 on Xilinx25).
//  This25 saves25 about25 1/3 of the Slice25 count and reduces25 P&R and synthesis25 times.
//
//  * Added25 optional25 baudrate25 output (baud_o25).
//  This25 is identical25 to BAUDOUT25* signal25 on 16550 chip25.
//  It outputs25 16xbit_clock_rate - the divided25 clock25.
//  It's disabled by default. Define25 UART_HAS_BAUDRATE_OUTPUT25 to use.
//
// Revision25 1.12  2001/12/19 08:03:34  mohor25
// Warnings25 cleared25.
//
// Revision25 1.11  2001/12/06 14:51:04  gorban25
// Bug25 in LSR25[0] is fixed25.
// All WISHBONE25 signals25 are now sampled25, so another25 wait-state is introduced25 on all transfers25.
//
// Revision25 1.10  2001/12/03 21:44:29  gorban25
// Updated25 specification25 documentation.
// Added25 full 32-bit data bus interface, now as default.
// Address is 5-bit wide25 in 32-bit data bus mode.
// Added25 wb_sel_i25 input to the core25. It's used in the 32-bit mode.
// Added25 debug25 interface with two25 32-bit read-only registers in 32-bit mode.
// Bits25 5 and 6 of LSR25 are now only cleared25 on TX25 FIFO write.
// My25 small test bench25 is modified to work25 with 32-bit mode.
//
// Revision25 1.9  2001/10/20 09:58:40  gorban25
// Small25 synopsis25 fixes25
//
// Revision25 1.8  2001/08/24 21:01:12  mohor25
// Things25 connected25 to parity25 changed.
// Clock25 devider25 changed.
//
// Revision25 1.7  2001/08/23 16:05:05  mohor25
// Stop bit bug25 fixed25.
// Parity25 bug25 fixed25.
// WISHBONE25 read cycle bug25 fixed25,
// OE25 indicator25 (Overrun25 Error) bug25 fixed25.
// PE25 indicator25 (Parity25 Error) bug25 fixed25.
// Register read bug25 fixed25.
//
// Revision25 1.4  2001/05/31 20:08:01  gorban25
// FIFO changes25 and other corrections25.
//
// Revision25 1.3  2001/05/21 19:12:01  gorban25
// Corrected25 some25 Linter25 messages25.
//
// Revision25 1.2  2001/05/17 18:34:18  gorban25
// First25 'stable' release. Should25 be sythesizable25 now. Also25 added new header.
//
// Revision25 1.0  2001-05-17 21:27:13+02  jacob25
// Initial25 revision25
//
//

// UART25 core25 WISHBONE25 interface 
//
// Author25: Jacob25 Gorban25   (jacob25.gorban25@flextronicssemi25.com25)
// Company25: Flextronics25 Semiconductor25
//

// synopsys25 translate_off25
`include "timescale.v"
// synopsys25 translate_on25
`include "uart_defines25.v"
 
module uart_wb25 (clk25, wb_rst_i25, 
	wb_we_i25, wb_stb_i25, wb_cyc_i25, wb_ack_o25, wb_adr_i25,
	wb_adr_int25, wb_dat_i25, wb_dat_o25, wb_dat8_i25, wb_dat8_o25, wb_dat32_o25, wb_sel_i25,
	we_o25, re_o25 // Write and read enable output for the core25
);

input 		  clk25;

// WISHBONE25 interface	
input 		  wb_rst_i25;
input 		  wb_we_i25;
input 		  wb_stb_i25;
input 		  wb_cyc_i25;
input [3:0]   wb_sel_i25;
input [`UART_ADDR_WIDTH25-1:0] 	wb_adr_i25; //WISHBONE25 address line

`ifdef DATA_BUS_WIDTH_825
input [7:0]  wb_dat_i25; //input WISHBONE25 bus 
output [7:0] wb_dat_o25;
reg [7:0] 	 wb_dat_o25;
wire [7:0] 	 wb_dat_i25;
reg [7:0] 	 wb_dat_is25;
`else // for 32 data bus mode
input [31:0]  wb_dat_i25; //input WISHBONE25 bus 
output [31:0] wb_dat_o25;
reg [31:0] 	  wb_dat_o25;
wire [31:0]   wb_dat_i25;
reg [31:0] 	  wb_dat_is25;
`endif // !`ifdef DATA_BUS_WIDTH_825

output [`UART_ADDR_WIDTH25-1:0]	wb_adr_int25; // internal signal25 for address bus
input [7:0]   wb_dat8_o25; // internal 8 bit output to be put into wb_dat_o25
output [7:0]  wb_dat8_i25;
input [31:0]  wb_dat32_o25; // 32 bit data output (for debug25 interface)
output 		  wb_ack_o25;
output 		  we_o25;
output 		  re_o25;

wire 			  we_o25;
reg 			  wb_ack_o25;
reg [7:0] 	  wb_dat8_i25;
wire [7:0] 	  wb_dat8_o25;
wire [`UART_ADDR_WIDTH25-1:0]	wb_adr_int25; // internal signal25 for address bus
reg [`UART_ADDR_WIDTH25-1:0]	wb_adr_is25;
reg 								wb_we_is25;
reg 								wb_cyc_is25;
reg 								wb_stb_is25;
reg [3:0] 						wb_sel_is25;
wire [3:0]   wb_sel_i25;
reg 			 wre25 ;// timing25 control25 signal25 for write or read enable

// wb_ack_o25 FSM25
reg [1:0] 	 wbstate25;
always  @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) begin
		wb_ack_o25 <= #1 1'b0;
		wbstate25 <= #1 0;
		wre25 <= #1 1'b1;
	end else
		case (wbstate25)
			0: begin
				if (wb_stb_is25 & wb_cyc_is25) begin
					wre25 <= #1 0;
					wbstate25 <= #1 1;
					wb_ack_o25 <= #1 1;
				end else begin
					wre25 <= #1 1;
					wb_ack_o25 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o25 <= #1 0;
				wbstate25 <= #1 2;
				wre25 <= #1 0;
			end
			2,3: begin
				wb_ack_o25 <= #1 0;
				wbstate25 <= #1 0;
				wre25 <= #1 0;
			end
		endcase

assign we_o25 =  wb_we_is25 & wb_stb_is25 & wb_cyc_is25 & wre25 ; //WE25 for registers	
assign re_o25 = ~wb_we_is25 & wb_stb_is25 & wb_cyc_is25 & wre25 ; //RE25 for registers	

// Sample25 input signals25
always  @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25) begin
		wb_adr_is25 <= #1 0;
		wb_we_is25 <= #1 0;
		wb_cyc_is25 <= #1 0;
		wb_stb_is25 <= #1 0;
		wb_dat_is25 <= #1 0;
		wb_sel_is25 <= #1 0;
	end else begin
		wb_adr_is25 <= #1 wb_adr_i25;
		wb_we_is25 <= #1 wb_we_i25;
		wb_cyc_is25 <= #1 wb_cyc_i25;
		wb_stb_is25 <= #1 wb_stb_i25;
		wb_dat_is25 <= #1 wb_dat_i25;
		wb_sel_is25 <= #1 wb_sel_i25;
	end

`ifdef DATA_BUS_WIDTH_825 // 8-bit data bus
always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25)
		wb_dat_o25 <= #1 0;
	else
		wb_dat_o25 <= #1 wb_dat8_o25;

always @(wb_dat_is25)
	wb_dat8_i25 = wb_dat_is25;

assign wb_adr_int25 = wb_adr_is25;

`else // 32-bit bus
// put output to the correct25 byte in 32 bits using select25 line
always @(posedge clk25 or posedge wb_rst_i25)
	if (wb_rst_i25)
		wb_dat_o25 <= #1 0;
	else if (re_o25)
		case (wb_sel_is25)
			4'b0001: wb_dat_o25 <= #1 {24'b0, wb_dat8_o25};
			4'b0010: wb_dat_o25 <= #1 {16'b0, wb_dat8_o25, 8'b0};
			4'b0100: wb_dat_o25 <= #1 {8'b0, wb_dat8_o25, 16'b0};
			4'b1000: wb_dat_o25 <= #1 {wb_dat8_o25, 24'b0};
			4'b1111: wb_dat_o25 <= #1 wb_dat32_o25; // debug25 interface output
 			default: wb_dat_o25 <= #1 0;
		endcase // case(wb_sel_i25)

reg [1:0] wb_adr_int_lsb25;

always @(wb_sel_is25 or wb_dat_is25)
begin
	case (wb_sel_is25)
		4'b0001 : wb_dat8_i25 = wb_dat_is25[7:0];
		4'b0010 : wb_dat8_i25 = wb_dat_is25[15:8];
		4'b0100 : wb_dat8_i25 = wb_dat_is25[23:16];
		4'b1000 : wb_dat8_i25 = wb_dat_is25[31:24];
		default : wb_dat8_i25 = wb_dat_is25[7:0];
	endcase // case(wb_sel_i25)

  `ifdef LITLE_ENDIAN25
	case (wb_sel_is25)
		4'b0001 : wb_adr_int_lsb25 = 2'h0;
		4'b0010 : wb_adr_int_lsb25 = 2'h1;
		4'b0100 : wb_adr_int_lsb25 = 2'h2;
		4'b1000 : wb_adr_int_lsb25 = 2'h3;
		default : wb_adr_int_lsb25 = 2'h0;
	endcase // case(wb_sel_i25)
  `else
	case (wb_sel_is25)
		4'b0001 : wb_adr_int_lsb25 = 2'h3;
		4'b0010 : wb_adr_int_lsb25 = 2'h2;
		4'b0100 : wb_adr_int_lsb25 = 2'h1;
		4'b1000 : wb_adr_int_lsb25 = 2'h0;
		default : wb_adr_int_lsb25 = 2'h0;
	endcase // case(wb_sel_i25)
  `endif
end

assign wb_adr_int25 = {wb_adr_is25[`UART_ADDR_WIDTH25-1:2], wb_adr_int_lsb25};

`endif // !`ifdef DATA_BUS_WIDTH_825

endmodule










