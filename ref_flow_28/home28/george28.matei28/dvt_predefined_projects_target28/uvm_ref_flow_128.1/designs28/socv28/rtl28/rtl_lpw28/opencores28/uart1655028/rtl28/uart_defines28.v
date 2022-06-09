//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines28.v                                              ////
////                                                              ////
////                                                              ////
////  This28 file is part of the "UART28 16550 compatible28" project28    ////
////  http28://www28.opencores28.org28/cores28/uart1655028/                   ////
////                                                              ////
////  Documentation28 related28 to this project28:                      ////
////  - http28://www28.opencores28.org28/cores28/uart1655028/                 ////
////                                                              ////
////  Projects28 compatibility28:                                     ////
////  - WISHBONE28                                                  ////
////  RS23228 Protocol28                                              ////
////  16550D uart28 (mostly28 supported)                              ////
////                                                              ////
////  Overview28 (main28 Features28):                                   ////
////  Defines28 of the Core28                                         ////
////                                                              ////
////  Known28 problems28 (limits28):                                    ////
////  None28                                                        ////
////                                                              ////
////  To28 Do28:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author28(s):                                                  ////
////      - gorban28@opencores28.org28                                  ////
////      - Jacob28 Gorban28                                          ////
////      - Igor28 Mohor28 (igorm28@opencores28.org28)                      ////
////                                                              ////
////  Created28:        2001/05/12                                  ////
////  Last28 Updated28:   2001/05/17                                  ////
////                  (See log28 for the revision28 history28)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright28 (C) 2000, 2001 Authors28                             ////
////                                                              ////
//// This28 source28 file may be used and distributed28 without         ////
//// restriction28 provided that this copyright28 statement28 is not    ////
//// removed from the file and that any derivative28 work28 contains28  ////
//// the original copyright28 notice28 and the associated disclaimer28. ////
////                                                              ////
//// This28 source28 file is free software28; you can redistribute28 it   ////
//// and/or modify it under the terms28 of the GNU28 Lesser28 General28   ////
//// Public28 License28 as published28 by the Free28 Software28 Foundation28; ////
//// either28 version28 2.1 of the License28, or (at your28 option) any   ////
//// later28 version28.                                               ////
////                                                              ////
//// This28 source28 is distributed28 in the hope28 that it will be       ////
//// useful28, but WITHOUT28 ANY28 WARRANTY28; without even28 the implied28   ////
//// warranty28 of MERCHANTABILITY28 or FITNESS28 FOR28 A PARTICULAR28      ////
//// PURPOSE28.  See the GNU28 Lesser28 General28 Public28 License28 for more ////
//// details28.                                                     ////
////                                                              ////
//// You should have received28 a copy of the GNU28 Lesser28 General28    ////
//// Public28 License28 along28 with this source28; if not, download28 it   ////
//// from http28://www28.opencores28.org28/lgpl28.shtml28                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS28 Revision28 History28
//
// $Log: not supported by cvs2svn28 $
// Revision28 1.13  2003/06/11 16:37:47  gorban28
// This28 fixes28 errors28 in some28 cases28 when data is being read and put to the FIFO at the same time. Patch28 is submitted28 by Scott28 Furman28. Update is very28 recommended28.
//
// Revision28 1.12  2002/07/22 23:02:23  gorban28
// Bug28 Fixes28:
//  * Possible28 loss of sync and bad28 reception28 of stop bit on slow28 baud28 rates28 fixed28.
//   Problem28 reported28 by Kenny28.Tung28.
//  * Bad (or lack28 of ) loopback28 handling28 fixed28. Reported28 by Cherry28 Withers28.
//
// Improvements28:
//  * Made28 FIFO's as general28 inferrable28 memory where possible28.
//  So28 on FPGA28 they should be inferred28 as RAM28 (Distributed28 RAM28 on Xilinx28).
//  This28 saves28 about28 1/3 of the Slice28 count and reduces28 P&R and synthesis28 times.
//
//  * Added28 optional28 baudrate28 output (baud_o28).
//  This28 is identical28 to BAUDOUT28* signal28 on 16550 chip28.
//  It outputs28 16xbit_clock_rate - the divided28 clock28.
//  It's disabled by default. Define28 UART_HAS_BAUDRATE_OUTPUT28 to use.
//
// Revision28 1.10  2001/12/11 08:55:40  mohor28
// Scratch28 register define added.
//
// Revision28 1.9  2001/12/03 21:44:29  gorban28
// Updated28 specification28 documentation.
// Added28 full 32-bit data bus interface, now as default.
// Address is 5-bit wide28 in 32-bit data bus mode.
// Added28 wb_sel_i28 input to the core28. It's used in the 32-bit mode.
// Added28 debug28 interface with two28 32-bit read-only registers in 32-bit mode.
// Bits28 5 and 6 of LSR28 are now only cleared28 on TX28 FIFO write.
// My28 small test bench28 is modified to work28 with 32-bit mode.
//
// Revision28 1.8  2001/11/26 21:38:54  gorban28
// Lots28 of fixes28:
// Break28 condition wasn28't handled28 correctly at all.
// LSR28 bits could lose28 their28 values.
// LSR28 value after reset was wrong28.
// Timing28 of THRE28 interrupt28 signal28 corrected28.
// LSR28 bit 0 timing28 corrected28.
//
// Revision28 1.7  2001/08/24 21:01:12  mohor28
// Things28 connected28 to parity28 changed.
// Clock28 devider28 changed.
//
// Revision28 1.6  2001/08/23 16:05:05  mohor28
// Stop bit bug28 fixed28.
// Parity28 bug28 fixed28.
// WISHBONE28 read cycle bug28 fixed28,
// OE28 indicator28 (Overrun28 Error) bug28 fixed28.
// PE28 indicator28 (Parity28 Error) bug28 fixed28.
// Register read bug28 fixed28.
//
// Revision28 1.5  2001/05/31 20:08:01  gorban28
// FIFO changes28 and other corrections28.
//
// Revision28 1.4  2001/05/21 19:12:02  gorban28
// Corrected28 some28 Linter28 messages28.
//
// Revision28 1.3  2001/05/17 18:34:18  gorban28
// First28 'stable' release. Should28 be sythesizable28 now. Also28 added new header.
//
// Revision28 1.0  2001-05-17 21:27:11+02  jacob28
// Initial28 revision28
//
//

// remove comments28 to restore28 to use the new version28 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i28 signal28 is used to put data in correct28 place28
// also, in 8-bit version28 there28'll be no debugging28 features28 included28
// CAUTION28: doesn't work28 with current version28 of OR120028
//`define DATA_BUS_WIDTH_828

`ifdef DATA_BUS_WIDTH_828
 `define UART_ADDR_WIDTH28 3
 `define UART_DATA_WIDTH28 8
`else
 `define UART_ADDR_WIDTH28 5
 `define UART_DATA_WIDTH28 32
`endif

// Uncomment28 this if you want28 your28 UART28 to have
// 16xBaudrate output port.
// If28 defined, the enable signal28 will be used to drive28 baudrate_o28 signal28
// It's frequency28 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT28

// Register addresses28
`define UART_REG_RB28	`UART_ADDR_WIDTH28'd0	// receiver28 buffer28
`define UART_REG_TR28  `UART_ADDR_WIDTH28'd0	// transmitter28
`define UART_REG_IE28	`UART_ADDR_WIDTH28'd1	// Interrupt28 enable
`define UART_REG_II28  `UART_ADDR_WIDTH28'd2	// Interrupt28 identification28
`define UART_REG_FC28  `UART_ADDR_WIDTH28'd2	// FIFO control28
`define UART_REG_LC28	`UART_ADDR_WIDTH28'd3	// Line28 Control28
`define UART_REG_MC28	`UART_ADDR_WIDTH28'd4	// Modem28 control28
`define UART_REG_LS28  `UART_ADDR_WIDTH28'd5	// Line28 status
`define UART_REG_MS28  `UART_ADDR_WIDTH28'd6	// Modem28 status
`define UART_REG_SR28  `UART_ADDR_WIDTH28'd7	// Scratch28 register
`define UART_REG_DL128	`UART_ADDR_WIDTH28'd0	// Divisor28 latch28 bytes (1-2)
`define UART_REG_DL228	`UART_ADDR_WIDTH28'd1

// Interrupt28 Enable28 register bits
`define UART_IE_RDA28	0	// Received28 Data available interrupt28
`define UART_IE_THRE28	1	// Transmitter28 Holding28 Register empty28 interrupt28
`define UART_IE_RLS28	2	// Receiver28 Line28 Status Interrupt28
`define UART_IE_MS28	3	// Modem28 Status Interrupt28

// Interrupt28 Identification28 register bits
`define UART_II_IP28	0	// Interrupt28 pending when 0
`define UART_II_II28	3:1	// Interrupt28 identification28

// Interrupt28 identification28 values for bits 3:1
`define UART_II_RLS28	3'b011	// Receiver28 Line28 Status
`define UART_II_RDA28	3'b010	// Receiver28 Data available
`define UART_II_TI28	3'b110	// Timeout28 Indication28
`define UART_II_THRE28	3'b001	// Transmitter28 Holding28 Register empty28
`define UART_II_MS28	3'b000	// Modem28 Status

// FIFO Control28 Register bits
`define UART_FC_TL28	1:0	// Trigger28 level

// FIFO trigger level values
`define UART_FC_128		2'b00
`define UART_FC_428		2'b01
`define UART_FC_828		2'b10
`define UART_FC_1428	2'b11

// Line28 Control28 register bits
`define UART_LC_BITS28	1:0	// bits in character28
`define UART_LC_SB28	2	// stop bits
`define UART_LC_PE28	3	// parity28 enable
`define UART_LC_EP28	4	// even28 parity28
`define UART_LC_SP28	5	// stick28 parity28
`define UART_LC_BC28	6	// Break28 control28
`define UART_LC_DL28	7	// Divisor28 Latch28 access bit

// Modem28 Control28 register bits
`define UART_MC_DTR28	0
`define UART_MC_RTS28	1
`define UART_MC_OUT128	2
`define UART_MC_OUT228	3
`define UART_MC_LB28	4	// Loopback28 mode

// Line28 Status Register bits
`define UART_LS_DR28	0	// Data ready
`define UART_LS_OE28	1	// Overrun28 Error
`define UART_LS_PE28	2	// Parity28 Error
`define UART_LS_FE28	3	// Framing28 Error
`define UART_LS_BI28	4	// Break28 interrupt28
`define UART_LS_TFE28	5	// Transmit28 FIFO is empty28
`define UART_LS_TE28	6	// Transmitter28 Empty28 indicator28
`define UART_LS_EI28	7	// Error indicator28

// Modem28 Status Register bits
`define UART_MS_DCTS28	0	// Delta28 signals28
`define UART_MS_DDSR28	1
`define UART_MS_TERI28	2
`define UART_MS_DDCD28	3
`define UART_MS_CCTS28	4	// Complement28 signals28
`define UART_MS_CDSR28	5
`define UART_MS_CRI28	6
`define UART_MS_CDCD28	7

// FIFO parameter defines28

`define UART_FIFO_WIDTH28	8
`define UART_FIFO_DEPTH28	16
`define UART_FIFO_POINTER_W28	4
`define UART_FIFO_COUNTER_W28	5
// receiver28 fifo has width 11 because it has break, parity28 and framing28 error bits
`define UART_FIFO_REC_WIDTH28  11


`define VERBOSE_WB28  0           // All activity28 on the WISHBONE28 is recorded28
`define VERBOSE_LINE_STATUS28 0   // Details28 about28 the lsr28 (line status register)
`define FAST_TEST28   1           // 64/1024 packets28 are sent28







