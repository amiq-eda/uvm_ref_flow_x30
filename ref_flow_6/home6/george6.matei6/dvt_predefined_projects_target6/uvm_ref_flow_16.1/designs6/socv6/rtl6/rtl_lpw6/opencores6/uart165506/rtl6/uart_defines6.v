//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines6.v                                              ////
////                                                              ////
////                                                              ////
////  This6 file is part of the "UART6 16550 compatible6" project6    ////
////  http6://www6.opencores6.org6/cores6/uart165506/                   ////
////                                                              ////
////  Documentation6 related6 to this project6:                      ////
////  - http6://www6.opencores6.org6/cores6/uart165506/                 ////
////                                                              ////
////  Projects6 compatibility6:                                     ////
////  - WISHBONE6                                                  ////
////  RS2326 Protocol6                                              ////
////  16550D uart6 (mostly6 supported)                              ////
////                                                              ////
////  Overview6 (main6 Features6):                                   ////
////  Defines6 of the Core6                                         ////
////                                                              ////
////  Known6 problems6 (limits6):                                    ////
////  None6                                                        ////
////                                                              ////
////  To6 Do6:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author6(s):                                                  ////
////      - gorban6@opencores6.org6                                  ////
////      - Jacob6 Gorban6                                          ////
////      - Igor6 Mohor6 (igorm6@opencores6.org6)                      ////
////                                                              ////
////  Created6:        2001/05/12                                  ////
////  Last6 Updated6:   2001/05/17                                  ////
////                  (See log6 for the revision6 history6)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright6 (C) 2000, 2001 Authors6                             ////
////                                                              ////
//// This6 source6 file may be used and distributed6 without         ////
//// restriction6 provided that this copyright6 statement6 is not    ////
//// removed from the file and that any derivative6 work6 contains6  ////
//// the original copyright6 notice6 and the associated disclaimer6. ////
////                                                              ////
//// This6 source6 file is free software6; you can redistribute6 it   ////
//// and/or modify it under the terms6 of the GNU6 Lesser6 General6   ////
//// Public6 License6 as published6 by the Free6 Software6 Foundation6; ////
//// either6 version6 2.1 of the License6, or (at your6 option) any   ////
//// later6 version6.                                               ////
////                                                              ////
//// This6 source6 is distributed6 in the hope6 that it will be       ////
//// useful6, but WITHOUT6 ANY6 WARRANTY6; without even6 the implied6   ////
//// warranty6 of MERCHANTABILITY6 or FITNESS6 FOR6 A PARTICULAR6      ////
//// PURPOSE6.  See the GNU6 Lesser6 General6 Public6 License6 for more ////
//// details6.                                                     ////
////                                                              ////
//// You should have received6 a copy of the GNU6 Lesser6 General6    ////
//// Public6 License6 along6 with this source6; if not, download6 it   ////
//// from http6://www6.opencores6.org6/lgpl6.shtml6                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS6 Revision6 History6
//
// $Log: not supported by cvs2svn6 $
// Revision6 1.13  2003/06/11 16:37:47  gorban6
// This6 fixes6 errors6 in some6 cases6 when data is being read and put to the FIFO at the same time. Patch6 is submitted6 by Scott6 Furman6. Update is very6 recommended6.
//
// Revision6 1.12  2002/07/22 23:02:23  gorban6
// Bug6 Fixes6:
//  * Possible6 loss of sync and bad6 reception6 of stop bit on slow6 baud6 rates6 fixed6.
//   Problem6 reported6 by Kenny6.Tung6.
//  * Bad (or lack6 of ) loopback6 handling6 fixed6. Reported6 by Cherry6 Withers6.
//
// Improvements6:
//  * Made6 FIFO's as general6 inferrable6 memory where possible6.
//  So6 on FPGA6 they should be inferred6 as RAM6 (Distributed6 RAM6 on Xilinx6).
//  This6 saves6 about6 1/3 of the Slice6 count and reduces6 P&R and synthesis6 times.
//
//  * Added6 optional6 baudrate6 output (baud_o6).
//  This6 is identical6 to BAUDOUT6* signal6 on 16550 chip6.
//  It outputs6 16xbit_clock_rate - the divided6 clock6.
//  It's disabled by default. Define6 UART_HAS_BAUDRATE_OUTPUT6 to use.
//
// Revision6 1.10  2001/12/11 08:55:40  mohor6
// Scratch6 register define added.
//
// Revision6 1.9  2001/12/03 21:44:29  gorban6
// Updated6 specification6 documentation.
// Added6 full 32-bit data bus interface, now as default.
// Address is 5-bit wide6 in 32-bit data bus mode.
// Added6 wb_sel_i6 input to the core6. It's used in the 32-bit mode.
// Added6 debug6 interface with two6 32-bit read-only registers in 32-bit mode.
// Bits6 5 and 6 of LSR6 are now only cleared6 on TX6 FIFO write.
// My6 small test bench6 is modified to work6 with 32-bit mode.
//
// Revision6 1.8  2001/11/26 21:38:54  gorban6
// Lots6 of fixes6:
// Break6 condition wasn6't handled6 correctly at all.
// LSR6 bits could lose6 their6 values.
// LSR6 value after reset was wrong6.
// Timing6 of THRE6 interrupt6 signal6 corrected6.
// LSR6 bit 0 timing6 corrected6.
//
// Revision6 1.7  2001/08/24 21:01:12  mohor6
// Things6 connected6 to parity6 changed.
// Clock6 devider6 changed.
//
// Revision6 1.6  2001/08/23 16:05:05  mohor6
// Stop bit bug6 fixed6.
// Parity6 bug6 fixed6.
// WISHBONE6 read cycle bug6 fixed6,
// OE6 indicator6 (Overrun6 Error) bug6 fixed6.
// PE6 indicator6 (Parity6 Error) bug6 fixed6.
// Register read bug6 fixed6.
//
// Revision6 1.5  2001/05/31 20:08:01  gorban6
// FIFO changes6 and other corrections6.
//
// Revision6 1.4  2001/05/21 19:12:02  gorban6
// Corrected6 some6 Linter6 messages6.
//
// Revision6 1.3  2001/05/17 18:34:18  gorban6
// First6 'stable' release. Should6 be sythesizable6 now. Also6 added new header.
//
// Revision6 1.0  2001-05-17 21:27:11+02  jacob6
// Initial6 revision6
//
//

// remove comments6 to restore6 to use the new version6 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i6 signal6 is used to put data in correct6 place6
// also, in 8-bit version6 there6'll be no debugging6 features6 included6
// CAUTION6: doesn't work6 with current version6 of OR12006
//`define DATA_BUS_WIDTH_86

`ifdef DATA_BUS_WIDTH_86
 `define UART_ADDR_WIDTH6 3
 `define UART_DATA_WIDTH6 8
`else
 `define UART_ADDR_WIDTH6 5
 `define UART_DATA_WIDTH6 32
`endif

// Uncomment6 this if you want6 your6 UART6 to have
// 16xBaudrate output port.
// If6 defined, the enable signal6 will be used to drive6 baudrate_o6 signal6
// It's frequency6 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT6

// Register addresses6
`define UART_REG_RB6	`UART_ADDR_WIDTH6'd0	// receiver6 buffer6
`define UART_REG_TR6  `UART_ADDR_WIDTH6'd0	// transmitter6
`define UART_REG_IE6	`UART_ADDR_WIDTH6'd1	// Interrupt6 enable
`define UART_REG_II6  `UART_ADDR_WIDTH6'd2	// Interrupt6 identification6
`define UART_REG_FC6  `UART_ADDR_WIDTH6'd2	// FIFO control6
`define UART_REG_LC6	`UART_ADDR_WIDTH6'd3	// Line6 Control6
`define UART_REG_MC6	`UART_ADDR_WIDTH6'd4	// Modem6 control6
`define UART_REG_LS6  `UART_ADDR_WIDTH6'd5	// Line6 status
`define UART_REG_MS6  `UART_ADDR_WIDTH6'd6	// Modem6 status
`define UART_REG_SR6  `UART_ADDR_WIDTH6'd7	// Scratch6 register
`define UART_REG_DL16	`UART_ADDR_WIDTH6'd0	// Divisor6 latch6 bytes (1-2)
`define UART_REG_DL26	`UART_ADDR_WIDTH6'd1

// Interrupt6 Enable6 register bits
`define UART_IE_RDA6	0	// Received6 Data available interrupt6
`define UART_IE_THRE6	1	// Transmitter6 Holding6 Register empty6 interrupt6
`define UART_IE_RLS6	2	// Receiver6 Line6 Status Interrupt6
`define UART_IE_MS6	3	// Modem6 Status Interrupt6

// Interrupt6 Identification6 register bits
`define UART_II_IP6	0	// Interrupt6 pending when 0
`define UART_II_II6	3:1	// Interrupt6 identification6

// Interrupt6 identification6 values for bits 3:1
`define UART_II_RLS6	3'b011	// Receiver6 Line6 Status
`define UART_II_RDA6	3'b010	// Receiver6 Data available
`define UART_II_TI6	3'b110	// Timeout6 Indication6
`define UART_II_THRE6	3'b001	// Transmitter6 Holding6 Register empty6
`define UART_II_MS6	3'b000	// Modem6 Status

// FIFO Control6 Register bits
`define UART_FC_TL6	1:0	// Trigger6 level

// FIFO trigger level values
`define UART_FC_16		2'b00
`define UART_FC_46		2'b01
`define UART_FC_86		2'b10
`define UART_FC_146	2'b11

// Line6 Control6 register bits
`define UART_LC_BITS6	1:0	// bits in character6
`define UART_LC_SB6	2	// stop bits
`define UART_LC_PE6	3	// parity6 enable
`define UART_LC_EP6	4	// even6 parity6
`define UART_LC_SP6	5	// stick6 parity6
`define UART_LC_BC6	6	// Break6 control6
`define UART_LC_DL6	7	// Divisor6 Latch6 access bit

// Modem6 Control6 register bits
`define UART_MC_DTR6	0
`define UART_MC_RTS6	1
`define UART_MC_OUT16	2
`define UART_MC_OUT26	3
`define UART_MC_LB6	4	// Loopback6 mode

// Line6 Status Register bits
`define UART_LS_DR6	0	// Data ready
`define UART_LS_OE6	1	// Overrun6 Error
`define UART_LS_PE6	2	// Parity6 Error
`define UART_LS_FE6	3	// Framing6 Error
`define UART_LS_BI6	4	// Break6 interrupt6
`define UART_LS_TFE6	5	// Transmit6 FIFO is empty6
`define UART_LS_TE6	6	// Transmitter6 Empty6 indicator6
`define UART_LS_EI6	7	// Error indicator6

// Modem6 Status Register bits
`define UART_MS_DCTS6	0	// Delta6 signals6
`define UART_MS_DDSR6	1
`define UART_MS_TERI6	2
`define UART_MS_DDCD6	3
`define UART_MS_CCTS6	4	// Complement6 signals6
`define UART_MS_CDSR6	5
`define UART_MS_CRI6	6
`define UART_MS_CDCD6	7

// FIFO parameter defines6

`define UART_FIFO_WIDTH6	8
`define UART_FIFO_DEPTH6	16
`define UART_FIFO_POINTER_W6	4
`define UART_FIFO_COUNTER_W6	5
// receiver6 fifo has width 11 because it has break, parity6 and framing6 error bits
`define UART_FIFO_REC_WIDTH6  11


`define VERBOSE_WB6  0           // All activity6 on the WISHBONE6 is recorded6
`define VERBOSE_LINE_STATUS6 0   // Details6 about6 the lsr6 (line status register)
`define FAST_TEST6   1           // 64/1024 packets6 are sent6







