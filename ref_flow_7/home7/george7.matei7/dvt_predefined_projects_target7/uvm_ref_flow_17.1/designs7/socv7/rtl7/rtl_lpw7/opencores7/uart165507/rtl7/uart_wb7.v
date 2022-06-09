//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb7.v                                                   ////
////                                                              ////
////                                                              ////
////  This7 file is part of the "UART7 16550 compatible7" project7    ////
////  http7://www7.opencores7.org7/cores7/uart165507/                   ////
////                                                              ////
////  Documentation7 related7 to this project7:                      ////
////  - http7://www7.opencores7.org7/cores7/uart165507/                 ////
////                                                              ////
////  Projects7 compatibility7:                                     ////
////  - WISHBONE7                                                  ////
////  RS2327 Protocol7                                              ////
////  16550D uart7 (mostly7 supported)                              ////
////                                                              ////
////  Overview7 (main7 Features7):                                   ////
////  UART7 core7 WISHBONE7 interface.                               ////
////                                                              ////
////  Known7 problems7 (limits7):                                    ////
////  Inserts7 one wait state on all transfers7.                    ////
////  Note7 affected7 signals7 and the way7 they are affected7.        ////
////                                                              ////
////  To7 Do7:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author7(s):                                                  ////
////      - gorban7@opencores7.org7                                  ////
////      - Jacob7 Gorban7                                          ////
////      - Igor7 Mohor7 (igorm7@opencores7.org7)                      ////
////                                                              ////
////  Created7:        2001/05/12                                  ////
////  Last7 Updated7:   2001/05/17                                  ////
////                  (See log7 for the revision7 history7)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2000, 2001 Authors7                             ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS7 Revision7 History7
//
// $Log: not supported by cvs2svn7 $
// Revision7 1.16  2002/07/29 21:16:18  gorban7
// The uart_defines7.v file is included7 again7 in sources7.
//
// Revision7 1.15  2002/07/22 23:02:23  gorban7
// Bug7 Fixes7:
//  * Possible7 loss of sync and bad7 reception7 of stop bit on slow7 baud7 rates7 fixed7.
//   Problem7 reported7 by Kenny7.Tung7.
//  * Bad (or lack7 of ) loopback7 handling7 fixed7. Reported7 by Cherry7 Withers7.
//
// Improvements7:
//  * Made7 FIFO's as general7 inferrable7 memory where possible7.
//  So7 on FPGA7 they should be inferred7 as RAM7 (Distributed7 RAM7 on Xilinx7).
//  This7 saves7 about7 1/3 of the Slice7 count and reduces7 P&R and synthesis7 times.
//
//  * Added7 optional7 baudrate7 output (baud_o7).
//  This7 is identical7 to BAUDOUT7* signal7 on 16550 chip7.
//  It outputs7 16xbit_clock_rate - the divided7 clock7.
//  It's disabled by default. Define7 UART_HAS_BAUDRATE_OUTPUT7 to use.
//
// Revision7 1.12  2001/12/19 08:03:34  mohor7
// Warnings7 cleared7.
//
// Revision7 1.11  2001/12/06 14:51:04  gorban7
// Bug7 in LSR7[0] is fixed7.
// All WISHBONE7 signals7 are now sampled7, so another7 wait-state is introduced7 on all transfers7.
//
// Revision7 1.10  2001/12/03 21:44:29  gorban7
// Updated7 specification7 documentation.
// Added7 full 32-bit data bus interface, now as default.
// Address is 5-bit wide7 in 32-bit data bus mode.
// Added7 wb_sel_i7 input to the core7. It's used in the 32-bit mode.
// Added7 debug7 interface with two7 32-bit read-only registers in 32-bit mode.
// Bits7 5 and 6 of LSR7 are now only cleared7 on TX7 FIFO write.
// My7 small test bench7 is modified to work7 with 32-bit mode.
//
// Revision7 1.9  2001/10/20 09:58:40  gorban7
// Small7 synopsis7 fixes7
//
// Revision7 1.8  2001/08/24 21:01:12  mohor7
// Things7 connected7 to parity7 changed.
// Clock7 devider7 changed.
//
// Revision7 1.7  2001/08/23 16:05:05  mohor7
// Stop bit bug7 fixed7.
// Parity7 bug7 fixed7.
// WISHBONE7 read cycle bug7 fixed7,
// OE7 indicator7 (Overrun7 Error) bug7 fixed7.
// PE7 indicator7 (Parity7 Error) bug7 fixed7.
// Register read bug7 fixed7.
//
// Revision7 1.4  2001/05/31 20:08:01  gorban7
// FIFO changes7 and other corrections7.
//
// Revision7 1.3  2001/05/21 19:12:01  gorban7
// Corrected7 some7 Linter7 messages7.
//
// Revision7 1.2  2001/05/17 18:34:18  gorban7
// First7 'stable' release. Should7 be sythesizable7 now. Also7 added new header.
//
// Revision7 1.0  2001-05-17 21:27:13+02  jacob7
// Initial7 revision7
//
//

// UART7 core7 WISHBONE7 interface 
//
// Author7: Jacob7 Gorban7   (jacob7.gorban7@flextronicssemi7.com7)
// Company7: Flextronics7 Semiconductor7
//

// synopsys7 translate_off7
`include "timescale.v"
// synopsys7 translate_on7
`include "uart_defines7.v"
 
module uart_wb7 (clk7, wb_rst_i7, 
	wb_we_i7, wb_stb_i7, wb_cyc_i7, wb_ack_o7, wb_adr_i7,
	wb_adr_int7, wb_dat_i7, wb_dat_o7, wb_dat8_i7, wb_dat8_o7, wb_dat32_o7, wb_sel_i7,
	we_o7, re_o7 // Write and read enable output for the core7
);

input 		  clk7;

// WISHBONE7 interface	
input 		  wb_rst_i7;
input 		  wb_we_i7;
input 		  wb_stb_i7;
input 		  wb_cyc_i7;
input [3:0]   wb_sel_i7;
input [`UART_ADDR_WIDTH7-1:0] 	wb_adr_i7; //WISHBONE7 address line

`ifdef DATA_BUS_WIDTH_87
input [7:0]  wb_dat_i7; //input WISHBONE7 bus 
output [7:0] wb_dat_o7;
reg [7:0] 	 wb_dat_o7;
wire [7:0] 	 wb_dat_i7;
reg [7:0] 	 wb_dat_is7;
`else // for 32 data bus mode
input [31:0]  wb_dat_i7; //input WISHBONE7 bus 
output [31:0] wb_dat_o7;
reg [31:0] 	  wb_dat_o7;
wire [31:0]   wb_dat_i7;
reg [31:0] 	  wb_dat_is7;
`endif // !`ifdef DATA_BUS_WIDTH_87

output [`UART_ADDR_WIDTH7-1:0]	wb_adr_int7; // internal signal7 for address bus
input [7:0]   wb_dat8_o7; // internal 8 bit output to be put into wb_dat_o7
output [7:0]  wb_dat8_i7;
input [31:0]  wb_dat32_o7; // 32 bit data output (for debug7 interface)
output 		  wb_ack_o7;
output 		  we_o7;
output 		  re_o7;

wire 			  we_o7;
reg 			  wb_ack_o7;
reg [7:0] 	  wb_dat8_i7;
wire [7:0] 	  wb_dat8_o7;
wire [`UART_ADDR_WIDTH7-1:0]	wb_adr_int7; // internal signal7 for address bus
reg [`UART_ADDR_WIDTH7-1:0]	wb_adr_is7;
reg 								wb_we_is7;
reg 								wb_cyc_is7;
reg 								wb_stb_is7;
reg [3:0] 						wb_sel_is7;
wire [3:0]   wb_sel_i7;
reg 			 wre7 ;// timing7 control7 signal7 for write or read enable

// wb_ack_o7 FSM7
reg [1:0] 	 wbstate7;
always  @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) begin
		wb_ack_o7 <= #1 1'b0;
		wbstate7 <= #1 0;
		wre7 <= #1 1'b1;
	end else
		case (wbstate7)
			0: begin
				if (wb_stb_is7 & wb_cyc_is7) begin
					wre7 <= #1 0;
					wbstate7 <= #1 1;
					wb_ack_o7 <= #1 1;
				end else begin
					wre7 <= #1 1;
					wb_ack_o7 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o7 <= #1 0;
				wbstate7 <= #1 2;
				wre7 <= #1 0;
			end
			2,3: begin
				wb_ack_o7 <= #1 0;
				wbstate7 <= #1 0;
				wre7 <= #1 0;
			end
		endcase

assign we_o7 =  wb_we_is7 & wb_stb_is7 & wb_cyc_is7 & wre7 ; //WE7 for registers	
assign re_o7 = ~wb_we_is7 & wb_stb_is7 & wb_cyc_is7 & wre7 ; //RE7 for registers	

// Sample7 input signals7
always  @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7) begin
		wb_adr_is7 <= #1 0;
		wb_we_is7 <= #1 0;
		wb_cyc_is7 <= #1 0;
		wb_stb_is7 <= #1 0;
		wb_dat_is7 <= #1 0;
		wb_sel_is7 <= #1 0;
	end else begin
		wb_adr_is7 <= #1 wb_adr_i7;
		wb_we_is7 <= #1 wb_we_i7;
		wb_cyc_is7 <= #1 wb_cyc_i7;
		wb_stb_is7 <= #1 wb_stb_i7;
		wb_dat_is7 <= #1 wb_dat_i7;
		wb_sel_is7 <= #1 wb_sel_i7;
	end

`ifdef DATA_BUS_WIDTH_87 // 8-bit data bus
always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7)
		wb_dat_o7 <= #1 0;
	else
		wb_dat_o7 <= #1 wb_dat8_o7;

always @(wb_dat_is7)
	wb_dat8_i7 = wb_dat_is7;

assign wb_adr_int7 = wb_adr_is7;

`else // 32-bit bus
// put output to the correct7 byte in 32 bits using select7 line
always @(posedge clk7 or posedge wb_rst_i7)
	if (wb_rst_i7)
		wb_dat_o7 <= #1 0;
	else if (re_o7)
		case (wb_sel_is7)
			4'b0001: wb_dat_o7 <= #1 {24'b0, wb_dat8_o7};
			4'b0010: wb_dat_o7 <= #1 {16'b0, wb_dat8_o7, 8'b0};
			4'b0100: wb_dat_o7 <= #1 {8'b0, wb_dat8_o7, 16'b0};
			4'b1000: wb_dat_o7 <= #1 {wb_dat8_o7, 24'b0};
			4'b1111: wb_dat_o7 <= #1 wb_dat32_o7; // debug7 interface output
 			default: wb_dat_o7 <= #1 0;
		endcase // case(wb_sel_i7)

reg [1:0] wb_adr_int_lsb7;

always @(wb_sel_is7 or wb_dat_is7)
begin
	case (wb_sel_is7)
		4'b0001 : wb_dat8_i7 = wb_dat_is7[7:0];
		4'b0010 : wb_dat8_i7 = wb_dat_is7[15:8];
		4'b0100 : wb_dat8_i7 = wb_dat_is7[23:16];
		4'b1000 : wb_dat8_i7 = wb_dat_is7[31:24];
		default : wb_dat8_i7 = wb_dat_is7[7:0];
	endcase // case(wb_sel_i7)

  `ifdef LITLE_ENDIAN7
	case (wb_sel_is7)
		4'b0001 : wb_adr_int_lsb7 = 2'h0;
		4'b0010 : wb_adr_int_lsb7 = 2'h1;
		4'b0100 : wb_adr_int_lsb7 = 2'h2;
		4'b1000 : wb_adr_int_lsb7 = 2'h3;
		default : wb_adr_int_lsb7 = 2'h0;
	endcase // case(wb_sel_i7)
  `else
	case (wb_sel_is7)
		4'b0001 : wb_adr_int_lsb7 = 2'h3;
		4'b0010 : wb_adr_int_lsb7 = 2'h2;
		4'b0100 : wb_adr_int_lsb7 = 2'h1;
		4'b1000 : wb_adr_int_lsb7 = 2'h0;
		default : wb_adr_int_lsb7 = 2'h0;
	endcase // case(wb_sel_i7)
  `endif
end

assign wb_adr_int7 = {wb_adr_is7[`UART_ADDR_WIDTH7-1:2], wb_adr_int_lsb7};

`endif // !`ifdef DATA_BUS_WIDTH_87

endmodule










