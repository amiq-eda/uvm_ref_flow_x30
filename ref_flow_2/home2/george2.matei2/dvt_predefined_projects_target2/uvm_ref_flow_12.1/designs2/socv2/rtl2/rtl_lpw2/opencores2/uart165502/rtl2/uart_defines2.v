//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines2.v                                              ////
////                                                              ////
////                                                              ////
////  This2 file is part of the "UART2 16550 compatible2" project2    ////
////  http2://www2.opencores2.org2/cores2/uart165502/                   ////
////                                                              ////
////  Documentation2 related2 to this project2:                      ////
////  - http2://www2.opencores2.org2/cores2/uart165502/                 ////
////                                                              ////
////  Projects2 compatibility2:                                     ////
////  - WISHBONE2                                                  ////
////  RS2322 Protocol2                                              ////
////  16550D uart2 (mostly2 supported)                              ////
////                                                              ////
////  Overview2 (main2 Features2):                                   ////
////  Defines2 of the Core2                                         ////
////                                                              ////
////  Known2 problems2 (limits2):                                    ////
////  None2                                                        ////
////                                                              ////
////  To2 Do2:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author2(s):                                                  ////
////      - gorban2@opencores2.org2                                  ////
////      - Jacob2 Gorban2                                          ////
////      - Igor2 Mohor2 (igorm2@opencores2.org2)                      ////
////                                                              ////
////  Created2:        2001/05/12                                  ////
////  Last2 Updated2:   2001/05/17                                  ////
////                  (See log2 for the revision2 history2)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2000, 2001 Authors2                             ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS2 Revision2 History2
//
// $Log: not supported by cvs2svn2 $
// Revision2 1.13  2003/06/11 16:37:47  gorban2
// This2 fixes2 errors2 in some2 cases2 when data is being read and put to the FIFO at the same time. Patch2 is submitted2 by Scott2 Furman2. Update is very2 recommended2.
//
// Revision2 1.12  2002/07/22 23:02:23  gorban2
// Bug2 Fixes2:
//  * Possible2 loss of sync and bad2 reception2 of stop bit on slow2 baud2 rates2 fixed2.
//   Problem2 reported2 by Kenny2.Tung2.
//  * Bad (or lack2 of ) loopback2 handling2 fixed2. Reported2 by Cherry2 Withers2.
//
// Improvements2:
//  * Made2 FIFO's as general2 inferrable2 memory where possible2.
//  So2 on FPGA2 they should be inferred2 as RAM2 (Distributed2 RAM2 on Xilinx2).
//  This2 saves2 about2 1/3 of the Slice2 count and reduces2 P&R and synthesis2 times.
//
//  * Added2 optional2 baudrate2 output (baud_o2).
//  This2 is identical2 to BAUDOUT2* signal2 on 16550 chip2.
//  It outputs2 16xbit_clock_rate - the divided2 clock2.
//  It's disabled by default. Define2 UART_HAS_BAUDRATE_OUTPUT2 to use.
//
// Revision2 1.10  2001/12/11 08:55:40  mohor2
// Scratch2 register define added.
//
// Revision2 1.9  2001/12/03 21:44:29  gorban2
// Updated2 specification2 documentation.
// Added2 full 32-bit data bus interface, now as default.
// Address is 5-bit wide2 in 32-bit data bus mode.
// Added2 wb_sel_i2 input to the core2. It's used in the 32-bit mode.
// Added2 debug2 interface with two2 32-bit read-only registers in 32-bit mode.
// Bits2 5 and 6 of LSR2 are now only cleared2 on TX2 FIFO write.
// My2 small test bench2 is modified to work2 with 32-bit mode.
//
// Revision2 1.8  2001/11/26 21:38:54  gorban2
// Lots2 of fixes2:
// Break2 condition wasn2't handled2 correctly at all.
// LSR2 bits could lose2 their2 values.
// LSR2 value after reset was wrong2.
// Timing2 of THRE2 interrupt2 signal2 corrected2.
// LSR2 bit 0 timing2 corrected2.
//
// Revision2 1.7  2001/08/24 21:01:12  mohor2
// Things2 connected2 to parity2 changed.
// Clock2 devider2 changed.
//
// Revision2 1.6  2001/08/23 16:05:05  mohor2
// Stop bit bug2 fixed2.
// Parity2 bug2 fixed2.
// WISHBONE2 read cycle bug2 fixed2,
// OE2 indicator2 (Overrun2 Error) bug2 fixed2.
// PE2 indicator2 (Parity2 Error) bug2 fixed2.
// Register read bug2 fixed2.
//
// Revision2 1.5  2001/05/31 20:08:01  gorban2
// FIFO changes2 and other corrections2.
//
// Revision2 1.4  2001/05/21 19:12:02  gorban2
// Corrected2 some2 Linter2 messages2.
//
// Revision2 1.3  2001/05/17 18:34:18  gorban2
// First2 'stable' release. Should2 be sythesizable2 now. Also2 added new header.
//
// Revision2 1.0  2001-05-17 21:27:11+02  jacob2
// Initial2 revision2
//
//

// remove comments2 to restore2 to use the new version2 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i2 signal2 is used to put data in correct2 place2
// also, in 8-bit version2 there2'll be no debugging2 features2 included2
// CAUTION2: doesn't work2 with current version2 of OR12002
//`define DATA_BUS_WIDTH_82

`ifdef DATA_BUS_WIDTH_82
 `define UART_ADDR_WIDTH2 3
 `define UART_DATA_WIDTH2 8
`else
 `define UART_ADDR_WIDTH2 5
 `define UART_DATA_WIDTH2 32
`endif

// Uncomment2 this if you want2 your2 UART2 to have
// 16xBaudrate output port.
// If2 defined, the enable signal2 will be used to drive2 baudrate_o2 signal2
// It's frequency2 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT2

// Register addresses2
`define UART_REG_RB2	`UART_ADDR_WIDTH2'd0	// receiver2 buffer2
`define UART_REG_TR2  `UART_ADDR_WIDTH2'd0	// transmitter2
`define UART_REG_IE2	`UART_ADDR_WIDTH2'd1	// Interrupt2 enable
`define UART_REG_II2  `UART_ADDR_WIDTH2'd2	// Interrupt2 identification2
`define UART_REG_FC2  `UART_ADDR_WIDTH2'd2	// FIFO control2
`define UART_REG_LC2	`UART_ADDR_WIDTH2'd3	// Line2 Control2
`define UART_REG_MC2	`UART_ADDR_WIDTH2'd4	// Modem2 control2
`define UART_REG_LS2  `UART_ADDR_WIDTH2'd5	// Line2 status
`define UART_REG_MS2  `UART_ADDR_WIDTH2'd6	// Modem2 status
`define UART_REG_SR2  `UART_ADDR_WIDTH2'd7	// Scratch2 register
`define UART_REG_DL12	`UART_ADDR_WIDTH2'd0	// Divisor2 latch2 bytes (1-2)
`define UART_REG_DL22	`UART_ADDR_WIDTH2'd1

// Interrupt2 Enable2 register bits
`define UART_IE_RDA2	0	// Received2 Data available interrupt2
`define UART_IE_THRE2	1	// Transmitter2 Holding2 Register empty2 interrupt2
`define UART_IE_RLS2	2	// Receiver2 Line2 Status Interrupt2
`define UART_IE_MS2	3	// Modem2 Status Interrupt2

// Interrupt2 Identification2 register bits
`define UART_II_IP2	0	// Interrupt2 pending when 0
`define UART_II_II2	3:1	// Interrupt2 identification2

// Interrupt2 identification2 values for bits 3:1
`define UART_II_RLS2	3'b011	// Receiver2 Line2 Status
`define UART_II_RDA2	3'b010	// Receiver2 Data available
`define UART_II_TI2	3'b110	// Timeout2 Indication2
`define UART_II_THRE2	3'b001	// Transmitter2 Holding2 Register empty2
`define UART_II_MS2	3'b000	// Modem2 Status

// FIFO Control2 Register bits
`define UART_FC_TL2	1:0	// Trigger2 level

// FIFO trigger level values
`define UART_FC_12		2'b00
`define UART_FC_42		2'b01
`define UART_FC_82		2'b10
`define UART_FC_142	2'b11

// Line2 Control2 register bits
`define UART_LC_BITS2	1:0	// bits in character2
`define UART_LC_SB2	2	// stop bits
`define UART_LC_PE2	3	// parity2 enable
`define UART_LC_EP2	4	// even2 parity2
`define UART_LC_SP2	5	// stick2 parity2
`define UART_LC_BC2	6	// Break2 control2
`define UART_LC_DL2	7	// Divisor2 Latch2 access bit

// Modem2 Control2 register bits
`define UART_MC_DTR2	0
`define UART_MC_RTS2	1
`define UART_MC_OUT12	2
`define UART_MC_OUT22	3
`define UART_MC_LB2	4	// Loopback2 mode

// Line2 Status Register bits
`define UART_LS_DR2	0	// Data ready
`define UART_LS_OE2	1	// Overrun2 Error
`define UART_LS_PE2	2	// Parity2 Error
`define UART_LS_FE2	3	// Framing2 Error
`define UART_LS_BI2	4	// Break2 interrupt2
`define UART_LS_TFE2	5	// Transmit2 FIFO is empty2
`define UART_LS_TE2	6	// Transmitter2 Empty2 indicator2
`define UART_LS_EI2	7	// Error indicator2

// Modem2 Status Register bits
`define UART_MS_DCTS2	0	// Delta2 signals2
`define UART_MS_DDSR2	1
`define UART_MS_TERI2	2
`define UART_MS_DDCD2	3
`define UART_MS_CCTS2	4	// Complement2 signals2
`define UART_MS_CDSR2	5
`define UART_MS_CRI2	6
`define UART_MS_CDCD2	7

// FIFO parameter defines2

`define UART_FIFO_WIDTH2	8
`define UART_FIFO_DEPTH2	16
`define UART_FIFO_POINTER_W2	4
`define UART_FIFO_COUNTER_W2	5
// receiver2 fifo has width 11 because it has break, parity2 and framing2 error bits
`define UART_FIFO_REC_WIDTH2  11


`define VERBOSE_WB2  0           // All activity2 on the WISHBONE2 is recorded2
`define VERBOSE_LINE_STATUS2 0   // Details2 about2 the lsr2 (line status register)
`define FAST_TEST2   1           // 64/1024 packets2 are sent2







