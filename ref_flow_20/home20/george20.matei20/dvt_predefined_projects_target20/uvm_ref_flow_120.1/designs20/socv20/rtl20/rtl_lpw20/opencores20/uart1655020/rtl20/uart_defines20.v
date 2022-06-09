//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines20.v                                              ////
////                                                              ////
////                                                              ////
////  This20 file is part of the "UART20 16550 compatible20" project20    ////
////  http20://www20.opencores20.org20/cores20/uart1655020/                   ////
////                                                              ////
////  Documentation20 related20 to this project20:                      ////
////  - http20://www20.opencores20.org20/cores20/uart1655020/                 ////
////                                                              ////
////  Projects20 compatibility20:                                     ////
////  - WISHBONE20                                                  ////
////  RS23220 Protocol20                                              ////
////  16550D uart20 (mostly20 supported)                              ////
////                                                              ////
////  Overview20 (main20 Features20):                                   ////
////  Defines20 of the Core20                                         ////
////                                                              ////
////  Known20 problems20 (limits20):                                    ////
////  None20                                                        ////
////                                                              ////
////  To20 Do20:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author20(s):                                                  ////
////      - gorban20@opencores20.org20                                  ////
////      - Jacob20 Gorban20                                          ////
////      - Igor20 Mohor20 (igorm20@opencores20.org20)                      ////
////                                                              ////
////  Created20:        2001/05/12                                  ////
////  Last20 Updated20:   2001/05/17                                  ////
////                  (See log20 for the revision20 history20)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright20 (C) 2000, 2001 Authors20                             ////
////                                                              ////
//// This20 source20 file may be used and distributed20 without         ////
//// restriction20 provided that this copyright20 statement20 is not    ////
//// removed from the file and that any derivative20 work20 contains20  ////
//// the original copyright20 notice20 and the associated disclaimer20. ////
////                                                              ////
//// This20 source20 file is free software20; you can redistribute20 it   ////
//// and/or modify it under the terms20 of the GNU20 Lesser20 General20   ////
//// Public20 License20 as published20 by the Free20 Software20 Foundation20; ////
//// either20 version20 2.1 of the License20, or (at your20 option) any   ////
//// later20 version20.                                               ////
////                                                              ////
//// This20 source20 is distributed20 in the hope20 that it will be       ////
//// useful20, but WITHOUT20 ANY20 WARRANTY20; without even20 the implied20   ////
//// warranty20 of MERCHANTABILITY20 or FITNESS20 FOR20 A PARTICULAR20      ////
//// PURPOSE20.  See the GNU20 Lesser20 General20 Public20 License20 for more ////
//// details20.                                                     ////
////                                                              ////
//// You should have received20 a copy of the GNU20 Lesser20 General20    ////
//// Public20 License20 along20 with this source20; if not, download20 it   ////
//// from http20://www20.opencores20.org20/lgpl20.shtml20                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS20 Revision20 History20
//
// $Log: not supported by cvs2svn20 $
// Revision20 1.13  2003/06/11 16:37:47  gorban20
// This20 fixes20 errors20 in some20 cases20 when data is being read and put to the FIFO at the same time. Patch20 is submitted20 by Scott20 Furman20. Update is very20 recommended20.
//
// Revision20 1.12  2002/07/22 23:02:23  gorban20
// Bug20 Fixes20:
//  * Possible20 loss of sync and bad20 reception20 of stop bit on slow20 baud20 rates20 fixed20.
//   Problem20 reported20 by Kenny20.Tung20.
//  * Bad (or lack20 of ) loopback20 handling20 fixed20. Reported20 by Cherry20 Withers20.
//
// Improvements20:
//  * Made20 FIFO's as general20 inferrable20 memory where possible20.
//  So20 on FPGA20 they should be inferred20 as RAM20 (Distributed20 RAM20 on Xilinx20).
//  This20 saves20 about20 1/3 of the Slice20 count and reduces20 P&R and synthesis20 times.
//
//  * Added20 optional20 baudrate20 output (baud_o20).
//  This20 is identical20 to BAUDOUT20* signal20 on 16550 chip20.
//  It outputs20 16xbit_clock_rate - the divided20 clock20.
//  It's disabled by default. Define20 UART_HAS_BAUDRATE_OUTPUT20 to use.
//
// Revision20 1.10  2001/12/11 08:55:40  mohor20
// Scratch20 register define added.
//
// Revision20 1.9  2001/12/03 21:44:29  gorban20
// Updated20 specification20 documentation.
// Added20 full 32-bit data bus interface, now as default.
// Address is 5-bit wide20 in 32-bit data bus mode.
// Added20 wb_sel_i20 input to the core20. It's used in the 32-bit mode.
// Added20 debug20 interface with two20 32-bit read-only registers in 32-bit mode.
// Bits20 5 and 6 of LSR20 are now only cleared20 on TX20 FIFO write.
// My20 small test bench20 is modified to work20 with 32-bit mode.
//
// Revision20 1.8  2001/11/26 21:38:54  gorban20
// Lots20 of fixes20:
// Break20 condition wasn20't handled20 correctly at all.
// LSR20 bits could lose20 their20 values.
// LSR20 value after reset was wrong20.
// Timing20 of THRE20 interrupt20 signal20 corrected20.
// LSR20 bit 0 timing20 corrected20.
//
// Revision20 1.7  2001/08/24 21:01:12  mohor20
// Things20 connected20 to parity20 changed.
// Clock20 devider20 changed.
//
// Revision20 1.6  2001/08/23 16:05:05  mohor20
// Stop bit bug20 fixed20.
// Parity20 bug20 fixed20.
// WISHBONE20 read cycle bug20 fixed20,
// OE20 indicator20 (Overrun20 Error) bug20 fixed20.
// PE20 indicator20 (Parity20 Error) bug20 fixed20.
// Register read bug20 fixed20.
//
// Revision20 1.5  2001/05/31 20:08:01  gorban20
// FIFO changes20 and other corrections20.
//
// Revision20 1.4  2001/05/21 19:12:02  gorban20
// Corrected20 some20 Linter20 messages20.
//
// Revision20 1.3  2001/05/17 18:34:18  gorban20
// First20 'stable' release. Should20 be sythesizable20 now. Also20 added new header.
//
// Revision20 1.0  2001-05-17 21:27:11+02  jacob20
// Initial20 revision20
//
//

// remove comments20 to restore20 to use the new version20 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i20 signal20 is used to put data in correct20 place20
// also, in 8-bit version20 there20'll be no debugging20 features20 included20
// CAUTION20: doesn't work20 with current version20 of OR120020
//`define DATA_BUS_WIDTH_820

`ifdef DATA_BUS_WIDTH_820
 `define UART_ADDR_WIDTH20 3
 `define UART_DATA_WIDTH20 8
`else
 `define UART_ADDR_WIDTH20 5
 `define UART_DATA_WIDTH20 32
`endif

// Uncomment20 this if you want20 your20 UART20 to have
// 16xBaudrate output port.
// If20 defined, the enable signal20 will be used to drive20 baudrate_o20 signal20
// It's frequency20 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT20

// Register addresses20
`define UART_REG_RB20	`UART_ADDR_WIDTH20'd0	// receiver20 buffer20
`define UART_REG_TR20  `UART_ADDR_WIDTH20'd0	// transmitter20
`define UART_REG_IE20	`UART_ADDR_WIDTH20'd1	// Interrupt20 enable
`define UART_REG_II20  `UART_ADDR_WIDTH20'd2	// Interrupt20 identification20
`define UART_REG_FC20  `UART_ADDR_WIDTH20'd2	// FIFO control20
`define UART_REG_LC20	`UART_ADDR_WIDTH20'd3	// Line20 Control20
`define UART_REG_MC20	`UART_ADDR_WIDTH20'd4	// Modem20 control20
`define UART_REG_LS20  `UART_ADDR_WIDTH20'd5	// Line20 status
`define UART_REG_MS20  `UART_ADDR_WIDTH20'd6	// Modem20 status
`define UART_REG_SR20  `UART_ADDR_WIDTH20'd7	// Scratch20 register
`define UART_REG_DL120	`UART_ADDR_WIDTH20'd0	// Divisor20 latch20 bytes (1-2)
`define UART_REG_DL220	`UART_ADDR_WIDTH20'd1

// Interrupt20 Enable20 register bits
`define UART_IE_RDA20	0	// Received20 Data available interrupt20
`define UART_IE_THRE20	1	// Transmitter20 Holding20 Register empty20 interrupt20
`define UART_IE_RLS20	2	// Receiver20 Line20 Status Interrupt20
`define UART_IE_MS20	3	// Modem20 Status Interrupt20

// Interrupt20 Identification20 register bits
`define UART_II_IP20	0	// Interrupt20 pending when 0
`define UART_II_II20	3:1	// Interrupt20 identification20

// Interrupt20 identification20 values for bits 3:1
`define UART_II_RLS20	3'b011	// Receiver20 Line20 Status
`define UART_II_RDA20	3'b010	// Receiver20 Data available
`define UART_II_TI20	3'b110	// Timeout20 Indication20
`define UART_II_THRE20	3'b001	// Transmitter20 Holding20 Register empty20
`define UART_II_MS20	3'b000	// Modem20 Status

// FIFO Control20 Register bits
`define UART_FC_TL20	1:0	// Trigger20 level

// FIFO trigger level values
`define UART_FC_120		2'b00
`define UART_FC_420		2'b01
`define UART_FC_820		2'b10
`define UART_FC_1420	2'b11

// Line20 Control20 register bits
`define UART_LC_BITS20	1:0	// bits in character20
`define UART_LC_SB20	2	// stop bits
`define UART_LC_PE20	3	// parity20 enable
`define UART_LC_EP20	4	// even20 parity20
`define UART_LC_SP20	5	// stick20 parity20
`define UART_LC_BC20	6	// Break20 control20
`define UART_LC_DL20	7	// Divisor20 Latch20 access bit

// Modem20 Control20 register bits
`define UART_MC_DTR20	0
`define UART_MC_RTS20	1
`define UART_MC_OUT120	2
`define UART_MC_OUT220	3
`define UART_MC_LB20	4	// Loopback20 mode

// Line20 Status Register bits
`define UART_LS_DR20	0	// Data ready
`define UART_LS_OE20	1	// Overrun20 Error
`define UART_LS_PE20	2	// Parity20 Error
`define UART_LS_FE20	3	// Framing20 Error
`define UART_LS_BI20	4	// Break20 interrupt20
`define UART_LS_TFE20	5	// Transmit20 FIFO is empty20
`define UART_LS_TE20	6	// Transmitter20 Empty20 indicator20
`define UART_LS_EI20	7	// Error indicator20

// Modem20 Status Register bits
`define UART_MS_DCTS20	0	// Delta20 signals20
`define UART_MS_DDSR20	1
`define UART_MS_TERI20	2
`define UART_MS_DDCD20	3
`define UART_MS_CCTS20	4	// Complement20 signals20
`define UART_MS_CDSR20	5
`define UART_MS_CRI20	6
`define UART_MS_CDCD20	7

// FIFO parameter defines20

`define UART_FIFO_WIDTH20	8
`define UART_FIFO_DEPTH20	16
`define UART_FIFO_POINTER_W20	4
`define UART_FIFO_COUNTER_W20	5
// receiver20 fifo has width 11 because it has break, parity20 and framing20 error bits
`define UART_FIFO_REC_WIDTH20  11


`define VERBOSE_WB20  0           // All activity20 on the WISHBONE20 is recorded20
`define VERBOSE_LINE_STATUS20 0   // Details20 about20 the lsr20 (line status register)
`define FAST_TEST20   1           // 64/1024 packets20 are sent20







