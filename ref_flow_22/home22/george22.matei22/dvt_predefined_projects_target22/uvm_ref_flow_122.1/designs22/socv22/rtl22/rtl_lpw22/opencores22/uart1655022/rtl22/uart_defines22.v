//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines22.v                                              ////
////                                                              ////
////                                                              ////
////  This22 file is part of the "UART22 16550 compatible22" project22    ////
////  http22://www22.opencores22.org22/cores22/uart1655022/                   ////
////                                                              ////
////  Documentation22 related22 to this project22:                      ////
////  - http22://www22.opencores22.org22/cores22/uart1655022/                 ////
////                                                              ////
////  Projects22 compatibility22:                                     ////
////  - WISHBONE22                                                  ////
////  RS23222 Protocol22                                              ////
////  16550D uart22 (mostly22 supported)                              ////
////                                                              ////
////  Overview22 (main22 Features22):                                   ////
////  Defines22 of the Core22                                         ////
////                                                              ////
////  Known22 problems22 (limits22):                                    ////
////  None22                                                        ////
////                                                              ////
////  To22 Do22:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author22(s):                                                  ////
////      - gorban22@opencores22.org22                                  ////
////      - Jacob22 Gorban22                                          ////
////      - Igor22 Mohor22 (igorm22@opencores22.org22)                      ////
////                                                              ////
////  Created22:        2001/05/12                                  ////
////  Last22 Updated22:   2001/05/17                                  ////
////                  (See log22 for the revision22 history22)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright22 (C) 2000, 2001 Authors22                             ////
////                                                              ////
//// This22 source22 file may be used and distributed22 without         ////
//// restriction22 provided that this copyright22 statement22 is not    ////
//// removed from the file and that any derivative22 work22 contains22  ////
//// the original copyright22 notice22 and the associated disclaimer22. ////
////                                                              ////
//// This22 source22 file is free software22; you can redistribute22 it   ////
//// and/or modify it under the terms22 of the GNU22 Lesser22 General22   ////
//// Public22 License22 as published22 by the Free22 Software22 Foundation22; ////
//// either22 version22 2.1 of the License22, or (at your22 option) any   ////
//// later22 version22.                                               ////
////                                                              ////
//// This22 source22 is distributed22 in the hope22 that it will be       ////
//// useful22, but WITHOUT22 ANY22 WARRANTY22; without even22 the implied22   ////
//// warranty22 of MERCHANTABILITY22 or FITNESS22 FOR22 A PARTICULAR22      ////
//// PURPOSE22.  See the GNU22 Lesser22 General22 Public22 License22 for more ////
//// details22.                                                     ////
////                                                              ////
//// You should have received22 a copy of the GNU22 Lesser22 General22    ////
//// Public22 License22 along22 with this source22; if not, download22 it   ////
//// from http22://www22.opencores22.org22/lgpl22.shtml22                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS22 Revision22 History22
//
// $Log: not supported by cvs2svn22 $
// Revision22 1.13  2003/06/11 16:37:47  gorban22
// This22 fixes22 errors22 in some22 cases22 when data is being read and put to the FIFO at the same time. Patch22 is submitted22 by Scott22 Furman22. Update is very22 recommended22.
//
// Revision22 1.12  2002/07/22 23:02:23  gorban22
// Bug22 Fixes22:
//  * Possible22 loss of sync and bad22 reception22 of stop bit on slow22 baud22 rates22 fixed22.
//   Problem22 reported22 by Kenny22.Tung22.
//  * Bad (or lack22 of ) loopback22 handling22 fixed22. Reported22 by Cherry22 Withers22.
//
// Improvements22:
//  * Made22 FIFO's as general22 inferrable22 memory where possible22.
//  So22 on FPGA22 they should be inferred22 as RAM22 (Distributed22 RAM22 on Xilinx22).
//  This22 saves22 about22 1/3 of the Slice22 count and reduces22 P&R and synthesis22 times.
//
//  * Added22 optional22 baudrate22 output (baud_o22).
//  This22 is identical22 to BAUDOUT22* signal22 on 16550 chip22.
//  It outputs22 16xbit_clock_rate - the divided22 clock22.
//  It's disabled by default. Define22 UART_HAS_BAUDRATE_OUTPUT22 to use.
//
// Revision22 1.10  2001/12/11 08:55:40  mohor22
// Scratch22 register define added.
//
// Revision22 1.9  2001/12/03 21:44:29  gorban22
// Updated22 specification22 documentation.
// Added22 full 32-bit data bus interface, now as default.
// Address is 5-bit wide22 in 32-bit data bus mode.
// Added22 wb_sel_i22 input to the core22. It's used in the 32-bit mode.
// Added22 debug22 interface with two22 32-bit read-only registers in 32-bit mode.
// Bits22 5 and 6 of LSR22 are now only cleared22 on TX22 FIFO write.
// My22 small test bench22 is modified to work22 with 32-bit mode.
//
// Revision22 1.8  2001/11/26 21:38:54  gorban22
// Lots22 of fixes22:
// Break22 condition wasn22't handled22 correctly at all.
// LSR22 bits could lose22 their22 values.
// LSR22 value after reset was wrong22.
// Timing22 of THRE22 interrupt22 signal22 corrected22.
// LSR22 bit 0 timing22 corrected22.
//
// Revision22 1.7  2001/08/24 21:01:12  mohor22
// Things22 connected22 to parity22 changed.
// Clock22 devider22 changed.
//
// Revision22 1.6  2001/08/23 16:05:05  mohor22
// Stop bit bug22 fixed22.
// Parity22 bug22 fixed22.
// WISHBONE22 read cycle bug22 fixed22,
// OE22 indicator22 (Overrun22 Error) bug22 fixed22.
// PE22 indicator22 (Parity22 Error) bug22 fixed22.
// Register read bug22 fixed22.
//
// Revision22 1.5  2001/05/31 20:08:01  gorban22
// FIFO changes22 and other corrections22.
//
// Revision22 1.4  2001/05/21 19:12:02  gorban22
// Corrected22 some22 Linter22 messages22.
//
// Revision22 1.3  2001/05/17 18:34:18  gorban22
// First22 'stable' release. Should22 be sythesizable22 now. Also22 added new header.
//
// Revision22 1.0  2001-05-17 21:27:11+02  jacob22
// Initial22 revision22
//
//

// remove comments22 to restore22 to use the new version22 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i22 signal22 is used to put data in correct22 place22
// also, in 8-bit version22 there22'll be no debugging22 features22 included22
// CAUTION22: doesn't work22 with current version22 of OR120022
//`define DATA_BUS_WIDTH_822

`ifdef DATA_BUS_WIDTH_822
 `define UART_ADDR_WIDTH22 3
 `define UART_DATA_WIDTH22 8
`else
 `define UART_ADDR_WIDTH22 5
 `define UART_DATA_WIDTH22 32
`endif

// Uncomment22 this if you want22 your22 UART22 to have
// 16xBaudrate output port.
// If22 defined, the enable signal22 will be used to drive22 baudrate_o22 signal22
// It's frequency22 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT22

// Register addresses22
`define UART_REG_RB22	`UART_ADDR_WIDTH22'd0	// receiver22 buffer22
`define UART_REG_TR22  `UART_ADDR_WIDTH22'd0	// transmitter22
`define UART_REG_IE22	`UART_ADDR_WIDTH22'd1	// Interrupt22 enable
`define UART_REG_II22  `UART_ADDR_WIDTH22'd2	// Interrupt22 identification22
`define UART_REG_FC22  `UART_ADDR_WIDTH22'd2	// FIFO control22
`define UART_REG_LC22	`UART_ADDR_WIDTH22'd3	// Line22 Control22
`define UART_REG_MC22	`UART_ADDR_WIDTH22'd4	// Modem22 control22
`define UART_REG_LS22  `UART_ADDR_WIDTH22'd5	// Line22 status
`define UART_REG_MS22  `UART_ADDR_WIDTH22'd6	// Modem22 status
`define UART_REG_SR22  `UART_ADDR_WIDTH22'd7	// Scratch22 register
`define UART_REG_DL122	`UART_ADDR_WIDTH22'd0	// Divisor22 latch22 bytes (1-2)
`define UART_REG_DL222	`UART_ADDR_WIDTH22'd1

// Interrupt22 Enable22 register bits
`define UART_IE_RDA22	0	// Received22 Data available interrupt22
`define UART_IE_THRE22	1	// Transmitter22 Holding22 Register empty22 interrupt22
`define UART_IE_RLS22	2	// Receiver22 Line22 Status Interrupt22
`define UART_IE_MS22	3	// Modem22 Status Interrupt22

// Interrupt22 Identification22 register bits
`define UART_II_IP22	0	// Interrupt22 pending when 0
`define UART_II_II22	3:1	// Interrupt22 identification22

// Interrupt22 identification22 values for bits 3:1
`define UART_II_RLS22	3'b011	// Receiver22 Line22 Status
`define UART_II_RDA22	3'b010	// Receiver22 Data available
`define UART_II_TI22	3'b110	// Timeout22 Indication22
`define UART_II_THRE22	3'b001	// Transmitter22 Holding22 Register empty22
`define UART_II_MS22	3'b000	// Modem22 Status

// FIFO Control22 Register bits
`define UART_FC_TL22	1:0	// Trigger22 level

// FIFO trigger level values
`define UART_FC_122		2'b00
`define UART_FC_422		2'b01
`define UART_FC_822		2'b10
`define UART_FC_1422	2'b11

// Line22 Control22 register bits
`define UART_LC_BITS22	1:0	// bits in character22
`define UART_LC_SB22	2	// stop bits
`define UART_LC_PE22	3	// parity22 enable
`define UART_LC_EP22	4	// even22 parity22
`define UART_LC_SP22	5	// stick22 parity22
`define UART_LC_BC22	6	// Break22 control22
`define UART_LC_DL22	7	// Divisor22 Latch22 access bit

// Modem22 Control22 register bits
`define UART_MC_DTR22	0
`define UART_MC_RTS22	1
`define UART_MC_OUT122	2
`define UART_MC_OUT222	3
`define UART_MC_LB22	4	// Loopback22 mode

// Line22 Status Register bits
`define UART_LS_DR22	0	// Data ready
`define UART_LS_OE22	1	// Overrun22 Error
`define UART_LS_PE22	2	// Parity22 Error
`define UART_LS_FE22	3	// Framing22 Error
`define UART_LS_BI22	4	// Break22 interrupt22
`define UART_LS_TFE22	5	// Transmit22 FIFO is empty22
`define UART_LS_TE22	6	// Transmitter22 Empty22 indicator22
`define UART_LS_EI22	7	// Error indicator22

// Modem22 Status Register bits
`define UART_MS_DCTS22	0	// Delta22 signals22
`define UART_MS_DDSR22	1
`define UART_MS_TERI22	2
`define UART_MS_DDCD22	3
`define UART_MS_CCTS22	4	// Complement22 signals22
`define UART_MS_CDSR22	5
`define UART_MS_CRI22	6
`define UART_MS_CDCD22	7

// FIFO parameter defines22

`define UART_FIFO_WIDTH22	8
`define UART_FIFO_DEPTH22	16
`define UART_FIFO_POINTER_W22	4
`define UART_FIFO_COUNTER_W22	5
// receiver22 fifo has width 11 because it has break, parity22 and framing22 error bits
`define UART_FIFO_REC_WIDTH22  11


`define VERBOSE_WB22  0           // All activity22 on the WISHBONE22 is recorded22
`define VERBOSE_LINE_STATUS22 0   // Details22 about22 the lsr22 (line status register)
`define FAST_TEST22   1           // 64/1024 packets22 are sent22







