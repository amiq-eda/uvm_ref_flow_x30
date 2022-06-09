//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines17.v                                              ////
////                                                              ////
////                                                              ////
////  This17 file is part of the "UART17 16550 compatible17" project17    ////
////  http17://www17.opencores17.org17/cores17/uart1655017/                   ////
////                                                              ////
////  Documentation17 related17 to this project17:                      ////
////  - http17://www17.opencores17.org17/cores17/uart1655017/                 ////
////                                                              ////
////  Projects17 compatibility17:                                     ////
////  - WISHBONE17                                                  ////
////  RS23217 Protocol17                                              ////
////  16550D uart17 (mostly17 supported)                              ////
////                                                              ////
////  Overview17 (main17 Features17):                                   ////
////  Defines17 of the Core17                                         ////
////                                                              ////
////  Known17 problems17 (limits17):                                    ////
////  None17                                                        ////
////                                                              ////
////  To17 Do17:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author17(s):                                                  ////
////      - gorban17@opencores17.org17                                  ////
////      - Jacob17 Gorban17                                          ////
////      - Igor17 Mohor17 (igorm17@opencores17.org17)                      ////
////                                                              ////
////  Created17:        2001/05/12                                  ////
////  Last17 Updated17:   2001/05/17                                  ////
////                  (See log17 for the revision17 history17)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2000, 2001 Authors17                             ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS17 Revision17 History17
//
// $Log: not supported by cvs2svn17 $
// Revision17 1.13  2003/06/11 16:37:47  gorban17
// This17 fixes17 errors17 in some17 cases17 when data is being read and put to the FIFO at the same time. Patch17 is submitted17 by Scott17 Furman17. Update is very17 recommended17.
//
// Revision17 1.12  2002/07/22 23:02:23  gorban17
// Bug17 Fixes17:
//  * Possible17 loss of sync and bad17 reception17 of stop bit on slow17 baud17 rates17 fixed17.
//   Problem17 reported17 by Kenny17.Tung17.
//  * Bad (or lack17 of ) loopback17 handling17 fixed17. Reported17 by Cherry17 Withers17.
//
// Improvements17:
//  * Made17 FIFO's as general17 inferrable17 memory where possible17.
//  So17 on FPGA17 they should be inferred17 as RAM17 (Distributed17 RAM17 on Xilinx17).
//  This17 saves17 about17 1/3 of the Slice17 count and reduces17 P&R and synthesis17 times.
//
//  * Added17 optional17 baudrate17 output (baud_o17).
//  This17 is identical17 to BAUDOUT17* signal17 on 16550 chip17.
//  It outputs17 16xbit_clock_rate - the divided17 clock17.
//  It's disabled by default. Define17 UART_HAS_BAUDRATE_OUTPUT17 to use.
//
// Revision17 1.10  2001/12/11 08:55:40  mohor17
// Scratch17 register define added.
//
// Revision17 1.9  2001/12/03 21:44:29  gorban17
// Updated17 specification17 documentation.
// Added17 full 32-bit data bus interface, now as default.
// Address is 5-bit wide17 in 32-bit data bus mode.
// Added17 wb_sel_i17 input to the core17. It's used in the 32-bit mode.
// Added17 debug17 interface with two17 32-bit read-only registers in 32-bit mode.
// Bits17 5 and 6 of LSR17 are now only cleared17 on TX17 FIFO write.
// My17 small test bench17 is modified to work17 with 32-bit mode.
//
// Revision17 1.8  2001/11/26 21:38:54  gorban17
// Lots17 of fixes17:
// Break17 condition wasn17't handled17 correctly at all.
// LSR17 bits could lose17 their17 values.
// LSR17 value after reset was wrong17.
// Timing17 of THRE17 interrupt17 signal17 corrected17.
// LSR17 bit 0 timing17 corrected17.
//
// Revision17 1.7  2001/08/24 21:01:12  mohor17
// Things17 connected17 to parity17 changed.
// Clock17 devider17 changed.
//
// Revision17 1.6  2001/08/23 16:05:05  mohor17
// Stop bit bug17 fixed17.
// Parity17 bug17 fixed17.
// WISHBONE17 read cycle bug17 fixed17,
// OE17 indicator17 (Overrun17 Error) bug17 fixed17.
// PE17 indicator17 (Parity17 Error) bug17 fixed17.
// Register read bug17 fixed17.
//
// Revision17 1.5  2001/05/31 20:08:01  gorban17
// FIFO changes17 and other corrections17.
//
// Revision17 1.4  2001/05/21 19:12:02  gorban17
// Corrected17 some17 Linter17 messages17.
//
// Revision17 1.3  2001/05/17 18:34:18  gorban17
// First17 'stable' release. Should17 be sythesizable17 now. Also17 added new header.
//
// Revision17 1.0  2001-05-17 21:27:11+02  jacob17
// Initial17 revision17
//
//

// remove comments17 to restore17 to use the new version17 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i17 signal17 is used to put data in correct17 place17
// also, in 8-bit version17 there17'll be no debugging17 features17 included17
// CAUTION17: doesn't work17 with current version17 of OR120017
//`define DATA_BUS_WIDTH_817

`ifdef DATA_BUS_WIDTH_817
 `define UART_ADDR_WIDTH17 3
 `define UART_DATA_WIDTH17 8
`else
 `define UART_ADDR_WIDTH17 5
 `define UART_DATA_WIDTH17 32
`endif

// Uncomment17 this if you want17 your17 UART17 to have
// 16xBaudrate output port.
// If17 defined, the enable signal17 will be used to drive17 baudrate_o17 signal17
// It's frequency17 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT17

// Register addresses17
`define UART_REG_RB17	`UART_ADDR_WIDTH17'd0	// receiver17 buffer17
`define UART_REG_TR17  `UART_ADDR_WIDTH17'd0	// transmitter17
`define UART_REG_IE17	`UART_ADDR_WIDTH17'd1	// Interrupt17 enable
`define UART_REG_II17  `UART_ADDR_WIDTH17'd2	// Interrupt17 identification17
`define UART_REG_FC17  `UART_ADDR_WIDTH17'd2	// FIFO control17
`define UART_REG_LC17	`UART_ADDR_WIDTH17'd3	// Line17 Control17
`define UART_REG_MC17	`UART_ADDR_WIDTH17'd4	// Modem17 control17
`define UART_REG_LS17  `UART_ADDR_WIDTH17'd5	// Line17 status
`define UART_REG_MS17  `UART_ADDR_WIDTH17'd6	// Modem17 status
`define UART_REG_SR17  `UART_ADDR_WIDTH17'd7	// Scratch17 register
`define UART_REG_DL117	`UART_ADDR_WIDTH17'd0	// Divisor17 latch17 bytes (1-2)
`define UART_REG_DL217	`UART_ADDR_WIDTH17'd1

// Interrupt17 Enable17 register bits
`define UART_IE_RDA17	0	// Received17 Data available interrupt17
`define UART_IE_THRE17	1	// Transmitter17 Holding17 Register empty17 interrupt17
`define UART_IE_RLS17	2	// Receiver17 Line17 Status Interrupt17
`define UART_IE_MS17	3	// Modem17 Status Interrupt17

// Interrupt17 Identification17 register bits
`define UART_II_IP17	0	// Interrupt17 pending when 0
`define UART_II_II17	3:1	// Interrupt17 identification17

// Interrupt17 identification17 values for bits 3:1
`define UART_II_RLS17	3'b011	// Receiver17 Line17 Status
`define UART_II_RDA17	3'b010	// Receiver17 Data available
`define UART_II_TI17	3'b110	// Timeout17 Indication17
`define UART_II_THRE17	3'b001	// Transmitter17 Holding17 Register empty17
`define UART_II_MS17	3'b000	// Modem17 Status

// FIFO Control17 Register bits
`define UART_FC_TL17	1:0	// Trigger17 level

// FIFO trigger level values
`define UART_FC_117		2'b00
`define UART_FC_417		2'b01
`define UART_FC_817		2'b10
`define UART_FC_1417	2'b11

// Line17 Control17 register bits
`define UART_LC_BITS17	1:0	// bits in character17
`define UART_LC_SB17	2	// stop bits
`define UART_LC_PE17	3	// parity17 enable
`define UART_LC_EP17	4	// even17 parity17
`define UART_LC_SP17	5	// stick17 parity17
`define UART_LC_BC17	6	// Break17 control17
`define UART_LC_DL17	7	// Divisor17 Latch17 access bit

// Modem17 Control17 register bits
`define UART_MC_DTR17	0
`define UART_MC_RTS17	1
`define UART_MC_OUT117	2
`define UART_MC_OUT217	3
`define UART_MC_LB17	4	// Loopback17 mode

// Line17 Status Register bits
`define UART_LS_DR17	0	// Data ready
`define UART_LS_OE17	1	// Overrun17 Error
`define UART_LS_PE17	2	// Parity17 Error
`define UART_LS_FE17	3	// Framing17 Error
`define UART_LS_BI17	4	// Break17 interrupt17
`define UART_LS_TFE17	5	// Transmit17 FIFO is empty17
`define UART_LS_TE17	6	// Transmitter17 Empty17 indicator17
`define UART_LS_EI17	7	// Error indicator17

// Modem17 Status Register bits
`define UART_MS_DCTS17	0	// Delta17 signals17
`define UART_MS_DDSR17	1
`define UART_MS_TERI17	2
`define UART_MS_DDCD17	3
`define UART_MS_CCTS17	4	// Complement17 signals17
`define UART_MS_CDSR17	5
`define UART_MS_CRI17	6
`define UART_MS_CDCD17	7

// FIFO parameter defines17

`define UART_FIFO_WIDTH17	8
`define UART_FIFO_DEPTH17	16
`define UART_FIFO_POINTER_W17	4
`define UART_FIFO_COUNTER_W17	5
// receiver17 fifo has width 11 because it has break, parity17 and framing17 error bits
`define UART_FIFO_REC_WIDTH17  11


`define VERBOSE_WB17  0           // All activity17 on the WISHBONE17 is recorded17
`define VERBOSE_LINE_STATUS17 0   // Details17 about17 the lsr17 (line status register)
`define FAST_TEST17   1           // 64/1024 packets17 are sent17







