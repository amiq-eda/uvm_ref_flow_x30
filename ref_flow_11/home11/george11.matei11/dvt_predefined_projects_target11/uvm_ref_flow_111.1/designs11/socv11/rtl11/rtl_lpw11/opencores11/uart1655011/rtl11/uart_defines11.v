//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines11.v                                              ////
////                                                              ////
////                                                              ////
////  This11 file is part of the "UART11 16550 compatible11" project11    ////
////  http11://www11.opencores11.org11/cores11/uart1655011/                   ////
////                                                              ////
////  Documentation11 related11 to this project11:                      ////
////  - http11://www11.opencores11.org11/cores11/uart1655011/                 ////
////                                                              ////
////  Projects11 compatibility11:                                     ////
////  - WISHBONE11                                                  ////
////  RS23211 Protocol11                                              ////
////  16550D uart11 (mostly11 supported)                              ////
////                                                              ////
////  Overview11 (main11 Features11):                                   ////
////  Defines11 of the Core11                                         ////
////                                                              ////
////  Known11 problems11 (limits11):                                    ////
////  None11                                                        ////
////                                                              ////
////  To11 Do11:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author11(s):                                                  ////
////      - gorban11@opencores11.org11                                  ////
////      - Jacob11 Gorban11                                          ////
////      - Igor11 Mohor11 (igorm11@opencores11.org11)                      ////
////                                                              ////
////  Created11:        2001/05/12                                  ////
////  Last11 Updated11:   2001/05/17                                  ////
////                  (See log11 for the revision11 history11)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright11 (C) 2000, 2001 Authors11                             ////
////                                                              ////
//// This11 source11 file may be used and distributed11 without         ////
//// restriction11 provided that this copyright11 statement11 is not    ////
//// removed from the file and that any derivative11 work11 contains11  ////
//// the original copyright11 notice11 and the associated disclaimer11. ////
////                                                              ////
//// This11 source11 file is free software11; you can redistribute11 it   ////
//// and/or modify it under the terms11 of the GNU11 Lesser11 General11   ////
//// Public11 License11 as published11 by the Free11 Software11 Foundation11; ////
//// either11 version11 2.1 of the License11, or (at your11 option) any   ////
//// later11 version11.                                               ////
////                                                              ////
//// This11 source11 is distributed11 in the hope11 that it will be       ////
//// useful11, but WITHOUT11 ANY11 WARRANTY11; without even11 the implied11   ////
//// warranty11 of MERCHANTABILITY11 or FITNESS11 FOR11 A PARTICULAR11      ////
//// PURPOSE11.  See the GNU11 Lesser11 General11 Public11 License11 for more ////
//// details11.                                                     ////
////                                                              ////
//// You should have received11 a copy of the GNU11 Lesser11 General11    ////
//// Public11 License11 along11 with this source11; if not, download11 it   ////
//// from http11://www11.opencores11.org11/lgpl11.shtml11                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS11 Revision11 History11
//
// $Log: not supported by cvs2svn11 $
// Revision11 1.13  2003/06/11 16:37:47  gorban11
// This11 fixes11 errors11 in some11 cases11 when data is being read and put to the FIFO at the same time. Patch11 is submitted11 by Scott11 Furman11. Update is very11 recommended11.
//
// Revision11 1.12  2002/07/22 23:02:23  gorban11
// Bug11 Fixes11:
//  * Possible11 loss of sync and bad11 reception11 of stop bit on slow11 baud11 rates11 fixed11.
//   Problem11 reported11 by Kenny11.Tung11.
//  * Bad (or lack11 of ) loopback11 handling11 fixed11. Reported11 by Cherry11 Withers11.
//
// Improvements11:
//  * Made11 FIFO's as general11 inferrable11 memory where possible11.
//  So11 on FPGA11 they should be inferred11 as RAM11 (Distributed11 RAM11 on Xilinx11).
//  This11 saves11 about11 1/3 of the Slice11 count and reduces11 P&R and synthesis11 times.
//
//  * Added11 optional11 baudrate11 output (baud_o11).
//  This11 is identical11 to BAUDOUT11* signal11 on 16550 chip11.
//  It outputs11 16xbit_clock_rate - the divided11 clock11.
//  It's disabled by default. Define11 UART_HAS_BAUDRATE_OUTPUT11 to use.
//
// Revision11 1.10  2001/12/11 08:55:40  mohor11
// Scratch11 register define added.
//
// Revision11 1.9  2001/12/03 21:44:29  gorban11
// Updated11 specification11 documentation.
// Added11 full 32-bit data bus interface, now as default.
// Address is 5-bit wide11 in 32-bit data bus mode.
// Added11 wb_sel_i11 input to the core11. It's used in the 32-bit mode.
// Added11 debug11 interface with two11 32-bit read-only registers in 32-bit mode.
// Bits11 5 and 6 of LSR11 are now only cleared11 on TX11 FIFO write.
// My11 small test bench11 is modified to work11 with 32-bit mode.
//
// Revision11 1.8  2001/11/26 21:38:54  gorban11
// Lots11 of fixes11:
// Break11 condition wasn11't handled11 correctly at all.
// LSR11 bits could lose11 their11 values.
// LSR11 value after reset was wrong11.
// Timing11 of THRE11 interrupt11 signal11 corrected11.
// LSR11 bit 0 timing11 corrected11.
//
// Revision11 1.7  2001/08/24 21:01:12  mohor11
// Things11 connected11 to parity11 changed.
// Clock11 devider11 changed.
//
// Revision11 1.6  2001/08/23 16:05:05  mohor11
// Stop bit bug11 fixed11.
// Parity11 bug11 fixed11.
// WISHBONE11 read cycle bug11 fixed11,
// OE11 indicator11 (Overrun11 Error) bug11 fixed11.
// PE11 indicator11 (Parity11 Error) bug11 fixed11.
// Register read bug11 fixed11.
//
// Revision11 1.5  2001/05/31 20:08:01  gorban11
// FIFO changes11 and other corrections11.
//
// Revision11 1.4  2001/05/21 19:12:02  gorban11
// Corrected11 some11 Linter11 messages11.
//
// Revision11 1.3  2001/05/17 18:34:18  gorban11
// First11 'stable' release. Should11 be sythesizable11 now. Also11 added new header.
//
// Revision11 1.0  2001-05-17 21:27:11+02  jacob11
// Initial11 revision11
//
//

// remove comments11 to restore11 to use the new version11 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i11 signal11 is used to put data in correct11 place11
// also, in 8-bit version11 there11'll be no debugging11 features11 included11
// CAUTION11: doesn't work11 with current version11 of OR120011
//`define DATA_BUS_WIDTH_811

`ifdef DATA_BUS_WIDTH_811
 `define UART_ADDR_WIDTH11 3
 `define UART_DATA_WIDTH11 8
`else
 `define UART_ADDR_WIDTH11 5
 `define UART_DATA_WIDTH11 32
`endif

// Uncomment11 this if you want11 your11 UART11 to have
// 16xBaudrate output port.
// If11 defined, the enable signal11 will be used to drive11 baudrate_o11 signal11
// It's frequency11 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT11

// Register addresses11
`define UART_REG_RB11	`UART_ADDR_WIDTH11'd0	// receiver11 buffer11
`define UART_REG_TR11  `UART_ADDR_WIDTH11'd0	// transmitter11
`define UART_REG_IE11	`UART_ADDR_WIDTH11'd1	// Interrupt11 enable
`define UART_REG_II11  `UART_ADDR_WIDTH11'd2	// Interrupt11 identification11
`define UART_REG_FC11  `UART_ADDR_WIDTH11'd2	// FIFO control11
`define UART_REG_LC11	`UART_ADDR_WIDTH11'd3	// Line11 Control11
`define UART_REG_MC11	`UART_ADDR_WIDTH11'd4	// Modem11 control11
`define UART_REG_LS11  `UART_ADDR_WIDTH11'd5	// Line11 status
`define UART_REG_MS11  `UART_ADDR_WIDTH11'd6	// Modem11 status
`define UART_REG_SR11  `UART_ADDR_WIDTH11'd7	// Scratch11 register
`define UART_REG_DL111	`UART_ADDR_WIDTH11'd0	// Divisor11 latch11 bytes (1-2)
`define UART_REG_DL211	`UART_ADDR_WIDTH11'd1

// Interrupt11 Enable11 register bits
`define UART_IE_RDA11	0	// Received11 Data available interrupt11
`define UART_IE_THRE11	1	// Transmitter11 Holding11 Register empty11 interrupt11
`define UART_IE_RLS11	2	// Receiver11 Line11 Status Interrupt11
`define UART_IE_MS11	3	// Modem11 Status Interrupt11

// Interrupt11 Identification11 register bits
`define UART_II_IP11	0	// Interrupt11 pending when 0
`define UART_II_II11	3:1	// Interrupt11 identification11

// Interrupt11 identification11 values for bits 3:1
`define UART_II_RLS11	3'b011	// Receiver11 Line11 Status
`define UART_II_RDA11	3'b010	// Receiver11 Data available
`define UART_II_TI11	3'b110	// Timeout11 Indication11
`define UART_II_THRE11	3'b001	// Transmitter11 Holding11 Register empty11
`define UART_II_MS11	3'b000	// Modem11 Status

// FIFO Control11 Register bits
`define UART_FC_TL11	1:0	// Trigger11 level

// FIFO trigger level values
`define UART_FC_111		2'b00
`define UART_FC_411		2'b01
`define UART_FC_811		2'b10
`define UART_FC_1411	2'b11

// Line11 Control11 register bits
`define UART_LC_BITS11	1:0	// bits in character11
`define UART_LC_SB11	2	// stop bits
`define UART_LC_PE11	3	// parity11 enable
`define UART_LC_EP11	4	// even11 parity11
`define UART_LC_SP11	5	// stick11 parity11
`define UART_LC_BC11	6	// Break11 control11
`define UART_LC_DL11	7	// Divisor11 Latch11 access bit

// Modem11 Control11 register bits
`define UART_MC_DTR11	0
`define UART_MC_RTS11	1
`define UART_MC_OUT111	2
`define UART_MC_OUT211	3
`define UART_MC_LB11	4	// Loopback11 mode

// Line11 Status Register bits
`define UART_LS_DR11	0	// Data ready
`define UART_LS_OE11	1	// Overrun11 Error
`define UART_LS_PE11	2	// Parity11 Error
`define UART_LS_FE11	3	// Framing11 Error
`define UART_LS_BI11	4	// Break11 interrupt11
`define UART_LS_TFE11	5	// Transmit11 FIFO is empty11
`define UART_LS_TE11	6	// Transmitter11 Empty11 indicator11
`define UART_LS_EI11	7	// Error indicator11

// Modem11 Status Register bits
`define UART_MS_DCTS11	0	// Delta11 signals11
`define UART_MS_DDSR11	1
`define UART_MS_TERI11	2
`define UART_MS_DDCD11	3
`define UART_MS_CCTS11	4	// Complement11 signals11
`define UART_MS_CDSR11	5
`define UART_MS_CRI11	6
`define UART_MS_CDCD11	7

// FIFO parameter defines11

`define UART_FIFO_WIDTH11	8
`define UART_FIFO_DEPTH11	16
`define UART_FIFO_POINTER_W11	4
`define UART_FIFO_COUNTER_W11	5
// receiver11 fifo has width 11 because it has break, parity11 and framing11 error bits
`define UART_FIFO_REC_WIDTH11  11


`define VERBOSE_WB11  0           // All activity11 on the WISHBONE11 is recorded11
`define VERBOSE_LINE_STATUS11 0   // Details11 about11 the lsr11 (line status register)
`define FAST_TEST11   1           // 64/1024 packets11 are sent11







