//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define4.v                                                ////
////                                                              ////
////  This4 file is part of the SPI4 IP4 core4 project4                ////
////  http4://www4.opencores4.org4/projects4/spi4/                      ////
////                                                              ////
////  Author4(s):                                                  ////
////      - Simon4 Srot4 (simons4@opencores4.org4)                     ////
////                                                              ////
////  All additional4 information is avaliable4 in the Readme4.txt4   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright4 (C) 2002 Authors4                                   ////
////                                                              ////
//// This4 source4 file may be used and distributed4 without         ////
//// restriction4 provided that this copyright4 statement4 is not    ////
//// removed from the file and that any derivative4 work4 contains4  ////
//// the original copyright4 notice4 and the associated disclaimer4. ////
////                                                              ////
//// This4 source4 file is free software4; you can redistribute4 it   ////
//// and/or modify it under the terms4 of the GNU4 Lesser4 General4   ////
//// Public4 License4 as published4 by the Free4 Software4 Foundation4; ////
//// either4 version4 2.1 of the License4, or (at your4 option) any   ////
//// later4 version4.                                               ////
////                                                              ////
//// This4 source4 is distributed4 in the hope4 that it will be       ////
//// useful4, but WITHOUT4 ANY4 WARRANTY4; without even4 the implied4   ////
//// warranty4 of MERCHANTABILITY4 or FITNESS4 FOR4 A PARTICULAR4      ////
//// PURPOSE4.  See the GNU4 Lesser4 General4 Public4 License4 for more ////
//// details4.                                                     ////
////                                                              ////
//// You should have received4 a copy of the GNU4 Lesser4 General4    ////
//// Public4 License4 along4 with this source4; if not, download4 it   ////
//// from http4://www4.opencores4.org4/lgpl4.shtml4                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number4 of bits used for devider4 register. If4 used in system with
// low4 frequency4 of system clock4 this can be reduced4.
// Use SPI_DIVIDER_LEN4 for fine4 tuning4 theexact4 number4.
//
//`define SPI_DIVIDER_LEN_84
`define SPI_DIVIDER_LEN_164
//`define SPI_DIVIDER_LEN_244
//`define SPI_DIVIDER_LEN_324

`ifdef SPI_DIVIDER_LEN_84
  `define SPI_DIVIDER_LEN4       8    // Can4 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_164                                       
  `define SPI_DIVIDER_LEN4       16   // Can4 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_244                                       
  `define SPI_DIVIDER_LEN4       24   // Can4 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_324                                       
  `define SPI_DIVIDER_LEN4       32   // Can4 be set from 25 to 32 
`endif

//
// Maximum4 nuber4 of bits that can be send/received4 at once4. 
// Use SPI_MAX_CHAR4 for fine4 tuning4 the exact4 number4, when using
// SPI_MAX_CHAR_324, SPI_MAX_CHAR_244, SPI_MAX_CHAR_164, SPI_MAX_CHAR_84.
//
`define SPI_MAX_CHAR_1284
//`define SPI_MAX_CHAR_644
//`define SPI_MAX_CHAR_324
//`define SPI_MAX_CHAR_244
//`define SPI_MAX_CHAR_164
//`define SPI_MAX_CHAR_84

`ifdef SPI_MAX_CHAR_1284
  `define SPI_MAX_CHAR4          128  // Can4 only be set to 128 
  `define SPI_CHAR_LEN_BITS4     7
`endif
`ifdef SPI_MAX_CHAR_644
  `define SPI_MAX_CHAR4          64   // Can4 only be set to 64 
  `define SPI_CHAR_LEN_BITS4     6
`endif
`ifdef SPI_MAX_CHAR_324
  `define SPI_MAX_CHAR4          32   // Can4 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS4     5
`endif
`ifdef SPI_MAX_CHAR_244
  `define SPI_MAX_CHAR4          24   // Can4 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS4     5
`endif
`ifdef SPI_MAX_CHAR_164
  `define SPI_MAX_CHAR4          16   // Can4 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS4     4
`endif
`ifdef SPI_MAX_CHAR_84
  `define SPI_MAX_CHAR4          8    // Can4 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS4     3
`endif

//
// Number4 of device4 select4 signals4. Use SPI_SS_NB4 for fine4 tuning4 the 
// exact4 number4.
//
`define SPI_SS_NB_84
//`define SPI_SS_NB_164
//`define SPI_SS_NB_244
//`define SPI_SS_NB_324

`ifdef SPI_SS_NB_84
  `define SPI_SS_NB4             8    // Can4 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_164
  `define SPI_SS_NB4             16   // Can4 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_244
  `define SPI_SS_NB4             24   // Can4 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_324
  `define SPI_SS_NB4             32   // Can4 be set from 25 to 32
`endif

//
// Bits4 of WISHBONE4 address used for partial4 decoding4 of SPI4 registers.
//
`define SPI_OFS_BITS4	          4:2

//
// Register offset
//
`define SPI_RX_04                0
`define SPI_RX_14                1
`define SPI_RX_24                2
`define SPI_RX_34                3
`define SPI_TX_04                0
`define SPI_TX_14                1
`define SPI_TX_24                2
`define SPI_TX_34                3
`define SPI_CTRL4                4
`define SPI_DEVIDE4              5
`define SPI_SS4                  6

//
// Number4 of bits in ctrl4 register
//
`define SPI_CTRL_BIT_NB4         14

//
// Control4 register bit position4
//
`define SPI_CTRL_ASS4            13
`define SPI_CTRL_IE4             12
`define SPI_CTRL_LSB4            11
`define SPI_CTRL_TX_NEGEDGE4     10
`define SPI_CTRL_RX_NEGEDGE4     9
`define SPI_CTRL_GO4             8
`define SPI_CTRL_RES_14          7
`define SPI_CTRL_CHAR_LEN4       6:0

