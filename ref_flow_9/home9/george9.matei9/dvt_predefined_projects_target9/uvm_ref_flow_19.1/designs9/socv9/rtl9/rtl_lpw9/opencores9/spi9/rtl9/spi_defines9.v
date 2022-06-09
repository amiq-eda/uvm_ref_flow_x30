//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define9.v                                                ////
////                                                              ////
////  This9 file is part of the SPI9 IP9 core9 project9                ////
////  http9://www9.opencores9.org9/projects9/spi9/                      ////
////                                                              ////
////  Author9(s):                                                  ////
////      - Simon9 Srot9 (simons9@opencores9.org9)                     ////
////                                                              ////
////  All additional9 information is avaliable9 in the Readme9.txt9   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright9 (C) 2002 Authors9                                   ////
////                                                              ////
//// This9 source9 file may be used and distributed9 without         ////
//// restriction9 provided that this copyright9 statement9 is not    ////
//// removed from the file and that any derivative9 work9 contains9  ////
//// the original copyright9 notice9 and the associated disclaimer9. ////
////                                                              ////
//// This9 source9 file is free software9; you can redistribute9 it   ////
//// and/or modify it under the terms9 of the GNU9 Lesser9 General9   ////
//// Public9 License9 as published9 by the Free9 Software9 Foundation9; ////
//// either9 version9 2.1 of the License9, or (at your9 option) any   ////
//// later9 version9.                                               ////
////                                                              ////
//// This9 source9 is distributed9 in the hope9 that it will be       ////
//// useful9, but WITHOUT9 ANY9 WARRANTY9; without even9 the implied9   ////
//// warranty9 of MERCHANTABILITY9 or FITNESS9 FOR9 A PARTICULAR9      ////
//// PURPOSE9.  See the GNU9 Lesser9 General9 Public9 License9 for more ////
//// details9.                                                     ////
////                                                              ////
//// You should have received9 a copy of the GNU9 Lesser9 General9    ////
//// Public9 License9 along9 with this source9; if not, download9 it   ////
//// from http9://www9.opencores9.org9/lgpl9.shtml9                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number9 of bits used for devider9 register. If9 used in system with
// low9 frequency9 of system clock9 this can be reduced9.
// Use SPI_DIVIDER_LEN9 for fine9 tuning9 theexact9 number9.
//
//`define SPI_DIVIDER_LEN_89
`define SPI_DIVIDER_LEN_169
//`define SPI_DIVIDER_LEN_249
//`define SPI_DIVIDER_LEN_329

`ifdef SPI_DIVIDER_LEN_89
  `define SPI_DIVIDER_LEN9       8    // Can9 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_169                                       
  `define SPI_DIVIDER_LEN9       16   // Can9 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_249                                       
  `define SPI_DIVIDER_LEN9       24   // Can9 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_329                                       
  `define SPI_DIVIDER_LEN9       32   // Can9 be set from 25 to 32 
`endif

//
// Maximum9 nuber9 of bits that can be send/received9 at once9. 
// Use SPI_MAX_CHAR9 for fine9 tuning9 the exact9 number9, when using
// SPI_MAX_CHAR_329, SPI_MAX_CHAR_249, SPI_MAX_CHAR_169, SPI_MAX_CHAR_89.
//
`define SPI_MAX_CHAR_1289
//`define SPI_MAX_CHAR_649
//`define SPI_MAX_CHAR_329
//`define SPI_MAX_CHAR_249
//`define SPI_MAX_CHAR_169
//`define SPI_MAX_CHAR_89

`ifdef SPI_MAX_CHAR_1289
  `define SPI_MAX_CHAR9          128  // Can9 only be set to 128 
  `define SPI_CHAR_LEN_BITS9     7
`endif
`ifdef SPI_MAX_CHAR_649
  `define SPI_MAX_CHAR9          64   // Can9 only be set to 64 
  `define SPI_CHAR_LEN_BITS9     6
`endif
`ifdef SPI_MAX_CHAR_329
  `define SPI_MAX_CHAR9          32   // Can9 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS9     5
`endif
`ifdef SPI_MAX_CHAR_249
  `define SPI_MAX_CHAR9          24   // Can9 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS9     5
`endif
`ifdef SPI_MAX_CHAR_169
  `define SPI_MAX_CHAR9          16   // Can9 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS9     4
`endif
`ifdef SPI_MAX_CHAR_89
  `define SPI_MAX_CHAR9          8    // Can9 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS9     3
`endif

//
// Number9 of device9 select9 signals9. Use SPI_SS_NB9 for fine9 tuning9 the 
// exact9 number9.
//
`define SPI_SS_NB_89
//`define SPI_SS_NB_169
//`define SPI_SS_NB_249
//`define SPI_SS_NB_329

`ifdef SPI_SS_NB_89
  `define SPI_SS_NB9             8    // Can9 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_169
  `define SPI_SS_NB9             16   // Can9 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_249
  `define SPI_SS_NB9             24   // Can9 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_329
  `define SPI_SS_NB9             32   // Can9 be set from 25 to 32
`endif

//
// Bits9 of WISHBONE9 address used for partial9 decoding9 of SPI9 registers.
//
`define SPI_OFS_BITS9	          4:2

//
// Register offset
//
`define SPI_RX_09                0
`define SPI_RX_19                1
`define SPI_RX_29                2
`define SPI_RX_39                3
`define SPI_TX_09                0
`define SPI_TX_19                1
`define SPI_TX_29                2
`define SPI_TX_39                3
`define SPI_CTRL9                4
`define SPI_DEVIDE9              5
`define SPI_SS9                  6

//
// Number9 of bits in ctrl9 register
//
`define SPI_CTRL_BIT_NB9         14

//
// Control9 register bit position9
//
`define SPI_CTRL_ASS9            13
`define SPI_CTRL_IE9             12
`define SPI_CTRL_LSB9            11
`define SPI_CTRL_TX_NEGEDGE9     10
`define SPI_CTRL_RX_NEGEDGE9     9
`define SPI_CTRL_GO9             8
`define SPI_CTRL_RES_19          7
`define SPI_CTRL_CHAR_LEN9       6:0

