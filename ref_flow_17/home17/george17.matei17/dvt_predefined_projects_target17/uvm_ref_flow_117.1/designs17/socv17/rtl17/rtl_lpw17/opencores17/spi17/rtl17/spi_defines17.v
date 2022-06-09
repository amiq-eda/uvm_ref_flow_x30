//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define17.v                                                ////
////                                                              ////
////  This17 file is part of the SPI17 IP17 core17 project17                ////
////  http17://www17.opencores17.org17/projects17/spi17/                      ////
////                                                              ////
////  Author17(s):                                                  ////
////      - Simon17 Srot17 (simons17@opencores17.org17)                     ////
////                                                              ////
////  All additional17 information is avaliable17 in the Readme17.txt17   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright17 (C) 2002 Authors17                                   ////
////                                                              ////
//// This17 source17 file may be used and distributed17 without         ////
//// restriction17 provided that this copyright17 statement17 is not    ////
//// removed from the file and that any derivative17 work17 contains17  ////
//// the original copyright17 notice17 and the associated disclaimer17. ////
////                                                              ////
//// This17 source17 file is free software17; you can redistribute17 it   ////
//// and/or modify it under the terms17 of the GNU17 Lesser17 General17   ////
//// Public17 License17 as published17 by the Free17 Software17 Foundation17; ////
//// either17 version17 2.1 of the License17, or (at your17 option) any   ////
//// later17 version17.                                               ////
////                                                              ////
//// This17 source17 is distributed17 in the hope17 that it will be       ////
//// useful17, but WITHOUT17 ANY17 WARRANTY17; without even17 the implied17   ////
//// warranty17 of MERCHANTABILITY17 or FITNESS17 FOR17 A PARTICULAR17      ////
//// PURPOSE17.  See the GNU17 Lesser17 General17 Public17 License17 for more ////
//// details17.                                                     ////
////                                                              ////
//// You should have received17 a copy of the GNU17 Lesser17 General17    ////
//// Public17 License17 along17 with this source17; if not, download17 it   ////
//// from http17://www17.opencores17.org17/lgpl17.shtml17                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number17 of bits used for devider17 register. If17 used in system with
// low17 frequency17 of system clock17 this can be reduced17.
// Use SPI_DIVIDER_LEN17 for fine17 tuning17 theexact17 number17.
//
//`define SPI_DIVIDER_LEN_817
`define SPI_DIVIDER_LEN_1617
//`define SPI_DIVIDER_LEN_2417
//`define SPI_DIVIDER_LEN_3217

`ifdef SPI_DIVIDER_LEN_817
  `define SPI_DIVIDER_LEN17       8    // Can17 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1617                                       
  `define SPI_DIVIDER_LEN17       16   // Can17 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2417                                       
  `define SPI_DIVIDER_LEN17       24   // Can17 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3217                                       
  `define SPI_DIVIDER_LEN17       32   // Can17 be set from 25 to 32 
`endif

//
// Maximum17 nuber17 of bits that can be send/received17 at once17. 
// Use SPI_MAX_CHAR17 for fine17 tuning17 the exact17 number17, when using
// SPI_MAX_CHAR_3217, SPI_MAX_CHAR_2417, SPI_MAX_CHAR_1617, SPI_MAX_CHAR_817.
//
`define SPI_MAX_CHAR_12817
//`define SPI_MAX_CHAR_6417
//`define SPI_MAX_CHAR_3217
//`define SPI_MAX_CHAR_2417
//`define SPI_MAX_CHAR_1617
//`define SPI_MAX_CHAR_817

`ifdef SPI_MAX_CHAR_12817
  `define SPI_MAX_CHAR17          128  // Can17 only be set to 128 
  `define SPI_CHAR_LEN_BITS17     7
`endif
`ifdef SPI_MAX_CHAR_6417
  `define SPI_MAX_CHAR17          64   // Can17 only be set to 64 
  `define SPI_CHAR_LEN_BITS17     6
`endif
`ifdef SPI_MAX_CHAR_3217
  `define SPI_MAX_CHAR17          32   // Can17 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS17     5
`endif
`ifdef SPI_MAX_CHAR_2417
  `define SPI_MAX_CHAR17          24   // Can17 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS17     5
`endif
`ifdef SPI_MAX_CHAR_1617
  `define SPI_MAX_CHAR17          16   // Can17 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS17     4
`endif
`ifdef SPI_MAX_CHAR_817
  `define SPI_MAX_CHAR17          8    // Can17 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS17     3
`endif

//
// Number17 of device17 select17 signals17. Use SPI_SS_NB17 for fine17 tuning17 the 
// exact17 number17.
//
`define SPI_SS_NB_817
//`define SPI_SS_NB_1617
//`define SPI_SS_NB_2417
//`define SPI_SS_NB_3217

`ifdef SPI_SS_NB_817
  `define SPI_SS_NB17             8    // Can17 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1617
  `define SPI_SS_NB17             16   // Can17 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2417
  `define SPI_SS_NB17             24   // Can17 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3217
  `define SPI_SS_NB17             32   // Can17 be set from 25 to 32
`endif

//
// Bits17 of WISHBONE17 address used for partial17 decoding17 of SPI17 registers.
//
`define SPI_OFS_BITS17	          4:2

//
// Register offset
//
`define SPI_RX_017                0
`define SPI_RX_117                1
`define SPI_RX_217                2
`define SPI_RX_317                3
`define SPI_TX_017                0
`define SPI_TX_117                1
`define SPI_TX_217                2
`define SPI_TX_317                3
`define SPI_CTRL17                4
`define SPI_DEVIDE17              5
`define SPI_SS17                  6

//
// Number17 of bits in ctrl17 register
//
`define SPI_CTRL_BIT_NB17         14

//
// Control17 register bit position17
//
`define SPI_CTRL_ASS17            13
`define SPI_CTRL_IE17             12
`define SPI_CTRL_LSB17            11
`define SPI_CTRL_TX_NEGEDGE17     10
`define SPI_CTRL_RX_NEGEDGE17     9
`define SPI_CTRL_GO17             8
`define SPI_CTRL_RES_117          7
`define SPI_CTRL_CHAR_LEN17       6:0

