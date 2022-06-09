//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines27.v                                              ////
////                                                              ////
////                                                              ////
////  This27 file is part of the "UART27 16550 compatible27" project27    ////
////  http27://www27.opencores27.org27/cores27/uart1655027/                   ////
////                                                              ////
////  Documentation27 related27 to this project27:                      ////
////  - http27://www27.opencores27.org27/cores27/uart1655027/                 ////
////                                                              ////
////  Projects27 compatibility27:                                     ////
////  - WISHBONE27                                                  ////
////  RS23227 Protocol27                                              ////
////  16550D uart27 (mostly27 supported)                              ////
////                                                              ////
////  Overview27 (main27 Features27):                                   ////
////  Defines27 of the Core27                                         ////
////                                                              ////
////  Known27 problems27 (limits27):                                    ////
////  None27                                                        ////
////                                                              ////
////  To27 Do27:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author27(s):                                                  ////
////      - gorban27@opencores27.org27                                  ////
////      - Jacob27 Gorban27                                          ////
////      - Igor27 Mohor27 (igorm27@opencores27.org27)                      ////
////                                                              ////
////  Created27:        2001/05/12                                  ////
////  Last27 Updated27:   2001/05/17                                  ////
////                  (See log27 for the revision27 history27)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2000, 2001 Authors27                             ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS27 Revision27 History27
//
// $Log: not supported by cvs2svn27 $
// Revision27 1.13  2003/06/11 16:37:47  gorban27
// This27 fixes27 errors27 in some27 cases27 when data is being read and put to the FIFO at the same time. Patch27 is submitted27 by Scott27 Furman27. Update is very27 recommended27.
//
// Revision27 1.12  2002/07/22 23:02:23  gorban27
// Bug27 Fixes27:
//  * Possible27 loss of sync and bad27 reception27 of stop bit on slow27 baud27 rates27 fixed27.
//   Problem27 reported27 by Kenny27.Tung27.
//  * Bad (or lack27 of ) loopback27 handling27 fixed27. Reported27 by Cherry27 Withers27.
//
// Improvements27:
//  * Made27 FIFO's as general27 inferrable27 memory where possible27.
//  So27 on FPGA27 they should be inferred27 as RAM27 (Distributed27 RAM27 on Xilinx27).
//  This27 saves27 about27 1/3 of the Slice27 count and reduces27 P&R and synthesis27 times.
//
//  * Added27 optional27 baudrate27 output (baud_o27).
//  This27 is identical27 to BAUDOUT27* signal27 on 16550 chip27.
//  It outputs27 16xbit_clock_rate - the divided27 clock27.
//  It's disabled by default. Define27 UART_HAS_BAUDRATE_OUTPUT27 to use.
//
// Revision27 1.10  2001/12/11 08:55:40  mohor27
// Scratch27 register define added.
//
// Revision27 1.9  2001/12/03 21:44:29  gorban27
// Updated27 specification27 documentation.
// Added27 full 32-bit data bus interface, now as default.
// Address is 5-bit wide27 in 32-bit data bus mode.
// Added27 wb_sel_i27 input to the core27. It's used in the 32-bit mode.
// Added27 debug27 interface with two27 32-bit read-only registers in 32-bit mode.
// Bits27 5 and 6 of LSR27 are now only cleared27 on TX27 FIFO write.
// My27 small test bench27 is modified to work27 with 32-bit mode.
//
// Revision27 1.8  2001/11/26 21:38:54  gorban27
// Lots27 of fixes27:
// Break27 condition wasn27't handled27 correctly at all.
// LSR27 bits could lose27 their27 values.
// LSR27 value after reset was wrong27.
// Timing27 of THRE27 interrupt27 signal27 corrected27.
// LSR27 bit 0 timing27 corrected27.
//
// Revision27 1.7  2001/08/24 21:01:12  mohor27
// Things27 connected27 to parity27 changed.
// Clock27 devider27 changed.
//
// Revision27 1.6  2001/08/23 16:05:05  mohor27
// Stop bit bug27 fixed27.
// Parity27 bug27 fixed27.
// WISHBONE27 read cycle bug27 fixed27,
// OE27 indicator27 (Overrun27 Error) bug27 fixed27.
// PE27 indicator27 (Parity27 Error) bug27 fixed27.
// Register read bug27 fixed27.
//
// Revision27 1.5  2001/05/31 20:08:01  gorban27
// FIFO changes27 and other corrections27.
//
// Revision27 1.4  2001/05/21 19:12:02  gorban27
// Corrected27 some27 Linter27 messages27.
//
// Revision27 1.3  2001/05/17 18:34:18  gorban27
// First27 'stable' release. Should27 be sythesizable27 now. Also27 added new header.
//
// Revision27 1.0  2001-05-17 21:27:11+02  jacob27
// Initial27 revision27
//
//

// remove comments27 to restore27 to use the new version27 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i27 signal27 is used to put data in correct27 place27
// also, in 8-bit version27 there27'll be no debugging27 features27 included27
// CAUTION27: doesn't work27 with current version27 of OR120027
//`define DATA_BUS_WIDTH_827

`ifdef DATA_BUS_WIDTH_827
 `define UART_ADDR_WIDTH27 3
 `define UART_DATA_WIDTH27 8
`else
 `define UART_ADDR_WIDTH27 5
 `define UART_DATA_WIDTH27 32
`endif

// Uncomment27 this if you want27 your27 UART27 to have
// 16xBaudrate output port.
// If27 defined, the enable signal27 will be used to drive27 baudrate_o27 signal27
// It's frequency27 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT27

// Register addresses27
`define UART_REG_RB27	`UART_ADDR_WIDTH27'd0	// receiver27 buffer27
`define UART_REG_TR27  `UART_ADDR_WIDTH27'd0	// transmitter27
`define UART_REG_IE27	`UART_ADDR_WIDTH27'd1	// Interrupt27 enable
`define UART_REG_II27  `UART_ADDR_WIDTH27'd2	// Interrupt27 identification27
`define UART_REG_FC27  `UART_ADDR_WIDTH27'd2	// FIFO control27
`define UART_REG_LC27	`UART_ADDR_WIDTH27'd3	// Line27 Control27
`define UART_REG_MC27	`UART_ADDR_WIDTH27'd4	// Modem27 control27
`define UART_REG_LS27  `UART_ADDR_WIDTH27'd5	// Line27 status
`define UART_REG_MS27  `UART_ADDR_WIDTH27'd6	// Modem27 status
`define UART_REG_SR27  `UART_ADDR_WIDTH27'd7	// Scratch27 register
`define UART_REG_DL127	`UART_ADDR_WIDTH27'd0	// Divisor27 latch27 bytes (1-2)
`define UART_REG_DL227	`UART_ADDR_WIDTH27'd1

// Interrupt27 Enable27 register bits
`define UART_IE_RDA27	0	// Received27 Data available interrupt27
`define UART_IE_THRE27	1	// Transmitter27 Holding27 Register empty27 interrupt27
`define UART_IE_RLS27	2	// Receiver27 Line27 Status Interrupt27
`define UART_IE_MS27	3	// Modem27 Status Interrupt27

// Interrupt27 Identification27 register bits
`define UART_II_IP27	0	// Interrupt27 pending when 0
`define UART_II_II27	3:1	// Interrupt27 identification27

// Interrupt27 identification27 values for bits 3:1
`define UART_II_RLS27	3'b011	// Receiver27 Line27 Status
`define UART_II_RDA27	3'b010	// Receiver27 Data available
`define UART_II_TI27	3'b110	// Timeout27 Indication27
`define UART_II_THRE27	3'b001	// Transmitter27 Holding27 Register empty27
`define UART_II_MS27	3'b000	// Modem27 Status

// FIFO Control27 Register bits
`define UART_FC_TL27	1:0	// Trigger27 level

// FIFO trigger level values
`define UART_FC_127		2'b00
`define UART_FC_427		2'b01
`define UART_FC_827		2'b10
`define UART_FC_1427	2'b11

// Line27 Control27 register bits
`define UART_LC_BITS27	1:0	// bits in character27
`define UART_LC_SB27	2	// stop bits
`define UART_LC_PE27	3	// parity27 enable
`define UART_LC_EP27	4	// even27 parity27
`define UART_LC_SP27	5	// stick27 parity27
`define UART_LC_BC27	6	// Break27 control27
`define UART_LC_DL27	7	// Divisor27 Latch27 access bit

// Modem27 Control27 register bits
`define UART_MC_DTR27	0
`define UART_MC_RTS27	1
`define UART_MC_OUT127	2
`define UART_MC_OUT227	3
`define UART_MC_LB27	4	// Loopback27 mode

// Line27 Status Register bits
`define UART_LS_DR27	0	// Data ready
`define UART_LS_OE27	1	// Overrun27 Error
`define UART_LS_PE27	2	// Parity27 Error
`define UART_LS_FE27	3	// Framing27 Error
`define UART_LS_BI27	4	// Break27 interrupt27
`define UART_LS_TFE27	5	// Transmit27 FIFO is empty27
`define UART_LS_TE27	6	// Transmitter27 Empty27 indicator27
`define UART_LS_EI27	7	// Error indicator27

// Modem27 Status Register bits
`define UART_MS_DCTS27	0	// Delta27 signals27
`define UART_MS_DDSR27	1
`define UART_MS_TERI27	2
`define UART_MS_DDCD27	3
`define UART_MS_CCTS27	4	// Complement27 signals27
`define UART_MS_CDSR27	5
`define UART_MS_CRI27	6
`define UART_MS_CDCD27	7

// FIFO parameter defines27

`define UART_FIFO_WIDTH27	8
`define UART_FIFO_DEPTH27	16
`define UART_FIFO_POINTER_W27	4
`define UART_FIFO_COUNTER_W27	5
// receiver27 fifo has width 11 because it has break, parity27 and framing27 error bits
`define UART_FIFO_REC_WIDTH27  11


`define VERBOSE_WB27  0           // All activity27 on the WISHBONE27 is recorded27
`define VERBOSE_LINE_STATUS27 0   // Details27 about27 the lsr27 (line status register)
`define FAST_TEST27   1           // 64/1024 packets27 are sent27







