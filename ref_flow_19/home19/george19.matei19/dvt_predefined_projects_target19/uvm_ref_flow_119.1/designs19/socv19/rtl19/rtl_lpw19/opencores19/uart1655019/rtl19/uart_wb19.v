//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb19.v                                                   ////
////                                                              ////
////                                                              ////
////  This19 file is part of the "UART19 16550 compatible19" project19    ////
////  http19://www19.opencores19.org19/cores19/uart1655019/                   ////
////                                                              ////
////  Documentation19 related19 to this project19:                      ////
////  - http19://www19.opencores19.org19/cores19/uart1655019/                 ////
////                                                              ////
////  Projects19 compatibility19:                                     ////
////  - WISHBONE19                                                  ////
////  RS23219 Protocol19                                              ////
////  16550D uart19 (mostly19 supported)                              ////
////                                                              ////
////  Overview19 (main19 Features19):                                   ////
////  UART19 core19 WISHBONE19 interface.                               ////
////                                                              ////
////  Known19 problems19 (limits19):                                    ////
////  Inserts19 one wait state on all transfers19.                    ////
////  Note19 affected19 signals19 and the way19 they are affected19.        ////
////                                                              ////
////  To19 Do19:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author19(s):                                                  ////
////      - gorban19@opencores19.org19                                  ////
////      - Jacob19 Gorban19                                          ////
////      - Igor19 Mohor19 (igorm19@opencores19.org19)                      ////
////                                                              ////
////  Created19:        2001/05/12                                  ////
////  Last19 Updated19:   2001/05/17                                  ////
////                  (See log19 for the revision19 history19)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2000, 2001 Authors19                             ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS19 Revision19 History19
//
// $Log: not supported by cvs2svn19 $
// Revision19 1.16  2002/07/29 21:16:18  gorban19
// The uart_defines19.v file is included19 again19 in sources19.
//
// Revision19 1.15  2002/07/22 23:02:23  gorban19
// Bug19 Fixes19:
//  * Possible19 loss of sync and bad19 reception19 of stop bit on slow19 baud19 rates19 fixed19.
//   Problem19 reported19 by Kenny19.Tung19.
//  * Bad (or lack19 of ) loopback19 handling19 fixed19. Reported19 by Cherry19 Withers19.
//
// Improvements19:
//  * Made19 FIFO's as general19 inferrable19 memory where possible19.
//  So19 on FPGA19 they should be inferred19 as RAM19 (Distributed19 RAM19 on Xilinx19).
//  This19 saves19 about19 1/3 of the Slice19 count and reduces19 P&R and synthesis19 times.
//
//  * Added19 optional19 baudrate19 output (baud_o19).
//  This19 is identical19 to BAUDOUT19* signal19 on 16550 chip19.
//  It outputs19 16xbit_clock_rate - the divided19 clock19.
//  It's disabled by default. Define19 UART_HAS_BAUDRATE_OUTPUT19 to use.
//
// Revision19 1.12  2001/12/19 08:03:34  mohor19
// Warnings19 cleared19.
//
// Revision19 1.11  2001/12/06 14:51:04  gorban19
// Bug19 in LSR19[0] is fixed19.
// All WISHBONE19 signals19 are now sampled19, so another19 wait-state is introduced19 on all transfers19.
//
// Revision19 1.10  2001/12/03 21:44:29  gorban19
// Updated19 specification19 documentation.
// Added19 full 32-bit data bus interface, now as default.
// Address is 5-bit wide19 in 32-bit data bus mode.
// Added19 wb_sel_i19 input to the core19. It's used in the 32-bit mode.
// Added19 debug19 interface with two19 32-bit read-only registers in 32-bit mode.
// Bits19 5 and 6 of LSR19 are now only cleared19 on TX19 FIFO write.
// My19 small test bench19 is modified to work19 with 32-bit mode.
//
// Revision19 1.9  2001/10/20 09:58:40  gorban19
// Small19 synopsis19 fixes19
//
// Revision19 1.8  2001/08/24 21:01:12  mohor19
// Things19 connected19 to parity19 changed.
// Clock19 devider19 changed.
//
// Revision19 1.7  2001/08/23 16:05:05  mohor19
// Stop bit bug19 fixed19.
// Parity19 bug19 fixed19.
// WISHBONE19 read cycle bug19 fixed19,
// OE19 indicator19 (Overrun19 Error) bug19 fixed19.
// PE19 indicator19 (Parity19 Error) bug19 fixed19.
// Register read bug19 fixed19.
//
// Revision19 1.4  2001/05/31 20:08:01  gorban19
// FIFO changes19 and other corrections19.
//
// Revision19 1.3  2001/05/21 19:12:01  gorban19
// Corrected19 some19 Linter19 messages19.
//
// Revision19 1.2  2001/05/17 18:34:18  gorban19
// First19 'stable' release. Should19 be sythesizable19 now. Also19 added new header.
//
// Revision19 1.0  2001-05-17 21:27:13+02  jacob19
// Initial19 revision19
//
//

// UART19 core19 WISHBONE19 interface 
//
// Author19: Jacob19 Gorban19   (jacob19.gorban19@flextronicssemi19.com19)
// Company19: Flextronics19 Semiconductor19
//

// synopsys19 translate_off19
`include "timescale.v"
// synopsys19 translate_on19
`include "uart_defines19.v"
 
module uart_wb19 (clk19, wb_rst_i19, 
	wb_we_i19, wb_stb_i19, wb_cyc_i19, wb_ack_o19, wb_adr_i19,
	wb_adr_int19, wb_dat_i19, wb_dat_o19, wb_dat8_i19, wb_dat8_o19, wb_dat32_o19, wb_sel_i19,
	we_o19, re_o19 // Write and read enable output for the core19
);

input 		  clk19;

// WISHBONE19 interface	
input 		  wb_rst_i19;
input 		  wb_we_i19;
input 		  wb_stb_i19;
input 		  wb_cyc_i19;
input [3:0]   wb_sel_i19;
input [`UART_ADDR_WIDTH19-1:0] 	wb_adr_i19; //WISHBONE19 address line

`ifdef DATA_BUS_WIDTH_819
input [7:0]  wb_dat_i19; //input WISHBONE19 bus 
output [7:0] wb_dat_o19;
reg [7:0] 	 wb_dat_o19;
wire [7:0] 	 wb_dat_i19;
reg [7:0] 	 wb_dat_is19;
`else // for 32 data bus mode
input [31:0]  wb_dat_i19; //input WISHBONE19 bus 
output [31:0] wb_dat_o19;
reg [31:0] 	  wb_dat_o19;
wire [31:0]   wb_dat_i19;
reg [31:0] 	  wb_dat_is19;
`endif // !`ifdef DATA_BUS_WIDTH_819

output [`UART_ADDR_WIDTH19-1:0]	wb_adr_int19; // internal signal19 for address bus
input [7:0]   wb_dat8_o19; // internal 8 bit output to be put into wb_dat_o19
output [7:0]  wb_dat8_i19;
input [31:0]  wb_dat32_o19; // 32 bit data output (for debug19 interface)
output 		  wb_ack_o19;
output 		  we_o19;
output 		  re_o19;

wire 			  we_o19;
reg 			  wb_ack_o19;
reg [7:0] 	  wb_dat8_i19;
wire [7:0] 	  wb_dat8_o19;
wire [`UART_ADDR_WIDTH19-1:0]	wb_adr_int19; // internal signal19 for address bus
reg [`UART_ADDR_WIDTH19-1:0]	wb_adr_is19;
reg 								wb_we_is19;
reg 								wb_cyc_is19;
reg 								wb_stb_is19;
reg [3:0] 						wb_sel_is19;
wire [3:0]   wb_sel_i19;
reg 			 wre19 ;// timing19 control19 signal19 for write or read enable

// wb_ack_o19 FSM19
reg [1:0] 	 wbstate19;
always  @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) begin
		wb_ack_o19 <= #1 1'b0;
		wbstate19 <= #1 0;
		wre19 <= #1 1'b1;
	end else
		case (wbstate19)
			0: begin
				if (wb_stb_is19 & wb_cyc_is19) begin
					wre19 <= #1 0;
					wbstate19 <= #1 1;
					wb_ack_o19 <= #1 1;
				end else begin
					wre19 <= #1 1;
					wb_ack_o19 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o19 <= #1 0;
				wbstate19 <= #1 2;
				wre19 <= #1 0;
			end
			2,3: begin
				wb_ack_o19 <= #1 0;
				wbstate19 <= #1 0;
				wre19 <= #1 0;
			end
		endcase

assign we_o19 =  wb_we_is19 & wb_stb_is19 & wb_cyc_is19 & wre19 ; //WE19 for registers	
assign re_o19 = ~wb_we_is19 & wb_stb_is19 & wb_cyc_is19 & wre19 ; //RE19 for registers	

// Sample19 input signals19
always  @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19) begin
		wb_adr_is19 <= #1 0;
		wb_we_is19 <= #1 0;
		wb_cyc_is19 <= #1 0;
		wb_stb_is19 <= #1 0;
		wb_dat_is19 <= #1 0;
		wb_sel_is19 <= #1 0;
	end else begin
		wb_adr_is19 <= #1 wb_adr_i19;
		wb_we_is19 <= #1 wb_we_i19;
		wb_cyc_is19 <= #1 wb_cyc_i19;
		wb_stb_is19 <= #1 wb_stb_i19;
		wb_dat_is19 <= #1 wb_dat_i19;
		wb_sel_is19 <= #1 wb_sel_i19;
	end

`ifdef DATA_BUS_WIDTH_819 // 8-bit data bus
always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19)
		wb_dat_o19 <= #1 0;
	else
		wb_dat_o19 <= #1 wb_dat8_o19;

always @(wb_dat_is19)
	wb_dat8_i19 = wb_dat_is19;

assign wb_adr_int19 = wb_adr_is19;

`else // 32-bit bus
// put output to the correct19 byte in 32 bits using select19 line
always @(posedge clk19 or posedge wb_rst_i19)
	if (wb_rst_i19)
		wb_dat_o19 <= #1 0;
	else if (re_o19)
		case (wb_sel_is19)
			4'b0001: wb_dat_o19 <= #1 {24'b0, wb_dat8_o19};
			4'b0010: wb_dat_o19 <= #1 {16'b0, wb_dat8_o19, 8'b0};
			4'b0100: wb_dat_o19 <= #1 {8'b0, wb_dat8_o19, 16'b0};
			4'b1000: wb_dat_o19 <= #1 {wb_dat8_o19, 24'b0};
			4'b1111: wb_dat_o19 <= #1 wb_dat32_o19; // debug19 interface output
 			default: wb_dat_o19 <= #1 0;
		endcase // case(wb_sel_i19)

reg [1:0] wb_adr_int_lsb19;

always @(wb_sel_is19 or wb_dat_is19)
begin
	case (wb_sel_is19)
		4'b0001 : wb_dat8_i19 = wb_dat_is19[7:0];
		4'b0010 : wb_dat8_i19 = wb_dat_is19[15:8];
		4'b0100 : wb_dat8_i19 = wb_dat_is19[23:16];
		4'b1000 : wb_dat8_i19 = wb_dat_is19[31:24];
		default : wb_dat8_i19 = wb_dat_is19[7:0];
	endcase // case(wb_sel_i19)

  `ifdef LITLE_ENDIAN19
	case (wb_sel_is19)
		4'b0001 : wb_adr_int_lsb19 = 2'h0;
		4'b0010 : wb_adr_int_lsb19 = 2'h1;
		4'b0100 : wb_adr_int_lsb19 = 2'h2;
		4'b1000 : wb_adr_int_lsb19 = 2'h3;
		default : wb_adr_int_lsb19 = 2'h0;
	endcase // case(wb_sel_i19)
  `else
	case (wb_sel_is19)
		4'b0001 : wb_adr_int_lsb19 = 2'h3;
		4'b0010 : wb_adr_int_lsb19 = 2'h2;
		4'b0100 : wb_adr_int_lsb19 = 2'h1;
		4'b1000 : wb_adr_int_lsb19 = 2'h0;
		default : wb_adr_int_lsb19 = 2'h0;
	endcase // case(wb_sel_i19)
  `endif
end

assign wb_adr_int19 = {wb_adr_is19[`UART_ADDR_WIDTH19-1:2], wb_adr_int_lsb19};

`endif // !`ifdef DATA_BUS_WIDTH_819

endmodule










