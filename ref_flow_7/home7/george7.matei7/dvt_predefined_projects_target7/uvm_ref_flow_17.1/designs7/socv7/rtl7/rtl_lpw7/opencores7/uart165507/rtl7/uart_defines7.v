//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines7.v                                              ////
////                                                              ////
////                                                              ////
////  This7 file is part of the "UART7 16550 compatible7" project7    ////
////  http7://www7.opencores7.org7/cores7/uart165507/                   ////
////                                                              ////
////  Documentation7 related7 to this project7:                      ////
////  - http7://www7.opencores7.org7/cores7/uart165507/                 ////
////                                                              ////
////  Projects7 compatibility7:                                     ////
////  - WISHBONE7                                                  ////
////  RS2327 Protocol7                                              ////
////  16550D uart7 (mostly7 supported)                              ////
////                                                              ////
////  Overview7 (main7 Features7):                                   ////
////  Defines7 of the Core7                                         ////
////                                                              ////
////  Known7 problems7 (limits7):                                    ////
////  None7                                                        ////
////                                                              ////
////  To7 Do7:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author7(s):                                                  ////
////      - gorban7@opencores7.org7                                  ////
////      - Jacob7 Gorban7                                          ////
////      - Igor7 Mohor7 (igorm7@opencores7.org7)                      ////
////                                                              ////
////  Created7:        2001/05/12                                  ////
////  Last7 Updated7:   2001/05/17                                  ////
////                  (See log7 for the revision7 history7)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright7 (C) 2000, 2001 Authors7                             ////
////                                                              ////
//// This7 source7 file may be used and distributed7 without         ////
//// restriction7 provided that this copyright7 statement7 is not    ////
//// removed from the file and that any derivative7 work7 contains7  ////
//// the original copyright7 notice7 and the associated disclaimer7. ////
////                                                              ////
//// This7 source7 file is free software7; you can redistribute7 it   ////
//// and/or modify it under the terms7 of the GNU7 Lesser7 General7   ////
//// Public7 License7 as published7 by the Free7 Software7 Foundation7; ////
//// either7 version7 2.1 of the License7, or (at your7 option) any   ////
//// later7 version7.                                               ////
////                                                              ////
//// This7 source7 is distributed7 in the hope7 that it will be       ////
//// useful7, but WITHOUT7 ANY7 WARRANTY7; without even7 the implied7   ////
//// warranty7 of MERCHANTABILITY7 or FITNESS7 FOR7 A PARTICULAR7      ////
//// PURPOSE7.  See the GNU7 Lesser7 General7 Public7 License7 for more ////
//// details7.                                                     ////
////                                                              ////
//// You should have received7 a copy of the GNU7 Lesser7 General7    ////
//// Public7 License7 along7 with this source7; if not, download7 it   ////
//// from http7://www7.opencores7.org7/lgpl7.shtml7                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS7 Revision7 History7
//
// $Log: not supported by cvs2svn7 $
// Revision7 1.13  2003/06/11 16:37:47  gorban7
// This7 fixes7 errors7 in some7 cases7 when data is being read and put to the FIFO at the same time. Patch7 is submitted7 by Scott7 Furman7. Update is very7 recommended7.
//
// Revision7 1.12  2002/07/22 23:02:23  gorban7
// Bug7 Fixes7:
//  * Possible7 loss of sync and bad7 reception7 of stop bit on slow7 baud7 rates7 fixed7.
//   Problem7 reported7 by Kenny7.Tung7.
//  * Bad (or lack7 of ) loopback7 handling7 fixed7. Reported7 by Cherry7 Withers7.
//
// Improvements7:
//  * Made7 FIFO's as general7 inferrable7 memory where possible7.
//  So7 on FPGA7 they should be inferred7 as RAM7 (Distributed7 RAM7 on Xilinx7).
//  This7 saves7 about7 1/3 of the Slice7 count and reduces7 P&R and synthesis7 times.
//
//  * Added7 optional7 baudrate7 output (baud_o7).
//  This7 is identical7 to BAUDOUT7* signal7 on 16550 chip7.
//  It outputs7 16xbit_clock_rate - the divided7 clock7.
//  It's disabled by default. Define7 UART_HAS_BAUDRATE_OUTPUT7 to use.
//
// Revision7 1.10  2001/12/11 08:55:40  mohor7
// Scratch7 register define added.
//
// Revision7 1.9  2001/12/03 21:44:29  gorban7
// Updated7 specification7 documentation.
// Added7 full 32-bit data bus interface, now as default.
// Address is 5-bit wide7 in 32-bit data bus mode.
// Added7 wb_sel_i7 input to the core7. It's used in the 32-bit mode.
// Added7 debug7 interface with two7 32-bit read-only registers in 32-bit mode.
// Bits7 5 and 6 of LSR7 are now only cleared7 on TX7 FIFO write.
// My7 small test bench7 is modified to work7 with 32-bit mode.
//
// Revision7 1.8  2001/11/26 21:38:54  gorban7
// Lots7 of fixes7:
// Break7 condition wasn7't handled7 correctly at all.
// LSR7 bits could lose7 their7 values.
// LSR7 value after reset was wrong7.
// Timing7 of THRE7 interrupt7 signal7 corrected7.
// LSR7 bit 0 timing7 corrected7.
//
// Revision7 1.7  2001/08/24 21:01:12  mohor7
// Things7 connected7 to parity7 changed.
// Clock7 devider7 changed.
//
// Revision7 1.6  2001/08/23 16:05:05  mohor7
// Stop bit bug7 fixed7.
// Parity7 bug7 fixed7.
// WISHBONE7 read cycle bug7 fixed7,
// OE7 indicator7 (Overrun7 Error) bug7 fixed7.
// PE7 indicator7 (Parity7 Error) bug7 fixed7.
// Register read bug7 fixed7.
//
// Revision7 1.5  2001/05/31 20:08:01  gorban7
// FIFO changes7 and other corrections7.
//
// Revision7 1.4  2001/05/21 19:12:02  gorban7
// Corrected7 some7 Linter7 messages7.
//
// Revision7 1.3  2001/05/17 18:34:18  gorban7
// First7 'stable' release. Should7 be sythesizable7 now. Also7 added new header.
//
// Revision7 1.0  2001-05-17 21:27:11+02  jacob7
// Initial7 revision7
//
//

// remove comments7 to restore7 to use the new version7 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i7 signal7 is used to put data in correct7 place7
// also, in 8-bit version7 there7'll be no debugging7 features7 included7
// CAUTION7: doesn't work7 with current version7 of OR12007
//`define DATA_BUS_WIDTH_87

`ifdef DATA_BUS_WIDTH_87
 `define UART_ADDR_WIDTH7 3
 `define UART_DATA_WIDTH7 8
`else
 `define UART_ADDR_WIDTH7 5
 `define UART_DATA_WIDTH7 32
`endif

// Uncomment7 this if you want7 your7 UART7 to have
// 16xBaudrate output port.
// If7 defined, the enable signal7 will be used to drive7 baudrate_o7 signal7
// It's frequency7 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT7

// Register addresses7
`define UART_REG_RB7	`UART_ADDR_WIDTH7'd0	// receiver7 buffer7
`define UART_REG_TR7  `UART_ADDR_WIDTH7'd0	// transmitter7
`define UART_REG_IE7	`UART_ADDR_WIDTH7'd1	// Interrupt7 enable
`define UART_REG_II7  `UART_ADDR_WIDTH7'd2	// Interrupt7 identification7
`define UART_REG_FC7  `UART_ADDR_WIDTH7'd2	// FIFO control7
`define UART_REG_LC7	`UART_ADDR_WIDTH7'd3	// Line7 Control7
`define UART_REG_MC7	`UART_ADDR_WIDTH7'd4	// Modem7 control7
`define UART_REG_LS7  `UART_ADDR_WIDTH7'd5	// Line7 status
`define UART_REG_MS7  `UART_ADDR_WIDTH7'd6	// Modem7 status
`define UART_REG_SR7  `UART_ADDR_WIDTH7'd7	// Scratch7 register
`define UART_REG_DL17	`UART_ADDR_WIDTH7'd0	// Divisor7 latch7 bytes (1-2)
`define UART_REG_DL27	`UART_ADDR_WIDTH7'd1

// Interrupt7 Enable7 register bits
`define UART_IE_RDA7	0	// Received7 Data available interrupt7
`define UART_IE_THRE7	1	// Transmitter7 Holding7 Register empty7 interrupt7
`define UART_IE_RLS7	2	// Receiver7 Line7 Status Interrupt7
`define UART_IE_MS7	3	// Modem7 Status Interrupt7

// Interrupt7 Identification7 register bits
`define UART_II_IP7	0	// Interrupt7 pending when 0
`define UART_II_II7	3:1	// Interrupt7 identification7

// Interrupt7 identification7 values for bits 3:1
`define UART_II_RLS7	3'b011	// Receiver7 Line7 Status
`define UART_II_RDA7	3'b010	// Receiver7 Data available
`define UART_II_TI7	3'b110	// Timeout7 Indication7
`define UART_II_THRE7	3'b001	// Transmitter7 Holding7 Register empty7
`define UART_II_MS7	3'b000	// Modem7 Status

// FIFO Control7 Register bits
`define UART_FC_TL7	1:0	// Trigger7 level

// FIFO trigger level values
`define UART_FC_17		2'b00
`define UART_FC_47		2'b01
`define UART_FC_87		2'b10
`define UART_FC_147	2'b11

// Line7 Control7 register bits
`define UART_LC_BITS7	1:0	// bits in character7
`define UART_LC_SB7	2	// stop bits
`define UART_LC_PE7	3	// parity7 enable
`define UART_LC_EP7	4	// even7 parity7
`define UART_LC_SP7	5	// stick7 parity7
`define UART_LC_BC7	6	// Break7 control7
`define UART_LC_DL7	7	// Divisor7 Latch7 access bit

// Modem7 Control7 register bits
`define UART_MC_DTR7	0
`define UART_MC_RTS7	1
`define UART_MC_OUT17	2
`define UART_MC_OUT27	3
`define UART_MC_LB7	4	// Loopback7 mode

// Line7 Status Register bits
`define UART_LS_DR7	0	// Data ready
`define UART_LS_OE7	1	// Overrun7 Error
`define UART_LS_PE7	2	// Parity7 Error
`define UART_LS_FE7	3	// Framing7 Error
`define UART_LS_BI7	4	// Break7 interrupt7
`define UART_LS_TFE7	5	// Transmit7 FIFO is empty7
`define UART_LS_TE7	6	// Transmitter7 Empty7 indicator7
`define UART_LS_EI7	7	// Error indicator7

// Modem7 Status Register bits
`define UART_MS_DCTS7	0	// Delta7 signals7
`define UART_MS_DDSR7	1
`define UART_MS_TERI7	2
`define UART_MS_DDCD7	3
`define UART_MS_CCTS7	4	// Complement7 signals7
`define UART_MS_CDSR7	5
`define UART_MS_CRI7	6
`define UART_MS_CDCD7	7

// FIFO parameter defines7

`define UART_FIFO_WIDTH7	8
`define UART_FIFO_DEPTH7	16
`define UART_FIFO_POINTER_W7	4
`define UART_FIFO_COUNTER_W7	5
// receiver7 fifo has width 11 because it has break, parity7 and framing7 error bits
`define UART_FIFO_REC_WIDTH7  11


`define VERBOSE_WB7  0           // All activity7 on the WISHBONE7 is recorded7
`define VERBOSE_LINE_STATUS7 0   // Details7 about7 the lsr7 (line status register)
`define FAST_TEST7   1           // 64/1024 packets7 are sent7







