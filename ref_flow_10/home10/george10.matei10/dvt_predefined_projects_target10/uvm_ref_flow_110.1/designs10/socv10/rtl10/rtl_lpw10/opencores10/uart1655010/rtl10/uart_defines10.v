//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines10.v                                              ////
////                                                              ////
////                                                              ////
////  This10 file is part of the "UART10 16550 compatible10" project10    ////
////  http10://www10.opencores10.org10/cores10/uart1655010/                   ////
////                                                              ////
////  Documentation10 related10 to this project10:                      ////
////  - http10://www10.opencores10.org10/cores10/uart1655010/                 ////
////                                                              ////
////  Projects10 compatibility10:                                     ////
////  - WISHBONE10                                                  ////
////  RS23210 Protocol10                                              ////
////  16550D uart10 (mostly10 supported)                              ////
////                                                              ////
////  Overview10 (main10 Features10):                                   ////
////  Defines10 of the Core10                                         ////
////                                                              ////
////  Known10 problems10 (limits10):                                    ////
////  None10                                                        ////
////                                                              ////
////  To10 Do10:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author10(s):                                                  ////
////      - gorban10@opencores10.org10                                  ////
////      - Jacob10 Gorban10                                          ////
////      - Igor10 Mohor10 (igorm10@opencores10.org10)                      ////
////                                                              ////
////  Created10:        2001/05/12                                  ////
////  Last10 Updated10:   2001/05/17                                  ////
////                  (See log10 for the revision10 history10)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright10 (C) 2000, 2001 Authors10                             ////
////                                                              ////
//// This10 source10 file may be used and distributed10 without         ////
//// restriction10 provided that this copyright10 statement10 is not    ////
//// removed from the file and that any derivative10 work10 contains10  ////
//// the original copyright10 notice10 and the associated disclaimer10. ////
////                                                              ////
//// This10 source10 file is free software10; you can redistribute10 it   ////
//// and/or modify it under the terms10 of the GNU10 Lesser10 General10   ////
//// Public10 License10 as published10 by the Free10 Software10 Foundation10; ////
//// either10 version10 2.1 of the License10, or (at your10 option) any   ////
//// later10 version10.                                               ////
////                                                              ////
//// This10 source10 is distributed10 in the hope10 that it will be       ////
//// useful10, but WITHOUT10 ANY10 WARRANTY10; without even10 the implied10   ////
//// warranty10 of MERCHANTABILITY10 or FITNESS10 FOR10 A PARTICULAR10      ////
//// PURPOSE10.  See the GNU10 Lesser10 General10 Public10 License10 for more ////
//// details10.                                                     ////
////                                                              ////
//// You should have received10 a copy of the GNU10 Lesser10 General10    ////
//// Public10 License10 along10 with this source10; if not, download10 it   ////
//// from http10://www10.opencores10.org10/lgpl10.shtml10                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS10 Revision10 History10
//
// $Log: not supported by cvs2svn10 $
// Revision10 1.13  2003/06/11 16:37:47  gorban10
// This10 fixes10 errors10 in some10 cases10 when data is being read and put to the FIFO at the same time. Patch10 is submitted10 by Scott10 Furman10. Update is very10 recommended10.
//
// Revision10 1.12  2002/07/22 23:02:23  gorban10
// Bug10 Fixes10:
//  * Possible10 loss of sync and bad10 reception10 of stop bit on slow10 baud10 rates10 fixed10.
//   Problem10 reported10 by Kenny10.Tung10.
//  * Bad (or lack10 of ) loopback10 handling10 fixed10. Reported10 by Cherry10 Withers10.
//
// Improvements10:
//  * Made10 FIFO's as general10 inferrable10 memory where possible10.
//  So10 on FPGA10 they should be inferred10 as RAM10 (Distributed10 RAM10 on Xilinx10).
//  This10 saves10 about10 1/3 of the Slice10 count and reduces10 P&R and synthesis10 times.
//
//  * Added10 optional10 baudrate10 output (baud_o10).
//  This10 is identical10 to BAUDOUT10* signal10 on 16550 chip10.
//  It outputs10 16xbit_clock_rate - the divided10 clock10.
//  It's disabled by default. Define10 UART_HAS_BAUDRATE_OUTPUT10 to use.
//
// Revision10 1.10  2001/12/11 08:55:40  mohor10
// Scratch10 register define added.
//
// Revision10 1.9  2001/12/03 21:44:29  gorban10
// Updated10 specification10 documentation.
// Added10 full 32-bit data bus interface, now as default.
// Address is 5-bit wide10 in 32-bit data bus mode.
// Added10 wb_sel_i10 input to the core10. It's used in the 32-bit mode.
// Added10 debug10 interface with two10 32-bit read-only registers in 32-bit mode.
// Bits10 5 and 6 of LSR10 are now only cleared10 on TX10 FIFO write.
// My10 small test bench10 is modified to work10 with 32-bit mode.
//
// Revision10 1.8  2001/11/26 21:38:54  gorban10
// Lots10 of fixes10:
// Break10 condition wasn10't handled10 correctly at all.
// LSR10 bits could lose10 their10 values.
// LSR10 value after reset was wrong10.
// Timing10 of THRE10 interrupt10 signal10 corrected10.
// LSR10 bit 0 timing10 corrected10.
//
// Revision10 1.7  2001/08/24 21:01:12  mohor10
// Things10 connected10 to parity10 changed.
// Clock10 devider10 changed.
//
// Revision10 1.6  2001/08/23 16:05:05  mohor10
// Stop bit bug10 fixed10.
// Parity10 bug10 fixed10.
// WISHBONE10 read cycle bug10 fixed10,
// OE10 indicator10 (Overrun10 Error) bug10 fixed10.
// PE10 indicator10 (Parity10 Error) bug10 fixed10.
// Register read bug10 fixed10.
//
// Revision10 1.5  2001/05/31 20:08:01  gorban10
// FIFO changes10 and other corrections10.
//
// Revision10 1.4  2001/05/21 19:12:02  gorban10
// Corrected10 some10 Linter10 messages10.
//
// Revision10 1.3  2001/05/17 18:34:18  gorban10
// First10 'stable' release. Should10 be sythesizable10 now. Also10 added new header.
//
// Revision10 1.0  2001-05-17 21:27:11+02  jacob10
// Initial10 revision10
//
//

// remove comments10 to restore10 to use the new version10 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i10 signal10 is used to put data in correct10 place10
// also, in 8-bit version10 there10'll be no debugging10 features10 included10
// CAUTION10: doesn't work10 with current version10 of OR120010
//`define DATA_BUS_WIDTH_810

`ifdef DATA_BUS_WIDTH_810
 `define UART_ADDR_WIDTH10 3
 `define UART_DATA_WIDTH10 8
`else
 `define UART_ADDR_WIDTH10 5
 `define UART_DATA_WIDTH10 32
`endif

// Uncomment10 this if you want10 your10 UART10 to have
// 16xBaudrate output port.
// If10 defined, the enable signal10 will be used to drive10 baudrate_o10 signal10
// It's frequency10 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT10

// Register addresses10
`define UART_REG_RB10	`UART_ADDR_WIDTH10'd0	// receiver10 buffer10
`define UART_REG_TR10  `UART_ADDR_WIDTH10'd0	// transmitter10
`define UART_REG_IE10	`UART_ADDR_WIDTH10'd1	// Interrupt10 enable
`define UART_REG_II10  `UART_ADDR_WIDTH10'd2	// Interrupt10 identification10
`define UART_REG_FC10  `UART_ADDR_WIDTH10'd2	// FIFO control10
`define UART_REG_LC10	`UART_ADDR_WIDTH10'd3	// Line10 Control10
`define UART_REG_MC10	`UART_ADDR_WIDTH10'd4	// Modem10 control10
`define UART_REG_LS10  `UART_ADDR_WIDTH10'd5	// Line10 status
`define UART_REG_MS10  `UART_ADDR_WIDTH10'd6	// Modem10 status
`define UART_REG_SR10  `UART_ADDR_WIDTH10'd7	// Scratch10 register
`define UART_REG_DL110	`UART_ADDR_WIDTH10'd0	// Divisor10 latch10 bytes (1-2)
`define UART_REG_DL210	`UART_ADDR_WIDTH10'd1

// Interrupt10 Enable10 register bits
`define UART_IE_RDA10	0	// Received10 Data available interrupt10
`define UART_IE_THRE10	1	// Transmitter10 Holding10 Register empty10 interrupt10
`define UART_IE_RLS10	2	// Receiver10 Line10 Status Interrupt10
`define UART_IE_MS10	3	// Modem10 Status Interrupt10

// Interrupt10 Identification10 register bits
`define UART_II_IP10	0	// Interrupt10 pending when 0
`define UART_II_II10	3:1	// Interrupt10 identification10

// Interrupt10 identification10 values for bits 3:1
`define UART_II_RLS10	3'b011	// Receiver10 Line10 Status
`define UART_II_RDA10	3'b010	// Receiver10 Data available
`define UART_II_TI10	3'b110	// Timeout10 Indication10
`define UART_II_THRE10	3'b001	// Transmitter10 Holding10 Register empty10
`define UART_II_MS10	3'b000	// Modem10 Status

// FIFO Control10 Register bits
`define UART_FC_TL10	1:0	// Trigger10 level

// FIFO trigger level values
`define UART_FC_110		2'b00
`define UART_FC_410		2'b01
`define UART_FC_810		2'b10
`define UART_FC_1410	2'b11

// Line10 Control10 register bits
`define UART_LC_BITS10	1:0	// bits in character10
`define UART_LC_SB10	2	// stop bits
`define UART_LC_PE10	3	// parity10 enable
`define UART_LC_EP10	4	// even10 parity10
`define UART_LC_SP10	5	// stick10 parity10
`define UART_LC_BC10	6	// Break10 control10
`define UART_LC_DL10	7	// Divisor10 Latch10 access bit

// Modem10 Control10 register bits
`define UART_MC_DTR10	0
`define UART_MC_RTS10	1
`define UART_MC_OUT110	2
`define UART_MC_OUT210	3
`define UART_MC_LB10	4	// Loopback10 mode

// Line10 Status Register bits
`define UART_LS_DR10	0	// Data ready
`define UART_LS_OE10	1	// Overrun10 Error
`define UART_LS_PE10	2	// Parity10 Error
`define UART_LS_FE10	3	// Framing10 Error
`define UART_LS_BI10	4	// Break10 interrupt10
`define UART_LS_TFE10	5	// Transmit10 FIFO is empty10
`define UART_LS_TE10	6	// Transmitter10 Empty10 indicator10
`define UART_LS_EI10	7	// Error indicator10

// Modem10 Status Register bits
`define UART_MS_DCTS10	0	// Delta10 signals10
`define UART_MS_DDSR10	1
`define UART_MS_TERI10	2
`define UART_MS_DDCD10	3
`define UART_MS_CCTS10	4	// Complement10 signals10
`define UART_MS_CDSR10	5
`define UART_MS_CRI10	6
`define UART_MS_CDCD10	7

// FIFO parameter defines10

`define UART_FIFO_WIDTH10	8
`define UART_FIFO_DEPTH10	16
`define UART_FIFO_POINTER_W10	4
`define UART_FIFO_COUNTER_W10	5
// receiver10 fifo has width 11 because it has break, parity10 and framing10 error bits
`define UART_FIFO_REC_WIDTH10  11


`define VERBOSE_WB10  0           // All activity10 on the WISHBONE10 is recorded10
`define VERBOSE_LINE_STATUS10 0   // Details10 about10 the lsr10 (line status register)
`define FAST_TEST10   1           // 64/1024 packets10 are sent10







