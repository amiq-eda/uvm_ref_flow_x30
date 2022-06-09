//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines14.v                                              ////
////                                                              ////
////                                                              ////
////  This14 file is part of the "UART14 16550 compatible14" project14    ////
////  http14://www14.opencores14.org14/cores14/uart1655014/                   ////
////                                                              ////
////  Documentation14 related14 to this project14:                      ////
////  - http14://www14.opencores14.org14/cores14/uart1655014/                 ////
////                                                              ////
////  Projects14 compatibility14:                                     ////
////  - WISHBONE14                                                  ////
////  RS23214 Protocol14                                              ////
////  16550D uart14 (mostly14 supported)                              ////
////                                                              ////
////  Overview14 (main14 Features14):                                   ////
////  Defines14 of the Core14                                         ////
////                                                              ////
////  Known14 problems14 (limits14):                                    ////
////  None14                                                        ////
////                                                              ////
////  To14 Do14:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author14(s):                                                  ////
////      - gorban14@opencores14.org14                                  ////
////      - Jacob14 Gorban14                                          ////
////      - Igor14 Mohor14 (igorm14@opencores14.org14)                      ////
////                                                              ////
////  Created14:        2001/05/12                                  ////
////  Last14 Updated14:   2001/05/17                                  ////
////                  (See log14 for the revision14 history14)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2000, 2001 Authors14                             ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS14 Revision14 History14
//
// $Log: not supported by cvs2svn14 $
// Revision14 1.13  2003/06/11 16:37:47  gorban14
// This14 fixes14 errors14 in some14 cases14 when data is being read and put to the FIFO at the same time. Patch14 is submitted14 by Scott14 Furman14. Update is very14 recommended14.
//
// Revision14 1.12  2002/07/22 23:02:23  gorban14
// Bug14 Fixes14:
//  * Possible14 loss of sync and bad14 reception14 of stop bit on slow14 baud14 rates14 fixed14.
//   Problem14 reported14 by Kenny14.Tung14.
//  * Bad (or lack14 of ) loopback14 handling14 fixed14. Reported14 by Cherry14 Withers14.
//
// Improvements14:
//  * Made14 FIFO's as general14 inferrable14 memory where possible14.
//  So14 on FPGA14 they should be inferred14 as RAM14 (Distributed14 RAM14 on Xilinx14).
//  This14 saves14 about14 1/3 of the Slice14 count and reduces14 P&R and synthesis14 times.
//
//  * Added14 optional14 baudrate14 output (baud_o14).
//  This14 is identical14 to BAUDOUT14* signal14 on 16550 chip14.
//  It outputs14 16xbit_clock_rate - the divided14 clock14.
//  It's disabled by default. Define14 UART_HAS_BAUDRATE_OUTPUT14 to use.
//
// Revision14 1.10  2001/12/11 08:55:40  mohor14
// Scratch14 register define added.
//
// Revision14 1.9  2001/12/03 21:44:29  gorban14
// Updated14 specification14 documentation.
// Added14 full 32-bit data bus interface, now as default.
// Address is 5-bit wide14 in 32-bit data bus mode.
// Added14 wb_sel_i14 input to the core14. It's used in the 32-bit mode.
// Added14 debug14 interface with two14 32-bit read-only registers in 32-bit mode.
// Bits14 5 and 6 of LSR14 are now only cleared14 on TX14 FIFO write.
// My14 small test bench14 is modified to work14 with 32-bit mode.
//
// Revision14 1.8  2001/11/26 21:38:54  gorban14
// Lots14 of fixes14:
// Break14 condition wasn14't handled14 correctly at all.
// LSR14 bits could lose14 their14 values.
// LSR14 value after reset was wrong14.
// Timing14 of THRE14 interrupt14 signal14 corrected14.
// LSR14 bit 0 timing14 corrected14.
//
// Revision14 1.7  2001/08/24 21:01:12  mohor14
// Things14 connected14 to parity14 changed.
// Clock14 devider14 changed.
//
// Revision14 1.6  2001/08/23 16:05:05  mohor14
// Stop bit bug14 fixed14.
// Parity14 bug14 fixed14.
// WISHBONE14 read cycle bug14 fixed14,
// OE14 indicator14 (Overrun14 Error) bug14 fixed14.
// PE14 indicator14 (Parity14 Error) bug14 fixed14.
// Register read bug14 fixed14.
//
// Revision14 1.5  2001/05/31 20:08:01  gorban14
// FIFO changes14 and other corrections14.
//
// Revision14 1.4  2001/05/21 19:12:02  gorban14
// Corrected14 some14 Linter14 messages14.
//
// Revision14 1.3  2001/05/17 18:34:18  gorban14
// First14 'stable' release. Should14 be sythesizable14 now. Also14 added new header.
//
// Revision14 1.0  2001-05-17 21:27:11+02  jacob14
// Initial14 revision14
//
//

// remove comments14 to restore14 to use the new version14 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i14 signal14 is used to put data in correct14 place14
// also, in 8-bit version14 there14'll be no debugging14 features14 included14
// CAUTION14: doesn't work14 with current version14 of OR120014
//`define DATA_BUS_WIDTH_814

`ifdef DATA_BUS_WIDTH_814
 `define UART_ADDR_WIDTH14 3
 `define UART_DATA_WIDTH14 8
`else
 `define UART_ADDR_WIDTH14 5
 `define UART_DATA_WIDTH14 32
`endif

// Uncomment14 this if you want14 your14 UART14 to have
// 16xBaudrate output port.
// If14 defined, the enable signal14 will be used to drive14 baudrate_o14 signal14
// It's frequency14 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT14

// Register addresses14
`define UART_REG_RB14	`UART_ADDR_WIDTH14'd0	// receiver14 buffer14
`define UART_REG_TR14  `UART_ADDR_WIDTH14'd0	// transmitter14
`define UART_REG_IE14	`UART_ADDR_WIDTH14'd1	// Interrupt14 enable
`define UART_REG_II14  `UART_ADDR_WIDTH14'd2	// Interrupt14 identification14
`define UART_REG_FC14  `UART_ADDR_WIDTH14'd2	// FIFO control14
`define UART_REG_LC14	`UART_ADDR_WIDTH14'd3	// Line14 Control14
`define UART_REG_MC14	`UART_ADDR_WIDTH14'd4	// Modem14 control14
`define UART_REG_LS14  `UART_ADDR_WIDTH14'd5	// Line14 status
`define UART_REG_MS14  `UART_ADDR_WIDTH14'd6	// Modem14 status
`define UART_REG_SR14  `UART_ADDR_WIDTH14'd7	// Scratch14 register
`define UART_REG_DL114	`UART_ADDR_WIDTH14'd0	// Divisor14 latch14 bytes (1-2)
`define UART_REG_DL214	`UART_ADDR_WIDTH14'd1

// Interrupt14 Enable14 register bits
`define UART_IE_RDA14	0	// Received14 Data available interrupt14
`define UART_IE_THRE14	1	// Transmitter14 Holding14 Register empty14 interrupt14
`define UART_IE_RLS14	2	// Receiver14 Line14 Status Interrupt14
`define UART_IE_MS14	3	// Modem14 Status Interrupt14

// Interrupt14 Identification14 register bits
`define UART_II_IP14	0	// Interrupt14 pending when 0
`define UART_II_II14	3:1	// Interrupt14 identification14

// Interrupt14 identification14 values for bits 3:1
`define UART_II_RLS14	3'b011	// Receiver14 Line14 Status
`define UART_II_RDA14	3'b010	// Receiver14 Data available
`define UART_II_TI14	3'b110	// Timeout14 Indication14
`define UART_II_THRE14	3'b001	// Transmitter14 Holding14 Register empty14
`define UART_II_MS14	3'b000	// Modem14 Status

// FIFO Control14 Register bits
`define UART_FC_TL14	1:0	// Trigger14 level

// FIFO trigger level values
`define UART_FC_114		2'b00
`define UART_FC_414		2'b01
`define UART_FC_814		2'b10
`define UART_FC_1414	2'b11

// Line14 Control14 register bits
`define UART_LC_BITS14	1:0	// bits in character14
`define UART_LC_SB14	2	// stop bits
`define UART_LC_PE14	3	// parity14 enable
`define UART_LC_EP14	4	// even14 parity14
`define UART_LC_SP14	5	// stick14 parity14
`define UART_LC_BC14	6	// Break14 control14
`define UART_LC_DL14	7	// Divisor14 Latch14 access bit

// Modem14 Control14 register bits
`define UART_MC_DTR14	0
`define UART_MC_RTS14	1
`define UART_MC_OUT114	2
`define UART_MC_OUT214	3
`define UART_MC_LB14	4	// Loopback14 mode

// Line14 Status Register bits
`define UART_LS_DR14	0	// Data ready
`define UART_LS_OE14	1	// Overrun14 Error
`define UART_LS_PE14	2	// Parity14 Error
`define UART_LS_FE14	3	// Framing14 Error
`define UART_LS_BI14	4	// Break14 interrupt14
`define UART_LS_TFE14	5	// Transmit14 FIFO is empty14
`define UART_LS_TE14	6	// Transmitter14 Empty14 indicator14
`define UART_LS_EI14	7	// Error indicator14

// Modem14 Status Register bits
`define UART_MS_DCTS14	0	// Delta14 signals14
`define UART_MS_DDSR14	1
`define UART_MS_TERI14	2
`define UART_MS_DDCD14	3
`define UART_MS_CCTS14	4	// Complement14 signals14
`define UART_MS_CDSR14	5
`define UART_MS_CRI14	6
`define UART_MS_CDCD14	7

// FIFO parameter defines14

`define UART_FIFO_WIDTH14	8
`define UART_FIFO_DEPTH14	16
`define UART_FIFO_POINTER_W14	4
`define UART_FIFO_COUNTER_W14	5
// receiver14 fifo has width 11 because it has break, parity14 and framing14 error bits
`define UART_FIFO_REC_WIDTH14  11


`define VERBOSE_WB14  0           // All activity14 on the WISHBONE14 is recorded14
`define VERBOSE_LINE_STATUS14 0   // Details14 about14 the lsr14 (line status register)
`define FAST_TEST14   1           // 64/1024 packets14 are sent14







