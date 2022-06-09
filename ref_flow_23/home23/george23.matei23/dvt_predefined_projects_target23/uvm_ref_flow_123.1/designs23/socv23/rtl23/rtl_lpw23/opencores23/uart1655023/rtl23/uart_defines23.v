//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines23.v                                              ////
////                                                              ////
////                                                              ////
////  This23 file is part of the "UART23 16550 compatible23" project23    ////
////  http23://www23.opencores23.org23/cores23/uart1655023/                   ////
////                                                              ////
////  Documentation23 related23 to this project23:                      ////
////  - http23://www23.opencores23.org23/cores23/uart1655023/                 ////
////                                                              ////
////  Projects23 compatibility23:                                     ////
////  - WISHBONE23                                                  ////
////  RS23223 Protocol23                                              ////
////  16550D uart23 (mostly23 supported)                              ////
////                                                              ////
////  Overview23 (main23 Features23):                                   ////
////  Defines23 of the Core23                                         ////
////                                                              ////
////  Known23 problems23 (limits23):                                    ////
////  None23                                                        ////
////                                                              ////
////  To23 Do23:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author23(s):                                                  ////
////      - gorban23@opencores23.org23                                  ////
////      - Jacob23 Gorban23                                          ////
////      - Igor23 Mohor23 (igorm23@opencores23.org23)                      ////
////                                                              ////
////  Created23:        2001/05/12                                  ////
////  Last23 Updated23:   2001/05/17                                  ////
////                  (See log23 for the revision23 history23)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2000, 2001 Authors23                             ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS23 Revision23 History23
//
// $Log: not supported by cvs2svn23 $
// Revision23 1.13  2003/06/11 16:37:47  gorban23
// This23 fixes23 errors23 in some23 cases23 when data is being read and put to the FIFO at the same time. Patch23 is submitted23 by Scott23 Furman23. Update is very23 recommended23.
//
// Revision23 1.12  2002/07/22 23:02:23  gorban23
// Bug23 Fixes23:
//  * Possible23 loss of sync and bad23 reception23 of stop bit on slow23 baud23 rates23 fixed23.
//   Problem23 reported23 by Kenny23.Tung23.
//  * Bad (or lack23 of ) loopback23 handling23 fixed23. Reported23 by Cherry23 Withers23.
//
// Improvements23:
//  * Made23 FIFO's as general23 inferrable23 memory where possible23.
//  So23 on FPGA23 they should be inferred23 as RAM23 (Distributed23 RAM23 on Xilinx23).
//  This23 saves23 about23 1/3 of the Slice23 count and reduces23 P&R and synthesis23 times.
//
//  * Added23 optional23 baudrate23 output (baud_o23).
//  This23 is identical23 to BAUDOUT23* signal23 on 16550 chip23.
//  It outputs23 16xbit_clock_rate - the divided23 clock23.
//  It's disabled by default. Define23 UART_HAS_BAUDRATE_OUTPUT23 to use.
//
// Revision23 1.10  2001/12/11 08:55:40  mohor23
// Scratch23 register define added.
//
// Revision23 1.9  2001/12/03 21:44:29  gorban23
// Updated23 specification23 documentation.
// Added23 full 32-bit data bus interface, now as default.
// Address is 5-bit wide23 in 32-bit data bus mode.
// Added23 wb_sel_i23 input to the core23. It's used in the 32-bit mode.
// Added23 debug23 interface with two23 32-bit read-only registers in 32-bit mode.
// Bits23 5 and 6 of LSR23 are now only cleared23 on TX23 FIFO write.
// My23 small test bench23 is modified to work23 with 32-bit mode.
//
// Revision23 1.8  2001/11/26 21:38:54  gorban23
// Lots23 of fixes23:
// Break23 condition wasn23't handled23 correctly at all.
// LSR23 bits could lose23 their23 values.
// LSR23 value after reset was wrong23.
// Timing23 of THRE23 interrupt23 signal23 corrected23.
// LSR23 bit 0 timing23 corrected23.
//
// Revision23 1.7  2001/08/24 21:01:12  mohor23
// Things23 connected23 to parity23 changed.
// Clock23 devider23 changed.
//
// Revision23 1.6  2001/08/23 16:05:05  mohor23
// Stop bit bug23 fixed23.
// Parity23 bug23 fixed23.
// WISHBONE23 read cycle bug23 fixed23,
// OE23 indicator23 (Overrun23 Error) bug23 fixed23.
// PE23 indicator23 (Parity23 Error) bug23 fixed23.
// Register read bug23 fixed23.
//
// Revision23 1.5  2001/05/31 20:08:01  gorban23
// FIFO changes23 and other corrections23.
//
// Revision23 1.4  2001/05/21 19:12:02  gorban23
// Corrected23 some23 Linter23 messages23.
//
// Revision23 1.3  2001/05/17 18:34:18  gorban23
// First23 'stable' release. Should23 be sythesizable23 now. Also23 added new header.
//
// Revision23 1.0  2001-05-17 21:27:11+02  jacob23
// Initial23 revision23
//
//

// remove comments23 to restore23 to use the new version23 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i23 signal23 is used to put data in correct23 place23
// also, in 8-bit version23 there23'll be no debugging23 features23 included23
// CAUTION23: doesn't work23 with current version23 of OR120023
//`define DATA_BUS_WIDTH_823

`ifdef DATA_BUS_WIDTH_823
 `define UART_ADDR_WIDTH23 3
 `define UART_DATA_WIDTH23 8
`else
 `define UART_ADDR_WIDTH23 5
 `define UART_DATA_WIDTH23 32
`endif

// Uncomment23 this if you want23 your23 UART23 to have
// 16xBaudrate output port.
// If23 defined, the enable signal23 will be used to drive23 baudrate_o23 signal23
// It's frequency23 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT23

// Register addresses23
`define UART_REG_RB23	`UART_ADDR_WIDTH23'd0	// receiver23 buffer23
`define UART_REG_TR23  `UART_ADDR_WIDTH23'd0	// transmitter23
`define UART_REG_IE23	`UART_ADDR_WIDTH23'd1	// Interrupt23 enable
`define UART_REG_II23  `UART_ADDR_WIDTH23'd2	// Interrupt23 identification23
`define UART_REG_FC23  `UART_ADDR_WIDTH23'd2	// FIFO control23
`define UART_REG_LC23	`UART_ADDR_WIDTH23'd3	// Line23 Control23
`define UART_REG_MC23	`UART_ADDR_WIDTH23'd4	// Modem23 control23
`define UART_REG_LS23  `UART_ADDR_WIDTH23'd5	// Line23 status
`define UART_REG_MS23  `UART_ADDR_WIDTH23'd6	// Modem23 status
`define UART_REG_SR23  `UART_ADDR_WIDTH23'd7	// Scratch23 register
`define UART_REG_DL123	`UART_ADDR_WIDTH23'd0	// Divisor23 latch23 bytes (1-2)
`define UART_REG_DL223	`UART_ADDR_WIDTH23'd1

// Interrupt23 Enable23 register bits
`define UART_IE_RDA23	0	// Received23 Data available interrupt23
`define UART_IE_THRE23	1	// Transmitter23 Holding23 Register empty23 interrupt23
`define UART_IE_RLS23	2	// Receiver23 Line23 Status Interrupt23
`define UART_IE_MS23	3	// Modem23 Status Interrupt23

// Interrupt23 Identification23 register bits
`define UART_II_IP23	0	// Interrupt23 pending when 0
`define UART_II_II23	3:1	// Interrupt23 identification23

// Interrupt23 identification23 values for bits 3:1
`define UART_II_RLS23	3'b011	// Receiver23 Line23 Status
`define UART_II_RDA23	3'b010	// Receiver23 Data available
`define UART_II_TI23	3'b110	// Timeout23 Indication23
`define UART_II_THRE23	3'b001	// Transmitter23 Holding23 Register empty23
`define UART_II_MS23	3'b000	// Modem23 Status

// FIFO Control23 Register bits
`define UART_FC_TL23	1:0	// Trigger23 level

// FIFO trigger level values
`define UART_FC_123		2'b00
`define UART_FC_423		2'b01
`define UART_FC_823		2'b10
`define UART_FC_1423	2'b11

// Line23 Control23 register bits
`define UART_LC_BITS23	1:0	// bits in character23
`define UART_LC_SB23	2	// stop bits
`define UART_LC_PE23	3	// parity23 enable
`define UART_LC_EP23	4	// even23 parity23
`define UART_LC_SP23	5	// stick23 parity23
`define UART_LC_BC23	6	// Break23 control23
`define UART_LC_DL23	7	// Divisor23 Latch23 access bit

// Modem23 Control23 register bits
`define UART_MC_DTR23	0
`define UART_MC_RTS23	1
`define UART_MC_OUT123	2
`define UART_MC_OUT223	3
`define UART_MC_LB23	4	// Loopback23 mode

// Line23 Status Register bits
`define UART_LS_DR23	0	// Data ready
`define UART_LS_OE23	1	// Overrun23 Error
`define UART_LS_PE23	2	// Parity23 Error
`define UART_LS_FE23	3	// Framing23 Error
`define UART_LS_BI23	4	// Break23 interrupt23
`define UART_LS_TFE23	5	// Transmit23 FIFO is empty23
`define UART_LS_TE23	6	// Transmitter23 Empty23 indicator23
`define UART_LS_EI23	7	// Error indicator23

// Modem23 Status Register bits
`define UART_MS_DCTS23	0	// Delta23 signals23
`define UART_MS_DDSR23	1
`define UART_MS_TERI23	2
`define UART_MS_DDCD23	3
`define UART_MS_CCTS23	4	// Complement23 signals23
`define UART_MS_CDSR23	5
`define UART_MS_CRI23	6
`define UART_MS_CDCD23	7

// FIFO parameter defines23

`define UART_FIFO_WIDTH23	8
`define UART_FIFO_DEPTH23	16
`define UART_FIFO_POINTER_W23	4
`define UART_FIFO_COUNTER_W23	5
// receiver23 fifo has width 11 because it has break, parity23 and framing23 error bits
`define UART_FIFO_REC_WIDTH23  11


`define VERBOSE_WB23  0           // All activity23 on the WISHBONE23 is recorded23
`define VERBOSE_LINE_STATUS23 0   // Details23 about23 the lsr23 (line status register)
`define FAST_TEST23   1           // 64/1024 packets23 are sent23







