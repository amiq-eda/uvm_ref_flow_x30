//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_defines12.v                                              ////
////                                                              ////
////                                                              ////
////  This12 file is part of the "UART12 16550 compatible12" project12    ////
////  http12://www12.opencores12.org12/cores12/uart1655012/                   ////
////                                                              ////
////  Documentation12 related12 to this project12:                      ////
////  - http12://www12.opencores12.org12/cores12/uart1655012/                 ////
////                                                              ////
////  Projects12 compatibility12:                                     ////
////  - WISHBONE12                                                  ////
////  RS23212 Protocol12                                              ////
////  16550D uart12 (mostly12 supported)                              ////
////                                                              ////
////  Overview12 (main12 Features12):                                   ////
////  Defines12 of the Core12                                         ////
////                                                              ////
////  Known12 problems12 (limits12):                                    ////
////  None12                                                        ////
////                                                              ////
////  To12 Do12:                                                      ////
////  Nothing.                                                    ////
////                                                              ////
////  Author12(s):                                                  ////
////      - gorban12@opencores12.org12                                  ////
////      - Jacob12 Gorban12                                          ////
////      - Igor12 Mohor12 (igorm12@opencores12.org12)                      ////
////                                                              ////
////  Created12:        2001/05/12                                  ////
////  Last12 Updated12:   2001/05/17                                  ////
////                  (See log12 for the revision12 history12)          ////
////                                                              ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright12 (C) 2000, 2001 Authors12                             ////
////                                                              ////
//// This12 source12 file may be used and distributed12 without         ////
//// restriction12 provided that this copyright12 statement12 is not    ////
//// removed from the file and that any derivative12 work12 contains12  ////
//// the original copyright12 notice12 and the associated disclaimer12. ////
////                                                              ////
//// This12 source12 file is free software12; you can redistribute12 it   ////
//// and/or modify it under the terms12 of the GNU12 Lesser12 General12   ////
//// Public12 License12 as published12 by the Free12 Software12 Foundation12; ////
//// either12 version12 2.1 of the License12, or (at your12 option) any   ////
//// later12 version12.                                               ////
////                                                              ////
//// This12 source12 is distributed12 in the hope12 that it will be       ////
//// useful12, but WITHOUT12 ANY12 WARRANTY12; without even12 the implied12   ////
//// warranty12 of MERCHANTABILITY12 or FITNESS12 FOR12 A PARTICULAR12      ////
//// PURPOSE12.  See the GNU12 Lesser12 General12 Public12 License12 for more ////
//// details12.                                                     ////
////                                                              ////
//// You should have received12 a copy of the GNU12 Lesser12 General12    ////
//// Public12 License12 along12 with this source12; if not, download12 it   ////
//// from http12://www12.opencores12.org12/lgpl12.shtml12                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS12 Revision12 History12
//
// $Log: not supported by cvs2svn12 $
// Revision12 1.13  2003/06/11 16:37:47  gorban12
// This12 fixes12 errors12 in some12 cases12 when data is being read and put to the FIFO at the same time. Patch12 is submitted12 by Scott12 Furman12. Update is very12 recommended12.
//
// Revision12 1.12  2002/07/22 23:02:23  gorban12
// Bug12 Fixes12:
//  * Possible12 loss of sync and bad12 reception12 of stop bit on slow12 baud12 rates12 fixed12.
//   Problem12 reported12 by Kenny12.Tung12.
//  * Bad (or lack12 of ) loopback12 handling12 fixed12. Reported12 by Cherry12 Withers12.
//
// Improvements12:
//  * Made12 FIFO's as general12 inferrable12 memory where possible12.
//  So12 on FPGA12 they should be inferred12 as RAM12 (Distributed12 RAM12 on Xilinx12).
//  This12 saves12 about12 1/3 of the Slice12 count and reduces12 P&R and synthesis12 times.
//
//  * Added12 optional12 baudrate12 output (baud_o12).
//  This12 is identical12 to BAUDOUT12* signal12 on 16550 chip12.
//  It outputs12 16xbit_clock_rate - the divided12 clock12.
//  It's disabled by default. Define12 UART_HAS_BAUDRATE_OUTPUT12 to use.
//
// Revision12 1.10  2001/12/11 08:55:40  mohor12
// Scratch12 register define added.
//
// Revision12 1.9  2001/12/03 21:44:29  gorban12
// Updated12 specification12 documentation.
// Added12 full 32-bit data bus interface, now as default.
// Address is 5-bit wide12 in 32-bit data bus mode.
// Added12 wb_sel_i12 input to the core12. It's used in the 32-bit mode.
// Added12 debug12 interface with two12 32-bit read-only registers in 32-bit mode.
// Bits12 5 and 6 of LSR12 are now only cleared12 on TX12 FIFO write.
// My12 small test bench12 is modified to work12 with 32-bit mode.
//
// Revision12 1.8  2001/11/26 21:38:54  gorban12
// Lots12 of fixes12:
// Break12 condition wasn12't handled12 correctly at all.
// LSR12 bits could lose12 their12 values.
// LSR12 value after reset was wrong12.
// Timing12 of THRE12 interrupt12 signal12 corrected12.
// LSR12 bit 0 timing12 corrected12.
//
// Revision12 1.7  2001/08/24 21:01:12  mohor12
// Things12 connected12 to parity12 changed.
// Clock12 devider12 changed.
//
// Revision12 1.6  2001/08/23 16:05:05  mohor12
// Stop bit bug12 fixed12.
// Parity12 bug12 fixed12.
// WISHBONE12 read cycle bug12 fixed12,
// OE12 indicator12 (Overrun12 Error) bug12 fixed12.
// PE12 indicator12 (Parity12 Error) bug12 fixed12.
// Register read bug12 fixed12.
//
// Revision12 1.5  2001/05/31 20:08:01  gorban12
// FIFO changes12 and other corrections12.
//
// Revision12 1.4  2001/05/21 19:12:02  gorban12
// Corrected12 some12 Linter12 messages12.
//
// Revision12 1.3  2001/05/17 18:34:18  gorban12
// First12 'stable' release. Should12 be sythesizable12 now. Also12 added new header.
//
// Revision12 1.0  2001-05-17 21:27:11+02  jacob12
// Initial12 revision12
//
//

// remove comments12 to restore12 to use the new version12 with 8 data bit interface
// in 32bit-bus mode, the wb_sel_i12 signal12 is used to put data in correct12 place12
// also, in 8-bit version12 there12'll be no debugging12 features12 included12
// CAUTION12: doesn't work12 with current version12 of OR120012
//`define DATA_BUS_WIDTH_812

`ifdef DATA_BUS_WIDTH_812
 `define UART_ADDR_WIDTH12 3
 `define UART_DATA_WIDTH12 8
`else
 `define UART_ADDR_WIDTH12 5
 `define UART_DATA_WIDTH12 32
`endif

// Uncomment12 this if you want12 your12 UART12 to have
// 16xBaudrate output port.
// If12 defined, the enable signal12 will be used to drive12 baudrate_o12 signal12
// It's frequency12 is 16xbaudrate

// `define UART_HAS_BAUDRATE_OUTPUT12

// Register addresses12
`define UART_REG_RB12	`UART_ADDR_WIDTH12'd0	// receiver12 buffer12
`define UART_REG_TR12  `UART_ADDR_WIDTH12'd0	// transmitter12
`define UART_REG_IE12	`UART_ADDR_WIDTH12'd1	// Interrupt12 enable
`define UART_REG_II12  `UART_ADDR_WIDTH12'd2	// Interrupt12 identification12
`define UART_REG_FC12  `UART_ADDR_WIDTH12'd2	// FIFO control12
`define UART_REG_LC12	`UART_ADDR_WIDTH12'd3	// Line12 Control12
`define UART_REG_MC12	`UART_ADDR_WIDTH12'd4	// Modem12 control12
`define UART_REG_LS12  `UART_ADDR_WIDTH12'd5	// Line12 status
`define UART_REG_MS12  `UART_ADDR_WIDTH12'd6	// Modem12 status
`define UART_REG_SR12  `UART_ADDR_WIDTH12'd7	// Scratch12 register
`define UART_REG_DL112	`UART_ADDR_WIDTH12'd0	// Divisor12 latch12 bytes (1-2)
`define UART_REG_DL212	`UART_ADDR_WIDTH12'd1

// Interrupt12 Enable12 register bits
`define UART_IE_RDA12	0	// Received12 Data available interrupt12
`define UART_IE_THRE12	1	// Transmitter12 Holding12 Register empty12 interrupt12
`define UART_IE_RLS12	2	// Receiver12 Line12 Status Interrupt12
`define UART_IE_MS12	3	// Modem12 Status Interrupt12

// Interrupt12 Identification12 register bits
`define UART_II_IP12	0	// Interrupt12 pending when 0
`define UART_II_II12	3:1	// Interrupt12 identification12

// Interrupt12 identification12 values for bits 3:1
`define UART_II_RLS12	3'b011	// Receiver12 Line12 Status
`define UART_II_RDA12	3'b010	// Receiver12 Data available
`define UART_II_TI12	3'b110	// Timeout12 Indication12
`define UART_II_THRE12	3'b001	// Transmitter12 Holding12 Register empty12
`define UART_II_MS12	3'b000	// Modem12 Status

// FIFO Control12 Register bits
`define UART_FC_TL12	1:0	// Trigger12 level

// FIFO trigger level values
`define UART_FC_112		2'b00
`define UART_FC_412		2'b01
`define UART_FC_812		2'b10
`define UART_FC_1412	2'b11

// Line12 Control12 register bits
`define UART_LC_BITS12	1:0	// bits in character12
`define UART_LC_SB12	2	// stop bits
`define UART_LC_PE12	3	// parity12 enable
`define UART_LC_EP12	4	// even12 parity12
`define UART_LC_SP12	5	// stick12 parity12
`define UART_LC_BC12	6	// Break12 control12
`define UART_LC_DL12	7	// Divisor12 Latch12 access bit

// Modem12 Control12 register bits
`define UART_MC_DTR12	0
`define UART_MC_RTS12	1
`define UART_MC_OUT112	2
`define UART_MC_OUT212	3
`define UART_MC_LB12	4	// Loopback12 mode

// Line12 Status Register bits
`define UART_LS_DR12	0	// Data ready
`define UART_LS_OE12	1	// Overrun12 Error
`define UART_LS_PE12	2	// Parity12 Error
`define UART_LS_FE12	3	// Framing12 Error
`define UART_LS_BI12	4	// Break12 interrupt12
`define UART_LS_TFE12	5	// Transmit12 FIFO is empty12
`define UART_LS_TE12	6	// Transmitter12 Empty12 indicator12
`define UART_LS_EI12	7	// Error indicator12

// Modem12 Status Register bits
`define UART_MS_DCTS12	0	// Delta12 signals12
`define UART_MS_DDSR12	1
`define UART_MS_TERI12	2
`define UART_MS_DDCD12	3
`define UART_MS_CCTS12	4	// Complement12 signals12
`define UART_MS_CDSR12	5
`define UART_MS_CRI12	6
`define UART_MS_CDCD12	7

// FIFO parameter defines12

`define UART_FIFO_WIDTH12	8
`define UART_FIFO_DEPTH12	16
`define UART_FIFO_POINTER_W12	4
`define UART_FIFO_COUNTER_W12	5
// receiver12 fifo has width 11 because it has break, parity12 and framing12 error bits
`define UART_FIFO_REC_WIDTH12  11


`define VERBOSE_WB12  0           // All activity12 on the WISHBONE12 is recorded12
`define VERBOSE_LINE_STATUS12 0   // Details12 about12 the lsr12 (line status register)
`define FAST_TEST12   1           // 64/1024 packets12 are sent12







