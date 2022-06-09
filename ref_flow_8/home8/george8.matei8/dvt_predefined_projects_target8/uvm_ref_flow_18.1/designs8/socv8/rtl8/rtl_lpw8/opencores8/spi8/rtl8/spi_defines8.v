//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define8.v                                                ////
////                                                              ////
////  This8 file is part of the SPI8 IP8 core8 project8                ////
////  http8://www8.opencores8.org8/projects8/spi8/                      ////
////                                                              ////
////  Author8(s):                                                  ////
////      - Simon8 Srot8 (simons8@opencores8.org8)                     ////
////                                                              ////
////  All additional8 information is avaliable8 in the Readme8.txt8   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright8 (C) 2002 Authors8                                   ////
////                                                              ////
//// This8 source8 file may be used and distributed8 without         ////
//// restriction8 provided that this copyright8 statement8 is not    ////
//// removed from the file and that any derivative8 work8 contains8  ////
//// the original copyright8 notice8 and the associated disclaimer8. ////
////                                                              ////
//// This8 source8 file is free software8; you can redistribute8 it   ////
//// and/or modify it under the terms8 of the GNU8 Lesser8 General8   ////
//// Public8 License8 as published8 by the Free8 Software8 Foundation8; ////
//// either8 version8 2.1 of the License8, or (at your8 option) any   ////
//// later8 version8.                                               ////
////                                                              ////
//// This8 source8 is distributed8 in the hope8 that it will be       ////
//// useful8, but WITHOUT8 ANY8 WARRANTY8; without even8 the implied8   ////
//// warranty8 of MERCHANTABILITY8 or FITNESS8 FOR8 A PARTICULAR8      ////
//// PURPOSE8.  See the GNU8 Lesser8 General8 Public8 License8 for more ////
//// details8.                                                     ////
////                                                              ////
//// You should have received8 a copy of the GNU8 Lesser8 General8    ////
//// Public8 License8 along8 with this source8; if not, download8 it   ////
//// from http8://www8.opencores8.org8/lgpl8.shtml8                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number8 of bits used for devider8 register. If8 used in system with
// low8 frequency8 of system clock8 this can be reduced8.
// Use SPI_DIVIDER_LEN8 for fine8 tuning8 theexact8 number8.
//
//`define SPI_DIVIDER_LEN_88
`define SPI_DIVIDER_LEN_168
//`define SPI_DIVIDER_LEN_248
//`define SPI_DIVIDER_LEN_328

`ifdef SPI_DIVIDER_LEN_88
  `define SPI_DIVIDER_LEN8       8    // Can8 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_168                                       
  `define SPI_DIVIDER_LEN8       16   // Can8 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_248                                       
  `define SPI_DIVIDER_LEN8       24   // Can8 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_328                                       
  `define SPI_DIVIDER_LEN8       32   // Can8 be set from 25 to 32 
`endif

//
// Maximum8 nuber8 of bits that can be send/received8 at once8. 
// Use SPI_MAX_CHAR8 for fine8 tuning8 the exact8 number8, when using
// SPI_MAX_CHAR_328, SPI_MAX_CHAR_248, SPI_MAX_CHAR_168, SPI_MAX_CHAR_88.
//
`define SPI_MAX_CHAR_1288
//`define SPI_MAX_CHAR_648
//`define SPI_MAX_CHAR_328
//`define SPI_MAX_CHAR_248
//`define SPI_MAX_CHAR_168
//`define SPI_MAX_CHAR_88

`ifdef SPI_MAX_CHAR_1288
  `define SPI_MAX_CHAR8          128  // Can8 only be set to 128 
  `define SPI_CHAR_LEN_BITS8     7
`endif
`ifdef SPI_MAX_CHAR_648
  `define SPI_MAX_CHAR8          64   // Can8 only be set to 64 
  `define SPI_CHAR_LEN_BITS8     6
`endif
`ifdef SPI_MAX_CHAR_328
  `define SPI_MAX_CHAR8          32   // Can8 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS8     5
`endif
`ifdef SPI_MAX_CHAR_248
  `define SPI_MAX_CHAR8          24   // Can8 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS8     5
`endif
`ifdef SPI_MAX_CHAR_168
  `define SPI_MAX_CHAR8          16   // Can8 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS8     4
`endif
`ifdef SPI_MAX_CHAR_88
  `define SPI_MAX_CHAR8          8    // Can8 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS8     3
`endif

//
// Number8 of device8 select8 signals8. Use SPI_SS_NB8 for fine8 tuning8 the 
// exact8 number8.
//
`define SPI_SS_NB_88
//`define SPI_SS_NB_168
//`define SPI_SS_NB_248
//`define SPI_SS_NB_328

`ifdef SPI_SS_NB_88
  `define SPI_SS_NB8             8    // Can8 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_168
  `define SPI_SS_NB8             16   // Can8 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_248
  `define SPI_SS_NB8             24   // Can8 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_328
  `define SPI_SS_NB8             32   // Can8 be set from 25 to 32
`endif

//
// Bits8 of WISHBONE8 address used for partial8 decoding8 of SPI8 registers.
//
`define SPI_OFS_BITS8	          4:2

//
// Register offset
//
`define SPI_RX_08                0
`define SPI_RX_18                1
`define SPI_RX_28                2
`define SPI_RX_38                3
`define SPI_TX_08                0
`define SPI_TX_18                1
`define SPI_TX_28                2
`define SPI_TX_38                3
`define SPI_CTRL8                4
`define SPI_DEVIDE8              5
`define SPI_SS8                  6

//
// Number8 of bits in ctrl8 register
//
`define SPI_CTRL_BIT_NB8         14

//
// Control8 register bit position8
//
`define SPI_CTRL_ASS8            13
`define SPI_CTRL_IE8             12
`define SPI_CTRL_LSB8            11
`define SPI_CTRL_TX_NEGEDGE8     10
`define SPI_CTRL_RX_NEGEDGE8     9
`define SPI_CTRL_GO8             8
`define SPI_CTRL_RES_18          7
`define SPI_CTRL_CHAR_LEN8       6:0

