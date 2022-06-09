//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define24.v                                                ////
////                                                              ////
////  This24 file is part of the SPI24 IP24 core24 project24                ////
////  http24://www24.opencores24.org24/projects24/spi24/                      ////
////                                                              ////
////  Author24(s):                                                  ////
////      - Simon24 Srot24 (simons24@opencores24.org24)                     ////
////                                                              ////
////  All additional24 information is avaliable24 in the Readme24.txt24   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright24 (C) 2002 Authors24                                   ////
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
// Number24 of bits used for devider24 register. If24 used in system with
// low24 frequency24 of system clock24 this can be reduced24.
// Use SPI_DIVIDER_LEN24 for fine24 tuning24 theexact24 number24.
//
//`define SPI_DIVIDER_LEN_824
`define SPI_DIVIDER_LEN_1624
//`define SPI_DIVIDER_LEN_2424
//`define SPI_DIVIDER_LEN_3224

`ifdef SPI_DIVIDER_LEN_824
  `define SPI_DIVIDER_LEN24       8    // Can24 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1624                                       
  `define SPI_DIVIDER_LEN24       16   // Can24 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2424                                       
  `define SPI_DIVIDER_LEN24       24   // Can24 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3224                                       
  `define SPI_DIVIDER_LEN24       32   // Can24 be set from 25 to 32 
`endif

//
// Maximum24 nuber24 of bits that can be send/received24 at once24. 
// Use SPI_MAX_CHAR24 for fine24 tuning24 the exact24 number24, when using
// SPI_MAX_CHAR_3224, SPI_MAX_CHAR_2424, SPI_MAX_CHAR_1624, SPI_MAX_CHAR_824.
//
`define SPI_MAX_CHAR_12824
//`define SPI_MAX_CHAR_6424
//`define SPI_MAX_CHAR_3224
//`define SPI_MAX_CHAR_2424
//`define SPI_MAX_CHAR_1624
//`define SPI_MAX_CHAR_824

`ifdef SPI_MAX_CHAR_12824
  `define SPI_MAX_CHAR24          128  // Can24 only be set to 128 
  `define SPI_CHAR_LEN_BITS24     7
`endif
`ifdef SPI_MAX_CHAR_6424
  `define SPI_MAX_CHAR24          64   // Can24 only be set to 64 
  `define SPI_CHAR_LEN_BITS24     6
`endif
`ifdef SPI_MAX_CHAR_3224
  `define SPI_MAX_CHAR24          32   // Can24 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS24     5
`endif
`ifdef SPI_MAX_CHAR_2424
  `define SPI_MAX_CHAR24          24   // Can24 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS24     5
`endif
`ifdef SPI_MAX_CHAR_1624
  `define SPI_MAX_CHAR24          16   // Can24 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS24     4
`endif
`ifdef SPI_MAX_CHAR_824
  `define SPI_MAX_CHAR24          8    // Can24 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS24     3
`endif

//
// Number24 of device24 select24 signals24. Use SPI_SS_NB24 for fine24 tuning24 the 
// exact24 number24.
//
`define SPI_SS_NB_824
//`define SPI_SS_NB_1624
//`define SPI_SS_NB_2424
//`define SPI_SS_NB_3224

`ifdef SPI_SS_NB_824
  `define SPI_SS_NB24             8    // Can24 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1624
  `define SPI_SS_NB24             16   // Can24 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2424
  `define SPI_SS_NB24             24   // Can24 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3224
  `define SPI_SS_NB24             32   // Can24 be set from 25 to 32
`endif

//
// Bits24 of WISHBONE24 address used for partial24 decoding24 of SPI24 registers.
//
`define SPI_OFS_BITS24	          4:2

//
// Register offset
//
`define SPI_RX_024                0
`define SPI_RX_124                1
`define SPI_RX_224                2
`define SPI_RX_324                3
`define SPI_TX_024                0
`define SPI_TX_124                1
`define SPI_TX_224                2
`define SPI_TX_324                3
`define SPI_CTRL24                4
`define SPI_DEVIDE24              5
`define SPI_SS24                  6

//
// Number24 of bits in ctrl24 register
//
`define SPI_CTRL_BIT_NB24         14

//
// Control24 register bit position24
//
`define SPI_CTRL_ASS24            13
`define SPI_CTRL_IE24             12
`define SPI_CTRL_LSB24            11
`define SPI_CTRL_TX_NEGEDGE24     10
`define SPI_CTRL_RX_NEGEDGE24     9
`define SPI_CTRL_GO24             8
`define SPI_CTRL_RES_124          7
`define SPI_CTRL_CHAR_LEN24       6:0

