//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines5.v                                              ////
////                                                              ////
////                                                              ////
////  This5 file is part of the "UART5 16550 compatible5" project5    ////
////  http5://www5.opencores5.org5/cores5/uart165505/                   ////
////                                                              ////
////  Documentation5 related5 to this project5:                      ////
////  - http5://www5.opencores5.org5/cores5/uart165505/                 ////
////                                                              ////
////  Projects5 compatibility5:                                     ////
////  - WISHBONE5                                                  ////
////  RS2325 Protocol5                                              ////
////  16550D uart5 (mostly5 supported)                              ////
////                                                              ////
////  Overview5 (main5 Features5):                                   ////
////  Defines5 of the Core5                                         ////
////                                                              ////
////  Known5 problems5 (limits5):                                    ////
////  None5                                                        ////
////                                                              ////
////  To5 Do5:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author5(s):                                                  ////
////      - gorban5@opencores5.org5                                  ////
////      - Jacob5 Gorban5                                          ////
////      - Igor5 Mohor5 (igorm5@opencores5.org5)                      ////
////                                                              ////
////  Created5:        2001/05/12                                  ////
////  Last5 Updated5:   2001/05/17                                  ////
////                  (See log5 for the revision5 history5)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright5 (C) 2000, 2001 Authors5                             ////
////                                                              ////
//// This5 source5 file may be used and distributed5 without         ////
//// restriction5 provided that this copyright5 statement5 is not    ////
//// removed from the file and that any derivative5 work5 contains5  ////
//// the original copyright5 notice5 and the associated disclaimer5. ////
////                                                              ////
//// This5 source5 file is free software5; you can redistribute5 it   ////
//// and/or modify it under the terms5 of the GNU5 Lesser5 General5   ////
//// Public5 License5 as published5 by the Free5 Software5 Foundation5; ////
//// either5 version5 2.1 of the License5, or (at your5 option) any   ////
//// later5 version5.                                               ////
////                                                              ////
//// This5 source5 is distributed5 in the hope5 that it will be       ////
//// useful5, but WITHOUT5 ANY5 WARRANTY5; without even5 the implied5   ////
//// warranty5 of MERCHANTABILITY5 or FITNESS5 FOR5 A PARTICULAR5      ////
//// PURPOSE5.  See the GNU5 Lesser5 General5 Public5 License5 for more ////
//// details5.                                                     ////
////                                                              ////
//// You should have received5 a copy of the GNU5 Lesser5 General5    ////
//// Public5 License5 along5 with this source5; if not, download5 it   ////
//// from http5://www5.opencores5.org5/lgpl5.shtml5                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS5 Revision5 History5
//
// $Log: not supported by cvs2svn5 $
// Revision5 1.13  2003/06/11 16:37:47  gorban5
// This5 fixes5 errors5 in some5 cases5 when data is being read and put to the FIFO at the same time. Patch5 is submitted5 by Scott5 Furman5. Update is very5 recommended5.
//
// Revision5 1.12  2002/07/22 23:02:23  gorban5
// Bug5 Fixes5:
//  * Possible5 loss of sync and bad5 reception5 of stop bit on slow5 baud5 rates5 fixed5.
//   Problem5 reported5 by Kenny5.Tung5.
//  * Bad (or lack5 of ) loopback5 handling5 fixed5. Reported5 by Cherry5 Withers5.
//
// Improvements5:
//  * Made5 FIFO's as general5 inferrable5 memory where possible5.
//  So5 on FPGA5 they should be inferred5 as RAM5 (Distributed5 RAM5 on Xilinx5).
//  This5 saves5 about5 1/3 of the Slice5 count and reduces5 P&R and synthesis5 times.
//
//  * Added5 optional5 baudrate5 output (baud_o5).
//  This5 is identical5 to BAUDOUT5* signal5 on 16550 chip5.
//  It outputs5 16xbit_clock_rate - the divided5 clock5.
//  It's disabled by default. Define5 UART_HAS_BAUDRATE_OUTPUT5 to use.
//
// Revision5 1.10  2001/12/11 08:55:40  mohor5
// Scratch5 register define added.
//
// Revision5 1.9  2001/12/03 21:44:29  gorban5
// Updated5 specification5 documentation.
// Added5 full 32-bit data bus interface, now as default.
// Address is 5-bit wide5 in 32-bit data bus mode.
// Added5 wb_sel_i5 input to the core5. It's used in the 32-bit mode.
// Added5 debug5 interface with two5 32-bit read-only registers in 32-bit mode.
// Bits5 5 and 6 of LSR5 are now only cleared5 on TX5 FIFO write.
// My5 small test bench5 is modified to work5 with 32-bit mode.
//
// Revision5 1.8  2001/11/26 21:38:54  gorban5
// Lots5 of fixes5:
// Break5 condition wasn5't handled5 correctly at all.
// LSR5 bits could lose5 their5 values.
// LSR5 value after reset was wrong5.
// Timing5 of THRE5 interrupt5 signal5 corrected5.
// LSR5 bit 0 timing5 corrected5.
//
// Revision5 1.7  2001/08/24 21:01:12  mohor5
// Things5 connected5 to parity5 changed.
// Clock5 devider5 changed.
//
// Revision5 1.6  2001/08/23 16:05:05  mohor5
// Stop bit bug5 fixed5.
// Parity5 bug5 fixed5.
// WISHBONE5 read cycle bug5 fixed5,
// OE5 indicator5 (Overrun5 Error) bug5 fixed5.
// PE5 indicator5 (Parity5 Error) bug5 fixed5.
// Register read bug5 fixed5.
//
// Revision5 1.5  2001/05/31 20:08:01  gorban5
// FIFO changes5 and other corrections5.
//
// Revision5 1.4  2001/05/21 19:12:02  gorban5
// Corrected5 some5 Linter5 messages5.
//
// Revision5 1.3  2001/05/17 18:34:18  gorban5
// First5 'stable' release. Should5 be sythesizable5 now. Also5 added new header.
//
// Revision5 1.0  2001-05-17 21:27:11+02  jacob5
// Initial5 revision5
//
//

// remove comments5 to restore5 to use the new version5 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i5 signal5 is used to put data in correct5 place5
// also, in 8-bit version5 there5'll be no debugging5 features5 included5
// CAUTION5: doesn't work5 with current version5 of OR12005
//`define DATA_BUS_WIDTH_85

`ifdef DATA_BUS_WIDTH_85
 `define UART_ADDR_WIDTH5 3
 `define UART_DATA_WIDTH5 8
`else
 `define UART_ADDR_WIDTH5 5
 `define UART_DATA_WIDTH5 32
`endif

// Uncomment5 this if you want5 your5 UART5 to have
// 16xBaudrate output port.
// If5 defined, the enable signal5 will be used to drive5 baudrate_o5 signal5
// It's frequency5 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT5

// Register addresses5
`define UART_REG_RB5	`UART_ADDR_WIDTH5'd0	// receiver5 buffer5
`define UART_REG_TR5  `UART_ADDR_WIDTH5'd0	// transmitter5
`define UART_REG_IE5	`UART_ADDR_WIDTH5'd1	// Interrupt5 enable
`define UART_REG_II5  `UART_ADDR_WIDTH5'd2	// Interrupt5 identification5
`define UART_REG_FC5  `UART_ADDR_WIDTH5'd2	// FIFO control5
`define UART_REG_LC5	`UART_ADDR_WIDTH5'd3	// Line5 Control5
`define UART_REG_MC5	`UART_ADDR_WIDTH5'd4	// Modem5 control5
`define UART_REG_LS5  `UART_ADDR_WIDTH5'd5	// Line5 status
`define UART_REG_MS5  `UART_ADDR_WIDTH5'd6	// Modem5 status
`define UART_REG_SR5  `UART_ADDR_WIDTH5'd7	// Scratch5 register
`define UART_REG_DL15	`UART_ADDR_WIDTH5'd0	// Divisor5 latch5 bytes (1-2)
`define UART_REG_DL25	`UART_ADDR_WIDTH5'd1

// Interrupt5 Enable5 register bits
`define UART_IE_RDA5	0	// Received5 Data available interrupt5
`define UART_IE_THRE5	1	// Transmitter5 Holding5 Register empty5 interrupt5
`define UART_IE_RLS5	2	// Receiver5 Line5 Status Interrupt5
`define UART_IE_MS5	3	// Modem5 Status Interrupt5

// Interrupt5 Identification5 register bits
`define UART_II_IP5	0	// Interrupt5 pending when 0
`define UART_II_II5	3:1	// Interrupt5 identification5

// Interrupt5 identification5 values for bits 3:1
`define UART_II_RLS5	3'b011	// Receiver5 Line5 Status
`define UART_II_RDA5	3'b010	// Receiver5 Data available
`define UART_II_TI5	3'b110	// Timeout5 Indication5
`define UART_II_THRE5	3'b001	// Transmitter5 Holding5 Register empty5
`define UART_II_MS5	3'b000	// Modem5 Status

// FIFO Control5 Register bits
`define UART_FC_TL5	1:0	// Trigger5 level

// FIFO trigger level values
`define UART_FC_15		2'b00
`define UART_FC_45		2'b01
`define UART_FC_85		2'b10
`define UART_FC_145	2'b11

// Line5 Control5 register bits
`define UART_LC_BITS5	1:0	// bits in character5
`define UART_LC_SB5	2	// stop bits
`define UART_LC_PE5	3	// parity5 enable
`define UART_LC_EP5	4	// even5 parity5
`define UART_LC_SP5	5	// stick5 parity5
`define UART_LC_BC5	6	// Break5 control5
`define UART_LC_DL5	7	// Divisor5 Latch5 access bit

// Modem5 Control5 register bits
`define UART_MC_DTR5	0
`define UART_MC_RTS5	1
`define UART_MC_OUT15	2
`define UART_MC_OUT25	3
`define UART_MC_LB5	4	// Loopback5 mode

// Line5 Status Register bits
`define UART_LS_DR5	0	// Data ready
`define UART_LS_OE5	1	// Overrun5 Error
`define UART_LS_PE5	2	// Parity5 Error
`define UART_LS_FE5	3	// Framing5 Error
`define UART_LS_BI5	4	// Break5 interrupt5
`define UART_LS_TFE5	5	// Transmit5 FIFO is empty5
`define UART_LS_TE5	6	// Transmitter5 Empty5 indicator5
`define UART_LS_EI5	7	// Error indicator5

// Modem5 Status Register bits
`define UART_MS_DCTS5	0	// Delta5 signals5
`define UART_MS_DDSR5	1
`define UART_MS_TERI5	2
`define UART_MS_DDCD5	3
`define UART_MS_CCTS5	4	// Complement5 signals5
`define UART_MS_CDSR5	5
`define UART_MS_CRI5	6
`define UART_MS_CDCD5	7

// FIFO parameter defines5

`define UART_FIFO_WIDTH5	8
`define UART_FIFO_DEPTH5	16
`define UART_FIFO_POINTER_W5	4
`define UART_FIFO_COUNTER_W5	5
// receiver5 fifo has width 11 because it has break, parity5 and framing5 error bits
`define UART_FIFO_REC_WIDTH5  11


`define VERBOSE_WB5  0           // All activity5 on the WISHBONE5 is recorded5
`define VERBOSE_LINE_STATUS5 0   // Details5 about5 the lsr5 (line status register)
`define FAST_TEST5   1           // 64/1024 packets5 are sent5







