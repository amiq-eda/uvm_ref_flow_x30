//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define10.v                                                ////
////                                                              ////
////  This10 file is part of the SPI10 IP10 core10 project10                ////
////  http10://www10.opencores10.org10/projects10/spi10/                      ////
////                                                              ////
////  Author10(s):                                                  ////
////      - Simon10 Srot10 (simons10@opencores10.org10)                     ////
////                                                              ////
////  All additional10 information is avaliable10 in the Readme10.txt10   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright10 (C) 2002 Authors10                                   ////
////                                                              ////
//// This10 source10 file may be used and distributed10 without         ////
//// restriction10 provided that this copyright10 statement10 is not    ////
//// removed from the file and that any derivative10 work10 contains10  ////
//// the original copyright10 notice10 and the associated disclaimer10. ////
////                                                              ////
//// This10 source10 file is free software10; you can redistribute10 it   ////
//// and/or modify it under the terms10 of the GNU10 Lesser10 General10   ////
//// Public10 License10 as published10 by the Free10 Software10 Foundation10; ////
//// either10 version10 2.1 of the License10, or (at your10 option) any   ////
//// later10 version10.                                               ////
////                                                              ////
//// This10 source10 is distributed10 in the hope10 that it will be       ////
//// useful10, but WITHOUT10 ANY10 WARRANTY10; without even10 the implied10   ////
//// warranty10 of MERCHANTABILITY10 or FITNESS10 FOR10 A PARTICULAR10      ////
//// PURPOSE10.  See the GNU10 Lesser10 General10 Public10 License10 for more ////
//// details10.                                                     ////
////                                                              ////
//// You should have received10 a copy of the GNU10 Lesser10 General10    ////
//// Public10 License10 along10 with this source10; if not, download10 it   ////
//// from http10://www10.opencores10.org10/lgpl10.shtml10                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number10 of bits used for devider10 register. If10 used in system with
// low10 frequency10 of system clock10 this can be reduced10.
// Use SPI_DIVIDER_LEN10 for fine10 tuning10 theexact10 number10.
//
//`define SPI_DIVIDER_LEN_810
`define SPI_DIVIDER_LEN_1610
//`define SPI_DIVIDER_LEN_2410
//`define SPI_DIVIDER_LEN_3210

`ifdef SPI_DIVIDER_LEN_810
  `define SPI_DIVIDER_LEN10       8    // Can10 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1610                                       
  `define SPI_DIVIDER_LEN10       16   // Can10 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2410                                       
  `define SPI_DIVIDER_LEN10       24   // Can10 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3210                                       
  `define SPI_DIVIDER_LEN10       32   // Can10 be set from 25 to 32 
`endif

//
// Maximum10 nuber10 of bits that can be send/received10 at once10. 
// Use SPI_MAX_CHAR10 for fine10 tuning10 the exact10 number10, when using
// SPI_MAX_CHAR_3210, SPI_MAX_CHAR_2410, SPI_MAX_CHAR_1610, SPI_MAX_CHAR_810.
//
`define SPI_MAX_CHAR_12810
//`define SPI_MAX_CHAR_6410
//`define SPI_MAX_CHAR_3210
//`define SPI_MAX_CHAR_2410
//`define SPI_MAX_CHAR_1610
//`define SPI_MAX_CHAR_810

`ifdef SPI_MAX_CHAR_12810
  `define SPI_MAX_CHAR10          128  // Can10 only be set to 128 
  `define SPI_CHAR_LEN_BITS10     7
`endif
`ifdef SPI_MAX_CHAR_6410
  `define SPI_MAX_CHAR10          64   // Can10 only be set to 64 
  `define SPI_CHAR_LEN_BITS10     6
`endif
`ifdef SPI_MAX_CHAR_3210
  `define SPI_MAX_CHAR10          32   // Can10 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS10     5
`endif
`ifdef SPI_MAX_CHAR_2410
  `define SPI_MAX_CHAR10          24   // Can10 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS10     5
`endif
`ifdef SPI_MAX_CHAR_1610
  `define SPI_MAX_CHAR10          16   // Can10 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS10     4
`endif
`ifdef SPI_MAX_CHAR_810
  `define SPI_MAX_CHAR10          8    // Can10 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS10     3
`endif

//
// Number10 of device10 select10 signals10. Use SPI_SS_NB10 for fine10 tuning10 the 
// exact10 number10.
//
`define SPI_SS_NB_810
//`define SPI_SS_NB_1610
//`define SPI_SS_NB_2410
//`define SPI_SS_NB_3210

`ifdef SPI_SS_NB_810
  `define SPI_SS_NB10             8    // Can10 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1610
  `define SPI_SS_NB10             16   // Can10 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2410
  `define SPI_SS_NB10             24   // Can10 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3210
  `define SPI_SS_NB10             32   // Can10 be set from 25 to 32
`endif

//
// Bits10 of WISHBONE10 address used for partial10 decoding10 of SPI10 registers.
//
`define SPI_OFS_BITS10	          4:2

//
// Register offset
//
`define SPI_RX_010                0
`define SPI_RX_110                1
`define SPI_RX_210                2
`define SPI_RX_310                3
`define SPI_TX_010                0
`define SPI_TX_110                1
`define SPI_TX_210                2
`define SPI_TX_310                3
`define SPI_CTRL10                4
`define SPI_DEVIDE10              5
`define SPI_SS10                  6

//
// Number10 of bits in ctrl10 register
//
`define SPI_CTRL_BIT_NB10         14

//
// Control10 register bit position10
//
`define SPI_CTRL_ASS10            13
`define SPI_CTRL_IE10             12
`define SPI_CTRL_LSB10            11
`define SPI_CTRL_TX_NEGEDGE10     10
`define SPI_CTRL_RX_NEGEDGE10     9
`define SPI_CTRL_GO10             8
`define SPI_CTRL_RES_110          7
`define SPI_CTRL_CHAR_LEN10       6:0

