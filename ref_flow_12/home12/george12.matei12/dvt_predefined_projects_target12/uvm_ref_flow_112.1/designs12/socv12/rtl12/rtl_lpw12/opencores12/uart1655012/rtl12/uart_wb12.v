//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_wb12.v                                                   ////
////                                                              ////
////                                                              ////
////  This12 file is part of the "UART12 16550 compatible12" project12    ////
////  http12://www12.opencores12.org12/cores12/uart1655012/                   ////
////                                                              ////
////  Documentation12 related12 to this project12:                      ////
////  - http12://www12.opencores12.org12/cores12/uart1655012/                 ////
////                                                              ////
////  Projects12 compatibility12:                                     ////
////  - WISHBONE12                                                  ////
////  RS23212 Protocol12                                              ////
////  16550D uart12 (mostly12 supported)                              ////
////                                                              ////
////  Overview12 (main12 Features12):                                   ////
////  UART12 core12 WISHBONE12 interface.                               ////
////                                                              ////
////  Known12 problems12 (limits12):                                    ////
////  Inserts12 one wait state on all transfers12.                    ////
////  Note12 affected12 signals12 and the way12 they are affected12.        ////
////                                                              ////
////  To12 Do12:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author12(s):                                                  ////
////      - gorban12@opencores12.org12                                  ////
////      - Jacob12 Gorban12                                          ////
////      - Igor12 Mohor12 (igorm12@opencores12.org12)                      ////
////                                                              ////
////  Created12:        2001/05/12                                  ////
////  Last12 Updated12:   2001/05/17                                  ////
////                  (See log12 for the revision12 history12)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright12 (C) 2000, 2001 Authors12                             ////
////                                                              ////
//// This12 source12 file may be used and distributed12 without         ////
//// restriction12 provided that this copyright12 statement12 is not    ////
//// removed from the file and that any derivative12 work12 contains12  ////
//// the original copyright12 notice12 and the associated disclaimer12. ////
////                                                              ////
//// This12 source12 file is free software12; you can redistribute12 it   ////
//// and/or modify it under the terms12 of the GNU12 Lesser12 General12   ////
//// Public12 License12 as published12 by the Free12 Software12 Foundation12; ////
//// either12 version12 2.1 of the License12, or (at your12 option) any   ////
//// later12 version12.                                               ////
////                                                              ////
//// This12 source12 is distributed12 in the hope12 that it will be       ////
//// useful12, but WITHOUT12 ANY12 WARRANTY12; without even12 the implied12   ////
//// warranty12 of MERCHANTABILITY12 or FITNESS12 FOR12 A PARTICULAR12      ////
//// PURPOSE12.  See the GNU12 Lesser12 General12 Public12 License12 for more ////
//// details12.                                                     ////
////                                                              ////
//// You should have received12 a copy of the GNU12 Lesser12 General12    ////
//// Public12 License12 along12 with this source12; if not, download12 it   ////
//// from http12://www12.opencores12.org12/lgpl12.shtml12                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS12 Revision12 History12
//
// $Log: not supported by cvs2svn12 $
// Revision12 1.16  2002/07/29 21:16:18  gorban12
// The uart_defines12.v file is included12 again12 in sources12.
//
// Revision12 1.15  2002/07/22 23:02:23  gorban12
// Bug12 Fixes12:
//  * Possible12 loss of sync and bad12 reception12 of stop bit on slow12 baud12 rates12 fixed12.
//   Problem12 reported12 by Kenny12.Tung12.
//  * Bad (or lack12 of ) loopback12 handling12 fixed12. Reported12 by Cherry12 Withers12.
//
// Improvements12:
//  * Made12 FIFO's as general12 inferrable12 memory where possible12.
//  So12 on FPGA12 they should be inferred12 as RAM12 (Distributed12 RAM12 on Xilinx12).
//  This12 saves12 about12 1/3 of the Slice12 count and reduces12 P&R and synthesis12 times.
//
//  * Added12 optional12 baudrate12 output (baud_o12).
//  This12 is identical12 to BAUDOUT12* signal12 on 16550 chip12.
//  It outputs12 16xbit_clock_rate - the divided12 clock12.
//  It's disabled by default. Define12 UART_HAS_BAUDRATE_OUTPUT12 to use.
//
// Revision12 1.12  2001/12/19 08:03:34  mohor12
// Warnings12 cleared12.
//
// Revision12 1.11  2001/12/06 14:51:04  gorban12
// Bug12 in LSR12[0] is fixed12.
// All WISHBONE12 signals12 are now sampled12, so another12 wait-state is introduced12 on all transfers12.
//
// Revision12 1.10  2001/12/03 21:44:29  gorban12
// Updated12 specification12 documentation.
// Added12 full 32-bit data bus interface, now as default.
// Address is 5-bit wide12 in 32-bit data bus mode.
// Added12 wb_sel_i12 input to the core12. It's used in the 32-bit mode.
// Added12 debug12 interface with two12 32-bit read-only registers in 32-bit mode.
// Bits12 5 and 6 of LSR12 are now only cleared12 on TX12 FIFO write.
// My12 small test bench12 is modified to work12 with 32-bit mode.
//
// Revision12 1.9  2001/10/20 09:58:40  gorban12
// Small12 synopsis12 fixes12
//
// Revision12 1.8  2001/08/24 21:01:12  mohor12
// Things12 connected12 to parity12 changed.
// Clock12 devider12 changed.
//
// Revision12 1.7  2001/08/23 16:05:05  mohor12
// Stop bit bug12 fixed12.
// Parity12 bug12 fixed12.
// WISHBONE12 read cycle bug12 fixed12,
// OE12 indicator12 (Overrun12 Error) bug12 fixed12.
// PE12 indicator12 (Parity12 Error) bug12 fixed12.
// Register read bug12 fixed12.
//
// Revision12 1.4  2001/05/31 20:08:01  gorban12
// FIFO changes12 and other corrections12.
//
// Revision12 1.3  2001/05/21 19:12:01  gorban12
// Corrected12 some12 Linter12 messages12.
//
// Revision12 1.2  2001/05/17 18:34:18  gorban12
// First12 'stable' release. Should12 be sythesizable12 now. Also12 added new header.
//
// Revision12 1.0  2001-05-17 21:27:13+02  jacob12
// Initial12 revision12
//
//

// UART12 core12 WISHBONE12 interface 
//
// Author12: Jacob12 Gorban12   (jacob12.gorban12@flextronicssemi12.com12)
// Company12: Flextronics12 Semiconductor12
//

// synopsys12 translate_off12
`include "timescale.v"
// synopsys12 translate_on12
`include "uart_defines12.v"
 
module uart_wb12 (clk12, wb_rst_i12, 
	wb_we_i12, wb_stb_i12, wb_cyc_i12, wb_ack_o12, wb_adr_i12,
	wb_adr_int12, wb_dat_i12, wb_dat_o12, wb_dat8_i12, wb_dat8_o12, wb_dat32_o12, wb_sel_i12,
	we_o12, re_o12 // Write and read enable output for the core12
);

input 		  clk12;

// WISHBONE12 interface	
input 		  wb_rst_i12;
input 		  wb_we_i12;
input 		  wb_stb_i12;
input 		  wb_cyc_i12;
input [3:0]   wb_sel_i12;
input [`UART_ADDR_WIDTH12-1:0] 	wb_adr_i12; //WISHBONE12 address line

`ifdef DATA_BUS_WIDTH_812
input [7:0]  wb_dat_i12; //input WISHBONE12 bus 
output [7:0] wb_dat_o12;
reg [7:0] 	 wb_dat_o12;
wire [7:0] 	 wb_dat_i12;
reg [7:0] 	 wb_dat_is12;
`else // for 32 data bus mode
input [31:0]  wb_dat_i12; //input WISHBONE12 bus 
output [31:0] wb_dat_o12;
reg [31:0] 	  wb_dat_o12;
wire [31:0]   wb_dat_i12;
reg [31:0] 	  wb_dat_is12;
`endif // !`ifdef DATA_BUS_WIDTH_812

output [`UART_ADDR_WIDTH12-1:0]	wb_adr_int12; // internal signal12 for address bus
input [7:0]   wb_dat8_o12; // internal 8 bit output to be put into wb_dat_o12
output [7:0]  wb_dat8_i12;
input [31:0]  wb_dat32_o12; // 32 bit data output (for debug12 interface)
output 		  wb_ack_o12;
output 		  we_o12;
output 		  re_o12;

wire 			  we_o12;
reg 			  wb_ack_o12;
reg [7:0] 	  wb_dat8_i12;
wire [7:0] 	  wb_dat8_o12;
wire [`UART_ADDR_WIDTH12-1:0]	wb_adr_int12; // internal signal12 for address bus
reg [`UART_ADDR_WIDTH12-1:0]	wb_adr_is12;
reg 								wb_we_is12;
reg 								wb_cyc_is12;
reg 								wb_stb_is12;
reg [3:0] 						wb_sel_is12;
wire [3:0]   wb_sel_i12;
reg 			 wre12 ;// timing12 control12 signal12 for write or read enable

// wb_ack_o12 FSM12
reg [1:0] 	 wbstate12;
always  @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) begin
		wb_ack_o12 <= #1 1'b0;
		wbstate12 <= #1 0;
		wre12 <= #1 1'b1;
	end else
		case (wbstate12)
			0: begin
				if (wb_stb_is12 & wb_cyc_is12) begin
					wre12 <= #1 0;
					wbstate12 <= #1 1;
					wb_ack_o12 <= #1 1;
				end else begin
					wre12 <= #1 1;
					wb_ack_o12 <= #1 0;
				end
			end
			1: begin
			   wb_ack_o12 <= #1 0;
				wbstate12 <= #1 2;
				wre12 <= #1 0;
			end
			2,3: begin
				wb_ack_o12 <= #1 0;
				wbstate12 <= #1 0;
				wre12 <= #1 0;
			end
		endcase

assign we_o12 =  wb_we_is12 & wb_stb_is12 & wb_cyc_is12 & wre12 ; //WE12 for registers	
assign re_o12 = ~wb_we_is12 & wb_stb_is12 & wb_cyc_is12 & wre12 ; //RE12 for registers	

// Sample12 input signals12
always  @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12) begin
		wb_adr_is12 <= #1 0;
		wb_we_is12 <= #1 0;
		wb_cyc_is12 <= #1 0;
		wb_stb_is12 <= #1 0;
		wb_dat_is12 <= #1 0;
		wb_sel_is12 <= #1 0;
	end else begin
		wb_adr_is12 <= #1 wb_adr_i12;
		wb_we_is12 <= #1 wb_we_i12;
		wb_cyc_is12 <= #1 wb_cyc_i12;
		wb_stb_is12 <= #1 wb_stb_i12;
		wb_dat_is12 <= #1 wb_dat_i12;
		wb_sel_is12 <= #1 wb_sel_i12;
	end

`ifdef DATA_BUS_WIDTH_812 // 8-bit data bus
always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12)
		wb_dat_o12 <= #1 0;
	else
		wb_dat_o12 <= #1 wb_dat8_o12;

always @(wb_dat_is12)
	wb_dat8_i12 = wb_dat_is12;

assign wb_adr_int12 = wb_adr_is12;

`else // 32-bit bus
// put output to the correct12 byte in 32 bits using select12 line
always @(posedge clk12 or posedge wb_rst_i12)
	if (wb_rst_i12)
		wb_dat_o12 <= #1 0;
	else if (re_o12)
		case (wb_sel_is12)
			4'b0001: wb_dat_o12 <= #1 {24'b0, wb_dat8_o12};
			4'b0010: wb_dat_o12 <= #1 {16'b0, wb_dat8_o12, 8'b0};
			4'b0100: wb_dat_o12 <= #1 {8'b0, wb_dat8_o12, 16'b0};
			4'b1000: wb_dat_o12 <= #1 {wb_dat8_o12, 24'b0};
			4'b1111: wb_dat_o12 <= #1 wb_dat32_o12; // debug12 interface output
 			default: wb_dat_o12 <= #1 0;
		endcase // case(wb_sel_i12)

reg [1:0] wb_adr_int_lsb12;

always @(wb_sel_is12 or wb_dat_is12)
begin
	case (wb_sel_is12)
		4'b0001 : wb_dat8_i12 = wb_dat_is12[7:0];
		4'b0010 : wb_dat8_i12 = wb_dat_is12[15:8];
		4'b0100 : wb_dat8_i12 = wb_dat_is12[23:16];
		4'b1000 : wb_dat8_i12 = wb_dat_is12[31:24];
		default : wb_dat8_i12 = wb_dat_is12[7:0];
	endcase // case(wb_sel_i12)

  `ifdef LITLE_ENDIAN12
	case (wb_sel_is12)
		4'b0001 : wb_adr_int_lsb12 = 2'h0;
		4'b0010 : wb_adr_int_lsb12 = 2'h1;
		4'b0100 : wb_adr_int_lsb12 = 2'h2;
		4'b1000 : wb_adr_int_lsb12 = 2'h3;
		default : wb_adr_int_lsb12 = 2'h0;
	endcase // case(wb_sel_i12)
  `else
	case (wb_sel_is12)
		4'b0001 : wb_adr_int_lsb12 = 2'h3;
		4'b0010 : wb_adr_int_lsb12 = 2'h2;
		4'b0100 : wb_adr_int_lsb12 = 2'h1;
		4'b1000 : wb_adr_int_lsb12 = 2'h0;
		default : wb_adr_int_lsb12 = 2'h0;
	endcase // case(wb_sel_i12)
  `endif
end

assign wb_adr_int12 = {wb_adr_is12[`UART_ADDR_WIDTH12-1:2], wb_adr_int_lsb12};

`endif // !`ifdef DATA_BUS_WIDTH_812

endmodule










