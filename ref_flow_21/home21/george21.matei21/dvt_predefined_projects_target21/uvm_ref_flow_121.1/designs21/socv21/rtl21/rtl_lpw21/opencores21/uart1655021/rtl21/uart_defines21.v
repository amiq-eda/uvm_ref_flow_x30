//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines21.v                                              ////
////                                                              ////
////                                                              ////
////  This21 file is part of the "UART21 16550 compatible21" project21    ////
////  http21://www21.opencores21.org21/cores21/uart1655021/                   ////
////                                                              ////
////  Documentation21 related21 to this project21:                      ////
////  - http21://www21.opencores21.org21/cores21/uart1655021/                 ////
////                                                              ////
////  Projects21 compatibility21:                                     ////
////  - WISHBONE21                                                  ////
////  RS23221 Protocol21                                              ////
////  16550D uart21 (mostly21 supported)                              ////
////                                                              ////
////  Overview21 (main21 Features21):                                   ////
////  Defines21 of the Core21                                         ////
////                                                              ////
////  Known21 problems21 (limits21):                                    ////
////  None21                                                        ////
////                                                              ////
////  To21 Do21:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author21(s):                                                  ////
////      - gorban21@opencores21.org21                                  ////
////      - Jacob21 Gorban21                                          ////
////      - Igor21 Mohor21 (igorm21@opencores21.org21)                      ////
////                                                              ////
////  Created21:        2001/05/12                                  ////
////  Last21 Updated21:   2001/05/17                                  ////
////                  (See log21 for the revision21 history21)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2000, 2001 Authors21                             ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS21 Revision21 History21
//
// $Log: not supported by cvs2svn21 $
// Revision21 1.13  2003/06/11 16:37:47  gorban21
// This21 fixes21 errors21 in some21 cases21 when data is being read and put to the FIFO at the same time. Patch21 is submitted21 by Scott21 Furman21. Update is very21 recommended21.
//
// Revision21 1.12  2002/07/22 23:02:23  gorban21
// Bug21 Fixes21:
//  * Possible21 loss of sync and bad21 reception21 of stop bit on slow21 baud21 rates21 fixed21.
//   Problem21 reported21 by Kenny21.Tung21.
//  * Bad (or lack21 of ) loopback21 handling21 fixed21. Reported21 by Cherry21 Withers21.
//
// Improvements21:
//  * Made21 FIFO's as general21 inferrable21 memory where possible21.
//  So21 on FPGA21 they should be inferred21 as RAM21 (Distributed21 RAM21 on Xilinx21).
//  This21 saves21 about21 1/3 of the Slice21 count and reduces21 P&R and synthesis21 times.
//
//  * Added21 optional21 baudrate21 output (baud_o21).
//  This21 is identical21 to BAUDOUT21* signal21 on 16550 chip21.
//  It outputs21 16xbit_clock_rate - the divided21 clock21.
//  It's disabled by default. Define21 UART_HAS_BAUDRATE_OUTPUT21 to use.
//
// Revision21 1.10  2001/12/11 08:55:40  mohor21
// Scratch21 register define added.
//
// Revision21 1.9  2001/12/03 21:44:29  gorban21
// Updated21 specification21 documentation.
// Added21 full 32-bit data bus interface, now as default.
// Address is 5-bit wide21 in 32-bit data bus mode.
// Added21 wb_sel_i21 input to the core21. It's used in the 32-bit mode.
// Added21 debug21 interface with two21 32-bit read-only registers in 32-bit mode.
// Bits21 5 and 6 of LSR21 are now only cleared21 on TX21 FIFO write.
// My21 small test bench21 is modified to work21 with 32-bit mode.
//
// Revision21 1.8  2001/11/26 21:38:54  gorban21
// Lots21 of fixes21:
// Break21 condition wasn21't handled21 correctly at all.
// LSR21 bits could lose21 their21 values.
// LSR21 value after reset was wrong21.
// Timing21 of THRE21 interrupt21 signal21 corrected21.
// LSR21 bit 0 timing21 corrected21.
//
// Revision21 1.7  2001/08/24 21:01:12  mohor21
// Things21 connected21 to parity21 changed.
// Clock21 devider21 changed.
//
// Revision21 1.6  2001/08/23 16:05:05  mohor21
// Stop bit bug21 fixed21.
// Parity21 bug21 fixed21.
// WISHBONE21 read cycle bug21 fixed21,
// OE21 indicator21 (Overrun21 Error) bug21 fixed21.
// PE21 indicator21 (Parity21 Error) bug21 fixed21.
// Register read bug21 fixed21.
//
// Revision21 1.5  2001/05/31 20:08:01  gorban21
// FIFO changes21 and other corrections21.
//
// Revision21 1.4  2001/05/21 19:12:02  gorban21
// Corrected21 some21 Linter21 messages21.
//
// Revision21 1.3  2001/05/17 18:34:18  gorban21
// First21 'stable' release. Should21 be sythesizable21 now. Also21 added new header.
//
// Revision21 1.0  2001-05-17 21:27:11+02  jacob21
// Initial21 revision21
//
//

// remove comments21 to restore21 to use the new version21 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i21 signal21 is used to put data in correct21 place21
// also, in 8-bit version21 there21'll be no debugging21 features21 included21
// CAUTION21: doesn't work21 with current version21 of OR120021
//`define DATA_BUS_WIDTH_821

`ifdef DATA_BUS_WIDTH_821
 `define UART_ADDR_WIDTH21 3
 `define UART_DATA_WIDTH21 8
`else
 `define UART_ADDR_WIDTH21 5
 `define UART_DATA_WIDTH21 32
`endif

// Uncomment21 this if you want21 your21 UART21 to have
// 16xBaudrate output port.
// If21 defined, the enable signal21 will be used to drive21 baudrate_o21 signal21
// It's frequency21 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT21

// Register addresses21
`define UART_REG_RB21	`UART_ADDR_WIDTH21'd0	// receiver21 buffer21
`define UART_REG_TR21  `UART_ADDR_WIDTH21'd0	// transmitter21
`define UART_REG_IE21	`UART_ADDR_WIDTH21'd1	// Interrupt21 enable
`define UART_REG_II21  `UART_ADDR_WIDTH21'd2	// Interrupt21 identification21
`define UART_REG_FC21  `UART_ADDR_WIDTH21'd2	// FIFO control21
`define UART_REG_LC21	`UART_ADDR_WIDTH21'd3	// Line21 Control21
`define UART_REG_MC21	`UART_ADDR_WIDTH21'd4	// Modem21 control21
`define UART_REG_LS21  `UART_ADDR_WIDTH21'd5	// Line21 status
`define UART_REG_MS21  `UART_ADDR_WIDTH21'd6	// Modem21 status
`define UART_REG_SR21  `UART_ADDR_WIDTH21'd7	// Scratch21 register
`define UART_REG_DL121	`UART_ADDR_WIDTH21'd0	// Divisor21 latch21 bytes (1-2)
`define UART_REG_DL221	`UART_ADDR_WIDTH21'd1

// Interrupt21 Enable21 register bits
`define UART_IE_RDA21	0	// Received21 Data available interrupt21
`define UART_IE_THRE21	1	// Transmitter21 Holding21 Register empty21 interrupt21
`define UART_IE_RLS21	2	// Receiver21 Line21 Status Interrupt21
`define UART_IE_MS21	3	// Modem21 Status Interrupt21

// Interrupt21 Identification21 register bits
`define UART_II_IP21	0	// Interrupt21 pending when 0
`define UART_II_II21	3:1	// Interrupt21 identification21

// Interrupt21 identification21 values for bits 3:1
`define UART_II_RLS21	3'b011	// Receiver21 Line21 Status
`define UART_II_RDA21	3'b010	// Receiver21 Data available
`define UART_II_TI21	3'b110	// Timeout21 Indication21
`define UART_II_THRE21	3'b001	// Transmitter21 Holding21 Register empty21
`define UART_II_MS21	3'b000	// Modem21 Status

// FIFO Control21 Register bits
`define UART_FC_TL21	1:0	// Trigger21 level

// FIFO trigger level values
`define UART_FC_121		2'b00
`define UART_FC_421		2'b01
`define UART_FC_821		2'b10
`define UART_FC_1421	2'b11

// Line21 Control21 register bits
`define UART_LC_BITS21	1:0	// bits in character21
`define UART_LC_SB21	2	// stop bits
`define UART_LC_PE21	3	// parity21 enable
`define UART_LC_EP21	4	// even21 parity21
`define UART_LC_SP21	5	// stick21 parity21
`define UART_LC_BC21	6	// Break21 control21
`define UART_LC_DL21	7	// Divisor21 Latch21 access bit

// Modem21 Control21 register bits
`define UART_MC_DTR21	0
`define UART_MC_RTS21	1
`define UART_MC_OUT121	2
`define UART_MC_OUT221	3
`define UART_MC_LB21	4	// Loopback21 mode

// Line21 Status Register bits
`define UART_LS_DR21	0	// Data ready
`define UART_LS_OE21	1	// Overrun21 Error
`define UART_LS_PE21	2	// Parity21 Error
`define UART_LS_FE21	3	// Framing21 Error
`define UART_LS_BI21	4	// Break21 interrupt21
`define UART_LS_TFE21	5	// Transmit21 FIFO is empty21
`define UART_LS_TE21	6	// Transmitter21 Empty21 indicator21
`define UART_LS_EI21	7	// Error indicator21

// Modem21 Status Register bits
`define UART_MS_DCTS21	0	// Delta21 signals21
`define UART_MS_DDSR21	1
`define UART_MS_TERI21	2
`define UART_MS_DDCD21	3
`define UART_MS_CCTS21	4	// Complement21 signals21
`define UART_MS_CDSR21	5
`define UART_MS_CRI21	6
`define UART_MS_CDCD21	7

// FIFO parameter defines21

`define UART_FIFO_WIDTH21	8
`define UART_FIFO_DEPTH21	16
`define UART_FIFO_POINTER_W21	4
`define UART_FIFO_COUNTER_W21	5
// receiver21 fifo has width 11 because it has break, parity21 and framing21 error bits
`define UART_FIFO_REC_WIDTH21  11


`define VERBOSE_WB21  0           // All activity21 on the WISHBONE21 is recorded21
`define VERBOSE_LINE_STATUS21 0   // Details21 about21 the lsr21 (line status register)
`define FAST_TEST21   1           // 64/1024 packets21 are sent21







