//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb18.v                                                   ////
////                                                              ////
////                                                              ////
////  This18 file is part of the "UART18 16550 compatible18" project18    ////
////  http18://www18.opencores18.org18/cores18/uart1655018/                   ////
////                                                              ////
////  Documentation18 related18 to this project18:                      ////
////  - http18://www18.opencores18.org18/cores18/uart1655018/                 ////
////                                                              ////
////  Projects18 compatibility18:                                     ////
////  - WISHBONE18                                                  ////
////  RS23218 Protocol18                                              ////
////  16550D uart18 (mostly18 supported)                              ////
////                                                              ////
////  Overview18 (main18 Features18):                                   ////
////  UART18 core18 WISHBONE18 interface.                               ////
////                                                              ////
////  Known18 problems18 (limits18):                                    ////
////  Inserts18 one wait state on all transfers18.                    ////
////  Note18 affected18 signals18 and the way18 they are affected18.        ////
////                                                              ////
////  To18 Do18:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author18(s):                                                  ////
////      - gorban18@opencores18.org18                                  ////
////      - Jacob18 Gorban18                                          ////
////      - Igor18 Mohor18 (igorm18@opencores18.org18)                      ////
////                                                              ////
////  Created18:        2001/05/12                                  ////
////  Last18 Updated18:   2001/05/17                                  ////
////                  (See log18 for the revision18 history18)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2000, 2001 Authors18                             ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS18 Revision18 History18
//
// $Log: not supported by cvs2svn18 $
// Revision18 1.16  2002/07/29 21:16:18  gorban18
// The uart_defines18.v file is included18 again18 in sources18.
//
// Revision18 1.15  2002/07/22 23:02:23  gorban18
// Bug18 Fixes18:
//  * Possible18 loss of sync and bad18 reception18 of stop bit on slow18 baud18 rates18 fixed18.
//   Problem18 reported18 by Kenny18.Tung18.
//  * Bad (or lack18 of ) loopback18 handling18 fixed18. Reported18 by Cherry18 Withers18.
//
// Improvements18:
//  * Made18 FIFO's as general18 inferrable18 memory where possible18.
//  So18 on FPGA18 they should be inferred18 as RAM18 (Distributed18 RAM18 on Xilinx18).
//  This18 saves18 about18 1/3 of the Slice18 count and reduces18 P&R and synthesis18 times.
//
//  * Added18 optional18 baudrate18 output (baud_o18).
//  This18 is identical18 to BAUDOUT18* signal18 on 16550 chip18.
//  It outputs18 16xbit_clock_rate - the divided18 clock18.
//  It's disabled by default. Define18 UART_HAS_BAUDRATE_OUTPUT18 to use.
//
// Revision18 1.12  2001/12/19 08:03:34  mohor18
// Warnings18 cleared18.
//
// Revision18 1.11  2001/12/06 14:51:04  gorban18
// Bug18 in LSR18[0] is fixed18.
// All WISHBONE18 signals18 are now sampled18, so another18 wait-state is introduced18 on all transfers18.
//
// Revision18 1.10  2001/12/03 21:44:29  gorban18
// Updated18 specification18 documentation.
// Added18 full 32-bit data bus interface, now as default.
// Address is 5-bit wide18 in 32-bit data bus mode.
// Added18 wb_sel_i18 input to the core18. It's used in the 32-bit mode.
// Added18 debug18 interface with two18 32-bit read-only registers in 32-bit mode.
// Bits18 5 and 6 of LSR18 are now only cleared18 on TX18 FIFO write.
// My18 small test bench18 is modified to work18 with 32-bit mode.
//
// Revision18 1.9  2001/10/20 09:58:40  gorban18
// Small18 synopsis18 fixes18
//
// Revision18 1.8  2001/08/24 21:01:12  mohor18
// Things18 connected18 to parity18 changed.
// Clock18 devider18 changed.
//
// Revision18 1.7  2001/08/23 16:05:05  mohor18
// Stop bit bug18 fixed18.
// Parity18 bug18 fixed18.
// WISHBONE18 read cycle bug18 fixed18,
// OE18 indicator18 (Overrun18 Error) bug18 fixed18.
// PE18 indicator18 (Parity18 Error) bug18 fixed18.
// Register read bug18 fixed18.
//
// Revision18 1.4  2001/05/31 20:08:01  gorban18
// FIFO changes18 and other corrections18.
//
// Revision18 1.3  2001/05/21 19:12:01  gorban18
// Corrected18 some18 Linter18 messages18.
//
// Revision18 1.2  2001/05/17 18:34:18  gorban18
// First18 'stable' release. Should18 be sythesizable18 now. Also18 added new header.
//
// Revision18 1.0  2001-05-17 21:27:13+02  jacob18
// Initial18 revision18
//
//

// UART18 core18 WISHBONE18 interface 
//
// Author18: Jacob18 Gorban18   (jacob18.gorban18@flextronicssemi18.com18)
// Company18: Flextronics18 Semiconductor18
//

// synopsys18 translate_off18
`include "timescale.v"
// synopsys18 translate_on18
`include "uart_defines18.v"
 
module uart_wb18 (clk18, wb_rst_i18, 
	wb_we_i18, wb_stb_i18, wb_cyc_i18, wb_ack_o18, wb_adr_i18,
	wb_adr_int18, wb_dat_i18, wb_dat_o18, wb_dat8_i18, wb_dat8_o18, wb_dat32_o18, wb_sel_i18,
	we_o18, re_o18 // Write and read enable output for the core18
);

input 		  clk18;

// WISHBONE18 interface	
input 		  wb_rst_i18;
input 		  wb_we_i18;
input 		  wb_stb_i18;
input 		  wb_cyc_i18;
input [3:0]   wb_sel_i18;
input [`UART_ADDR_WIDTH18-1:0] 	wb_adr_i18; //WISHBONE18 address line

`ifdef DATA_BUS_WIDTH_818
input [7:0]  wb_dat_i18; //input WISHBONE18 bus 
output [7:0] wb_dat_o18;
reg [7:0] 	 wb_dat_o18;
wire [7:0] 	 wb_dat_i18;
reg [7:0] 	 wb_dat_is18;
`else // for 32 data bus mode
input [31:0]  wb_dat_i18; //input WISHBONE18 bus 
output [31:0] wb_dat_o18;
reg [31:0] 	  wb_dat_o18;
wire [31:0]   wb_dat_i18;
reg [31:0] 	  wb_dat_is18;
`endif // !`ifdef DATA_BUS_WIDTH_818

output [`UART_ADDR_WIDTH18-1:0]	wb_adr_int18; // internal signal18 for address bus
input [7:0]   wb_dat8_o18; // internal 8 bit output to be put into wb_dat_o18
output [7:0]  wb_dat8_i18;
input [31:0]  wb_dat32_o18; // 32 bit data output (for debug18 interface)
output 		  wb_ack_o18;
output 		  we_o18;
output 		  re_o18;

wire 			  we_o18;
reg 			  wb_ack_o18;
reg [7:0] 	  wb_dat8_i18;
wire [7:0] 	  wb_dat8_o18;
wire [`UART_ADDR_WIDTH18-1:0]	wb_adr_int18; // internal signal18 for address bus
reg [`UART_ADDR_WIDTH18-1:0]	wb_adr_is18;
reg 								wb_we_is18;
reg 								wb_cyc_is18;
reg 								wb_stb_is18;
reg [3:0] 						wb_sel_is18;
wire [3:0]   wb_sel_i18;
reg 			 wre18 ;// timing18 control18 signal18 for write or read enable

// wb_ack_o18 FSM18
reg [1:0] 	 wbstate18;
always  @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) begin
		wb_ack_o18 <= #1 1'b0;
		wbstate18 <= #1 0;
		wre18 <= #1 1'b1;
	end else
		case (wbstate18)
			0: begin
				if (wb_stb_is18 & wb_cyc_is18) begin
					wre18 <= #1 0;
					wbstate18 <= #1 1;
					wb_ack_o18 <= #1 1;
				end else begin
					wre18 <= #1 1;
					wb_ack_o18 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o18 <= #1 0;
				wbstate18 <= #1 2;
				wre18 <= #1 0;
			end
			2,3: begin
				wb_ack_o18 <= #1 0;
				wbstate18 <= #1 0;
				wre18 <= #1 0;
			end
		endcase

assign we_o18 =  wb_we_is18 & wb_stb_is18 & wb_cyc_is18 & wre18 ; //WE18 for registers	
assign re_o18 = ~wb_we_is18 & wb_stb_is18 & wb_cyc_is18 & wre18 ; //RE18 for registers	

// Sample18 input signals18
always  @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18) begin
		wb_adr_is18 <= #1 0;
		wb_we_is18 <= #1 0;
		wb_cyc_is18 <= #1 0;
		wb_stb_is18 <= #1 0;
		wb_dat_is18 <= #1 0;
		wb_sel_is18 <= #1 0;
	end else begin
		wb_adr_is18 <= #1 wb_adr_i18;
		wb_we_is18 <= #1 wb_we_i18;
		wb_cyc_is18 <= #1 wb_cyc_i18;
		wb_stb_is18 <= #1 wb_stb_i18;
		wb_dat_is18 <= #1 wb_dat_i18;
		wb_sel_is18 <= #1 wb_sel_i18;
	end

`ifdef DATA_BUS_WIDTH_818 // 8-bit data bus
always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18)
		wb_dat_o18 <= #1 0;
	else
		wb_dat_o18 <= #1 wb_dat8_o18;

always @(wb_dat_is18)
	wb_dat8_i18 = wb_dat_is18;

assign wb_adr_int18 = wb_adr_is18;

`else // 32-bit bus
// put output to the correct18 byte in 32 bits using select18 line
always @(posedge clk18 or posedge wb_rst_i18)
	if (wb_rst_i18)
		wb_dat_o18 <= #1 0;
	else if (re_o18)
		case (wb_sel_is18)
			4'b0001: wb_dat_o18 <= #1 {24'b0, wb_dat8_o18};
			4'b0010: wb_dat_o18 <= #1 {16'b0, wb_dat8_o18, 8'b0};
			4'b0100: wb_dat_o18 <= #1 {8'b0, wb_dat8_o18, 16'b0};
			4'b1000: wb_dat_o18 <= #1 {wb_dat8_o18, 24'b0};
			4'b1111: wb_dat_o18 <= #1 wb_dat32_o18; // debug18 interface output
 			default: wb_dat_o18 <= #1 0;
		endcase // case(wb_sel_i18)

reg [1:0] wb_adr_int_lsb18;

always @(wb_sel_is18 or wb_dat_is18)
begin
	case (wb_sel_is18)
		4'b0001 : wb_dat8_i18 = wb_dat_is18[7:0];
		4'b0010 : wb_dat8_i18 = wb_dat_is18[15:8];
		4'b0100 : wb_dat8_i18 = wb_dat_is18[23:16];
		4'b1000 : wb_dat8_i18 = wb_dat_is18[31:24];
		default : wb_dat8_i18 = wb_dat_is18[7:0];
	endcase // case(wb_sel_i18)

  `ifdef LITLE_ENDIAN18
	case (wb_sel_is18)
		4'b0001 : wb_adr_int_lsb18 = 2'h0;
		4'b0010 : wb_adr_int_lsb18 = 2'h1;
		4'b0100 : wb_adr_int_lsb18 = 2'h2;
		4'b1000 : wb_adr_int_lsb18 = 2'h3;
		default : wb_adr_int_lsb18 = 2'h0;
	endcase // case(wb_sel_i18)
  `else
	case (wb_sel_is18)
		4'b0001 : wb_adr_int_lsb18 = 2'h3;
		4'b0010 : wb_adr_int_lsb18 = 2'h2;
		4'b0100 : wb_adr_int_lsb18 = 2'h1;
		4'b1000 : wb_adr_int_lsb18 = 2'h0;
		default : wb_adr_int_lsb18 = 2'h0;
	endcase // case(wb_sel_i18)
  `endif
end

assign wb_adr_int18 = {wb_adr_is18[`UART_ADDR_WIDTH18-1:2], wb_adr_int_lsb18};

`endif // !`ifdef DATA_BUS_WIDTH_818

endmodule










