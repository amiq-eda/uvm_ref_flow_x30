//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define21.v                                                ////
////                                                              ////
////  This21 file is part of the SPI21 IP21 core21 project21                ////
////  http21://www21.opencores21.org21/projects21/spi21/                      ////
////                                                              ////
////  Author21(s):                                                  ////
////      - Simon21 Srot21 (simons21@opencores21.org21)                     ////
////                                                              ////
////  All additional21 information is avaliable21 in the Readme21.txt21   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright21 (C) 2002 Authors21                                   ////
////                                                              ////
//// This21 source21 file may be used and distributed21 without         ////
//// restriction21 provided that this copyright21 statement21 is not    ////
//// removed from the file and that any derivative21 work21 contains21  ////
//// the original copyright21 notice21 and the associated disclaimer21. ////
////                                                              ////
//// This21 source21 file is free software21; you can redistribute21 it   ////
//// and/or modify it under the terms21 of the GNU21 Lesser21 General21   ////
//// Public21 License21 as published21 by the Free21 Software21 Foundation21; ////
//// either21 version21 2.1 of the License21, or (at your21 option) any   ////
//// later21 version21.                                               ////
////                                                              ////
//// This21 source21 is distributed21 in the hope21 that it will be       ////
//// useful21, but WITHOUT21 ANY21 WARRANTY21; without even21 the implied21   ////
//// warranty21 of MERCHANTABILITY21 or FITNESS21 FOR21 A PARTICULAR21      ////
//// PURPOSE21.  See the GNU21 Lesser21 General21 Public21 License21 for more ////
//// details21.                                                     ////
////                                                              ////
//// You should have received21 a copy of the GNU21 Lesser21 General21    ////
//// Public21 License21 along21 with this source21; if not, download21 it   ////
//// from http21://www21.opencores21.org21/lgpl21.shtml21                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number21 of bits used for devider21 register. If21 used in system with
// low21 frequency21 of system clock21 this can be reduced21.
// Use SPI_DIVIDER_LEN21 for fine21 tuning21 theexact21 number21.
//
//`define SPI_DIVIDER_LEN_821
`define SPI_DIVIDER_LEN_1621
//`define SPI_DIVIDER_LEN_2421
//`define SPI_DIVIDER_LEN_3221

`ifdef SPI_DIVIDER_LEN_821
  `define SPI_DIVIDER_LEN21       8    // Can21 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1621                                       
  `define SPI_DIVIDER_LEN21       16   // Can21 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2421                                       
  `define SPI_DIVIDER_LEN21       24   // Can21 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3221                                       
  `define SPI_DIVIDER_LEN21       32   // Can21 be set from 25 to 32 
`endif

//
// Maximum21 nuber21 of bits that can be send/received21 at once21. 
// Use SPI_MAX_CHAR21 for fine21 tuning21 the exact21 number21, when using
// SPI_MAX_CHAR_3221, SPI_MAX_CHAR_2421, SPI_MAX_CHAR_1621, SPI_MAX_CHAR_821.
//
`define SPI_MAX_CHAR_12821
//`define SPI_MAX_CHAR_6421
//`define SPI_MAX_CHAR_3221
//`define SPI_MAX_CHAR_2421
//`define SPI_MAX_CHAR_1621
//`define SPI_MAX_CHAR_821

`ifdef SPI_MAX_CHAR_12821
  `define SPI_MAX_CHAR21          128  // Can21 only be set to 128 
  `define SPI_CHAR_LEN_BITS21     7
`endif
`ifdef SPI_MAX_CHAR_6421
  `define SPI_MAX_CHAR21          64   // Can21 only be set to 64 
  `define SPI_CHAR_LEN_BITS21     6
`endif
`ifdef SPI_MAX_CHAR_3221
  `define SPI_MAX_CHAR21          32   // Can21 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS21     5
`endif
`ifdef SPI_MAX_CHAR_2421
  `define SPI_MAX_CHAR21          24   // Can21 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS21     5
`endif
`ifdef SPI_MAX_CHAR_1621
  `define SPI_MAX_CHAR21          16   // Can21 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS21     4
`endif
`ifdef SPI_MAX_CHAR_821
  `define SPI_MAX_CHAR21          8    // Can21 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS21     3
`endif

//
// Number21 of device21 select21 signals21. Use SPI_SS_NB21 for fine21 tuning21 the 
// exact21 number21.
//
`define SPI_SS_NB_821
//`define SPI_SS_NB_1621
//`define SPI_SS_NB_2421
//`define SPI_SS_NB_3221

`ifdef SPI_SS_NB_821
  `define SPI_SS_NB21             8    // Can21 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1621
  `define SPI_SS_NB21             16   // Can21 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2421
  `define SPI_SS_NB21             24   // Can21 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3221
  `define SPI_SS_NB21             32   // Can21 be set from 25 to 32
`endif

//
// Bits21 of WISHBONE21 address used for partial21 decoding21 of SPI21 registers.
//
`define SPI_OFS_BITS21	          4:2

//
// Register offset
//
`define SPI_RX_021                0
`define SPI_RX_121                1
`define SPI_RX_221                2
`define SPI_RX_321                3
`define SPI_TX_021                0
`define SPI_TX_121                1
`define SPI_TX_221                2
`define SPI_TX_321                3
`define SPI_CTRL21                4
`define SPI_DEVIDE21              5
`define SPI_SS21                  6

//
// Number21 of bits in ctrl21 register
//
`define SPI_CTRL_BIT_NB21         14

//
// Control21 register bit position21
//
`define SPI_CTRL_ASS21            13
`define SPI_CTRL_IE21             12
`define SPI_CTRL_LSB21            11
`define SPI_CTRL_TX_NEGEDGE21     10
`define SPI_CTRL_RX_NEGEDGE21     9
`define SPI_CTRL_GO21             8
`define SPI_CTRL_RES_121          7
`define SPI_CTRL_CHAR_LEN21       6:0

