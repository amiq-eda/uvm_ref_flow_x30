//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb22.v                                                   ////
////                                                              ////
////                                                              ////
////  This22 file is part of the "UART22 16550 compatible22" project22    ////
////  http22://www22.opencores22.org22/cores22/uart1655022/                   ////
////                                                              ////
////  Documentation22 related22 to this project22:                      ////
////  - http22://www22.opencores22.org22/cores22/uart1655022/                 ////
////                                                              ////
////  Projects22 compatibility22:                                     ////
////  - WISHBONE22                                                  ////
////  RS23222 Protocol22                                              ////
////  16550D uart22 (mostly22 supported)                              ////
////                                                              ////
////  Overview22 (main22 Features22):                                   ////
////  UART22 core22 WISHBONE22 interface.                               ////
////                                                              ////
////  Known22 problems22 (limits22):                                    ////
////  Inserts22 one wait state on all transfers22.                    ////
////  Note22 affected22 signals22 and the way22 they are affected22.        ////
////                                                              ////
////  To22 Do22:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author22(s):                                                  ////
////      - gorban22@opencores22.org22                                  ////
////      - Jacob22 Gorban22                                          ////
////      - Igor22 Mohor22 (igorm22@opencores22.org22)                      ////
////                                                              ////
////  Created22:        2001/05/12                                  ////
////  Last22 Updated22:   2001/05/17                                  ////
////                  (See log22 for the revision22 history22)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2000, 2001 Authors22                             ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS22 Revision22 History22
//
// $Log: not supported by cvs2svn22 $
// Revision22 1.16  2002/07/29 21:16:18  gorban22
// The uart_defines22.v file is included22 again22 in sources22.
//
// Revision22 1.15  2002/07/22 23:02:23  gorban22
// Bug22 Fixes22:
//  * Possible22 loss of sync and bad22 reception22 of stop bit on slow22 baud22 rates22 fixed22.
//   Problem22 reported22 by Kenny22.Tung22.
//  * Bad (or lack22 of ) loopback22 handling22 fixed22. Reported22 by Cherry22 Withers22.
//
// Improvements22:
//  * Made22 FIFO's as general22 inferrable22 memory where possible22.
//  So22 on FPGA22 they should be inferred22 as RAM22 (Distributed22 RAM22 on Xilinx22).
//  This22 saves22 about22 1/3 of the Slice22 count and reduces22 P&R and synthesis22 times.
//
//  * Added22 optional22 baudrate22 output (baud_o22).
//  This22 is identical22 to BAUDOUT22* signal22 on 16550 chip22.
//  It outputs22 16xbit_clock_rate - the divided22 clock22.
//  It's disabled by default. Define22 UART_HAS_BAUDRATE_OUTPUT22 to use.
//
// Revision22 1.12  2001/12/19 08:03:34  mohor22
// Warnings22 cleared22.
//
// Revision22 1.11  2001/12/06 14:51:04  gorban22
// Bug22 in LSR22[0] is fixed22.
// All WISHBONE22 signals22 are now sampled22, so another22 wait-state is introduced22 on all transfers22.
//
// Revision22 1.10  2001/12/03 21:44:29  gorban22
// Updated22 specification22 documentation.
// Added22 full 32-bit data bus interface, now as default.
// Address is 5-bit wide22 in 32-bit data bus mode.
// Added22 wb_sel_i22 input to the core22. It's used in the 32-bit mode.
// Added22 debug22 interface with two22 32-bit read-only registers in 32-bit mode.
// Bits22 5 and 6 of LSR22 are now only cleared22 on TX22 FIFO write.
// My22 small test bench22 is modified to work22 with 32-bit mode.
//
// Revision22 1.9  2001/10/20 09:58:40  gorban22
// Small22 synopsis22 fixes22
//
// Revision22 1.8  2001/08/24 21:01:12  mohor22
// Things22 connected22 to parity22 changed.
// Clock22 devider22 changed.
//
// Revision22 1.7  2001/08/23 16:05:05  mohor22
// Stop bit bug22 fixed22.
// Parity22 bug22 fixed22.
// WISHBONE22 read cycle bug22 fixed22,
// OE22 indicator22 (Overrun22 Error) bug22 fixed22.
// PE22 indicator22 (Parity22 Error) bug22 fixed22.
// Register read bug22 fixed22.
//
// Revision22 1.4  2001/05/31 20:08:01  gorban22
// FIFO changes22 and other corrections22.
//
// Revision22 1.3  2001/05/21 19:12:01  gorban22
// Corrected22 some22 Linter22 messages22.
//
// Revision22 1.2  2001/05/17 18:34:18  gorban22
// First22 'stable' release. Should22 be sythesizable22 now. Also22 added new header.
//
// Revision22 1.0  2001-05-17 21:27:13+02  jacob22
// Initial22 revision22
//
//

// UART22 core22 WISHBONE22 interface 
//
// Author22: Jacob22 Gorban22   (jacob22.gorban22@flextronicssemi22.com22)
// Company22: Flextronics22 Semiconductor22
//

// synopsys22 translate_off22
`include "timescale.v"
// synopsys22 translate_on22
`include "uart_defines22.v"
 
module uart_wb22 (clk22, wb_rst_i22, 
	wb_we_i22, wb_stb_i22, wb_cyc_i22, wb_ack_o22, wb_adr_i22,
	wb_adr_int22, wb_dat_i22, wb_dat_o22, wb_dat8_i22, wb_dat8_o22, wb_dat32_o22, wb_sel_i22,
	we_o22, re_o22 // Write and read enable output for the core22
);

input 		  clk22;

// WISHBONE22 interface	
input 		  wb_rst_i22;
input 		  wb_we_i22;
input 		  wb_stb_i22;
input 		  wb_cyc_i22;
input [3:0]   wb_sel_i22;
input [`UART_ADDR_WIDTH22-1:0] 	wb_adr_i22; //WISHBONE22 address line

`ifdef DATA_BUS_WIDTH_822
input [7:0]  wb_dat_i22; //input WISHBONE22 bus 
output [7:0] wb_dat_o22;
reg [7:0] 	 wb_dat_o22;
wire [7:0] 	 wb_dat_i22;
reg [7:0] 	 wb_dat_is22;
`else // for 32 data bus mode
input [31:0]  wb_dat_i22; //input WISHBONE22 bus 
output [31:0] wb_dat_o22;
reg [31:0] 	  wb_dat_o22;
wire [31:0]   wb_dat_i22;
reg [31:0] 	  wb_dat_is22;
`endif // !`ifdef DATA_BUS_WIDTH_822

output [`UART_ADDR_WIDTH22-1:0]	wb_adr_int22; // internal signal22 for address bus
input [7:0]   wb_dat8_o22; // internal 8 bit output to be put into wb_dat_o22
output [7:0]  wb_dat8_i22;
input [31:0]  wb_dat32_o22; // 32 bit data output (for debug22 interface)
output 		  wb_ack_o22;
output 		  we_o22;
output 		  re_o22;

wire 			  we_o22;
reg 			  wb_ack_o22;
reg [7:0] 	  wb_dat8_i22;
wire [7:0] 	  wb_dat8_o22;
wire [`UART_ADDR_WIDTH22-1:0]	wb_adr_int22; // internal signal22 for address bus
reg [`UART_ADDR_WIDTH22-1:0]	wb_adr_is22;
reg 								wb_we_is22;
reg 								wb_cyc_is22;
reg 								wb_stb_is22;
reg [3:0] 						wb_sel_is22;
wire [3:0]   wb_sel_i22;
reg 			 wre22 ;// timing22 control22 signal22 for write or read enable

// wb_ack_o22 FSM22
reg [1:0] 	 wbstate22;
always  @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) begin
		wb_ack_o22 <= #1 1'b0;
		wbstate22 <= #1 0;
		wre22 <= #1 1'b1;
	end else
		case (wbstate22)
			0: begin
				if (wb_stb_is22 & wb_cyc_is22) begin
					wre22 <= #1 0;
					wbstate22 <= #1 1;
					wb_ack_o22 <= #1 1;
				end else begin
					wre22 <= #1 1;
					wb_ack_o22 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o22 <= #1 0;
				wbstate22 <= #1 2;
				wre22 <= #1 0;
			end
			2,3: begin
				wb_ack_o22 <= #1 0;
				wbstate22 <= #1 0;
				wre22 <= #1 0;
			end
		endcase

assign we_o22 =  wb_we_is22 & wb_stb_is22 & wb_cyc_is22 & wre22 ; //WE22 for registers	
assign re_o22 = ~wb_we_is22 & wb_stb_is22 & wb_cyc_is22 & wre22 ; //RE22 for registers	

// Sample22 input signals22
always  @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22) begin
		wb_adr_is22 <= #1 0;
		wb_we_is22 <= #1 0;
		wb_cyc_is22 <= #1 0;
		wb_stb_is22 <= #1 0;
		wb_dat_is22 <= #1 0;
		wb_sel_is22 <= #1 0;
	end else begin
		wb_adr_is22 <= #1 wb_adr_i22;
		wb_we_is22 <= #1 wb_we_i22;
		wb_cyc_is22 <= #1 wb_cyc_i22;
		wb_stb_is22 <= #1 wb_stb_i22;
		wb_dat_is22 <= #1 wb_dat_i22;
		wb_sel_is22 <= #1 wb_sel_i22;
	end

`ifdef DATA_BUS_WIDTH_822 // 8-bit data bus
always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22)
		wb_dat_o22 <= #1 0;
	else
		wb_dat_o22 <= #1 wb_dat8_o22;

always @(wb_dat_is22)
	wb_dat8_i22 = wb_dat_is22;

assign wb_adr_int22 = wb_adr_is22;

`else // 32-bit bus
// put output to the correct22 byte in 32 bits using select22 line
always @(posedge clk22 or posedge wb_rst_i22)
	if (wb_rst_i22)
		wb_dat_o22 <= #1 0;
	else if (re_o22)
		case (wb_sel_is22)
			4'b0001: wb_dat_o22 <= #1 {24'b0, wb_dat8_o22};
			4'b0010: wb_dat_o22 <= #1 {16'b0, wb_dat8_o22, 8'b0};
			4'b0100: wb_dat_o22 <= #1 {8'b0, wb_dat8_o22, 16'b0};
			4'b1000: wb_dat_o22 <= #1 {wb_dat8_o22, 24'b0};
			4'b1111: wb_dat_o22 <= #1 wb_dat32_o22; // debug22 interface output
 			default: wb_dat_o22 <= #1 0;
		endcase // case(wb_sel_i22)

reg [1:0] wb_adr_int_lsb22;

always @(wb_sel_is22 or wb_dat_is22)
begin
	case (wb_sel_is22)
		4'b0001 : wb_dat8_i22 = wb_dat_is22[7:0];
		4'b0010 : wb_dat8_i22 = wb_dat_is22[15:8];
		4'b0100 : wb_dat8_i22 = wb_dat_is22[23:16];
		4'b1000 : wb_dat8_i22 = wb_dat_is22[31:24];
		default : wb_dat8_i22 = wb_dat_is22[7:0];
	endcase // case(wb_sel_i22)

  `ifdef LITLE_ENDIAN22
	case (wb_sel_is22)
		4'b0001 : wb_adr_int_lsb22 = 2'h0;
		4'b0010 : wb_adr_int_lsb22 = 2'h1;
		4'b0100 : wb_adr_int_lsb22 = 2'h2;
		4'b1000 : wb_adr_int_lsb22 = 2'h3;
		default : wb_adr_int_lsb22 = 2'h0;
	endcase // case(wb_sel_i22)
  `else
	case (wb_sel_is22)
		4'b0001 : wb_adr_int_lsb22 = 2'h3;
		4'b0010 : wb_adr_int_lsb22 = 2'h2;
		4'b0100 : wb_adr_int_lsb22 = 2'h1;
		4'b1000 : wb_adr_int_lsb22 = 2'h0;
		default : wb_adr_int_lsb22 = 2'h0;
	endcase // case(wb_sel_i22)
  `endif
end

assign wb_adr_int22 = {wb_adr_is22[`UART_ADDR_WIDTH22-1:2], wb_adr_int_lsb22};

`endif // !`ifdef DATA_BUS_WIDTH_822

endmodule










