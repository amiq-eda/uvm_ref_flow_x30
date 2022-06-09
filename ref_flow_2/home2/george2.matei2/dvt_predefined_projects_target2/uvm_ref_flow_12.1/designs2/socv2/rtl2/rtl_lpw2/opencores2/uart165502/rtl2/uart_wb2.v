//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb2.v                                                   ////
////                                                              ////
////                                                              ////
////  This2 file is part of the "UART2 16550 compatible2" project2    ////
////  http2://www2.opencores2.org2/cores2/uart165502/                   ////
////                                                              ////
////  Documentation2 related2 to this project2:                      ////
////  - http2://www2.opencores2.org2/cores2/uart165502/                 ////
////                                                              ////
////  Projects2 compatibility2:                                     ////
////  - WISHBONE2                                                  ////
////  RS2322 Protocol2                                              ////
////  16550D uart2 (mostly2 supported)                              ////
////                                                              ////
////  Overview2 (main2 Features2):                                   ////
////  UART2 core2 WISHBONE2 interface.                               ////
////                                                              ////
////  Known2 problems2 (limits2):                                    ////
////  Inserts2 one wait state on all transfers2.                    ////
////  Note2 affected2 signals2 and the way2 they are affected2.        ////
////                                                              ////
////  To2 Do2:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author2(s):                                                  ////
////      - gorban2@opencores2.org2                                  ////
////      - Jacob2 Gorban2                                          ////
////      - Igor2 Mohor2 (igorm2@opencores2.org2)                      ////
////                                                              ////
////  Created2:        2001/05/12                                  ////
////  Last2 Updated2:   2001/05/17                                  ////
////                  (See log2 for the revision2 history2)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2000, 2001 Authors2                             ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS2 Revision2 History2
//
// $Log: not supported by cvs2svn2 $
// Revision2 1.16  2002/07/29 21:16:18  gorban2
// The uart_defines2.v file is included2 again2 in sources2.
//
// Revision2 1.15  2002/07/22 23:02:23  gorban2
// Bug2 Fixes2:
//  * Possible2 loss of sync and bad2 reception2 of stop bit on slow2 baud2 rates2 fixed2.
//   Problem2 reported2 by Kenny2.Tung2.
//  * Bad (or lack2 of ) loopback2 handling2 fixed2. Reported2 by Cherry2 Withers2.
//
// Improvements2:
//  * Made2 FIFO's as general2 inferrable2 memory where possible2.
//  So2 on FPGA2 they should be inferred2 as RAM2 (Distributed2 RAM2 on Xilinx2).
//  This2 saves2 about2 1/3 of the Slice2 count and reduces2 P&R and synthesis2 times.
//
//  * Added2 optional2 baudrate2 output (baud_o2).
//  This2 is identical2 to BAUDOUT2* signal2 on 16550 chip2.
//  It outputs2 16xbit_clock_rate - the divided2 clock2.
//  It's disabled by default. Define2 UART_HAS_BAUDRATE_OUTPUT2 to use.
//
// Revision2 1.12  2001/12/19 08:03:34  mohor2
// Warnings2 cleared2.
//
// Revision2 1.11  2001/12/06 14:51:04  gorban2
// Bug2 in LSR2[0] is fixed2.
// All WISHBONE2 signals2 are now sampled2, so another2 wait-state is introduced2 on all transfers2.
//
// Revision2 1.10  2001/12/03 21:44:29  gorban2
// Updated2 specification2 documentation.
// Added2 full 32-bit data bus interface, now as default.
// Address is 5-bit wide2 in 32-bit data bus mode.
// Added2 wb_sel_i2 input to the core2. It's used in the 32-bit mode.
// Added2 debug2 interface with two2 32-bit read-only registers in 32-bit mode.
// Bits2 5 and 6 of LSR2 are now only cleared2 on TX2 FIFO write.
// My2 small test bench2 is modified to work2 with 32-bit mode.
//
// Revision2 1.9  2001/10/20 09:58:40  gorban2
// Small2 synopsis2 fixes2
//
// Revision2 1.8  2001/08/24 21:01:12  mohor2
// Things2 connected2 to parity2 changed.
// Clock2 devider2 changed.
//
// Revision2 1.7  2001/08/23 16:05:05  mohor2
// Stop bit bug2 fixed2.
// Parity2 bug2 fixed2.
// WISHBONE2 read cycle bug2 fixed2,
// OE2 indicator2 (Overrun2 Error) bug2 fixed2.
// PE2 indicator2 (Parity2 Error) bug2 fixed2.
// Register read bug2 fixed2.
//
// Revision2 1.4  2001/05/31 20:08:01  gorban2
// FIFO changes2 and other corrections2.
//
// Revision2 1.3  2001/05/21 19:12:01  gorban2
// Corrected2 some2 Linter2 messages2.
//
// Revision2 1.2  2001/05/17 18:34:18  gorban2
// First2 'stable' release. Should2 be sythesizable2 now. Also2 added new header.
//
// Revision2 1.0  2001-05-17 21:27:13+02  jacob2
// Initial2 revision2
//
//

// UART2 core2 WISHBONE2 interface 
//
// Author2: Jacob2 Gorban2   (jacob2.gorban2@flextronicssemi2.com2)
// Company2: Flextronics2 Semiconductor2
//

// synopsys2 translate_off2
`include "timescale.v"
// synopsys2 translate_on2
`include "uart_defines2.v"
 
module uart_wb2 (clk2, wb_rst_i2, 
	wb_we_i2, wb_stb_i2, wb_cyc_i2, wb_ack_o2, wb_adr_i2,
	wb_adr_int2, wb_dat_i2, wb_dat_o2, wb_dat8_i2, wb_dat8_o2, wb_dat32_o2, wb_sel_i2,
	we_o2, re_o2 // Write and read enable output for the core2
);

input 		  clk2;

// WISHBONE2 interface	
input 		  wb_rst_i2;
input 		  wb_we_i2;
input 		  wb_stb_i2;
input 		  wb_cyc_i2;
input [3:0]   wb_sel_i2;
input [`UART_ADDR_WIDTH2-1:0] 	wb_adr_i2; //WISHBONE2 address line

`ifdef DATA_BUS_WIDTH_82
input [7:0]  wb_dat_i2; //input WISHBONE2 bus 
output [7:0] wb_dat_o2;
reg [7:0] 	 wb_dat_o2;
wire [7:0] 	 wb_dat_i2;
reg [7:0] 	 wb_dat_is2;
`else // for 32 data bus mode
input [31:0]  wb_dat_i2; //input WISHBONE2 bus 
output [31:0] wb_dat_o2;
reg [31:0] 	  wb_dat_o2;
wire [31:0]   wb_dat_i2;
reg [31:0] 	  wb_dat_is2;
`endif // !`ifdef DATA_BUS_WIDTH_82

output [`UART_ADDR_WIDTH2-1:0]	wb_adr_int2; // internal signal2 for address bus
input [7:0]   wb_dat8_o2; // internal 8 bit output to be put into wb_dat_o2
output [7:0]  wb_dat8_i2;
input [31:0]  wb_dat32_o2; // 32 bit data output (for debug2 interface)
output 		  wb_ack_o2;
output 		  we_o2;
output 		  re_o2;

wire 			  we_o2;
reg 			  wb_ack_o2;
reg [7:0] 	  wb_dat8_i2;
wire [7:0] 	  wb_dat8_o2;
wire [`UART_ADDR_WIDTH2-1:0]	wb_adr_int2; // internal signal2 for address bus
reg [`UART_ADDR_WIDTH2-1:0]	wb_adr_is2;
reg 								wb_we_is2;
reg 								wb_cyc_is2;
reg 								wb_stb_is2;
reg [3:0] 						wb_sel_is2;
wire [3:0]   wb_sel_i2;
reg 			 wre2 ;// timing2 control2 signal2 for write or read enable

// wb_ack_o2 FSM2
reg [1:0] 	 wbstate2;
always  @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) begin
		wb_ack_o2 <= #1 1'b0;
		wbstate2 <= #1 0;
		wre2 <= #1 1'b1;
	end else
		case (wbstate2)
			0: begin
				if (wb_stb_is2 & wb_cyc_is2) begin
					wre2 <= #1 0;
					wbstate2 <= #1 1;
					wb_ack_o2 <= #1 1;
				end else begin
					wre2 <= #1 1;
					wb_ack_o2 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o2 <= #1 0;
				wbstate2 <= #1 2;
				wre2 <= #1 0;
			end
			2,3: begin
				wb_ack_o2 <= #1 0;
				wbstate2 <= #1 0;
				wre2 <= #1 0;
			end
		endcase

assign we_o2 =  wb_we_is2 & wb_stb_is2 & wb_cyc_is2 & wre2 ; //WE2 for registers	
assign re_o2 = ~wb_we_is2 & wb_stb_is2 & wb_cyc_is2 & wre2 ; //RE2 for registers	

// Sample2 input signals2
always  @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2) begin
		wb_adr_is2 <= #1 0;
		wb_we_is2 <= #1 0;
		wb_cyc_is2 <= #1 0;
		wb_stb_is2 <= #1 0;
		wb_dat_is2 <= #1 0;
		wb_sel_is2 <= #1 0;
	end else begin
		wb_adr_is2 <= #1 wb_adr_i2;
		wb_we_is2 <= #1 wb_we_i2;
		wb_cyc_is2 <= #1 wb_cyc_i2;
		wb_stb_is2 <= #1 wb_stb_i2;
		wb_dat_is2 <= #1 wb_dat_i2;
		wb_sel_is2 <= #1 wb_sel_i2;
	end

`ifdef DATA_BUS_WIDTH_82 // 8-bit data bus
always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2)
		wb_dat_o2 <= #1 0;
	else
		wb_dat_o2 <= #1 wb_dat8_o2;

always @(wb_dat_is2)
	wb_dat8_i2 = wb_dat_is2;

assign wb_adr_int2 = wb_adr_is2;

`else // 32-bit bus
// put output to the correct2 byte in 32 bits using select2 line
always @(posedge clk2 or posedge wb_rst_i2)
	if (wb_rst_i2)
		wb_dat_o2 <= #1 0;
	else if (re_o2)
		case (wb_sel_is2)
			4'b0001: wb_dat_o2 <= #1 {24'b0, wb_dat8_o2};
			4'b0010: wb_dat_o2 <= #1 {16'b0, wb_dat8_o2, 8'b0};
			4'b0100: wb_dat_o2 <= #1 {8'b0, wb_dat8_o2, 16'b0};
			4'b1000: wb_dat_o2 <= #1 {wb_dat8_o2, 24'b0};
			4'b1111: wb_dat_o2 <= #1 wb_dat32_o2; // debug2 interface output
 			default: wb_dat_o2 <= #1 0;
		endcase // case(wb_sel_i2)

reg [1:0] wb_adr_int_lsb2;

always @(wb_sel_is2 or wb_dat_is2)
begin
	case (wb_sel_is2)
		4'b0001 : wb_dat8_i2 = wb_dat_is2[7:0];
		4'b0010 : wb_dat8_i2 = wb_dat_is2[15:8];
		4'b0100 : wb_dat8_i2 = wb_dat_is2[23:16];
		4'b1000 : wb_dat8_i2 = wb_dat_is2[31:24];
		default : wb_dat8_i2 = wb_dat_is2[7:0];
	endcase // case(wb_sel_i2)

  `ifdef LITLE_ENDIAN2
	case (wb_sel_is2)
		4'b0001 : wb_adr_int_lsb2 = 2'h0;
		4'b0010 : wb_adr_int_lsb2 = 2'h1;
		4'b0100 : wb_adr_int_lsb2 = 2'h2;
		4'b1000 : wb_adr_int_lsb2 = 2'h3;
		default : wb_adr_int_lsb2 = 2'h0;
	endcase // case(wb_sel_i2)
  `else
	case (wb_sel_is2)
		4'b0001 : wb_adr_int_lsb2 = 2'h3;
		4'b0010 : wb_adr_int_lsb2 = 2'h2;
		4'b0100 : wb_adr_int_lsb2 = 2'h1;
		4'b1000 : wb_adr_int_lsb2 = 2'h0;
		default : wb_adr_int_lsb2 = 2'h0;
	endcase // case(wb_sel_i2)
  `endif
end

assign wb_adr_int2 = {wb_adr_is2[`UART_ADDR_WIDTH2-1:2], wb_adr_int_lsb2};

`endif // !`ifdef DATA_BUS_WIDTH_82

endmodule










