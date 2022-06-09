//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines26.v                                              ////
////                                                              ////
////                                                              ////
////  This26 file is part of the "UART26 16550 compatible26" project26    ////
////  http26://www26.opencores26.org26/cores26/uart1655026/                   ////
////                                                              ////
////  Documentation26 related26 to this project26:                      ////
////  - http26://www26.opencores26.org26/cores26/uart1655026/                 ////
////                                                              ////
////  Projects26 compatibility26:                                     ////
////  - WISHBONE26                                                  ////
////  RS23226 Protocol26                                              ////
////  16550D uart26 (mostly26 supported)                              ////
////                                                              ////
////  Overview26 (main26 Features26):                                   ////
////  Defines26 of the Core26                                         ////
////                                                              ////
////  Known26 problems26 (limits26):                                    ////
////  None26                                                        ////
////                                                              ////
////  To26 Do26:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author26(s):                                                  ////
////      - gorban26@opencores26.org26                                  ////
////      - Jacob26 Gorban26                                          ////
////      - Igor26 Mohor26 (igorm26@opencores26.org26)                      ////
////                                                              ////
////  Created26:        2001/05/12                                  ////
////  Last26 Updated26:   2001/05/17                                  ////
////                  (See log26 for the revision26 history26)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright26 (C) 2000, 2001 Authors26                             ////
////                                                              ////
//// This26 source26 file may be used and distributed26 without         ////
//// restriction26 provided that this copyright26 statement26 is not    ////
//// removed from the file and that any derivative26 work26 contains26  ////
//// the original copyright26 notice26 and the associated disclaimer26. ////
////                                                              ////
//// This26 source26 file is free software26; you can redistribute26 it   ////
//// and/or modify it under the terms26 of the GNU26 Lesser26 General26   ////
//// Public26 License26 as published26 by the Free26 Software26 Foundation26; ////
//// either26 version26 2.1 of the License26, or (at your26 option) any   ////
//// later26 version26.                                               ////
////                                                              ////
//// This26 source26 is distributed26 in the hope26 that it will be       ////
//// useful26, but WITHOUT26 ANY26 WARRANTY26; without even26 the implied26   ////
//// warranty26 of MERCHANTABILITY26 or FITNESS26 FOR26 A PARTICULAR26      ////
//// PURPOSE26.  See the GNU26 Lesser26 General26 Public26 License26 for more ////
//// details26.                                                     ////
////                                                              ////
//// You should have received26 a copy of the GNU26 Lesser26 General26    ////
//// Public26 License26 along26 with this source26; if not, download26 it   ////
//// from http26://www26.opencores26.org26/lgpl26.shtml26                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS26 Revision26 History26
//
// $Log: not supported by cvs2svn26 $
// Revision26 1.13  2003/06/11 16:37:47  gorban26
// This26 fixes26 errors26 in some26 cases26 when data is being read and put to the FIFO at the same time. Patch26 is submitted26 by Scott26 Furman26. Update is very26 recommended26.
//
// Revision26 1.12  2002/07/22 23:02:23  gorban26
// Bug26 Fixes26:
//  * Possible26 loss of sync and bad26 reception26 of stop bit on slow26 baud26 rates26 fixed26.
//   Problem26 reported26 by Kenny26.Tung26.
//  * Bad (or lack26 of ) loopback26 handling26 fixed26. Reported26 by Cherry26 Withers26.
//
// Improvements26:
//  * Made26 FIFO's as general26 inferrable26 memory where possible26.
//  So26 on FPGA26 they should be inferred26 as RAM26 (Distributed26 RAM26 on Xilinx26).
//  This26 saves26 about26 1/3 of the Slice26 count and reduces26 P&R and synthesis26 times.
//
//  * Added26 optional26 baudrate26 output (baud_o26).
//  This26 is identical26 to BAUDOUT26* signal26 on 16550 chip26.
//  It outputs26 16xbit_clock_rate - the divided26 clock26.
//  It's disabled by default. Define26 UART_HAS_BAUDRATE_OUTPUT26 to use.
//
// Revision26 1.10  2001/12/11 08:55:40  mohor26
// Scratch26 register define added.
//
// Revision26 1.9  2001/12/03 21:44:29  gorban26
// Updated26 specification26 documentation.
// Added26 full 32-bit data bus interface, now as default.
// Address is 5-bit wide26 in 32-bit data bus mode.
// Added26 wb_sel_i26 input to the core26. It's used in the 32-bit mode.
// Added26 debug26 interface with two26 32-bit read-only registers in 32-bit mode.
// Bits26 5 and 6 of LSR26 are now only cleared26 on TX26 FIFO write.
// My26 small test bench26 is modified to work26 with 32-bit mode.
//
// Revision26 1.8  2001/11/26 21:38:54  gorban26
// Lots26 of fixes26:
// Break26 condition wasn26't handled26 correctly at all.
// LSR26 bits could lose26 their26 values.
// LSR26 value after reset was wrong26.
// Timing26 of THRE26 interrupt26 signal26 corrected26.
// LSR26 bit 0 timing26 corrected26.
//
// Revision26 1.7  2001/08/24 21:01:12  mohor26
// Things26 connected26 to parity26 changed.
// Clock26 devider26 changed.
//
// Revision26 1.6  2001/08/23 16:05:05  mohor26
// Stop bit bug26 fixed26.
// Parity26 bug26 fixed26.
// WISHBONE26 read cycle bug26 fixed26,
// OE26 indicator26 (Overrun26 Error) bug26 fixed26.
// PE26 indicator26 (Parity26 Error) bug26 fixed26.
// Register read bug26 fixed26.
//
// Revision26 1.5  2001/05/31 20:08:01  gorban26
// FIFO changes26 and other corrections26.
//
// Revision26 1.4  2001/05/21 19:12:02  gorban26
// Corrected26 some26 Linter26 messages26.
//
// Revision26 1.3  2001/05/17 18:34:18  gorban26
// First26 'stable' release. Should26 be sythesizable26 now. Also26 added new header.
//
// Revision26 1.0  2001-05-17 21:27:11+02  jacob26
// Initial26 revision26
//
//

// remove comments26 to restore26 to use the new version26 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i26 signal26 is used to put data in correct26 place26
// also, in 8-bit version26 there26'll be no debugging26 features26 included26
// CAUTION26: doesn't work26 with current version26 of OR120026
//`define DATA_BUS_WIDTH_826

`ifdef DATA_BUS_WIDTH_826
 `define UART_ADDR_WIDTH26 3
 `define UART_DATA_WIDTH26 8
`else
 `define UART_ADDR_WIDTH26 5
 `define UART_DATA_WIDTH26 32
`endif

// Uncomment26 this if you want26 your26 UART26 to have
// 16xBaudrate output port.
// If26 defined, the enable signal26 will be used to drive26 baudrate_o26 signal26
// It's frequency26 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT26

// Register addresses26
`define UART_REG_RB26	`UART_ADDR_WIDTH26'd0	// receiver26 buffer26
`define UART_REG_TR26  `UART_ADDR_WIDTH26'd0	// transmitter26
`define UART_REG_IE26	`UART_ADDR_WIDTH26'd1	// Interrupt26 enable
`define UART_REG_II26  `UART_ADDR_WIDTH26'd2	// Interrupt26 identification26
`define UART_REG_FC26  `UART_ADDR_WIDTH26'd2	// FIFO control26
`define UART_REG_LC26	`UART_ADDR_WIDTH26'd3	// Line26 Control26
`define UART_REG_MC26	`UART_ADDR_WIDTH26'd4	// Modem26 control26
`define UART_REG_LS26  `UART_ADDR_WIDTH26'd5	// Line26 status
`define UART_REG_MS26  `UART_ADDR_WIDTH26'd6	// Modem26 status
`define UART_REG_SR26  `UART_ADDR_WIDTH26'd7	// Scratch26 register
`define UART_REG_DL126	`UART_ADDR_WIDTH26'd0	// Divisor26 latch26 bytes (1-2)
`define UART_REG_DL226	`UART_ADDR_WIDTH26'd1

// Interrupt26 Enable26 register bits
`define UART_IE_RDA26	0	// Received26 Data available interrupt26
`define UART_IE_THRE26	1	// Transmitter26 Holding26 Register empty26 interrupt26
`define UART_IE_RLS26	2	// Receiver26 Line26 Status Interrupt26
`define UART_IE_MS26	3	// Modem26 Status Interrupt26

// Interrupt26 Identification26 register bits
`define UART_II_IP26	0	// Interrupt26 pending when 0
`define UART_II_II26	3:1	// Interrupt26 identification26

// Interrupt26 identification26 values for bits 3:1
`define UART_II_RLS26	3'b011	// Receiver26 Line26 Status
`define UART_II_RDA26	3'b010	// Receiver26 Data available
`define UART_II_TI26	3'b110	// Timeout26 Indication26
`define UART_II_THRE26	3'b001	// Transmitter26 Holding26 Register empty26
`define UART_II_MS26	3'b000	// Modem26 Status

// FIFO Control26 Register bits
`define UART_FC_TL26	1:0	// Trigger26 level

// FIFO trigger level values
`define UART_FC_126		2'b00
`define UART_FC_426		2'b01
`define UART_FC_826		2'b10
`define UART_FC_1426	2'b11

// Line26 Control26 register bits
`define UART_LC_BITS26	1:0	// bits in character26
`define UART_LC_SB26	2	// stop bits
`define UART_LC_PE26	3	// parity26 enable
`define UART_LC_EP26	4	// even26 parity26
`define UART_LC_SP26	5	// stick26 parity26
`define UART_LC_BC26	6	// Break26 control26
`define UART_LC_DL26	7	// Divisor26 Latch26 access bit

// Modem26 Control26 register bits
`define UART_MC_DTR26	0
`define UART_MC_RTS26	1
`define UART_MC_OUT126	2
`define UART_MC_OUT226	3
`define UART_MC_LB26	4	// Loopback26 mode

// Line26 Status Register bits
`define UART_LS_DR26	0	// Data ready
`define UART_LS_OE26	1	// Overrun26 Error
`define UART_LS_PE26	2	// Parity26 Error
`define UART_LS_FE26	3	// Framing26 Error
`define UART_LS_BI26	4	// Break26 interrupt26
`define UART_LS_TFE26	5	// Transmit26 FIFO is empty26
`define UART_LS_TE26	6	// Transmitter26 Empty26 indicator26
`define UART_LS_EI26	7	// Error indicator26

// Modem26 Status Register bits
`define UART_MS_DCTS26	0	// Delta26 signals26
`define UART_MS_DDSR26	1
`define UART_MS_TERI26	2
`define UART_MS_DDCD26	3
`define UART_MS_CCTS26	4	// Complement26 signals26
`define UART_MS_CDSR26	5
`define UART_MS_CRI26	6
`define UART_MS_CDCD26	7

// FIFO parameter defines26

`define UART_FIFO_WIDTH26	8
`define UART_FIFO_DEPTH26	16
`define UART_FIFO_POINTER_W26	4
`define UART_FIFO_COUNTER_W26	5
// receiver26 fifo has width 11 because it has break, parity26 and framing26 error bits
`define UART_FIFO_REC_WIDTH26  11


`define VERBOSE_WB26  0           // All activity26 on the WISHBONE26 is recorded26
`define VERBOSE_LINE_STATUS26 0   // Details26 about26 the lsr26 (line status register)
`define FAST_TEST26   1           // 64/1024 packets26 are sent26







