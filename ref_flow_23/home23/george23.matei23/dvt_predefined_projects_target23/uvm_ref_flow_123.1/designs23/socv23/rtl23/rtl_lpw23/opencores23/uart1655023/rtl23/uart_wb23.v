//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb23.v                                                   ////
////                                                              ////
////                                                              ////
////  This23 file is part of the "UART23 16550 compatible23" project23    ////
////  http23://www23.opencores23.org23/cores23/uart1655023/                   ////
////                                                              ////
////  Documentation23 related23 to this project23:                      ////
////  - http23://www23.opencores23.org23/cores23/uart1655023/                 ////
////                                                              ////
////  Projects23 compatibility23:                                     ////
////  - WISHBONE23                                                  ////
////  RS23223 Protocol23                                              ////
////  16550D uart23 (mostly23 supported)                              ////
////                                                              ////
////  Overview23 (main23 Features23):                                   ////
////  UART23 core23 WISHBONE23 interface.                               ////
////                                                              ////
////  Known23 problems23 (limits23):                                    ////
////  Inserts23 one wait state on all transfers23.                    ////
////  Note23 affected23 signals23 and the way23 they are affected23.        ////
////                                                              ////
////  To23 Do23:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author23(s):                                                  ////
////      - gorban23@opencores23.org23                                  ////
////      - Jacob23 Gorban23                                          ////
////      - Igor23 Mohor23 (igorm23@opencores23.org23)                      ////
////                                                              ////
////  Created23:        2001/05/12                                  ////
////  Last23 Updated23:   2001/05/17                                  ////
////                  (See log23 for the revision23 history23)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2000, 2001 Authors23                             ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS23 Revision23 History23
//
// $Log: not supported by cvs2svn23 $
// Revision23 1.16  2002/07/29 21:16:18  gorban23
// The uart_defines23.v file is included23 again23 in sources23.
//
// Revision23 1.15  2002/07/22 23:02:23  gorban23
// Bug23 Fixes23:
//  * Possible23 loss of sync and bad23 reception23 of stop bit on slow23 baud23 rates23 fixed23.
//   Problem23 reported23 by Kenny23.Tung23.
//  * Bad (or lack23 of ) loopback23 handling23 fixed23. Reported23 by Cherry23 Withers23.
//
// Improvements23:
//  * Made23 FIFO's as general23 inferrable23 memory where possible23.
//  So23 on FPGA23 they should be inferred23 as RAM23 (Distributed23 RAM23 on Xilinx23).
//  This23 saves23 about23 1/3 of the Slice23 count and reduces23 P&R and synthesis23 times.
//
//  * Added23 optional23 baudrate23 output (baud_o23).
//  This23 is identical23 to BAUDOUT23* signal23 on 16550 chip23.
//  It outputs23 16xbit_clock_rate - the divided23 clock23.
//  It's disabled by default. Define23 UART_HAS_BAUDRATE_OUTPUT23 to use.
//
// Revision23 1.12  2001/12/19 08:03:34  mohor23
// Warnings23 cleared23.
//
// Revision23 1.11  2001/12/06 14:51:04  gorban23
// Bug23 in LSR23[0] is fixed23.
// All WISHBONE23 signals23 are now sampled23, so another23 wait-state is introduced23 on all transfers23.
//
// Revision23 1.10  2001/12/03 21:44:29  gorban23
// Updated23 specification23 documentation.
// Added23 full 32-bit data bus interface, now as default.
// Address is 5-bit wide23 in 32-bit data bus mode.
// Added23 wb_sel_i23 input to the core23. It's used in the 32-bit mode.
// Added23 debug23 interface with two23 32-bit read-only registers in 32-bit mode.
// Bits23 5 and 6 of LSR23 are now only cleared23 on TX23 FIFO write.
// My23 small test bench23 is modified to work23 with 32-bit mode.
//
// Revision23 1.9  2001/10/20 09:58:40  gorban23
// Small23 synopsis23 fixes23
//
// Revision23 1.8  2001/08/24 21:01:12  mohor23
// Things23 connected23 to parity23 changed.
// Clock23 devider23 changed.
//
// Revision23 1.7  2001/08/23 16:05:05  mohor23
// Stop bit bug23 fixed23.
// Parity23 bug23 fixed23.
// WISHBONE23 read cycle bug23 fixed23,
// OE23 indicator23 (Overrun23 Error) bug23 fixed23.
// PE23 indicator23 (Parity23 Error) bug23 fixed23.
// Register read bug23 fixed23.
//
// Revision23 1.4  2001/05/31 20:08:01  gorban23
// FIFO changes23 and other corrections23.
//
// Revision23 1.3  2001/05/21 19:12:01  gorban23
// Corrected23 some23 Linter23 messages23.
//
// Revision23 1.2  2001/05/17 18:34:18  gorban23
// First23 'stable' release. Should23 be sythesizable23 now. Also23 added new header.
//
// Revision23 1.0  2001-05-17 21:27:13+02  jacob23
// Initial23 revision23
//
//

// UART23 core23 WISHBONE23 interface 
//
// Author23: Jacob23 Gorban23   (jacob23.gorban23@flextronicssemi23.com23)
// Company23: Flextronics23 Semiconductor23
//

// synopsys23 translate_off23
`include "timescale.v"
// synopsys23 translate_on23
`include "uart_defines23.v"
 
module uart_wb23 (clk23, wb_rst_i23, 
	wb_we_i23, wb_stb_i23, wb_cyc_i23, wb_ack_o23, wb_adr_i23,
	wb_adr_int23, wb_dat_i23, wb_dat_o23, wb_dat8_i23, wb_dat8_o23, wb_dat32_o23, wb_sel_i23,
	we_o23, re_o23 // Write and read enable output for the core23
);

input 		  clk23;

// WISHBONE23 interface	
input 		  wb_rst_i23;
input 		  wb_we_i23;
input 		  wb_stb_i23;
input 		  wb_cyc_i23;
input [3:0]   wb_sel_i23;
input [`UART_ADDR_WIDTH23-1:0] 	wb_adr_i23; //WISHBONE23 address line

`ifdef DATA_BUS_WIDTH_823
input [7:0]  wb_dat_i23; //input WISHBONE23 bus 
output [7:0] wb_dat_o23;
reg [7:0] 	 wb_dat_o23;
wire [7:0] 	 wb_dat_i23;
reg [7:0] 	 wb_dat_is23;
`else // for 32 data bus mode
input [31:0]  wb_dat_i23; //input WISHBONE23 bus 
output [31:0] wb_dat_o23;
reg [31:0] 	  wb_dat_o23;
wire [31:0]   wb_dat_i23;
reg [31:0] 	  wb_dat_is23;
`endif // !`ifdef DATA_BUS_WIDTH_823

output [`UART_ADDR_WIDTH23-1:0]	wb_adr_int23; // internal signal23 for address bus
input [7:0]   wb_dat8_o23; // internal 8 bit output to be put into wb_dat_o23
output [7:0]  wb_dat8_i23;
input [31:0]  wb_dat32_o23; // 32 bit data output (for debug23 interface)
output 		  wb_ack_o23;
output 		  we_o23;
output 		  re_o23;

wire 			  we_o23;
reg 			  wb_ack_o23;
reg [7:0] 	  wb_dat8_i23;
wire [7:0] 	  wb_dat8_o23;
wire [`UART_ADDR_WIDTH23-1:0]	wb_adr_int23; // internal signal23 for address bus
reg [`UART_ADDR_WIDTH23-1:0]	wb_adr_is23;
reg 								wb_we_is23;
reg 								wb_cyc_is23;
reg 								wb_stb_is23;
reg [3:0] 						wb_sel_is23;
wire [3:0]   wb_sel_i23;
reg 			 wre23 ;// timing23 control23 signal23 for write or read enable

// wb_ack_o23 FSM23
reg [1:0] 	 wbstate23;
always  @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) begin
		wb_ack_o23 <= #1 1'b0;
		wbstate23 <= #1 0;
		wre23 <= #1 1'b1;
	end else
		case (wbstate23)
			0: begin
				if (wb_stb_is23 & wb_cyc_is23) begin
					wre23 <= #1 0;
					wbstate23 <= #1 1;
					wb_ack_o23 <= #1 1;
				end else begin
					wre23 <= #1 1;
					wb_ack_o23 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o23 <= #1 0;
				wbstate23 <= #1 2;
				wre23 <= #1 0;
			end
			2,3: begin
				wb_ack_o23 <= #1 0;
				wbstate23 <= #1 0;
				wre23 <= #1 0;
			end
		endcase

assign we_o23 =  wb_we_is23 & wb_stb_is23 & wb_cyc_is23 & wre23 ; //WE23 for registers	
assign re_o23 = ~wb_we_is23 & wb_stb_is23 & wb_cyc_is23 & wre23 ; //RE23 for registers	

// Sample23 input signals23
always  @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23) begin
		wb_adr_is23 <= #1 0;
		wb_we_is23 <= #1 0;
		wb_cyc_is23 <= #1 0;
		wb_stb_is23 <= #1 0;
		wb_dat_is23 <= #1 0;
		wb_sel_is23 <= #1 0;
	end else begin
		wb_adr_is23 <= #1 wb_adr_i23;
		wb_we_is23 <= #1 wb_we_i23;
		wb_cyc_is23 <= #1 wb_cyc_i23;
		wb_stb_is23 <= #1 wb_stb_i23;
		wb_dat_is23 <= #1 wb_dat_i23;
		wb_sel_is23 <= #1 wb_sel_i23;
	end

`ifdef DATA_BUS_WIDTH_823 // 8-bit data bus
always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23)
		wb_dat_o23 <= #1 0;
	else
		wb_dat_o23 <= #1 wb_dat8_o23;

always @(wb_dat_is23)
	wb_dat8_i23 = wb_dat_is23;

assign wb_adr_int23 = wb_adr_is23;

`else // 32-bit bus
// put output to the correct23 byte in 32 bits using select23 line
always @(posedge clk23 or posedge wb_rst_i23)
	if (wb_rst_i23)
		wb_dat_o23 <= #1 0;
	else if (re_o23)
		case (wb_sel_is23)
			4'b0001: wb_dat_o23 <= #1 {24'b0, wb_dat8_o23};
			4'b0010: wb_dat_o23 <= #1 {16'b0, wb_dat8_o23, 8'b0};
			4'b0100: wb_dat_o23 <= #1 {8'b0, wb_dat8_o23, 16'b0};
			4'b1000: wb_dat_o23 <= #1 {wb_dat8_o23, 24'b0};
			4'b1111: wb_dat_o23 <= #1 wb_dat32_o23; // debug23 interface output
 			default: wb_dat_o23 <= #1 0;
		endcase // case(wb_sel_i23)

reg [1:0] wb_adr_int_lsb23;

always @(wb_sel_is23 or wb_dat_is23)
begin
	case (wb_sel_is23)
		4'b0001 : wb_dat8_i23 = wb_dat_is23[7:0];
		4'b0010 : wb_dat8_i23 = wb_dat_is23[15:8];
		4'b0100 : wb_dat8_i23 = wb_dat_is23[23:16];
		4'b1000 : wb_dat8_i23 = wb_dat_is23[31:24];
		default : wb_dat8_i23 = wb_dat_is23[7:0];
	endcase // case(wb_sel_i23)

  `ifdef LITLE_ENDIAN23
	case (wb_sel_is23)
		4'b0001 : wb_adr_int_lsb23 = 2'h0;
		4'b0010 : wb_adr_int_lsb23 = 2'h1;
		4'b0100 : wb_adr_int_lsb23 = 2'h2;
		4'b1000 : wb_adr_int_lsb23 = 2'h3;
		default : wb_adr_int_lsb23 = 2'h0;
	endcase // case(wb_sel_i23)
  `else
	case (wb_sel_is23)
		4'b0001 : wb_adr_int_lsb23 = 2'h3;
		4'b0010 : wb_adr_int_lsb23 = 2'h2;
		4'b0100 : wb_adr_int_lsb23 = 2'h1;
		4'b1000 : wb_adr_int_lsb23 = 2'h0;
		default : wb_adr_int_lsb23 = 2'h0;
	endcase // case(wb_sel_i23)
  `endif
end

assign wb_adr_int23 = {wb_adr_is23[`UART_ADDR_WIDTH23-1:2], wb_adr_int_lsb23};

`endif // !`ifdef DATA_BUS_WIDTH_823

endmodule










