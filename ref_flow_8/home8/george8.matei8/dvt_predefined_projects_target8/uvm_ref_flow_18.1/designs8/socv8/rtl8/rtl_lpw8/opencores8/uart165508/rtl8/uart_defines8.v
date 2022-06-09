//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines8.v                                              ////
////                                                              ////
////                                                              ////
////  This8 file is part of the "UART8 16550 compatible8" project8    ////
////  http8://www8.opencores8.org8/cores8/uart165508/                   ////
////                                                              ////
////  Documentation8 related8 to this project8:                      ////
////  - http8://www8.opencores8.org8/cores8/uart165508/                 ////
////                                                              ////
////  Projects8 compatibility8:                                     ////
////  - WISHBONE8                                                  ////
////  RS2328 Protocol8                                              ////
////  16550D uart8 (mostly8 supported)                              ////
////                                                              ////
////  Overview8 (main8 Features8):                                   ////
////  Defines8 of the Core8                                         ////
////                                                              ////
////  Known8 problems8 (limits8):                                    ////
////  None8                                                        ////
////                                                              ////
////  To8 Do8:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author8(s):                                                  ////
////      - gorban8@opencores8.org8                                  ////
////      - Jacob8 Gorban8                                          ////
////      - Igor8 Mohor8 (igorm8@opencores8.org8)                      ////
////                                                              ////
////  Created8:        2001/05/12                                  ////
////  Last8 Updated8:   2001/05/17                                  ////
////                  (See log8 for the revision8 history8)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2000, 2001 Authors8                             ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS8 Revision8 History8
//
// $Log: not supported by cvs2svn8 $
// Revision8 1.13  2003/06/11 16:37:47  gorban8
// This8 fixes8 errors8 in some8 cases8 when data is being read and put to the FIFO at the same time. Patch8 is submitted8 by Scott8 Furman8. Update is very8 recommended8.
//
// Revision8 1.12  2002/07/22 23:02:23  gorban8
// Bug8 Fixes8:
//  * Possible8 loss of sync and bad8 reception8 of stop bit on slow8 baud8 rates8 fixed8.
//   Problem8 reported8 by Kenny8.Tung8.
//  * Bad (or lack8 of ) loopback8 handling8 fixed8. Reported8 by Cherry8 Withers8.
//
// Improvements8:
//  * Made8 FIFO's as general8 inferrable8 memory where possible8.
//  So8 on FPGA8 they should be inferred8 as RAM8 (Distributed8 RAM8 on Xilinx8).
//  This8 saves8 about8 1/3 of the Slice8 count and reduces8 P&R and synthesis8 times.
//
//  * Added8 optional8 baudrate8 output (baud_o8).
//  This8 is identical8 to BAUDOUT8* signal8 on 16550 chip8.
//  It outputs8 16xbit_clock_rate - the divided8 clock8.
//  It's disabled by default. Define8 UART_HAS_BAUDRATE_OUTPUT8 to use.
//
// Revision8 1.10  2001/12/11 08:55:40  mohor8
// Scratch8 register define added.
//
// Revision8 1.9  2001/12/03 21:44:29  gorban8
// Updated8 specification8 documentation.
// Added8 full 32-bit data bus interface, now as default.
// Address is 5-bit wide8 in 32-bit data bus mode.
// Added8 wb_sel_i8 input to the core8. It's used in the 32-bit mode.
// Added8 debug8 interface with two8 32-bit read-only registers in 32-bit mode.
// Bits8 5 and 6 of LSR8 are now only cleared8 on TX8 FIFO write.
// My8 small test bench8 is modified to work8 with 32-bit mode.
//
// Revision8 1.8  2001/11/26 21:38:54  gorban8
// Lots8 of fixes8:
// Break8 condition wasn8't handled8 correctly at all.
// LSR8 bits could lose8 their8 values.
// LSR8 value after reset was wrong8.
// Timing8 of THRE8 interrupt8 signal8 corrected8.
// LSR8 bit 0 timing8 corrected8.
//
// Revision8 1.7  2001/08/24 21:01:12  mohor8
// Things8 connected8 to parity8 changed.
// Clock8 devider8 changed.
//
// Revision8 1.6  2001/08/23 16:05:05  mohor8
// Stop bit bug8 fixed8.
// Parity8 bug8 fixed8.
// WISHBONE8 read cycle bug8 fixed8,
// OE8 indicator8 (Overrun8 Error) bug8 fixed8.
// PE8 indicator8 (Parity8 Error) bug8 fixed8.
// Register read bug8 fixed8.
//
// Revision8 1.5  2001/05/31 20:08:01  gorban8
// FIFO changes8 and other corrections8.
//
// Revision8 1.4  2001/05/21 19:12:02  gorban8
// Corrected8 some8 Linter8 messages8.
//
// Revision8 1.3  2001/05/17 18:34:18  gorban8
// First8 'stable' release. Should8 be sythesizable8 now. Also8 added new header.
//
// Revision8 1.0  2001-05-17 21:27:11+02  jacob8
// Initial8 revision8
//
//

// remove comments8 to restore8 to use the new version8 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i8 signal8 is used to put data in correct8 place8
// also, in 8-bit version8 there8'll be no debugging8 features8 included8
// CAUTION8: doesn't work8 with current version8 of OR12008
//`define DATA_BUS_WIDTH_88

`ifdef DATA_BUS_WIDTH_88
 `define UART_ADDR_WIDTH8 3
 `define UART_DATA_WIDTH8 8
`else
 `define UART_ADDR_WIDTH8 5
 `define UART_DATA_WIDTH8 32
`endif

// Uncomment8 this if you want8 your8 UART8 to have
// 16xBaudrate output port.
// If8 defined, the enable signal8 will be used to drive8 baudrate_o8 signal8
// It's frequency8 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT8

// Register addresses8
`define UART_REG_RB8	`UART_ADDR_WIDTH8'd0	// receiver8 buffer8
`define UART_REG_TR8  `UART_ADDR_WIDTH8'd0	// transmitter8
`define UART_REG_IE8	`UART_ADDR_WIDTH8'd1	// Interrupt8 enable
`define UART_REG_II8  `UART_ADDR_WIDTH8'd2	// Interrupt8 identification8
`define UART_REG_FC8  `UART_ADDR_WIDTH8'd2	// FIFO control8
`define UART_REG_LC8	`UART_ADDR_WIDTH8'd3	// Line8 Control8
`define UART_REG_MC8	`UART_ADDR_WIDTH8'd4	// Modem8 control8
`define UART_REG_LS8  `UART_ADDR_WIDTH8'd5	// Line8 status
`define UART_REG_MS8  `UART_ADDR_WIDTH8'd6	// Modem8 status
`define UART_REG_SR8  `UART_ADDR_WIDTH8'd7	// Scratch8 register
`define UART_REG_DL18	`UART_ADDR_WIDTH8'd0	// Divisor8 latch8 bytes (1-2)
`define UART_REG_DL28	`UART_ADDR_WIDTH8'd1

// Interrupt8 Enable8 register bits
`define UART_IE_RDA8	0	// Received8 Data available interrupt8
`define UART_IE_THRE8	1	// Transmitter8 Holding8 Register empty8 interrupt8
`define UART_IE_RLS8	2	// Receiver8 Line8 Status Interrupt8
`define UART_IE_MS8	3	// Modem8 Status Interrupt8

// Interrupt8 Identification8 register bits
`define UART_II_IP8	0	// Interrupt8 pending when 0
`define UART_II_II8	3:1	// Interrupt8 identification8

// Interrupt8 identification8 values for bits 3:1
`define UART_II_RLS8	3'b011	// Receiver8 Line8 Status
`define UART_II_RDA8	3'b010	// Receiver8 Data available
`define UART_II_TI8	3'b110	// Timeout8 Indication8
`define UART_II_THRE8	3'b001	// Transmitter8 Holding8 Register empty8
`define UART_II_MS8	3'b000	// Modem8 Status

// FIFO Control8 Register bits
`define UART_FC_TL8	1:0	// Trigger8 level

// FIFO trigger level values
`define UART_FC_18		2'b00
`define UART_FC_48		2'b01
`define UART_FC_88		2'b10
`define UART_FC_148	2'b11

// Line8 Control8 register bits
`define UART_LC_BITS8	1:0	// bits in character8
`define UART_LC_SB8	2	// stop bits
`define UART_LC_PE8	3	// parity8 enable
`define UART_LC_EP8	4	// even8 parity8
`define UART_LC_SP8	5	// stick8 parity8
`define UART_LC_BC8	6	// Break8 control8
`define UART_LC_DL8	7	// Divisor8 Latch8 access bit

// Modem8 Control8 register bits
`define UART_MC_DTR8	0
`define UART_MC_RTS8	1
`define UART_MC_OUT18	2
`define UART_MC_OUT28	3
`define UART_MC_LB8	4	// Loopback8 mode

// Line8 Status Register bits
`define UART_LS_DR8	0	// Data ready
`define UART_LS_OE8	1	// Overrun8 Error
`define UART_LS_PE8	2	// Parity8 Error
`define UART_LS_FE8	3	// Framing8 Error
`define UART_LS_BI8	4	// Break8 interrupt8
`define UART_LS_TFE8	5	// Transmit8 FIFO is empty8
`define UART_LS_TE8	6	// Transmitter8 Empty8 indicator8
`define UART_LS_EI8	7	// Error indicator8

// Modem8 Status Register bits
`define UART_MS_DCTS8	0	// Delta8 signals8
`define UART_MS_DDSR8	1
`define UART_MS_TERI8	2
`define UART_MS_DDCD8	3
`define UART_MS_CCTS8	4	// Complement8 signals8
`define UART_MS_CDSR8	5
`define UART_MS_CRI8	6
`define UART_MS_CDCD8	7

// FIFO parameter defines8

`define UART_FIFO_WIDTH8	8
`define UART_FIFO_DEPTH8	16
`define UART_FIFO_POINTER_W8	4
`define UART_FIFO_COUNTER_W8	5
// receiver8 fifo has width 11 because it has break, parity8 and framing8 error bits
`define UART_FIFO_REC_WIDTH8  11


`define VERBOSE_WB8  0           // All activity8 on the WISHBONE8 is recorded8
`define VERBOSE_LINE_STATUS8 0   // Details8 about8 the lsr8 (line status register)
`define FAST_TEST8   1           // 64/1024 packets8 are sent8







