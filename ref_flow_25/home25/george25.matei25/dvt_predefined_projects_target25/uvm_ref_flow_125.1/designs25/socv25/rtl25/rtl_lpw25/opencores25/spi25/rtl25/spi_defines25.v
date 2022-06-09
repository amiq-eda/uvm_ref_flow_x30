//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define25.v                                                ////
////                                                              ////
////  This25 file is part of the SPI25 IP25 core25 project25                ////
////  http25://www25.opencores25.org25/projects25/spi25/                      ////
////                                                              ////
////  Author25(s):                                                  ////
////      - Simon25 Srot25 (simons25@opencores25.org25)                     ////
////                                                              ////
////  All additional25 information is avaliable25 in the Readme25.txt25   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright25 (C) 2002 Authors25                                   ////
////                                                              ////
//// This25 source25 file may be used and distributed25 without         ////
//// restriction25 provided that this copyright25 statement25 is not    ////
//// removed from the file and that any derivative25 work25 contains25  ////
//// the original copyright25 notice25 and the associated disclaimer25. ////
////                                                              ////
//// This25 source25 file is free software25; you can redistribute25 it   ////
//// and/or modify it under the terms25 of the GNU25 Lesser25 General25   ////
//// Public25 License25 as published25 by the Free25 Software25 Foundation25; ////
//// either25 version25 2.1 of the License25, or (at your25 option) any   ////
//// later25 version25.                                               ////
////                                                              ////
//// This25 source25 is distributed25 in the hope25 that it will be       ////
//// useful25, but WITHOUT25 ANY25 WARRANTY25; without even25 the implied25   ////
//// warranty25 of MERCHANTABILITY25 or FITNESS25 FOR25 A PARTICULAR25      ////
//// PURPOSE25.  See the GNU25 Lesser25 General25 Public25 License25 for more ////
//// details25.                                                     ////
////                                                              ////
//// You should have received25 a copy of the GNU25 Lesser25 General25    ////
//// Public25 License25 along25 with this source25; if not, download25 it   ////
//// from http25://www25.opencores25.org25/lgpl25.shtml25                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number25 of bits used for devider25 register. If25 used in system with
// low25 frequency25 of system clock25 this can be reduced25.
// Use SPI_DIVIDER_LEN25 for fine25 tuning25 theexact25 number25.
//
//`define SPI_DIVIDER_LEN_825
`define SPI_DIVIDER_LEN_1625
//`define SPI_DIVIDER_LEN_2425
//`define SPI_DIVIDER_LEN_3225

`ifdef SPI_DIVIDER_LEN_825
  `define SPI_DIVIDER_LEN25       8    // Can25 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1625                                       
  `define SPI_DIVIDER_LEN25       16   // Can25 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2425                                       
  `define SPI_DIVIDER_LEN25       24   // Can25 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3225                                       
  `define SPI_DIVIDER_LEN25       32   // Can25 be set from 25 to 32 
`endif

//
// Maximum25 nuber25 of bits that can be send/received25 at once25. 
// Use SPI_MAX_CHAR25 for fine25 tuning25 the exact25 number25, when using
// SPI_MAX_CHAR_3225, SPI_MAX_CHAR_2425, SPI_MAX_CHAR_1625, SPI_MAX_CHAR_825.
//
`define SPI_MAX_CHAR_12825
//`define SPI_MAX_CHAR_6425
//`define SPI_MAX_CHAR_3225
//`define SPI_MAX_CHAR_2425
//`define SPI_MAX_CHAR_1625
//`define SPI_MAX_CHAR_825

`ifdef SPI_MAX_CHAR_12825
  `define SPI_MAX_CHAR25          128  // Can25 only be set to 128 
  `define SPI_CHAR_LEN_BITS25     7
`endif
`ifdef SPI_MAX_CHAR_6425
  `define SPI_MAX_CHAR25          64   // Can25 only be set to 64 
  `define SPI_CHAR_LEN_BITS25     6
`endif
`ifdef SPI_MAX_CHAR_3225
  `define SPI_MAX_CHAR25          32   // Can25 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS25     5
`endif
`ifdef SPI_MAX_CHAR_2425
  `define SPI_MAX_CHAR25          24   // Can25 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS25     5
`endif
`ifdef SPI_MAX_CHAR_1625
  `define SPI_MAX_CHAR25          16   // Can25 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS25     4
`endif
`ifdef SPI_MAX_CHAR_825
  `define SPI_MAX_CHAR25          8    // Can25 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS25     3
`endif

//
// Number25 of device25 select25 signals25. Use SPI_SS_NB25 for fine25 tuning25 the 
// exact25 number25.
//
`define SPI_SS_NB_825
//`define SPI_SS_NB_1625
//`define SPI_SS_NB_2425
//`define SPI_SS_NB_3225

`ifdef SPI_SS_NB_825
  `define SPI_SS_NB25             8    // Can25 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1625
  `define SPI_SS_NB25             16   // Can25 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2425
  `define SPI_SS_NB25             24   // Can25 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3225
  `define SPI_SS_NB25             32   // Can25 be set from 25 to 32
`endif

//
// Bits25 of WISHBONE25 address used for partial25 decoding25 of SPI25 registers.
//
`define SPI_OFS_BITS25	          4:2

//
// Register offset
//
`define SPI_RX_025                0
`define SPI_RX_125                1
`define SPI_RX_225                2
`define SPI_RX_325                3
`define SPI_TX_025                0
`define SPI_TX_125                1
`define SPI_TX_225                2
`define SPI_TX_325                3
`define SPI_CTRL25                4
`define SPI_DEVIDE25              5
`define SPI_SS25                  6

//
// Number25 of bits in ctrl25 register
//
`define SPI_CTRL_BIT_NB25         14

//
// Control25 register bit position25
//
`define SPI_CTRL_ASS25            13
`define SPI_CTRL_IE25             12
`define SPI_CTRL_LSB25            11
`define SPI_CTRL_TX_NEGEDGE25     10
`define SPI_CTRL_RX_NEGEDGE25     9
`define SPI_CTRL_GO25             8
`define SPI_CTRL_RES_125          7
`define SPI_CTRL_CHAR_LEN25       6:0

