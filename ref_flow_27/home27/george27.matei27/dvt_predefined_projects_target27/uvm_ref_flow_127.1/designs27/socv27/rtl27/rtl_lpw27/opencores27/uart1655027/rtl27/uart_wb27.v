//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb27.v                                                   ////
////                                                              ////
////                                                              ////
////  This27 file is part of the "UART27 16550 compatible27" project27    ////
////  http27://www27.opencores27.org27/cores27/uart1655027/                   ////
////                                                              ////
////  Documentation27 related27 to this project27:                      ////
////  - http27://www27.opencores27.org27/cores27/uart1655027/                 ////
////                                                              ////
////  Projects27 compatibility27:                                     ////
////  - WISHBONE27                                                  ////
////  RS23227 Protocol27                                              ////
////  16550D uart27 (mostly27 supported)                              ////
////                                                              ////
////  Overview27 (main27 Features27):                                   ////
////  UART27 core27 WISHBONE27 interface.                               ////
////                                                              ////
////  Known27 problems27 (limits27):                                    ////
////  Inserts27 one wait state on all transfers27.                    ////
////  Note27 affected27 signals27 and the way27 they are affected27.        ////
////                                                              ////
////  To27 Do27:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author27(s):                                                  ////
////      - gorban27@opencores27.org27                                  ////
////      - Jacob27 Gorban27                                          ////
////      - Igor27 Mohor27 (igorm27@opencores27.org27)                      ////
////                                                              ////
////  Created27:        2001/05/12                                  ////
////  Last27 Updated27:   2001/05/17                                  ////
////                  (See log27 for the revision27 history27)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2000, 2001 Authors27                             ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS27 Revision27 History27
//
// $Log: not supported by cvs2svn27 $
// Revision27 1.16  2002/07/29 21:16:18  gorban27
// The uart_defines27.v file is included27 again27 in sources27.
//
// Revision27 1.15  2002/07/22 23:02:23  gorban27
// Bug27 Fixes27:
//  * Possible27 loss of sync and bad27 reception27 of stop bit on slow27 baud27 rates27 fixed27.
//   Problem27 reported27 by Kenny27.Tung27.
//  * Bad (or lack27 of ) loopback27 handling27 fixed27. Reported27 by Cherry27 Withers27.
//
// Improvements27:
//  * Made27 FIFO's as general27 inferrable27 memory where possible27.
//  So27 on FPGA27 they should be inferred27 as RAM27 (Distributed27 RAM27 on Xilinx27).
//  This27 saves27 about27 1/3 of the Slice27 count and reduces27 P&R and synthesis27 times.
//
//  * Added27 optional27 baudrate27 output (baud_o27).
//  This27 is identical27 to BAUDOUT27* signal27 on 16550 chip27.
//  It outputs27 16xbit_clock_rate - the divided27 clock27.
//  It's disabled by default. Define27 UART_HAS_BAUDRATE_OUTPUT27 to use.
//
// Revision27 1.12  2001/12/19 08:03:34  mohor27
// Warnings27 cleared27.
//
// Revision27 1.11  2001/12/06 14:51:04  gorban27
// Bug27 in LSR27[0] is fixed27.
// All WISHBONE27 signals27 are now sampled27, so another27 wait-state is introduced27 on all transfers27.
//
// Revision27 1.10  2001/12/03 21:44:29  gorban27
// Updated27 specification27 documentation.
// Added27 full 32-bit data bus interface, now as default.
// Address is 5-bit wide27 in 32-bit data bus mode.
// Added27 wb_sel_i27 input to the core27. It's used in the 32-bit mode.
// Added27 debug27 interface with two27 32-bit read-only registers in 32-bit mode.
// Bits27 5 and 6 of LSR27 are now only cleared27 on TX27 FIFO write.
// My27 small test bench27 is modified to work27 with 32-bit mode.
//
// Revision27 1.9  2001/10/20 09:58:40  gorban27
// Small27 synopsis27 fixes27
//
// Revision27 1.8  2001/08/24 21:01:12  mohor27
// Things27 connected27 to parity27 changed.
// Clock27 devider27 changed.
//
// Revision27 1.7  2001/08/23 16:05:05  mohor27
// Stop bit bug27 fixed27.
// Parity27 bug27 fixed27.
// WISHBONE27 read cycle bug27 fixed27,
// OE27 indicator27 (Overrun27 Error) bug27 fixed27.
// PE27 indicator27 (Parity27 Error) bug27 fixed27.
// Register read bug27 fixed27.
//
// Revision27 1.4  2001/05/31 20:08:01  gorban27
// FIFO changes27 and other corrections27.
//
// Revision27 1.3  2001/05/21 19:12:01  gorban27
// Corrected27 some27 Linter27 messages27.
//
// Revision27 1.2  2001/05/17 18:34:18  gorban27
// First27 'stable' release. Should27 be sythesizable27 now. Also27 added new header.
//
// Revision27 1.0  2001-05-17 21:27:13+02  jacob27
// Initial27 revision27
//
//

// UART27 core27 WISHBONE27 interface 
//
// Author27: Jacob27 Gorban27   (jacob27.gorban27@flextronicssemi27.com27)
// Company27: Flextronics27 Semiconductor27
//

// synopsys27 translate_off27
`include "timescale.v"
// synopsys27 translate_on27
`include "uart_defines27.v"
 
module uart_wb27 (clk27, wb_rst_i27, 
	wb_we_i27, wb_stb_i27, wb_cyc_i27, wb_ack_o27, wb_adr_i27,
	wb_adr_int27, wb_dat_i27, wb_dat_o27, wb_dat8_i27, wb_dat8_o27, wb_dat32_o27, wb_sel_i27,
	we_o27, re_o27 // Write and read enable output for the core27
);

input 		  clk27;

// WISHBONE27 interface	
input 		  wb_rst_i27;
input 		  wb_we_i27;
input 		  wb_stb_i27;
input 		  wb_cyc_i27;
input [3:0]   wb_sel_i27;
input [`UART_ADDR_WIDTH27-1:0] 	wb_adr_i27; //WISHBONE27 address line

`ifdef DATA_BUS_WIDTH_827
input [7:0]  wb_dat_i27; //input WISHBONE27 bus 
output [7:0] wb_dat_o27;
reg [7:0] 	 wb_dat_o27;
wire [7:0] 	 wb_dat_i27;
reg [7:0] 	 wb_dat_is27;
`else // for 32 data bus mode
input [31:0]  wb_dat_i27; //input WISHBONE27 bus 
output [31:0] wb_dat_o27;
reg [31:0] 	  wb_dat_o27;
wire [31:0]   wb_dat_i27;
reg [31:0] 	  wb_dat_is27;
`endif // !`ifdef DATA_BUS_WIDTH_827

output [`UART_ADDR_WIDTH27-1:0]	wb_adr_int27; // internal signal27 for address bus
input [7:0]   wb_dat8_o27; // internal 8 bit output to be put into wb_dat_o27
output [7:0]  wb_dat8_i27;
input [31:0]  wb_dat32_o27; // 32 bit data output (for debug27 interface)
output 		  wb_ack_o27;
output 		  we_o27;
output 		  re_o27;

wire 			  we_o27;
reg 			  wb_ack_o27;
reg [7:0] 	  wb_dat8_i27;
wire [7:0] 	  wb_dat8_o27;
wire [`UART_ADDR_WIDTH27-1:0]	wb_adr_int27; // internal signal27 for address bus
reg [`UART_ADDR_WIDTH27-1:0]	wb_adr_is27;
reg 								wb_we_is27;
reg 								wb_cyc_is27;
reg 								wb_stb_is27;
reg [3:0] 						wb_sel_is27;
wire [3:0]   wb_sel_i27;
reg 			 wre27 ;// timing27 control27 signal27 for write or read enable

// wb_ack_o27 FSM27
reg [1:0] 	 wbstate27;
always  @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) begin
		wb_ack_o27 <= #1 1'b0;
		wbstate27 <= #1 0;
		wre27 <= #1 1'b1;
	end else
		case (wbstate27)
			0: begin
				if (wb_stb_is27 & wb_cyc_is27) begin
					wre27 <= #1 0;
					wbstate27 <= #1 1;
					wb_ack_o27 <= #1 1;
				end else begin
					wre27 <= #1 1;
					wb_ack_o27 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o27 <= #1 0;
				wbstate27 <= #1 2;
				wre27 <= #1 0;
			end
			2,3: begin
				wb_ack_o27 <= #1 0;
				wbstate27 <= #1 0;
				wre27 <= #1 0;
			end
		endcase

assign we_o27 =  wb_we_is27 & wb_stb_is27 & wb_cyc_is27 & wre27 ; //WE27 for registers	
assign re_o27 = ~wb_we_is27 & wb_stb_is27 & wb_cyc_is27 & wre27 ; //RE27 for registers	

// Sample27 input signals27
always  @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27) begin
		wb_adr_is27 <= #1 0;
		wb_we_is27 <= #1 0;
		wb_cyc_is27 <= #1 0;
		wb_stb_is27 <= #1 0;
		wb_dat_is27 <= #1 0;
		wb_sel_is27 <= #1 0;
	end else begin
		wb_adr_is27 <= #1 wb_adr_i27;
		wb_we_is27 <= #1 wb_we_i27;
		wb_cyc_is27 <= #1 wb_cyc_i27;
		wb_stb_is27 <= #1 wb_stb_i27;
		wb_dat_is27 <= #1 wb_dat_i27;
		wb_sel_is27 <= #1 wb_sel_i27;
	end

`ifdef DATA_BUS_WIDTH_827 // 8-bit data bus
always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27)
		wb_dat_o27 <= #1 0;
	else
		wb_dat_o27 <= #1 wb_dat8_o27;

always @(wb_dat_is27)
	wb_dat8_i27 = wb_dat_is27;

assign wb_adr_int27 = wb_adr_is27;

`else // 32-bit bus
// put output to the correct27 byte in 32 bits using select27 line
always @(posedge clk27 or posedge wb_rst_i27)
	if (wb_rst_i27)
		wb_dat_o27 <= #1 0;
	else if (re_o27)
		case (wb_sel_is27)
			4'b0001: wb_dat_o27 <= #1 {24'b0, wb_dat8_o27};
			4'b0010: wb_dat_o27 <= #1 {16'b0, wb_dat8_o27, 8'b0};
			4'b0100: wb_dat_o27 <= #1 {8'b0, wb_dat8_o27, 16'b0};
			4'b1000: wb_dat_o27 <= #1 {wb_dat8_o27, 24'b0};
			4'b1111: wb_dat_o27 <= #1 wb_dat32_o27; // debug27 interface output
 			default: wb_dat_o27 <= #1 0;
		endcase // case(wb_sel_i27)

reg [1:0] wb_adr_int_lsb27;

always @(wb_sel_is27 or wb_dat_is27)
begin
	case (wb_sel_is27)
		4'b0001 : wb_dat8_i27 = wb_dat_is27[7:0];
		4'b0010 : wb_dat8_i27 = wb_dat_is27[15:8];
		4'b0100 : wb_dat8_i27 = wb_dat_is27[23:16];
		4'b1000 : wb_dat8_i27 = wb_dat_is27[31:24];
		default : wb_dat8_i27 = wb_dat_is27[7:0];
	endcase // case(wb_sel_i27)

  `ifdef LITLE_ENDIAN27
	case (wb_sel_is27)
		4'b0001 : wb_adr_int_lsb27 = 2'h0;
		4'b0010 : wb_adr_int_lsb27 = 2'h1;
		4'b0100 : wb_adr_int_lsb27 = 2'h2;
		4'b1000 : wb_adr_int_lsb27 = 2'h3;
		default : wb_adr_int_lsb27 = 2'h0;
	endcase // case(wb_sel_i27)
  `else
	case (wb_sel_is27)
		4'b0001 : wb_adr_int_lsb27 = 2'h3;
		4'b0010 : wb_adr_int_lsb27 = 2'h2;
		4'b0100 : wb_adr_int_lsb27 = 2'h1;
		4'b1000 : wb_adr_int_lsb27 = 2'h0;
		default : wb_adr_int_lsb27 = 2'h0;
	endcase // case(wb_sel_i27)
  `endif
end

assign wb_adr_int27 = {wb_adr_is27[`UART_ADDR_WIDTH27-1:2], wb_adr_int_lsb27};

`endif // !`ifdef DATA_BUS_WIDTH_827

endmodule










