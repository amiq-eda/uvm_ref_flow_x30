//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines16.v                                              ////
////                                                              ////
////                                                              ////
////  This16 file is part of the "UART16 16550 compatible16" project16    ////
////  http16://www16.opencores16.org16/cores16/uart1655016/                   ////
////                                                              ////
////  Documentation16 related16 to this project16:                      ////
////  - http16://www16.opencores16.org16/cores16/uart1655016/                 ////
////                                                              ////
////  Projects16 compatibility16:                                     ////
////  - WISHBONE16                                                  ////
////  RS23216 Protocol16                                              ////
////  16550D uart16 (mostly16 supported)                              ////
////                                                              ////
////  Overview16 (main16 Features16):                                   ////
////  Defines16 of the Core16                                         ////
////                                                              ////
////  Known16 problems16 (limits16):                                    ////
////  None16                                                        ////
////                                                              ////
////  To16 Do16:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author16(s):                                                  ////
////      - gorban16@opencores16.org16                                  ////
////      - Jacob16 Gorban16                                          ////
////      - Igor16 Mohor16 (igorm16@opencores16.org16)                      ////
////                                                              ////
////  Created16:        2001/05/12                                  ////
////  Last16 Updated16:   2001/05/17                                  ////
////                  (See log16 for the revision16 history16)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2000, 2001 Authors16                             ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS16 Revision16 History16
//
// $Log: not supported by cvs2svn16 $
// Revision16 1.13  2003/06/11 16:37:47  gorban16
// This16 fixes16 errors16 in some16 cases16 when data is being read and put to the FIFO at the same time. Patch16 is submitted16 by Scott16 Furman16. Update is very16 recommended16.
//
// Revision16 1.12  2002/07/22 23:02:23  gorban16
// Bug16 Fixes16:
//  * Possible16 loss of sync and bad16 reception16 of stop bit on slow16 baud16 rates16 fixed16.
//   Problem16 reported16 by Kenny16.Tung16.
//  * Bad (or lack16 of ) loopback16 handling16 fixed16. Reported16 by Cherry16 Withers16.
//
// Improvements16:
//  * Made16 FIFO's as general16 inferrable16 memory where possible16.
//  So16 on FPGA16 they should be inferred16 as RAM16 (Distributed16 RAM16 on Xilinx16).
//  This16 saves16 about16 1/3 of the Slice16 count and reduces16 P&R and synthesis16 times.
//
//  * Added16 optional16 baudrate16 output (baud_o16).
//  This16 is identical16 to BAUDOUT16* signal16 on 16550 chip16.
//  It outputs16 16xbit_clock_rate - the divided16 clock16.
//  It's disabled by default. Define16 UART_HAS_BAUDRATE_OUTPUT16 to use.
//
// Revision16 1.10  2001/12/11 08:55:40  mohor16
// Scratch16 register define added.
//
// Revision16 1.9  2001/12/03 21:44:29  gorban16
// Updated16 specification16 documentation.
// Added16 full 32-bit data bus interface, now as default.
// Address is 5-bit wide16 in 32-bit data bus mode.
// Added16 wb_sel_i16 input to the core16. It's used in the 32-bit mode.
// Added16 debug16 interface with two16 32-bit read-only registers in 32-bit mode.
// Bits16 5 and 6 of LSR16 are now only cleared16 on TX16 FIFO write.
// My16 small test bench16 is modified to work16 with 32-bit mode.
//
// Revision16 1.8  2001/11/26 21:38:54  gorban16
// Lots16 of fixes16:
// Break16 condition wasn16't handled16 correctly at all.
// LSR16 bits could lose16 their16 values.
// LSR16 value after reset was wrong16.
// Timing16 of THRE16 interrupt16 signal16 corrected16.
// LSR16 bit 0 timing16 corrected16.
//
// Revision16 1.7  2001/08/24 21:01:12  mohor16
// Things16 connected16 to parity16 changed.
// Clock16 devider16 changed.
//
// Revision16 1.6  2001/08/23 16:05:05  mohor16
// Stop bit bug16 fixed16.
// Parity16 bug16 fixed16.
// WISHBONE16 read cycle bug16 fixed16,
// OE16 indicator16 (Overrun16 Error) bug16 fixed16.
// PE16 indicator16 (Parity16 Error) bug16 fixed16.
// Register read bug16 fixed16.
//
// Revision16 1.5  2001/05/31 20:08:01  gorban16
// FIFO changes16 and other corrections16.
//
// Revision16 1.4  2001/05/21 19:12:02  gorban16
// Corrected16 some16 Linter16 messages16.
//
// Revision16 1.3  2001/05/17 18:34:18  gorban16
// First16 'stable' release. Should16 be sythesizable16 now. Also16 added new header.
//
// Revision16 1.0  2001-05-17 21:27:11+02  jacob16
// Initial16 revision16
//
//

// remove comments16 to restore16 to use the new version16 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i16 signal16 is used to put data in correct16 place16
// also, in 8-bit version16 there16'll be no debugging16 features16 included16
// CAUTION16: doesn't work16 with current version16 of OR120016
//`define DATA_BUS_WIDTH_816

`ifdef DATA_BUS_WIDTH_816
 `define UART_ADDR_WIDTH16 3
 `define UART_DATA_WIDTH16 8
`else
 `define UART_ADDR_WIDTH16 5
 `define UART_DATA_WIDTH16 32
`endif

// Uncomment16 this if you want16 your16 UART16 to have
// 16xBaudrate output port.
// If16 defined, the enable signal16 will be used to drive16 baudrate_o16 signal16
// It's frequency16 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT16

// Register addresses16
`define UART_REG_RB16	`UART_ADDR_WIDTH16'd0	// receiver16 buffer16
`define UART_REG_TR16  `UART_ADDR_WIDTH16'd0	// transmitter16
`define UART_REG_IE16	`UART_ADDR_WIDTH16'd1	// Interrupt16 enable
`define UART_REG_II16  `UART_ADDR_WIDTH16'd2	// Interrupt16 identification16
`define UART_REG_FC16  `UART_ADDR_WIDTH16'd2	// FIFO control16
`define UART_REG_LC16	`UART_ADDR_WIDTH16'd3	// Line16 Control16
`define UART_REG_MC16	`UART_ADDR_WIDTH16'd4	// Modem16 control16
`define UART_REG_LS16  `UART_ADDR_WIDTH16'd5	// Line16 status
`define UART_REG_MS16  `UART_ADDR_WIDTH16'd6	// Modem16 status
`define UART_REG_SR16  `UART_ADDR_WIDTH16'd7	// Scratch16 register
`define UART_REG_DL116	`UART_ADDR_WIDTH16'd0	// Divisor16 latch16 bytes (1-2)
`define UART_REG_DL216	`UART_ADDR_WIDTH16'd1

// Interrupt16 Enable16 register bits
`define UART_IE_RDA16	0	// Received16 Data available interrupt16
`define UART_IE_THRE16	1	// Transmitter16 Holding16 Register empty16 interrupt16
`define UART_IE_RLS16	2	// Receiver16 Line16 Status Interrupt16
`define UART_IE_MS16	3	// Modem16 Status Interrupt16

// Interrupt16 Identification16 register bits
`define UART_II_IP16	0	// Interrupt16 pending when 0
`define UART_II_II16	3:1	// Interrupt16 identification16

// Interrupt16 identification16 values for bits 3:1
`define UART_II_RLS16	3'b011	// Receiver16 Line16 Status
`define UART_II_RDA16	3'b010	// Receiver16 Data available
`define UART_II_TI16	3'b110	// Timeout16 Indication16
`define UART_II_THRE16	3'b001	// Transmitter16 Holding16 Register empty16
`define UART_II_MS16	3'b000	// Modem16 Status

// FIFO Control16 Register bits
`define UART_FC_TL16	1:0	// Trigger16 level

// FIFO trigger level values
`define UART_FC_116		2'b00
`define UART_FC_416		2'b01
`define UART_FC_816		2'b10
`define UART_FC_1416	2'b11

// Line16 Control16 register bits
`define UART_LC_BITS16	1:0	// bits in character16
`define UART_LC_SB16	2	// stop bits
`define UART_LC_PE16	3	// parity16 enable
`define UART_LC_EP16	4	// even16 parity16
`define UART_LC_SP16	5	// stick16 parity16
`define UART_LC_BC16	6	// Break16 control16
`define UART_LC_DL16	7	// Divisor16 Latch16 access bit

// Modem16 Control16 register bits
`define UART_MC_DTR16	0
`define UART_MC_RTS16	1
`define UART_MC_OUT116	2
`define UART_MC_OUT216	3
`define UART_MC_LB16	4	// Loopback16 mode

// Line16 Status Register bits
`define UART_LS_DR16	0	// Data ready
`define UART_LS_OE16	1	// Overrun16 Error
`define UART_LS_PE16	2	// Parity16 Error
`define UART_LS_FE16	3	// Framing16 Error
`define UART_LS_BI16	4	// Break16 interrupt16
`define UART_LS_TFE16	5	// Transmit16 FIFO is empty16
`define UART_LS_TE16	6	// Transmitter16 Empty16 indicator16
`define UART_LS_EI16	7	// Error indicator16

// Modem16 Status Register bits
`define UART_MS_DCTS16	0	// Delta16 signals16
`define UART_MS_DDSR16	1
`define UART_MS_TERI16	2
`define UART_MS_DDCD16	3
`define UART_MS_CCTS16	4	// Complement16 signals16
`define UART_MS_CDSR16	5
`define UART_MS_CRI16	6
`define UART_MS_CDCD16	7

// FIFO parameter defines16

`define UART_FIFO_WIDTH16	8
`define UART_FIFO_DEPTH16	16
`define UART_FIFO_POINTER_W16	4
`define UART_FIFO_COUNTER_W16	5
// receiver16 fifo has width 11 because it has break, parity16 and framing16 error bits
`define UART_FIFO_REC_WIDTH16  11


`define VERBOSE_WB16  0           // All activity16 on the WISHBONE16 is recorded16
`define VERBOSE_LINE_STATUS16 0   // Details16 about16 the lsr16 (line status register)
`define FAST_TEST16   1           // 64/1024 packets16 are sent16







