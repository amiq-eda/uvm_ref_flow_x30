//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define16.v                                                ////
////                                                              ////
////  This16 file is part of the SPI16 IP16 core16 project16                ////
////  http16://www16.opencores16.org16/projects16/spi16/                      ////
////                                                              ////
////  Author16(s):                                                  ////
////      - Simon16 Srot16 (simons16@opencores16.org16)                     ////
////                                                              ////
////  All additional16 information is avaliable16 in the Readme16.txt16   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright16 (C) 2002 Authors16                                   ////
////                                                              ////
//// This16 source16 file may be used and distributed16 without         ////
//// restriction16 provided that this copyright16 statement16 is not    ////
//// removed from the file and that any derivative16 work16 contains16  ////
//// the original copyright16 notice16 and the associated disclaimer16. ////
////                                                              ////
//// This16 source16 file is free software16; you can redistribute16 it   ////
//// and/or modify it under the terms16 of the GNU16 Lesser16 General16   ////
//// Public16 License16 as published16 by the Free16 Software16 Foundation16; ////
//// either16 version16 2.1 of the License16, or (at your16 option) any   ////
//// later16 version16.                                               ////
////                                                              ////
//// This16 source16 is distributed16 in the hope16 that it will be       ////
//// useful16, but WITHOUT16 ANY16 WARRANTY16; without even16 the implied16   ////
//// warranty16 of MERCHANTABILITY16 or FITNESS16 FOR16 A PARTICULAR16      ////
//// PURPOSE16.  See the GNU16 Lesser16 General16 Public16 License16 for more ////
//// details16.                                                     ////
////                                                              ////
//// You should have received16 a copy of the GNU16 Lesser16 General16    ////
//// Public16 License16 along16 with this source16; if not, download16 it   ////
//// from http16://www16.opencores16.org16/lgpl16.shtml16                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number16 of bits used for devider16 register. If16 used in system with
// low16 frequency16 of system clock16 this can be reduced16.
// Use SPI_DIVIDER_LEN16 for fine16 tuning16 theexact16 number16.
//
//`define SPI_DIVIDER_LEN_816
`define SPI_DIVIDER_LEN_1616
//`define SPI_DIVIDER_LEN_2416
//`define SPI_DIVIDER_LEN_3216

`ifdef SPI_DIVIDER_LEN_816
  `define SPI_DIVIDER_LEN16       8    // Can16 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1616                                       
  `define SPI_DIVIDER_LEN16       16   // Can16 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2416                                       
  `define SPI_DIVIDER_LEN16       24   // Can16 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3216                                       
  `define SPI_DIVIDER_LEN16       32   // Can16 be set from 25 to 32 
`endif

//
// Maximum16 nuber16 of bits that can be send/received16 at once16. 
// Use SPI_MAX_CHAR16 for fine16 tuning16 the exact16 number16, when using
// SPI_MAX_CHAR_3216, SPI_MAX_CHAR_2416, SPI_MAX_CHAR_1616, SPI_MAX_CHAR_816.
//
`define SPI_MAX_CHAR_12816
//`define SPI_MAX_CHAR_6416
//`define SPI_MAX_CHAR_3216
//`define SPI_MAX_CHAR_2416
//`define SPI_MAX_CHAR_1616
//`define SPI_MAX_CHAR_816

`ifdef SPI_MAX_CHAR_12816
  `define SPI_MAX_CHAR16          128  // Can16 only be set to 128 
  `define SPI_CHAR_LEN_BITS16     7
`endif
`ifdef SPI_MAX_CHAR_6416
  `define SPI_MAX_CHAR16          64   // Can16 only be set to 64 
  `define SPI_CHAR_LEN_BITS16     6
`endif
`ifdef SPI_MAX_CHAR_3216
  `define SPI_MAX_CHAR16          32   // Can16 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS16     5
`endif
`ifdef SPI_MAX_CHAR_2416
  `define SPI_MAX_CHAR16          24   // Can16 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS16     5
`endif
`ifdef SPI_MAX_CHAR_1616
  `define SPI_MAX_CHAR16          16   // Can16 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS16     4
`endif
`ifdef SPI_MAX_CHAR_816
  `define SPI_MAX_CHAR16          8    // Can16 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS16     3
`endif

//
// Number16 of device16 select16 signals16. Use SPI_SS_NB16 for fine16 tuning16 the 
// exact16 number16.
//
`define SPI_SS_NB_816
//`define SPI_SS_NB_1616
//`define SPI_SS_NB_2416
//`define SPI_SS_NB_3216

`ifdef SPI_SS_NB_816
  `define SPI_SS_NB16             8    // Can16 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1616
  `define SPI_SS_NB16             16   // Can16 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2416
  `define SPI_SS_NB16             24   // Can16 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3216
  `define SPI_SS_NB16             32   // Can16 be set from 25 to 32
`endif

//
// Bits16 of WISHBONE16 address used for partial16 decoding16 of SPI16 registers.
//
`define SPI_OFS_BITS16	          4:2

//
// Register offset
//
`define SPI_RX_016                0
`define SPI_RX_116                1
`define SPI_RX_216                2
`define SPI_RX_316                3
`define SPI_TX_016                0
`define SPI_TX_116                1
`define SPI_TX_216                2
`define SPI_TX_316                3
`define SPI_CTRL16                4
`define SPI_DEVIDE16              5
`define SPI_SS16                  6

//
// Number16 of bits in ctrl16 register
//
`define SPI_CTRL_BIT_NB16         14

//
// Control16 register bit position16
//
`define SPI_CTRL_ASS16            13
`define SPI_CTRL_IE16             12
`define SPI_CTRL_LSB16            11
`define SPI_CTRL_TX_NEGEDGE16     10
`define SPI_CTRL_RX_NEGEDGE16     9
`define SPI_CTRL_GO16             8
`define SPI_CTRL_RES_116          7
`define SPI_CTRL_CHAR_LEN16       6:0

