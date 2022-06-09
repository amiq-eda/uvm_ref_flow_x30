//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb5.v                                                   ////
////                                                              ////
////                                                              ////
////  This5 file is part of the "UART5 16550 compatible5" project5    ////
////  http5://www5.opencores5.org5/cores5/uart165505/                   ////
////                                                              ////
////  Documentation5 related5 to this project5:                      ////
////  - http5://www5.opencores5.org5/cores5/uart165505/                 ////
////                                                              ////
////  Projects5 compatibility5:                                     ////
////  - WISHBONE5                                                  ////
////  RS2325 Protocol5                                              ////
////  16550D uart5 (mostly5 supported)                              ////
////                                                              ////
////  Overview5 (main5 Features5):                                   ////
////  UART5 core5 WISHBONE5 interface.                               ////
////                                                              ////
////  Known5 problems5 (limits5):                                    ////
////  Inserts5 one wait state on all transfers5.                    ////
////  Note5 affected5 signals5 and the way5 they are affected5.        ////
////                                                              ////
////  To5 Do5:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author5(s):                                                  ////
////      - gorban5@opencores5.org5                                  ////
////      - Jacob5 Gorban5                                          ////
////      - Igor5 Mohor5 (igorm5@opencores5.org5)                      ////
////                                                              ////
////  Created5:        2001/05/12                                  ////
////  Last5 Updated5:   2001/05/17                                  ////
////                  (See log5 for the revision5 history5)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2000, 2001 Authors5                             ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS5 Revision5 History5
//
// $Log: not supported by cvs2svn5 $
// Revision5 1.16  2002/07/29 21:16:18  gorban5
// The uart_defines5.v file is included5 again5 in sources5.
//
// Revision5 1.15  2002/07/22 23:02:23  gorban5
// Bug5 Fixes5:
//  * Possible5 loss of sync and bad5 reception5 of stop bit on slow5 baud5 rates5 fixed5.
//   Problem5 reported5 by Kenny5.Tung5.
//  * Bad (or lack5 of ) loopback5 handling5 fixed5. Reported5 by Cherry5 Withers5.
//
// Improvements5:
//  * Made5 FIFO's as general5 inferrable5 memory where possible5.
//  So5 on FPGA5 they should be inferred5 as RAM5 (Distributed5 RAM5 on Xilinx5).
//  This5 saves5 about5 1/3 of the Slice5 count and reduces5 P&R and synthesis5 times.
//
//  * Added5 optional5 baudrate5 output (baud_o5).
//  This5 is identical5 to BAUDOUT5* signal5 on 16550 chip5.
//  It outputs5 16xbit_clock_rate - the divided5 clock5.
//  It's disabled by default. Define5 UART_HAS_BAUDRATE_OUTPUT5 to use.
//
// Revision5 1.12  2001/12/19 08:03:34  mohor5
// Warnings5 cleared5.
//
// Revision5 1.11  2001/12/06 14:51:04  gorban5
// Bug5 in LSR5[0] is fixed5.
// All WISHBONE5 signals5 are now sampled5, so another5 wait-state is introduced5 on all transfers5.
//
// Revision5 1.10  2001/12/03 21:44:29  gorban5
// Updated5 specification5 documentation.
// Added5 full 32-bit data bus interface, now as default.
// Address is 5-bit wide5 in 32-bit data bus mode.
// Added5 wb_sel_i5 input to the core5. It's used in the 32-bit mode.
// Added5 debug5 interface with two5 32-bit read-only registers in 32-bit mode.
// Bits5 5 and 6 of LSR5 are now only cleared5 on TX5 FIFO write.
// My5 small test bench5 is modified to work5 with 32-bit mode.
//
// Revision5 1.9  2001/10/20 09:58:40  gorban5
// Small5 synopsis5 fixes5
//
// Revision5 1.8  2001/08/24 21:01:12  mohor5
// Things5 connected5 to parity5 changed.
// Clock5 devider5 changed.
//
// Revision5 1.7  2001/08/23 16:05:05  mohor5
// Stop bit bug5 fixed5.
// Parity5 bug5 fixed5.
// WISHBONE5 read cycle bug5 fixed5,
// OE5 indicator5 (Overrun5 Error) bug5 fixed5.
// PE5 indicator5 (Parity5 Error) bug5 fixed5.
// Register read bug5 fixed5.
//
// Revision5 1.4  2001/05/31 20:08:01  gorban5
// FIFO changes5 and other corrections5.
//
// Revision5 1.3  2001/05/21 19:12:01  gorban5
// Corrected5 some5 Linter5 messages5.
//
// Revision5 1.2  2001/05/17 18:34:18  gorban5
// First5 'stable' release. Should5 be sythesizable5 now. Also5 added new header.
//
// Revision5 1.0  2001-05-17 21:27:13+02  jacob5
// Initial5 revision5
//
//

// UART5 core5 WISHBONE5 interface 
//
// Author5: Jacob5 Gorban5   (jacob5.gorban5@flextronicssemi5.com5)
// Company5: Flextronics5 Semiconductor5
//

// synopsys5 translate_off5
`include "timescale.v"
// synopsys5 translate_on5
`include "uart_defines5.v"
 
module uart_wb5 (clk5, wb_rst_i5, 
	wb_we_i5, wb_stb_i5, wb_cyc_i5, wb_ack_o5, wb_adr_i5,
	wb_adr_int5, wb_dat_i5, wb_dat_o5, wb_dat8_i5, wb_dat8_o5, wb_dat32_o5, wb_sel_i5,
	we_o5, re_o5 // Write and read enable output for the core5
);

input 		  clk5;

// WISHBONE5 interface	
input 		  wb_rst_i5;
input 		  wb_we_i5;
input 		  wb_stb_i5;
input 		  wb_cyc_i5;
input [3:0]   wb_sel_i5;
input [`UART_ADDR_WIDTH5-1:0] 	wb_adr_i5; //WISHBONE5 address line

`ifdef DATA_BUS_WIDTH_85
input [7:0]  wb_dat_i5; //input WISHBONE5 bus 
output [7:0] wb_dat_o5;
reg [7:0] 	 wb_dat_o5;
wire [7:0] 	 wb_dat_i5;
reg [7:0] 	 wb_dat_is5;
`else // for 32 data bus mode
input [31:0]  wb_dat_i5; //input WISHBONE5 bus 
output [31:0] wb_dat_o5;
reg [31:0] 	  wb_dat_o5;
wire [31:0]   wb_dat_i5;
reg [31:0] 	  wb_dat_is5;
`endif // !`ifdef DATA_BUS_WIDTH_85

output [`UART_ADDR_WIDTH5-1:0]	wb_adr_int5; // internal signal5 for address bus
input [7:0]   wb_dat8_o5; // internal 8 bit output to be put into wb_dat_o5
output [7:0]  wb_dat8_i5;
input [31:0]  wb_dat32_o5; // 32 bit data output (for debug5 interface)
output 		  wb_ack_o5;
output 		  we_o5;
output 		  re_o5;

wire 			  we_o5;
reg 			  wb_ack_o5;
reg [7:0] 	  wb_dat8_i5;
wire [7:0] 	  wb_dat8_o5;
wire [`UART_ADDR_WIDTH5-1:0]	wb_adr_int5; // internal signal5 for address bus
reg [`UART_ADDR_WIDTH5-1:0]	wb_adr_is5;
reg 								wb_we_is5;
reg 								wb_cyc_is5;
reg 								wb_stb_is5;
reg [3:0] 						wb_sel_is5;
wire [3:0]   wb_sel_i5;
reg 			 wre5 ;// timing5 control5 signal5 for write or read enable

// wb_ack_o5 FSM5
reg [1:0] 	 wbstate5;
always  @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) begin
		wb_ack_o5 <= #1 1'b0;
		wbstate5 <= #1 0;
		wre5 <= #1 1'b1;
	end else
		case (wbstate5)
			0: begin
				if (wb_stb_is5 & wb_cyc_is5) begin
					wre5 <= #1 0;
					wbstate5 <= #1 1;
					wb_ack_o5 <= #1 1;
				end else begin
					wre5 <= #1 1;
					wb_ack_o5 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o5 <= #1 0;
				wbstate5 <= #1 2;
				wre5 <= #1 0;
			end
			2,3: begin
				wb_ack_o5 <= #1 0;
				wbstate5 <= #1 0;
				wre5 <= #1 0;
			end
		endcase

assign we_o5 =  wb_we_is5 & wb_stb_is5 & wb_cyc_is5 & wre5 ; //WE5 for registers	
assign re_o5 = ~wb_we_is5 & wb_stb_is5 & wb_cyc_is5 & wre5 ; //RE5 for registers	

// Sample5 input signals5
always  @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5) begin
		wb_adr_is5 <= #1 0;
		wb_we_is5 <= #1 0;
		wb_cyc_is5 <= #1 0;
		wb_stb_is5 <= #1 0;
		wb_dat_is5 <= #1 0;
		wb_sel_is5 <= #1 0;
	end else begin
		wb_adr_is5 <= #1 wb_adr_i5;
		wb_we_is5 <= #1 wb_we_i5;
		wb_cyc_is5 <= #1 wb_cyc_i5;
		wb_stb_is5 <= #1 wb_stb_i5;
		wb_dat_is5 <= #1 wb_dat_i5;
		wb_sel_is5 <= #1 wb_sel_i5;
	end

`ifdef DATA_BUS_WIDTH_85 // 8-bit data bus
always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5)
		wb_dat_o5 <= #1 0;
	else
		wb_dat_o5 <= #1 wb_dat8_o5;

always @(wb_dat_is5)
	wb_dat8_i5 = wb_dat_is5;

assign wb_adr_int5 = wb_adr_is5;

`else // 32-bit bus
// put output to the correct5 byte in 32 bits using select5 line
always @(posedge clk5 or posedge wb_rst_i5)
	if (wb_rst_i5)
		wb_dat_o5 <= #1 0;
	else if (re_o5)
		case (wb_sel_is5)
			4'b0001: wb_dat_o5 <= #1 {24'b0, wb_dat8_o5};
			4'b0010: wb_dat_o5 <= #1 {16'b0, wb_dat8_o5, 8'b0};
			4'b0100: wb_dat_o5 <= #1 {8'b0, wb_dat8_o5, 16'b0};
			4'b1000: wb_dat_o5 <= #1 {wb_dat8_o5, 24'b0};
			4'b1111: wb_dat_o5 <= #1 wb_dat32_o5; // debug5 interface output
 			default: wb_dat_o5 <= #1 0;
		endcase // case(wb_sel_i5)

reg [1:0] wb_adr_int_lsb5;

always @(wb_sel_is5 or wb_dat_is5)
begin
	case (wb_sel_is5)
		4'b0001 : wb_dat8_i5 = wb_dat_is5[7:0];
		4'b0010 : wb_dat8_i5 = wb_dat_is5[15:8];
		4'b0100 : wb_dat8_i5 = wb_dat_is5[23:16];
		4'b1000 : wb_dat8_i5 = wb_dat_is5[31:24];
		default : wb_dat8_i5 = wb_dat_is5[7:0];
	endcase // case(wb_sel_i5)

  `ifdef LITLE_ENDIAN5
	case (wb_sel_is5)
		4'b0001 : wb_adr_int_lsb5 = 2'h0;
		4'b0010 : wb_adr_int_lsb5 = 2'h1;
		4'b0100 : wb_adr_int_lsb5 = 2'h2;
		4'b1000 : wb_adr_int_lsb5 = 2'h3;
		default : wb_adr_int_lsb5 = 2'h0;
	endcase // case(wb_sel_i5)
  `else
	case (wb_sel_is5)
		4'b0001 : wb_adr_int_lsb5 = 2'h3;
		4'b0010 : wb_adr_int_lsb5 = 2'h2;
		4'b0100 : wb_adr_int_lsb5 = 2'h1;
		4'b1000 : wb_adr_int_lsb5 = 2'h0;
		default : wb_adr_int_lsb5 = 2'h0;
	endcase // case(wb_sel_i5)
  `endif
end

assign wb_adr_int5 = {wb_adr_is5[`UART_ADDR_WIDTH5-1:2], wb_adr_int_lsb5};

`endif // !`ifdef DATA_BUS_WIDTH_85

endmodule










