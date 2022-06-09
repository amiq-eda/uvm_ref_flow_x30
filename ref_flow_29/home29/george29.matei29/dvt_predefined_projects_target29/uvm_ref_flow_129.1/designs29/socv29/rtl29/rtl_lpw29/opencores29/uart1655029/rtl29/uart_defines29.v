//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines29.v                                              ////
////                                                              ////
////                                                              ////
////  This29 file is part of the "UART29 16550 compatible29" project29    ////
////  http29://www29.opencores29.org29/cores29/uart1655029/                   ////
////                                                              ////
////  Documentation29 related29 to this project29:                      ////
////  - http29://www29.opencores29.org29/cores29/uart1655029/                 ////
////                                                              ////
////  Projects29 compatibility29:                                     ////
////  - WISHBONE29                                                  ////
////  RS23229 Protocol29                                              ////
////  16550D uart29 (mostly29 supported)                              ////
////                                                              ////
////  Overview29 (main29 Features29):                                   ////
////  Defines29 of the Core29                                         ////
////                                                              ////
////  Known29 problems29 (limits29):                                    ////
////  None29                                                        ////
////                                                              ////
////  To29 Do29:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author29(s):                                                  ////
////      - gorban29@opencores29.org29                                  ////
////      - Jacob29 Gorban29                                          ////
////      - Igor29 Mohor29 (igorm29@opencores29.org29)                      ////
////                                                              ////
////  Created29:        2001/05/12                                  ////
////  Last29 Updated29:   2001/05/17                                  ////
////                  (See log29 for the revision29 history29)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright29 (C) 2000, 2001 Authors29                             ////
////                                                              ////
//// This29 source29 file may be used and distributed29 without         ////
//// restriction29 provided that this copyright29 statement29 is not    ////
//// removed from the file and that any derivative29 work29 contains29  ////
//// the original copyright29 notice29 and the associated disclaimer29. ////
////                                                              ////
//// This29 source29 file is free software29; you can redistribute29 it   ////
//// and/or modify it under the terms29 of the GNU29 Lesser29 General29   ////
//// Public29 License29 as published29 by the Free29 Software29 Foundation29; ////
//// either29 version29 2.1 of the License29, or (at your29 option) any   ////
//// later29 version29.                                               ////
////                                                              ////
//// This29 source29 is distributed29 in the hope29 that it will be       ////
//// useful29, but WITHOUT29 ANY29 WARRANTY29; without even29 the implied29   ////
//// warranty29 of MERCHANTABILITY29 or FITNESS29 FOR29 A PARTICULAR29      ////
//// PURPOSE29.  See the GNU29 Lesser29 General29 Public29 License29 for more ////
//// details29.                                                     ////
////                                                              ////
//// You should have received29 a copy of the GNU29 Lesser29 General29    ////
//// Public29 License29 along29 with this source29; if not, download29 it   ////
//// from http29://www29.opencores29.org29/lgpl29.shtml29                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS29 Revision29 History29
//
// $Log: not supported by cvs2svn29 $
// Revision29 1.13  2003/06/11 16:37:47  gorban29
// This29 fixes29 errors29 in some29 cases29 when data is being read and put to the FIFO at the same time. Patch29 is submitted29 by Scott29 Furman29. Update is very29 recommended29.
//
// Revision29 1.12  2002/07/22 23:02:23  gorban29
// Bug29 Fixes29:
//  * Possible29 loss of sync and bad29 reception29 of stop bit on slow29 baud29 rates29 fixed29.
//   Problem29 reported29 by Kenny29.Tung29.
//  * Bad (or lack29 of ) loopback29 handling29 fixed29. Reported29 by Cherry29 Withers29.
//
// Improvements29:
//  * Made29 FIFO's as general29 inferrable29 memory where possible29.
//  So29 on FPGA29 they should be inferred29 as RAM29 (Distributed29 RAM29 on Xilinx29).
//  This29 saves29 about29 1/3 of the Slice29 count and reduces29 P&R and synthesis29 times.
//
//  * Added29 optional29 baudrate29 output (baud_o29).
//  This29 is identical29 to BAUDOUT29* signal29 on 16550 chip29.
//  It outputs29 16xbit_clock_rate - the divided29 clock29.
//  It's disabled by default. Define29 UART_HAS_BAUDRATE_OUTPUT29 to use.
//
// Revision29 1.10  2001/12/11 08:55:40  mohor29
// Scratch29 register define added.
//
// Revision29 1.9  2001/12/03 21:44:29  gorban29
// Updated29 specification29 documentation.
// Added29 full 32-bit data bus interface, now as default.
// Address is 5-bit wide29 in 32-bit data bus mode.
// Added29 wb_sel_i29 input to the core29. It's used in the 32-bit mode.
// Added29 debug29 interface with two29 32-bit read-only registers in 32-bit mode.
// Bits29 5 and 6 of LSR29 are now only cleared29 on TX29 FIFO write.
// My29 small test bench29 is modified to work29 with 32-bit mode.
//
// Revision29 1.8  2001/11/26 21:38:54  gorban29
// Lots29 of fixes29:
// Break29 condition wasn29't handled29 correctly at all.
// LSR29 bits could lose29 their29 values.
// LSR29 value after reset was wrong29.
// Timing29 of THRE29 interrupt29 signal29 corrected29.
// LSR29 bit 0 timing29 corrected29.
//
// Revision29 1.7  2001/08/24 21:01:12  mohor29
// Things29 connected29 to parity29 changed.
// Clock29 devider29 changed.
//
// Revision29 1.6  2001/08/23 16:05:05  mohor29
// Stop bit bug29 fixed29.
// Parity29 bug29 fixed29.
// WISHBONE29 read cycle bug29 fixed29,
// OE29 indicator29 (Overrun29 Error) bug29 fixed29.
// PE29 indicator29 (Parity29 Error) bug29 fixed29.
// Register read bug29 fixed29.
//
// Revision29 1.5  2001/05/31 20:08:01  gorban29
// FIFO changes29 and other corrections29.
//
// Revision29 1.4  2001/05/21 19:12:02  gorban29
// Corrected29 some29 Linter29 messages29.
//
// Revision29 1.3  2001/05/17 18:34:18  gorban29
// First29 'stable' release. Should29 be sythesizable29 now. Also29 added new header.
//
// Revision29 1.0  2001-05-17 21:27:11+02  jacob29
// Initial29 revision29
//
//

// remove comments29 to restore29 to use the new version29 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i29 signal29 is used to put data in correct29 place29
// also, in 8-bit version29 there29'll be no debugging29 features29 included29
// CAUTION29: doesn't work29 with current version29 of OR120029
//`define DATA_BUS_WIDTH_829

`ifdef DATA_BUS_WIDTH_829
 `define UART_ADDR_WIDTH29 3
 `define UART_DATA_WIDTH29 8
`else
 `define UART_ADDR_WIDTH29 5
 `define UART_DATA_WIDTH29 32
`endif

// Uncomment29 this if you want29 your29 UART29 to have
// 16xBaudrate output port.
// If29 defined, the enable signal29 will be used to drive29 baudrate_o29 signal29
// It's frequency29 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT29

// Register addresses29
`define UART_REG_RB29	`UART_ADDR_WIDTH29'd0	// receiver29 buffer29
`define UART_REG_TR29  `UART_ADDR_WIDTH29'd0	// transmitter29
`define UART_REG_IE29	`UART_ADDR_WIDTH29'd1	// Interrupt29 enable
`define UART_REG_II29  `UART_ADDR_WIDTH29'd2	// Interrupt29 identification29
`define UART_REG_FC29  `UART_ADDR_WIDTH29'd2	// FIFO control29
`define UART_REG_LC29	`UART_ADDR_WIDTH29'd3	// Line29 Control29
`define UART_REG_MC29	`UART_ADDR_WIDTH29'd4	// Modem29 control29
`define UART_REG_LS29  `UART_ADDR_WIDTH29'd5	// Line29 status
`define UART_REG_MS29  `UART_ADDR_WIDTH29'd6	// Modem29 status
`define UART_REG_SR29  `UART_ADDR_WIDTH29'd7	// Scratch29 register
`define UART_REG_DL129	`UART_ADDR_WIDTH29'd0	// Divisor29 latch29 bytes (1-2)
`define UART_REG_DL229	`UART_ADDR_WIDTH29'd1

// Interrupt29 Enable29 register bits
`define UART_IE_RDA29	0	// Received29 Data available interrupt29
`define UART_IE_THRE29	1	// Transmitter29 Holding29 Register empty29 interrupt29
`define UART_IE_RLS29	2	// Receiver29 Line29 Status Interrupt29
`define UART_IE_MS29	3	// Modem29 Status Interrupt29

// Interrupt29 Identification29 register bits
`define UART_II_IP29	0	// Interrupt29 pending when 0
`define UART_II_II29	3:1	// Interrupt29 identification29

// Interrupt29 identification29 values for bits 3:1
`define UART_II_RLS29	3'b011	// Receiver29 Line29 Status
`define UART_II_RDA29	3'b010	// Receiver29 Data available
`define UART_II_TI29	3'b110	// Timeout29 Indication29
`define UART_II_THRE29	3'b001	// Transmitter29 Holding29 Register empty29
`define UART_II_MS29	3'b000	// Modem29 Status

// FIFO Control29 Register bits
`define UART_FC_TL29	1:0	// Trigger29 level

// FIFO trigger level values
`define UART_FC_129		2'b00
`define UART_FC_429		2'b01
`define UART_FC_829		2'b10
`define UART_FC_1429	2'b11

// Line29 Control29 register bits
`define UART_LC_BITS29	1:0	// bits in character29
`define UART_LC_SB29	2	// stop bits
`define UART_LC_PE29	3	// parity29 enable
`define UART_LC_EP29	4	// even29 parity29
`define UART_LC_SP29	5	// stick29 parity29
`define UART_LC_BC29	6	// Break29 control29
`define UART_LC_DL29	7	// Divisor29 Latch29 access bit

// Modem29 Control29 register bits
`define UART_MC_DTR29	0
`define UART_MC_RTS29	1
`define UART_MC_OUT129	2
`define UART_MC_OUT229	3
`define UART_MC_LB29	4	// Loopback29 mode

// Line29 Status Register bits
`define UART_LS_DR29	0	// Data ready
`define UART_LS_OE29	1	// Overrun29 Error
`define UART_LS_PE29	2	// Parity29 Error
`define UART_LS_FE29	3	// Framing29 Error
`define UART_LS_BI29	4	// Break29 interrupt29
`define UART_LS_TFE29	5	// Transmit29 FIFO is empty29
`define UART_LS_TE29	6	// Transmitter29 Empty29 indicator29
`define UART_LS_EI29	7	// Error indicator29

// Modem29 Status Register bits
`define UART_MS_DCTS29	0	// Delta29 signals29
`define UART_MS_DDSR29	1
`define UART_MS_TERI29	2
`define UART_MS_DDCD29	3
`define UART_MS_CCTS29	4	// Complement29 signals29
`define UART_MS_CDSR29	5
`define UART_MS_CRI29	6
`define UART_MS_CDCD29	7

// FIFO parameter defines29

`define UART_FIFO_WIDTH29	8
`define UART_FIFO_DEPTH29	16
`define UART_FIFO_POINTER_W29	4
`define UART_FIFO_COUNTER_W29	5
// receiver29 fifo has width 11 because it has break, parity29 and framing29 error bits
`define UART_FIFO_REC_WIDTH29  11


`define VERBOSE_WB29  0           // All activity29 on the WISHBONE29 is recorded29
`define VERBOSE_LINE_STATUS29 0   // Details29 about29 the lsr29 (line status register)
`define FAST_TEST29   1           // 64/1024 packets29 are sent29







