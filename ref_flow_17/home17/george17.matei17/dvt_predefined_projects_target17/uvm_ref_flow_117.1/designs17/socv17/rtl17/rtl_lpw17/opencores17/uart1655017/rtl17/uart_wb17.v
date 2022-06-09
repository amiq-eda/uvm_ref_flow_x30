//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb17.v                                                   ////
////                                                              ////
////                                                              ////
////  This17 file is part of the "UART17 16550 compatible17" project17    ////
////  http17://www17.opencores17.org17/cores17/uart1655017/                   ////
////                                                              ////
////  Documentation17 related17 to this project17:                      ////
////  - http17://www17.opencores17.org17/cores17/uart1655017/                 ////
////                                                              ////
////  Projects17 compatibility17:                                     ////
////  - WISHBONE17                                                  ////
////  RS23217 Protocol17                                              ////
////  16550D uart17 (mostly17 supported)                              ////
////                                                              ////
////  Overview17 (main17 Features17):                                   ////
////  UART17 core17 WISHBONE17 interface.                               ////
////                                                              ////
////  Known17 problems17 (limits17):                                    ////
////  Inserts17 one wait state on all transfers17.                    ////
////  Note17 affected17 signals17 and the way17 they are affected17.        ////
////                                                              ////
////  To17 Do17:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author17(s):                                                  ////
////      - gorban17@opencores17.org17                                  ////
////      - Jacob17 Gorban17                                          ////
////      - Igor17 Mohor17 (igorm17@opencores17.org17)                      ////
////                                                              ////
////  Created17:        2001/05/12                                  ////
////  Last17 Updated17:   2001/05/17                                  ////
////                  (See log17 for the revision17 history17)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2000, 2001 Authors17                             ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS17 Revision17 History17
//
// $Log: not supported by cvs2svn17 $
// Revision17 1.16  2002/07/29 21:16:18  gorban17
// The uart_defines17.v file is included17 again17 in sources17.
//
// Revision17 1.15  2002/07/22 23:02:23  gorban17
// Bug17 Fixes17:
//  * Possible17 loss of sync and bad17 reception17 of stop bit on slow17 baud17 rates17 fixed17.
//   Problem17 reported17 by Kenny17.Tung17.
//  * Bad (or lack17 of ) loopback17 handling17 fixed17. Reported17 by Cherry17 Withers17.
//
// Improvements17:
//  * Made17 FIFO's as general17 inferrable17 memory where possible17.
//  So17 on FPGA17 they should be inferred17 as RAM17 (Distributed17 RAM17 on Xilinx17).
//  This17 saves17 about17 1/3 of the Slice17 count and reduces17 P&R and synthesis17 times.
//
//  * Added17 optional17 baudrate17 output (baud_o17).
//  This17 is identical17 to BAUDOUT17* signal17 on 16550 chip17.
//  It outputs17 16xbit_clock_rate - the divided17 clock17.
//  It's disabled by default. Define17 UART_HAS_BAUDRATE_OUTPUT17 to use.
//
// Revision17 1.12  2001/12/19 08:03:34  mohor17
// Warnings17 cleared17.
//
// Revision17 1.11  2001/12/06 14:51:04  gorban17
// Bug17 in LSR17[0] is fixed17.
// All WISHBONE17 signals17 are now sampled17, so another17 wait-state is introduced17 on all transfers17.
//
// Revision17 1.10  2001/12/03 21:44:29  gorban17
// Updated17 specification17 documentation.
// Added17 full 32-bit data bus interface, now as default.
// Address is 5-bit wide17 in 32-bit data bus mode.
// Added17 wb_sel_i17 input to the core17. It's used in the 32-bit mode.
// Added17 debug17 interface with two17 32-bit read-only registers in 32-bit mode.
// Bits17 5 and 6 of LSR17 are now only cleared17 on TX17 FIFO write.
// My17 small test bench17 is modified to work17 with 32-bit mode.
//
// Revision17 1.9  2001/10/20 09:58:40  gorban17
// Small17 synopsis17 fixes17
//
// Revision17 1.8  2001/08/24 21:01:12  mohor17
// Things17 connected17 to parity17 changed.
// Clock17 devider17 changed.
//
// Revision17 1.7  2001/08/23 16:05:05  mohor17
// Stop bit bug17 fixed17.
// Parity17 bug17 fixed17.
// WISHBONE17 read cycle bug17 fixed17,
// OE17 indicator17 (Overrun17 Error) bug17 fixed17.
// PE17 indicator17 (Parity17 Error) bug17 fixed17.
// Register read bug17 fixed17.
//
// Revision17 1.4  2001/05/31 20:08:01  gorban17
// FIFO changes17 and other corrections17.
//
// Revision17 1.3  2001/05/21 19:12:01  gorban17
// Corrected17 some17 Linter17 messages17.
//
// Revision17 1.2  2001/05/17 18:34:18  gorban17
// First17 'stable' release. Should17 be sythesizable17 now. Also17 added new header.
//
// Revision17 1.0  2001-05-17 21:27:13+02  jacob17
// Initial17 revision17
//
//

// UART17 core17 WISHBONE17 interface 
//
// Author17: Jacob17 Gorban17   (jacob17.gorban17@flextronicssemi17.com17)
// Company17: Flextronics17 Semiconductor17
//

// synopsys17 translate_off17
`include "timescale.v"
// synopsys17 translate_on17
`include "uart_defines17.v"
 
module uart_wb17 (clk17, wb_rst_i17, 
	wb_we_i17, wb_stb_i17, wb_cyc_i17, wb_ack_o17, wb_adr_i17,
	wb_adr_int17, wb_dat_i17, wb_dat_o17, wb_dat8_i17, wb_dat8_o17, wb_dat32_o17, wb_sel_i17,
	we_o17, re_o17 // Write and read enable output for the core17
);

input 		  clk17;

// WISHBONE17 interface	
input 		  wb_rst_i17;
input 		  wb_we_i17;
input 		  wb_stb_i17;
input 		  wb_cyc_i17;
input [3:0]   wb_sel_i17;
input [`UART_ADDR_WIDTH17-1:0] 	wb_adr_i17; //WISHBONE17 address line

`ifdef DATA_BUS_WIDTH_817
input [7:0]  wb_dat_i17; //input WISHBONE17 bus 
output [7:0] wb_dat_o17;
reg [7:0] 	 wb_dat_o17;
wire [7:0] 	 wb_dat_i17;
reg [7:0] 	 wb_dat_is17;
`else // for 32 data bus mode
input [31:0]  wb_dat_i17; //input WISHBONE17 bus 
output [31:0] wb_dat_o17;
reg [31:0] 	  wb_dat_o17;
wire [31:0]   wb_dat_i17;
reg [31:0] 	  wb_dat_is17;
`endif // !`ifdef DATA_BUS_WIDTH_817

output [`UART_ADDR_WIDTH17-1:0]	wb_adr_int17; // internal signal17 for address bus
input [7:0]   wb_dat8_o17; // internal 8 bit output to be put into wb_dat_o17
output [7:0]  wb_dat8_i17;
input [31:0]  wb_dat32_o17; // 32 bit data output (for debug17 interface)
output 		  wb_ack_o17;
output 		  we_o17;
output 		  re_o17;

wire 			  we_o17;
reg 			  wb_ack_o17;
reg [7:0] 	  wb_dat8_i17;
wire [7:0] 	  wb_dat8_o17;
wire [`UART_ADDR_WIDTH17-1:0]	wb_adr_int17; // internal signal17 for address bus
reg [`UART_ADDR_WIDTH17-1:0]	wb_adr_is17;
reg 								wb_we_is17;
reg 								wb_cyc_is17;
reg 								wb_stb_is17;
reg [3:0] 						wb_sel_is17;
wire [3:0]   wb_sel_i17;
reg 			 wre17 ;// timing17 control17 signal17 for write or read enable

// wb_ack_o17 FSM17
reg [1:0] 	 wbstate17;
always  @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) begin
		wb_ack_o17 <= #1 1'b0;
		wbstate17 <= #1 0;
		wre17 <= #1 1'b1;
	end else
		case (wbstate17)
			0: begin
				if (wb_stb_is17 & wb_cyc_is17) begin
					wre17 <= #1 0;
					wbstate17 <= #1 1;
					wb_ack_o17 <= #1 1;
				end else begin
					wre17 <= #1 1;
					wb_ack_o17 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o17 <= #1 0;
				wbstate17 <= #1 2;
				wre17 <= #1 0;
			end
			2,3: begin
				wb_ack_o17 <= #1 0;
				wbstate17 <= #1 0;
				wre17 <= #1 0;
			end
		endcase

assign we_o17 =  wb_we_is17 & wb_stb_is17 & wb_cyc_is17 & wre17 ; //WE17 for registers	
assign re_o17 = ~wb_we_is17 & wb_stb_is17 & wb_cyc_is17 & wre17 ; //RE17 for registers	

// Sample17 input signals17
always  @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17) begin
		wb_adr_is17 <= #1 0;
		wb_we_is17 <= #1 0;
		wb_cyc_is17 <= #1 0;
		wb_stb_is17 <= #1 0;
		wb_dat_is17 <= #1 0;
		wb_sel_is17 <= #1 0;
	end else begin
		wb_adr_is17 <= #1 wb_adr_i17;
		wb_we_is17 <= #1 wb_we_i17;
		wb_cyc_is17 <= #1 wb_cyc_i17;
		wb_stb_is17 <= #1 wb_stb_i17;
		wb_dat_is17 <= #1 wb_dat_i17;
		wb_sel_is17 <= #1 wb_sel_i17;
	end

`ifdef DATA_BUS_WIDTH_817 // 8-bit data bus
always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17)
		wb_dat_o17 <= #1 0;
	else
		wb_dat_o17 <= #1 wb_dat8_o17;

always @(wb_dat_is17)
	wb_dat8_i17 = wb_dat_is17;

assign wb_adr_int17 = wb_adr_is17;

`else // 32-bit bus
// put output to the correct17 byte in 32 bits using select17 line
always @(posedge clk17 or posedge wb_rst_i17)
	if (wb_rst_i17)
		wb_dat_o17 <= #1 0;
	else if (re_o17)
		case (wb_sel_is17)
			4'b0001: wb_dat_o17 <= #1 {24'b0, wb_dat8_o17};
			4'b0010: wb_dat_o17 <= #1 {16'b0, wb_dat8_o17, 8'b0};
			4'b0100: wb_dat_o17 <= #1 {8'b0, wb_dat8_o17, 16'b0};
			4'b1000: wb_dat_o17 <= #1 {wb_dat8_o17, 24'b0};
			4'b1111: wb_dat_o17 <= #1 wb_dat32_o17; // debug17 interface output
 			default: wb_dat_o17 <= #1 0;
		endcase // case(wb_sel_i17)

reg [1:0] wb_adr_int_lsb17;

always @(wb_sel_is17 or wb_dat_is17)
begin
	case (wb_sel_is17)
		4'b0001 : wb_dat8_i17 = wb_dat_is17[7:0];
		4'b0010 : wb_dat8_i17 = wb_dat_is17[15:8];
		4'b0100 : wb_dat8_i17 = wb_dat_is17[23:16];
		4'b1000 : wb_dat8_i17 = wb_dat_is17[31:24];
		default : wb_dat8_i17 = wb_dat_is17[7:0];
	endcase // case(wb_sel_i17)

  `ifdef LITLE_ENDIAN17
	case (wb_sel_is17)
		4'b0001 : wb_adr_int_lsb17 = 2'h0;
		4'b0010 : wb_adr_int_lsb17 = 2'h1;
		4'b0100 : wb_adr_int_lsb17 = 2'h2;
		4'b1000 : wb_adr_int_lsb17 = 2'h3;
		default : wb_adr_int_lsb17 = 2'h0;
	endcase // case(wb_sel_i17)
  `else
	case (wb_sel_is17)
		4'b0001 : wb_adr_int_lsb17 = 2'h3;
		4'b0010 : wb_adr_int_lsb17 = 2'h2;
		4'b0100 : wb_adr_int_lsb17 = 2'h1;
		4'b1000 : wb_adr_int_lsb17 = 2'h0;
		default : wb_adr_int_lsb17 = 2'h0;
	endcase // case(wb_sel_i17)
  `endif
end

assign wb_adr_int17 = {wb_adr_is17[`UART_ADDR_WIDTH17-1:2], wb_adr_int_lsb17};

`endif // !`ifdef DATA_BUS_WIDTH_817

endmodule










