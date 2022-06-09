//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines4.v                                              ////
////                                                              ////
////                                                              ////
////  This4 file is part of the "UART4 16550 compatible4" project4    ////
////  http4://www4.opencores4.org4/cores4/uart165504/                   ////
////                                                              ////
////  Documentation4 related4 to this project4:                      ////
////  - http4://www4.opencores4.org4/cores4/uart165504/                 ////
////                                                              ////
////  Projects4 compatibility4:                                     ////
////  - WISHBONE4                                                  ////
////  RS2324 Protocol4                                              ////
////  16550D uart4 (mostly4 supported)                              ////
////                                                              ////
////  Overview4 (main4 Features4):                                   ////
////  Defines4 of the Core4                                         ////
////                                                              ////
////  Known4 problems4 (limits4):                                    ////
////  None4                                                        ////
////                                                              ////
////  To4 Do4:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author4(s):                                                  ////
////      - gorban4@opencores4.org4                                  ////
////      - Jacob4 Gorban4                                          ////
////      - Igor4 Mohor4 (igorm4@opencores4.org4)                      ////
////                                                              ////
////  Created4:        2001/05/12                                  ////
////  Last4 Updated4:   2001/05/17                                  ////
////                  (See log4 for the revision4 history4)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2000, 2001 Authors4                             ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS4 Revision4 History4
//
// $Log: not supported by cvs2svn4 $
// Revision4 1.13  2003/06/11 16:37:47  gorban4
// This4 fixes4 errors4 in some4 cases4 when data is being read and put to the FIFO at the same time. Patch4 is submitted4 by Scott4 Furman4. Update is very4 recommended4.
//
// Revision4 1.12  2002/07/22 23:02:23  gorban4
// Bug4 Fixes4:
//  * Possible4 loss of sync and bad4 reception4 of stop bit on slow4 baud4 rates4 fixed4.
//   Problem4 reported4 by Kenny4.Tung4.
//  * Bad (or lack4 of ) loopback4 handling4 fixed4. Reported4 by Cherry4 Withers4.
//
// Improvements4:
//  * Made4 FIFO's as general4 inferrable4 memory where possible4.
//  So4 on FPGA4 they should be inferred4 as RAM4 (Distributed4 RAM4 on Xilinx4).
//  This4 saves4 about4 1/3 of the Slice4 count and reduces4 P&R and synthesis4 times.
//
//  * Added4 optional4 baudrate4 output (baud_o4).
//  This4 is identical4 to BAUDOUT4* signal4 on 16550 chip4.
//  It outputs4 16xbit_clock_rate - the divided4 clock4.
//  It's disabled by default. Define4 UART_HAS_BAUDRATE_OUTPUT4 to use.
//
// Revision4 1.10  2001/12/11 08:55:40  mohor4
// Scratch4 register define added.
//
// Revision4 1.9  2001/12/03 21:44:29  gorban4
// Updated4 specification4 documentation.
// Added4 full 32-bit data bus interface, now as default.
// Address is 5-bit wide4 in 32-bit data bus mode.
// Added4 wb_sel_i4 input to the core4. It's used in the 32-bit mode.
// Added4 debug4 interface with two4 32-bit read-only registers in 32-bit mode.
// Bits4 5 and 6 of LSR4 are now only cleared4 on TX4 FIFO write.
// My4 small test bench4 is modified to work4 with 32-bit mode.
//
// Revision4 1.8  2001/11/26 21:38:54  gorban4
// Lots4 of fixes4:
// Break4 condition wasn4't handled4 correctly at all.
// LSR4 bits could lose4 their4 values.
// LSR4 value after reset was wrong4.
// Timing4 of THRE4 interrupt4 signal4 corrected4.
// LSR4 bit 0 timing4 corrected4.
//
// Revision4 1.7  2001/08/24 21:01:12  mohor4
// Things4 connected4 to parity4 changed.
// Clock4 devider4 changed.
//
// Revision4 1.6  2001/08/23 16:05:05  mohor4
// Stop bit bug4 fixed4.
// Parity4 bug4 fixed4.
// WISHBONE4 read cycle bug4 fixed4,
// OE4 indicator4 (Overrun4 Error) bug4 fixed4.
// PE4 indicator4 (Parity4 Error) bug4 fixed4.
// Register read bug4 fixed4.
//
// Revision4 1.5  2001/05/31 20:08:01  gorban4
// FIFO changes4 and other corrections4.
//
// Revision4 1.4  2001/05/21 19:12:02  gorban4
// Corrected4 some4 Linter4 messages4.
//
// Revision4 1.3  2001/05/17 18:34:18  gorban4
// First4 'stable' release. Should4 be sythesizable4 now. Also4 added new header.
//
// Revision4 1.0  2001-05-17 21:27:11+02  jacob4
// Initial4 revision4
//
//

// remove comments4 to restore4 to use the new version4 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i4 signal4 is used to put data in correct4 place4
// also, in 8-bit version4 there4'll be no debugging4 features4 included4
// CAUTION4: doesn't work4 with current version4 of OR12004
//`define DATA_BUS_WIDTH_84

`ifdef DATA_BUS_WIDTH_84
 `define UART_ADDR_WIDTH4 3
 `define UART_DATA_WIDTH4 8
`else
 `define UART_ADDR_WIDTH4 5
 `define UART_DATA_WIDTH4 32
`endif

// Uncomment4 this if you want4 your4 UART4 to have
// 16xBaudrate output port.
// If4 defined, the enable signal4 will be used to drive4 baudrate_o4 signal4
// It's frequency4 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT4

// Register addresses4
`define UART_REG_RB4	`UART_ADDR_WIDTH4'd0	// receiver4 buffer4
`define UART_REG_TR4  `UART_ADDR_WIDTH4'd0	// transmitter4
`define UART_REG_IE4	`UART_ADDR_WIDTH4'd1	// Interrupt4 enable
`define UART_REG_II4  `UART_ADDR_WIDTH4'd2	// Interrupt4 identification4
`define UART_REG_FC4  `UART_ADDR_WIDTH4'd2	// FIFO control4
`define UART_REG_LC4	`UART_ADDR_WIDTH4'd3	// Line4 Control4
`define UART_REG_MC4	`UART_ADDR_WIDTH4'd4	// Modem4 control4
`define UART_REG_LS4  `UART_ADDR_WIDTH4'd5	// Line4 status
`define UART_REG_MS4  `UART_ADDR_WIDTH4'd6	// Modem4 status
`define UART_REG_SR4  `UART_ADDR_WIDTH4'd7	// Scratch4 register
`define UART_REG_DL14	`UART_ADDR_WIDTH4'd0	// Divisor4 latch4 bytes (1-2)
`define UART_REG_DL24	`UART_ADDR_WIDTH4'd1

// Interrupt4 Enable4 register bits
`define UART_IE_RDA4	0	// Received4 Data available interrupt4
`define UART_IE_THRE4	1	// Transmitter4 Holding4 Register empty4 interrupt4
`define UART_IE_RLS4	2	// Receiver4 Line4 Status Interrupt4
`define UART_IE_MS4	3	// Modem4 Status Interrupt4

// Interrupt4 Identification4 register bits
`define UART_II_IP4	0	// Interrupt4 pending when 0
`define UART_II_II4	3:1	// Interrupt4 identification4

// Interrupt4 identification4 values for bits 3:1
`define UART_II_RLS4	3'b011	// Receiver4 Line4 Status
`define UART_II_RDA4	3'b010	// Receiver4 Data available
`define UART_II_TI4	3'b110	// Timeout4 Indication4
`define UART_II_THRE4	3'b001	// Transmitter4 Holding4 Register empty4
`define UART_II_MS4	3'b000	// Modem4 Status

// FIFO Control4 Register bits
`define UART_FC_TL4	1:0	// Trigger4 level

// FIFO trigger level values
`define UART_FC_14		2'b00
`define UART_FC_44		2'b01
`define UART_FC_84		2'b10
`define UART_FC_144	2'b11

// Line4 Control4 register bits
`define UART_LC_BITS4	1:0	// bits in character4
`define UART_LC_SB4	2	// stop bits
`define UART_LC_PE4	3	// parity4 enable
`define UART_LC_EP4	4	// even4 parity4
`define UART_LC_SP4	5	// stick4 parity4
`define UART_LC_BC4	6	// Break4 control4
`define UART_LC_DL4	7	// Divisor4 Latch4 access bit

// Modem4 Control4 register bits
`define UART_MC_DTR4	0
`define UART_MC_RTS4	1
`define UART_MC_OUT14	2
`define UART_MC_OUT24	3
`define UART_MC_LB4	4	// Loopback4 mode

// Line4 Status Register bits
`define UART_LS_DR4	0	// Data ready
`define UART_LS_OE4	1	// Overrun4 Error
`define UART_LS_PE4	2	// Parity4 Error
`define UART_LS_FE4	3	// Framing4 Error
`define UART_LS_BI4	4	// Break4 interrupt4
`define UART_LS_TFE4	5	// Transmit4 FIFO is empty4
`define UART_LS_TE4	6	// Transmitter4 Empty4 indicator4
`define UART_LS_EI4	7	// Error indicator4

// Modem4 Status Register bits
`define UART_MS_DCTS4	0	// Delta4 signals4
`define UART_MS_DDSR4	1
`define UART_MS_TERI4	2
`define UART_MS_DDCD4	3
`define UART_MS_CCTS4	4	// Complement4 signals4
`define UART_MS_CDSR4	5
`define UART_MS_CRI4	6
`define UART_MS_CDCD4	7

// FIFO parameter defines4

`define UART_FIFO_WIDTH4	8
`define UART_FIFO_DEPTH4	16
`define UART_FIFO_POINTER_W4	4
`define UART_FIFO_COUNTER_W4	5
// receiver4 fifo has width 11 because it has break, parity4 and framing4 error bits
`define UART_FIFO_REC_WIDTH4  11


`define VERBOSE_WB4  0           // All activity4 on the WISHBONE4 is recorded4
`define VERBOSE_LINE_STATUS4 0   // Details4 about4 the lsr4 (line status register)
`define FAST_TEST4   1           // 64/1024 packets4 are sent4







