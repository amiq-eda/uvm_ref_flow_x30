//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb28.v                                                   ////
////                                                              ////
////                                                              ////
////  This28 file is part of the "UART28 16550 compatible28" project28    ////
////  http28://www28.opencores28.org28/cores28/uart1655028/                   ////
////                                                              ////
////  Documentation28 related28 to this project28:                      ////
////  - http28://www28.opencores28.org28/cores28/uart1655028/                 ////
////                                                              ////
////  Projects28 compatibility28:                                     ////
////  - WISHBONE28                                                  ////
////  RS23228 Protocol28                                              ////
////  16550D uart28 (mostly28 supported)                              ////
////                                                              ////
////  Overview28 (main28 Features28):                                   ////
////  UART28 core28 WISHBONE28 interface.                               ////
////                                                              ////
////  Known28 problems28 (limits28):                                    ////
////  Inserts28 one wait state on all transfers28.                    ////
////  Note28 affected28 signals28 and the way28 they are affected28.        ////
////                                                              ////
////  To28 Do28:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author28(s):                                                  ////
////      - gorban28@opencores28.org28                                  ////
////      - Jacob28 Gorban28                                          ////
////      - Igor28 Mohor28 (igorm28@opencores28.org28)                      ////
////                                                              ////
////  Created28:        2001/05/12                                  ////
////  Last28 Updated28:   2001/05/17                                  ////
////                  (See log28 for the revision28 history28)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2000, 2001 Authors28                             ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS28 Revision28 History28
//
// $Log: not supported by cvs2svn28 $
// Revision28 1.16  2002/07/29 21:16:18  gorban28
// The uart_defines28.v file is included28 again28 in sources28.
//
// Revision28 1.15  2002/07/22 23:02:23  gorban28
// Bug28 Fixes28:
//  * Possible28 loss of sync and bad28 reception28 of stop bit on slow28 baud28 rates28 fixed28.
//   Problem28 reported28 by Kenny28.Tung28.
//  * Bad (or lack28 of ) loopback28 handling28 fixed28. Reported28 by Cherry28 Withers28.
//
// Improvements28:
//  * Made28 FIFO's as general28 inferrable28 memory where possible28.
//  So28 on FPGA28 they should be inferred28 as RAM28 (Distributed28 RAM28 on Xilinx28).
//  This28 saves28 about28 1/3 of the Slice28 count and reduces28 P&R and synthesis28 times.
//
//  * Added28 optional28 baudrate28 output (baud_o28).
//  This28 is identical28 to BAUDOUT28* signal28 on 16550 chip28.
//  It outputs28 16xbit_clock_rate - the divided28 clock28.
//  It's disabled by default. Define28 UART_HAS_BAUDRATE_OUTPUT28 to use.
//
// Revision28 1.12  2001/12/19 08:03:34  mohor28
// Warnings28 cleared28.
//
// Revision28 1.11  2001/12/06 14:51:04  gorban28
// Bug28 in LSR28[0] is fixed28.
// All WISHBONE28 signals28 are now sampled28, so another28 wait-state is introduced28 on all transfers28.
//
// Revision28 1.10  2001/12/03 21:44:29  gorban28
// Updated28 specification28 documentation.
// Added28 full 32-bit data bus interface, now as default.
// Address is 5-bit wide28 in 32-bit data bus mode.
// Added28 wb_sel_i28 input to the core28. It's used in the 32-bit mode.
// Added28 debug28 interface with two28 32-bit read-only registers in 32-bit mode.
// Bits28 5 and 6 of LSR28 are now only cleared28 on TX28 FIFO write.
// My28 small test bench28 is modified to work28 with 32-bit mode.
//
// Revision28 1.9  2001/10/20 09:58:40  gorban28
// Small28 synopsis28 fixes28
//
// Revision28 1.8  2001/08/24 21:01:12  mohor28
// Things28 connected28 to parity28 changed.
// Clock28 devider28 changed.
//
// Revision28 1.7  2001/08/23 16:05:05  mohor28
// Stop bit bug28 fixed28.
// Parity28 bug28 fixed28.
// WISHBONE28 read cycle bug28 fixed28,
// OE28 indicator28 (Overrun28 Error) bug28 fixed28.
// PE28 indicator28 (Parity28 Error) bug28 fixed28.
// Register read bug28 fixed28.
//
// Revision28 1.4  2001/05/31 20:08:01  gorban28
// FIFO changes28 and other corrections28.
//
// Revision28 1.3  2001/05/21 19:12:01  gorban28
// Corrected28 some28 Linter28 messages28.
//
// Revision28 1.2  2001/05/17 18:34:18  gorban28
// First28 'stable' release. Should28 be sythesizable28 now. Also28 added new header.
//
// Revision28 1.0  2001-05-17 21:27:13+02  jacob28
// Initial28 revision28
//
//

// UART28 core28 WISHBONE28 interface 
//
// Author28: Jacob28 Gorban28   (jacob28.gorban28@flextronicssemi28.com28)
// Company28: Flextronics28 Semiconductor28
//

// synopsys28 translate_off28
`include "timescale.v"
// synopsys28 translate_on28
`include "uart_defines28.v"
 
module uart_wb28 (clk28, wb_rst_i28, 
	wb_we_i28, wb_stb_i28, wb_cyc_i28, wb_ack_o28, wb_adr_i28,
	wb_adr_int28, wb_dat_i28, wb_dat_o28, wb_dat8_i28, wb_dat8_o28, wb_dat32_o28, wb_sel_i28,
	we_o28, re_o28 // Write and read enable output for the core28
);

input 		  clk28;

// WISHBONE28 interface	
input 		  wb_rst_i28;
input 		  wb_we_i28;
input 		  wb_stb_i28;
input 		  wb_cyc_i28;
input [3:0]   wb_sel_i28;
input [`UART_ADDR_WIDTH28-1:0] 	wb_adr_i28; //WISHBONE28 address line

`ifdef DATA_BUS_WIDTH_828
input [7:0]  wb_dat_i28; //input WISHBONE28 bus 
output [7:0] wb_dat_o28;
reg [7:0] 	 wb_dat_o28;
wire [7:0] 	 wb_dat_i28;
reg [7:0] 	 wb_dat_is28;
`else // for 32 data bus mode
input [31:0]  wb_dat_i28; //input WISHBONE28 bus 
output [31:0] wb_dat_o28;
reg [31:0] 	  wb_dat_o28;
wire [31:0]   wb_dat_i28;
reg [31:0] 	  wb_dat_is28;
`endif // !`ifdef DATA_BUS_WIDTH_828

output [`UART_ADDR_WIDTH28-1:0]	wb_adr_int28; // internal signal28 for address bus
input [7:0]   wb_dat8_o28; // internal 8 bit output to be put into wb_dat_o28
output [7:0]  wb_dat8_i28;
input [31:0]  wb_dat32_o28; // 32 bit data output (for debug28 interface)
output 		  wb_ack_o28;
output 		  we_o28;
output 		  re_o28;

wire 			  we_o28;
reg 			  wb_ack_o28;
reg [7:0] 	  wb_dat8_i28;
wire [7:0] 	  wb_dat8_o28;
wire [`UART_ADDR_WIDTH28-1:0]	wb_adr_int28; // internal signal28 for address bus
reg [`UART_ADDR_WIDTH28-1:0]	wb_adr_is28;
reg 								wb_we_is28;
reg 								wb_cyc_is28;
reg 								wb_stb_is28;
reg [3:0] 						wb_sel_is28;
wire [3:0]   wb_sel_i28;
reg 			 wre28 ;// timing28 control28 signal28 for write or read enable

// wb_ack_o28 FSM28
reg [1:0] 	 wbstate28;
always  @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) begin
		wb_ack_o28 <= #1 1'b0;
		wbstate28 <= #1 0;
		wre28 <= #1 1'b1;
	end else
		case (wbstate28)
			0: begin
				if (wb_stb_is28 & wb_cyc_is28) begin
					wre28 <= #1 0;
					wbstate28 <= #1 1;
					wb_ack_o28 <= #1 1;
				end else begin
					wre28 <= #1 1;
					wb_ack_o28 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o28 <= #1 0;
				wbstate28 <= #1 2;
				wre28 <= #1 0;
			end
			2,3: begin
				wb_ack_o28 <= #1 0;
				wbstate28 <= #1 0;
				wre28 <= #1 0;
			end
		endcase

assign we_o28 =  wb_we_is28 & wb_stb_is28 & wb_cyc_is28 & wre28 ; //WE28 for registers	
assign re_o28 = ~wb_we_is28 & wb_stb_is28 & wb_cyc_is28 & wre28 ; //RE28 for registers	

// Sample28 input signals28
always  @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28) begin
		wb_adr_is28 <= #1 0;
		wb_we_is28 <= #1 0;
		wb_cyc_is28 <= #1 0;
		wb_stb_is28 <= #1 0;
		wb_dat_is28 <= #1 0;
		wb_sel_is28 <= #1 0;
	end else begin
		wb_adr_is28 <= #1 wb_adr_i28;
		wb_we_is28 <= #1 wb_we_i28;
		wb_cyc_is28 <= #1 wb_cyc_i28;
		wb_stb_is28 <= #1 wb_stb_i28;
		wb_dat_is28 <= #1 wb_dat_i28;
		wb_sel_is28 <= #1 wb_sel_i28;
	end

`ifdef DATA_BUS_WIDTH_828 // 8-bit data bus
always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28)
		wb_dat_o28 <= #1 0;
	else
		wb_dat_o28 <= #1 wb_dat8_o28;

always @(wb_dat_is28)
	wb_dat8_i28 = wb_dat_is28;

assign wb_adr_int28 = wb_adr_is28;

`else // 32-bit bus
// put output to the correct28 byte in 32 bits using select28 line
always @(posedge clk28 or posedge wb_rst_i28)
	if (wb_rst_i28)
		wb_dat_o28 <= #1 0;
	else if (re_o28)
		case (wb_sel_is28)
			4'b0001: wb_dat_o28 <= #1 {24'b0, wb_dat8_o28};
			4'b0010: wb_dat_o28 <= #1 {16'b0, wb_dat8_o28, 8'b0};
			4'b0100: wb_dat_o28 <= #1 {8'b0, wb_dat8_o28, 16'b0};
			4'b1000: wb_dat_o28 <= #1 {wb_dat8_o28, 24'b0};
			4'b1111: wb_dat_o28 <= #1 wb_dat32_o28; // debug28 interface output
 			default: wb_dat_o28 <= #1 0;
		endcase // case(wb_sel_i28)

reg [1:0] wb_adr_int_lsb28;

always @(wb_sel_is28 or wb_dat_is28)
begin
	case (wb_sel_is28)
		4'b0001 : wb_dat8_i28 = wb_dat_is28[7:0];
		4'b0010 : wb_dat8_i28 = wb_dat_is28[15:8];
		4'b0100 : wb_dat8_i28 = wb_dat_is28[23:16];
		4'b1000 : wb_dat8_i28 = wb_dat_is28[31:24];
		default : wb_dat8_i28 = wb_dat_is28[7:0];
	endcase // case(wb_sel_i28)

  `ifdef LITLE_ENDIAN28
	case (wb_sel_is28)
		4'b0001 : wb_adr_int_lsb28 = 2'h0;
		4'b0010 : wb_adr_int_lsb28 = 2'h1;
		4'b0100 : wb_adr_int_lsb28 = 2'h2;
		4'b1000 : wb_adr_int_lsb28 = 2'h3;
		default : wb_adr_int_lsb28 = 2'h0;
	endcase // case(wb_sel_i28)
  `else
	case (wb_sel_is28)
		4'b0001 : wb_adr_int_lsb28 = 2'h3;
		4'b0010 : wb_adr_int_lsb28 = 2'h2;
		4'b0100 : wb_adr_int_lsb28 = 2'h1;
		4'b1000 : wb_adr_int_lsb28 = 2'h0;
		default : wb_adr_int_lsb28 = 2'h0;
	endcase // case(wb_sel_i28)
  `endif
end

assign wb_adr_int28 = {wb_adr_is28[`UART_ADDR_WIDTH28-1:2], wb_adr_int_lsb28};

`endif // !`ifdef DATA_BUS_WIDTH_828

endmodule










