//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define27.v                                                ////
////                                                              ////
////  This27 file is part of the SPI27 IP27 core27 project27                ////
////  http27://www27.opencores27.org27/projects27/spi27/                      ////
////                                                              ////
////  Author27(s):                                                  ////
////      - Simon27 Srot27 (simons27@opencores27.org27)                     ////
////                                                              ////
////  All additional27 information is avaliable27 in the Readme27.txt27   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright27 (C) 2002 Authors27                                   ////
////                                                              ////
//// This27 source27 file may be used and distributed27 without         ////
//// restriction27 provided that this copyright27 statement27 is not    ////
//// removed from the file and that any derivative27 work27 contains27  ////
//// the original copyright27 notice27 and the associated disclaimer27. ////
////                                                              ////
//// This27 source27 file is free software27; you can redistribute27 it   ////
//// and/or modify it under the terms27 of the GNU27 Lesser27 General27   ////
//// Public27 License27 as published27 by the Free27 Software27 Foundation27; ////
//// either27 version27 2.1 of the License27, or (at your27 option) any   ////
//// later27 version27.                                               ////
////                                                              ////
//// This27 source27 is distributed27 in the hope27 that it will be       ////
//// useful27, but WITHOUT27 ANY27 WARRANTY27; without even27 the implied27   ////
//// warranty27 of MERCHANTABILITY27 or FITNESS27 FOR27 A PARTICULAR27      ////
//// PURPOSE27.  See the GNU27 Lesser27 General27 Public27 License27 for more ////
//// details27.                                                     ////
////                                                              ////
//// You should have received27 a copy of the GNU27 Lesser27 General27    ////
//// Public27 License27 along27 with this source27; if not, download27 it   ////
//// from http27://www27.opencores27.org27/lgpl27.shtml27                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number27 of bits used for devider27 register. If27 used in system with
// low27 frequency27 of system clock27 this can be reduced27.
// Use SPI_DIVIDER_LEN27 for fine27 tuning27 theexact27 number27.
//
//`define SPI_DIVIDER_LEN_827
`define SPI_DIVIDER_LEN_1627
//`define SPI_DIVIDER_LEN_2427
//`define SPI_DIVIDER_LEN_3227

`ifdef SPI_DIVIDER_LEN_827
  `define SPI_DIVIDER_LEN27       8    // Can27 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1627                                       
  `define SPI_DIVIDER_LEN27       16   // Can27 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2427                                       
  `define SPI_DIVIDER_LEN27       24   // Can27 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3227                                       
  `define SPI_DIVIDER_LEN27       32   // Can27 be set from 25 to 32 
`endif

//
// Maximum27 nuber27 of bits that can be send/received27 at once27. 
// Use SPI_MAX_CHAR27 for fine27 tuning27 the exact27 number27, when using
// SPI_MAX_CHAR_3227, SPI_MAX_CHAR_2427, SPI_MAX_CHAR_1627, SPI_MAX_CHAR_827.
//
`define SPI_MAX_CHAR_12827
//`define SPI_MAX_CHAR_6427
//`define SPI_MAX_CHAR_3227
//`define SPI_MAX_CHAR_2427
//`define SPI_MAX_CHAR_1627
//`define SPI_MAX_CHAR_827

`ifdef SPI_MAX_CHAR_12827
  `define SPI_MAX_CHAR27          128  // Can27 only be set to 128 
  `define SPI_CHAR_LEN_BITS27     7
`endif
`ifdef SPI_MAX_CHAR_6427
  `define SPI_MAX_CHAR27          64   // Can27 only be set to 64 
  `define SPI_CHAR_LEN_BITS27     6
`endif
`ifdef SPI_MAX_CHAR_3227
  `define SPI_MAX_CHAR27          32   // Can27 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS27     5
`endif
`ifdef SPI_MAX_CHAR_2427
  `define SPI_MAX_CHAR27          24   // Can27 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS27     5
`endif
`ifdef SPI_MAX_CHAR_1627
  `define SPI_MAX_CHAR27          16   // Can27 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS27     4
`endif
`ifdef SPI_MAX_CHAR_827
  `define SPI_MAX_CHAR27          8    // Can27 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS27     3
`endif

//
// Number27 of device27 select27 signals27. Use SPI_SS_NB27 for fine27 tuning27 the 
// exact27 number27.
//
`define SPI_SS_NB_827
//`define SPI_SS_NB_1627
//`define SPI_SS_NB_2427
//`define SPI_SS_NB_3227

`ifdef SPI_SS_NB_827
  `define SPI_SS_NB27             8    // Can27 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1627
  `define SPI_SS_NB27             16   // Can27 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2427
  `define SPI_SS_NB27             24   // Can27 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3227
  `define SPI_SS_NB27             32   // Can27 be set from 25 to 32
`endif

//
// Bits27 of WISHBONE27 address used for partial27 decoding27 of SPI27 registers.
//
`define SPI_OFS_BITS27	          4:2

//
// Register offset
//
`define SPI_RX_027                0
`define SPI_RX_127                1
`define SPI_RX_227                2
`define SPI_RX_327                3
`define SPI_TX_027                0
`define SPI_TX_127                1
`define SPI_TX_227                2
`define SPI_TX_327                3
`define SPI_CTRL27                4
`define SPI_DEVIDE27              5
`define SPI_SS27                  6

//
// Number27 of bits in ctrl27 register
//
`define SPI_CTRL_BIT_NB27         14

//
// Control27 register bit position27
//
`define SPI_CTRL_ASS27            13
`define SPI_CTRL_IE27             12
`define SPI_CTRL_LSB27            11
`define SPI_CTRL_TX_NEGEDGE27     10
`define SPI_CTRL_RX_NEGEDGE27     9
`define SPI_CTRL_GO27             8
`define SPI_CTRL_RES_127          7
`define SPI_CTRL_CHAR_LEN27       6:0

