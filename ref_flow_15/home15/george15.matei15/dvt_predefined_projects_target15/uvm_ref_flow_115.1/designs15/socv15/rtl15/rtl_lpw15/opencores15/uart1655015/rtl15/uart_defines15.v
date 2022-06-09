//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines15.v                                              ////
////                                                              ////
////                                                              ////
////  This15 file is part of the "UART15 16550 compatible15" project15    ////
////  http15://www15.opencores15.org15/cores15/uart1655015/                   ////
////                                                              ////
////  Documentation15 related15 to this project15:                      ////
////  - http15://www15.opencores15.org15/cores15/uart1655015/                 ////
////                                                              ////
////  Projects15 compatibility15:                                     ////
////  - WISHBONE15                                                  ////
////  RS23215 Protocol15                                              ////
////  16550D uart15 (mostly15 supported)                              ////
////                                                              ////
////  Overview15 (main15 Features15):                                   ////
////  Defines15 of the Core15                                         ////
////                                                              ////
////  Known15 problems15 (limits15):                                    ////
////  None15                                                        ////
////                                                              ////
////  To15 Do15:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author15(s):                                                  ////
////      - gorban15@opencores15.org15                                  ////
////      - Jacob15 Gorban15                                          ////
////      - Igor15 Mohor15 (igorm15@opencores15.org15)                      ////
////                                                              ////
////  Created15:        2001/05/12                                  ////
////  Last15 Updated15:   2001/05/17                                  ////
////                  (See log15 for the revision15 history15)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright15 (C) 2000, 2001 Authors15                             ////
////                                                              ////
//// This15 source15 file may be used and distributed15 without         ////
//// restriction15 provided that this copyright15 statement15 is not    ////
//// removed from the file and that any derivative15 work15 contains15  ////
//// the original copyright15 notice15 and the associated disclaimer15. ////
////                                                              ////
//// This15 source15 file is free software15; you can redistribute15 it   ////
//// and/or modify it under the terms15 of the GNU15 Lesser15 General15   ////
//// Public15 License15 as published15 by the Free15 Software15 Foundation15; ////
//// either15 version15 2.1 of the License15, or (at your15 option) any   ////
//// later15 version15.                                               ////
////                                                              ////
//// This15 source15 is distributed15 in the hope15 that it will be       ////
//// useful15, but WITHOUT15 ANY15 WARRANTY15; without even15 the implied15   ////
//// warranty15 of MERCHANTABILITY15 or FITNESS15 FOR15 A PARTICULAR15      ////
//// PURPOSE15.  See the GNU15 Lesser15 General15 Public15 License15 for more ////
//// details15.                                                     ////
////                                                              ////
//// You should have received15 a copy of the GNU15 Lesser15 General15    ////
//// Public15 License15 along15 with this source15; if not, download15 it   ////
//// from http15://www15.opencores15.org15/lgpl15.shtml15                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS15 Revision15 History15
//
// $Log: not supported by cvs2svn15 $
// Revision15 1.13  2003/06/11 16:37:47  gorban15
// This15 fixes15 errors15 in some15 cases15 when data is being read and put to the FIFO at the same time. Patch15 is submitted15 by Scott15 Furman15. Update is very15 recommended15.
//
// Revision15 1.12  2002/07/22 23:02:23  gorban15
// Bug15 Fixes15:
//  * Possible15 loss of sync and bad15 reception15 of stop bit on slow15 baud15 rates15 fixed15.
//   Problem15 reported15 by Kenny15.Tung15.
//  * Bad (or lack15 of ) loopback15 handling15 fixed15. Reported15 by Cherry15 Withers15.
//
// Improvements15:
//  * Made15 FIFO's as general15 inferrable15 memory where possible15.
//  So15 on FPGA15 they should be inferred15 as RAM15 (Distributed15 RAM15 on Xilinx15).
//  This15 saves15 about15 1/3 of the Slice15 count and reduces15 P&R and synthesis15 times.
//
//  * Added15 optional15 baudrate15 output (baud_o15).
//  This15 is identical15 to BAUDOUT15* signal15 on 16550 chip15.
//  It outputs15 16xbit_clock_rate - the divided15 clock15.
//  It's disabled by default. Define15 UART_HAS_BAUDRATE_OUTPUT15 to use.
//
// Revision15 1.10  2001/12/11 08:55:40  mohor15
// Scratch15 register define added.
//
// Revision15 1.9  2001/12/03 21:44:29  gorban15
// Updated15 specification15 documentation.
// Added15 full 32-bit data bus interface, now as default.
// Address is 5-bit wide15 in 32-bit data bus mode.
// Added15 wb_sel_i15 input to the core15. It's used in the 32-bit mode.
// Added15 debug15 interface with two15 32-bit read-only registers in 32-bit mode.
// Bits15 5 and 6 of LSR15 are now only cleared15 on TX15 FIFO write.
// My15 small test bench15 is modified to work15 with 32-bit mode.
//
// Revision15 1.8  2001/11/26 21:38:54  gorban15
// Lots15 of fixes15:
// Break15 condition wasn15't handled15 correctly at all.
// LSR15 bits could lose15 their15 values.
// LSR15 value after reset was wrong15.
// Timing15 of THRE15 interrupt15 signal15 corrected15.
// LSR15 bit 0 timing15 corrected15.
//
// Revision15 1.7  2001/08/24 21:01:12  mohor15
// Things15 connected15 to parity15 changed.
// Clock15 devider15 changed.
//
// Revision15 1.6  2001/08/23 16:05:05  mohor15
// Stop bit bug15 fixed15.
// Parity15 bug15 fixed15.
// WISHBONE15 read cycle bug15 fixed15,
// OE15 indicator15 (Overrun15 Error) bug15 fixed15.
// PE15 indicator15 (Parity15 Error) bug15 fixed15.
// Register read bug15 fixed15.
//
// Revision15 1.5  2001/05/31 20:08:01  gorban15
// FIFO changes15 and other corrections15.
//
// Revision15 1.4  2001/05/21 19:12:02  gorban15
// Corrected15 some15 Linter15 messages15.
//
// Revision15 1.3  2001/05/17 18:34:18  gorban15
// First15 'stable' release. Should15 be sythesizable15 now. Also15 added new header.
//
// Revision15 1.0  2001-05-17 21:27:11+02  jacob15
// Initial15 revision15
//
//

// remove comments15 to restore15 to use the new version15 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i15 signal15 is used to put data in correct15 place15
// also, in 8-bit version15 there15'll be no debugging15 features15 included15
// CAUTION15: doesn't work15 with current version15 of OR120015
//`define DATA_BUS_WIDTH_815

`ifdef DATA_BUS_WIDTH_815
 `define UART_ADDR_WIDTH15 3
 `define UART_DATA_WIDTH15 8
`else
 `define UART_ADDR_WIDTH15 5
 `define UART_DATA_WIDTH15 32
`endif

// Uncomment15 this if you want15 your15 UART15 to have
// 16xBaudrate output port.
// If15 defined, the enable signal15 will be used to drive15 baudrate_o15 signal15
// It's frequency15 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT15

// Register addresses15
`define UART_REG_RB15	`UART_ADDR_WIDTH15'd0	// receiver15 buffer15
`define UART_REG_TR15  `UART_ADDR_WIDTH15'd0	// transmitter15
`define UART_REG_IE15	`UART_ADDR_WIDTH15'd1	// Interrupt15 enable
`define UART_REG_II15  `UART_ADDR_WIDTH15'd2	// Interrupt15 identification15
`define UART_REG_FC15  `UART_ADDR_WIDTH15'd2	// FIFO control15
`define UART_REG_LC15	`UART_ADDR_WIDTH15'd3	// Line15 Control15
`define UART_REG_MC15	`UART_ADDR_WIDTH15'd4	// Modem15 control15
`define UART_REG_LS15  `UART_ADDR_WIDTH15'd5	// Line15 status
`define UART_REG_MS15  `UART_ADDR_WIDTH15'd6	// Modem15 status
`define UART_REG_SR15  `UART_ADDR_WIDTH15'd7	// Scratch15 register
`define UART_REG_DL115	`UART_ADDR_WIDTH15'd0	// Divisor15 latch15 bytes (1-2)
`define UART_REG_DL215	`UART_ADDR_WIDTH15'd1

// Interrupt15 Enable15 register bits
`define UART_IE_RDA15	0	// Received15 Data available interrupt15
`define UART_IE_THRE15	1	// Transmitter15 Holding15 Register empty15 interrupt15
`define UART_IE_RLS15	2	// Receiver15 Line15 Status Interrupt15
`define UART_IE_MS15	3	// Modem15 Status Interrupt15

// Interrupt15 Identification15 register bits
`define UART_II_IP15	0	// Interrupt15 pending when 0
`define UART_II_II15	3:1	// Interrupt15 identification15

// Interrupt15 identification15 values for bits 3:1
`define UART_II_RLS15	3'b011	// Receiver15 Line15 Status
`define UART_II_RDA15	3'b010	// Receiver15 Data available
`define UART_II_TI15	3'b110	// Timeout15 Indication15
`define UART_II_THRE15	3'b001	// Transmitter15 Holding15 Register empty15
`define UART_II_MS15	3'b000	// Modem15 Status

// FIFO Control15 Register bits
`define UART_FC_TL15	1:0	// Trigger15 level

// FIFO trigger level values
`define UART_FC_115		2'b00
`define UART_FC_415		2'b01
`define UART_FC_815		2'b10
`define UART_FC_1415	2'b11

// Line15 Control15 register bits
`define UART_LC_BITS15	1:0	// bits in character15
`define UART_LC_SB15	2	// stop bits
`define UART_LC_PE15	3	// parity15 enable
`define UART_LC_EP15	4	// even15 parity15
`define UART_LC_SP15	5	// stick15 parity15
`define UART_LC_BC15	6	// Break15 control15
`define UART_LC_DL15	7	// Divisor15 Latch15 access bit

// Modem15 Control15 register bits
`define UART_MC_DTR15	0
`define UART_MC_RTS15	1
`define UART_MC_OUT115	2
`define UART_MC_OUT215	3
`define UART_MC_LB15	4	// Loopback15 mode

// Line15 Status Register bits
`define UART_LS_DR15	0	// Data ready
`define UART_LS_OE15	1	// Overrun15 Error
`define UART_LS_PE15	2	// Parity15 Error
`define UART_LS_FE15	3	// Framing15 Error
`define UART_LS_BI15	4	// Break15 interrupt15
`define UART_LS_TFE15	5	// Transmit15 FIFO is empty15
`define UART_LS_TE15	6	// Transmitter15 Empty15 indicator15
`define UART_LS_EI15	7	// Error indicator15

// Modem15 Status Register bits
`define UART_MS_DCTS15	0	// Delta15 signals15
`define UART_MS_DDSR15	1
`define UART_MS_TERI15	2
`define UART_MS_DDCD15	3
`define UART_MS_CCTS15	4	// Complement15 signals15
`define UART_MS_CDSR15	5
`define UART_MS_CRI15	6
`define UART_MS_CDCD15	7

// FIFO parameter defines15

`define UART_FIFO_WIDTH15	8
`define UART_FIFO_DEPTH15	16
`define UART_FIFO_POINTER_W15	4
`define UART_FIFO_COUNTER_W15	5
// receiver15 fifo has width 11 because it has break, parity15 and framing15 error bits
`define UART_FIFO_REC_WIDTH15  11


`define VERBOSE_WB15  0           // All activity15 on the WISHBONE15 is recorded15
`define VERBOSE_LINE_STATUS15 0   // Details15 about15 the lsr15 (line status register)
`define FAST_TEST15   1           // 64/1024 packets15 are sent15







