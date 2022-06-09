//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb10.v                                                   ////
////                                                              ////
////                                                              ////
////  This10 file is part of the "UART10 16550 compatible10" project10    ////
////  http10://www10.opencores10.org10/cores10/uart1655010/                   ////
////                                                              ////
////  Documentation10 related10 to this project10:                      ////
////  - http10://www10.opencores10.org10/cores10/uart1655010/                 ////
////                                                              ////
////  Projects10 compatibility10:                                     ////
////  - WISHBONE10                                                  ////
////  RS23210 Protocol10                                              ////
////  16550D uart10 (mostly10 supported)                              ////
////                                                              ////
////  Overview10 (main10 Features10):                                   ////
////  UART10 core10 WISHBONE10 interface.                               ////
////                                                              ////
////  Known10 problems10 (limits10):                                    ////
////  Inserts10 one wait state on all transfers10.                    ////
////  Note10 affected10 signals10 and the way10 they are affected10.        ////
////                                                              ////
////  To10 Do10:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author10(s):                                                  ////
////      - gorban10@opencores10.org10                                  ////
////      - Jacob10 Gorban10                                          ////
////      - Igor10 Mohor10 (igorm10@opencores10.org10)                      ////
////                                                              ////
////  Created10:        2001/05/12                                  ////
////  Last10 Updated10:   2001/05/17                                  ////
////                  (See log10 for the revision10 history10)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright10 (C) 2000, 2001 Authors10                             ////
////                                                              ////
//// This10 source10 file may be used and distributed10 without         ////
//// restriction10 provided that this copyright10 statement10 is not    ////
//// removed from the file and that any derivative10 work10 contains10  ////
//// the original copyright10 notice10 and the associated disclaimer10. ////
////                                                              ////
//// This10 source10 file is free software10; you can redistribute10 it   ////
//// and/or modify it under the terms10 of the GNU10 Lesser10 General10   ////
//// Public10 License10 as published10 by the Free10 Software10 Foundation10; ////
//// either10 version10 2.1 of the License10, or (at your10 option) any   ////
//// later10 version10.                                               ////
////                                                              ////
//// This10 source10 is distributed10 in the hope10 that it will be       ////
//// useful10, but WITHOUT10 ANY10 WARRANTY10; without even10 the implied10   ////
//// warranty10 of MERCHANTABILITY10 or FITNESS10 FOR10 A PARTICULAR10      ////
//// PURPOSE10.  See the GNU10 Lesser10 General10 Public10 License10 for more ////
//// details10.                                                     ////
////                                                              ////
//// You should have received10 a copy of the GNU10 Lesser10 General10    ////
//// Public10 License10 along10 with this source10; if not, download10 it   ////
//// from http10://www10.opencores10.org10/lgpl10.shtml10                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS10 Revision10 History10
//
// $Log: not supported by cvs2svn10 $
// Revision10 1.16  2002/07/29 21:16:18  gorban10
// The uart_defines10.v file is included10 again10 in sources10.
//
// Revision10 1.15  2002/07/22 23:02:23  gorban10
// Bug10 Fixes10:
//  * Possible10 loss of sync and bad10 reception10 of stop bit on slow10 baud10 rates10 fixed10.
//   Problem10 reported10 by Kenny10.Tung10.
//  * Bad (or lack10 of ) loopback10 handling10 fixed10. Reported10 by Cherry10 Withers10.
//
// Improvements10:
//  * Made10 FIFO's as general10 inferrable10 memory where possible10.
//  So10 on FPGA10 they should be inferred10 as RAM10 (Distributed10 RAM10 on Xilinx10).
//  This10 saves10 about10 1/3 of the Slice10 count and reduces10 P&R and synthesis10 times.
//
//  * Added10 optional10 baudrate10 output (baud_o10).
//  This10 is identical10 to BAUDOUT10* signal10 on 16550 chip10.
//  It outputs10 16xbit_clock_rate - the divided10 clock10.
//  It's disabled by default. Define10 UART_HAS_BAUDRATE_OUTPUT10 to use.
//
// Revision10 1.12  2001/12/19 08:03:34  mohor10
// Warnings10 cleared10.
//
// Revision10 1.11  2001/12/06 14:51:04  gorban10
// Bug10 in LSR10[0] is fixed10.
// All WISHBONE10 signals10 are now sampled10, so another10 wait-state is introduced10 on all transfers10.
//
// Revision10 1.10  2001/12/03 21:44:29  gorban10
// Updated10 specification10 documentation.
// Added10 full 32-bit data bus interface, now as default.
// Address is 5-bit wide10 in 32-bit data bus mode.
// Added10 wb_sel_i10 input to the core10. It's used in the 32-bit mode.
// Added10 debug10 interface with two10 32-bit read-only registers in 32-bit mode.
// Bits10 5 and 6 of LSR10 are now only cleared10 on TX10 FIFO write.
// My10 small test bench10 is modified to work10 with 32-bit mode.
//
// Revision10 1.9  2001/10/20 09:58:40  gorban10
// Small10 synopsis10 fixes10
//
// Revision10 1.8  2001/08/24 21:01:12  mohor10
// Things10 connected10 to parity10 changed.
// Clock10 devider10 changed.
//
// Revision10 1.7  2001/08/23 16:05:05  mohor10
// Stop bit bug10 fixed10.
// Parity10 bug10 fixed10.
// WISHBONE10 read cycle bug10 fixed10,
// OE10 indicator10 (Overrun10 Error) bug10 fixed10.
// PE10 indicator10 (Parity10 Error) bug10 fixed10.
// Register read bug10 fixed10.
//
// Revision10 1.4  2001/05/31 20:08:01  gorban10
// FIFO changes10 and other corrections10.
//
// Revision10 1.3  2001/05/21 19:12:01  gorban10
// Corrected10 some10 Linter10 messages10.
//
// Revision10 1.2  2001/05/17 18:34:18  gorban10
// First10 'stable' release. Should10 be sythesizable10 now. Also10 added new header.
//
// Revision10 1.0  2001-05-17 21:27:13+02  jacob10
// Initial10 revision10
//
//

// UART10 core10 WISHBONE10 interface 
//
// Author10: Jacob10 Gorban10   (jacob10.gorban10@flextronicssemi10.com10)
// Company10: Flextronics10 Semiconductor10
//

// synopsys10 translate_off10
`include "timescale.v"
// synopsys10 translate_on10
`include "uart_defines10.v"
 
module uart_wb10 (clk10, wb_rst_i10, 
	wb_we_i10, wb_stb_i10, wb_cyc_i10, wb_ack_o10, wb_adr_i10,
	wb_adr_int10, wb_dat_i10, wb_dat_o10, wb_dat8_i10, wb_dat8_o10, wb_dat32_o10, wb_sel_i10,
	we_o10, re_o10 // Write and read enable output for the core10
);

input 		  clk10;

// WISHBONE10 interface	
input 		  wb_rst_i10;
input 		  wb_we_i10;
input 		  wb_stb_i10;
input 		  wb_cyc_i10;
input [3:0]   wb_sel_i10;
input [`UART_ADDR_WIDTH10-1:0] 	wb_adr_i10; //WISHBONE10 address line

`ifdef DATA_BUS_WIDTH_810
input [7:0]  wb_dat_i10; //input WISHBONE10 bus 
output [7:0] wb_dat_o10;
reg [7:0] 	 wb_dat_o10;
wire [7:0] 	 wb_dat_i10;
reg [7:0] 	 wb_dat_is10;
`else // for 32 data bus mode
input [31:0]  wb_dat_i10; //input WISHBONE10 bus 
output [31:0] wb_dat_o10;
reg [31:0] 	  wb_dat_o10;
wire [31:0]   wb_dat_i10;
reg [31:0] 	  wb_dat_is10;
`endif // !`ifdef DATA_BUS_WIDTH_810

output [`UART_ADDR_WIDTH10-1:0]	wb_adr_int10; // internal signal10 for address bus
input [7:0]   wb_dat8_o10; // internal 8 bit output to be put into wb_dat_o10
output [7:0]  wb_dat8_i10;
input [31:0]  wb_dat32_o10; // 32 bit data output (for debug10 interface)
output 		  wb_ack_o10;
output 		  we_o10;
output 		  re_o10;

wire 			  we_o10;
reg 			  wb_ack_o10;
reg [7:0] 	  wb_dat8_i10;
wire [7:0] 	  wb_dat8_o10;
wire [`UART_ADDR_WIDTH10-1:0]	wb_adr_int10; // internal signal10 for address bus
reg [`UART_ADDR_WIDTH10-1:0]	wb_adr_is10;
reg 								wb_we_is10;
reg 								wb_cyc_is10;
reg 								wb_stb_is10;
reg [3:0] 						wb_sel_is10;
wire [3:0]   wb_sel_i10;
reg 			 wre10 ;// timing10 control10 signal10 for write or read enable

// wb_ack_o10 FSM10
reg [1:0] 	 wbstate10;
always  @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) begin
		wb_ack_o10 <= #1 1'b0;
		wbstate10 <= #1 0;
		wre10 <= #1 1'b1;
	end else
		case (wbstate10)
			0: begin
				if (wb_stb_is10 & wb_cyc_is10) begin
					wre10 <= #1 0;
					wbstate10 <= #1 1;
					wb_ack_o10 <= #1 1;
				end else begin
					wre10 <= #1 1;
					wb_ack_o10 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o10 <= #1 0;
				wbstate10 <= #1 2;
				wre10 <= #1 0;
			end
			2,3: begin
				wb_ack_o10 <= #1 0;
				wbstate10 <= #1 0;
				wre10 <= #1 0;
			end
		endcase

assign we_o10 =  wb_we_is10 & wb_stb_is10 & wb_cyc_is10 & wre10 ; //WE10 for registers	
assign re_o10 = ~wb_we_is10 & wb_stb_is10 & wb_cyc_is10 & wre10 ; //RE10 for registers	

// Sample10 input signals10
always  @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10) begin
		wb_adr_is10 <= #1 0;
		wb_we_is10 <= #1 0;
		wb_cyc_is10 <= #1 0;
		wb_stb_is10 <= #1 0;
		wb_dat_is10 <= #1 0;
		wb_sel_is10 <= #1 0;
	end else begin
		wb_adr_is10 <= #1 wb_adr_i10;
		wb_we_is10 <= #1 wb_we_i10;
		wb_cyc_is10 <= #1 wb_cyc_i10;
		wb_stb_is10 <= #1 wb_stb_i10;
		wb_dat_is10 <= #1 wb_dat_i10;
		wb_sel_is10 <= #1 wb_sel_i10;
	end

`ifdef DATA_BUS_WIDTH_810 // 8-bit data bus
always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10)
		wb_dat_o10 <= #1 0;
	else
		wb_dat_o10 <= #1 wb_dat8_o10;

always @(wb_dat_is10)
	wb_dat8_i10 = wb_dat_is10;

assign wb_adr_int10 = wb_adr_is10;

`else // 32-bit bus
// put output to the correct10 byte in 32 bits using select10 line
always @(posedge clk10 or posedge wb_rst_i10)
	if (wb_rst_i10)
		wb_dat_o10 <= #1 0;
	else if (re_o10)
		case (wb_sel_is10)
			4'b0001: wb_dat_o10 <= #1 {24'b0, wb_dat8_o10};
			4'b0010: wb_dat_o10 <= #1 {16'b0, wb_dat8_o10, 8'b0};
			4'b0100: wb_dat_o10 <= #1 {8'b0, wb_dat8_o10, 16'b0};
			4'b1000: wb_dat_o10 <= #1 {wb_dat8_o10, 24'b0};
			4'b1111: wb_dat_o10 <= #1 wb_dat32_o10; // debug10 interface output
 			default: wb_dat_o10 <= #1 0;
		endcase // case(wb_sel_i10)

reg [1:0] wb_adr_int_lsb10;

always @(wb_sel_is10 or wb_dat_is10)
begin
	case (wb_sel_is10)
		4'b0001 : wb_dat8_i10 = wb_dat_is10[7:0];
		4'b0010 : wb_dat8_i10 = wb_dat_is10[15:8];
		4'b0100 : wb_dat8_i10 = wb_dat_is10[23:16];
		4'b1000 : wb_dat8_i10 = wb_dat_is10[31:24];
		default : wb_dat8_i10 = wb_dat_is10[7:0];
	endcase // case(wb_sel_i10)

  `ifdef LITLE_ENDIAN10
	case (wb_sel_is10)
		4'b0001 : wb_adr_int_lsb10 = 2'h0;
		4'b0010 : wb_adr_int_lsb10 = 2'h1;
		4'b0100 : wb_adr_int_lsb10 = 2'h2;
		4'b1000 : wb_adr_int_lsb10 = 2'h3;
		default : wb_adr_int_lsb10 = 2'h0;
	endcase // case(wb_sel_i10)
  `else
	case (wb_sel_is10)
		4'b0001 : wb_adr_int_lsb10 = 2'h3;
		4'b0010 : wb_adr_int_lsb10 = 2'h2;
		4'b0100 : wb_adr_int_lsb10 = 2'h1;
		4'b1000 : wb_adr_int_lsb10 = 2'h0;
		default : wb_adr_int_lsb10 = 2'h0;
	endcase // case(wb_sel_i10)
  `endif
end

assign wb_adr_int10 = {wb_adr_is10[`UART_ADDR_WIDTH10-1:2], wb_adr_int_lsb10};

`endif // !`ifdef DATA_BUS_WIDTH_810

endmodule










