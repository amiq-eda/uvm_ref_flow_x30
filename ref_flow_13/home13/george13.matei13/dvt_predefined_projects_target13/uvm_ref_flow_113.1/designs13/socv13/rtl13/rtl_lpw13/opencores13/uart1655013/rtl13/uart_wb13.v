//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb13.v                                                   ////
////                                                              ////
////                                                              ////
////  This13 file is part of the "UART13 16550 compatible13" project13    ////
////  http13://www13.opencores13.org13/cores13/uart1655013/                   ////
////                                                              ////
////  Documentation13 related13 to this project13:                      ////
////  - http13://www13.opencores13.org13/cores13/uart1655013/                 ////
////                                                              ////
////  Projects13 compatibility13:                                     ////
////  - WISHBONE13                                                  ////
////  RS23213 Protocol13                                              ////
////  16550D uart13 (mostly13 supported)                              ////
////                                                              ////
////  Overview13 (main13 Features13):                                   ////
////  UART13 core13 WISHBONE13 interface.                               ////
////                                                              ////
////  Known13 problems13 (limits13):                                    ////
////  Inserts13 one wait state on all transfers13.                    ////
////  Note13 affected13 signals13 and the way13 they are affected13.        ////
////                                                              ////
////  To13 Do13:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author13(s):                                                  ////
////      - gorban13@opencores13.org13                                  ////
////      - Jacob13 Gorban13                                          ////
////      - Igor13 Mohor13 (igorm13@opencores13.org13)                      ////
////                                                              ////
////  Created13:        2001/05/12                                  ////
////  Last13 Updated13:   2001/05/17                                  ////
////                  (See log13 for the revision13 history13)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2000, 2001 Authors13                             ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS13 Revision13 History13
//
// $Log: not supported by cvs2svn13 $
// Revision13 1.16  2002/07/29 21:16:18  gorban13
// The uart_defines13.v file is included13 again13 in sources13.
//
// Revision13 1.15  2002/07/22 23:02:23  gorban13
// Bug13 Fixes13:
//  * Possible13 loss of sync and bad13 reception13 of stop bit on slow13 baud13 rates13 fixed13.
//   Problem13 reported13 by Kenny13.Tung13.
//  * Bad (or lack13 of ) loopback13 handling13 fixed13. Reported13 by Cherry13 Withers13.
//
// Improvements13:
//  * Made13 FIFO's as general13 inferrable13 memory where possible13.
//  So13 on FPGA13 they should be inferred13 as RAM13 (Distributed13 RAM13 on Xilinx13).
//  This13 saves13 about13 1/3 of the Slice13 count and reduces13 P&R and synthesis13 times.
//
//  * Added13 optional13 baudrate13 output (baud_o13).
//  This13 is identical13 to BAUDOUT13* signal13 on 16550 chip13.
//  It outputs13 16xbit_clock_rate - the divided13 clock13.
//  It's disabled by default. Define13 UART_HAS_BAUDRATE_OUTPUT13 to use.
//
// Revision13 1.12  2001/12/19 08:03:34  mohor13
// Warnings13 cleared13.
//
// Revision13 1.11  2001/12/06 14:51:04  gorban13
// Bug13 in LSR13[0] is fixed13.
// All WISHBONE13 signals13 are now sampled13, so another13 wait-state is introduced13 on all transfers13.
//
// Revision13 1.10  2001/12/03 21:44:29  gorban13
// Updated13 specification13 documentation.
// Added13 full 32-bit data bus interface, now as default.
// Address is 5-bit wide13 in 32-bit data bus mode.
// Added13 wb_sel_i13 input to the core13. It's used in the 32-bit mode.
// Added13 debug13 interface with two13 32-bit read-only registers in 32-bit mode.
// Bits13 5 and 6 of LSR13 are now only cleared13 on TX13 FIFO write.
// My13 small test bench13 is modified to work13 with 32-bit mode.
//
// Revision13 1.9  2001/10/20 09:58:40  gorban13
// Small13 synopsis13 fixes13
//
// Revision13 1.8  2001/08/24 21:01:12  mohor13
// Things13 connected13 to parity13 changed.
// Clock13 devider13 changed.
//
// Revision13 1.7  2001/08/23 16:05:05  mohor13
// Stop bit bug13 fixed13.
// Parity13 bug13 fixed13.
// WISHBONE13 read cycle bug13 fixed13,
// OE13 indicator13 (Overrun13 Error) bug13 fixed13.
// PE13 indicator13 (Parity13 Error) bug13 fixed13.
// Register read bug13 fixed13.
//
// Revision13 1.4  2001/05/31 20:08:01  gorban13
// FIFO changes13 and other corrections13.
//
// Revision13 1.3  2001/05/21 19:12:01  gorban13
// Corrected13 some13 Linter13 messages13.
//
// Revision13 1.2  2001/05/17 18:34:18  gorban13
// First13 'stable' release. Should13 be sythesizable13 now. Also13 added new header.
//
// Revision13 1.0  2001-05-17 21:27:13+02  jacob13
// Initial13 revision13
//
//

// UART13 core13 WISHBONE13 interface 
//
// Author13: Jacob13 Gorban13   (jacob13.gorban13@flextronicssemi13.com13)
// Company13: Flextronics13 Semiconductor13
//

// synopsys13 translate_off13
`include "timescale.v"
// synopsys13 translate_on13
`include "uart_defines13.v"
 
module uart_wb13 (clk13, wb_rst_i13, 
	wb_we_i13, wb_stb_i13, wb_cyc_i13, wb_ack_o13, wb_adr_i13,
	wb_adr_int13, wb_dat_i13, wb_dat_o13, wb_dat8_i13, wb_dat8_o13, wb_dat32_o13, wb_sel_i13,
	we_o13, re_o13 // Write and read enable output for the core13
);

input 		  clk13;

// WISHBONE13 interface	
input 		  wb_rst_i13;
input 		  wb_we_i13;
input 		  wb_stb_i13;
input 		  wb_cyc_i13;
input [3:0]   wb_sel_i13;
input [`UART_ADDR_WIDTH13-1:0] 	wb_adr_i13; //WISHBONE13 address line

`ifdef DATA_BUS_WIDTH_813
input [7:0]  wb_dat_i13; //input WISHBONE13 bus 
output [7:0] wb_dat_o13;
reg [7:0] 	 wb_dat_o13;
wire [7:0] 	 wb_dat_i13;
reg [7:0] 	 wb_dat_is13;
`else // for 32 data bus mode
input [31:0]  wb_dat_i13; //input WISHBONE13 bus 
output [31:0] wb_dat_o13;
reg [31:0] 	  wb_dat_o13;
wire [31:0]   wb_dat_i13;
reg [31:0] 	  wb_dat_is13;
`endif // !`ifdef DATA_BUS_WIDTH_813

output [`UART_ADDR_WIDTH13-1:0]	wb_adr_int13; // internal signal13 for address bus
input [7:0]   wb_dat8_o13; // internal 8 bit output to be put into wb_dat_o13
output [7:0]  wb_dat8_i13;
input [31:0]  wb_dat32_o13; // 32 bit data output (for debug13 interface)
output 		  wb_ack_o13;
output 		  we_o13;
output 		  re_o13;

wire 			  we_o13;
reg 			  wb_ack_o13;
reg [7:0] 	  wb_dat8_i13;
wire [7:0] 	  wb_dat8_o13;
wire [`UART_ADDR_WIDTH13-1:0]	wb_adr_int13; // internal signal13 for address bus
reg [`UART_ADDR_WIDTH13-1:0]	wb_adr_is13;
reg 								wb_we_is13;
reg 								wb_cyc_is13;
reg 								wb_stb_is13;
reg [3:0] 						wb_sel_is13;
wire [3:0]   wb_sel_i13;
reg 			 wre13 ;// timing13 control13 signal13 for write or read enable

// wb_ack_o13 FSM13
reg [1:0] 	 wbstate13;
always  @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) begin
		wb_ack_o13 <= #1 1'b0;
		wbstate13 <= #1 0;
		wre13 <= #1 1'b1;
	end else
		case (wbstate13)
			0: begin
				if (wb_stb_is13 & wb_cyc_is13) begin
					wre13 <= #1 0;
					wbstate13 <= #1 1;
					wb_ack_o13 <= #1 1;
				end else begin
					wre13 <= #1 1;
					wb_ack_o13 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o13 <= #1 0;
				wbstate13 <= #1 2;
				wre13 <= #1 0;
			end
			2,3: begin
				wb_ack_o13 <= #1 0;
				wbstate13 <= #1 0;
				wre13 <= #1 0;
			end
		endcase

assign we_o13 =  wb_we_is13 & wb_stb_is13 & wb_cyc_is13 & wre13 ; //WE13 for registers	
assign re_o13 = ~wb_we_is13 & wb_stb_is13 & wb_cyc_is13 & wre13 ; //RE13 for registers	

// Sample13 input signals13
always  @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13) begin
		wb_adr_is13 <= #1 0;
		wb_we_is13 <= #1 0;
		wb_cyc_is13 <= #1 0;
		wb_stb_is13 <= #1 0;
		wb_dat_is13 <= #1 0;
		wb_sel_is13 <= #1 0;
	end else begin
		wb_adr_is13 <= #1 wb_adr_i13;
		wb_we_is13 <= #1 wb_we_i13;
		wb_cyc_is13 <= #1 wb_cyc_i13;
		wb_stb_is13 <= #1 wb_stb_i13;
		wb_dat_is13 <= #1 wb_dat_i13;
		wb_sel_is13 <= #1 wb_sel_i13;
	end

`ifdef DATA_BUS_WIDTH_813 // 8-bit data bus
always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13)
		wb_dat_o13 <= #1 0;
	else
		wb_dat_o13 <= #1 wb_dat8_o13;

always @(wb_dat_is13)
	wb_dat8_i13 = wb_dat_is13;

assign wb_adr_int13 = wb_adr_is13;

`else // 32-bit bus
// put output to the correct13 byte in 32 bits using select13 line
always @(posedge clk13 or posedge wb_rst_i13)
	if (wb_rst_i13)
		wb_dat_o13 <= #1 0;
	else if (re_o13)
		case (wb_sel_is13)
			4'b0001: wb_dat_o13 <= #1 {24'b0, wb_dat8_o13};
			4'b0010: wb_dat_o13 <= #1 {16'b0, wb_dat8_o13, 8'b0};
			4'b0100: wb_dat_o13 <= #1 {8'b0, wb_dat8_o13, 16'b0};
			4'b1000: wb_dat_o13 <= #1 {wb_dat8_o13, 24'b0};
			4'b1111: wb_dat_o13 <= #1 wb_dat32_o13; // debug13 interface output
 			default: wb_dat_o13 <= #1 0;
		endcase // case(wb_sel_i13)

reg [1:0] wb_adr_int_lsb13;

always @(wb_sel_is13 or wb_dat_is13)
begin
	case (wb_sel_is13)
		4'b0001 : wb_dat8_i13 = wb_dat_is13[7:0];
		4'b0010 : wb_dat8_i13 = wb_dat_is13[15:8];
		4'b0100 : wb_dat8_i13 = wb_dat_is13[23:16];
		4'b1000 : wb_dat8_i13 = wb_dat_is13[31:24];
		default : wb_dat8_i13 = wb_dat_is13[7:0];
	endcase // case(wb_sel_i13)

  `ifdef LITLE_ENDIAN13
	case (wb_sel_is13)
		4'b0001 : wb_adr_int_lsb13 = 2'h0;
		4'b0010 : wb_adr_int_lsb13 = 2'h1;
		4'b0100 : wb_adr_int_lsb13 = 2'h2;
		4'b1000 : wb_adr_int_lsb13 = 2'h3;
		default : wb_adr_int_lsb13 = 2'h0;
	endcase // case(wb_sel_i13)
  `else
	case (wb_sel_is13)
		4'b0001 : wb_adr_int_lsb13 = 2'h3;
		4'b0010 : wb_adr_int_lsb13 = 2'h2;
		4'b0100 : wb_adr_int_lsb13 = 2'h1;
		4'b1000 : wb_adr_int_lsb13 = 2'h0;
		default : wb_adr_int_lsb13 = 2'h0;
	endcase // case(wb_sel_i13)
  `endif
end

assign wb_adr_int13 = {wb_adr_is13[`UART_ADDR_WIDTH13-1:2], wb_adr_int_lsb13};

`endif // !`ifdef DATA_BUS_WIDTH_813

endmodule










