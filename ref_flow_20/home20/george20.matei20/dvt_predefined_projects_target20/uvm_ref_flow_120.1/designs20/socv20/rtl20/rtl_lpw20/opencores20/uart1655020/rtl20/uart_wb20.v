//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb20.v                                                   ////
////                                                              ////
////                                                              ////
////  This20 file is part of the "UART20 16550 compatible20" project20    ////
////  http20://www20.opencores20.org20/cores20/uart1655020/                   ////
////                                                              ////
////  Documentation20 related20 to this project20:                      ////
////  - http20://www20.opencores20.org20/cores20/uart1655020/                 ////
////                                                              ////
////  Projects20 compatibility20:                                     ////
////  - WISHBONE20                                                  ////
////  RS23220 Protocol20                                              ////
////  16550D uart20 (mostly20 supported)                              ////
////                                                              ////
////  Overview20 (main20 Features20):                                   ////
////  UART20 core20 WISHBONE20 interface.                               ////
////                                                              ////
////  Known20 problems20 (limits20):                                    ////
////  Inserts20 one wait state on all transfers20.                    ////
////  Note20 affected20 signals20 and the way20 they are affected20.        ////
////                                                              ////
////  To20 Do20:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author20(s):                                                  ////
////      - gorban20@opencores20.org20                                  ////
////      - Jacob20 Gorban20                                          ////
////      - Igor20 Mohor20 (igorm20@opencores20.org20)                      ////
////                                                              ////
////  Created20:        2001/05/12                                  ////
////  Last20 Updated20:   2001/05/17                                  ////
////                  (See log20 for the revision20 history20)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2000, 2001 Authors20                             ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS20 Revision20 History20
//
// $Log: not supported by cvs2svn20 $
// Revision20 1.16  2002/07/29 21:16:18  gorban20
// The uart_defines20.v file is included20 again20 in sources20.
//
// Revision20 1.15  2002/07/22 23:02:23  gorban20
// Bug20 Fixes20:
//  * Possible20 loss of sync and bad20 reception20 of stop bit on slow20 baud20 rates20 fixed20.
//   Problem20 reported20 by Kenny20.Tung20.
//  * Bad (or lack20 of ) loopback20 handling20 fixed20. Reported20 by Cherry20 Withers20.
//
// Improvements20:
//  * Made20 FIFO's as general20 inferrable20 memory where possible20.
//  So20 on FPGA20 they should be inferred20 as RAM20 (Distributed20 RAM20 on Xilinx20).
//  This20 saves20 about20 1/3 of the Slice20 count and reduces20 P&R and synthesis20 times.
//
//  * Added20 optional20 baudrate20 output (baud_o20).
//  This20 is identical20 to BAUDOUT20* signal20 on 16550 chip20.
//  It outputs20 16xbit_clock_rate - the divided20 clock20.
//  It's disabled by default. Define20 UART_HAS_BAUDRATE_OUTPUT20 to use.
//
// Revision20 1.12  2001/12/19 08:03:34  mohor20
// Warnings20 cleared20.
//
// Revision20 1.11  2001/12/06 14:51:04  gorban20
// Bug20 in LSR20[0] is fixed20.
// All WISHBONE20 signals20 are now sampled20, so another20 wait-state is introduced20 on all transfers20.
//
// Revision20 1.10  2001/12/03 21:44:29  gorban20
// Updated20 specification20 documentation.
// Added20 full 32-bit data bus interface, now as default.
// Address is 5-bit wide20 in 32-bit data bus mode.
// Added20 wb_sel_i20 input to the core20. It's used in the 32-bit mode.
// Added20 debug20 interface with two20 32-bit read-only registers in 32-bit mode.
// Bits20 5 and 6 of LSR20 are now only cleared20 on TX20 FIFO write.
// My20 small test bench20 is modified to work20 with 32-bit mode.
//
// Revision20 1.9  2001/10/20 09:58:40  gorban20
// Small20 synopsis20 fixes20
//
// Revision20 1.8  2001/08/24 21:01:12  mohor20
// Things20 connected20 to parity20 changed.
// Clock20 devider20 changed.
//
// Revision20 1.7  2001/08/23 16:05:05  mohor20
// Stop bit bug20 fixed20.
// Parity20 bug20 fixed20.
// WISHBONE20 read cycle bug20 fixed20,
// OE20 indicator20 (Overrun20 Error) bug20 fixed20.
// PE20 indicator20 (Parity20 Error) bug20 fixed20.
// Register read bug20 fixed20.
//
// Revision20 1.4  2001/05/31 20:08:01  gorban20
// FIFO changes20 and other corrections20.
//
// Revision20 1.3  2001/05/21 19:12:01  gorban20
// Corrected20 some20 Linter20 messages20.
//
// Revision20 1.2  2001/05/17 18:34:18  gorban20
// First20 'stable' release. Should20 be sythesizable20 now. Also20 added new header.
//
// Revision20 1.0  2001-05-17 21:27:13+02  jacob20
// Initial20 revision20
//
//

// UART20 core20 WISHBONE20 interface 
//
// Author20: Jacob20 Gorban20   (jacob20.gorban20@flextronicssemi20.com20)
// Company20: Flextronics20 Semiconductor20
//

// synopsys20 translate_off20
`include "timescale.v"
// synopsys20 translate_on20
`include "uart_defines20.v"
 
module uart_wb20 (clk20, wb_rst_i20, 
	wb_we_i20, wb_stb_i20, wb_cyc_i20, wb_ack_o20, wb_adr_i20,
	wb_adr_int20, wb_dat_i20, wb_dat_o20, wb_dat8_i20, wb_dat8_o20, wb_dat32_o20, wb_sel_i20,
	we_o20, re_o20 // Write and read enable output for the core20
);

input 		  clk20;

// WISHBONE20 interface	
input 		  wb_rst_i20;
input 		  wb_we_i20;
input 		  wb_stb_i20;
input 		  wb_cyc_i20;
input [3:0]   wb_sel_i20;
input [`UART_ADDR_WIDTH20-1:0] 	wb_adr_i20; //WISHBONE20 address line

`ifdef DATA_BUS_WIDTH_820
input [7:0]  wb_dat_i20; //input WISHBONE20 bus 
output [7:0] wb_dat_o20;
reg [7:0] 	 wb_dat_o20;
wire [7:0] 	 wb_dat_i20;
reg [7:0] 	 wb_dat_is20;
`else // for 32 data bus mode
input [31:0]  wb_dat_i20; //input WISHBONE20 bus 
output [31:0] wb_dat_o20;
reg [31:0] 	  wb_dat_o20;
wire [31:0]   wb_dat_i20;
reg [31:0] 	  wb_dat_is20;
`endif // !`ifdef DATA_BUS_WIDTH_820

output [`UART_ADDR_WIDTH20-1:0]	wb_adr_int20; // internal signal20 for address bus
input [7:0]   wb_dat8_o20; // internal 8 bit output to be put into wb_dat_o20
output [7:0]  wb_dat8_i20;
input [31:0]  wb_dat32_o20; // 32 bit data output (for debug20 interface)
output 		  wb_ack_o20;
output 		  we_o20;
output 		  re_o20;

wire 			  we_o20;
reg 			  wb_ack_o20;
reg [7:0] 	  wb_dat8_i20;
wire [7:0] 	  wb_dat8_o20;
wire [`UART_ADDR_WIDTH20-1:0]	wb_adr_int20; // internal signal20 for address bus
reg [`UART_ADDR_WIDTH20-1:0]	wb_adr_is20;
reg 								wb_we_is20;
reg 								wb_cyc_is20;
reg 								wb_stb_is20;
reg [3:0] 						wb_sel_is20;
wire [3:0]   wb_sel_i20;
reg 			 wre20 ;// timing20 control20 signal20 for write or read enable

// wb_ack_o20 FSM20
reg [1:0] 	 wbstate20;
always  @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) begin
		wb_ack_o20 <= #1 1'b0;
		wbstate20 <= #1 0;
		wre20 <= #1 1'b1;
	end else
		case (wbstate20)
			0: begin
				if (wb_stb_is20 & wb_cyc_is20) begin
					wre20 <= #1 0;
					wbstate20 <= #1 1;
					wb_ack_o20 <= #1 1;
				end else begin
					wre20 <= #1 1;
					wb_ack_o20 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o20 <= #1 0;
				wbstate20 <= #1 2;
				wre20 <= #1 0;
			end
			2,3: begin
				wb_ack_o20 <= #1 0;
				wbstate20 <= #1 0;
				wre20 <= #1 0;
			end
		endcase

assign we_o20 =  wb_we_is20 & wb_stb_is20 & wb_cyc_is20 & wre20 ; //WE20 for registers	
assign re_o20 = ~wb_we_is20 & wb_stb_is20 & wb_cyc_is20 & wre20 ; //RE20 for registers	

// Sample20 input signals20
always  @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20) begin
		wb_adr_is20 <= #1 0;
		wb_we_is20 <= #1 0;
		wb_cyc_is20 <= #1 0;
		wb_stb_is20 <= #1 0;
		wb_dat_is20 <= #1 0;
		wb_sel_is20 <= #1 0;
	end else begin
		wb_adr_is20 <= #1 wb_adr_i20;
		wb_we_is20 <= #1 wb_we_i20;
		wb_cyc_is20 <= #1 wb_cyc_i20;
		wb_stb_is20 <= #1 wb_stb_i20;
		wb_dat_is20 <= #1 wb_dat_i20;
		wb_sel_is20 <= #1 wb_sel_i20;
	end

`ifdef DATA_BUS_WIDTH_820 // 8-bit data bus
always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20)
		wb_dat_o20 <= #1 0;
	else
		wb_dat_o20 <= #1 wb_dat8_o20;

always @(wb_dat_is20)
	wb_dat8_i20 = wb_dat_is20;

assign wb_adr_int20 = wb_adr_is20;

`else // 32-bit bus
// put output to the correct20 byte in 32 bits using select20 line
always @(posedge clk20 or posedge wb_rst_i20)
	if (wb_rst_i20)
		wb_dat_o20 <= #1 0;
	else if (re_o20)
		case (wb_sel_is20)
			4'b0001: wb_dat_o20 <= #1 {24'b0, wb_dat8_o20};
			4'b0010: wb_dat_o20 <= #1 {16'b0, wb_dat8_o20, 8'b0};
			4'b0100: wb_dat_o20 <= #1 {8'b0, wb_dat8_o20, 16'b0};
			4'b1000: wb_dat_o20 <= #1 {wb_dat8_o20, 24'b0};
			4'b1111: wb_dat_o20 <= #1 wb_dat32_o20; // debug20 interface output
 			default: wb_dat_o20 <= #1 0;
		endcase // case(wb_sel_i20)

reg [1:0] wb_adr_int_lsb20;

always @(wb_sel_is20 or wb_dat_is20)
begin
	case (wb_sel_is20)
		4'b0001 : wb_dat8_i20 = wb_dat_is20[7:0];
		4'b0010 : wb_dat8_i20 = wb_dat_is20[15:8];
		4'b0100 : wb_dat8_i20 = wb_dat_is20[23:16];
		4'b1000 : wb_dat8_i20 = wb_dat_is20[31:24];
		default : wb_dat8_i20 = wb_dat_is20[7:0];
	endcase // case(wb_sel_i20)

  `ifdef LITLE_ENDIAN20
	case (wb_sel_is20)
		4'b0001 : wb_adr_int_lsb20 = 2'h0;
		4'b0010 : wb_adr_int_lsb20 = 2'h1;
		4'b0100 : wb_adr_int_lsb20 = 2'h2;
		4'b1000 : wb_adr_int_lsb20 = 2'h3;
		default : wb_adr_int_lsb20 = 2'h0;
	endcase // case(wb_sel_i20)
  `else
	case (wb_sel_is20)
		4'b0001 : wb_adr_int_lsb20 = 2'h3;
		4'b0010 : wb_adr_int_lsb20 = 2'h2;
		4'b0100 : wb_adr_int_lsb20 = 2'h1;
		4'b1000 : wb_adr_int_lsb20 = 2'h0;
		default : wb_adr_int_lsb20 = 2'h0;
	endcase // case(wb_sel_i20)
  `endif
end

assign wb_adr_int20 = {wb_adr_is20[`UART_ADDR_WIDTH20-1:2], wb_adr_int_lsb20};

`endif // !`ifdef DATA_BUS_WIDTH_820

endmodule










