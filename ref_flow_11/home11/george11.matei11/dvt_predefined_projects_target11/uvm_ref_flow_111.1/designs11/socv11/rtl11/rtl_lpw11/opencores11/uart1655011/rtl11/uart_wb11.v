//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb11.v                                                   ////
////                                                              ////
////                                                              ////
////  This11 file is part of the "UART11 16550 compatible11" project11    ////
////  http11://www11.opencores11.org11/cores11/uart1655011/                   ////
////                                                              ////
////  Documentation11 related11 to this project11:                      ////
////  - http11://www11.opencores11.org11/cores11/uart1655011/                 ////
////                                                              ////
////  Projects11 compatibility11:                                     ////
////  - WISHBONE11                                                  ////
////  RS23211 Protocol11                                              ////
////  16550D uart11 (mostly11 supported)                              ////
////                                                              ////
////  Overview11 (main11 Features11):                                   ////
////  UART11 core11 WISHBONE11 interface.                               ////
////                                                              ////
////  Known11 problems11 (limits11):                                    ////
////  Inserts11 one wait state on all transfers11.                    ////
////  Note11 affected11 signals11 and the way11 they are affected11.        ////
////                                                              ////
////  To11 Do11:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author11(s):                                                  ////
////      - gorban11@opencores11.org11                                  ////
////      - Jacob11 Gorban11                                          ////
////      - Igor11 Mohor11 (igorm11@opencores11.org11)                      ////
////                                                              ////
////  Created11:        2001/05/12                                  ////
////  Last11 Updated11:   2001/05/17                                  ////
////                  (See log11 for the revision11 history11)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2000, 2001 Authors11                             ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS11 Revision11 History11
//
// $Log: not supported by cvs2svn11 $
// Revision11 1.16  2002/07/29 21:16:18  gorban11
// The uart_defines11.v file is included11 again11 in sources11.
//
// Revision11 1.15  2002/07/22 23:02:23  gorban11
// Bug11 Fixes11:
//  * Possible11 loss of sync and bad11 reception11 of stop bit on slow11 baud11 rates11 fixed11.
//   Problem11 reported11 by Kenny11.Tung11.
//  * Bad (or lack11 of ) loopback11 handling11 fixed11. Reported11 by Cherry11 Withers11.
//
// Improvements11:
//  * Made11 FIFO's as general11 inferrable11 memory where possible11.
//  So11 on FPGA11 they should be inferred11 as RAM11 (Distributed11 RAM11 on Xilinx11).
//  This11 saves11 about11 1/3 of the Slice11 count and reduces11 P&R and synthesis11 times.
//
//  * Added11 optional11 baudrate11 output (baud_o11).
//  This11 is identical11 to BAUDOUT11* signal11 on 16550 chip11.
//  It outputs11 16xbit_clock_rate - the divided11 clock11.
//  It's disabled by default. Define11 UART_HAS_BAUDRATE_OUTPUT11 to use.
//
// Revision11 1.12  2001/12/19 08:03:34  mohor11
// Warnings11 cleared11.
//
// Revision11 1.11  2001/12/06 14:51:04  gorban11
// Bug11 in LSR11[0] is fixed11.
// All WISHBONE11 signals11 are now sampled11, so another11 wait-state is introduced11 on all transfers11.
//
// Revision11 1.10  2001/12/03 21:44:29  gorban11
// Updated11 specification11 documentation.
// Added11 full 32-bit data bus interface, now as default.
// Address is 5-bit wide11 in 32-bit data bus mode.
// Added11 wb_sel_i11 input to the core11. It's used in the 32-bit mode.
// Added11 debug11 interface with two11 32-bit read-only registers in 32-bit mode.
// Bits11 5 and 6 of LSR11 are now only cleared11 on TX11 FIFO write.
// My11 small test bench11 is modified to work11 with 32-bit mode.
//
// Revision11 1.9  2001/10/20 09:58:40  gorban11
// Small11 synopsis11 fixes11
//
// Revision11 1.8  2001/08/24 21:01:12  mohor11
// Things11 connected11 to parity11 changed.
// Clock11 devider11 changed.
//
// Revision11 1.7  2001/08/23 16:05:05  mohor11
// Stop bit bug11 fixed11.
// Parity11 bug11 fixed11.
// WISHBONE11 read cycle bug11 fixed11,
// OE11 indicator11 (Overrun11 Error) bug11 fixed11.
// PE11 indicator11 (Parity11 Error) bug11 fixed11.
// Register read bug11 fixed11.
//
// Revision11 1.4  2001/05/31 20:08:01  gorban11
// FIFO changes11 and other corrections11.
//
// Revision11 1.3  2001/05/21 19:12:01  gorban11
// Corrected11 some11 Linter11 messages11.
//
// Revision11 1.2  2001/05/17 18:34:18  gorban11
// First11 'stable' release. Should11 be sythesizable11 now. Also11 added new header.
//
// Revision11 1.0  2001-05-17 21:27:13+02  jacob11
// Initial11 revision11
//
//

// UART11 core11 WISHBONE11 interface 
//
// Author11: Jacob11 Gorban11   (jacob11.gorban11@flextronicssemi11.com11)
// Company11: Flextronics11 Semiconductor11
//

// synopsys11 translate_off11
`include "timescale.v"
// synopsys11 translate_on11
`include "uart_defines11.v"
 
module uart_wb11 (clk11, wb_rst_i11, 
	wb_we_i11, wb_stb_i11, wb_cyc_i11, wb_ack_o11, wb_adr_i11,
	wb_adr_int11, wb_dat_i11, wb_dat_o11, wb_dat8_i11, wb_dat8_o11, wb_dat32_o11, wb_sel_i11,
	we_o11, re_o11 // Write and read enable output for the core11
);

input 		  clk11;

// WISHBONE11 interface	
input 		  wb_rst_i11;
input 		  wb_we_i11;
input 		  wb_stb_i11;
input 		  wb_cyc_i11;
input [3:0]   wb_sel_i11;
input [`UART_ADDR_WIDTH11-1:0] 	wb_adr_i11; //WISHBONE11 address line

`ifdef DATA_BUS_WIDTH_811
input [7:0]  wb_dat_i11; //input WISHBONE11 bus 
output [7:0] wb_dat_o11;
reg [7:0] 	 wb_dat_o11;
wire [7:0] 	 wb_dat_i11;
reg [7:0] 	 wb_dat_is11;
`else // for 32 data bus mode
input [31:0]  wb_dat_i11; //input WISHBONE11 bus 
output [31:0] wb_dat_o11;
reg [31:0] 	  wb_dat_o11;
wire [31:0]   wb_dat_i11;
reg [31:0] 	  wb_dat_is11;
`endif // !`ifdef DATA_BUS_WIDTH_811

output [`UART_ADDR_WIDTH11-1:0]	wb_adr_int11; // internal signal11 for address bus
input [7:0]   wb_dat8_o11; // internal 8 bit output to be put into wb_dat_o11
output [7:0]  wb_dat8_i11;
input [31:0]  wb_dat32_o11; // 32 bit data output (for debug11 interface)
output 		  wb_ack_o11;
output 		  we_o11;
output 		  re_o11;

wire 			  we_o11;
reg 			  wb_ack_o11;
reg [7:0] 	  wb_dat8_i11;
wire [7:0] 	  wb_dat8_o11;
wire [`UART_ADDR_WIDTH11-1:0]	wb_adr_int11; // internal signal11 for address bus
reg [`UART_ADDR_WIDTH11-1:0]	wb_adr_is11;
reg 								wb_we_is11;
reg 								wb_cyc_is11;
reg 								wb_stb_is11;
reg [3:0] 						wb_sel_is11;
wire [3:0]   wb_sel_i11;
reg 			 wre11 ;// timing11 control11 signal11 for write or read enable

// wb_ack_o11 FSM11
reg [1:0] 	 wbstate11;
always  @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) begin
		wb_ack_o11 <= #1 1'b0;
		wbstate11 <= #1 0;
		wre11 <= #1 1'b1;
	end else
		case (wbstate11)
			0: begin
				if (wb_stb_is11 & wb_cyc_is11) begin
					wre11 <= #1 0;
					wbstate11 <= #1 1;
					wb_ack_o11 <= #1 1;
				end else begin
					wre11 <= #1 1;
					wb_ack_o11 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o11 <= #1 0;
				wbstate11 <= #1 2;
				wre11 <= #1 0;
			end
			2,3: begin
				wb_ack_o11 <= #1 0;
				wbstate11 <= #1 0;
				wre11 <= #1 0;
			end
		endcase

assign we_o11 =  wb_we_is11 & wb_stb_is11 & wb_cyc_is11 & wre11 ; //WE11 for registers	
assign re_o11 = ~wb_we_is11 & wb_stb_is11 & wb_cyc_is11 & wre11 ; //RE11 for registers	

// Sample11 input signals11
always  @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11) begin
		wb_adr_is11 <= #1 0;
		wb_we_is11 <= #1 0;
		wb_cyc_is11 <= #1 0;
		wb_stb_is11 <= #1 0;
		wb_dat_is11 <= #1 0;
		wb_sel_is11 <= #1 0;
	end else begin
		wb_adr_is11 <= #1 wb_adr_i11;
		wb_we_is11 <= #1 wb_we_i11;
		wb_cyc_is11 <= #1 wb_cyc_i11;
		wb_stb_is11 <= #1 wb_stb_i11;
		wb_dat_is11 <= #1 wb_dat_i11;
		wb_sel_is11 <= #1 wb_sel_i11;
	end

`ifdef DATA_BUS_WIDTH_811 // 8-bit data bus
always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11)
		wb_dat_o11 <= #1 0;
	else
		wb_dat_o11 <= #1 wb_dat8_o11;

always @(wb_dat_is11)
	wb_dat8_i11 = wb_dat_is11;

assign wb_adr_int11 = wb_adr_is11;

`else // 32-bit bus
// put output to the correct11 byte in 32 bits using select11 line
always @(posedge clk11 or posedge wb_rst_i11)
	if (wb_rst_i11)
		wb_dat_o11 <= #1 0;
	else if (re_o11)
		case (wb_sel_is11)
			4'b0001: wb_dat_o11 <= #1 {24'b0, wb_dat8_o11};
			4'b0010: wb_dat_o11 <= #1 {16'b0, wb_dat8_o11, 8'b0};
			4'b0100: wb_dat_o11 <= #1 {8'b0, wb_dat8_o11, 16'b0};
			4'b1000: wb_dat_o11 <= #1 {wb_dat8_o11, 24'b0};
			4'b1111: wb_dat_o11 <= #1 wb_dat32_o11; // debug11 interface output
 			default: wb_dat_o11 <= #1 0;
		endcase // case(wb_sel_i11)

reg [1:0] wb_adr_int_lsb11;

always @(wb_sel_is11 or wb_dat_is11)
begin
	case (wb_sel_is11)
		4'b0001 : wb_dat8_i11 = wb_dat_is11[7:0];
		4'b0010 : wb_dat8_i11 = wb_dat_is11[15:8];
		4'b0100 : wb_dat8_i11 = wb_dat_is11[23:16];
		4'b1000 : wb_dat8_i11 = wb_dat_is11[31:24];
		default : wb_dat8_i11 = wb_dat_is11[7:0];
	endcase // case(wb_sel_i11)

  `ifdef LITLE_ENDIAN11
	case (wb_sel_is11)
		4'b0001 : wb_adr_int_lsb11 = 2'h0;
		4'b0010 : wb_adr_int_lsb11 = 2'h1;
		4'b0100 : wb_adr_int_lsb11 = 2'h2;
		4'b1000 : wb_adr_int_lsb11 = 2'h3;
		default : wb_adr_int_lsb11 = 2'h0;
	endcase // case(wb_sel_i11)
  `else
	case (wb_sel_is11)
		4'b0001 : wb_adr_int_lsb11 = 2'h3;
		4'b0010 : wb_adr_int_lsb11 = 2'h2;
		4'b0100 : wb_adr_int_lsb11 = 2'h1;
		4'b1000 : wb_adr_int_lsb11 = 2'h0;
		default : wb_adr_int_lsb11 = 2'h0;
	endcase // case(wb_sel_i11)
  `endif
end

assign wb_adr_int11 = {wb_adr_is11[`UART_ADDR_WIDTH11-1:2], wb_adr_int_lsb11};

`endif // !`ifdef DATA_BUS_WIDTH_811

endmodule










