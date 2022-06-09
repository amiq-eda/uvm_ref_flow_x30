//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define3.v                                                ////
////                                                              ////
////  This3 file is part of the SPI3 IP3 core3 project3                ////
////  http3://www3.opencores3.org3/projects3/spi3/                      ////
////                                                              ////
////  Author3(s):                                                  ////
////      - Simon3 Srot3 (simons3@opencores3.org3)                     ////
////                                                              ////
////  All additional3 information is avaliable3 in the Readme3.txt3   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright3 (C) 2002 Authors3                                   ////
////                                                              ////
//// This3 source3 file may be used and distributed3 without         ////
//// restriction3 provided that this copyright3 statement3 is not    ////
//// removed from the file and that any derivative3 work3 contains3  ////
//// the original copyright3 notice3 and the associated disclaimer3. ////
////                                                              ////
//// This3 source3 file is free software3; you can redistribute3 it   ////
//// and/or modify it under the terms3 of the GNU3 Lesser3 General3   ////
//// Public3 License3 as published3 by the Free3 Software3 Foundation3; ////
//// either3 version3 2.1 of the License3, or (at your3 option) any   ////
//// later3 version3.                                               ////
////                                                              ////
//// This3 source3 is distributed3 in the hope3 that it will be       ////
//// useful3, but WITHOUT3 ANY3 WARRANTY3; without even3 the implied3   ////
//// warranty3 of MERCHANTABILITY3 or FITNESS3 FOR3 A PARTICULAR3      ////
//// PURPOSE3.  See the GNU3 Lesser3 General3 Public3 License3 for more ////
//// details3.                                                     ////
////                                                              ////
//// You should have received3 a copy of the GNU3 Lesser3 General3    ////
//// Public3 License3 along3 with this source3; if not, download3 it   ////
//// from http3://www3.opencores3.org3/lgpl3.shtml3                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number3 of bits used for devider3 register. If3 used in system with
// low3 frequency3 of system clock3 this can be reduced3.
// Use SPI_DIVIDER_LEN3 for fine3 tuning3 theexact3 number3.
//
//`define SPI_DIVIDER_LEN_83
`define SPI_DIVIDER_LEN_163
//`define SPI_DIVIDER_LEN_243
//`define SPI_DIVIDER_LEN_323

`ifdef SPI_DIVIDER_LEN_83
  `define SPI_DIVIDER_LEN3       8    // Can3 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_163                                       
  `define SPI_DIVIDER_LEN3       16   // Can3 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_243                                       
  `define SPI_DIVIDER_LEN3       24   // Can3 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_323                                       
  `define SPI_DIVIDER_LEN3       32   // Can3 be set from 25 to 32 
`endif

//
// Maximum3 nuber3 of bits that can be send/received3 at once3. 
// Use SPI_MAX_CHAR3 for fine3 tuning3 the exact3 number3, when using
// SPI_MAX_CHAR_323, SPI_MAX_CHAR_243, SPI_MAX_CHAR_163, SPI_MAX_CHAR_83.
//
`define SPI_MAX_CHAR_1283
//`define SPI_MAX_CHAR_643
//`define SPI_MAX_CHAR_323
//`define SPI_MAX_CHAR_243
//`define SPI_MAX_CHAR_163
//`define SPI_MAX_CHAR_83

`ifdef SPI_MAX_CHAR_1283
  `define SPI_MAX_CHAR3          128  // Can3 only be set to 128 
  `define SPI_CHAR_LEN_BITS3     7
`endif
`ifdef SPI_MAX_CHAR_643
  `define SPI_MAX_CHAR3          64   // Can3 only be set to 64 
  `define SPI_CHAR_LEN_BITS3     6
`endif
`ifdef SPI_MAX_CHAR_323
  `define SPI_MAX_CHAR3          32   // Can3 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS3     5
`endif
`ifdef SPI_MAX_CHAR_243
  `define SPI_MAX_CHAR3          24   // Can3 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS3     5
`endif
`ifdef SPI_MAX_CHAR_163
  `define SPI_MAX_CHAR3          16   // Can3 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS3     4
`endif
`ifdef SPI_MAX_CHAR_83
  `define SPI_MAX_CHAR3          8    // Can3 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS3     3
`endif

//
// Number3 of device3 select3 signals3. Use SPI_SS_NB3 for fine3 tuning3 the 
// exact3 number3.
//
`define SPI_SS_NB_83
//`define SPI_SS_NB_163
//`define SPI_SS_NB_243
//`define SPI_SS_NB_323

`ifdef SPI_SS_NB_83
  `define SPI_SS_NB3             8    // Can3 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_163
  `define SPI_SS_NB3             16   // Can3 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_243
  `define SPI_SS_NB3             24   // Can3 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_323
  `define SPI_SS_NB3             32   // Can3 be set from 25 to 32
`endif

//
// Bits3 of WISHBONE3 address used for partial3 decoding3 of SPI3 registers.
//
`define SPI_OFS_BITS3	          4:2

//
// Register offset
//
`define SPI_RX_03                0
`define SPI_RX_13                1
`define SPI_RX_23                2
`define SPI_RX_33                3
`define SPI_TX_03                0
`define SPI_TX_13                1
`define SPI_TX_23                2
`define SPI_TX_33                3
`define SPI_CTRL3                4
`define SPI_DEVIDE3              5
`define SPI_SS3                  6

//
// Number3 of bits in ctrl3 register
//
`define SPI_CTRL_BIT_NB3         14

//
// Control3 register bit position3
//
`define SPI_CTRL_ASS3            13
`define SPI_CTRL_IE3             12
`define SPI_CTRL_LSB3            11
`define SPI_CTRL_TX_NEGEDGE3     10
`define SPI_CTRL_RX_NEGEDGE3     9
`define SPI_CTRL_GO3             8
`define SPI_CTRL_RES_13          7
`define SPI_CTRL_CHAR_LEN3       6:0

