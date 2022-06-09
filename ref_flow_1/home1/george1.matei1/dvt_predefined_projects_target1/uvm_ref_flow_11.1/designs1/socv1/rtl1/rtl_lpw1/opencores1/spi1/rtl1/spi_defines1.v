//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define1.v                                                ////
////                                                              ////
////  This1 file is part of the SPI1 IP1 core1 project1                ////
////  http1://www1.opencores1.org1/projects1/spi1/                      ////
////                                                              ////
////  Author1(s):                                                  ////
////      - Simon1 Srot1 (simons1@opencores1.org1)                     ////
////                                                              ////
////  All additional1 information is avaliable1 in the Readme1.txt1   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright1 (C) 2002 Authors1                                   ////
////                                                              ////
//// This1 source1 file may be used and distributed1 without         ////
//// restriction1 provided that this copyright1 statement1 is not    ////
//// removed from the file and that any derivative1 work1 contains1  ////
//// the original copyright1 notice1 and the associated disclaimer1. ////
////                                                              ////
//// This1 source1 file is free software1; you can redistribute1 it   ////
//// and/or modify it under the terms1 of the GNU1 Lesser1 General1   ////
//// Public1 License1 as published1 by the Free1 Software1 Foundation1; ////
//// either1 version1 2.1 of the License1, or (at your1 option) any   ////
//// later1 version1.                                               ////
////                                                              ////
//// This1 source1 is distributed1 in the hope1 that it will be       ////
//// useful1, but WITHOUT1 ANY1 WARRANTY1; without even1 the implied1   ////
//// warranty1 of MERCHANTABILITY1 or FITNESS1 FOR1 A PARTICULAR1      ////
//// PURPOSE1.  See the GNU1 Lesser1 General1 Public1 License1 for more ////
//// details1.                                                     ////
////                                                              ////
//// You should have received1 a copy of the GNU1 Lesser1 General1    ////
//// Public1 License1 along1 with this source1; if not, download1 it   ////
//// from http1://www1.opencores1.org1/lgpl1.shtml1                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number1 of bits used for devider1 register. If1 used in system with
// low1 frequency1 of system clock1 this can be reduced1.
// Use SPI_DIVIDER_LEN1 for fine1 tuning1 theexact1 number1.
//
//`define SPI_DIVIDER_LEN_81
`define SPI_DIVIDER_LEN_161
//`define SPI_DIVIDER_LEN_241
//`define SPI_DIVIDER_LEN_321

`ifdef SPI_DIVIDER_LEN_81
  `define SPI_DIVIDER_LEN1       8    // Can1 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_161                                       
  `define SPI_DIVIDER_LEN1       16   // Can1 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_241                                       
  `define SPI_DIVIDER_LEN1       24   // Can1 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_321                                       
  `define SPI_DIVIDER_LEN1       32   // Can1 be set from 25 to 32 
`endif

//
// Maximum1 nuber1 of bits that can be send/received1 at once1. 
// Use SPI_MAX_CHAR1 for fine1 tuning1 the exact1 number1, when using
// SPI_MAX_CHAR_321, SPI_MAX_CHAR_241, SPI_MAX_CHAR_161, SPI_MAX_CHAR_81.
//
`define SPI_MAX_CHAR_1281
//`define SPI_MAX_CHAR_641
//`define SPI_MAX_CHAR_321
//`define SPI_MAX_CHAR_241
//`define SPI_MAX_CHAR_161
//`define SPI_MAX_CHAR_81

`ifdef SPI_MAX_CHAR_1281
  `define SPI_MAX_CHAR1          128  // Can1 only be set to 128 
  `define SPI_CHAR_LEN_BITS1     7
`endif
`ifdef SPI_MAX_CHAR_641
  `define SPI_MAX_CHAR1          64   // Can1 only be set to 64 
  `define SPI_CHAR_LEN_BITS1     6
`endif
`ifdef SPI_MAX_CHAR_321
  `define SPI_MAX_CHAR1          32   // Can1 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS1     5
`endif
`ifdef SPI_MAX_CHAR_241
  `define SPI_MAX_CHAR1          24   // Can1 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS1     5
`endif
`ifdef SPI_MAX_CHAR_161
  `define SPI_MAX_CHAR1          16   // Can1 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS1     4
`endif
`ifdef SPI_MAX_CHAR_81
  `define SPI_MAX_CHAR1          8    // Can1 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS1     3
`endif

//
// Number1 of device1 select1 signals1. Use SPI_SS_NB1 for fine1 tuning1 the 
// exact1 number1.
//
`define SPI_SS_NB_81
//`define SPI_SS_NB_161
//`define SPI_SS_NB_241
//`define SPI_SS_NB_321

`ifdef SPI_SS_NB_81
  `define SPI_SS_NB1             8    // Can1 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_161
  `define SPI_SS_NB1             16   // Can1 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_241
  `define SPI_SS_NB1             24   // Can1 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_321
  `define SPI_SS_NB1             32   // Can1 be set from 25 to 32
`endif

//
// Bits1 of WISHBONE1 address used for partial1 decoding1 of SPI1 registers.
//
`define SPI_OFS_BITS1	          4:2

//
// Register offset
//
`define SPI_RX_01                0
`define SPI_RX_11                1
`define SPI_RX_21                2
`define SPI_RX_31                3
`define SPI_TX_01                0
`define SPI_TX_11                1
`define SPI_TX_21                2
`define SPI_TX_31                3
`define SPI_CTRL1                4
`define SPI_DEVIDE1              5
`define SPI_SS1                  6

//
// Number1 of bits in ctrl1 register
//
`define SPI_CTRL_BIT_NB1         14

//
// Control1 register bit position1
//
`define SPI_CTRL_ASS1            13
`define SPI_CTRL_IE1             12
`define SPI_CTRL_LSB1            11
`define SPI_CTRL_TX_NEGEDGE1     10
`define SPI_CTRL_RX_NEGEDGE1     9
`define SPI_CTRL_GO1             8
`define SPI_CTRL_RES_11          7
`define SPI_CTRL_CHAR_LEN1       6:0

