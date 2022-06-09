//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define2.v                                                ////
////                                                              ////
////  This2 file is part of the SPI2 IP2 core2 project2                ////
////  http2://www2.opencores2.org2/projects2/spi2/                      ////
////                                                              ////
////  Author2(s):                                                  ////
////      - Simon2 Srot2 (simons2@opencores2.org2)                     ////
////                                                              ////
////  All additional2 information is avaliable2 in the Readme2.txt2   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright2 (C) 2002 Authors2                                   ////
////                                                              ////
//// This2 source2 file may be used and distributed2 without         ////
//// restriction2 provided that this copyright2 statement2 is not    ////
//// removed from the file and that any derivative2 work2 contains2  ////
//// the original copyright2 notice2 and the associated disclaimer2. ////
////                                                              ////
//// This2 source2 file is free software2; you can redistribute2 it   ////
//// and/or modify it under the terms2 of the GNU2 Lesser2 General2   ////
//// Public2 License2 as published2 by the Free2 Software2 Foundation2; ////
//// either2 version2 2.1 of the License2, or (at your2 option) any   ////
//// later2 version2.                                               ////
////                                                              ////
//// This2 source2 is distributed2 in the hope2 that it will be       ////
//// useful2, but WITHOUT2 ANY2 WARRANTY2; without even2 the implied2   ////
//// warranty2 of MERCHANTABILITY2 or FITNESS2 FOR2 A PARTICULAR2      ////
//// PURPOSE2.  See the GNU2 Lesser2 General2 Public2 License2 for more ////
//// details2.                                                     ////
////                                                              ////
//// You should have received2 a copy of the GNU2 Lesser2 General2    ////
//// Public2 License2 along2 with this source2; if not, download2 it   ////
//// from http2://www2.opencores2.org2/lgpl2.shtml2                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number2 of bits used for devider2 register. If2 used in system with
// low2 frequency2 of system clock2 this can be reduced2.
// Use SPI_DIVIDER_LEN2 for fine2 tuning2 theexact2 number2.
//
//`define SPI_DIVIDER_LEN_82
`define SPI_DIVIDER_LEN_162
//`define SPI_DIVIDER_LEN_242
//`define SPI_DIVIDER_LEN_322

`ifdef SPI_DIVIDER_LEN_82
  `define SPI_DIVIDER_LEN2       8    // Can2 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_162                                       
  `define SPI_DIVIDER_LEN2       16   // Can2 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_242                                       
  `define SPI_DIVIDER_LEN2       24   // Can2 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_322                                       
  `define SPI_DIVIDER_LEN2       32   // Can2 be set from 25 to 32 
`endif

//
// Maximum2 nuber2 of bits that can be send/received2 at once2. 
// Use SPI_MAX_CHAR2 for fine2 tuning2 the exact2 number2, when using
// SPI_MAX_CHAR_322, SPI_MAX_CHAR_242, SPI_MAX_CHAR_162, SPI_MAX_CHAR_82.
//
`define SPI_MAX_CHAR_1282
//`define SPI_MAX_CHAR_642
//`define SPI_MAX_CHAR_322
//`define SPI_MAX_CHAR_242
//`define SPI_MAX_CHAR_162
//`define SPI_MAX_CHAR_82

`ifdef SPI_MAX_CHAR_1282
  `define SPI_MAX_CHAR2          128  // Can2 only be set to 128 
  `define SPI_CHAR_LEN_BITS2     7
`endif
`ifdef SPI_MAX_CHAR_642
  `define SPI_MAX_CHAR2          64   // Can2 only be set to 64 
  `define SPI_CHAR_LEN_BITS2     6
`endif
`ifdef SPI_MAX_CHAR_322
  `define SPI_MAX_CHAR2          32   // Can2 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS2     5
`endif
`ifdef SPI_MAX_CHAR_242
  `define SPI_MAX_CHAR2          24   // Can2 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS2     5
`endif
`ifdef SPI_MAX_CHAR_162
  `define SPI_MAX_CHAR2          16   // Can2 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS2     4
`endif
`ifdef SPI_MAX_CHAR_82
  `define SPI_MAX_CHAR2          8    // Can2 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS2     3
`endif

//
// Number2 of device2 select2 signals2. Use SPI_SS_NB2 for fine2 tuning2 the 
// exact2 number2.
//
`define SPI_SS_NB_82
//`define SPI_SS_NB_162
//`define SPI_SS_NB_242
//`define SPI_SS_NB_322

`ifdef SPI_SS_NB_82
  `define SPI_SS_NB2             8    // Can2 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_162
  `define SPI_SS_NB2             16   // Can2 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_242
  `define SPI_SS_NB2             24   // Can2 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_322
  `define SPI_SS_NB2             32   // Can2 be set from 25 to 32
`endif

//
// Bits2 of WISHBONE2 address used for partial2 decoding2 of SPI2 registers.
//
`define SPI_OFS_BITS2	          4:2

//
// Register offset
//
`define SPI_RX_02                0
`define SPI_RX_12                1
`define SPI_RX_22                2
`define SPI_RX_32                3
`define SPI_TX_02                0
`define SPI_TX_12                1
`define SPI_TX_22                2
`define SPI_TX_32                3
`define SPI_CTRL2                4
`define SPI_DEVIDE2              5
`define SPI_SS2                  6

//
// Number2 of bits in ctrl2 register
//
`define SPI_CTRL_BIT_NB2         14

//
// Control2 register bit position2
//
`define SPI_CTRL_ASS2            13
`define SPI_CTRL_IE2             12
`define SPI_CTRL_LSB2            11
`define SPI_CTRL_TX_NEGEDGE2     10
`define SPI_CTRL_RX_NEGEDGE2     9
`define SPI_CTRL_GO2             8
`define SPI_CTRL_RES_12          7
`define SPI_CTRL_CHAR_LEN2       6:0

