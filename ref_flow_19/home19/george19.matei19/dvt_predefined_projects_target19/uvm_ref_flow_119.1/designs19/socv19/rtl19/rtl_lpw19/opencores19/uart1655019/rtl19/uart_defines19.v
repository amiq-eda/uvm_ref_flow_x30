//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines19.v                                              ////
////                                                              ////
////                                                              ////
////  This19 file is part of the "UART19 16550 compatible19" project19    ////
////  http19://www19.opencores19.org19/cores19/uart1655019/                   ////
////                                                              ////
////  Documentation19 related19 to this project19:                      ////
////  - http19://www19.opencores19.org19/cores19/uart1655019/                 ////
////                                                              ////
////  Projects19 compatibility19:                                     ////
////  - WISHBONE19                                                  ////
////  RS23219 Protocol19                                              ////
////  16550D uart19 (mostly19 supported)                              ////
////                                                              ////
////  Overview19 (main19 Features19):                                   ////
////  Defines19 of the Core19                                         ////
////                                                              ////
////  Known19 problems19 (limits19):                                    ////
////  None19                                                        ////
////                                                              ////
////  To19 Do19:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author19(s):                                                  ////
////      - gorban19@opencores19.org19                                  ////
////      - Jacob19 Gorban19                                          ////
////      - Igor19 Mohor19 (igorm19@opencores19.org19)                      ////
////                                                              ////
////  Created19:        2001/05/12                                  ////
////  Last19 Updated19:   2001/05/17                                  ////
////                  (See log19 for the revision19 history19)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright19 (C) 2000, 2001 Authors19                             ////
////                                                              ////
//// This19 source19 file may be used and distributed19 without         ////
//// restriction19 provided that this copyright19 statement19 is not    ////
//// removed from the file and that any derivative19 work19 contains19  ////
//// the original copyright19 notice19 and the associated disclaimer19. ////
////                                                              ////
//// This19 source19 file is free software19; you can redistribute19 it   ////
//// and/or modify it under the terms19 of the GNU19 Lesser19 General19   ////
//// Public19 License19 as published19 by the Free19 Software19 Foundation19; ////
//// either19 version19 2.1 of the License19, or (at your19 option) any   ////
//// later19 version19.                                               ////
////                                                              ////
//// This19 source19 is distributed19 in the hope19 that it will be       ////
//// useful19, but WITHOUT19 ANY19 WARRANTY19; without even19 the implied19   ////
//// warranty19 of MERCHANTABILITY19 or FITNESS19 FOR19 A PARTICULAR19      ////
//// PURPOSE19.  See the GNU19 Lesser19 General19 Public19 License19 for more ////
//// details19.                                                     ////
////                                                              ////
//// You should have received19 a copy of the GNU19 Lesser19 General19    ////
//// Public19 License19 along19 with this source19; if not, download19 it   ////
//// from http19://www19.opencores19.org19/lgpl19.shtml19                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS19 Revision19 History19
//
// $Log: not supported by cvs2svn19 $
// Revision19 1.13  2003/06/11 16:37:47  gorban19
// This19 fixes19 errors19 in some19 cases19 when data is being read and put to the FIFO at the same time. Patch19 is submitted19 by Scott19 Furman19. Update is very19 recommended19.
//
// Revision19 1.12  2002/07/22 23:02:23  gorban19
// Bug19 Fixes19:
//  * Possible19 loss of sync and bad19 reception19 of stop bit on slow19 baud19 rates19 fixed19.
//   Problem19 reported19 by Kenny19.Tung19.
//  * Bad (or lack19 of ) loopback19 handling19 fixed19. Reported19 by Cherry19 Withers19.
//
// Improvements19:
//  * Made19 FIFO's as general19 inferrable19 memory where possible19.
//  So19 on FPGA19 they should be inferred19 as RAM19 (Distributed19 RAM19 on Xilinx19).
//  This19 saves19 about19 1/3 of the Slice19 count and reduces19 P&R and synthesis19 times.
//
//  * Added19 optional19 baudrate19 output (baud_o19).
//  This19 is identical19 to BAUDOUT19* signal19 on 16550 chip19.
//  It outputs19 16xbit_clock_rate - the divided19 clock19.
//  It's disabled by default. Define19 UART_HAS_BAUDRATE_OUTPUT19 to use.
//
// Revision19 1.10  2001/12/11 08:55:40  mohor19
// Scratch19 register define added.
//
// Revision19 1.9  2001/12/03 21:44:29  gorban19
// Updated19 specification19 documentation.
// Added19 full 32-bit data bus interface, now as default.
// Address is 5-bit wide19 in 32-bit data bus mode.
// Added19 wb_sel_i19 input to the core19. It's used in the 32-bit mode.
// Added19 debug19 interface with two19 32-bit read-only registers in 32-bit mode.
// Bits19 5 and 6 of LSR19 are now only cleared19 on TX19 FIFO write.
// My19 small test bench19 is modified to work19 with 32-bit mode.
//
// Revision19 1.8  2001/11/26 21:38:54  gorban19
// Lots19 of fixes19:
// Break19 condition wasn19't handled19 correctly at all.
// LSR19 bits could lose19 their19 values.
// LSR19 value after reset was wrong19.
// Timing19 of THRE19 interrupt19 signal19 corrected19.
// LSR19 bit 0 timing19 corrected19.
//
// Revision19 1.7  2001/08/24 21:01:12  mohor19
// Things19 connected19 to parity19 changed.
// Clock19 devider19 changed.
//
// Revision19 1.6  2001/08/23 16:05:05  mohor19
// Stop bit bug19 fixed19.
// Parity19 bug19 fixed19.
// WISHBONE19 read cycle bug19 fixed19,
// OE19 indicator19 (Overrun19 Error) bug19 fixed19.
// PE19 indicator19 (Parity19 Error) bug19 fixed19.
// Register read bug19 fixed19.
//
// Revision19 1.5  2001/05/31 20:08:01  gorban19
// FIFO changes19 and other corrections19.
//
// Revision19 1.4  2001/05/21 19:12:02  gorban19
// Corrected19 some19 Linter19 messages19.
//
// Revision19 1.3  2001/05/17 18:34:18  gorban19
// First19 'stable' release. Should19 be sythesizable19 now. Also19 added new header.
//
// Revision19 1.0  2001-05-17 21:27:11+02  jacob19
// Initial19 revision19
//
//

// remove comments19 to restore19 to use the new version19 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i19 signal19 is used to put data in correct19 place19
// also, in 8-bit version19 there19'll be no debugging19 features19 included19
// CAUTION19: doesn't work19 with current version19 of OR120019
//`define DATA_BUS_WIDTH_819

`ifdef DATA_BUS_WIDTH_819
 `define UART_ADDR_WIDTH19 3
 `define UART_DATA_WIDTH19 8
`else
 `define UART_ADDR_WIDTH19 5
 `define UART_DATA_WIDTH19 32
`endif

// Uncomment19 this if you want19 your19 UART19 to have
// 16xBaudrate output port.
// If19 defined, the enable signal19 will be used to drive19 baudrate_o19 signal19
// It's frequency19 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT19

// Register addresses19
`define UART_REG_RB19	`UART_ADDR_WIDTH19'd0	// receiver19 buffer19
`define UART_REG_TR19  `UART_ADDR_WIDTH19'd0	// transmitter19
`define UART_REG_IE19	`UART_ADDR_WIDTH19'd1	// Interrupt19 enable
`define UART_REG_II19  `UART_ADDR_WIDTH19'd2	// Interrupt19 identification19
`define UART_REG_FC19  `UART_ADDR_WIDTH19'd2	// FIFO control19
`define UART_REG_LC19	`UART_ADDR_WIDTH19'd3	// Line19 Control19
`define UART_REG_MC19	`UART_ADDR_WIDTH19'd4	// Modem19 control19
`define UART_REG_LS19  `UART_ADDR_WIDTH19'd5	// Line19 status
`define UART_REG_MS19  `UART_ADDR_WIDTH19'd6	// Modem19 status
`define UART_REG_SR19  `UART_ADDR_WIDTH19'd7	// Scratch19 register
`define UART_REG_DL119	`UART_ADDR_WIDTH19'd0	// Divisor19 latch19 bytes (1-2)
`define UART_REG_DL219	`UART_ADDR_WIDTH19'd1

// Interrupt19 Enable19 register bits
`define UART_IE_RDA19	0	// Received19 Data available interrupt19
`define UART_IE_THRE19	1	// Transmitter19 Holding19 Register empty19 interrupt19
`define UART_IE_RLS19	2	// Receiver19 Line19 Status Interrupt19
`define UART_IE_MS19	3	// Modem19 Status Interrupt19

// Interrupt19 Identification19 register bits
`define UART_II_IP19	0	// Interrupt19 pending when 0
`define UART_II_II19	3:1	// Interrupt19 identification19

// Interrupt19 identification19 values for bits 3:1
`define UART_II_RLS19	3'b011	// Receiver19 Line19 Status
`define UART_II_RDA19	3'b010	// Receiver19 Data available
`define UART_II_TI19	3'b110	// Timeout19 Indication19
`define UART_II_THRE19	3'b001	// Transmitter19 Holding19 Register empty19
`define UART_II_MS19	3'b000	// Modem19 Status

// FIFO Control19 Register bits
`define UART_FC_TL19	1:0	// Trigger19 level

// FIFO trigger level values
`define UART_FC_119		2'b00
`define UART_FC_419		2'b01
`define UART_FC_819		2'b10
`define UART_FC_1419	2'b11

// Line19 Control19 register bits
`define UART_LC_BITS19	1:0	// bits in character19
`define UART_LC_SB19	2	// stop bits
`define UART_LC_PE19	3	// parity19 enable
`define UART_LC_EP19	4	// even19 parity19
`define UART_LC_SP19	5	// stick19 parity19
`define UART_LC_BC19	6	// Break19 control19
`define UART_LC_DL19	7	// Divisor19 Latch19 access bit

// Modem19 Control19 register bits
`define UART_MC_DTR19	0
`define UART_MC_RTS19	1
`define UART_MC_OUT119	2
`define UART_MC_OUT219	3
`define UART_MC_LB19	4	// Loopback19 mode

// Line19 Status Register bits
`define UART_LS_DR19	0	// Data ready
`define UART_LS_OE19	1	// Overrun19 Error
`define UART_LS_PE19	2	// Parity19 Error
`define UART_LS_FE19	3	// Framing19 Error
`define UART_LS_BI19	4	// Break19 interrupt19
`define UART_LS_TFE19	5	// Transmit19 FIFO is empty19
`define UART_LS_TE19	6	// Transmitter19 Empty19 indicator19
`define UART_LS_EI19	7	// Error indicator19

// Modem19 Status Register bits
`define UART_MS_DCTS19	0	// Delta19 signals19
`define UART_MS_DDSR19	1
`define UART_MS_TERI19	2
`define UART_MS_DDCD19	3
`define UART_MS_CCTS19	4	// Complement19 signals19
`define UART_MS_CDSR19	5
`define UART_MS_CRI19	6
`define UART_MS_CDCD19	7

// FIFO parameter defines19

`define UART_FIFO_WIDTH19	8
`define UART_FIFO_DEPTH19	16
`define UART_FIFO_POINTER_W19	4
`define UART_FIFO_COUNTER_W19	5
// receiver19 fifo has width 11 because it has break, parity19 and framing19 error bits
`define UART_FIFO_REC_WIDTH19  11


`define VERBOSE_WB19  0           // All activity19 on the WISHBONE19 is recorded19
`define VERBOSE_LINE_STATUS19 0   // Details19 about19 the lsr19 (line status register)
`define FAST_TEST19   1           // 64/1024 packets19 are sent19







