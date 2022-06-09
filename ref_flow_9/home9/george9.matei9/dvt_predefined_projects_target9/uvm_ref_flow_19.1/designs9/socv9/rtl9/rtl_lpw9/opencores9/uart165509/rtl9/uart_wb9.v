//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb9.v                                                   ////
////                                                              ////
////                                                              ////
////  This9 file is part of the "UART9 16550 compatible9" project9    ////
////  http9://www9.opencores9.org9/cores9/uart165509/                   ////
////                                                              ////
////  Documentation9 related9 to this project9:                      ////
////  - http9://www9.opencores9.org9/cores9/uart165509/                 ////
////                                                              ////
////  Projects9 compatibility9:                                     ////
////  - WISHBONE9                                                  ////
////  RS2329 Protocol9                                              ////
////  16550D uart9 (mostly9 supported)                              ////
////                                                              ////
////  Overview9 (main9 Features9):                                   ////
////  UART9 core9 WISHBONE9 interface.                               ////
////                                                              ////
////  Known9 problems9 (limits9):                                    ////
////  Inserts9 one wait state on all transfers9.                    ////
////  Note9 affected9 signals9 and the way9 they are affected9.        ////
////                                                              ////
////  To9 Do9:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author9(s):                                                  ////
////      - gorban9@opencores9.org9                                  ////
////      - Jacob9 Gorban9                                          ////
////      - Igor9 Mohor9 (igorm9@opencores9.org9)                      ////
////                                                              ////
////  Created9:        2001/05/12                                  ////
////  Last9 Updated9:   2001/05/17                                  ////
////                  (See log9 for the revision9 history9)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2000, 2001 Authors9                             ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS9 Revision9 History9
//
// $Log: not supported by cvs2svn9 $
// Revision9 1.16  2002/07/29 21:16:18  gorban9
// The uart_defines9.v file is included9 again9 in sources9.
//
// Revision9 1.15  2002/07/22 23:02:23  gorban9
// Bug9 Fixes9:
//  * Possible9 loss of sync and bad9 reception9 of stop bit on slow9 baud9 rates9 fixed9.
//   Problem9 reported9 by Kenny9.Tung9.
//  * Bad (or lack9 of ) loopback9 handling9 fixed9. Reported9 by Cherry9 Withers9.
//
// Improvements9:
//  * Made9 FIFO's as general9 inferrable9 memory where possible9.
//  So9 on FPGA9 they should be inferred9 as RAM9 (Distributed9 RAM9 on Xilinx9).
//  This9 saves9 about9 1/3 of the Slice9 count and reduces9 P&R and synthesis9 times.
//
//  * Added9 optional9 baudrate9 output (baud_o9).
//  This9 is identical9 to BAUDOUT9* signal9 on 16550 chip9.
//  It outputs9 16xbit_clock_rate - the divided9 clock9.
//  It's disabled by default. Define9 UART_HAS_BAUDRATE_OUTPUT9 to use.
//
// Revision9 1.12  2001/12/19 08:03:34  mohor9
// Warnings9 cleared9.
//
// Revision9 1.11  2001/12/06 14:51:04  gorban9
// Bug9 in LSR9[0] is fixed9.
// All WISHBONE9 signals9 are now sampled9, so another9 wait-state is introduced9 on all transfers9.
//
// Revision9 1.10  2001/12/03 21:44:29  gorban9
// Updated9 specification9 documentation.
// Added9 full 32-bit data bus interface, now as default.
// Address is 5-bit wide9 in 32-bit data bus mode.
// Added9 wb_sel_i9 input to the core9. It's used in the 32-bit mode.
// Added9 debug9 interface with two9 32-bit read-only registers in 32-bit mode.
// Bits9 5 and 6 of LSR9 are now only cleared9 on TX9 FIFO write.
// My9 small test bench9 is modified to work9 with 32-bit mode.
//
// Revision9 1.9  2001/10/20 09:58:40  gorban9
// Small9 synopsis9 fixes9
//
// Revision9 1.8  2001/08/24 21:01:12  mohor9
// Things9 connected9 to parity9 changed.
// Clock9 devider9 changed.
//
// Revision9 1.7  2001/08/23 16:05:05  mohor9
// Stop bit bug9 fixed9.
// Parity9 bug9 fixed9.
// WISHBONE9 read cycle bug9 fixed9,
// OE9 indicator9 (Overrun9 Error) bug9 fixed9.
// PE9 indicator9 (Parity9 Error) bug9 fixed9.
// Register read bug9 fixed9.
//
// Revision9 1.4  2001/05/31 20:08:01  gorban9
// FIFO changes9 and other corrections9.
//
// Revision9 1.3  2001/05/21 19:12:01  gorban9
// Corrected9 some9 Linter9 messages9.
//
// Revision9 1.2  2001/05/17 18:34:18  gorban9
// First9 'stable' release. Should9 be sythesizable9 now. Also9 added new header.
//
// Revision9 1.0  2001-05-17 21:27:13+02  jacob9
// Initial9 revision9
//
//

// UART9 core9 WISHBONE9 interface 
//
// Author9: Jacob9 Gorban9   (jacob9.gorban9@flextronicssemi9.com9)
// Company9: Flextronics9 Semiconductor9
//

// synopsys9 translate_off9
`include "timescale.v"
// synopsys9 translate_on9
`include "uart_defines9.v"
 
module uart_wb9 (clk9, wb_rst_i9, 
	wb_we_i9, wb_stb_i9, wb_cyc_i9, wb_ack_o9, wb_adr_i9,
	wb_adr_int9, wb_dat_i9, wb_dat_o9, wb_dat8_i9, wb_dat8_o9, wb_dat32_o9, wb_sel_i9,
	we_o9, re_o9 // Write and read enable output for the core9
);

input 		  clk9;

// WISHBONE9 interface	
input 		  wb_rst_i9;
input 		  wb_we_i9;
input 		  wb_stb_i9;
input 		  wb_cyc_i9;
input [3:0]   wb_sel_i9;
input [`UART_ADDR_WIDTH9-1:0] 	wb_adr_i9; //WISHBONE9 address line

`ifdef DATA_BUS_WIDTH_89
input [7:0]  wb_dat_i9; //input WISHBONE9 bus 
output [7:0] wb_dat_o9;
reg [7:0] 	 wb_dat_o9;
wire [7:0] 	 wb_dat_i9;
reg [7:0] 	 wb_dat_is9;
`else // for 32 data bus mode
input [31:0]  wb_dat_i9; //input WISHBONE9 bus 
output [31:0] wb_dat_o9;
reg [31:0] 	  wb_dat_o9;
wire [31:0]   wb_dat_i9;
reg [31:0] 	  wb_dat_is9;
`endif // !`ifdef DATA_BUS_WIDTH_89

output [`UART_ADDR_WIDTH9-1:0]	wb_adr_int9; // internal signal9 for address bus
input [7:0]   wb_dat8_o9; // internal 8 bit output to be put into wb_dat_o9
output [7:0]  wb_dat8_i9;
input [31:0]  wb_dat32_o9; // 32 bit data output (for debug9 interface)
output 		  wb_ack_o9;
output 		  we_o9;
output 		  re_o9;

wire 			  we_o9;
reg 			  wb_ack_o9;
reg [7:0] 	  wb_dat8_i9;
wire [7:0] 	  wb_dat8_o9;
wire [`UART_ADDR_WIDTH9-1:0]	wb_adr_int9; // internal signal9 for address bus
reg [`UART_ADDR_WIDTH9-1:0]	wb_adr_is9;
reg 								wb_we_is9;
reg 								wb_cyc_is9;
reg 								wb_stb_is9;
reg [3:0] 						wb_sel_is9;
wire [3:0]   wb_sel_i9;
reg 			 wre9 ;// timing9 control9 signal9 for write or read enable

// wb_ack_o9 FSM9
reg [1:0] 	 wbstate9;
always  @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) begin
		wb_ack_o9 <= #1 1'b0;
		wbstate9 <= #1 0;
		wre9 <= #1 1'b1;
	end else
		case (wbstate9)
			0: begin
				if (wb_stb_is9 & wb_cyc_is9) begin
					wre9 <= #1 0;
					wbstate9 <= #1 1;
					wb_ack_o9 <= #1 1;
				end else begin
					wre9 <= #1 1;
					wb_ack_o9 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o9 <= #1 0;
				wbstate9 <= #1 2;
				wre9 <= #1 0;
			end
			2,3: begin
				wb_ack_o9 <= #1 0;
				wbstate9 <= #1 0;
				wre9 <= #1 0;
			end
		endcase

assign we_o9 =  wb_we_is9 & wb_stb_is9 & wb_cyc_is9 & wre9 ; //WE9 for registers	
assign re_o9 = ~wb_we_is9 & wb_stb_is9 & wb_cyc_is9 & wre9 ; //RE9 for registers	

// Sample9 input signals9
always  @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9) begin
		wb_adr_is9 <= #1 0;
		wb_we_is9 <= #1 0;
		wb_cyc_is9 <= #1 0;
		wb_stb_is9 <= #1 0;
		wb_dat_is9 <= #1 0;
		wb_sel_is9 <= #1 0;
	end else begin
		wb_adr_is9 <= #1 wb_adr_i9;
		wb_we_is9 <= #1 wb_we_i9;
		wb_cyc_is9 <= #1 wb_cyc_i9;
		wb_stb_is9 <= #1 wb_stb_i9;
		wb_dat_is9 <= #1 wb_dat_i9;
		wb_sel_is9 <= #1 wb_sel_i9;
	end

`ifdef DATA_BUS_WIDTH_89 // 8-bit data bus
always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9)
		wb_dat_o9 <= #1 0;
	else
		wb_dat_o9 <= #1 wb_dat8_o9;

always @(wb_dat_is9)
	wb_dat8_i9 = wb_dat_is9;

assign wb_adr_int9 = wb_adr_is9;

`else // 32-bit bus
// put output to the correct9 byte in 32 bits using select9 line
always @(posedge clk9 or posedge wb_rst_i9)
	if (wb_rst_i9)
		wb_dat_o9 <= #1 0;
	else if (re_o9)
		case (wb_sel_is9)
			4'b0001: wb_dat_o9 <= #1 {24'b0, wb_dat8_o9};
			4'b0010: wb_dat_o9 <= #1 {16'b0, wb_dat8_o9, 8'b0};
			4'b0100: wb_dat_o9 <= #1 {8'b0, wb_dat8_o9, 16'b0};
			4'b1000: wb_dat_o9 <= #1 {wb_dat8_o9, 24'b0};
			4'b1111: wb_dat_o9 <= #1 wb_dat32_o9; // debug9 interface output
 			default: wb_dat_o9 <= #1 0;
		endcase // case(wb_sel_i9)

reg [1:0] wb_adr_int_lsb9;

always @(wb_sel_is9 or wb_dat_is9)
begin
	case (wb_sel_is9)
		4'b0001 : wb_dat8_i9 = wb_dat_is9[7:0];
		4'b0010 : wb_dat8_i9 = wb_dat_is9[15:8];
		4'b0100 : wb_dat8_i9 = wb_dat_is9[23:16];
		4'b1000 : wb_dat8_i9 = wb_dat_is9[31:24];
		default : wb_dat8_i9 = wb_dat_is9[7:0];
	endcase // case(wb_sel_i9)

  `ifdef LITLE_ENDIAN9
	case (wb_sel_is9)
		4'b0001 : wb_adr_int_lsb9 = 2'h0;
		4'b0010 : wb_adr_int_lsb9 = 2'h1;
		4'b0100 : wb_adr_int_lsb9 = 2'h2;
		4'b1000 : wb_adr_int_lsb9 = 2'h3;
		default : wb_adr_int_lsb9 = 2'h0;
	endcase // case(wb_sel_i9)
  `else
	case (wb_sel_is9)
		4'b0001 : wb_adr_int_lsb9 = 2'h3;
		4'b0010 : wb_adr_int_lsb9 = 2'h2;
		4'b0100 : wb_adr_int_lsb9 = 2'h1;
		4'b1000 : wb_adr_int_lsb9 = 2'h0;
		default : wb_adr_int_lsb9 = 2'h0;
	endcase // case(wb_sel_i9)
  `endif
end

assign wb_adr_int9 = {wb_adr_is9[`UART_ADDR_WIDTH9-1:2], wb_adr_int_lsb9};

`endif // !`ifdef DATA_BUS_WIDTH_89

endmodule










