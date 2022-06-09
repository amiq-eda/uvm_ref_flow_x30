//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb6.v                                                   ////
////                                                              ////
////                                                              ////
////  This6 file is part of the "UART6 16550 compatible6" project6    ////
////  http6://www6.opencores6.org6/cores6/uart165506/                   ////
////                                                              ////
////  Documentation6 related6 to this project6:                      ////
////  - http6://www6.opencores6.org6/cores6/uart165506/                 ////
////                                                              ////
////  Projects6 compatibility6:                                     ////
////  - WISHBONE6                                                  ////
////  RS2326 Protocol6                                              ////
////  16550D uart6 (mostly6 supported)                              ////
////                                                              ////
////  Overview6 (main6 Features6):                                   ////
////  UART6 core6 WISHBONE6 interface.                               ////
////                                                              ////
////  Known6 problems6 (limits6):                                    ////
////  Inserts6 one wait state on all transfers6.                    ////
////  Note6 affected6 signals6 and the way6 they are affected6.        ////
////                                                              ////
////  To6 Do6:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author6(s):                                                  ////
////      - gorban6@opencores6.org6                                  ////
////      - Jacob6 Gorban6                                          ////
////      - Igor6 Mohor6 (igorm6@opencores6.org6)                      ////
////                                                              ////
////  Created6:        2001/05/12                                  ////
////  Last6 Updated6:   2001/05/17                                  ////
////                  (See log6 for the revision6 history6)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2000, 2001 Authors6                             ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS6 Revision6 History6
//
// $Log: not supported by cvs2svn6 $
// Revision6 1.16  2002/07/29 21:16:18  gorban6
// The uart_defines6.v file is included6 again6 in sources6.
//
// Revision6 1.15  2002/07/22 23:02:23  gorban6
// Bug6 Fixes6:
//  * Possible6 loss of sync and bad6 reception6 of stop bit on slow6 baud6 rates6 fixed6.
//   Problem6 reported6 by Kenny6.Tung6.
//  * Bad (or lack6 of ) loopback6 handling6 fixed6. Reported6 by Cherry6 Withers6.
//
// Improvements6:
//  * Made6 FIFO's as general6 inferrable6 memory where possible6.
//  So6 on FPGA6 they should be inferred6 as RAM6 (Distributed6 RAM6 on Xilinx6).
//  This6 saves6 about6 1/3 of the Slice6 count and reduces6 P&R and synthesis6 times.
//
//  * Added6 optional6 baudrate6 output (baud_o6).
//  This6 is identical6 to BAUDOUT6* signal6 on 16550 chip6.
//  It outputs6 16xbit_clock_rate - the divided6 clock6.
//  It's disabled by default. Define6 UART_HAS_BAUDRATE_OUTPUT6 to use.
//
// Revision6 1.12  2001/12/19 08:03:34  mohor6
// Warnings6 cleared6.
//
// Revision6 1.11  2001/12/06 14:51:04  gorban6
// Bug6 in LSR6[0] is fixed6.
// All WISHBONE6 signals6 are now sampled6, so another6 wait-state is introduced6 on all transfers6.
//
// Revision6 1.10  2001/12/03 21:44:29  gorban6
// Updated6 specification6 documentation.
// Added6 full 32-bit data bus interface, now as default.
// Address is 5-bit wide6 in 32-bit data bus mode.
// Added6 wb_sel_i6 input to the core6. It's used in the 32-bit mode.
// Added6 debug6 interface with two6 32-bit read-only registers in 32-bit mode.
// Bits6 5 and 6 of LSR6 are now only cleared6 on TX6 FIFO write.
// My6 small test bench6 is modified to work6 with 32-bit mode.
//
// Revision6 1.9  2001/10/20 09:58:40  gorban6
// Small6 synopsis6 fixes6
//
// Revision6 1.8  2001/08/24 21:01:12  mohor6
// Things6 connected6 to parity6 changed.
// Clock6 devider6 changed.
//
// Revision6 1.7  2001/08/23 16:05:05  mohor6
// Stop bit bug6 fixed6.
// Parity6 bug6 fixed6.
// WISHBONE6 read cycle bug6 fixed6,
// OE6 indicator6 (Overrun6 Error) bug6 fixed6.
// PE6 indicator6 (Parity6 Error) bug6 fixed6.
// Register read bug6 fixed6.
//
// Revision6 1.4  2001/05/31 20:08:01  gorban6
// FIFO changes6 and other corrections6.
//
// Revision6 1.3  2001/05/21 19:12:01  gorban6
// Corrected6 some6 Linter6 messages6.
//
// Revision6 1.2  2001/05/17 18:34:18  gorban6
// First6 'stable' release. Should6 be sythesizable6 now. Also6 added new header.
//
// Revision6 1.0  2001-05-17 21:27:13+02  jacob6
// Initial6 revision6
//
//

// UART6 core6 WISHBONE6 interface 
//
// Author6: Jacob6 Gorban6   (jacob6.gorban6@flextronicssemi6.com6)
// Company6: Flextronics6 Semiconductor6
//

// synopsys6 translate_off6
`include "timescale.v"
// synopsys6 translate_on6
`include "uart_defines6.v"
 
module uart_wb6 (clk6, wb_rst_i6, 
	wb_we_i6, wb_stb_i6, wb_cyc_i6, wb_ack_o6, wb_adr_i6,
	wb_adr_int6, wb_dat_i6, wb_dat_o6, wb_dat8_i6, wb_dat8_o6, wb_dat32_o6, wb_sel_i6,
	we_o6, re_o6 // Write and read enable output for the core6
);

input 		  clk6;

// WISHBONE6 interface	
input 		  wb_rst_i6;
input 		  wb_we_i6;
input 		  wb_stb_i6;
input 		  wb_cyc_i6;
input [3:0]   wb_sel_i6;
input [`UART_ADDR_WIDTH6-1:0] 	wb_adr_i6; //WISHBONE6 address line

`ifdef DATA_BUS_WIDTH_86
input [7:0]  wb_dat_i6; //input WISHBONE6 bus 
output [7:0] wb_dat_o6;
reg [7:0] 	 wb_dat_o6;
wire [7:0] 	 wb_dat_i6;
reg [7:0] 	 wb_dat_is6;
`else // for 32 data bus mode
input [31:0]  wb_dat_i6; //input WISHBONE6 bus 
output [31:0] wb_dat_o6;
reg [31:0] 	  wb_dat_o6;
wire [31:0]   wb_dat_i6;
reg [31:0] 	  wb_dat_is6;
`endif // !`ifdef DATA_BUS_WIDTH_86

output [`UART_ADDR_WIDTH6-1:0]	wb_adr_int6; // internal signal6 for address bus
input [7:0]   wb_dat8_o6; // internal 8 bit output to be put into wb_dat_o6
output [7:0]  wb_dat8_i6;
input [31:0]  wb_dat32_o6; // 32 bit data output (for debug6 interface)
output 		  wb_ack_o6;
output 		  we_o6;
output 		  re_o6;

wire 			  we_o6;
reg 			  wb_ack_o6;
reg [7:0] 	  wb_dat8_i6;
wire [7:0] 	  wb_dat8_o6;
wire [`UART_ADDR_WIDTH6-1:0]	wb_adr_int6; // internal signal6 for address bus
reg [`UART_ADDR_WIDTH6-1:0]	wb_adr_is6;
reg 								wb_we_is6;
reg 								wb_cyc_is6;
reg 								wb_stb_is6;
reg [3:0] 						wb_sel_is6;
wire [3:0]   wb_sel_i6;
reg 			 wre6 ;// timing6 control6 signal6 for write or read enable

// wb_ack_o6 FSM6
reg [1:0] 	 wbstate6;
always  @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) begin
		wb_ack_o6 <= #1 1'b0;
		wbstate6 <= #1 0;
		wre6 <= #1 1'b1;
	end else
		case (wbstate6)
			0: begin
				if (wb_stb_is6 & wb_cyc_is6) begin
					wre6 <= #1 0;
					wbstate6 <= #1 1;
					wb_ack_o6 <= #1 1;
				end else begin
					wre6 <= #1 1;
					wb_ack_o6 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o6 <= #1 0;
				wbstate6 <= #1 2;
				wre6 <= #1 0;
			end
			2,3: begin
				wb_ack_o6 <= #1 0;
				wbstate6 <= #1 0;
				wre6 <= #1 0;
			end
		endcase

assign we_o6 =  wb_we_is6 & wb_stb_is6 & wb_cyc_is6 & wre6 ; //WE6 for registers	
assign re_o6 = ~wb_we_is6 & wb_stb_is6 & wb_cyc_is6 & wre6 ; //RE6 for registers	

// Sample6 input signals6
always  @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6) begin
		wb_adr_is6 <= #1 0;
		wb_we_is6 <= #1 0;
		wb_cyc_is6 <= #1 0;
		wb_stb_is6 <= #1 0;
		wb_dat_is6 <= #1 0;
		wb_sel_is6 <= #1 0;
	end else begin
		wb_adr_is6 <= #1 wb_adr_i6;
		wb_we_is6 <= #1 wb_we_i6;
		wb_cyc_is6 <= #1 wb_cyc_i6;
		wb_stb_is6 <= #1 wb_stb_i6;
		wb_dat_is6 <= #1 wb_dat_i6;
		wb_sel_is6 <= #1 wb_sel_i6;
	end

`ifdef DATA_BUS_WIDTH_86 // 8-bit data bus
always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6)
		wb_dat_o6 <= #1 0;
	else
		wb_dat_o6 <= #1 wb_dat8_o6;

always @(wb_dat_is6)
	wb_dat8_i6 = wb_dat_is6;

assign wb_adr_int6 = wb_adr_is6;

`else // 32-bit bus
// put output to the correct6 byte in 32 bits using select6 line
always @(posedge clk6 or posedge wb_rst_i6)
	if (wb_rst_i6)
		wb_dat_o6 <= #1 0;
	else if (re_o6)
		case (wb_sel_is6)
			4'b0001: wb_dat_o6 <= #1 {24'b0, wb_dat8_o6};
			4'b0010: wb_dat_o6 <= #1 {16'b0, wb_dat8_o6, 8'b0};
			4'b0100: wb_dat_o6 <= #1 {8'b0, wb_dat8_o6, 16'b0};
			4'b1000: wb_dat_o6 <= #1 {wb_dat8_o6, 24'b0};
			4'b1111: wb_dat_o6 <= #1 wb_dat32_o6; // debug6 interface output
 			default: wb_dat_o6 <= #1 0;
		endcase // case(wb_sel_i6)

reg [1:0] wb_adr_int_lsb6;

always @(wb_sel_is6 or wb_dat_is6)
begin
	case (wb_sel_is6)
		4'b0001 : wb_dat8_i6 = wb_dat_is6[7:0];
		4'b0010 : wb_dat8_i6 = wb_dat_is6[15:8];
		4'b0100 : wb_dat8_i6 = wb_dat_is6[23:16];
		4'b1000 : wb_dat8_i6 = wb_dat_is6[31:24];
		default : wb_dat8_i6 = wb_dat_is6[7:0];
	endcase // case(wb_sel_i6)

  `ifdef LITLE_ENDIAN6
	case (wb_sel_is6)
		4'b0001 : wb_adr_int_lsb6 = 2'h0;
		4'b0010 : wb_adr_int_lsb6 = 2'h1;
		4'b0100 : wb_adr_int_lsb6 = 2'h2;
		4'b1000 : wb_adr_int_lsb6 = 2'h3;
		default : wb_adr_int_lsb6 = 2'h0;
	endcase // case(wb_sel_i6)
  `else
	case (wb_sel_is6)
		4'b0001 : wb_adr_int_lsb6 = 2'h3;
		4'b0010 : wb_adr_int_lsb6 = 2'h2;
		4'b0100 : wb_adr_int_lsb6 = 2'h1;
		4'b1000 : wb_adr_int_lsb6 = 2'h0;
		default : wb_adr_int_lsb6 = 2'h0;
	endcase // case(wb_sel_i6)
  `endif
end

assign wb_adr_int6 = {wb_adr_is6[`UART_ADDR_WIDTH6-1:2], wb_adr_int_lsb6};

`endif // !`ifdef DATA_BUS_WIDTH_86

endmodule










