//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines13.v                                              ////
////                                                              ////
////                                                              ////
////  This13 file is part of the "UART13 16550 compatible13" project13    ////
////  http13://www13.opencores13.org13/cores13/uart1655013/                   ////
////                                                              ////
////  Documentation13 related13 to this project13:                      ////
////  - http13://www13.opencores13.org13/cores13/uart1655013/                 ////
////                                                              ////
////  Projects13 compatibility13:                                     ////
////  - WISHBONE13                                                  ////
////  RS23213 Protocol13                                              ////
////  16550D uart13 (mostly13 supported)                              ////
////                                                              ////
////  Overview13 (main13 Features13):                                   ////
////  Defines13 of the Core13                                         ////
////                                                              ////
////  Known13 problems13 (limits13):                                    ////
////  None13                                                        ////
////                                                              ////
////  To13 Do13:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author13(s):                                                  ////
////      - gorban13@opencores13.org13                                  ////
////      - Jacob13 Gorban13                                          ////
////      - Igor13 Mohor13 (igorm13@opencores13.org13)                      ////
////                                                              ////
////  Created13:        2001/05/12                                  ////
////  Last13 Updated13:   2001/05/17                                  ////
////                  (See log13 for the revision13 history13)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright13 (C) 2000, 2001 Authors13                             ////
////                                                              ////
//// This13 source13 file may be used and distributed13 without         ////
//// restriction13 provided that this copyright13 statement13 is not    ////
//// removed from the file and that any derivative13 work13 contains13  ////
//// the original copyright13 notice13 and the associated disclaimer13. ////
////                                                              ////
//// This13 source13 file is free software13; you can redistribute13 it   ////
//// and/or modify it under the terms13 of the GNU13 Lesser13 General13   ////
//// Public13 License13 as published13 by the Free13 Software13 Foundation13; ////
//// either13 version13 2.1 of the License13, or (at your13 option) any   ////
//// later13 version13.                                               ////
////                                                              ////
//// This13 source13 is distributed13 in the hope13 that it will be       ////
//// useful13, but WITHOUT13 ANY13 WARRANTY13; without even13 the implied13   ////
//// warranty13 of MERCHANTABILITY13 or FITNESS13 FOR13 A PARTICULAR13      ////
//// PURPOSE13.  See the GNU13 Lesser13 General13 Public13 License13 for more ////
//// details13.                                                     ////
////                                                              ////
//// You should have received13 a copy of the GNU13 Lesser13 General13    ////
//// Public13 License13 along13 with this source13; if not, download13 it   ////
//// from http13://www13.opencores13.org13/lgpl13.shtml13                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS13 Revision13 History13
//
// $Log: not supported by cvs2svn13 $
// Revision13 1.13  2003/06/11 16:37:47  gorban13
// This13 fixes13 errors13 in some13 cases13 when data is being read and put to the FIFO at the same time. Patch13 is submitted13 by Scott13 Furman13. Update is very13 recommended13.
//
// Revision13 1.12  2002/07/22 23:02:23  gorban13
// Bug13 Fixes13:
//  * Possible13 loss of sync and bad13 reception13 of stop bit on slow13 baud13 rates13 fixed13.
//   Problem13 reported13 by Kenny13.Tung13.
//  * Bad (or lack13 of ) loopback13 handling13 fixed13. Reported13 by Cherry13 Withers13.
//
// Improvements13:
//  * Made13 FIFO's as general13 inferrable13 memory where possible13.
//  So13 on FPGA13 they should be inferred13 as RAM13 (Distributed13 RAM13 on Xilinx13).
//  This13 saves13 about13 1/3 of the Slice13 count and reduces13 P&R and synthesis13 times.
//
//  * Added13 optional13 baudrate13 output (baud_o13).
//  This13 is identical13 to BAUDOUT13* signal13 on 16550 chip13.
//  It outputs13 16xbit_clock_rate - the divided13 clock13.
//  It's disabled by default. Define13 UART_HAS_BAUDRATE_OUTPUT13 to use.
//
// Revision13 1.10  2001/12/11 08:55:40  mohor13
// Scratch13 register define added.
//
// Revision13 1.9  2001/12/03 21:44:29  gorban13
// Updated13 specification13 documentation.
// Added13 full 32-bit data bus interface, now as default.
// Address is 5-bit wide13 in 32-bit data bus mode.
// Added13 wb_sel_i13 input to the core13. It's used in the 32-bit mode.
// Added13 debug13 interface with two13 32-bit read-only registers in 32-bit mode.
// Bits13 5 and 6 of LSR13 are now only cleared13 on TX13 FIFO write.
// My13 small test bench13 is modified to work13 with 32-bit mode.
//
// Revision13 1.8  2001/11/26 21:38:54  gorban13
// Lots13 of fixes13:
// Break13 condition wasn13't handled13 correctly at all.
// LSR13 bits could lose13 their13 values.
// LSR13 value after reset was wrong13.
// Timing13 of THRE13 interrupt13 signal13 corrected13.
// LSR13 bit 0 timing13 corrected13.
//
// Revision13 1.7  2001/08/24 21:01:12  mohor13
// Things13 connected13 to parity13 changed.
// Clock13 devider13 changed.
//
// Revision13 1.6  2001/08/23 16:05:05  mohor13
// Stop bit bug13 fixed13.
// Parity13 bug13 fixed13.
// WISHBONE13 read cycle bug13 fixed13,
// OE13 indicator13 (Overrun13 Error) bug13 fixed13.
// PE13 indicator13 (Parity13 Error) bug13 fixed13.
// Register read bug13 fixed13.
//
// Revision13 1.5  2001/05/31 20:08:01  gorban13
// FIFO changes13 and other corrections13.
//
// Revision13 1.4  2001/05/21 19:12:02  gorban13
// Corrected13 some13 Linter13 messages13.
//
// Revision13 1.3  2001/05/17 18:34:18  gorban13
// First13 'stable' release. Should13 be sythesizable13 now. Also13 added new header.
//
// Revision13 1.0  2001-05-17 21:27:11+02  jacob13
// Initial13 revision13
//
//

// remove comments13 to restore13 to use the new version13 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i13 signal13 is used to put data in correct13 place13
// also, in 8-bit version13 there13'll be no debugging13 features13 included13
// CAUTION13: doesn't work13 with current version13 of OR120013
//`define DATA_BUS_WIDTH_813

`ifdef DATA_BUS_WIDTH_813
 `define UART_ADDR_WIDTH13 3
 `define UART_DATA_WIDTH13 8
`else
 `define UART_ADDR_WIDTH13 5
 `define UART_DATA_WIDTH13 32
`endif

// Uncomment13 this if you want13 your13 UART13 to have
// 16xBaudrate output port.
// If13 defined, the enable signal13 will be used to drive13 baudrate_o13 signal13
// It's frequency13 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT13

// Register addresses13
`define UART_REG_RB13	`UART_ADDR_WIDTH13'd0	// receiver13 buffer13
`define UART_REG_TR13  `UART_ADDR_WIDTH13'd0	// transmitter13
`define UART_REG_IE13	`UART_ADDR_WIDTH13'd1	// Interrupt13 enable
`define UART_REG_II13  `UART_ADDR_WIDTH13'd2	// Interrupt13 identification13
`define UART_REG_FC13  `UART_ADDR_WIDTH13'd2	// FIFO control13
`define UART_REG_LC13	`UART_ADDR_WIDTH13'd3	// Line13 Control13
`define UART_REG_MC13	`UART_ADDR_WIDTH13'd4	// Modem13 control13
`define UART_REG_LS13  `UART_ADDR_WIDTH13'd5	// Line13 status
`define UART_REG_MS13  `UART_ADDR_WIDTH13'd6	// Modem13 status
`define UART_REG_SR13  `UART_ADDR_WIDTH13'd7	// Scratch13 register
`define UART_REG_DL113	`UART_ADDR_WIDTH13'd0	// Divisor13 latch13 bytes (1-2)
`define UART_REG_DL213	`UART_ADDR_WIDTH13'd1

// Interrupt13 Enable13 register bits
`define UART_IE_RDA13	0	// Received13 Data available interrupt13
`define UART_IE_THRE13	1	// Transmitter13 Holding13 Register empty13 interrupt13
`define UART_IE_RLS13	2	// Receiver13 Line13 Status Interrupt13
`define UART_IE_MS13	3	// Modem13 Status Interrupt13

// Interrupt13 Identification13 register bits
`define UART_II_IP13	0	// Interrupt13 pending when 0
`define UART_II_II13	3:1	// Interrupt13 identification13

// Interrupt13 identification13 values for bits 3:1
`define UART_II_RLS13	3'b011	// Receiver13 Line13 Status
`define UART_II_RDA13	3'b010	// Receiver13 Data available
`define UART_II_TI13	3'b110	// Timeout13 Indication13
`define UART_II_THRE13	3'b001	// Transmitter13 Holding13 Register empty13
`define UART_II_MS13	3'b000	// Modem13 Status

// FIFO Control13 Register bits
`define UART_FC_TL13	1:0	// Trigger13 level

// FIFO trigger level values
`define UART_FC_113		2'b00
`define UART_FC_413		2'b01
`define UART_FC_813		2'b10
`define UART_FC_1413	2'b11

// Line13 Control13 register bits
`define UART_LC_BITS13	1:0	// bits in character13
`define UART_LC_SB13	2	// stop bits
`define UART_LC_PE13	3	// parity13 enable
`define UART_LC_EP13	4	// even13 parity13
`define UART_LC_SP13	5	// stick13 parity13
`define UART_LC_BC13	6	// Break13 control13
`define UART_LC_DL13	7	// Divisor13 Latch13 access bit

// Modem13 Control13 register bits
`define UART_MC_DTR13	0
`define UART_MC_RTS13	1
`define UART_MC_OUT113	2
`define UART_MC_OUT213	3
`define UART_MC_LB13	4	// Loopback13 mode

// Line13 Status Register bits
`define UART_LS_DR13	0	// Data ready
`define UART_LS_OE13	1	// Overrun13 Error
`define UART_LS_PE13	2	// Parity13 Error
`define UART_LS_FE13	3	// Framing13 Error
`define UART_LS_BI13	4	// Break13 interrupt13
`define UART_LS_TFE13	5	// Transmit13 FIFO is empty13
`define UART_LS_TE13	6	// Transmitter13 Empty13 indicator13
`define UART_LS_EI13	7	// Error indicator13

// Modem13 Status Register bits
`define UART_MS_DCTS13	0	// Delta13 signals13
`define UART_MS_DDSR13	1
`define UART_MS_TERI13	2
`define UART_MS_DDCD13	3
`define UART_MS_CCTS13	4	// Complement13 signals13
`define UART_MS_CDSR13	5
`define UART_MS_CRI13	6
`define UART_MS_CDCD13	7

// FIFO parameter defines13

`define UART_FIFO_WIDTH13	8
`define UART_FIFO_DEPTH13	16
`define UART_FIFO_POINTER_W13	4
`define UART_FIFO_COUNTER_W13	5
// receiver13 fifo has width 11 because it has break, parity13 and framing13 error bits
`define UART_FIFO_REC_WIDTH13  11


`define VERBOSE_WB13  0           // All activity13 on the WISHBONE13 is recorded13
`define VERBOSE_LINE_STATUS13 0   // Details13 about13 the lsr13 (line status register)
`define FAST_TEST13   1           // 64/1024 packets13 are sent13







