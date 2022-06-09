//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines9.v                                              ////
////                                                              ////
////                                                              ////
////  This9 file is part of the "UART9 16550 compatible9" project9    ////
////  http9://www9.opencores9.org9/cores9/uart165509/                   ////
////                                                              ////
////  Documentation9 related9 to this project9:                      ////
////  - http9://www9.opencores9.org9/cores9/uart165509/                 ////
////                                                              ////
////  Projects9 compatibility9:                                     ////
////  - WISHBONE9                                                  ////
////  RS2329 Protocol9                                              ////
////  16550D uart9 (mostly9 supported)                              ////
////                                                              ////
////  Overview9 (main9 Features9):                                   ////
////  Defines9 of the Core9                                         ////
////                                                              ////
////  Known9 problems9 (limits9):                                    ////
////  None9                                                        ////
////                                                              ////
////  To9 Do9:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author9(s):                                                  ////
////      - gorban9@opencores9.org9                                  ////
////      - Jacob9 Gorban9                                          ////
////      - Igor9 Mohor9 (igorm9@opencores9.org9)                      ////
////                                                              ////
////  Created9:        2001/05/12                                  ////
////  Last9 Updated9:   2001/05/17                                  ////
////                  (See log9 for the revision9 history9)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2000, 2001 Authors9                             ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS9 Revision9 History9
//
// $Log: not supported by cvs2svn9 $
// Revision9 1.13  2003/06/11 16:37:47  gorban9
// This9 fixes9 errors9 in some9 cases9 when data is being read and put to the FIFO at the same time. Patch9 is submitted9 by Scott9 Furman9. Update is very9 recommended9.
//
// Revision9 1.12  2002/07/22 23:02:23  gorban9
// Bug9 Fixes9:
//  * Possible9 loss of sync and bad9 reception9 of stop bit on slow9 baud9 rates9 fixed9.
//   Problem9 reported9 by Kenny9.Tung9.
//  * Bad (or lack9 of ) loopback9 handling9 fixed9. Reported9 by Cherry9 Withers9.
//
// Improvements9:
//  * Made9 FIFO's as general9 inferrable9 memory where possible9.
//  So9 on FPGA9 they should be inferred9 as RAM9 (Distributed9 RAM9 on Xilinx9).
//  This9 saves9 about9 1/3 of the Slice9 count and reduces9 P&R and synthesis9 times.
//
//  * Added9 optional9 baudrate9 output (baud_o9).
//  This9 is identical9 to BAUDOUT9* signal9 on 16550 chip9.
//  It outputs9 16xbit_clock_rate - the divided9 clock9.
//  It's disabled by default. Define9 UART_HAS_BAUDRATE_OUTPUT9 to use.
//
// Revision9 1.10  2001/12/11 08:55:40  mohor9
// Scratch9 register define added.
//
// Revision9 1.9  2001/12/03 21:44:29  gorban9
// Updated9 specification9 documentation.
// Added9 full 32-bit data bus interface, now as default.
// Address is 5-bit wide9 in 32-bit data bus mode.
// Added9 wb_sel_i9 input to the core9. It's used in the 32-bit mode.
// Added9 debug9 interface with two9 32-bit read-only registers in 32-bit mode.
// Bits9 5 and 6 of LSR9 are now only cleared9 on TX9 FIFO write.
// My9 small test bench9 is modified to work9 with 32-bit mode.
//
// Revision9 1.8  2001/11/26 21:38:54  gorban9
// Lots9 of fixes9:
// Break9 condition wasn9't handled9 correctly at all.
// LSR9 bits could lose9 their9 values.
// LSR9 value after reset was wrong9.
// Timing9 of THRE9 interrupt9 signal9 corrected9.
// LSR9 bit 0 timing9 corrected9.
//
// Revision9 1.7  2001/08/24 21:01:12  mohor9
// Things9 connected9 to parity9 changed.
// Clock9 devider9 changed.
//
// Revision9 1.6  2001/08/23 16:05:05  mohor9
// Stop bit bug9 fixed9.
// Parity9 bug9 fixed9.
// WISHBONE9 read cycle bug9 fixed9,
// OE9 indicator9 (Overrun9 Error) bug9 fixed9.
// PE9 indicator9 (Parity9 Error) bug9 fixed9.
// Register read bug9 fixed9.
//
// Revision9 1.5  2001/05/31 20:08:01  gorban9
// FIFO changes9 and other corrections9.
//
// Revision9 1.4  2001/05/21 19:12:02  gorban9
// Corrected9 some9 Linter9 messages9.
//
// Revision9 1.3  2001/05/17 18:34:18  gorban9
// First9 'stable' release. Should9 be sythesizable9 now. Also9 added new header.
//
// Revision9 1.0  2001-05-17 21:27:11+02  jacob9
// Initial9 revision9
//
//

// remove comments9 to restore9 to use the new version9 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i9 signal9 is used to put data in correct9 place9
// also, in 8-bit version9 there9'll be no debugging9 features9 included9
// CAUTION9: doesn't work9 with current version9 of OR12009
//`define DATA_BUS_WIDTH_89

`ifdef DATA_BUS_WIDTH_89
 `define UART_ADDR_WIDTH9 3
 `define UART_DATA_WIDTH9 8
`else
 `define UART_ADDR_WIDTH9 5
 `define UART_DATA_WIDTH9 32
`endif

// Uncomment9 this if you want9 your9 UART9 to have
// 16xBaudrate output port.
// If9 defined, the enable signal9 will be used to drive9 baudrate_o9 signal9
// It's frequency9 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT9

// Register addresses9
`define UART_REG_RB9	`UART_ADDR_WIDTH9'd0	// receiver9 buffer9
`define UART_REG_TR9  `UART_ADDR_WIDTH9'd0	// transmitter9
`define UART_REG_IE9	`UART_ADDR_WIDTH9'd1	// Interrupt9 enable
`define UART_REG_II9  `UART_ADDR_WIDTH9'd2	// Interrupt9 identification9
`define UART_REG_FC9  `UART_ADDR_WIDTH9'd2	// FIFO control9
`define UART_REG_LC9	`UART_ADDR_WIDTH9'd3	// Line9 Control9
`define UART_REG_MC9	`UART_ADDR_WIDTH9'd4	// Modem9 control9
`define UART_REG_LS9  `UART_ADDR_WIDTH9'd5	// Line9 status
`define UART_REG_MS9  `UART_ADDR_WIDTH9'd6	// Modem9 status
`define UART_REG_SR9  `UART_ADDR_WIDTH9'd7	// Scratch9 register
`define UART_REG_DL19	`UART_ADDR_WIDTH9'd0	// Divisor9 latch9 bytes (1-2)
`define UART_REG_DL29	`UART_ADDR_WIDTH9'd1

// Interrupt9 Enable9 register bits
`define UART_IE_RDA9	0	// Received9 Data available interrupt9
`define UART_IE_THRE9	1	// Transmitter9 Holding9 Register empty9 interrupt9
`define UART_IE_RLS9	2	// Receiver9 Line9 Status Interrupt9
`define UART_IE_MS9	3	// Modem9 Status Interrupt9

// Interrupt9 Identification9 register bits
`define UART_II_IP9	0	// Interrupt9 pending when 0
`define UART_II_II9	3:1	// Interrupt9 identification9

// Interrupt9 identification9 values for bits 3:1
`define UART_II_RLS9	3'b011	// Receiver9 Line9 Status
`define UART_II_RDA9	3'b010	// Receiver9 Data available
`define UART_II_TI9	3'b110	// Timeout9 Indication9
`define UART_II_THRE9	3'b001	// Transmitter9 Holding9 Register empty9
`define UART_II_MS9	3'b000	// Modem9 Status

// FIFO Control9 Register bits
`define UART_FC_TL9	1:0	// Trigger9 level

// FIFO trigger level values
`define UART_FC_19		2'b00
`define UART_FC_49		2'b01
`define UART_FC_89		2'b10
`define UART_FC_149	2'b11

// Line9 Control9 register bits
`define UART_LC_BITS9	1:0	// bits in character9
`define UART_LC_SB9	2	// stop bits
`define UART_LC_PE9	3	// parity9 enable
`define UART_LC_EP9	4	// even9 parity9
`define UART_LC_SP9	5	// stick9 parity9
`define UART_LC_BC9	6	// Break9 control9
`define UART_LC_DL9	7	// Divisor9 Latch9 access bit

// Modem9 Control9 register bits
`define UART_MC_DTR9	0
`define UART_MC_RTS9	1
`define UART_MC_OUT19	2
`define UART_MC_OUT29	3
`define UART_MC_LB9	4	// Loopback9 mode

// Line9 Status Register bits
`define UART_LS_DR9	0	// Data ready
`define UART_LS_OE9	1	// Overrun9 Error
`define UART_LS_PE9	2	// Parity9 Error
`define UART_LS_FE9	3	// Framing9 Error
`define UART_LS_BI9	4	// Break9 interrupt9
`define UART_LS_TFE9	5	// Transmit9 FIFO is empty9
`define UART_LS_TE9	6	// Transmitter9 Empty9 indicator9
`define UART_LS_EI9	7	// Error indicator9

// Modem9 Status Register bits
`define UART_MS_DCTS9	0	// Delta9 signals9
`define UART_MS_DDSR9	1
`define UART_MS_TERI9	2
`define UART_MS_DDCD9	3
`define UART_MS_CCTS9	4	// Complement9 signals9
`define UART_MS_CDSR9	5
`define UART_MS_CRI9	6
`define UART_MS_CDCD9	7

// FIFO parameter defines9

`define UART_FIFO_WIDTH9	8
`define UART_FIFO_DEPTH9	16
`define UART_FIFO_POINTER_W9	4
`define UART_FIFO_COUNTER_W9	5
// receiver9 fifo has width 11 because it has break, parity9 and framing9 error bits
`define UART_FIFO_REC_WIDTH9  11


`define VERBOSE_WB9  0           // All activity9 on the WISHBONE9 is recorded9
`define VERBOSE_LINE_STATUS9 0   // Details9 about9 the lsr9 (line status register)
`define FAST_TEST9   1           // 64/1024 packets9 are sent9







