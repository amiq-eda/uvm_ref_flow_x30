//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb26.v                                                   ////
////                                                              ////
////                                                              ////
////  This26 file is part of the "UART26 16550 compatible26" project26    ////
////  http26://www26.opencores26.org26/cores26/uart1655026/                   ////
////                                                              ////
////  Documentation26 related26 to this project26:                      ////
////  - http26://www26.opencores26.org26/cores26/uart1655026/                 ////
////                                                              ////
////  Projects26 compatibility26:                                     ////
////  - WISHBONE26                                                  ////
////  RS23226 Protocol26                                              ////
////  16550D uart26 (mostly26 supported)                              ////
////                                                              ////
////  Overview26 (main26 Features26):                                   ////
////  UART26 core26 WISHBONE26 interface.                               ////
////                                                              ////
////  Known26 problems26 (limits26):                                    ////
////  Inserts26 one wait state on all transfers26.                    ////
////  Note26 affected26 signals26 and the way26 they are affected26.        ////
////                                                              ////
////  To26 Do26:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author26(s):                                                  ////
////      - gorban26@opencores26.org26                                  ////
////      - Jacob26 Gorban26                                          ////
////      - Igor26 Mohor26 (igorm26@opencores26.org26)                      ////
////                                                              ////
////  Created26:        2001/05/12                                  ////
////  Last26 Updated26:   2001/05/17                                  ////
////                  (See log26 for the revision26 history26)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2000, 2001 Authors26                             ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS26 Revision26 History26
//
// $Log: not supported by cvs2svn26 $
// Revision26 1.16  2002/07/29 21:16:18  gorban26
// The uart_defines26.v file is included26 again26 in sources26.
//
// Revision26 1.15  2002/07/22 23:02:23  gorban26
// Bug26 Fixes26:
//  * Possible26 loss of sync and bad26 reception26 of stop bit on slow26 baud26 rates26 fixed26.
//   Problem26 reported26 by Kenny26.Tung26.
//  * Bad (or lack26 of ) loopback26 handling26 fixed26. Reported26 by Cherry26 Withers26.
//
// Improvements26:
//  * Made26 FIFO's as general26 inferrable26 memory where possible26.
//  So26 on FPGA26 they should be inferred26 as RAM26 (Distributed26 RAM26 on Xilinx26).
//  This26 saves26 about26 1/3 of the Slice26 count and reduces26 P&R and synthesis26 times.
//
//  * Added26 optional26 baudrate26 output (baud_o26).
//  This26 is identical26 to BAUDOUT26* signal26 on 16550 chip26.
//  It outputs26 16xbit_clock_rate - the divided26 clock26.
//  It's disabled by default. Define26 UART_HAS_BAUDRATE_OUTPUT26 to use.
//
// Revision26 1.12  2001/12/19 08:03:34  mohor26
// Warnings26 cleared26.
//
// Revision26 1.11  2001/12/06 14:51:04  gorban26
// Bug26 in LSR26[0] is fixed26.
// All WISHBONE26 signals26 are now sampled26, so another26 wait-state is introduced26 on all transfers26.
//
// Revision26 1.10  2001/12/03 21:44:29  gorban26
// Updated26 specification26 documentation.
// Added26 full 32-bit data bus interface, now as default.
// Address is 5-bit wide26 in 32-bit data bus mode.
// Added26 wb_sel_i26 input to the core26. It's used in the 32-bit mode.
// Added26 debug26 interface with two26 32-bit read-only registers in 32-bit mode.
// Bits26 5 and 6 of LSR26 are now only cleared26 on TX26 FIFO write.
// My26 small test bench26 is modified to work26 with 32-bit mode.
//
// Revision26 1.9  2001/10/20 09:58:40  gorban26
// Small26 synopsis26 fixes26
//
// Revision26 1.8  2001/08/24 21:01:12  mohor26
// Things26 connected26 to parity26 changed.
// Clock26 devider26 changed.
//
// Revision26 1.7  2001/08/23 16:05:05  mohor26
// Stop bit bug26 fixed26.
// Parity26 bug26 fixed26.
// WISHBONE26 read cycle bug26 fixed26,
// OE26 indicator26 (Overrun26 Error) bug26 fixed26.
// PE26 indicator26 (Parity26 Error) bug26 fixed26.
// Register read bug26 fixed26.
//
// Revision26 1.4  2001/05/31 20:08:01  gorban26
// FIFO changes26 and other corrections26.
//
// Revision26 1.3  2001/05/21 19:12:01  gorban26
// Corrected26 some26 Linter26 messages26.
//
// Revision26 1.2  2001/05/17 18:34:18  gorban26
// First26 'stable' release. Should26 be sythesizable26 now. Also26 added new header.
//
// Revision26 1.0  2001-05-17 21:27:13+02  jacob26
// Initial26 revision26
//
//

// UART26 core26 WISHBONE26 interface 
//
// Author26: Jacob26 Gorban26   (jacob26.gorban26@flextronicssemi26.com26)
// Company26: Flextronics26 Semiconductor26
//

// synopsys26 translate_off26
`include "timescale.v"
// synopsys26 translate_on26
`include "uart_defines26.v"
 
module uart_wb26 (clk26, wb_rst_i26, 
	wb_we_i26, wb_stb_i26, wb_cyc_i26, wb_ack_o26, wb_adr_i26,
	wb_adr_int26, wb_dat_i26, wb_dat_o26, wb_dat8_i26, wb_dat8_o26, wb_dat32_o26, wb_sel_i26,
	we_o26, re_o26 // Write and read enable output for the core26
);

input 		  clk26;

// WISHBONE26 interface	
input 		  wb_rst_i26;
input 		  wb_we_i26;
input 		  wb_stb_i26;
input 		  wb_cyc_i26;
input [3:0]   wb_sel_i26;
input [`UART_ADDR_WIDTH26-1:0] 	wb_adr_i26; //WISHBONE26 address line

`ifdef DATA_BUS_WIDTH_826
input [7:0]  wb_dat_i26; //input WISHBONE26 bus 
output [7:0] wb_dat_o26;
reg [7:0] 	 wb_dat_o26;
wire [7:0] 	 wb_dat_i26;
reg [7:0] 	 wb_dat_is26;
`else // for 32 data bus mode
input [31:0]  wb_dat_i26; //input WISHBONE26 bus 
output [31:0] wb_dat_o26;
reg [31:0] 	  wb_dat_o26;
wire [31:0]   wb_dat_i26;
reg [31:0] 	  wb_dat_is26;
`endif // !`ifdef DATA_BUS_WIDTH_826

output [`UART_ADDR_WIDTH26-1:0]	wb_adr_int26; // internal signal26 for address bus
input [7:0]   wb_dat8_o26; // internal 8 bit output to be put into wb_dat_o26
output [7:0]  wb_dat8_i26;
input [31:0]  wb_dat32_o26; // 32 bit data output (for debug26 interface)
output 		  wb_ack_o26;
output 		  we_o26;
output 		  re_o26;

wire 			  we_o26;
reg 			  wb_ack_o26;
reg [7:0] 	  wb_dat8_i26;
wire [7:0] 	  wb_dat8_o26;
wire [`UART_ADDR_WIDTH26-1:0]	wb_adr_int26; // internal signal26 for address bus
reg [`UART_ADDR_WIDTH26-1:0]	wb_adr_is26;
reg 								wb_we_is26;
reg 								wb_cyc_is26;
reg 								wb_stb_is26;
reg [3:0] 						wb_sel_is26;
wire [3:0]   wb_sel_i26;
reg 			 wre26 ;// timing26 control26 signal26 for write or read enable

// wb_ack_o26 FSM26
reg [1:0] 	 wbstate26;
always  @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) begin
		wb_ack_o26 <= #1 1'b0;
		wbstate26 <= #1 0;
		wre26 <= #1 1'b1;
	end else
		case (wbstate26)
			0: begin
				if (wb_stb_is26 & wb_cyc_is26) begin
					wre26 <= #1 0;
					wbstate26 <= #1 1;
					wb_ack_o26 <= #1 1;
				end else begin
					wre26 <= #1 1;
					wb_ack_o26 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o26 <= #1 0;
				wbstate26 <= #1 2;
				wre26 <= #1 0;
			end
			2,3: begin
				wb_ack_o26 <= #1 0;
				wbstate26 <= #1 0;
				wre26 <= #1 0;
			end
		endcase

assign we_o26 =  wb_we_is26 & wb_stb_is26 & wb_cyc_is26 & wre26 ; //WE26 for registers	
assign re_o26 = ~wb_we_is26 & wb_stb_is26 & wb_cyc_is26 & wre26 ; //RE26 for registers	

// Sample26 input signals26
always  @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26) begin
		wb_adr_is26 <= #1 0;
		wb_we_is26 <= #1 0;
		wb_cyc_is26 <= #1 0;
		wb_stb_is26 <= #1 0;
		wb_dat_is26 <= #1 0;
		wb_sel_is26 <= #1 0;
	end else begin
		wb_adr_is26 <= #1 wb_adr_i26;
		wb_we_is26 <= #1 wb_we_i26;
		wb_cyc_is26 <= #1 wb_cyc_i26;
		wb_stb_is26 <= #1 wb_stb_i26;
		wb_dat_is26 <= #1 wb_dat_i26;
		wb_sel_is26 <= #1 wb_sel_i26;
	end

`ifdef DATA_BUS_WIDTH_826 // 8-bit data bus
always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26)
		wb_dat_o26 <= #1 0;
	else
		wb_dat_o26 <= #1 wb_dat8_o26;

always @(wb_dat_is26)
	wb_dat8_i26 = wb_dat_is26;

assign wb_adr_int26 = wb_adr_is26;

`else // 32-bit bus
// put output to the correct26 byte in 32 bits using select26 line
always @(posedge clk26 or posedge wb_rst_i26)
	if (wb_rst_i26)
		wb_dat_o26 <= #1 0;
	else if (re_o26)
		case (wb_sel_is26)
			4'b0001: wb_dat_o26 <= #1 {24'b0, wb_dat8_o26};
			4'b0010: wb_dat_o26 <= #1 {16'b0, wb_dat8_o26, 8'b0};
			4'b0100: wb_dat_o26 <= #1 {8'b0, wb_dat8_o26, 16'b0};
			4'b1000: wb_dat_o26 <= #1 {wb_dat8_o26, 24'b0};
			4'b1111: wb_dat_o26 <= #1 wb_dat32_o26; // debug26 interface output
 			default: wb_dat_o26 <= #1 0;
		endcase // case(wb_sel_i26)

reg [1:0] wb_adr_int_lsb26;

always @(wb_sel_is26 or wb_dat_is26)
begin
	case (wb_sel_is26)
		4'b0001 : wb_dat8_i26 = wb_dat_is26[7:0];
		4'b0010 : wb_dat8_i26 = wb_dat_is26[15:8];
		4'b0100 : wb_dat8_i26 = wb_dat_is26[23:16];
		4'b1000 : wb_dat8_i26 = wb_dat_is26[31:24];
		default : wb_dat8_i26 = wb_dat_is26[7:0];
	endcase // case(wb_sel_i26)

  `ifdef LITLE_ENDIAN26
	case (wb_sel_is26)
		4'b0001 : wb_adr_int_lsb26 = 2'h0;
		4'b0010 : wb_adr_int_lsb26 = 2'h1;
		4'b0100 : wb_adr_int_lsb26 = 2'h2;
		4'b1000 : wb_adr_int_lsb26 = 2'h3;
		default : wb_adr_int_lsb26 = 2'h0;
	endcase // case(wb_sel_i26)
  `else
	case (wb_sel_is26)
		4'b0001 : wb_adr_int_lsb26 = 2'h3;
		4'b0010 : wb_adr_int_lsb26 = 2'h2;
		4'b0100 : wb_adr_int_lsb26 = 2'h1;
		4'b1000 : wb_adr_int_lsb26 = 2'h0;
		default : wb_adr_int_lsb26 = 2'h0;
	endcase // case(wb_sel_i26)
  `endif
end

assign wb_adr_int26 = {wb_adr_is26[`UART_ADDR_WIDTH26-1:2], wb_adr_int_lsb26};

`endif // !`ifdef DATA_BUS_WIDTH_826

endmodule










