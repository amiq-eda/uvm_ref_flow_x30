//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines18.v                                              ////
////                                                              ////
////                                                              ////
////  This18 file is part of the "UART18 16550 compatible18" project18    ////
////  http18://www18.opencores18.org18/cores18/uart1655018/                   ////
////                                                              ////
////  Documentation18 related18 to this project18:                      ////
////  - http18://www18.opencores18.org18/cores18/uart1655018/                 ////
////                                                              ////
////  Projects18 compatibility18:                                     ////
////  - WISHBONE18                                                  ////
////  RS23218 Protocol18                                              ////
////  16550D uart18 (mostly18 supported)                              ////
////                                                              ////
////  Overview18 (main18 Features18):                                   ////
////  Defines18 of the Core18                                         ////
////                                                              ////
////  Known18 problems18 (limits18):                                    ////
////  None18                                                        ////
////                                                              ////
////  To18 Do18:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author18(s):                                                  ////
////      - gorban18@opencores18.org18                                  ////
////      - Jacob18 Gorban18                                          ////
////      - Igor18 Mohor18 (igorm18@opencores18.org18)                      ////
////                                                              ////
////  Created18:        2001/05/12                                  ////
////  Last18 Updated18:   2001/05/17                                  ////
////                  (See log18 for the revision18 history18)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2000, 2001 Authors18                             ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS18 Revision18 History18
//
// $Log: not supported by cvs2svn18 $
// Revision18 1.13  2003/06/11 16:37:47  gorban18
// This18 fixes18 errors18 in some18 cases18 when data is being read and put to the FIFO at the same time. Patch18 is submitted18 by Scott18 Furman18. Update is very18 recommended18.
//
// Revision18 1.12  2002/07/22 23:02:23  gorban18
// Bug18 Fixes18:
//  * Possible18 loss of sync and bad18 reception18 of stop bit on slow18 baud18 rates18 fixed18.
//   Problem18 reported18 by Kenny18.Tung18.
//  * Bad (or lack18 of ) loopback18 handling18 fixed18. Reported18 by Cherry18 Withers18.
//
// Improvements18:
//  * Made18 FIFO's as general18 inferrable18 memory where possible18.
//  So18 on FPGA18 they should be inferred18 as RAM18 (Distributed18 RAM18 on Xilinx18).
//  This18 saves18 about18 1/3 of the Slice18 count and reduces18 P&R and synthesis18 times.
//
//  * Added18 optional18 baudrate18 output (baud_o18).
//  This18 is identical18 to BAUDOUT18* signal18 on 16550 chip18.
//  It outputs18 16xbit_clock_rate - the divided18 clock18.
//  It's disabled by default. Define18 UART_HAS_BAUDRATE_OUTPUT18 to use.
//
// Revision18 1.10  2001/12/11 08:55:40  mohor18
// Scratch18 register define added.
//
// Revision18 1.9  2001/12/03 21:44:29  gorban18
// Updated18 specification18 documentation.
// Added18 full 32-bit data bus interface, now as default.
// Address is 5-bit wide18 in 32-bit data bus mode.
// Added18 wb_sel_i18 input to the core18. It's used in the 32-bit mode.
// Added18 debug18 interface with two18 32-bit read-only registers in 32-bit mode.
// Bits18 5 and 6 of LSR18 are now only cleared18 on TX18 FIFO write.
// My18 small test bench18 is modified to work18 with 32-bit mode.
//
// Revision18 1.8  2001/11/26 21:38:54  gorban18
// Lots18 of fixes18:
// Break18 condition wasn18't handled18 correctly at all.
// LSR18 bits could lose18 their18 values.
// LSR18 value after reset was wrong18.
// Timing18 of THRE18 interrupt18 signal18 corrected18.
// LSR18 bit 0 timing18 corrected18.
//
// Revision18 1.7  2001/08/24 21:01:12  mohor18
// Things18 connected18 to parity18 changed.
// Clock18 devider18 changed.
//
// Revision18 1.6  2001/08/23 16:05:05  mohor18
// Stop bit bug18 fixed18.
// Parity18 bug18 fixed18.
// WISHBONE18 read cycle bug18 fixed18,
// OE18 indicator18 (Overrun18 Error) bug18 fixed18.
// PE18 indicator18 (Parity18 Error) bug18 fixed18.
// Register read bug18 fixed18.
//
// Revision18 1.5  2001/05/31 20:08:01  gorban18
// FIFO changes18 and other corrections18.
//
// Revision18 1.4  2001/05/21 19:12:02  gorban18
// Corrected18 some18 Linter18 messages18.
//
// Revision18 1.3  2001/05/17 18:34:18  gorban18
// First18 'stable' release. Should18 be sythesizable18 now. Also18 added new header.
//
// Revision18 1.0  2001-05-17 21:27:11+02  jacob18
// Initial18 revision18
//
//

// remove comments18 to restore18 to use the new version18 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i18 signal18 is used to put data in correct18 place18
// also, in 8-bit version18 there18'll be no debugging18 features18 included18
// CAUTION18: doesn't work18 with current version18 of OR120018
//`define DATA_BUS_WIDTH_818

`ifdef DATA_BUS_WIDTH_818
 `define UART_ADDR_WIDTH18 3
 `define UART_DATA_WIDTH18 8
`else
 `define UART_ADDR_WIDTH18 5
 `define UART_DATA_WIDTH18 32
`endif

// Uncomment18 this if you want18 your18 UART18 to have
// 16xBaudrate output port.
// If18 defined, the enable signal18 will be used to drive18 baudrate_o18 signal18
// It's frequency18 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT18

// Register addresses18
`define UART_REG_RB18	`UART_ADDR_WIDTH18'd0	// receiver18 buffer18
`define UART_REG_TR18  `UART_ADDR_WIDTH18'd0	// transmitter18
`define UART_REG_IE18	`UART_ADDR_WIDTH18'd1	// Interrupt18 enable
`define UART_REG_II18  `UART_ADDR_WIDTH18'd2	// Interrupt18 identification18
`define UART_REG_FC18  `UART_ADDR_WIDTH18'd2	// FIFO control18
`define UART_REG_LC18	`UART_ADDR_WIDTH18'd3	// Line18 Control18
`define UART_REG_MC18	`UART_ADDR_WIDTH18'd4	// Modem18 control18
`define UART_REG_LS18  `UART_ADDR_WIDTH18'd5	// Line18 status
`define UART_REG_MS18  `UART_ADDR_WIDTH18'd6	// Modem18 status
`define UART_REG_SR18  `UART_ADDR_WIDTH18'd7	// Scratch18 register
`define UART_REG_DL118	`UART_ADDR_WIDTH18'd0	// Divisor18 latch18 bytes (1-2)
`define UART_REG_DL218	`UART_ADDR_WIDTH18'd1

// Interrupt18 Enable18 register bits
`define UART_IE_RDA18	0	// Received18 Data available interrupt18
`define UART_IE_THRE18	1	// Transmitter18 Holding18 Register empty18 interrupt18
`define UART_IE_RLS18	2	// Receiver18 Line18 Status Interrupt18
`define UART_IE_MS18	3	// Modem18 Status Interrupt18

// Interrupt18 Identification18 register bits
`define UART_II_IP18	0	// Interrupt18 pending when 0
`define UART_II_II18	3:1	// Interrupt18 identification18

// Interrupt18 identification18 values for bits 3:1
`define UART_II_RLS18	3'b011	// Receiver18 Line18 Status
`define UART_II_RDA18	3'b010	// Receiver18 Data available
`define UART_II_TI18	3'b110	// Timeout18 Indication18
`define UART_II_THRE18	3'b001	// Transmitter18 Holding18 Register empty18
`define UART_II_MS18	3'b000	// Modem18 Status

// FIFO Control18 Register bits
`define UART_FC_TL18	1:0	// Trigger18 level

// FIFO trigger level values
`define UART_FC_118		2'b00
`define UART_FC_418		2'b01
`define UART_FC_818		2'b10
`define UART_FC_1418	2'b11

// Line18 Control18 register bits
`define UART_LC_BITS18	1:0	// bits in character18
`define UART_LC_SB18	2	// stop bits
`define UART_LC_PE18	3	// parity18 enable
`define UART_LC_EP18	4	// even18 parity18
`define UART_LC_SP18	5	// stick18 parity18
`define UART_LC_BC18	6	// Break18 control18
`define UART_LC_DL18	7	// Divisor18 Latch18 access bit

// Modem18 Control18 register bits
`define UART_MC_DTR18	0
`define UART_MC_RTS18	1
`define UART_MC_OUT118	2
`define UART_MC_OUT218	3
`define UART_MC_LB18	4	// Loopback18 mode

// Line18 Status Register bits
`define UART_LS_DR18	0	// Data ready
`define UART_LS_OE18	1	// Overrun18 Error
`define UART_LS_PE18	2	// Parity18 Error
`define UART_LS_FE18	3	// Framing18 Error
`define UART_LS_BI18	4	// Break18 interrupt18
`define UART_LS_TFE18	5	// Transmit18 FIFO is empty18
`define UART_LS_TE18	6	// Transmitter18 Empty18 indicator18
`define UART_LS_EI18	7	// Error indicator18

// Modem18 Status Register bits
`define UART_MS_DCTS18	0	// Delta18 signals18
`define UART_MS_DDSR18	1
`define UART_MS_TERI18	2
`define UART_MS_DDCD18	3
`define UART_MS_CCTS18	4	// Complement18 signals18
`define UART_MS_CDSR18	5
`define UART_MS_CRI18	6
`define UART_MS_CDCD18	7

// FIFO parameter defines18

`define UART_FIFO_WIDTH18	8
`define UART_FIFO_DEPTH18	16
`define UART_FIFO_POINTER_W18	4
`define UART_FIFO_COUNTER_W18	5
// receiver18 fifo has width 11 because it has break, parity18 and framing18 error bits
`define UART_FIFO_REC_WIDTH18  11


`define VERBOSE_WB18  0           // All activity18 on the WISHBONE18 is recorded18
`define VERBOSE_LINE_STATUS18 0   // Details18 about18 the lsr18 (line status register)
`define FAST_TEST18   1           // 64/1024 packets18 are sent18







