//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb21.v                                                   ////
////                                                              ////
////                                                              ////
////  This21 file is part of the "UART21 16550 compatible21" project21    ////
////  http21://www21.opencores21.org21/cores21/uart1655021/                   ////
////                                                              ////
////  Documentation21 related21 to this project21:                      ////
////  - http21://www21.opencores21.org21/cores21/uart1655021/                 ////
////                                                              ////
////  Projects21 compatibility21:                                     ////
////  - WISHBONE21                                                  ////
////  RS23221 Protocol21                                              ////
////  16550D uart21 (mostly21 supported)                              ////
////                                                              ////
////  Overview21 (main21 Features21):                                   ////
////  UART21 core21 WISHBONE21 interface.                               ////
////                                                              ////
////  Known21 problems21 (limits21):                                    ////
////  Inserts21 one wait state on all transfers21.                    ////
////  Note21 affected21 signals21 and the way21 they are affected21.        ////
////                                                              ////
////  To21 Do21:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author21(s):                                                  ////
////      - gorban21@opencores21.org21                                  ////
////      - Jacob21 Gorban21                                          ////
////      - Igor21 Mohor21 (igorm21@opencores21.org21)                      ////
////                                                              ////
////  Created21:        2001/05/12                                  ////
////  Last21 Updated21:   2001/05/17                                  ////
////                  (See log21 for the revision21 history21)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2000, 2001 Authors21                             ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS21 Revision21 History21
//
// $Log: not supported by cvs2svn21 $
// Revision21 1.16  2002/07/29 21:16:18  gorban21
// The uart_defines21.v file is included21 again21 in sources21.
//
// Revision21 1.15  2002/07/22 23:02:23  gorban21
// Bug21 Fixes21:
//  * Possible21 loss of sync and bad21 reception21 of stop bit on slow21 baud21 rates21 fixed21.
//   Problem21 reported21 by Kenny21.Tung21.
//  * Bad (or lack21 of ) loopback21 handling21 fixed21. Reported21 by Cherry21 Withers21.
//
// Improvements21:
//  * Made21 FIFO's as general21 inferrable21 memory where possible21.
//  So21 on FPGA21 they should be inferred21 as RAM21 (Distributed21 RAM21 on Xilinx21).
//  This21 saves21 about21 1/3 of the Slice21 count and reduces21 P&R and synthesis21 times.
//
//  * Added21 optional21 baudrate21 output (baud_o21).
//  This21 is identical21 to BAUDOUT21* signal21 on 16550 chip21.
//  It outputs21 16xbit_clock_rate - the divided21 clock21.
//  It's disabled by default. Define21 UART_HAS_BAUDRATE_OUTPUT21 to use.
//
// Revision21 1.12  2001/12/19 08:03:34  mohor21
// Warnings21 cleared21.
//
// Revision21 1.11  2001/12/06 14:51:04  gorban21
// Bug21 in LSR21[0] is fixed21.
// All WISHBONE21 signals21 are now sampled21, so another21 wait-state is introduced21 on all transfers21.
//
// Revision21 1.10  2001/12/03 21:44:29  gorban21
// Updated21 specification21 documentation.
// Added21 full 32-bit data bus interface, now as default.
// Address is 5-bit wide21 in 32-bit data bus mode.
// Added21 wb_sel_i21 input to the core21. It's used in the 32-bit mode.
// Added21 debug21 interface with two21 32-bit read-only registers in 32-bit mode.
// Bits21 5 and 6 of LSR21 are now only cleared21 on TX21 FIFO write.
// My21 small test bench21 is modified to work21 with 32-bit mode.
//
// Revision21 1.9  2001/10/20 09:58:40  gorban21
// Small21 synopsis21 fixes21
//
// Revision21 1.8  2001/08/24 21:01:12  mohor21
// Things21 connected21 to parity21 changed.
// Clock21 devider21 changed.
//
// Revision21 1.7  2001/08/23 16:05:05  mohor21
// Stop bit bug21 fixed21.
// Parity21 bug21 fixed21.
// WISHBONE21 read cycle bug21 fixed21,
// OE21 indicator21 (Overrun21 Error) bug21 fixed21.
// PE21 indicator21 (Parity21 Error) bug21 fixed21.
// Register read bug21 fixed21.
//
// Revision21 1.4  2001/05/31 20:08:01  gorban21
// FIFO changes21 and other corrections21.
//
// Revision21 1.3  2001/05/21 19:12:01  gorban21
// Corrected21 some21 Linter21 messages21.
//
// Revision21 1.2  2001/05/17 18:34:18  gorban21
// First21 'stable' release. Should21 be sythesizable21 now. Also21 added new header.
//
// Revision21 1.0  2001-05-17 21:27:13+02  jacob21
// Initial21 revision21
//
//

// UART21 core21 WISHBONE21 interface 
//
// Author21: Jacob21 Gorban21   (jacob21.gorban21@flextronicssemi21.com21)
// Company21: Flextronics21 Semiconductor21
//

// synopsys21 translate_off21
`include "timescale.v"
// synopsys21 translate_on21
`include "uart_defines21.v"
 
module uart_wb21 (clk21, wb_rst_i21, 
	wb_we_i21, wb_stb_i21, wb_cyc_i21, wb_ack_o21, wb_adr_i21,
	wb_adr_int21, wb_dat_i21, wb_dat_o21, wb_dat8_i21, wb_dat8_o21, wb_dat32_o21, wb_sel_i21,
	we_o21, re_o21 // Write and read enable output for the core21
);

input 		  clk21;

// WISHBONE21 interface	
input 		  wb_rst_i21;
input 		  wb_we_i21;
input 		  wb_stb_i21;
input 		  wb_cyc_i21;
input [3:0]   wb_sel_i21;
input [`UART_ADDR_WIDTH21-1:0] 	wb_adr_i21; //WISHBONE21 address line

`ifdef DATA_BUS_WIDTH_821
input [7:0]  wb_dat_i21; //input WISHBONE21 bus 
output [7:0] wb_dat_o21;
reg [7:0] 	 wb_dat_o21;
wire [7:0] 	 wb_dat_i21;
reg [7:0] 	 wb_dat_is21;
`else // for 32 data bus mode
input [31:0]  wb_dat_i21; //input WISHBONE21 bus 
output [31:0] wb_dat_o21;
reg [31:0] 	  wb_dat_o21;
wire [31:0]   wb_dat_i21;
reg [31:0] 	  wb_dat_is21;
`endif // !`ifdef DATA_BUS_WIDTH_821

output [`UART_ADDR_WIDTH21-1:0]	wb_adr_int21; // internal signal21 for address bus
input [7:0]   wb_dat8_o21; // internal 8 bit output to be put into wb_dat_o21
output [7:0]  wb_dat8_i21;
input [31:0]  wb_dat32_o21; // 32 bit data output (for debug21 interface)
output 		  wb_ack_o21;
output 		  we_o21;
output 		  re_o21;

wire 			  we_o21;
reg 			  wb_ack_o21;
reg [7:0] 	  wb_dat8_i21;
wire [7:0] 	  wb_dat8_o21;
wire [`UART_ADDR_WIDTH21-1:0]	wb_adr_int21; // internal signal21 for address bus
reg [`UART_ADDR_WIDTH21-1:0]	wb_adr_is21;
reg 								wb_we_is21;
reg 								wb_cyc_is21;
reg 								wb_stb_is21;
reg [3:0] 						wb_sel_is21;
wire [3:0]   wb_sel_i21;
reg 			 wre21 ;// timing21 control21 signal21 for write or read enable

// wb_ack_o21 FSM21
reg [1:0] 	 wbstate21;
always  @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) begin
		wb_ack_o21 <= #1 1'b0;
		wbstate21 <= #1 0;
		wre21 <= #1 1'b1;
	end else
		case (wbstate21)
			0: begin
				if (wb_stb_is21 & wb_cyc_is21) begin
					wre21 <= #1 0;
					wbstate21 <= #1 1;
					wb_ack_o21 <= #1 1;
				end else begin
					wre21 <= #1 1;
					wb_ack_o21 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o21 <= #1 0;
				wbstate21 <= #1 2;
				wre21 <= #1 0;
			end
			2,3: begin
				wb_ack_o21 <= #1 0;
				wbstate21 <= #1 0;
				wre21 <= #1 0;
			end
		endcase

assign we_o21 =  wb_we_is21 & wb_stb_is21 & wb_cyc_is21 & wre21 ; //WE21 for registers	
assign re_o21 = ~wb_we_is21 & wb_stb_is21 & wb_cyc_is21 & wre21 ; //RE21 for registers	

// Sample21 input signals21
always  @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21) begin
		wb_adr_is21 <= #1 0;
		wb_we_is21 <= #1 0;
		wb_cyc_is21 <= #1 0;
		wb_stb_is21 <= #1 0;
		wb_dat_is21 <= #1 0;
		wb_sel_is21 <= #1 0;
	end else begin
		wb_adr_is21 <= #1 wb_adr_i21;
		wb_we_is21 <= #1 wb_we_i21;
		wb_cyc_is21 <= #1 wb_cyc_i21;
		wb_stb_is21 <= #1 wb_stb_i21;
		wb_dat_is21 <= #1 wb_dat_i21;
		wb_sel_is21 <= #1 wb_sel_i21;
	end

`ifdef DATA_BUS_WIDTH_821 // 8-bit data bus
always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21)
		wb_dat_o21 <= #1 0;
	else
		wb_dat_o21 <= #1 wb_dat8_o21;

always @(wb_dat_is21)
	wb_dat8_i21 = wb_dat_is21;

assign wb_adr_int21 = wb_adr_is21;

`else // 32-bit bus
// put output to the correct21 byte in 32 bits using select21 line
always @(posedge clk21 or posedge wb_rst_i21)
	if (wb_rst_i21)
		wb_dat_o21 <= #1 0;
	else if (re_o21)
		case (wb_sel_is21)
			4'b0001: wb_dat_o21 <= #1 {24'b0, wb_dat8_o21};
			4'b0010: wb_dat_o21 <= #1 {16'b0, wb_dat8_o21, 8'b0};
			4'b0100: wb_dat_o21 <= #1 {8'b0, wb_dat8_o21, 16'b0};
			4'b1000: wb_dat_o21 <= #1 {wb_dat8_o21, 24'b0};
			4'b1111: wb_dat_o21 <= #1 wb_dat32_o21; // debug21 interface output
 			default: wb_dat_o21 <= #1 0;
		endcase // case(wb_sel_i21)

reg [1:0] wb_adr_int_lsb21;

always @(wb_sel_is21 or wb_dat_is21)
begin
	case (wb_sel_is21)
		4'b0001 : wb_dat8_i21 = wb_dat_is21[7:0];
		4'b0010 : wb_dat8_i21 = wb_dat_is21[15:8];
		4'b0100 : wb_dat8_i21 = wb_dat_is21[23:16];
		4'b1000 : wb_dat8_i21 = wb_dat_is21[31:24];
		default : wb_dat8_i21 = wb_dat_is21[7:0];
	endcase // case(wb_sel_i21)

  `ifdef LITLE_ENDIAN21
	case (wb_sel_is21)
		4'b0001 : wb_adr_int_lsb21 = 2'h0;
		4'b0010 : wb_adr_int_lsb21 = 2'h1;
		4'b0100 : wb_adr_int_lsb21 = 2'h2;
		4'b1000 : wb_adr_int_lsb21 = 2'h3;
		default : wb_adr_int_lsb21 = 2'h0;
	endcase // case(wb_sel_i21)
  `else
	case (wb_sel_is21)
		4'b0001 : wb_adr_int_lsb21 = 2'h3;
		4'b0010 : wb_adr_int_lsb21 = 2'h2;
		4'b0100 : wb_adr_int_lsb21 = 2'h1;
		4'b1000 : wb_adr_int_lsb21 = 2'h0;
		default : wb_adr_int_lsb21 = 2'h0;
	endcase // case(wb_sel_i21)
  `endif
end

assign wb_adr_int21 = {wb_adr_is21[`UART_ADDR_WIDTH21-1:2], wb_adr_int_lsb21};

`endif // !`ifdef DATA_BUS_WIDTH_821

endmodule










