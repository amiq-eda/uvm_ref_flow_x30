//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines24.v                                              ////
////                                                              ////
////                                                              ////
////  This24 file is part of the "UART24 16550 compatible24" project24    ////
////  http24://www24.opencores24.org24/cores24/uart1655024/                   ////
////                                                              ////
////  Documentation24 related24 to this project24:                      ////
////  - http24://www24.opencores24.org24/cores24/uart1655024/                 ////
////                                                              ////
////  Projects24 compatibility24:                                     ////
////  - WISHBONE24                                                  ////
////  RS23224 Protocol24                                              ////
////  16550D uart24 (mostly24 supported)                              ////
////                                                              ////
////  Overview24 (main24 Features24):                                   ////
////  Defines24 of the Core24                                         ////
////                                                              ////
////  Known24 problems24 (limits24):                                    ////
////  None24                                                        ////
////                                                              ////
////  To24 Do24:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author24(s):                                                  ////
////      - gorban24@opencores24.org24                                  ////
////      - Jacob24 Gorban24                                          ////
////      - Igor24 Mohor24 (igorm24@opencores24.org24)                      ////
////                                                              ////
////  Created24:        2001/05/12                                  ////
////  Last24 Updated24:   2001/05/17                                  ////
////                  (See log24 for the revision24 history24)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright24 (C) 2000, 2001 Authors24                             ////
////                                                              ////
//// This24 source24 file may be used and distributed24 without         ////
//// restriction24 provided that this copyright24 statement24 is not    ////
//// removed from the file and that any derivative24 work24 contains24  ////
//// the original copyright24 notice24 and the associated disclaimer24. ////
////                                                              ////
//// This24 source24 file is free software24; you can redistribute24 it   ////
//// and/or modify it under the terms24 of the GNU24 Lesser24 General24   ////
//// Public24 License24 as published24 by the Free24 Software24 Foundation24; ////
//// either24 version24 2.1 of the License24, or (at your24 option) any   ////
//// later24 version24.                                               ////
////                                                              ////
//// This24 source24 is distributed24 in the hope24 that it will be       ////
//// useful24, but WITHOUT24 ANY24 WARRANTY24; without even24 the implied24   ////
//// warranty24 of MERCHANTABILITY24 or FITNESS24 FOR24 A PARTICULAR24      ////
//// PURPOSE24.  See the GNU24 Lesser24 General24 Public24 License24 for more ////
//// details24.                                                     ////
////                                                              ////
//// You should have received24 a copy of the GNU24 Lesser24 General24    ////
//// Public24 License24 along24 with this source24; if not, download24 it   ////
//// from http24://www24.opencores24.org24/lgpl24.shtml24                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS24 Revision24 History24
//
// $Log: not supported by cvs2svn24 $
// Revision24 1.13  2003/06/11 16:37:47  gorban24
// This24 fixes24 errors24 in some24 cases24 when data is being read and put to the FIFO at the same time. Patch24 is submitted24 by Scott24 Furman24. Update is very24 recommended24.
//
// Revision24 1.12  2002/07/22 23:02:23  gorban24
// Bug24 Fixes24:
//  * Possible24 loss of sync and bad24 reception24 of stop bit on slow24 baud24 rates24 fixed24.
//   Problem24 reported24 by Kenny24.Tung24.
//  * Bad (or lack24 of ) loopback24 handling24 fixed24. Reported24 by Cherry24 Withers24.
//
// Improvements24:
//  * Made24 FIFO's as general24 inferrable24 memory where possible24.
//  So24 on FPGA24 they should be inferred24 as RAM24 (Distributed24 RAM24 on Xilinx24).
//  This24 saves24 about24 1/3 of the Slice24 count and reduces24 P&R and synthesis24 times.
//
//  * Added24 optional24 baudrate24 output (baud_o24).
//  This24 is identical24 to BAUDOUT24* signal24 on 16550 chip24.
//  It outputs24 16xbit_clock_rate - the divided24 clock24.
//  It's disabled by default. Define24 UART_HAS_BAUDRATE_OUTPUT24 to use.
//
// Revision24 1.10  2001/12/11 08:55:40  mohor24
// Scratch24 register define added.
//
// Revision24 1.9  2001/12/03 21:44:29  gorban24
// Updated24 specification24 documentation.
// Added24 full 32-bit data bus interface, now as default.
// Address is 5-bit wide24 in 32-bit data bus mode.
// Added24 wb_sel_i24 input to the core24. It's used in the 32-bit mode.
// Added24 debug24 interface with two24 32-bit read-only registers in 32-bit mode.
// Bits24 5 and 6 of LSR24 are now only cleared24 on TX24 FIFO write.
// My24 small test bench24 is modified to work24 with 32-bit mode.
//
// Revision24 1.8  2001/11/26 21:38:54  gorban24
// Lots24 of fixes24:
// Break24 condition wasn24't handled24 correctly at all.
// LSR24 bits could lose24 their24 values.
// LSR24 value after reset was wrong24.
// Timing24 of THRE24 interrupt24 signal24 corrected24.
// LSR24 bit 0 timing24 corrected24.
//
// Revision24 1.7  2001/08/24 21:01:12  mohor24
// Things24 connected24 to parity24 changed.
// Clock24 devider24 changed.
//
// Revision24 1.6  2001/08/23 16:05:05  mohor24
// Stop bit bug24 fixed24.
// Parity24 bug24 fixed24.
// WISHBONE24 read cycle bug24 fixed24,
// OE24 indicator24 (Overrun24 Error) bug24 fixed24.
// PE24 indicator24 (Parity24 Error) bug24 fixed24.
// Register read bug24 fixed24.
//
// Revision24 1.5  2001/05/31 20:08:01  gorban24
// FIFO changes24 and other corrections24.
//
// Revision24 1.4  2001/05/21 19:12:02  gorban24
// Corrected24 some24 Linter24 messages24.
//
// Revision24 1.3  2001/05/17 18:34:18  gorban24
// First24 'stable' release. Should24 be sythesizable24 now. Also24 added new header.
//
// Revision24 1.0  2001-05-17 21:27:11+02  jacob24
// Initial24 revision24
//
//

// remove comments24 to restore24 to use the new version24 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i24 signal24 is used to put data in correct24 place24
// also, in 8-bit version24 there24'll be no debugging24 features24 included24
// CAUTION24: doesn't work24 with current version24 of OR120024
//`define DATA_BUS_WIDTH_824

`ifdef DATA_BUS_WIDTH_824
 `define UART_ADDR_WIDTH24 3
 `define UART_DATA_WIDTH24 8
`else
 `define UART_ADDR_WIDTH24 5
 `define UART_DATA_WIDTH24 32
`endif

// Uncomment24 this if you want24 your24 UART24 to have
// 16xBaudrate output port.
// If24 defined, the enable signal24 will be used to drive24 baudrate_o24 signal24
// It's frequency24 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT24

// Register addresses24
`define UART_REG_RB24	`UART_ADDR_WIDTH24'd0	// receiver24 buffer24
`define UART_REG_TR24  `UART_ADDR_WIDTH24'd0	// transmitter24
`define UART_REG_IE24	`UART_ADDR_WIDTH24'd1	// Interrupt24 enable
`define UART_REG_II24  `UART_ADDR_WIDTH24'd2	// Interrupt24 identification24
`define UART_REG_FC24  `UART_ADDR_WIDTH24'd2	// FIFO control24
`define UART_REG_LC24	`UART_ADDR_WIDTH24'd3	// Line24 Control24
`define UART_REG_MC24	`UART_ADDR_WIDTH24'd4	// Modem24 control24
`define UART_REG_LS24  `UART_ADDR_WIDTH24'd5	// Line24 status
`define UART_REG_MS24  `UART_ADDR_WIDTH24'd6	// Modem24 status
`define UART_REG_SR24  `UART_ADDR_WIDTH24'd7	// Scratch24 register
`define UART_REG_DL124	`UART_ADDR_WIDTH24'd0	// Divisor24 latch24 bytes (1-2)
`define UART_REG_DL224	`UART_ADDR_WIDTH24'd1

// Interrupt24 Enable24 register bits
`define UART_IE_RDA24	0	// Received24 Data available interrupt24
`define UART_IE_THRE24	1	// Transmitter24 Holding24 Register empty24 interrupt24
`define UART_IE_RLS24	2	// Receiver24 Line24 Status Interrupt24
`define UART_IE_MS24	3	// Modem24 Status Interrupt24

// Interrupt24 Identification24 register bits
`define UART_II_IP24	0	// Interrupt24 pending when 0
`define UART_II_II24	3:1	// Interrupt24 identification24

// Interrupt24 identification24 values for bits 3:1
`define UART_II_RLS24	3'b011	// Receiver24 Line24 Status
`define UART_II_RDA24	3'b010	// Receiver24 Data available
`define UART_II_TI24	3'b110	// Timeout24 Indication24
`define UART_II_THRE24	3'b001	// Transmitter24 Holding24 Register empty24
`define UART_II_MS24	3'b000	// Modem24 Status

// FIFO Control24 Register bits
`define UART_FC_TL24	1:0	// Trigger24 level

// FIFO trigger level values
`define UART_FC_124		2'b00
`define UART_FC_424		2'b01
`define UART_FC_824		2'b10
`define UART_FC_1424	2'b11

// Line24 Control24 register bits
`define UART_LC_BITS24	1:0	// bits in character24
`define UART_LC_SB24	2	// stop bits
`define UART_LC_PE24	3	// parity24 enable
`define UART_LC_EP24	4	// even24 parity24
`define UART_LC_SP24	5	// stick24 parity24
`define UART_LC_BC24	6	// Break24 control24
`define UART_LC_DL24	7	// Divisor24 Latch24 access bit

// Modem24 Control24 register bits
`define UART_MC_DTR24	0
`define UART_MC_RTS24	1
`define UART_MC_OUT124	2
`define UART_MC_OUT224	3
`define UART_MC_LB24	4	// Loopback24 mode

// Line24 Status Register bits
`define UART_LS_DR24	0	// Data ready
`define UART_LS_OE24	1	// Overrun24 Error
`define UART_LS_PE24	2	// Parity24 Error
`define UART_LS_FE24	3	// Framing24 Error
`define UART_LS_BI24	4	// Break24 interrupt24
`define UART_LS_TFE24	5	// Transmit24 FIFO is empty24
`define UART_LS_TE24	6	// Transmitter24 Empty24 indicator24
`define UART_LS_EI24	7	// Error indicator24

// Modem24 Status Register bits
`define UART_MS_DCTS24	0	// Delta24 signals24
`define UART_MS_DDSR24	1
`define UART_MS_TERI24	2
`define UART_MS_DDCD24	3
`define UART_MS_CCTS24	4	// Complement24 signals24
`define UART_MS_CDSR24	5
`define UART_MS_CRI24	6
`define UART_MS_CDCD24	7

// FIFO parameter defines24

`define UART_FIFO_WIDTH24	8
`define UART_FIFO_DEPTH24	16
`define UART_FIFO_POINTER_W24	4
`define UART_FIFO_COUNTER_W24	5
// receiver24 fifo has width 11 because it has break, parity24 and framing24 error bits
`define UART_FIFO_REC_WIDTH24  11


`define VERBOSE_WB24  0           // All activity24 on the WISHBONE24 is recorded24
`define VERBOSE_LINE_STATUS24 0   // Details24 about24 the lsr24 (line status register)
`define FAST_TEST24   1           // 64/1024 packets24 are sent24







