//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines1.v                                              ////
////                                                              ////
////                                                              ////
////  This1 file is part of the "UART1 16550 compatible1" project1    ////
////  http1://www1.opencores1.org1/cores1/uart165501/                   ////
////                                                              ////
////  Documentation1 related1 to this project1:                      ////
////  - http1://www1.opencores1.org1/cores1/uart165501/                 ////
////                                                              ////
////  Projects1 compatibility1:                                     ////
////  - WISHBONE1                                                  ////
////  RS2321 Protocol1                                              ////
////  16550D uart1 (mostly1 supported)                              ////
////                                                              ////
////  Overview1 (main1 Features1):                                   ////
////  Defines1 of the Core1                                         ////
////                                                              ////
////  Known1 problems1 (limits1):                                    ////
////  None1                                                        ////
////                                                              ////
////  To1 Do1:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author1(s):                                                  ////
////      - gorban1@opencores1.org1                                  ////
////      - Jacob1 Gorban1                                          ////
////      - Igor1 Mohor1 (igorm1@opencores1.org1)                      ////
////                                                              ////
////  Created1:        2001/05/12                                  ////
////  Last1 Updated1:   2001/05/17                                  ////
////                  (See log1 for the revision1 history1)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright1 (C) 2000, 2001 Authors1                             ////
////                                                              ////
//// This1 source1 file may be used and distributed1 without         ////
//// restriction1 provided that this copyright1 statement1 is not    ////
//// removed from the file and that any derivative1 work1 contains1  ////
//// the original copyright1 notice1 and the associated disclaimer1. ////
////                                                              ////
//// This1 source1 file is free software1; you can redistribute1 it   ////
//// and/or modify it under the terms1 of the GNU1 Lesser1 General1   ////
//// Public1 License1 as published1 by the Free1 Software1 Foundation1; ////
//// either1 version1 2.1 of the License1, or (at your1 option) any   ////
//// later1 version1.                                               ////
////                                                              ////
//// This1 source1 is distributed1 in the hope1 that it will be       ////
//// useful1, but WITHOUT1 ANY1 WARRANTY1; without even1 the implied1   ////
//// warranty1 of MERCHANTABILITY1 or FITNESS1 FOR1 A PARTICULAR1      ////
//// PURPOSE1.  See the GNU1 Lesser1 General1 Public1 License1 for more ////
//// details1.                                                     ////
////                                                              ////
//// You should have received1 a copy of the GNU1 Lesser1 General1    ////
//// Public1 License1 along1 with this source1; if not, download1 it   ////
//// from http1://www1.opencores1.org1/lgpl1.shtml1                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS1 Revision1 History1
//
// $Log: not supported by cvs2svn1 $
// Revision1 1.13  2003/06/11 16:37:47  gorban1
// This1 fixes1 errors1 in some1 cases1 when data is being read and put to the FIFO at the same time. Patch1 is submitted1 by Scott1 Furman1. Update is very1 recommended1.
//
// Revision1 1.12  2002/07/22 23:02:23  gorban1
// Bug1 Fixes1:
//  * Possible1 loss of sync and bad1 reception1 of stop bit on slow1 baud1 rates1 fixed1.
//   Problem1 reported1 by Kenny1.Tung1.
//  * Bad (or lack1 of ) loopback1 handling1 fixed1. Reported1 by Cherry1 Withers1.
//
// Improvements1:
//  * Made1 FIFO's as general1 inferrable1 memory where possible1.
//  So1 on FPGA1 they should be inferred1 as RAM1 (Distributed1 RAM1 on Xilinx1).
//  This1 saves1 about1 1/3 of the Slice1 count and reduces1 P&R and synthesis1 times.
//
//  * Added1 optional1 baudrate1 output (baud_o1).
//  This1 is identical1 to BAUDOUT1* signal1 on 16550 chip1.
//  It outputs1 16xbit_clock_rate - the divided1 clock1.
//  It's disabled by default. Define1 UART_HAS_BAUDRATE_OUTPUT1 to use.
//
// Revision1 1.10  2001/12/11 08:55:40  mohor1
// Scratch1 register define added.
//
// Revision1 1.9  2001/12/03 21:44:29  gorban1
// Updated1 specification1 documentation.
// Added1 full 32-bit data bus interface, now as default.
// Address is 5-bit wide1 in 32-bit data bus mode.
// Added1 wb_sel_i1 input to the core1. It's used in the 32-bit mode.
// Added1 debug1 interface with two1 32-bit read-only registers in 32-bit mode.
// Bits1 5 and 6 of LSR1 are now only cleared1 on TX1 FIFO write.
// My1 small test bench1 is modified to work1 with 32-bit mode.
//
// Revision1 1.8  2001/11/26 21:38:54  gorban1
// Lots1 of fixes1:
// Break1 condition wasn1't handled1 correctly at all.
// LSR1 bits could lose1 their1 values.
// LSR1 value after reset was wrong1.
// Timing1 of THRE1 interrupt1 signal1 corrected1.
// LSR1 bit 0 timing1 corrected1.
//
// Revision1 1.7  2001/08/24 21:01:12  mohor1
// Things1 connected1 to parity1 changed.
// Clock1 devider1 changed.
//
// Revision1 1.6  2001/08/23 16:05:05  mohor1
// Stop bit bug1 fixed1.
// Parity1 bug1 fixed1.
// WISHBONE1 read cycle bug1 fixed1,
// OE1 indicator1 (Overrun1 Error) bug1 fixed1.
// PE1 indicator1 (Parity1 Error) bug1 fixed1.
// Register read bug1 fixed1.
//
// Revision1 1.5  2001/05/31 20:08:01  gorban1
// FIFO changes1 and other corrections1.
//
// Revision1 1.4  2001/05/21 19:12:02  gorban1
// Corrected1 some1 Linter1 messages1.
//
// Revision1 1.3  2001/05/17 18:34:18  gorban1
// First1 'stable' release. Should1 be sythesizable1 now. Also1 added new header.
//
// Revision1 1.0  2001-05-17 21:27:11+02  jacob1
// Initial1 revision1
//
//

// remove comments1 to restore1 to use the new version1 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i1 signal1 is used to put data in correct1 place1
// also, in 8-bit version1 there1'll be no debugging1 features1 included1
// CAUTION1: doesn't work1 with current version1 of OR12001
//`define DATA_BUS_WIDTH_81

`ifdef DATA_BUS_WIDTH_81
 `define UART_ADDR_WIDTH1 3
 `define UART_DATA_WIDTH1 8
`else
 `define UART_ADDR_WIDTH1 5
 `define UART_DATA_WIDTH1 32
`endif

// Uncomment1 this if you want1 your1 UART1 to have
// 16xBaudrate output port.
// If1 defined, the enable signal1 will be used to drive1 baudrate_o1 signal1
// It's frequency1 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT1

// Register addresses1
`define UART_REG_RB1	`UART_ADDR_WIDTH1'd0	// receiver1 buffer1
`define UART_REG_TR1  `UART_ADDR_WIDTH1'd0	// transmitter1
`define UART_REG_IE1	`UART_ADDR_WIDTH1'd1	// Interrupt1 enable
`define UART_REG_II1  `UART_ADDR_WIDTH1'd2	// Interrupt1 identification1
`define UART_REG_FC1  `UART_ADDR_WIDTH1'd2	// FIFO control1
`define UART_REG_LC1	`UART_ADDR_WIDTH1'd3	// Line1 Control1
`define UART_REG_MC1	`UART_ADDR_WIDTH1'd4	// Modem1 control1
`define UART_REG_LS1  `UART_ADDR_WIDTH1'd5	// Line1 status
`define UART_REG_MS1  `UART_ADDR_WIDTH1'd6	// Modem1 status
`define UART_REG_SR1  `UART_ADDR_WIDTH1'd7	// Scratch1 register
`define UART_REG_DL11	`UART_ADDR_WIDTH1'd0	// Divisor1 latch1 bytes (1-2)
`define UART_REG_DL21	`UART_ADDR_WIDTH1'd1

// Interrupt1 Enable1 register bits
`define UART_IE_RDA1	0	// Received1 Data available interrupt1
`define UART_IE_THRE1	1	// Transmitter1 Holding1 Register empty1 interrupt1
`define UART_IE_RLS1	2	// Receiver1 Line1 Status Interrupt1
`define UART_IE_MS1	3	// Modem1 Status Interrupt1

// Interrupt1 Identification1 register bits
`define UART_II_IP1	0	// Interrupt1 pending when 0
`define UART_II_II1	3:1	// Interrupt1 identification1

// Interrupt1 identification1 values for bits 3:1
`define UART_II_RLS1	3'b011	// Receiver1 Line1 Status
`define UART_II_RDA1	3'b010	// Receiver1 Data available
`define UART_II_TI1	3'b110	// Timeout1 Indication1
`define UART_II_THRE1	3'b001	// Transmitter1 Holding1 Register empty1
`define UART_II_MS1	3'b000	// Modem1 Status

// FIFO Control1 Register bits
`define UART_FC_TL1	1:0	// Trigger1 level

// FIFO trigger level values
`define UART_FC_11		2'b00
`define UART_FC_41		2'b01
`define UART_FC_81		2'b10
`define UART_FC_141	2'b11

// Line1 Control1 register bits
`define UART_LC_BITS1	1:0	// bits in character1
`define UART_LC_SB1	2	// stop bits
`define UART_LC_PE1	3	// parity1 enable
`define UART_LC_EP1	4	// even1 parity1
`define UART_LC_SP1	5	// stick1 parity1
`define UART_LC_BC1	6	// Break1 control1
`define UART_LC_DL1	7	// Divisor1 Latch1 access bit

// Modem1 Control1 register bits
`define UART_MC_DTR1	0
`define UART_MC_RTS1	1
`define UART_MC_OUT11	2
`define UART_MC_OUT21	3
`define UART_MC_LB1	4	// Loopback1 mode

// Line1 Status Register bits
`define UART_LS_DR1	0	// Data ready
`define UART_LS_OE1	1	// Overrun1 Error
`define UART_LS_PE1	2	// Parity1 Error
`define UART_LS_FE1	3	// Framing1 Error
`define UART_LS_BI1	4	// Break1 interrupt1
`define UART_LS_TFE1	5	// Transmit1 FIFO is empty1
`define UART_LS_TE1	6	// Transmitter1 Empty1 indicator1
`define UART_LS_EI1	7	// Error indicator1

// Modem1 Status Register bits
`define UART_MS_DCTS1	0	// Delta1 signals1
`define UART_MS_DDSR1	1
`define UART_MS_TERI1	2
`define UART_MS_DDCD1	3
`define UART_MS_CCTS1	4	// Complement1 signals1
`define UART_MS_CDSR1	5
`define UART_MS_CRI1	6
`define UART_MS_CDCD1	7

// FIFO parameter defines1

`define UART_FIFO_WIDTH1	8
`define UART_FIFO_DEPTH1	16
`define UART_FIFO_POINTER_W1	4
`define UART_FIFO_COUNTER_W1	5
// receiver1 fifo has width 11 because it has break, parity1 and framing1 error bits
`define UART_FIFO_REC_WIDTH1  11


`define VERBOSE_WB1  0           // All activity1 on the WISHBONE1 is recorded1
`define VERBOSE_LINE_STATUS1 0   // Details1 about1 the lsr1 (line status register)
`define FAST_TEST1   1           // 64/1024 packets1 are sent1







