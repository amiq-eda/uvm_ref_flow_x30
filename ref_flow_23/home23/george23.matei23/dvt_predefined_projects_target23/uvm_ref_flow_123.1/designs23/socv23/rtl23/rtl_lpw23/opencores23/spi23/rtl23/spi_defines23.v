//////////////////////////////////////////////////////////////////////
////                                                              ////
////  spi_define23.v                                                ////
////                                                              ////
////  This23 file is part of the SPI23 IP23 core23 project23                ////
////  http23://www23.opencores23.org23/projects23/spi23/                      ////
////                                                              ////
////  Author23(s):                                                  ////
////      - Simon23 Srot23 (simons23@opencores23.org23)                     ////
////                                                              ////
////  All additional23 information is avaliable23 in the Readme23.txt23   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright23 (C) 2002 Authors23                                   ////
////                                                              ////
//// This23 source23 file may be used and distributed23 without         ////
//// restriction23 provided that this copyright23 statement23 is not    ////
//// removed from the file and that any derivative23 work23 contains23  ////
//// the original copyright23 notice23 and the associated disclaimer23. ////
////                                                              ////
//// This23 source23 file is free software23; you can redistribute23 it   ////
//// and/or modify it under the terms23 of the GNU23 Lesser23 General23   ////
//// Public23 License23 as published23 by the Free23 Software23 Foundation23; ////
//// either23 version23 2.1 of the License23, or (at your23 option) any   ////
//// later23 version23.                                               ////
////                                                              ////
//// This23 source23 is distributed23 in the hope23 that it will be       ////
//// useful23, but WITHOUT23 ANY23 WARRANTY23; without even23 the implied23   ////
//// warranty23 of MERCHANTABILITY23 or FITNESS23 FOR23 A PARTICULAR23      ////
//// PURPOSE23.  See the GNU23 Lesser23 General23 Public23 License23 for more ////
//// details23.                                                     ////
////                                                              ////
//// You should have received23 a copy of the GNU23 Lesser23 General23    ////
//// Public23 License23 along23 with this source23; if not, download23 it   ////
//// from http23://www23.opencores23.org23/lgpl23.shtml23                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////

//
// Number23 of bits used for devider23 register. If23 used in system with
// low23 frequency23 of system clock23 this can be reduced23.
// Use SPI_DIVIDER_LEN23 for fine23 tuning23 theexact23 number23.
//
//`define SPI_DIVIDER_LEN_823
`define SPI_DIVIDER_LEN_1623
//`define SPI_DIVIDER_LEN_2423
//`define SPI_DIVIDER_LEN_3223

`ifdef SPI_DIVIDER_LEN_823
  `define SPI_DIVIDER_LEN23       8    // Can23 be set from 1 to 8
`endif                                                          
`ifdef SPI_DIVIDER_LEN_1623                                       
  `define SPI_DIVIDER_LEN23       16   // Can23 be set from 9 to 16
`endif                                                          
`ifdef SPI_DIVIDER_LEN_2423                                       
  `define SPI_DIVIDER_LEN23       24   // Can23 be set from 17 to 24
`endif                                                          
`ifdef SPI_DIVIDER_LEN_3223                                       
  `define SPI_DIVIDER_LEN23       32   // Can23 be set from 25 to 32 
`endif

//
// Maximum23 nuber23 of bits that can be send/received23 at once23. 
// Use SPI_MAX_CHAR23 for fine23 tuning23 the exact23 number23, when using
// SPI_MAX_CHAR_3223, SPI_MAX_CHAR_2423, SPI_MAX_CHAR_1623, SPI_MAX_CHAR_823.
//
`define SPI_MAX_CHAR_12823
//`define SPI_MAX_CHAR_6423
//`define SPI_MAX_CHAR_3223
//`define SPI_MAX_CHAR_2423
//`define SPI_MAX_CHAR_1623
//`define SPI_MAX_CHAR_823

`ifdef SPI_MAX_CHAR_12823
  `define SPI_MAX_CHAR23          128  // Can23 only be set to 128 
  `define SPI_CHAR_LEN_BITS23     7
`endif
`ifdef SPI_MAX_CHAR_6423
  `define SPI_MAX_CHAR23          64   // Can23 only be set to 64 
  `define SPI_CHAR_LEN_BITS23     6
`endif
`ifdef SPI_MAX_CHAR_3223
  `define SPI_MAX_CHAR23          32   // Can23 be set from 25 to 32 
  `define SPI_CHAR_LEN_BITS23     5
`endif
`ifdef SPI_MAX_CHAR_2423
  `define SPI_MAX_CHAR23          24   // Can23 be set from 17 to 24 
  `define SPI_CHAR_LEN_BITS23     5
`endif
`ifdef SPI_MAX_CHAR_1623
  `define SPI_MAX_CHAR23          16   // Can23 be set from 9 to 16 
  `define SPI_CHAR_LEN_BITS23     4
`endif
`ifdef SPI_MAX_CHAR_823
  `define SPI_MAX_CHAR23          8    // Can23 be set from 1 to 8 
  `define SPI_CHAR_LEN_BITS23     3
`endif

//
// Number23 of device23 select23 signals23. Use SPI_SS_NB23 for fine23 tuning23 the 
// exact23 number23.
//
`define SPI_SS_NB_823
//`define SPI_SS_NB_1623
//`define SPI_SS_NB_2423
//`define SPI_SS_NB_3223

`ifdef SPI_SS_NB_823
  `define SPI_SS_NB23             8    // Can23 be set from 1 to 8
`endif
`ifdef SPI_SS_NB_1623
  `define SPI_SS_NB23             16   // Can23 be set from 9 to 16
`endif
`ifdef SPI_SS_NB_2423
  `define SPI_SS_NB23             24   // Can23 be set from 17 to 24
`endif
`ifdef SPI_SS_NB_3223
  `define SPI_SS_NB23             32   // Can23 be set from 25 to 32
`endif

//
// Bits23 of WISHBONE23 address used for partial23 decoding23 of SPI23 registers.
//
`define SPI_OFS_BITS23	          4:2

//
// Register offset
//
`define SPI_RX_023                0
`define SPI_RX_123                1
`define SPI_RX_223                2
`define SPI_RX_323                3
`define SPI_TX_023                0
`define SPI_TX_123                1
`define SPI_TX_223                2
`define SPI_TX_323                3
`define SPI_CTRL23                4
`define SPI_DEVIDE23              5
`define SPI_SS23                  6

//
// Number23 of bits in ctrl23 register
//
`define SPI_CTRL_BIT_NB23         14

//
// Control23 register bit position23
//
`define SPI_CTRL_ASS23            13
`define SPI_CTRL_IE23             12
`define SPI_CTRL_LSB23            11
`define SPI_CTRL_TX_NEGEDGE23     10
`define SPI_CTRL_RX_NEGEDGE23     9
`define SPI_CTRL_GO23             8
`define SPI_CTRL_RES_123          7
`define SPI_CTRL_CHAR_LEN23       6:0

