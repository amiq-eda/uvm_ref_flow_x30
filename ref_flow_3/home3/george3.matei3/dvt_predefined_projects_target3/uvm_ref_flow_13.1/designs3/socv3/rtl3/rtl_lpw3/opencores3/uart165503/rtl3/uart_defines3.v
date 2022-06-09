//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines3.v                                              ////
////                                                              ////
////                                                              ////
////  This3 file is part of the "UART3 16550 compatible3" project3    ////
////  http3://www3.opencores3.org3/cores3/uart165503/                   ////
////                                                              ////
////  Documentation3 related3 to this project3:                      ////
////  - http3://www3.opencores3.org3/cores3/uart165503/                 ////
////                                                              ////
////  Projects3 compatibility3:                                     ////
////  - WISHBONE3                                                  ////
////  RS2323 Protocol3                                              ////
////  16550D uart3 (mostly3 supported)                              ////
////                                                              ////
////  Overview3 (main3 Features3):                                   ////
////  Defines3 of the Core3                                         ////
////                                                              ////
////  Known3 problems3 (limits3):                                    ////
////  None3                                                        ////
////                                                              ////
////  To3 Do3:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author3(s):                                                  ////
////      - gorban3@opencores3.org3                                  ////
////      - Jacob3 Gorban3                                          ////
////      - Igor3 Mohor3 (igorm3@opencores3.org3)                      ////
////                                                              ////
////  Created3:        2001/05/12                                  ////
////  Last3 Updated3:   2001/05/17                                  ////
////                  (See log3 for the revision3 history3)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2000, 2001 Authors3                             ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS3 Revision3 History3
//
// $Log: not supported by cvs2svn3 $
// Revision3 1.13  2003/06/11 16:37:47  gorban3
// This3 fixes3 errors3 in some3 cases3 when data is being read and put to the FIFO at the same time. Patch3 is submitted3 by Scott3 Furman3. Update is very3 recommended3.
//
// Revision3 1.12  2002/07/22 23:02:23  gorban3
// Bug3 Fixes3:
//  * Possible3 loss of sync and bad3 reception3 of stop bit on slow3 baud3 rates3 fixed3.
//   Problem3 reported3 by Kenny3.Tung3.
//  * Bad (or lack3 of ) loopback3 handling3 fixed3. Reported3 by Cherry3 Withers3.
//
// Improvements3:
//  * Made3 FIFO's as general3 inferrable3 memory where possible3.
//  So3 on FPGA3 they should be inferred3 as RAM3 (Distributed3 RAM3 on Xilinx3).
//  This3 saves3 about3 1/3 of the Slice3 count and reduces3 P&R and synthesis3 times.
//
//  * Added3 optional3 baudrate3 output (baud_o3).
//  This3 is identical3 to BAUDOUT3* signal3 on 16550 chip3.
//  It outputs3 16xbit_clock_rate - the divided3 clock3.
//  It's disabled by default. Define3 UART_HAS_BAUDRATE_OUTPUT3 to use.
//
// Revision3 1.10  2001/12/11 08:55:40  mohor3
// Scratch3 register define added.
//
// Revision3 1.9  2001/12/03 21:44:29  gorban3
// Updated3 specification3 documentation.
// Added3 full 32-bit data bus interface, now as default.
// Address is 5-bit wide3 in 32-bit data bus mode.
// Added3 wb_sel_i3 input to the core3. It's used in the 32-bit mode.
// Added3 debug3 interface with two3 32-bit read-only registers in 32-bit mode.
// Bits3 5 and 6 of LSR3 are now only cleared3 on TX3 FIFO write.
// My3 small test bench3 is modified to work3 with 32-bit mode.
//
// Revision3 1.8  2001/11/26 21:38:54  gorban3
// Lots3 of fixes3:
// Break3 condition wasn3't handled3 correctly at all.
// LSR3 bits could lose3 their3 values.
// LSR3 value after reset was wrong3.
// Timing3 of THRE3 interrupt3 signal3 corrected3.
// LSR3 bit 0 timing3 corrected3.
//
// Revision3 1.7  2001/08/24 21:01:12  mohor3
// Things3 connected3 to parity3 changed.
// Clock3 devider3 changed.
//
// Revision3 1.6  2001/08/23 16:05:05  mohor3
// Stop bit bug3 fixed3.
// Parity3 bug3 fixed3.
// WISHBONE3 read cycle bug3 fixed3,
// OE3 indicator3 (Overrun3 Error) bug3 fixed3.
// PE3 indicator3 (Parity3 Error) bug3 fixed3.
// Register read bug3 fixed3.
//
// Revision3 1.5  2001/05/31 20:08:01  gorban3
// FIFO changes3 and other corrections3.
//
// Revision3 1.4  2001/05/21 19:12:02  gorban3
// Corrected3 some3 Linter3 messages3.
//
// Revision3 1.3  2001/05/17 18:34:18  gorban3
// First3 'stable' release. Should3 be sythesizable3 now. Also3 added new header.
//
// Revision3 1.0  2001-05-17 21:27:11+02  jacob3
// Initial3 revision3
//
//

// remove comments3 to restore3 to use the new version3 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i3 signal3 is used to put data in correct3 place3
// also, in 8-bit version3 there3'll be no debugging3 features3 included3
// CAUTION3: doesn't work3 with current version3 of OR12003
//`define DATA_BUS_WIDTH_83

`ifdef DATA_BUS_WIDTH_83
 `define UART_ADDR_WIDTH3 3
 `define UART_DATA_WIDTH3 8
`else
 `define UART_ADDR_WIDTH3 5
 `define UART_DATA_WIDTH3 32
`endif

// Uncomment3 this if you want3 your3 UART3 to have
// 16xBaudrate output port.
// If3 defined, the enable signal3 will be used to drive3 baudrate_o3 signal3
// It's frequency3 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT3

// Register addresses3
`define UART_REG_RB3	`UART_ADDR_WIDTH3'd0	// receiver3 buffer3
`define UART_REG_TR3  `UART_ADDR_WIDTH3'd0	// transmitter3
`define UART_REG_IE3	`UART_ADDR_WIDTH3'd1	// Interrupt3 enable
`define UART_REG_II3  `UART_ADDR_WIDTH3'd2	// Interrupt3 identification3
`define UART_REG_FC3  `UART_ADDR_WIDTH3'd2	// FIFO control3
`define UART_REG_LC3	`UART_ADDR_WIDTH3'd3	// Line3 Control3
`define UART_REG_MC3	`UART_ADDR_WIDTH3'd4	// Modem3 control3
`define UART_REG_LS3  `UART_ADDR_WIDTH3'd5	// Line3 status
`define UART_REG_MS3  `UART_ADDR_WIDTH3'd6	// Modem3 status
`define UART_REG_SR3  `UART_ADDR_WIDTH3'd7	// Scratch3 register
`define UART_REG_DL13	`UART_ADDR_WIDTH3'd0	// Divisor3 latch3 bytes (1-2)
`define UART_REG_DL23	`UART_ADDR_WIDTH3'd1

// Interrupt3 Enable3 register bits
`define UART_IE_RDA3	0	// Received3 Data available interrupt3
`define UART_IE_THRE3	1	// Transmitter3 Holding3 Register empty3 interrupt3
`define UART_IE_RLS3	2	// Receiver3 Line3 Status Interrupt3
`define UART_IE_MS3	3	// Modem3 Status Interrupt3

// Interrupt3 Identification3 register bits
`define UART_II_IP3	0	// Interrupt3 pending when 0
`define UART_II_II3	3:1	// Interrupt3 identification3

// Interrupt3 identification3 values for bits 3:1
`define UART_II_RLS3	3'b011	// Receiver3 Line3 Status
`define UART_II_RDA3	3'b010	// Receiver3 Data available
`define UART_II_TI3	3'b110	// Timeout3 Indication3
`define UART_II_THRE3	3'b001	// Transmitter3 Holding3 Register empty3
`define UART_II_MS3	3'b000	// Modem3 Status

// FIFO Control3 Register bits
`define UART_FC_TL3	1:0	// Trigger3 level

// FIFO trigger level values
`define UART_FC_13		2'b00
`define UART_FC_43		2'b01
`define UART_FC_83		2'b10
`define UART_FC_143	2'b11

// Line3 Control3 register bits
`define UART_LC_BITS3	1:0	// bits in character3
`define UART_LC_SB3	2	// stop bits
`define UART_LC_PE3	3	// parity3 enable
`define UART_LC_EP3	4	// even3 parity3
`define UART_LC_SP3	5	// stick3 parity3
`define UART_LC_BC3	6	// Break3 control3
`define UART_LC_DL3	7	// Divisor3 Latch3 access bit

// Modem3 Control3 register bits
`define UART_MC_DTR3	0
`define UART_MC_RTS3	1
`define UART_MC_OUT13	2
`define UART_MC_OUT23	3
`define UART_MC_LB3	4	// Loopback3 mode

// Line3 Status Register bits
`define UART_LS_DR3	0	// Data ready
`define UART_LS_OE3	1	// Overrun3 Error
`define UART_LS_PE3	2	// Parity3 Error
`define UART_LS_FE3	3	// Framing3 Error
`define UART_LS_BI3	4	// Break3 interrupt3
`define UART_LS_TFE3	5	// Transmit3 FIFO is empty3
`define UART_LS_TE3	6	// Transmitter3 Empty3 indicator3
`define UART_LS_EI3	7	// Error indicator3

// Modem3 Status Register bits
`define UART_MS_DCTS3	0	// Delta3 signals3
`define UART_MS_DDSR3	1
`define UART_MS_TERI3	2
`define UART_MS_DDCD3	3
`define UART_MS_CCTS3	4	// Complement3 signals3
`define UART_MS_CDSR3	5
`define UART_MS_CRI3	6
`define UART_MS_CDCD3	7

// FIFO parameter defines3

`define UART_FIFO_WIDTH3	8
`define UART_FIFO_DEPTH3	16
`define UART_FIFO_POINTER_W3	4
`define UART_FIFO_COUNTER_W3	5
// receiver3 fifo has width 11 because it has break, parity3 and framing3 error bits
`define UART_FIFO_REC_WIDTH3  11


`define VERBOSE_WB3  0           // All activity3 on the WISHBONE3 is recorded3
`define VERBOSE_LINE_STATUS3 0   // Details3 about3 the lsr3 (line status register)
`define FAST_TEST3   1           // 64/1024 packets3 are sent3







