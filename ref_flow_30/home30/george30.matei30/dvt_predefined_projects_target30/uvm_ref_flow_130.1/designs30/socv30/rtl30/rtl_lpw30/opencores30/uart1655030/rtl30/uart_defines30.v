//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines30.v                                              ////
////                                                              ////
////                                                              ////
////  This30 file is part of the "UART30 16550 compatible30" project30    ////
////  http30://www30.opencores30.org30/cores30/uart1655030/                   ////
////                                                              ////
////  Documentation30 related30 to this project30:                      ////
////  - http30://www30.opencores30.org30/cores30/uart1655030/                 ////
////                                                              ////
////  Projects30 compatibility30:                                     ////
////  - WISHBONE30                                                  ////
////  RS23230 Protocol30                                              ////
////  16550D uart30 (mostly30 supported)                              ////
////                                                              ////
////  Overview30 (main30 Features30):                                   ////
////  Defines30 of the Core30                                         ////
////                                                              ////
////  Known30 problems30 (limits30):                                    ////
////  None30                                                        ////
////                                                              ////
////  To30 Do30:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author30(s):                                                  ////
////      - gorban30@opencores30.org30                                  ////
////      - Jacob30 Gorban30                                          ////
////      - Igor30 Mohor30 (igorm30@opencores30.org30)                      ////
////                                                              ////
////  Created30:        2001/05/12                                  ////
////  Last30 Updated30:   2001/05/17                                  ////
////                  (See log30 for the revision30 history30)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright30 (C) 2000, 2001 Authors30                             ////
////                                                              ////
//// This30 source30 file may be used and distributed30 without         ////
//// restriction30 provided that this copyright30 statement30 is not    ////
//// removed from the file and that any derivative30 work30 contains30  ////
//// the original copyright30 notice30 and the associated disclaimer30. ////
////                                                              ////
//// This30 source30 file is free software30; you can redistribute30 it   ////
//// and/or modify it under the terms30 of the GNU30 Lesser30 General30   ////
//// Public30 License30 as published30 by the Free30 Software30 Foundation30; ////
//// either30 version30 2.1 of the License30, or (at your30 option) any   ////
//// later30 version30.                                               ////
////                                                              ////
//// This30 source30 is distributed30 in the hope30 that it will be       ////
//// useful30, but WITHOUT30 ANY30 WARRANTY30; without even30 the implied30   ////
//// warranty30 of MERCHANTABILITY30 or FITNESS30 FOR30 A PARTICULAR30      ////
//// PURPOSE30.  See the GNU30 Lesser30 General30 Public30 License30 for more ////
//// details30.                                                     ////
////                                                              ////
//// You should have received30 a copy of the GNU30 Lesser30 General30    ////
//// Public30 License30 along30 with this source30; if not, download30 it   ////
//// from http30://www30.opencores30.org30/lgpl30.shtml30                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS30 Revision30 History30
//
// $Log: not supported by cvs2svn30 $
// Revision30 1.13  2003/06/11 16:37:47  gorban30
// This30 fixes30 errors30 in some30 cases30 when data is being read and put to the FIFO at the same time. Patch30 is submitted30 by Scott30 Furman30. Update is very30 recommended30.
//
// Revision30 1.12  2002/07/22 23:02:23  gorban30
// Bug30 Fixes30:
//  * Possible30 loss of sync and bad30 reception30 of stop bit on slow30 baud30 rates30 fixed30.
//   Problem30 reported30 by Kenny30.Tung30.
//  * Bad (or lack30 of ) loopback30 handling30 fixed30. Reported30 by Cherry30 Withers30.
//
// Improvements30:
//  * Made30 FIFO's as general30 inferrable30 memory where possible30.
//  So30 on FPGA30 they should be inferred30 as RAM30 (Distributed30 RAM30 on Xilinx30).
//  This30 saves30 about30 1/3 of the Slice30 count and reduces30 P&R and synthesis30 times.
//
//  * Added30 optional30 baudrate30 output (baud_o30).
//  This30 is identical30 to BAUDOUT30* signal30 on 16550 chip30.
//  It outputs30 16xbit_clock_rate - the divided30 clock30.
//  It's disabled by default. Define30 UART_HAS_BAUDRATE_OUTPUT30 to use.
//
// Revision30 1.10  2001/12/11 08:55:40  mohor30
// Scratch30 register define added.
//
// Revision30 1.9  2001/12/03 21:44:29  gorban30
// Updated30 specification30 documentation.
// Added30 full 32-bit data bus interface, now as default.
// Address is 5-bit wide30 in 32-bit data bus mode.
// Added30 wb_sel_i30 input to the core30. It's used in the 32-bit mode.
// Added30 debug30 interface with two30 32-bit read-only registers in 32-bit mode.
// Bits30 5 and 6 of LSR30 are now only cleared30 on TX30 FIFO write.
// My30 small test bench30 is modified to work30 with 32-bit mode.
//
// Revision30 1.8  2001/11/26 21:38:54  gorban30
// Lots30 of fixes30:
// Break30 condition wasn30't handled30 correctly at all.
// LSR30 bits could lose30 their30 values.
// LSR30 value after reset was wrong30.
// Timing30 of THRE30 interrupt30 signal30 corrected30.
// LSR30 bit 0 timing30 corrected30.
//
// Revision30 1.7  2001/08/24 21:01:12  mohor30
// Things30 connected30 to parity30 changed.
// Clock30 devider30 changed.
//
// Revision30 1.6  2001/08/23 16:05:05  mohor30
// Stop bit bug30 fixed30.
// Parity30 bug30 fixed30.
// WISHBONE30 read cycle bug30 fixed30,
// OE30 indicator30 (Overrun30 Error) bug30 fixed30.
// PE30 indicator30 (Parity30 Error) bug30 fixed30.
// Register read bug30 fixed30.
//
// Revision30 1.5  2001/05/31 20:08:01  gorban30
// FIFO changes30 and other corrections30.
//
// Revision30 1.4  2001/05/21 19:12:02  gorban30
// Corrected30 some30 Linter30 messages30.
//
// Revision30 1.3  2001/05/17 18:34:18  gorban30
// First30 'stable' release. Should30 be sythesizable30 now. Also30 added new header.
//
// Revision30 1.0  2001-05-17 21:27:11+02  jacob30
// Initial30 revision30
//
//

// remove comments30 to restore30 to use the new version30 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i30 signal30 is used to put data in correct30 place30
// also, in 8-bit version30 there30'll be no debugging30 features30 included30
// CAUTION30: doesn't work30 with current version30 of OR120030
//`define DATA_BUS_WIDTH_830

`ifdef DATA_BUS_WIDTH_830
 `define UART_ADDR_WIDTH30 3
 `define UART_DATA_WIDTH30 8
`else
 `define UART_ADDR_WIDTH30 5
 `define UART_DATA_WIDTH30 32
`endif

// Uncomment30 this if you want30 your30 UART30 to have
// 16xBaudrate output port.
// If30 defined, the enable signal30 will be used to drive30 baudrate_o30 signal30
// It's frequency30 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT30

// Register addresses30
`define UART_REG_RB30	`UART_ADDR_WIDTH30'd0	// receiver30 buffer30
`define UART_REG_TR30  `UART_ADDR_WIDTH30'd0	// transmitter30
`define UART_REG_IE30	`UART_ADDR_WIDTH30'd1	// Interrupt30 enable
`define UART_REG_II30  `UART_ADDR_WIDTH30'd2	// Interrupt30 identification30
`define UART_REG_FC30  `UART_ADDR_WIDTH30'd2	// FIFO control30
`define UART_REG_LC30	`UART_ADDR_WIDTH30'd3	// Line30 Control30
`define UART_REG_MC30	`UART_ADDR_WIDTH30'd4	// Modem30 control30
`define UART_REG_LS30  `UART_ADDR_WIDTH30'd5	// Line30 status
`define UART_REG_MS30  `UART_ADDR_WIDTH30'd6	// Modem30 status
`define UART_REG_SR30  `UART_ADDR_WIDTH30'd7	// Scratch30 register
`define UART_REG_DL130	`UART_ADDR_WIDTH30'd0	// Divisor30 latch30 bytes (1-2)
`define UART_REG_DL230	`UART_ADDR_WIDTH30'd1

// Interrupt30 Enable30 register bits
`define UART_IE_RDA30	0	// Received30 Data available interrupt30
`define UART_IE_THRE30	1	// Transmitter30 Holding30 Register empty30 interrupt30
`define UART_IE_RLS30	2	// Receiver30 Line30 Status Interrupt30
`define UART_IE_MS30	3	// Modem30 Status Interrupt30

// Interrupt30 Identification30 register bits
`define UART_II_IP30	0	// Interrupt30 pending when 0
`define UART_II_II30	3:1	// Interrupt30 identification30

// Interrupt30 identification30 values for bits 3:1
`define UART_II_RLS30	3'b011	// Receiver30 Line30 Status
`define UART_II_RDA30	3'b010	// Receiver30 Data available
`define UART_II_TI30	3'b110	// Timeout30 Indication30
`define UART_II_THRE30	3'b001	// Transmitter30 Holding30 Register empty30
`define UART_II_MS30	3'b000	// Modem30 Status

// FIFO Control30 Register bits
`define UART_FC_TL30	1:0	// Trigger30 level

// FIFO trigger level values
`define UART_FC_130		2'b00
`define UART_FC_430		2'b01
`define UART_FC_830		2'b10
`define UART_FC_1430	2'b11

// Line30 Control30 register bits
`define UART_LC_BITS30	1:0	// bits in character30
`define UART_LC_SB30	2	// stop bits
`define UART_LC_PE30	3	// parity30 enable
`define UART_LC_EP30	4	// even30 parity30
`define UART_LC_SP30	5	// stick30 parity30
`define UART_LC_BC30	6	// Break30 control30
`define UART_LC_DL30	7	// Divisor30 Latch30 access bit

// Modem30 Control30 register bits
`define UART_MC_DTR30	0
`define UART_MC_RTS30	1
`define UART_MC_OUT130	2
`define UART_MC_OUT230	3
`define UART_MC_LB30	4	// Loopback30 mode

// Line30 Status Register bits
`define UART_LS_DR30	0	// Data ready
`define UART_LS_OE30	1	// Overrun30 Error
`define UART_LS_PE30	2	// Parity30 Error
`define UART_LS_FE30	3	// Framing30 Error
`define UART_LS_BI30	4	// Break30 interrupt30
`define UART_LS_TFE30	5	// Transmit30 FIFO is empty30
`define UART_LS_TE30	6	// Transmitter30 Empty30 indicator30
`define UART_LS_EI30	7	// Error indicator30

// Modem30 Status Register bits
`define UART_MS_DCTS30	0	// Delta30 signals30
`define UART_MS_DDSR30	1
`define UART_MS_TERI30	2
`define UART_MS_DDCD30	3
`define UART_MS_CCTS30	4	// Complement30 signals30
`define UART_MS_CDSR30	5
`define UART_MS_CRI30	6
`define UART_MS_CDCD30	7

// FIFO parameter defines30

`define UART_FIFO_WIDTH30	8
`define UART_FIFO_DEPTH30	16
`define UART_FIFO_POINTER_W30	4
`define UART_FIFO_COUNTER_W30	5
// receiver30 fifo has width 11 because it has break, parity30 and framing30 error bits
`define UART_FIFO_REC_WIDTH30  11


`define VERBOSE_WB30  0           // All activity30 on the WISHBONE30 is recorded30
`define VERBOSE_LINE_STATUS30 0   // Details30 about30 the lsr30 (line status register)
`define FAST_TEST30   1           // 64/1024 packets30 are sent30







