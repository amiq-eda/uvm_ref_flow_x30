//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define18.v                                                ////
////                                                              ////
////  This18 file is part of the SPI18 IP18 core18 project18                ////
////  http18://www18.opencores18.org18/projects18/spi18/                      ////
////                                                              ////
////  Author18(s):                                                  ////
////      - Simon18 Srot18 (simons18@opencores18.org18)                     ////
////                                                              ////
////  All additional18 information is avaliable18 in the Readme18.txt18   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright18 (C) 2002 Authors18                                   ////
////                                                              ////
//// This18 source18 file may be used and distributed18 without         ////
//// restriction18 provided that this copyright18 statement18 is not    ////
//// removed from the file and that any derivative18 work18 contains18  ////
//// the original copyright18 notice18 and the associated disclaimer18. ////
////                                                              ////
//// This18 source18 file is free software18; you can redistribute18 it   ////
//// and/or modify it under the terms18 of the GNU18 Lesser18 General18   ////
//// Public18 License18 as published18 by the Free18 Software18 Foundation18; ////
//// either18 version18 2.1 of the License18, or (at your18 option) any   ////
//// later18 version18.                                               ////
////                                                              ////
//// This18 source18 is distributed18 in the hope18 that it will be       ////
//// useful18, but WITHOUT18 ANY18 WARRANTY18; without even18 the implied18   ////
//// warranty18 of MERCHANTABILITY18 or FITNESS18 FOR18 A PARTICULAR18      ////
//// PURPOSE18.  See the GNU18 Lesser18 General18 Public18 License18 for more ////
//// details18.                                                     ////
////                                                              ////
//// You should have received18 a copy of the GNU18 Lesser18 General18    ////
//// Public18 License18 along18 with this source18; if not, download18 it   ////
//// from http18://www18.opencores18.org18/lgpl18.shtml18                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number18 of bits used for devider18 register. If18 used in system with
// low18 frequency18 of system clock18 this can be reduced18.
// Use SPI_DIVIDER_LEN18 for fine18 tuning18 theexact18 number18.
//
//`define SPI_DIVIDER_LEN_818
`define SPI_DIVIDER_LEN_1618
//`define SPI_DIVIDER_LEN_2418
//`define SPI_DIVIDER_LEN_3218

`ifdef SPI_DIVIDER_LEN_818
  `define SPI_DIVIDER_LEN18       8    // Can18 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1618                                       
  `define SPI_DIVIDER_LEN18       16   // Can18 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2418                                       
  `define SPI_DIVIDER_LEN18       24   // Can18 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3218                                       
  `define SPI_DIVIDER_LEN18       32   // Can18 be set from 25 to 32 
`endif

//
// Maximum18 nuber18 of bits that can be send/received18 at once18. 
// Use SPI_MAX_CHAR18 for fine18 tuning18 the exact18 number18, when using
// SPI_MAX_CHAR_3218, SPI_MAX_CHAR_2418, SPI_MAX_CHAR_1618, SPI_MAX_CHAR_818.
//
`define SPI_MAX_CHAR_12818
//`define SPI_MAX_CHAR_6418
//`define SPI_MAX_CHAR_3218
//`define SPI_MAX_CHAR_2418
//`define SPI_MAX_CHAR_1618
//`define SPI_MAX_CHAR_818

`ifdef SPI_MAX_CHAR_12818
  `define SPI_MAX_CHAR18          128  // Can18 only be set to 128 
  `define SPI_CHAR_LEN_BITS18     7
`endif
`ifdef SPI_MAX_CHAR_6418
  `define SPI_MAX_CHAR18          64   // Can18 only be set to 64 
  `define SPI_CHAR_LEN_BITS18     6
`endif
`ifdef SPI_MAX_CHAR_3218
  `define SPI_MAX_CHAR18          32   // Can18 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS18     5
`endif
`ifdef SPI_MAX_CHAR_2418
  `define SPI_MAX_CHAR18          24   // Can18 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS18     5
`endif
`ifdef SPI_MAX_CHAR_1618
  `define SPI_MAX_CHAR18          16   // Can18 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS18     4
`endif
`ifdef SPI_MAX_CHAR_818
  `define SPI_MAX_CHAR18          8    // Can18 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS18     3
`endif

//
// Number18 of device18 select18 signals18. Use SPI_SS_NB18 for fine18 tuning18 the 
// exact18 number18.
//
`define SPI_SS_NB_818
//`define SPI_SS_NB_1618
//`define SPI_SS_NB_2418
//`define SPI_SS_NB_3218

`ifdef SPI_SS_NB_818
  `define SPI_SS_NB18             8    // Can18 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1618
  `define SPI_SS_NB18             16   // Can18 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2418
  `define SPI_SS_NB18             24   // Can18 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3218
  `define SPI_SS_NB18             32   // Can18 be set from 25 to 32
`endif

//
// Bits18 of WISHBONE18 address used for partial18 decoding18 of SPI18 registers.
//
`define SPI_OFS_BITS18	          4:2

//
// Register offset
//
`define SPI_RX_018                0
`define SPI_RX_118                1
`define SPI_RX_218                2
`define SPI_RX_318                3
`define SPI_TX_018                0
`define SPI_TX_118                1
`define SPI_TX_218                2
`define SPI_TX_318                3
`define SPI_CTRL18                4
`define SPI_DEVIDE18              5
`define SPI_SS18                  6

//
// Number18 of bits in ctrl18 register
//
`define SPI_CTRL_BIT_NB18         14

//
// Control18 register bit position18
//
`define SPI_CTRL_ASS18            13
`define SPI_CTRL_IE18             12
`define SPI_CTRL_LSB18            11
`define SPI_CTRL_TX_NEGEDGE18     10
`define SPI_CTRL_RX_NEGEDGE18     9
`define SPI_CTRL_GO18             8
`define SPI_CTRL_RES_118          7
`define SPI_CTRL_CHAR_LEN18       6:0

