//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb30.v                                                   ////
////                                                              ////
////                                                              ////
////  This30 file is part of the "UART30 16550 compatible30" project30    ////
////  http30://www30.opencores30.org30/cores30/uart1655030/                   ////
////                                                              ////
////  Documentation30 related30 to this project30:                      ////
////  - http30://www30.opencores30.org30/cores30/uart1655030/                 ////
////                                                              ////
////  Projects30 compatibility30:                                     ////
////  - WISHBONE30                                                  ////
////  RS23230 Protocol30                                              ////
////  16550D uart30 (mostly30 supported)                              ////
////                                                              ////
////  Overview30 (main30 Features30):                                   ////
////  UART30 core30 WISHBONE30 interface.                               ////
////                                                              ////
////  Known30 problems30 (limits30):                                    ////
////  Inserts30 one wait state on all transfers30.                    ////
////  Note30 affected30 signals30 and the way30 they are affected30.        ////
////                                                              ////
////  To30 Do30:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author30(s):                                                  ////
////      - gorban30@opencores30.org30                                  ////
////      - Jacob30 Gorban30                                          ////
////      - Igor30 Mohor30 (igorm30@opencores30.org30)                      ////
////                                                              ////
////  Created30:        2001/05/12                                  ////
////  Last30 Updated30:   2001/05/17                                  ////
////                  (See log30 for the revision30 history30)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2000, 2001 Authors30                             ////
////                                                              ////
//// This30 source30 file may be used and distributed30 without         ////
//// restriction30 provided that this copyright30 statement30 is not    ////
//// removed from the file and that any derivative30 work30 contains30  ////
//// the original copyright30 notice30 and the associated disclaimer30. ////
////                                                              ////
//// This30 source30 file is free software30; you can redistribute30 it   ////
//// and/or modify it under the terms30 of the GNU30 Lesser30 General30   ////
//// Public30 License30 as published30 by the Free30 Software30 Foundation30; ////
//// either30 version30 2.1 of the License30, or (at your30 option) any   ////
//// later30 version30.                                               ////
////                                                              ////
//// This30 source30 is distributed30 in the hope30 that it will be       ////
//// useful30, but WITHOUT30 ANY30 WARRANTY30; without even30 the implied30   ////
//// warranty30 of MERCHANTABILITY30 or FITNESS30 FOR30 A PARTICULAR30      ////
//// PURPOSE30.  See the GNU30 Lesser30 General30 Public30 License30 for more ////
//// details30.                                                     ////
////                                                              ////
//// You should have received30 a copy of the GNU30 Lesser30 General30    ////
//// Public30 License30 along30 with this source30; if not, download30 it   ////
//// from http30://www30.opencores30.org30/lgpl30.shtml30                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS30 Revision30 History30
//
// $Log: not supported by cvs2svn30 $
// Revision30 1.16  2002/07/29 21:16:18  gorban30
// The uart_defines30.v file is included30 again30 in sources30.
//
// Revision30 1.15  2002/07/22 23:02:23  gorban30
// Bug30 Fixes30:
//  * Possible30 loss of sync and bad30 reception30 of stop bit on slow30 baud30 rates30 fixed30.
//   Problem30 reported30 by Kenny30.Tung30.
//  * Bad (or lack30 of ) loopback30 handling30 fixed30. Reported30 by Cherry30 Withers30.
//
// Improvements30:
//  * Made30 FIFO's as general30 inferrable30 memory where possible30.
//  So30 on FPGA30 they should be inferred30 as RAM30 (Distributed30 RAM30 on Xilinx30).
//  This30 saves30 about30 1/3 of the Slice30 count and reduces30 P&R and synthesis30 times.
//
//  * Added30 optional30 baudrate30 output (baud_o30).
//  This30 is identical30 to BAUDOUT30* signal30 on 16550 chip30.
//  It outputs30 16xbit_clock_rate - the divided30 clock30.
//  It's disabled by default. Define30 UART_HAS_BAUDRATE_OUTPUT30 to use.
//
// Revision30 1.12  2001/12/19 08:03:34  mohor30
// Warnings30 cleared30.
//
// Revision30 1.11  2001/12/06 14:51:04  gorban30
// Bug30 in LSR30[0] is fixed30.
// All WISHBONE30 signals30 are now sampled30, so another30 wait-state is introduced30 on all transfers30.
//
// Revision30 1.10  2001/12/03 21:44:29  gorban30
// Updated30 specification30 documentation.
// Added30 full 32-bit data bus interface, now as default.
// Address is 5-bit wide30 in 32-bit data bus mode.
// Added30 wb_sel_i30 input to the core30. It's used in the 32-bit mode.
// Added30 debug30 interface with two30 32-bit read-only registers in 32-bit mode.
// Bits30 5 and 6 of LSR30 are now only cleared30 on TX30 FIFO write.
// My30 small test bench30 is modified to work30 with 32-bit mode.
//
// Revision30 1.9  2001/10/20 09:58:40  gorban30
// Small30 synopsis30 fixes30
//
// Revision30 1.8  2001/08/24 21:01:12  mohor30
// Things30 connected30 to parity30 changed.
// Clock30 devider30 changed.
//
// Revision30 1.7  2001/08/23 16:05:05  mohor30
// Stop bit bug30 fixed30.
// Parity30 bug30 fixed30.
// WISHBONE30 read cycle bug30 fixed30,
// OE30 indicator30 (Overrun30 Error) bug30 fixed30.
// PE30 indicator30 (Parity30 Error) bug30 fixed30.
// Register read bug30 fixed30.
//
// Revision30 1.4  2001/05/31 20:08:01  gorban30
// FIFO changes30 and other corrections30.
//
// Revision30 1.3  2001/05/21 19:12:01  gorban30
// Corrected30 some30 Linter30 messages30.
//
// Revision30 1.2  2001/05/17 18:34:18  gorban30
// First30 'stable' release. Should30 be sythesizable30 now. Also30 added new header.
//
// Revision30 1.0  2001-05-17 21:27:13+02  jacob30
// Initial30 revision30
//
//

// UART30 core30 WISHBONE30 interface 
//
// Author30: Jacob30 Gorban30   (jacob30.gorban30@flextronicssemi30.com30)
// Company30: Flextronics30 Semiconductor30
//

// synopsys30 translate_off30
`include "timescale.v"
// synopsys30 translate_on30
`include "uart_defines30.v"
 
module uart_wb30 (clk30, wb_rst_i30, 
	wb_we_i30, wb_stb_i30, wb_cyc_i30, wb_ack_o30, wb_adr_i30,
	wb_adr_int30, wb_dat_i30, wb_dat_o30, wb_dat8_i30, wb_dat8_o30, wb_dat32_o30, wb_sel_i30,
	we_o30, re_o30 // Write and read enable output for the core30
);

input 		  clk30;

// WISHBONE30 interface	
input 		  wb_rst_i30;
input 		  wb_we_i30;
input 		  wb_stb_i30;
input 		  wb_cyc_i30;
input [3:0]   wb_sel_i30;
input [`UART_ADDR_WIDTH30-1:0] 	wb_adr_i30; //WISHBONE30 address line

`ifdef DATA_BUS_WIDTH_830
input [7:0]  wb_dat_i30; //input WISHBONE30 bus 
output [7:0] wb_dat_o30;
reg [7:0] 	 wb_dat_o30;
wire [7:0] 	 wb_dat_i30;
reg [7:0] 	 wb_dat_is30;
`else // for 32 data bus mode
input [31:0]  wb_dat_i30; //input WISHBONE30 bus 
output [31:0] wb_dat_o30;
reg [31:0] 	  wb_dat_o30;
wire [31:0]   wb_dat_i30;
reg [31:0] 	  wb_dat_is30;
`endif // !`ifdef DATA_BUS_WIDTH_830

output [`UART_ADDR_WIDTH30-1:0]	wb_adr_int30; // internal signal30 for address bus
input [7:0]   wb_dat8_o30; // internal 8 bit output to be put into wb_dat_o30
output [7:0]  wb_dat8_i30;
input [31:0]  wb_dat32_o30; // 32 bit data output (for debug30 interface)
output 		  wb_ack_o30;
output 		  we_o30;
output 		  re_o30;

wire 			  we_o30;
reg 			  wb_ack_o30;
reg [7:0] 	  wb_dat8_i30;
wire [7:0] 	  wb_dat8_o30;
wire [`UART_ADDR_WIDTH30-1:0]	wb_adr_int30; // internal signal30 for address bus
reg [`UART_ADDR_WIDTH30-1:0]	wb_adr_is30;
reg 								wb_we_is30;
reg 								wb_cyc_is30;
reg 								wb_stb_is30;
reg [3:0] 						wb_sel_is30;
wire [3:0]   wb_sel_i30;
reg 			 wre30 ;// timing30 control30 signal30 for write or read enable

// wb_ack_o30 FSM30
reg [1:0] 	 wbstate30;
always  @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) begin
		wb_ack_o30 <= #1 1'b0;
		wbstate30 <= #1 0;
		wre30 <= #1 1'b1;
	end else
		case (wbstate30)
			0: begin
				if (wb_stb_is30 & wb_cyc_is30) begin
					wre30 <= #1 0;
					wbstate30 <= #1 1;
					wb_ack_o30 <= #1 1;
				end else begin
					wre30 <= #1 1;
					wb_ack_o30 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o30 <= #1 0;
				wbstate30 <= #1 2;
				wre30 <= #1 0;
			end
			2,3: begin
				wb_ack_o30 <= #1 0;
				wbstate30 <= #1 0;
				wre30 <= #1 0;
			end
		endcase

assign we_o30 =  wb_we_is30 & wb_stb_is30 & wb_cyc_is30 & wre30 ; //WE30 for registers	
assign re_o30 = ~wb_we_is30 & wb_stb_is30 & wb_cyc_is30 & wre30 ; //RE30 for registers	

// Sample30 input signals30
always  @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30) begin
		wb_adr_is30 <= #1 0;
		wb_we_is30 <= #1 0;
		wb_cyc_is30 <= #1 0;
		wb_stb_is30 <= #1 0;
		wb_dat_is30 <= #1 0;
		wb_sel_is30 <= #1 0;
	end else begin
		wb_adr_is30 <= #1 wb_adr_i30;
		wb_we_is30 <= #1 wb_we_i30;
		wb_cyc_is30 <= #1 wb_cyc_i30;
		wb_stb_is30 <= #1 wb_stb_i30;
		wb_dat_is30 <= #1 wb_dat_i30;
		wb_sel_is30 <= #1 wb_sel_i30;
	end

`ifdef DATA_BUS_WIDTH_830 // 8-bit data bus
always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30)
		wb_dat_o30 <= #1 0;
	else
		wb_dat_o30 <= #1 wb_dat8_o30;

always @(wb_dat_is30)
	wb_dat8_i30 = wb_dat_is30;

assign wb_adr_int30 = wb_adr_is30;

`else // 32-bit bus
// put output to the correct30 byte in 32 bits using select30 line
always @(posedge clk30 or posedge wb_rst_i30)
	if (wb_rst_i30)
		wb_dat_o30 <= #1 0;
	else if (re_o30)
		case (wb_sel_is30)
			4'b0001: wb_dat_o30 <= #1 {24'b0, wb_dat8_o30};
			4'b0010: wb_dat_o30 <= #1 {16'b0, wb_dat8_o30, 8'b0};
			4'b0100: wb_dat_o30 <= #1 {8'b0, wb_dat8_o30, 16'b0};
			4'b1000: wb_dat_o30 <= #1 {wb_dat8_o30, 24'b0};
			4'b1111: wb_dat_o30 <= #1 wb_dat32_o30; // debug30 interface output
 			default: wb_dat_o30 <= #1 0;
		endcase // case(wb_sel_i30)

reg [1:0] wb_adr_int_lsb30;

always @(wb_sel_is30 or wb_dat_is30)
begin
	case (wb_sel_is30)
		4'b0001 : wb_dat8_i30 = wb_dat_is30[7:0];
		4'b0010 : wb_dat8_i30 = wb_dat_is30[15:8];
		4'b0100 : wb_dat8_i30 = wb_dat_is30[23:16];
		4'b1000 : wb_dat8_i30 = wb_dat_is30[31:24];
		default : wb_dat8_i30 = wb_dat_is30[7:0];
	endcase // case(wb_sel_i30)

  `ifdef LITLE_ENDIAN30
	case (wb_sel_is30)
		4'b0001 : wb_adr_int_lsb30 = 2'h0;
		4'b0010 : wb_adr_int_lsb30 = 2'h1;
		4'b0100 : wb_adr_int_lsb30 = 2'h2;
		4'b1000 : wb_adr_int_lsb30 = 2'h3;
		default : wb_adr_int_lsb30 = 2'h0;
	endcase // case(wb_sel_i30)
  `else
	case (wb_sel_is30)
		4'b0001 : wb_adr_int_lsb30 = 2'h3;
		4'b0010 : wb_adr_int_lsb30 = 2'h2;
		4'b0100 : wb_adr_int_lsb30 = 2'h1;
		4'b1000 : wb_adr_int_lsb30 = 2'h0;
		default : wb_adr_int_lsb30 = 2'h0;
	endcase // case(wb_sel_i30)
  `endif
end

assign wb_adr_int30 = {wb_adr_is30[`UART_ADDR_WIDTH30-1:2], wb_adr_int_lsb30};

`endif // !`ifdef DATA_BUS_WIDTH_830

endmodule










