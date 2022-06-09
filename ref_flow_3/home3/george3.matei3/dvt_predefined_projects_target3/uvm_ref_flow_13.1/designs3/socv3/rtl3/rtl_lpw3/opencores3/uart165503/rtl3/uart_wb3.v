//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb3.v                                                   ////
////                                                              ////
////                                                              ////
////  This3 file is part of the "UART3 16550 compatible3" project3    ////
////  http3://www3.opencores3.org3/cores3/uart165503/                   ////
////                                                              ////
////  Documentation3 related3 to this project3:                      ////
////  - http3://www3.opencores3.org3/cores3/uart165503/                 ////
////                                                              ////
////  Projects3 compatibility3:                                     ////
////  - WISHBONE3                                                  ////
////  RS2323 Protocol3                                              ////
////  16550D uart3 (mostly3 supported)                              ////
////                                                              ////
////  Overview3 (main3 Features3):                                   ////
////  UART3 core3 WISHBONE3 interface.                               ////
////                                                              ////
////  Known3 problems3 (limits3):                                    ////
////  Inserts3 one wait state on all transfers3.                    ////
////  Note3 affected3 signals3 and the way3 they are affected3.        ////
////                                                              ////
////  To3 Do3:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author3(s):                                                  ////
////      - gorban3@opencores3.org3                                  ////
////      - Jacob3 Gorban3                                          ////
////      - Igor3 Mohor3 (igorm3@opencores3.org3)                      ////
////                                                              ////
////  Created3:        2001/05/12                                  ////
////  Last3 Updated3:   2001/05/17                                  ////
////                  (See log3 for the revision3 history3)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2000, 2001 Authors3                             ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS3 Revision3 History3
//
// $Log: not supported by cvs2svn3 $
// Revision3 1.16  2002/07/29 21:16:18  gorban3
// The uart_defines3.v file is included3 again3 in sources3.
//
// Revision3 1.15  2002/07/22 23:02:23  gorban3
// Bug3 Fixes3:
//  * Possible3 loss of sync and bad3 reception3 of stop bit on slow3 baud3 rates3 fixed3.
//   Problem3 reported3 by Kenny3.Tung3.
//  * Bad (or lack3 of ) loopback3 handling3 fixed3. Reported3 by Cherry3 Withers3.
//
// Improvements3:
//  * Made3 FIFO's as general3 inferrable3 memory where possible3.
//  So3 on FPGA3 they should be inferred3 as RAM3 (Distributed3 RAM3 on Xilinx3).
//  This3 saves3 about3 1/3 of the Slice3 count and reduces3 P&R and synthesis3 times.
//
//  * Added3 optional3 baudrate3 output (baud_o3).
//  This3 is identical3 to BAUDOUT3* signal3 on 16550 chip3.
//  It outputs3 16xbit_clock_rate - the divided3 clock3.
//  It's disabled by default. Define3 UART_HAS_BAUDRATE_OUTPUT3 to use.
//
// Revision3 1.12  2001/12/19 08:03:34  mohor3
// Warnings3 cleared3.
//
// Revision3 1.11  2001/12/06 14:51:04  gorban3
// Bug3 in LSR3[0] is fixed3.
// All WISHBONE3 signals3 are now sampled3, so another3 wait-state is introduced3 on all transfers3.
//
// Revision3 1.10  2001/12/03 21:44:29  gorban3
// Updated3 specification3 documentation.
// Added3 full 32-bit data bus interface, now as default.
// Address is 5-bit wide3 in 32-bit data bus mode.
// Added3 wb_sel_i3 input to the core3. It's used in the 32-bit mode.
// Added3 debug3 interface with two3 32-bit read-only registers in 32-bit mode.
// Bits3 5 and 6 of LSR3 are now only cleared3 on TX3 FIFO write.
// My3 small test bench3 is modified to work3 with 32-bit mode.
//
// Revision3 1.9  2001/10/20 09:58:40  gorban3
// Small3 synopsis3 fixes3
//
// Revision3 1.8  2001/08/24 21:01:12  mohor3
// Things3 connected3 to parity3 changed.
// Clock3 devider3 changed.
//
// Revision3 1.7  2001/08/23 16:05:05  mohor3
// Stop bit bug3 fixed3.
// Parity3 bug3 fixed3.
// WISHBONE3 read cycle bug3 fixed3,
// OE3 indicator3 (Overrun3 Error) bug3 fixed3.
// PE3 indicator3 (Parity3 Error) bug3 fixed3.
// Register read bug3 fixed3.
//
// Revision3 1.4  2001/05/31 20:08:01  gorban3
// FIFO changes3 and other corrections3.
//
// Revision3 1.3  2001/05/21 19:12:01  gorban3
// Corrected3 some3 Linter3 messages3.
//
// Revision3 1.2  2001/05/17 18:34:18  gorban3
// First3 'stable' release. Should3 be sythesizable3 now. Also3 added new header.
//
// Revision3 1.0  2001-05-17 21:27:13+02  jacob3
// Initial3 revision3
//
//

// UART3 core3 WISHBONE3 interface 
//
// Author3: Jacob3 Gorban3   (jacob3.gorban3@flextronicssemi3.com3)
// Company3: Flextronics3 Semiconductor3
//

// synopsys3 translate_off3
`include "timescale.v"
// synopsys3 translate_on3
`include "uart_defines3.v"
 
module uart_wb3 (clk3, wb_rst_i3, 
	wb_we_i3, wb_stb_i3, wb_cyc_i3, wb_ack_o3, wb_adr_i3,
	wb_adr_int3, wb_dat_i3, wb_dat_o3, wb_dat8_i3, wb_dat8_o3, wb_dat32_o3, wb_sel_i3,
	we_o3, re_o3 // Write and read enable output for the core3
);

input 		  clk3;

// WISHBONE3 interface	
input 		  wb_rst_i3;
input 		  wb_we_i3;
input 		  wb_stb_i3;
input 		  wb_cyc_i3;
input [3:0]   wb_sel_i3;
input [`UART_ADDR_WIDTH3-1:0] 	wb_adr_i3; //WISHBONE3 address line

`ifdef DATA_BUS_WIDTH_83
input [7:0]  wb_dat_i3; //input WISHBONE3 bus 
output [7:0] wb_dat_o3;
reg [7:0] 	 wb_dat_o3;
wire [7:0] 	 wb_dat_i3;
reg [7:0] 	 wb_dat_is3;
`else // for 32 data bus mode
input [31:0]  wb_dat_i3; //input WISHBONE3 bus 
output [31:0] wb_dat_o3;
reg [31:0] 	  wb_dat_o3;
wire [31:0]   wb_dat_i3;
reg [31:0] 	  wb_dat_is3;
`endif // !`ifdef DATA_BUS_WIDTH_83

output [`UART_ADDR_WIDTH3-1:0]	wb_adr_int3; // internal signal3 for address bus
input [7:0]   wb_dat8_o3; // internal 8 bit output to be put into wb_dat_o3
output [7:0]  wb_dat8_i3;
input [31:0]  wb_dat32_o3; // 32 bit data output (for debug3 interface)
output 		  wb_ack_o3;
output 		  we_o3;
output 		  re_o3;

wire 			  we_o3;
reg 			  wb_ack_o3;
reg [7:0] 	  wb_dat8_i3;
wire [7:0] 	  wb_dat8_o3;
wire [`UART_ADDR_WIDTH3-1:0]	wb_adr_int3; // internal signal3 for address bus
reg [`UART_ADDR_WIDTH3-1:0]	wb_adr_is3;
reg 								wb_we_is3;
reg 								wb_cyc_is3;
reg 								wb_stb_is3;
reg [3:0] 						wb_sel_is3;
wire [3:0]   wb_sel_i3;
reg 			 wre3 ;// timing3 control3 signal3 for write or read enable

// wb_ack_o3 FSM3
reg [1:0] 	 wbstate3;
always  @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) begin
		wb_ack_o3 <= #1 1'b0;
		wbstate3 <= #1 0;
		wre3 <= #1 1'b1;
	end else
		case (wbstate3)
			0: begin
				if (wb_stb_is3 & wb_cyc_is3) begin
					wre3 <= #1 0;
					wbstate3 <= #1 1;
					wb_ack_o3 <= #1 1;
				end else begin
					wre3 <= #1 1;
					wb_ack_o3 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o3 <= #1 0;
				wbstate3 <= #1 2;
				wre3 <= #1 0;
			end
			2,3: begin
				wb_ack_o3 <= #1 0;
				wbstate3 <= #1 0;
				wre3 <= #1 0;
			end
		endcase

assign we_o3 =  wb_we_is3 & wb_stb_is3 & wb_cyc_is3 & wre3 ; //WE3 for registers	
assign re_o3 = ~wb_we_is3 & wb_stb_is3 & wb_cyc_is3 & wre3 ; //RE3 for registers	

// Sample3 input signals3
always  @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3) begin
		wb_adr_is3 <= #1 0;
		wb_we_is3 <= #1 0;
		wb_cyc_is3 <= #1 0;
		wb_stb_is3 <= #1 0;
		wb_dat_is3 <= #1 0;
		wb_sel_is3 <= #1 0;
	end else begin
		wb_adr_is3 <= #1 wb_adr_i3;
		wb_we_is3 <= #1 wb_we_i3;
		wb_cyc_is3 <= #1 wb_cyc_i3;
		wb_stb_is3 <= #1 wb_stb_i3;
		wb_dat_is3 <= #1 wb_dat_i3;
		wb_sel_is3 <= #1 wb_sel_i3;
	end

`ifdef DATA_BUS_WIDTH_83 // 8-bit data bus
always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3)
		wb_dat_o3 <= #1 0;
	else
		wb_dat_o3 <= #1 wb_dat8_o3;

always @(wb_dat_is3)
	wb_dat8_i3 = wb_dat_is3;

assign wb_adr_int3 = wb_adr_is3;

`else // 32-bit bus
// put output to the correct3 byte in 32 bits using select3 line
always @(posedge clk3 or posedge wb_rst_i3)
	if (wb_rst_i3)
		wb_dat_o3 <= #1 0;
	else if (re_o3)
		case (wb_sel_is3)
			4'b0001: wb_dat_o3 <= #1 {24'b0, wb_dat8_o3};
			4'b0010: wb_dat_o3 <= #1 {16'b0, wb_dat8_o3, 8'b0};
			4'b0100: wb_dat_o3 <= #1 {8'b0, wb_dat8_o3, 16'b0};
			4'b1000: wb_dat_o3 <= #1 {wb_dat8_o3, 24'b0};
			4'b1111: wb_dat_o3 <= #1 wb_dat32_o3; // debug3 interface output
 			default: wb_dat_o3 <= #1 0;
		endcase // case(wb_sel_i3)

reg [1:0] wb_adr_int_lsb3;

always @(wb_sel_is3 or wb_dat_is3)
begin
	case (wb_sel_is3)
		4'b0001 : wb_dat8_i3 = wb_dat_is3[7:0];
		4'b0010 : wb_dat8_i3 = wb_dat_is3[15:8];
		4'b0100 : wb_dat8_i3 = wb_dat_is3[23:16];
		4'b1000 : wb_dat8_i3 = wb_dat_is3[31:24];
		default : wb_dat8_i3 = wb_dat_is3[7:0];
	endcase // case(wb_sel_i3)

  `ifdef LITLE_ENDIAN3
	case (wb_sel_is3)
		4'b0001 : wb_adr_int_lsb3 = 2'h0;
		4'b0010 : wb_adr_int_lsb3 = 2'h1;
		4'b0100 : wb_adr_int_lsb3 = 2'h2;
		4'b1000 : wb_adr_int_lsb3 = 2'h3;
		default : wb_adr_int_lsb3 = 2'h0;
	endcase // case(wb_sel_i3)
  `else
	case (wb_sel_is3)
		4'b0001 : wb_adr_int_lsb3 = 2'h3;
		4'b0010 : wb_adr_int_lsb3 = 2'h2;
		4'b0100 : wb_adr_int_lsb3 = 2'h1;
		4'b1000 : wb_adr_int_lsb3 = 2'h0;
		default : wb_adr_int_lsb3 = 2'h0;
	endcase // case(wb_sel_i3)
  `endif
end

assign wb_adr_int3 = {wb_adr_is3[`UART_ADDR_WIDTH3-1:2], wb_adr_int_lsb3};

`endif // !`ifdef DATA_BUS_WIDTH_83

endmodule










