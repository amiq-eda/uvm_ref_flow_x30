//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define14.v                                                ////
////                                                              ////
////  This14 file is part of the SPI14 IP14 core14 project14                ////
////  http14://www14.opencores14.org14/projects14/spi14/                      ////
////                                                              ////
////  Author14(s):                                                  ////
////      - Simon14 Srot14 (simons14@opencores14.org14)                     ////
////                                                              ////
////  All additional14 information is avaliable14 in the Readme14.txt14   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright14 (C) 2002 Authors14                                   ////
////                                                              ////
//// This14 source14 file may be used and distributed14 without         ////
//// restriction14 provided that this copyright14 statement14 is not    ////
//// removed from the file and that any derivative14 work14 contains14  ////
//// the original copyright14 notice14 and the associated disclaimer14. ////
////                                                              ////
//// This14 source14 file is free software14; you can redistribute14 it   ////
//// and/or modify it under the terms14 of the GNU14 Lesser14 General14   ////
//// Public14 License14 as published14 by the Free14 Software14 Foundation14; ////
//// either14 version14 2.1 of the License14, or (at your14 option) any   ////
//// later14 version14.                                               ////
////                                                              ////
//// This14 source14 is distributed14 in the hope14 that it will be       ////
//// useful14, but WITHOUT14 ANY14 WARRANTY14; without even14 the implied14   ////
//// warranty14 of MERCHANTABILITY14 or FITNESS14 FOR14 A PARTICULAR14      ////
//// PURPOSE14.  See the GNU14 Lesser14 General14 Public14 License14 for more ////
//// details14.                                                     ////
////                                                              ////
//// You should have received14 a copy of the GNU14 Lesser14 General14    ////
//// Public14 License14 along14 with this source14; if not, download14 it   ////
//// from http14://www14.opencores14.org14/lgpl14.shtml14                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number14 of bits used for devider14 register. If14 used in system with
// low14 frequency14 of system clock14 this can be reduced14.
// Use SPI_DIVIDER_LEN14 for fine14 tuning14 theexact14 number14.
//
//`define SPI_DIVIDER_LEN_814
`define SPI_DIVIDER_LEN_1614
//`define SPI_DIVIDER_LEN_2414
//`define SPI_DIVIDER_LEN_3214

`ifdef SPI_DIVIDER_LEN_814
  `define SPI_DIVIDER_LEN14       8    // Can14 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1614                                       
  `define SPI_DIVIDER_LEN14       16   // Can14 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2414                                       
  `define SPI_DIVIDER_LEN14       24   // Can14 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3214                                       
  `define SPI_DIVIDER_LEN14       32   // Can14 be set from 25 to 32 
`endif

//
// Maximum14 nuber14 of bits that can be send/received14 at once14. 
// Use SPI_MAX_CHAR14 for fine14 tuning14 the exact14 number14, when using
// SPI_MAX_CHAR_3214, SPI_MAX_CHAR_2414, SPI_MAX_CHAR_1614, SPI_MAX_CHAR_814.
//
`define SPI_MAX_CHAR_12814
//`define SPI_MAX_CHAR_6414
//`define SPI_MAX_CHAR_3214
//`define SPI_MAX_CHAR_2414
//`define SPI_MAX_CHAR_1614
//`define SPI_MAX_CHAR_814

`ifdef SPI_MAX_CHAR_12814
  `define SPI_MAX_CHAR14          128  // Can14 only be set to 128 
  `define SPI_CHAR_LEN_BITS14     7
`endif
`ifdef SPI_MAX_CHAR_6414
  `define SPI_MAX_CHAR14          64   // Can14 only be set to 64 
  `define SPI_CHAR_LEN_BITS14     6
`endif
`ifdef SPI_MAX_CHAR_3214
  `define SPI_MAX_CHAR14          32   // Can14 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS14     5
`endif
`ifdef SPI_MAX_CHAR_2414
  `define SPI_MAX_CHAR14          24   // Can14 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS14     5
`endif
`ifdef SPI_MAX_CHAR_1614
  `define SPI_MAX_CHAR14          16   // Can14 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS14     4
`endif
`ifdef SPI_MAX_CHAR_814
  `define SPI_MAX_CHAR14          8    // Can14 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS14     3
`endif

//
// Number14 of device14 select14 signals14. Use SPI_SS_NB14 for fine14 tuning14 the 
// exact14 number14.
//
`define SPI_SS_NB_814
//`define SPI_SS_NB_1614
//`define SPI_SS_NB_2414
//`define SPI_SS_NB_3214

`ifdef SPI_SS_NB_814
  `define SPI_SS_NB14             8    // Can14 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1614
  `define SPI_SS_NB14             16   // Can14 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2414
  `define SPI_SS_NB14             24   // Can14 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3214
  `define SPI_SS_NB14             32   // Can14 be set from 25 to 32
`endif

//
// Bits14 of WISHBONE14 address used for partial14 decoding14 of SPI14 registers.
//
`define SPI_OFS_BITS14	          4:2

//
// Register offset
//
`define SPI_RX_014                0
`define SPI_RX_114                1
`define SPI_RX_214                2
`define SPI_RX_314                3
`define SPI_TX_014                0
`define SPI_TX_114                1
`define SPI_TX_214                2
`define SPI_TX_314                3
`define SPI_CTRL14                4
`define SPI_DEVIDE14              5
`define SPI_SS14                  6

//
// Number14 of bits in ctrl14 register
//
`define SPI_CTRL_BIT_NB14         14

//
// Control14 register bit position14
//
`define SPI_CTRL_ASS14            13
`define SPI_CTRL_IE14             12
`define SPI_CTRL_LSB14            11
`define SPI_CTRL_TX_NEGEDGE14     10
`define SPI_CTRL_RX_NEGEDGE14     9
`define SPI_CTRL_GO14             8
`define SPI_CTRL_RES_114          7
`define SPI_CTRL_CHAR_LEN14       6:0

