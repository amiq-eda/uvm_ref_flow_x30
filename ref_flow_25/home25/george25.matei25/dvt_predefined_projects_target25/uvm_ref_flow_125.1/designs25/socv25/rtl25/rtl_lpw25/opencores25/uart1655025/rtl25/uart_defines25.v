//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines25.v                                              ////
////                                                              ////
////                                                              ////
////  This25 file is part of the "UART25 16550 compatible25" project25    ////
////  http25://www25.opencores25.org25/cores25/uart1655025/                   ////
////                                                              ////
////  Documentation25 related25 to this project25:                      ////
////  - http25://www25.opencores25.org25/cores25/uart1655025/                 ////
////                                                              ////
////  Projects25 compatibility25:                                     ////
////  - WISHBONE25                                                  ////
////  RS23225 Protocol25                                              ////
////  16550D uart25 (mostly25 supported)                              ////
////                                                              ////
////  Overview25 (main25 Features25):                                   ////
////  Defines25 of the Core25                                         ////
////                                                              ////
////  Known25 problems25 (limits25):                                    ////
////  None25                                                        ////
////                                                              ////
////  To25 Do25:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author25(s):                                                  ////
////      - gorban25@opencores25.org25                                  ////
////      - Jacob25 Gorban25                                          ////
////      - Igor25 Mohor25 (igorm25@opencores25.org25)                      ////
////                                                              ////
////  Created25:        2001/05/12                                  ////
////  Last25 Updated25:   2001/05/17                                  ////
////                  (See log25 for the revision25 history25)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2000, 2001 Authors25                             ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS25 Revision25 History25
//
// $Log: not supported by cvs2svn25 $
// Revision25 1.13  2003/06/11 16:37:47  gorban25
// This25 fixes25 errors25 in some25 cases25 when data is being read and put to the FIFO at the same time. Patch25 is submitted25 by Scott25 Furman25. Update is very25 recommended25.
//
// Revision25 1.12  2002/07/22 23:02:23  gorban25
// Bug25 Fixes25:
//  * Possible25 loss of sync and bad25 reception25 of stop bit on slow25 baud25 rates25 fixed25.
//   Problem25 reported25 by Kenny25.Tung25.
//  * Bad (or lack25 of ) loopback25 handling25 fixed25. Reported25 by Cherry25 Withers25.
//
// Improvements25:
//  * Made25 FIFO's as general25 inferrable25 memory where possible25.
//  So25 on FPGA25 they should be inferred25 as RAM25 (Distributed25 RAM25 on Xilinx25).
//  This25 saves25 about25 1/3 of the Slice25 count and reduces25 P&R and synthesis25 times.
//
//  * Added25 optional25 baudrate25 output (baud_o25).
//  This25 is identical25 to BAUDOUT25* signal25 on 16550 chip25.
//  It outputs25 16xbit_clock_rate - the divided25 clock25.
//  It's disabled by default. Define25 UART_HAS_BAUDRATE_OUTPUT25 to use.
//
// Revision25 1.10  2001/12/11 08:55:40  mohor25
// Scratch25 register define added.
//
// Revision25 1.9  2001/12/03 21:44:29  gorban25
// Updated25 specification25 documentation.
// Added25 full 32-bit data bus interface, now as default.
// Address is 5-bit wide25 in 32-bit data bus mode.
// Added25 wb_sel_i25 input to the core25. It's used in the 32-bit mode.
// Added25 debug25 interface with two25 32-bit read-only registers in 32-bit mode.
// Bits25 5 and 6 of LSR25 are now only cleared25 on TX25 FIFO write.
// My25 small test bench25 is modified to work25 with 32-bit mode.
//
// Revision25 1.8  2001/11/26 21:38:54  gorban25
// Lots25 of fixes25:
// Break25 condition wasn25't handled25 correctly at all.
// LSR25 bits could lose25 their25 values.
// LSR25 value after reset was wrong25.
// Timing25 of THRE25 interrupt25 signal25 corrected25.
// LSR25 bit 0 timing25 corrected25.
//
// Revision25 1.7  2001/08/24 21:01:12  mohor25
// Things25 connected25 to parity25 changed.
// Clock25 devider25 changed.
//
// Revision25 1.6  2001/08/23 16:05:05  mohor25
// Stop bit bug25 fixed25.
// Parity25 bug25 fixed25.
// WISHBONE25 read cycle bug25 fixed25,
// OE25 indicator25 (Overrun25 Error) bug25 fixed25.
// PE25 indicator25 (Parity25 Error) bug25 fixed25.
// Register read bug25 fixed25.
//
// Revision25 1.5  2001/05/31 20:08:01  gorban25
// FIFO changes25 and other corrections25.
//
// Revision25 1.4  2001/05/21 19:12:02  gorban25
// Corrected25 some25 Linter25 messages25.
//
// Revision25 1.3  2001/05/17 18:34:18  gorban25
// First25 'stable' release. Should25 be sythesizable25 now. Also25 added new header.
//
// Revision25 1.0  2001-05-17 21:27:11+02  jacob25
// Initial25 revision25
//
//

// remove comments25 to restore25 to use the new version25 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i25 signal25 is used to put data in correct25 place25
// also, in 8-bit version25 there25'll be no debugging25 features25 included25
// CAUTION25: doesn't work25 with current version25 of OR120025
//`define DATA_BUS_WIDTH_825

`ifdef DATA_BUS_WIDTH_825
 `define UART_ADDR_WIDTH25 3
 `define UART_DATA_WIDTH25 8
`else
 `define UART_ADDR_WIDTH25 5
 `define UART_DATA_WIDTH25 32
`endif

// Uncomment25 this if you want25 your25 UART25 to have
// 16xBaudrate output port.
// If25 defined, the enable signal25 will be used to drive25 baudrate_o25 signal25
// It's frequency25 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT25

// Register addresses25
`define UART_REG_RB25	`UART_ADDR_WIDTH25'd0	// receiver25 buffer25
`define UART_REG_TR25  `UART_ADDR_WIDTH25'd0	// transmitter25
`define UART_REG_IE25	`UART_ADDR_WIDTH25'd1	// Interrupt25 enable
`define UART_REG_II25  `UART_ADDR_WIDTH25'd2	// Interrupt25 identification25
`define UART_REG_FC25  `UART_ADDR_WIDTH25'd2	// FIFO control25
`define UART_REG_LC25	`UART_ADDR_WIDTH25'd3	// Line25 Control25
`define UART_REG_MC25	`UART_ADDR_WIDTH25'd4	// Modem25 control25
`define UART_REG_LS25  `UART_ADDR_WIDTH25'd5	// Line25 status
`define UART_REG_MS25  `UART_ADDR_WIDTH25'd6	// Modem25 status
`define UART_REG_SR25  `UART_ADDR_WIDTH25'd7	// Scratch25 register
`define UART_REG_DL125	`UART_ADDR_WIDTH25'd0	// Divisor25 latch25 bytes (1-2)
`define UART_REG_DL225	`UART_ADDR_WIDTH25'd1

// Interrupt25 Enable25 register bits
`define UART_IE_RDA25	0	// Received25 Data available interrupt25
`define UART_IE_THRE25	1	// Transmitter25 Holding25 Register empty25 interrupt25
`define UART_IE_RLS25	2	// Receiver25 Line25 Status Interrupt25
`define UART_IE_MS25	3	// Modem25 Status Interrupt25

// Interrupt25 Identification25 register bits
`define UART_II_IP25	0	// Interrupt25 pending when 0
`define UART_II_II25	3:1	// Interrupt25 identification25

// Interrupt25 identification25 values for bits 3:1
`define UART_II_RLS25	3'b011	// Receiver25 Line25 Status
`define UART_II_RDA25	3'b010	// Receiver25 Data available
`define UART_II_TI25	3'b110	// Timeout25 Indication25
`define UART_II_THRE25	3'b001	// Transmitter25 Holding25 Register empty25
`define UART_II_MS25	3'b000	// Modem25 Status

// FIFO Control25 Register bits
`define UART_FC_TL25	1:0	// Trigger25 level

// FIFO trigger level values
`define UART_FC_125		2'b00
`define UART_FC_425		2'b01
`define UART_FC_825		2'b10
`define UART_FC_1425	2'b11

// Line25 Control25 register bits
`define UART_LC_BITS25	1:0	// bits in character25
`define UART_LC_SB25	2	// stop bits
`define UART_LC_PE25	3	// parity25 enable
`define UART_LC_EP25	4	// even25 parity25
`define UART_LC_SP25	5	// stick25 parity25
`define UART_LC_BC25	6	// Break25 control25
`define UART_LC_DL25	7	// Divisor25 Latch25 access bit

// Modem25 Control25 register bits
`define UART_MC_DTR25	0
`define UART_MC_RTS25	1
`define UART_MC_OUT125	2
`define UART_MC_OUT225	3
`define UART_MC_LB25	4	// Loopback25 mode

// Line25 Status Register bits
`define UART_LS_DR25	0	// Data ready
`define UART_LS_OE25	1	// Overrun25 Error
`define UART_LS_PE25	2	// Parity25 Error
`define UART_LS_FE25	3	// Framing25 Error
`define UART_LS_BI25	4	// Break25 interrupt25
`define UART_LS_TFE25	5	// Transmit25 FIFO is empty25
`define UART_LS_TE25	6	// Transmitter25 Empty25 indicator25
`define UART_LS_EI25	7	// Error indicator25

// Modem25 Status Register bits
`define UART_MS_DCTS25	0	// Delta25 signals25
`define UART_MS_DDSR25	1
`define UART_MS_TERI25	2
`define UART_MS_DDCD25	3
`define UART_MS_CCTS25	4	// Complement25 signals25
`define UART_MS_CDSR25	5
`define UART_MS_CRI25	6
`define UART_MS_CDCD25	7

// FIFO parameter defines25

`define UART_FIFO_WIDTH25	8
`define UART_FIFO_DEPTH25	16
`define UART_FIFO_POINTER_W25	4
`define UART_FIFO_COUNTER_W25	5
// receiver25 fifo has width 11 because it has break, parity25 and framing25 error bits
`define UART_FIFO_REC_WIDTH25  11


`define VERBOSE_WB25  0           // All activity25 on the WISHBONE25 is recorded25
`define VERBOSE_LINE_STATUS25 0   // Details25 about25 the lsr25 (line status register)
`define FAST_TEST25   1           // 64/1024 packets25 are sent25







